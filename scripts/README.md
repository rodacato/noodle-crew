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
│  doctor.sh ◄─── diagnose problems                                   │
│       │                                                             │
│       ▼                                                             │
│  recover.sh ◄─── fix problems (uses git for recovery)               │
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

### Diagnostics & Recovery

| Script | Purpose |
|--------|---------|
| `doctor.sh` | Diagnose project health and detect issues |
| `recover.sh` | Recover from failed or inconsistent states |

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

### Diagnose Problems

```bash
./scripts/doctor.sh examples/landing-saas
./scripts/doctor.sh examples/landing-saas --fix
```

Check project health and get fix suggestions.

### Recover from Failures

```bash
# Discard uncommitted changes (expert failed mid-task)
./scripts/recover.sh examples/landing-saas --discard

# Undo last completed iteration
./scripts/recover.sh examples/landing-saas --reset-last

# Fix state inconsistencies
./scripts/recover.sh examples/landing-saas --sync-tasks
```

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

## Recovery Philosophy

**Git is our checkpoint system.** No separate checkpoint files needed.

Each successful iteration ends with a git commit:
```
feat(discovery): generate PRD from idea
feat(architecture): ADR-001 frontend framework
```

Recovery scenarios:

| Scenario | What Happened | Recovery |
|----------|---------------|----------|
| Expert failed before commit | Changes uncommitted | `--discard` (git checkout .) |
| Need to undo last iteration | Commit exists | `--reset-last` (git reset HEAD~1) |
| State inconsistent | Manual edits broke things | `--sync-tasks` |

---

## Dependencies

- **bash** (4.0+)
- **claude** CLI - Claude Code installed and authenticated
- **git** - For commits and recovery
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

Implementation order:
1. `build-prompt.sh` (pure function, easy to test)
2. `check-termination.sh` (file checks)
3. `resolve-context.sh` (state parsing)
4. `doctor.sh` (validation checks)
5. `run-expert.sh` (LLM integration)
6. `recover.sh` (git operations)
7. `iterate.sh` (orchestrates everything)
8. `init-project.sh` (file copying)

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
- Recovery uses git - no separate checkpoint system needed
