# Manifest Schema

> Complete reference for manifest.yml configuration.

---

## Overview

The `manifest.yml` file configures crew execution. It lives in the crew package and gets copied to `.noodlecrew/manifest.yml` when installed.

---

## Full Schema

```yaml
project:
  name: string           # Project identifier
  type: string           # Crew type (saas, api, fintech, etc.)

crew:
  default_llm: string    # Default LLM for all experts
  experts:               # Expert roster
    - role: string       # Expert identifier (matches folder name)
      phase: string      # Primary phase
      llm: string        # Optional: override LLM
      only: [string]     # Optional: limit to these phases
      except: [string]   # Optional: exclude from these phases

phases:                  # Execution order
  - string

execution:
  max_iterations: int    # Safety limit (default: 100)
  max_cost: float        # Budget limit (default: 30.00)

validation:
  human_gates: [string]  # Phases requiring review
  blocker_mode: string   # pause | skip

workflow:
  task_selection: string # first_unchecked | priority_weighted
  commit_format: string  # Git commit template
  auto_commit: bool      # Commit after each task
  one_task_per_turn: bool
  context: [string]      # Files to inject
  output_dir: string     # Artifact location template
  questions_dir: string  # Blocker location
```

---

## Sections

### project

Project metadata.

```yaml
project:
  name: "my-saas-idea"
  type: "saas"
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Project identifier (kebab-case) |
| `type` | No | Crew type for categorization |

### crew

Expert configuration.

```yaml
crew:
  default_llm: claude
  experts:
    - role: product-owner
      phase: discovery
    - role: software-architect
      phase: architecture
      llm: gemini-2.5-flash
```

| Field | Required | Description |
|-------|----------|-------------|
| `default_llm` | Yes | LLM for experts without override |
| `experts` | Yes | List of expert configurations |

#### Expert Fields

| Field | Required | Description |
|-------|----------|-------------|
| `role` | Yes | Expert identifier (matches folder in `experts/`) |
| `phase` | Yes | Primary phase this expert works in |
| `llm` | No | Override default LLM |
| `only` | No | Only participate in these phases |
| `except` | No | Exclude from these phases |

### phases

Execution order.

```yaml
phases:
  - discovery
  - architecture
  - implementation
```

Phases execute in order. Each phase must have at least one expert assigned.

### execution

Safety limits.

```yaml
execution:
  max_iterations: 100
  max_cost: 30.00
```

| Field | Default | Description |
|-------|---------|-------------|
| `max_iterations` | 100 | Stop after N iterations |
| `max_cost` | 30.00 | Stop after $N spent |

### validation

Human checkpoints.

```yaml
validation:
  human_gates:
    - discovery
    - architecture
  blocker_mode: pause
```

| Field | Default | Description |
|-------|---------|-------------|
| `human_gates` | `[]` | Phases that pause for review |
| `blocker_mode` | `pause` | `pause` or `skip` blockers |

### workflow

Execution behavior.

```yaml
workflow:
  task_selection: first_unchecked
  commit_format: "feat({{phase}}): {{task}}"
  auto_commit: true
  one_task_per_turn: true
  context:
    - IDEA.md
    - tasks.md
    - INDEX.md
    - previous_artifacts
    - WORKFLOW.md
  output_dir: docs/{{phase}}/
  questions_dir: questions/
```

| Field | Default | Description |
|-------|---------|-------------|
| `task_selection` | `first_unchecked` | How to pick next task |
| `commit_format` | `feat({{phase}}): {{task}}` | Git message template |
| `auto_commit` | `true` | Commit after each task |
| `one_task_per_turn` | `true` | Enforce single task per turn |
| `context` | See above | Files injected into prompts |
| `output_dir` | `docs/{{phase}}/` | Where artifacts go |
| `questions_dir` | `questions/` | Where blockers go |

---

## Supported LLMs

| Value | Model | Best For |
|-------|-------|----------|
| `claude` | Claude Sonnet 4.5 | General purpose |
| `claude-opus-4.5` | Claude Opus 4.5 | Complex reasoning |
| `gemini-2.5-flash` | Gemini 2.5 Flash | Fast iterations |
| `gemini-2.5-pro` | Gemini 2.5 Pro | Complex analysis |

---

## Examples

### Minimal

```yaml
project:
  name: "quick-idea"

crew:
  default_llm: claude
  experts:
    - role: product-owner
      phase: discovery
    - role: software-architect
      phase: architecture
    - role: developer
      phase: implementation

phases:
  - discovery
  - architecture
  - implementation
```

### With Human Gates

```yaml
project:
  name: "careful-project"

crew:
  default_llm: claude
  experts:
    - role: product-owner
      phase: discovery
    - role: software-architect
      phase: architecture
    - role: developer
      phase: implementation

phases:
  - discovery
  - architecture
  - implementation

validation:
  human_gates:
    - discovery      # Review PRD before architecture
    - architecture   # Review ADRs before implementation
```

### Mixed LLMs

```yaml
crew:
  default_llm: gemini-2.5-flash  # Fast by default

  experts:
    - role: product-owner
      # Uses gemini-2.5-flash

    - role: software-architect
      llm: claude  # Better for architecture decisions

    - role: developer
      llm: claude-opus-4.5  # Best for complex code
```

### Extended Crew

```yaml
crew:
  default_llm: claude
  experts:
    - role: product-owner
      phase: discovery
    - role: ux-designer
      phase: design
    - role: software-architect
      phase: architecture
    - role: developer
      phase: implementation
    - role: security-reviewer
      phase: review
      only: [architecture, review]

phases:
  - discovery
  - design
  - architecture
  - implementation
  - review

validation:
  human_gates:
    - architecture
    - review
```

---

## Environment Variables

Override config via environment:

```bash
NOODLECREW_DEFAULT_LLM=gemini ncrew run
NOODLECREW_MAX_ITERATIONS=50 ncrew run
```

| Variable | Overrides |
|----------|-----------|
| `NOODLECREW_DEFAULT_LLM` | `crew.default_llm` |
| `NOODLECREW_MAX_ITERATIONS` | `execution.max_iterations` |
| `NOODLECREW_MAX_COST` | `execution.max_cost` |

---

## Further Reading

- [Crew Overview](overview.md) — Crew anatomy
- [Expert Format](expert-format.md) — EXPERT.md specification
- [Workflow File](workflow-file.md) — WORKFLOW.md specification
