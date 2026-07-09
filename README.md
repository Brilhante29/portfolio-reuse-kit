# Portfolio Reuse Kit

Reusable decision brain and engineering layer for a 30-repository technical portfolio.

This repository is the decision brain and shared operating system for the portfolio: it defines portfolio programs, project contracts, scaffolding, architecture decision rules, engineering principles, stack decision matrices, messaging decisions, language/framework profiles, proficiency map, design-system standards, metrics, benchmark harnesses, agent skills, validation rules, and GitHub publication automation.

It is intentionally not one of the portfolio projects. It exists so every project can be created, evaluated, documented, and published with the same level of rigor.

## What Problem This Solves

Without a reuse layer, each repository tends to drift:

- different README structure
- missing benchmark command
- architecture chosen by habit instead of problem forces
- stack, API style, broker, cloud, database, or library choices made without a recorded decision
- repositories that do not belong to a larger portfolio story
- visual and documentation inconsistency across repos
- language conventions reinvented per project
- inconsistent Docker path
- unclear reuse attribution
- weak acceptance criteria
- agent prompts rewritten from scratch
- repeated CI and benchmark boilerplate

This kit solves that by making every portfolio project follow the same contract and decision flow.

## Core Contract

Every completed project must provide:

- a `project.yaml` manifest
- an explicit portfolio program
- an explicit architecture decision with rejected alternatives
- a `decision_brain` section with principles, stack, API style, messaging, cloud/Kumo, database/runtime, library policy, and rejected options
- a primary language/framework profile
- shared design-system components
- README opening with project number, claim, and benchmark result
- `sdd/spec.md`, `sdd/benchmark-plan.md`, `sdd/architecture-decision.md`, and `sdd/technical-decision.md`
- Docker build/run path
- benchmark JSON compatible with `contracts/benchmark-result.schema.json`
- `REFERENCES.md` with clean reuse attribution
- validation before commit or publication
- no paid secret required for the default demo path

## Architecture

```txt
portfolio-reuse-kit
  catalog/           -> portfolio source of truth and program grouping
  architecture/      -> decision matrix for MVC, modular, Clean, Hexagonal, MVVM, pipeline, etc.
  decision-brain/    -> engineering principles, stack, API style, messaging, cloud, database/runtime, and library decision matrices
  language-profiles/ -> language/framework-specific repo standards
  design-system/     -> README, diagram, dashboard, and benchmark presentation standards
  contracts/         -> schemas every project must satisfy
  templates/         -> reusable project scaffolding
  sdd/               -> specification-driven development templates
  harness/           -> benchmark runners and result comparison
  metrics/           -> metric registry and units
  skills/            -> Codex and Claude Code operating instructions
  tools/             -> create, validate, install, publish
  docs/              -> human operating model
```

The intended flow is:

```txt
program -> proficiency signal -> architecture -> decision brain -> stack profile -> messaging/libs -> design system -> scaffold -> SDD -> implementation -> benchmark -> validation -> publication
```

## Quickstart

Create a new project scaffold:

```powershell
powershell -ExecutionPolicy Bypass -File tools/new-project.ps1 `
  -Id 3 `
  -Name rag-knowledge-base `
  -TargetDir C:\Users\Guilherme\Desktop\repos-github `
  -InstallSkills `
  -InitializeGit
```

Validate the kit:

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-kit.ps1
```

Run a generic benchmark wrapper:

```powershell
python harness/bench.py --project kit-smoke --metric latency_ms --unit ms --repeat 3 python --version
```

Publish a repository:

```powershell
$env:GH_TOKEN = "<token>"
powershell -ExecutionPolicy Bypass -File tools/publish-github.ps1 `
  -RepoPath . `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Visibility public
Remove-Item Env:\GH_TOKEN
```

## Repository Layout

