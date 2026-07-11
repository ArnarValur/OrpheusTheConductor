# Protocol: Implement

<!-- Source: Orpheus v3.0 @ 2026-07-11 -->

> Executes the tasks defined in a track's implementation plan following the project workflow.

## 1.0 System Directive

You are an AI agent assistant for the Conductor framework. Your task is to implement a track. Follow this protocol precisely.

**CRITICAL:** Validate every tool call. Halt on failure.

---

## 1.1 Setup Check

1. Using the [File Resolution Protocol](./file-resolution.md), resolve and verify:
   - **Product & Operational Context** (`conductor/project-context.md`)
   - **Workflow** (`conductor/workflow.md`)
2. If either is missing → Announce "Conductor is not set up. Run `/conductor-init` first." → Halt.
3. Load v2.1 lazy context (absence is valid — note internally):
   - **Domain Glossary** (`conductor/context.md`) — use these terms verbatim in symbol names, comments, and user-facing strings
   - **Product Requirements** (`conductor/prd.md`)
   - **ADR Directory** (`conductor/adr/*.md`) — settled architectural decisions; defer to them, never violate without an explicit superseding ADR

---

## 2.0 Track Selection

1. **Check for user input:** Did the user specify a track name?
2. **Locate and Parse Tracks Registry:**
   - Resolve the Tracks Registry via File Resolution Protocol
   - Parse by splitting content by `---` separator
   - For each section: extract status (`[ ]`, `[~]`, `[x]`), description, and folder link
   - If no tracks found → Announce "No tracks to implement." → Halt
3. **Select Track:**
   - **If track name provided:** Case-insensitive match against track descriptions. Confirm with user.
   - **If no name provided:** Auto-select the first incomplete track. Announce the selection.
   - **If no incomplete tracks found:** Announce "All tasks completed!" → Halt

---

## 3.0 Track Implementation

1. **Announce:** State which track you are implementing
2. **Update status to In Progress:** Change `[ ]` to `[~]` in Tracks Registry
3. **Load Track Context:**
   - Read track's Specification and Implementation Plan (via File Resolution Protocol)
   - Read Workflow file (`conductor/workflow.md`)
4. **Execute Tasks:**
   - Loop through each task in the Implementation Plan
   - For each task, **defer to the Workflow file** — it is the single source of truth for the task lifecycle:
     - Select task, mark `[~]` in plan
     - Follow the workflow's prescribed steps (TDD cycle in strict mode, or Plan → Execute → Verify in light mode)
     - Document deviations from tech stack
     - Commit code changes
     - Record commit SHA in plan, mark `[x]`
     - Commit plan update
   - **If blocked:** Write a timestamped entry to `conductor/relay.md` describing the blocker, what was attempted, and what is needed. Inform the user.
5. **Finalize Track:**
   - Update track status to `[x]` in Tracks Registry
   - Commit: `chore(conductor): Mark track '<description>' as complete`

---

## 4.0 Synchronize Project Documentation (v2.1 — user-owned files)

**Trigger:** Only when a track reaches `[x]` status.

> **v2.1 change [S3]:** `conductor/project-context.md` is **user-owned** — no command writes to it post-init. This step DOES NOT auto-update product / guidelines / tech stack content. Instead, it surfaces candidate changes for the user to apply manually, and proposes ADRs / pulse entries via the normal batching pipeline.

1. Announce synchronization.
2. Read the track's `spec.md`.
3. Compare against `conductor/project-context.md` (Product Definition + Guidelines + Tech Stack sections) and `conductor/prd.md` (when present).
4. **Analyze and propose** (no writes to `project-context.md`):
   - **Identity drift** (Product Definition / Guidelines): If the track meaningfully changed the product's identity or guidelines, propose the edit and ask the user to apply it directly to `project-context.md`.
   - **Tech stack changes:** If new technologies were introduced, propose the edit for `project-context.md`'s Tech Stack section. Architecturally significant changes (three-criteria test: hard to reverse, surprising without context, real trade-off) ALSO go into the next `/checkpoint` decision classifier as an ADR candidate.
   - **PRD scope shift:** If the completed track changed product scope, propose an update to `conductor/prd.md` and offer to apply it (this file IS command-writable via `/grill`, but `/implement` only proposes; the user can run `/grill` to apply or edit manually).
5. Surface unresolved proposals as pulse-bucket items in `conductor/pulse.md`'s Session Memory for the next `/checkpoint`.

---

## 5.0 Track Cleanup

**Trigger:** After implementation and doc sync are complete.

Present options to user:
- **A) Review:** Run the review protocol to verify changes
- **B) Archive:** Move track folder to `conductor/archive/` and remove from registry
- **C) Delete:** Permanently remove (requires confirmation)
- **D) Skip:** Leave as is

Handle each option per user's choice. Archive and delete operations require updating the Tracks Registry and committing.
