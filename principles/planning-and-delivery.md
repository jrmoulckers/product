# Planning and delivery principles

Draft Product obligations for turning strategy into reviewable, shippable outcomes.

## PROD-PLAN-001: Plan independently shippable outcome slices

- **Status:** Draft
- **Principle:** Decompose milestones into the smallest coherent slices that can deliver, test, or retire an outcome independently.
- **Rationale:** Independent slices shorten feedback cycles, expose risk early, and keep delivery moving when optional capabilities are delayed.
- **Verification:** Every planned slice names its user or business outcome, acceptance evidence, dependencies, safe stopping point, and value without later slices.
- **Owner and ratification:** Product owns this planning outcome; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering and Studio implement viable slices in their realms, `.github` automates delivery workflow, and Product owns slice boundaries and outcome readiness.
- **Legacy inputs:** `studio-legacy:project-planning:1`, `studio-legacy:project-planning:2`, `studio-legacy:ai-products:8`

## PROD-PLAN-002: Make work decision-ready before commitment

- **Status:** Draft
- **Principle:** Give committed work an explicit priority, one accountable owner, bounded scope, testable acceptance, and stated non-goals.
- **Rationale:** Clear commitments prevent silent scope growth and make ownership, tradeoffs, and completion observable.
- **Verification:** The work record contains priority, accountable owner, acceptance checks, non-goals, and a visible decision when any of them changes.
- **Owner and ratification:** Product owns prioritization and acceptance; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering and Studio contribute feasibility and realm-specific evidence, while `.github` may automate records without deciding priority or acceptance.
- **Legacy inputs:** `studio-legacy:project-planning:3`, `studio-legacy:project-planning:5`

## PROD-PLAN-003: Expose dependencies and parity obligations

- **Status:** Draft
- **Principle:** Make cross-authority dependencies, sequencing constraints, compatibility obligations, and intentional parity gaps visible before scheduling.
- **Rationale:** Delivery risk should be chosen in planning rather than discovered during integration or release.
- **Verification:** The plan identifies each dependency owner, required outcome, due point, blocked work, parity decision, and accepted gap with rationale.
- **Owner and ratification:** Product owns the integrated plan; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering, Studio, and `.github` own dependencies and evidence in their realms; Product owns the cross-authority map and resulting priority decisions.
- **Legacy inputs:** `studio-legacy:project-planning:2`, `studio-legacy:project-planning:6`

## PROD-PLAN-004: Keep the backlog intentional

- **Status:** Draft
- **Principle:** Groom the backlog on a declared cadence so every retained item still has current value, priority, ownership, and evidence.
- **Rationale:** An unmanaged queue hides obsolete assumptions and makes accidental age look like strategy.
- **Verification:** Grooming records show duplicates closed, stale items retired or revalidated, priorities and owners refreshed, and deferral reasons recorded.
- **Owner and ratification:** Product owns backlog decisions; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Other authorities update realm evidence and dependencies, while `.github` may automate queue hygiene without deciding what Product keeps or drops.
- **Legacy inputs:** `studio-legacy:project-planning:4`

## PROD-PLAN-005: Make go or no-go explicit

- **Status:** Draft
- **Principle:** Record an explicit go, hold, or no-go decision before exposing a material outcome, and apply the Release Decision principles when that exposure is a formal release.
- **Rationale:** A visible decision prevents schedule pressure or automation from silently accepting unresolved product risk.
- **Verification:** The decision names the accountable Product owner, affected outcome and exposure, applicable readiness policy, effective time, and resulting go, hold, or no-go state.
- **Owner and ratification:** Product owns the go or no-go decision; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering provides technical readiness evidence, Studio provides user-facing and documentation readiness, and `.github` owns CI, branch, and release automation.
- **Legacy inputs:** `studio-legacy:project-planning:7`, `studio-legacy:process:5`, `studio-legacy:process:6`
