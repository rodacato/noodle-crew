# Architecture

> How NoodleCrew works under the hood.

---

## System Overview

NoodleCrew is an orchestrator that coordinates AI experts to produce product artifacts. It's not a single AI call — it's a loop that manages state, delegates to experts, and builds documentation incrementally.

```
┌─────────────────────────────────────────────────────────────────────┐
│                         NOODLECREW SYSTEM                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐         │
│  │   manifest   │    │    State     │    │   Experts    │         │
│  │    .yml      │    │  INDEX.md    │    │  EXPERT.md   │         │
│  │              │    │  TODO.md     │    │  templates/  │         │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘         │
│         │                   │                   │                  │
│         └───────────────────┼───────────────────┘                  │
│                             │                                      │
│                             ▼                                      │
│                    ┌────────────────┐                              │
│                    │  Execution     │                              │
│                    │  Loop          │◄──────────────────┐          │
│                    └────────┬───────┘                   │          │
│                             │                           │          │
│                             ▼                           │          │
│                    ┌────────────────┐          ┌───────┴────────┐ │
│                    │  LLM Call      │          │  Termination   │ │
│                    │  (Claude/      │          │  Check         │ │
│                    │   Gemini)      │          └────────────────┘ │
│                    └────────┬───────┘                              │
│                             │                                      │
│                             ▼                                      │
│                    ┌────────────────┐                              │
│                    │  Artifacts     │                              │
│                    │  docs/         │                              │
│                    │  questions/    │                              │
│                    └────────────────┘                              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## The Execution Loop

When you run `ncrew run`, NoodleCrew starts an autonomous loop (inspired by DLP's "Ralph Wiggum Loop"). Each iteration does one unit of work.

### Loop Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                       EXECUTION LOOP                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  START                                                              │
│    │                                                                │
│    ▼                                                                │
│  ┌─────────────────────────────────────────┐                       │
│  │ 1. LOAD STATE                           │                       │
│  │    - Read INDEX.md (current phase)      │                       │
│  │    - Read TODO.md (pending tasks)       │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 2. DETERMINE CURRENT TASK               │                       │
│  │    - Which phase are we in?             │                       │
│  │    - What's the next unchecked task?    │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 3. SELECT EXPERT                        │                       │
│  │    - Load EXPERT.md for current phase   │                       │
│  │    - Load templates for output format   │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 4. BUILD PROMPT CONTEXT                 │                       │
│  │    - IDEA.md (original input)           │                       │
│  │    - EXPERT.md (role definition)        │                       │
│  │    - Templates (output format)          │                       │
│  │    - Previous artifacts (context)       │                       │
│  │    - INDEX.md (project state)           │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 5. CALL LLM                             │                       │
│  │    - Send prompt to Claude/Gemini       │                       │
│  │    - Receive response                   │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 6. PARSE RESPONSE                       │                       │
│  │    - Extract artifacts (markdown files) │                       │
│  │    - Detect blockers (questions)        │                       │
│  │    - Validate output format             │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 7. WRITE ARTIFACTS                      │                       │
│  │    - Save to docs/{phase}/              │                       │
│  │    - Create questions/ if blocker       │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 8. UPDATE STATE                         │                       │
│  │    - Mark task complete in TODO.md      │                       │
│  │    - Update INDEX.md (artifacts, phase) │                       │
│  │    - Increment iteration counter        │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 9. GIT COMMIT                           │                       │
│  │    - Stage changed files                │                       │
│  │    - Commit with message:               │                       │
│  │      "feat(phase): task (iteration N)"  │                       │
│  └────────────────────┬────────────────────┘                       │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────┐                       │
│  │ 10. CHECK TERMINATION                   │                       │
│  │                                         │                       │
│  │    All phases complete?  ───────────► EXIT (success)            │
│  │            │                                                    │
│  │            ▼                                                    │
│  │    Human gate reached? ─────────────► PAUSE (await review)      │
│  │            │                                                    │
│  │            ▼                                                    │
│  │    Blocker detected? ───────────────► PAUSE (await answer)      │
│  │            │                                                    │
│  │            ▼                                                    │
│  │    Max iterations? ─────────────────► EXIT (safety limit)       │
│  │            │                                                    │
│  │            ▼                                                    │
│  │    Otherwise ───────────────────────► LOOP (go to step 1)       │
│  │                                         │                       │
│  └─────────────────────────────────────────┘                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Iteration Anatomy

Each iteration is atomic and produces:
- One artifact (or progress toward one)
- One git commit
- Updated state files

```
Iteration 42:
├── Input
│   ├── INDEX.md (phase: architecture, iteration: 41)
│   ├── TODO.md (task: "Define database schema")
│   └── EXPERT.md (software-architect)
│
├── LLM Call
│   └── Prompt: "You are a Software Architect... create ADR for database..."
│
├── Output
│   └── docs/architecture/adrs/002-database.md (new file)
│
├── State Update
│   ├── INDEX.md (iteration: 42, artifacts: +1)
│   └── TODO.md (task: ✅ "Define database schema")
│
└── Git Commit
    └── "feat(architecture): ADR-002 database choice (iteration 42)"
