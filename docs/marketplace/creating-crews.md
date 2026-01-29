# Creating Custom Crews

> Customize your crew or create one for the marketplace.

---

## Overview

There are two ways to work with custom crews:

1. **Customize your project** — Modify the config, prompts, and templates in your project
2. **Create for marketplace** — Package a crew for others to use

Both use the same structure. The difference is where the files live.

---

## Understanding the Structure

Your crew configuration consists of three parts:

```
my-project/
├── .noodlecrew.yml              # WHO does WHAT (experts, phases, LLMs)
└── .noodlecrew/
    ├── prompts/                 # HOW experts think (system prompts)
    └── templates/               # WHAT gets produced (artifact formats)
```

| Component | Purpose | Example Change |
|-----------|---------|----------------|
| `.noodlecrew.yml` | Experts, phases, LLM assignments | Add security reviewer, change to Gemini |
| `prompts/` | Expert behavior and personality | Make PO focus on enterprise compliance |
| `templates/` | Artifact structure and sections | Add "Compliance" section to PRD |

---

## Option A: Customize Your Project

Start with any crew (default or marketplace), then modify.

### Step 1: Change Configuration

Edit `.noodlecrew.yml`:

```yaml
# Original (default crew)
crew:
  default_llm: claude
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer

# Customized
crew:
  default_llm: gemini-2.5-flash    # Faster iterations
  experts:
    - role: product-owner
    - role: software-architect
      llm: claude                   # Override for architecture
    - role: developer
    - role: security-reviewer       # Added expert
      only: [architecture, review]
```

### Step 2: Customize Prompts

Edit prompts in `.noodlecrew/prompts/`:

```bash
# View current prompt
cat .noodlecrew/prompts/product-owner.md

# Edit to customize
vim .noodlecrew/prompts/product-owner.md
```

Prompt structure:

```markdown
# Product Owner

## Role

You are a Product Owner specialized in [YOUR DOMAIN].

## Responsibilities

- Define product vision and strategy
- Create user personas
- Write PRD with clear scope
- [ADD YOUR SPECIFIC REQUIREMENTS]

## Output Format

[SPECIFY HOW YOU WANT ARTIFACTS]

## Domain Knowledge

[ADD CONTEXT ABOUT YOUR DOMAIN]
```

### Step 3: Customize Templates

Edit templates in `.noodlecrew/templates/`:

```bash
vim .noodlecrew/templates/prd-template.md
```

Add sections relevant to your domain:

```markdown
# PRD: {{project_name}}

## Problem Statement
[What problem are we solving?]

## User Personas
[Who are we building for?]

## Success Metrics
[How do we measure success?]

## Compliance Requirements          <!-- Added for regulated industries -->
[Regulatory constraints]

## Security Considerations          <!-- Added for security-focused teams -->
[Data handling requirements]
```

---

## Option B: Create for Marketplace

Package your customizations for others to use.

### Step 1: Create Crew Directory

```bash
mkdir -p my-crew/{prompts,templates}
```

### Step 2: Create CREW.md (Manifest)

```markdown
---
name: My Custom Crew
version: 1.0.0
author: "@yourusername"
tags: [your, relevant, tags]
default_llm: claude
---

# My Custom Crew

> One-line description of what this crew does.

## What It Does

Describe the use case and what makes this crew special.

## Experts Included

| Expert | LLM Override | Phase Participation |
|--------|--------------|---------------------|
| product-owner | - | discovery |
| software-architect | - | architecture |
| developer | - | implementation |

## Pre-configured Decisions

List any opinionated defaults:
- Database recommendation
- Auth approach
- Deployment targets

## Best For

- Project type A
- Project type B
- Teams that need X

## Usage

\`\`\`bash
ncrew init my-project --crew my-custom-crew
\`\`\`
```

### Step 3: Add Configuration

Create `.noodlecrew.yml` with your settings:

```yaml
project:
  name: "{{project_name}}"
  type: "your-type"

crew:
  default_llm: claude

  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
    # Add your custom experts

phases:
  - discovery
  - architecture
  - implementation
  # Your phase order

validation:
  human_gates:
    - architecture
```

### Step 4: Add Prompts

Create prompt files in `prompts/`:

```
my-crew/
└── prompts/
    ├── product-owner.md
    ├── software-architect.md
    └── developer.md
```

### Step 5: Add Templates

Create template files in `templates/`:

```
my-crew/
└── templates/
    ├── prd-template.md
    ├── adr-template.md
    └── changelog-template.md
```

### Final Structure

