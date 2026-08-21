# Observability Publication Handoff

## Published Project

- Project: `observability-stack` (#25).
- Final `main`: `d332fe943da5a02cdaf75d43c8a648d952997265`.
- Exact-head CI: `32446714093`.
- Canonical source evidence: `2b289f4554d5f976f45d0126816d93490811f34d`.
- Recovery median: `0.1336 s`; detection median: `0.0712 s`.
- Correlation: `1.0` for metrics, traces, and logs across `3/3` runs.

## Runtime Proof

- Fast profile: non-root app, Collector, named evidence/result volumes, and fail-closed benchmark.
- Full profile: healthy Prometheus, Tempo 3, Loki, Grafana, and API.
- Navigation: Prometheus target `up`, trace retrieved from Tempo, lifecycle events retrieved from Loki, and three Grafana datasources plus dashboard provisioned.
- Cloud switch: standard OTLP endpoint; no provider SDK in domain or application code.

## Reuse Promotion

- Kit source commit: `845560aa0f0704e8e8c6f6c4f98ba50d083b12a5`.
- Kit CI: `32446626119`.
- Added `observability-evidence-v1`, positive and negative fixtures, mirrored `observability-evidence-harness` skill, component-pack rules, UID-portable named-volume guidance, and historical-provenance checkout guard.

## Next

Audit and close #27 `terraform-aws-baseline`. Preserve Kumo as the local-first AWS-compatible option, define the actual portability boundary before adding resources, and benchmark reproducible provisioning without requiring cloud credentials.
