---
name: portfolio-project
description: Build, review, or upgrade one repository in the 30-project portfolio using the shared reuse layer: project manifest, SDD, Docker path, benchmark contract, references, validation, and publication workflow. Use when the user asks to scaffold, implement, harden, validate, or publish a portfolio repository.
---

# Portfolio Project

Use the portfolio reuse layer as the source of truth.

1. Read `catalog/projects.yaml` to identify project id, stack, claim, benchmark target, and reuse references.
2. Create or update `project.yaml` from `templates/project.yaml`.
3. Create or update `sdd/spec.md` and `sdd/benchmark-plan.md` before implementation.
4. Keep the default path runnable without paid credentials.
5. Ensure `README.md` starts with the project number, claim, and benchmark status/result.
6. Include `REFERENCES.md` and state whether reuse is dependency, architecture, benchmark idea, or documentation pattern.
7. Add Docker support and one documented command path.
8. Add a benchmark command that writes JSON compatible with `contracts/benchmark-result.schema.json` under `benchmarks/results/`.
9. Run local validation before commit or publication.

Do not present scaffold-only repositories as finished portfolio evidence.