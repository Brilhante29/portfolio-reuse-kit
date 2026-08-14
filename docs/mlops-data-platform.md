# MLOps And Data Platform

This macro is one evidence system, not six unrelated demos. It proves that data can be rejected safely, identified immutably, materialized as features, used by a real training lifecycle, evaluated in a clinical reproduction, observed for drift, and processed as a stream.

## Repository Responsibilities

| # | Repository | Responsibility | Publication state |
|---:|---|---|---|
| 26 | `data-quality-checks` | Fail-closed structural and row gate; accepted/quarantine artifacts and manifest | Published |
| 23 | `feature-store-lite` | Point-in-time-correct feature materialization and online reads | Active next |
| 21 | `mlops-end2end` | Airflow execution, MLflow registry, deploy and monitor lifecycle | Published |
| 4 | `stroke-signal-demo` | Reproducible clinical classifier and held-out evaluation | Pending |
| 22 | `model-drift-detector` | Baseline/current feature and prediction drift alarms | Pending |
| 28 | `kafka-streams-demo` | Stateful streaming and message-rate evidence | Published |

## Artifact Flow

```mermaid
flowchart LR
  raw["Raw batch"] --> quality["#26 Data quality gate"]
  quality -->|"validated-batch-manifest-v1"| features["#23 Feature store"]
  features -->|"feature-snapshot-v1"| lifecycle["#21 Train, register, deploy"]
  features --> drift["#22 Drift detector"]
  lifecycle --> drift
  quality --> clinical["#4 Clinical reproduction"]
  events["Versioned events"] --> streams["#28 Kafka Streams"]
```

The arrows are artifact contracts, not source imports or a claim that every repository is deployed together. The central contract is `contracts/mlops-data-platform.yaml`; `contracts/validated-batch-manifest-v1.schema.json` is the first implemented cross-repository boundary.

## Decoupling Rules

- Domain and application policy do not import Pandera, Polars, Feast, Airflow, MLflow, Kafka, storage SDKs, or transports.
- Adapters depend inward on ports and versioned contracts. Consumers validate schema version, contract identity, quality status, and digest before reading an artifact.
- Substitution is proved with reference-versus-optimized adapter parity where multiple implementations exist.
- Each repository keeps one focused proof and benchmark. Infrastructure is added only when it participates in that proof.
- Docker is the local-first runtime. Cloud equivalents stay plug-compatible behind project-owned ports; Kumo is selected only for AWS behavior that must be emulated.

## Completion Gate

A component is publication-complete only when Docker execution, README headline numbers, canonical V2 evidence, reproducible smoke evidence, and exact-head CI all pass. The macro closes at 6/6, after #23, #22, and #4 consume or demonstrate compatible versions of the artifact chain.
