#!/bin/bash
# ============================================================================
# recover.sh - Recover from failed or inconsistent states
# ============================================================================
#
# RESPONSIBILITY:
#   Repairs project state after failures or interruptions.
#   Uses git as the recovery mechanism - each successful iteration
#   creates a commit, so we can always restore to a known-good state.
#
# DESIGN PRINCIPLE:
#   Git IS our checkpoint system. No need for separate checkpoint files.
#   - Expert completes task → git commit (saved)
#   - Expert fails before commit → git checkout (restore)
#
# USAGE:
#   ./scripts/recover.sh <project-dir> <action> [options]
#
# ARGUMENTS:
#   <project-dir>  Path to project directory
#   <action>       Recovery action to perform
#
# ACTIONS:
#   --discard          Discard uncommitted changes (failed mid-iteration)
#   --reset-to <sha>   Reset to specific commit
#   --reset-last       Reset to previous commit (undo last iteration)
#   --sync-tasks       Align tasks.md with actual docs/ artifacts
#   --sync-index       Rebuild INDEX.md from tasks.md state
#   --unlock           Clear lock file from interrupted run
#
# OPTIONS:
#   --dry-run          Show what would be done without doing it
#   --force            Skip confirmation prompts
#
# EXAMPLES:
#   # Expert failed mid-task, discard partial changes
#   ./scripts/recover.sh examples/landing-saas --discard
#
#   # Undo last completed iteration
#   ./scripts/recover.sh examples/landing-saas --reset-last
#
#   # Reset to specific point
#   ./scripts/recover.sh examples/landing-saas --reset-to abc123
#
#   # Fix state inconsistency
#   ./scripts/recover.sh examples/landing-saas --sync-tasks
#
# RECOVERY ACTIONS EXPLAINED:
#
#   --discard
#      When: Expert failed BEFORE completing its commit
#      What: git checkout . && git clean -fd
#      Result: Working directory matches last commit
#
#   --reset-to <sha>
#      When: Need to go back to specific iteration
#      What: git reset --hard <sha>
#      Result: Project state matches that commit
#      Note: Find SHA with: git log --oneline | grep "feat(phase)"
#
#   --reset-last
#      When: Last iteration was wrong, undo it
#      What: git reset --hard HEAD~1
#      Result: Back to state before last commit
#
#   --sync-tasks
#      When: tasks.md doesn't match reality (manual edits, etc)
#      What: Scan docs/, update tasks.md to match
#      Result: tasks.md reflects actual artifacts
#
#   --sync-index
#      When: INDEX.md has wrong phase/iteration
#      What: Count completed tasks, recalculate
#      Result: INDEX.md reflects current progress
#
#   --unlock
#      When: Previous run left .noodlecrew/.lock file
#      What: rm .noodlecrew/.lock
#      Result: New runs can proceed
#
# WHY GIT IS ENOUGH:
#   Each iteration ends with: git commit -m "feat(phase): task"
#   If iteration fails before commit:
#     → Changes are uncommitted
#     → git checkout . restores previous state
#   If iteration succeeds:
#     → Commit exists
#     → git reset HEAD~1 undoes it
#
# EXIT CODES:
#   0 - Recovery successful
#   1 - Invalid arguments
#   2 - Recovery failed
#   3 - Project not found
#   5 - User cancelled (when --force not used)
#
# SEE ALSO:
#   - doctor.sh (diagnose issues before recovering)
#   - iterate.sh (creates commits that enable recovery)
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
echo " NoodleCrew Recovery"
echo "========================================${NC}"
echo ""
echo -e "${YELLOW}[recover.sh]${NC} Called with: $@"
echo ""
echo -e "${BLUE}Available actions:${NC}"
echo ""
echo "  --discard"
echo "     Discard uncommitted changes from failed iteration"
echo "     → git checkout . && git clean -fd"
echo ""
echo "  --reset-last"
echo "     Undo the last completed iteration"
echo "     → git reset --hard HEAD~1"
echo ""
echo "  --reset-to <sha>"
echo "     Reset to specific commit"
echo "     → git reset --hard <sha>"
echo ""
echo "  --sync-tasks"
echo "     Align tasks.md with actual docs/ artifacts"
echo ""
echo "  --sync-index"
echo "     Rebuild INDEX.md from tasks.md progress"
echo ""
echo "  --unlock"
echo "     Remove .noodlecrew/.lock file"
echo ""
echo -e "${GREEN}Why git is enough:${NC}"
echo "  • Each iteration = 1 commit"
echo "  • Failed before commit → git checkout . (restore)"
echo "  • Need to undo → git reset HEAD~1"
echo "  • No separate checkpoints needed"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
