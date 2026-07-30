# Portfolio Evidence Register

## Skill

- `i-have-adhd` source: `https://github.com/ayghri/i-have-adhd`
- pinned `main`: `07684c4ab625dd7d1ea6e99e065f60bc0ac6a1ba`
- local skill read: passed

## Project #3

- Repository: `Brilhante29/rag-knowledge-base`
- Published status: `project.yaml` is `published`.
- V1 execution result: Recall@3 `1.00`, 5 repetitions, 35 timed samples.
- V2 publication result: Recall@3 `1.00`, average `0.3175 ms`, p95 `0.4523 ms`, cost/query `0`.
- V2 schema: `contracts/benchmark-result-v2.schema.json`, validation errors: `0`.
- Benchmark source/artifact head: `eafd61108bb4536184c963cf45176242e3f15c57`.
- Benchmark source/artifact CI: `https://github.com/Brilhante29/rag-knowledge-base/actions/runs/30578422267`.
- Final release metadata head: `f0b37dd9dd09674e0a1066e66ce95da7818380e9`.
- Final release metadata CI: `https://github.com/Brilhante29/rag-knowledge-base/actions/runs/30579105424`.
- Central evidence file: `.portfolio-control/publications/rag-knowledge-base.json`.

## Reuse Learned

- Keep V1 execution and V2 publication artifacts separate.
- Add `benchmark.publication_result_path` to manifests instead of weakening either contract.
- Treat exact-head CI and publication evidence as separate gates from local validation.
- Reuse the producer/lockfile/provenance pattern for the next project only after generic kit validation passes.

Evidence is intentionally concise. Full logs stay in command output or project
artifacts; no credential values are recorded here.