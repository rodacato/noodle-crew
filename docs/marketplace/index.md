# Marketplace

> Pre-configured crews for common project types.

---

## What is the Marketplace?

The NoodleCrew Marketplace is a collection of pre-configured crews optimized for specific project types. Instead of configuring from scratch, start with a crew that has:

- **Curated experts** for your vertical
- **Optimized LLM assignments**
- **Domain-specific prompts**
- **Specialized templates**

When you install a marketplace crew, it's **copied to your project** — you own it completely and can customize everything.

---

## Quick Start

```bash
# Initialize with a marketplace crew
ncrew init my-project --crew saas-b2b

# Or install into existing project
cd my-project
ncrew marketplace install saas-b2b

# Write your idea and run
vim IDEA.md
ncrew run
```

---

## Available Crews

| Crew | Best For | Experts |
|------|----------|---------|
| **default** | General projects | PO, Architect, Developer |
| **saas-b2b** | Enterprise SaaS, multi-tenant | + Security Reviewer |
| **fintech-app** | Fintech, payments, compliance | + Security, Performance |
| **consumer-app** | Consumer apps, growth focus | + UX Designer |
| **api-service** | API-first backends | + Tech Writer |

---

## What's in a Crew?

```text
saas-b2b/
├── CREW.md                       # Crew overview
├── PHASES.md                     # Phase flow
├── manifest.yml                    # Pre-configured settings
├── experts/                      # Expert definitions
│   ├── product-owner/
│   │   ├── EXPERT.md
│   │   └── templates/
│   │       └── prd.md
│   └── security-reviewer/        # Additional expert
│       ├── EXPERT.md
│       └── templates/
└── phases/
    ├── discovery/PHASE.md
    └── architecture/PHASE.md
```

When installed, your project becomes:

```text
my-project/
├── IDEA.md                       # Write your idea here!
├── INDEX.md                      # Project state
├── TODO.md                       # Task tracking
├── docs/                         # Generated output
│   ├── discovery/
│   ├── architecture/
│   └── implementation/
├── questions/                    # Blockers needing input
└── .noodlecrew/                  # Crew configuration
    ├── manifest.yml
    ├── experts/
    ├── phases/
    └── logs/
```

---

## Customizing After Install

Marketplace crews are starting points. Customize freely:

### Change LLM

```yaml
# .noodlecrew/manifest.yml
crew:
  default_llm: gemini-2.5-flash
```

### Add an Expert

```yaml
crew:
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
    - role: qa-engineer           # Added
      only: [testing, review]
```

Then create the expert:

```bash
mkdir -p .noodlecrew/experts/qa-engineer/templates
vim .noodlecrew/experts/qa-engineer/EXPERT.md
```

### Modify Expert Prompts

```bash
vim .noodlecrew/experts/product-owner/EXPERT.md
```

### Change Templates

```bash
vim .noodlecrew/experts/product-owner/templates/prd.md
```

---

## Creating Your Own Crew

### Option A: Customize Your Project

1. Start with any crew (default or marketplace)
2. Edit `.noodlecrew/manifest.yml`
3. Edit `experts/*/EXPERT.md`
4. Edit `experts/*/templates/*`

### Option B: Create for Marketplace

Create a crew package:

```bash
mkdir -p my-crew/experts/product-owner/templates
mkdir -p my-crew/phases/discovery
```

Required files:

```text
my-crew/
├── CREW.md                       # Required: manifest
├── PHASES.md                     # Required: flow overview
├── manifest.yml                    # Required: configuration
├── experts/
│   └── product-owner/
│       ├── EXPERT.md             # Required per expert
│       └── templates/
│           └── prd.md
└── phases/
    └── discovery/PHASE.md        # Required per phase
```

### CREW.md Format

```markdown
---
name: My Custom Crew
version: 1.0.0
author: "@yourusername"
tags: [your, tags]
---

# My Custom Crew

> One-line description.

## What It Does
[Description]

## Experts Included
| Expert | LLM Override | Phases |
|--------|--------------|--------|
| product-owner | - | discovery |

## Best For
- Project type A
- Project type B

## Usage
\`\`\`bash
ncrew init my-project --crew my-custom-crew
\`\`\`
```

### EXPERT.md Format

```markdown
# Product Owner

## Role
You are a Product Owner specialized in [domain].

## Responsibilities
- Define product vision
- Create user personas
- Write PRD with clear scope

## Context
You will receive: `IDEA.md`
You produce: `docs/discovery/prd.md`, `docs/discovery/personas.md`

## Output Format
Use the templates in your `templates/` directory.

## Domain Knowledge
- [Relevant expertise]
```

---

## Publishing to Marketplace

1. **Test it** — `ncrew init test --crew ./my-crew`
2. **Document it** — Complete CREW.md and PHASES.md
3. **Submit** — Open PR to NoodleCrew marketplace repo

Requirements:
- Complete CREW.md with all sections
- Working manifest.yml
- All experts with EXPERT.md and templates/
- All phases with PHASE.md

---

## Troubleshooting

**Crew not found?**
```bash
ncrew marketplace list
```

**LLM not available?**
Install and authenticate the required CLI, or change LLM in `.noodlecrew/manifest.yml`.

**Config conflict?**
Existing config is backed up to `.noodlecrew.backup/`.

---

*See also: [Configuration Guide](../guides/index.md) | [Project Structure](../reference/project-structure.md)*
