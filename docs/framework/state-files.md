# State Files

> How state flows between orchestrator and experts during execution.

---

## TL;DR

State lives in markdown files. `INDEX.md` shows visible status, `tasks.md` tracks work, `questions/` holds blockers, and `CREW_COMPLETE` signals "done". No database — just files the next expert reads.

---

## Quick Reference

| File | Purpose | Created By | Modified By |
|------|---------|------------|-------------|
| `INDEX.md` | Project state (phase, iteration) | `ncrew init` | Expert |
| `tasks.md` | Task checklist per phase | `ncrew init` | Expert |
| `questions/*.md` | Blocker questions | Expert | You |
| `CREW_COMPLETE` | Termination signal | Expert | — |

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

| Field | Type | Description |
|-------|------|-------------|
| `status` | enum | `in_progress`, `blocked`, or `complete` |
| `current_phase` | string | Active phase name |
| `current_iteration` | integer | How many iterations have run |
| `cost_so_far` | float | Accumulated LLM cost in USD |

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

## tasks.md

### Purpose

Task checklist that experts read to find their next task.

### Format

```markdown
---
project: my-project
updated: "2026-01-28T14:52:33Z"
---

# Tasks

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

### Phase Status

| Emoji | Status | Condition |
|-------|--------|-----------|
| ✅ | COMPLETE | All tasks `[x]` |
| 🔄 | IN PROGRESS | Some checked, some unchecked |
| ⏳ | PENDING | No tasks checked yet |

### Expert Behavior

1. Read tasks.md
2. Find first phase with unchecked tasks
3. Pick first unchecked task `[ ]`
4. Do the task
5. Mark task as `[x]`
6. If ALL tasks done → `touch CREW_COMPLETE`

---

## questions/ (Blockers)

### Purpose

When an expert encounters genuine ambiguity, it creates a blocker. Blockers are **rare by design** — experts are opinionated and make reasonable decisions.

### When to Create a Blocker

**Create blocker ONLY when:**
- Requirements are contradictory
- Critical business decision outside technical scope
- A choice would fundamentally change product direction

**Do NOT create blockers for:**
- Preferences ("Do you prefer X or Y?")
- Confirmations ("Is this correct?")
- Details that can be reasonably assumed

### File Format

**Filename:** `{expert}-{number}-{topic}.md`

```markdown
---
from: software-architect
to: user
type: blocker
status: pending
created: "2026-01-28"
---

# BLOCKER: Authentication Strategy

## Context
The PRD mentions "enterprise SSO" but doesn't specify...

## Question
Should we support SAML, OIDC, or both?

## Options
- **Option A:** SAML only (enterprise standard)
- **Option B:** OIDC only (modern, easier)
- **Option C:** Both (maximum compatibility)

## Recommendation
Option A — matches enterprise requirements

---

## Your Answer (required to resume)
**Decision:** ___
**Reason:** ___
```

### Lifecycle

```
Expert detects ambiguity
         │
         ▼
Creates questions/architect-001-auth.md
  status: pending
         │
         ▼
Orchestrator detects → PAUSE
         │
         ▼
You write answer, set status: resolved
         │
         ▼
ncrew resume
         │
         ▼
Loop continues with your answer as context
```

---

## CREW_COMPLETE

### Purpose

Empty file signaling project completion.

### Why a File?

- **Simple detection:** Just check `file_exists("CREW_COMPLETE")`
- **Expert decides:** Expert has full context to know when done
- **No parsing:** Orchestrator doesn't parse tasks.md

### Expert Logic

```
After completing task:

1. Check tasks.md — are ALL tasks in ALL phases [x]?
   ├── YES → touch CREW_COMPLETE && end turn
   └── NO  → end turn (loop restarts)
```

### Orchestrator Check

```
1. CREW_COMPLETE exists? → EXIT success
2. questions/ has pending? → PAUSE
3. Phase in human_gates? → PAUSE
4. iteration >= max? → EXIT safety
5. cost >= max? → EXIT budget
6. Otherwise → LOOP
```

---

## State Evolution Example

### Start (Iteration 1)

```yaml
# INDEX.md
status: in_progress
current_phase: discovery
current_iteration: 1
```

```markdown
# tasks.md
## Discovery Phase 🔄 IN PROGRESS
- [ ] Generate PRD
- [ ] Define personas

## Architecture Phase ⏳ PENDING
- [ ] ADR-001: Frontend
```

### End (All Complete)

```yaml
# INDEX.md
status: complete
current_phase: implementation
current_iteration: 47
```

```markdown
# tasks.md
## Discovery Phase ✅ COMPLETE
- [x] Generate PRD
- [x] Define personas

## Architecture Phase ✅ COMPLETE
- [x] ADR-001: Frontend

## Implementation Phase ✅ COMPLETE
- [x] Generate CHANGELOG
```

`CREW_COMPLETE` file exists → Orchestrator exits successfully.

---

## Further Reading

- [Project Structure](project-structure.md) — All generated files
- [Execution Loop](execution-loop.md) — How the loop works
- [Expert Format](../crew-development/expert-format.md) — How experts are defined
