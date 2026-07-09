# Engineering Principles

This portfolio must show engineering judgment, not just stack variety.

The default rule is strict: domain and use cases cannot depend on HTTP, GraphQL, database drivers, ORM sessions, cloud SDKs, queues, framework runtime, environment variables, or UI rendering. Those concerns belong in adapters.

## Core Rule

```txt
business policy / domain / use cases
  -> ports owned by the application
  -> adapters for HTTP, GraphQL, database, cloud, broker, CLI, UI, files
```

Dependencies point inward. Details depend on policy. Policy does not depend on details.

## SOLID

| Principle | Portfolio Rule | Common Failure |
|---|---|---|
| SRP | One reason to change per module/class/function. | A service validates input, writes DB, sends queue message, and formats HTTP response. |
| OCP | Add behavior through adapters, strategies, policies, or handlers. | Big `if/else` for providers, queues, payment methods, or storage backends. |
| LSP | Any implementation of a port must be substitutable. | Local fake behaves differently from real AWS/Kumo/RabbitMQ/Kafka adapter. |
| ISP | Use small capability-specific ports. | One broad client interface with unrelated methods. |
| DIP | High-level use cases depend on abstractions, not SDKs. | Use case creates Prisma, AWS SDK, Kafka producer, SQLAlchemy session, or HTTP client directly. |

When the user writes `LISP` in this context, treat it as `LSP`: Liskov Substitution Principle.

## Simplicity

KISS: choose the simplest design that proves the claim and benchmark.

YAGNI: do not create extension points for futures the repo does not prove.

DRY: remove duplicated business rules and contracts, but do not create premature generic abstractions for incidental similarity.

## Required Evidence

A project that claims Clean Architecture, Hexagonal, Modular Monolith, or serious backend design must show:

- domain/use cases testable without HTTP server
- domain/use cases testable without database, broker, or cloud
- cloud/broker/database behind ports
- controllers/resolvers/handlers thin
- adapters with contract tests when there is more than one implementation
- local adapter and real adapter with the same behavior where applicable
- benchmark still runnable from the default Docker path

## Rejection Rule

If a pattern does not improve testability, replaceability, clarity, or benchmark evidence, do not add it.
