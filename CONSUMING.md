# Consuming Product authority

This repository is consumed **by reference, not by copy**. Nothing here is
synced, vendored, or published as a package. A consuming repository cites the
Product obligations that bind it and keeps its own instance material local.

## Why reference and not sync

The organization sync engine in `jrmoulckers/.github` distributes agents,
skills, prompts, instructions, and tokens into member repositories. It sources
only from `.github` and `studio`, so it cannot deliver Product principles. That
is intentional: principles are obligations to satisfy, not files to install. A
copied principle silently goes stale and creates a second source of truth, which
`PROD-CONTENT-001` forbids.

## Citation format

Cite a Product obligation by its stable ID:

```text
PROD-REL-002
```

IDs are stable and never reused, renumbered, or reordered. The repository
validator rejects deletion, renumbering, and reordering, so an ID you cite today
resolves to the same obligation later.

When the exact wording matters — a review record, an audit trail, a compliance
artifact — pin the citation to a commit SHA:

```text
PROD-COMP-005 @ 3a752c11856515a74eb204675d5d5198cac1e48e
https://github.com/jrmoulckers/product/blob/3a752c11856515a74eb204675d5d5198cac1e48e/principles/compliance.md
```

Never cite a branch. `main` moves; a SHA does not.

## Before you cite

These three rules were written after seven repositories adopted this catalog.
Each one records a mistake that a careful reader made anyway.

**Name the principle carrying that exact substance, and confirm you have read its
text.** "This topic is centrally owned" is not sufficient. Topical adjacency is
not coverage: a principle about metrics does not necessarily govern survey
design, and a principle about content does not necessarily govern disclosure
policy. Read the obligation's body, not its title, and check that the subject of
the obligation is actually present in your local content. An ID that resolves is
not yet an ID that applies.

**A citation attributes authority; it never substitutes for substance.** Adding
`PROD-MET-001` above a metric definition does not move that definition here.
Central carries obligations, not method. If deleting local content leaves a
reader unable to do the thing the obligation requires, the content was never
duplicated — it was the only copy. Reduce only what a named central passage
actually replaces, and prefer citing above intact content to rewriting it.

**A negative result from a tool is a hypothesis, not a finding.** A search that
returns nothing may mean the content is absent, or that it wraps across a line,
uses different casing, or sits behind a heading you did not search. Before
concluding something is missing or unused, confirm the negative by a second
method.

Claiming an obligation is *vacuous* or *inapplicable* carries the same burden as
citing it: read the text first.

## Every principle here is in force

Each principle carries `**Status:** Ratified`. Each also ends its
`**Owner and ratification:**` line with `...and this proposal remains Draft.`
Those two statements have different subjects and do not conflict: `Status` is the
principle's live catalog state, while the trailing clause describes *the source
proposal*, whose wording is frozen verbatim to prove that ratification changed
status and nothing else.

**Where they appear to disagree, `Status` governs.** Do not read the frozen
clause as evidence that an obligation is unratified, provisional, or unsafe to
cite. See
[`principles/README.md`](principles/README.md#reading-the-status-fields).

## Machine-readable catalog

[`principles/manifest.json`](principles/manifest.json) lists every principle with
its ID, title, area, source file, and status, plus the ratification provenance.
It is generated from the principle files by `scripts/build-manifest.ps1` and the
repository validator fails if it drifts from the catalog. Tooling should read the
manifest rather than parse Markdown.

## What a consuming repository does

1. **Declare the authority.** Add a Product authority reference to the
   repository's `README.md` or the product-authored section of its `AGENTS.md`,
   outside any `studio:base` sync markers.
2. **Cite obligations where decisions are made.** A release checklist cites
   `PROD-REL-001`. A metric definition cites `PROD-MET-001`. A retention
   schedule cites `PROD-COMP-005`. The citation names the obligation; the local
   document is the evidence that satisfies it.
3. **Keep instance material local.** Roadmaps, sprint plans, KPI dashboards,
   privacy audits, and per-application product definitions belong in the
   application repository. Product owns the obligation; the application owns its
   instance.
4. **Use the templates.** [`templates/`](templates/) holds the reusable shapes —
   product definition, go/no-go record, metric definition, experiment decision.
   Copy a template into the consuming repository and fill it in.

## What stays central and what stays local

| Concern | Central here | Local in the application repository |
| --- | --- | --- |
| Product definition | `templates/PRODUCT.md` shape | The filled-in `PRODUCT.md` |
| Release decisions | `PROD-REL-001` .. `PROD-REL-004`, go/no-go template | Each dated go/no-go record |
| Metrics | `PROD-MET-001` .. `PROD-MET-003`, metric definition template | The metric catalog and dashboards |
| Experiments | `PROD-DISC-001` .. `PROD-DISC-004`, experiment template | Each experiment record and result |
| Compliance | `PROD-COMP-001` .. `PROD-COMP-009` | Data inventories, retention schedules, rights audits |
| Content operations | `PROD-CONTENT-001` .. `PROD-CONTENT-009` | The repository's actual documentation |
| Planning | `PROD-PLAN-001` .. `PROD-PLAN-005` | Roadmaps, sprint plans, backlogs |

## Suggested reference block

Add this to a consuming repository's `README.md` or product-authored `AGENTS.md`
section:

```markdown
## Product authority

Product obligations and outcomes are defined in
[jrmoulckers/product](https://github.com/jrmoulckers/product). Cite obligations
by stable ID (for example `PROD-REL-001`); pin to a commit SHA when exact
wording matters. Roadmaps, metrics, experiments, and compliance evidence stay in
this repository and cite the obligation they satisfy.

Engineering mechanisms are defined in
[jrmoulckers/engineering](https://github.com/jrmoulckers/engineering), design and
UI in [jrmoulckers/studio](https://github.com/jrmoulckers/studio), and automation
and shared agent assets in
[jrmoulckers/.github](https://github.com/jrmoulckers/.github).
```

## Authority boundary

Citing a Product obligation transfers no authority in either direction. Product
defines the obligation and the outcome. Engineering implements mechanisms and
supplies technical evidence. Studio expresses the user interface. `.github`
automates the workflow. A consuming repository does not gain the ability to
ratify Product principles, and Product does not gain the ability to dictate
mechanism, interface, or automation.

Compliance principles establish governance, evidence expectations, and triggers
for qualified human review. They are not legal advice.
