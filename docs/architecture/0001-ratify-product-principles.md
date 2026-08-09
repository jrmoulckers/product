# 0001: Ratify the Product principle catalog

- **Status:** Proposed
- **Date:** 2026-08-09
- **Owner:** Repository owner

## Context

Source PR [#3](https://github.com/jrmoulckers/product/pull/3) proposed the 18
core Product principles, and source PR
[#4](https://github.com/jrmoulckers/product/pull/4) proposed the 22 compliance,
content-operations, and release-decision principles. Both source proposals
reserved Ratification to the repository owner.

## Decision

Propose Ratification of exactly these unchanged ranges:

- Core (18): `PROD-STRAT-001` through `PROD-STRAT-003`,
  `PROD-PLAN-001` through `PROD-PLAN-005`, `PROD-BUS-001` through
  `PROD-BUS-003`, `PROD-DISC-001` through `PROD-DISC-004`, and `PROD-MET-001`
  through `PROD-MET-003`.
- Compliance and operations (22): `PROD-COMP-001` through `PROD-COMP-009`,
  `PROD-CONTENT-001` through `PROD-CONTENT-009`, and `PROD-REL-001` through
  `PROD-REL-004`.

Only the 40 `Status` metadata values change from `Draft` to `Ratified`. IDs,
ordering, paths, principle statements, rationale, verification, ownership and
Ratification wording, handoffs, and Legacy inputs remain byte-for-byte
semantically unchanged from source PRs #3 and #4.

## Evidence required before merge

- Final owner review confirms the diff contains the 40 status changes,
  validation wiring, indexes, and this record, with no content or ownership
  change.
- Local Windows PowerShell and the GitHub-hosted `ubuntu-latest` PowerShell
  workflow run `./scripts/test-validate-repository.ps1` successfully.
- The exact-catalog validator derives paths, IDs, ordering, and
  status-excluded semantic hashes from immutable source PR #4 merge commit
  `b0b2ef66094bbc5abf19cd4ae0ac85b05f12ddb5`, which contains source PR #3,
  then reports 40 unique `Ratified` principles and the expected catalog hash.

## Consequences

The exact catalog becomes a required Product constraint only after effective
Ratification. This record creates no package, runtime, template, or new
authority. Compliance principles remain governance and qualified-review
triggers, not legal advice. Product still defines obligations and outcomes;
Engineering implements mechanisms and evidence, Studio expresses UI, and
`.github` automates.

## Handoffs

Engineering, Studio, and `.github` consume the ratified Product obligations
without inheriting Product decision authority or transferring their own
authority to Product.

## Ratification

This record contains no approval. If and only if the repository owner merges
the pull request that introduces it, that merge is the explicit Ratification
act and makes this decision effective. Reviews, agent-authored commits, green
validation, or approval or merge by anyone else do not ratify the catalog.
