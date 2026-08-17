# Python Model Monitoring

## Claim Boundary

Data drift means an input distribution changed. Prediction drift means the model output distribution changed. Neither proves concept drift or accuracy decay without labels. An alarm starts an investigation; it does not trigger automatic retraining.

## Required Identity

A comparison is valid only when reference and current batches preserve compatible producer, dataset, contract, model artifact, and feature-schema identities. The current capture time must follow the reference time, and the two payload digests must differ.

`monitoring-batch.schema.json` is the shared transport envelope. It requires:

- producer project and version;
- model id, version, and artifact SHA-256;
- a SHA-256-locked successful `validated-batch-manifest-v1`;
- capture time, payload size, row count, digest, and typed column roles.

The v1 envelope was hardened before its first verified consumer publication in #22. Future breaking changes require a new schema version.

## Statistical Decision

1. Choose the test from data type and monitored claim.
2. Correct multiple tests explicitly.
3. Require an operational effect threshold in addition to significance.
4. Keep the alarm policy outside the statistical library adapter.
5. Record unsupported shifts, such as correlation-only change for a univariate detector.

Evidently may be a reporting or comparison adapter. It must not hide the method, correction, effect, workload, or claim boundary.

## Publication Gate

Publish at least three same-image repetitions. Preserve F1, precision, recall, false-positive rate, runtime samples, blind spots, failures, source/image/wheel/lock digests, fixture identity, and comparability key. CI smoke evidence uses a separate output path and never mutates canonical evidence.

The proving implementation is [model-drift-detector](https://github.com/Brilhante29/model-drift-detector), exact-head CI run `31994181644`.
