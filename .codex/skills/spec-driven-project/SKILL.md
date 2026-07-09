---
name: spec-driven-project
description: Write or update Specification Driven Development artifacts for portfolio repositories, including program fit, proficiency signal, project.yaml, architecture decision, language/framework profile, design-system expectations, spec.md, benchmark-plan.md, ADRs, release checklist, acceptance criteria, and publication readiness.
---

# Spec Driven Project

Drive implementation from explicit project evidence. In generated projects, prefer `.portfolio/` standards when present.

1. Convert the project idea into one measurable claim.
2. Place the repo into a program from `catalog/programs.yaml` or `.portfolio/catalog/programs.yaml` and explain how it strengthens that program narrative.
3. Define the public proficiency signal from `catalog/proficiency.yaml` or `.portfolio/catalog/proficiency.yaml`: backend, AI/ML, data orchestration, Angular enterprise UI, Next.js product UI, infra, or observability.
4. Define in-scope behavior, out-of-scope behavior, and default Docker path.
5. Choose the software architecture from `architecture/decision-matrix.yaml` or `.portfolio/architecture/decision-matrix.yaml` using problem forces: domain complexity, integration pressure, UI state, data/ML reproducibility, auditability, async pressure, and deployability.
6. Choose the primary language/framework profile from `language-profiles/` or `.portfolio/language-profiles/` after the architecture decision.
7. Apply `design-system/tokens.yaml` or `.portfolio/design-system/tokens.yaml` to README structure, architecture summary, diagrams, and benchmark tables.
8. Record program, architecture, language profile, design system, and benchmark in `project.yaml`.
9. Create an ADR from `sdd/templates/architecture-decision.md`.
10. Specify metric name, unit, target, benchmark command, fixture, seed, and JSON result path.
11. Identify reusable assets from the kit: programs, proficiency map, architecture catalog, language profiles, design system, templates, contracts, harness, CI, skills, and references.
12. Add ADRs for architecture, model/runtime, storage, protocol, benchmark methodology, or dependency choices.
13. Add release criteria that include Docker, tests, benchmark JSON, references, README result, and no-secret default demo.

Use `catalog/`, `catalog/proficiency.yaml`, `architecture/`, `language-profiles/`, `design-system/`, `sdd/templates/`, and `contracts/` when present.
