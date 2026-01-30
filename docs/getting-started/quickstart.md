# Quickstart

> Get from idea to documented prototype in minutes.

---

## TL;DR

```bash
ncrew init my-project    # Create project
vim IDEA.md              # Write your idea
ncrew run                # Let the crew work
ls docs/                 # Review artifacts
```

---

## Prerequisites

- **Node.js 18+** or **Bun** installed
- **Claude Code CLI** or **Gemini CLI** configured
- **Git** installed

---

## Step 1: Install NoodleCrew

### Option A: Run Without Installing (Recommended)

```bash
# Using bunx (if you have Bun)
bunx noodlecrew init my-project

# Using npx (if you have Node.js)
npx noodlecrew init my-project
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

```bash
ncrew init my-project
cd my-project
```

This creates:

```
my-project/
├── .noodlecrew/              # Crew configuration
│   ├── manifest.yml          # Settings
│   ├── experts/              # Expert definitions
│   └── phases/               # Phase definitions
├── IDEA.md                   # Your idea goes here!
├── INDEX.md                  # Project state
├── docs/                     # Generated artifacts
└── questions/                # Blockers (if any)
```

---

## Step 3: Write Your Idea

Edit `IDEA.md`:

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

You'll see:

```
🍜 NoodleCrew - Starting execution...

Phase: Discovery
Expert: Product Owner
Task: Generate PRD from IDEA.md

[14:35:22] Building prompt context...
[14:35:45] ✓ Response received (3,847 tokens)
[14:35:46] ✓ Created: docs/discovery/prd.md
[14:35:47] ✓ Git commit: "feat(discovery): generate PRD"

...

🎉 Crew Execution Complete!
```

---

## Step 5: Review the Output

When complete:

```
my-project/
├── docs/
│   ├── discovery/
│   │   ├── prd.md                # Product Requirements
│   │   ├── vision.md             # Product vision
│   │   └── personas.md           # User personas
│   ├── architecture/
│   │   ├── adrs/
│   │   │   ├── 001-frontend.md   # Why React + TypeScript
│   │   │   ├── 002-database.md   # Why PostgreSQL
│   │   │   └── 003-auth.md       # Why Auth0
│   │   └── architecture.md       # System overview
│   └── implementation/
│       ├── changelog.md          # Version history
│       └── implementation-notes.md
└── .noodlecrew/
    └── logs/                     # Execution logs
```

Each file includes rationale for decisions.

---

## Step 6: Check Git History

Every iteration is committed:

```bash
git log --oneline
```

```
a1b2c3d feat(implementation): finalize CHANGELOG
d4e5f6g feat(architecture): ADR-003 authentication
h7i8j9k feat(architecture): ADR-002 database
l0m1n2o feat(architecture): ADR-001 frontend
p3q4r5s feat(discovery): define user personas
t6u7v8w feat(discovery): generate PRD
```

Full audit trail.

---

## What Just Happened?

| Phase | Expert | Did |
|-------|--------|-----|
| Discovery | Product Owner | Read your idea, generated PRD, personas, vision |
| Architecture | Software Architect | Made tech decisions, documented in ADRs |
| Implementation | Developer | Generated specs and CHANGELOG |

The crew made reasonable decisions based on best practices. If you disagree, the rationale is documented — you can understand *why* and change it.

---

## Next Steps

| I want to... | Do this |
|--------------|---------|
| Customize the crew | Edit `.noodlecrew/manifest.yml` |
| Use a pre-configured crew | `ncrew init my-project --crew saas-b2b` |
| Understand the decisions | Read ADRs in `docs/architecture/adrs/` |
| Learn how it works | [Framework Overview](../framework/overview.md) |

---

## Troubleshooting

**Crew asks too many questions?**

Your idea might be too vague. Add more context to `IDEA.md`.

**Crew made a bad decision?**

Review the ADR. You can edit and re-run from that phase.

**Crew got stuck?**

Check logs with `ncrew logs`. Review iteration limit in manifest.yml.

---

## Try It Manually (Current)

Before the CLI is published, try manually:

```bash
# Clone the repo
git clone https://github.com/rodacato/noodle-crew
cd noodle-crew

# See what would be sent
./scripts/run-expert.sh product-owner examples/landing-saas --dry-run

# Run an expert
./scripts/run-expert.sh product-owner examples/landing-saas
```

---

## Summary

```bash
ncrew init my-project
cd my-project
vim IDEA.md
ncrew run
ls docs/
```

Idea to prototype artifacts. Zero context switching.
