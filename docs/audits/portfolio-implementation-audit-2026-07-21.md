# Portfolio Implementation Audit - 2026-07-21

Scope: static review of all 30 implementation trees, tests, Dockerfiles, workflows, benchmark evidence, SDD/OpenSpec artifacts, Git state, and macro-system integration. July 20 execution is excluded from Codex efficiency accounting, but its resulting code is included in the technical review.

## Portfolio Truth

| Measure | Result |
|---|---:|
| Repositories | 30 |
| Dockerfiles tracked | 30 |
| CI workflows tracked | 30 |
| Repositories with tracked benchmark JSON | 22 |
| Repositories whose tracked JSON follows the shared minimum contract | 15 |
| Local structural candidates | 9 |
| Verified publications | 0 |
| Declared `published` but unverified | 30 |
| Repositories with configured origin | 10 |
| Repositories with upstream | 0 |

A file-presence gate previously reported 30/30. That number was a false positive: it accepted ignored benchmark output and treated workflow existence as green CI/publication evidence.

## Per-Repository Verdict

| # | Repository | Verdict | Required adjustment |
|---:|---|---|---|
| 1 | `yolo-training-pipeline` | Strong foundation | Enforce comparable runs, regenerate summary without manual fields, and correct license distribution. |
| 2 | `llm-eval-harness` | Minimal utility | Evaluate real model/RAG outputs and emit the shared benchmark contract. |
| 3 | `rag-knowledge-base` | Functional prototype | Correct Recall@k, inject ports, restrict API paths, and run statistically valid repeats. |
| 4 | `stroke-signal-demo` | Claim mismatch | Reclassify as tabular synthetic ML or reproduce the paper with an appropriate dataset and protocol. |
| 5 | `alpr-mercosul` | Invalid benchmark | Replace the label oracle with image-only detection/OCR and an independent test set. |
| 6 | `melanoma-classifier` | Circular synthetic demo | Use real dermatoscopic data, patient-level splits, and external validation. |
| 7 | `vision-serving-fastapi` | Mock serving prototype | Load a real YOLO/ONNX artifact, fix Prometheus wire format, and honor benchmark arguments. |
| 8 | `embeddings-benchmark` | Lexical demo | Run actual embedding models and compute Recall@k correctly. |
| 9 | `llm-agent-eval` | Rule-router demo | Evaluate tool traces, expected tool selection, task success, latency, and measured cost. |
| 10 | `prompt-ab-testing` | Biased fixture demo | Use blinded grading or deterministic task metrics instead of fixture multipliers. |
| 11 | `spring-hexagonal-payments` | Strong foundation | Add replay/conflict/capture and real concurrency coverage to the benchmark. |
| 12 | `go-rate-limiter` | Strong foundation | Add dedicated Redis adapter integration and race coverage. |
| 13 | `mini-aws-emulator` | Strong local-first suite | Narrow AWS parity claims and fail/report cleanup errors. |
| 14 | `event-sourcing-orders` | Incomplete event sourcing | Add aggregate invariants, expected-version append, incremental projection, and correct workload labeling. |
| 15 | `grpc-vs-rest-bench` | Useful experiment, invalid method | Synchronize connection initialization, warm both transports, count errors, and randomize order. |
| 16 | `saga-orchestrator` | P0 claim failure | Implement real compensation and surface compensation failure before measuring consistency. |
| 17 | `multi-tenant-starter` | P0 claim failure | Provision and route real PostgreSQL schemas, add HTTP tenant context, rollback, and isolation tests. |
| 18 | `api-gateway-lite` | Incomplete gateway | Remove fallback secret, add server timeouts and trace propagation, and resolve duplicated rate limiting/program fit. |
| 19 | `cache-strategies-bench` | Methodology prototype | Restore wrapper, fix layer direction, equalize warm-up/randomness, and expose only intended runtime surfaces. |
| 20 | `outbox-pattern` | P0 claim failure | Persist order and outbox atomically in PostgreSQL, retry failures, and test broker outage with Redpanda. |
| 21 | `mlops-end2end` | Pipeline prototype | Benchmark a real Airflow DAG run with task state/retries, not direct Python stage calls. |
| 22 | `model-drift-detector` | Functional component | Preserve and enforce model identity across reference/current batches. |
| 23 | `feature-store-lite` | Functional component | Replace stale proof artifacts and integrate versioned dataset/feature contracts. |
| 24 | `ci-cd-templates` | Useful control component | Detect mutable `docker://` actions and job-level write permissions; roll its own guardrails into every repo. |
| 25 | `observability-stack` | Demo, not end-to-end | Measure HTTP, Prometheus scrape, alert rule, and recovery loop with Alertmanager. |
| 26 | `data-quality-checks` | Functional component | Publish accepted/quarantine bundles atomically and align README with tracked results. |
| 27 | `terraform-aws-baseline` | Local adapter prototype | Make local/AWS outputs identical, test both adapters, and correct public/private subnet semantics. |
| 28 | `kafka-streams-demo` | Functional topology with invalid assumption | Rekey from payload before join, fail on dropped joins, align README baseline, and calibrate CI workload. |
| 29 | `load-test-suite` | P0 clone failure | Anchor `/target/` ignore rule, version `internal/target`, require nonzero metric samples, and readiness-poll. |
| 30 | `cost-aware-inference` | Calculator demo | Execute local/API adapters and measure observed token cost and latency. |

## Macro-System Design

1. AI Evaluation and Retrieval: `llm-eval-harness + rag-knowledge-base + embeddings-benchmark + llm-agent-eval + prompt-ab-testing + cost-aware-inference`. Connect them through versioned evaluation datasets, trace/result contracts, one orchestrator, and a cross-repo acceptance suite.
2. Applied CV: `yolo-training-pipeline -> vision-serving-fastapi`; ALPR and melanoma are independent verticals sharing artifact/benchmark contracts. Move stroke to MLOps/Applied ML.
3. Backend Reliability: payments, rate limiter, gateway, event sourcing, saga, multi-tenant, cache, outbox, and protocol benchmark. Use real local PostgreSQL/Redis/Redpanda where the claim is transactional or distributed.
4. MLOps Data Platform: `data-quality -> feature-store -> mlops -> monitoring-batch -> drift`, with versioned dataset, model, feature, and prediction manifests.
5. Delivery and Observability: CI guardrails apply to every repository; Terraform provisions adapters; Kafka produces contract events; observability collects all services; load tests exercise real endpoints.

## Reuse Corrections

- Stop copying the full agent/scaffold tree into every repository. Keep shared skills and policies in the kit; materialize only a versioned project snapshot and project-specific decisions.
- Add reusable contracts for model artifacts, datasets, feature vectors, prediction batches, tool traces, and publication evidence.
- Add checks for ignored Docker inputs, benchmark schema, README-to-baseline drift, CI action immutability, Docker non-root/digest, and adapter parity.
- Treat architecture claims as executable rules: dependency direction, ports used by application code, LSP contract tests, and no framework imports in the domain.
- Keep KISS/YAGNI: do not add Kafka, RabbitMQ, GraphQL, cloud, or Clean Architecture unless the problem forces and benchmark exercise them.

## Security Action

Credentialed Git push URLs were removed locally. Any PAT exposed in conversation or local config must be revoked in GitHub; deleting the local value does not invalidate the credential.