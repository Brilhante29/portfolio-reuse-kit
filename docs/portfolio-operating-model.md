# Portfolio Operating Model

The portfolio is not 30 unrelated repositories. It is a set of programs. Each program solves a larger problem through several repositories that share standards, fixtures, metrics, visual language, and agent instructions.

## Programs

| Program | Projects | Problem Solved |
|---|---:|---|
| AI Evaluation and Retrieval Systems | 2, 3, 8, 9, 10, 30 | Measure LLM/RAG quality, cost, latency, prompts, agents, and inference tradeoffs. |
| Applied Computer Vision and Medical AI | 1, 4, 5, 6, 7 | Train, evaluate, and serve visual models with reproducible metrics. |
| Backend Reliability and Architecture Platform | 11-20 | Prove backend architecture, reliability, performance, consistency, and integration patterns. |
| MLOps and Data Platform | 21, 22, 23, 26, 28 | Connect training, registry, features, data checks, drift, and streaming. |
| Delivery, Observability, and Infrastructure | 24, 25, 27, 29 | Standardize CI, provisioning, telemetry, load tests, and operational evidence. |

## How Agents Should Use This

Before creating a repository, the agent must answer:

1. Which program does this repo belong to?
2. What shared assets from that program should be reused?
3. Which architecture fits the problem forces?
4. Which language profile governs formatting, tests, folder conventions, and CI?
5. Which design-system pieces make the README, diagrams, badges, tables, screenshots, and dashboards visually consistent?
6. What benchmark turns this repo into evidence for the program narrative?

## Reuse Levels

| Level | What Is Reused | Example |
|---|---|---|
| Portfolio | Naming, README shape, release rule, publication workflow | All repos open with number, claim, benchmark. |
| Program | Shared problem, fixtures, metric family, story | RAG repos share retrieval metrics and cost reporting. |
| Architecture | Folder boundaries and dependency rules | Backend reliability projects can use Hexagonal, Clean, CQRS, or Event-driven based on problem. |
| Language | Tooling, tests, formatting, package layout | Python uses `src/`, pytest, ruff; Java uses domain/application/infra packages and Testcontainers. |
| Design | Badges, colors, diagrams, tables, benchmark cards | Every README and dashboard feels like one portfolio. |
| Harness | Benchmark JSON, k6 profiles, comparison scripts | Results are comparable across posts. |

## Rule

A new project is valid only when it has a place in a program. If a repo does not strengthen a program story, it should not be built yet.
