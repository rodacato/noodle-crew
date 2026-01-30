# Workflow File

> Specification for WORKFLOW.md — instructions injected into every expert's prompt.

---

## Overview

`WORKFLOW.md` contains the execution instructions that every expert receives. It defines:

- How to read and update tasks
- How to create artifacts
- How to manage state
- How to commit changes

This file is **crew-specific** but must follow framework conventions.

---

## Location

```
marketplace/<crew>/WORKFLOW.md
     ↓ (ncrew init)
.noodlecrew/WORKFLOW.md
```

---

## Required Sections

### Execution Model

Explains that experts are autonomous and run in a loop.

```markdown
## Execution Model

You are an **autonomous expert** working as part of a crew.
You have full access to the filesystem and shell.
The orchestrator will restart you after each turn until all work is complete.
```

### Your Turn

Step-by-step instructions for each iteration.

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

Table of where files live.

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

Guidelines for autonomous decisions.

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

When and how to create blocker files.

```markdown
### Creating Blockers

Create a blocker file ONLY when:
- Requirements are genuinely contradictory
- A decision would fundamentally change the product direction
- Critical business/compliance information is missing

To create a blocker:

\`\`\`bash
cat > questions/{{role}}-{{number}}-{{topic}}.md << 'EOF'
---
from: {{role}}
to: user
type: blocker
status: pending
created: "{{timestamp}}"
---

# BLOCKER: {{title}}

## Context
[Why this decision is needed]

## Question
[The specific question]

## Options
...

## Recommendation
[Your suggestion]

---

## Your Answer (required to resume)

**Decision**: ___
**Reason**: ___
EOF
\`\`\`
```

### Git Conventions

Commit format and what to include.

```markdown
## Git Conventions

### Commit Format

\`\`\`
feat({{phase}}): {{brief description}}
\`\`\`

Examples:
- `feat(discovery): generate PRD from idea`
- `feat(architecture): ADR-001 frontend framework`

### What to Commit

- Your artifact in `docs/{{phase}}/`
- Updated `tasks.md` with task marked complete
- Updated `INDEX.md` with new iteration
```

### Termination

How to signal completion.

```markdown
## Termination

After completing your task, check tasks.md:

\`\`\`
Are ALL tasks in ALL phases checked [x]?
├── YES → touch CREW_COMPLETE && end turn
└── NO  → end turn (loop restarts you or next expert)
\`\`\`
```

---

## Template Variables

Use these placeholders in WORKFLOW.md:

| Variable | Description |
|----------|-------------|
| `{{phase}}` | Current phase name |
| `{{role}}` | Current expert role |
| `{{task}}` | Current task description |
| `{{timestamp}}` | ISO datetime |
| `{{number}}` | Sequential number |
| `{{topic}}` | Blocker topic (kebab-case) |

---

## Complete Example

See [marketplace/default/WORKFLOW.md](../../marketplace/default/WORKFLOW.md) for the full default implementation.

---

## Customization

### Adding Crew-Specific Rules

Add sections for your domain:

```markdown
## Domain Guidelines

### Fintech Requirements

- All monetary values must use decimal (not float)
- Include compliance considerations in every ADR
- Document audit trail requirements
```

### Changing Task Selection

Default is first unchecked. For priority-based:

```markdown
## Your Turn

1. **Read tasks.md** — Find the highest priority unchecked task
   - Priority indicated by `[!]` prefix
   - If no priority markers, use first unchecked
```

### Custom Commit Format

For teams with different conventions:

```markdown
## Git Conventions

### Commit Format

\`\`\`
[NOODLE-{{iteration}}] {{task}} ({{phase}})
\`\`\`
```

---

## Validation

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
- [Framework Execution Loop](../framework/execution-loop.md) — How the loop works
