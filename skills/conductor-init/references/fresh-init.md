# Fresh init — Steps 2–13

Loaded by SKILL.md when there is no `conductor/`. `<plugin-root>` is the path SKILL.md names. Steps 11b and 13b live in SKILL.md.

## Contents

- Step 2 — Product definition grill
- Step 2b — Targeted domain scan (brownfield only)
- Step 3 — Product guidelines grill
- Step 4 — Tech stack grill
- Step 5 — Code style guide selection
- Step 6 — Workflow mode selection
- Step 7 — Directory structure (+ 7b `.docs/` migration)
- Step 8 — Copy style guides
- Step 9 — Copy workflow template
- Step 10 — `project-context.md`
- Step 11 — State files from templates (+ 11b → SKILL.md)
- Step 12 — First track (optional)
- Step 13 — Git commit (+ 13b → SKILL.md)

---

## Step 2: Product Definition Grill

Ask these questions **sequentially** (one at a time, wait for response before next). Maximum 5 questions. For each question, provide 3 suggested answers plus a write-in option.

Topics to cover:

- **Product name** — What is the project called?
- **Tagline** — One-line description.
- **Description** — What does it do? What problem does it solve?
- **Target audience** — Who is this for?
- **Key differentiators** — What makes this unique?

For Brownfield projects, pre-fill suggestions from the code analysis in Step 1.

After gathering responses, draft the **Product Definition** section content for `project-context.md`. Present for review and approval before writing (writing happens in Step 10).

---

## Step 2b: Targeted Domain Scan (brownfield only)

> **Skip for greenfield.** Greenfield projects get no `context.md` at init — the file is created lazily when the first domain term emerges.

For brownfield projects, perform a **targeted** domain scan — NOT a naive grep across the entire codebase.

### Procedure

1. **Ask the user:** *"Where does your core domain logic live?"* with suggestions inferred from Step 1's read-only scan:
   - `src/domain/`, `src/models/`, `src/entities/`
   - `app/entities/`, `app/models/`
   - `models/`, `entities/`
   - Database schema files (`*.surql`, `migrations/`, `schema/`, `*.sql`)
   - API route handlers if domain logic is colocated there

2. **Prioritize during the scan:**
   - Model / entity directories.
   - Database schema files (`.surql`, SQL migrations, ORM model definitions).
   - Type definitions for domain entities.
   - API route handlers (when they encode domain operations rather than CRUD).

3. **Exclude during the scan:**
   - Utility / infrastructure code: `Logger`, `Config`, `DatabaseConnector`, `AuthMiddleware`, `Cache`, `EventBus`.
   - Test directories.
   - Build artifacts, `node_modules/`, `vendor/`, `target/`.
   - Anything matching `.gitignore`.

4. **Extract candidates:** class names, type names, table names, top-level keys in entity files. For each candidate, capture aliases found in the code (e.g., `User` and `Customer` if both appear referring to the same domain concept).

5. **Present the candidate list to the user:**
   > "Here's what I found in your domain layer. Confirm the ones that are real domain concepts (vs incidental types):"
   > {numbered list with proposed definition and "Also known as" column}

6. **Write `conductor/context.md`** from `<plugin-root>/templates/context.md` (strip the header comment), with the confirmed terms under `## Entities`. Leave `## Relationships` and `## Terminology Boundaries` empty for later refinement.

7. **Index note:** in Step 11's static index, flip the glossary line from plain path to a link (the file now exists at init time).

---

## Step 3: Product Guidelines Grill

Ask sequentially. Maximum 3 questions. Topics:

- **Brand voice** — Technical / casual / formal? Tone and personality.
- **UX principles** — Key design principles (e.g., "simplicity first", "mobile-first").
- **Accessibility** — Accessibility standards to follow (e.g., WCAG 2.1 AA).

Draft the **Product Guidelines** section content for `project-context.md`. Present for review.

---

## Step 4: Tech Stack Grill

Ask sequentially. Maximum 5 questions. Topics:

