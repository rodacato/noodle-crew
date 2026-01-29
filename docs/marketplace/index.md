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
│  │ Edit config  │            │ ncrew run    │                       │
│  │ Edit prompts │     →      │              │                       │
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

```
saas-b2b/
├── CREW.md                      # Description and metadata
├── .noodlecrew.yml              # Pre-configured settings
├── prompts/                     # Expert prompts
│   ├── product-owner.md
│   ├── software-architect.md
│   ├── developer.md
│   └── security-reviewer.md     # Additional experts
└── templates/                   # Artifact templates
    ├── prd-template.md
    ├── adr-template.md
    └── changelog-template.md
```

When installed, this becomes your project's configuration:

```
my-project/
├── .noodlecrew.yml              # Your crew config
└── .noodlecrew/
    ├── prompts/                 # Your prompts (editable)
    └── templates/               # Your templates (editable)
```

---

## Customization

Marketplace crews are starting points, not constraints. After installing:

1. **Change LLM** — Edit `default_llm` in `.noodlecrew.yml`
2. **Add/remove experts** — Edit `experts` list in config
3. **Modify prompts** — Edit files in `.noodlecrew/prompts/`
4. **Adjust templates** — Edit files in `.noodlecrew/templates/`

See [Creating Crews](creating-crews.md) for detailed customization guide.

---

## Next Steps

- [Using Crews](using-crews.md) — Install and use marketplace crews
- [Creating Crews](creating-crews.md) — Customize or create your own
- [Catalog](catalog.md) — Browse all available crews

---

*See also: [Configuration Guide](../guides/configuration.md) | [Experts Guide](../guides/experts.md)*
