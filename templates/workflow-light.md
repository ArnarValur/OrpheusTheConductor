<!-- Template: Orpheus v3.1 | Mode: light -->
# Project Workflow — Light

> Streamlined workflow for prototypes, websites, and non-product projects.
> Plan → Execute → Verify. Testing encouraged, not mandated.

---

## The Two Laws

These bind every write in this conductor. Everything else in this file is convention; these are law.

1. **One fact, one home.** Live truth lives in `pulse.md`. A session's story is told once, in `relay.md`. Lessons live in the permanent rules files (`agent-rules/`). Decisions live in ADRs (`adr/`) or track-plan D-numbers. Never retell — point.
2. **A ruling binds only when it lands in a repo file.** Agent memory is a cache and conversation is vapor. If a rule, decision, or lesson is not in a repo file, it does not exist.

---

## Guiding Principles

1. **The Plan is the Source of Truth:** All work is tracked in a track — its `plan.md` holds the tasks; `tracks.md` holds one line per track
2. **The Tech Stack is Deliberate:** Changes to the tech stack must be documented in the **Tech Stack** section of `project-context.md` *before* implementation. Architecturally significant changes (those satisfying the three-criteria ADR test: hard to reverse, surprising without context, real trade-off) additionally warrant an ADR in `conductor/adr/` — propose it in-session; approved ADRs are written at `/checkpoint`.
3. **Ship Early, Iterate Fast:** Prioritize working software over ceremony
4. **Test Where It Matters:** Write tests for complex logic, critical paths, and fragile code — skip boilerplate coverage
5. **User Experience First:** Every decision should prioritize user experience
6. **Non-Interactive & CI-Aware:** Prefer non-interactive commands. Use `CI=true` for watch-mode tools

---

## Task Workflow

### Standard Task Lifecycle

1. **Select Task:** Choose the next available task from the active track's `plan.md`, in order

2. **Mark In Progress:** In the track's `plan.md`, change the task from `[ ]` to `[~]`

3. **Plan Approach:**
   - Review the task requirements and acceptance criteria
   - Identify any dependencies or blockers
   - Decide if tests are valuable for this task (complex logic, regressions, integrations)

4. **Execute:**
   - Implement the feature or fix
   - Write tests if planned in step 3 (not mandatory but recommended for non-trivial logic)
   - Verify the implementation works as expected

5. **Verify:**
   - Run any existing tests to ensure nothing is broken: `CI=true <test command>`
   - Check for obvious regressions

6. **Document Deviations:** If implementation differs from tech stack:
   - **STOP** implementation
   - Update the **Tech Stack** section of `project-context.md` with the new design
   - Add a dated note explaining the change (user-edited — no command writes to `project-context.md` post-init)
   - If the change is architecturally significant (three-criteria ADR test), propose it as an ADR in-session; it is written at `/checkpoint` once approved
   - Resume implementation

7. **Commit Code Changes:**
   - Stage all code changes related to the task
   - Commit with a clear, concise message following conventional commits format
   - Example: `feat(landing): Add hero section with CTA`

8. **Record Task Completion:**
   - In the track's `plan.md`, update the completed task from `[~]` to `[x]` and append the first 7 characters of the commit hash

9. **Commit Plan Update:**
    - Stage the track's `plan.md`
    - Commit: `conductor(tracks): Mark task '<task name>' as complete`

---

## Phase Completion — Checkpointing Protocol

**Trigger:** Executed immediately after a task is completed that also concludes a phase in the track's `plan.md`.

1. **Run Existing Tests (if any):** announce the command, run it. If tests fail, attempt a fix (max 2 attempts); if still failing, **stop and ask for guidance**
2. **Create Checkpoint Commit:** `conductor(checkpoint): Checkpoint end of Phase X` (empty commit if no changes)
3. **Record Phase Checkpoint SHA:** in the track's `plan.md`, append `[checkpoint: <7-char-sha>]` to the completed phase heading, and commit: `conductor(tracks): Mark phase '<PHASE NAME>' as complete`
4. **Announce Completion:** tell the user the phase is done — no sign-off step; the user speaks up if something is wrong
---

## Commit Guidelines

### Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding missing tests
- `chore`: Maintenance tasks
- `conductor`: Conductor file updates (plan, checkpoint, tracks)

### Examples

```bash
git commit -m "feat(auth): Add remember me functionality"
git commit -m "fix(layout): Correct mobile nav overflow"
git commit -m "chore(deps): Update dependencies"
git commit -m "conductor(tracks): Mark task 'Build landing page' as complete"
```

---

## Definition of Done

A task is complete when:

1. Feature implemented and working as intended
2. Existing tests still pass (no regressions)
3. Tests written for complex/critical logic (where valuable)
4. Code follows project style guidelines
5. Works on mobile (if applicable)
6. Implementation recorded in the track's `plan.md`
7. Changes committed with proper message

---

## Development Commands

> **Customize this section per project.** Replace examples with actual project commands.

### Setup

```bash
# Install dependencies and configure environment
# e.g., npm install / go mod tidy / pip install -r requirements.txt
```

### Daily Development

```bash
# Start dev server, run tests, lint
# e.g., npm run dev / go run main.go
```

### Before Committing

```bash
# Run pre-commit checks: format, lint, test
# e.g., npm run check / make check
```

---

## When to Add Tests

Tests are not mandatory in light mode but are strongly recommended for:

- **Complex business logic** — calculations, state machines, parsers
- **Data transformations** — serialization, API response mapping
- **Integration points** — API clients, database queries
- **Regression-prone areas** — code that has broken before
- **Security-sensitive paths** — auth, input validation, permissions

Skip tests for:

- Static content pages
- Simple CRUD with no logic
- One-off scripts and prototypes
- Pure UI layout (use visual verification instead)

