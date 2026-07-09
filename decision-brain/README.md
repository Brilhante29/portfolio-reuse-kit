# Decision Brain

This directory is the decision brain for every portfolio repository.

Agents must consult these files before choosing architecture, stack, broker, database, framework, library, benchmark style, or public proof angle. The goal is to make decisions explicit, reusable, and reviewable instead of hidden inside prompts.

## Decision Order

1. `catalog/programs.yaml`: where the repo fits in the portfolio.
2. `catalog/proficiency.yaml`: what public proficiency it should prove.
3. `architecture/decision-matrix.yaml`: which architecture fits the problem forces.
4. `decision-brain/stack-matrix.yaml`: which concrete stack profile fits the problem.
5. `decision-brain/messaging-matrix.yaml`: whether to use no broker, outbox, RabbitMQ, Kafka, Redis Streams, or NATS.
6. `decision-brain/library-selection.yaml`: which libraries are preferred and when they are rejected.
7. `language-profiles/*.yaml`: how the chosen stack is organized, tested, benchmarked, and documented.

## Rule

Every non-trivial repo must record its decision in `project.yaml` and, when the choice affects architecture or benchmark, in `sdd/technical-decision.md`.
