# Conductor state stays gitted; secrets are gitignored

> **Recorded:** 2026-07-11 01:59
> **Status:** accepted

Conductor state remains git-tracked — cross-machine sync (PlutoII ↔ Saturn), state history, git-aware `/revert`, and self-hosting all depend on it. The real hazard observed in the wild (DittoDatto carried live `.env` files and a service-account key under `conductor/docs/keys/`) is secrets, not git. Therefore `/conductor-init` ships a `.gitignore` inside `conductor/` covering `docs/keys/`, `*.env`, and `.obsidian/`, so local convenience files stay handy but never travel.

## Considered Options

- Never gitted ("corner rule") — maximum privacy, but rewrites the commit step in all five Commands and loses sync, history, and revert.
- Per-project toggle at init — flexible, but two persistence models to maintain.
