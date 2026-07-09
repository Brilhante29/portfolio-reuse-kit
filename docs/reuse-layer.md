# Reuse Layer Architecture

This repository is a reusable platform layer for the portfolio. It should answer five questions for every project:

1. What larger portfolio program does this project strengthen?
2. What is this project supposed to prove?
3. Which architecture best fits the problem forces?
4. Which language and design standards does it inherit?
5. How is the claim measured before publication?

## Layers

| Layer | Path | Responsibility |
|---|---|---|
| Portfolio registry | `catalog/` | Defines the 30 projects, program groups, and intended evidence. |
| Project contract | `contracts/` | Defines required shape for `project.yaml` and benchmark JSON. |
| Architecture selection | `architecture/` | Provides the decision matrix for MVC, layered, modular monolith, Clean Architecture, Hexagonal, MVVM, pipeline, event-driven, CQRS, serverless, and microservices. |
| Language standards | `language-profiles/` | Provides language-specific layout, testing, lint, Docker, and benchmark expectations. |
| Design system | `design-system/` | Provides shared README, diagram, badge, dashboard, and benchmark presentation rules. |
| Scaffolding | `templates/` | Provides reusable files copied into each project. |
| Specification | `sdd/` | Forces scope, architecture, metrics, and acceptance criteria before implementation. |
| Measurement | `harness/` and `metrics/` | Provides repeatable benchmark execution and metric vocabulary. |
| Agent operations | `.codex/skills`, `.claude/skills` | Teaches agents how to use the kit consistently. |
| Automation | `tools/` | Creates projects, installs skills, validates, publishes to GitHub. |

## Reuse Boundary

This kit owns shared process and infrastructure. Individual portfolio projects own implementation.

Owned by this kit:

- program catalog
- README structure
- manifest schema
- architecture decision matrix
- architecture ADR template
- language profiles
- design-system tokens
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
- final architecture decision for the project
- project-specific tests

## Project Contract

Each generated project should include:

```txt
project.yaml
README.md
REFERENCES.md
sdd/spec.md
sdd/benchmark-plan.md
sdd/architecture-decision.md
.portfolio/*
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
