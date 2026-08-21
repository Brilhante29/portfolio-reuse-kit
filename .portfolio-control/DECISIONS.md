# Portfolio Decision Register

## i-have-adhd

- Source: `https://github.com/ayghri/i-have-adhd`
- Skill: `skills/i-have-adhd/SKILL.md`
- Commit: `07684c4ab625dd7d1ea6e99e065f60bc0ac6a1ba`
- Scope: workspace
- Status: active
- Verification: public `main` resolved with `git ls-remote`; local SKILL.md was read in full.

## Operating Decisions

| Decision | Selected option | Evidence | Revisit trigger |
|---|---|---|---|
| Work order | one active project plus one kit improvement | goal objective and `PROJECT_QUEUE.md` | external blocker or dependency change |
| Project selection | #3 first | local status: code, Docker, and exact-head CI are present; V2 is missing | V2 producer and publication evidence pass |
| Architecture | problem-first; clean/hexagonal/modular as forces require | `decision-brain/` and each project's SDD | coupling or proof target changes |
| Local-first | Docker by default; Kumo only for AWS-like behavior | `decision-brain/cloud-matrix.yaml` | parity gap is measured |
| Publication result | keep v1 execution evidence and V2 provenance evidence separate | central validator currently conflates one path; fix is generic | contract model changes |
| Secrets | environment only; never write token values | `AGENTS.md`, continuity protocol | none |

## Engineering Principles

- Domain and application policy stay independent from transport and infrastructure.
- Ports own contracts; adapters depend inward and preserve failure semantics.
- SOLID, LSP, KISS, YAGNI, DRY, and testability must be evidenced in code and tests.
- A benchmark number is valid only when its command, inputs, environment, and provenance are reproducible.

## 2026-07-30 #3 publication closure

- #3 produced a separate contract-valid V2 publication result and passed exact-head CI.
- The central kit now tracks publication evidence by repository and exact HEAD.
- The next active project is #11; its architecture and evidence must be audited before implementation.

## 2026-07-30 #11 publication closure

- #11 published with Kotlin/Gradle dependency locking and three-run V2 benchmark provenance.
- The next active project is #13; audit Kumo/local-first boundaries before implementation.

## 2026-08-02 V2 semantic integrity

- `execution.repeat` records independent run repetitions; it never substitutes for `workload.measured_iterations`.
- The generic producer is selected only for one V1 metric/value result with an explicit or unambiguous workload count.
- Multi-run, multi-metric, provider-diagnostic, and domain-specific aggregation remain project-owned producers behind the shared V2 contract.
- A schema pass is necessary but not sufficient; agents inspect workload size, samples, units, aggregation, provider identity, and exact-head CI.

## 2026-08-02 #13 publication closure

- `mini-aws-emulator` is published at `8d3a4f7`; exact-head CI run `30774984792` passed all jobs and steps.
- The reusable producer correction shipped in `6f557a0`; committed-head publication validation shipped in `16a3622` and passed kit CI `30774849915`.
- Published facts come from committed Git `HEAD`. Dirty worktree files remain a warning signal and are never silently ignored.
- The active defect family remains open because ALPR V2 reports one measured iteration for a 100-plate workload.
- Repairing false evidence outranks starting #21; `mlops-end2end` becomes active after ALPR semantic validation closes.

## 2026-08-02 - ALPR Oracle Tautology

Context: the old benchmark returned ground truth, so perfect accuracy did not prove OCR.
Decision: prediction accepts image pixels only; labels exist only in evaluation; pixel mutation is the negative proof.
Rejected: publishing oracle accuracy as a placeholder.
Evidence: #5 source `b23be43`, evidence `f22c834`, final CI `30778498303`.

## 2026-08-02 - MLOps Orchestration Proof

Context: #21 defines an Airflow DAG but its measured path calls Python stages directly.
Decision: publication must execute through Airflow task machinery and retain the specified three-run median.
Rejected: describing function-equivalent execution as Airflow orchestration evidence.
Evidence: `runner.py`, `dags/mlops_end2end.py`, and `sdd/benchmark-plan.md`.
## 2026-08-03 - #21 MLOps Publication Closure

Context: the old measured path defined an Airflow DAG but called Python stage functions directly, ran one sample, and started a redundant localhost MLflow HTTP server.

Decision: execute the lifecycle with `airflow dags test`, use direct local SQLite MLflow tracking/registry, retain three independent same-image runs, and publish the median with raw samples.

Rejected: describing function-equivalent execution as Airflow proof; adding distributed infrastructure to a local reproducibility benchmark; collapsing multi-metric project aggregation into the generic producer.

