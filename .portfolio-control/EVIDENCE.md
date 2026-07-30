# Portfolio Evidence Register

## Skill

- i-have-adhd source: https://github.com/ayghri/i-have-adhd
- pinned main: 07684c4ab625dd7d1ea6e99e065f60bc0ac6a1ba
- local skill read: passed

## Project #3

- Repository: Brilhante29/rag-knowledge-base
- Published status: project.yaml is published.
- V2 result: Recall@3 1.00, average 0.3175 ms, p95 0.4523 ms, cost/query 0.
- Benchmark/artifact head: eafd61108bb4536184c963cf45176242e3f15c57.
- Exact-head CI: https://github.com/Brilhante29/rag-knowledge-base/actions/runs/30578422267.
- Final release metadata head: f0b37dd9dd09674e0a1066e66ce95da7818380e9.
- Final release CI: https://github.com/Brilhante29/rag-knowledge-base/actions/runs/30579105424.

## Project #11

- Repository: Brilhante29/spring-hexagonal-payments
- Published status: project.yaml is published.
- Stack: Kotlin 2.4.10, Gradle 9.3, Spring Boot 4.1, JDBC, Flyway, PostgreSQL 18.4, k6 2.1.
- V2 result: median p99 108.122 ms, mean throughput 734.4 req/s, minimum core coverage 95.65%, zero HTTP failures.
- V2 samples: p99 87.201, 108.122, 120.869 ms; throughput 801.2, 756.3, 645.7 req/s.
- V2 source/artifact head: bedd98e964f94636463c97eb66f4f3a7d3711cd2.
- Exact-head CI: https://github.com/Brilhante29/spring-hexagonal-payments/actions/runs/30581889788.
- Final release metadata head: bdbf919a522f7a7884b087df40fefbc1fe818f6a.
- Final release CI: https://github.com/Brilhante29/spring-hexagonal-payments/actions/runs/30582309495.

## Reuse Learned

- Keep V1 execution and V2 publication artifacts separate.
- Add benchmark.publication_result_path to manifests instead of weakening either contract.
- For JVM/k6 workloads, lock Gradle dependencies and publish independent samples rather than hiding p99 variance.
- Treat exact-head CI and publication evidence as separate gates from local validation.
- Reuse the producer/provenance pattern for the next project only after generic kit validation passes.

Evidence is intentionally concise. Full logs stay in command output or project
artifacts; no credential values are recorded here.