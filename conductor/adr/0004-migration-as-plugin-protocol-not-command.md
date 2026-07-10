# Migration as plugin protocol, not a command

> **Recorded:** 2026-07-11 01:10
> **Status:** accepted

Refines ADR 0003: the v2.x → v3.0 migration logic lives in `protocols/migrate.md` inside the Orpheus plugin — invoked by `/conductor-init` when it detects a v2.x conductor, and signposted by `/conductor` resume when `.agents/workflows/` remnants are found. A dedicated `/conductor-migrate` command was considered and rejected: commands are permanent API surface, while this need is transient (~10 runs); a protocol file is retired far more cheaply than a public command is deprecated. First concrete application of ADR 0002's consequence that protocols may ship un-inlined inside the plugin.

## Considered Options

- `/conductor-migrate` sixth command — clearest verb semantics, but permanent surface for a transient need.
- Inline in `conductor-init.md` — zero new files, but grows the already-largest command (460 lines) and buries the migration path.