```

---

## Phase Transitions

Phases execute sequentially. The crew moves to the next phase when all tasks in the current phase are complete.

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  DISCOVERY   │         │ ARCHITECTURE │         │IMPLEMENTATION│
│              │         │              │         │              │
│  ☑ PRD       │         │  ☑ ADR-001   │         │  ☐ CHANGELOG │
│  ☑ Personas  │  ────►  │  ☑ ADR-002   │  ────►  │  ☐ Specs     │
│  ☑ Vision    │         │  ☐ ADR-003   │         │  ☐ Notes     │
│              │         │              │         │              │
│   COMPLETE   │         │  IN PROGRESS │         │   PENDING    │
└──────────────┘         └──────────────┘         └──────────────┘
                               │
                               │ human_gate: architecture
                               │
                               ▼
                         ┌──────────────┐
                         │    PAUSE     │
                         │ for review   │
                         └──────────────┘
```

### Human Gates

When `human_gates` includes a phase, the loop pauses after completing that phase:

```yaml
# manifest.yml
validation:
  human_gates:
    - architecture  # Pause after architecture, before implementation
```

This lets you review ADRs before the Developer expert starts creating specs.

---

## Blocker Handling

When an expert encounters something it can't resolve autonomously, it creates a blocker:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        BLOCKER FLOW                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Expert detects ambiguity                                           │
│         │                                                           │
│         ▼                                                           │
│  ┌──────────────────────────────────────────┐                      │
│  │ Create questions/architect-001-auth.md   │                      │
│  │                                          │                      │
│  │ # Authentication Strategy                │                      │
│  │                                          │                      │
│  │ ## Question                              │                      │
│  │ Should we use OAuth2 or custom JWT?      │                      │
│  │                                          │                      │
│  │ ## Options                               │                      │
│  │ A) OAuth2 with Auth0                     │                      │
│  │ B) Custom JWT implementation             │                      │
│  │                                          │                      │
│  │ ## Your Answer                           │                      │
│  │ [Write your choice here]                 │                      │
│  └──────────────────────────────────────────┘                      │
│         │                                                           │
│         ▼                                                           │
│  Update INDEX.md: status = "blocked"                                │
│         │                                                           │
│         ▼                                                           │
│  PAUSE execution                                                    │
│         │                                                           │
│         ▼                                                           │
│  User writes answer in questions/ file                              │
│         │                                                           │
│         ▼                                                           │
│  User runs: ncrew resume                                            │
│         │                                                           │
│         ▼                                                           │
│  Loop continues with answer as context                              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

Blockers are **rare** by design. The crew is opinionated and makes reasonable decisions. It only asks when:
- There's genuine ambiguity that affects architecture
- Requirements conflict with each other
- Business decisions are outside technical scope

---

## Components Deep Dive

### State Files

| File | Purpose | Modified By |
|------|---------|-------------|
| `INDEX.md` | Master state: phase, iteration, artifacts, blockers | Crew |
| `TODO.md` | Task checklist per phase | Crew |

### Configuration

| File | Purpose | Modified By |
|------|---------|-------------|
| `manifest.yml` | Experts, LLMs, phases, gates | User |
| `CREW.md` | Crew metadata (for marketplace) | User |
| `PHASES.md` | Phase overview (human-readable) | User |

### Expert Units

Each expert is self-contained:

```
.noodlecrew/experts/product-owner/
├── EXPERT.md          # Role definition (prompt)
└── templates/         # Output formats
    ├── prd.md
    └── personas.md
```

See [Expert Format](../reference/expert-format.md) for the complete EXPERT.md specification.

### Phase Definitions

Each phase defines what tasks to execute:

```
.noodlecrew/phases/discovery/
└── PHASE.md           # Tasks for this phase
```

---

## LLM Integration

NoodleCrew calls LLMs through their respective CLIs:

| Provider | CLI | Model Options |
|----------|-----|---------------|
| Claude | `claude` (Claude Code CLI) | claude, claude-opus-4.5 |
| Gemini | `gemini` (Vertex AI CLI) | gemini-2.5-flash, gemini-2.5-pro |

### Prompt Structure

Each LLM call includes:

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PROMPT CONTEXT                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  SYSTEM:                                                            │
│  [Contents of EXPERT.md - role definition]                          │
│                                                                     │
│  CONTEXT:                                                           │
│  - Project idea: [IDEA.md]                                          │
│  - Current phase: [from INDEX.md]                                   │
│  - Previous artifacts: [relevant docs/ files]                       │
│  - Output template: [from templates/]                               │
│                                                                     │
│  TASK:                                                              │
│  [Specific task from TODO.md]                                       │
│                                                                     │
│  CONSTRAINTS:                                                       │
│  - Be opinionated, don't ask unnecessary questions                  │
│  - Follow the template format exactly                               │
│  - Document rationale for decisions                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Cost and Limits

The loop has safety limits:

| Limit | Default | Config Key |
|-------|---------|------------|
| Max iterations | 100 | `execution.max_iterations` |
| Max cost | $30.00 | `execution.max_cost` |

Costs are tracked in INDEX.md and the loop exits if limits are reached.

---

## Resuming Execution

When paused (human gate or blocker), resume with:

```bash
ncrew resume
```

This:
1. Reads current state from INDEX.md
2. Checks if blocker has been answered
3. Continues the loop from where it paused

---

## Further Reading

- [Expert Format](../reference/expert-format.md) — EXPERT.md specification
- [Project Structure](../reference/project-structure.md) — All generated files
- [Philosophy](philosophy.md) — Why this architecture
