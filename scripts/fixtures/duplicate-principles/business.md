# Duplicate principle fixture

## PROD-BUS-999: Preserve unique identifiers

- **Status:** Draft
- **Principle:** Give every principle a unique identifier.
- **Rationale:** Stable references require unambiguous identifiers.
- **Verification:** The identifier appears once in the principle tree.
- **Owner and ratification:** Product owns identifier uniqueness; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** `.github` runs the validator without assigning Product identifiers.
- **Legacy inputs:** none

## PROD-BUS-999: Reject reused identifiers

- **Status:** Draft
- **Principle:** Reject an identifier already assigned to another principle.
- **Rationale:** Duplicate identifiers make references ambiguous.
- **Verification:** The validator reports the reused identifier.
- **Owner and ratification:** Product owns identifier uniqueness; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** `.github` runs the validator without assigning Product identifiers.
- **Legacy inputs:** none