Evidence: source `9e8c76d`, final head `fb77827`, exact-head CI `30781190229`, lifecycle median `58.696 s`.

## 2026-08-03 - Canonical Git Provenance

Context: Windows checkout CRLF bytes produced different digests from Linux CI, and a shallow checkout could not verify the source commit.

Decision: fixture, config, and dependency-lock digests are calculated from canonical Git blobs at `provenance.source_commit`; generated artifacts use actual output bytes. CI fetches source history and performs this gate before expensive Docker work.

Rejected: normalizing arbitrary filesystem bytes after execution or weakening the source-commit check.

Evidence: ten producer tests, including LF/CRLF, committed tree, and untracked-input regressions.

## 2026-08-14 - Backend Reliability Platform Closure

Context: the transactional core was complete, but the traffic and platform edge still contained simulated infrastructure, ambiguous protocol workload semantics, stale local-cloud proof, and CI smoke evidence that was not portable to Linux.

Decision: close the ten repositories as one system with private data boundaries and versioned behavior contracts. Canonical benchmark evidence remains committed; variable CI smoke evidence is written to runner-temporary paths and uploaded separately. A Linux benchmark writer uses the host UID/GID only for its bind-mounted output, while long-running service images retain non-root users.

Rejected: presenting the ten repositories as unrelated pattern demos; claiming PostgreSQL, Redis, Kumo, OpenTelemetry, REST/gRPC parity, or distributed quota without those components in the measured path; weakening container users globally to solve artifact permissions.

Evidence: all ten public `main` heads have exact-head CI success. Edge runs: #12 `31770932954`, #13 `31770435198`, #15 `31770456018`, #17 `31770435136`, and #18 `31770456130`.

## 2026-08-14 - #26 Data Quality Publication Closure

Context: the data-quality component detected labeled defects correctly, but lacked a versioned cross-repository output manifest, transitive dependency lock, and truthful V2 identity for runtime workload overrides.

Decision: publish accepted and quarantine artifacts through `validated-batch-manifest-v1`, including data-contract identity, row counts, reason counts, and SHA-256 digests. Keep the reference engine as the LSP oracle for the Polars/Pandera adapter. Every workload override changes workload identity, comparability key, and effective configuration digest.

Rejected: direct source imports between MLOps repositories; feature ingestion without a passed quality status; weakening clean-tree provenance for editable Python installs; CI smoke artifacts that report canonical row counts.

Evidence: final `main` `8d6dd2110243123324b97810886463f2385738d2`; exact-head CI `31773506491`; canonical F1 `1.0`; median throughput `717607.9778021169 rows/s`; 26 tests and 94.99% coverage.

## 2026-08-17 - #23 Feature Store Publication Closure

Context: the feature-store component had a valid Feast implementation and old latency evidence, but its publication path did not consume the #26 data contract, lacked transitive dependency locking and Benchmark Result V2 provenance, and aggregated with the host Python runtime.

Decision: validate `validated-batch-manifest-v1` fail closed before Feast sees rows; keep temporal truth independent from Feast; measure only warmed SDK reads; record cold first read and materialization separately; aggregate three runs inside the pinned image; publish exact source, image, wheel, lock, workload, correctness, and comparability identity.

Rejected: source imports between #26 and #23; custom joins presented as a feature-store engine; Redis or HTTP without a concurrency/transport claim; latency without future-leak, TTL, and online-value correctness proof; host-runtime-dependent aggregation.

Evidence: final `main` `6f8c957807a122d189fe8021c80cfd3e2639e329`; exact-head CI `31991401685`; p95 median `45.645578341645894 ms`; throughput median `1061.9468119765338 entity values/s`; point-in-time and online match `1.0`; zero future leaks and TTL violations; 23 tests and 91.09% coverage.

## 2026-08-20 - #24 Reusable CI Publication Closure

Context: `ci-cd-templates` promised reusable pipelines but only shipped a scanner, and its README number no longer matched committed evidence.

Decision: publish five explicit `workflow_call` profiles for Python, Go, Node, JVM/Gradle, and Terraform. Each profile executes a repository-owned fixture, pins external actions by full SHA, uses read-only permissions, disables checkout credential persistence, and owns its timeout. Measure deterministic policy scan latency separately from hosted consumer build duration.

Rejected: a universal template that accepts arbitrary commands; mutable workflow refs; comparing unrelated stack build times; treating actionlint-only validation as execution proof.

Evidence: source `8bfd94a1a8fd6186b717bc7be53d61e92d419b2d`; final `main` `bc591185eeb3ec73ff550fa6b1fdf4d41885a55e`; exact-head CI `32001541506`; median scan `104.945 ms`; `7/7` unsafe findings; zero template findings.
