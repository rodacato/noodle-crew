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
#   <project-dir>  Path to project directory (e.g., examples/landing-saas)
#
# OPTIONS:
#   --dry-run      Show assembled prompt without executing
#   --llm <name>   Override LLM (claude, gemini). Default: claude
#   --verbose      Show detailed output
#
# EXAMPLES:
#   ./scripts/run-expert.sh product-owner examples/landing-saas
#   ./scripts/run-expert.sh product-owner examples/landing-saas --dry-run
#   ./scripts/run-expert.sh software-architect examples/landing-saas --llm gemini
#
# DEPENDENCIES:
#   - build-prompt.sh (to assemble the prompt)
#   - claude CLI or gemini CLI installed
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
#   - Expert creates git commit
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
#   - build-prompt.sh
#   - iterate.sh (calls this script in a loop)
#   - FLOW.md (execution contract)
#
# ============================================================================

set -e

# Colors for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}[run-expert.sh]${NC} Called with: $@"
echo -e "${BLUE}Would execute:${NC}"
echo "  1. Validate arguments: expert=$1, project=$2"
echo "  2. Call build-prompt.sh to assemble context"
echo "  3. Execute LLM with prompt (claude -p or gemini --yolo)"
echo "  4. LLM runs autonomously: read tasks, do ONE, update state, commit"
echo "  5. Return exit code based on LLM result"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
