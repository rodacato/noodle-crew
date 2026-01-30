# Feedback - NoodleCrew

> Evaluacion multi-perspectiva del proyecto.
> Fecha: 2026-01-30
> Evaluador: Claude (Programador Senior, PM, CTO, Product Marketing)

---

## Resumen Ejecutivo

| Dimension | Score | Veredicto |
|-----------|-------|-----------|
| Arquitectura | 8/10 | Solida, bien pensada |
| Documentacion | 9/10 | Excelente (quizas excesiva) |
| Ejecucion | 3/10 | Solo stubs, nada funcional |
| Posicionamiento | 7/10 | Claro pero overselling |

---

## TODO Priorizado (Critico a Menor)

### P0 - Critico (Bloquea validacion)

- [ ] **Implementar `run-expert.sh` funcional** - El script actual es stub. Sin esto no puedes validar nada.
  - Debe ensamblar prompt real (EXPERT.md + WORKFLOW.md + contexto)
  - Debe ejecutar `claude -p` con el prompt
  - Tiempo estimado: 30-60 min

- [ ] **Ejecutar Product Owner manualmente** - Validar hipotesis core: ¿los prompts funcionan?
  - Observar: ¿sigue instrucciones? ¿crea archivos correctos? ¿actualiza TODO.md?
  - Documentar resultados en `examples/landing-saas/RETROSPECTIVE.md`

- [ ] **Definir metricas de exito del PoC**
  - Calidad: ¿El PRD generado es util?
  - Eficiencia: ¿Cuantas iteraciones necesita?
  - Coherencia: ¿El handoff entre expertos funciona?

### P1 - Alto (Afecta credibilidad)

- [ ] **Cambiar badge de "ALPHA" a "CONCEPT"** - No hay producto que probar, ser honesto
  - Agregar disclaimer: "Design spec in validation phase"

- [ ] **Congelar documentacion** - No mas docs hasta validar PoC
  - El gap documentacion/ejecucion es muy grande

- [ ] **Ejecutar flujo completo PO -> Architect -> Developer**
  - Solo despues de validar PO individualmente

### P2 - Medio (Mejora calidad)

- [ ] **Agregar tests basicos** - Para cuando exista codigo real
  - Al menos smoke tests para scripts

- [ ] **Definir target audience** - ¿Developers solos? ¿Startups? ¿Enterprise?
  - El tono actual oscila entre tecnico y casual

- [ ] **Documentar estrategia de diferenciacion** - ¿Por que NoodleCrew vs CrewAI/AutoGPT?
  - "Vault-native" es tecnico, no es selling point para usuarios

### P3 - Bajo (Nice to have)

- [ ] **Remover features ficticias del README** - El ejemplo de "127 commits" no existe
  - O marcarlo claramente como "ejemplo de output futuro"

- [ ] **Agregar plan de contingencia LLM** - ¿Que pasa si Claude CLI cambia?
  - Documentar dependencias y riesgos

- [ ] **Simplificar manifest.yml** - Tiene features (cost limits, human_gates) que requieren infra no trivial

---

## Feedback Detallado por Perspectiva

### Como Programador Senior

**Lo bueno:**
- Arquitectura elegante: el "Ralph Wiggum Loop" con expertos autonomos es simple y poderoso
- Separacion clara entre framework (runtime) y crews (configuracion) — extensibilidad bien pensada
- Estado en markdown + git es brillante: auditable, portable, sin dependencias externas
- Los scripts estan bien documentados con headers claros (responsabilidades, inputs, outputs, exit codes)

**Preocupaciones:**
- Los scripts son stubs. Mucha documentacion, cero codigo ejecutable. El gap entre vision y realidad es grande.
- No hay tests. Para un proyecto que aspira a ser CLI tool publicado en npm, necesita testing desde ya.
- El `manifest.yml` tiene features (cost limits, human_gates) que requeriran infraestructura no trivial para implementar.

**Sugerencia:** Antes de mas docs, implementa UN flujo end-to-end funcional. Un `run-expert.sh` que realmente ejecute Claude con el prompt ensamblado.

