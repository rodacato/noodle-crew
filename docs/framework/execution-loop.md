# Execution Loop

> How the orchestrator runs experts in a cycle.

---

## TL;DR

The orchestrator runs a simple loop: **resolve context → build prompt → launch expert → log → check termination → repeat**. Experts are autonomous — they manage their own files and commits. The orchestrator just restarts them.

---

## The Loop at a Glance

```
ncrew run
    │
    ▼
┌─────────────────────────────────────────────┐
│              EXECUTION LOOP                 │
├─────────────────────────────────────────────┤
│                                             │
│  1. RESOLVE    Which phase? Which expert?   │
│  2. BUILD      Assemble context files       │
│  3. LAUNCH     One-shot autonomous command  │
│  4. LOG        Save output, update costs    │
│  5. CHECK      Done? Blocked? Continue?     │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Step-by-Step

### Step 1: Resolve Context

Read state files to determine the current situation:

| Read | To Find |
|------|---------|
| `manifest.yml` | Phase order, expert assignments |
| `tasks.md` | First phase with `[ ]` tasks |
| Expert config | Which expert handles this phase |

### Step 2: Build Prompt

Assemble the expert's prompt in this order:

| Order | File | Purpose |
|-------|------|---------|
| 1 | `EXPERT.md` | "You are a Product Owner..." |
| 2 | `WORKFLOW.md` | "Do ONE task, commit, end turn" |
| 3 | `IDEA.md` | User's original idea |
| 4 | `INDEX.md` | Current phase, iteration |
| 5 | `tasks.md` | What needs to be done |
| 6 | `docs/*` | Previous artifacts |
| 7 | `templates/` | Output formats |

### Step 3: Launch Expert

Execute a one-shot command:

```bash
# Claude
claude -p "$(cat prompt.md)" --allowedTools "Edit,Write,Bash"

# Gemini
gemini --yolo < prompt.md
```

**The expert is autonomous.** It reads tasks.md, picks a task, creates artifacts, updates state, commits to git, and ends its turn.

**The orchestrator does NOT:**
- Parse the LLM response
- Extract artifacts
- Update state files
- Make git commits

### Step 4: Log & Track

After the expert finishes:

| Action | Location |
|--------|----------|
| Write log | `.noodlecrew/logs/<timestamp>.log` |
| Increment iteration | Internal counter |
| Add cost | If tracked |

### Step 5: Check Termination

Check conditions in priority order:

| Check | If True |
|-------|---------|
| `CREW_COMPLETE` exists? | EXIT success |
| `questions/` has `status: pending`? | PAUSE for user |
| Phase in `human_gates` AND just completed? | PAUSE for review |
| `iteration >= max_iterations`? | EXIT safety |
| `cost >= max_cost`? | EXIT budget |
| Otherwise | LOOP to step 1 |

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

1. Expert updates tasks.md status: `COMPLETE`
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

## Concrete Example

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
- [CLI Commands](cli-commands.md) — Available commands
