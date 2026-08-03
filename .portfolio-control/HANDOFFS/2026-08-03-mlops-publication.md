# MLOps End-to-End Publication

Date: 2026-08-03
Repository: `Brilhante29/mlops-end2end`
Status: published and centrally verified

## Immutable Evidence

- Source commit: `9e8c76d02a2a7f10c8ccee7049cd21fc47b9db12`
- Evidence commit: `02496591bfc3dbaa604099b9da33c0106d993db6`
- Final metadata head: `fb778279f4462f7f478dc34da87c5d2559d4fd5a`
- Evidence CI: `30780951251`
- Final exact-head CI: `30781190229`
- Source image: `sha256:5228391a3b888a26c0fa5263d5a2393694ee6f862a80e48d7839ad22a2fb541f`

## Result

- Lifecycle duration samples: `57.373 s`, `59.140 s`, `58.696 s`
- Median lifecycle: `58.696 s`
- Median ROC AUC: `0.928`
- Accuracy: `0.87`
- Inference p95: `72.733 ms`
- Throughput: `160.275 req/s`
- Failures: `0`

## Decisions

- Airflow proof executes `airflow dags test`; direct stage calls are not accepted as orchestration evidence.
- MLflow uses direct local SQLite tracking and registry instead of a redundant localhost HTTP server.
- The project keeps its three-run, multi-metric aggregation; the kit owns the common V2 contract.
- Tracked fixture/config/lock provenance comes from canonical source-commit Git blobs.
- CI runs provenance checks before expensive Docker work and fetches source history.

## Limit

This is a deterministic local-first lifecycle benchmark. It does not claim cloud production throughput or distributed Airflow/MLflow behavior.

## Next

Audit and publish #24 `ci-cd-templates`.