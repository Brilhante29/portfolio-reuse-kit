# Current Handoff

Updated: 2026-08-02
Owner: principal agent
Purpose: let another AI or human resume from observable engineering facts. This file records decisions, evidence, rejected alternatives, failures, and exact next actions. It never stores private chain-of-thought.

## Continuation Order

1. Read `docs/agent-continuation-map.md` for the durable rationale and this file for current facts.
2. Run `git status --short --branch` in the kit and target repository before editing.
3. Read `.portfolio-control/TRACKER.json`, `PROJECT_QUEUE.md`, `QUALITY_GATES.md`, and the target `project.yaml` plus SDD.
4. Select one active project and at most one reusable-kit improvement.
5. Run targeted checks before the full Docker and CI gates.
6. Update this handoff with exact commits, runs, dirty files, failures, and the next command.

## Current Truth

| Scope | State | Evidence |
|---|---|---|
| Original portfolio | 30 repositories audited | 30 Docker definitions, 30 CI workflows, 30 tracked benchmark contracts, 4 V2 artifacts |
| Published and centrally verified | #3, #11, #13 | exact-head GitHub Actions evidence under `.portfolio-control/publications/` |
| Reuse kit | published and green | commit `16a3622`, run `30774849915` |
| Active defect family | V2 semantic integrity | ALPR V2 says one measured iteration for a 100-plate workload |
| Next macro build | #21 `mlops-end2end` | starts after the ALPR evidence repair closes |

The central strict audit passed with:

```text
repositories=30 docker=30 ci=30 tracked_benchmarks=30
contract_benchmarks=30 contract_v2=4 local_candidates=30
publication_candidates=4 published_verified=3
declared_published_unverified=0
```

Do not translate `local_candidates=30` into 30 published projects. It means the local contract gate recognizes all 30; only three repositories have exact-head publication evidence.

## Completed Publication Chain

### #3 rag-knowledge-base

- Published head: `0cb9c6cc7d7ceb2b6e57c116403531de61ace02d`.
- Exact-head CI: `30638261570`.
- Claim: Recall@3 `1.00`, average `0.3175 ms`, p95 `0.4523 ms`, zero measured API cost.
- Local warning: two benchmark JSON files have pre-existing timestamp-only worktree churn. Preserve them; published validation reads committed `HEAD` and reports dirty files separately.

### #11 spring-hexagonal-payments

- Published head: `71925cf204f6aa62238edad28a11822a2db41106`.
- Exact-head CI: `30638268558`.
- Stack: Kotlin 2.4.10, Gradle 9.3, Spring Boot 4.1, PostgreSQL, Flyway, JDBC, k6.
- Claim: median p99 `108.122 ms`, mean `734.4 req/s`, minimum core coverage `95.65%`, zero HTTP failures.

### #13 mini-aws-emulator

- Benchmark source head: `33387dbf8c31206bcc5fed4ed8ae8533d27c8fb8`.
- Source CI: `30772714926`.
- Final published head: `8d3a4f7813b16bb61f9fbbfea19e7e6b41a5abbb`.
- Final exact-head CI: `30774984792`; Test, Vet, Docker build, scoped smoke evidence, and portfolio contract all passed.
- Claim: 100 percent scoped S3/SQS/DynamoDB conformance, median p95 `1.704 ms`, mean `764.682 ops/s`, 81.2 percent core coverage, zero failed operations.
- Runtime: Go 1.25.10, AWS SDK Go v2 1.41.9, pinned Kumo 0.25.3 by OCI digest.
- Limit: local Kumo latency is not an AWS production performance claim.

## Why The Kit Changed

The #13 publication exposed a reusable semantic problem. The generic V2 producer treated V1 `repeat=1` as workload size. That can be schema-valid and still false: ALPR processes 100 plates but its generated V2 artifact says one measured iteration.

Decision:

- `execution.repeat` means independent repetitions only.
- `workload.measured_iterations` must be explicit or derived from an unambiguous workload count.
- Missing or conflicting counts fail generation.
- Multi-run, multi-metric, and provider-specific aggregation stays project-owned behind the shared V2 schema.

Kit evidence:

- `6f557a0`: truthful measured-iteration semantics, bounded paths, clean-source provenance, immutable image digest, seven unit tests, and matching Codex/Claude skill.
- `16a3622`: published evidence is validated from committed `HEAD`; unrelated local generated churn remains visible but cannot rewrite published truth.
- Kit CI `30774849915`: every step passed.

