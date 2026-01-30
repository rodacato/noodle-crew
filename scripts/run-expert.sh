#!/bin/bash
# ============================================================================
# run-expert.sh - Execute a single expert turn
# ============================================================================
#
# RESPONSIBILITY:
#   Executes one expert in one-shot mode. The expert receives context,
#   does ONE task, updates state files, commits, and ends its turn.
#   This is the atomic unit of execution in NoodleCrew.
#
# USAGE:
#   ./scripts/run-expert.sh <expert> <project-dir> [options]
#
# ARGUMENTS:
#   <expert>       Expert role (e.g., product-owner, software-architect)
#   <project-dir>  Path to project directory (e.g., examples/finance-tracker)
#
# OPTIONS:
#   --dry-run      Show assembled prompt without executing
#   --no-commit    Skip git commit (for testing/development)
#   --llm <name>   Override LLM (claude, gemini). Default: claude
#   --verbose      Show detailed output
#
# EXAMPLES:
#   ./scripts/run-expert.sh product-owner examples/finance-tracker
#   ./scripts/run-expert.sh product-owner examples/finance-tracker --dry-run
#   ./scripts/run-expert.sh product-owner examples/finance-tracker --no-commit
#   ./scripts/run-expert.sh software-architect examples/finance-tracker --llm gemini
#
# DEPENDENCIES:
#   - build-prompt.sh (to assemble the prompt)
#   - claude CLI or gemini CLI installed and configured
#
# INPUTS (read from project):
#   - IDEA.md
#   - INDEX.md
#   - .noodlecrew/tasks.md
#   - docs/* (previous artifacts)
#
# INPUTS (read from crew):
#   - experts/<role>/EXPERT.md
#   - experts/<role>/templates/*
#   - WORKFLOW.md
#
# OUTPUTS:
#   - Expert creates artifacts in docs/<phase>/
#   - Expert updates .noodlecrew/tasks.md
#   - Expert updates INDEX.md
#   - Expert creates git commit (unless --no-commit)
#   - Expert may create CREW_COMPLETE if all done
#
# EXIT CODES:
#   0 - Success
#   1 - Invalid arguments
#   2 - Expert not found
#   3 - Project files missing
#   4 - LLM execution failed
#
# SEE ALSO:
#   - init-example.sh (initialize project before running)
#   - build-prompt.sh (assembles the prompt)
#   - clean-example.sh (reset project after testing)
#   - iterate.sh (runs multiple experts in a loop)
#   - FLOW.md (execution contract)
#
# ============================================================================

set -e

# Defaults
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false
NO_COMMIT=false
LLM="claude"
VERBOSE=false

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Parse arguments
EXPERT=""
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-commit)
            NO_COMMIT=true
            shift
            ;;
        --llm)
            LLM="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        -*)
            echo -e "${RED}Error:${NC} Unknown option: $1" >&2
            exit 1
            ;;
        *)
            if [[ -z "$EXPERT" ]]; then
                EXPERT="$1"
            elif [[ -z "$PROJECT_DIR" ]]; then
                PROJECT_DIR="$1"
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [[ -z "$EXPERT" ]] || [[ -z "$PROJECT_DIR" ]]; then
    echo -e "${RED}Error:${NC} Missing required arguments" >&2
    echo "Usage: $0 <expert> <project-dir> [--dry-run] [--llm <name>]" >&2
    exit 1
fi

# Banner
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  NoodleCrew - Expert Execution${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Expert:  ${GREEN}$EXPERT${NC}"
echo -e "  Project: ${BLUE}$PROJECT_DIR${NC}"
echo -e "  LLM:     $LLM"
echo -e "  Mode:    $(if $DRY_RUN; then echo 'dry-run'; else echo 'execute'; fi)"
echo -e "  Commit:  $(if $NO_COMMIT; then echo 'disabled'; else echo 'enabled'; fi)"
echo ""

# Build the prompt
echo -e "${BLUE}[1/3]${NC} Building prompt..."
PROMPT_FILE=$(mktemp)
"$SCRIPT_DIR/build-prompt.sh" "$EXPERT" "$PROJECT_DIR" --output "$PROMPT_FILE"

if [[ ! -s "$PROMPT_FILE" ]]; then
    echo -e "${RED}Error:${NC} Failed to build prompt" >&2
    rm -f "$PROMPT_FILE"
    exit 3
fi

PROMPT_SIZE=$(wc -c < "$PROMPT_FILE" | tr -d ' ')
echo -e "       Prompt size: ${GREEN}$PROMPT_SIZE bytes${NC}"

# Append no-commit instruction if flag is set
if $NO_COMMIT; then
    echo "" >> "$PROMPT_FILE"
    echo "---" >> "$PROMPT_FILE"
    echo "" >> "$PROMPT_FILE"
    echo "# IMPORTANT: NO COMMIT MODE" >> "$PROMPT_FILE"
    echo "" >> "$PROMPT_FILE"
    echo "**DO NOT run git commands.** Skip the commit step entirely." >> "$PROMPT_FILE"
    echo "Only create/update files. Do not commit." >> "$PROMPT_FILE"
    echo -e "       ${YELLOW}No-commit mode enabled${NC}"
fi

# Dry run mode - just show the prompt
if $DRY_RUN; then
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  DRY RUN - Assembled Prompt${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    cat "$PROMPT_FILE"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  End of prompt (dry-run mode)${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    rm -f "$PROMPT_FILE"
    exit 0
fi

# Resolve project dir to absolute path for LLM execution
if [[ ! "$PROJECT_DIR" = /* ]]; then
    PROJECT_DIR_ABS="$ROOT_DIR/$PROJECT_DIR"
else
    PROJECT_DIR_ABS="$PROJECT_DIR"
fi

# Execute LLM
echo -e "${BLUE}[2/3]${NC} Executing $LLM..."
echo ""

case $LLM in
    claude)
        # Claude Code CLI
        # -p: prompt from file
        # --allowedTools: tools the agent can use
        # We change to project directory so file operations are relative
        cd "$PROJECT_DIR_ABS"

        PROMPT_CONTENT=$(cat "$PROMPT_FILE")

        echo -e "${GREEN}Starting Claude...${NC}"
        echo ""

        # Execute claude with the prompt
        # The expert will work autonomously in the project directory
        claude -p "$PROMPT_CONTENT" --allowedTools "Edit,Write,Bash,Read,Glob,Grep"

        RESULT=$?
        ;;

    gemini)
        # Gemini CLI (placeholder - adjust based on actual CLI)
        cd "$PROJECT_DIR_ABS"

        echo -e "${GREEN}Starting Gemini...${NC}"
        echo ""

        # Gemini uses stdin for prompt
        cat "$PROMPT_FILE" | gemini --yolo

        RESULT=$?
        ;;

    *)
        echo -e "${RED}Error:${NC} Unknown LLM: $LLM" >&2
        rm -f "$PROMPT_FILE"
        exit 4
        ;;
esac

# Cleanup
rm -f "$PROMPT_FILE"

# Report result
echo ""
echo -e "${BLUE}[3/3]${NC} Execution complete"

if [[ $RESULT -eq 0 ]]; then
    echo -e "       Status: ${GREEN}SUCCESS${NC}"
else
    echo -e "       Status: ${RED}FAILED (exit code: $RESULT)${NC}"
fi

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit $RESULT
