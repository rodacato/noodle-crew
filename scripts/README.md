# NoodleCrew Scripts

> Internal scripts for the NoodleCrew execution engine.

---

## Overview

These scripts implement the execution loop described in [FLOW.md](../FLOW.md). They are **internal tools**, not the public CLI (that comes later as `ncrew`).

```
┌─────────────────────────────────────────────────────────────────────┐
│                        SCRIPT RELATIONSHIPS                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  init-project.sh                                                    │
│       │                                                             │
│       ▼                                                             │
│  iterate.sh ─────────────────────────────────────────────┐          │
│       │                                                  │          │
│       ├──► resolve-context.sh (which expert?)            │          │
│       │                                                  │          │
│       ├──► build-prompt.sh (assemble context)            │          │
│       │                                                  │          │
│       ├──► run-expert.sh (execute LLM)                   │ LOOP     │
│       │                                                  │          │
│       └──► check-termination.sh (continue/pause/stop?)   │          │
│                    │                                     │          │
│                    └─────────────────────────────────────┘          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Scripts

### Project Setup

| Script | Purpose |
|--------|---------|
| `init-project.sh` | Initialize a new project with crew files |

### Execution Loop

| Script | Purpose |
|--------|---------|
| `iterate.sh` | Main execution loop (the iterator) |
| `resolve-context.sh` | Determine which expert to run next |
| `build-prompt.sh` | Assemble expert prompt from context |
| `run-expert.sh` | Execute a single expert turn |
| `check-termination.sh` | Check if loop should stop |

---

## Quick Reference

### Initialize a Project

```bash
./scripts/init-project.sh my-project
./scripts/init-project.sh my-project --crew saas-b2b
```

Creates project structure and copies crew files.

### Run the Loop

```bash
./scripts/iterate.sh examples/landing-saas
./scripts/iterate.sh examples/landing-saas --max-iterations 10
```

Runs experts in a loop until done or limit reached.

### Run Single Expert (Manual Testing)

```bash
./scripts/run-expert.sh product-owner examples/landing-saas
./scripts/run-expert.sh product-owner examples/landing-saas --dry-run
```

Executes one expert turn. Use `--dry-run` to see prompt without executing.

### Check Status

```bash
./scripts/resolve-context.sh examples/landing-saas
./scripts/check-termination.sh examples/landing-saas
```

See current state and termination conditions.

---

## Exit Codes

All scripts follow a consistent exit code scheme:

| Code | Meaning | Action |
|------|---------|--------|
| 0 | Success / Complete | Done |
| 1-9 | Invalid arguments / setup errors | Fix input |
| 10 | Pause: blocker pending | Answer question, resume |
| 11 | Pause: human gate reached | Review, resume |
| 20 | Stop: max iterations | Increase limit or finish manually |
| 21 | Stop: max cost | Increase budget or finish manually |
| 100 | Continue | Next iteration (internal) |

---

## Dependencies

- **bash** (4.0+)
- **claude** CLI - Claude Code installed and authenticated
- **git** - For commits
- **yq** (optional) - For YAML parsing

### LLM Requirements

Scripts support multiple LLMs via the `--llm` flag:

```bash
./scripts/run-expert.sh product-owner examples/landing-saas --llm claude
./scripts/run-expert.sh product-owner examples/landing-saas --llm gemini
```

Default is `claude`. Ensure the respective CLI is installed:
- Claude: `claude --version`
- Gemini: `gemini --version`

---

## Development Status

These scripts are currently **documentation stubs**. They log what they would do but don't execute real logic yet.

To implement:
1. Start with `build-prompt.sh` (pure function, easy to test)
2. Then `check-termination.sh` (file checks)
3. Then `resolve-context.sh` (state parsing)
4. Then `run-expert.sh` (LLM integration)
5. Finally `iterate.sh` (orchestrates everything)

---

## File Locations

Scripts expect this structure:

```
noodle-crew/
├── scripts/           # These scripts
├── marketplace/       # Crew packages
│   └── default/       # Default crew
└── examples/          # Example projects
    └── landing-saas/  # Example project
        ├── IDEA.md
        ├── INDEX.md
        ├── .noodlecrew/
        │   ├── tasks.md
        │   └── ...
        └── docs/
```

---

## See Also

- [FLOW.md](../FLOW.md) - Execution contract
- [docs/framework/](../docs/framework/) - Framework documentation
- [marketplace/default/](../marketplace/default/) - Default crew

---

## Notes

- Scripts are **internal** - the public interface will be the `ncrew` CLI
- All scripts include detailed documentation in header comments
- Run any script without arguments to see usage help
