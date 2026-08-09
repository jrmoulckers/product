# Product authority

This private, **UNLICENSED** repository is the authority for JRM product and
operations principles and reusable decision and process templates.

## What this repository owns

- Product strategy, planning, business, discovery, and experimentation guidance
- Metric definitions and compliance obligations expressed as required outcomes
- Delivery and go/no-go practices
- Documentation and content operations

## What this repository does not own

- Application code
- Studio UI implementation
- Engineering mechanisms or technical evidence
- GitHub, Copilot, AI, or other automation implementation maintained in `.github`

## Handoff model

Product defines the obligation or outcome. Engineering implements mechanisms and
evidence. Studio expresses the user interface. `.github` automates the workflow.
Each domain remains authoritative for its part of the handoff.

## Governance and status

The repository owner alone ratifies Product principles. Agents may propose
changes, but proposals remain unratified until the owner explicitly accepts them.

The [Product principle tree](principles/README.md) contains exactly 40 entries
with **Ratified** catalog status: 18 core principles from source PR
[#3](https://github.com/jrmoulckers/product/pull/3) and 22 compliance, content,
and release-operations principles from source PR
[#4](https://github.com/jrmoulckers/product/pull/4). Under
[decision record 0001](docs/architecture/0001-ratify-product-principles.md),
that status became effective when the repository owner merged pull request
[#5](https://github.com/jrmoulckers/product/pull/5) on 2026-08-09 as commit
`3a752c11856515a74eb204675d5d5198cac1e48e`. The
[Ratification record](docs/ratification/2026-08-09-product-principles.md)
documents that act. The catalog is therefore a required Product constraint and a
citable set of obligations. Compliance principles establish governance and
qualified-review triggers; they are not legal advice.

This repository introduces no software package or runtime behavior.

## Consuming this repository

Product authority is consumed **by reference, not by copy**. See
[CONSUMING.md](CONSUMING.md) for the citation format, the machine-readable
[`principles/manifest.json`](principles/manifest.json), and the boundary between
what stays central and what stays in an application repository.
[`templates/`](templates/) holds the reusable shapes — product definition,
go/no-go record, metric definition, and experiment decision record — which are
copied into the consuming repository and filled in there.

## Near-term roadmap

1. Reference the ratified catalog by stable ID from every consuming repository.
2. Define reusable templates only when a recurring decision or process requires one.
