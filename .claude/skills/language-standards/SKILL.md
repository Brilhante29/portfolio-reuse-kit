---
name: language-standards
description: Select and apply repository conventions for the main implementation language or framework, including Angular, Next.js, Python, Java, Go, TypeScript, Terraform, package layout, testing, linting, Docker, benchmark rules, and README expectations.
---

# Language Standards

Use this skill after the project program, proficiency signal, and architecture are known.

1. Identify the dominant language or framework from the problem, public proficiency goal, and stack.
2. Read `catalog/proficiency.yaml` or `.portfolio/catalog/proficiency.yaml` to understand what the stack should prove publicly.
3. Read the matching file in `language-profiles/` or `.portfolio/language-profiles/`.
4. Apply language/framework conventions without overriding the architecture decision.
5. Ensure tests, linting, Docker, benchmark commands, and README scripts match the selected profile.
6. If a project uses multiple languages, choose one primary profile and list secondary profiles in `project.yaml`.

Available profiles:

- `python.yaml` for AI, ML, data, RAG, FastAPI, MLflow, Airflow, and benchmarks.
- `java.yaml` for Spring, Kafka, backend architecture, reliability, and event sourcing.
- `go.yaml` for gateways, protocol benchmarks, emulators, and high-throughput services.
- `typescript.yaml` for Node, NestJS, tooling, and k6 JavaScript.
- `angular.yaml` for enterprise frontend, admin tools, typed forms, guards, and modular UI.
- `nextjs.yaml` for React product frontend, public demos, dashboards, and SSR/ISR tradeoffs.
- `terraform.yaml` for infrastructure modules and AWS baselines.

Rule: language standards shape implementation hygiene; architecture still comes from the problem forces.
