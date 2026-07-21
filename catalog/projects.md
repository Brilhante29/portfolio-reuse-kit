# Project Catalog

| # | Project | Domain | Stack | Proves | Benchmark |
|---:|---|---|---|---|---|
| 1 | `yolo-training-pipeline` | computer-vision | python-3.12.13, ultralytics-8.4.96, pytorch-2.13.0-cpu, torchvision-0.28.0-cpu, pytest-9.1.1, ruff-0.15.21, docker | treino e inferencia de deteccao | mAP e latency_ms_per_image |
| 2 | `llm-eval-harness` | llm-eval | python, json-schema, jsonl, argparse, unittest, docker | avaliacao objetiva de RAG/LLM | exact_match, f1, latency_ms |
| 3 | `rag-knowledge-base` | rag | python, fastapi, uvicorn, local-hashing-embeddings, json-vector-store, docker | RAG do zero com busca vetorial | recall_at_k, latency_ms, cost_per_query |
| 4 | `stroke-signal-demo` | medical-ml | python, pandas, scikit-learn, matplotlib, docker | reproducao de classificador clinico | accuracy, confusion_matrix |
| 5 | `alpr-mercosul` | ocr | python, opencv, ultralytics, paddleocr, docker | leitura de placa Mercosul | character_accuracy, plate_accuracy |
| 6 | `melanoma-classifier` | medical-vision | python, scikit-learn, pillow, numpy, scipy, docker | classificacao de lesao de pele | auc, sensitivity |
| 7 | `vision-serving-fastapi` | model-serving | python, fastapi, onnxruntime, prometheus, k6, docker | servir modelo CV | throughput_rps, p95_latency_ms |
| 8 | `embeddings-benchmark` | retrieval | python, sparse-vectorizers, tf-idf, feature-hashing, jsonl, docker | comparacao de modelos de embedding | recall_at_k, indexing_time_ms, query_time_ms |
| 9 | `llm-agent-eval` | agents | python, jsonl, unittest, docker | agentes avaliados por tarefa | task_success_rate, cost_per_task |
| 10 | `prompt-ab-testing` | prompt-eval | python, statistics, jsonl, unittest, docker | comparacao estatistica de prompts | score_by_variant, confidence_interval |
| 11 | `spring-hexagonal-payments` | backend | java-25, kotlin-2.4, spring-boot-4.1, spring-mvc, spring-jdbc, jackson-kotlin-3.1, postgresql-18.4, flyway-12.4, testcontainers-2.0, junit-6, jacoco, k6-2.1, gradle-9.3, docker | arquitetura hexagonal em pagamentos | coverage_percent, p99_latency_ms |
| 12 | `go-rate-limiter` | backend | go-1.26, chi-v5, redis-8.8, go-redis-v9, lua, k6, docker | rate limiter distribuido | accepted_rps, rejected_rps, p95_latency_ms |
| 13 | `mini-aws-emulator` | cloud-emulation | go-1.25.10, aws-sdk-go-v2-1.41.9, kumo-0.25.3, smithy-go-1.26.0, docker-27.4 | paridade local AWS para S3, SQS e DynamoDB com adaptadores desacoplados | conformance_rate_percent, p95_operation_latency_ms, operations_per_second |
| 14 | `event-sourcing-orders` | backend | java21, spring-boot, postgresql, redpanda, docker | event sourcing e CQRS | events_per_second |
| 15 | `grpc-vs-rest-bench` | protocol-benchmark | go, grpc, chi, protobuf, docker | comparacao REST vs gRPC | latency_ms_by_protocol |
| 16 | `saga-orchestrator` | distributed-systems | java21, spring-boot, postgresql, docker, gradle | transacoes distribuidas com compensacao | consistency_rate |
| 17 | `multi-tenant-starter` | backend | java21, spring-boot, docker | multi-tenant real | tenant_onboarding_seconds |
| 18 | `api-gateway-lite` | gateway | go, reverse-proxy, redis, opentelemetry, k6, docker | gateway com auth, rate limit e observabilidade | overhead_ms |
| 19 | `cache-strategies-bench` | caching | java21, spring-boot, docker | cache-aside vs write-through | hit_ratio, p95_latency_ms |
| 20 | `outbox-pattern` | reliability | java21, spring-boot, postgresql, redpanda, docker | outbox transacional | lost_messages_under_failure |
| 21 | `mlops-end2end` | mlops | python-3.12, apache-airflow-3.3.0, mlflow-3.14.0, fastapi-0.136.3, scikit-learn-1.9.0, pandera-0.32.1, prometheus-client-0.25.0, docker | treino, registro, deploy e monitoramento | time_to_production_minutes |
| 22 | `model-drift-detector` | mlops | python-3.12, numpy-2.5.1, scipy-1.18.0, pydantic-2.13.4, prometheus-client-0.25.0, docker | deteccao de drift | drift_alarm_vs_baseline |
| 23 | `feature-store-lite` | data-platform | python-3.12, feast-0.64.0, pandas-2.3.3, pyarrow-25.0.0, parquet, sqlite, docker | feature store minima | online_read_latency_ms |
| 24 | `ci-cd-templates` | devops | Python 3.10+, PyYAML, actionlint 1.7.12, zizmor 1.26.1, Docker, GitHub Actions | pipelines reutilizaveis | build_time_seconds |
| 25 | `observability-stack` | observability | python-3.12, fastapi, prometheus-client, prometheus, grafana, docker-compose | observabilidade ponta a ponta | simulated_mttr_minutes |
| 26 | `data-quality-checks` | data-quality | python-3.12, pandera-0.32.1, polars-1.42.1, docker | validacao objetiva de dados | rejected_rows_percent |
| 27 | `terraform-aws-baseline` | infrastructure | terraform, python, docker, github-actions | baseline AWS como codigo | provision_time_seconds |
| 28 | `kafka-streams-demo` | streaming | kotlin, java21, gradle, kafka-streams, junit5, docker, redpanda-optional | processamento streaming | messages_per_second |
| 29 | `load-test-suite` | performance | go, k6, javascript, docker | suite reutilizavel de carga | p95_curve |
| 30 | `cost-aware-inference` | llmops | python, ports-and-adapters, openai-compatible-http, json, docker | custo e latencia local vs API | cost_per_1k_tokens, latency_ms |
| 31 | `portfolio-evidence-api` | portfolio-evidence | nodejs-lts, typescript-strict, nestjs, fastify, graphql, ajv, kysely, sqlite, postgresql, opentelemetry, prometheus, k6, docker | interoperable benchmark evidence ingestion, comparison, and publication readiness | ingestion_p95_ms, ingestion_throughput_rps, graphql_query_p95_ms, adapter_parity_percent |
| 32 | `portfolio-evidence-console` | portfolio-experience | nextjs, react, typescript-strict, graphql-codegen, echarts, playwright, lighthouse-ci, docker | public comparison and reproducibility experience backed by verified evidence | lcp_ms, inp_ms, cls, filter_to_chart_p95_ms, bundle_bytes |
| 33 | `portfolio-operations-console` | portfolio-operations | angular, typescript-strict, standalone-components, signals, angular-cdk, graphql-codegen, playwright, docker | audited evidence quarantine, revalidation, remediation, and publication operations | pending_items_filter_p95_ms, triage_duration_ms, inp_ms, command_confirmation_p95_ms |
