# Using Marketplace Crews

> Install and run pre-configured crews from the marketplace.

---

## Quick Start

```bash
# List available crews
ncrew marketplace list

# Initialize new project with a crew
ncrew init my-project --crew saas-b2b

# Or install into existing project
cd my-project
ncrew marketplace install saas-b2b
```

---

## Browsing Crews

### List All Crews

```bash
ncrew marketplace list
```

Output:

```
Available Crews:

  default        General purpose (3 core experts)
  saas-b2b       Enterprise SaaS, multi-tenant
  fintech-app    Fintech, payments, compliance
  consumer-app   Consumer apps, growth focus
  api-service    API-first backends

Use: ncrew init <project> --crew <name>
```

### View Crew Details

```bash
ncrew marketplace info saas-b2b
```

Output:

```
SaaS B2B Crew v1.0.0
by @rodacato

Pre-configured crew for enterprise SaaS products.

Experts:
  - product-owner
  - software-architect
  - developer (claude-opus-4.5)
  - security-reviewer (claude-opus-4.5)

Phases: discovery → architecture → implementation → testing → review

Tags: saas, b2b, enterprise, multi-tenant

Install: ncrew init my-project --crew saas-b2b
```

---

## Installing Crews

### New Project

Start a new project with a marketplace crew:

```bash
ncrew init my-saas --crew saas-b2b
cd my-saas
```

This creates:

```text
my-saas/
├── IDEA.md                           # Write your idea here!
├── INDEX.md                          # Project state
├── TODO.md                           # Task tracking
├── docs/                             # Generated documentation
│   ├── discovery/                    # PRD will go here
│   ├── architecture/                 # ADRs will go here
│   └── implementation/               # Specs will go here
├── questions/                        # Blockers requiring your input
└── .noodlecrew/                      # All crew config here
    ├── config.yml                    # Pre-configured for SaaS B2B
    ├── CREW.md                       # Crew overview
    ├── PHASES.md                     # Phases overview
    ├── experts/                      # Crew experts
    │   └── product-owner/
    │       ├── EXPERT.md
    │       └── templates/
    ├── phases/                       # Crew phases
    │   └── discovery/PHASE.md
    └── logs/                         # Execution logs
```

### Existing Project

Add a crew to an existing project:

```bash
cd my-existing-project
ncrew marketplace install fintech-app
```

This will:

1. Back up existing `.noodlecrew/` directory (if any)
2. Copy the crew's configuration, experts, and phases

---

## Running the Crew

After installation, run the crew:

```bash
# Write your idea first
vim IDEA.md

# Run the crew
ncrew run
```

The crew executes according to its configuration:

- Uses the experts defined in `.noodlecrew/config.yml`
- Follows the phase order specified
- Applies LLM assignments per expert

---

## Changing the LLM

Marketplace crews have default LLM settings. To change:

### Option 1: Edit Configuration

```yaml
# .noodlecrew/config.yml
crew:
  default_llm: gemini-2.5-flash    # Change from claude to gemini
```

### Option 2: Environment Variable

```bash
NOODLECREW_DEFAULT_LLM=gemini-2.5-flash ncrew run
```

### Option 3: Per-Expert Override

```yaml
# .noodlecrew/config.yml
crew:
  default_llm: gemini-2.5-flash    # Fast default
  experts:
    - role: developer
      llm: claude-opus-4.5          # Powerful for code
```

---

## Customizing After Install

Marketplace crews are starting points. Customize freely:

### Add an Expert

```yaml
# .noodlecrew/config.yml
crew:
  experts:
    - role: product-owner
    - role: software-architect
    - role: developer
    - role: qa-engineer           # Added
      only: [testing, review]
```

Then create the expert directory:

```bash
mkdir -p .noodlecrew/experts/qa-engineer/templates
vim .noodlecrew/experts/qa-engineer/EXPERT.md
```

### Remove a Phase

```yaml
# .noodlecrew/config.yml
phases:
  - discovery
  - architecture
  - implementation
  # Removed: testing, review
```

### Modify an Expert Prompt

```bash
vim .noodlecrew/experts/product-owner/EXPERT.md
```

### Change a Template

```bash
vim .noodlecrew/experts/product-owner/templates/prd.md
```

See [Creating Crews](creating-crews.md) for detailed customization guide.

---

## Common Workflows

### Fast Prototype

Use Gemini for speed:

```bash
ncrew init prototype --crew default
cd prototype

# Switch to fast LLM
vim .noodlecrew/config.yml
# Set: default_llm: gemini-2.5-flash

ncrew run
```

### Enterprise Security

Start with SaaS B2B, add performance reviewer:

```bash
ncrew init enterprise-app --crew saas-b2b
cd enterprise-app

# Add performance reviewer
vim .noodlecrew/config.yml
# Add to experts:
#   - role: performance-reviewer
#     only: [architecture, review]

ncrew run
```

### API-First Backend

Use API crew, skip design phase:

```bash
ncrew init my-api --crew api-service
cd my-api

# Already configured for API development
ncrew run
```

---

## Switching Crews

If you want to switch to a different crew:

```bash
# Install new crew (backs up existing config)
ncrew marketplace install fintech-app

# Your old config is saved as:
# .noodlecrew.backup/
```

To restore:

```bash
rm -rf .noodlecrew
mv .noodlecrew.backup .noodlecrew
```

---

## Offline Usage

Crews are copied to your project. Once installed, you don't need marketplace access:

- Project is self-contained
- Works without network
- Can be shared via git
- No external dependencies

---

## Troubleshooting

### Crew Not Found

```
Error: Crew 'my-crew' not found in marketplace
```

Check available crews:

```bash
ncrew marketplace list
```

### LLM Not Available

```
Error: LLM 'claude-opus-4.5' not configured
```

Either:

1. Install and authenticate the required CLI
2. Change to an available LLM in `.noodlecrew/config.yml`

### Config Conflict

```
Warning: .noodlecrew/ already exists
```

Options:

1. Continue (backs up existing to `.noodlecrew.backup/`)
2. Cancel and manually merge

---

## Next Steps

- [Creating Crews](creating-crews.md) — Make your own
- [Catalog](catalog.md) — Browse all crews
- [Configuration](../guides/configuration.md) — Full config reference

---

*See also: [Quickstart](../getting-started/quickstart.md) | [Experts Guide](../guides/experts.md)*
