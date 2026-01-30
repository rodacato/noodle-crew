# Marketplace

> Pre-configured crews for common project types.

---

## TL;DR

The Marketplace has ready-to-use crews optimized for specific verticals. Install one, customize it, and you're ready to go. When installed, crews are **copied to your project** — you own them completely.

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

```
saas-b2b/
├── CREW.md                       # Crew overview
├── PHASES.md                     # Phase flow
├── manifest.yml                  # Configuration
├── WORKFLOW.md                   # Expert instructions
├── experts/                      # Expert definitions
│   ├── product-owner/
│   │   ├── EXPERT.md
│   │   └── templates/
│   └── security-reviewer/        # Additional expert
│       ├── EXPERT.md
│       └── templates/
└── phases/
    ├── discovery/PHASE.md
    └── architecture/PHASE.md
```

---

## After Installation

Your project becomes:

```
my-project/
├── IDEA.md                       # Write your idea here!
├── INDEX.md                      # Project state
├── .noodlecrew/                  # Crew (your copy)
│   ├── manifest.yml
│   ├── experts/
│   └── phases/
├── docs/                         # Generated output
└── questions/                    # Blockers (if any)
```

---

## Customizing

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

| File | Purpose |
|------|---------|
| `CREW.md` | Metadata and description |
| `manifest.yml` | Configuration |
| `WORKFLOW.md` | Expert instructions |
| `experts/*/EXPERT.md` | Role definitions |
| `phases/*/PHASE.md` | Phase definitions |

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
ncrew init my-project --crew my-custom-crew
```

---

## Publishing to Marketplace

1. **Test it** — `ncrew init test --crew ./my-crew`
2. **Document it** — Complete CREW.md
3. **Submit** — Open PR to NoodleCrew repo

Requirements:
- Complete CREW.md with all sections
- Working manifest.yml
- All experts with EXPERT.md and templates/
- All phases with PHASE.md

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Crew not found | `ncrew marketplace list` |
| LLM not available | Install CLI or change LLM in manifest.yml |
| Config conflict | Existing config backed up to `.noodlecrew.backup/` |

---

## Further Reading

- [Crew Development](../crew-development/overview.md) — Create custom crews
- [Expert Format](../crew-development/expert-format.md) — EXPERT.md specification
- [Framework Overview](../framework/overview.md) — How crews execute
