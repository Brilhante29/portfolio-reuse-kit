# Current Handoff

Updated: 2026-08-14
Purpose: observable continuation state; no private chain-of-thought.

## Continuation Order

1. Read this file, `TRACKER.json`, `PROJECT_QUEUE.md`, and the active program document.
2. Verify final `main` SHA and exact-head CI before changing a completed repository.
3. Keep one macro active and apply only reuse improvements observed in multiple repositories.

## Current Truth

The Backend Reliability and Architecture Platform is complete at 10/10 repositories. Every row points to the current public `main` SHA and a successful exact-head GitHub Actions run:

| # | Repository | `main` head | CI run |
|---:|---|---|---:|
| 11 | `spring-hexagonal-payments` | `b85f563` | `31359207611` |
| 12 | `go-rate-limiter` | `2a40e08` | `31770932954` |
| 13 | `mini-aws-emulator` | `63927c0` | `31770435198` |
| 14 | `event-sourcing-orders` | `ddf17f0` | `31359210209` |
| 15 | `grpc-vs-rest-bench` | `5a96e7e` | `31770456018` |
| 16 | `saga-orchestrator` | `f213c00` | `31359213207` |
| 17 | `multi-tenant-starter` | `ca91f35` | `31770435136` |
| 18 | `api-gateway-lite` | `812fdfe` | `31770456130` |
| 19 | `cache-strategies-bench` | `bfddb67` | `31359781335` |
| 20 | `outbox-pattern` | `02f7a81` | `31359222289` |

Completed macros: AI Evaluation and Retrieval Systems 6/6, Applied Computer Vision and Medical AI 4/4, and Backend Reliability and Architecture Platform 10/10. Across the original 30 repositories, 22/30 are publication-complete: those 20 plus `#21 mlops-end2end` and `#28 kafka-streams-demo`. MLOps and Data Platform is 2/6.

## Decisions

- Treat the five repositories as one commerce reliability system with private database boundaries.
- Preserve idempotency keys across synchronous retries and `eventId`/correlation across asynchronous retries.
- Name PostgreSQL, Redis, or Kafka in a claim only when that infrastructure participates in the measured path.
- Separate committed benchmark evidence from variable CI smoke evidence.
- Claim at-least-once delivery plus idempotent consumers; do not claim exactly-once external effects.
- Run Linux benchmark-writer containers with the host UID/GID when writing bind-mounted CI evidence; archive smoke evidence without changing the canonical benchmark.

## Exact Next Action

Complete MLOps and Data Platform. Preserve published `#21` and `#28`, then audit `#4`, `#22`, `#23`, and `#26` as one data lifecycle: clinical training evidence, data quality, feature serving, drift detection, and event streaming. Start with `#26 data-quality-checks`, because its data contract is an input to the other three pending repositories.
