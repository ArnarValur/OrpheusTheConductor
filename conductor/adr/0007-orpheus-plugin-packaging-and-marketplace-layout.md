# Orpheus plugin packaging + marketplace layout

> **Recorded:** 2026-07-11 03:11
> **Status:** accepted

Orpheus v3.0 is packaged as a **plugin at the repository root** — manifest at `.claude-plugin/plugin.json`, the four session Commands in `commands/` (`/conductor`, `/grill`, `/new-track`, `/checkpoint`), `conductor-init` as a **Skill** (`skills/conductor-init/`, so it can auto-suggest on uninitialized projects), and Protocols + templates bundled at the plugin root and referenced via `${CLAUDE_PLUGIN_ROOT}`. The **same repo doubles as a git-sourced marketplace** (`.claude-plugin/marketplace.json`, name `merkurial-studio`) with the plugin listed at `"source": "."`. This resolves the PRD open question on distribution mechanics: distribution is a git-sourced marketplace, installed via `/plugin marketplace add <repo>` → `/plugin install orpheus@merkurial-studio` (or `claude --plugin-dir .` for local dev). `claude plugin validate .` passes on this layout.

## Considered Options

- **Plugin in a `plugins/orpheus/` subdir** (the docs' primary walkthrough) — cleaner if the repo ever hosts multiple plugins, but nests the entire product under a subdir of its own repo and churns every path. Chosen root-layout instead because Orpheus is a single-plugin repo; `conductor/` self-hosting state and design docs stay naturally at root, the plugin *is* the repo. Revisit the subdir layout only if a second plugin joins the marketplace.
- **`.claude/commands/` (project-command dir)** — how the Commands were bootstrapped, but that location is deprecated for plugins and would not be discovered once installed.
- **All five as Commands** — uniform, but loses `conductor-init`'s Skill auto-invocation on uninitialized projects.

## Consequences

- Plugin Commands are namespaced as `/orpheus:<name>` (e.g. `/orpheus:conductor`); the bare `/<name>` form still works when unambiguous.
- The Antigravity copy-to-`.agents/workflows/` deploy model is fully retired — installation replaces deployment (see Phase 2 + the `conductor-init` workflow rewrite).
- `plugin.json` omits `homepage`/`repository`/`license` until a git remote exists; the marketplace `source: "."` and live command registration in Claude Code CLI + Cowork still require a real install verification.
