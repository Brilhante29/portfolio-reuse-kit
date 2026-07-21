# Current Handoff

Updated: 2026-07-21
Owner: principal agent
Goal: complete the existing portfolio with truthful evidence and expand to 33 repositories only through one interoperable evidence platform.

## Current State

- Existing repositories: 30. Approved catalog size: 33.
- Existing structural truth: Docker 30/30, CI workflow 30/30, tracked declared primary benchmark 19/30, contract V1 19/30, contract V2 0/30.
- Local structural candidates: 12/30. Publication candidates: 0/30. Verified publications: 0/30.
- Origins: 10/30. Upstreams: 10/30.
- All repository statuses now declare `implemented` or `benchmarked`; none is accepted as published without current-head CI evidence.
- Credentialed `pushurl` values were removed from local Git configs. Previously exposed PATs still require revocation in GitHub.

## Completed

- Reuse kit commit `f368601` was pushed to `agent/automate-agent-context`; GitHub Actions run `29856286092` passed.
- The kit has truthful status gates, execution telemetry, permanent handoff, implementation audit, publication evidence, and automatic GitHub CI verification.
- Reuse kit commit `3b52308` added the 33-project catalog, JVM decision matrix, technology coverage, benchmark V2, parsed YAML gates, generated design tokens, and interoperability architecture; GitHub Actions run `29870619438` passed.
- A follow-up generator patch now materializes all contracts, V2 fixtures, and generated design tokens into new repositories; the isolated scaffold smoke passed and the patch awaits commit.
- `load-test-suite` commit `016e084` fixed clean-clone build inputs, readiness, fail-closed k6 checks, and GOARCH handling. Go tests, Docker build, and calibrated k6 smoke passed.
- Twenty-three non-AI repositories received isolated status-audit commits. Four configured remotes were pushed: `alpr-mercosul`, `go-rate-limiter`, `mini-aws-emulator`, and `spring-hexagonal-payments`.
- AI Evaluation commits integrated and pushed:
  - `embeddings-benchmark` `df381a8`: deterministic vectorizers and correct Recall@k.
  - `llm-eval-harness` `8c156cf`: prediction artifact contract and strict ID validation.
  - `llm-agent-eval` `c92b0d2`: supplied trace evaluation with outcome, tools, latency, and cost.
  - `prompt-ab-testing` `2bf01bd`: blinded deterministic scoring without fixture multipliers.
  - `cost-aware-inference` `91da259`: provider port, measured local adapter, optional OpenAI-compatible adapter, and separated pricing assumptions.
  - `rag-knowledge-base` `0c248f9`: correct Recall@k, injected ports, safe data/result roots, six tests, strict OpenSpec, repeated benchmark, and Docker validation.
- All six AI Evaluation repair branches passed pull-request CI and were squash-merged into their `main` branches; local clones now track `origin/main`.
- `multi-tenant-starter` commit `d46c176` repairs invalid YAML and truthfully marks the current in-memory implementation as a prototype. PostgreSQL and Flyway are no longer claimed as current stack.

## Approved Expansion

The missing technologies are real gaps: Node/TypeScript/NestJS, GraphQL, Next.js/React, Angular, and RabbitMQ have no executable proof in the initial 30. The approved solution is one macro system with three independently deployable repositories, not isolated technology demos:

31. `portfolio-evidence-api`: NestJS/Fastify, REST ingestion and commands, GraphQL queries, Ajv, Kysely, SQLite local-first, PostgreSQL and Kumo adapters.
32. `portfolio-evidence-console`: Next.js/React public evidence and AI evaluation experience.
33. `portfolio-operations-console`: Angular operational workflows for quarantine, revalidation, remediation, publication gates, and CI incidents.

RabbitMQ is conditional inside `saga-orchestrator`; it enters only with routing, acknowledgements, retries, DLQ recovery, and a measured failure case. No broker-only repository is approved.

## JVM Decision

