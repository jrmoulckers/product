# Product principles

This directory contains the proposed Product principle tree. Every principle is
**Draft** and unratified. The repository owner alone may ratify a principle.

## Draft tree

| Area | Draft IDs | Scope |
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

## Legacy input resolution

`studio-legacy:<document>:<n>` resolves to the `n`th numbered principle in the
legacy Studio `principles/<document>.md` file on `main`. The validator accepts
only the exact legacy IDs mapped by this tree. Adding a migration input requires
registering that source ID after resolving it. These references identify
migration inputs, not current authority.
