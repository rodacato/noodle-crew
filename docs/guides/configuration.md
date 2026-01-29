# Configuration Guide

> Complete reference for `.noodlecrew.yml` configuration.

---

## Overview

NoodleCrew is configured via `.noodlecrew.yml` in your project root. This file defines:

- Project metadata
- Which experts to use
- LLM assignments per expert
- Phase participation rules
- Validation gates

---

## Minimal Configuration

```yaml
project:
  name: "my-project"

crew:
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
```

This uses defaults: Claude for all experts, natural phases only.

---

## Full Configuration Reference

```yaml
# Project metadata
project:
  name: "my-saas-idea"
  type: "saas"                    # saas | consumer | api | tool | mobile

# Crew configuration
crew:
  # Default LLM for all experts (uses your CLI subscription)
  default_llm: claude             # claude | gemini-2.5-flash | gemini-2.5-pro

  # Expert definitions
  experts:
    # Core experts
    - role: product-owner
      # No llm → uses default_llm
      # No only/except → natural phase (discovery)

    - role: software-architect
      llm: gemini-2.5-flash       # Override: fast for decisions
      # Natural phase: architecture

    - role: developer
      llm: claude-opus-4.5        # Override: best for code
      except: [discovery, design] # Skip these phases

    # Extended experts
    - role: ux-designer
      only: [design]              # Only in design phase

    - role: qa-engineer
      llm: gemini-2.5-flash
      only: [testing, review]     # Testing and review phases

    - role: security-reviewer
      llm: claude-opus-4.5
      only: [architecture, review] # Cross-cutting review

# Phases to execute (in order)
phases:
  - discovery
  - design
  - architecture
  - implementation
  - testing
  - review

# Validation and quality control
validation:
  # Phases that pause for human approval
  human_gates:
    - architecture               # Review ADRs before implementation
    - review                     # Final review before completion

  # How to handle blockers
  blocker_mode: pause            # pause | skip

# Execution settings
execution:
  max_iterations: 100            # Safety limit
  commit_per_iteration: true     # Git commit after each iteration
```

---

## Experts Configuration

### Available Roles

| Role | Natural Phase | Description |
|------|---------------|-------------|
| `product-owner` | discovery | PRD, vision, personas |
| `software-architect` | architecture | ADRs, tech stack |
| `developer` | implementation | Specs, CHANGELOG |
| `ux-designer` | design | Wireframes, flows |
| `qa-engineer` | testing | Test plans, cases |
| `tech-writer` | documentation | Docs, guides |
| `security-reviewer` | review | Security analysis |
| `performance-reviewer` | review | Performance analysis |
| `accessibility-reviewer` | review | A11y compliance |

### Phase Participation

By default, each expert participates only in their natural phase. Override with:

**`only`** — Expert participates ONLY in these phases:

```yaml
- role: security-reviewer
  only: [architecture, review]    # Only these two phases
```

**`except`** — Expert participates in ALL phases EXCEPT these:

```yaml
- role: developer
  except: [discovery, design]     # All phases except these
```

**No modifier** — Uses natural phase only:

```yaml
- role: product-owner             # Only discovery phase
```

### LLM Assignment

Override the default LLM per expert:

```yaml
crew:
  default_llm: claude

  experts:
    - role: product-owner
      # Uses claude (default)

    - role: software-architect
      llm: gemini-2.5-flash       # Fast iterations

    - role: developer
      llm: claude-opus-4.5        # Complex reasoning
```

### Supported LLMs

| Value | Model | Best For |
|-------|-------|----------|
| `claude` | Claude Sonnet 4.5 | General purpose |
| `claude-sonnet-4.5` | Claude Sonnet 4.5 | Same as above |
| `claude-opus-4.5` | Claude Opus 4.5 | Complex reasoning |
| `gemini-2.5-flash` | Gemini 2.5 Flash | Fast iterations |
| `gemini-2.5-pro` | Gemini 2.5 Pro | Complex analysis |

**Prerequisites:** The respective CLI must be installed and authenticated:
- `claude` — Claude Code CLI
- `gemini` — Gemini CLI

