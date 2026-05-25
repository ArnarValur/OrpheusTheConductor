# Protocol: New Track

> Creates a new track (feature, bug, chore, spike) with spec and phased implementation plan.

## 1.0 System Directive

You are an AI agent assistant for the Conductor framework. Your task is to guide the user through creating a new Track, generating the specification (`spec.md`) and plan (`plan.md`), and organizing them within a dedicated track directory.

**CRITICAL:** Validate every tool call. Halt on failure.

---

## 1.1 Setup Check

1. Using the [File Resolution Protocol](./file-resolution.md), resolve and verify:
   - **Product Definition**
   - **Tech Stack**
   - **Workflow**
2. If ANY are missing → Announce "Conductor is not set up. Run `/conductor-init` first." → Halt.

---

## 2.0 New Track Initialization

### 2.1 Get Track Description and Determine Type

1. **Load Project Context:** Read Product Definition, Tech Stack, and other resolved project docs
2. **Get Track Description:** If user provided one, use it. Otherwise ask: "Please provide a brief description of the track you wish to start."
3. **Infer Track Type:** Classify as `feature`, `bug`, `chore`, or `spike`. Do NOT ask the user to classify it.

### 2.2 Domain Selection

1. **Parse existing domains:** Read `conductor/tracks.md` and list existing domain directories under `conductor/tracks/`
2. **Present options:**
   - List existing domains (e.g., `auth`, `ui`, `api`, `infra`)
   - Offer "Create new domain"
3. **If new domain:** Ask user for domain name (lowercase, kebab-case)

### 2.3 Interactive Specification Generation (`spec.md`)

1. **Announce:** "I'll guide you through questions to build a comprehensive specification for this track."
2. **Questioning Phase:**
   - Ask questions sequentially (one at a time, wait for response)
   - Reference Product Definition, Tech Stack for context-aware questions
   - Present 2-3 options (A/B/C) plus "Type your own answer"
   - Classify each question as "Additive" (select all that apply) or "Exclusive Choice"
   - **Features:** 3-5 questions about implementation, interactions, inputs/outputs
   - **Other:** 2-3 questions about scope, reproduction steps, success criteria
3. **Draft `spec.md`:** Sections: Overview, Functional Requirements, Non-Functional Requirements, Acceptance Criteria, Out of Scope
4. **User Confirmation:** Present draft, revise until approved

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
4. **Create `metadata.json`:**
   ```json
   {
     "track_id": "<track_id>",
     "domain": "<domain>",
     "type": "feature",
     "status": "new",
     "created_at": "ISO-8601",
     "updated_at": "ISO-8601",
     "description": "<description>"
   }
   ```
5. **Write files:** `spec.md`, `plan.md`, `index.md` (with links to spec, plan, metadata)
6. **Update Tracks Registry:** Append new track section:
   ```markdown
   ---

   - [ ] **Track: <Description>**
     *Domain: <domain>*
     *Link: [./<domain>/<track_id>/](./<domain>/<track_id>/)*
   ```
7. **Commit:** `track: create <track_id>`
8. **Announce:** "New track '<track_id>' created. You can now start implementation."
