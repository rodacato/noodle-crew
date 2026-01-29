# CLI Integration

> How to execute experts using gemini-cli and claude-code in one-shot mode.

---

## Overview

NoodleCrew's orchestrator launches experts as one-shot CLI commands. Each expert receives:

- Context files (IDEA.md, TODO.md, previous artifacts)
- System prompt (EXPERT.md + WORKFLOW.md)
- A task instruction

The CLI executes and returns, then the orchestrator checks state and loops.

---

## Claude Code (v2.1.22)

### Basic One-Shot

```bash
claude -p "Your prompt here"
```

### Full Expert Invocation

```bash
claude -p \
  --append-system-prompt-file .noodlecrew/experts/product-owner/EXPERT.md \
  --append-system-prompt-file .noodlecrew/WORKFLOW.md \
  --output-format json \
  --max-turns 10 \
  "Read TODO.md and complete the next unchecked task in your phase"
```

### Key Flags

| Flag | Purpose |
| ---- | ------- |
| `-p` | Non-interactive mode (required) |
| `--append-system-prompt-file` | Inject EXPERT.md + WORKFLOW.md |
| `--output-format json` | Structured output for parsing |
| `--max-turns N` | Limit iterations (safety) |
| `--permission-mode plan` | Analysis only, no modifications |
| `--dangerously-skip-permissions` | Auto-approve all (CI/CD only) |
| `--max-budget-usd N` | Cost limit |
| `--model sonnet\|opus\|haiku` | Model selection |
| `--add-dir PATH` | Include additional directories |

### JSON Output Structure

```json
{
  "type": "result",
  "result": "Task output...",
  "session_id": "uuid",
  "total_cost_usd": 0.04,
  "num_turns": 3
}
```

### Parsing

```bash
claude -p --output-format json "Task" | jq -r '.result'
claude -p --output-format json "Task" | jq -r '.total_cost_usd'
```

---

## Gemini CLI (v0.24.0)

### Basic One-Shot

```bash
gemini "Your prompt here"
```

### Full Expert Invocation

```bash
# Gemini requires concatenating system prompt into the prompt
EXPERT=$(cat .noodlecrew/experts/product-owner/EXPERT.md)
WORKFLOW=$(cat .noodlecrew/WORKFLOW.md)

gemini --yolo --output-format json "$EXPERT

---

$WORKFLOW

---

Read TODO.md and complete the next unchecked task in your phase"
```

### Key Flags

| Flag | Purpose |
| ---- | ------- |
| (positional) | Prompt text (required) |
| `--yolo` | Auto-approve all actions |
| `--approval-mode` | `auto_edit`, `yolo`, `default` |
| `--output-format json` | Structured output |
| `--include-directories PATH` | Add context dirs |
| `-m MODEL` | Model selection |
| `-s, --sandbox` | Sandboxed execution |

---

## Comparison

| Feature | Claude Code | Gemini CLI |
| ------- | ----------- | ---------- |
| One-shot flag | `-p` | positional |
| System prompt file | `--append-system-prompt-file` | Concatenate manually |
| Auto-approve | `--dangerously-skip-permissions` | `--yolo` |
| JSON output | `--output-format json` | `--output-format json` |
| Cost in response | Yes | No |

---

## Orchestrator Script

```bash
#!/bin/bash
# run-expert.sh <role> <phase> [llm]

ROLE=$1
PHASE=$2
LLM=${3:-claude}

EXPERT=".noodlecrew/experts/$ROLE/EXPERT.md"
WORKFLOW=".noodlecrew/WORKFLOW.md"
PROMPT="Current phase: $PHASE. Read TODO.md and complete the next unchecked task."

if [ "$LLM" = "claude" ]; then
    claude -p \
        --append-system-prompt-file "$EXPERT" \
        --append-system-prompt-file "$WORKFLOW" \
        --output-format json \
        --max-turns 10 \
        "$PROMPT"
else
    gemini --yolo --output-format json \
        "$(cat $EXPERT)
---
$(cat $WORKFLOW)
---
$PROMPT"
fi
```

Usage:

```bash
./run-expert.sh product-owner discovery claude
./run-expert.sh software-architect architecture gemini
```

---

## Testing

### Claude

```bash
# Simple test
claude -p "Say hello"

# With JSON
claude -p --output-format json "What is 2+2?" | jq .

# With system prompt
claude -p --append-system-prompt "You are a pirate" "Say hello"
```

### Gemini

```bash
# Simple test
gemini "Say hello"

# With JSON
gemini --output-format json "What is 2+2?"

# With yolo
gemini --yolo "List files in current directory"
```

---

## Further Reading

- [Architecture](../concepts/architecture.md) — The execution loop
- [Workflow Definition](../../marketplace/default/WORKFLOW.md) — Expert instructions
- [Expert Format](expert-format.md) — EXPERT.md specification
