# Decision Brain

This directory is the decision brain for every portfolio repository.

Agents must consult these files before choosing architecture, stack, API style, broker, cloud provider, database, framework, library, benchmark style, or public proof angle. The goal is to make decisions explicit, reusable, and reviewable instead of hidden inside prompts.

## Decision Order

1. `catalog/programs.yaml`: where the repo fits in the portfolio.
2. `catalog/proficiency.yaml`: what public proficiency it should prove.
3. `architecture/decision-matrix.yaml`: which architecture fits the problem forces.
4. `decision-brain/engineering-principles.yaml`: how coupling, SOLID, LSP, KISS, YAGNI, DRY, and testability are enforced.`r`n5. `decision-brain/stack-matrix.yaml`: which concrete stack profile fits the problem.
6. `decision-brain/api-style-matrix.yaml`: whether to expose REST/HTTP, GraphQL, gRPC, WebSocket, SSE, or CLI.
7. `decision-brain/messaging-matrix.yaml`: whether to use no broker, outbox, RabbitMQ, Kafka, Redis Streams, or NATS.
8. `decision-brain/cloud-matrix.yaml`: whether to use Kumo local-first, no cloud, an adapter fake, or real cloud.
9. `decision-brain/library-selection.yaml`: which libraries are preferred and when they are rejected.
10. `language-profiles/*.yaml`: how the chosen stack is organized, tested, benchmarked, and documented.

## Rule

Every non-trivial repo must record its decision in `project.yaml` and, when the choice affects architecture, coupling, SOLID boundaries, cloud, API contract, or benchmark, in `sdd/technical-decision.md`.
