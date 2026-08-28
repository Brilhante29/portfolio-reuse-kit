# Portfolio Evidence Register

## Current Audit

- Current exact-head publication checkpoint: 2026-08-21.
- Repositories: 30.
- Docker definitions: 30.
- CI workflows: 30.
- Tracked benchmark contracts: 30.
- Original repositories with durable successful publication records: 30/30.
- Central original-repository publication records: 30/30.
- Current Desktop clones matching their publication records exactly: 30/30.
- All current Desktop checkouts are clean. The prior dirty
  `multi-tenant-starter` state is preserved on a local WIP branch instead of
  being discarded.

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

## Project #27

- Repository: `Brilhante29/terraform-aws-baseline`.
- Source evidence commit: `bd51cd134a4b1c2742bbacfe833bbc4dda9a2db5`.
- Final published head: `32fb845ccb31e1c235f724aa1388b0ee9360fd24`.
- Exact-head CI: `https://github.com/Brilhante29/terraform-aws-baseline/actions/runs/32449453935`.
- Result: apply median `11.2674 s`; destroy median `14.2319 s`; resource parity `1.0` across `3/3` measured runs after one warmup.
- Runtime: Terraform `1.15.8`, AWS provider `5.100.0`, Kumo `0.28.1`, Python `3.12.14`.
- Lifecycle: four resources after every apply and empty state after every destroy; no AWS credential required.
- Provenance image: `sha256:198b11d02a761401632a8c2d20dd51ada744763dc7310628b82999d744ae2725`.
- Limit: local Kumo timing is not AWS latency, cost, IAM, durability, quota, or full conformance evidence.

## Project #29

- Repository: `Brilhante29/load-test-suite`.
- Source evidence commit: `3146602070006665950e42aeddc5aca19a8670db`.
- Final published head: `b2e976f7153b9746bd7a41727cd03c8e788c20d3`.
- Exact-head CI: `https://github.com/Brilhante29/load-test-suite/actions/runs/32451206733`.
- Result: median p95 `15.14099235 ms` at 20 VUs; samples `14.9140293`, `15.14099235`, and `15.2416762 ms`.
- Curve: p95 medians `3.3461`, `5.0537`, `8.9508`, and `15.1410 ms` at 1, 5, 10, and 20 VUs.
- Throughput: plateaus near `1,453 req/s`; 41,234 total requests; zero failures.
- Provenance image: `sha256:64f9c11c4de6a65cde252ccbb959091dd9b55e089e8c2499c070e14912af34f6`.
- Runtime: Go `1.26.6`, k6 `2.1.0`, Docker; current Actions pinned by SHA.
- Limit: controlled local bounded-worker target; not distributed-load or cloud-capacity evidence.

## Original Portfolio Closure

- Durable successful publication records: 30/30.
- All five macro systems complete.
- Contract set `1.9.0` promotes reusable multi-run k6 evidence without moving target-specific code into the kit.

## Checkout Alignment

- Strict verified-publication audit: 30/30.
- `cache-strategies-bench` corrected final head:
  `251f0f4d3b9a9cace77683014f45a26be9229d11`.
- Exact-head CI:
  `https://github.com/Brilhante29/cache-strategies-bench/actions/runs/32481590754`.
- `multi-tenant-starter` pre-alignment state preserved locally on
  `wip/preserved-before-main-alignment-20260821` at `0415b691`.

## Extension #31

- Repository: `Brilhante29/portfolio-evidence-api`.
- Published head: `88fa375de0abe7e4a93d427928016f6d4b0b8bfa`.
- Exact-head CI:
  `https://github.com/Brilhante29/portfolio-evidence-api/actions/runs/33205651604`.
- Historical V2 result: ingestion p95 `40.201 ms`, throughput `438.148
  requests/second`, GraphQL p95 `24.119 ms`, zero failures.
- Verification: 35 tests; 93.05% statements/lines, 89.4% branches, 100%
  functions; dependency advisory gate, project validator, Docker build, health
  smoke, and Docker calibration passed in CI.
- Security repair: patched direct and transitive lockfile versions, fail-closed
  Bulk Advisory client, and checkout/setup-node actions pinned to valid full
  SHAs; final CI has no action-runtime warning.
- Checkout and publication record: canonical Desktop clone is clean and
  aligned; `.portfolio-control/publications/portfolio-evidence-api.json` stores
  the durable proof.
- Reuse delta: literal-path validation is patched in the project template and
  kit; the remote-proven Node advisory transport is available under
  `harness/node/` with deterministic tests.
