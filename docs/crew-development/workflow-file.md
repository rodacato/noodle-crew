# Workflow File

> Specification for WORKFLOW.md — instructions injected into every expert's prompt.

---

## TL;DR

`WORKFLOW.md` contains execution instructions for all experts: how to read tasks, create artifacts, update state, and commit changes. It's **crew-specific** but must follow framework conventions.

---

## Location

```
marketplace/<crew>/WORKFLOW.md
     ↓ (ncrew init)
.noodlecrew/WORKFLOW.md
```

---

## Required Sections

| Section | Purpose |
|---------|---------|
| Execution Model | Explains autonomous operation |
| Your Turn | Step-by-step instructions |
| File Locations | Where files live |
| Decision Making | Autonomy guidelines |
| Creating Blockers | When/how to pause |
| Git Conventions | Commit format |
| Termination | How to signal "done" |

---

## Section Templates

### Execution Model

```markdown
## Execution Model

You are an **autonomous expert** working as part of a crew.
You have full access to the filesystem and shell.
The orchestrator will restart you after each turn until all work is complete.
```

### Your Turn

```markdown
## Your Turn

Each turn, you must:

1. **Read tasks.md** — Find the first unchecked task `[ ]` in your phase
2. **Do ONE task** — Create or update the required artifact
3. **Update state** — Mark the task `[x]` in tasks.md, update INDEX.md
4. **Commit** — `git add . && git commit -m "feat({{phase}}): {{task}}"`
5. **End turn** — Stop. The loop will restart you if there's more work.

**CRITICAL:** Do exactly ONE task per turn. Do not continue to the next task.
```

### File Locations

```markdown
## File Locations

| File | Location | Purpose |
|------|----------|---------|
| Your input | `IDEA.md` | Original idea from user |
| Your tasks | `tasks.md` | Task checklist |
| Project state | `INDEX.md` | Phase, iteration, status |
| Your output | `docs/{{phase}}/` | Artifacts you create |
| Blockers | `questions/` | Questions for the user |
```

### Decision Making

```markdown
## Decision Making

### Be Opinionated

You are an expert. Make reasonable decisions based on:
- Industry best practices
- The information in IDEA.md and previous artifacts
- Your professional judgment

**DON'T** ask the user for:
- Preferences ("Do you prefer X or Y?")
- Confirmations ("Is this correct?")
- Details you can reasonably assume

**DO** document your rationale for important decisions.
```

### Creating Blockers

```markdown
## Creating Blockers

Create a blocker file ONLY when:
- Requirements are genuinely contradictory
- A decision would fundamentally change product direction
- Critical business/compliance information is missing

File format: `questions/{{role}}-{{number}}-{{topic}}.md`

Include:
- Context (why this decision is needed)
- Question (specific)
- Options (with pros/cons)
- Recommendation (your suggestion)
```

### Git Conventions

```markdown
## Git Conventions

### Commit Format

feat({{phase}}): {{brief description}}

Examples:
- `feat(discovery): generate PRD from idea`
- `feat(architecture): ADR-001 frontend framework`

### What to Commit

- Your artifact in `docs/{{phase}}/`
- Updated `tasks.md` with task marked complete
- Updated `INDEX.md` with new iteration
```

### Termination

```markdown
## Termination

After completing your task, check tasks.md:

Are ALL tasks in ALL phases checked [x]?
├── YES → touch CREW_COMPLETE && end turn
└── NO  → end turn (loop restarts you or next expert)
```

---

## Template Variables

| Variable | Description |
|----------|-------------|
| `{{phase}}` | Current phase name |
| `{{role}}` | Current expert role |
| `{{task}}` | Current task description |
| `{{timestamp}}` | ISO datetime |

---

## Customization

### Adding Domain Rules

```markdown
## Domain Guidelines

### Fintech Requirements

- All monetary values must use decimal (not float)
- Include compliance considerations in every ADR
- Document audit trail requirements
```

### Custom Commit Format

```markdown
## Git Conventions

### Commit Format

[NOODLE-{{iteration}}] {{task}} ({{phase}})
```

---

## Validation Checklist

A valid WORKFLOW.md must include:

- [ ] Execution model explanation
- [ ] Step-by-step turn instructions
- [ ] File location table
- [ ] Decision-making guidelines
- [ ] Blocker creation protocol
- [ ] Git commit conventions
- [ ] Termination instructions

---

## Further Reading

- [Crew Overview](overview.md) — Crew anatomy
- [Expert Format](expert-format.md) — EXPERT.md specification
- [Execution Loop](../framework/execution-loop.md) — How the loop works