---

## Phases Configuration

Define which phases to execute and in what order:

```yaml
phases:
  - discovery        # Product Owner
  - design           # UX Designer
  - architecture     # Software Architect
  - implementation   # Developer
  - testing          # QA Engineer
  - documentation    # Tech Writer
  - review           # Reviewers (Security, Performance, A11y)
```

**Skip phases** by omitting them:

```yaml
phases:
  - discovery
  - architecture
  - implementation
  # No design, testing, or review
```

---

## Validation Configuration

### Human Gates

Pause execution for human review after specific phases:

```yaml
validation:
  human_gates:
    - architecture    # Review ADRs before implementation
```

When a gate is reached:
1. Execution pauses
2. User reviews artifacts
3. User runs `ncrew resume` to continue

### Blocker Mode

How to handle expert blockers (questions that need user input):

```yaml
validation:
  blocker_mode: pause    # Default: pause and wait
```

Options:
- `pause` — Stop execution, wait for user response
- `skip` — Log the blocker, continue with best guess

---

## Execution Settings

```yaml
execution:
  max_iterations: 100           # Stop after N iterations
  commit_per_iteration: true    # Git commit each iteration
```

---

## Examples

### Minimal (3 Core Experts)

```yaml
project:
  name: "quick-prototype"

crew:
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
```

### Fast Iteration (Gemini)

```yaml
project:
  name: "rapid-mvp"

crew:
  default_llm: gemini-2.5-flash

  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
```

### Production-Ready (Full Crew)

```yaml
project:
  name: "production-app"
  type: "saas"

crew:
  default_llm: claude

  experts:
    # Core
    - role: product-owner
    - role: software-architect
    - role: developer
      llm: claude-opus-4.5

    # Quality
    - role: qa-engineer
      llm: gemini-2.5-flash
      only: [implementation, testing]

    # Security
    - role: security-reviewer
      llm: claude-opus-4.5
      only: [architecture, review]

phases:
  - discovery
  - architecture
  - implementation
  - testing
  - review

validation:
  human_gates:
    - architecture
    - review
```

### Hybrid LLM Strategy

Use fast models for iteration, powerful models for complexity:

```yaml
crew:
  default_llm: gemini-2.5-flash    # Fast default

  experts:
    - role: product-owner
      # Uses fast default

    - role: software-architect
      # Uses fast default

    - role: developer
      llm: claude-opus-4.5         # Complex: use powerful

    - role: security-reviewer
      llm: claude-opus-4.5         # Critical: use powerful
      only: [architecture, review]
```

---

## Beyond the YAML

The `.noodlecrew.yml` defines **who** does **what**. But your crew configuration also includes:

```text
my-project/
├── .noodlecrew.yml              # WHO does WHAT (this file)
└── .noodlecrew/
    ├── prompts/                 # HOW experts think
    │   ├── product-owner.md
    │   ├── software-architect.md
    │   └── developer.md
    └── templates/               # WHAT gets produced
        ├── prd-template.md
        ├── adr-template.md
        └── changelog-template.md
```

### Prompts

Expert prompts define their behavior, personality, and domain knowledge. Edit these to:

- Focus experts on your specific domain
- Add company-specific guidelines
- Change output style or format

### Templates

Templates define the structure of generated artifacts. Edit these to:

- Match your company's documentation format
- Add required sections (compliance, security)
- Remove sections you don't need

See [Creating Crews](../marketplace/creating-crews.md) for detailed customization guide.

---

## Environment Variables

Override configuration via environment:

```bash
NOODLECREW_DEFAULT_LLM=gemini-2.5-flash ncrew run
```

| Variable | Overrides |
|----------|-----------|
| `NOODLECREW_DEFAULT_LLM` | `crew.default_llm` |
| `NOODLECREW_MAX_ITERATIONS` | `execution.max_iterations` |

---

## Validation

Validate your configuration:

```bash
ncrew config validate
```

Show resolved configuration (with defaults applied):

```bash
ncrew config show
```

---

*See also: [Experts Guide](experts.md) | [Understanding Phases](phases.md)*
