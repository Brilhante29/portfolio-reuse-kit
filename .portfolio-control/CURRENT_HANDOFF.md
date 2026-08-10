# Current Handoff

Updated: 2026-08-10
Owner: principal agent
Purpose: observable continuation state for Codex, Claude Code, another AI, or a human. No private chain-of-thought is stored.

## Continuation Order

1. Read this file, `.portfolio-control/TRACKER.json` and `.portfolio-control/PROJECT_QUEUE.md`.
2. Verify the current kit branch and exact-head GitHub Actions before selecting new work.
3. Read the selected program, project manifest, SDD, benchmark evidence and reuse review.
4. Keep one active macro and update the observable handoff after each publication milestone.

## Current Truth

Applied Computer Vision and Medical AI is closed as four coherent repositories:

| # | Repository | Published head | Exact-head CI | Measured proof |
|---:|---|---|---|---|
| 1 | `yolo-training-pipeline` | `14ecde1` | `31341854246` | median held-out mAP50-95 `0.002420`; warmed p95 `68.303 ms/image`; 3 runs |
| 5 | `alpr-mercosul` | `fcacf0c` | `31341450011` | character accuracy `1.000000`; 700 chars / 100 synthetic plates |
| 6 | `melanoma-classifier` | `890e3f1` | `31341853463` | DermaMNIST test AUC `0.736999`; sensitivity `0.762332`; 2,005 images |
| 7 | `vision-serving-fastapi` | `2966a47` | `31341853937` | real YOLO HTTP `39.200 req/s`; p95 `27.343 ms`; 20/20 successes |

Repository #4 `stroke-signal-demo` belongs to `mlops-data-platform`, not this vision program.

## System Story

`#1` produces a manifest-bound checkpoint. `#7` verifies its bytes and SHA-256 before real Ultralytics inference. `#5` proves label-independent image OCR under a narrow synthetic workload. `#6` proves real-dataset medical evaluation with official splits and validation-only threshold selection.

## Reuse Delta

- Added `python-computer-vision` and `medical-ai-evaluation` skills for Codex and Claude.
- New scaffolds receive the V2 producer, semantic validator, publication spec and validation lock automatically.
- Portfolio validation accepts canonical V2 `benchmark.result_path` while retaining legacy V1 compatibility.
- Medical rules now require source/license/checksum/splits, validation-only thresholds and explicit non-clinical scope.
- Model consumers must verify manifest schema, bytes and SHA-256 before framework load.

## Safety

- Never store credentials, private reasoning or machine-specific absolute paths in project evidence.
- Do not describe synthetic ALPR or YOLO metrics as real-domain accuracy.
- Do not describe the melanoma baseline as clinical safety or diagnosis.
- Keep cloud, broker, database and model registry out unless their behavior is the measured claim; use Kumo behind ports for AWS-like local behavior.

## Exact Next Action

After the reuse-kit branch passes exact-head CI, select and close the next macro as a bounded set. Do not reopen these four repositories unless their CI regresses or a new workload version is approved.
