# Architecture Decision Guide

This kit treats architecture as a project-specific decision, not a default folder template.

Agents must choose the architecture from the problem forces, then document the choice before implementation. The stack can change; the organization rule must still make sense.

## References That Shape This Kit

The organization style intentionally favors repositories where boundaries are easy to inspect:

- `rocketseat-education/05-nest-clean`: clear Clean Architecture separation across `core`, `domain`, `infra`, and `test`, with domain contexts isolated from framework details.
- `programadorLhama/CleanArch`: compact Clean Architecture learning repo with practical project hygiene such as `src`, entrypoint, Dockerfile, linting, and pre-commit config.

Use these as organization references only. Do not copy implementation, naming, exercises, fixtures, or repository-specific code.

## Required Decision

Every generated project must include an architecture section in `project.yaml` and an SDD note or ADR with:

- chosen style
- problem forces that made it fit
- rejected alternatives
- dependency rule
- folder layout
- testing strategy
- expected benchmark impact

## Selection Rules

| Problem shape | Prefer | Why |
|---|---|---|
| Simple CRUD, admin API, small demo | MVC or layered | Low ceremony, easy to read, fast to ship. |
| API with several business areas but one deploy | Modular monolith | Strong boundaries without distributed-system cost. |
| Domain rules are the evidence | Clean Architecture | Use cases and entities can be tested without framework or database. |
| Many external systems, providers, queues, APIs | Hexagonal | Ports/adapters make integration swaps and tests explicit. |
| Audit trail, replay, temporal state | CQRS + event sourcing | Events are the source of truth and benchmark. |
| Streaming, queues, async consistency | Event-driven | Message contracts and lag/throughput are central. |
| Rich UI state, forms, validation, screens | MVVM | View state is testable separately from rendering. |
| ML, CV, ETL, batch processing | Pipeline | Reproducibility comes from explicit stages and artifacts. |
| Small event-triggered workloads | Serverless | Cost and cold start are part of the claim. |
| Independent teams/deployments required | Microservices | Use only when independent deployability is real evidence. |

## Default Bias

For portfolio projects, prefer the simplest architecture that still proves the claim:

1. MVC/layered for small CRUD projects.
2. Modular monolith for backend systems with multiple contexts.
3. Clean Architecture or Hexagonal when domain isolation or adapters are the point.
4. Event-driven or CQRS only when the benchmark needs events, replay, lag, or consistency behavior.
5. Pipeline for AI/data projects.
6. Microservices only when the project explicitly proves service boundaries.

## Folder Organization Patterns

Clean Architecture style:

```txt
src/
  core/
  domain/<context>/
  application/use-cases/
  infra/http/
  infra/database/
test/
```

Hexagonal style:

```txt
src/
  domain/
  application/ports/in/
  application/ports/out/
  adapters/in/
  adapters/out/
  config/
test/
```

Modular monolith style:

```txt
src/
  modules/<context>/domain/
  modules/<context>/application/
  modules/<context>/infra/
  shared/kernel/
test/
```

Pipeline style:

```txt
src/
  stages/ingest/
  stages/prepare/
  stages/run/
  stages/evaluate/
artifacts/
benchmarks/
test/
```

## Agent Rule

If the architecture choice is not obvious, the agent must write the tradeoff instead of guessing silently. A good decision says: "For this problem, I choose X because Y. I reject Z because it would add cost without improving the benchmark or claim."
