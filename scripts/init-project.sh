#!/bin/bash
# ============================================================================
# init-project.sh - Initialize a new NoodleCrew project
# ============================================================================
#
# RESPONSIBILITY:
#   Creates a new project directory with all required files and structure.
#   Copies a crew from marketplace/ to the project's .noodlecrew/ directory.
#   Initializes git repository if not already initialized.
#
# USAGE:
#   ./scripts/init-project.sh <project-name> [options]
#
# ARGUMENTS:
#   <project-name>  Name of the project directory to create
#
# OPTIONS:
#   --crew <name>   Crew to install. Default: default
#   --dir <path>    Parent directory. Default: current directory
#   --no-git        Don't initialize git repository
#
# EXAMPLES:
#   ./scripts/init-project.sh my-saas-idea
#   ./scripts/init-project.sh my-fintech --crew fintech-app
#   ./scripts/init-project.sh my-project --dir ~/projects
#
# CREATED STRUCTURE (from FLOW.md):
#   <project-name>/
#   ├── IDEA.md                    # User input (from crew template)
#   ├── INDEX.md                   # Project state (from crew template)
#   ├── .noodlecrew/               # Crew internals
#   │   ├── manifest.yml           # Crew configuration
#   │   ├── tasks.md               # Task checklist (from crew template)
#   │   ├── experts/               # Expert definitions (copied from crew)
#   │   ├── phases/                # Phase definitions (copied from crew)
#   │   ├── questions/             # Blocker directory (created empty)
#   │   ├── logs/                  # Execution logs (created empty)
#   │   ├── CREW.md                # Crew metadata
#   │   ├── PHASES.md              # Phases overview
#   │   └── WORKFLOW.md            # Execution instructions
#   └── docs/                      # Output directory
#       ├── discovery/             # Phase output dirs (created empty)
#       ├── architecture/
#       └── implementation/
#
# INPUTS:
#   - marketplace/<crew>/          # Source crew package
#   - marketplace/<crew>/templates/ # Project templates (IDEA.md, INDEX.md, tasks.md)
#
# OUTPUTS:
#   - New project directory with all files
#   - Initialized git repository (unless --no-git)
#   - Initial commit with project structure
#
# EXIT CODES:
#   0 - Success
#   1 - Invalid arguments
#   2 - Crew not found
#   3 - Directory already exists
#   4 - Git initialization failed
#
# SEE ALSO:
#   - iterate.sh (run after init)
#   - FLOW.md Section 1.1 (Directory Structure)
#
# ============================================================================

set -e

# Colors for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}========================================"
echo " NoodleCrew Project Initializer"
echo "========================================${NC}"
echo ""
echo -e "${YELLOW}[init-project.sh]${NC} Called with: $@"
echo -e "${BLUE}Would execute:${NC}"
echo "  1. Validate crew exists in marketplace/"
echo "  2. Create project directory structure:"
echo "     - mkdir -p <project>/.noodlecrew/{questions,logs}"
echo "     - mkdir -p <project>/docs/{discovery,architecture,implementation}"
echo "  3. Copy crew files from marketplace/<crew>/:"
echo "     - manifest.yml, CREW.md, PHASES.md, WORKFLOW.md"
echo "     - experts/ directory"
echo "     - phases/ directory"
echo "  4. Copy templates to project root:"
echo "     - templates/IDEA.md → IDEA.md"
echo "     - templates/INDEX.md → INDEX.md"
echo "     - templates/tasks.md → .noodlecrew/tasks.md"
echo "  5. Initialize git repository (unless --no-git)"
echo "  6. Create initial commit"
echo ""
echo -e "${YELLOW}[NOT IMPLEMENTED]${NC} This is a documentation stub."
