# Harness

Reusable evidence harnesses for the portfolio projects.

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

## Node dependency advisories

```bash
node harness/node/npm-advisory-audit.mjs --level=high
```

The standalone Node 24 harness reads `package-lock.json`, calls npm's Bulk
Advisory endpoint, decodes identity or gzip bodies, retries bounded transport
failures, and fails closed when an advisory meets the selected severity.
Copy it into a Node repository only when ordinary `npm audit` transport is not
reliable in that CI environment; security findings must never be suppressed.
