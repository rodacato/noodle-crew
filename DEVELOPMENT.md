# Development Status

> Development notes and roadmap for NoodleCrew. For usage documentation, see [README.md](README.md).

---

## Current Phase

**Phase 1: Manual PoC** (In Progress)

This is a **pet project** in active development. The documentation describes the intended design, not necessarily the current implementation state.

### What Exists Today

- Complete design documentation in `.idea/`
- Documentation structure in `docs/`
- Templates and prompts (in progress)
- Manual execution workflow
- Example project with generated artifacts

### What's Coming

- Automated execution (Phase 2)
- CLI tool (Phase 3)
- Full expert crew (Phase 4)

---

## Roadmap

### Phase 1: Manual PoC (Current)

- [x] Design documentation
- [x] Project structure definition
- [ ] Default crew (prompts + templates)
- [ ] Manual execution validation

### Phase 2: Automated Iterator

- [ ] Shell iterator (Ralph Wiggum Loop)
- [ ] State management (INDEX.md, TODO.md)
- [ ] Git integration (commit per iteration)
- [ ] Blocker detection and handling
- [ ] Safety mechanisms (limits, timeouts)

### Phase 3: CLI Tool

- [ ] Bun/TypeScript CLI package
- [ ] bunx/npx zero-install distribution
- [ ] `ncrew init` command
- [ ] `ncrew run` command
- [ ] `ncrew status` / `ncrew logs` commands
- [ ] Multi-LLM support (Claude, Gemini)
- [ ] Marketplace foundation

### Phase 4: Full Crew

- [ ] Additional experts (9 total)
- [ ] Cross-cutting reviewers (Security, Performance, Accessibility)
- [ ] Marketplace system
- [ ] Community crews

### Phase 5: Multi-Channel (Future)

- [ ] Telegram bot
- [ ] Gateway server
- [ ] Interactive blocker resolution

---

## Design Documents

| Document | Description |
|----------|-------------|
| [.idea/INDEX.md](.idea/INDEX.md) | Master index of design docs |
| [.idea/context.md](.idea/context.md) | Project context and vision |
| [.idea/product-discovery.md](.idea/product-discovery.md) | Product decisions (Q&A) |
| [.idea/brainstorm-template.md](.idea/brainstorm-template.md) | Scope and MVP definition |
| [.idea/branding.md](.idea/branding.md) | Naming, architecture, iterator design |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

```bash
git clone https://github.com/rodacato/noodle-crew
cd noodle-crew
bun install
bun link
```

### Running Tests

```bash
bun test
```

---

*Last updated: 2026-01-28*
