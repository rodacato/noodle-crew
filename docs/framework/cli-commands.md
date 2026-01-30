# CLI Commands

> Available ncrew commands and LLM integration details.

---

## TL;DR

`ncrew` wraps existing AI CLIs (Claude Code, Gemini). You don't need new API keys — just your existing subscriptions. The CLI handles prompt assembly, expert launching, and state management.

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `ncrew init <name>` | Create new project |
| `ncrew run` | Execute the crew |
| `ncrew status` | Show current state |
| `ncrew resume` | Continue after pause |
| `ncrew logs` | View execution history |

---

## Commands

### ncrew init

Create a new project with a crew configuration.

```bash
# Default crew
ncrew init my-project

# Marketplace crew
ncrew init my-project --crew saas-b2b

# List available crews
ncrew marketplace list
```

**Creates:**
```
my-project/
├── IDEA.md
├── INDEX.md
├── .noodlecrew/
└── docs/
```

### ncrew run

Execute the crew from current state.

```bash
ncrew run

# With options
ncrew run --max-iterations 50
ncrew run --max-cost 10.00
ncrew run --dry-run  # Show what would happen
```

### ncrew status

Show current project state.

```bash
ncrew status
```

Output:
```
Project: my-project
Phase: architecture (2/3)
Progress: 5/9 tasks
Iteration: 42/100
Cost: $8.47 / $30.00
Status: in_progress
```

### ncrew resume

Continue after a pause (blocker or human gate).

```bash
# Answer blocker first, then:
ncrew resume
```

### ncrew logs

View execution history.

```bash
ncrew logs           # Latest log
ncrew logs --all     # All logs
ncrew logs --tail 50 # Last 50 lines
```

---

## LLM Integration

NoodleCrew wraps existing AI CLIs. No new API keys needed.

### Supported LLMs

| Config Value | CLI Used | Best For |
|--------------|----------|----------|
| `claude` | Claude Code | General purpose |
| `claude-opus-4.5` | Claude Code | Complex reasoning |
| `gemini-2.5-flash` | Gemini CLI | Fast iterations |
| `gemini-2.5-pro` | Gemini CLI | Complex analysis |

### How It Works

Under the hood, `ncrew run` executes:

```bash
# Claude
claude -p "$(cat prompt.md)" --allowedTools "Edit,Write,Bash"

# Gemini
gemini --yolo < prompt.md
```

### Claude Code Flags

| Flag | Purpose |
|------|---------|
| `-p` | Non-interactive mode |
| `--append-system-prompt-file` | Inject EXPERT.md |
| `--output-format json` | Structured output |
| `--max-turns N` | Iteration limit |
| `--max-budget-usd N` | Cost limit |

### Gemini CLI Flags

| Flag | Purpose |
|------|---------|
| `--yolo` | Auto-approve actions |
| `--output-format json` | Structured output |
| `-m MODEL` | Model selection |

---

## Manual Execution

Run experts manually without the full CLI:

```bash
# See what would be sent
./scripts/run-expert.sh product-owner examples/my-idea --dry-run

# Execute
./scripts/run-expert.sh product-owner examples/my-idea
```

### Script Usage

```bash
./scripts/run-expert.sh <role> <project-dir> [--dry-run]
```

| Argument | Description |
|----------|-------------|
| `role` | Expert name (e.g., `product-owner`) |
| `project-dir` | Path to project |
| `--dry-run` | Show prompt without executing |

---

## Environment Variables

Override configuration via environment:

```bash
NOODLECREW_DEFAULT_LLM=gemini ncrew run
NOODLECREW_MAX_ITERATIONS=50 ncrew run
NOODLECREW_MAX_COST=10 ncrew run
```

| Variable | Overrides |
|----------|-----------|
| `NOODLECREW_DEFAULT_LLM` | `crew.default_llm` |
| `NOODLECREW_MAX_ITERATIONS` | `execution.max_iterations` |
| `NOODLECREW_MAX_COST` | `execution.max_cost` |

---

## Testing Your Setup

### Claude Code

```bash
# Simple test
claude -p "Say hello"

# With JSON output
claude -p --output-format json "What is 2+2?" | jq .
```

### Gemini CLI

```bash
# Simple test
gemini "Say hello"

# With yolo mode
gemini --yolo "List files in current directory"
```

---

## Further Reading

- [Execution Loop](execution-loop.md) — How the loop works
- [Manifest Schema](../crew-development/manifest-schema.md) — Configuration options
- [Expert Format](../crew-development/expert-format.md) — EXPERT.md specification
