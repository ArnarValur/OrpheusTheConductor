# Plan — Orpheus v3.0 Port

> Track: `v3_port_20260711` · Domain: **platform** 🔴 · Mode: **Light** (flexible iteration, verification checkpoints — no TDD gates)
> Four phases, one per pillar, verification woven in.

---

## Phase 1 — Rename Sweep + Self-Host Mode *(foundational)*

- [ ] Task: Inventory all `TheOracle` references
    - [ ] Run `grep -ri theoracle` and enumerate the ~20 hits
    - [ ] Classify **forward-facing** (rename) vs **historical** (ADRs/relay — preserve verbatim)
- [ ] Task: Rename TheOracle → Orpheus across forward-facing files
    - [ ] Source headers → `# Source: Orpheus v3.0 @ <date>`
    - [ ] `plugin.json` name/description, README, templates, glossary references
    - [ ] `project-context.md` v2.1 header + "Antigravity" text — *user-owned: confirm the edit, do not silently rewrite identity prose*
- [ ] Task: Rewrite `workflow.md` Strict/TDD → **Light mode** (per ADR 0006)
- [ ] ✅ Verify: `grep -ri theoracle` clean except intentional legacy/AKA mentions

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
