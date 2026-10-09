---
name: conductor-init
description: Sets up Orpheus's conductor/ folder in a project, or refreshes an existing one in place without touching its state — emits the self-contained /conductor and /checkpoint commands and links the conductor as an Obsidian vault when ~/Documents/Project-Vaults/ exists. Use when the user wants to initialize, set up or bootstrap the conductor (or Orpheus) in a repo, upgrade or refresh an existing conductor after an Orpheus plugin update, or migrate a TheOracle v2.x project.
---

# Conductor Init

Plugin root for this run: `${CLAUDE_PLUGIN_ROOT}` — the reference files write it as `<plugin-root>`. Every conductor read and write targets `conductor/` in the project root.

**Shape contract (v3.1):** init emits a state-only pulse, a story-only relay, a workflow carrying the two laws, a static index, and self-contained `/conductor` + `/checkpoint` commands. Emitted files never reference `/conductor-init` and never hold static live-state — they say "enumerate live".

If you loaded this skill on your own (the user didn't ask to set up, refresh or upgrade the conductor), confirm before the first write — init creates files and commits.

## Route

Copy this checklist into your reply and tick it as you go:

```text
- [ ] Step 0   Hands-off guard
- [ ] Step 1   Detect maturity
- [ ] Step 1b  Existing conductor/ → references/upgrade.md (refresh or upgrade) → report, halt
- [ ] Steps 2–13  No conductor/ → references/fresh-init.md
- [ ] Step 11b Emit the commands (both paths, below)
- [ ] Step 13b Vault link (both paths, below)
```

- **Existing `conductor/`** → [references/upgrade.md](references/upgrade.md): retires v2.x remnants, refreshes a current conductor, or upgrades an old-shape one. It never rewrites state.
- **No `conductor/`** → [references/fresh-init.md](references/fresh-init.md): the product, guidelines and stack interview, then scaffolding.
- **v2.x remnants** (`.agents/workflows/`, a root `plugin.json` named `the-oracle`, `TheOracle`-headed files) → the [migrate protocol](${CLAUDE_PLUGIN_ROOT}/protocols/migrate.md) runs first, as upgrade.md Step 1b.0 says.

## Step 0: Hands-off guard

```bash
grep -qi 'orpheus: hands-off' conductor/agent-rules/behavioral.md 2>/dev/null && echo HANDS-OFF
```

- `HANDS-OFF` → halt before any write: *"⛔ `agent-rules/behavioral.md` marks this conductor `orpheus: hands-off` — init won't touch it. Change it by hand, or remove that line first."*
- No marker, but `behavioral.md` still says in other words that *this* repo's conductor must not be regenerated or written by tooling → stop and ask before any write. Rules that name a different repo don't count.

## Step 1: Detect project maturity

- **Existing conductor** — `conductor/` exists. Ask: "A `conductor/` directory already exists. **Refresh/upgrade in place** (all state is preserved; anything that needs judgment comes back to you as a checklist) or **abort**?" Abort → halt. Otherwise → Step 1b.
- **Brownfield** — no conductor, but any of: `.git` / `.svn` / `.hg`; a manifest (`package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pubspec.yaml`, `pom.xml`); `src/`, `app/` or `lib/` holding code. Announce it. If `git status` shows uncommitted changes, warn: "Commit or stash before proceeding." Run a read-only scan (README, manifests, directory layout; respect `.gitignore`) and summarize the inferred stack, architecture and goal. → Steps 2–13.
- **Greenfield** — none of the above. Ask "What are you building?", then `git init` if there is no `.git`. → Steps 2–13.

## Step 11b: Emit the commands

Both paths put the two self-contained commands in `.claude/commands/`. Compare first:

```bash
mkdir -p .claude/commands
for c in conductor checkpoint; do
  src="${CLAUDE_PLUGIN_ROOT}/templates/commands/$c.md"; dst=".claude/commands/$c.md"
  if [ ! -s "$src" ]; then echo "$c: TEMPLATE UNREADABLE ($src) — stop, start a new session"
  elif [ ! -f "$dst" ]; then echo "$c: missing"
  elif grep -v '^<!-- Template:' "$src" | diff -q - "$dst" >/dev/null; then echo "$c: current"
  else echo "$c: differs"; fi
done
```

- `missing` → write it. `current` → leave it. `differs` → show the `diff` and ask before overwriting (the human may have edited it). `TEMPLATE UNREADABLE` → write nothing; the plugin path is stale (usually a mid-session plugin update).
- Write one file at a time, header comment stripped. The temp file + move means a failed read can never leave an empty command behind:

```bash
c=conductor   # or: c=checkpoint
src="${CLAUDE_PLUGIN_ROOT}/templates/commands/$c.md"; dst=".claude/commands/$c.md"
[ -s "$src" ] && grep -v '^<!-- Template:' "$src" > "$dst.tmp" && command mv -f "$dst.tmp" "$dst" && echo "$c: written" || { command rm -f "$dst.tmp"; echo "⚠️ $c not written"; }
```

This gives the repo `/conductor` (boot: hot set only, warm-load table, ~10-line status) and `/checkpoint` (pulse rewrite, one relay entry, lesson graduation, fold to main) **with no plugin dependency**.

**Invariants for emitted files — hold them on every template edit:**

- Halt messages give the git-history recovery commands and never point at `/conductor-init` — consumer repos may not carry it.
- No plugin-root path, no mention of the Orpheus plugin, no file init does not emit.
- No static live-state — instructions say "enumerate live".
- `/checkpoint` keeps `disable-model-invocation: true`: it rewrites pulse, appends relay, commits and pushes, so only the human starts it.

## Step 13b: Obsidian vault link

Run on fresh inits and on every refresh or upgrade, from the project root:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/conductor-init/scripts/vault-link.sh"
```

It skips quietly when `~/Documents/Project-Vaults/` doesn't exist (that folder is the opt-in). Otherwise it links `~/Documents/Project-Vaults/<project> → <repo>/conductor` (the vault IS the conductor — never a copy or sync) and `conductor/memory → ~/.claude/projects/<slug>/memory`, gitignored and committed on its own. If it reports a real folder in the way, pass that message to the human as is — never move or delete the folder yourself.

## Gotchas

- **Plugin updates reach new sessions only.** After updating Orpheus, run `/conductor-init` in a fresh session, or you run the old copy.
- **Interactive shell aliases hang tool-run copies.** Some shells alias `cp`/`mv`/`rm` to `-i`, and a tool-run `cp` over an existing file then waits forever for "y". Use `command cp -f` / `command mv -f`; the snippets here already do.
- **Private conductor repo** — when `conductor/.git` exists, commit conductor changes with `git -C conductor`. The parent repo ignores `conductor/` and gets only `.claude/commands/`, and only if it tracks them.
- **Append to `.gitignore` files, never replace them.** A replaced `conductor/.gitignore` once dropped its secrets rules for a commit.

Ask every multiple-choice question with `AskUserQuestion`; fall back to plain-text options only if the tool fails.
