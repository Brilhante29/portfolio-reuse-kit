# Project Catalog

| # | Project | Domain | Stack | Proves | Benchmark |
|---:|---|---|---|---|---|
| 1 | `yolo-training-pipeline` | computer-vision | python, pytorch, ultralytics, opencv, docker | treino e inferencia de deteccao | mAP e latency_ms_per_image |
| 2 | `llm-eval-harness` | llm-eval | python, typer, pydantic, pytest, docker | avaliacao objetiva de RAG/LLM | exact_match, f1, latency_ms |
| 3 | `rag-knowledge-base` | rag | python, fastapi, qdrant, sentence-transformers, docker | RAG do zero com busca vetorial | recall_at_k, latency_ms, cost_per_query |
| 4 | `stroke-signal-demo` | medical-ml | python, pandas, scikit-learn, matplotlib, docker | reproducao de classificador clinico | accuracy, confusion_matrix |
| 5 | `alpr-mercosul` | ocr | python, opencv, ultralytics, paddleocr, docker | leitura de placa Mercosul | character_accuracy, plate_accuracy |
| 6 | `melanoma-classifier` | medical-vision | python, pytorch, timm, scikit-learn, docker | classificacao de lesao de pele | auc, sensitivity |
| 7 | `vision-serving-fastapi` | model-serving | python, fastapi, onnxruntime, prometheus, k6, docker | servir modelo CV | throughput_rps, p95_latency_ms |
| 8 | `embeddings-benchmark` | retrieval | python, sentence-transformers, faiss, qdrant, docker | comparacao de modelos de embedding | recall_at_k, indexing_time_ms, query_time_ms |
| 9 | `llm-agent-eval` | agents | python, langgraph, pytest, mlflow, docker | agentes avaliados por tarefa | task_success_rate, cost_per_task |
| 10 | `prompt-ab-testing` | prompt-eval | python, typer, duckdb, scipy, docker | comparacao estatistica de prompts | score_by_variant, confidence_interval |
| 11 | `spring-hexagonal-payments` | backend | java21, spring-boot, postgresql, flyway, testcontainers, k6, docker | arquitetura hexagonal em pagamentos | coverage_percent, p99_latency_ms |
| 12 | `go-rate-limiter` | backend | go, redis, chi, k6, docker | rate limiter distribuido | accepted_rps, rejected_rps, p95_latency_ms |
| 13 | `mini-aws-emulator` | cloud-emulation | go-1.25, aws-sdk-go-v2, kumo-0.25.3, docker | paridade local AWS para S3, SQS e DynamoDB com adaptadores desacoplados | conformance_rate_percent, p95_operation_latency_ms, operations_per_second |
| 14 | `event-sourcing-orders` | backend | java21, spring-boot, postgresql, redpanda, docker | event sourcing e CQRS | events_per_second |
| 15 | `grpc-vs-rest-bench` | protocol-benchmark | go, grpc, chi, ghz, k6, docker | comparacao REST vs gRPC | latency_ms_by_protocol |
| 16 | `saga-orchestrator` | distributed-systems | java21, spring-boot, postgresql, docker | transacoes distribuidas com compensacao | consistency_rate |
| 17 | `multi-tenant-starter` | backend | java21, spring-boot, postgresql, flyway, docker | multi-tenant real | tenant_onboarding_seconds |
| 18 | `api-gateway-lite` | gateway | go, reverse-proxy, redis, opentelemetry, k6, docker | gateway com auth, rate limit e observabilidade | overhead_ms |
| 19 | `cache-strategies-bench` | caching | java21, spring-boot, redis, postgresql, k6, docker | cache-aside vs write-through | hit_ratio, p95_latency_ms |
| 20 | `outbox-pattern` | reliability | java21, spring-boot, postgresql, redpanda, docker | outbox transacional | lost_messages_under_failure |
| 21 | `mlops-end2end` | mlops | python, mlflow, fastapi, prometheus, docker | treino, registro, deploy e monitoramento | time_to_production_minutes |
| 22 | `model-drift-detector` | mlops | python, pandas, scipy, prometheus, docker | deteccao de drift | drift_alarm_vs_baseline |
| 23 | `feature-store-lite` | data-platform | python, fastapi, postgresql, redis, docker | feature store minima | online_read_latency_ms |
| 24 | `ci-cd-templates` | devops | github-actions, docker-buildx, trivy, k6 | pipelines reutilizaveis | build_time_seconds |
| 25 | `observability-stack` | observability | go, prometheus, grafana, opentelemetry, docker-compose | observabilidade ponta a ponta | simulated_mttr_minutes |
| 26 | `data-quality-checks` | data-quality | python, pandera, duckdb, polars, docker | validacao objetiva de dados | rejected_rows_percent |
| 27 | `terraform-aws-baseline` | infrastructure | terraform, aws, tflint, checkov | baseline AWS como codigo | provision_time_seconds |
| 28 | `kafka-streams-demo` | streaming | java21, kafka-streams, redpanda, testcontainers, docker | processamento streaming | messages_per_second |
| 29 | `load-test-suite` | performance | k6, javascript, docker | suite reutilizavel de carga | p95_curve |
| 30 | `cost-aware-inference` | llmops | python, fastapi, litellm, ollama, duckdb, docker | custo e latencia local vs API | cost_per_1k_tokens, latency_ms |