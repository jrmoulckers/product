# Duplicate metadata fixture

## PROD-BUS-997: Keep metadata singular

- **Status:** Draft
- **Status:** Draft
- **Principle:** Record each required metadata field exactly once.
- **Rationale:** Duplicate metadata makes the governing value ambiguous.
- **Verification:** The validator rejects a repeated required field.
- **Owner and ratification:** Product owns principle metadata; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** `.github` runs the validator without defining Product metadata.
- **Legacy inputs:** none
