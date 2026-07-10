# Distribute Orpheus as a Claude Code plugin

> **Recorded:** 2026-07-11 00:42
> **Status:** accepted

Orpheus v3.0 ships as a Claude Code plugin (Commands + skills bundled, installed once) instead of copying command files into each project's `.agents/workflows/`. One install serves every project across Claude Code CLI and Cowork, ending fan-out deployments — on 2026-06-18 a single bug fix required 21 file updates across 10 projects. Conductor state (`conductor/`) still travels with each repo.

## Consequences

- The "workflows must be self-contained, protocols inlined" constraint dissolves — the plugin carries `protocols/` alongside Commands.
- Interactive prompts port from Antigravity's `ask_question` to Claude's `AskUserQuestion`.
- Per-project command copies become legacy; see ADR 0003 for migration.
