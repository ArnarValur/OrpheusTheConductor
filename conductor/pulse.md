# Pulse — Current Project State

**Last Updated:** 2026-07-11 03:18
**Session Focus:** Autonomous overnight v3.0 port — Phases 1–4 executed while the Captain slept (rename sweep · primitive port · plugin packaging · migration protocol)

## 🚀 Active Tracks
- **Orpheus v3.0 Port** (`v3_port_20260711`, domain `platform` 🔴) — **Phases 1–3 complete; Phase 4 protocol complete, pilot + live-verify deferred (supervised).**
  - P1 ✅ rename clean surface → Orpheus v3.0 + Light self-host (ADR 0006)
  - P2 ✅ `ask_question` → `AskUserQuestion`; retired legacy `.agents/workflows/` + `workflows/`
  - P3 ✅ packaged as Claude Code plugin (`.claude-plugin/`, `commands/`, marketplace) — `claude plugin validate .` passes (ADR 0007)
  - P4 ⏸️ `protocols/migrate.md` authored + wired into `/conductor-init` & `/conductor`; DittoDatto pilot deferred

## ✅ Recently Completed
- Grill: drew the v3.0 scope line (re-platform only; backlog → "v3.1 Hardening" in PRD), added `Protocol` glossary term
- Created + executed the v3.0 Port track across 4 phases — 6 commits (`b03098b` → `6c00c6a`) on branch `hermes/magical-spence-348695`
- Recorded ADR 0006 (Light self-host mode) + ADR 0007 (plugin packaging / marketplace layout) — **7 ADRs total**

## ⚠️ Blockers / Awaiting Supervised Action
- **Live plugin verification** — `claude --plugin-dir <orpheus-repo>`, then confirm `/orpheus:conductor` (+ the other four) register in Claude Code CLI **and** Cowork. Only the user can run this; it closes Phase 3's acceptance.
- **DittoDatto pilot migration** — deferred by design (separate live repo carrying real secrets, outside this worktree). Runbook ready: `tracks/platform/v3_port_20260711/dittodatto-pilot.md`. Closes Phase 4.

## 🧠 Session Memory
- Project initialized with Conductor
- Root-cause analysis: workflows didn't register as slash commands because YAML frontmatter was broken or missing entirely
- ~~Workflows must be self-contained — protocols inlined because `protocols/` is never deployed~~ **superseded by ADR 0002/0004: protocols now ship un-inlined inside the plugin**
- `conductor-init` is a skill (`skills/conductor-init/SKILL.md` → `workflow.md`); the other four are commands
- *2026-05-27* — Chose `ask_question` API in `/grill` for rich GUI selectors _(operational; **ported to `AskUserQuestion` in Phase 2**)_
- *2026-05-27* — Unixplor still needs manual workflow file update _(operational)_
- *2026-05-28 - 09:17* — Added time-of-day to session memory, scratchpad scaffolding, cleaned up /hermes references _(operational)_
- *2026-06-18 - 23:56* — Fixed decision batch quiz: inline classification; checkpoint Step 3 is safety-net sweep. Deployed to 11 checkpoint + 10 conductor files across 10 projects _(operational)_
- *2026-07-11 - 01:59* — DittoDatto measurement: relay.md 22K tokens/66 entries no guardrail; pulse 14K at 188/200 lines (lines ≠ tokens); 42 ADRs = 15K eager-loaded; tracks.md 7.3K; dual diverging sub-PRDs; forked ADR numbering, 0014 missing _(operational)_
- *2026-07-11 - 01:59* — v3.0 improvement backlog → now captured in PRD "Deferred to v3.1 — Hardening" _(operational)_
- *2026-07-11 - 03:18* — **Autonomous overnight run** (user asleep; granted "sail through all phases + subagents"). Executed v3.0 port P1–P4 in worktree branch `hermes/magical-spence-348695`. Held one boundary: did NOT run the live DittoDatto migration (separate repo + secrets + needs interactive verify). Structural facts (from claude-code-guide research): plugin manifest = `.claude-plugin/plugin.json`; plugin commands live in `commands/` (`.claude/commands/` deprecated for plugins); marketplace = `.claude-plugin/marketplace.json`; commands namespace `/orpheus:<name>`. Layout: plugin-at-root, repo doubles as marketplace `merkurial-studio`, source `"."`. `plugin.json` omits homepage/repository/license (no git remote yet). Deleting `workflows/` in P2 created 2 dangling refs (SKILL.md, protocols/new-track.md) — both fixed. Used 4 subagents (Command-port · plugin-schema research · conductor-init path rewrite · README rewrite), all diff-verified _(operational)_

## 📋 Next Session Suggestions (morning)
1. **Verify the plugin live** — `claude --plugin-dir <orpheus-repo>`, confirm all five Commands register (CLI + Cowork); fix any manifest/discovery issue. Closes Phase 3.
2. **Run the DittoDatto pilot** (supervised) — follow `dittodatto-pilot.md`; secrets-first per ADR 0005. Closes Phase 4.
3. Fill `plugin.json` `homepage`/`repository`/`license` once a git remote exists.
4. Then: merge the port branch; migrate the ~9 remaining v2.x projects; start v3.1 Hardening. (Carried over: Unixplor workflow files.)
