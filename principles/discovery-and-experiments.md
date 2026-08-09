# Discovery and experiment principles

Draft Product obligations for reducing uncertainty and governing exposure decisions.

## PROD-DISC-001: Discover before committing past uncertainty

- **Status:** Ratified
- **Principle:** Investigate the riskiest user, value, usability, viability, and feasibility assumptions before making a commitment that depends on them.
- **Rationale:** Discovery is valuable when it changes a decision, not when it merely accumulates research activity.
- **Verification:** The discovery brief states the decision, riskiest assumptions, evidence sought, participants or sources, stopping condition, and how each possible finding changes the plan.
- **Owner and ratification:** Product owns the discovery decision; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Studio owns user-facing research expression, Engineering provides feasibility evidence, and Product synthesizes the evidence into a product decision.
- **Legacy inputs:** none

## PROD-DISC-002: Predeclare experiments as bounded decisions

- **Status:** Ratified
- **Principle:** Before exposure, give each experiment one owner, one purpose, a falsifiable hypothesis, primary metric, guardrails, decision rule, kill conditions, and expiry.
- **Rationale:** Predeclared bounds prevent metric shopping, unmanaged exposure, and experiments that persist without answering a decision.
- **Verification:** The approved experiment record contains every required bound, the planned readout date, and the quality bar for any AI-backed outcome.
- **Owner and ratification:** Product owns the hypothesis and decision bounds; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering owns feature-flag and evaluation mechanisms, Studio owns participant-facing expression, and `.github` may automate records and expiry checks.
- **Legacy inputs:** `studio-legacy:featuring:1`, `studio-legacy:featuring:4`, `studio-legacy:ai-products:4`

## PROD-DISC-003: Stage exposure with safe, privacy-conscious cohorts

- **Status:** Ratified
- **Principle:** Increase exposure in deliberate stages using deterministic, privacy-conscious cohorts and a proven ability to stop when guardrails or kill conditions are breached.
- **Rationale:** Controlled exposure limits harm, makes comparisons reproducible, and preserves the ability to reverse a bad decision.
- **Verification:** The rollout decision defines stages, cohort outcome requirements, guardrails, advancement authority, stop conditions, and evidence that exposure can be halted.
- **Owner and ratification:** Product owns exposure stages and stop criteria; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering implements flags, cohort assignment, and stop mechanisms; Product P1.2 defines consent and data bounds; Studio expresses any required participant experience.
- **Legacy inputs:** `studio-legacy:featuring:2`, `studio-legacy:featuring:3`, `studio-legacy:featuring:6`

## PROD-DISC-004: Conclude every experiment honestly

- **Status:** Ratified
- **Principle:** Decide to ship, hold, revise, roll back, kill, or retire from the predeclared evidence, and close the experiment when the decision is made.
- **Rationale:** A winning primary metric does not excuse a guardrail breach, and unresolved experiment infrastructure must not become permanent product debt.
- **Verification:** The readout reports primary and guardrail results, uncertainty and limitations, deviations, the accountable decision, follow-up obligations, and retirement status.
- **Owner and ratification:** Product owns the experiment conclusion; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering and Studio provide realm evidence and remove concluded mechanisms or experiences; `.github` may automate retirement tracking.
- **Legacy inputs:** `studio-legacy:featuring:5`, `studio-legacy:featuring:7`
