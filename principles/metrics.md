# Metrics principles

Draft Product obligations for decision-useful definitions, collection bounds, and interpretation.

## PROD-MET-001: Give each metric one versioned decision definition

- **Status:** Ratified
- **Principle:** Maintain one owned, versioned definition for each metric that states the decision it informs, formula, population, window, exclusions, and required inputs.
- **Rationale:** A metric cannot guide a decision when teams calculate different meanings or silently rewrite its history.
- **Verification:** The metric record has one identifier, owner, decision use, complete definition, version history and effective dates, input lineage requirement, and migration note for breaking changes.
- **Owner and ratification:** Product owns metric meaning and decision use; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering owns event schemas, pipelines, catalogs, and lineage evidence; Studio displays metrics without changing their meaning.
- **Legacy inputs:** `studio-legacy:data-analytics:3`, `studio-legacy:data-analytics:4`, `studio-legacy:data-analytics:5`, `studio-legacy:business:2`

## PROD-MET-002: Bound measurement by purpose and consent

- **Status:** Ratified
- **Principle:** Define the minimum data, population, purpose, consent dependency, access, retention, and deletion outcomes needed before approving measurement.
- **Rationale:** Decision value does not justify unbounded collection or reuse, and Product must make the intended boundary explicit before mechanisms are built.
- **Verification:** The metric record identifies purpose, necessary fields and population, prohibited reuse, consent dependency, retention and deletion outcomes, access need, and unresolved P1.2 obligations.
- **Owner and ratification:** Product owns measurement purpose and bounds; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Product P1.2 defines compliance obligations, Engineering implements and evidences controls, and Studio expresses consent or disclosure where required.
- **Legacy inputs:** `studio-legacy:data-analytics:1`, `studio-legacy:data-analytics:2`, `studio-legacy:data-analytics:7`

## PROD-MET-003: Interpret metrics honestly

- **Status:** Ratified
- **Principle:** Report metric results with uncertainty, limitations, guardrail context, material segments, and alternative explanations before making a decision.
- **Rationale:** A number without context can reward noise, hide harm, or turn correlation into an unsupported product claim.
- **Verification:** The readout includes definition version, observation window, sample and missingness, uncertainty, guardrails, relevant segments, caveats, and the decision the evidence supports or cannot support.
- **Owner and ratification:** Product owns interpretation and the resulting decision; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering provides data-quality and statistical evidence, Studio communicates results without distortion, and Product states the warranted conclusion.
- **Legacy inputs:** `studio-legacy:business:2`, `studio-legacy:featuring:5`
