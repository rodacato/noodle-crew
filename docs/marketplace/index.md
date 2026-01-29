# Marketplace

> Pre-configured crews for common project types.

---

## What is the Marketplace?

The NoodleCrew Marketplace is a collection of pre-configured crews optimized for specific project types. Instead of configuring experts, prompts, and templates from scratch, you can start with a crew that already has:

- **Curated experts** for your vertical (e.g., security reviewer for fintech)
- **Optimized LLM assignments** (fast models where speed matters, powerful where complexity matters)
- **Domain-specific prompts** tailored to industry best practices
- **Specialized templates** for common artifacts in your domain

---

## How It Works

```
┌─────────────────────────────────────────────────────────────────────┐
│                      MARKETPLACE FLOW                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. BROWSE                    2. INSTALL                            │
│  ┌──────────────┐            ┌──────────────┐                       │
│  │ ncrew        │            │ ncrew init   │                       │
│  │ marketplace  │     →      │ --crew X     │                       │
│  │ list         │            │              │                       │
│  └──────────────┘            └──────────────┘                       │
│         │                           │                               │
│         ▼                           ▼                               │
│  Available crews:            Copies to your project:                │
│  - saas-b2b                  ├── .noodlecrew.yml                    │
│  - fintech-app               └── .noodlecrew/                       │
│  - consumer-app                  ├── prompts/                       │
│  - api-service                   └── templates/                     │
│                                                                     │
│  3. CUSTOMIZE (optional)     4. RUN                                 │
│  ┌──────────────┐            ┌──────────────┐                       │
│  │ Edit config  │            │ vim IDEA.md  │                       │
│  │ Edit prompts │     →      │ ncrew run    │                       │
│  │ Edit templates│           │              │                       │
│  └──────────────┘            └──────────────┘                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

When you install a marketplace crew, it's **copied to your project**, not referenced. This means:

- You own the configuration completely
- You can customize everything
- The project is self-contained and portable
- Changes to the marketplace don't affect your project

---

## Quick Start

### Using a Marketplace Crew

```bash
# Initialize with a specific crew
ncrew init my-project --crew saas-b2b

# Or install into existing project
cd my-project
ncrew marketplace install saas-b2b
```

### Using the Default Crew

```bash
# Default crew (3 core experts, Claude)
ncrew init my-project
```

The default crew includes:
- Product Owner
- Software Architect
- Developer

All using Claude as the LLM. [Change the LLM](../guides/configuration.md#llm-assignment) if you prefer Gemini.

---

## Available Crews

| Crew | Best For | Experts |
|------|----------|---------|
| **default** | General projects | PO, Architect, Developer |
| **saas-b2b** | Enterprise SaaS, multi-tenant | + Security Reviewer |
| **fintech-app** | Fintech, payments, compliance | + Security, Performance |
| **consumer-app** | Consumer apps, growth focus | + UX Designer |
| **api-service** | API-first backends | + Tech Writer |

See [Catalog](catalog.md) for detailed descriptions.

---

## What's in a Crew?

A marketplace crew is a package containing:

```text
saas-b2b/
├── CREW.md                           # Crew overview and metadata
├── PHASES.md                         # Phases overview and flow
├── config.yml                        # Pre-configured settings
├── experts/                          # Self-contained expert units
│   ├── product-owner/
│   │   ├── EXPERT.md
│   │   └── templates/
│   │       └── prd.md
│   ├── software-architect/
│   │   ├── EXPERT.md
│   │   └── templates/
│   │       └── adr.md
│   ├── developer/
│   │   ├── EXPERT.md
│   │   └── templates/
│   │       └── changelog.md
│   └── security-reviewer/            # Additional expert
│       ├── EXPERT.md
│       └── templates/
│           └── security-adr.md
└── phases/                           # Phase definitions
    ├── discovery/PHASE.md
    ├── architecture/PHASE.md
    └── implementation/PHASE.md
```

When installed, your project structure becomes:

```text
my-project/
├── IDEA.md                           # Your idea (write here!)
├── INDEX.md                          # Project state
├── TODO.md                           # Task tracking
├── docs/                             # Generated documentation
│   ├── discovery/
│   ├── architecture/
│   └── implementation/
├── questions/                        # Blockers requiring your input
└── .noodlecrew/                      # Crew configuration
    ├── CREW.md                       # Crew overview
    ├── PHASES.md                     # Phases overview
    ├── config.yml                    # Your config (editable)
    ├── experts/                      # Your experts (editable)
    │   └── product-owner/
    │       ├── EXPERT.md
    │       └── templates/
    ├── phases/                       # Your phases (editable)
    └── logs/                         # Execution logs
```

Each expert is self-contained with its prompt and templates.

---

## Customization

Marketplace crews are starting points, not constraints. After installing:

1. **Change LLM** — Edit `default_llm` in `.noodlecrew/config.yml`
2. **Add/remove experts** — Create or remove `experts/name/EXPERT.md`
3. **Modify phases** — Edit `phases/name/PHASE.md`
4. **Adjust templates** — Edit `templates/name/TEMPLATE.md`

See [Creating Crews](creating-crews.md) for detailed customization guide.

---

## Next Steps

- [Using Crews](using-crews.md) — Install and use marketplace crews
- [Creating Crews](creating-crews.md) — Customize or create your own
- [Catalog](catalog.md) — Browse all available crews

---

*See also: [Configuration Guide](../guides/configuration.md) | [Experts Guide](../guides/experts.md)*
