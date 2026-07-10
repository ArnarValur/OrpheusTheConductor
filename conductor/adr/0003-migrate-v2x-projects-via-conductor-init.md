# Migrate v2.x projects via /conductor-init brownfield re-init

> **Recorded:** 2026-07-11 00:42
> **Status:** accepted

The ~10 live v2.x projects migrate to Orpheus v3.0 through the established `/conductor-init` brownfield path rather than a separate migration script or manual checklist: detect v2.x, preserve `conductor/` state untouched, retire `.agents/workflows/` copies, confirm plugin availability. Consistent with the v2.0 → v2.1 re-init precedent, keeping a single migration mechanism to maintain.
