# Protocol: Migrate (v2.x → v3.0)

<!-- Source: Orpheus v3.0 @ 2026-07-11 -->

> Migrates a v2.x project (Antigravity / TheOracle, ≤ v2.1) onto Orpheus v3.0.
>
> **Used by:** `/conductor-init` — invoked when it detects a v2.x conductor.
> **Signposted by:** `/conductor` — when v2.x remnants are found on resume.

This protocol is **transient by design** (ADR 0004): it exists to move the ~10 live v2.x projects onto the Orpheus plugin, and is retired once they are all migrated. It **preserves `conductor/` state untouched** (ADR 0003) — the migration retires the old Antigravity deploy copies and confirms the plugin; it does NOT rewrite the user's pulse, relay, tracks, ADRs, glossary, or project-context.

## 1. Detection — is this a v2.x project?

Classify as v2.x if ANY of these remnants are present:

| Signal | Meaning |
|--------|---------|
| `.agents/workflows/` directory exists | Antigravity deploy target (per-project command copies) |
| A root `plugin.json` with `"name": "the-oracle"` | legacy plugin identity |
| File headers reading `<!-- Template: TheOracle v2.x -->` or `# Source: TheOracle v…` | v2.x-era templated files |
| `conductor/` exists, but its Commands were never sourced from the installed Orpheus plugin | pre-plugin install |

If none are present, this is already v3.0 (or greenfield) — halt and report *"nothing to migrate."*

## 2. Safety gate

1. Confirm a clean working tree, or ask the user to commit/stash first.
2. Recommend a migration branch (or record the current SHA for rollback): `git switch -c migrate/orpheus-v3`.
3. This protocol is **idempotent** — re-running it on a partially-migrated project is safe.

## 3. Migration actions (in order)

1. **Preserve `conductor/` state.** Do NOT modify `conductor/pulse.md`, `relay.md`, `tracks.md`, `tracks/`, `adr/`, `context.md`, `prd.md`, `project-context.md`, `pulse-archive/`, `agent-rules/`, or `code_styleguides/`. Their content is the user's — migration leaves it byte-for-byte.

2. **Retire the deploy copies.** Remove the Antigravity command copies — the installed Orpheus plugin supersedes them:
   ```bash
   git rm -r .agents/workflows/ 2>/dev/null || true
   # also remove a root-level workflows/ copy IF it is byte-identical to the plugin's Commands
   ```

3. **Confirm the plugin is available.** Verify the Orpheus plugin is installed and its Commands resolve (`/orpheus:conductor`, or bare `/conductor`). If not installed, direct the user to install it before continuing:
   > `/plugin marketplace add <orpheus-repo-url>` → `/plugin install orpheus@merkurial-studio` (or `claude --plugin-dir <path>` for local dev).

   The plugin — not per-project copies — now provides the Commands.

4. **Ship the secrets gitignore** (ADR 0005). If `conductor/.gitignore` is absent, create it so local convenience files stay handy but never travel:
   ```gitignore
   # conductor/.gitignore — local convenience files, never committed
   docs/keys/
   *.env
   .obsidian/
   ```
   If secrets were **already committed** in history, warn the user — this protocol does not rewrite git history.

5. **Reconcile the index.** Run the [Index Sync protocol](./index-sync.md) so `conductor/index.md` reflects what is actually on disk. (v3.0 changes no state format — index sync is unchanged.)

## 4. What this protocol does NOT do

- It does **not** rewrite user content or "modernize" stale headers inside `conductor/` — preservation over cleanup (ADR 0003).
- It does **not** auto-fix forked ADR numbering, dual / divergent PRDs, or other per-project drift (observed in the wild, e.g. DittoDatto). Those are **surfaced to the user as manual follow-ups**, never touched automatically.
- It does **not** change any `conductor/` state format — pulse, relay, tracks, and ADR formats are identical in v3.0.

## 5. Report + commit

1. Summarize: what was retired (`.agents/workflows/`, any redundant `workflows/`), whether `conductor/.gitignore` was added, and any manual follow-ups flagged.
2. Commit: `migrate: v2.x → Orpheus v3.0 (retire deploy copies, add secrets gitignore)`.
3. Tell the user to run `/conductor` to confirm the resume works on the plugin.
