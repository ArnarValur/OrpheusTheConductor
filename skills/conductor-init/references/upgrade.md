# Step 1b — Refresh or upgrade an existing conductor

Loaded by SKILL.md when `conductor/` already exists. `<plugin-root>` is the path SKILL.md names.

## Contents

- 1b.0 Retire Antigravity remnants (v2.x → v3.x)
- 1b.1 Detect conductor shape
- 1b.R Refresh a current conductor
- 1b.2 Structural upgrades (old shape)
- 1b.3 Hand-migration checklist
- 1b.4 Report and halt

**Philosophy: preserve + checklist.** State migration needs human judgment (what's a live blocker vs history), so init never rewrites `pulse.md`, `relay.md`, `tracks.md`, or track folders. It upgrades the *structural* files, emits the commands, and hands the human a checklist for the rest.

### 1b.0 Retire Antigravity remnants (v2.x → v3.x)

If this project carries v2.x Antigravity remnants — a `.agents/workflows/` directory, a root `plugin.json` named `the-oracle`, or `TheOracle`-headed files — run the **[Migrate protocol](<plugin-root>/protocols/migrate.md)** first: it retires the deploy copies, confirms the Orpheus plugin, and ships the secrets `.gitignore` (ADR 0005), all while preserving `conductor/` state. Then continue below.

### 1b.1 Detect conductor shape

| Signal | Diagnosis |
|--------|-----------|
| `pulse.md` has `📍 Now` and `📌 Parked` sections and no `Session Memory` / `Recently Completed` | **Current shape (v3.1)** — go to **1b.R Refresh** below (it also writes missing commands, e.g. on a fresh clone where `.claude/` is ignored). |
| `pulse.md` contains `Session Memory` / `Recently Completed` | **Old shape** — proceed with the upgrade below. |
| No `pulse.md` at all | Broken conductor — ask the user to describe the state before proceeding. |

### 1b.R Refresh a current conductor

This is the route by which template changes reach a current-shape repo after a plugin update. It never rewrites state (`pulse.md`, `relay.md`, `tracks.md`, track folders, `agent-rules/`, `project-context.md`).

1. **Commands** — SKILL.md Step 11b: compare each emitted command with its template; write it if missing; if it differs, show the diff and ask before overwriting.
2. **Index** — if `conductor/index.md` carries no writer notes (`grep -q 'written by' conductor/index.md` fails), offer to re-render it from `<plugin-root>/templates/index.md`: strip the header comment, substitute the project name, and turn plain-path entries into links for files that exist. Ask first — it's a map, not state, but the human may have edited it.
3. **Vault** — SKILL.md Step 13b.
4. **Drift checklist** — check these user-owned files and list what you find for the human. Fix nothing yourself:
   - `conductor/workflow.md` marks tasks in `tracks.md` (``grep -nE '(Edit|Stage|In|from|in) `tracks\.md`' conductor/workflow.md`` finds the old wording) → tasks live in each track's `plan.md`; `tracks.md` holds one line per track. The current wording is in `<plugin-root>/templates/workflow-light.md` / `workflow-strict.md`.
   - A `tracks.md` one-liner whose pointer lacks the domain (`→ tracks/<track-id>/plan.md`) → it should read `→ tracks/<domain>/<track-id>/plan.md`.
   - `metadata.json` files under `conductor/tracks/` → retired; delete at leisure.
5. **Commit** only what changed, with a pathspec so nothing the human already staged rides along: `git commit -m "chore: refresh conductor commands" -- .claude/commands/conductor.md .claude/commands/checkpoint.md` in the parent repo, unless the parent ignores them (`git check-ignore -q .claude/commands`); `index.md` with `git -C conductor commit -m … -- index.md` when `conductor/.git` exists, otherwise `git commit -m … -- conductor/index.md`.
6. **Report** in ≤8 lines — commands (current / refreshed / kept), index, vault, checklist items — and halt.

### 1b.2 Structural upgrades (safe, non-destructive)

Apply in order. If a target file already exists with user content, ask before overwriting — everything else is additive.

1. **Emit the commands** — SKILL.md Step 11b (compare; write if missing; show the diff and ask if different).
2. **Rewrite `conductor/index.md`** from `<plugin-root>/templates/index.md` (static Hot/Warm/Cold map; strip the header comment, substitute the project name). The old index was auto-derived, not user state — safe to replace. Flip lazy plain-path entries to links for files that already exist (glossary, prd, agent-rules files).
3. **Ensure `conductor/workflow.md` carries the two laws.** If the "The Two Laws" section is missing, insert it directly after the title block (copy the section verbatim from either workflow template).
4. **Scaffold missing directories** (idempotent):

   ```bash
   mkdir -p conductor/agent-rules conductor/pulse-archive conductor/adr conductor/docs
   touch conductor/agent-rules/.gitkeep conductor/pulse-archive/.gitkeep conductor/adr/.gitkeep conductor/docs/.gitkeep
   [ ! -f conductor/scratchpad.md ] && printf '%b\n' "# Scratchpad\n\nUse this scratchpad to quickly write down notes, ideas, thoughts, or reminders.\nThis file is user-owned and will not be modified by Conductor." > conductor/scratchpad.md
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
> Items 1–3 are what `/checkpoint` does — run it at the end of this session and review each write (the plugin's `/orpheus:checkpoint` also pauses on an old-shape pulse and walks the migration with you).

Init never drafts or writes `pulse.md` or `relay.md` — only `/checkpoint` does.

Add any items from the **1b.R drift checklist** that apply.

### 1b.4 Report and halt

Before reporting, run **SKILL.md Step 13b** (Obsidian vault link) — idempotent; its only repo footprint is the gitignored `conductor/memory` symlink.

If structural upgrades changed files and `conductor/.git` exists (private conductor repo), commit them inside it with `git -C conductor` — the parent repo ignores `conductor/`.

Report what was upgraded and what remains on the checklist, then halt — Steps 2–13 are for fresh initializations only.
