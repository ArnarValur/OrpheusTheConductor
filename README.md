# Orpheus v3.2

> A conductor, not a copilot.

Orpheus is a spec-driven development orchestrator. It doesn't write your code — it orchestrates the workflow around it: **spec → plan → implement → review → checkpoint** — under a hard context budget.

**Why it exists, in numbers:** the heaviest consumer of the old shape booted with a **~78K-token** hot set (unbounded relay, history-carrying pulse, eager ADR loads). After a full audit and rebuild, a v3.1 boot is budgeted at **300–400 lines** (~this repo boots at ~340). The whole design is downstream of that audit.

> *Not affiliated with [conductor.build](https://conductor.build) (the parallel-agents Mac app). The `conductor/` here is a per-repo state directory — the name predates the collision in our own stack.*

## What is Orpheus?

Orpheus gives a project a structured, spec-driven backbone: a domain glossary, architectural decision records, a living PRD, and a lifecycle for feature tracks from specification through implementation, review, and completion. State lives in a per-project `conductor/` directory and travels with the repo via Git.

Formerly **TheOracle** (through v2.1), v3.0 re-platformed from Google Antigravity to the Claude ecosystem — **Claude Code + Cowork**. It ships as a Claude Code plugin named `orpheus`, distributed through a git-sourced marketplace named `merkurial-studio`. The repo *is* both the plugin (at its root) and the marketplace. **v3.1** (2026-08-05) rebuilds the conductor shape around two laws, generalized from DittoDatto's field-tested rebuild:

1. **One fact, one home.** Live truth in `pulse.md`, the session story once in `relay.md`, lessons in `agent-rules/`, decisions in ADRs or track-plan D-numbers. Never retell — point.
2. **A ruling binds only when it lands in a repo file.** Agent memory is a cache.

Init also emits self-contained `/conductor` and `/checkpoint` commands into each repo's `.claude/commands/` — initialized projects boot and checkpoint **without any plugin dependency**.

Pure markdown and shell — no runtime dependencies.

## Install

Three ways to install, depending on your setup.

**From the marketplace:**

```
/plugin marketplace add ArnarValur/OrpheusTheConductor
/plugin install orpheus@merkurial-studio
```

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
| `/conductor-init` | Scaffold a project's Conductor and emit its `/conductor` + `/checkpoint` commands. On existing conductors: upgrade structure in place, hand the human a migration checklist. Also wires an Obsidian vault wrapper at `~/Documents/Project-Vaults/<project>/` (`conductor` + `memory` symlinks) when that folder exists. Shipped as a Skill. |
| `/conductor` | Boot: load the hot set (~300–400 lines), report ~10-line status, await orders. |
| `/grill` | Domain-refinement session: sharpen the glossary, batch ADRs, update the PRD. |
| `/new-track` | Create a domain-aware track (spec + phased plan with D-numbers). |
| `/checkpoint` | Rewrite pulse, tell the session story once in relay, graduate lessons, fold to main. |

> As plugin commands, these are namespaced `/orpheus:<name>` (e.g. `/orpheus:conductor`). The bare `/<name>` form also works when there's no naming collision. In initialized repos, the emitted `.claude/commands/` copies of `/conductor` and `/checkpoint` take the bare names — plugin and emitted copies carry the same shape (`templates/commands/` is the source of truth).

## The Agent

| Agent | Purpose |
|-------|---------|
| `drift-watchdog` | Read-only background monitor (Sonnet). Fires proactively after commits or feature work in any repo carrying `conductor/pulse.md`; checks stale pulse, code commits since the conductor was last touched, tracks-registry vs. plan mismatch, and hot-set cap breaches. Reports ≤ 8 lines only when something is actionable — otherwise one no-op line. Never writes. (ADR 0009) |

`/conductor` also warns at boot when the pulse's `Updated:` date is more than 14 days old — the Agent covers the session, the boot warning covers its start.

## Workflow Modes

Orpheus operates in one of two modes, selected at init:

- **Strict** — test-driven, with coverage gates. For products and production codebases.
- **Light** — flexible iteration, with verification checkpoints. For prototypes and experiments.

## The `conductor/` Directory

Each initialized project carries its Orpheus state in a `conductor/` directory:

| Path | Role |
|------|------|
| `project-context.md` | Project identity + operational context (user-owned after init) |
| `context.md` | Domain glossary (lazy) |
| `adr/` | Architectural decision records — proposed-and-approved only |
| `prd.md` | Living product requirements (lazy) |
| `tracks.md` + `tracks/` | One-liner registry + track folders (spec, plan, D-numbers) |
| `pulse.md` | Live state only — ~60-line cap, rewritten each checkpoint, never appended |
| `relay.md` | The session story, told once — one entry ≤10 lines per session |
| `agent-rules/` | Graduated lessons — `technical.md` (auto), `behavioral.md` (ask first) |
| `pulse-archive/` | Trimmed relay entries and old state |
| `index.md` | Static Hot/Warm/Cold map |

Conductor state travels with each repo via Git. Secrets stay out — `docs/keys/`, `*.env`, and `.obsidian/` are gitignored.

## Migrating

**From v2.x (TheOracle / Antigravity):** re-run `/conductor-init`. It runs `protocols/migrate.md` (retires `.agents/workflows/` copies, preserves `conductor/` state), then continues into the v3.1 structural upgrade below.

**From the v3.0 shape:** re-run `/conductor-init`. Structure is upgraded in place (static index, emitted commands, two laws, missing directories) with **all state preserved**; pulse/relay reshaping is handed to you as a checklist — state migration takes judgment, so it is never regenerated.

## Status

v3.0 port from Antigravity: **complete**. Current shape: **v3.1** (conductor rebuild, 2026-08-05, ADR 0008); **v3.2** adds the drift-watchdog Agent and the stale-pulse boot warning (2026-09-15, ADR 0009). Old init source archived under `.archived/init-source-pre-rebuild-20260805/`.

This repo **self-hosts**: its own `conductor/` runs the v3.1 shape it ships. Reading `conductor/pulse.md`, `relay.md`, and `adr/` is the live demo.

## License

MIT — see [LICENSE](./LICENSE).
