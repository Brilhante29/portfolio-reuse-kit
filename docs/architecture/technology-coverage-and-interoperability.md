# Technology Coverage and Interoperability

## Decision

The portfolio expands from 30 to 33 repositories only to close system-level gaps. New repositories are not technology showcases in isolation: they form the evidence plane that makes benchmark output from the existing programs comparable, queryable, and operable.

1. `portfolio-evidence-api`: authoritative ingestion, comparison, publication-readiness, and audit service.
2. `portfolio-evidence-console`: public Next.js experience for programs, projects, benchmarks, AI evaluation, and reproducibility.
3. `portfolio-operations-console`: Angular workspace for quarantine, revalidation, remediation, publication gates, and CI incidents.

The two frontends are separated by user and workflow, not by framework. The public console is read-oriented; the operations console owns audited commands.

## Contract Boundary

Every language emits the same vendored and digest-pinned `benchmark-result-v2` JSON contract. HTTP and schemas are the interoperability boundary; repositories do not depend on a shared runtime SDK.

- REST/OpenAPI accepts benchmark runs and audited commands.
- GraphQL serves flexible nested reads and comparisons.
- Golden valid and invalid fixtures run in Python, Go, Java/Kotlin, and TypeScript CI.
- V1 input is accepted only through an explicit migration adapter and is never automatically compared with V2.
- Each result records workload, environment, image, source commit, clean tree, lockfile, command, failures, and a comparability key.

## Evidence API

Architecture: modular monolith with hexagonal boundaries and explicit command/query separation, without a CQRS framework.

Boundaries: immutable evidence domain, ingestion and operational commands, read and comparison use cases, REST commands, GraphQL reads, schema validation, and SQLite persistence.

Stack: Node.js 24, TypeScript strict, NestJS 11, Fastify 5, REST commands, Mercurius GraphQL reads, Ajv, Kysely, SQLite local-first, Pino, Prometheus, Vitest, and Docker.

Kysely is selected over Prisma because controlled SQL and SQLite behavior are part of the evidence. NestJS, Fastify, GraphQL, Ajv, and Kysely stay outside the domain.

Default `docker run` uses SQLite and needs no secret, broker, cloud account, or second service. PostgreSQL is deferred until measured multi-writer pressure exists. Kumo becomes the first local provider only if artifact storage creates a real cloud boundary; AWS must remain behind the same future port.

Primary evidence: ingestion p95 `40.201 ms`, throughput `438.148 requests/second`, GraphQL query p95 `24.119 ms`, and zero workload failures across a clean-source V2 run.

## Public Console

Architecture: vertical slices and component-driven frontend.

Stack: Next.js App Router, React, TypeScript strict, Server Components for initial reads, Client Components for filters and charts, GraphQL Code Generator, ECharts loaded on demand, Playwright, and Lighthouse CI.

Primary evidence: LCP, INP, CLS, filter-to-chart p95, bundle size, and rendering 10,000 runs.

## Operations Console

Architecture: modular frontend with MVVM-style facades.

Stack: Angular standalone components, typed reactive forms, Signals, facades, Angular CDK, GraphQL Code Generator, and Playwright. NgRx is deferred until cross-feature coordination proves that local Signals and facades are insufficient.

This repository is valid only while it maintains at least three real workflows. Initial workflows are evidence quarantine, revalidation, remediation review, publication-gate review, and CI incident acknowledgement.

Primary evidence: load/filter p95 for 1,000 pending items, automated triage duration, INP, bundle size, and command-to-confirmed-state latency.

## JVM Distribution

Do not convert all Java repositories. The system deliberately demonstrates modern Java, idiomatic Kotlin, and a mixed boundary:

- Kotlin: payments, saga, and Kafka Streams.
- Java: event sourcing, multi-tenant, and cache strategies.
- Mixed: outbox core/contracts in Java with Spring runtime/adapters in Kotlin.

Every JVM project uses a committed Gradle Wrapper, Kotlin DSL build scripts, an explicit toolchain, identical quality gates, and Docker. Language comparisons are rejected unless implementation and workload are controlled; Java-versus-Kotlin microbenchmarks would mostly measure implementation choices rather than portfolio proficiency.

## Messaging

RabbitMQ belongs in `saga-orchestrator` only if command routing, acknowledgement, retry, poison-message handling, and DLQ recovery are implemented and benchmarked. Kafka/Redpanda remains the event-log choice for replay, streaming, CQRS projections, and outbox publication. No new messaging repository is created merely to add a logo.

## Contract Plane

The reuse kit now generates and validates:

- benchmark V2 JSON Schema and golden positive/negative fixtures;
- OpenAPI 3.1 ingestion and idempotent command contract;
- read-only GraphQL query and comparison schema;
- CSS variables, SCSS variables, and TypeScript design tokens;
- deterministic manifests with SHA-256 and byte size for every vendored contract;
- consumer-side drift checks whenever a repository vendors contracts/manifest.json.

OpenAPI owns writes and audited commands. GraphQL owns nested reads and comparisons. The contract manifest is generated from source assets and excludes itself, so clean-clone validation is deterministic.

Runtime components remain repository-owned. Python, Go, Java/Kotlin, Node, Next.js, and Angular depend on schemas and HTTP behavior rather than a shared runtime SDK. This keeps deployments independent and prevents the reuse layer from becoming a distributed monolith.
