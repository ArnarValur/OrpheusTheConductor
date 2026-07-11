# Plan — Orpheus v3.0 Port

> Track: `v3_port_20260711` · Domain: **platform** 🔴 · Mode: **Light** (flexible iteration, verification checkpoints — no TDD gates)
> Four phases, one per pillar, verification woven in.

---

## Phase 1 — Rename Sweep + Self-Host Mode *(foundational)* ✅

- [x] Task: Inventory all `TheOracle` references
    - [x] `grep -ri theoracle` — ~40 hits across 25 files
    - [x] Classify forward-facing (rename) vs historical (preserve) vs mechanism-entangled (defer)
- [x] Task: Rename TheOracle → Orpheus across the clean forward-facing surface
    - [x] Protocol source headers ×7 → `Orpheus v3.0 @ 2026-07-11`
    - [x] `plugin.json` (name `orpheus`, `3.0.0`, v3.0 description) + template headers ×4
    - [x] `project-context.md` — user-approved v3.0 rewrite (identity + tech stack + environment de-staled)
    - [~] Deferred: README + `conductor-init.md` `~/…/TheOracle/` source paths (entangled with Antigravity copy-from-source → **Phase 3**); `workflows/` + `.agents/workflows/` legacy dupes → **Phase 2**
- [x] Task: Rewrite `workflow.md` Strict/TDD → **Light mode** (per ADR 0006)
- [x] ✅ Verify: `grep` clean across renamed set; all remaining refs are intentional history or deferred-by-design

## Phase 2 — Primitive Port ✅

- [x] Task: Port `ask_question` → `AskUserQuestion` in all five Commands
    - [x] `grill.md` — ported 3 `ask_question` refs → `AskUserQuestion` (`multiSelect`, `options` label+description) + retired the dead Antigravity `/grill-me` line
    - [x] conductor / conductor-init / new-track / checkpoint — had no literal primitive; added a uniform `AskUserQuestion` "Interactive prompts" convention (via subagent, diff-verified)
- [x] Task: Retire legacy Antigravity command dirs — `.agents/workflows/` (4) + byte-identical `workflows/` (5) = 9 files deleted (superseded by `.claude/commands/`)
- [~] Verify: static verification done (grep clean, diffs reviewed). **Live modal smoke-test deferred** — needs an interactive session; folds into the Phase 3 install verification the user runs.

## Phase 3 — Plugin Packaging + Distribution ✅ *(live-verified — all five Commands register)*

- [x] Task: Author plugin manifest — `.claude-plugin/plugin.json` (orpheus, v3.0.0, author, keywords)
- [x] Task: Author `.claude-plugin/marketplace.json` (git-sourced marketplace `merkurial-studio`, plugin `source: "."`)
- [x] Task: Restructure to plugin-at-root — `.claude/commands/` → `commands/` (4 Commands) + `conductor-init` as a Skill; Protocols + templates bundled at plugin root, referenced via `${CLAUDE_PLUGIN_ROOT}` (ADR 0007)
- [x] Task: Finalize distribution mechanics — git-sourced marketplace (ADR 0007, resolves the PRD open question)
- [x] Task: Rewrite `README.md` → v3.0 (install, Commands, modes, conductor/ layout, migration)
- [x] ✅ Verify: `claude plugin validate .` + `--strict` pass; installed via local marketplace → `claude plugin details orpheus` lists all 5 components (v3.0.0, enabled); **user confirmed all Commands register live in the CLI palette with correct descriptions, as bare `/name` (2026-07-11 09:4x).** Cowork uses the same plugin — spot-check when convenient.

## Phase 4 — Migration Protocol + DittoDatto Pilot + Acceptance ⏸️ *(protocol authored; pilot deferred to a supervised run)*

- [x] Task: Author `protocols/migrate.md` (detect v2.x · preserve `conductor/` · retire deploy copies · confirm plugin · secrets gitignore · index reconcile)
    - [x] `conductor/.gitignore` shipped to Orpheus itself (`docs/keys/`, `*.env`, `.obsidian/`) per ADR 0005 — dogfooding
- [x] Task: Wire `/conductor-init` → `migrate.md` (Step 1b.0, on v2.x remnants); `/conductor` → signpost remnants (Step 2.6)
- [ ] Task: Pilot-migrate **DittoDatto** — ⏸️ **DEFERRED (supervised)**: separate live repo with real secrets, outside this worktree, needs interactive verification. Runbook ready → [`dittodatto-pilot.md`](./dittodatto-pilot.md)
    - [ ] Branch/backup its conductor state first
    - [ ] Migrate → verify `conductor/` intact, `.agents/workflows/` gone, secrets gitignored
    - [ ] Verify `/conductor` resumes on the plugin
- [~] Task: Acceptance + docs
    - [x] README rewritten to v3.0 (Phase 3); source headers → `Orpheus v3.0` (Phase 1)
    - [ ] Full acceptance checklist — pending live plugin install + the DittoDatto pilot (both supervised)
