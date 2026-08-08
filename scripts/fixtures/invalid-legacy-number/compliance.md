# Invalid legacy number fixture

## PROD-COMP-997: Reject unmapped legacy numbers

- **Status:** Draft
- **Principle:** Reject legacy references that do not resolve to a mapped source principle.
- **Rationale:** A valid source slug does not make an invented principle number traceable.
- **Verification:** The validator rejects a source number outside the Product migration map.
- **Owner and ratification:** Product owns migration traceability; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Studio preserves its legacy source history.
- **Legacy inputs:** `studio-legacy:compliance:999`
