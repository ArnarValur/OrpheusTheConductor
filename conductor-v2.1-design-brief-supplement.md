# Conductor v2.1 — Design Brief Supplement

> **Purpose:** Second-pass review of [`conductor-v2.1-design-brief.md`](./conductor-v2.1-design-brief.md). Captures seams introduced during the v2.0-audit revision pass and recommends concrete patches before implementation begins.
>
> **Created:** 2026-05-25 — session continuation after `e20ad7b9`
> **Status:** 🟡 Apply seams S1–S5 + polish items, then promote to ✅.
> **Read alongside:** the main brief is the source of truth; this supplement only addresses what changed between the v2.0 audit pass and now.

---

## Pass-through verification

All seven items from the v2.0 audit landed cleanly in the main brief:

| Audit item | Landed as |
|---|---|
| Consolidate `project-context.md` + lockstep file updates | D7 + deliverables #6, #7 |
| v2.0 → v2.1 migration path | D9 |
| `/checkpoint` becomes ADR gate | D11 + deliverable #4 |
| Lock down `/grill` vs `/conductor` intent boundaries | "Intent Routing" section |
| Reader/writer contract frontmatter | "Reader/Writer Contracts" section + per-deliverable bullet |
| Define `conductor/docs/` or drop it | D12 |
| Promote `context-map.md` validation gate to no-op-today | D5 final paragraph |
| `/grill` re-entry contract | Deliverable #1 |
| Shared index-sync protocol | "Shared Protocol: Index Sync" section + deliverable #8 |
| Round-trip + migration verification | Verification items #9, #10, #11 |

The deliverables list (1–9) maps cleanly onto the decisions. The structural choices (D7, D9, D11, D5 forward-compat gate) are sound.

---

## Seams introduced by the revision

### S1: D3 ↔ D11 overlap could cause duplicate ADR prompts

**The seam:** D3 says `/grill` and `/new-track` batch ADR proposals at end of command. D11 says `/checkpoint` also classifies decisions into ADR/operational/ephemeral. Without scoping, the two can collide.

**Scenario:** User runs `/grill`, approves 2 of 3 ADR candidates (rejects 1). Later runs `/checkpoint`. Does `/checkpoint` re-surface the rejected candidate? Re-surface the approved ones? Surface only new decisions made since `/grill`?

**Patch (apply to D11):**

> `/checkpoint` only processes decisions **not already handled by a command-end batch**. Concretely: it reads `pulse.md` Session Memory entries written during free-form work (while no batching command was active). Decisions surfaced and either approved or rejected by a prior `/grill` or `/new-track` ADR batch are NOT re-surfaced — they're considered settled (approved → in `adr/`, rejected → dropped intentionally).

**Why it matters:** without this, a user who deliberately rejects an ADR proposal in `/grill` will see it again in `/checkpoint`, eroding trust in the batching UX.

---

### S2: Deliverable #9 is itself a drift target

**The seam:** Deliverable #9 (`protocols/reader-writer-contracts.md`) is described as a "central registry" that hand-mirrors the contracts already declared in each workflow's frontmatter. The moment a workflow's contract changes without a parallel registry update, the system drifts — the exact failure mode the lazy-index protocol was designed to avoid.

**Patch:**

> **Drop deliverable #9.** The frontmatter blocks ARE the source of truth. A separate hand-maintained registry creates a second sync target. If a registry view is desired later, make it the **generated output** of a future `conductor-doctor` command (already mentioned in the Reader/Writer Contracts section), not a hand-maintained doc.

**Why it matters:** v2.1 is fundamentally about eliminating sync targets (consolidating `product.md`/`tech-stack.md`/`product-guidelines.md`, unifying decision logs, single source of truth for domain language). A hand-maintained contract registry would reintroduce the same drift pattern v2.1 is fixing.

---

### S3: `project-context.md` has no documented update path

**The seam:** D7 and the hierarchy table say `project-context.md` is "Written once by `/conductor-init`, updated rarely." But no v2.1 command writes to it post-init. If the user switches frameworks (Pinia → Vuex), changes brand voice, or adjusts a caution level, they hand-edit. That's fine — but it isn't stated, and the wording implies the file is read-only after init.

**Patch (apply to D7 + hierarchy table):**

> Change "Written once by `/conductor-init`" → **"Created by `/conductor-init`; user-edited thereafter (no command writes here)."**

**Why it matters:** prevents agents from refusing to read user edits ("the file is owned by init") or auto-regenerating user-modified content. Also gives the user explicit license to maintain this file by hand.

---

### S4: D5's validation gate insertion point is vague

**The seam:** D5 says `/new-track` Step 2 (Domain Selection) validates against `context-map.md`. But today's `workflows/new-track.md` Step 2 parses `tracks.md` for existing domains. The new validation needs to sit *before* that logic, otherwise `tracks.md` domains can shadow the context-map check.

