<p align="center">
  <img src="https://img.shields.io/badge/status-ALPHA-orange?style=for-the-badge" alt="Alpha Status">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge" alt="MIT License">
</p>

# NoodleCrew

> **Your AI product team that works while you sleep**

Transform your idea into a documented prototype — without the context switching, without the endless decisions, without writing documentation "later" (which never comes).

[Documentation](https://rodacato.github.io/noodle-crew) | [Quickstart](#quickstart) | [Marketplace](#marketplace)

---

## The Problem

Going from idea to validated prototype is painful:

```
Monday:    "I'll sketch out the requirements..."
Tuesday:   "Wait, what database should I use?"
Wednesday: "Let me research authentication options..."
Thursday:  "I should document this decision..."
Friday:    "Where was I? Let me re-read everything..."
```

- You're the product owner, architect, and developer — all at once
- Every context switch costs you 20 minutes of mental reload
- Documentation is always "I'll do it later"
- By the time you have a prototype, you forgot why you made half the decisions

---

## The Solution

Write your idea in markdown. Walk away. Come back to a complete set of product artifacts:

```
Your Idea (markdown)
       ↓
   NoodleCrew
       ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│Product Owner │ → │  Architect   │ → │  Developer   │
│ PRD, Vision  │    │ ADRs, Stack  │    │ Specs, Code  │
└──────────────┘    └──────────────┘    └──────────────┘
       ↓
Prototype + Complete Documentation
```

Each expert works autonomously, hands off context to the next, and commits every decision to git. **Zero supervision required.**

---

## How It Works

1. **Write your idea** in markdown (problem, solution, users)
2. **Run the crew** (`ncrew run`)
3. **Experts collaborate** autonomously, asking only for critical decisions
4. **Get artifacts**: PRD, ADRs, implementation specs, prototype

The crew is **opinionated by default** — it makes reasonable decisions using best practices and documents the rationale. You only get involved for truly critical blockers.

---

## Architecture

### Framework vs Crew

NoodleCrew separates **what runs** from **how it runs**:

```
┌─────────────────────────────────────────────────────────────┐
│                     FRAMEWORK (Runtime)                      │
├─────────────────────────────────────────────────────────────┤
│  • Directory structure (.noodlecrew/, docs/, questions/)    │
│  • State file schemas (INDEX.md, tasks.md)                  │
│  • Execution loop (build prompt → launch LLM → commit)      │
│  • Termination protocol (CREW_COMPLETE file)                │
│  • CLI commands (init, run, status, logs)                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      CREW (Configuration)                    │
├─────────────────────────────────────────────────────────────┤
│  • Expert definitions (EXPERT.md prompts)                   │
│  • Phase sequence (discovery → architecture → impl)         │
│  • Templates (PRD format, ADR format, etc.)                 │
│  • LLM assignments per expert                               │
└─────────────────────────────────────────────────────────────┘
```

The framework is fixed. Crews are swappable. Install a marketplace crew or create your own.

### The Execution Loop

Each expert runs in an autonomous loop until their phase is complete:

```
┌──────────────────────────────────────────────────────────────┐
│                    EXPERT EXECUTION LOOP                      │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   1. Read state files (INDEX.md, tasks.md)                   │
│   2. Determine next task from tasks.md                       │
│   3. Execute task (create files, update state)               │
│   4. Git commit with conventional message                    │
│   5. Check termination conditions                            │
│          │                                                   │
│          ├── All tasks done? → Create CREW_COMPLETE          │
│          ├── Blocked? → Create question in questions/        │
│          └── More work? → Loop back to step 1                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**Key insight:** The orchestrator doesn't parse LLM output. Experts manage their own files — they read `tasks.md`, create artifacts, and update state. The orchestrator just launches experts and checks for termination.

### State Files

All state lives in markdown files:

| File | Purpose | Updated By |
|------|---------|------------|
| `INDEX.md` | Project state, current phase, progress summary | Expert |
| `tasks.md` | Task list with status (pending/in_progress/done) | Expert |
| `questions/*.md` | Blockers requiring human input | Expert |
| `CREW_COMPLETE` | Empty file signaling completion | Expert |

No database. No API calls between experts. Just files that the next expert reads.

### Expert Autonomy

Each expert is a self-contained AI agent with:

```
.noodlecrew/experts/product-owner/
├── EXPERT.md           # System prompt: role, constraints, outputs
└── templates/
    ├── prd.md          # PRD template with sections to fill
    └── personas.md     # Persona template
```

The `EXPERT.md` defines:
- **Role**: "You are a Product Owner..."
- **Context**: What files to read (IDEA.md, INDEX.md)
- **Outputs**: What files to create (docs/discovery/prd.md)
- **Constraints**: Formatting rules, decision authority
- **Termination**: When to mark phase complete

Experts don't call each other. They communicate through artifacts — the architect reads the PRD, the developer reads the ADRs.

### LLM Integration

NoodleCrew wraps existing AI CLIs:

```bash
# Under the hood, ncrew run executes:
claude -p "$(cat prompt.txt)" --allowedTools Edit,Write,Bash

# Or for Gemini:
gemini --yolo < prompt.txt
```

No API keys to configure. Use your existing Claude Code or Gemini CLI subscription.

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

### Option 3: Try It Manually

```bash
# Clone and explore
git clone https://github.com/rodacato/noodle-crew
cd noodle-crew

# See what a crew execution looks like
./scripts/run-expert.sh product-owner examples/landing-saas --dry-run

# Run an expert manually
./scripts/run-expert.sh product-owner examples/landing-saas
```

[Full quickstart guide →](https://rodacato.github.io/noodle-crew/getting-started/quickstart.html)

---

## The Crew

NoodleCrew uses specialized AI experts, each with a defined role:

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

Configure which experts to use and optionally assign different LLMs per expert.

---

## Example Output

```
$ ncrew run

🍜 NoodleCrew - Starting execution...

Phase: Discovery
Expert: Product Owner
Task: Generate PRD from IDEA.md

[14:35:22] Building prompt context...
[14:35:45] ✓ Response received (3,847 tokens)
[14:35:46] ✓ Created: docs/discovery/prd.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Crew Execution Complete!

Artifacts Generated:
  ✓ docs/discovery/prd.md (5.2KB)
  ✓ docs/discovery/personas.md (3.8KB)
  ✓ docs/architecture/adrs/001-frontend.md (4.3KB)
  ✓ docs/architecture/adrs/002-database.md (3.9KB)
  ✓ docs/implementation/changelog.md (4.9KB)

Git Commits: 127
```

---

## Configuration

All crew configuration lives in `.noodlecrew/`:

```
.noodlecrew/
├── manifest.yml              # Crew manifest
├── CREW.md                   # Crew overview and metadata
├── experts/                  # Expert definitions
│   ├── product-owner/
│   │   ├── EXPERT.md         # How this expert thinks
│   │   └── templates/        # What this expert produces
│   ├── software-architect/
│   └── developer/
└── phases/                   # Phase definitions
    ├── discovery/PHASE.md
    ├── architecture/PHASE.md
    └── implementation/PHASE.md
```

Example `manifest.yml`:

```yaml
project:
  name: "my-saas-idea"
  type: "saas"

crew:
  default_llm: claude

  experts:
    - role: product-owner
    - role: software-architect
      llm: gemini-2.5-flash    # Fast for architecture
    - role: developer
      llm: claude-opus-4.5     # Best for implementation

phases:
  - discovery
  - architecture
  - implementation

validation:
  human_gates:
    - architecture  # Pause for review after architecture
```

[Full configuration reference →](https://rodacato.github.io/noodle-crew/crew-development/manifest-schema.html)

---

## Marketplace

Pre-configured crews for common verticals:

| Crew | Description |
|------|-------------|
| `saas-b2b` | Enterprise SaaS (multi-tenant, SSO, compliance) |
| `fintech-app` | Fintech (KYC, AML, payments) |
| `consumer-app` | Consumer apps (viral loops, onboarding) |

```bash
ncrew init my-project --crew saas-b2b
```

[Browse all crews →](https://rodacato.github.io/noodle-crew/marketplace/)

---

## Philosophy

1. **Artifacts Before Code** — Documentation and design BEFORE implementation. Forces intentional thinking.

2. **Vault-Native** — Markdown files + Git as source of truth. Human-readable, auditable, portable.

3. **Autonomous but Auditable** — Runs without you, but you can see everything. Every decision documented.

4. **Opinionated Defaults** — Best practices built-in. The crew decides and documents rationale rather than asking for every detail.

[Read more about our philosophy →](https://rodacato.github.io/noodle-crew/concepts/philosophy.html)

---

## Prerequisites

- **Node.js 18+** or **Bun** installed
- **Claude Code CLI** or **Gemini CLI** configured
- **Git** installed

The crew uses your existing AI CLI subscription — no additional API keys needed.

---

## Documentation

| Section | Description |
|---------|-------------|
| [Getting Started](https://rodacato.github.io/noodle-crew/getting-started/quickstart.html) | Quickstart tutorial |
| [Concepts](https://rodacato.github.io/noodle-crew/concepts/philosophy.html) | Philosophy and principles |
| [Framework](https://rodacato.github.io/noodle-crew/framework/overview.html) | How the runtime works |
| [Crew Development](https://rodacato.github.io/noodle-crew/crew-development/overview.html) | Create custom crews |
| [Marketplace](https://rodacato.github.io/noodle-crew/marketplace/) | Pre-configured crews |

---

## Contributing

Contributions are welcome!

1. Check [open issues](https://github.com/rodacato/noodle-crew/issues)
2. Read the [development notes](DEVELOPMENT.md)
3. Fork and submit a PR

---

## License

MIT — Do what you want, just don't blame me.

---

<p align="center">
  <sub>Part of the <strong>neural-noodle</strong> ecosystem</sub><br>
  <sub>Built by <a href="https://github.com/rodacato">@rodacato</a></sub>
</p>
