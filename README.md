# Portfolio Reuse Kit

Reusable engineering kit for building a 30-repository technical portfolio with the same release standard: specification first, Docker path, reproducible benchmark, clear references, and agent-readable skills.

This repository is not one of the 30 portfolio projects. It is the factory that keeps them consistent.

## Why This Exists

A portfolio repo should not be a demo folder. Each project must prove one concrete claim with a number that can be reproduced from a clean checkout.

This kit provides the shared contract:

- one visible project number
- one measurable claim
- one Docker path
- one benchmark result in JSON
- one reuse/reference policy
- one set of skills for Codex and Claude Code

## Quickstart

Create a new scaffold:

```powershell
powershell -ExecutionPolicy Bypass -File tools/new-project.ps1 `
  -Id 3 `
  -Name rag-knowledge-base `
  -TargetDir C:\Users\Guilherme\Desktop\repos-github `
  -InstallSkills `
  -InitializeGit
```

Install the shared skills into an existing repo:

```powershell
powershell -ExecutionPolicy Bypass -File tools/install-project-skills.ps1 `
  -TargetRepo C:\Users\Guilherme\Desktop\repos-github\rag-knowledge-base
```

Validate this kit:

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-kit.ps1
```

Run a generic benchmark wrapper:

```powershell
python harness/bench.py --project kit-smoke --metric latency_ms --unit ms --repeat 3 python --version
```

## Repository Layout

| Path | Purpose |
|---|---|
| `catalog/` | Source of truth for the 30 projects, stacks, claims, and benchmark targets. |
| `sdd/` | Specification Driven Development templates. |
| `harness/` | Reusable benchmark scripts and result schema. |
| `templates/` | README, Dockerfile, CI, and references templates. |
| `.codex/skills/` | Codex skills copied into each project. |
| `.claude/skills/` | Claude Code skills copied into each project. |
| `tools/` | Local project creation, skill installation, and validation scripts. |
| `docs/` | Human-readable operating model and repository standard. |

## The Rochedo Standard

Every portfolio project must ship with:

- README opening with `# #<id> <project-name>`
- one-sentence claim under `Proves`
- benchmark result in the first screen of the README
- Docker build/run instructions
- `sdd/spec.md` and `sdd/benchmark-plan.md`
- `REFERENCES.md` explaining clean reuse
- JSON benchmark output under `benchmarks/results/`
- no paid credential required for the default demo path

Detailed rules live in [docs/repository-standard.md](docs/repository-standard.md).

## Skills Included

The same three skills are provided for Codex and Claude Code:

| Skill | Use |
|---|---|
| `portfolio-rochedo` | Build or review one portfolio repository against the full standard. |
| `sdd-rochedo` | Write spec, benchmark plan, ADRs, and acceptance criteria. |
| `benchmark-harness` | Add or validate reproducible metrics, JSON results, and README tables. |

## First Six Projects

Recommended build order:

1. `llm-eval-harness`
2. `rag-knowledge-base`
3. `spring-hexagonal-payments`
4. `mini-aws-emulator`
5. `mlops-end2end`
6. `yolo-training-pipeline`

The full catalog is in [catalog/projects.md](catalog/projects.md) and [catalog/projects.yaml](catalog/projects.yaml).

## Reuse Policy

Use public repositories as references, not as disguised copies. Reuse dependencies, architecture ideas, benchmark patterns, and documentation structure. Project-specific implementation, fixtures, benchmark scripts, and results must be original.

See [catalog/reuse-policy.md](catalog/reuse-policy.md).

## License

MIT.