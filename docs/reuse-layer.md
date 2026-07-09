# Reuse Layer Architecture

This repository is a reusable platform layer for the portfolio. It should answer four questions for every project:

1. What is this project supposed to prove?
2. Which stack and reusable standards does it inherit?
3. How is the claim measured?
4. What must be true before the project is published?

## Layers

| Layer | Path | Responsibility |
|---|---|---|
| Portfolio registry | `catalog/` | Defines the 30 projects and their intended evidence. |
| Project contract | `contracts/` | Defines required shape for `project.yaml` and benchmark JSON. |
| Scaffolding | `templates/` | Provides reusable files copied into each project. |
| Specification | `sdd/` | Forces scope, architecture, metrics, and acceptance criteria before implementation. |
| Measurement | `harness/` and `metrics/` | Provides repeatable benchmark execution and metric vocabulary. |
| Agent operations | `.codex/skills`, `.claude/skills` | Teaches agents how to use the kit consistently. |
| Automation | `tools/` | Creates projects, installs skills, validates, publishes to GitHub. |

## Reuse Boundary

This kit owns shared process and infrastructure. Individual portfolio projects own implementation.

Owned by this kit:

- README structure
- manifest schema
- SDD templates
- benchmark result schema
- CI templates
- Dockerfile templates
- publication automation
- agent skills
- reusable metric vocabulary

Owned by each project:

- business/domain implementation
- dataset fixtures
- benchmark script details
- measured results
- architecture decisions specific to the project
- project-specific tests

## Project Contract

Each generated project should include:

```txt
project.yaml
README.md
REFERENCES.md
sdd/spec.md
sdd/benchmark-plan.md
benchmarks/results/.gitkeep
.codex/skills/*
.claude/skills/*
```

The project becomes publishable only after it also has:

- runnable Docker path
- benchmark command
- JSON result
- README number/result update
- references completed
- validation passing

## Design Principle

The kit should remove repeated decisions, not remove engineering judgment.

Good reuse makes each project faster to build while preserving project-specific proof.