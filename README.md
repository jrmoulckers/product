# Product

This repository is the canonical authority for JRM product and operations principles and,
when repeated work justifies them, reusable decision and process templates.

## Ownership

Product owns:

- product strategy, planning, and delivery decisions;
- business, discovery, experiments, and metric definitions;
- compliance obligations and go/no-go decisions; and
- documentation and content operations.

Product does not own application code, Studio UI implementation, Engineering mechanisms, or
GitHub/Copilot/AI implementation.

## Handoff model

| Domain | Responsibility |
| --- | --- |
| Product | Defines the obligation and intended outcome. |
| Engineering | Defines the technical mechanism and evidence. |
| Studio | Defines the user-facing expression. |
| `.github` | Automates checks and distribution. |

Only the repository owner may ratify a principle. Agents and other contributors may propose
principles, but proposals are not authority until the owner ratifies them.

## Status and roadmap

Milestone 1 unit P0.1 establishes the repository charter, contributor boundary, principle-tree
entry point, and portable text policy. No principles or process templates are ratified yet.

Near-term work will author and review domain principles. Decision records and reusable templates
will be added only after a recurring decision or process demonstrates the need.

Run the dependency-free repository check with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

## License

No license is granted for this private repository.
