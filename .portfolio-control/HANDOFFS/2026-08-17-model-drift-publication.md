# Model Drift Detector Publication Handoff

## Published State

- Repository: `Brilhante29/model-drift-detector`
- Source commit: `12534946a5a6cb35e10260702d3765bc86b1931a`
- Publication commit: `13a18d57657ac8c04e17c25adda98ff855b126a8`
- Exact-head CI: `31994181644`, success
- Canonical image: `sha256:fe60560a0d32b9cb6319cc7de7783b13c0caa93f24b33b95fdd143a8593251ac`
- Canonical wheel: `sha256:448368c4cea6a39597e8e97111865c5d6712c62c5a5359e746f65e685ae96e77`

## Proof

- Three independent 2,000-row Docker repetitions.
- Alarm F1, precision, and recall: `1.0`.
- False-positive rate: `0.0`.
- Median detection p95: `35.477515344973654 ms`.
- Correlation-only blind-spot detection: `0.0`, explicitly unscored and documented.
- 48 tests, 91.22% coverage, zero benchmark failures, strict V2 provenance, and the exact non-root default Docker command passed.

## Reuse Promoted

- Hardened `monitoring-batch.schema.json` with model-artifact and validated-input identity.
- Added mirrored `python-model-monitoring` skill.
- Added MLOps pack metrics, artifacts, rejection rules, and model-monitoring guide.

## Next Action

Close #4 `stroke-signal-demo`. Verify the paper target, dataset provenance, patient-level split, leakage controls, held-out confusion matrix, sensitivity/specificity, reproducible model artifact, three-run V2 evidence, and exact-head CI. Do not claim clinical deployment or generalization beyond the reproduced dataset.
