# Compliance principles

Draft Product obligations for governed compliance outcomes and evidence expectations. These principles establish review triggers and do not provide legal advice.

## PROD-COMP-001: Trace every applicable obligation to evidence

- **Status:** Ratified
- **Principle:** Maintain an obligation record that links each applicable source and scope to affected product behavior, data categories, an accountable owner, acceptance criteria, status, and durable evidence.
- **Rationale:** Compliance cannot be reviewed when an obligation, decision owner, expected outcome, or proof is implicit.
- **Verification:** Every applicable obligation has the required links, no ownerless or stale record passes review, and no record is marked verified without current evidence.
- **Owner and ratification:** Product owns applicability, required outcomes, and acceptance state; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified humans determine legal applicability, Engineering implements controls and generates evidence, Studio expresses affected experiences, and `.github` may automate record checks.
- **Legacy inputs:** `studio-legacy:compliance:1`, `studio-legacy:compliance:6`

## PROD-COMP-002: Bound processing by purpose and necessity

- **Status:** Ratified
- **Principle:** Approve each processing purpose only with applicable data categories, minimum necessary population and fields, prohibited reuse, retention outcome, and a qualified legal or privacy determination of the governing basis.
- **Rationale:** A useful purpose does not justify collecting or reusing more data than the approved product outcome requires.
- **Verification:** The processing record links purpose, categories, population, fields, prohibited reuse, retention, governing-basis determination, reviewer, and reassessment trigger; unresolved legal interpretation is marked `Needs Legal Review` and blocks approval.
- **Owner and ratification:** Product owns purpose, necessity bounds, and product requirements; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified legal or privacy reviewers determine the governing basis, Engineering implements collection and use bounds and generates evidence, and Studio expresses required user-facing outcomes.
- **Legacy inputs:** `studio-legacy:compliance:1`, `studio-legacy:compliance:7`, `studio-legacy:data-analytics:1`, `studio-legacy:data-analytics:2`

## PROD-COMP-003: Map privacy rights to product behavior

- **Status:** Ratified
- **Principle:** Define the promised access, correction, export, deletion, and opt-out behavior for every applicable personal-data category, jurisdiction, deadline, and disclosed exception.
- **Rationale:** A named privacy right is not an actionable obligation until its end-to-end product result and limits are explicit.
- **Verification:** Scenario evidence covers each applicable right across in-scope stores and processors, including identity, response timing, status, exception, and completion outcomes.
- **Owner and ratification:** Product owns the promised privacy-right outcomes; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified legal or privacy reviewers confirm rights, deadlines, and exceptions; unresolved interpretation is marked `Needs Legal Review`, Engineering implements propagation and produces evidence, and Studio owns accessible request, status, and error expression.
- **Legacy inputs:** `studio-legacy:compliance:2`, `studio-legacy:compliance:4`, `studio-legacy:data-analytics:1`, `studio-legacy:data-analytics:6`

## PROD-COMP-004: Decide residency and transfer bounds before launch

- **Status:** Ratified
- **Principle:** Approve allowed storage and processing regions, processors, transfer conditions, and disclosure outcomes for each data category before launch or material change.
- **Rationale:** Residency and transfer constraints must shape a product decision before architecture or processor choices make them costly to reverse.
- **Verification:** The decision records approved categories, regions, processors, transfer basis, disclosures, reviewer, and expiry; any unmatched actual location, subprocessor, or transfer blocks readiness.
- **Owner and ratification:** Product owns allowed residency and transfer outcomes; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified legal or privacy review determines transfer validity; unresolved interpretation is marked `Needs Legal Review`, Engineering owns topology and enforcement evidence, Studio owns user-facing regional disclosure expression, and `.github` may automate change review.
- **Legacy inputs:** `studio-legacy:compliance:3`

## PROD-COMP-005: Bound retention and terminal disposition

