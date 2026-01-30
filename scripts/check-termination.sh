#!/bin/bash
# ============================================================================
# check-termination.sh - Check if execution should stop
# ============================================================================
#
# RESPONSIBILITY:
#   Evaluates termination conditions after each iteration.
#   Returns exit code indicating whether to continue, pause, or stop.
#   This implements the termination protocol from FLOW.md Section 1.4.
#
# USAGE:
#   ./scripts/check-termination.sh <project-dir> [options]
#
# ARGUMENTS:
#   <project-dir>  Path to project directory
#
# OPTIONS:
#   --max-iterations <n>  Override max iterations. Default: 100
#   --max-cost <n>        Override max cost. Default: 30.00
#   --human-gates <list>  Comma-separated list of phases requiring review
#
# EXAMPLES:
#   ./scripts/check-termination.sh examples/landing-saas
#   ./scripts/check-termination.sh examples/landing-saas --max-iterations 50
#
# TERMINATION PROTOCOL (from FLOW.md):
#   Checks in order:
#   1. CREW_COMPLETE exists?        → EXIT success (code 0)
#   2. questions/ has pending?      → PAUSE blocker (code 10)
#   3. Phase in human_gates?        → PAUSE gate (code 11)
#   4. iteration >= max_iterations? → EXIT safety (code 20)
#   5. cost >= max_cost?            → EXIT budget (code 21)
#   6. Otherwise                    → CONTINUE (code 100)
#
# INPUTS (from project):
#   - CREW_COMPLETE (file existence check)
#   - .noodlecrew/questions/*.md (check for status: pending)
#   - INDEX.md (read current_iteration, cost_so_far, current_phase)
#   - .noodlecrew/manifest.yml (read human_gates, execution limits)
#
# OUTPUT:
#   Exit code indicating action to take.
#   Human-readable message to stderr.
#
# EXIT CODES:
#   0   - CREW_COMPLETE: All done, exit successfully
#   10  - PAUSE_BLOCKER: Pending question requires user input
#   11  - PAUSE_GATE: Human gate reached, awaiting review
#   20  - EXIT_SAFETY: Max iterations exceeded
#   21  - EXIT_BUDGET: Max cost exceeded
#   100 - CONTINUE: No termination condition met, continue loop
#
# SEE ALSO:
#   - iterate.sh (calls this after each iteration)
#   - FLOW.md Section 1.4 (Termination Protocol)
#
# ============================================================================

set -e

# Colors for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}[check-termination.sh]${NC} Called with: $@"
echo -e "${BLUE}Would execute:${NC}"
echo "  1. Check if CREW_COMPLETE file exists → exit 0"
echo "  2. Check .noodlecrew/questions/ for status: pending → exit 10"
echo "  3. Read INDEX.md for current_phase, check if in human_gates → exit 11"
echo "  4. Read INDEX.md for current_iteration, compare with max → exit 20"
echo "  5. Read INDEX.md for cost_so_far, compare with max → exit 21"
echo "  6. No condition met → exit 100 (continue)"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
exit 100  # Default: continue