- Keep Kotlin: `spring-hexagonal-payments`, `kafka-streams-demo`.
- Convert after semantic repair: `saga-orchestrator` to Kotlin sealed state/outcome modeling.
- Keep Java: `event-sourcing-orders`, `multi-tenant-starter`, `cache-strategies-bench`.
- Mixed interoperability: `outbox-pattern` uses a framework-free Java core/contracts and Kotlin Spring runtime/adapters after atomic persistence is implemented.
- Every JVM repository requires Gradle Wrapper, `build.gradle.kts`, explicit toolchain, equal quality gates, and Docker.
- Do not publish Java-versus-Kotlin microbenchmarks unless implementation variables are controlled.

## Applied Reuse-Kit Changes Awaiting Commit

- Strong benchmark V2 contract with run/workload identity, metric arrays, failure counts, execution metadata, environment, clean commit, image and lockfile digests, artifact digest, and comparability key.
- Valid and invalid golden fixtures plus JSON Schema validation.
- YAML parsing gate; this caught and repaired the malformed `agent-graph.yaml` before publication.
- Catalog expanded to 33 and stack values synchronized from project manifests; the previous catalog had 24 stack drifts.
- JVM language decision matrix, technology coverage matrix, and interoperability architecture document.
- Publication remains V2 plus current-head remote CI evidence; V1 is local compatibility only.

## Active Work

- `portfolio-evidence-api` is being implemented in `new-project-worktrees/portfolio-evidence-api`; it is not published and must remain local until tests, HTTP benchmark, Docker, SDD, and handoff pass.
- `saga-orchestrator` repair is isolated at `C:\tmp\saga-kotlin` on `agent/kotlin-saga-repair`. The preflight found 111 tracked `.gradle` cache files; the agent must remove them before semantic repair and Kotlin migration.
- Reuse kit branch `agent/reject-tracked-build-caches` adds a validator gate for `.gradle`, `node_modules`, `.venv`, `.terraform`, root build outputs, Next output, and coverage. Local kit validation passed; commit/PR/merge remain.
## Remaining P0

- `saga-orchestrator`: empty compensation logic and false consistency benchmark. Repair semantics before Kotlin conversion.
- `multi-tenant-starter`: implement real PostgreSQL schema routing, Flyway, rollback, HTTP context cleanup, and leakage tests.
- `outbox-pattern`: atomically write business data and outbox, add concurrent claim/retry, and prove broker outage recovery.
- Security: PATs removed locally but GitHub revocation remains mandatory.

## Efficiency Baseline

Excluded: all work on 2026-07-20, attributed by the user to Antigravity/OpenCode.

- Hard authorization limits: 4.
- Wait timeouts: 13.
- Command timeouts: 10 occurrences.
- Avoidable occurrences: 59.
- Tracked duration: 2923.55 seconds.
- Exact history: `.portfolio-control/EXECUTION_EVENTS.jsonl`.

Do not repeat equivalent Docker strategies after one isolated passing path. Read script parameters before invocation. For source-block edits, use delimiter-based replacement and parse immediately.

## Continuation Order

1. Commit and merge `agent/reject-tracked-build-caches` after GitHub CI.
2. Review, integrate, and publish `portfolio-evidence-api` only after its full local and remote gates pass.
3. Review and integrate the saga semantic repair/Kotlin migration, then migrate one Python, one Go, and one Kotlin producer to V2.
4. Repair saga, multi-tenant, and outbox P0 semantics; apply the JVM decisions above.
5. Implement `portfolio-evidence-console`, then `portfolio-operations-console` after the API contracts stabilize.
6. Repair the YOLO-to-serving artifact path and the data-quality to drift path.
7. Migrate remaining primary baselines to V2 and publish only current-head green CI evidence.

## Restart Commands

```powershell
./tools/validate-kit.ps1
./tools/validate-portfolio.ps1 -RepoRoot <portfolio-root> -JsonPath .portfolio-control/portfolio-audit.json
./tools/report-execution-efficiency.ps1
./tools/report-portfolio.ps1 -RepoRoot <portfolio-root> -MarkdownPath .portfolio-control/PORTFOLIO_STATUS.md -JsonPath .portfolio-control/PORTFOLIO_STATUS.json
python ./tools/sync-catalog-stacks.py --repo-root <portfolio-root> --catalog ./catalog/projects.yaml --markdown ./catalog/projects.md --check
```

Do not repeat the full static audit unless repository heads changed. Read the machine reports, dated audit, technology coverage matrix, JVM decision matrix, and this handoff first.
