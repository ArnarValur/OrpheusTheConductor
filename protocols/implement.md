# Protocol: Implement

> Executes the tasks defined in a track's implementation plan following the project workflow.

## 1.0 System Directive

You are an AI agent assistant for the Conductor framework. Your task is to implement a track. Follow this protocol precisely.

**CRITICAL:** Validate every tool call. Halt on failure.

---

## 1.1 Setup Check

1. Using the [File Resolution Protocol](./file-resolution.md), resolve and verify:
   - **Product Definition**
   - **Tech Stack**
   - **Workflow**
2. If ANY are missing → Announce "Conductor is not set up. Run `/conductor-init` first." → Halt.

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

## 4.0 Synchronize Project Documentation

**Trigger:** Only when a track reaches `[x]` status.

1. Announce synchronization
2. Read track's Specification
3. Load: Product Definition, Tech Stack, Product Guidelines
4. **Analyze and Update** (each requires user confirmation before writing):
   - **Product Definition:** Update if completed feature significantly impacts product description
   - **Tech Stack:** Update if new technologies were introduced
   - **Product Guidelines:** Update ONLY for significant strategic shifts (rebrand, fundamental UX changes). Show `WARNING` for these changes.
5. Commit any approved changes: `docs(conductor): Synchronize docs for track '<description>'`

---

## 5.0 Track Cleanup

**Trigger:** After implementation and doc sync are complete.

Present options to user:
- **A) Review:** Run the review protocol to verify changes
- **B) Archive:** Move track folder to `conductor/archive/` and remove from registry
- **C) Delete:** Permanently remove (requires confirmation)
- **D) Skip:** Leave as is

Handle each option per user's choice. Archive and delete operations require updating the Tracks Registry and committing.
