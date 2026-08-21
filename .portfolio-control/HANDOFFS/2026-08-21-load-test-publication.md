# Load Test Publication Handoff

- Project: #29 `load-test-suite`.
- Source SHA: `3146602070006665950e42aeddc5aca19a8670db`.
- Final SHA: `b2e976f7153b9746bd7a41727cd03c8e788c20d3`.
- Exact-head CI: `32451206733`.
- V1: `benchmarks/results/29-p95-curve-v1.json`.
- V2: `benchmarks/publication/29-p95-curve-v2.json`.
- Primary result: `15.14099235 ms` median p95 at 20 VUs.
- Samples: `14.9140293`, `15.14099235`, `15.2416762` ms.
- Volume/failures: 41,234 requests, zero errors.
- Image: `sha256:64f9c11c4de6a65cde252ccbb959091dd9b55e089e8c2499c070e14912af34f6`.
- Known limit: local controlled target; no distributed or cloud-capacity claim.
- Reuse: `k6-load-curve-v1`, tested aggregator, and mirrored `k6-load-evidence` skills.
- Next action: none for the original 30.
