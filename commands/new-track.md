---
description: Create a domain-aware track with spec and implementation plan. Reads context.md, ADRs, and PRD for informed specification
---

# New Track — Create a Domain-Aware Track

When the user invokes `/new-track`, execute this sequence to create a new track with full spec and plan artifacts, informed by the project's domain glossary, ADRs, and PRD.

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

## Step 1b: Load Domain Context

Before any domain-related question or spec interview, load all context documents that exist. Lazy files may be absent — that is a valid state.

| File | Use during this command |
|------|-------------------------|
| `conductor/project-context.md` | Identity + operational guardrails |
| `conductor/context.md` | Domain glossary — use these terms verbatim in questions / suggestions |
| `conductor/context-map.md` | Bounded-context registry — drives Step 2a validation |
| `conductor/prd.md` | Product scope — surface relevant in-scope features when proposing track scope; surface out-of-scope items to avoid relitigating |
| `conductor/adr/*.md` | Settled architectural decisions — propose ADR-consistent options; do NOT re-litigate without explicit user request |
| `conductor/workflow.md` | Strict vs Light — drives plan-generation rules in Step 4 |

If `conductor/` does not exist, halt with:
> "Conductor is not initialized in this project. Run `/conductor-init` first."

If `conductor/project-context.md` does not exist, halt with:
> "`conductor/project-context.md` is missing — recover it from git history: `git log --oneline --all -- conductor/project-context.md`, then `git checkout <sha> -- conductor/project-context.md`."

Other files (`context.md`, `prd.md`, `adr/*`, `context-map.md`) are LAZY — their absence is fine. Note absences internally and proceed.

---

## Step 2a: Context-Map Validation Gate

**Order matters.** This step runs BEFORE Step 2 (existing-domain parsing). Without this ordering, `tracks.md` domains can shadow the context-map check.

1. If `conductor/context-map.md` does NOT exist, **skip silently** and proceed to Step 2. This is the current behavior for single-context projects.
2. If `conductor/context-map.md` exists:
   1. Parse its registered bounded-context names.
   2. If the user has not yet proposed a domain for this track (typical at this stage), do nothing here — Step 2 will collect a proposal, then re-enter this gate before accepting it.
   3. If the user has proposed a domain (e.g., they passed it inline as `/new-track --domain booking ...`), validate the proposal against the registered set.
      - **Valid:** record the validated domain and skip Step 2's "Create new domain" branch.
      - **Invalid:** halt with:
        > "Domain `{proposed}` is not registered in `context-map.md`. Valid contexts: {list}. To add a new context, edit `context-map.md` first, then re-run `/new-track`."

> **Why this step exists today as a near-no-op:** `context-map.md` is supported but most projects do not have one yet. The gate is wired now so it has zero cost when the file is absent and full enforcement when it appears (e.g., when DittoDatto gets multi-context).

---

## Step 2: Domain Selection

Existing domains are the directory names under `conductor/tracks/` (enumerate live — there is no domain table to maintain). Caution levels come from the **Caution Levels** section of `conductor/project-context.md`.

Present the existing domains to the user:

> "Which domain does this track belong to?"
>
> {list of existing domains, annotated with caution levels where project-context defines them}
>
> Or: **Create a new domain**

If the user creates a new domain:

- Ask for: domain name (lowercase, kebab-case). The domain exists once its first track folder is created — no registry row anywhere.
- **Re-enter Step 2a with the proposed new domain.** If `context-map.md` exists, the new domain must match a registered context name — otherwise halt with the error from Step 2a.
- If the domain warrants a caution level, suggest the user add a row to the Caution Levels table in `project-context.md` — that file is user-owned, so the edit is theirs, not this command's.

For any domain marked 🔴 (Critical / Tread Carefully) in project-context, warn:

> "⚠️ This domain is marked as sensitive. Extra caution will be applied during implementation."

---

## Step 3: Create Track Folder

Generate a track ID and create the folder:

```text
conductor/tracks/{domain}/{snake_case_name}_{YYYYMMDD}/
```

**Track ID format:** `{snake_case_name}_{YYYYMMDD}`

Example: `conductor/tracks/api/rate_limiting_20260525/`

**Duplicate check:** Before creating, verify no existing track directory shares the same short name (the part before the date). If a duplicate exists, inform the user and ask them to choose a different name or resume the existing track.

---

## Step 4: Generate Track Files (Domain-Aware)

Create the following files in the new track folder.

> **No `metadata.json`.** It is retired — type, status, and dates live in the plan header and the `tracks.md` one-liner. Never write one.

### `spec.md` (domain-aware interview)

Run an interactive specification interview. Ask 3–5 clarifying questions (sequentially, one at a time) to flesh out the standard spec sections.

**Domain-awareness rules:**

1. **Use glossary terms verbatim.** When `context.md` exists, the entity / relationship / terminology terms in it are the project's ubiquitous language. Phrase every question using those terms.
2. **Respect ADRs.** When proposing options, default to choices consistent with `adr/*`. If a proposed option would conflict with an ADR, surface the ADR title in the question and ask the user whether they want to revisit it (an ADR superseder is a separate decision — see Step 6).
3. **Anchor scope to PRD.** When `prd.md` exists, cite the in-scope item this track delivers, and explicitly check the out-of-scope list to avoid feature-creep.

