# Protocol: New Track

<!-- Source: Orpheus v3.0 @ 2026-07-11 -->

> Reference protocol for creating a new track (feature, bug, chore, spike) with spec and phased implementation plan.
>
> **Canonical execution lives in [`commands/new-track.md`](../commands/new-track.md)** — this protocol is the underlying reference that the slash command implements. v2.1 added domain-awareness, ADR batching, and the S4 context-map gate to the slash command; this protocol captures the contract that any implementation must honor.

## 1.0 System Directive

You are an AI agent assistant for the Conductor framework. Your task is to guide the user through creating a new Track, generating the specification (`spec.md`) and plan (`plan.md`), and organizing them within a dedicated track directory.

**CRITICAL:** Validate every tool call. Halt on failure.

---

## 1.1 Setup Check

1. Using the [File Resolution Protocol](./file-resolution.md), resolve and verify:
   - **Product & Operational Context** (`conductor/project-context.md`)
   - **Workflow** (`conductor/workflow.md`)
2. If either is missing → Announce "Conductor is not set up. Run `/conductor-init` first." → Halt.
3. Load v2.1 lazy context (absence is valid):
   - **Domain Glossary** (`conductor/context.md`)
   - **Context Map** (`conductor/context-map.md`)
   - **Product Requirements** (`conductor/prd.md`)
   - **ADR Directory** (`conductor/adr/`)

---

## 2.0 New Track Initialization

### 2.1 Get Track Description and Determine Type

1. **Load Project Context:** Read `conductor/project-context.md` and any of the v2.1 lazy files that exist (`context.md`, `prd.md`, `adr/*`).
2. **Get Track Description:** If user provided one, use it. Otherwise ask: "Please provide a brief description of the track you wish to start."
3. **Infer Track Type:** Classify as `feature`, `bug`, `chore`, or `spike`. Do NOT ask the user to classify it.

### 2.2a Context-Map Validation Gate (S4 — D5 forward-compat)

**Runs BEFORE Step 2.2.** Without this ordering, `tracks.md` domains can shadow the context-map check.

1. If `conductor/context-map.md` does NOT exist, skip silently.
2. If it exists, validate the proposed domain (when provided) against registered context names. Invalid domain → halt with the list of valid contexts.

### 2.2 Domain Selection

1. **Parse existing domains:** Read `conductor/tracks.md` and list existing domain directories under `conductor/tracks/`.
2. **Present options:**
   - List existing domains (e.g., `auth`, `ui`, `api`, `infra`).
   - Offer "Create new domain".
3. **If new domain:** Ask user for domain name (lowercase, kebab-case). If `context-map.md` exists, the new domain must match a registered context name (re-enter 2.2a with the proposal).

### 2.3 Interactive Specification Generation (`spec.md`)

1. **Announce:** "I'll guide you through questions to build a comprehensive specification for this track."
2. **Questioning Phase (domain-aware in v2.1):**
   - Ask questions sequentially (one at a time, wait for response).
   - Reference `project-context.md`, `context.md` (use glossary terms verbatim), `adr/*` (propose ADR-consistent options), and `prd.md` (anchor scope to in-scope items, avoid out-of-scope items).
   - Present 2-3 options (A/B/C) plus "Type your own answer".
   - Classify each question as "Additive" (select all that apply) or "Exclusive Choice".
   - **Features:** 3-5 questions about implementation, interactions, inputs/outputs.
   - **Other:** 2-3 questions about scope, reproduction steps, success criteria.
3. **Accumulate** new domain terms and ADR candidates during the interview — do NOT write to disk yet.
4. **Draft `spec.md`:** Sections: Overview, Functional Requirements, Non-Functional Requirements, Acceptance Criteria, Out of Scope.
5. **User Confirmation:** Present draft, revise until approved.

### 2.4 Interactive Plan Generation (`plan.md`)

1. **Announce:** "Now I will create an implementation plan based on the specification."
2. **Generate Plan:**
   - Read confirmed spec and Workflow file (`conductor/workflow.md`)
   - Create hierarchical plan: Phases → Tasks → Sub-tasks
   - **CRITICAL:** Structure MUST adhere to Workflow methodology (e.g., strict mode = "Write Tests" + "Implement" sub-tasks per task)
   - Include `[ ]` status markers for EVERY task and sub-task
   - **Inject Phase Completion Tasks:** If Workflow defines a checkpointing protocol, append `- [ ] Task: Conductor - User Manual Verification '<Phase Name>' (Protocol in workflow.md)` to each phase
3. **User Confirmation:** Present draft, revise until approved

### 2.5 Create Track Artifacts and Update Registry

1. **Check for name collision:** List existing track directories in the selected domain. If proposed shortname matches → halt, suggest renaming or resuming
2. **Generate Track ID:** `<snake_case>_<YYYYMMDD>`
3. **Create directory:** `conductor/tracks/<domain>/<track_id>/`
4. **No `metadata.json`** — retired in v3.1. Type, status, and dates live in the `plan.md` header; the registry carries the one-liner. Never write one.
5. **Write files:** `spec.md`, `plan.md` (header + phases + `## Decisions` D-number section), `index.md` (links to spec and plan)
6. **Update Tracks Registry:** Add ONE line under `## Active` (boot reads only these one-liners):

   ```markdown
   - 🟢 **<track_id>** — <type>: <one-line state> → tracks/<domain>/<track_id>/plan.md
   ```

### 2.6 Domain Glossary Update (v2.1)

For each new domain term accumulated in 2.3, present a single batch to the user and append approved terms to `conductor/context.md`'s `## Entities` table. Create `context.md` from the greenfield template if absent.

### 2.7 ADR Batch (D3 + D10, command-end)

Filter accumulated ADR candidates against the three criteria (hard to reverse, surprising without context, real trade-off). Present surviving candidates as a single batch. Write approved ADRs to `conductor/adr/{NNNN}-{kebab-title}.md` numbered sequentially. **Settled here is settled** — `/checkpoint` writes no ADRs beyond in-session approvals and runs no sweep.

### 2.8 Index Touch

`conductor/index.md` is a static Hot/Warm/Cold map. Only permitted touch: if `context.md` was created this command, flip its plain-path line into a link. `adr/` is already listed statically — no action.

### 2.9 Commit and Announce

1. **Commit:** `track: create <track_id> (<N> glossary terms, <M> ADRs)` — simplify to `track: create <track_id>` when neither was touched.
2. **Announce:** "New track '<track_id>' created. You can now start implementation."
