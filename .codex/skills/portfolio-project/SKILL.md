---
name: portfolio-project
description: Build, review, or upgrade one repository in the 30-project portfolio using the shared reuse layer: program catalog, architecture decision, language profile, design system, SDD, Docker path, benchmark contract, references, validation, and publication workflow. Use when the user asks to scaffold, implement, harden, validate, or publish a portfolio repository.
---

# Portfolio Project

Use the portfolio reuse layer as the source of truth. In this kit, read files from the repository root. In generated projects, read the same standards from `.portfolio/` when present.

Decision order:

1. Read `catalog/programs.yaml` or `.portfolio/catalog/programs.yaml` and place the repo inside one portfolio program. Do not create isolated projects.
2. Read `catalog/projects.yaml` or `.portfolio/catalog/projects.yaml` to identify project id, claim, benchmark target, and reference ideas.
3. Read `architecture/decision-matrix.yaml` or `.portfolio/architecture/decision-matrix.yaml` and choose the architecture that fits the problem forces, not the stack.
4. Read the matching file in `language-profiles/` or `.portfolio/language-profiles/` and apply language-specific repository standards.
5. Read `design-system/tokens.yaml` or `.portfolio/design-system/tokens.yaml` and apply shared README, diagram, badge, benchmark, and dashboard conventions.
6. Create or update `project.yaml` from `templates/project.yaml`, including program, language profile, architecture, design system, benchmark, release, and reuse sections.
7. Create or update `sdd/spec.md`, `sdd/benchmark-plan.md`, and an architecture ADR before implementation.
8. Keep the default path runnable without paid credentials.
9. Ensure `README.md` starts with the project number, claim, and benchmark status/result.
10. Include `REFERENCES.md` and state whether reuse is dependency, architecture, organization pattern, benchmark idea, or documentation pattern.
11. Add Docker support and one documented command path.
12. Add a benchmark command that writes JSON compatible with `contracts/benchmark-result.schema.json` or `.portfolio/contracts/benchmark-result.schema.json` under `benchmarks/results/`.
13. Run local validation before commit or publication.

Do not present scaffold-only repositories as finished portfolio evidence.
