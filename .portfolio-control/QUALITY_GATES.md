# Portfolio Quality Gates

The gates below apply to the active project and are updated from command
evidence, not from manifest intent.

- [x] Kit contracts and validators pass.
- [x] Completed #3 local validator passes.
- [x] Completed #3 Docker build passes.
- [x] Completed #3 exact-head remote CI is verified.
- [x] Completed #3 publication benchmark V2 is produced and schema-valid.
- [x] Completed #3 status is promoted to published only after V2 evidence.
- [x] Completed #3 focused release review has no P0/P1 findings.
- [x] Completed #11 local validator passes through Docker.
- [x] Completed #11 Gradle dependency lock is committed and used by Docker.
- [x] Completed #11 three-run publication benchmark V2 is schema-valid.
- [x] Completed #11 exact-head CI and publication evidence are verified.
- [x] Completed #11 focused release review has no P0/P1 findings.
- [ ] Entire portfolio has current verified evidence for every published claim.
- [x] Active #13 local-first/Kumo architecture and provider boundary are reviewed.
- [x] Active #13 local Docker validation, three-run V2 schema, and exact-head source CI pass.
- [x] Active #13 central publication evidence is tied to source/artifact SHA 33387db.
- [x] Generic V2 producer distinguishes measured workload from run repetition and passes seven tests locally.
- [ ] Generic V2 producer exact-head kit CI is green.
- [ ] #13 final metadata status is published and its exact-head CI is green.

## Prohibited Shortcuts

- Do not promote a manifest without current evidence.
- Do not call local benchmark throughput a broker or cloud benchmark.
- Do not record secrets, private reasoning, or stale counts.
- Do not lower a security or contract gate to obtain green CI.