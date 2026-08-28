# Portfolio Evidence API Publication

Date: 2026-08-28

## Result

- Extension #31 `portfolio-evidence-api` is published at
  `88fa375de0abe7e4a93d427928016f6d4b0b8bfa`.
- Exact-head CI passed:
  https://github.com/Brilhante29/portfolio-evidence-api/actions/runs/33205651604
- Canonical Desktop checkout is clean and aligned with `origin/main`.
- Portfolio count is 30 original repositories plus one completed extension.

## Evidence

- 35 tests.
- Coverage: 93.05% statements/lines, 89.4% branches, 100% functions.
- V2 benchmark: ingestion p95 40.201 ms, 438.148 requests/second,
  GraphQL p95 24.119 ms, zero workload failures.
- CI passed dependency advisories, project policy, Docker build, health smoke,
  and Docker calibration without the deprecated action-runtime warning.

## Reuse Delta

- `templates/validate-project.ps1` and `tools/validate-kit.ps1` use literal
  path strings instead of optional `FileInfo` materialization.
- `harness/node/npm-advisory-audit.mjs` contains the remote-proven generic npm
  advisory transport with deterministic Node tests.
- PostgreSQL, brokers, Kumo, and AWS remain conditional because #31 has no
  measured problem force requiring them.

## Continuation

#32 `portfolio-evidence-console` is the next eligible repository. It consumes
read-only GraphQL and shared design tokens; audited commands remain REST and
belong to #33 workflows.
