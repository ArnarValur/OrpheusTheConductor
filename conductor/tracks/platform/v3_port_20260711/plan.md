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

## Phase 3 — Plugin Packaging + Distribution ✅ *(structure built + CLI-validated; live install pending user)*

- [x] Task: Author plugin manifest — `.claude-plugin/plugin.json` (orpheus, v3.0.0, author, keywords)
- [x] Task: Author `.claude-plugin/marketplace.json` (git-sourced marketplace `merkurial-studio`, plugin `source: "."`)
- [x] Task: Restructure to plugin-at-root — `.claude/commands/` → `commands/` (4 Commands) + `conductor-init` as a Skill; Protocols + templates bundled at plugin root, referenced via `${CLAUDE_PLUGIN_ROOT}` (ADR 0007)
- [x] Task: Finalize distribution mechanics — git-sourced marketplace (ADR 0007, resolves the PRD open question)
- [x] Task: Rewrite `README.md` → v3.0 (install, Commands, modes, conductor/ layout, migration)
- [~] Verify: **`claude plugin validate .` passes** ✓. **Live install → Command registration in CLI + Cowork deferred to the user** (`claude --plugin-dir .`, then `/orpheus:conductor`).

## Phase 4 — Migration Protocol + DittoDatto Pilot + Acceptance

- [ ] Task: Author `protocols/migrate.md`
    - [ ] Detect v2.x · preserve `conductor/` untouched · retire `.agents/workflows/` copies · confirm plugin availability
    - [ ] Ship `conductor/.gitignore` (`docs/keys/`, `*.env`, `.obsidian/`) per ADR 0005
- [ ] Task: Wire `/conductor-init` to invoke `migrate.md` on v2.x detection; `/conductor` to signpost remnants
- [ ] Task: Pilot-migrate **DittoDatto**
    - [ ] Branch/backup its conductor state first
    - [ ] Migrate → verify `conductor/` intact, `.agents/workflows/` gone, secrets gitignored
    - [ ] Verify `/conductor` resumes on the plugin
- [ ] Task: Acceptance + docs
    - [ ] Run the full acceptance-criteria checklist from `spec.md`
    - [ ] Update README + source headers; confirm v3.0 done
