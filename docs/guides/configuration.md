# Configuration Guide

> Complete reference for `.noodlecrew/config.yml` configuration.

---

## Overview

NoodleCrew is configured via the `.noodlecrew/` directory in your project root:

```text
.noodlecrew/
├── config.yml                        # Main configuration
├── CREW.md                           # Crew overview and metadata
├── PHASES.md                         # Phases overview and flow
├── experts/                          # Expert definitions (self-contained)
│   ├── product-owner/
│   │   ├── EXPERT.md                 # How this expert thinks
│   │   └── templates/                # What this expert produces
│   │       ├── prd.md
│   │       └── personas.md
│   ├── software-architect/
│   │   ├── EXPERT.md
│   │   └── templates/
│   │       └── adr.md
│   └── developer/
│       ├── EXPERT.md
│       └── templates/
│           └── changelog.md
└── phases/                           # Phase definitions
    ├── discovery/PHASE.md
    ├── architecture/PHASE.md
    └── implementation/PHASE.md
```

Each expert is self-contained with its prompt (`EXPERT.md`) and its templates.

The `config.yml` file defines:

- Project metadata
- Which experts to use
- LLM assignments per expert
- Phase participation rules
- Validation gates

---

## Minimal Configuration

```yaml
# .noodlecrew/config.yml
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

## Directory Structure

Everything lives in `.noodlecrew/`:

```text
my-project/
└── .noodlecrew/
    ├── config.yml                        # WHO does WHAT
    ├── CREW.md                           # Crew overview and metadata
    ├── PHASES.md                         # Phases overview and flow
    ├── experts/                          # Self-contained expert units
    │   ├── product-owner/
    │   │   ├── EXPERT.md                 # How this expert thinks
    │   │   └── templates/                # What this expert produces
    │   │       ├── prd.md
    │   │       └── personas.md
    │   ├── software-architect/
    │   │   ├── EXPERT.md
    │   │   └── templates/
    │   │       └── adr.md
    │   └── developer/
    │       ├── EXPERT.md
    │       └── templates/
    │           └── changelog.md
    └── phases/                           # Phase definitions
        ├── discovery/PHASE.md
        ├── architecture/PHASE.md
        └── implementation/PHASE.md
```

Each expert is self-contained with its prompt and templates.

### CREW.md

The crew manifest contains metadata about your crew:

```markdown
---
name: My Custom Crew
version: 1.0.0
author: "@myhandle"
tags: [saas, b2b]
---

# My Custom Crew

Description of what this crew does and when to use it.
```

### PHASES.md

The phases overview describes the execution flow:

```markdown
# Phases

## Overview

This crew uses 3 phases: Discovery → Architecture → Implementation.

## Flow

1. **Discovery** — Product Owner validates idea and creates PRD
2. **Architecture** — Architect makes technical decisions, documents ADRs
3. **Implementation** — Developer creates specs and CHANGELOG

## Human Gates

- After Architecture: Review ADRs before implementation
```

### Experts (EXPERT.md + templates/)

Each expert directory contains:

- **EXPERT.md** — Defines behavior, personality, and domain knowledge
- **templates/** — Templates for artifacts this expert produces

Edit EXPERT.md to:

- Focus experts on your specific domain
- Add company-specific guidelines
- Change output style or format

Edit templates to:

- Match your company's documentation format
- Add required sections (compliance, security)
- Remove sections you don't need

### Phases (PHASE.md)

Each phase directory contains a PHASE.md that defines:

- Description and purpose
- Entry criteria (what must exist before starting)
- Exit criteria (what must be produced)
- Default participating experts
- Validation rules

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
