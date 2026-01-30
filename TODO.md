# TODO - NoodleCrew

> Estado real del proyecto y siguiente pasos.
> Actualizado: 2026-01-30

---

## Resumen Ejecutivo

| Area | Estado |
|------|--------|
| Documentacion (.idea/) | COMPLETO |
| Documentacion (docs/) | COMPLETO |
| Default Crew (marketplace/default/) | COMPLETO |
| Prueba Manual (PoC) | PENDIENTE |
| Iterator Automatizado | NO INICIADO |
| CLI Tool (ncrew) | NO INICIADO |

---

## Lo Que Ya Tienes (Avance Real)

### marketplace/default/ - Crew Completo

```
marketplace/default/
├── manifest.yml                    # Configuracion del crew
├── CREW.md                         # Metadata del crew
├── PHASES.md                       # Overview de fases
├── WORKFLOW.md                     # Instrucciones para expertos
├── experts/
│   ├── product-owner/
│   │   ├── EXPERT.md               # Definicion del rol
│   │   └── templates/
│   │       ├── prd.md
│   │       ├── personas.md
│   │       └── vision.md
│   ├── software-architect/
│   │   ├── EXPERT.md
│   │   └── templates/
│   │       ├── adr.md
│   │       ├── architecture.md
│   │       └── tech-stack.md
│   └── developer/
│       ├── EXPERT.md
│       └── templates/
│           ├── changelog.md
│           └── implementation-notes.md
├── phases/
│   ├── discovery/PHASE.md
│   ├── architecture/PHASE.md
│   └── implementation/PHASE.md
└── templates/
    ├── IDEA.md                     # Template para usuario
    ├── INDEX.md                    # Template de estado
    └── TODO.md                     # Template de tareas
```

---

## Tareas Pendientes

### Phase 1: PoC Manual (ACTUAL)

- [x] **Crear scripts/run-expert.sh** (helper para dry-run)
  - Ensambla prompt con EXPERT.md + WORKFLOW.md + contexto del proyecto
  - Soporta `--dry-run` para ver prompt sin ejecutar

- [x] **Crear proyecto ejemplo** (`examples/landing-saas/`)
  - IDEA.md - Landing page para SaaS de notas
  - TODO.md - Tareas por fase
  - INDEX.md - Estado del proyecto
  - Directorios: docs/, questions/

- [ ] **Ejecutar Product Owner** (3 tareas)
  ```bash
  ./scripts/run-expert.sh product-owner examples/landing-saas
  ```
  - [ ] Generate PRD from IDEA.md
  - [ ] Define user personas
  - [ ] Create product vision

- [ ] **Ejecutar Software Architect** (4 tareas)
  ```bash
  ./scripts/run-expert.sh software-architect examples/landing-saas
  ```
  - [ ] ADR-001: Frontend framework
  - [ ] ADR-002: Hosting/deployment
  - [ ] Create architecture overview
  - [ ] Document tech stack

- [ ] **Ejecutar Developer** (2 tareas)
  ```bash
  ./scripts/run-expert.sh developer examples/landing-saas
  ```
  - [ ] Generate CHANGELOG structure
  - [ ] Document implementation steps

- [ ] **Documentar learnings** en `examples/landing-saas/RETROSPECTIVE.md`

### Phase 2: Iterator Automatizado

- [ ] Crear script shell para el loop
- [ ] Implementar build de prompt dinamico
- [ ] Implementar deteccion de terminacion
- [ ] Implementar deteccion de blockers
- [ ] Implementar logging
- [ ] Implementar safety limits (max iterations, max cost)

### Phase 3: CLI Tool

- [ ] Setup proyecto TypeScript/Bun
- [ ] Comando `ncrew init`
- [ ] Comando `ncrew run`
- [ ] Comando `ncrew status`
- [ ] Comando `ncrew resume`
- [ ] Publicar en npm

---

## Sugerencias (como LLM)

### 1. Simplificar el PoC Manual

El WORKFLOW.md es muy bueno pero para probar manualmente, necesitas un script que ensamble el prompt. Sugerencia:

```bash
#!/bin/bash
# scripts/run-expert.sh

EXPERT=$1
PHASE=$2
PROJECT_DIR=$3

# Ensamblar prompt
cat << EOF
$(cat marketplace/default/experts/$EXPERT/EXPERT.md)

---

$(cat marketplace/default/WORKFLOW.md)

---

## IDEA.md
$(cat $PROJECT_DIR/IDEA.md)

---

## TODO.md
$(cat $PROJECT_DIR/TODO.md)

---

## INDEX.md
$(cat $PROJECT_DIR/INDEX.md)
EOF
```

### 2. Falta Conexion Entre docs/ y marketplace/

La documentacion en `docs/reference/project-structure.md` describe una estructura `.noodlecrew/` pero el crew real esta en `marketplace/default/`. Esto puede confundir.

Opciones:

- **A)** Crear `.noodlecrew/` apuntando a marketplace/default (symlinks o copias)
- **B)** Actualizar docs/ para referenciar marketplace/ como source of truth
- **C)** Mantener marketplace/ como "crews distribuibles" y `.noodlecrew/` como "crew instalado en proyecto"

Recomendacion: **Opcion C** - Es el modelo correcto. `marketplace/` son paquetes, `.noodlecrew/` es el crew instalado. `ncrew init` copiaria de marketplace/ a `.noodlecrew/`.

### 4. Probar Con Claude Code Primero

El README menciona `gemini --yolo` pero Claude Code es mas maduro. Sugerencia:

```bash
# Claude tiene mejor manejo de archivos
claude -p "..." --allowedTools "Edit,Write,Bash"

# Gemini despues, para validar multi-LLM
```

### 5. El manifest.yml Necesita Ajustes

El `workflow.context` incluye `WORKFLOW.md` pero el experto deberia recibirlo como parte del prompt, no como archivo adicional. Verificar que el iterator lo inyecte correctamente.

### 6. Templates vs Ejemplos

Los templates en `marketplace/default/experts/*/templates/` son formatos de OUTPUT, no ejemplos completos. Podria ayudar tener:

- `templates/prd.md` - Estructura vacia (actual)
- `examples/prd-example.md` - PRD completado como referencia

Esto ayudaria a los expertos a entender el nivel de detalle esperado.

---

## Orden de Ejecucion Recomendado

```
1. [x] Crear examples/landing-saas/ con IDEA.md, INDEX.md, TODO.md
2. [x] Crear scripts/run-expert.sh para ensamblar prompts
3. [ ] Ejecutar Product Owner manualmente (3 ejecuciones)
4. [ ] Revisar output, ajustar EXPERT.md si necesario
5. [ ] Ejecutar Software Architect (4 ejecuciones)
6. [ ] Revisar, ajustar
7. [ ] Ejecutar Developer (2 ejecuciones)
8. [ ] Documentar learnings en examples/landing-saas/RETROSPECTIVE.md
9. [ ] Iniciar Phase 2 (iterator)
```

---

## Archivos a Revisar/Actualizar

| Archivo | Accion |
|---------|--------|
| DEVELOPMENT.md | Actualizar checkbox de "Default crew" |
| .idea/INDEX.md | Marcar templates como completados |
| docs/reference/project-structure.md | Clarificar marketplace/ vs .noodlecrew/ |

---

## Notas

- El diseño es solido. La arquitectura "Ralph Wiggum Loop" con expertos autonomos es elegante.
- El crew default esta bien estructurado. Los EXPERT.md son claros y opinionated.
- Lo que falta es **probar** que funciona en la practica.
- No te compliques con el CLI todavia. Primero valida manualmente.
