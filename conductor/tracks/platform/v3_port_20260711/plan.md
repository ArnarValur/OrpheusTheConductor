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

## Phase 2 — Primitive Port

- [ ] Task: Port `ask_question` → `AskUserQuestion` in all five Commands
    - [ ] Map each call to the schema (question / header / options / multiSelect)
    - [ ] Fit prompts to limits: ≤ 4 questions per modal, 2–4 options each
- [ ] Task: Retire `.agents/workflows/` deploy-target references in Commands + templates
- [ ] ✅ Verify: smoke-test each Command's modals render and return correctly

## Phase 3 — Plugin Packaging + Distribution

- [ ] Task: Author `plugin.json` manifest (Orpheus identity, v3.0.0, Commands + skills)
- [ ] Task: Author `marketplace.json` (git-sourced marketplace — the Orpheus repo doubles as its marketplace)
- [ ] Task: Bundle Protocols **un-inlined** inside the plugin (`protocols/` directory)
- [ ] Task: Finalize distribution mechanics — resolve the PRD open question (git-sourced marketplace vs local)
- [ ] ✅ Verify: local install → all five Commands register in **CLI + Cowork**

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
