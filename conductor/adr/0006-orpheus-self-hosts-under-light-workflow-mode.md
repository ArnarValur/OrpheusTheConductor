# Orpheus self-hosts under Light workflow mode

> **Recorded:** 2026-07-11 02:32
> **Status:** accepted

Orpheus's own `conductor/workflow.md` switches from Strict (TDD + coverage gates) to **Light** (flexible iteration with verification checkpoints). Orpheus is a pure markdown + shell product — its Commands have no unit-test or code-coverage surface, so the Strict lifecycle's Red→Green→Refactor and ">80% coverage" gates are unenforceable and misleading when applied to itself. Light mode matches how the product is actually built and verified (contract correctness + golden-session smoke, not unit tests). This governs Orpheus self-hosting only; both Strict and Light remain offered to projects Orpheus scaffolds. Implemented in the v3.0 Port track (`v3_port_20260711`, F4).

## Considered Options

- **Keep Strict, redefine the gates** — reinterpret "tests" as contract-lint + golden-session evals. Rejected: those tools are v3.1-deferred, creating a forward dependency, and it stretches "TDD" past recognition.
- **Defer the decision** — leave `workflow.md` Strict and only fix its header in the rename sweep. Rejected: leaves a self-contradicting workflow document shipping as the reference example.
