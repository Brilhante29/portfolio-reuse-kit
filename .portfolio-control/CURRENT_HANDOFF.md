# Current Handoff

Updated: 2026-08-02
Owner: principal agent
Purpose: observable state for Codex, Claude Code, another AI, or a human. No private chain-of-thought is stored.

## Continuation Order

1. Read `docs/agent-continuation-map.md`.
2. Read `.portfolio-control/TRACKER.json` and `PROJECT_QUEUE.md`.
3. Inspect Git status and the target SDD before editing.
4. Execute one critical-path change, validate it, and refresh this handoff.

## Current Truth

| Scope | State | Evidence |
|---|---|---|
| Portfolio | 30 repositories | 30 Docker, 30 CI, 30 tracked benchmarks |
| Published | #3, #5, #11, #13 | exact-head CI and central publication JSON |
| Reuse kit | last green head `fffdca4` | run `30775452256` |
| Active | #21 `mlops-end2end` at clean head `ae7d1e0` | one committed lifecycle run |
| Blocking defects | framework proof and repetition | direct stage calls; one run where SDD requires three |

## Closed: #5 alpr-mercosul

- Final head `b69ae1d1c3ada4c6aa94b30e51b4404aa89e0a11`; exact-head CI `30778498303`, all steps passed.
- Result: 100/100 synthetic plates, 700/700 characters, image-only prediction, zero failures.
- V2: `repeat=1`, `measured_iterations=100`, source `b23be43`, image `sha256:399b8ba8e00b4855fb0d7605682899a7b02345b3e31237a7755aa97f8f748e37`.
- Limit: synthetic fixed-layout OCR only; no vehicle detection, localization, real-road, or production claim.

## Active: #21 mlops-end2end

Existing strengths: Airflow 3.3, MLflow 3.14, FastAPI, Pandera, scikit-learn, Prometheus, Docker; framework-independent quality policy; registry port; alias-backed serving.

Current result: one run at `371.941 s`, ROC AUC `0.928441`, inference p95 `285.557 ms`, zero failures.

Publication blockers:

1. `runner.py` invokes `python -m dags.mlops_end2end`; `__main__` calls stages directly. This does not prove Airflow task execution.
2. The benchmark plan requires a three-run median with one image; only one V1 result exists and no V2 artifact is tracked.

Smallest valid change:

1. Execute `airflow dags test mlops_end2end <logical-date>` after metadata migration.
2. Add a focused regression and align benchmark wording.
3. Build one clean source image; retain three clean runs plus failures; aggregate median/min/max/range; generate V2.
4. Validate, push, inspect exact-head CI, publish, and refresh central evidence.

## Safety

- Keep domain aggregation local; reuse only generic producer and claim-verification guidance.
- Do not add Kafka, RabbitMQ, cloud, GraphQL, Kubernetes, or microservices without a measured force.
- Kumo applies only when AWS behavior enters scope.
- Preserve two known timestamp-only dirty files in `rag-knowledge-base`.
- Never store credentials or private reasoning. Rotate tokens pasted in conversation.

## Exact Next Commands

```powershell
cd $HOME\Desktop\repos-github\mlops-end2end
git status --short --branch
rg -n "python.*dags|airflow dags test|three|median" src tests dags sdd README.md
docker image inspect mlops-end2end
```
