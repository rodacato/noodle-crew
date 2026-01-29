# Phases

> Execution flow for the Default Crew.

---

## Flow

```
DISCOVERY ──────► ARCHITECTURE ──────► IMPLEMENTATION
    │                  │                     │
    ▼                  ▼                     ▼
  PRD              ADRs               CHANGELOG
  Personas         Architecture       Implementation Notes
  Vision           Tech Stack
```

---

## Discovery

**Expert:** Product Owner

**Purpose:** Define what to build and why.

**Tasks:**
- Generate PRD from IDEA.md
- Define user personas
- Create product vision

**Output:** `docs/discovery/`

---

## Architecture

**Expert:** Software Architect

**Purpose:** Define how to build it.

**Tasks:**
- ADR-001: Frontend framework
- ADR-002: Database choice
- ADR-003: Authentication strategy
- Architecture overview

**Output:** `docs/architecture/`

---

## Implementation

**Expert:** Developer

**Purpose:** Document the implementation path.

**Tasks:**
- Generate CHANGELOG structure
- Document implementation steps
- Create code snippets (optional)

**Output:** `docs/implementation/`

---

## Adding Phases

Edit `manifest.yml` to add phases:

```yaml
phases:
  - discovery
  - architecture
  - design        # Add new phase
  - implementation
```

Then create `phases/design/PHASE.md` and the corresponding expert.
