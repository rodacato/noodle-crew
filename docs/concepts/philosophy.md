# Philosophy

> Why NoodleCrew exists and the principles that guide its design.

---

## The Problem

Going from idea to validated prototype is painful:

1. **Context Switching Tax** — You constantly shift between Product thinking, Architecture decisions, Implementation, and Documentation. Each switch has cognitive overhead.

2. **Documentation as Afterthought** — It's always "I'll document it later." Later never comes. When it does, it's incomplete and outdated.

3. **Inconsistency Gap** — What you designed ≠ what you implemented. Requirements drift, architecture decisions get lost, the prototype doesn't match the original vision.

4. **Boilerplate Overhead** — Weeks of setup before you can validate the core concept. By the time you have a prototype, you've lost momentum.

## The Vision

**What if a complete team of AI experts could take your idea and autonomously produce a functional prototype with professional documentation?**

Not a coding assistant. A full product team:
- **Product Owner** who understands your problem and defines requirements
- **Software Architect** who makes technical decisions and documents rationale
- **Developer** who creates implementation specifications

All working together, handing off context, documenting everything, committing to git.

You write an idea. You get back a PRD, architecture decisions, implementation specs, and a prototype. With complete audit trail.

---

## Core Principles

### 1. Artifacts Before Code

**Documentation and design BEFORE implementation.**

