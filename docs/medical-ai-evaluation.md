# Medical AI Evaluation

This contract standardizes what a medical or biomedical benchmark may claim. It is an evidence boundary, not a shared runtime library and not a clinical certification.

## Required Proof

1. Group train, validation, and test identities by patient, encounter, or study; report zero overlap.
2. Fit on training data, select thresholds on validation data, and set `test_used_for_selection` to `false`.
3. Report TN, FP, FN, TP, sensitivity, specificity, accuracy, the task's primary metric, and latency.
4. Identify dataset and model artifacts with SHA-256 digests and preserve every repeated sample.
5. Set `clinical_use` to `false` and publish limitations beside the headline metric.

The machine-readable boundary is `contracts/medical-evaluation-report-v1.schema.json`. Its invalid fixture deliberately combines a clinical-use claim with test-driven selection and must always be rejected.

## Architecture Rule

Keep dataset identity, grouped split, training calibration, validation selection, test evaluation, and evidence serialization as separate modules. Depend on framework adapters only when an actual external boundary exists. A CLI pipeline is the default for offline scientific evidence; HTTP, GraphQL, brokers, cloud, and orchestration require a measured problem that uses them.

## Reference Implementation

`stroke-signal-demo` is the first implementation. Its synthetic Dice `0.9424706943` proves the protocol and paper-inspired segmentation mechanics. It does not reproduce clinical performance, consume private patient data, or claim diagnostic use.
