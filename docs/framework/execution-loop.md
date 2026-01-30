# Execution Loop

> How the orchestrator runs experts in a cycle.

---

## Overview

NoodleCrew uses a simple loop inspired by [DLP](https://github.com/edgarjs/dlp)'s "Ralph Wiggum Loop". The orchestrator doesn't parse LLM output or manage state—experts do that autonomously.

```
ncrew run
    │
    ▼
┌─────────────────────────────────────────────┐
│              EXECUTION LOOP                 │
├─────────────────────────────────────────────┤
│                                             │
│  1. RESOLVE CONTEXT                         │
│     └── Which phase? Which expert?          │
│                                             │
│  2. BUILD PROMPT                            │
│     └── Assemble context files              │
│                                             │
│  3. LAUNCH EXPERT                           │
│     └── One-shot autonomous command         │
│                                             │
│  4. LOG & TRACK                             │
│     └── Save output, update costs           │
│                                             │
│  5. CHECK TERMINATION                       │
│     └── Done? Blocked? Continue?            │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Step 1: Resolve Context

The orchestrator reads state files to determine:

```
Read manifest.yml
  └── Get phase order

Read tasks.md
  └── Find first phase with [ ] tasks

Select expert
  └── Match expert.phase == current_phase
```

---

## Step 2: Build Prompt

Assemble the expert's prompt in this order:

```
1. [ROLE]       EXPERT.md       "You are a Product Owner..."
2. [WORKFLOW]   WORKFLOW.md     "Do ONE task, commit, end turn"
3. [INPUT]      IDEA.md         User's original idea
4. [STATE]      INDEX.md        Current phase, iteration
5. [TASKS]      tasks.md        What needs to be done
6. [CONTEXT]    docs/*          Previous artifacts
7. [TEMPLATES]  templates/      Output formats
```

Later sections can reference earlier ones (e.g., the expert sees IDEA.md when deciding how to approach tasks).

---

## Step 3: Launch Expert

Execute a one-shot command:

```bash
# Claude
claude -p "$(cat prompt.md)" --allowedTools "Edit,Write,Bash"

# Gemini
gemini --yolo < prompt.md
```

The expert is **autonomous**. It:

- Reads tasks.md → picks ONE task
- Creates artifact in `docs/<phase>/`
- Updates tasks.md (marks `[x]`)
- Updates INDEX.md (iteration)
- Git commits
- Ends turn

The orchestrator does NOT:
- Parse the LLM response
- Extract artifacts
- Update state files
- Make git commits

---

## Step 4: Log & Track

After the expert finishes:

```
Write log
  └── .noodlecrew/logs/<timestamp>.log

Update metrics
  └── Increment iteration
  └── Add cost (if tracked)
```

---

## Step 5: Check Termination

Check conditions in this order:

```
1. CREW_COMPLETE exists?
   └── YES → EXIT success

2. questions/ has status: pending?
   └── YES → PAUSE (awaiting user)

3. Phase in human_gates AND just completed?
   └── YES → PAUSE (awaiting review)

4. iteration >= max_iterations?
   └── YES → EXIT safety

5. cost >= max_cost?
   └── YES → EXIT budget

6. Otherwise
   └── LOOP (back to step 1)
```

---

## Expert Autonomy

**Key insight:** The expert is fully autonomous within its turn.

```
┌─────────────────────────────────────────────────┐
│  EXPERT TURN (autonomous)                       │
├─────────────────────────────────────────────────┤
│                                                 │
│  Receives:                                      │
│  ├── EXPERT.md    (who you are)                │
│  ├── WORKFLOW.md  (how to work)                │
│  ├── IDEA.md      (what to build)              │
│  ├── tasks.md     (pending tasks)              │
│  ├── INDEX.md     (current state)              │
│  ├── docs/*       (previous work)              │
│  └── templates/   (output formats)             │
│                                                 │
│  Does (on its own):                             │
│  ├── Reads tasks.md → picks ONE task           │
│  ├── Creates artifact in docs/<phase>/         │
│  ├── Updates tasks.md [x]                      │
│  ├── Updates INDEX.md                          │
│  ├── Git commit                                │
│  └── If all done → touch CREW_COMPLETE         │
│                                                 │
│  Ends turn                                      │
│                                                 │
└─────────────────────────────────────────────────┘
```

The orchestrator just restarts the loop. Simple.

---

## Phase Transitions

When all tasks in a phase are `[x]`:

1. Expert updates tasks.md status: `✅ COMPLETE`
2. Next iteration selects next phase
3. Different expert starts working

```
DISCOVERY ──────► ARCHITECTURE ──────► IMPLEMENTATION
    │                  │                     │
    ▼                  ▼                     ▼
  [x] PRD          [x] ADR-001          [ ] CHANGELOG
  [x] Personas     [ ] ADR-002          [ ] Notes
  [x] Vision       [ ] ADR-003
   COMPLETE        IN PROGRESS            PENDING
```

---

## Resuming After Pause

When paused (blocker or gate):

```bash
ncrew resume
```

Flow:
1. Check if blockers resolved → Continue or re-pause
2. Check if gate acknowledged → Continue or re-pause
3. Restart loop from step 1

---

## Iteration Example

```
Iteration 42:

1. Orchestrator reads state
   └── Phase: architecture, Expert: software-architect

2. Build prompt
   └── EXPERT.md + WORKFLOW.md + IDEA.md + tasks.md + docs/*

3. Launch: claude -p "$(cat prompt.md)"
   └── Expert picks "ADR-002: Database choice"
   └── Creates docs/architecture/adrs/002-database.md
   └── Updates tasks.md: [x] ADR-002
   └── Commits: "feat(architecture): ADR-002 database choice"
   └── Ends turn

4. Log output
   └── .noodlecrew/logs/2026-01-30-143522.log

5. Check termination
   └── Not complete → LOOP
```

---

## Safety Limits

| Limit | Default | Config Key |
|-------|---------|------------|
| Max iterations | 100 | `execution.max_iterations` |
| Max cost | $30.00 | `execution.max_cost` |

These prevent runaway execution.

---

## Further Reading

- [State Files](state-files.md) — File format specifications
- [Project Structure](project-structure.md) — Directory layout
- [FLOW.md](../../FLOW.md) — Complete technical contract
