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

Architecture: modular monolith with hexagonal module boundaries and lightweight CQRS.

Modules: evidence ingestion, benchmark catalog, comparability, publication readiness, query read model, and audit.

Stack: Node.js LTS, TypeScript strict, NestJS, Fastify, REST commands, GraphQL queries, Ajv, Kysely, SQLite local-first, PostgreSQL adapter, Pino, OpenTelemetry, Prometheus, and k6.

Kysely is selected over Prisma because controlled SQL and adapter parity between SQLite and PostgreSQL are part of the claim. NestJS, Fastify, GraphQL, and Kysely stay outside the domain.

Default `docker run` uses SQLite and filesystem storage. Optional Compose profiles exercise PostgreSQL and Kumo. Real AWS remains behind the same object-store port.

Primary evidence: ingest p95 and throughput for 10,000 results, GraphQL query p95, invalid-evidence rejection rate, and SQLite/PostgreSQL behavioral parity.

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

## Reuse Delta

The reuse kit must generate, version, and hash:

- benchmark V2 JSON Schema and golden fixtures;
- OpenAPI ingestion/command contract;
- GraphQL query schema;
- CSS variables, SCSS variables, and TypeScript design tokens;
- a manifest containing version and SHA-256 for vendored assets;
- CI drift checks for every consumer.

Runtime components remain repository-owned. The kit shares contracts, tokens, skills, decision rules, harnesses, and verification, preserving loose coupling and independent deployment.
