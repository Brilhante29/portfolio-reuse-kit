# Current Handoff

Updated: 2026-07-30
Owner: principal agent
Purpose: provide an auditable engineering continuation map. This records observations, decisions, evidence, rejected alternatives, failures, and exact next actions. It does not contain private chain-of-thought.

## Read First

1. Read this file.
2. Read decision-brain/continuity-protocol.yaml.
2. Read decision-brain/jvm-language-matrix.yaml.
3. Read decision-brain/kafka-streams-matrix.yaml.
4. Read decision-brain/stack-matrix.yaml and decision-brain/messaging-matrix.yaml.
5. Read catalog/technology-coverage.yaml and catalog/programs.yaml.
6. Read the target repository project.yaml and SDD before changing code.
7. Re-run only the checks affected by a changed repository head.

## Goal And Quality Bar

The reuse kit is the decision, contract, validation, and agent handoff plane for the portfolio. A repository is portfolio-ready only when its claim is true, the default Docker path works without paid credentials, the README opens with the repository number and measured result, SDD and references are complete, a benchmark artifact is reproducible, tests pass, CI is green on the published head, and no secret is tracked.

Architecture and stack follow the problem. Public proficiency signal may break a tie between technically valid choices, but it may not create a need for a framework, broker, cloud service, language migration, or extra repository.

## Portfolio Truth

- Canonical original repositories: 30.
- Planned evidence-platform repositories: 31 API, 32 public console, 33 operations console.
- Public original repositories with origins: 10 of 30.
- Public numbered repositories including the API: 11 of 33.
- Repository 31 is implemented and public but is not publication-ready because its security gate correctly found six high-severity dependency advisories.
- Repositories 32 and 33 have no application implementation and must not be counted as created or complete.
- All 30 original manifests currently claim benchmarked, but that declaration is not trustworthy. The last central audit recognized 19 tracked primary benchmarks, zero V2 producers, and zero publication candidates.
- Sixteen of the 30 original manifests fail the current central project schema.
- Do not report 30 complete projects or 33 created repositories.

## Public And Verified Repositories

The ten original public repositories had a successful latest default-branch workflow at the audit time: alpr-mercosul, cost-aware-inference, embeddings-benchmark, go-rate-limiter, llm-agent-eval, llm-eval-harness, mini-aws-emulator, prompt-ab-testing, rag-knowledge-base, and spring-hexagonal-payments.

Caveats:

- Some local agent branches are ahead of the green remote main and are not covered by that green run.
- Several GitHub default branches incorrectly point to agent/sync-agent-contract.
- No audited public JVM repository has branch protection enabled.
- A green historical run does not prove the current local head.

## Repository 31: portfolio-evidence-api

Public repository: https://github.com/Brilhante29/portfolio-evidence-api

Implemented stack:

- Node 24, TypeScript, NestJS 11, Fastify 5, Mercurius GraphQL
- Kysely with SQLite and a PostgreSQL-compatible persistence boundary
- Ajv contract validation, Pino, Prometheus, Vitest
- modular monolith with framework-free domain and application boundaries
- REST for writes and commands; GraphQL for flexible reads
- non-root Docker image and health check

Measured clean-source Docker baseline:

- ingestion p95: 40.201 ms
- ingestion throughput: 438.148 requests/s
- GraphQL p95: 24.119 ms
- failures: 0
- source commit: 14e43efd63d780d21d71ca2d7ad6b0dde6bcdd0a
- image digest: sha256:09673d4874d540778ea5562d98097802d9636da6eb014dd2bae6df8583ccc6f1

Verification before the security failure:

- 35 tests on Node 24 Docker
- statements and lines coverage: 93.05 percent
- branch coverage: 89.4 percent
- function coverage: 100 percent
- project validator, benchmark digest, and benchmark schema passed

CI history:

- Run 30188840609: checks, coverage, and calibration passed; npm audit transport failed because npm parsed a raw gzip bulk response as JSON.
- A dependency-free audit client was implemented with identity encoding, defensive gzip decode, retries, schema checks, and tests.
- Run 30189214178: transport worked and found six real high-severity advisories.

Security findings that must be fixed, not allowlisted:

- @fastify/static, advisory GHSA-83w8-p2f5-377r
- brace-expansion, advisory GHSA-mh99-v99m-4gvg
- fast-uri, advisories GHSA-v39h-62p7-jpjc and GHSA-q3j6-qgpj-74h6
- find-my-way, advisory GHSA-c96f-x56v-gq3h
- ws, advisory GHSA-96hv-2xvq-fx4p

Policy blocker:

