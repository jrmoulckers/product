# Product repository agent overlay

The organization `.github` repository is the canonical source for shared agent
definitions, skills, and instructions. Do not copy those definitions into this
repository.

Agents working here must:

- follow the canonical `.github` guidance plus this local overlay;
- keep work within the Product authority described in `README.md`;
- treat all agent-authored principles and decision records as proposals until
  the repository owner makes Ratification effective by merging the owner-review
  change;
- never represent a proposed status change as approved before that explicit
  repository-owner action;
- treat the existing 40-principle catalog as already effective, ratified by the
  owner's merge of [PR #5](https://github.com/jrmoulckers/product/pull/5) on
  2026-08-09 and recorded in
  `docs/ratification/2026-08-09-product-principles.md`, and therefore binding
  rather than proposed;
- leave `docs/architecture/0001-ratify-product-principles.md` at `Proposed`,
  because it is the immutable record of the proposal and the validator enforces
  its wording; record later facts in a new record instead of rewriting it;
- preserve stable principle IDs, the exact `Ratified` status, the unchanged
  owner-and-ratification wording from the source proposals, and resolvable
  legacy-input references enforced by the repository validator;
- regenerate `principles/manifest.json` with `./scripts/build-manifest.ps1`
  after any catalog change, and keep `CONSUMING.md` and `templates/` consistent
  with the catalog they cite;
- follow local Product principles as required constraints once they are authored
  and ratified; and
- preserve the handoff boundary: Product defines obligations and outcomes,
  Engineering implements mechanisms and evidence, Studio expresses UI, and
  `.github` automates.

Product authority is consumed by reference, not by copy. Templates in
`templates/` define reusable shapes that consuming repositories fill in locally;
do not centralize an application's filled-in instances here.

Compliance proposals establish governance, evidence expectations, and triggers
for qualified human review; they must not claim to provide legal advice.
Content-operations proposals must not claim ownership of technical
implementation documentation or GitHub-native templates and workflows.
