# Metric definition template

Copy into the application repository's metric catalog, for example
`docs/metrics/<metric-slug>.md`. One file per metric. A metric with more than one
definition in circulation is not a metric — it is a disagreement.

Replace everything in angle brackets. Delete this preamble.

---

# \<Metric name\>

- **ID:** \<stable-slug\>
- **Definition version:** \<v1\>
- **Status:** \<Active | Deprecated, superseded by \<id\>\>
- **Owner:** \<Named person accountable for the definition\>
- **Last reviewed:** \<YYYY-MM-DD\>

## Decision this metric serves

> Satisfies `PROD-MET-001`.

\<The specific decision this metric informs. A metric that informs no decision
should not be collected. Name the decision, not the dashboard.\>

## Definition

> Satisfies `PROD-MET-001`.

- **Numerator:** \<Exactly what is counted\>
- **Denominator:** \<Exactly what it is counted against, or "N/A"\>
- **Unit:** \<Unit\>
- **Window:** \<Time window and whether it is rolling or fixed\>
- **Segmentation:** \<Permitted breakdowns\>
- **Inclusions:** \<What counts\>
- **Exclusions:** \<What deliberately does not count, and why\>

## Versioning

> Satisfies `PROD-MET-001`.

\<Any change to numerator, denominator, window, inclusions, or exclusions is a
new definition version. Record the previous version, the date it changed, and
why. Historical series computed under a prior version are not comparable without
a stated restatement.\>

| Version | Date | Change | Comparable to prior? |
| --- | --- | --- | --- |
| v1 | \<YYYY-MM-DD\> | Initial definition | N/A |

## Collection bounds

> Satisfies `PROD-MET-002`, `PROD-COMP-002`.

- **Purpose:** \<The specific purpose that justifies collecting this\>
- **Data collected:** \<The minimum fields required for the definition above\>
- **Personal data:** \<Yes/No; if yes, the lawful basis and the consent state required\>
- **Consent state:** \<What the user must have agreed to for this to be collected\>
- **Retention:** \<Bound, and terminal disposition; see `PROD-COMP-005`\>

Collecting more than the definition requires is out of bounds, even when it is
technically available.

## Honest interpretation

> Satisfies `PROD-MET-003`.

- **What this metric can support:** \<Claims it legitimately supports\>
- **What it cannot support:** \<Claims it will be misread as supporting\>
- **Known biases and blind spots:** \<Survivorship, seasonality, instrumentation gaps\>
- **Minimum meaningful movement:** \<The change size below which movement is noise\>

## Instrumentation

> Handoff to Engineering.

\<Link to the Engineering-owned event schema and collection mechanism. Product
owns the definition and the meaning; Engineering owns how it is emitted, stored,
and computed. Do not restate the implementation here.\>
