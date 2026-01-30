# Crew Development Overview

> How to create and customize crews.

---

## What is a Crew?

A **crew** is a package of experts, phases, and configuration that defines *what* gets done. The [framework](../framework/overview.md) handles *how* it runs.

```
CREW = Experts + Phases + Tasks + Config
```

---

## Crew Anatomy

```
marketplace/<crew-name>/
├── manifest.yml          # Configuration
├── CREW.md               # Metadata and description
├── PHASES.md             # Phase overview
├── WORKFLOW.md           # Instructions for experts
├── experts/              # Expert definitions
│   └── <role>/
│       ├── EXPERT.md     # Role definition
│       └── templates/    # Output formats
├── phases/               # Phase definitions
│   └── <phase>/
│       └── PHASE.md
└── templates/            # Project templates
    ├── IDEA.md           # User input template
    ├── INDEX.md          # State template
    └── tasks.md          # Task list template
```

---

## Key Files

### manifest.yml

The crew's configuration. Defines experts, phases, LLMs, and execution settings.

```yaml
project:
  name: "my-crew"
  type: "saas"

crew:
  default_llm: claude
  experts:
    - role: product-owner
      phase: discovery
    - role: software-architect
      phase: architecture

phases:
  - discovery
  - architecture

execution:
  max_iterations: 100

validation:
  human_gates: []
```

See [Manifest Schema](manifest-schema.md) for full reference.

### WORKFLOW.md

Instructions injected into every expert's prompt. Defines:

- How to read tasks
- How to create artifacts
- How to update state
- How to commit changes

This file is **crew-specific** but follows framework conventions.

See [Workflow File](workflow-file.md) for details.

### EXPERT.md

Each expert has an `EXPERT.md` that defines:

- Role (who you are)
- Responsibilities (what you do)
- Output format (how to structure artifacts)
- Decision guidelines (how to think)

See [Expert Format](expert-format.md) for specification.

---

## Creating a Crew

### 1. Start from Default

```bash
cp -r marketplace/default marketplace/my-crew
```

### 2. Edit manifest.yml

```yaml
project:
  name: "my-crew"
  type: "custom"

crew:
  experts:
    - role: my-expert
      phase: my-phase
```

### 3. Create Expert

```
mkdir -p marketplace/my-crew/experts/my-expert/templates
```

Write `EXPERT.md`:

```markdown
# My Expert

## Role
You are a [role] specialized in [domain].

## Responsibilities
- Task 1
- Task 2

## Output Format
Use templates in your `templates/` directory.

## Decision Guidelines
- Be opinionated
- Document rationale
```

### 4. Create Templates

```markdown
---
type: my-artifact
version: 1.0.0
status: draft
---

# Title

## Section 1

## Section 2
```

### 5. Define Phase

```
mkdir -p marketplace/my-crew/phases/my-phase
```

Write `PHASE.md`:

```markdown
# My Phase

**Expert:** my-expert
**Purpose:** [What this phase accomplishes]

**Tasks:**
- Task 1
- Task 2

**Output:** `docs/my-phase/`
```

### 6. Update tasks.md Template

Add your phase and tasks to `templates/tasks.md`.

---

## Crew Types

### Minimal (3 experts)

```
experts/
├── product-owner/
├── software-architect/
└── developer/
```

### Extended (with review)

```
experts/
├── product-owner/
├── ux-designer/
├── software-architect/
├── developer/
├── qa-engineer/
└── security-reviewer/
```

### Specialized (vertical)

```
experts/
├── fintech-analyst/
├── compliance-officer/
├── backend-architect/
└── frontend-developer/
```

---

## Best Practices

### Expert Design

1. **Single responsibility** — One expert, one domain
2. **Opinionated defaults** — Make decisions, document rationale
3. **Clear outputs** — Explicit templates with all sections
4. **Minimal blockers** — Only ask for genuine ambiguity

### Phase Design

1. **Sequential dependencies** — Later phases read earlier artifacts
2. **Clear boundaries** — No overlap between phase outputs
3. **Atomic tasks** — Each task produces one artifact

### Task Design

1. **Specific** — "Generate PRD" not "Do product work"
2. **Completable** — Can be done in one turn
3. **Verifiable** — Clear when done

---

## Publishing to Marketplace

1. Ensure all files present
2. Add `CREW.md` with description
3. Test with `ncrew init <project> --crew <your-crew>`
4. Submit PR to `marketplace/`

---

## Further Reading

- [Expert Format](expert-format.md) — EXPERT.md specification
- [Manifest Schema](manifest-schema.md) — Configuration reference
- [Workflow File](workflow-file.md) — WORKFLOW.md specification
- [Framework Overview](../framework/overview.md) — How crews execute
