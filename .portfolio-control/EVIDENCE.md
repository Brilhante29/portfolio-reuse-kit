# Portfolio Evidence Register

## Current Audit

- Strict local audit: passed on 2026-08-02.
- Repositories: 30.
- Docker definitions: 30.
- CI workflows: 30.
- Tracked benchmark contracts: 30.
- V2 publication artifacts: 4.
- Published and centrally verified: 3.
- Declared published without verification: 0.

## Project #3

- Repository: `Brilhante29/rag-knowledge-base`.
- Published head: `0cb9c6cc7d7ceb2b6e57c116403531de61ace02d`.
- Exact-head CI: `https://github.com/Brilhante29/rag-knowledge-base/actions/runs/30638261570`.
- Result: Recall@3 `1.00`, average `0.3175 ms`, p95 `0.4523 ms`, zero measured API cost.
- Local caveat: two timestamp-only dirty benchmark files are preserved and excluded from committed-head publication truth.

## Project #11

- Repository: `Brilhante29/spring-hexagonal-payments`.
- Published head: `71925cf204f6aa62238edad28a11822a2db41106`.
- Exact-head CI: `https://github.com/Brilhante29/spring-hexagonal-payments/actions/runs/30638268558`.
- Result: median p99 `108.122 ms`, mean `734.4 req/s`, minimum core coverage `95.65%`, zero HTTP failures.
- Stack: Kotlin 2.4.10, Gradle 9.3, Spring Boot 4.1, JDBC, Flyway, PostgreSQL 18.4, k6 2.1.

## Project #13

- Repository: `Brilhante29/mini-aws-emulator`.
- Published status: verified.
- Benchmark source head: `33387dbf8c31206bcc5fed4ed8ae8533d27c8fb8`.
- Source CI: `https://github.com/Brilhante29/mini-aws-emulator/actions/runs/30772714926`.
- Final published head: `8d3a4f7813b16bb61f9fbbfea19e7e6b41a5abbb`.
- Final exact-head CI: `https://github.com/Brilhante29/mini-aws-emulator/actions/runs/30774984792`.
- Result: 100 percent scoped conformance, median p95 `1.704 ms`, mean `764.682 ops/s`, 81.2 percent core coverage, zero failed operations.
- Kumo digest: `sha256:7ea090ae0b6d1d34615e8b7bd04a2f1cd864ec640a6826a91e90f40e975e196b`.
- Limit: local Kumo latency is not an AWS production performance claim.

## Reuse Kit

- Generic truthful producer: commit `6f557a0`.
- Committed-head publication validation: commit `16a3622`.
- Exact-head CI: `https://github.com/Brilhante29/portfolio-reuse-kit/actions/runs/30774849915`.
- Tests: seven Python unit tests plus the PowerShell published-head regression.
- Shared skill: `publish-benchmark-evidence` for Codex and Claude.

## Learned Reuse

- Keep V1 execution output and V2 publication provenance separate.
- Repetition count never substitutes for measured workload size.
- Validate schema and semantic fields: units, workload, samples, aggregation, provider identity, clean source, image digest, and exact-head CI.
- Read published truth from committed Git `HEAD`; report local dirty files independently.
- Keep domain-specific aggregation in the project until a second implementation proves a stable reusable abstraction.

Full command output remains in CI and project artifacts. Credential values and private reasoning are intentionally excluded.
