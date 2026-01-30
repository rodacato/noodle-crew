# Execution Flow

> The runtime contract between CLI, Orchestrator, and Crews.

---

## Overview

This document defines **what the framework guarantees** vs **what crews customize**. The framework owns the execution loop; crews own the domain logic.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         RESPONSIBILITY SPLIT                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   FRAMEWORK (ncrew CLI)              CREW (marketplace package)         │
│   ─────────────────────              ─────────────────────────          │
│   • Directory structure              • Expert definitions               │
│   • State file locations             • Phase sequence                   │
│   • Execution loop                   • Task lists                       │
│   • Termination protocol             • Templates                        │
│   • Context injection                • LLM preferences                  │
│   • Logging & cost tracking          • Human gates                      │
│                                                                         │
│   "HOW it runs"                      "WHAT it runs"                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Invariants

These rules are **absolute**. No crew can override them.

### 1.1 Directory Structure

```
<project>/
├── IDEA.md                    # INPUT  - User's idea (required)
├── INDEX.md                   # STATE  - Project summary (visible)
├── .noodlecrew/               # HIDDEN - Crew internals
│   ├── manifest.yml           # Crew configuration
│   ├── tasks.md               # Task backlog
│   ├── questions/             # Blocker files
│   ├── logs/                  # Execution logs
│   ├── experts/               # Expert definitions
│   └── phases/                # Phase definitions
├── docs/                      # OUTPUT - Generated artifacts
│   └── <phase>/               # One folder per phase
└── CREW_COMPLETE              # SIGNAL - Termination marker
```

**Why this structure:**
- `IDEA.md` and `INDEX.md` at root = always visible to user
- `.noodlecrew/` hidden = reduces noise, internals stay internal
- `docs/` clean = only deliverables, no system files
- Flat termination signal = simple detection (`file_exists`)

### 1.2 Required Files

| File | Created By | Required | Purpose |
|------|------------|----------|---------|
| `IDEA.md` | User | Yes | Input - the original idea |
| `INDEX.md` | `ncrew init` | Yes | State summary (human-readable) |
| `.noodlecrew/manifest.yml` | `ncrew init` | Yes | Crew configuration |
| `.noodlecrew/tasks.md` | `ncrew init` | Yes | Task checklist |

### 1.3 State File Schemas

#### INDEX.md Frontmatter

```yaml
---
type: project                    # Always "project"
status: in_progress | blocked | complete
current_phase: <phase-name>
current_iteration: <integer>
cost_so_far: <float>
created: "<ISO-date>"
updated: "<ISO-datetime>"
---
```

#### tasks.md Format

```markdown
---
project: <name>
updated: "<ISO-datetime>"
---

# Tasks

## <Phase Name> - <STATUS>

- [x] Completed task
- [ ] Pending task    ← Expert picks first unchecked
```

Phase status: `COMPLETE` | `IN PROGRESS` | `PENDING`

### 1.4 Termination Protocol

The framework checks termination **after every iteration**:

```
CHECK TERMINATION (in order):

1. CREW_COMPLETE exists?
   └── YES → EXIT success

2. questions/ has status: pending?
   └── YES → PAUSE (awaiting user)

3. Phase in human_gates AND phase just completed?
   └── YES → PAUSE (awaiting review)

4. iteration >= max_iterations?
   └── YES → EXIT safety

5. cost_so_far >= max_cost?
   └── YES → EXIT budget

6. Otherwise
   └── LOOP (restart expert)
```

**The expert creates `CREW_COMPLETE`**, not the orchestrator. This keeps termination logic in one place (the expert has full context to know when truly done).

---

## 2. Execution Loop

The orchestrator runs a simple loop. It doesn't parse LLM output or manage state—experts do that.

