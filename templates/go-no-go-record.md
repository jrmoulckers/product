# Go/no-go record template

Copy to the application repository as a dated record, for example
`docs/releases/2026-08-09-v1.0-go-no-go.md`. One record per release decision.
Records are append-only evidence: supersede them, do not rewrite them.

Replace everything in angle brackets. Delete this preamble.

---

# \<Release identity\> — go/no-go

- **Decision:** \<Go | No-go | Go with accepted risk\>
- **Date:** \<YYYY-MM-DD\>
- **Decider:** \<Named person accountable for the decision\>
- **Release identity:** \<Version, build, or artifact identity being decided on\>

## Readiness

> Satisfies `PROD-REL-001`, `PROD-PLAN-005`.

| Readiness area | State | Evidence |
| --- | --- | --- |
| Functional scope complete | \<Met / Not met / N/A\> | \<Link\> |
| Quality evidence | \<Met / Not met / N/A\> | \<Link to test and assurance evidence from Engineering\> |
| Accessibility conformance | \<Met / Not met / N/A\> | \<Link\> |
| Privacy and compliance obligations | \<Met / Not met / N/A\> | \<Link to the obligations traced under `PROD-COMP-001`\> |
| Documentation and public surfaces current | \<Met / Not met / N/A\> | \<Link; see `PROD-CONTENT-002`, `PROD-CONTENT-004`\> |
| Rollback path verified | \<Met / Not met / N/A\> | \<Link to Engineering's rollback evidence\> |
| Support and rollout obligations | \<Met / Not met / N/A\> | \<Link\> |

State every area explicitly. An unstated area is a no-go, not an implicit pass.

## Accepted risk

> Satisfies `PROD-REL-002`.

Every accepted risk expires. An accepted risk with no expiry is not accepted.

| Risk | Impact if realized | Accepted by | Expires | Follow-up |
| --- | --- | --- | --- | --- |
| \<Risk\> | \<Impact\> | \<Name\> | \<YYYY-MM-DD or named event\> | \<Issue link\> |

If there are none, write "None."

## Known gaps disclosed

> Satisfies `PROD-REL-003`.

\<What ships incomplete, degraded, or absent, and how users learn about it. A gap
that users are not told about is not disclosed.\>

## Cadence

> Satisfies `PROD-REL-004`.

\<Where this release sits in the intended cadence, and whether it moved. If the
cadence slipped, say why.\>

## Handoffs

Engineering supplied the mechanism and technical evidence linked above. Studio
supplied the interface expression. `.github` supplied the automation and the
delivery workflow. This record is the Product decision on top of that evidence,
and it neither claims nor transfers their authority.