This is the single most important principle, adopted from [DLP](https://github.com/edgarjs/dlp) (Edgar's Development Lifecycle Protocol).

Why it matters:
- **Forces intentional thinking** — You can't hand-wave decisions when you have to write them down
- **Reduces refactoring** — Changing a design doc is cheaper than changing code
- **Creates handoff material** — If you hire a developer, they have complete specs
- **Builds institutional knowledge** — Decisions survive the project

In practice:
```
❌ Bad:  Idea → Code → (maybe) Documentation
✅ Good: Idea → PRD → ADRs → Specs → Code
```

### 2. Vault-Native

**Markdown files + Git as source of truth.**

Why markdown:
- **Human-readable** — Open any file, understand the state
- **AI-friendly** — LLMs work natively with text
- **Tool-agnostic** — Works with any editor, any platform
- **Portable** — Copy a folder, you have everything

Why git:
- **Audit trail** — Every change is tracked
- **Branching** — Experiment without risk
- **Collaboration** — Standard workflow everyone knows
- **Backup** — Push to remote, never lose work

No databases. No cloud sync. No proprietary formats. Just files.

### 3. Autonomous but Auditable

**The crew runs without you, but you can see everything.**

Autonomy:
- Crew makes reasonable decisions using best practices
- Only asks for truly critical blockers
- Continues working while you sleep

Auditability:
- Every decision documented in ADRs
- Every iteration committed to git
- Every artifact follows templates
- Full execution logs

You're not locked out. You can intervene at any time. But you don't have to.

### 4. Opinionated Defaults

**The crew decides and documents rationale rather than asking for every detail.**

What the crew does NOT ask:
- Tech stack? → Uses React + TypeScript + Tailwind (industry standard)
- Database? → Uses PostgreSQL (scalable, well-documented)
- Styling? → Uses Tailwind (utility-first, rapid prototyping)
- Minor decisions? → Applies YAGNI, KISS, best practices

What the crew DOES ask:
- Ambiguity that affects the entire architecture
- Direct conflicts in the original idea
- Business decisions outside technical scope

The philosophy: **"Better to decide and document rationale than to ask for every detail."**

If you disagree with a decision, it's documented. You can change it. But you don't have to answer 50 questions before the crew can start.

---

## Framework vs Crew

**NoodleCrew is the framework. A crew is a configuration.**

This distinction is important:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    NOODLECREW (Framework)                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Defines:                                                           │
│  ├── Crew manifest (.noodlecrew/manifest.yml)                 │
│  ├── Execution process (iteration loop)                            │
│  ├── Supported LLMs (Claude, Gemini, etc.)                         │
│  └── Extension points (experts/, phases/, templates/)              │
│                                                                     │
│  Does NOT define:                                                   │
│  ├── Which experts to use (EXPERT.md)   → You decide               │
│  ├── Which phases to run (PHASE.md)     → You decide               │
│  ├── What templates produce (TEMPLATE.md) → You decide             │
│  └── How they all work together         → You decide               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         CREWS (Configurations)                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │ default  │  │ saas-b2b │  │ fintech  │  │ your own │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
│                                                                     │
│  Each crew is just ONE way to configure the framework:             │
│  - Different experts                                                │
│  - Different phases                                                 │
│  - Different LLM assignments                                        │
│  - Different prompts and templates                                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### What This Means for You

The **default crew** (3 experts, Claude, standard phases) is just an example. You can:

| Attribute | Default Crew | You Can... |
| --------- | ------------ | ---------- |
| `experts/` | 3 (PO, Architect, Dev) | Add 20 custom experts via EXPERT.md |
| `phases/` | 3 (discovery, arch, impl) | Create PHASE.md for `ideation`, `validation`, `launch` |
| `templates/` | Standard formats | Match your company's format via TEMPLATE.md |
| `default_llm` | claude | Use gemini, or mix both per expert |

**The only limits are what the framework supports, not what the default crew uses.**

### Why This Matters

1. **Don't feel constrained** — The guides use the default crew as a teaching example, but you're not limited to it.

2. **Marketplace crews are starting points** — They're pre-configured for specific use cases, but you own the files and can modify everything.

3. **Create your own workflow** — If your product development process is different, configure NoodleCrew to match it.

See [Marketplace](../marketplace/index.md) for how to customize.

---

## Inspiration & Attribution

NoodleCrew stands on the shoulders of giants:

### DLP (Development Lifecycle Protocol)

**Source:** [github.com/edgarjs/dlp](https://github.com/edgarjs/dlp) by Edgar

The primary inspiration. DLP introduced:
- **Dual-path workflow** — Standard (full ceremony) vs Minimal (quick prototypes)
- **Phase anchoring** — Explicitly declare phase before generating output
- **Artifacts before code** — Design documents before implementation
- **Template-driven outputs** — Standardized formats reduce ambiguity
- **Cross-cutting as layer** — Security/Performance/Accessibility are filters, not phases
- **Ralph Wiggum Loop** — Infinite autonomous execution loop

**Key difference:** DLP is developer-centric (takes requirements, generates code). NoodleCrew is product-centric (takes idea, generates complete product artifacts).

### CrewAI

**Source:** [github.com/joaomdmoura/crewAI](https://github.com/joaomdmoura/crewAI)

Demonstrated viability of multi-agent orchestration:
- Role definitions for specialized agents
- Task delegation patterns
- Agent communication protocols

**Key difference:** CrewAI is a general-purpose framework. NoodleCrew is opinionated for product development, vault-native, and markdown-first.

### Shape Up (Basecamp)

**Source:** [basecamp.com/shapeup](https://basecamp.com/shapeup)

Product development methodology:
- **Appetites** — Fixed time, variable scope
- **Pitches** — Structured idea format
- **Hill charts** — Progress visualization

**Key difference:** Shape Up is for human teams. NoodleCrew applies similar principles to AI crews.

### Superpowers

**Source:** [github.com/obra/superpowers](https://github.com/obra/superpowers)

Modular skill system:
- **SKILL.md** — Self-describing skill manifests
- **Automatic activation** — Skills trigger without configuration
- **Anti-patterns** — Teaching what NOT to do

**Key influence:** The CREW.md manifest format for marketplace crews.

### Moltbot

**Source:** [github.com/moltbot/moltbot](https://github.com/moltbot/moltbot)

Multi-channel AI gateway:
- **Hub-and-spoke** — Multiple platforms, single brain
- **Skills registry** — Declarative discovery
- **Chat interface** — Conversational control

**Key influence:** Future Telegram bot and multi-channel support (Phase 5).

---

## What NoodleCrew is NOT

**Not a coding assistant.** Tools like Cursor and Claude Code help you write code. NoodleCrew generates complete product artifacts: PRDs, architecture decisions, specs.

**Not a no-code platform.** No-code tools generate apps from visual builders. NoodleCrew generates specifications that developers can implement.

**Not enterprise-grade.** This is a pet project for rapid prototyping. Don't expect production-ready code or 99.9% uptime.

**Not a replacement for human judgment.** The crew makes reasonable decisions, but you should review critical artifacts. The system is designed for auditability precisely so you can intervene.

---

## The Name

**NoodleCrew** — Part of the neural-noodle ecosystem.

Why "noodle":
- Neural networks → brain → noodle (playful connection)
- Tangled complexity → untangled clarity (what the tool does)
- Pet project vibes (clear this is experimental)
- Memorable and unique (easy to search, no conflicts)

The noodle theme is consistent but not forced. Playful without being cringe.

---

## Further Reading

- [Architecture](architecture.md) — System design and components
- [Glossary](glossary.md) — Key terms defined
- [Anti-Patterns](../guides/anti-patterns.md) — Common mistakes to avoid
- [DLP Repository](https://github.com/edgarjs/dlp) — Original inspiration
