# Strategy principles

Draft Product obligations for choosing direction and sequencing outcomes.

## PROD-STRAT-001: Put durable value and trust first

- **Status:** Draft
- **Principle:** Choose strategies that create durable user value and preserve trust before optimizing revenue, adoption, or novelty.
- **Rationale:** Growth that weakens user agency, reliability, or confidence destroys the product asset it is meant to improve.
- **Verification:** A strategy decision names the target user value, trust constraints, expected business value, tradeoffs, and reasons rejected options lost.
- **Owner and ratification:** Product owns this decision; the repository owner alone ratifies it, and this proposal remains Draft.
- **Handoff:** Studio expresses the intended value and trust posture in user experience; Engineering and Product P1.2 implement and define the required technical and compliance controls.
- **Legacy inputs:** `studio-legacy:business:6`, `studio-legacy:ai-products:6`

## PROD-STRAT-002: Separate evidence, inference, and assumption

- **Status:** Draft
- **Principle:** State the evidence, inference, assumptions, confidence, and next learning needed for every material strategic choice.
- **Rationale:** Explicit uncertainty makes decisions reviewable and allows new evidence to change direction without rewriting history.
- **Verification:** The decision record links dated evidence, labels assumptions, records confidence and alternatives, and assigns a trigger or method for reassessment.
- **Owner and ratification:** Product owns this decision; the repository owner alone ratifies it, and this proposal remains Draft.
- **Handoff:** Engineering supplies technical evidence, Studio supplies user and design evidence, and Product judges what the combined evidence means for direction.
- **Legacy inputs:** `studio-legacy:business:2`, `studio-legacy:business:4`

## PROD-STRAT-003: Build roadmaps from coherent outcome milestones

- **Status:** Draft
- **Principle:** Sequence milestones as coherent user and business outcomes that remain valuable without depending on one package, platform, vendor, model, or implementation contract.
- **Rationale:** Outcome milestones keep strategy adaptable and prevent a technical dependency from becoming the product plan.
- **Verification:** Each roadmap milestone states its outcome, affected users, success evidence, dependencies, non-goals, and the capability that remains if an optional dependency is unavailable.
- **Owner and ratification:** Product owns this decision; the repository owner alone ratifies it, and this proposal remains Draft.
- **Handoff:** Engineering owns mechanism and dependency options, Studio owns the experience expression, `.github` owns roadmap automation, and Product owns milestone meaning and sequence.
- **Legacy inputs:** `studio-legacy:project-planning:1`, `studio-legacy:ai-products:8`
