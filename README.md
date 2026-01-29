# NoodleCrew

> Your AI product team that works while you sleep

A pet project exploring autonomous product development with AI agents. Don't expect production-grade code — expect rapid prototypes and learning experiments.

Built by [@rodacato](https://github.com/rodacato) as part of the neural-noodle ecosystem.

[Quickstart](#quickstart) | [Documentation](docs/) | [Marketplace](docs/marketplace/)

---

## The Paradigm Shift

**The problem:** Going from idea to validated prototype is slow, inconsistent, and documentation is always an afterthought.

Traditional workflow:
```
You (context switch) → Product thinking
You (context switch) → Architecture decisions
You (context switch) → Implementation
You (context switch) → Documentation (if ever)
```

**The vision:** What if a complete team of AI experts could take your idea and autonomously produce a functional prototype with professional documentation?

NoodleCrew workflow:
```
Your Idea (markdown)
       ↓
   NoodleCrew
       ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│Product Owner │ → │  Architect   │ → │  Developer   │
│ PRD, Vision  │    │ ADRs, Stack  │    │Specs, Code   │
└──────────────┘    └──────────────┘    └──────────────┘
       ↓
Prototype + Complete Documentation
```

Each phase commits to git automatically. Full audit trail. Zero context switching.

---

## How It Works

1. **Write your idea** in markdown (problem, solution, users)
2. **Run the crew** (`ncrew run`)
3. **Experts collaborate** autonomously, asking only for critical decisions
4. **Get artifacts**: PRD, ADRs, implementation specs, prototype

The crew is **opinionated by default** — it makes reasonable decisions using best practices and documents the rationale. You only get involved for truly critical blockers.

---

## Quickstart

### Option 1: Run Without Installing (Recommended)

```bash
# Using bunx (if you have Bun)
bunx noodlecrew init my-saas-idea
bunx noodlecrew run

# Using npx (if you have Node.js)
npx noodlecrew init my-saas-idea
npx noodlecrew run
```

### Option 2: Install Globally

```bash
# With Bun (faster)
bun install -g noodlecrew

# With npm
npm install -g noodlecrew

# Then use anywhere
ncrew init my-saas-idea
ncrew run
```

[Full installation guide →](docs/getting-started/installation.md)

---

## The Crew

NoodleCrew uses specialized AI experts, each with a defined role. Configure which experts to use and optionally assign different LLMs per expert.

### Core Experts

| Expert | Produces | Phase |
|--------|----------|-------|
| **Product Owner** | PRD, Vision, Personas | Discovery |
| **Software Architect** | ADRs, Architecture, Tech Stack | Architecture |
| **Developer** | Implementation Specs, CHANGELOG | Implementation |

### Extended Experts

| Expert | Produces | Phase |
|--------|----------|-------|
| **UX Designer** | Wireframes, User Flows, Design System | Design |
| **QA Engineer** | Test Plan, Test Cases, Quality Gates | Testing |
| **Tech Writer** | Documentation, API Docs, Guides | Documentation |
| **Security Reviewer** | Security ADRs, Threat Model | Review |
| **Performance Reviewer** | Performance ADRs, Benchmarks | Review |
| **Accessibility Reviewer** | A11y ADRs, WCAG Compliance | Review |

[Learn about each expert →](docs/guides/experts.md)

---

## Example Output

```
$ ncrew run

🍜 NoodleCrew - Starting execution...

Phase: Discovery
Expert: Product Owner
Task: Generate PRD from idea-original.md

[14:35:22] Building prompt context...
[14:35:45] ✓ Response received (3,847 tokens)
[14:35:46] ✓ Created: 01-discovery/prd.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Crew Execution Complete!

Artifacts Generated:
  ✓ 01-discovery/prd.md (5.2KB)
  ✓ 01-discovery/personas.md (3.8KB)
  ✓ 04-architecture/adrs/001-frontend.md (4.3KB)
  ✓ 04-architecture/adrs/002-database.md (3.9KB)
  ✓ 05-implementation/CHANGELOG.md (4.9KB)

Total Cost: $12.50
Total Time: 47 minutes
Git Commits: 127
```

[See complete example →](docs/marketplace/catalog.md)

---

## Configuration

All crew configuration lives in `.noodlecrew/`:

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

Example `config.yml`:

```yaml
project:
  name: "my-saas-idea"
  type: "saas"

crew:
  # Default LLM for all experts (uses your CLI subscription)
  default_llm: claude

  # Configure experts - override LLM per expert if needed
  experts:
    - role: product-owner
      # Uses default_llm (claude)

    - role: software-architect
      llm: gemini-2.5-flash    # Fast for architecture decisions

    - role: developer
      llm: claude-opus-4.5     # Best for complex implementation

phases:
  - discovery
  - architecture
  - implementation

validation:
  human_gates:
    - architecture  # Pause for review after architecture phase
```

**Prerequisites:** Claude Code CLI and/or Gemini CLI installed with active subscriptions.

[Full configuration reference →](docs/guides/configuration.md) | [Creating custom crews →](docs/marketplace/creating-crews.md)

---

## Marketplace

Pre-configured crews for common verticals:

| Crew | Description | Install |
|------|-------------|---------|
| `saas-b2b` | Enterprise SaaS (multi-tenant, SSO, compliance) | `ncrew marketplace install saas-b2b` |
| `fintech-app` | Fintech (KYC, AML, payments) | `ncrew marketplace install fintech-app` |
| `consumer-app` | Consumer apps (viral loops, onboarding) | `ncrew marketplace install consumer-app` |

```bash
# Use a marketplace crew
ncrew init my-project --crew saas-b2b
```

[Browse all crews →](docs/marketplace/catalog.md) | [Create your own →](docs/marketplace/creating-crews.md)

---

## Philosophy

NoodleCrew follows these principles:

1. **Artifacts Before Code** — Documentation and design BEFORE implementation. Forces intentional thinking.

2. **Vault-Native** — Markdown files + Git as source of truth. Human-readable, auditable, portable.

3. **Autonomous but Auditable** — Runs without you, but you can see everything. Every decision documented.

4. **Opinionated Defaults** — Best practices built-in. The crew decides and documents rationale rather than asking for every detail.

Inspired by:
- [DLP](https://github.com/edgarjs/dlp) (Edgar) — Agent-first development lifecycle
- [CrewAI](https://github.com/joaomdmoura/crewAI) — Multi-agent orchestration
- [Superpowers](https://github.com/obra/superpowers) — Modular skill system
- [Moltbot](https://github.com/moltbot/moltbot) — Multi-channel AI gateway

[Read more about our philosophy →](docs/concepts/philosophy.md)

---

## Documentation

| Section | Description |
|---------|-------------|
| [Getting Started](docs/getting-started/) | Installation, quickstart, first crew |
| [Concepts](docs/concepts/) | Philosophy, architecture, glossary |
| [Guides](docs/guides/) | Configuration, experts, phases, templates |
| [CLI Reference](docs/cli/) | Command documentation |
| [Marketplace](docs/marketplace/) | Using and creating crews |
| [Reference](docs/reference/) | Technical specifications |

---

## Contributing

This is a pet project, but contributions are welcome!

1. Read the [development status and roadmap](DEVELOPMENT.md)
2. Check [open issues](https://github.com/rodacato/noodle-crew/issues)
3. Fork and submit a PR

[Contributing guide →](CONTRIBUTING.md)

---

## License

MIT — Do what you want, just don't blame me.

---

<p align="center">
  <sub>Part of the neural-noodle ecosystem</sub>
</p>