- **Languages** — Primary programming language(s).
- **Frameworks** — Frontend / backend frameworks.
- **Databases** — Data storage solutions.
- **Deployment targets** — Where will this run? (cloud, self-hosted, edge, etc.)
- **Hosting** — Hosting provider / platform.

For Brownfield projects, present the inferred stack and ask for confirmation rather than starting from scratch.

Draft the **Tech Stack** section content for `project-context.md`. Present for review.

---

## Step 5: Code Style Guide Selection

List the available guides live: `ls "<plugin-root>/templates/code_styleguides/"`.

**Recommend** guides based on the tech stack defined in Step 4. Ask the user to confirm or customize the selection.

> "Based on your tech stack, I recommend: {recommended guides}. Would you like to proceed with these, or customize the selection?"

`general.md` is always included regardless of selection.

---

## Step 6: Workflow Mode Selection

Present two workflow modes and ask the user to choose:

### Strict Mode

- **Best for:** Products, production apps, TDD-driven development
- Enforces test-driven development (write tests first)
- Tests must pass before a phase closes
- Commit after every task
- Code coverage requirements
- Full spec → plan → implement cycle

### Light Mode

- **Best for:** Prototypes, websites, experiments, spikes
- No mandatory TDD
- Flexible commit cadence
- Simplified planning
- Faster iteration, fewer guardrails

> "Which workflow mode fits this project?"

Both modes carry **the two laws** (one fact, one home; a ruling binds only in a repo file) — the mode only changes the task lifecycle around them.

---

## Step 7: Create Directory Structure

Create the `conductor/` directory tree. Empty directories get a `.gitkeep` so Git tracks them.

```bash
mkdir -p conductor/tracks conductor/pulse-archive conductor/code_styleguides conductor/adr conductor/docs conductor/agent-rules
touch conductor/adr/.gitkeep conductor/docs/.gitkeep conductor/agent-rules/.gitkeep conductor/pulse-archive/.gitkeep

# Create an initial user-owned scratchpad
printf '%b\n' "# Scratchpad\n\nUse this scratchpad to quickly write down notes, ideas, thoughts, or reminders.\nThis file is user-owned and will not be modified by Conductor." > conductor/scratchpad.md
```

Resulting tree:

```text
conductor/
├── tracks/
├── pulse-archive/
│   └── .gitkeep
├── code_styleguides/
├── adr/
│   └── .gitkeep
├── docs/
│   └── .gitkeep
├── agent-rules/
│   └── .gitkeep
└── scratchpad.md
```

> **Lazy by design** — grow-on-demand, not maximum ceremony on day 1:
> `context.md` (glossary), `prd.md`, ADR files, docs content, and the agent-rules
> files (`behavioral.md`, `technical.md`) are NOT created here. `agent-rules/`
> files are created by `/checkpoint` on the first graduated lesson; the glossary
> and PRD appear when domain language / scope first crystallizes.

---

## Step 7b: `.docs/` Migration (optional)

If a `.docs/` directory exists in the project root, ask:

> "Found a `.docs/` directory with {N} files. Orpheus places long-form documentation under `conductor/docs/` instead. Migrate `.docs/` → `conductor/docs/`?"

On approval:

1. Move everything, dotfiles included: `find .docs -mindepth 1 -maxdepth 1 -exec mv -f {} conductor/docs/ \;`
2. Remove the now-empty directory: `rmdir .docs`
3. Drop the placeholder (real files are present): `command rm -f conductor/docs/.gitkeep`

> Reminder: `conductor/docs/` has **no command writers**. Humans write there directly. This migration is the only command-touch to that directory. The static index already lists `docs/` under Warm — no index action needed.

---

## Step 8: Copy Style Guides

Copy the selected style guides from `<plugin-root>/templates/code_styleguides/` to `conductor/code_styleguides/`.

```bash
command cp -f "<plugin-root>/templates/code_styleguides/typescript.md" conductor/code_styleguides/
command cp -f "<plugin-root>/templates/code_styleguides/general.md" conductor/code_styleguides/
# ... etc.
```

Always include `general.md` regardless of selection.

---

## Step 9: Copy Workflow Template

Based on the mode selected in Step 6:

- **Strict:** Copy `<plugin-root>/templates/workflow-strict.md` → `conductor/workflow.md`
- **Light:** Copy `<plugin-root>/templates/workflow-light.md` → `conductor/workflow.md`

Both templates carry the two laws at the top — do not strip that section.

---

## Step 10: Create `project-context.md`

Write `conductor/project-context.md` using the template at `<plugin-root>/templates/project-context.md` as a base. The file consolidates **identity + operational** content in one document. Populate with information gathered during Steps 2–4.

**Section order (deliberate, identity-first — do NOT reorder):**

1. **Product Definition** (from Step 2)
2. **Product Guidelines** (from Step 3)
3. **Tech Stack** (from Step 4)
4. **Caution Levels** (from template default; user-editable)
5. **Domain Expertise** (from template default; user-editable)
6. **Preferred Workflows** (from template default)
7. **Project-Specific Constraints** (from template default; user-editable)
8. **Environment Notes** (from template default; user-editable)

> After this file is written, **no command writes to it**. All future edits are by the user directly.
>
> **No static live-state as permanent truth:** tenant lists, port numbers, host names and the like do not get baked into conductor files as facts — agents enumerate live state where the work happens. §7/§8 may state *constraints* ("must deploy to region X"), not *observations* ("service Y currently runs on port Z").

---

## Step 11: Create State Files from Templates

Create the four state/map files from `<plugin-root>/templates/`, substituting `{PROJECT_NAME}` (from Step 2) and `{DATE}` (today, `YYYY-MM-DD`):

| Template | Target | Notes |
|----------|--------|-------|
| `templates/pulse.md` | `conductor/pulse.md` | State-only skeleton, ~60-line cap. Rewritten (never appended) by `/checkpoint`. No Session Focus / Session Memory / Recently Completed — history never lives in pulse. |
| `templates/relay.md` | `conductor/relay.md` | The one place a session's story is told. Init writes the first entry. |
| `templates/tracks.md` | `conductor/tracks.md` | One-liner registry. |
| `templates/index.md` | `conductor/index.md` | **Static** Hot/Warm/Cold map — no reconcile logic anywhere. If Step 2b wrote `context.md`, flip the glossary line from plain path to a link. |

Strip the `<!-- Template: ... -->` header comment from each emitted file.

---

## Step 11b: Emit the commands

Run **SKILL.md Step 11b**. On a fresh init both files are `missing`, so it writes them.

---

## Step 12: First Track (Optional)

Ask the user:
> "Would you like to create the first track now, or start your first session with `/conductor` and create it then?"

- **Now** → if the Orpheus plugin's `/new-track` command is available, invoke it inline; otherwise scaffold `conductor/tracks/{domain}/{track-id}/plan.md` by hand (goal, phased task list with `[ ]` checkboxes) and add its one-liner to `conductor/tracks.md`.
- **Later** → skip to Step 13.

---

## Step 13: Git Commit

Stage all emitted files and commit:

```bash
git add conductor/ .claude/commands/
git commit -m "chore: initialize conductor (v3.1 shape)"
```

**Private conductor repo:** if `conductor/.git` exists, `conductor/` is its own (usually private) repo and the parent ignores it. Commit it there, and add the commands to the parent only when the parent tracks them:

```bash
git -C conductor add -A
git -C conductor commit -m "chore: initialize conductor (v3.1 shape)"
git check-ignore -q .claude/commands || { git add .claude/commands/ && git commit -m "chore: emit conductor commands"; }
```

If `.docs/` was migrated in Step 7b, include its removal in the same commit (or a separate `chore: migrate .docs/ → conductor/docs/` commit — your call based on cleanliness).

Run **SKILL.md Step 13b** (Obsidian vault link), then announce completion:

> "✅ Conductor initialized. Your project is ready."
>
> **Next:**
> - `/conductor` — boot: loads the hot set and reports status
> - Create your first track (Step 12, or any time)
> - Open `~/Documents/Project-Vaults/{project}` in Obsidian (Step 13b)
> - `/checkpoint` — end every session with it; it rewrites pulse, tells the story once in relay, and folds to main