### 2.1 The Loop

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           EXECUTION LOOP                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ncrew run                                                              │
│      │                                                                  │
│      ▼                                                                  │
│  ┌───────────────────────────────────────────────────────────────┐     │
│  │ 1. RESOLVE CONTEXT                                            │     │
│  │                                                                │     │
│  │    Read manifest.yml → determine current phase                 │     │
│  │    Read tasks.md → find phase with pending tasks               │     │
│  │    Select expert for that phase                                │     │
│  │                                                                │     │
│  └───────────────────────────┬───────────────────────────────────┘     │
│                              │                                          │
│                              ▼                                          │
│  ┌───────────────────────────────────────────────────────────────┐     │
│  │ 2. BUILD PROMPT                                               │     │
│  │                                                                │     │
│  │    Assemble:                                                   │     │
│  │    ├── EXPERT.md (role definition)                            │     │
│  │    ├── WORKFLOW.md (execution instructions)                   │     │
│  │    ├── IDEA.md (user input)                                   │     │
│  │    ├── tasks.md (current tasks)                               │     │
│  │    ├── INDEX.md (project state)                               │     │
│  │    ├── docs/* (previous artifacts)                            │     │
│  │    └── Expert's templates/                                    │     │
│  │                                                                │     │
│  └───────────────────────────┬───────────────────────────────────┘     │
│                              │                                          │
│                              ▼                                          │
│  ┌───────────────────────────────────────────────────────────────┐     │
│  │ 3. LAUNCH EXPERT                                              │     │
│  │                                                                │     │
│  │    Execute one-shot command:                                   │     │
│  │    claude -p "$(cat prompt.md)" --allowedTools ...            │     │
│  │                                                                │     │
│  │    Expert runs autonomously:                                   │     │
│  │    ├── Reads tasks.md → picks ONE task                        │     │
│  │    ├── Creates artifact in docs/<phase>/                      │     │
│  │    ├── Updates tasks.md (marks [x])                           │     │
│  │    ├── Updates INDEX.md                                       │     │
│  │    ├── Git commit                                             │     │
│  │    ├── If all done → touch CREW_COMPLETE                      │     │
│  │    └── Ends turn                                              │     │
│  │                                                                │     │
│  └───────────────────────────┬───────────────────────────────────┘     │
│                              │                                          │
│                              ▼                                          │
│  ┌───────────────────────────────────────────────────────────────┐     │
│  │ 4. LOG & TRACK                                                │     │
│  │                                                                │     │
│  │    Write to .noodlecrew/logs/<timestamp>.log                  │     │
│  │    Update cost_so_far in INDEX.md                             │     │
│  │    Increment iteration counter                                │     │
│  │                                                                │     │
│  └───────────────────────────┬───────────────────────────────────┘     │
│                              │                                          │
│                              ▼                                          │
│  ┌───────────────────────────────────────────────────────────────┐     │
│  │ 5. CHECK TERMINATION                                          │     │
│  │                                                                │     │
│  │    (See termination protocol above)                           │     │
│  │                                                                │     │
│  │    CREW_COMPLETE? ──────────────────────────► EXIT success    │     │
│  │    Blocker pending? ────────────────────────► PAUSE           │     │
│  │    Human gate? ─────────────────────────────► PAUSE           │     │
│  │    Safety limit? ───────────────────────────► EXIT            │     │
│  │    Otherwise ───────────────────────────────► LOOP (step 1)   │     │
│  │                                                                │     │
│  └───────────────────────────────────────────────────────────────┘     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Context Injection Order

The prompt is assembled in this order (later sections can reference earlier):

```
1. [ROLE]       ← EXPERT.md (who you are)
2. [WORKFLOW]   ← WORKFLOW.md (how to work)
3. [INPUT]      ← IDEA.md (what to build)
4. [STATE]      ← INDEX.md + tasks.md (current status)
5. [CONTEXT]    ← docs/* (previous work)
6. [TEMPLATES]  ← expert's templates/ (output format)
7. [INSTRUCTION]← "Do ONE task, commit, end turn"
```

### 2.3 LLM Command Templates

The framework supports multiple LLM backends:

```bash
# Claude (default)
claude -p "$(cat prompt.md)" \
  --allowedTools "Edit,Write,Bash" \
  --max-turns 1

# Gemini
gemini --yolo < prompt.md

# Generic (future)
ncrew exec --llm <provider> --prompt prompt.md
```

---

## 3. Expert Protocol

Every expert must follow this contract. The framework guarantees inputs; the expert guarantees behavior.

### 3.1 Inputs (Framework Guarantees)

| Input | Location | Description |
|-------|----------|-------------|
| Role | `EXPERT.md` | Who you are, what you produce |
| Workflow | `WORKFLOW.md` | Execution rules |
| Idea | `IDEA.md` | User's original input |
| Tasks | `tasks.md` | What needs to be done |
| State | `INDEX.md` | Current phase, iteration |
| Context | `docs/*` | All previous artifacts |
| Templates | `templates/` | Output formats |

### 3.2 Outputs (Expert Guarantees)

| Output | Location | Description |
|--------|----------|-------------|
| Artifact | `docs/<phase>/` | The work product |
| Task update | `tasks.md` | Mark task `[x]` |
| State update | `INDEX.md` | Increment iteration |
| Commit | git | `feat(<phase>): <task>` |
| Termination | `CREW_COMPLETE` | If all tasks done |

### 3.3 Required Behavior

```
EXPERT TURN:

1. READ tasks.md
   └── Find first [ ] task in current phase

2. DO exactly ONE task
   └── Create/update artifact in docs/<phase>/

3. UPDATE state
   ├── Mark task [x] in tasks.md
   └── Update INDEX.md (iteration, timestamp)

4. COMMIT
   └── git add . && git commit -m "feat(<phase>): <task>"

5. CHECK completion
   ├── All tasks [x] in ALL phases?
   │   └── YES → touch CREW_COMPLETE
   └── End turn (do NOT continue)
```

### 3.4 Blocker Protocol

Experts create blockers **only for genuine ambiguity**:

```
questions/<role>-<number>-<topic>.md
```

Required frontmatter:
```yaml
---
from: <role>
to: user
type: blocker
status: pending | resolved
created: "<ISO-datetime>"
---
```

**When to create:**
- Contradictory requirements
- Critical business decision outside technical scope
- Missing information that fundamentally changes direction

**When NOT to create:**
- Preferences ("X or Y?")
- Confirmations ("Is this right?")
- Details that can be reasonably assumed

---

## 4. Crew Extension Points

Crews customize execution within the framework's constraints.

### 4.1 What Crews Define

| Component | Location | Purpose |
|-----------|----------|---------|
| Experts | `.noodlecrew/experts/<role>/` | Role definitions |
| Phases | `.noodlecrew/phases/<name>/` | Phase definitions |
| Tasks | `.noodlecrew/tasks.md` | Initial task list |
| Config | `.noodlecrew/manifest.yml` | Crew settings |

### 4.2 manifest.yml Schema

```yaml
project:
  name: string           # Project identifier
  type: string           # Crew type (saas, api, etc.)

crew:
  default_llm: string    # Default LLM (claude, gemini)
  experts:
    - role: string       # Expert identifier
      phase: string      # Primary phase
      llm: string        # Optional: override LLM

phases:                  # Execution order
  - phase-name

execution:
  max_iterations: int    # Safety limit (default: 100)
  max_cost: float        # Budget limit (default: 30.00)

validation:
  human_gates: []        # Phases requiring review
```

### 4.3 What Crews CANNOT Change

| Invariant | Reason |
|-----------|--------|
| File locations | Orchestrator expects fixed paths |
| State file schemas | Framework reads these programmatically |
| Termination protocol | `CREW_COMPLETE` is the only signal |
| One task per turn | Ensures auditable, atomic progress |
| Git commit format | Enables consistent history parsing |

---

## 5. Lifecycle Events

The framework emits events that crews can hook into (future capability).

### 5.1 Event Types

```
LIFECYCLE EVENTS:

crew.started          → Crew execution begins
iteration.started     → New iteration begins
expert.launching      → About to launch expert
expert.completed      → Expert turn finished
phase.completed       → All tasks in phase done
blocker.created       → Expert created a blocker
gate.reached          → Human gate triggered
crew.completed        → CREW_COMPLETE detected
crew.failed           → Error or limit reached
```

### 5.2 Hook Locations (Future)

```yaml
# manifest.yml (future)
hooks:
  phase.completed:
    - script: ./hooks/notify-slack.sh
  crew.completed:
    - script: ./hooks/generate-report.sh
```

---

## 6. Resume Protocol

When paused (blocker or gate), `ncrew resume` restarts the loop.

### 6.1 Resume Flow

```
ncrew resume
    │
    ├── Check questions/ for status: pending
    │   └── Still pending? → EXIT (answer required)
    │
    ├── Check human_gates
    │   └── Gate not acknowledged? → EXIT (review required)
    │
    └── Otherwise → Restart loop (step 1)
```

### 6.2 Answer Injection

When a blocker is resolved, the answer becomes context:

```
Next expert prompt includes:

## Previously Resolved Questions

### BLOCKER: Authentication Strategy

**Question:** Should we use Auth0 or custom SSO?

**Answer:** Use Auth0 - faster time to market is priority.

**Date:** 2026-01-28
```

---

## 7. Error Handling

### 7.1 Expert Failures

```
Expert exits with error
    │
    ├── Log error to .noodlecrew/logs/
    │
    ├── Retry? (configurable)
    │   └── retry_count < max_retries → LOOP
    │
    └── Otherwise → EXIT with error status
```

### 7.2 State Recovery

The framework can recover from interrupted execution:

```bash
ncrew status     # Show current state
ncrew resume     # Continue from last checkpoint
ncrew reset      # Reset to last human gate
```

State is in files, not memory—always recoverable.

---

## 8. Quick Reference

### Commands

| Command | Description |
|---------|-------------|
| `ncrew init <name>` | Initialize project with crew |
| `ncrew run` | Start/continue execution |
| `ncrew status` | Show current state |
| `ncrew resume` | Resume after pause |
| `ncrew logs` | View execution history |

### Key Files

| File | Purpose |
|------|---------|
| `IDEA.md` | User input |
| `INDEX.md` | State summary |
| `.noodlecrew/tasks.md` | Task checklist |
| `.noodlecrew/manifest.yml` | Crew config |
| `CREW_COMPLETE` | Done signal |

### Termination Conditions

| Condition | Result |
|-----------|--------|
| `CREW_COMPLETE` exists | Success exit |
| Pending blocker | Pause |
| Human gate reached | Pause |
| `max_iterations` exceeded | Safety exit |
| `max_cost` exceeded | Budget exit |

---

## Further Reading

- [Framework Overview](docs/framework/overview.md) — What the framework guarantees
- [Execution Loop](docs/framework/execution-loop.md) — Detailed loop explanation
- [State Files](docs/framework/state-files.md) — File format specifications
- [Project Structure](docs/framework/project-structure.md) — Directory layout
- [Expert Format](docs/crew-development/expert-format.md) — EXPERT.md specification
- [Manifest Schema](docs/crew-development/manifest-schema.md) — Configuration reference
