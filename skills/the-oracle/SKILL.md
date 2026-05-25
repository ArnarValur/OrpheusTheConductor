---
name: the-oracle
description: "TheOracle — Spec-driven development orchestrator for Merkurial-studio. Scaffolds projects, manages tracks, enforces workflow discipline, and maintains living documentation. Instantiate into any project via /conductor-init."
---

# TheOracle

> Spec-driven development orchestrator for Merkurial-studio.
> Per-project conductors are instantiated when a project needs structured development orchestration.

## What This Skill Does

TheOracle manages the full lifecycle of spec-driven software development:

1. **Setup** — Interactive project scaffolding (product definition, tech stack, guidelines, workflow, initial track)
2. **New Track** — Define a feature/bug/chore, generate spec + phased implementation plan
3. **Implement** — Execute tasks from the plan following the project workflow with git-tracked checkpoints
4. **Review** — Code review against style guides, spec compliance, and security
5. **Revert** — Git-aware undo of tracks, phases, or individual tasks
6. **Status** — Progress dashboard across all tracks

## When to Use

- Starting a new project that needs structured development
- Beginning a new feature or bug fix
- Resuming work on an existing track
- Reviewing completed work before deployment
- Checking overall project progress

## How to Use

### Step 1: Determine Operation

Based on the user's intent, select the appropriate action:

| User Intent | Action |
|---|---|
| "Set up conductor" / new project | Read [workflows/conductor-init.md](../../workflows/conductor-init.md) |
| "New feature" / "new track" / "I want to build X" | Read [workflows/new-track.md](../../workflows/new-track.md) |
| "Resume" / "continue" / "where was I" | Read [workflows/conductor.md](../../workflows/conductor.md) |
| "Start working" / "implement" / "continue task" | Read [protocols/implement.md](../../protocols/implement.md) |
| "Review" / "check my code" | Read [protocols/review.md](../../protocols/review.md) |
| "Undo" / "revert" / "roll back" | Read [protocols/revert.md](../../protocols/revert.md) |
| "Status" / "progress" / "where are we" | Read [protocols/status.md](../../protocols/status.md) |
| "Save state" / "checkpoint" | Read [workflows/checkpoint.md](../../workflows/checkpoint.md) |

### Step 2: Load Context

Before executing any protocol, load the [File Resolution Protocol](../../protocols/file-resolution.md) to locate conductor files within the project.

### Step 3: Execute

Read the selected protocol file and follow its instructions precisely. Each protocol is self-contained with numbered steps, decision trees, and error handling.

## Templates

The [templates/](../../templates/) directory contains scaffolding materials used during project setup:

- `templates/workflow-strict.md` — Full TDD workflow (Red → Green → Refactor, >80% coverage)
- `templates/workflow-light.md` — Lighter workflow for prototypes (Plan → Execute → Verify)
- `templates/project-context.md` — Per-project operational context
- `templates/index.md` — Project context index template
- `templates/code_styleguides/` — Language-specific style guides (9 languages)

## Per-Project Structure

When conductor is initialized in a project, it creates:

```
project-root/
├── .agents/workflows/          ← Antigravity slash commands
│   ├── conductor.md            ← /conductor (resume)
│   ├── conductor-init.md       ← /conductor-init (setup)
│   ├── checkpoint.md           ← /checkpoint (save state)
│   └── new-track.md            ← /new-track (create track)
├── conductor/                  ← Project conductor state
│   ├── index.md                ← Project context index
│   ├── product.md              ← Product definition
│   ├── product-guidelines.md   ← Brand and UX guidelines
│   ├── tech-stack.md           ← Technology choices
│   ├── workflow.md             ← Development workflow (strict or light)
│   ├── project-context.md      ← Operational context and constraints
│   ├── pulse.md                ← Session memory and recent activity
│   ├── relay.md                ← Cross-session handoff log
│   ├── tracks.md               ← Tracks registry
│   ├── tracks/                 ← Track directories
│   │   └── <domain>/
│   │       └── <snake_case>_<YYYYMMDD>/
│   │           ├── index.md
│   │           ├── spec.md
│   │           ├── plan.md
│   │           └── metadata.json
│   └── code_styleguides/       ← Copied from templates
```

## Critical Rules

1. **The Plan is the Source of Truth** — All work is tracked in `plan.md` within the active track
2. **The Tech Stack is Deliberate** — Changes to tech stack must be documented before implementation
3. **Follow the Workflow** — Defer to `conductor/workflow.md` for the task lifecycle (strict or light mode)
4. **Validate Every Tool Call** — If any operation fails, halt and inform the user
5. **Europe-West1** — All Firebase Functions deploy to `europe-west1` (Norway)
