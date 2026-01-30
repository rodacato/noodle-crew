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

Cada experto:
- Lee el estado actual del proyecto
- Hace UNA tarea
- Actualiza los archivos de estado
- Hace commit
- Termina su turno

El loop continúa hasta completar todas las fases.

---

## Cómo funciona

### 1. Escribes tu idea

Crea un archivo `IDEA.md` con el problema, solución y usuarios:

```markdown
# Mi SaaS de Notas

## Problem
Los equipos remotos pierden contexto en sus notas...

## Solution
Una app de notas colaborativas con contexto automático...

## Users
- Equipos remotos de 5-20 personas
- Product managers
```

### 2. El crew trabaja

Cada experto se ejecuta en secuencia:

| Fase | Experto | Produce |
|------|---------|---------|
| Discovery | Product Owner | PRD, Personas, Vision |
| Architecture | Software Architect | ADRs, Tech Stack |
| Implementation | Developer | Specs, Changelog |

### 3. Obtienes artifacts

```
docs/
├── discovery/
│   ├── prd.md
│   ├── personas.md
│   └── vision.md
├── architecture/
│   ├── adrs/
│   │   ├── 001-frontend.md
│   │   └── 002-database.md
│   └── tech-stack.md
└── implementation/
    └── changelog.md
```

Cada archivo tiene commits individuales. Full audit trail.

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

Repite hasta completar todas las tareas de cada fase.

### Opción 2: CLI (próximamente)

```bash
# Inicializar proyecto
ncrew init mi-proyecto

# Ejecutar el crew completo
ncrew run

# Ver estado
ncrew status
```

---

## Principios

1. **Artifacts Before Code** — Documentación primero, código después
2. **Vault-Native** — Markdown + Git como source of truth
3. **Autonomous but Auditable** — Corre solo, pero todo queda registrado
4. **Opinionated Defaults** — El crew decide y documenta el rationale

---

## Documentación

| Sección | Descripción |
|---------|-------------|
| [Quickstart](getting-started/quickstart.md) | Tutorial de 5 minutos |
| [Philosophy](concepts/philosophy.md) | Por qué existe NoodleCrew |
| [Architecture](concepts/architecture.md) | Cómo funciona el loop |
| [Configuration](guides/index.md) | Configurar expertos y fases |
| [Expert Format](reference/expert-format.md) | Especificación EXPERT.md |
| [Marketplace](marketplace/index.md) | Crews pre-configurados |

---

## Estado del Proyecto

**Fase actual:** Manual PoC

- [x] Diseño y documentación
- [x] Default crew (3 expertos)
- [ ] Validación manual
- [ ] Iterator automatizado
- [ ] CLI tool

Ver [DEVELOPMENT.md](https://github.com/rodacato/noodle-crew/blob/master/DEVELOPMENT.md) para el roadmap completo.

---

## Links

- [GitHub](https://github.com/rodacato/noodle-crew)
- [Issues](https://github.com/rodacato/noodle-crew/issues)

---

<p align="center">
  <sub>Part of the neural-noodle ecosystem</sub>
</p>
