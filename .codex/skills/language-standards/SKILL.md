---
name: language-standards
description: Select and apply repository conventions for the main implementation language, including package layout, testing, linting, Docker, benchmark rules, and README expectations.
---

# Language Standards

Use this skill after the project program and architecture are known.

1. Identify the dominant language or runtime from the problem and stack.
2. Read the matching file in `.portfolio/language-profiles/`.
3. Apply language conventions without overriding the architecture decision.
4. Ensure tests, linting, Docker, benchmark commands, and README scripts match the language profile.
5. If a project uses multiple languages, choose one primary profile and list secondary profiles in `project.yaml`.

Available profiles:

- `python.yaml` for AI, ML, data, RAG, FastAPI, and benchmarks.
- `java.yaml` for Spring, Kafka, backend architecture, reliability, and event sourcing.
- `go.yaml` for gateways, protocol benchmarks, emulators, and high-throughput services.
- `typescript.yaml` for Node, NestJS, frontend, tooling, and k6 JavaScript.
- `terraform.yaml` for infrastructure modules and AWS baselines.

Rule: language standards shape implementation hygiene; architecture still comes from the problem forces.


