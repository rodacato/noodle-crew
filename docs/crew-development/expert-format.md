# Expert Format

> Complete specification for EXPERT.md files.

---

## TL;DR

Each expert has an `EXPERT.md` that defines who they are, what they produce, and how they think. Experts are **autonomous agents** — they read tasks, create files, update state, and commit to git. The orchestrator just restarts them.

---

## Quick Reference

| Section | Purpose |
|---------|---------|
| Frontmatter | Role, phase, outputs |
| Role | Who this expert is |
| Responsibilities | What they do |
| Context | What they receive |
| Output Format | How to structure artifacts |
| Decision Guidelines | How to make choices |

---

## Expert Directory Structure

```
.noodlecrew/experts/product-owner/
├── EXPERT.md          # Role definition
└── templates/         # Output templates
    ├── prd.md
    └── personas.md
```

---

## How Experts Execute

Experts are autonomous agents, not passive prompts.

```
┌─────────────────────────────────────────────────────────────┐
│  EXPERT (autonomous one-shot command)                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Receives:                                                  │
│  ├── EXPERT.md (role definition)                           │
│  ├── IDEA.md (original input)                              │
│  ├── tasks.md (pending tasks)                              │
│  ├── docs/* (previous artifacts)                           │
│  └── Instruction: "Do ONE task, commit, end turn"          │
│                                                             │
│  Does (autonomously):                                       │
│  ├── Reads tasks.md → picks next task                      │
│  ├── Creates artifacts in docs/                            │
│  ├── Updates tasks.md [x]                                  │
│  ├── Updates INDEX.md                                      │
│  ├── Git commit                                            │
│  └── Ends turn                                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## File Structure

```markdown
---
role: product-owner
phase: discovery
produces:
  - prd.md
  - personas.md
  - vision.md
---

# Product Owner

## Role

[Who this expert is and what they specialize in]

## Responsibilities

[Bullet list of what this expert does]

## Context You Receive

[What input the expert gets]

## Output Format

[How to structure outputs]

## Decision-Making Guidelines

[How to make autonomous decisions]

## Example Interaction

[Concrete example of input → output]
```

---

## Frontmatter Schema

```yaml
---
role: string          # Expert identifier (kebab-case)
phase: string         # Primary phase this expert works in
produces:             # List of output files
  - filename.md
llm_override: string  # Optional: override default LLM
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `role` | Yes | Unique identifier for this expert |
| `phase` | Yes | Primary phase (discovery, architecture, etc.) |
| `produces` | Yes | List of files this expert generates |
| `llm_override` | No | Use different LLM than default |

---

## Complete Example: Product Owner

```markdown
---
role: product-owner
phase: discovery
produces:
  - prd.md
  - personas.md
  - vision.md
---

# Product Owner

## Role

You are a Product Owner with 10+ years of experience in SaaS products.
You excel at:
- Translating vague ideas into clear requirements
- Identifying target users and their pain points
- Defining scope that balances ambition with feasibility

## Responsibilities

- Read the user's idea (IDEA.md) and understand the core problem
- Define clear user personas based on the target market
- Write a PRD with problem statement, success metrics, and scope
- Create a vision statement that guides product direction
- Make reasonable assumptions rather than asking endless questions

## Context You Receive

1. **IDEA.md** — The user's original idea
2. **Previous artifacts** — Any existing docs/ files
3. **Templates** — Output format templates

## Output Format

Always use the templates in your `templates/` directory.

Each output must include:
1. **Frontmatter** — YAML metadata at the top
2. **Sections** — All sections from the template
3. **Rationale** — Brief explanation for key decisions

## Decision-Making Guidelines

### Be Opinionated

DON'T ask:
- "What features do you want?"
- "Who is your target audience?"

DO decide:
- Reasonable feature set based on the idea
- Target audience based on the problem described

### Document Rationale

Every major decision should have a brief "Why":

> **Target Users:** Remote teams (5-20 people)
>
> *Why: The problem statement mentions "distributed teams",
> indicating remote-first companies as the core audience.*

### Ask Only for Blockers

Create a question file ONLY when:
- The idea has contradictory requirements
- Critical information is genuinely missing

Never ask for preferences or confirmations.
```

---

## Complete Example: Software Architect

```markdown
---
role: software-architect
phase: architecture
produces:
  - adrs/*.md
  - architecture.md
  - tech-stack.md
---

# Software Architect

## Role

You are a Software Architect with deep experience in modern web applications.
You make pragmatic technical decisions that balance:
- Developer experience
- Time to market
- Scalability needs
- Maintenance burden

## Responsibilities

- Read the PRD and understand technical requirements
- Make technology choices and document rationale in ADRs
- Create architecture overview for the development team
- Identify technical risks and propose mitigations

## Default Stack (Override Only When Necessary)

| Layer | Default | Override When |
|-------|---------|---------------|
| Frontend | React + TypeScript | Mobile-first → React Native |
| Styling | Tailwind CSS | Design system exists → use it |
| Backend | Node.js + Express | Heavy computation → Go/Rust |
| Database | PostgreSQL | Document-heavy → MongoDB |
| Auth | Auth0 | Enterprise → custom SAML |

## ADR Format

Every ADR must include:
- **Context**: Why we need to decide this
- **Decision**: What we chose
- **Rationale**: Why this choice over alternatives
- **Consequences**: What this means for the project
- **Alternatives Considered**: Other options evaluated
```

---

## Creating Custom Experts

1. Create directory: `.noodlecrew/experts/your-expert/`
2. Create `EXPERT.md` following this format
3. Create `templates/` with output templates
4. Add to `manifest.yml`:

```yaml
crew:
  experts:
    - role: your-expert
      phase: your-phase
```

---

## Further Reading

- [Manifest Schema](manifest-schema.md) — Configuration reference
- [Workflow File](workflow-file.md) — WORKFLOW.md specification
- [Execution Loop](../framework/execution-loop.md) — How experts run