---

### Como Project Manager

**Lo bueno:**
- Roadmap claro: PoC Manual -> Iterator -> CLI. Fases bien definidas.
- TODO.md es excelente — estado real vs percibido claramente separado
- El approach "documentation first" reduce riesgo de scope creep

**Preocupaciones:**
- Llevas 3 dias (27-30 enero) con mucha documentacion pero sin validar la hipotesis core: ¿funcionan los expertos autonomos con los prompts actuales?
- El scope crece: marketplace, multi-LLM, human gates, cost tracking... El MVP se infla antes de validar.

**Riesgo:** Paralisis por analisis. Demasiada documentacion, poca ejecucion.

**Sugerencia:** Congela la documentacion. Las proximas 3-5 horas deben ser ejecutar Product Owner manualmente y ver que pasa. Documentar learnings DESPUES.

---

### Como CTO

**Lo bueno:**
- La apuesta tecnologica es conservadora: shell scripts, markdown, CLIs existentes. Bajo riesgo tecnico.
- No reinventas la rueda — usas Claude/Gemini CLI existentes
- El modelo de negocio "marketplace de crews" tiene potencial (similar a Homebrew taps, NPM scopes)

**Preocupaciones:**
- **Dependencia de LLM capabilities**: Si Claude Code cambia su API o comportamiento, el proyecto se rompe. No tienes control.
- **Falta estrategia de diferenciacion**: CrewAI, AutoGPT, AgentGPT existen. ¿Por que alguien usaria NoodleCrew? La respuesta ("vault-native, markdown-first") es tecnicamente elegante pero no es un selling point para usuarios.
- **No hay metricas definidas**: ¿Como sabras si esto funciona? ¿Que mides?

**Sugerencia:** Define 3 metricas de exito para el PoC:
1. ¿El PRD generado es util? (calidad)
2. ¿Cuantas iteraciones necesita? (eficiencia)
3. ¿El handoff architect->developer funciona? (coherencia)

---

### Como Product Marketing

**Lo bueno:**
- El posicionamiento es claro: "Your AI product team that works while you sleep"
- El problema esta bien articulado (context switching, documentation debt)
- El README tiene buen storytelling con el ejemplo Monday->Friday
- El diagrama visual del flujo PO->Architect->Dev es facil de entender

**Preocupaciones:**
- **Alpha sin producto**: El badge dice "ALPHA" pero no hay nada que probar. Esto dana credibilidad.
- **Target audience difuso**: ¿Es para developers solos? ¿Startups? ¿Enterprise? El tono oscila entre tecnico y casual.
- **El ejemplo de output es ficcion**: El `ncrew run` con "127 commits" no existe. Vender features no implementadas es arriesgado.

**Sugerencia:** Cambia el badge a "CONCEPT" o "DESIGN PHASE". Se honesto: "This is currently a design spec. We're validating the approach manually before building the CLI."

---

## Prompt para Re-evaluacion

Usa este prompt para volver a evaluar el proyecto despues de avances:

```
Actua como un programador senior, un project manager, un CTO y un product marketing.
Analiza este proyecto y dame tus impresiones y sugerencias.

Contexto adicional para re-evaluacion:
- Fecha de evaluacion anterior: 2026-01-30
- Archivo de feedback anterior: FEEDBACK.md
- Compara el estado actual vs el feedback anterior
- Indica que items del TODO se completaron
- Identifica nuevos riesgos o mejoras
```

---

## Historial de Evaluaciones

| Fecha | Evaluador | Arquitectura | Documentacion | Ejecucion | Posicionamiento |
|-------|-----------|--------------|---------------|-----------|-----------------|
| 2026-01-30 | Claude | 8/10 | 9/10 | 3/10 | 7/10 |

---

## Notas

- Este documento debe actualizarse despues de cada evaluacion
- Los TODOs P0 deben completarse antes de la proxima evaluacion
- El objetivo es subir "Ejecucion" de 3/10 a 7/10+ en la proxima iteracion
