#!/bin/bash
# ============================================================================
# doctor.sh - Diagnose project health and detect issues
# ============================================================================
#
# RESPONSIBILITY:
#   Analyzes project state and reports any inconsistencies, missing files,
#   or potential problems. Like 'brew doctor' - shows what's wrong and
#   suggests how to fix it.
#
# USAGE:
#   ./scripts/doctor.sh <project-dir> [options]
#
# ARGUMENTS:
#   <project-dir>  Path to project directory
#
# OPTIONS:
#   --fix          Attempt to fix simple issues automatically
#   --json         Output as JSON for programmatic use
#   --quiet        Only show errors, not warnings
#
# EXAMPLES:
#   ./scripts/doctor.sh examples/landing-saas
#   ./scripts/doctor.sh examples/landing-saas --fix
#   ./scripts/doctor.sh examples/landing-saas --json
#
# CHECKS PERFORMED:
#
#   1. STRUCTURE CHECKS
#      - IDEA.md exists and has content
#      - INDEX.md exists and has valid frontmatter
#      - .noodlecrew/ directory exists
#      - .noodlecrew/tasks.md exists and is valid
#      - .noodlecrew/manifest.yml exists and is valid YAML
#      - docs/ directory exists
#
#   2. STATE CONSISTENCY
#      - Tasks marked [x] have corresponding artifacts in docs/
#      - Tasks marked [ ] don't have artifacts yet
#      - INDEX.md phase matches tasks.md progress
#      - INDEX.md iteration is reasonable
#
#   3. BLOCKER CHECKS
#      - questions/*.md have valid frontmatter
#      - Pending blockers have no answer filled
#      - Resolved blockers have answer filled
#
#   4. GIT CHECKS
#      - Working tree is clean (no uncommitted changes)
#      - No merge conflicts
#      - Remote is configured (optional)
#
#   5. CREW CHECKS
#      - All experts referenced in manifest exist
#      - All phases referenced have definitions
#      - WORKFLOW.md exists
#
# OUTPUT FORMAT:
#   ✓ Check passed
#   ⚠ Warning (non-blocking)
#   ✗ Error (blocking)
#   → Suggestion for fixing
#
# EXAMPLE OUTPUT:
#   $ ./scripts/doctor.sh examples/landing-saas
#
#   NoodleCrew Doctor - Project Health Check
#   =========================================
#
#   Structure:
#     ✓ IDEA.md exists (1.2KB)
#     ✓ INDEX.md valid
#     ✓ .noodlecrew/ structure complete
#
#   State Consistency:
#     ✗ tasks.md: "Generate PRD" marked [x] but docs/discovery/prd.md missing
#       → Run: ./scripts/recover.sh examples/landing-saas --sync-tasks
#     ⚠ INDEX.md iteration (5) seems low for 3 completed tasks
#
#   Blockers:
#     ⚠ questions/architect-001.md: status 'pending' but answer is filled
#       → Change status to 'resolved' and run 'ncrew resume'
#
#   Git:
#     ✓ Working tree clean
#     ✓ On branch 'master'
#
#   Summary: 1 error, 2 warnings
#   Run with --fix to attempt automatic repairs.
#
# EXIT CODES:
#   0 - All checks passed (may have warnings)
#   1 - Invalid arguments
#   2 - Errors found (blocking issues)
#   3 - Project not found
#
# SEE ALSO:
#   - recover.sh (fix issues found by doctor)
#   - check-termination.sh (runtime checks)
#
# ============================================================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================"
echo " NoodleCrew Doctor"
echo "========================================${NC}"
echo ""
echo -e "${YELLOW}[doctor.sh]${NC} Called with: $@"
echo ""
echo -e "${BLUE}Would check:${NC}"
echo ""
echo "  Structure:"
echo "    □ IDEA.md exists and has content"
echo "    □ INDEX.md exists with valid frontmatter"
echo "    □ .noodlecrew/ directory structure"
echo "    □ .noodlecrew/tasks.md valid markdown"
echo "    □ .noodlecrew/manifest.yml valid YAML"
echo ""
echo "  State Consistency:"
echo "    □ Tasks [x] have artifacts in docs/"
echo "    □ Tasks [ ] don't have artifacts yet"
echo "    □ INDEX.md phase matches progress"
echo "    □ No duplicate task completions"
echo ""
echo "  Blockers:"
echo "    □ questions/*.md have valid frontmatter"
echo "    □ Pending blockers awaiting answer"
echo "    □ Resolved blockers have answers"
echo ""
echo "  Git:"
echo "    □ Working tree clean"
echo "    □ No merge conflicts"
echo ""
echo "  Crew:"
echo "    □ All experts in manifest exist"
echo "    □ All phases have definitions"
echo "    □ WORKFLOW.md exists"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