Updating package-lock.json requires sending local dependency names and versions to the public npm registry. Do not run the npm update until the user explicitly authorizes that disclosure. The exact requested authorization is:

AUTORIZO enviar ao registro pÃƒÆ’Ã‚Âºblico npm os nomes e versÃƒÆ’Ã‚Âµes das dependÃƒÆ’Ã‚Âªncias do package-lock.json para atualizar os patches de seguranÃƒÆ’Ã‚Â§a.

The repository currently has only sdd/agent-handoff.md uncommitted. Read it before continuing.

## Technology Coverage Decision

Do not create a repository only to add a technology keyword.

Coverage already sufficient:

- Kotlin, Java, Spring, and Gradle: repair the seven existing JVM repositories.
- Python and FastAPI: already over-represented; improve real HTTP and infrastructure evidence.
- Go: five repositories; remove duplicated rate-limiting claims between the limiter and gateway.
- Kafka: improve Kafka Streams and outbox evidence; do not add a separate Kafka repository.
- RabbitMQ: keep conditional for a future saga command-queue problem with ack, retry, DLQ, and recovery evidence.
- Kumo: mini-aws-emulator is the real local-first proof. Remove artificial Kumo fields from projects with no cloud behavior.
- MLflow and Airflow: strengthen mlops-end2end so Airflow actually starts the DAG and MLflow promotes the exact served artifact.
- Terraform: terraform-aws-baseline already owns this signal.

Real gaps:

- Node, NestJS, and GraphQL are implemented by repository 31 but blocked by dependency remediation.
- React and Next.js belong in repository 32 only after the API is stable and at least three V2 producers exist: one Python, one Go, and one JVM.
- Angular belongs in repository 33 only when at least three real quarantine, revalidation, remediation, or publication command workflows exist.

No repository 34 is currently justified.

## JVM Decision

Keep Kotlin:

- spring-hexagonal-payments
- kafka-streams-demo

Keep Java:

- event-sourcing-orders
- multi-tenant-starter
- cache-strategies-bench

Conditional Kotlin:

- saga-orchestrator only after semantic repair is proven in Java by the P0 contract suite

Mixed JVM:

- outbox-pattern should use a framework-free Java core and contracts with Kotlin Spring runtime and infrastructure adapters, but only after atomic persistence exists

Global JVM gates:

- Gradle Wrapper scripts, JAR, properties, executable mode, pinned released distribution, and distribution checksum
- Gradle Kotlin DSL and settings.gradle.kts
- explicit Java and Kotlin toolchains with aligned compiler targets
- the same test, lint, architecture, benchmark, Docker, and CI gates for Java and Kotlin
- CI and Docker must use the Wrapper, never global Gradle or Maven
- no Java-versus-Kotlin performance post unless implementation and workload variables are controlled

Seven-repository JVM audit:

- spring-hexagonal-payments: only repository with complete executable Wrapper and checksum; remote main green
- kafka-streams-demo: Wrapper absent, toolchain incomplete, benchmark evidence inconsistent
- cache-strategies-bench: wrapper JAR absent, script not executable, no Actions runs
- event-sourcing-orders: remote CI red because workflow used environment Gradle and JUnit Platform Launcher was missing
- multi-tenant-starter: script not executable, no Actions runs, real tenancy semantics absent
- outbox-pattern: script not executable, Docker masks failures, atomic outbox absent
- saga-orchestrator: script not executable, no Actions runs, compensation semantics false

## Kafka Streams Decision

Repository 28 stays Kotlin without Spring because the claim is the topology, not HTTP or dependency injection.

Required split of evidence:

- TopologyTestDriver microbenchmark proves deterministic topology semantics only.
- Real broker benchmark proves broker, network, partitions, rebalance, restoration, retention, and end-to-end throughput.
- Driver throughput must never be presented as Kafka throughput.
- Both modes must fail before reporting performance when input and output invariants do not hold.
- Use at least five measured samples after explicit warmup.
- Record keys, repartitioning, SerDes and schema evolution, stream/table semantics, state stores, processing guarantee, invalid-record handling, retry or quarantine, and restoration behavior.

Current repository 28 contradictions:

- README reports 10.2940 messages/s for 1,000 records.
- tracked baseline reports 17.91656 messages/s for 100,000 records and took about 5,581,428 ms.
- project.yaml command points to latest.json while result_path points to baseline.json.
- project.yaml claims Spring and artificial Kumo or AWS adapters although neither exists.
- CI and Docker invoke global Gradle.
- branch agent/gradle-wrapper-hardening-v2 is the correct repair worktree; the similarly named v1 worktree is stale and must not be edited.

