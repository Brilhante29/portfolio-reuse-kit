# Kumo Publication Checkpoint

Date: 2026-08-02
Project: `mini-aws-emulator` (#13)
Outcome: published and centrally verified

## Evidence

- Benchmark source commit: `33387dbf8c31206bcc5fed4ed8ae8533d27c8fb8`.
- Benchmark-source CI: `30772714926`.
- Final metadata commit: `8d3a4f7813b16bb61f9fbbfea19e7e6b41a5abbb`.
- Final exact-head CI: `30774984792`.
- V2 result: 100 percent scoped conformance, median p95 `1.704 ms`, mean `764.682 ops/s`, three runs, zero failed operations.
- Local gate: project validator, Go test/vet/coverage through Docker, Docker build, schema, README, and secret scan passed.

## Reuse Delta

- The project exposed a semantic defect in generic V2 workload sizing.
- Kit commit `6f557a0` separates measured iterations from execution repetition and adds seven unit tests plus matching Codex and Claude skills.
- Kit commit `16a3622` validates publication facts from committed `HEAD` while preserving dirty-worktree visibility.
- Kit exact-head CI `30774849915` passed every step.

## Rejected

- Treating three Kumo samples as generic single-result evidence.
- Treating repeat count as measured operations.
- Moving S3, SQS, DynamoDB, or Kumo-specific aggregation into the shared kit.
- Treating local Kumo latency as an AWS production result.

## Next Action

Repair `alpr-mercosul` V2 workload semantics: verify the 100-plate loop, regenerate evidence with 100 measured iterations, run Docker validation, and require exact-head CI before closing the defect family.
