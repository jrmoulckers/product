# Product principles

This directory contains the 40-entry Product principle tree. Every principle has
**Ratified** catalog status. That status becomes effective only through the
repository owner's merge of
[decision record 0001](../docs/architecture/0001-ratify-product-principles.md);
before that owner action, the status change is an unapproved proposal.

## Ratified tree

| Area | Ratified IDs | Scope |
| --- | --- | --- |
| [Strategy](strategy.md) | `PROD-STRAT-001` through `PROD-STRAT-003` | Direction, evidence, and outcome milestones |
| [Planning and delivery](planning-and-delivery.md) | `PROD-PLAN-001` through `PROD-PLAN-005` | Slices, commitments, dependencies, backlog, and go/no-go |
| [Business](business.md) | `PROD-BUS-001` through `PROD-BUS-003` | Value, trust, viability, and market evidence |
| [Discovery and experiments](discovery-and-experiments.md) | `PROD-DISC-001` through `PROD-DISC-004` | Learning, hypotheses, exposure, and experiment decisions |
| [Metrics](metrics.md) | `PROD-MET-001` through `PROD-MET-003` | Definitions, collection bounds, and interpretation |
| [Compliance](compliance.md) | `PROD-COMP-001` through `PROD-COMP-009` | Obligations, privacy outcomes, data governance, licensing, and audit readiness |
| [Content operations](content-operations.md) | `PROD-CONTENT-001` through `PROD-CONTENT-009` | Contract documentation, public surfaces, examples, accessibility, terminology, and lifecycle |
| [Release decisions](release-decisions.md) | `PROD-REL-001` through `PROD-REL-004` | Readiness, risk acceptance, release identity, gaps, and cadence |

Each principle records a stable ID, status, imperative, rationale, observable
verification, ownership and ratification, authority handoff, and exact legacy
input IDs or `none`. Legacy input references provide traceability without making
the legacy Studio wording authoritative here.

The exact catalog validator rejects deletion, renumbering, reordering,
unauthorized or mixed statuses, and any status-excluded semantic drift.

## Legacy input resolution

`studio-legacy:<document>:<n>` resolves to the `n`th numbered principle in the
legacy Studio `principles/<document>.md` file on `main`. The validator accepts
only IDs within the confirmed no-gap range for each registered legacy source.
Resolution confirms historical existence, not adoption or authority. These
references identify migration inputs; the legacy wording remains non-authoritative.
