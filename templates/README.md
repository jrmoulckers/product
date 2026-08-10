# Templates

Reusable shapes for recurring Product decisions and processes. Each template is
copied **into the consuming repository** and filled in there; the filled-in
instance is local evidence, and this directory owns only the shape.

Every template binds its sections to the Product obligations they satisfy. Keep
those citations when you copy — they are how a reviewer knows what the document
is evidence for.

| Template | Copy to | Obligations |
| --- | --- | --- |
| [`PRODUCT.md`](PRODUCT.md) | `PRODUCT.md` in the application repository | `PROD-STRAT-*`, `PROD-BUS-*`, `PROD-PLAN-*` |
| [`go-no-go-record.md`](go-no-go-record.md) | One dated record per release decision | `PROD-REL-*`, `PROD-PLAN-005` |
| [`metric-definition.md`](metric-definition.md) | One file per metric in the local metric catalog | `PROD-MET-*`, `PROD-COMP-002` |
| [`experiment-decision-record.md`](experiment-decision-record.md) | One record per experiment | `PROD-DISC-*`, `PROD-MET-001` |

See [`../CONSUMING.md`](../CONSUMING.md) for the citation format and the
central-versus-local boundary.

## Adding a template

Add one only when a recurring decision or process actually requires it, per the
repository roadmap. A template that exists without a recurring need is
documentation debt. Each template must:

- state that it is copied into the consuming repository and filled in there;
- cite the Product obligations each section satisfies;
- avoid specifying mechanism, interface implementation, or automation, which
  belong to Engineering, Studio, and `.github`; and
- be listed in the table above, which the repository validator checks.
