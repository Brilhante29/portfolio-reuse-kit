# Portfolio Reuse Map

`portfolio-reuse-kit` is the shared decision, contract, automation, and
continuity layer. Projects consume it through generated snapshots and should
return only generic improvements.

## Shared Inputs

| Concern | Kit source | Consumer contract |
|---|---|---|
| Agent behavior | `.codex/skills/`, `.claude/skills/`, `decision-brain/agent-graph.yaml` | bounded roles and evidence handoffs |
| Problem-first architecture | `architecture/decision-matrix.yaml` | SDD decision with rejected alternatives |
| Stack/API/messaging/cloud | `decision-brain/`, `language-profiles/` | `project.yaml` and technical decision |
| Local-first runtime | `decision-brain/cloud-matrix.yaml`, Docker templates | no paid secret; Kumo behind ports when applicable |
| SDD/OpenSpec | `sdd/templates/`, `openspec/` | aligned specification and change artifacts |
| Benchmark evidence | `contracts/`, `metrics/`, `harness/` | reproducible JSON and README number |
| Validation/publication | `tools/` and GitHub workflows | current-head CI and publication evidence |
| Design system | `design-system/` | consistent README, diagrams, and metrics |

## Current Project Delta

| Project | Reusable delta | Decision |
|---|---|---|
| #3 `rag-knowledge-base` | deterministic retrieval fixture and a two-contract benchmark path: local v1 result plus publication V2 provenance | `patch_now` for the central validator and templates; keep domain code local |

| #11 spring-hexagonal-payments | Gradle lock plus three-run JVM/k6 V2 provenance pattern | patch_now as generic benchmark/provenance guidance candidate; keep payment policy local |

## Reuse Boundary

Upstream only a pattern that is generic, tested, documented, backward
compatible, and useful to at least two projects or a complete family. Keep
retrieval policy, fixtures, and domain behavior in project #3.
