# Portfolio Evidence Register

## Current Audit

- Current exact-head publication checkpoint: 2026-08-17.
- Repositories: 30.
- Docker definitions: 30.
- CI workflows: 30.
- Tracked benchmark contracts: 30.
- Original repositories with durable successful publication records: 25/30.
- Central publication records: 26, including the reuse kit.
- Current Desktop clones matching their publication records exactly: 8/30.
- Live local status is a synchronization audit, not permission to erase durable successful CI evidence; refresh stale records when those repositories become active.

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

## Project #23

- Repository: `Brilhante29/feature-store-lite`.
- Source evidence commit: `10641d32af027761aec62c23b0586b3c1a10992f`.
- Final published head: `6f8c957807a122d189fe8021c80cfd3e2639e329`.
- Exact-head CI: `https://github.com/Brilhante29/feature-store-lite/actions/runs/31991401685`.
- Result: p95 median `45.645578341645894 ms`; throughput median `1061.9468119765338 entity values/s`; three same-image repetitions.
- Correctness: historical and online match `1.0`; future leaks, TTL violations, and failures `0`.
- Provenance: image `sha256:cf84e303a901636d32baf1900565425f261664a2ce0575267a4daf8b334224bc`; wheel `sha256:eae158ceb9e9b1edbb02713025a4ca255ff776f7179b3ad5ac0be35d5efba5a9`.
- Contract: consumes `validated-batch-manifest-v1` with schema, contract, digest, reconciliation, status, and path-confinement checks.
- Limit: local in-process Feast SDK with SQLite; not Redis, network-serving, or cloud latency.

## Project #22

- Repository: `Brilhante29/model-drift-detector`.
- Source evidence commit: `12534946a5a6cb35e10260702d3765bc86b1931a`.
- Final published head: `13a18d57657ac8c04e17c25adda98ff855b126a8`.
- Exact-head CI: `https://github.com/Brilhante29/model-drift-detector/actions/runs/31994181644`.
- Result: alarm F1 `1.0`; precision `1.0`; recall `1.0`; FPR `0.0`; median p95 `35.477515344973654 ms`; zero failures.
- Provenance: image `sha256:fe60560a0d32b9cb6319cc7de7783b13c0caa93f24b33b95fdd143a8593251ac`; wheel `sha256:448368c4cea6a39597e8e97111865c5d6712c62c5a5359e746f65e685ae96e77`.
- Contract: fail-closed validated input plus producer, dataset, contract, model artifact, time-order, payload, and feature-schema compatibility.
- Limit: univariate KS intentionally misses correlation-only multivariate drift; no labeled model-performance claim.

## Reuse Kit

- Previous proven implementation head: `2d92dcc31ddca0eeb2c81ab83f2fb3dd9da07879`.
- Previous exact-head CI: `https://github.com/Brilhante29/portfolio-reuse-kit/actions/runs/31773886720`.
- Shared MLOps assets now include the validated-batch contract, effective workload rules, and mirrored `python-feature-store` skill.
- Shared skill: `publish-benchmark-evidence` for Codex and Claude.
- Published improvement: canonical Git-blob digests for tracked provenance inputs.

## Learned Reuse

- Keep V1 execution output and V2 publication provenance separate.
- Repetition count never substitutes for measured workload size.
- Read tracked fixture, config, and lock bytes from the source commit; checkout EOL conversion must not change provenance.
- Fetch the source commit in CI and reject provenance before expensive builds.
- Validate schema and semantics: units, workload, samples, aggregation, provider identity, clean source, image digest, and exact-head CI.
- Keep domain-specific multi-run aggregation in the project until a second implementation proves a stable reusable abstraction.

Full command output remains in CI and project artifacts. Credential values and private reasoning are intentionally excluded.

## Project #24

- Repository: `Brilhante29/ci-cd-templates`.
- Source evidence commit: `8bfd94a1a8fd6186b717bc7be53d61e92d419b2d`.
- Final published head: `bc591185eeb3ec73ff550fa6b1fdf4d41885a55e`.
- Exact-head CI: `https://github.com/Brilhante29/ci-cd-templates/actions/runs/32001541506`.
- Result: median `104.945 ms`; samples `104.945`, `103.531`, `152.502 ms`; all seven unsafe fixture findings; zero template findings.
- Profiles: Python `3.12.13`, Go `1.26.0`, Node `24.13.0`, Java `21` with Gradle `9.3.1`, and Terraform `1.14.8`.
- Provenance: image `sha256:c075a917595faf3e84c5189306eb59c422e051cabaefbc6ea7f75b46d58ae70f`; V1 artifact `sha256:570d8173cb6c7d901df3a15d4a3229ba1e7451066de1c349a797fba817c24985`.
- Limit: the benchmark measures deterministic static guardrails; GitHub Actions proves profile execution but does not compare arbitrary consumer build duration.

## Project #25

- Repository: `Brilhante29/observability-stack`.
- Source evidence commit: `2b289f4554d5f976f45d0126816d93490811f34d`.
- Final published head: `d332fe943da5a02cdaf75d43c8a648d952997265`.
- Exact-head CI: `https://github.com/Brilhante29/observability-stack/actions/runs/32446714093`.
- Result: recovery median `0.1336 s`; detection median `0.0712 s`; correlation `1.0` across metrics, traces, and logs in `3/3` runs.
- Full runtime: Prometheus target `up`, trace retrieved from Tempo, three lifecycle events retrieved from Loki, and Grafana datasources/dashboard provisioned.
- Provenance: image `sha256:a28b8b6e2f27aa4ed1d06c905bf59dc1448704b834c68bfffe590fd1c52b25a6`.
- Limit: local controlled-incident instrumentation integrity; not production MTTR, retention, HA, or distributed ingest scale.
