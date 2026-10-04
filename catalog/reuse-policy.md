# Reuse Policy

Prioritize this kit's skills, templates, decision brain, SDD, and harness. Use public repositories as references and accelerators, not as copies.

## Priority

1. The kit's own skills in `.codex/skills/` and `.claude/skills/`.
2. Canonical kit decisions: `decision-brain/`, `component-packs/`, `architecture/`, `language-profiles/`, `design-system/`, `sdd/`, `harness/`, and `templates/`.
3. Patterns from external repositories that improve organization, contracts, tests, benchmarks, docs, agent workflow, schemas, or developer experience.
4. Official libraries and dependencies when they solve the project's problem better.

If an external reference contradicts one of the kit's skills, the kit's skill wins. If the external reference is clearly better, update the kit first or record a backlog item in `sdd/reuse-improvement-review.md`.

## Allowed

- Learning organization, boundaries, folder patterns, workflow, SDD, validators, and benchmarks from external repositories.
- Using official libraries as dependencies.
- Recreating an architecture in another domain.
- Reusing benchmark ideas and API contracts.
- Citing references in `REFERENCES.md`.
- Using small excerpts only when the license allows it and attribution is given.

## Avoid

- Replacing the kit's skills with external components without a recorded decision.
- Forking an example and renaming things.
- Copying an entire structure without a reason.
- Using AGPL code internally without understanding its obligations.
- Publishing a repository without a reproducible result.

## Required in every project

```md
## References

This project was informed by:
- <repo/doc>: <what was reused>

Implementation, fixtures, benchmark scripts and reported results are project-specific.
```
