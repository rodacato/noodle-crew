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
# CONTEXT INJECTION ORDER:
#   1. [ROLE]       EXPERT.md       "You are a Product Owner..."
#   2. [WORKFLOW]   WORKFLOW.md     "Do ONE task, commit, end turn"
#   3. [INPUT]      IDEA.md         User's original idea
#   4. [STATE]      INDEX.md        Current phase, iteration
#   5. [TASKS]      tasks.md        What needs to be done
#   6. [CONTEXT]    docs/*          Previous artifacts
#   7. [TEMPLATES]  templates/      Output formats
#   8. [INSTRUCTION]                "Execute your next task..."
#
# EXAMPLES:
#   ./scripts/build-prompt.sh product-owner examples/finance-tracker
#   ./scripts/build-prompt.sh product-owner examples/finance-tracker --output /tmp/prompt.md
#   ./scripts/build-prompt.sh software-architect examples/finance-tracker --crew marketplace/custom
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

# Defaults
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CREW_DIR="$ROOT_DIR/marketplace/default"
OUTPUT_FILE=""

# Colors
RED='\033[0;31m'
NC='\033[0m'

# Parse arguments
EXPERT=""
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --crew)
            CREW_DIR="$2"
            shift 2
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
    echo "Usage: $0 <expert> <project-dir> [--output <file>] [--crew <dir>]" >&2
    exit 1
fi

# Resolve project dir to absolute path
if [[ ! "$PROJECT_DIR" = /* ]]; then
    PROJECT_DIR="$ROOT_DIR/$PROJECT_DIR"
fi

# Validate paths
EXPERT_DIR="$CREW_DIR/experts/$EXPERT"
if [[ ! -d "$EXPERT_DIR" ]]; then
    echo -e "${RED}Error:${NC} Expert not found: $EXPERT_DIR" >&2
    exit 2
fi

if [[ ! -f "$PROJECT_DIR/IDEA.md" ]]; then
    echo -e "${RED}Error:${NC} IDEA.md not found in $PROJECT_DIR" >&2
    exit 2
fi

# Function to output (to file or stdout)
output() {
    if [[ -n "$OUTPUT_FILE" ]]; then
        echo "$1" >> "$OUTPUT_FILE"
    else
        echo "$1"
    fi
}

# Clear output file if specified
if [[ -n "$OUTPUT_FILE" ]]; then
    > "$OUTPUT_FILE"
fi

# ============================================================================
# ASSEMBLE PROMPT
# ============================================================================

# 1. [ROLE] - Expert definition
output "# ROLE"
output ""
if [[ -f "$EXPERT_DIR/EXPERT.md" ]]; then
    output "$(cat "$EXPERT_DIR/EXPERT.md")"
else
    echo -e "${RED}Error:${NC} EXPERT.md not found" >&2
    exit 2
fi
output ""

# 2. [WORKFLOW] - Execution instructions
output "---"
output ""
output "# WORKFLOW"
output ""
if [[ -f "$CREW_DIR/WORKFLOW.md" ]]; then
    output "$(cat "$CREW_DIR/WORKFLOW.md")"
fi
output ""

# 3. [INPUT] - User's idea
output "---"
output ""
output "# INPUT: IDEA.md"
output ""
output "$(cat "$PROJECT_DIR/IDEA.md")"
output ""

# 4. [STATE] - Project state
output "---"
output ""
output "# STATE: INDEX.md"
output ""
if [[ -f "$PROJECT_DIR/INDEX.md" ]]; then
    output "$(cat "$PROJECT_DIR/INDEX.md")"
else
    output "_No INDEX.md found_"
fi
output ""

# 5. [TASKS] - Task list
output "---"
output ""
output "# TASKS: tasks.md"
output ""
# Check both possible locations
if [[ -f "$PROJECT_DIR/.noodlecrew/tasks.md" ]]; then
    output "$(cat "$PROJECT_DIR/.noodlecrew/tasks.md")"
elif [[ -f "$PROJECT_DIR/TODO.md" ]]; then
    output "$(cat "$PROJECT_DIR/TODO.md")"
else
    output "_No tasks file found_"
fi
output ""

# 6. [CONTEXT] - Previous artifacts
output "---"
output ""
output "# CONTEXT: Previous Artifacts"
output ""
DOCS_DIR="$PROJECT_DIR/docs"
if [[ -d "$DOCS_DIR" ]]; then
    ARTIFACTS=$(find "$DOCS_DIR" -name "*.md" -type f 2>/dev/null | sort)
    if [[ -n "$ARTIFACTS" ]]; then
        for artifact in $ARTIFACTS; do
            rel_path="${artifact#$PROJECT_DIR/}"
            output "## $rel_path"
            output ""
            output "$(cat "$artifact")"
            output ""
        done
    else
        output "_No previous artifacts_"
    fi
else
    output "_No docs directory_"
fi
output ""

# 7. [TEMPLATES] - Output formats
output "---"
output ""
output "# TEMPLATES"
output ""
output "Use these templates for your output:"
output ""
TEMPLATES_DIR="$EXPERT_DIR/templates"
if [[ -d "$TEMPLATES_DIR" ]]; then
    for template in "$TEMPLATES_DIR"/*.md; do
        if [[ -f "$template" ]]; then
            template_name=$(basename "$template")
            output "## Template: $template_name"
            output ""
            output '```markdown'
            output "$(cat "$template")"
            output '```'
            output ""
        fi
    done
else
    output "_No templates directory_"
fi
output ""

# 8. [INSTRUCTION] - Final instruction
output "---"
output ""
output "# INSTRUCTION"
output ""
output "You are now executing as **$EXPERT**."
output ""
output "1. Read the TASKS section above"
output "2. Find the FIRST unchecked task \`[ ]\` in your phase"
output "3. Execute ONLY that one task"
output "4. Create the artifact in \`docs/discovery/\` (or appropriate phase directory)"
output "5. Update the task to \`[x]\` in \`.noodlecrew/tasks.md\`"
output "6. Update INDEX.md with progress"
output "7. Commit with: \`git add . && git commit -m \"feat(discovery): <task>\"\`"
output "8. Stop. Do not continue to the next task."
output ""
output "**START NOW.** Read your tasks and execute."
