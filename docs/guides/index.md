# Configuration Guide

> Complete reference for configuring NoodleCrew crews.

---

## Overview

All crew configuration lives in `.noodlecrew/`:

```text
.noodlecrew/
├── manifest.yml                    # Main configuration
├── CREW.md                       # Crew metadata
├── PHASES.md                     # Phases overview
├── experts/                      # Expert definitions
│   └── product-owner/
│       ├── EXPERT.md             # How this expert thinks
│       └── templates/            # What this expert produces
│           └── prd.md
└── phases/                       # Phase definitions
    └── discovery/PHASE.md
```

---

## Quick Start Configuration

```yaml
# .noodlecrew/manifest.yml
project:
  name: "my-project"
  type: "saas"

crew:
  default_llm: claude
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer

phases:
  - discovery
  - architecture
  - implementation

validation:
  human_gates:
    - architecture
```

---

## Experts

### Core Experts

| Expert | Phase | Produces |
|--------|-------|----------|
| `product-owner` | discovery | PRD, vision, personas |
| `software-architect` | architecture | ADRs, tech stack |
| `developer` | implementation | Specs, changelog |

### Extended Experts

| Expert | Phase | Produces |
|--------|-------|----------|
| `ux-designer` | design | Wireframes, user flows |
| `qa-engineer` | testing | Test plans, cases |
| `tech-writer` | documentation | API docs, guides |
| `security-reviewer` | review | Security ADRs |
| `performance-reviewer` | review | Performance ADRs |

### Per-Expert LLM Override

```yaml
crew:
  default_llm: claude

  experts:
    - role: product-owner
      # Uses default (claude)

    - role: software-architect
      llm: gemini-2.5-flash      # Fast for decisions

    - role: developer
      llm: claude-opus-4.5       # Best for code
```

### Phase Participation

By default, experts only participate in their natural phase. Override with `only` or `except`:

```yaml
crew:
  experts:
    - role: security-reviewer
      only: [architecture, review]   # Only these phases

    - role: developer
      except: [discovery, design]    # All except these
```

---

## Supported LLMs

| Value | Model | Best For |
|-------|-------|----------|
| `claude` | Claude Sonnet 4.5 | General purpose |
| `claude-opus-4.5` | Claude Opus 4.5 | Complex reasoning |
| `gemini-2.5-flash` | Gemini 2.5 Flash | Fast iterations |
| `gemini-2.5-pro` | Gemini 2.5 Pro | Complex analysis |

**Prerequisites:** Claude Code CLI and/or Gemini CLI installed and authenticated.

---

## Phases

Define which phases to execute:

```yaml
phases:
  - discovery        # Product Owner
  - design           # UX Designer
  - architecture     # Software Architect
  - implementation   # Developer
  - testing          # QA Engineer
  - review           # Reviewers
```

Skip phases by omitting them from the list.

---

## Validation

### Human Gates

Pause for human review after specific phases:

```yaml
validation:
  human_gates:
    - architecture    # Review ADRs before implementation
```

### Blocker Mode

```yaml
validation:
  blocker_mode: pause    # pause | skip
```

---

## Execution Settings

```yaml
execution:
  max_iterations: 100           # Safety limit
  commit_per_iteration: true    # Git commit each iteration
```

---

## Creating Custom Experts

Create an expert directory with `EXPERT.md` and `templates/`:

```text
.noodlecrew/experts/my-expert/
├── EXPERT.md
└── templates/
    └── my-template.md
```

**EXPERT.md structure:**

```markdown
# My Expert

## Role
You are a [role] specialized in [domain].

## Responsibilities
- [What this expert does]

## Output Format
Use the templates in your `templates/` directory.

## Domain Knowledge
- [Relevant expertise]
```

Then reference in config:

```yaml
crew:
  experts:
    - role: my-expert
```

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

## Example Configurations

### Minimal (3 Experts)

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
crew:
  default_llm: gemini-2.5-flash
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
```

### Production-Ready (Full Crew)

```yaml
crew:
  default_llm: claude

  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
      llm: claude-opus-4.5
    - role: security-reviewer
      llm: claude-opus-4.5
      only: [architecture, review]

phases:
  - discovery
  - architecture
  - implementation
  - review

validation:
  human_gates:
    - architecture
    - review
```

---

*See also: [Project Structure](../reference/project-structure.md) | [Marketplace](../marketplace/index.md)*