| Path | Responsibility |
|---|---|
| `catalog/` | Source of truth for all 30 projects, program grouping, stack, claim, benchmark, and references. |
| `architecture/` | Decision matrix for choosing software architecture by problem forces. |
| `decision-brain/` | Central decision matrices for engineering principles, stack profiles, API style, messaging, cloud local-first, runtime/database, and library selection. |
| `language-profiles/` | Language/framework-specific conventions for Python, Java, Go, TypeScript, Angular, Next.js, Spring Kotlin, FastAPI, Go backend, and Terraform. |
| `design-system/` | Shared README, diagram, badge, benchmark, and dashboard standards. |
| `contracts/` | JSON schemas for project manifests and benchmark results. |
| `templates/` | Files copied into new projects: README, manifest, references, Dockerfiles, CI. |
| `sdd/` | Specification templates: spec, benchmark plan, ADR, technical decision, release checklist. |
| `harness/` | Benchmark runner, comparison script, k6 smoke script, benchmark schema. |
| `metrics/` | Metric names, units, and optimization direction. |
| `.codex/skills/` | Codex skills installed into generated projects. |
| `.claude/skills/` | Claude Code skills installed into generated projects. |
| `tools/` | Automation for project creation, validation, skill install, and GitHub publishing. |
| `docs/` | Operating model for humans and agents. |

## Skills Included

The same skills are provided for Codex and Claude Code:

| Skill | Use |
|---|---|
| `portfolio-project` | Build, review, harden, validate, or publish one portfolio project. |
| `spec-driven-project` | Write project manifest, SDD, benchmark plan, ADRs, and release criteria. |
| `architecture-selector` | Choose MVC, layered, modular monolith, Clean Architecture, Hexagonal, MVVM, pipeline, event-driven, CQRS, serverless, or microservices for the specific problem. |
| `engineering-principles` | Enforce decoupling, SOLID, LSP, KISS, YAGNI, DRY, dependency inversion, and testability evidence. |
| `stack-decision` | Choose concrete stack profile from the decision brain. |
| `api-style-decision` | Decide REST/HTTP, GraphQL, gRPC, WebSocket, SSE, or CLI. |
| `cloud-local-first` | Apply Kumo local-first cloud and real-cloud adapter rules. |
| `messaging-decision` | Decide no broker, outbox, RabbitMQ, Kafka, Redis Streams, or NATS. |
| `spring-kotlin-backend` | Apply Spring Kotlin backend standards. |
| `fastapi-backend` | Apply FastAPI backend standards. |
| `go-backend` | Apply Go backend standards. |
| `node-typescript-backend` | Apply NestJS/Rocketseat-style Node TypeScript backend standards. |
| `language-standards` | Apply language/framework layout, tests, linting, Docker, and benchmark conventions. |
| `design-system` | Apply shared visual and documentation standards across repositories. |
| `benchmark-harness` | Add or validate metrics, benchmark JSON, k6 checks, and README tables. |

## Program Groups

The 30 repositories are grouped into portfolio programs:

- AI Evaluation and Retrieval Systems
- Applied Computer Vision and Medical AI
- Backend Reliability and Architecture Platform
- MLOps and Data Platform
- Delivery, Observability, and Infrastructure

The program catalog is in [catalog/programs.yaml](catalog/programs.yaml).

## First Six Projects

Recommended build order:

1. `llm-eval-harness`
2. `rag-knowledge-base`
3. `spring-hexagonal-payments`
4. `mini-aws-emulator`
5. `mlops-end2end`
6. `yolo-training-pipeline`

The full project catalog is in [catalog/projects.md](catalog/projects.md) and [catalog/projects.yaml](catalog/projects.yaml).

## Documentation

- [Reuse layer architecture](docs/reuse-layer.md)
- [Architecture decision guide](docs/architecture-decision-guide.md)
- [Decision brain](docs/decision-brain.md)
- [Engineering principles](docs/engineering-principles.md)
- [API style decision](docs/api-style-decision.md)
- [Cloud local-first](docs/cloud-local-first.md)
- [Portfolio operating model](docs/portfolio-operating-model.md)
- [Proficiency map](docs/proficiency-map.md)
- [Project lifecycle](docs/project-lifecycle.md)
- [Repository standard](docs/repository-standard.md)
- [Usage](docs/usage.md)
- [Publish](PUBLISH.md)

## Reuse Policy

Use public repositories as references, not as disguised copies. Reuse dependencies, architecture ideas, organization patterns, benchmark patterns, and documentation structure. Project-specific implementation, fixtures, benchmark scripts, and results must be original.

See [catalog/reuse-policy.md](catalog/reuse-policy.md).

## License

MIT.
