#!/bin/bash
# NoodleCrew - Manual Expert Runner
#
# Uso: ./scripts/run-expert.sh <expert> <project-dir> [--dry-run]
# Ejemplo: ./scripts/run-expert.sh product-owner examples/landing-saas
#
# Opciones:
#   --dry-run  Muestra el prompt sin ejecutar claude

set -e

EXPERT=$1
PROJECT_DIR=$2
CREW_DIR="marketplace/default"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validar argumentos
if [[ -z "$EXPERT" || -z "$PROJECT_DIR" ]]; then
  echo -e "${YELLOW}NoodleCrew - Manual Expert Runner${NC}"
  echo ""
  echo "Uso: $0 <expert> <project-dir> [--dry-run]"
  echo ""
  echo "Expertos disponibles:"
  echo "  - product-owner      (Discovery phase)"
  echo "  - software-architect (Architecture phase)"
  echo "  - developer          (Implementation phase)"
  echo ""
  echo "Ejemplo:"
  echo "  $0 product-owner examples/landing-saas"
  echo "  $0 product-owner examples/landing-saas --dry-run"
  exit 1
fi

# Validar que el experto existe
if [[ ! -f "$ROOT_DIR/$CREW_DIR/experts/$EXPERT/EXPERT.md" ]]; then
  echo -e "${RED}Error: Experto '$EXPERT' no encontrado${NC}"
  echo "Buscado en: $ROOT_DIR/$CREW_DIR/experts/$EXPERT/EXPERT.md"
  exit 1
fi

# Validar que el proyecto existe
if [[ ! -f "$ROOT_DIR/$PROJECT_DIR/IDEA.md" ]]; then
  echo -e "${RED}Error: $PROJECT_DIR/IDEA.md no encontrado${NC}"
  exit 1
fi

if [[ ! -f "$ROOT_DIR/$PROJECT_DIR/.noodlecrew/tasks.md" ]]; then
  echo -e "${RED}Error: $PROJECT_DIR/.noodlecrew/tasks.md no encontrado${NC}"
  exit 1
fi

if [[ ! -f "$ROOT_DIR/$PROJECT_DIR/INDEX.md" ]]; then
  echo -e "${RED}Error: $PROJECT_DIR/INDEX.md no encontrado${NC}"
  exit 1
fi

# Leer contenido de los archivos
EXPERT_CONTENT=$(cat "$ROOT_DIR/$CREW_DIR/experts/$EXPERT/EXPERT.md")
WORKFLOW_CONTENT=$(cat "$ROOT_DIR/$CREW_DIR/WORKFLOW.md")
IDEA_CONTENT=$(cat "$ROOT_DIR/$PROJECT_DIR/IDEA.md")
TASKS_CONTENT=$(cat "$ROOT_DIR/$PROJECT_DIR/.noodlecrew/tasks.md")
INDEX_CONTENT=$(cat "$ROOT_DIR/$PROJECT_DIR/INDEX.md")

# Construir el prompt
PROMPT="# Expert Definition

$EXPERT_CONTENT

---

# Workflow Instructions

$WORKFLOW_CONTENT

---

# Project Context

## IDEA.md

$IDEA_CONTENT

---

## Tasks (.noodlecrew/tasks.md)

$TASKS_CONTENT

---

## INDEX.md

$INDEX_CONTENT

---

# Your Turn

You are working in the project directory. Execute your next task following the workflow instructions above.

Remember:
1. Read .noodlecrew/tasks.md to find your next unchecked task
2. Do ONE task only
3. Create artifacts in docs/
4. Update .noodlecrew/tasks.md and INDEX.md
5. Commit your changes
6. End your turn"

# Modo dry-run
if [[ "$3" == "--dry-run" ]]; then
  echo -e "${BLUE}========================================"
  echo " NoodleCrew Dry-Run (prompt preview)"
  echo "========================================${NC}"
  echo ""
  echo "$PROMPT"
  exit 0
fi

# Ejecutar con Claude
echo -e "${GREEN}========================================"
echo " NoodleCrew Expert Runner"
echo "========================================${NC}"
echo -e " Expert:  ${YELLOW}$EXPERT${NC}"
echo -e " Project: ${YELLOW}$PROJECT_DIR${NC}"
echo "========================================"
echo ""

cd "$ROOT_DIR/$PROJECT_DIR"
echo -e "${BLUE}Ejecutando claude...${NC}"
echo ""

claude -p "$PROMPT" --allowedTools "Edit,Write,Bash"
