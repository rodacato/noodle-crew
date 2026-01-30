# Manifest Schema

> Complete reference for manifest.yml configuration.

---

## TL;DR

`manifest.yml` configures crew execution: experts, phases, LLMs, and safety limits. It lives in the crew package and gets copied to `.noodlecrew/manifest.yml` when installed.

---

## Quick Reference

| Section | Purpose |
|---------|---------|
| `project` | Name and type |
| `crew` | Experts and default LLM |
| `phases` | Execution order |
| `execution` | Safety limits |
| `validation` | Human gates |
| `workflow` | Execution behavior |

---

## Full Schema

```yaml
project:
  name: string           # Project identifier
  type: string           # Crew type (saas, api, fintech, etc.)

crew:
  default_llm: string    # Default LLM for all experts
  experts:               # Expert roster
    - role: string       # Expert identifier
      phase: string      # Primary phase
      llm: string        # Optional: override LLM

phases:                  # Execution order
  - string

execution:
  max_iterations: int    # Safety limit (default: 100)
  max_cost: float        # Budget limit (default: 30.00)

validation:
  human_gates: [string]  # Phases requiring review
```

---

## Sections

### project

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

### phases

```yaml
phases:
  - discovery
  - architecture
  - implementation
```

Phases execute in order. Each phase must have at least one expert assigned.

### execution

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

```yaml
validation:
  human_gates:
    - discovery
    - architecture
```

| Field | Default | Description |
|-------|---------|-------------|
| `human_gates` | `[]` | Phases that pause for review |

---

## Supported LLMs

| Value | Model | Best For |
|-------|-------|----------|
| `claude` | Claude Sonnet | General purpose |
| `claude-opus-4.5` | Claude Opus | Complex reasoning |
| `gemini-2.5-flash` | Gemini Flash | Fast iterations |
| `gemini-2.5-pro` | Gemini Pro | Complex analysis |

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
      llm: claude  # Better for architecture

    - role: developer
      llm: claude-opus-4.5  # Best for complex code
```

---

## Environment Variables

Override configuration via environment:

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
