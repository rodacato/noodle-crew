# NoodleCrew - Context for AI Assistants

## Project Status

Documentation-only project (no code implementation yet).
Phase: Manual PoC - designing the system before building it.

## Quick Navigation

| Topic | Primary File | Notes |
|-------|--------------|-------|
| What it does | README.md | Philosophy-first overview |
| How it works | docs/concepts/architecture.md | Autonomous expert loop |
| Expert definition | docs/reference/expert-format.md | EXPERT.md spec |
| State files | docs/reference/state-files.md | INDEX.md, TODO.md, blockers |
| CLI integration | docs/reference/cli-integration.md | One-shot with claude/gemini |
| Configuration | docs/guides/index.md | manifest.yml options |
| Project layout | docs/reference/project-structure.md | Generated folders |
| Default crew | marketplace/default/ | Ready-to-use crew package |

## Key Architecture Decisions (Already Made)

1. **Experts are autonomous agents** - They read TODO.md, create files, update state, git commit, end turn
2. **Orchestrator is a simple loop** - Build prompt → launch expert → log → check termination → repeat
3. **Termination via CREW_COMPLETE file** - Expert creates empty file when all tasks done
4. **State lives in markdown** - INDEX.md (project state), TODO.md (tasks), questions/ (blockers)
5. **No response parsing** - Orchestrator doesn't parse LLM output; expert manages its own files

## Directory Structure

```
noodle-crew/
├── README.md                 # Entry point, philosophy
├── DEVELOPMENT.md            # Roadmap and status
├── CLAUDE.md                 # This file (AI context)
├── docs/
│   ├── concepts/             # Why and how
│   │   ├── philosophy.md
│   │   └── architecture.md
│   ├── guides/               # Configuration
│   │   └── index.md
│   ├── reference/            # Specifications
│   │   ├── project-structure.md
│   │   ├── expert-format.md
│   │   └── state-files.md
│   ├── marketplace/          # Crews catalog
│   │   └── index.md
│   └── getting-started/
│       └── quickstart.md
└── examples/                 # Sample projects
```

## Conventions

- **Commit style**: `type(scope): description` (conventional commits)
- **Doc format**: Markdown with YAML frontmatter
- **Language**: English for docs, Spanish OK for conversations

## What NOT to Re-explore

These topics are settled - don't spend tokens re-investigating:

- Expert autonomy model (DLP-inspired)
- State file formats (INDEX.md, TODO.md)
- Termination mechanism (CREW_COMPLETE file)
- Project structure (.noodlecrew/, docs/, questions/)
- Phase flow (discovery → architecture → implementation)
- CLI integration (claude -p, gemini --yolo)
