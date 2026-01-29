# Architecture Phase

## Purpose

Define **how** to build it.

## Expert

**Software Architect** — Makes pragmatic technical decisions.

## Tasks

1. ADR-001: Frontend framework
2. ADR-002: Database choice
3. ADR-003: Authentication strategy
4. Create architecture overview
5. Document tech stack

## Outputs

| File | Description |
|------|-------------|
| `docs/architecture/adrs/*.md` | Architecture Decision Records |
| `docs/architecture/architecture.md` | System architecture overview |
| `docs/architecture/tech-stack.md` | Technology choices summary |

## Success Criteria

- All major technical decisions documented
- Rationale clear for each choice
- Alternatives considered
- Consequences understood

## Transition

This phase completes when all tasks are checked in TODO.md.

If `human_gates: [architecture]` is configured, execution pauses for review before Implementation phase.
