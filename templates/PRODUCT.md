# Product definition template

Copy this file to `PRODUCT.md` in an application repository and fill it in. It
is the local, per-application product definition. It stays in the application
repository — this repository owns the *shape* and the obligations, not the
instance.

Each section names the Product obligation it satisfies. Keep the citation; it is
how a reviewer knows which obligation the section is evidence for. Delete a
section only when it genuinely does not apply, and say why rather than leaving it
empty.

Replace everything in angle brackets. Delete this preamble.

---

# \<Product name\> — product

## Users

> Satisfies `PROD-STRAT-001`, `PROD-BUS-003`.

\<Who has the problem, what they use today, and the situation they are in when
they use this. Be concrete about context — device, place, connectivity,
interruption, expertise. Ground claims in evidence rather than assumption; where
it is an assumption, label it.\>

## Purpose

> Satisfies `PROD-STRAT-001`, `PROD-STRAT-003`.

\<One paragraph. What this product does, what durable user value it creates, and
what "working well" looks like from the user's side. State the outcome, not the
implementation.\>

## Promise

> Satisfies `PROD-STRAT-001`, `PROD-BUS-001`.

\<The single primary promise, plus two to four proof points. Name the trust
constraints that the promise depends on and that no growth or monetization
decision may weaken.\>

## Operating context and constraints

> Satisfies `PROD-STRAT-003`, `PROD-PLAN-003`.

\<Platforms in scope, offline and connectivity assumptions, data ownership
posture, and the capability that remains if an optional dependency is
unavailable. Name parity obligations across platforms.\>

## Invariants

> Satisfies `PROD-PLAN-002`, `PROD-REL-003`.

\<Numbered statements that must remain true of product behavior regardless of
implementation. These are the things a change may not silently break. Keep them
observable — a reviewer should be able to tell whether one is violated.\>

1. \<Invariant\>
2. \<Invariant\>

## Scope and non-goals

> Satisfies `PROD-PLAN-001`, `PROD-PLAN-004`, `PROD-STRAT-003`.

\<What this product deliberately does and does not do, sequenced as outcome
milestones rather than feature lists. Non-goals are as load-bearing as goals —
state them.\>

## Anti-references

> Satisfies `PROD-STRAT-001`.

\<What this must never feel like, and why. Naming the failure mode makes the
positive direction reviewable.\>

## Monetization

> Satisfies `PROD-BUS-001`, `PROD-BUS-002`.

\<The value metric charged for, tier boundaries, and what is never gated. Privacy,
safety, accessibility, and access to a user's own existing data are not
chargeable value. If the product is not monetized, say so and state what would
have to be true to change that.\>

## Measurement

> Satisfies `PROD-MET-001`, `PROD-MET-002`.

\<Link to the local metric catalog. Each metric there carries one versioned
definition and a stated collection purpose. Do not restate definitions here.\>

## Compliance posture

> Satisfies `PROD-COMP-002`, `PROD-COMP-003`, `PROD-COMP-005`.

\<Link to the local data inventory, retention schedule, and rights-handling
evidence. State the processing purpose and the retention bound at a summary
level; the linked documents are the evidence.\>

## Accessibility and inclusion

> Satisfies `PROD-CONTENT-005`.

\<The accessibility commitment as a product obligation and where the conformance
evidence lives. Studio owns the interface expression; this section owns the
obligation.\>

## Authority

> Satisfies `PROD-CONTENT-001`.

Product obligations are defined in
[jrmoulckers/product](https://github.com/jrmoulckers/product). Engineering
mechanisms are defined in
[jrmoulckers/engineering](https://github.com/jrmoulckers/engineering), design and
interface in [jrmoulckers/studio](https://github.com/jrmoulckers/studio), and
automation in [jrmoulckers/.github](https://github.com/jrmoulckers/.github).

This document defines what this product owes its users. It does not define
mechanism, interface implementation, or automation.
