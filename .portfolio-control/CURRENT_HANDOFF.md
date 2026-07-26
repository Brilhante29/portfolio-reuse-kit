# Current Handoff

Updated: 2026-07-26
Owner: principal agent
Goal: complete the portfolio with truthful, reproducible evidence while using the reuse kit as the decision and contract plane.

## Current State

- Existing repositories: 30. Approved catalog size: 33.
- Existing structural truth: Docker 30/30, CI workflow 30/30, tracked primary benchmark 19/30, contract V1 19/30, contract V2 0/30.
- Local structural candidates: 12/30. Publication candidates: 0/30. Verified publications: 0/30.
- Origins: 10/30. Upstreams: 10/30.
- No repository is accepted as published without a current-head green CI run and V2 evidence.
- Previously exposed PATs were removed from Git config, but the user must still revoke them in GitHub.

## Completed And Merged

- Reuse-kit main is 581631c: truthful status gates, execution telemetry, permanent handoff, parsed YAML validation, 33-project catalog, JVM decision matrix, technology coverage, benchmark V2, generated design tokens, complete contract scaffolding, and rejection of tracked build caches.
- Reuse-kit PRs #1 and #2 passed GitHub Actions and were squash-merged.
- Six AI Evaluation repositories passed pull-request CI and were squash-merged into main: llm-eval-harness, rag-knowledge-base, embeddings-benchmark, llm-agent-eval, prompt-ab-testing, and cost-aware-inference.
- rag-knowledge-base proves Recall@3 = 1.00 with a measured local baseline, six tests, Docker, strict OpenSpec, and corrected retrieval evaluation.
- multi-tenant-starter now truthfully declares its current in-memory implementation as a prototype; PostgreSQL/Flyway remain implementation work.

## Approved Platform Expansion

The missing Node/TypeScript/NestJS, GraphQL, Next.js/React, and Angular proof is addressed by one platform with three independently deployable repositories:

31. portfolio-evidence-api: evidence ingestion, validation, comparison, readiness, and audit.
32. portfolio-evidence-console: public Next.js/React read experience.
33. portfolio-operations-console: Angular operational command workflows.

The consoles are separate because their users and workflows differ, not to showcase frameworks. REST/OpenAPI owns writes; GraphQL owns flexible reads. JSON Schema and HTTP are the language-neutral boundary.

## JVM Decision

- Kotlin: spring-hexagonal-payments, kafka-streams-demo, and saga-orchestrator after semantic repair.
- Java: event-sourcing-orders, multi-tenant-starter, and cache-strategies-bench.
- Mixed: framework-free Java core/contracts plus Kotlin Spring runtime/adapters in outbox-pattern, after atomic persistence exists.
- Every JVM repository requires Gradle Wrapper, Kotlin DSL build scripts, explicit toolchain, equal quality gates, and Docker.
- Do not publish Java-versus-Kotlin microbenchmarks unless implementation variables and workloads are controlled.

## Active Reuse-Kit Branch

Branch agent/interoperability-contract-plane contains the integrated contract-plane change; kit-audit-stage remains its telemetry/source overlay:

- contracts/portfolio-evidence.openapi.yaml
- contracts/portfolio-evidence.graphql
- contracts/manifest.json
- tools/generate-contract-manifest.py
- formal OpenAPI 3.1, GraphQL SDL, JSON Schema, and SHA-256 validation
- consumer-side vendored-contract drift checking
- CI pins: PyYAML 6.0.2, jsonschema 4.26.0, graphql-core 3.2.11, openapi-spec-validator 0.9.0

Isolated and full-kit validation passed on 2026-07-26. A generated-project smoke copied all ten hashed assets, and a tampered GraphQL contract failed SHA-256 and byte-size gates with exit code 1. The staged Git blobs were independently re-hashed after LF normalization and match all ten manifest entries. The branch still needs commit, PR CI, and merge.

## Active Repository Work

### portfolio-evidence-api

Location: new-project-worktrees/portfolio-evidence-api.

Implemented and previously verified:

- NestJS 11, Fastify 5, Mercurius, strict TypeScript
- framework-free domain/application boundaries
- Ajv V2 validation
- Kysely/SQLite transactional persistence and duplicate rejection
- REST ingestion, GraphQL reads/comparison, health, Prometheus, and Pino
- 9 focused tests and 5 e2e tests; typecheck passed

Not complete:

- no benchmark harness/result
- no Dockerfile
- no CI workflow
- incomplete SDD/OpenSpec/README/project manifest
- npm audit reported seven high vulnerabilities and was not triaged
- no commit, remote, Docker evidence, or publication

### portfolio-evidence-console and portfolio-operations-console

Their directories are empty. Do not count repositories 32 and 33 as created or implemented.

### saga-orchestrator

Location: C:\tmp\saga-kotlin, branch agent/kotlin-saga-repair.

- Characterization tests and SDD/OpenSpec were started.
- 111 tracked .gradle artifacts were identified; cleanup is incomplete in the worktree.
- The Kotlin migration and durable compensation semantics are not implemented.
- No final commit or publication exists.

## Remaining P0

- saga-orchestrator: real reverse compensation, compensation-failure/manual-intervention state, durability, idempotency, and recovery benchmark.
- multi-tenant-starter: PostgreSQL schema routing, Flyway, rollback, context cleanup, and leakage tests.
- outbox-pattern: atomic business/outbox transaction, concurrent claim/retry, and broker-outage recovery.
- Security: revoke exposed GitHub PATs.

## Efficiency

Excluded: all activity on 2026-07-20, attributed by the user to Antigravity/OpenCode.

Latest machine report:

- hard-limit occurrences: 8
- wait timeouts: 13
- command timeouts: 10
- avoidable occurrences: 72
- tracked duration: 2940.95 seconds

Four new hard-limit occurrences came from opening four heavy write agents simultaneously. Only the API agent produced substantive code; both frontend agents produced no files. New operating rule: at most two heavy write agents, preflight one writer, stabilize producers/contracts before consumers, and save a concise handoff before approaching limits.

Authoritative log: .portfolio-control/EXECUTION_EVENTS.jsonl.

## Continuation Order

1. Integrate and validate the staged contract plane in the full reuse-kit clone.
2. Push a reuse-kit branch, open a PR, require green CI, and merge.
3. Finish portfolio-evidence-api locally in the order: static checks, benchmark, docs, Docker, clean-source benchmark, independent review.
4. Publish #31 only after local and remote gates pass.
5. Start #32 after #31 contracts stabilize; start #33 only when operational command endpoints exist.
6. Repair Saga semantics before Kotlin migration, then multi-tenant and outbox P0.
7. Migrate one Python, one Go, and one Kotlin producer to benchmark V2 before broad rollout.

## Restart Commands

- .\tools\validate-kit.ps1
- .\tools\report-execution-efficiency.ps1 -JsonPath .portfolio-control\execution-efficiency.json
- .\tools\report-portfolio.ps1 -RepoRoot PORTFOLIO_ROOT -MarkdownPath .portfolio-control\PORTFOLIO_STATUS.md -JsonPath .portfolio-control\PORTFOLIO_STATUS.json
- python .\tools\generate-contract-manifest.py --check
- python .\tools\validate-contracts.py

Do not repeat the full static portfolio audit unless repository heads changed. Read this handoff, the machine reports, the dated audit, the technology coverage matrix, and the JVM decision matrix first.
