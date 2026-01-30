#!/bin/bash
# ============================================================================
# build-prompt.sh - Assemble expert prompt from context files
# ============================================================================
#
# RESPONSIBILITY:
#   Reads all context files and assembles them into a single prompt string
#   following the context injection order defined in FLOW.md.
#   This is a pure function: reads files, outputs text.
#
# USAGE:
#   ./scripts/build-prompt.sh <expert> <project-dir> [--output <file>]
#
# ARGUMENTS:
#   <expert>       Expert role (e.g., product-owner)
#   <project-dir>  Path to project directory
#
# OPTIONS:
#   --output <file>  Write prompt to file instead of stdout
#   --crew <dir>     Override crew directory. Default: marketplace/default
#
# EXAMPLES:
#   ./scripts/build-prompt.sh product-owner examples/landing-saas
#   ./scripts/build-prompt.sh product-owner examples/landing-saas --output /tmp/prompt.md
#
# CONTEXT INJECTION ORDER (from FLOW.md):
#   1. [ROLE]       EXPERT.md       "You are a Product Owner..."
#   2. [WORKFLOW]   WORKFLOW.md     "Do ONE task, commit, end turn"
#   3. [INPUT]      IDEA.md         User's original idea
#   4. [STATE]      INDEX.md        Current phase, iteration
#   5. [TASKS]      tasks.md        What needs to be done
#   6. [CONTEXT]    docs/*          Previous artifacts
#   7. [TEMPLATES]  templates/      Output formats
#   8. [INSTRUCTION]                "Execute your next task..."
#
# INPUTS (from project):
#   - IDEA.md
#   - INDEX.md
#   - .noodlecrew/tasks.md
#   - docs/**/*.md (all previous artifacts)
#
# INPUTS (from crew):
#   - experts/<role>/EXPERT.md
#   - experts/<role>/templates/*.md
#   - WORKFLOW.md
#
# OUTPUT:
#   Assembled prompt as markdown text (stdout or file)
#
# EXIT CODES:
#   0 - Success
#   1 - Invalid arguments
#   2 - Required files missing
#
# SEE ALSO:
#   - run-expert.sh (uses this to build prompts)
#   - FLOW.md Section 2.2 (Context Injection Order)
#
# ============================================================================

set -e

# Colors for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}[build-prompt.sh]${NC} Called with: $@"
echo -e "${BLUE}Would execute:${NC}"
echo "  1. Read EXPERT.md from crew/experts/$1/"
echo "  2. Read WORKFLOW.md from crew/"
echo "  3. Read IDEA.md from project"
echo "  4. Read INDEX.md from project"
echo "  5. Read .noodlecrew/tasks.md from project"
echo "  6. Collect all docs/**/*.md as context"
echo "  7. Read templates from crew/experts/$1/templates/"
echo "  8. Assemble in order: ROLE → WORKFLOW → INPUT → STATE → TASKS → CONTEXT → TEMPLATES → INSTRUCTION"
echo "  9. Output assembled prompt to stdout or file"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
