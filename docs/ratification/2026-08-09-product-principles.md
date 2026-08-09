# Product principle Ratification

- Decision state: Effective. The repository owner `jrmoulckers` merged
  [PR #5](https://github.com/jrmoulckers/product/pull/5) on 2026-08-09 as merge
  commit `3a752c11856515a74eb204675d5d5198cac1e48e`. That merge is the explicit
  Ratification act described in
  [decision record 0001](../architecture/0001-ratify-product-principles.md).
- Catalog: `PROD-STRAT-001` through `PROD-STRAT-003`; `PROD-PLAN-001` through
  `PROD-PLAN-005`; `PROD-BUS-001` through `PROD-BUS-003`; `PROD-DISC-001`
  through `PROD-DISC-004`; `PROD-MET-001` through `PROD-MET-003`;
  `PROD-COMP-001` through `PROD-COMP-009`; `PROD-CONTENT-001` through
  `PROD-CONTENT-009`; `PROD-REL-001` through `PROD-REL-004` (40 total: 18 core
  and 22 compliance, content, and release operations).
- Source proposals: [PR #3](https://github.com/jrmoulckers/product/pull/3) and
  [PR #4](https://github.com/jrmoulckers/product/pull/4), preserved at immutable
  source commit `b0b2ef66094bbc5abf19cd4ae0ac85b05f12ddb5`.
- Content changes: None; only the 40 Status fields changed from Draft to
  Ratified.
- Ownership changes: None; owner and Ratification wording, authority handoffs,
  and Legacy inputs remain unchanged from the source proposals.

## Why this record is separate from decision record 0001

Decision record 0001 is the immutable record of the *proposal*. It permanently
reads `Status: Proposed` because its own text reserves effectiveness to the
owner merge rather than to any edit of the file, and the repository validator
enforces that wording. This record states the separate, later fact that the
owner merge occurred, without rewriting the proposal it ratified.

## Scope of effect

The 40 Ratified principles are required Product constraints for work in this
repository and are citable obligations for consuming repositories. Ratification
transfers no authority: Product defines obligations and outcomes, Engineering
implements mechanisms and evidence, Studio expresses the user interface, and
`.github` automates. Compliance principles remain governance and
qualified-review triggers, not legal advice.
