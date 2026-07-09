# #<id> <project-name>

**Proves:** <one sentence>

**Benchmark:** `<metric> = <value> <unit>` on `<date>`.

## Run

```bash
docker build -t <project-name> .
docker run --rm <project-name>
```

## Benchmark

```bash
docker run --rm <project-name> benchmark
```

| Metric | Value | Unit |
|---|---:|---|
| <metric> | <value> | <unit> |

## Architecture

```txt
<brief diagram>
```

## Reproduce

1. Clone the repository.
2. Build the Docker image.
3. Run the benchmark command.
4. Compare the generated JSON in `benchmarks/results/`.

## References

This project was informed by:

- <reference>: <what was reused>

Implementation, fixtures, benchmark scripts and reported results are project-specific.
