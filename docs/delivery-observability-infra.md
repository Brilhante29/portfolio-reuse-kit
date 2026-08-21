# Delivery, Observability, And Infrastructure

This macro proves one operational path across four focused repositories. CI supplies executable gates, observability shortens incident recovery, Terraform provisions interchangeable infrastructure, and k6 applies reproducible load. The repositories share contracts and evidence rules, not application source code.

## Repository Responsibilities

| # | Repository | Responsibility | Publication state |
|---:|---|---|---|
| 24 | `ci-cd-templates` | Execute and secure reusable Python, Go, Node, JVM/Gradle, and Terraform workflows | Published |
| 25 | `observability-stack` | Correlate traces, metrics, and logs and measure a real controlled HTTP incident | Published |
| 27 | `terraform-aws-baseline` | Provision a local-first Kumo-compatible baseline with a plug-compatible AWS adapter | Next |
| 29 | `load-test-suite` | Reuse k6 scenarios and publish the p95 load curve of real endpoints | Pending |

## Contract Flow

```mermaid
flowchart LR
  repo["Stack repository"] -->|"ci-profile-v1"| ci["#24 Reusable CI"]
  ci -->|"exact-head release evidence"| observe["#25 Observability"]
  infra["#27 Terraform baseline"] --> observe
  load["#29 k6 workload"] --> observe
  observe --> contract["observability-evidence-v1"]
  contract --> evidence["Benchmark result V2"]
```

`ci-profile-v1` identifies the workflow by immutable source commit, runtime and explicit commands, supply-chain controls, executable fixture, zero static findings, and exact-head CI run. It does not force all repositories onto one universal command script.

`observability-evidence-v1` requires at least three real `200 -> 503 -> 200`
runs, monotonic timing, unique lifecycle trace IDs, correlation rate `1.0`,
non-root named-volume evidence, full backend health/navigation, immutable
provenance, full Git history for source validation, and exact-head CI.

## Decoupling Rules

- Stack-specific commands stay in explicit workflow profiles; project domain code does not depend on CI implementation.
- Telemetry is emitted through standard ports and semantic attributes; dashboards do not become application dependencies.
- OTLP is the local-to-cloud switch. Domain and application code never import telemetry backends or cloud SDKs.
- Fast evidence and full exploration are separate profiles. Prometheus, Tempo, Loki, and Grafana are included only when they prove navigation across signals.
- Tempo 3 runs monolithically for this workload; Kafka is rejected because there is no distributed ingest requirement.
- Terraform modules expose provider-neutral inputs where behavior is equivalent. Kumo is the default AWS-compatible local adapter; real AWS remains a configuration switch behind the same project boundary.
- k6 workloads consume public service contracts and versioned fixtures, never internal application modules.
- Static guardrail latency, hosted build time, MTTR, provision time, and load p95 remain separate benchmarks with separate comparability keys.

## Completion Gate

Each repository needs a credential-free local Docker path, README headline number, benchmark result V2, clean source provenance, and successful CI at the exact final `main`. Current progress is 2/4; #27 is next.
