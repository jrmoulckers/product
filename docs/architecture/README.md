# Decision records

Architecture decision records (ADRs) are justified here only for durable choices
about this repository's authority, governance, structure, or cross-domain
contracts. They are not a home for application or infrastructure implementation
decisions.

## Convention

- Name records `NNNN-short-title.md`, beginning with `0001`.
- Copy `0000-template.md` and keep the record concise.
- Use `Proposed`, `Ratified`, or `Superseded by NNNN` as the status.
- Agents may create only `Proposed` records.
- Only the repository owner may change a record to `Ratified`.
- Preserve accepted records; supersede them rather than rewriting history.

## Records

- [0001: Ratify the Product principle catalog](0001-ratify-product-principles.md)
  is the owner-merge Ratification record for exactly 40 unchanged Product
  principles. It permanently reads `Proposed` because its own text reserves
  effectiveness to the owner merge rather than to any later edit of the record,
  and the repository validator enforces that wording. The separate
  [Ratification record](../ratification/2026-08-09-product-principles.md)
  states that the merge occurred.
- [0002: Correct three legacy-input references](0002-correct-legacy-input-references.md)
  authorizes the only permitted departure from the immutable source catalog:
  three `Legacy inputs` identifiers in `principles/content-operations.md`,
  enumerated in
  [legacy-input-corrections.json](../../principles/legacy-input-corrections.json).
  It changes no obligation, and it reads `Proposed` for the same reason 0001
  does.
