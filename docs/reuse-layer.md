# Reuse Layer Architecture

This repository is a reusable decision platform for the portfolio. It should answer seven questions for every project:

1. Which agent graph coordinates the work from objective to publication?
2. What larger portfolio program does this project strengthen?
3. What public proficiency signal should this project prove?
4. Which architecture best fits the problem forces?
5. Which principles, stack, API style, broker, cloud mode, database/runtime, and libraries should be selected?
6. Which language/framework and design standards does it inherit?
7. How is the claim measured before publication?

## Layers

| Layer | Path | Responsibility |
|---|---|---|
| Portfolio registry | `catalog/` | Defines the 30 projects, program groups, proficiency signals, and intended evidence. |
| Project contract | `contracts/` | Defines required shape for `project.yaml` and benchmark JSON. |
| Agent graph | `decision-brain/agent-graph.yaml` and `docs/agent-graph.md` | Defines principal agent, subagents, local-first runtime, handoff contract, validation, and publication flow. |
| Reuse improvement | `decision-brain/reuse-improvement-loop.yaml` and `docs/reuse-improvement-loop.md` | Forces every project to patch, backlog, or reject improvements to the reuse kit. |
| Architecture selection | `architecture/` | Provides the decision matrix for MVC, layered, modular monolith, Clean Architecture, Hexagonal, MVVM, pipeline, event-driven, CQRS, serverless, and microservices. |
| Decision brain | `decision-brain/` | Provides engineering principles, stack, API style, messaging, cloud local-first, runtime/database, and library decision matrices. |
| Language standards | `language-profiles/` | Provides language/framework-specific layout, testing, lint, Docker, and benchmark expectations. |
| Design system | `design-system/` | Provides shared README, diagram, badge, dashboard, and benchmark presentation rules. |
| Scaffolding | `templates/` | Provides reusable files copied into each project. |
| Specification | `sdd/` | Forces scope, architecture, technical decisions, metrics, handoff, and acceptance criteria before implementation. |
| Measurement | `harness/` and `metrics/` | Provides repeatable benchmark execution and metric vocabulary. |
| Agent operations | `.codex/skills`, `.claude/skills` | Teaches agents how to use the kit consistently. |
| Automation | `tools/` | Creates projects, installs skills, validates, publishes to GitHub. |

## Reuse Boundary

This kit owns shared process and infrastructure. Individual portfolio projects own implementation.

Owned by this kit:

- program catalog
- proficiency map
- README structure
- manifest schema
- agent orchestration graph
- reuse improvement loop
- architecture decision matrix
- engineering principles matrix
- stack, API style, cloud, and messaging decision matrices
- library selection policy
- architecture ADR template
- technical decision template
- agent handoff template
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
- final technical decisions for stack, API style, cloud, messaging, database/runtime, and libraries
- project-specific tests

## Project Contract

Each generated project should include:

```txt
project.yaml
README.md
REFERENCES.md
AGENTS.md
sdd/spec.md
sdd/benchmark-plan.md
sdd/architecture-decision.md
sdd/technical-decision.md
sdd/agent-handoff.md
sdd/reuse-improvement-review.md
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
