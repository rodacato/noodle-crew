---
layout: default
title: NoodleCrew
description: Your AI product team that works while you sleep
nav_order: 1
---

<p align="center">
  <img src="https://img.shields.io/badge/status-ALPHA-orange?style=for-the-badge" alt="Alpha Status">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge" alt="MIT License">
</p>

# NoodleCrew

> **Your AI product team that works while you sleep**

Transform your idea into a documented prototype — without the context switching, without the endless decisions, without writing documentation "later" (which never comes).

---

## The Problem You Know Too Well

You have an idea. A good one. But between *thinking about it* and *having something to show*, there's a painful gap:

```
Monday:    "I'll sketch out the requirements..."
Tuesday:   "Wait, what database should I use?"
Wednesday: "Let me research authentication options..."
Thursday:  "I should document this decision..."
Friday:    "Where was I? Let me re-read everything..."
```

**Sound familiar?**

- You're the product owner, architect, and developer — all at once
- Every context switch costs you 20 minutes of mental reload
- Documentation is always "I'll do it later"
- By the time you have a prototype, you forgot why you made half the decisions

---

## What If You Could Skip All That?

Write your idea in a markdown file. Walk away. Come back to:

- A **Product Requirements Document** with personas and success metrics
- **Architecture Decision Records** explaining *why* you're using React, PostgreSQL, and JWT
- **Implementation specs** ready for you (or another developer) to execute
- **Full git history** of every decision, every iteration

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

```bash
# 1. Initialize a project
ncrew init my-saas-idea

# 2. Write your idea in IDEA.md
vim IDEA.md

# 3. Let the crew work
ncrew run

# 4. Review the artifacts
ls docs/
```

That's it. The crew handles the rest:

| Phase | Expert | Produces |
|-------|--------|----------|
| **Discovery** | Product Owner | PRD, Vision, Personas |
| **Architecture** | Software Architect | ADRs, Tech Stack, Diagrams |
| **Implementation** | Developer | Specs, CHANGELOG, Code |

---

## Quick Start

<details>
<summary><strong>Option A: Run Without Installing</strong></summary>

```bash
# Using bunx (if you have Bun)
bunx noodlecrew init my-project
bunx noodlecrew run

# Using npx (if you have Node.js)
npx noodlecrew init my-project
npx noodlecrew run
```
</details>

<details>
<summary><strong>Option B: Install Globally</strong></summary>

```bash
# With Bun (faster)
bun install -g noodlecrew

# With npm
npm install -g noodlecrew

# Then use anywhere
ncrew init my-project
ncrew run
```
</details>

<details>
<summary><strong>Option C: Try It Manually (Current)</strong></summary>

```bash
# Clone and explore
git clone https://github.com/rodacato/noodle-crew
cd noodle-crew

# See what a crew execution looks like
./scripts/run-expert.sh product-owner examples/landing-saas --dry-run

# Run an expert manually
./scripts/run-expert.sh product-owner examples/landing-saas
```
</details>

[Full Quickstart Guide →](getting-started/quickstart.md)

---

## Explore the Documentation

### I want to understand...

| Topic | Start Here |
|-------|------------|
| What NoodleCrew is and why it exists | [Philosophy](concepts/philosophy.md) |
| How the execution loop works | [Execution Loop](framework/execution-loop.md) |
| What files the framework uses | [Project Structure](framework/project-structure.md) |

### I want to use...

| Topic | Start Here |
|-------|------------|
| Pre-configured crews for common use cases | [Marketplace](marketplace/index.md) |
| The CLI commands available | [CLI Commands](framework/cli-commands.md) |
| State files (INDEX.md, tasks.md) | [State Files](framework/state-files.md) |

### I want to create...

| Topic | Start Here |
|-------|------------|
| My own expert with custom prompts | [Expert Format](crew-development/expert-format.md) |
| A complete custom crew | [Crew Development](crew-development/overview.md) |
| A new workflow for my team | [Workflow File](crew-development/workflow-file.md) |

---

## Core Principles

1. **Artifacts Before Code** — Documentation and design *before* implementation. Forces intentional thinking.

2. **Vault-Native** — Markdown + Git as source of truth. Human-readable, auditable, portable.

3. **Autonomous but Auditable** — Runs without you, but you can see everything. Every decision documented.

4. **Opinionated Defaults** — The crew decides and documents rationale rather than asking for every detail.

[Deep dive into philosophy →](concepts/philosophy.md)

---

## Example Output

After running the crew, you get:

```
my-project/
├── docs/
│   ├── discovery/
│   │   ├── prd.md              # Product Requirements Document
│   │   ├── vision.md           # Product vision statement
│   │   └── personas.md         # User personas
│   ├── architecture/
│   │   ├── adrs/
│   │   │   ├── 001-frontend.md # Why React + TypeScript
│   │   │   ├── 002-database.md # Why PostgreSQL
│   │   │   └── 003-auth.md     # Why JWT + refresh tokens
│   │   └── architecture.md     # System overview
│   └── implementation/
│       ├── changelog.md        # Version history
│       └── specs/              # Implementation specs
├── IDEA.md                     # Your original idea
├── INDEX.md                    # Current project state
└── .noodlecrew/
    └── logs/                   # Execution logs
```

Every file follows a template. Every decision includes rationale. Full audit trail in git.

---

## Prerequisites

- **Node.js 18+** or **Bun** installed
- **Claude Code CLI** or **Gemini CLI** configured
- **Git** installed

The crew uses your existing AI CLI subscription — no additional API keys needed.

---

## What NoodleCrew is NOT

- **Not a coding assistant** — It generates *product artifacts* (PRD, ADRs, specs), not code completion
- **Not a no-code platform** — It generates specifications that developers implement
- **Not production-grade** — This is an experimental tool for rapid prototyping

---

## Links

- [GitHub Repository](https://github.com/rodacato/noodle-crew)
- [Report Issues](https://github.com/rodacato/noodle-crew/issues)
- [Contributing Guide](https://github.com/rodacato/noodle-crew/blob/master/CONTRIBUTING.md)

---

<p align="center">
  <sub>Part of the <strong>neural-noodle</strong> ecosystem</sub><br>
  <sub>Built by <a href="https://github.com/rodacato">@rodacato</a></sub>
</p>
