# Decision Brain

This repository is the decision brain for the portfolio.

It does not only scaffold files. It decides, records, and standardizes the engineering choices that every generated repository must follow: program, public proficiency signal, architecture, stack, messaging, database, runtime, libraries, design system, benchmark, and release evidence.

## What This Solves

Without a decision brain, agents tend to make isolated choices:

- Spring because the project says backend
- FastAPI because the project says Python
- Go because the project says performance
- Kafka because events sound impressive
- RabbitMQ because queues sound useful
- random libraries because they are familiar

That is not enough for a serious portfolio. Every choice must prove something.

## Mandatory Decision Flow

```txt
portfolio program
  -> proficiency signal
  -> architecture
  -> concrete stack profile
  -> messaging mode
  -> database/runtime/library policy
  -> benchmark
  -> README/post evidence
```

## Backend Stack Rules

| Problem | Default Stack | Why |
|---|---|---|
| Transactional enterprise domain, consistency, payments, outbox, saga | Spring Kotlin backend | Shows enterprise backend skill, architecture boundaries, transactions, Testcontainers, observability. |
| Python API around ML, RAG, CV, evaluation, data | FastAPI backend | Shows typed Python API, OpenAPI, ASGI, Pydantic, async I/O where useful, ML/data integration. |
| Gateway, rate limiter, emulator, protocol benchmark, low overhead service | Go backend | Shows concurrency, low overhead, networking, pprof, allocations, and direct performance evidence. |
| Enterprise admin/dashboard UI | Angular | Shows typed forms, guards, services/facades, modular UI architecture. |
| Public demo/product UI | Next.js | Shows React, routing, rendering tradeoffs, polished shareable demo. |

## Messaging Rules

| Need | Choice |
|---|---|
| No async semantics needed | No broker |
| Atomic persistence plus later publish | Transactional outbox |
| Jobs, routing, retry, DLQ, per-message ack | RabbitMQ |
| Event log, replay, partitions, stream processing, CQRS projections | Kafka/Redpanda |
| Lightweight stream where Redis is already present | Redis Streams |
| Lightweight pub/sub or request/reply | NATS |

## Library Rules

1. Prefer standard library or framework built-ins.
2. Prefer official framework libraries when integration matters.
3. Use mature ecosystem libraries for common production concerns.
4. Use specialized libraries only when the benchmark or claim requires them.
5. Reject dependencies that hide the concept the repo is supposed to prove.

## Required Evidence

Every non-trivial project must include:

- `project.yaml` with `decision_brain`
- `sdd/technical-decision.md`
- rejected alternatives
- Docker default path
- benchmark result JSON
- README result table

## Source Basis

The decision brain is based on primary documentation and benchmark-aware reasoning:

- Spring Framework Kotlin support and WebFlux guidance
- Spring Boot Actuator and Testcontainers documentation
- FastAPI, Pydantic, SQLAlchemy asyncio, and Uvicorn documentation
- Go official documentation for idiomatic code, tests, diagnostics, and pprof
- chi, Gin, pgx, and Redis Go client project documentation
- Apache Kafka and RabbitMQ official documentation
- TechEmpower-style benchmark thinking: measure the exact workload instead of assuming framework speed
