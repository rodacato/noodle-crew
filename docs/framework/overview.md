# Framework Overview

> What the ncrew CLI provides and guarantees.

---

## TL;DR

The **framework** runs crews. It handles directories, state files, the execution loop, and termination — so crews just define *what* gets done, not *how* it runs.

```
Framework = Runtime (fixed)
Crew      = Configuration (swappable)
```

---

## Quick Navigation

| I want to... | Go to |
|--------------|-------|
| Understand directory layout | [Project Structure](project-structure.md) |
| Learn about INDEX.md and tasks.md | [State Files](state-files.md) |
| See how the loop works | [Execution Loop](execution-loop.md) |
| Know the CLI commands | [CLI Commands](cli-commands.md) |

---

## What the Framework Provides

| Component | What It Does |
|-----------|--------------|
| **Directory structure** | Where files must live (`.noodlecrew/`, `docs/`, etc.) |
| **State management** | How progress is tracked (INDEX.md, tasks.md) |
| **Execution loop** | How experts run (build prompt → launch → commit → repeat) |
| **Termination protocol** | How completion is detected (CREW_COMPLETE file) |

The framework is **crew-agnostic**. It doesn't care what your experts do — only that they follow the protocol.

---

## Responsibility Split

### Framework Owns (Fixed)

| Responsibility | Description |
|----------------|-------------|
| Directory layout | `.noodlecrew/`, `docs/`, `IDEA.md`, `INDEX.md` |
| State file schemas | Frontmatter format for INDEX.md, tasks.md |
| Execution loop | Build prompt → launch → log → check termination |
| Termination detection | CREW_COMPLETE, blockers, gates, iteration limits |
| Context injection | What goes into each expert's prompt |
| CLI commands | `ncrew init`, `ncrew run`, `ncrew status` |

### Crew Owns (Configurable)

| Responsibility | Description |
|----------------|-------------|
| Expert definitions | `EXPERT.md` files with role and guidelines |
| Phase sequence | Which phases exist and their order |
| Task lists | What work needs to be done |
| Templates | Output formats for artifacts |
| Human gates | Which phases require review |

---

## The Contract

The framework guarantees inputs to experts. In return, experts must produce specific outputs.

### Framework Guarantees (Inputs)

Every expert receives:

| Order | File | Purpose |
|-------|------|---------|
| 1 | `EXPERT.md` | Who you are |
| 2 | `WORKFLOW.md` | How to work |
| 3 | `IDEA.md` | What to build |
| 4 | `tasks.md` | Current tasks |
| 5 | `INDEX.md` | Project state |
| 6 | `docs/*` | Previous artifacts |
| 7 | `templates/` | Output formats |

### Expert Must Provide (Outputs)

Every expert must:

1. Create artifact in `docs/<phase>/`
2. Mark task `[x]` in tasks.md
3. Update INDEX.md iteration
4. Git commit with conventional format
5. If all done → `touch CREW_COMPLETE`

---

## Key Concepts

### Three-Layer File System

```
<project>/
├── IDEA.md          # INPUT  — User's idea (visible)
├── INDEX.md         # STATE  — Summary (visible)
├── .noodlecrew/     # STATE  — Internals (hidden)
└── docs/            # OUTPUT — Artifacts (visible)
```

### Termination Hierarchy

The framework checks these conditions in order:

| Priority | Condition | Result |
|----------|-----------|--------|
| 1 | `CREW_COMPLETE` exists | Success exit |
| 2 | Blocker pending | Pause |
| 3 | Human gate reached | Pause |
| 4 | Max iterations | Safety exit |
| 5 | Max cost | Budget exit |
| 6 | Otherwise | Continue loop |

### Atomic Progress

Each iteration:
- Does exactly **one task**
- Creates **one git commit**
- Updates state files

This ensures full audit trail, easy debugging, and clean rollback points.

---

## Further Reading

- [Project Structure](project-structure.md) — Directory layout details
- [State Files](state-files.md) — File format specifications
- [Execution Loop](execution-loop.md) — How the loop works
- [CLI Commands](cli-commands.md) — Available commands
