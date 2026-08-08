# Business principles

Draft Product obligations for value, viability, pricing, and market decisions.

## PROD-BUS-001: Make monetization serve user value and trust

- **Status:** Draft
- **Principle:** Base pricing, packaging, and entitlements on a documented value hypothesis, and reject revenue gains that materially weaken user value or trust.
- **Rationale:** Sustainable monetization captures a fair share of created value without making infrastructure, opacity, or coercion the product.
- **Verification:** The proposal identifies the beneficiary, value created, price or entitlement logic, trust risks, affected alternatives, and explicit human approval for contentious tradeoffs.
- **Owner and ratification:** Product owns this business decision; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Studio expresses pricing and entitlements honestly, Engineering implements access mechanisms, and Product P1.2 defines applicable consent and compliance obligations.
- **Legacy inputs:** `studio-legacy:business:1`, `studio-legacy:business:6`, `studio-legacy:ai-products:6`

## PROD-BUS-002: Prove viability with bounded assumptions

- **Status:** Draft
- **Principle:** Evaluate investment with named assumptions, low/base/high ranges, contribution economics, payback expectations, and explicit cost or latency budgets where they affect value.
- **Rationale:** Ranges and constraints expose sensitivity and prevent a precise-looking forecast from disguising uncertainty.
- **Verification:** The business case records inputs and sources, range logic, unit economics, payback threshold, material operating constraints, sensitivity, and a reassessment trigger.
- **Owner and ratification:** Product owns viability and budget outcomes; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering provides and enforces technical cost and latency evidence, while Product decides whether the resulting economics justify investment.
- **Legacy inputs:** `studio-legacy:business:2`, `studio-legacy:business:3`, `studio-legacy:ai-products:5`

## PROD-BUS-003: Ground market claims and constraints in evidence

- **Status:** Draft
- **Principle:** Support competitive claims with dated observable evidence and express resulting business constraints as reviewable outcomes rather than code or design instructions.
- **Rationale:** Evidence-backed claims improve decisions while outcome-based constraints preserve authority boundaries and implementation choice.
- **Verification:** The decision cites sources and observation dates, distinguishes fact from interpretation, and records each resulting constraint, owner, acceptance evidence, and expiry or review date.
- **Owner and ratification:** Product owns market interpretation and business constraints; the repository owner alone ratifies this principle, and this proposal remains Draft.
- **Handoff:** Engineering and Studio decide mechanisms and expression in their realms; `.github` may automate traceability but does not author business conclusions.
- **Legacy inputs:** `studio-legacy:business:4`, `studio-legacy:business:5`
