# Experts Guide

> Understanding and configuring the NoodleCrew expert team.

---

## Overview

NoodleCrew uses specialized AI experts to handle different aspects of product development. Each expert has a defined role, produces specific artifacts, and operates in designated phases.

**Key concepts:**

- **Experts** are AI personas with specific responsibilities
- **Phases** are stages of the development lifecycle
- **Artifacts** are the documents each expert produces
- **LLM** can be configured per expert (Claude, Gemini, etc.)

---

## Phase-to-Expert Mapping

```
┌─────────────────────────────────────────────────────────────────────┐
│                        NOODLECREW PHASES                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  DISCOVERY          DESIGN           ARCHITECTURE                  │
│  ┌──────────┐      ┌──────────┐      ┌──────────────────┐          │
│  │ Product  │  →   │    UX    │  →   │    Software      │          │
│  │  Owner   │      │ Designer │      │    Architect     │          │
│  └──────────┘      └──────────┘      └──────────────────┘          │
│       │                 │                    │                      │
│       ▼                 ▼                    ▼                      │
│    PRD.md          Wireframes            ADRs                      │
│    Vision.md       User Flows            Architecture.md           │
│    Personas.md     Design System         Tech Stack                │
│                                                                     │
│  IMPLEMENTATION     TESTING             REVIEW                      │
│  ┌──────────┐      ┌──────────┐      ┌──────────────────┐          │
│  │Developer │  →   │    QA    │  →   │    Reviewers     │          │
│  │          │      │ Engineer │      │ (Sec/Perf/A11y)  │          │
│  └──────────┘      └──────────┘      └──────────────────┘          │
│       │                 │                    │                      │
│       ▼                 ▼                    ▼                      │
│  CHANGELOG.md      Test Plan           Security ADR                │
│  Impl Notes        Test Cases          Performance ADR             │
│  Code Specs        Quality Gates       A11y ADR                    │
│                                                                     │
│  DOCUMENTATION                                                      │
│  ┌──────────┐                                                       │
│  │  Tech    │                                                       │
│  │  Writer  │                                                       │
│  └──────────┘                                                       │
│       │                                                             │
│       ▼                                                             │
│  API Docs                                                           │
│  User Guides                                                        │
│  README                                                             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Core Experts

These are the primary experts for most projects.

### Product Owner

**Phase:** Discovery

**Responsibilities:**
- Validate idea viability (pre-check)
- Define problem statement and solution
- Create user personas
- Establish success metrics
- Define MVP scope

**Artifacts:**
- `01-discovery/prd.md` — Product Requirements Document
- `01-discovery/vision.md` — Product vision statement
- `01-discovery/personas.md` — User personas

**When to use:** Always. Every project starts with discovery.

**Recommended LLM:** Claude Sonnet 4.5 (good reasoning, follows templates well)

---

### Software Architect

**Phase:** Architecture

**Responsibilities:**
- Make technical decisions
- Document rationale in ADRs
- Choose tech stack
- Design system architecture
- Define data models

**Artifacts:**
- `04-architecture/adrs/*.md` — Architecture Decision Records
- `04-architecture/architecture.md` — System architecture overview
- `04-architecture/tech-stack.md` — Technology choices

**When to use:** Always. Technical decisions should be documented.

**Recommended LLM:** Claude Sonnet 4.5 or Gemini 2.5 Flash (architecture decisions benefit from speed)

---

### Developer

**Phase:** Implementation

**Responsibilities:**
- Create implementation specifications
- Define build order and dependencies
- Generate code structure
- Maintain changelog

**Artifacts:**
- `05-implementation/CHANGELOG.md` — Version history
- `05-implementation/implementation-notes.md` — Build specifications
- `05-implementation/code-structure.md` — Project organization

**When to use:** Always. Implementation specs guide development.

**Recommended LLM:** Claude Opus (best for complex implementation details)

---

## Extended Experts

Additional experts for comprehensive projects.

### UX Designer

**Phase:** Design

**Responsibilities:**
- Create wireframes
- Define user flows
- Establish design system
- Document UI patterns

**Artifacts:**
- `02-design/wireframes.md` — Screen mockups (ASCII/description)
- `02-design/user-flows.md` — User journey diagrams
- `02-design/design-system.md` — Colors, typography, components

**When to use:** Consumer apps, complex UIs, user-facing products.

**Recommended LLM:** Claude Sonnet 4.5 (good at visual descriptions)

---

### QA Engineer

**Phase:** Testing

**Responsibilities:**
- Create test plans
- Define test cases
- Establish quality gates
- Document acceptance criteria

**Artifacts:**
- `06-testing/test-plan.md` — Testing strategy
- `06-testing/test-cases.md` — Specific test scenarios
- `06-testing/quality-gates.md` — Release criteria

**When to use:** Production-bound projects, compliance requirements.

**Recommended LLM:** Gemini 2.5 Flash (fast, good for structured output)

---

### Tech Writer

**Phase:** Documentation

**Responsibilities:**
- Create user documentation
- Write API documentation
- Generate installation guides
- Maintain README

**Artifacts:**
- `07-docs/api-reference.md` — API documentation
- `07-docs/user-guide.md` — End-user documentation
- `07-docs/installation.md` — Setup instructions

**When to use:** Developer tools, APIs, products with users.

**Recommended LLM:** Claude Sonnet 4.5 (clear, concise writing)

---

## Review Experts

Cross-cutting experts that review artifacts from other phases.

### Security Reviewer

**Phase:** Review (cross-cutting)

**Responsibilities:**
- Review architecture for security issues
- Identify threat vectors
- Recommend mitigations
- Document security decisions

**Artifacts:**
- `04-architecture/adrs/xxx-security.md` — Security ADR

**When to use:** Fintech, healthcare, auth systems, data-sensitive apps.

**Recommended LLM:** Claude Opus (thorough analysis)

---

### Performance Reviewer

**Phase:** Review (cross-cutting)

**Responsibilities:**
- Review architecture for performance issues
- Identify bottlenecks
- Recommend optimizations
- Document performance decisions

**Artifacts:**
- `04-architecture/adrs/xxx-performance.md` — Performance ADR

**When to use:** High-traffic apps, real-time systems, data-intensive apps.

**Recommended LLM:** Claude Sonnet 4.5 (good technical analysis)

---

### Accessibility Reviewer

**Phase:** Review (cross-cutting)

**Responsibilities:**
- Review design for accessibility issues
- Check WCAG compliance
- Recommend improvements
- Document a11y decisions

**Artifacts:**
- `04-architecture/adrs/xxx-accessibility.md` — Accessibility ADR

**When to use:** Consumer apps, government/enterprise requirements, inclusive products.

**Recommended LLM:** Claude Sonnet 4.5 (understands standards well)

---

## Configuration

### Basic Configuration

```yaml
crew:
  default_llm: claude

  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
```

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

    - role: qa-engineer
      llm: gemini-2.5-flash      # Fast for test generation
```

### Phase Participation

By default, experts only participate in their natural phase. Use `only` or `except` to customize:

```yaml
crew:
  experts:
    - role: product-owner
      # No modifier → natural phase only (discovery)

    - role: security-reviewer
      only: [architecture, review]   # Only these phases

    - role: developer
      except: [discovery, design]    # All except these
```

### Full Crew Configuration

```yaml
crew:
  default_llm: claude

  experts:
    # Core
    - role: product-owner
    - role: software-architect
      llm: gemini-2.5-flash
    - role: developer
      llm: claude-opus-4.5
      except: [discovery, design]

    # Extended
    - role: ux-designer
      only: [design]
    - role: qa-engineer
      llm: gemini-2.5-flash
      only: [testing, review]
    - role: tech-writer

    # Reviewers (cross-cutting)
    - role: security-reviewer
      llm: claude-opus-4.5
      only: [architecture, review]
    - role: performance-reviewer
      only: [architecture, review]
    - role: accessibility-reviewer
      only: [design, review]

phases:
  - discovery
  - design
  - architecture
  - implementation
  - testing
  - documentation
  - review
```

---

## Supported LLMs

NoodleCrew uses your existing CLI subscriptions:

| LLM | Config Value | Best For |
|-----|--------------|----------|
| Claude Sonnet 4.5 | `claude` or `claude-sonnet-4.5` | General purpose, templates |
| Claude Opus 4.5 | `claude-opus-4.5` | Complex reasoning, code |
| Gemini 2.5 Flash | `gemini-2.5-flash` | Fast iterations, structured output |
| Gemini 2.5 Pro | `gemini-2.5-pro` | Complex analysis |

**Prerequisites:** Install and authenticate the respective CLIs:
- Claude Code CLI (`claude`)
- Gemini CLI (`gemini`)

---

## Creating Custom Experts

You can define custom experts by creating an expert directory:

```text
.noodlecrew/
└── experts/
    ├── product-owner/EXPERT.md       # Built-in
    ├── software-architect/EXPERT.md  # Built-in
    ├── developer/EXPERT.md           # Built-in
    └── my-custom-expert/EXPERT.md    # Your custom expert
```

Then reference in configuration:

```yaml
# .noodlecrew/config.yml
crew:
  experts:
    - role: my-custom-expert
      llm: claude
```

The role name must match the directory name in `experts/`.

See [Creating Custom Experts](../advanced/custom-experts.md) for details.

---

## Best Practices

1. **Start small** — Use core experts (PO, Architect, Developer) first
2. **Add reviewers for production** — Security/Performance for real deployments
3. **Match LLM to task** — Fast models for iteration, powerful for complexity
4. **Review artifacts** — Human gates after Architecture phase recommended

---

*See also: [Configuration Guide](configuration.md) | [Understanding Phases](phases.md)*
