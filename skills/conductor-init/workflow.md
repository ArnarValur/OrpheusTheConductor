# 🎵 Conductor Init — Project Scaffolding

When the user invokes `/conductor-init`, execute this interactive setup sequence to scaffold a Conductor-managed project.

**Shape contract (v3.1, from the 2026-08-05 conductor rebuild):** init emits a state-only pulse, a story-only relay, a workflow carrying the two laws, a static index, and self-contained `/conductor` + `/checkpoint` commands into the consumer repo. Emitted files must never reference `/conductor-init` (consumer repos may not carry it) and must never contain static live-state — they instruct "enumerate live".

---

## Step 1: Detect Project Maturity

Determine if this is a **Brownfield** (existing) or **Greenfield** (new) project.

**Brownfield indicators** — if ANY are present, classify as Brownfield:

- Version control directories: `.git`, `.svn`, `.hg`
- Dependency manifests: `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pubspec.yaml`
- Source code directories: `src/`, `app/`, `lib/` containing code files
- An existing `conductor/` directory (previous initialization)

**Greenfield** — ONLY if none of the above are found.

**If an existing `conductor/` directory is detected:**
> Ask the user: "A `conductor/` directory already exists. Do you want to **upgrade in place** (preserve all state, emit the current-shape commands and index, and get a hand-migration checklist — see Step 1b) or **abort**?"
> If abort, halt. If upgrade, proceed to Step 1b.

**If Brownfield (no existing conductor):**

1. Announce existing project detected.
2. If uncommitted git changes exist, warn: "You have uncommitted changes. Commit or stash before proceeding."
3. Perform a read-only scan: analyze `README.md`, manifest files, and directory structure to infer project context.
4. Respect `.gitignore` and `.geminiignore` when scanning.
5. Summarize findings: inferred tech stack, architecture type, project goal.

**If Greenfield:**

1. Announce new project initialization.
2. Initialize git repo if `.git` doesn't exist: `git init`.
3. Ask: "What are you building?" — use the response as the initial concept.

---

## Step 1b: In-place Upgrade (only when an existing conductor is detected)

