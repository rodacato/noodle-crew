# State Files

> How state flows between orchestrator and experts during execution.

---

## Overview

NoodleCrew uses markdown files as the source of truth for project state:

| File              | Purpose                              | Created By  | Modified By |
|-------------------|--------------------------------------|-------------|-------------|
| INDEX.md          | Project state (phase, iteration)     | `ncrew init`| Expert      |
| TODO.md           | Task checklist per phase             | `ncrew init`| Expert      |
| questions/*.md    | Blocker questions                    | Expert      | User        |
| CREW_COMPLETE     | Termination signal                   | Expert      | —           |

The orchestrator reads these files to determine:

- Which expert to run (based on current phase)
- Whether to pause (blockers, human gates)
- Whether to terminate (CREW_COMPLETE exists, max iterations)

---

## INDEX.md

### Purpose

Master state document tracking overall project progress.

### Schema

```yaml
---
type: project
status: in_progress | blocked | complete
current_phase: discovery | architecture | implementation
current_iteration: 42
cost_so_far: 8.47
created: "2026-01-28"
updated: "2026-01-28T14:52:33Z"
---
```

| Field             | Type    | Description                              |
|-------------------|---------|------------------------------------------|
| type              | string  | Always "project"                         |
| status            | enum    | in_progress, blocked, or complete        |
| current_phase     | string  | Active phase name                        |
| current_iteration | integer | How many iterations have run             |
| cost_so_far       | float   | Accumulated LLM cost in USD              |
| created           | date    | When project was initialized             |
| updated           | datetime| Last modification timestamp              |

### Who Reads/Writes

| Actor        | Reads           | Writes                           |
|--------------|-----------------|----------------------------------|
| Orchestrator | current_phase   | —                                |
| Expert       | All fields      | All fields (updates after task)  |

### State Transitions

```
status: in_progress
         │
         ├── Expert creates blocker ──────► status: blocked
         │
         ├── Expert creates CREW_COMPLETE ► status: complete
         │
         └── Otherwise ───────────────────► stays in_progress
```

---

## TODO.md

### Purpose

Task checklist that experts read to find their next task.

### Syntax

```markdown
---
project: my-project
updated: "2026-01-28T14:52:33Z"
---

# TODO

## Discovery Phase ✅ COMPLETE

- [x] Generate PRD from idea
- [x] Define user personas

## Architecture Phase 🔄 IN PROGRESS

- [x] ADR-001: Frontend stack
- [ ] ADR-002: Database choice   ← Expert picks this
- [ ] ADR-003: Authentication

## Implementation Phase ⏳ PENDING

- [ ] Generate CHANGELOG
- [ ] Document implementation steps
```

### Phase Status Rules

| Emoji | Status       | Condition                                        |
|-------|--------------|--------------------------------------------------|
| ✅    | COMPLETE     | All tasks checked `[x]`                          |
| 🔄    | IN PROGRESS  | At least one checked, at least one unchecked     |
| ⏳    | PENDING      | No tasks checked yet                             |

### Expert Behavior

1. Read TODO.md
2. Find first phase with unchecked tasks
3. Pick first unchecked task `[ ]` in that phase
4. Do the task
5. Mark task as `[x]`
6. Update phase status emoji if all tasks done
7. If ALL tasks in ALL phases are done → `touch CREW_COMPLETE`

### Orchestrator Behavior

1. Check if CREW_COMPLETE exists → EXIT
2. Check if questions/ has pending blockers → PAUSE
3. Check human_gates in manifest.yml → PAUSE if gate reached
4. Otherwise → select expert for current phase → LOOP

---

## questions/ (Blockers)

### Purpose

When an expert encounters genuine ambiguity, it creates a blocker file. Blockers are **rare** by design — experts are opinionated and make reasonable decisions.

### When to Create a Blocker

Create a blocker ONLY when:

- The idea has contradictory requirements
- Critical business decision is outside technical scope
- A choice would fundamentally change the product direction

Do NOT create blockers for:

- Preferences ("Do you prefer X or Y?")
- Confirmations ("Is this correct?")
- Technical details that can be reasonably assumed

### Lifecycle

```
Expert detects genuine ambiguity
         │
         ▼
Creates questions/architect-001-auth.md
  status: pending
         │
         ▼
Orchestrator detects file → PAUSE
         │
         ▼
User writes answer in file
  status: resolved
         │
         ▼
User runs: ncrew resume
         │
         ▼
Orchestrator reads resolved blocker
Answer becomes context for next prompt
         │
         ▼
Loop continues
```

### File Format

```markdown
---
from: software-architect
to: user
type: blocker
status: pending
created: "2026-01-28T14:52:33Z"
---

# BLOCKER: Authentication Strategy

## Context

The PRD requires "enterprise-ready authentication" but doesn't specify
whether this means supporting existing enterprise identity providers
or building custom SSO.

## Question

Should we integrate with enterprise identity providers (Auth0, Okta)
or build custom SSO capabilities?

## Options

### Option A: Auth0 Integration

- Pros: Fast to implement, battle-tested, SOC2 compliant
- Cons: Recurring cost, vendor dependency

### Option B: Custom SSO

- Pros: Full control, no vendor lock-in
- Cons: Significant development effort, security risk

## Recommendation

Option A (Auth0) — matches the "rapid prototyping" philosophy
and enterprise requirements can be met immediately.

---

## Your Answer (required to resume)

**Decision**: ___________
**Reason**: ___________
**Date**: ___________
```

### Resolution

1. User changes `status: pending` → `status: resolved`
2. User fills in "Your Answer" section
3. User runs `ncrew resume`
4. Orchestrator includes the answer in the next expert's context

---

## CREW_COMPLETE (Termination Signal)

### Purpose

An empty file that signals project completion. When an expert finishes the last task and confirms all phases are done, it creates this file.

### Why a File Signal?

Following the DLP pattern:

- **Simple detection**: Orchestrator just checks `file_exists("CREW_COMPLETE")`
- **Expert decides**: The expert has full context to know when truly done
- **No parsing**: Orchestrator doesn't need to parse TODO.md

### Expert Logic

The expert's instructions include:

```markdown
## Termination

After completing your task:

1. Check TODO.md — are ALL tasks in ALL phases checked [x]?
2. If YES → run: `touch CREW_COMPLETE` and end your turn
3. If NO → end your turn normally (loop will restart you)
```

### Orchestrator Check

```
CHECK TERMINATION (after each iteration):

1. File CREW_COMPLETE exists?
   └── YES → EXIT (success)

2. Check questions/ directory
   └── Any file with status: pending? → PAUSE

3. Check manifest.yml human_gates
   └── Current phase in gates AND phase just completed? → PAUSE

4. Check iteration counter
   └── iteration >= max_iterations? → EXIT (safety)

5. Check cost tracker
   └── cost_so_far >= max_cost? → EXIT (budget)

6. Otherwise → LOOP
```

---

## Example: State Evolution

### Iteration 1 (Discovery starts)

**INDEX.md:**

```yaml
---
status: in_progress
current_phase: discovery
current_iteration: 1
---
```

**TODO.md:**

```markdown
## Discovery Phase 🔄 IN PROGRESS

- [ ] Generate PRD
- [ ] Define personas

## Architecture Phase ⏳ PENDING

- [ ] ADR-001: Frontend
```

### Iteration 2 (PRD done)

**INDEX.md:**

```yaml
current_iteration: 2
```

**TODO.md:**

```markdown
## Discovery Phase 🔄 IN PROGRESS

- [x] Generate PRD
- [ ] Define personas
```

**docs/discovery/prd.md:** Created

### Iteration 3 (Discovery complete)

**INDEX.md:**

```yaml
current_phase: architecture
current_iteration: 3
```

**TODO.md:**

```markdown
## Discovery Phase ✅ COMPLETE

- [x] Generate PRD
- [x] Define personas

## Architecture Phase 🔄 IN PROGRESS

- [ ] ADR-001: Frontend
```

If `human_gates: [discovery]` in manifest.yml → **PAUSE here for review**

### Final Iteration (All done)

**TODO.md:**

```markdown
## Discovery Phase ✅ COMPLETE

- [x] Generate PRD
- [x] Define personas

## Architecture Phase ✅ COMPLETE

- [x] ADR-001: Frontend

## Implementation Phase ✅ COMPLETE

- [x] Generate CHANGELOG
```

**CREW_COMPLETE:** Created (empty file)

**Orchestrator:** Detects CREW_COMPLETE → EXIT (success)

---

## Further Reading

- [Architecture](../concepts/architecture.md) — The execution loop
- [Project Structure](project-structure.md) — All generated files
- [Expert Format](expert-format.md) — How experts are defined