Rejected alternatives:

- Reusing run repetition as workload size: semantically false.
- Hiding project-specific aggregation inside a universal producer: erases domain meaning.
- Rejecting every published repository with unrelated local churn: confuses the worktree with exact-head publication evidence.
- Ignoring dirty files: loses an important warning signal.

## Active Work: ALPR Semantic Repair

Repository: `alpr-mercosul` (#5).

Problem: inspect `benchmarks/publication/*-v2.json`; the current workload claims `measured_iterations=1` although the benchmark evaluates 100 plates.

Required outcome:

1. Map V1 input fields and the actual 100-plate loop before editing.
2. Regenerate V2 evidence with `--measured-iterations 100` or a single truthful count field.
3. Confirm units, sample semantics, aggregation, source commit, clean tree, image digest, and README number.
4. Run the local project validator and Docker benchmark.
5. Commit, push, require exact-head CI, and refresh central publication evidence only if publication gates are met.
6. Record whether any generic kit improvement remains. Do not add ALPR-specific code to the kit.

## Exact Restart Commands

From `portfolio-reuse-kit`:

```powershell
git status --short --branch
Get-Content .portfolio-control\TRACKER.json
.\tools\validate-kit.ps1
.\tools\validate-portfolio.ps1 -RepoRoot "$HOME\Desktop\repos-github" -Strict
```

From `alpr-mercosul`:

```powershell
git status --short --branch
Get-Content project.yaml
Get-ChildItem benchmarks\publication,benchmarks\results -File
rg -n "measured_iterations|repeat|100|plate" benchmarks tools src tests README.md sdd openspec
```

Do not run a write command until the ALPR input loop and current dirty state are understood.

## Architecture And Reuse Invariants

- Choose architecture from problem forces, not stack preference.
- Domain and application policy do not import transport, framework, ORM, broker, cloud SDK, or UI concerns.
- Ports own contracts; adapters depend inward and preserve failures, satisfying DIP and LSP.
- Use SRP, OCP, ISP, KISS, YAGNI, DRY, Law of Demeter, and testability as reviewable boundaries, not slogans.
- Docker is the default local execution boundary. Kumo is used only for AWS-like behavior and remains swappable with guarded real-cloud adapters.
- REST, GraphQL, gRPC, Kafka, RabbitMQ, databases, and frameworks require a problem-specific reason plus evidence.
- Improve the kit only for repeated, low-risk, project-independent behavior. Keep business logic and domain aggregation in projects.

## Tools, Skills, And Fallbacks

- Active communication skill: `i-have-adhd`.
- Skill authoring guidance used: `skill-creator`.
- Publication skill installed in kit for Codex and Claude: `publish-benchmark-evidence`.
- `ctx` and `trk` were unavailable; `.portfolio-control/TRACKER.json` is the authoritative fallback.
- `apply_patch` repeatedly failed across the Windows split-root sandbox. Use one reviewed patch path or an isolated clean worktree after the first failure; do not retry unchanged commands.

## Local Safety Notes

- Preserve unrelated user/generated changes.
- `rag-knowledge-base` has two known dirty benchmark JSON files; do not revert or publish them without a semantic review.
- Temporary clean worktree `kit-edit-20260802` can be removed only after checking it is clean and its resolved path is the intended workspace path.
- GitHub credentials are environment-only. Token values pasted in conversation must be revoked and rotated; never write them to files, remotes, commands, logs, or handoffs.

## Limit And Efficiency State

- Current report excluding 2026-07-20: 58 event records, 112 occurrences, 8 hard-limit occurrences, 16 wait-timeout occurrences, 94 avoidable occurrences, and 3,386.95 tracked seconds.
- No new weekly, authorization, or account limit was observed in this cycle.
- Exact account quota is not observable, so do not invent a count.
- Failures and avoidable retries are recorded in `.portfolio-control/EXECUTION_EVENTS.jsonl`.
- The PowerShell literal-newline mistake recurred once during #13 metadata editing and was corrected before commit; use `[Environment]::NewLine` or structured serializers.
- Checkpoint after each local gate, commit, push, and exact-head CI result.

## Completion Rule

The active defect family closes only when ALPR evidence is semantically truthful and all affected generic producer tests remain green. Then move the active project to #21 `mlops-end2end` and retain #24 and #1 behind it.
