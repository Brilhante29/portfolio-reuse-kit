# Current Handoff

Updated: 2026-08-17
Purpose: observable continuation state; no private chain-of-thought.

## Continuation Order

1. Read this file, `TRACKER.json`, `PROJECT_QUEUE.md`, and `docs/mlops-data-platform.md`.
2. Verify the target repository's remote `main`, current evidence, Docker path, and exact-head CI before editing.
3. Keep only #22 active; add a kit improvement only when the repository exposes a generic gap.

## Current Truth

Completed macros: AI Evaluation and Retrieval Systems 6/6, Applied Computer Vision and Medical AI 4/4, and Backend Reliability and Architecture Platform 10/10.

Across the original 30 repositories, **24/30** are publication-complete. MLOps and Data Platform is **4/6**:

| # | Repository | `main` head | Exact-head CI | State |
|---:|---|---|---:|---|
| 21 | `mlops-end2end` | `fb77827` | `30781190229` | Published |
| 23 | `feature-store-lite` | `6f8c957` | `31991401685` | Published |
| 26 | `data-quality-checks` | `8d6dd21` | `31773506491` | Published |
| 28 | `kafka-streams-demo` | current verified `main` | `31402256249` | Published |
| 22 | `model-drift-detector` | verify before editing | pending | Active next |
| 4 | `stroke-signal-demo` | verify before editing | pending | After #22 |

## #23 Evidence

- Canonical p95: `45.645578341645894 ms`; median throughput: `1061.9468119765338 entity values/s`.
- Historical and online value match: `1.0`; future leaks and TTL violations: `0`.
- Docker: Python 3.12.13, Feast 0.64.0, Pandas 2.3.3, PyArrow 25.0.0, Parquet, SQLite, Jsonschema 4.26.0.
- Cross-repository boundary: consumes `validated-batch-manifest-v1` fail closed; no source imports from #26.
- Generic improvement: mirrored `python-feature-store` skill and MLOps pack/validator gates.

## Exact Next Action

Audit `#22 model-drift-detector`. Preserve model, feature, reference-window, and current-window identity; reject thresholds selected from the evaluation batch; consume a versioned validated input contract; publish a three-repetition V2 drift report and exact-head CI. Do not add Evidently, Prometheus, an API, broker, or cloud unless each participates in the measured claim.
