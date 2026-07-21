# Portfolio Status Report

Generated: 2026-07-21T18:10:17.5993717Z

Repositories: **30** | Docker: **30** | CI files: **30** | tracked benchmarks: **22** | contract-valid benchmarks: **15** | local candidates: **9** | verified publications: **0** | origins: **10** | upstreams: **0**

| # | Repository | Program | Declared | Language | Stack | Architecture | API | Messaging | Cloud | Database | Benchmark | Contract | Placeholders | Local | Published |
|---:|---|---|---|---|---|---|---|---|---|---|:---:|:---:|---:|:---:|:---:|
| 1 | yolo-training-pipeline | applied-computer-vision | published | python | python-3.12.13, ultralytics-8.4.96, pytorch-2.13.0-cpu, torchvision-0.28.0-cpu, pytest-9.1.1, ruff-0.15.21, docker | pipeline | cli | none | none | none | True | True | 1 | False | False |
| 2 | llm-eval-harness | ai-evaluation-retrieval | published | python | python, argparse, unittest, docker | clean-architecture | cli-first | none | none | fixture-files | True | False | 1 | False | False |
| 3 | rag-knowledge-base | ai-evaluation-retrieval | published | fastapi-backend | python, fastapi, uvicorn, local-hashing-embeddings, json-vector-store, docker | clean-architecture | rest-http | none | none | json-vector-store | True | True | 1 | False | False |
| 4 | stroke-signal-demo | mlops-data-platform | published | python-ml | python, pandas, scikit-learn, matplotlib, docker | pipeline | cli | none | none | none | False | False | 0 | False | False |
| 5 | alpr-mercosul | applied-computer-vision | published | python-ml | python, opencv, ultralytics, paddleocr, docker | pipeline | cli | none | none | none | False | False | 0 | False | False |
| 6 | melanoma-classifier | applied-computer-vision | published | python-ml | python, scikit-learn, pillow, numpy, scipy, docker | pipeline | cli | none | none | none | False | False | 0 | False | False |
| 7 | vision-serving-fastapi | applied-computer-vision | published | fastapi-backend | python, fastapi, onnxruntime, prometheus, k6, docker | modular-monolith | rest-http | none | none | none | False | False | 0 | False | False |
| 8 | embeddings-benchmark | ai-evaluation-retrieval | published | python | python, deterministic-embeddings, jsonl, docker | clean-architecture | cli-first | none | none | fixture-files | True | False | 1 | False | False |
| 9 | llm-agent-eval | ai-evaluation-retrieval | published | python | python, deterministic-agents, unittest, docker | clean-architecture | cli-first | none | none | fixture-files | True | False | 1 | False | False |
| 10 | prompt-ab-testing | ai-evaluation-retrieval | published | python | python, statistics, jsonl, docker | clean-architecture | cli-first | none | none | fixture-files | True | False | 1 | False | False |
| 11 | spring-hexagonal-payments | backend-reliability-platform | published | spring-kotlin-backend | java-25, kotlin-2.4, spring-boot-4.1, spring-mvc, spring-jdbc, jackson-kotlin-3.1, postgresql-18.4, flyway-12.4, testcontainers-2.0, junit-6, jacoco, k6-2.1, gradle-9.3, docker | hexagonal | rest-http | none | none | postgresql | True | True | 0 | True | False |
| 12 | go-rate-limiter | backend-reliability-platform | published | go-backend | go-1.26, chi-v5, redis-8.8, go-redis-v9, lua, k6, docker | hexagonal | rest-http | none | none | redis | True | True | 0 | True | False |
| 13 | mini-aws-emulator | backend-reliability-platform | published | go-backend | go-1.25.10, aws-sdk-go-v2-1.41.9, kumo-0.25.3, smithy-go-1.26.0, docker-27.4 | hexagonal | cli | none | kumo-local-first | dynamodb-compatible-key-value | True | True | 0 | True | False |
| 14 | event-sourcing-orders | backend-reliability-platform | published | spring-kotlin-backend | java21, spring-boot, postgresql, redpanda, docker | cqrs-event-sourcing | rest-http | none | none | none | False | False | 0 | False | False |
| 15 | grpc-vs-rest-bench | backend-reliability-platform | published | go-backend | go, grpc, chi, protobuf, docker | modular-monolith | rest-http+grpc | none | none | none | True | False | 0 | False | False |
| 16 | saga-orchestrator | backend-reliability-platform | published | spring-kotlin-backend | java21, spring-boot, postgresql, docker, gradle | layered | rest-http | none | none | postgresql | False | False | 0 | False | False |
| 17 | multi-tenant-starter | backend-reliability-platform | published | java | java21, spring-boot, postgresql, flyway, docker | hexagonal | rest-http | none | adapter-fake | in-memory (simulates schema-per-tenant) | False | False | 0 | False | False |
| 18 | api-gateway-lite | delivery-observability-infra | published | go-backend | go, reverse-proxy, redis, opentelemetry, k6, docker | modular-monolith | rest-http | none | none | none | False | False | 0 | False | False |
| 19 | cache-strategies-bench | backend-reliability-platform | published | java | java21, spring-boot, docker | layered | rest-http | none | none | none (in-memory simulation) | True | False | 0 | False | False |
| 20 | outbox-pattern | backend-reliability-platform | published | java | java21, spring-boot, postgresql, redpanda, docker | hexagonal | rest-http | outbox-only | none | none (in-memory) | True | True | 0 | True | False |
| 21 | mlops-end2end | mlops-data-platform | published | python | python-3.12, apache-airflow-3.3.0, mlflow-3.14.0, fastapi-0.136.3, scikit-learn-1.9.0, pandera-0.32.1, prometheus-client-0.25.0, docker | pipeline | rest-http | none | none | SQLite for ephemeral Airflow and MLflow metadata | True | True | 1 | False | False |
| 22 | model-drift-detector | mlops-data-platform | published | python | python-3.12, numpy-2.5.1, scipy-1.18.0, pydantic-2.13.4, prometheus-client-0.25.0, docker | pipeline | cli | none | none | none | True | True | 1 | False | False |
| 23 | feature-store-lite | mlops-data-platform | published | python | python-3.12, feast-0.64.0, pandas-2.3.3, pyarrow-25.0.0, parquet, sqlite, docker | pipeline | cli | none | none | sqlite | True | True | 1 | False | False |
| 24 | ci-cd-templates | delivery-observability-infra | published | python | Python 3.10+, PyYAML, actionlint 1.7.12, zizmor 1.26.1, Docker, GitHub Actions | pipeline | cli | none | none | none | True | True | 0 | True | False |
| 25 | observability-stack | backend-reliability-platform | published | fastapi-backend | python-3.12, fastapi, prometheus-client, prometheus, grafana, docker-compose | hexagonal | rest-http | none | none | none | True | True | 0 | True | False |
| 26 | data-quality-checks | mlops-data-platform | published | python | python-3.12, pandera-0.32.1, polars-1.42.1, docker | pipeline | cli | none | none | none | True | True | 1 | False | False |
| 27 | terraform-aws-baseline | delivery-observability-infra | published | terraform | not-selected | hexagonal | cli | none | adapter-fake | none | True | True | 0 | True | False |
| 28 | kafka-streams-demo | mlops-data-platform | published | spring-kotlin-backend | not-selected | event-driven | cli | kafka | adapter-fake | none | True | True | 0 | True | False |
| 29 | load-test-suite | delivery-observability-infra | published | go-backend | not-selected | modular-monolith | rest-http | none | none | none | True | True | 0 | True | False |
| 30 | cost-aware-inference | ai-evaluation-retrieval | published | python | python, provider-ports, json, docker | clean-architecture | cli-first | none | none | fixture-files | True | False | 1 | False | False |