**Patch (apply to deliverable #3):**

> Insert validation as a **new Step 2a, before existing Step 2** domain parsing:
>
> 1. Step 2a (new): If `context-map.md` exists, validate the proposed domain against registered context names. If invalid, halt with a list of valid contexts. If `context-map.md` does not exist, skip silently.
> 2. Step 2 (existing): Parse `tracks.md` for existing domains and present them to the user.
>
> Order matters — `context-map.md` is the authoritative source for multi-context projects, `tracks.md` is descriptive only.

**Why it matters:** without explicit ordering, the validation can be implemented "after" the existing parsing and end up rubber-stamping whatever the user typed into `tracks.md`, defeating the purpose.

---

### S5: Merged `project-context.md` needs an explicit section order

**The seam:** D7 says merge Product Definition, Guidelines, Tech Stack into the existing operational template. That produces an 8-section file. Without a deliberate order, it reads as a dump — and worse, agents reading the file may read top-down and weight the wrong sections.

**Patch (apply to deliverable #7):**

> Define section order in the merged `templates/project-context.md`:
>
> 1. **Product Definition** (identity)
> 2. **Product Guidelines** (brand voice, UX, accessibility)
> 3. **Tech Stack** (languages, frameworks, deployment)
> 4. **Caution Levels** (operational)
> 5. **Domain Expertise** (operational)
> 6. **Preferred Workflows** (operational)
> 7. **Project-Specific Constraints**
> 8. **Environment Notes**
>
> **Mental model: identity-first, operational-second.** Mirrors "what is this product → how should agents behave when working on it."

**Why it matters:** when agents partial-read a file (token budget, context window), they read top-to-bottom. Identity sections must be readable in the first chunk; operational guardrails come after. Reverse order means agents miss product intent on shallow reads.

---

## Minor polish

### P1: `conductor/docs/` write semantics

**Current (D12):** "read-only to all commands except explicit user-driven writes."

**Issue:** "explicit user-driven writes" is undefined.

**Patch:**

> v2.1 has **no command** that writes to `conductor/docs/`. Humans write there directly with their editor. Agents must not auto-generate content here. If a future command needs to write documentation, it requires its own decision record.

### P2: D9 step 3 trigger phrasing

**Current:** *"If separate `product.md`, `product-guidelines.md`, `tech-stack.md` exist (v2.0 README structure)..."*

**Issue:** The v2.0 audit (D7) revealed that **no v2.0 project actually follows the README structure** — `conductor-init.md` always merged into `project-context.md`. So calling it "v2.0 README structure" misleads. The migration is still defensive (v1 Oracle projects, manual user edits), but the trigger should be neutral.

**Patch:**

> Change *"If separate `product.md`, `product-guidelines.md`, `tech-stack.md` exist (v2.0 README structure)"* → *"If any of `product.md`, `product-guidelines.md`, or `tech-stack.md` exist as separate files (from pre-v2.0 Oracle or manual user edits)"*.

### P3: Verification #11 lacks a "how"

**Current:** *"Reader/writer contract validation — for each workflow, verify its declared reads/writes match actual file operations."*

**Issue:** No mechanism specified.

**Patch:**

> Add: *"Method: manual cross-check during implementation, comparing each workflow's frontmatter to the file operations it actually performs. Automated validation via `conductor-doctor` is deferred to a later track."*

### P4: Reader/Writer Contracts scope

**Current:** *"Every workflow file gets a frontmatter block."*

**Issue:** Doesn't say whether protocols (`protocols/*.md`) also get contracts.

**Patch:**

> Clarify: **workflows only.** Protocols are reference docs invoked by workflows, so their I/O is covered transitively by the calling workflow's contract. This keeps the contract surface small and unambiguous.

---

## Recommended track split for implementation

Once S1–S5 + P1–P4 are patched into the main brief, implementation can be carved into six tracks. Track 1 is the prerequisite; tracks 2–6 can interleave since they touch different files.

| # | Track ID | Scope |
|---|---|---|
| 1 | `oracle_v2.1_foundation_20260525` | D7 consolidation + deliverables #6, #7, #8 (file-resolution, lockstep template updates, `index-sync` protocol). **Prerequisite for all others.** |
| 2 | `oracle_v2.1_grill_skill_20260525` | Deliverable #1 — new `/grill` skill |
| 3 | `oracle_v2.1_init_upgrade_20260525` | Deliverable #2 + D9 migration — `/conductor-init` v2.1 with brownfield targeted scan |
| 4 | `oracle_v2.1_new_track_domain_aware_20260525` | Deliverable #3 + S4 patch — domain-aware `/new-track` with context-map validation gate |
| 5 | `oracle_v2.1_checkpoint_adr_gate_20260525` | Deliverable #4 + D11 + S1 patch — `/checkpoint` as decision classifier |
| 6 | `oracle_v2.1_conductor_resume_20260525` | Deliverable #5 — `/conductor` reads new files + defensive index reconcile |

**Domain:** `oracle` (or `conductor` — pick one and add to `tracks.md`).
**Caution level:** 🟡 Careful — these tracks touch the orchestrator itself, mistakes propagate to every downstream project.

---

## Final verdict

The main brief is in genuinely good shape. The decisions are load-bearing and consistent. With S1–S5 + P1–P4 applied, this becomes implementation-ready with no remaining seams I can see from a static review.

The remaining unknowns are runtime unknowns — things that only emerge when you actually run `/conductor-init` on a brownfield project, or when `/grill` produces its first batch of ADRs in anger. The verification plan covers those, and any new findings can be patched into the brief (or a future v2.2 brief) as they surface.

**Sign-off recommendation:** apply the patches in this supplement, bump the brief's "Revised" header to note this second pass, flip status to ✅, and create track 1 (`oracle_v2.1_foundation_20260525`).

---

## Cross-references

- Main brief: [`conductor-v2.1-design-brief.md`](./conductor-v2.1-design-brief.md)
- Current implementation plan (v2.0): [`implementation_plan.md`](./implementation_plan.md)
- v2.0 workflows being upgraded:
  - [`workflows/conductor-init.md`](./workflows/conductor-init.md)
  - [`workflows/conductor.md`](./workflows/conductor.md)
  - [`workflows/new-track.md`](./workflows/new-track.md)
  - [`workflows/checkpoint.md`](./workflows/checkpoint.md)
- v2.0 protocol being updated: [`protocols/file-resolution.md`](./protocols/file-resolution.md)
- v2.0 templates being updated: [`templates/project-context.md`](./templates/project-context.md), [`templates/index.md`](./templates/index.md)
