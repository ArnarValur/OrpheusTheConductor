---
name: the-oracle
description: "TheOracle — Spec-driven development orchestrator for Merkurial-studio. Scaffolds projects with consolidated identity/operational context, a domain glossary, and architectural decision records. Manages domain-aware tracks, enforces workflow discipline, and maintains living documentation. Instantiate into any project via /conductor-init."
---

# TheOracle

> Spec-driven development orchestrator for Merkurial-studio.
> Per-project conductors are instantiated when a project needs structured development orchestration.

## What This Skill Does

TheOracle manages the full lifecycle of spec-driven software development:

1. **Setup** — Interactive project scaffolding (identity + operational context, tech stack, guidelines, workflow, optional brownfield domain scan)
2. **Domain refinement** — Repeatable `/grill` sessions sharpen `context.md`, batch architectural decisions into `adr/`, and lazily produce `prd.md` as scope crystallizes
3. **New Track** — Define a feature/bug/chore with a *domain-aware* spec (reads `context.md`, `adr/`, `prd.md`) and a phased implementation plan
4. **Implement** — Execute tasks from the plan following the project workflow with git-tracked checkpoints
5. **Review** — Code review against style guides, spec compliance, and security
6. **Revert** — Git-aware undo of tracks, phases, or individual tasks
7. **Status** — Progress dashboard across all tracks
8. **Checkpoint** — Save session state; classify accumulated decisions into ADR / pulse / drop

## When to Use

- Starting a new project that needs structured development
- Refining the domain language or capturing an architectural decision
- Beginning a new feature or bug fix
- Resuming work on an existing track
- Reviewing completed work before deployment
- Checking overall project progress

## How to Use

### Step 1: Determine Operation

Based on the user's intent, select the appropriate action:

| User intent                                              | Action |
|----------------------------------------------------------|--------|
| "Set up conductor" / new project                         | Read [workflows/conductor-init.md](../../workflows/conductor-init.md) |
| "Where am I, what's next?" / resume                      | Read [workflows/conductor.md](../../workflows/conductor.md) |
| "Let's think about the product/domain/decisions" / grill | Read [workflows/grill.md](../../workflows/grill.md) |
| "I want to build X" / new feature / new track            | Read [workflows/new-track.md](../../workflows/new-track.md) |
| "Start working" / "implement" / "continue task"          | Read [protocols/implement.md](../../protocols/implement.md) |
| "Review" / "check my code"                               | Read [protocols/review.md](../../protocols/review.md) |
| "Undo" / "revert" / "roll back"                          | Read [protocols/revert.md](../../protocols/revert.md) |
| "Status" / "progress" / "where are we"                   | Read [protocols/status.md](../../protocols/status.md) |
| "Save state" / "checkpoint"                              | Read [workflows/checkpoint.md](../../workflows/checkpoint.md) |

### Step 2: Load Context

Before executing any protocol, load the [File Resolution Protocol](../../protocols/file-resolution.md) to locate conductor files within the project. Lazy files (`context.md`, `prd.md`, `adr/*`, `context-map.md`) may legitimately not exist yet — absence is a valid state.

### Step 3: Execute

Read the selected protocol file and follow its instructions precisely. Each protocol is self-contained with numbered steps, decision trees, and error handling.

When a workflow creates a new lazy file, append the corresponding link to `conductor/index.md` per [`protocols/index-sync.md`](../../protocols/index-sync.md). Never write a dead link.

## Templates

The [templates/](../../templates/) directory contains scaffolding materials used during project setup:

- `templates/workflow-strict.md` — Full TDD workflow (Red → Green → Refactor, >80% coverage)
- `templates/workflow-light.md` — Lighter workflow for prototypes (Plan → Execute → Verify)
- `templates/project-context.md` — Consolidated identity + operational context (v2.1 section order)
- `templates/index.md` — Dynamic project context index template
- `templates/code_styleguides/` — Language-specific style guides (9 languages)

## Per-Project Structure (v2.1)

When conductor is initialized in a project, it creates:

```text
project-root/
├── .agents/workflows/          ← Antigravity slash commands
│   ├── conductor.md            ← /conductor (resume + defensive index reconcile)
│   ├── conductor-init.md       ← /conductor-init (setup + brownfield domain scan)
│   ├── grill.md                ← /grill (domain refinement + ADR batching)
│   ├── new-track.md            ← /new-track (domain-aware spec + plan)
│   └── checkpoint.md           ← /checkpoint (ADR gate + state save)
├── conductor/                  ← Project conductor state
│   ├── index.md                ← Dynamic index (lazy links via protocols/index-sync.md)
│   ├── project-context.md      ← Consolidated identity + operational (no command writes here post-init)
│   ├── workflow.md             ← Development workflow (strict or light)
│   ├── context.md              ← Domain glossary (lazy)
│   ├── context-map.md          ← Bounded-context map (optional, multi-context only)
│   ├── prd.md                  ← Living product requirements (lazy)
│   ├── adr/                    ← Architectural decision records (batched)
│   │   └── .gitkeep
│   ├── docs/                   ← Long-form human-authored docs (no command writers)
│   │   └── .gitkeep
│   ├── agent-rules/            ← Book-sourced coding rules (optional, from agent-rules plugin)
│   ├── code_styleguides/       ← Language style guides (copied at init)
│   ├── pulse.md                ← Session memory
│   ├── pulse-archive/          ← Archived session states
│   ├── relay.md                ← Cross-session handoff log
│   ├── tracks.md               ← Tracks registry
│   └── tracks/                 ← Track directories
│       └── <domain>/<snake_case>_<YYYYMMDD>/
│           ├── index.md
│           ├── spec.md         ← Domain-aware
│           ├── plan.md
│           └── metadata.json
```

## Critical Rules

1. **The Plan is the Source of Truth** — All work is tracked in `plan.md` within the active track.
2. **`project-context.md` is created at init, user-edited thereafter** — no command writes here post-init. User edits are authoritative.
3. **Domain-aware before grilling for a track** — `/new-track` MUST read `context.md`, `adr/`, and `prd.md` (if they exist) before its spec interview.
4. **ADRs are batched at command end** — `/grill` and `/new-track` accumulate decisions during their session and present a single batch for approval at the end of the command invocation. `/checkpoint` only handles decisions NOT already processed by a batch (no double-prompting).
5. **`conductor/docs/` has no command writers** — humans write there directly. Agents must not auto-generate content there.
6. **No dead links in `index.md`** — every link must point to a file that exists on disk. Use [`protocols/index-sync.md`](../../protocols/index-sync.md) when adding links.
7. **Follow the Workflow** — Defer to `conductor/workflow.md` for the task lifecycle (strict or light mode).
8. **Validate Every Tool Call** — If any operation fails, halt and inform the user.
9. **Europe-West1** — All Firebase Functions deploy to `europe-west1` (Norway).
