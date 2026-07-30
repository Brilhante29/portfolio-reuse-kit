# Current Handoff

Updated: 2026-07-30
Owner: principal agent
Purpose: provide an auditable engineering continuation map. This records observations, decisions, evidence, rejected alternatives, failures, and exact next actions. It does not contain private chain-of-thought.

## Current Critical Path - 2026-07-30

Repository 3, `rag-knowledge-base`, is the active implementation project. Its branch is `codex/rag-knowledge-base/publication-gates` at the last audited head `e8d00dff29be52340f5c5913b60aa15aa129222f`. The economic audit is in progress; no implementation edit has been accepted yet.

Repository 28, `kafka-streams-demo`, is parked as a release candidate. PR 1 and its pull-request CI are green on head `1db8d620d918eda88aa4397c20b9557694c0db37`. It remains draft and unmerged because explicit owner authorization is required. Do not merge it autonomously.

The truthful-checkpoint reuse-kit work is in PR 6 on branch `codex/portfolio-reuse-kit/truthful-checkpoint`. CI was green on published head `de84916639458123853e69462dc7cc7aa4325057`. A local security follow-up is adding a Git-auth sanitizer and must be committed, pushed, and verified on remote CI before the PR is again release-ready. Do not merge it autonomously.

Security remediation completed on the portfolio root:

- 31 direct repository Git configurations were audited without printing credential values
- 29 configurations contained authenticated URLs or token-like local values
- all 29 were normalized to clean canonical `origin` URLs and branch remotes named `origin`
- local HTTP authorization extraheaders were removed
- the second audit found zero affected configurations
- exposed conversation tokens must be revoked and rotated; they must never enter repository files, Git URLs, logs, commands, or handoffs

Strict continuation order:

1. Finish and fully validate the reusable Git-auth sanitizer.
2. Commit and push the security follow-up to PR 6 using only ephemeral `GH_TOKEN` authentication; verify current-head remote CI.
3. Complete the economic P0/P1 audit of repository 3 from code and evidence.
4. Reuse kit contracts selectively, then close only P0/P1 gaps in repository 3.
5. Produce a truthful benchmark V2, Docker evidence, security scans, SBOM, documentation, and current-head CI for repository 3.
6. Keep repository 28 parked until explicit merge authorization arrives.

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

## Reuse-Kit Branch In Progress

Worktree: `<workspace>/reuse-kit-truthful-checkpoint`

Branch: `codex/portfolio-reuse-kit/truthful-checkpoint`

Published commits:

- `0e6b036 feat(control): derive truthful portfolio checkpoints`
- `de84916 fix(ci): enforce immutable action references`

Published PR evidence:

- PR: https://github.com/Brilhante29/portfolio-reuse-kit/pull/6
- green CI before the local security follow-up: https://github.com/Brilhante29/portfolio-reuse-kit/actions/runs/30563468338
- mergeable, draft, and unmerged; explicit owner authorization is required

Security follow-up in this branch:

- `tools/sanitize-git-auth.ps1` audits or remediates direct child repository Git configurations without printing matched values
- `tools/test-sanitize-git-auth.ps1` covers credentialized remotes, credentialized branch remotes, and authorization extraheaders
- `tools/clear-github-token.ps1` can invoke repository-config sanitization
- `docs/usage.md` documents sanitization and audit-only commands
- `tools/validate-kit.ps1` requires and runs the sanitizer fixture
- this handoff records the remediation and current critical path

Local validation completed on this exact security diff:

    git diff --check
    ./tools/test-sanitize-git-auth.ps1
    ./tools/validate-kit.ps1

The expected commit subject is `fix(security): sanitize persisted Git credentials`. Push only with an ephemeral HTTP header derived from `GH_TOKEN`; PR 6 CI must be green on the resulting branch head.

## Current Worktrees And Safety

Use:

- `<workspace>/reuse-kit-truthful-checkpoint` for PR 6 and the Git-auth sanitizer
- `<portfolio-root>/rag-knowledge-base` for active repository 3
- the known repository 28 release worktree only when verifying or completing its authorized release

Safety rules:

- verify branch, head, upstream, and working-tree status before every edit
- preserve unrelated user or generated changes
- do not merge PR 1 or PR 6 without explicit owner authorization
- do not persist credentials in Git configuration; use `GH_TOKEN` only through an ephemeral header
- do not repeat a full static portfolio audit unless repository heads changed
- if account or context capacity becomes uncertain, update this handoff, STATE.json, queue, and execution telemetry before stopping

## Efficiency And Failures

Execution telemetry excludes 2026-07-20, attributed by the user to Antigravity and OpenCode.

Current report after excluding 2026-07-20:

- event records: 46
- occurrence count: 97
- hard-limit occurrences: 8
- wait-timeout occurrences: 18
- avoidable occurrences: 80
- tracked duration: 3,350.95 seconds

This branch recorded:

- two apply_patch Windows sandbox failures, recovered without another retry path
- one avoidable recursive Git copy into C:\tmp, replaced by a minimal workspace smoke fixture
- one planner YAML-shape failure that exposed regex truncation and was fixed with structured PyYAML parsing
- three avoidable reviewer wait timeouts; the reviewer was then interrupted for an immediate bounded verdict
- one avoidable stale CI smoke fixture; current templates now seed the coherence test
- one avoidable continuity-count diagnostic; corrected by reading the matched line without rerunning all gates
- two bounded waits totaling 150 seconds produced no independent-review verdict for the truthful checkpoint; the reviewer was closed and deterministic validation remained authoritative
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

1. Validate, commit, and publish the reuse-kit sanitizer follow-up; verify PR 6 CI on its new head.
2. Inspect repository 3 implementation, tests, manifests, benchmark, Docker path, CI, dependency reproducibility, and public evidence.
3. Write the repository 3 P0/P1 audit and reuse map before changing application behavior.
4. Implement only claim-critical gaps, validating after each logical slice.
5. Generate benchmark V2 from a clean reproducible path and close release documentation.
6. Push repository 3 through a draft PR and verify real pull-request CI before any merge request.
7. Keep repository 28 in release-candidate state until explicit owner authorization.
8. Update root checkpoint data after every repository head or publication-state change.

## Restart Commands

From the reuse-kit worktree:

    git status --short --branch
    ./tools/test-sanitize-git-auth.ps1
    ./tools/validate-kit.ps1
    git diff --check

From repository 3:

    git status --short --branch
    git rev-parse HEAD
    git remote get-url origin
    python -m unittest discover -s tests -v
    python benchmarks/run_benchmark.py
    docker build -t rag-knowledge-base .

Do not report a repository complete from declared status or file presence. Completion requires measured evidence, green CI on the published current head, publication verification, and the evidence-derived checkpoint.

Do not include private chain-of-thought in handoffs. Record observations, decisions, rejected options, commands and results, blockers, and the exact next action.
