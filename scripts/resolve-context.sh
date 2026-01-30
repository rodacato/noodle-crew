#!/bin/bash
# ============================================================================
# resolve-context.sh - Determine which expert to run next
# ============================================================================
#
# RESPONSIBILITY:
#   Reads project state and determines which expert should execute next.
#   This is the "brain" that decides phase transitions and expert selection.
#
# USAGE:
#   ./scripts/resolve-context.sh <project-dir> [options]
#
# ARGUMENTS:
#   <project-dir>  Path to project directory
#
# OPTIONS:
#   --crew <dir>   Override crew directory. Default: marketplace/default
#   --json         Output as JSON instead of shell variables
#
# EXAMPLES:
#   ./scripts/resolve-context.sh examples/landing-saas
#   eval $(./scripts/resolve-context.sh examples/landing-saas)
#   echo "Current expert: $EXPERT, phase: $PHASE"
#
# RESOLUTION LOGIC:
#   1. Read .noodlecrew/tasks.md
#   2. Find first phase with unchecked tasks [ ]
#   3. Read manifest.yml to get expert for that phase
#   4. Output expert role and phase
#
# INPUTS:
#   - .noodlecrew/tasks.md (task checklist)
#   - .noodlecrew/manifest.yml (expert-phase mapping)
#
# OUTPUT (shell format):
#   PHASE=discovery
#   EXPERT=product-owner
#   TASK="Generate PRD from IDEA.md"
#   STATUS=in_progress
#
# OUTPUT (json format):
#   {"phase": "discovery", "expert": "product-owner", "task": "...", "status": "..."}
#
# EXIT CODES:
#   0 - Success, expert found
#   1 - Invalid arguments
#   2 - All tasks complete (no pending work)
#   3 - No expert found for phase
#
# SEE ALSO:
#   - iterate.sh (calls this to determine next expert)
#   - FLOW.md Section 2.1 (Resolve Context)
#
# ============================================================================

set -e

# Colors for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}[resolve-context.sh]${NC} Called with: $@"
echo -e "${BLUE}Would execute:${NC}"
echo "  1. Read .noodlecrew/tasks.md"
echo "  2. Parse markdown to find first unchecked [ ] task"
echo "  3. Determine which phase that task belongs to"
echo "  4. Read manifest.yml to find expert for that phase"
echo "  5. Output: PHASE=<phase> EXPERT=<expert> TASK=<task>"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
echo ""
echo "# Example output (what would be printed):"
echo "PHASE=discovery"
echo "EXPERT=product-owner"
echo "TASK=\"Generate PRD from IDEA.md\""
echo "STATUS=pending"
