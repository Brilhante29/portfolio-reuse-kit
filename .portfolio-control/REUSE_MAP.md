# Portfolio Reuse Map

`portfolio-reuse-kit` is the shared decision, contract, automation, and continuity layer. Projects consume generated snapshots and return only generic, tested improvements.

## Shared Inputs

| Concern | Kit source | Consumer contract |
|---|---|---|
| Agent behavior | `.codex/skills/`, `.claude/skills/`, `decision-brain/agent-graph.yaml` | bounded roles and evidence handoffs |
| Problem-first architecture | `architecture/decision-matrix.yaml` | SDD decision with rejected alternatives |
| Stack/API/messaging/cloud | `decision-brain/`, `language-profiles/` | `project.yaml` and technical decision |
| Local-first runtime | `decision-brain/cloud-matrix.yaml`, Docker templates | no paid secret; Kumo behind ports when AWS parity matters |
| SDD/OpenSpec | `sdd/templates/`, `openspec/` | aligned specification and change artifacts |
| Benchmark evidence | `contracts/`, `metrics/`, `harness/` | reproducible JSON and README number |
| Validation/publication | `tools/` and GitHub workflows | current-head CI and publication evidence |
| Design system | `design-system/` | consistent README, diagrams, and metrics |

## Current Project Delta

| Project | Reusable delta | Decision |
|---|---|---|
| #3 `rag-knowledge-base` | deterministic retrieval fixture and separate V1 execution/V2 provenance | `patch_now` in validator and templates; retrieval policy stays local |
| #5 `alpr-mercosul` | explicit workload derivation and label-leakage negative proof | `patch_now` in claim-verification guidance; OCR implementation stays local |
| #11 `spring-hexagonal-payments` | Gradle lock plus three-run JVM/k6 V2 provenance | `patch_now` as benchmark guidance; payment policy stays local |
| #13 `mini-aws-emulator` | pinned-provider provenance, workload sizing, project-specific aggregation | `patch_now` in producer selection and Kumo guidance; conformance semantics stay local |
| #12 `go-rate-limiter` | shared Redis quota, fail-closed storage behavior, and host-owned Linux CI evidence volumes | `patch_now` in backend/benchmark gates; limiter policy and Lua stay local |
| #15 `grpc-vs-rest-bench` | workload/repetition distinction, protocol parity, and paired metrics | `patch_now` in benchmark skills; Echo workload stays local |
| #17 `multi-tenant-starter` | real PostgreSQL isolation, executable Gradle wrapper, and stable CI evidence | `patch_now` in backend/Gradle gates; tenant SQL stays local |
| #18 `api-gateway-lite` | canonical-versus-smoke evidence, shared quota, and upstream trace observation | `patch_now` in benchmark and backend evidence packs; gateway policy stays local |
| #21 `mlops-end2end` | source-commit Git-blob provenance, early CI gate, framework execution proof | `patch_now` in generic producer and mirrored skills; lifecycle aggregation stays local |

## Reuse Boundary

Upstream a pattern only when it is generic, tested, documented, backward compatible, and useful to at least two projects or a complete family. Domain fixtures, policies, and benchmark aggregation remain project-owned unless reuse is proven.

## Current Generic Improvements

- V1 execution evidence and V2 publication evidence have separate ownership.
- Published truth is read from committed Git `HEAD`; dirty files are reported independently.
- Tracked fixture, config, and dependency-lock digests come from canonical Git blobs at `source_commit`.
- Generated raw artifacts are hashed from the bytes actually produced.
- CI fetches source history and runs cheap provenance gates before Docker builds.
- Codex and Claude use the same `publish-benchmark-evidence` skill contract.
- Benchmark skills distinguish domain work items from independent repetitions and align repetition-level sample counts with `execution.repeat`.
- CI smoke benchmarks write to temporary artifact paths and never replace committed publication evidence.
- Linux benchmark-writer containers use the runner UID/GID for bind-mounted evidence while service containers retain non-root image users.
