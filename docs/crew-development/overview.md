# Crew Development

> How to create and customize crews.

---

## TL;DR

A **crew** is a package of experts, phases, and templates that defines *what* gets done. The framework handles *how* it runs. Start from the default crew and customize, or build your own from scratch.

```
CREW = Experts + Phases + Tasks + Templates + Config
```

---

## Quick Navigation

| I want to... | Go to |
|--------------|-------|
| Define an expert | [Expert Format](expert-format.md) |
| Configure manifest.yml | [Manifest Schema](manifest-schema.md) |
| Write workflow instructions | [Workflow File](workflow-file.md) |
| Publish to marketplace | [Marketplace](../marketplace/index.md) |

---

## Crew Anatomy

```
marketplace/<crew-name>/
├── manifest.yml          # Configuration
├── CREW.md               # Metadata and description
├── PHASES.md             # Phase overview
├── WORKFLOW.md           # Instructions for all experts
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

| File | Purpose |
|------|---------|
| `manifest.yml` | Experts, phases, LLMs, execution settings |
| `WORKFLOW.md` | Instructions injected into every expert |
| `EXPERT.md` | Role definition for each expert |
| `templates/` | Output formats for artifacts |

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
  default_llm: claude
  experts:
    - role: my-expert
      phase: my-phase

phases:
  - my-phase
```

### 3. Create Expert

```bash
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

Write `phases/my-phase/PHASE.md`:

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

| Principle | Description |
|-----------|-------------|
| Single responsibility | One expert, one domain |
| Opinionated defaults | Make decisions, document rationale |
| Clear outputs | Explicit templates with all sections |
| Minimal blockers | Only ask for genuine ambiguity |

### Phase Design

| Principle | Description |
|-----------|-------------|
| Sequential dependencies | Later phases read earlier artifacts |
| Clear boundaries | No overlap between phase outputs |
| Atomic tasks | Each task produces one artifact |

### Task Design

| Principle | Description |
|-----------|-------------|
| Specific | "Generate PRD" not "Do product work" |
| Completable | Can be done in one turn |
| Verifiable | Clear when done |

---

## Publishing to Marketplace

1. Ensure all required files present
2. Add `CREW.md` with description
3. Test with `ncrew init <project> --crew <your-crew>`
4. Submit PR to `marketplace/`

---

## Further Reading

- [Expert Format](expert-format.md) — EXPERT.md specification
- [Manifest Schema](manifest-schema.md) — Configuration reference
- [Workflow File](workflow-file.md) — WORKFLOW.md specification
- [Framework Overview](../framework/overview.md) — How crews execute
