# Harness

Reusable benchmark harness for the 30 projects.

## Generic command benchmark

```bash
python harness/bench.py --project rag-knowledge-base --metric latency_ms --unit ms --repeat 10 python -m app.benchmark
```

The script writes JSON to `benchmarks/results/`.

## Compare two result files

```bash
python harness/compare_results.py old.json new.json
```

## Result rule

Every benchmark must produce a JSON object compatible with `result.schema.json`.
