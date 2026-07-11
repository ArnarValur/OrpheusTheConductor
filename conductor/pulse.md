# Pulse — Current Project State

**Last Updated:** 2026-07-11 10:31
**Session Focus:** Morning — live-verified the plugin (all five Commands register), merged the v3.0 port to `main`, swapped to a durable user-scope install. Checkpoint.

## 🚀 Active Tracks
- **Orpheus v3.0 Port** (`v3_port_20260711`, domain `platform` 🔴) — **P1–P3 complete + live-verified; merged to `main`. P4 protocol complete; the DittoDatto pilot is a separate rollout task (not on this machine).**
  - P1 ✅ rename → Orpheus v3.0 + Light self-host (ADR 0006)
  - P2 ✅ `ask_question` → `AskUserQuestion`; retired legacy `.agents/workflows/` + `workflows/`
  - P3 ✅ Claude Code plugin — **live-verified**: `claude plugin details orpheus` lists all 5 components; user confirmed Commands register in the palette (ADR 0007)
  - P4 ✅ `protocols/migrate.md` + wiring; pilot deferred to a separate supervised rollout

## ✅ Recently Completed
- **Merged the v3.0 port to `main`** (merge commit `472e632`); reconciled cleanly with the user's own housekeeping commit (`2f08a53`: archived v2.1 design docs → `.archived/`, template whitespace)
- **Live-verified** the plugin: installed via marketplace, all five Commands register with correct descriptions (bare `/name`)
- **Durable install**: swapped the `merkurial-studio` marketplace from the worktree → `main`, `orpheus` now installed **user-scope** (survives worktree cleanup)

## ⚠️ Blockers
- _None._ The port is built, verified, merged, and installed.

## 🧠 Session Memory
- Project initialized with Conductor
- ~~Workflows must be self-contained — protocols inlined~~ **superseded by ADR 0002/0004: protocols ship un-inlined inside the plugin**
- `conductor-init` is a skill (`skills/conductor-init/SKILL.md` → `workflow.md`); the other four are commands
- *2026-05-27* — Unixplor still needs manual workflow file update _(operational)_
- *2026-06-18 - 23:56* — Fixed decision batch quiz: inline classification; checkpoint is safety-net sweep _(operational)_
- *2026-07-11 - 01:59* — DittoDatto measurement: relay unbounded, pulse lines≠tokens, ADRs eager-loaded → captured in PRD "Deferred to v3.1 — Hardening" _(operational)_
- *2026-07-11 - 03:18* — Autonomous overnight run (granted "sail through all phases + subagents"). Executed v3.0 port P1–P4; held the boundary of not running the live DittoDatto migration. Plugin facts: manifest `.claude-plugin/plugin.json`; commands in `commands/`; marketplace `.claude-plugin/marketplace.json`; layout plugin-at-root, repo doubles as marketplace `merkurial-studio`. 4 subagents used, all diff-verified _(operational)_
- *2026-07-11 - 10:31* — **DittoDatto's keys are intentional.** The keys under `conductor/docs/keys/` (and local `.env`) are there on purpose — do NOT flag them as a hazard, scrub them, or alarm about them. ADR 0005's `.gitignore` correctly keeps them *local* (never committed); that's the whole handling. _(preference — user-corrected)_
- *2026-07-11 - 10:31* — Checkpoint: port merged to `main` + durably installed. Worktree branch `hermes/magical-spence-348695` is fully merged and can be `git worktree remove`d (do it from `main`, not mid-session). Future conductor work belongs on `main`. _(operational)_

## 📋 Next Session Suggestions
1. **Retire the worktree** — `git worktree remove` the merged `magical-spence-348695` worktree (from `main`, when convenient).
2. **v2.x rollout** — migrate existing projects (DittoDatto, AgentPollus, Charon, Unixplor, …) via `/conductor-init` + `migrate.md`, each in its own repo/session. Keys stay local, untouched.
3. **Fill `plugin.json`** `homepage`/`repository`/`license` once a git remote exists; consider pushing `main` for PlutoII↔Saturn sync + a real marketplace URL.
4. **Start v3.1 Hardening** (see PRD) when ready.
