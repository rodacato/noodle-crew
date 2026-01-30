---
layout: default
title: NoodleCrew
nav_order: 1
---

# NoodleCrew

> Your AI product team that works while you sleep

NoodleCrew es un sistema de agentes IA autónomos que transforma tu idea en un prototipo documentado. Sin supervisión constante, sin context switching.

---

## Qué es

Un equipo virtual de expertos IA que trabaja de forma autónoma:

```
Tu Idea (markdown)
       ↓
   NoodleCrew
       ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│Product Owner │ → │  Architect   │ → │  Developer   │
│ PRD, Vision  │    │ ADRs, Stack  │    │ Specs, Code  │
└──────────────┘    └──────────────┘    └──────────────┘
       ↓
Prototipo + Documentación Completa
```

---

## Documentación

La documentación está organizada en tres áreas:

### Framework (El Runtime)

Cómo el CLI ejecuta crews — estructura de archivos, loop de ejecución, protocolo de terminación.

| Documento | Descripción |
|-----------|-------------|
| [Overview](framework/overview.md) | Qué garantiza el framework |
| [Project Structure](framework/project-structure.md) | Estructura de directorios |
| [State Files](framework/state-files.md) | INDEX.md, tasks.md, blockers |
| [Execution Loop](framework/execution-loop.md) | El ciclo de ejecución |
| [CLI Commands](framework/cli-commands.md) | Comandos disponibles |

### Crew Development (Crear Crews)

Cómo crear y personalizar crews — expertos, fases, templates.

| Documento | Descripción |
|-----------|-------------|
| [Overview](crew-development/overview.md) | Anatomía de un crew |
| [Expert Format](crew-development/expert-format.md) | Especificación EXPERT.md |
| [Manifest Schema](crew-development/manifest-schema.md) | Configuración manifest.yml |
| [Workflow File](crew-development/workflow-file.md) | Instrucciones WORKFLOW.md |

### Concepts (Filosofía)

Por qué NoodleCrew existe y cómo piensa.

| Documento | Descripción |
|-----------|-------------|
| [Philosophy](concepts/philosophy.md) | Principios de diseño |

### Quick Start

| Documento | Descripción |
|-----------|-------------|
| [Quickstart](getting-started/quickstart.md) | Tutorial de 5 minutos |
| [Marketplace](marketplace/index.md) | Crews pre-configurados |

---

## Cómo usarlo

### Opción 1: Manual (PoC actual)

```bash
# Clonar el repo
git clone https://github.com/rodacato/noodle-crew
cd noodle-crew

# Ver el prompt que se enviaría
./scripts/run-expert.sh product-owner examples/landing-saas --dry-run

# Ejecutar un experto
./scripts/run-expert.sh product-owner examples/landing-saas
```

### Opción 2: CLI (próximamente)

```bash
ncrew init mi-proyecto
ncrew run
ncrew status
```

---

## Principios

1. **Artifacts Before Code** — Documentación primero, código después
2. **Vault-Native** — Markdown + Git como source of truth
3. **Autonomous but Auditable** — Corre solo, pero todo queda registrado
4. **Opinionated Defaults** — El crew decide y documenta el rationale

---

## Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                    RESPONSIBILITY SPLIT                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   FRAMEWORK                         CREW                    │
│   ─────────                         ────                    │
│   • Directory structure             • Expert definitions    │
│   • State file schemas              • Phase sequence        │
│   • Execution loop                  • Task lists            │
│   • Termination protocol            • Templates             │
│                                                             │
│   "HOW it runs"                     "WHAT it runs"          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Ver [FLOW.md](../FLOW.md) para el contrato técnico completo.

---

## Estado del Proyecto

**Fase actual:** Manual PoC

- [x] Diseño y documentación
- [x] Default crew (3 expertos)
- [ ] Validación manual
- [ ] Iterator automatizado
- [ ] CLI tool

Ver [DEVELOPMENT.md](../DEVELOPMENT.md) para el roadmap completo.

---

## Links

- [GitHub](https://github.com/rodacato/noodle-crew)
- [Issues](https://github.com/rodacato/noodle-crew/issues)

---

<p align="center">
  <sub>Part of the neural-noodle ecosystem</sub>
</p>
