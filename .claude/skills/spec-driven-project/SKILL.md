---
name: spec-driven-project
description: Write or update Specification Driven Development artifacts for portfolio repositories, including project.yaml, spec.md, benchmark-plan.md, ADRs, release checklist, acceptance criteria, and publication readiness. Use before implementation or when defining scope, architecture, metrics, benchmark design, reuse policy, or done criteria.
---

# Spec Driven Project

Drive implementation from explicit project evidence.

1. Convert the project idea into one measurable claim.
2. Define in-scope behavior, out-of-scope behavior, and default Docker path.
3. Specify metric name, unit, target, benchmark command, fixture, seed, and JSON result path.
4. Identify reusable assets from the kit: templates, contracts, harness, CI, skills, and references.
5. Add ADRs for architecture, model/runtime, storage, protocol, benchmark methodology, or dependency choices.
6. Add release criteria that include Docker, tests, benchmark JSON, references, README result, and no-secret default demo.

Use `sdd/templates/` and `contracts/` when present.