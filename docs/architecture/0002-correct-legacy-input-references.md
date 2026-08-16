# 0002: Correct three legacy-input references

- **Status:** Proposed
- **Date:** 2026-08-10
- **Owner:** Repository owner

## Context

[Decision record 0001](0001-ratify-product-principles.md) ratified the catalog by
changing exactly the 40 `Status` values and committed that every other field
remains byte-for-byte semantically unchanged from source proposals
[#3](https://github.com/jrmoulckers/product/pull/3) and
[#4](https://github.com/jrmoulckers/product/pull/4). The repository validator
enforces that by deriving expected semantic hashes at runtime from immutable
source commit `b0b2ef66094bbc5abf19cd4ae0ac85b05f12ddb5`.

Three `Legacy inputs` references in `principles/content-operations.md` name the
wrong legacy principle. Verified against the legacy Studio
`principles/documentation.md` headings at migration baseline
`efe6aa3b5ad020331a91f533844b0b9f70d70b76`:

| Principle | Source cites | That legacy rule is | Correct input |
| --- | --- | --- | --- |
| `PROD-CONTENT-002` Enumerate every public surface | `documentation:3` | Examples are runnable and match the current code | `documentation:2` Public API surface is documented and enumerated |
| `PROD-CONTENT-003` Keep examples executable and current | `documentation:4` | Docs change in the same PR as the code they describe | `documentation:3` Examples are runnable and match the current code |
| `PROD-CONTENT-006` Use diagrams when relationships need them | `documentation:3` | Examples are runnable and match the current code | `documentation:5` Diagrams clarify architecture and flow |

Each correction matches the successor recorded in the
[Studio migration ledger](https://github.com/jrmoulckers/studio/blob/main/principles/migration-ledger.json),
which maps `documentation:2`, `:3`, and `:5` to these three principles. Studio
already documented the mismatch: its ledger carries `citationException` entries
of kind `externally-verified-ownership` stating that "its merged Legacy inputs
cites documentation:3 rather than documentation:2". The defect was known
upstream and never recorded here.

Before this correction, `studio-legacy:documentation:5` was claimed by no
principle in the catalog, while `PROD-CONTENT-006`, the diagrams principle, cited
the examples rule.

No obligation is affected. Legacy inputs carry migration traceability only, and
resolution confirms historical existence, not adoption or authority. Every
principle statement, rationale, verification, ownership, handoff, and ID is
unchanged, and every citation in consuming repositories remains correct. The cost
is provenance: tracing `PROD-CONTENT-006` to its origin lands on the wrong rule,
and the diagrams rule appears dropped in migration when it was not.

## Decision

Authorize exactly three corrections, enumerated in
[`principles/legacy-input-corrections.json`](../../principles/legacy-input-corrections.json),
each replacing one `Legacy inputs` line with a version differing by a single
legacy identifier.

The validator applies this list to the immutable source text before computing
expected semantic hashes. The freeze guarantee becomes: ratification changed only
the 40 `Status` values, plus exactly the corrections enumerated in that file. Any
principle-file difference not enumerated there still fails
`PRINCIPLE_SEMANTIC_DRIFT`.

The immutable source commit is not re-pinned. `b0b2ef66094bbc5abf19cd4ae0ac85b05f12ddb5`
remains the historical record of what was proposed, and the correction list is
the auditable delta against it.

## Scope

Corrected:

- `PROD-CONTENT-002`, `PROD-CONTENT-003`, and `PROD-CONTENT-006` `Legacy inputs`
  lines, one legacy identifier each.

Not corrected:

- `PROD-CONTENT-005` cites `studio-legacy:documentation:6` where
  `studio-legacy:documentation:7` is a closer subject match. The ledger assigns
  `documentation:7` to `PROD-CONTENT-008` and records no legacy input for
  `PROD-CONTENT-005`. Legacy inputs may legitimately be broader than the
  ledger's primary successor, so this is unsupported rather than demonstrably
  wrong, and correcting it would rest on subject judgement rather than evidence.
- Additional `documentation:6` references retained on `PROD-CONTENT-003` and
  `PROD-CONTENT-006`. Only the demonstrably wrong identifier in each line
  changes.
- Every principle statement, rationale, verification, ownership and Ratification
  wording, handoff, ID, ordering, and path.

## Evidence required before merge

- Each correction's `from` string matches its source line exactly once; the
  validator fails if a correction is unused, ambiguous, or already applied.
- The corrected source reproduces the working-tree principle files exactly,
  with `Status` values excluded.
- `./scripts/test-validate-repository.ps1` passes, including negative fixtures
  proving that an unenumerated change, a mutated correction, and a removed
  correction each still fail.
- The semantic catalog hash changes exactly once, from
  `e906730c0648b240d2dfe0062da07ac9114cf70fb5951902b21a3b80d177d16d` to
  `8dd1e14c3f5455a248656c44bfd5598b250e6439bbaece49c7ddfa52c6e1b0c0`, and the
  new value is recorded in the Ratification record written after the owner merge.

## Consequences

The catalog gains an auditable correction mechanism bounded to enumerated,
evidence-backed changes. The mechanism can be abused to launder edits, so the
validator requires every correction to be used, unambiguous, and reproduced in
the working tree, and this record requires ledger evidence for each entry.

Ratification is the repository owner's act. Merging the pull request that carries
this record makes the corrections effective; until then they are proposed.