**Philosophy: preserve + checklist.** State migration needs human judgment (what's a live blocker vs history), so init never rewrites `pulse.md`, `relay.md`, `tracks.md`, or track folders. It upgrades the *structural* files, emits the commands, and hands the human a checklist for the rest.

### 1b.0 Retire Antigravity remnants (v2.x → v3.x)

If this project carries v2.x Antigravity remnants — a `.agents/workflows/` directory, a root `plugin.json` named `the-oracle`, or `TheOracle`-headed files — run the **[Migrate protocol](${CLAUDE_PLUGIN_ROOT}/protocols/migrate.md)** first: it retires the deploy copies, confirms the Orpheus plugin, and ships the secrets `.gitignore` (ADR 0005), all while preserving `conductor/` state. Then continue below.

### 1b.1 Detect conductor shape

| Signal | Diagnosis |
|--------|-----------|
| `pulse.md` has `📍 Now` and `📌 Parked` sections, no `Session Memory`, AND `.claude/commands/conductor.md` exists | **Current shape (v3.1)** — report "already current" and halt. |
| `pulse.md` contains `Session Memory` / `Recently Completed`, or tracks carry `metadata.json`, or no `.claude/commands/conductor.md` | **Old shape** — proceed with the upgrade below. |
| No `pulse.md` at all | Broken conductor — ask the user to describe the state before proceeding. |

### 1b.2 Structural upgrades (safe, non-destructive)

Apply in order. If a target file already exists with user content, ask before overwriting — everything else is additive.

1. **Emit the commands** (Step 11b) into `.claude/commands/`. If either file already exists there, show a diff summary and ask before overwriting.
2. **Rewrite `conductor/index.md`** from `${CLAUDE_PLUGIN_ROOT}/templates/index.md` (static Hot/Warm/Cold map). The old index was auto-derived, not user state — safe to replace. Flip lazy plain-path entries to links for files that already exist (glossary, prd, agent-rules files).
3. **Ensure `conductor/workflow.md` carries the two laws.** If the "The Two Laws" section is missing, insert it directly after the title block (copy the section verbatim from either workflow template).
4. **Scaffold missing directories** (idempotent):

   ```bash
   mkdir -p conductor/agent-rules conductor/pulse-archive conductor/adr conductor/docs
   touch conductor/agent-rules/.gitkeep conductor/pulse-archive/.gitkeep conductor/adr/.gitkeep conductor/docs/.gitkeep
   [ ! -f conductor/scratchpad.md ] && echo -e "# Scratchpad\n\nUse this scratchpad to quickly write down notes, ideas, thoughts, or reminders.\nThis file is user-owned and will not be modified by Conductor." > conductor/scratchpad.md
   ```

5. **Preserve everything else.** Do NOT touch `conductor/pulse.md`, `conductor/relay.md`, `conductor/tracks.md`, `conductor/tracks/`, `conductor/pulse-archive/` contents, `conductor/agent-rules/` contents, `conductor/project-context.md`, or `conductor/code_styleguides/`.

### 1b.3 Hand-migration checklist

Print this checklist for the human (adjust numbers to what you actually observed):

> **Your conductor's structure is upgraded. State migration is yours — the shape needs judgment, not regeneration:**
>
> 1. **Rewrite `pulse.md`** into the five-section skeleton (📍 Now · 🚀 Active tracks · ⚠️ Blockers · 📋 Next queue · 📌 Parked), cap ~60 lines. Move history OUT — it doesn't live in pulse. (~15 min)
> 2. **Reshape `relay.md`**: one entry per session, ≤10 lines each. If more than 12 entries, keep the newest 8 and archive the rest to `conductor/pulse-archive/relay-pre-{date}.md`. (~10 min)
> 3. **Graduate lessons** buried in the old pulse (Session Memory etc.) into `conductor/agent-rules/technical.md` / `behavioral.md`. (~10 min)
> 4. **Delete `metadata.json`** files under `conductor/tracks/` at leisure — nothing reads them anymore. (~2 min)
> 5. **Commit**: `checkpoint: migrate conductor to v3.1 shape`.
>
> I can draft 1–3 for your review if you want — say the word. I won't write them unreviewed.

### 1b.4 Report and halt

Report what was upgraded and what remains on the checklist, then halt — Steps 2–13 are for fresh initializations only.

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
   - Anything matching `.gitignore` or `.geminiignore`.

4. **Extract candidates:** class names, type names, table names, top-level keys in entity files. For each candidate, capture aliases found in the code (e.g., `User` and `Customer` if both appear referring to the same domain concept).

5. **Present the candidate list to the user:**
   > "Here's what I found in your domain layer. Confirm the ones that are real domain concepts (vs incidental types):"
   > {numbered list with proposed definition and "Also known as" column}

6. **Write `conductor/context.md`** with the confirmed terms under `## Entities`. Leave `## Relationships` and `## Terminology Boundaries` empty for later refinement.

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

List available style guides from `${CLAUDE_PLUGIN_ROOT}/templates/code_styleguides/`:

| Guide | File |
|-------|------|
| C++ | `cpp.md` |
| C# | `csharp.md` |
| Dart | `dart.md` |
| General | `general.md` |
| Go | `go.md` |
| HTML/CSS | `html-css.md` |
| JavaScript | `javascript.md` |
| Python | `python.md` |
| TypeScript | `typescript.md` |

**Recommend** guides based on the tech stack defined in Step 4. Ask the user to confirm or customize the selection.

> "Based on your tech stack, I recommend: {recommended guides}. Would you like to proceed with these, or customize the selection?"

`general.md` is always included regardless of selection.

---

## Step 6: Workflow Mode Selection

Present two workflow modes and ask the user to choose:

### Strict Mode

- **Best for:** Products, production apps, TDD-driven development
- Enforces test-driven development (write tests first)
- Requires phase completion verification
- Commit after every task
- Code coverage requirements
- Full spec → plan → implement cycle

### Light Mode

- **Best for:** Prototypes, websites, experiments, spikes
- No mandatory TDD
- Flexible commit cadence
- Simplified planning (no phase verification gates)
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
echo -e "# Scratchpad\n\nUse this scratchpad to quickly write down notes, ideas, thoughts, or reminders.\nThis file is user-owned and will not be modified by Conductor." > conductor/scratchpad.md
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

1. `mv .docs/* conductor/docs/`
2. Remove the now-empty `.docs/` directory.
3. Remove `conductor/docs/.gitkeep` (no longer needed — real files are present).

> Reminder: `conductor/docs/` has **no command writers**. Humans write there directly. This migration is the only command-touch to that directory. The static index already lists `docs/` under Warm — no index action needed.

---

## Step 8: Copy Style Guides

Copy the selected style guides from `${CLAUDE_PLUGIN_ROOT}/templates/code_styleguides/` to `conductor/code_styleguides/`.

```bash
cp ${CLAUDE_PLUGIN_ROOT}/templates/code_styleguides/typescript.md conductor/code_styleguides/
cp ${CLAUDE_PLUGIN_ROOT}/templates/code_styleguides/general.md conductor/code_styleguides/
# ... etc.
```

Always include `general.md` regardless of selection.

---

## Step 9: Copy Workflow Template

Based on the mode selected in Step 6:

- **Strict:** Copy `${CLAUDE_PLUGIN_ROOT}/templates/workflow-strict.md` → `conductor/workflow.md`
- **Light:** Copy `${CLAUDE_PLUGIN_ROOT}/templates/workflow-light.md` → `conductor/workflow.md`

Both templates carry the two laws at the top — do not strip that section.

---

## Step 10: Create `project-context.md`

Write `conductor/project-context.md` using the template at `${CLAUDE_PLUGIN_ROOT}/templates/project-context.md` as a base. The file consolidates **identity + operational** content in one document. Populate with information gathered during Steps 2–4.

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

Create the four state/map files from `${CLAUDE_PLUGIN_ROOT}/templates/`, substituting `{PROJECT_NAME}` (from Step 2) and `{DATE}` (today, `YYYY-MM-DD`):

| Template | Target | Notes |
|----------|--------|-------|
| `templates/pulse.md` | `conductor/pulse.md` | State-only skeleton, ~60-line cap. Rewritten (never appended) by `/checkpoint`. No Session Focus / Session Memory / Recently Completed — history never lives in pulse. |
| `templates/relay.md` | `conductor/relay.md` | The one place a session's story is told. Init writes the first entry. |
| `templates/tracks.md` | `conductor/tracks.md` | One-liner registry. |
| `templates/index.md` | `conductor/index.md` | **Static** Hot/Warm/Cold map — no reconcile logic anywhere. If Step 2b wrote `context.md`, flip the glossary line from plain path to a link. |

Strip the `<!-- Template: ... -->` header comment from each emitted file.

---

## Step 11b: Emit the Commands

Copy the two self-contained command files into the project:

```bash
mkdir -p .claude/commands
cp ${CLAUDE_PLUGIN_ROOT}/templates/commands/conductor.md .claude/commands/conductor.md
cp ${CLAUDE_PLUGIN_ROOT}/templates/commands/checkpoint.md .claude/commands/checkpoint.md
```

Strip the `<!-- Template: ... -->` header comment from each emitted file.

These give the repo `/conductor` (boot: hot set only, warm-load trigger table, ~10-line status) and `/checkpoint` (pulse rewrite, one relay entry, lesson graduation, fold-to-main) **without any plugin dependency**.

**Invariants for emitted files — enforce on every future template edit:**

- Halt messages say "recover the file from git history" and give the git commands. They never point at `/conductor-init` — consumer repos may not carry it.
- No reference to `${CLAUDE_PLUGIN_ROOT}`, the Orpheus plugin, or any file init does not emit.
- No static live-state — instructions say "enumerate live".

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

If `.docs/` was migrated in Step 7b, include its removal in the same commit (or a separate `chore: migrate .docs/ → conductor/docs/` commit — your call based on cleanliness).

Announce completion:

> "✅ Conductor initialized. Your project is ready."
>
> **Next:**
> - `/conductor` — boot: loads the hot set and reports status
> - Create your first track (Step 12, or any time)
> - `/checkpoint` — end every session with it; it rewrites pulse, tells the story once in relay, and folds to main

---

## Session Behavior

- **Interactive prompts:** Use the `AskUserQuestion` tool for all multiple-choice selections and confirmations — it renders as a rich Claude Code modal (up to 4 questions per call, 2–4 options each, with an automatic "Other" write-in). Fall back to plain markdown options only if the tool is unavailable.
