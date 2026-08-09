# Release decision principles

Draft Product obligations that make release readiness and risk acceptance explicit without owning build, version, deployment, or workflow mechanisms.

## PROD-REL-001: Decide against explicit release readiness

- **Status:** Ratified
- **Principle:** Specialize `PROD-PLAN-005` for a formal release by defining readiness criteria for accepted scope, required evidence, P0 and P1 treatment, security, privacy, compliance, accessibility, localization, content, rollback, and support.
- **Rationale:** Green technical checks are necessary evidence but cannot silently accept unmet Product obligations.
- **Verification:** The dated decision names scope, accountable Product owner, every criterion and evidence link, unresolved severity, final state, rationale, and deterministic no-go conditions.
- **Owner and ratification:** Product owns readiness criteria and the final release decision; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering supplies build, test, security, deployment, and rollback evidence; Studio supplies UX, accessibility, and localization evidence; `.github` automates checks without deciding release.
- **Legacy inputs:** `studio-legacy:project-planning:7`, `studio-legacy:process:4`, `studio-legacy:process:5`, `studio-legacy:process:6`, `studio-legacy:security:6`, `studio-legacy:documentation:4`

## PROD-REL-002: Make risk acceptance explicit and expiring

- **Status:** Ratified
- **Principle:** Require a qualified human to accept each releasable P1 or other material gap with affected outcome, evidence, rationale, compensating action, accountable owner, expiry, and remediation trigger; unresolved P0 risk is no-go.
- **Rationale:** A release exception without named human accountability and an end condition converts a conscious tradeoff into permanent hidden risk.
- **Verification:** Every accepted risk has the required record and remains within expiry; unresolved P0 items and unaccepted or expired material risks block go.
- **Owner and ratification:** Product owns product-risk acceptance and severity treatment; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified security, legal, accessibility, or other reviewers accept risks in their authority, Engineering and Studio own remediation, and `.github` may enforce expiry.
- **Legacy inputs:** `studio-legacy:project-planning:3`, `studio-legacy:project-planning:7`, `studio-legacy:process:5`, `studio-legacy:security:6`

## PROD-REL-003: Identify the released outcome and disclose gaps

- **Status:** Ratified
- **Principle:** Require every release decision to identify the exact runtime outcome and evidence set, trace it to approved scope and changes, and disclose known compatibility, parity, documentation, and support gaps.
- **Rationale:** Users and operators cannot reason about a release when its runtime identity differs from its label or known gaps remain implicit.
- **Verification:** Release evidence resolves version and runtime identity to approved scope, changes, artifacts, environments, documentation, parity state, accepted gaps, and supported rollback target.
- **Owner and ratification:** Product owns traceability requirements and gap disclosure outcomes; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering implements version, artifact, provenance, runtime, and rollback evidence; Studio expresses relevant gaps; `.github` automates traceability and publication.
- **Legacy inputs:** `studio-legacy:project-planning:2`, `studio-legacy:project-planning:6`, `studio-legacy:project-planning:7`, `studio-legacy:process:6`

## PROD-REL-004: Release on a meaningful cadence

- **Status:** Ratified
- **Principle:** Choose a release cadence that delivers coherent user value, creates timely learning, preserves supportability, and does not batch unrelated risk merely to satisfy a calendar.
- **Rationale:** Cadence is useful when it shortens feedback without turning date compliance into a substitute for a meaningful and ready outcome.
- **Verification:** The release plan states the coherent outcome, target cadence, evidence window, support capacity, dependency timing, deferral rule, and rationale for any batch or delay.
- **Owner and ratification:** Product owns release timing and outcome coherence; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering provides delivery and operational capacity evidence, Studio provides experience-readiness evidence, and `.github` automates schedules without setting cadence.
- **Legacy inputs:** `studio-legacy:project-planning:1`, `studio-legacy:project-planning:2`, `studio-legacy:process:4`, `studio-legacy:process:6`
