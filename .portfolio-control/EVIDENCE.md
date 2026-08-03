# Portfolio Evidence Register

## Current Audit

- Strict local audit target date: 2026-08-03.
- Repositories: 30.
- Docker definitions: 30.
- CI workflows: 30.
- Tracked benchmark contracts: 30.
- V2 publication artifacts: 5.
- Published and centrally verified: 5.
- Declared published without verification: 0.

## Project #3

- Repository: `Brilhante29/rag-knowledge-base`.
- Published head: `0cb9c6cc7d7ceb2b6e57c116403531de61ace02d`.
- Exact-head CI: `https://github.com/Brilhante29/rag-knowledge-base/actions/runs/30638261570`.
- Result: Recall@3 `1.00`, average `0.3175 ms`, p95 `0.4523 ms`, zero measured API cost.
- Local caveat: two timestamp-only dirty benchmark files are preserved and excluded from committed-head publication truth.

## Project #5

- Repository: `Brilhante29/alpr-mercosul`.
- Final head: `b69ae1d1c3ada4c6aa94b30e51b4404aa89e0a11`; CI `30778498303`.
- Result: character accuracy `1.0`, plate accuracy `1.0`, 100 plates, 700 characters, zero failures.
- Provenance: source `b23be43`, evidence `f22c834`, image `sha256:399b8ba8e00b4855fb0d7605682899a7b02345b3e31237a7755aa97f8f748e37`.
- Semantic proof: `read_plate(image) -> str`; pixel mutation proves prediction follows image content.
- Limit: synthetic fixed-layout workload, not real-road or production ALPR.

## Project #11

- Repository: `Brilhante29/spring-hexagonal-payments`.
- Published head: `71925cf204f6aa62238edad28a11822a2db41106`.
- Exact-head CI: `https://github.com/Brilhante29/spring-hexagonal-payments/actions/runs/30638268558`.
- Result: median p99 `108.122 ms`, mean `734.4 req/s`, minimum core coverage `95.65%`, zero HTTP failures.
- Stack: Kotlin 2.4.10, Gradle 9.3, Spring Boot 4.1, JDBC, Flyway, PostgreSQL 18.4, k6 2.1.

## Project #13

- Repository: `Brilhante29/mini-aws-emulator`.
- Final published head: `8d3a4f7813b16bb61f9fbbfea19e7e6b41a5abbb`.
- Final exact-head CI: `https://github.com/Brilhante29/mini-aws-emulator/actions/runs/30774984792`.
- Result: 100 percent scoped conformance, median p95 `1.704 ms`, mean `764.682 ops/s`, 81.2 percent core coverage, zero failed operations.
- Kumo digest: `sha256:7ea090ae0b6d1d34615e8b7bd04a2f1cd864ec640a6826a91e90f40e975e196b`.
- Limit: local Kumo latency is not an AWS production performance claim.

## Project #21

- Repository: `Brilhante29/mlops-end2end`.
- Source head: `9e8c76d02a2a7f10c8ccee7049cd21fc47b9db12`.
- Final published head: `fb778279f4462f7f478dc34da87c5d2559d4fd5a`.
- Final exact-head CI: `https://github.com/Brilhante29/mlops-end2end/actions/runs/30781190229`.
- Result: lifecycle samples `57.373 s`, `59.140 s`, `58.696 s`; median `58.696 s`.
- Quality and serving: median ROC AUC `0.928`, accuracy `0.87`, inference p95 `72.733 ms`, throughput `160.275 req/s`, zero failures.
- Framework proof: Airflow `dags test`, MLflow SQLite registry and alias, FastAPI serving, Prometheus metrics.
- Image digest: `sha256:5228391a3b888a26c0fa5263d5a2393694ee6f862a80e48d7839ad22a2fb541f`.
- Limit: deterministic local-first lifecycle, not distributed-cloud throughput.

## Reuse Kit

- Last green head: `9049970b36c34bdc3eb0905934efc539100e84fd`.
- Exact-head CI: `https://github.com/Brilhante29/portfolio-reuse-kit/actions/runs/30779025633`.
- Tests: ten Python producer tests plus the PowerShell published-head regression.
- Shared skill: `publish-benchmark-evidence` for Codex and Claude.
- Current improvement pending publication: canonical Git-blob digests for tracked provenance inputs.

## Learned Reuse

- Keep V1 execution output and V2 publication provenance separate.
- Repetition count never substitutes for measured workload size.
- Read tracked fixture, config, and lock bytes from the source commit; checkout EOL conversion must not change provenance.
- Fetch the source commit in CI and reject provenance before expensive builds.
- Validate schema and semantics: units, workload, samples, aggregation, provider identity, clean source, image digest, and exact-head CI.
- Keep domain-specific multi-run aggregation in the project until a second implementation proves a stable reusable abstraction.

Full command output remains in CI and project artifacts. Credential values and private reasoning are intentionally excluded.