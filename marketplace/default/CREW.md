# Default Crew

> The standard NoodleCrew configuration for general projects.

---

## Overview

This crew takes your idea from concept to implementation-ready documentation:

1. **Discovery** — Product Owner defines what to build and why
2. **Architecture** — Software Architect defines how to build it
3. **Implementation** — Developer documents the implementation path

## Experts

| Expert | Phase | Produces |
|--------|-------|----------|
| Product Owner | Discovery | PRD, Personas, Vision |
| Software Architect | Architecture | ADRs, Architecture Overview |
| Developer | Implementation | CHANGELOG, Implementation Notes |

## When to Use

Use this crew for:

- General SaaS products
- Web applications
- API services
- Internal tools

## Customization

Override LLM per expert in `manifest.yml`:

```yaml
crew:
  experts:
    - role: software-architect
      llm: gemini-2.5-flash  # Faster for architecture decisions
```

Add human gates for review points:

```yaml
validation:
  human_gates:
    - discovery     # Review PRD before architecture
    - architecture  # Review ADRs before implementation
```

---

*Part of NoodleCrew marketplace. See [documentation](../../docs/) for more.*
