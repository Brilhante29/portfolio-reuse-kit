# ALPR Publication And MLOps Transition

- Published: `alpr-mercosul` head `b69ae1d1c3ada4c6aa94b30e51b4404aa89e0a11`.
- CI: run `30778498303`, all steps passed.
- Benchmark: 100 synthetic plates, 700 characters, 1.0 character and plate accuracy, zero failures.
- Integrity fix: ground-truth oracle removed; prediction receives image pixels only.
- V2: 100 measured iterations with clean source and immutable runtime image.
- Next: `mlops-end2end` at clean head `ae7d1e0`.
- Defects: benchmark bypasses Airflow task execution; three-run publication evidence is missing.
