# Portfolio Quality Gates

The gates below apply to the active project and are updated from command
evidence, not from manifest intent.

- [x] Kit contracts and validators pass.
- [x] Completed #3 local validator passes.
- [x] Completed #3 Docker build passes.
- [x] Completed #3 exact-head remote CI is verified.
- [x] Completed #3 publication benchmark V2 is produced and schema-valid.
- [x] Completed #3 status is promoted to `published` only after V2 evidence.
- [x] Completed #3 focused release review has no P0/P1 findings.
- [ ] Entire portfolio has current verified evidence for every published claim.
- [ ] Active #11 local validator, Docker, benchmark, and publication gates.

## Prohibited Shortcuts

- Do not promote a manifest without current evidence.
- Do not call local benchmark throughput a broker or cloud benchmark.
- Do not record secrets, private reasoning, or stale counts.
- Do not lower a security or contract gate to obtain green CI.