## Saga And Outbox P0

Saga currently has a tautological consistency benchmark, no-op production compensation, ignored compensation failures, and no durable state. Do not migrate it to Kotlin first.

Saga acceptance requires:

- real resource states and reverse compensation
- COMPENSATION_FAILED and manual intervention for irreversible or failed actions
- PostgreSQL durability, optimistic versioning, atomic transition persistence
- idempotency conflict behavior and concurrent start or recovery tests
- process-kill and restart scenarios
- semantic suite green before Kotlin adapters are introduced

Outbox currently persists only in-memory events and its failure benchmark recovers vacuously.

Outbox acceptance requires:

- aggregate mutation and outbox insert in one PostgreSQL transaction and connection
- at-least-once relay with broker confirmation before mark-published
- persistent retry, bounded backoff, lease or SKIP LOCKED, and terminal state
- expected transport duplicates plus consumer inbox deduplication
- zero atomicity violations, zero missing committed events after recovery, and zero duplicate business effects
- Kafka or Redpanda is justified when feeding kafka-streams-demo; do not claim exactly once

## Reuse-Kit Branch Status

Branch `feat/jvm-kafka-governance` was merged into `main` as commit `16a9396`
("Govern JVM, Kafka Streams, and manifest v2 rollout (#5)"). Local head and
`origin/main` both point to `16a9396`. The in-progress section below is kept
for traceability of what shipped; the "next actions" in this handoff describe
post-merge work, not the branch itself.

Implemented on this branch:

- project schema supports dimensional JVM and messaging decisions
- benchmarked and published statuses require current evidence status
- cloud mode none rejects artificial Kumo or AWS provider metadata
- all five SOLID principles and all architecture problem forces are required
- Kotlin JVM, Java Spring, and Kafka Streams profiles
- Kafka Streams decision matrix and Codex or Claude skill
- reviewed Gradle Wrapper distribution and JAR checksum validation for 8.10.2, 8.12, and 9.3.0
- toolchain and target alignment checks
- executable gradlew check
- CI Wrapper validation requirement
- Gradle-based Spring Docker and Actions templates
- planner parses project YAML structurally and emits the full Kafka contract: processing mode, topics, keys, repartition, SerDes, topology, joins, windows, stores, changelog, guarantees, invalid records, restoration, rebalance, benchmark modes, and evidence
- project sync and scaffold copy the Gradle validator and continuity automation with their callers
- project schema fixtures cover JVM profile, Kafka selection from either side of the decision, orphan Kafka Streams blocks, checksums, non-JVM behavior, and legacy compatibility
- manifest v2 rollout audit separates current compatibility from v2 readiness
- contract set bumped from 1.1.0 to 1.2.0
- continuity protocol, matching Codex and Claude skill, compact multi-worktree snapshot command, and root agent pointers

Local verification completed:

- all 45 YAML files parsed
- project schema is Draft 2020-12 valid
- all valid v2, non-JVM, and legacy fixtures have zero schema errors
- benchmark, missing JVM, Kafka mismatch, unknown Wrapper checksum, and mismatched Wrapper version/checksum fixtures are rejected
- the 30 original manifests remain 14 valid and 16 invalid under both old and versioned schemas; compatibility changes: zero
- rollout audit reports 5 manifests v2-ready and 25 pending explicit migration
- contract validator passed OpenAPI, GraphQL, project fixtures, benchmark fixtures, and manifest
- full tools/validate-kit.ps1 passed
- PowerShell scripts parsed
- git diff --check passed
- a minimal reviewed Gradle 8.12 fixture passed the strict structural validator
- matching manifest/Wrapper/build/Docker/CI JVM 21 passed; manifest JVM 17 against build and Docker 21 was rejected
- dynamic CI JVM versions, workflow global Gradle using dash-run syntax, and Docker bases not bound to JVM_VERSION were rejected
- a fixture with global Gradle and non-executable gradlew was rejected with exit code 1
- planner smoke retained every schema-required Kafka Streams decision after structured PyYAML parsing
- sync smoke installed contract set 1.2.0 plus validator helpers; new-project smoke selected manifest v2 and included continuity automation
- continuity snapshot plus every public file, including handoffs, are scanned for personal absolute paths and live GitHub-token shapes
- the current Kafka repository was rejected for the expected Wrapper, toolchain, Docker, and CI violations
- the GitHub Actions template uses official gradle/actions/setup-gradle v6, whose wrapper validation is enabled by default
- final independent re-review reported no remaining merge blockers

Validation environment:

