# Experiment decision record template

Copy into the application repository, for example
`docs/experiments/<YYYY-MM-DD>-<slug>.md`. Fill in everything above "Result"
**before** exposure starts. Predeclaration is the point; a decision rule written
after seeing the data is not a decision rule.

Replace everything in angle brackets. Delete this preamble.

---

# \<Experiment name\>

- **Status:** \<Predeclared | Running | Concluded | Abandoned\>
- **Predeclared on:** \<YYYY-MM-DD\>
- **Owner:** \<Named person\>

## Uncertainty

> Satisfies `PROD-DISC-001`.

\<What is genuinely unknown, and why committing without learning it is a bad
bet. If the answer is already known or the decision would not change, do not run
an experiment.\>

## Hypothesis

> Satisfies `PROD-DISC-002`.

\<A falsifiable statement: changing X for population Y will move metric Z by at
least W, because of mechanism M. If no plausible result would falsify it, it is
not a hypothesis.\>

## Decision rule

> Satisfies `PROD-DISC-002`.

Declared before exposure. Filling this in afterwards invalidates the experiment.

- **Primary metric:** \<Link to its versioned definition; see `PROD-MET-001`\>
- **Guardrail metrics:** \<Metrics that must not degrade, and their limits\>
- **Ship if:** \<Explicit threshold\>
- **Abandon if:** \<Explicit threshold\>
- **Inconclusive if:** \<The range where neither rule fires, and what happens then\>
- **Minimum meaningful effect:** \<Below this, movement is noise\>
- **Planned duration or sample:** \<Fixed in advance\>
- **Stopping rule:** \<When early stopping is permitted, and when peeking is not\>

## Exposure plan

> Satisfies `PROD-DISC-003`, `PROD-MET-002`, `PROD-COMP-002`.

- **Population:** \<Who is exposed and who is deliberately excluded\>
- **Staging:** \<Ramp steps and the check between each\>
- **Cohort data:** \<The minimum data required to assign and evaluate\>
- **Consent state required:** \<What the user must have agreed to\>
- **Excluded populations:** \<Who must not be exposed, and why\>
- **Kill switch:** \<How exposure stops, and who can stop it\>

Exposure that requires collecting more than the decision rule needs is out of
bounds.

## Result

> Satisfies `PROD-DISC-004`.

Complete this after the experiment concludes. Record what happened, including
when it is unflattering.

- **Concluded on:** \<YYYY-MM-DD\>
- **Observed effect:** \<Primary metric movement with uncertainty stated\>
- **Guardrails:** \<Held or breached\>
- **Rule fired:** \<Ship | Abandon | Inconclusive\>
- **Decision taken:** \<What was actually decided\>
- **Deviations from predeclaration:** \<Any deviation, and why. "None" is a valid answer and the expected one.\>

## What was learned

> Satisfies `PROD-STRAT-002`, `PROD-DISC-004`.

\<Separate evidence from inference from assumption. State the confidence level
and what would change the conclusion. An inconclusive experiment that is honestly
reported is a successful experiment; a reinterpreted decision rule is not.\>
