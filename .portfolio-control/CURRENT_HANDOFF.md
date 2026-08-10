# Current Handoff

Updated: 2026-08-10
Purpose: observable continuation state; no private chain-of-thought.

## Continuation Order

1. Read this file, `TRACKER.json`, `PROJECT_QUEUE.md`, and the active program document.
2. Verify final `main` SHA and exact-head CI before changing a completed repository.
3. Keep one macro active and apply only reuse improvements observed in multiple repositories.

## Current Truth

The Backend Reliability Platform transactional core is complete:

| # | Repository | `main` head | CI run |
|---:|---|---|---:|
| 11 | `spring-hexagonal-payments` | `b85f563` | `31359207611` |
| 14 | `event-sourcing-orders` | `ddf17f0` | `31359210209` |
| 16 | `saga-orchestrator` | `f213c00` | `31359213207` |
| 19 | `cache-strategies-bench` | `bfddb67` | `31359781335` |
| 20 | `outbox-pattern` | `02f7a81` | `31359222289` |

AI Evaluation and Retrieval Systems remains complete at 6/6 repositories with exact-head CI.

## Decisions

- Treat the five repositories as one commerce reliability system with private database boundaries.
- Preserve idempotency keys across synchronous retries and `eventId`/correlation across asynchronous retries.
- Name PostgreSQL, Redis, or Kafka in a claim only when that infrastructure participates in the measured path.
- Separate committed benchmark evidence from variable CI smoke evidence.
- Claim at-least-once delivery plus idempotent consumers; do not claim exactly-once external effects.

## Exact Next Action

Publish this kit branch to `main` and require exact-head CI green. Then start the bounded Backend Traffic and Platform Edge slice (`#12`, `#13`, `#15`, `#17`, `#18`) without reopening the completed transactional core unless CI regresses.
