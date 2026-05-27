# 🎵 Conductor Init — Project Scaffolding

When the user invokes `/conductor-init`, execute this interactive setup sequence to scaffold a Conductor-managed project.


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
> Ask the user: "A `conductor/` directory already exists. Do you want to **reinitialize** (this will detect a v2.0 conductor and migrate it to v2.1 in place — see Step 1b) or **abort**?"
> If abort, halt. If reinitialize, proceed to Step 1b.

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

## Step 1b: v2.0 → v2.1 Migration (only when reinitializing an existing conductor)

**This step does NOT clobber** existing user data — tracks, pulse, relay, pulse-archive, agent-rules, and code_styleguides are preserved untouched.

### 1b.1 Detect conductor version

| Signal | Diagnosis |
|--------|-----------|
| `conductor/project-context.md` contains `Product Definition` AND `Tech Stack` sections | v2.0 conductor-init structure (single file) — minor migration only |
| Any of `conductor/product.md`, `conductor/product-guidelines.md`, `conductor/tech-stack.md` exist as separate files | Pre-v2.0 Oracle structure or manual user split — merge required |
| Neither — only legacy files present | Ask the user to describe the project state before proceeding |

### 1b.2 Migration actions

Apply in order:

1. **Scaffold new lazy directories** (idempotent):

   ```bash
   mkdir -p conductor/adr conductor/docs
   touch conductor/adr/.gitkeep conductor/docs/.gitkeep
   ```

2. **Handle product.md split:**
   - If any of `product.md`, `product-guidelines.md`, or `tech-stack.md` exist as separate files (from pre-v2.0 Oracle or manual user edits), present them to the user with proposed section assignments in the consolidated `project-context.md`, and ask: *"Merge these into `project-context.md` and remove the originals?"*
   - On approval, merge content into `project-context.md` using the section order in Step 10 (identity-first). Remove the source files. Commit as a separate step labeled "migrate: consolidate v2.0 product files".
   - If `project-context.md` already contains the merged content (v2.0 conductor-init structure), no action.

3. **Targeted domain scan** (only if `conductor/context.md` does not exist) — invoke Step 2b. Otherwise leave `context.md` alone.

4. **Rewrite `conductor/index.md`** to the dynamic format — keep only links to files that **actually exist** on disk. See Step 11. Then reconcile: for any lazy files present (context.md, prd.md, first ADR, docs/, agent-rules/), ensure `index.md` has a matching link — append if missing.

5. **Update deployed workflows** — copy the latest workflows from `~/Hermes/TheOracle/workflows/` to `.agents/workflows/`, overwriting old versions.

6. **Preserve everything else.** Do NOT touch `conductor/pulse.md`, `conductor/relay.md`, `conductor/tracks.md`, `conductor/tracks/`, `conductor/pulse-archive/`, `conductor/agent-rules/`, or `conductor/code_styleguides/`.

7. **Report** the migration result to the user and skip ahead to Step 12 (deploy workflows) — Steps 2–11 are for fresh initializations.

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

> **Skip for greenfield.** Greenfield projects get no `context.md` at init — the file is created lazily by `/grill` when the first domain term emerges.

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

6. **Write `conductor/context.md`** from the brownfield template. Populate `## Entities` with confirmed terms. Leave `## Relationships` and `## Terminology Boundaries` empty for `/grill` to refine.

7. **Queue an index-sync append** for `context.md` (applied in Step 11).

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

List available style guides from `~/Hermes/TheOracle/templates/code_styleguides/`:

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

---

## Step 7: Create Directory Structure

Create the `conductor/` directory tree. Lazy directories (`adr/`, `docs/`) get a `.gitkeep` so Git tracks them (Git does not track empty directories).

```bash
mkdir -p conductor/tracks conductor/pulse-archive conductor/code_styleguides conductor/adr conductor/docs
touch conductor/adr/.gitkeep conductor/docs/.gitkeep
```

Resulting tree:

```text
conductor/
├── tracks/
├── pulse-archive/
├── code_styleguides/
├── adr/
│   └── .gitkeep
└── docs/
    └── .gitkeep
```

> Lazy files (`context.md`, `prd.md`, `context-map.md`) are NOT created here. They appear when `/grill` or Step 2b writes something to them.

---

## Step 7b: `.docs/` Migration (optional)

If a `.docs/` directory exists in the project root, ask:

> "Found a `.docs/` directory with {N} files. v2.1 places long-form documentation under `conductor/docs/` instead. Migrate `.docs/` → `conductor/docs/`?"

On approval:

1. `mv .docs/* conductor/docs/`
2. Remove the now-empty `.docs/` directory.
3. Remove `conductor/docs/.gitkeep` (no longer needed — real files are present).
4. Queue an index-sync append for `docs/` (applied in Step 11).

> Reminder: `conductor/docs/` has **no command writers**. Humans write there directly. This migration is the only command-touch to that directory.

---

## Step 8: Copy Style Guides

Copy the selected style guides from `~/Hermes/TheOracle/templates/code_styleguides/` to `conductor/code_styleguides/`.

```bash
cp ~/Hermes/TheOracle/templates/code_styleguides/typescript.md conductor/code_styleguides/
cp ~/Hermes/TheOracle/templates/code_styleguides/general.md conductor/code_styleguides/
# ... etc.
```

Always include `general.md` regardless of selection.

---

## Step 9: Copy Workflow Template

Based on the mode selected in Step 6:

- **Strict:** Copy `~/Hermes/TheOracle/templates/workflow-strict.md` → `conductor/workflow.md`
- **Light:** Copy `~/Hermes/TheOracle/templates/workflow-light.md` → `conductor/workflow.md`

