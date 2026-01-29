# Quickstart

> Run your first NoodleCrew project in 5 minutes.

---

## Prerequisites

- **Node.js 18+** or **Bun** installed
- Claude API access (or Claude Code CLI installed)
- Git installed
- A text editor

---

## Step 1: Install NoodleCrew

Choose your preferred method:

### Option A: Run Without Installing (Recommended)

```bash
# Using bunx (if you have Bun)
bunx noodlecrew init my-first-project

# Using npx (if you have Node.js)
npx noodlecrew init my-first-project
```

### Option B: Install Globally

```bash
# With Bun (faster)
bun install -g noodlecrew

# With npm
npm install -g noodlecrew
```

---

## Step 2: Initialize a Project

Create a new crew project:

```bash
ncrew init my-first-project
cd my-first-project
```

This creates:
```
my-first-project/
├── .noodlecrew/              # Crew configuration
│   ├── manifest.yml          # Crew manifest
│   ├── CREW.md               # Crew overview
│   ├── experts/              # Expert definitions
│   └── phases/               # Phase definitions
├── IDEA.md                   # Your idea goes here!
├── INDEX.md                  # Project state
├── TODO.md                   # Task tracking
├── docs/                     # Generated documentation
│   ├── discovery/            # PRD will be generated here
│   ├── architecture/         # ADRs will be generated here
│   └── implementation/       # Specs will be generated here
└── questions/                # Blockers requiring your input
```

---

## Step 3: Write Your Idea

Edit `IDEA.md` in the project root:

```markdown
# My SaaS Idea

## Problem

Teams waste hours coordinating note-taking during meetings.
Notes are scattered, action items get lost, follow-ups slip.

## Solution

A collaborative notes app that:
- Real-time co-editing during meetings
- AI-powered summarization after meetings
- Automatic action item extraction and assignment

## Users

- Product teams (5-20 people)
- Remote-first companies
- Teams with 5+ meetings per week

## MVP Scope

- Real-time collaborative editing
- Meeting summarization
- Action item extraction
- Simple team management
```

That's it. The crew will figure out the rest.

---

## Step 4: Run the Crew

```bash
ncrew run
```

You'll see output like:

```
🍜 NoodleCrew - Starting execution...

Phase: Discovery
Expert: Product Owner
Task: Generate PRD from IDEA.md

[14:35:22] Building prompt context...
[14:35:45] ✓ Response received (3,847 tokens)
[14:35:46] ✓ Created: docs/discovery/prd.md
[14:35:47] ✓ Git commit: "feat(discovery): generate PRD"

Phase: Discovery
Expert: Product Owner
Task: Define user personas

[14:36:12] ✓ Created: docs/discovery/personas.md
...
```

The crew will:
1. **Discovery Phase** — Product Owner generates PRD, vision, personas
2. **Architecture Phase** — Architect generates ADRs for key decisions
3. **Implementation Phase** — Developer generates specs and CHANGELOG

---

## Step 5: Review the Output

When complete, you'll have:

```
my-first-project/
├── docs/
│   ├── discovery/
│   │   ├── prd.md                # Product Requirements Document
│   │   ├── vision.md             # Product vision statement
│   │   └── personas.md           # User personas
│   ├── architecture/
│   │   ├── adrs/
│   │   │   ├── 001-frontend.md   # Frontend stack decision
│   │   │   ├── 002-database.md   # Database choice
│   │   │   └── 003-auth.md       # Authentication strategy
│   │   └── architecture.md       # Architecture overview
│   └── implementation/
│       ├── changelog.md          # Version history
│       └── implementation-notes.md
└── .noodlecrew/
    └── logs/                     # Execution logs
        └── 2026-01-28-143522.log
```

Each file follows a template and includes rationale for decisions.

---

## Step 6: Check Git History

Every iteration is committed:

```bash
git log --oneline
```

```
a1b2c3d feat(implementation): finalize CHANGELOG
d4e5f6g feat(implementation): create implementation notes
h7i8j9k feat(architecture): ADR-003 authentication strategy
l0m1n2o feat(architecture): ADR-002 database choice
p3q4r5s feat(architecture): ADR-001 frontend stack
t6u7v8w feat(discovery): define user personas
x9y0z1a feat(discovery): generate PRD
```

Full audit trail. You can see exactly what the crew did.

---

## What Just Happened?

1. **Product Owner** read your idea and generated a proper PRD with problem statement, success metrics, scope definition, and user personas.

2. **Software Architect** read the PRD and made technical decisions: what frontend framework, what database, what authentication strategy. Each decision is documented in an ADR (Architecture Decision Record) with rationale and alternatives considered.

3. **Developer** read the architecture and generated implementation specifications: what to build, in what order, with what tools.

The crew made reasonable decisions based on best practices. If you disagree, the rationale is documented — you can understand *why* and change it.

---

## Next Steps

**Want to customize the crew?**
- Edit `.noodlecrew/manifest.yml` to change experts, LLM settings, or phases
- See [Configuration Guide](../guides/index.md)

**Want to understand the decisions?**
- Read the generated ADRs in `docs/architecture/adrs/`
- See [Understanding Phases](../guides/phases.md)

**Want to use a pre-configured crew?**
- Browse the [Marketplace](../marketplace/catalog.md)
- Install with `ncrew init my-project --crew saas-b2b`

**Want a complete walkthrough?**
- See [Your First Crew](your-first-crew.md) for detailed explanations

---

## Troubleshooting

**Crew asks too many questions?**

The crew should be autonomous. If it's asking for every detail, your idea might be too vague. Add more context to `IDEA.md`.

**Crew made a bad decision?**

Review the ADR. The rationale is documented. You can:
1. Edit the ADR and re-run from that phase
2. Add constraints to your idea
3. Use a marketplace crew with different defaults

**Crew got stuck in a loop?**

Check the iteration limit in `.noodlecrew/manifest.yml`. Default is 100. If the crew isn't making progress, review logs with `ncrew logs`.

---

## Summary

```bash
# Run without installing (recommended)
bunx noodlecrew init my-project
cd my-project

# Or install globally first
bun install -g noodlecrew
ncrew init my-project
cd my-project

# Write your idea
vim IDEA.md

# Run the crew
bunx noodlecrew run   # or: ncrew run (if installed globally)

# Review output
cat docs/discovery/prd.md
cat docs/architecture/adrs/001-frontend.md
```

That's it. Idea to prototype artifacts in minutes, not weeks.
