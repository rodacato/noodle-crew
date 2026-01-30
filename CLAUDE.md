# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Status

**Documentation-only project** - Phase 1 (Manual PoC). Scripts are documented stubs, not functional yet.

## Development Commands

```bash
# Setup
bun install
bun link

# Test
bun test

# Manual expert execution (scripts are stubs, use --dry-run)
./scripts/run-expert.sh product-owner examples/landing-saas --dry-run
./scripts/iterate.sh examples/landing-saas --max-iterations 10

# Project initialization
./scripts/init-project.sh my-project --crew saas-b2b

# Diagnostics
./scripts/doctor.sh examples/landing-saas
./scripts/recover.sh examples/landing-saas --discard
```

## Key Architecture Decisions (Already Made)

1. **Experts are autonomous agents** - They read TODO.md, create files, update state, git commit, end turn
2. **Orchestrator is a simple loop** - Build prompt → launch expert → log → check termination → repeat
3. **Termination via CREW_COMPLETE file** - Expert creates empty file when all tasks done
4. **State lives in markdown** - INDEX.md (project state), TODO.md (tasks), questions/ (blockers)
5. **No response parsing** - Orchestrator doesn't parse LLM output; expert manages its own files

## Directory Structure

```
noodle-crew/
├── docs/                     # Public documentation (GitHub Pages)
│   ├── concepts/             # Philosophy, architecture
│   ├── reference/            # Specs (expert-format, state-files)
│   └── guides/               # Configuration guides
├── scripts/                  # Execution engine (shell stubs)
│   ├── iterate.sh            # Main execution loop
│   ├── run-expert.sh         # Single expert turn
│   ├── build-prompt.sh       # Assemble context for LLM
│   ├── doctor.sh             # Diagnose project health
│   └── recover.sh            # Git-based recovery
├── marketplace/              # Crew packages
│   └── default/              # Default crew (product-owner, architect, dev)
└── examples/                 # Sample projects for testing
```

## Conventions

- **Commit style**: `type(scope): description` (conventional commits)
- **Doc format**: Markdown with YAML frontmatter
- **Language**: English for docs, Spanish OK for conversations

## What NOT to Re-explore

These design decisions are final - don't spend tokens re-investigating:

- Expert autonomy model (DLP-inspired)
- State file formats (INDEX.md, TODO.md)
- Termination mechanism (CREW_COMPLETE file)
- Project structure (.noodlecrew/, docs/, questions/)
- Phase flow (discovery → architecture → implementation)
- CLI integration (claude -p, gemini --yolo)

## Key Files for Context

| Topic | File |
|-------|------|
| Design docs | .idea/INDEX.md |
| Framework docs | docs/concepts/architecture.md |
| Expert spec | docs/reference/expert-format.md |
| Script usage | scripts/README.md |