---

## Step 10: Create `project-context.md`

Write `conductor/project-context.md` using the template at `~/Hermes/TheOracle/templates/project-context.md` as a base. The file consolidates **identity + operational** content in one document. Populate with information gathered during Steps 2–4.

**Section order (deliberate, identity-first — do NOT reorder):**

1. **Product Definition** (from Step 2)
2. **Product Guidelines** (from Step 3)
3. **Tech Stack** (from Step 4)
4. **Caution Levels** (from template default; user-editable)
5. **Domain Expertise** (from template default; user-editable)
6. **Preferred Workflows** (from template default; updated to mention `adr/` and `pulse.md` decision split)
7. **Project-Specific Constraints** (from template default; user-editable)
8. **Environment Notes** (from template default; user-editable)

> After this file is written, **no command writes to it**. All future edits are by the user directly. This includes framework switches, brand voice changes, and caution-level adjustments — they happen in the user's editor, not via `/grill` or any other workflow.

---

## Step 11: Create Conductor Files (dynamic `index.md`)

### `conductor/index.md`

The init-time `index.md` lists **only files that actually exist on disk now**. Lazy files (`context.md`, `prd.md`, `adr/*`, `docs/*` migrated content) get added later when created by `/grill`, `/new-track`, or `/checkpoint`.

Base template:

```markdown
# Conductor Index

## Context
- [Project Context](./project-context.md)
- [Workflow](./workflow.md)
- [Code Style Guides](./code_styleguides/)

## State
- [Pulse](./pulse.md)
- [Relay](./relay.md)
- [Tracks Registry](./tracks.md)
- [Tracks Directory](./tracks/)
```

**Conditional appends** (apply now if the corresponding lazy file/dir was created in this run):

| Trigger this run | Append under | Link |
|------------------|--------------|------|
| Step 2b wrote `context.md` (brownfield scan) | `## Context` | `- [Domain Glossary](./context.md)` |
| Step 7b migrated `.docs/` → `docs/` | `## Documentation` (new section) | `- [Project Docs](./docs/)` |
| `conductor/agent-rules/` exists (installed by the agent-rules plugin) | `## Context` | `- [Agent Rules](./agent-rules/)` |

> `adr/` and `docs/` themselves are NOT linked at init even though their `.gitkeep` files exist. They are linked on first real-content write (first ADR, first migrated/authored doc) by the index sync steps in `/grill`, `/new-track`, or `/checkpoint`.

### `conductor/relay.md`

```markdown
# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

---

## {YYYY-MM-DD HH:MM}
- **Session:** Initial setup
- **Status:** Project initialized with Conductor
- **Next:** Refine domain with `/grill` or create the first track with `/new-track`
```

### `conductor/pulse.md`

```markdown
# Pulse — Current Project State

**Last Updated:** {current date}
**Session Focus:** Project initialization

## 🚀 Active Tracks
_No tracks yet. Create one with `/new-track`._

## ✅ Recently Completed
_None yet._

## ⚠️ Blockers
_None._

## 🧠 Session Memory
- Project initialized with Conductor

## 📋 Next Session Suggestions
- Refine domain language with `/grill`
- Create the first track with `/new-track`
- Review `project-context.md` for accuracy
```

### `conductor/tracks.md`

```markdown
# Tracks Registry

All tracks organized by domain. Each track links to its dedicated folder.

---

## 🗂️ Domain Structure

| Domain | Path | Caution Level |
|--------|------|---------------|
| _Define domains when creating tracks_ | | |

---

## Active Tracks

_No tracks yet._

## Completed Tracks

_None._
```

---

## Step 12: Deploy Workflow Files

Copy the Conductor workflow files to the project's `.agents/workflows/` directory so they are available as slash commands:

```bash
mkdir -p .agents/workflows
cp ~/Hermes/TheOracle/workflows/conductor.md .agents/workflows/
cp ~/Hermes/TheOracle/workflows/grill.md .agents/workflows/
cp ~/Hermes/TheOracle/workflows/checkpoint.md .agents/workflows/
cp ~/Hermes/TheOracle/workflows/new-track.md .agents/workflows/
```

**Post-copy verification:** After copying, verify each deployed file:
1. Starts with `---` on line 1.
2. Contains a `description:` field in the YAML frontmatter.
3. Is under 12,000 characters total.

If any file fails these checks, halt and report the error — do not proceed with a broken deployment.

> **Note:** `conductor-init.md` is intentionally NOT deployed into the project. It is a one-shot scaffolding command — the plugin-level skill provides it globally for any reinit or migration needs.

---

## Step 13: Initial Track Generation (Optional)

Ask the user:
> "Would you like to create the first track now, run `/grill` to refine the domain first, or do that later?"

- **First track now** → invoke the `/new-track` workflow inline.
- **Grill first** → tell the user to run `/grill` after this command completes; it will read the freshly-written `project-context.md` (and `context.md` if brownfield) for orientation.
- **Later** → skip to Step 14.

---

## Step 14: Git Commit

Stage all conductor files and commit:

```bash
git add conductor/ .agents/workflows/
git commit -m "chore: initialize conductor"
```

If `.docs/` was migrated in Step 7b, include `.docs/`'s removal in the same commit (or a separate `chore: migrate .docs/ → conductor/docs/` commit — your call based on cleanliness).

Announce completion:

> "✅ Conductor initialized. Your project is ready."
>
> **Next:**
> - `/grill` — refine domain language, batch ADRs, optionally write a PRD
> - `/new-track` — create a feature/bug/chore track (will be domain-aware on top of `/grill`'s output)
> - `/conductor` — resume / status dashboard
