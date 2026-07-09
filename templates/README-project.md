# #<id> <project-name>

**Status:** scaffold

**Proves:** <one sentence claim>

**Benchmark:** `<metric> = pending <unit>`.

## Run

```bash
docker build -t <project-name> .
docker run --rm <project-name>
```

## Benchmark

```bash
docker run --rm <project-name> benchmark
```

| Metric | Value | Unit | Notes |
|---|---:|---|---|
| <metric> | pending | <unit> | first reproducible baseline pending |

## Architecture

Defined in `sdd/spec.md` before implementation.

## Reproduce

1. Clone the repository.
2. Build the Docker image.
3. Run the benchmark command.
4. Compare the generated JSON in `benchmarks/results/`.

## References

See `REFERENCES.md`.