**Sections to populate (unchanged from v2.0):**

- **Overview** — What problem does this solve?
- **Functional Requirements** — What must it do?
- **Non-Functional Requirements** — Performance, security, etc. (if applicable)
- **Acceptance Criteria** — How do we know it's done?
- **Edge Cases & Constraints** — What could go wrong?
- **Dependencies** — Other tracks or systems this depends on
- **Out of Scope** — What this track explicitly does NOT cover

For each question, provide 2–3 suggested answers (defaulting to ADR-consistent choices) plus a write-in option. Tailor questions based on track type:

- **Feature:** user-facing behavior, UI, data flow
- **Bug:** reproduction steps, expected vs actual, severity
- **Chore:** scope, affected systems, success criteria
- **Spike:** research questions, time-box, deliverables

### Accumulation during the interview

Maintain two internal lists. **Do NOT write to disk during the interview** — only at command end (Steps 6–7).

| List | Triggers | Example |
|------|----------|---------|
| **New domain terms** | A noun comes up that's not in `context.md` and seems to be a real domain concept | "`RateLimitPolicy` — a per-route configuration governing throttle behavior" |
| **ADR candidates** | A decision satisfies all three criteria: hard to reverse, surprising without context, real trade-off | "Use token-bucket over leaky-bucket for the limiter algorithm" |

Present the drafted `spec.md` for user review and approval before writing.

### `plan.md`

Generate a phased implementation plan based on the approved spec and `conductor/workflow.md`. Open with a short header (type, status, created date — the facts `metadata.json` used to carry), then the phases:

1. **Research & Design** phase
2. **Implementation** phase (with test-first sub-tasks if strict workflow)
3. **Integration & Polish** phase
4. **Verification & Documentation** phase

Close the plan with a `## Decisions` section for **track-scoped** decisions, numbered `D1`, `D2`, … — one line each. Decisions that meet the three-criteria ADR test go to `conductor/adr/` instead (Step 7); D-numbers are for the rest, and relay entries cite them.

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
```

---

## Step 5: Update `conductor/tracks.md`

Add ONE line under the `## Active` section — boot reads only these one-liners, so detail stays in the track folder:

```markdown
- 🟢 **{track_id}** — {type}: {one-line state} → tracks/{domain}/{track_id}/plan.md
```

---

## Step 6: Domain Glossary Update

For each **New domain term** accumulated in Step 4:

1. If `context.md` does NOT exist, create it from the greenfield template.
2. Present the proposed terms to the user as a single batch:
   > "These terms came up during the spec interview that aren't yet in the glossary. Should I add them?"
3. For approved terms, append rows to the `## Entities` table of `context.md`. Update the `> Last refined: {datetime}` header.
4. If `context.md` was created this run, flip its plain-path line in `conductor/index.md` to a link (applied in Step 8).

---

## Step 7: ADR Batch (Command-End)

This is the same batching pattern as `/grill`. Runs once, at command end.

1. **Filter candidates** against the three criteria (hard to reverse, surprising without context, real trade-off). Drop anything that doesn't meet all three.
2. **Present the batch:**
   > "These architectural decisions surfaced while specifying this track. Which should be recorded as ADRs?"
   > {numbered list with proposed titles + 1-sentence summary}
3. For each candidate, the user can: **approve**, **reject**, or **defer**.
4. For each approved candidate, write `conductor/adr/{NNNN}-{short-title-kebab}.md` using the standard ADR format. Number sequentially from the highest existing `NNNN`.
5. **Settled here is settled.** This batch IS the proposed-and-approved-in-session path — `/checkpoint` writes no ADRs beyond it and runs no sweep. Deferred candidates land as a line in pulse's 📋 Next queue at the next checkpoint, nothing else remembers them.

---

## Step 8: Index Touch (static map — no sync ceremony)

`conductor/index.md` is a **static** Hot/Warm/Cold map. The only permitted touch: when a lazy file listed as a plain path came into existence this command (`context.md`), flip that one line into a markdown link. ADRs need nothing — `adr/` is already listed under Warm.

Never append new sections, never scan for drift, never write a dead link.

---

## Step 9: Git Commit

Stage and commit:

```bash
git add conductor/
git commit -m "track: create {track_id} ({N glossary terms}, {M ADRs})"
```

If `conductor/.git` exists, `conductor/` is its own repo: use `git -C conductor add -A` and `git -C conductor commit` instead, then `git -C conductor push` when it has a remote.

If neither glossary nor ADRs were touched, simplify the message: `track: create {track_id}`.

---

## Step 10: Confirm

Tell the user:

> "✅ Track `{track_id}` created at `conductor/tracks/{domain}/{track_id}/`.
>
> - Glossary updates: **{N terms}**
> - ADRs recorded: **{M}** ({titles if any})
>
> **Next steps:**
>
> - Review the spec: `conductor/tracks/{domain}/{track_id}/spec.md`
> - Start implementation: run `/conductor` and select this track
> - Create another track: `/new-track`"

---

## Session Behavior

- **Interactive prompts:** Use the `AskUserQuestion` tool for all multiple-choice selections and confirmations — it renders as a rich Claude Code modal (up to 4 questions per call, 2–4 options each, with an automatic "Other" write-in). Fall back to plain markdown options only if the tool is unavailable.
