# <project-name>: <one-line value proposition>

**<primary metric and value>** from <workload>. <One sentence on what the result proves, and its boundary.>

**Status:** scaffold. **Benchmark:** `<metric> = pending <unit>`.

<!-- Badges: CI, license, main language or framework. Keep the primary metric within the first eight lines. -->

## Why this exists

<The problem in plain language, why common approaches fail, and the three to five properties this repository makes verifiable.>

## Results

| Metric | Value | Unit | Notes |
|---|---:|---|---|
| <metric> | pending | <unit> | first reproducible baseline pending |

<How to read the result: what it shows, what it does not, and which number is the honest signal.>

## Quickstart

```bash
docker build -t <project-name> .
docker run --rm <project-name>
```

## How it works

<Diagram and the module or layer responsibilities. Architecture decisions live in `sdd/architecture-decision.md`.>

## Design decisions

| Decision | Why | Rejected |
|---|---|---|
| <decision> | <force that justifies it> | <alternative and reason> |

## Limitations

- <What this repository does not prove.>

## Reproducibility

1. Clone the repository.
2. Build the Docker image.
3. Run the benchmark command.
4. Compare the generated JSON in `benchmarks/results/`.

## Project structure

```text
<directories and their responsibilities>
```

## How this repository is built

The project follows the spec-driven workflow of [portfolio-reuse-kit](https://github.com/Brilhante29/portfolio-reuse-kit). Requirements and decisions live in [`sdd/`](sdd) and [`openspec/`](openspec), and [`project.yaml`](project.yaml) records the architecture, stack, and rejected alternatives. `.portfolio-control/` maps reuse, decisions, agent handoffs, critical path, and quality gates. Development is AI-assisted and human-governed: [`AGENTS.md`](AGENTS.md) and [`CLAUDE.md`](CLAUDE.md) hold the coding-agent instructions, while tests, validators, and CI decide what gets published.

## Related work

- <Sibling repositories that share a contract or answer an adjacent question.>

See `REFERENCES.md` for sources and reuse attribution.

## Author

**Guilherme Brilhante**, software engineer working on scalable backends and production AI.
[LinkedIn](https://www.linkedin.com/in/guilhermefreirebrilhanteseveriano/) · [GitHub](https://github.com/Brilhante29) · [Publications](https://dblp.org/pid/353/6812.html)

## License

[MIT](LICENSE).
