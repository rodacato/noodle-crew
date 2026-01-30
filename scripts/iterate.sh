#!/bin/bash
# ============================================================================
# iterate.sh - The main execution loop (iterator)
# ============================================================================
#
# RESPONSIBILITY:
#   Runs the NoodleCrew execution loop until termination.
#   This is the "Ralph Wiggum Loop" - a simple loop that restarts experts
#   until all work is done or a termination condition is met.
#
# USAGE:
#   ./scripts/iterate.sh <project-dir> [options]
#
# ARGUMENTS:
#   <project-dir>  Path to project directory
#
# OPTIONS:
#   --crew <dir>          Override crew directory. Default: marketplace/default
#   --max-iterations <n>  Override max iterations. Default: 100
#   --max-cost <n>        Override max cost. Default: 30.00
#   --llm <name>          Override LLM. Default: claude
#   --verbose             Show detailed output
#   --single              Run only one iteration (for testing)
#
# EXAMPLES:
#   ./scripts/iterate.sh examples/landing-saas
#   ./scripts/iterate.sh examples/landing-saas --max-iterations 10
#   ./scripts/iterate.sh examples/landing-saas --single
#
# EXECUTION LOOP (from FLOW.md):
#   1. RESOLVE CONTEXT
#      - Read manifest.yml → determine phases
#      - Read tasks.md → find phase with pending tasks
#      - Select expert for that phase
#
#   2. BUILD PROMPT
#      - Call build-prompt.sh
#
#   3. LAUNCH EXPERT
#      - Call run-expert.sh
#      - Expert runs autonomously (read, work, update, commit)
#
#   4. LOG & TRACK
#      - Write to .noodlecrew/logs/
#      - Update iteration counter
#
#   5. CHECK TERMINATION
#      - Call check-termination.sh
#      - Based on exit code: continue, pause, or stop
#
# INPUTS:
#   - Project directory with IDEA.md, INDEX.md, .noodlecrew/
#   - Crew directory with experts/, manifest.yml
#
# OUTPUTS:
#   - Artifacts in docs/
#   - Updated state files
#   - Git commits
#   - Logs in .noodlecrew/logs/
#
# EXIT CODES:
#   0  - Success (CREW_COMPLETE)
#   1  - Invalid arguments
#   10 - Paused: blocker pending
#   11 - Paused: human gate reached
#   20 - Stopped: max iterations
#   21 - Stopped: max cost
#   99 - Error during execution
#
# SEE ALSO:
#   - run-expert.sh
#   - build-prompt.sh
#   - check-termination.sh
#   - FLOW.md Section 2 (Execution Loop)
#
# ============================================================================

set -e

# Colors for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}========================================"
echo " NoodleCrew Iterator"
echo "========================================${NC}"
echo ""
echo -e "${YELLOW}[iterate.sh]${NC} Called with: $@"
echo -e "${BLUE}Would execute:${NC}"
echo "  LOOP {"
echo "    1. resolve-context.sh → determine current phase and expert"
echo "    2. build-prompt.sh → assemble expert prompt"
echo "    3. run-expert.sh → execute expert (LLM call)"
echo "    4. Log output to .noodlecrew/logs/"
echo "    5. check-termination.sh → evaluate stop conditions"
echo "       - exit 0 (done) → break loop, exit success"
echo "       - exit 10/11 (pause) → break loop, exit pause code"
echo "       - exit 20/21 (limit) → break loop, exit limit code"
echo "       - exit 100 (continue) → next iteration"
echo "  }"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
