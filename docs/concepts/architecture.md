# Architecture

> How NoodleCrew works under the hood.

---

## The Core Idea

NoodleCrew runs **autonomous expert agents** in a loop. Each expert is a one-shot command that:

- Receives full context (phase, pending tasks, previous artifacts)
- Decides what to do next
- Does the work (creates files, updates state, commits)
- Ends its turn

The loop simply restarts experts until all work is done.

---

## The Execution Loop

When you run `ncrew run`, this happens:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    RALPH WIGGUM LOOP                                 │
│                 (inspired by DLP)                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  START                                                              │
│    │                                                                │
│    ▼                                                                │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 1. BUILD EXPERT PROMPT                                      │   │
│  │                                                             │   │
│  │    Combine:                                                 │   │
│  │    - EXPERT.md (role: "You are a Product Owner...")        │   │
│  │    - Current phase from manifest.yml                        │   │
│  │    - IDEA.md (original input)                               │   │
│  │    - Previous artifacts (docs/*)                            │   │
│  │    - Instructions: "Read TODO.md, do ONE task, commit"      │   │
│  │                                                             │   │
│  └────────────────────────┬────────────────────────────────────┘   │
│                           │                                         │
│                           ▼                                         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 2. LAUNCH EXPERT (one-shot autonomous command)              │   │
│  │                                                             │   │
│  │    The expert is AUTONOMOUS. It has access to:              │   │
│  │    - File system (read/write)                               │   │
│  │    - Shell commands (git, etc)                              │   │
│  │                                                             │   │
│  │    The expert does ALL of this on its own:                  │   │
│  │    ├── Reads TODO.md to find next task                      │   │
│  │    ├── Decides what to do                                   │   │
│  │    ├── Creates artifacts in docs/                           │   │
│  │    ├── Updates TODO.md (marks task complete)                │   │
│  │    ├── Updates INDEX.md (project state)                     │   │
│  │    ├── Git commit                                           │   │
│  │    └── Ends its turn                                        │   │
│  │                                                             │   │
│  └────────────────────────┬────────────────────────────────────┘   │
│                           │                                         │
│                           ▼                                         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 3. LOG OUTPUT                                               │   │
│  │    Save expert's work to .noodlecrew/logs/                  │   │
│  └────────────────────────┬────────────────────────────────────┘   │
│                           │                                         │
│                           ▼                                         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 4. CHECK TERMINATION                                        │   │
│  │                                                             │   │
│  │    All phases complete?  ───────────► EXIT (success)        │   │
│  │            │                                                │   │
│  │            ▼                                                │   │
│  │    Human gate reached? ─────────────► PAUSE (await review)  │   │
│  │            │                                                │   │
│  │            ▼                                                │   │
│  │    Blocker file created? ───────────► PAUSE (await answer)  │   │
│  │            │                                                │   │
│  │            ▼                                                │   │
│  │    Max iterations? ─────────────────► EXIT (safety limit)   │   │
│  │            │                                                │   │
│  │            ▼                                                │   │
│  │    Otherwise ───────────────────────► LOOP (go to step 1)   │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Key insight:** The orchestrator doesn't parse responses or manage state. The expert is fully autonomous — it reads TODO.md, does one task, updates everything, and ends. The loop just restarts it.

---

## Expert Prompt Structure

Each expert receives a prompt like this:

```markdown
## Role

You are an expert Product Owner. Your specialty is translating vague ideas
into clear product requirements.

## Context

We are developing [from IDEA.md]. The project is currently in the Discovery
phase. Here are the existing artifacts:
- docs/discovery/prd.md (completed)
- docs/discovery/personas.md (in progress)

## Instruction

> **NOTE**: You are building this without supervision, so don't prompt for
> user input. If in doubt, use your best judgment. If you end your turn,
> you'll be restarted automatically.

Execute the next task:

1. Read `TODO.md` to find the next uncompleted task
2. Choose **only one** task and complete it
3. Create/update artifacts in `docs/discovery/`
4. Update `TODO.md` to mark the task complete
5. Commit your changes: `feat(discovery): <task description>`
6. End your turn

**CRITICAL**: You must end your turn after completing ONE task.
Do NOT continue with the next task.

## Constraints

- Be opinionated: make reasonable decisions, don't ask
- Document rationale: explain WHY, not just WHAT
- Only create blockers for genuine ambiguity
```

The expert is a self-contained worker. It knows what to do, has access to the filesystem, and manages its own output.

---

## What The Orchestrator Does (and Doesn't Do)

### What it does

- Selects which expert to run based on current phase
- Builds the prompt with context
- Launches the expert as a one-shot command
- Logs the output
- Checks termination conditions
- Restarts the loop

### What it does NOT do

- Parse LLM responses
- Extract artifacts from output
- Update state files (expert does this)
- Make git commits (expert does this)
- Decide what task to do next (expert reads TODO.md)

This separation keeps the orchestrator simple and the experts autonomous.

---

## State Files

The orchestrator and experts communicate through markdown files:

| File | Purpose | Who Writes |
| ---- | ------- | ---------- |
| **INDEX.md** | Project state (phase, iteration, status) | Expert |
| **TODO.md** | Task checklist per phase | Expert |
| **questions/** | Blocker files requiring user input | Expert creates, User resolves |
| **CREW_COMPLETE** | Termination signal | Expert |

The orchestrator only *reads* these files to determine what to do next. The expert *writes* them as part of its autonomous work.

See [State Files Reference](../reference/state-files.md) for complete specification.

---

## Phase Transitions

The expert updates TODO.md as it works. When all tasks in a phase are checked off, the loop selects the next phase's expert.

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
       │ human_gate?
       ▼
┌──────────────┐
│    PAUSE     │
│ for review   │
└──────────────┘
```

---

## Human Gates

When `human_gates` includes a phase, the loop pauses after that phase completes:

```yaml
# manifest.yml
validation:
  human_gates:
    - architecture  # Pause after architecture, before implementation
```

---

## Blocker Handling

When an expert creates a file in `questions/`, the loop pauses:

```
Expert detects genuine ambiguity
         │
         ▼
Creates questions/architect-001-auth.md
         │
         ▼
Loop detects blocker file → PAUSE
         │
         ▼
User writes answer in the file
         │
         ▼
User runs: ncrew resume
         │
         ▼
Loop continues (answer is now context)
```

Blockers are **rare** by design. Experts are opinionated and make reasonable decisions. They only ask when there's genuine ambiguity that affects the entire project.

---

## Iteration Example

```
Iteration 42:

1. Loop builds prompt for software-architect expert
   - Includes: EXPERT.md, IDEA.md, docs/discovery/*, TODO.md

2. Expert launches, does its work:
   - Reads TODO.md → finds "ADR-002: Database choice"
   - Creates docs/architecture/adrs/002-database.md
   - Updates TODO.md: ☑ ADR-002
   - Updates INDEX.md: iteration 42, artifact added
   - Commits: "feat(architecture): ADR-002 database choice"
   - Ends turn

3. Loop logs output to .noodlecrew/logs/

4. Loop checks termination:
   - Not all done → restart loop
```

---

## Cost and Limits

Safety limits prevent runaway execution:

| Limit          | Default | Config Key                 |
|----------------|---------|----------------------------|
| Max iterations | 100     | `execution.max_iterations` |
| Max cost       | $30.00  | `execution.max_cost`       |

---

## Resuming Execution

When paused (human gate or blocker):

```bash
ncrew resume
```

This restarts the loop. If there was a blocker, the answer in `questions/` becomes part of the next prompt context.

---

## Why This Architecture?

1. **Simple orchestrator** — Just a loop that restarts experts
2. **Autonomous experts** — Each expert is self-contained and does its own state management
3. **Auditable** — Every change is a git commit
4. **Resumable** — State is in files, not memory

Inspired by [DLP](https://github.com/edgarjs/dlp)'s "Ralph Wiggum Loop" pattern.

---

## Further Reading

- [Expert Format](../reference/expert-format.md) — EXPERT.md specification
- [Project Structure](../reference/project-structure.md) — All generated files
- [Philosophy](philosophy.md) — Why this architecture