```
my-crew/
├── CREW.md                      # Required: manifest
├── .noodlecrew.yml              # Required: configuration
├── prompts/
│   ├── product-owner.md
│   ├── software-architect.md
│   └── developer.md
└── templates/
    ├── prd-template.md
    ├── adr-template.md
    └── changelog-template.md
```

---

## Prompt Writing Guide

### Structure

Every expert prompt should include:

1. **Role definition** — Who is this expert?
2. **Responsibilities** — What do they do?
3. **Context awareness** — What files do they read?
4. **Output format** — What do they produce?
5. **Domain knowledge** — Specialized expertise

### Example: Security-Focused Product Owner

```markdown
# Product Owner (Security-Focused)

## Role

You are a Product Owner with expertise in security-sensitive products.
You understand compliance requirements (SOC2, GDPR, HIPAA) and
incorporate them into product requirements from day one.

## Responsibilities

- Validate idea viability with security constraints in mind
- Define problem statement with threat context
- Create user personas including potential attackers
- Establish success metrics including security KPIs
- Define MVP scope with security as a core feature

## Context

You will receive:
- `00-input/idea-original.md` — Raw product idea

You produce:
- `01-discovery/prd.md` — PRD with security requirements
- `01-discovery/personas.md` — Including threat actors
- `01-discovery/threat-context.md` — Initial threat landscape

## Output Format

Use the templates in `.noodlecrew/templates/`.
Include a "Security Considerations" section in every artifact.

## Domain Knowledge

- OWASP Top 10
- Data classification (PII, PHI, financial)
- Regulatory frameworks relevant to the project
- Privacy by design principles
```

### Tips for Good Prompts

1. **Be specific** — "Enterprise SaaS" not "software"
2. **Include examples** — Show the output format you want
3. **Add constraints** — "Never recommend vendor lock-in"
4. **Reference templates** — Point to your template files
5. **Keep focused** — One expert, one responsibility

---

## Template Writing Guide

### Variables

Templates support variable substitution:

| Variable | Description |
|----------|-------------|
| `{{project_name}}` | From `.noodlecrew.yml` |
| `{{date}}` | Current date |
| `{{expert}}` | Expert generating the artifact |
| `{{phase}}` | Current phase |

### Example: PRD Template

```markdown
# PRD: {{project_name}}

> Generated by {{expert}} on {{date}}

## Document Info

| Field | Value |
|-------|-------|
| Status | Draft |
| Author | {{expert}} |
| Phase | {{phase}} |

---

## Problem Statement

### The Problem
[Describe the problem users face]

### Impact
[Quantify the impact: time wasted, money lost, frustration]

### Current Alternatives
[How do users solve this today?]

---

## Solution Overview

### Core Value Proposition
[One sentence: what do we offer?]

### Key Features
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

---

## User Personas

### Primary Persona
[Detailed persona description]

### Secondary Persona
[If applicable]

---

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| [Metric 1] | [Target] | [How to measure] |

---

## MVP Scope

### In Scope
- [Feature/requirement]

### Out of Scope (Future)
- [Feature/requirement]

---

## Open Questions

- [ ] [Question that needs resolution]
```

---

## Publishing to Marketplace

Once your crew is ready:

1. **Test it** — Run `ncrew init test-project --crew ./my-crew` locally
2. **Document it** — Ensure CREW.md is complete and helpful
3. **Submit** — Open a PR to the NoodleCrew marketplace repository

Requirements for marketplace submission:
- Complete CREW.md with all sections
- Working `.noodlecrew.yml`
- All referenced prompts and templates included
- At least one example project demonstrating output

---

## Examples

### Minimal Custom Crew

Just change the LLM:

```yaml
# .noodlecrew.yml
crew:
  default_llm: gemini-2.5-flash
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
```

### Fintech Crew

Add security and performance reviewers:

```yaml
crew:
  default_llm: claude
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
      llm: claude-opus-4.5
    - role: security-reviewer
      llm: claude-opus-4.5
      only: [architecture, review]
    - role: performance-reviewer
      only: [architecture, review]

phases:
  - discovery
  - architecture
  - implementation
  - testing
  - review

validation:
  human_gates:
    - architecture
    - review
```

### Fast Prototype Crew

Optimize for speed:

```yaml
crew:
  default_llm: gemini-2.5-flash
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer

phases:
  - discovery
  - architecture
  - implementation
  # No testing or review phases
```

---

*See also: [Using Crews](using-crews.md) | [Experts Guide](../guides/experts.md) | [Configuration](../guides/configuration.md)*
