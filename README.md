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
that status becomes effective only if the repository owner merges the pull
request introducing the record. Until that owner action, the change remains a
proposal and does not claim approval. Compliance principles establish
governance and qualified-review triggers; they are not legal advice.

This repository introduces no software package or runtime behavior.

## Near-term roadmap

1. Preserve the ratified catalog and apply it only after owner Ratification is effective.
2. Define reusable templates only when a recurring decision or process requires one.
