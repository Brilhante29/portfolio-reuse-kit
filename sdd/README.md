# SDD

SDD means Specification Driven Development.

Before implementing a portfolio project, fill the lightweight SDD files:

1. `templates/spec.md`
2. `templates/benchmark-plan.md`
3. `templates/adr.md` when an architectural decision matters
4. `templates/release-checklist.md` before publishing

The kit also includes an OpenSpec-compatible schema in `openspec/schemas/portfolio-system/`. Use it when the project needs a richer artifact graph or spans multiple repositories. If OpenSpec is not installed, use the same graph manually with `sdd/` and `project.yaml`.

The required graph is: intent -> portfolio impact -> architecture record -> component pack -> reuse delta -> benchmark proof -> tasks -> verification.

The goal is to force each repository to prove one measurable claim and to improve the reuse layer when repeated decisions appear.
