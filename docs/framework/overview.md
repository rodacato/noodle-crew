# Framework Overview

> What the ncrew CLI provides and guarantees.

---

## What is the Framework?

The **framework** is the runtime environment that executes crews. It provides:

- **Directory structure** — Where files must live
- **State management** — How progress is tracked
- **Execution loop** — How experts run
- **Termination protocol** — How completion is detected

The framework is **crew-agnostic**. It doesn't care what your experts do—only that they follow the [Expert Protocol](../crew-development/expert-format.md).

---

## Responsibilities

### Framework Owns

| Responsibility | Description |
|----------------|-------------|
| Directory layout | `.noodlecrew/`, `docs/`, `IDEA.md`, `INDEX.md` |
| State file schemas | Frontmatter format for INDEX.md, tasks.md |
| Execution loop | Build prompt → launch → log → check termination |
| Termination detection | `CREW_COMPLETE`, blockers, gates, limits |
| Context injection | What goes into each expert's prompt |
| CLI commands | `ncrew init`, `ncrew run`, `ncrew status` |

### Crew Owns

| Responsibility | Description |
|----------------|-------------|
| Expert definitions | `EXPERT.md` files with role and guidelines |
| Phase sequence | Which phases exist and their order |
| Task lists | What work needs to be done |
| Templates | Output formats for artifacts |
| Human gates | Which phases require review |

---

## The Contract

The framework guarantees certain inputs to experts. In return, experts must produce certain outputs.

### Framework Guarantees (Inputs)

Every expert receives:

```
1. EXPERT.md      ← Who you are
2. WORKFLOW.md    ← How to work
3. IDEA.md        ← What to build
4. tasks.md       ← Current tasks
5. INDEX.md       ← Project state
6. docs/*         ← Previous artifacts
7. templates/     ← Output formats
```

### Expert Must Provide (Outputs)

Every expert must:

```
1. Create artifact in docs/<phase>/
2. Mark task [x] in tasks.md
3. Update INDEX.md iteration
4. Git commit with conventional format
5. If all done → touch CREW_COMPLETE
```

See [FLOW.md](../../FLOW.md) for the complete technical specification.

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

1. `CREW_COMPLETE` exists → **Success**
2. Blocker pending → **Pause**
3. Human gate reached → **Pause**
4. Max iterations → **Safety exit**
5. Max cost → **Budget exit**
6. Otherwise → **Continue loop**

### Atomic Progress

Each iteration:
- Does exactly ONE task
- Creates ONE git commit
- Updates state files

This ensures:
- Full audit trail
- Easy debugging
- Clean rollback points

---

## Further Reading

- [Project Structure](project-structure.md) — Directory layout details
- [State Files](state-files.md) — File format specifications
- [Execution Loop](execution-loop.md) — How the loop works
- [CLI Commands](cli-commands.md) — Available commands
- [FLOW.md](../../FLOW.md) — Complete technical contract