- **Status:** Ratified
- **Principle:** Give every data category a purpose-linked retention period, start trigger, terminal disposition, documented exception or legal hold, and consequence for deletion or consent withdrawal.
- **Rationale:** Collection remains unbounded when Product cannot state when data expires, what replaces it, or why an exception applies.
- **Verification:** The approved schedule covers every category, and sampled expiry, deletion, aggregation, exception, and user-visible outcomes match it.
- **Owner and ratification:** Product owns retention, exception, and terminal-disposition requirements; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified legal or privacy reviewers approve durations, holds, and exceptions; unresolved interpretation is marked `Needs Legal Review`, Engineering implements deletion and backup behavior and generates evidence, and Studio expresses promised outcomes.
- **Legacy inputs:** `studio-legacy:compliance:2`, `studio-legacy:compliance:4`, `studio-legacy:data-analytics:6`

## PROD-COMP-006: Permit only reviewed software distribution

- **Status:** Ratified
- **Principle:** Require a known license classification, policy decision, publishing boundary, and fulfilled attribution, notice, source-offer, or other obligation before using or distributing software.
- **Rationale:** An unknown or incompatible license can invalidate a release decision even when the software is technically ready.
- **Verification:** Every included dependency and distributed artifact has a current disposition and required actions; unknown or disallowed licenses block release.
- **Owner and ratification:** Product owns permitted-use and distribution outcomes; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified legal review resolves licensing questions and boundary changes; unresolved interpretation is marked `Needs Legal Review`, Engineering owns inventories and generated artifacts, and `.github` owns license-policy automation.
- **Legacy inputs:** `studio-legacy:compliance:5`, `studio-legacy:security:2`

## PROD-COMP-007: Keep audit readiness continuous

- **Status:** Ratified
- **Principle:** Review compliance evidence, approvals, exceptions, owners, and remediation on a declared cadence instead of assembling readiness only for an audit or release.
- **Rationale:** Evidence that is missing, expired, or detached from its obligation cannot support a current readiness claim.
- **Verification:** Each review reports evidence freshness, expired approvals, open exceptions, accountable owners, due dates, remediation state, and any readiness decision it blocks.
- **Owner and ratification:** Product owns review cadence, evidence requirements, and exception acceptance; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering generates control evidence, qualified reviewers judge regulated claims, and `.github` may collect and report evidence without deciding readiness.
- **Legacy inputs:** `studio-legacy:compliance:1`, `studio-legacy:compliance:6`

## PROD-COMP-008: Make consent specific and revocable

- **Status:** Ratified
- **Principle:** Define each consent-dependent purpose with versioned disclosure requirements, granular choice, default state, receipt requirement, effective date, supported locales, and a withdrawal outcome no harder than granting consent.
- **Rationale:** Consent is not meaningful when purposes are bundled, wording drifts, choices are inaccessible, or withdrawal does not stop the promised processing.
- **Verification:** Purpose records and scenarios show the approved version, choice and receipt, localized disclosure, withdrawal path, downstream stop outcome, and treatment of previously collected data.
- **Owner and ratification:** Product owns purpose, required disclosure outcomes, and withdrawal promises; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified legal or privacy reviewers approve legal basis and regulated claims; unresolved interpretation is marked `Needs Legal Review`, Engineering enforces and evidences consent state, Studio owns user-facing wording and accessible choice expression, and `.github` may automate review.
- **Legacy inputs:** `studio-legacy:compliance:7`, `studio-legacy:data-analytics:2`, `studio-legacy:business:6`, `studio-legacy:localization:1`, `studio-legacy:localization:2`, `studio-legacy:localization:8`, `studio-legacy:localization:9`

## PROD-COMP-009: Use data categories and synthetic examples

- **Status:** Ratified
- **Principle:** Describe compliance work with an approved data-category vocabulary and use explicitly labeled synthetic examples instead of production identifiers or raw personal data.
- **Rationale:** Evidence and review artifacts should explain obligations without creating another uncontrolled copy of sensitive data.
- **Verification:** Sampled matrices, assessments, release records, screenshots, and examples use approved categories, contain no production personal data, and label synthetic values.
- **Owner and ratification:** Product owns the category vocabulary and artifact-content outcome; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering owns sanitization mechanisms, Studio owns safe visual examples, and `.github` may check governed artifacts without receiving production data.
- **Legacy inputs:** `studio-legacy:compliance:8`, `studio-legacy:business:2`