- isolated venv: reuse-kit-jvm-kafka/.venv
- dependencies come from requirements-ci.txt
- activate by putting .venv/Scripts first on PATH
- .venv is ignored and must never be committed

## Current Worktrees And Safety

Use:

- reuse-kit-jvm-kafka for the active reuse-kit branch
- jvm-worktrees/kafka-wrapper-hardening-v2 for Kafka repair
- new-project-worktrees/portfolio-evidence-api for repository 31
- <saga-worktree> only after reading its dirty state carefully

Do not use:

- jvm-worktrees/kafka-wrapper-hardening, which starts from stale Kafka main
- stream28-src or stream28-ready, which are independent dirty copies without remotes
- scratch-kafka or spring-payments-src as sources of truth

Never revert unrelated or pre-existing changes. The saga worktree contains many user or generated changes and tracked .gradle artifacts; inspect and preserve intent before cleanup.

## Efficiency And Failures

Execution telemetry excludes 2026-07-20, attributed by the user to Antigravity and OpenCode.

Current report after excluding 2026-07-20:

- event records: 45
- occurrence count: 95
- hard-limit occurrences: 8
- wait-timeout occurrences: 16
- avoidable occurrences: 78
- tracked duration: 3,200.95 seconds

This branch recorded:

- two apply_patch Windows sandbox failures, recovered without another retry path
- one avoidable recursive Git copy into C:\tmp, replaced by a minimal workspace smoke fixture
- one planner YAML-shape failure that exposed regex truncation and was fixed with structured PyYAML parsing
- three avoidable reviewer wait timeouts; the reviewer was then interrupted for an immediate bounded verdict
- one avoidable stale CI smoke fixture; current templates now seed the coherence test
- one avoidable continuity-count diagnostic; corrected by reading the matched line without rerunning all gates
- no new weekly or authorization limit hit; exact account quota remains unobservable
Operating rules:

- exact account weekly quota is not observable; checkpoint proactively at milestones, repeated failures, user warning, or context risk
- no more than two heavy write agents at once
- delegate disjoint write sets only
- avoid repeated waits; continue non-overlapping local work
- use known-good worktrees and verify branch or head before editing
- write the SDD and update this handoff before implementation milestones
- capture exact failing evidence instead of retrying blindly
- save an updated handoff before any context or tool limit risk

## Security

The user pasted GitHub personal access tokens in conversation. Never write them to files, Git config, remotes, logs, commands, or this handoff. Use GH_TOKEN from the environment only through ephemeral authentication. The user must revoke and rotate all exposed tokens.

Do not lower security thresholds, omit advisories, or allowlist real findings to obtain a green build.

## Continuation Order

1. Review this branch diff and run the full reuse-kit validation again.
2. Update contract and kit documentation links if the review finds missing navigation.
3. Commit feat/jvm-kafka-governance, push it, open a PR, wait for green CI, and merge.
4. Sync contract set 1.2.0, JVM gates, and Kafka skill into repository 28.
5. Repair repository 28 SDD and manifest before code.
6. Add the reviewed Gradle 8.10.2 Wrapper, checksum, toolchain, CI Wrapper validation, and Wrapper-only Docker commands.
7. Split repository 28 into driver microbenchmark and real-broker benchmark; generate a new truthful V2 baseline.
8. Publish repository 28 only after clean-source Docker and remote CI pass.
9. Continue repository 31 security remediation only after the exact npm-registry authorization is received.
10. Migrate one Python, one Go, and repository 28 as the Kotlin V2 producer before starting repository 32.
11. Keep repository 33 conditional on real operations workflows.
12. Repair event-sourcing CI, then saga semantics, multi-tenancy, and outbox atomicity in that order.

## Restart Commands

From the reuse-kit root:

    $env:PATH=(Resolve-Path .venv\Scripts).Path+[IO.Path]::PathSeparator+$env:PATH
    .\tools\validate-kit.ps1
    python .\tools\generate-contract-manifest.py --check
    python .\tools\validate-contracts.py
    git diff --check
    git status --short --branch

From repository 28 after the kit branch is merged and synced:

    .\tools\validate-gradle-project.ps1 -RepoPath .
    .\gradlew.bat --no-daemon clean check
    docker build -t kafka-streams-demo .

## Post-Merge Snapshot Backlog

The merge added 8 contract files (1.2.0 set) under `portfolio-reuse-kit/contracts/`
and 3 decision-brain matrices that were NOT yet mirrored in each repo's
`.portfolio/` snapshot.

### 2026-07-27 Snapshot Sync — Completed

