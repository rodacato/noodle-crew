# NoodleCrew Documentation

> Your AI product team that works while you sleep

Welcome to the NoodleCrew documentation. Choose your path:

## Quick Links

- **New here?** Start with the [Quickstart Guide](getting-started/quickstart.md)
- **Want to understand the system?** Read [Philosophy](concepts/philosophy.md)
- **Ready to configure?** Check [Configuration Guide](guides/configuration.md)
- **Looking for commands?** See [CLI Reference](cli/index.md)

---

## Documentation Sections

### Getting Started

Get up and running with NoodleCrew.

| Document | Description |
| -------- | ----------- |
| [Installation](getting-started/installation.md) | Install via Claude plugin, CLI, or from source |
| [Quickstart](getting-started/quickstart.md) | 5-minute tutorial to run your first crew |
| [Your First Crew](getting-started/your-first-crew.md) | Complete walkthrough with explanations |

### Concepts

Understand the mental model behind NoodleCrew.

| Document | Description |
| -------- | ----------- |
| [Philosophy](concepts/philosophy.md) | Why NoodleCrew exists and its core principles |
| [Architecture](concepts/architecture.md) | System design and component overview |
| [Glossary](concepts/glossary.md) | Key terms: Crew, Expert, Phase, Artifact, Blocker |
| [Vault-Native](concepts/vault-native.md) | Why markdown + git as source of truth |

### Guides

Practical how-to guides for common tasks.

| Document | Description |
| -------- | ----------- |
| [Configuration](guides/configuration.md) | Deep dive into `.noodlecrew.yml` |
| [Experts](guides/experts.md) | Understanding the crew roles |
| [Phases](guides/phases.md) | Discovery, Architecture, Implementation |
| [Blockers & Gates](guides/blockers-and-gates.md) | Human intervention points |
| [Templates](guides/templates.md) | Customizing output templates |
| [Prompts](guides/prompts.md) | Customizing expert prompts |
| [Anti-Patterns](guides/anti-patterns.md) | Common mistakes to avoid |

### CLI Reference

Command documentation for `ncrew` / `noodlecrew`.

| Command | Description |
| ------- | ----------- |
| [init](cli/init.md) | Initialize a new project |
| [run](cli/run.md) | Execute the crew |
| [status](cli/status.md) | Show execution progress |
| [logs](cli/logs.md) | View iteration logs |
| [pause](cli/pause.md) | Pause execution |
| [resume](cli/resume.md) | Resume from pause/blocker |
| [marketplace](cli/marketplace.md) | Manage marketplace crews |

### Marketplace

Pre-configured crews for common verticals.

| Document | Description |
| -------- | ----------- |
| [Overview](marketplace/index.md) | What is the marketplace? |
| [Using Crews](marketplace/using-crews.md) | Installing and using marketplace crews |
| [Creating Crews](marketplace/creating-crews.md) | Customize or create your own crew |
| [Catalog](marketplace/catalog.md) | Available crews |

### Reference

Technical specifications and schemas.

| Document | Description |
| -------- | ----------- |
| [Configuration Schema](reference/configuration-schema.md) | Complete `.noodlecrew.yml` specification |
| [Project Structure](reference/project-structure.md) | Generated folder layout |
| [INDEX.md Format](reference/index-format.md) | Project state file specification |
| [TODO.md Format](reference/todo-format.md) | Task tracking file specification |
| [Blocker Format](reference/blocker-format.md) | Question file specification |

### Advanced

Power user features and integrations.

| Document | Description |
| -------- | ----------- |
| [Multi-LLM](advanced/multi-llm.md) | Claude + Gemini hybrid configuration |
| [Custom Experts](advanced/custom-experts.md) | Creating new expert roles |
| [n8n Integration](advanced/integration-n8n.md) | External automation triggers |
| [Telegram Bot](advanced/telegram-bot.md) | Chat interface (future) |

---

## Project Status

**Current Phase**: Phase 1 - Manual PoC

This documentation describes the intended design. Some features may not be implemented yet.

See [Development Status](../DEVELOPMENT.md) for roadmap and implementation status.

---

## Need Help?

- Read the [Philosophy](concepts/philosophy.md) to understand the design
- Check [Anti-Patterns](guides/anti-patterns.md) for common mistakes
- Open an [issue](https://github.com/rodacato/noodle-crew/issues) for bugs or questions
