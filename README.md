# Orpheus v3.0

> A conductor, not a copilot.

Orpheus is a spec-driven development orchestrator for Merkurial-studio. It doesn't write your code — it orchestrates the workflow around it: **spec → plan → implement → review → checkpoint**.

## What is Orpheus?

Orpheus gives a project a structured, spec-driven backbone: a domain glossary, architectural decision records, a living PRD, and a lifecycle for feature tracks from specification through implementation, review, and completion. State lives in a per-project `conductor/` directory and travels with the repo via Git.

Formerly **TheOracle** (through v2.1), v3.0 re-platforms from Google Antigravity to the Claude ecosystem — **Claude Code + Cowork**. It ships as a Claude Code plugin named `orpheus`, distributed through a git-sourced marketplace named `merkurial-studio`. The repo *is* both the plugin (at its root) and the marketplace.

Pure markdown and shell — no runtime dependencies.

## Install

Three ways to install, depending on your setup.

**From the marketplace** (once a git remote exists):

```
/plugin marketplace add <orpheus-repo-url>
/plugin install orpheus@merkurial-studio
```

> `<orpheus-repo-url>` is a placeholder — no git remote is configured yet, so this URL is **TBD** until the repo is pushed.

**From a local marketplace** (point at your local checkout):

```
/plugin marketplace add /path/to/orpheus
/plugin install orpheus@merkurial-studio
```

**Local dev** (no marketplace, load the plugin directly):

```
claude --plugin-dir /path/to/orpheus
```

## The Five Commands

| Command | Purpose |
|---------|---------|
| `/conductor-init` | Scaffold or migrate a project's Conductor. Shipped as a Skill; auto-suggests on uninitialized projects. |
| `/conductor` | Resume session context, reconcile the index, and present status. |
| `/grill` | Domain-refinement session: sharpen the glossary, batch ADRs, update the PRD. |
| `/new-track` | Create a domain-aware track (spec + phased plan). |
| `/checkpoint` | Save session state and sweep for unclassified decisions. |

> As plugin commands, these are namespaced `/orpheus:<name>` (e.g. `/orpheus:conductor`). The bare `/<name>` form also works when there's no naming collision.

## Workflow Modes

Orpheus operates in one of two modes, selected at init:

- **Strict** — test-driven, with coverage gates. For products and production codebases.
- **Light** — flexible iteration, with verification checkpoints. For prototypes and experiments.

## The `conductor/` Directory

Each initialized project carries its Orpheus state in a `conductor/` directory:

| Path | Role |
|------|------|
| `project-context.md` | Project identity + operational context |
| `context.md` | Domain glossary |
| `adr/` | Architectural decision records |
| `prd.md` | Living product requirements |
| `tracks.md` + `tracks/` | Work tracks |
| `pulse.md` | Session memory |
| `relay.md` | Cross-session handoff |
| `index.md` | Dynamic index |

Conductor state travels with each repo via Git. Secrets stay out — `docs/keys/`, `*.env`, and `.obsidian/` are gitignored.

## Migrating from v2.x (TheOracle)

Existing Antigravity / TheOracle projects migrate through `/conductor-init` as a brownfield re-init. It runs `protocols/migrate.md`, which:

1. Detects a v2.x project.
2. Preserves the existing `conductor/` state untouched.
3. Retires the old `.agents/workflows/` copies.

## Status

The v3.0 port from Antigravity to the Claude ecosystem is **in progress**.
