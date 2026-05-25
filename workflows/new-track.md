# Source: TheOracle v2.0 @ 2026-05-22

---
name: new-track
description: Create a new Conductor track — gather info, generate spec and plan, register in tracks.md
---

# 🎵 New Track — Create a Track

When the user invokes `/new-track`, execute this sequence to create a new track with full spec and plan artifacts.

---

## Step 1: Gather Track Information

Ask the user for:

1. **Track description** — What does this track accomplish? (e.g., "Add user authentication with OAuth2")
2. **Track type** — Select one:
   - `feature` — New functionality
   - `bug` — Defect fix
   - `chore` — Maintenance, refactoring, tooling
   - `spike` — Research or investigation (no deliverable code)

If the user provides a description inline (e.g., `/new-track add rate limiting`), use that as the description and infer the type. Only ask for clarification if the type is ambiguous.

---

## Step 2: Domain Selection

Read `conductor/tracks.md` and parse the `## 🗂️ Domain Structure` section to get available domains.

Present the existing domains to the user:

> "Which domain does this track belong to?"
>
> {list of existing domains with their caution levels}
>
> Or: **Create a new domain**

If the user creates a new domain:
- Ask for: domain name, path prefix, and caution level (🟢 Normal / 🟡 Careful / 🔴 Tread Carefully)
- Add the new domain to the Domain Structure table in `conductor/tracks.md`

For any domain marked 🔴 (Tread Carefully), warn:
> "⚠️ This domain is marked as sensitive. Extra caution will be applied during implementation."

---

## Step 3: Create Track Folder

Generate a track ID and create the folder:

```
conductor/tracks/{domain}/{snake_case_name}_{YYYYMMDD}/
```

**Track ID format:** `{snake_case_name}_{YYYYMMDD}`

Example: `conductor/tracks/api/rate_limiting_20260522/`

**Duplicate check:** Before creating, verify no existing track directory shares the same short name (the part before the date). If a duplicate exists, inform the user and ask them to choose a different name or resume the existing track.

---

## Step 4: Generate Track Files

Create the following files in the new track folder:

### `metadata.json`

```json
{
  "track_id": "{snake_case_name}_{YYYYMMDD}",
  "type": "{feature|bug|chore|spike}",
  "status": "new",
  "domain": "{domain}",
  "created_at": "{ISO 8601 timestamp}",
  "updated_at": "{ISO 8601 timestamp}",
  "description": "{user-provided description}"
}
```

### `spec.md`

Generate an interactive specification. Ask 3–5 clarifying questions (sequentially, one at a time) to flesh out:

- **Overview** — What problem does this solve?
- **Functional Requirements** — What must it do?
- **Non-Functional Requirements** — Performance, security, etc. (if applicable)
- **Acceptance Criteria** — How do we know it's done?
- **Edge Cases & Constraints** — What could go wrong?
- **Dependencies** — Other tracks or systems this depends on
- **Out of Scope** — What this track explicitly does NOT cover

For each question, provide 2–3 suggested answers plus a write-in option. Tailor questions based on track type:
- **Feature:** Focus on user-facing behavior, UI, data flow
- **Bug:** Focus on reproduction steps, expected vs actual, severity
- **Chore:** Focus on scope, affected systems, success criteria
- **Spike:** Focus on research questions, time-box, deliverables

Present the drafted `spec.md` for user review and approval before writing.

### `plan.md`

Generate a phased implementation plan based on the approved spec and `conductor/workflow.md`:

1. **Research & Design** phase
2. **Implementation** phase (with test-first sub-tasks if strict workflow)
3. **Integration & Polish** phase
4. **Verification & Documentation** phase

Each task uses checkbox format:
```markdown
- [ ] Task: {description}
    - [ ] {sub-task}
    - [ ] {sub-task}
```

If the workflow is **strict mode**, each implementation task must follow TDD:
```markdown
- [ ] Task: Implement {feature}
    - [ ] Write tests for {feature}
    - [ ] Implement {feature} to pass tests
```

Present the drafted `plan.md` for user review and approval before writing.

### `index.md`

```markdown
# Track: {track_id}

- [Specification](./spec.md)
- [Implementation Plan](./plan.md)
- [Metadata](./metadata.json)
```

---

## Step 5: Update `conductor/tracks.md`

Add the new track entry under the **Active Tracks** section:

```markdown
- [ ] **{Track Description}**
  - *Type:* {type} | *Domain:* {domain} | *Status:* new
  - *Link:* [tracks/{domain}/{track_id}/](./tracks/{domain}/{track_id}/)
```

---

## Step 6: Git Commit

Stage and commit:

```bash
git add conductor/
git commit -m "track: create {track_id}"
```

---

## Step 7: Confirm

Tell the user:

> "✅ Track `{track_id}` created at `conductor/tracks/{domain}/{track_id}/`."
>
> **Next steps:**
> - Review the spec: `conductor/tracks/{domain}/{track_id}/spec.md`
> - Start implementation: run `/conductor` and select this track
> - Create another track: `/new-track`