`relay/scripts/_sync-snapshot.ps1` performed an additive, non-overwriting
copy from `portfolio-reuse-kit/contracts/` and `portfolio-reuse-kit/decision-brain/`
into each of the 30 repos' `.portfolio/`:

- 209 contract files added (7/repo, 1 pre-existing on `model-drift-detector`)
- 90 decision-brain files added (3/repo: `continuity-protocol.yaml`,
  `jvm-language-matrix.yaml`, `kafka-streams-matrix.yaml`)
- 0 errors

Post-sync verification:

- `python tools/validate-contracts.py` — green
  ("validated 45 YAML files, project and benchmark V2 fixtures, OpenAPI,
  GraphQL, and contract manifest")
- `python relay/scripts/_validate-manifests.py` — **14 manifests valid,
  16 invalid** (confirms handoff's pre-sync claim)

Pre-existing repo-specific extras preserved: `vision-model-artifact.schema.json`
in `yolo-training-pipeline`.

### Remaining Backlog (after snapshot sync)

1. **Manifest v2 migration**: 16 of 30 `project.yaml` files fail the current
   schema. Categories observed:
   - missing `design_system` block (alpr-mercosul, kafka-streams-demo,
     melanoma-classifier, stroke-signal-demo, ...)
   - `decision_brain.stack_profile` using raw language (`python`, `java`,
     `go`) instead of enum values (`fastapi-backend`, `java-spring-backend`,
     `kotlin-jvm`, ...)
   - `decision_brain.api_style` multi-value (`rest-http+grpc`) instead of
     single enum value
   - `architecture.boundaries` items as dicts instead of strings
   - `architecture.problem_forces.data_or_ml_reproducibility: none`
     not allowed (enum: low/medium/high)
   - `decision_brain.principles.solid` items as dicts instead of strings
2. Repo 28 (kafka-streams-demo) — once manifest is valid, repair:
   `command`/`result_path` contradiction, artificial Kumo/AWS providers,
   add reviewed Gradle wrapper, split TopologyTestDriver microbenchmark
   from real-broker benchmark, generate truthful V2 baseline.
3. Repo 14 (event-sourcing-orders): CI repair (JUnit Platform Launcher,
   wrapper-only Gradle).
4. Repo 19 (cache-strategies-bench): wrapper JAR + executable script + CI.
5. Repo 17 (multi-tenant-starter): executable script + real tenancy semantics.
6. Repo 16 (saga-orchestrator): resource states, real reverse compensation,
   durable state.
7. Repo 20 (outbox-pattern): atomic aggregate + outbox in one PostgreSQL
   transaction; at-least-once relay with broker confirmation.
8. Repo 31 (portfolio-evidence-api) npm remediation: BLOCKED until user
   pastes the exact authorization phrase from handoff L95.

### Manifest Schema-Failure Inventory (16)

- alpr-mercosul — missing design_system
- api-gateway-lite — boundaries item is dict, not string
- cache-strategies-bench — stack_profile raw
- cost-aware-inference — stack_profile raw
- embeddings-benchmark — stack_profile raw
- grpc-vs-rest-bench — api_style multi-value
- kafka-streams-demo — missing design_system
- llm-agent-eval — stack_profile raw
- llm-eval-harness — stack_profile raw
- load-test-suite — boundaries item is dict
- melanoma-classifier — missing design_system
- multi-tenant-starter — principles.solid items are dicts
- outbox-pattern — problem_forces.data_or_ml_reproducibility: none invalid
- prompt-ab-testing — stack_profile raw
- saga-orchestrator — boundaries item is dict
- stroke-signal-demo — missing design_system

### Operating Constraints Reminder

- No bulk write without a per-repo verify step.
- No claim of `benchmarked` or `published` from a manifest alone — evidence
  required.
- Never lower a security gate to make CI green.
- Never commit secrets or local paths.

### 2026-07-30 Continuity Map

- Added `docs/agent-continuation-map.md` as the durable, reviewable map of
  portfolio intent, decision order, boundaries, evidence, and continuation.
- Added `templates/portfolio-control/DECISION_CONTEXT.md`; new scaffolds and
  backfills now receive a project-level rationale context card.
- Clarified in `AGENTS.md` and `CLAUDE.md` that continuity artifacts contain
  observable rationale only and never private chain-of-thought.
- Updated the continuity protocol, generator, backfill, and README navigation.
- Existing current state, counts, blockers, dirty files, and branch facts remain
  authoritative in this handoff and must be refreshed before the next action.

## 2026-07-30 #11 publication closure

- #11 published with Kotlin/Gradle dependency locking and three-run V2 benchmark provenance.
- The next active project is #13; audit Kumo/local-first boundaries before implementation.
