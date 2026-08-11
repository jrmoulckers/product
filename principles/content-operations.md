# Content operations principles

Draft Product obligations for keeping product, policy, and release content usable and current without owning technical implementation documentation or GitHub-native templates.

## PROD-CONTENT-001: Keep contract documentation beside governed artifacts

- **Status:** Ratified
- **Principle:** Require every governed product or technical contract artifact to carry or directly resolve to canonical, version-correct documentation with an owner, audience, compatibility promise, and change policy.
- **Rationale:** Contract documentation that is detached from the artifact it governs becomes difficult to discover and easy to contradict.
- **Verification:** Each governed artifact carries or directly links one canonical contract document with matching version, ownership, audience, compatibility, and change-policy metadata.
- **Owner and ratification:** Product owns the documentation obligation and acceptance outcome; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering authors technical contract content and adjacency mechanisms, Studio authors experience contracts in its realm, and `.github` may validate placement without owning content.
- **Legacy inputs:** `studio-legacy:documentation:1`, `studio-legacy:documentation:2`

## PROD-CONTENT-002: Enumerate every public surface

- **Status:** Ratified
- **Principle:** Maintain an owned inventory of public product, policy, support, integration, and release surfaces with the documentation required for each audience.
- **Rationale:** Content coverage cannot be assessed when public promises and entry points are discovered only after users encounter them.
- **Verification:** The inventory names every public surface, audience, canonical content, owner, lifecycle state, supported locales, and any approved documentation gap.
- **Owner and ratification:** Product owns public-surface enumeration and required coverage; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering and Studio identify surfaces in their realms, while `.github` may automate inventory checks and repository health-file distribution.
- **Legacy inputs:** `studio-legacy:documentation:2`, `studio-legacy:security:8`

## PROD-CONTENT-003: Keep examples executable and current

- **Status:** Ratified
- **Principle:** Require examples that make behavioral or technical claims to use supported interfaces, state prerequisites and expected results, and remain executable where execution is meaningful.
- **Rationale:** An example that cannot be reproduced teaches a stale or false contract.
- **Verification:** Each governed example names its supported context and expected result, and current execution evidence or an explicit non-executable rationale accompanies review.
- **Owner and ratification:** Product owns the example-currentness outcome; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering authors and executes technical examples, Studio owns experience examples, and `.github` may automate execution without redefining the claim.
- **Legacy inputs:** `studio-legacy:documentation:3`, `studio-legacy:documentation:6`

## PROD-CONTENT-004: Update required content in the same change

- **Status:** Ratified
- **Principle:** Change affected product, policy, contract, support, migration, localization, and release content with the behavior or decision that makes it stale.
- **Rationale:** Deferred documentation creates a period in which the product and its promises disagree.
- **Verification:** Change evidence identifies affected content and locales, includes their updates, or records an approved gap with owner, user impact, expiry, and release decision.
- **Owner and ratification:** Product owns content currency and accepted gaps; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering updates technical documentation, Studio updates experience content, and `.github` may enforce change workflows without deciding sufficiency.
- **Legacy inputs:** `studio-legacy:documentation:4`, `studio-legacy:localization:9`

## PROD-CONTENT-005: Structure content for accessible use

- **Status:** Ratified
- **Principle:** Define content with descriptive headings, meaningful link text, text alternatives, plain language, logical reading order, and non-visual equivalents for essential information.
- **Rationale:** Content is incomplete when its structure or wording prevents people from perceiving, navigating, or understanding it.
- **Verification:** Content review records structure, reading order, links, alternatives, language clarity, and qualified accessibility findings for every supported presentation.
- **Owner and ratification:** Product owns source-content accessibility requirements; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Studio owns accessible presentation and interaction evidence, Engineering owns rendering mechanisms, and qualified humans approve any legal conformance claim.
- **Legacy inputs:** `studio-legacy:documentation:6`, `studio-legacy:accessibility:1`

## PROD-CONTENT-006: Use diagrams when relationships need them

- **Status:** Ratified
- **Principle:** Require an explicit diagram decision for governed content whose acceptance depends on sequence, state transitions, cross-authority ownership, or system relationships.
- **Rationale:** The right visual model can expose gaps and make a cross-authority contract reviewable without replacing precise text.
- **Verification:** Content classified in any listed relationship category includes a maintained diagram, surrounding explanation, accessible equivalent, owner, and update trigger, or records why a diagram would not improve the decision.
- **Owner and ratification:** Product owns when a governed explanation requires a diagram; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering and Studio validate realm accuracy and accessible rendering, while `.github` may automate diagram rendering and freshness checks.
- **Legacy inputs:** `studio-legacy:documentation:5`, `studio-legacy:documentation:6`

## PROD-CONTENT-007: Preserve link integrity

- **Status:** Ratified
- **Principle:** Keep internal and external references resolvable, purposeful, and anchored to the canonical version of the content they support.
- **Rationale:** Broken, circular, or obsolete links sever evidence, navigation, and migration paths.
- **Verification:** Automated and sampled review finds no broken governed links, and redirects or replacements preserve intent, ownership, and version context.
- **Owner and ratification:** Product owns link-integrity and canonical-target outcomes; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering owns technical link-checking mechanisms, Studio owns navigational expression, and `.github` may automate repository-wide checks.
- **Legacy inputs:** `studio-legacy:documentation:6`, `studio-legacy:documentation:7`

## PROD-CONTENT-008: Govern terminology and content changes

- **Status:** Ratified
- **Principle:** Route material non-interface source content through one versioned glossary and a declared workflow for drafting, domain review, accessibility, localization, qualified review when triggered, approval, publication, and rollback.
- **Rationale:** Shared terms and explicit review prevent contradictory promises while keeping sensitive wording under qualified human control.
- **Verification:** Each material change links the terms used, required reviewers, locale coverage, approval state, effective version, publication result, and rollback path.
- **Owner and ratification:** Product owns shared terminology, non-interface source-content workflow, and publication approval; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Qualified humans review regulated claims, Studio owns interface and disclosure wording, UX expression, and text accommodation, Engineering owns catalogs and formatting mechanisms, and `.github` automates workflow.
- **Legacy inputs:** `studio-legacy:documentation:7`, `studio-legacy:localization:1`, `studio-legacy:localization:2`, `studio-legacy:localization:3`, `studio-legacy:localization:4`, `studio-legacy:localization:5`, `studio-legacy:localization:8`, `studio-legacy:localization:9`

## PROD-CONTENT-009: Own the full content lifecycle

- **Status:** Ratified
- **Principle:** Give every governed content item a canonical source, accountable owner, audience, status, version and effective date, review cadence, supported locales, linked product behavior, and retirement or archival rule.
- **Rationale:** Content without lifecycle ownership accumulates stale promises and remains published after its behavior or audience has changed.
- **Verification:** Lifecycle review identifies no ownerless, overdue, behavior-detached, unsupported, or indefinitely deprecated governed content without an accepted exception.
- **Owner and ratification:** Product owns governed content lifecycle outcomes and exceptions; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering owns technical implementation-document lifecycles, Studio owns experience-content expression, and `.github` owns GitHub-native templates, workflows, and automation.
- **Legacy inputs:** `studio-legacy:documentation:3`, `studio-legacy:documentation:4`, `studio-legacy:documentation:7`, `studio-legacy:localization:9`
