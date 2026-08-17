# Current Handoff

Updated: 2026-08-17
Purpose: observable continuation state; no private chain-of-thought.

## Continuation Order

1. Read this file, `TRACKER.json`, `PROJECT_QUEUE.md`, and `docs/mlops-data-platform.md`.
2. Verify the target repository's remote `main`, current evidence, Docker path, and exact-head CI before editing.
3. Keep only #4 active; the #22 monitoring-contract and skill improvements are already promoted into the kit.

## Current Truth

Completed macros: AI Evaluation and Retrieval Systems 6/6, Applied Computer Vision and Medical AI 4/4, and Backend Reliability and Architecture Platform 10/10.

Across the original 30 repositories, **25/30** have durable successful publication records. The current Desktop clone audit matches 8/30 records exactly; other clones require synchronization or renewed exact-head evidence before they can be called current. MLOps and Data Platform is **5/6**:

| # | Repository | `main` head | Exact-head CI | State |
|---:|---|---|---:|---|
| 21 | `mlops-end2end` | `fb77827` | `30781190229` | Published |
| 23 | `feature-store-lite` | `6f8c957` | `31991401685` | Published |
| 26 | `data-quality-checks` | `8d6dd21` | `31773506491` | Published |
| 28 | `kafka-streams-demo` | current verified `main` | `31402256249` | Published |
| 22 | `model-drift-detector` | `13a18d5` | `31994181644` | Published |
| 4 | `stroke-signal-demo` | verify before editing | pending | Active next |

## #22 Evidence

- Canonical alarm F1 `1.0`, FPR `0.0`, median p95 `35.477515344973654 ms`, and blind-spot detection `0.0` across three 2,000-row runs.
- Source `12534946`; image `sha256:fe60560a0d32b9cb6319cc7de7783b13c0caa93f24b33b95fdd143a8593251ac`; wheel `sha256:448368c4cea6a39597e8e97111865c5d6712c62c5a5359e746f65e685ae96e77`.
- 48 tests, 91.22% coverage, exact non-root Docker command, strict V2 provenance, and exact-head CI passed.
- Cross-repository boundary: consumes a successful `validated-batch-manifest-v1` and preserves producer, dataset, contract, model artifact, time, payload, and feature-schema identity.
- Generic improvement: hardened monitoring-batch v1, mirrored `python-model-monitoring` skill, and MLOps pack/validator gates.

## Exact Next Action

Audit and close `#4 stroke-signal-demo`. Preserve patient/split/model identity, prevent train-test leakage, reproduce the paper claim with a held-out confusion matrix, publish accuracy plus clinically relevant sensitivity/specificity, and require three-run V2 evidence with exact-head CI. Keep the implementation local-first and do not claim clinical deployment.
