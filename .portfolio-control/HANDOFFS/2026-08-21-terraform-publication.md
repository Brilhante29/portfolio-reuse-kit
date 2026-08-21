# Terraform Publication Checkpoint

## Published project

- Repository: `terraform-aws-baseline` (#27).
- Final main: `32fb845ccb31e1c235f724aa1388b0ee9360fd24`.
- Exact-head CI: `https://github.com/Brilhante29/terraform-aws-baseline/actions/runs/32449453935`.
- Benchmark source: `bd51cd134a4b1c2742bbacfe833bbc4dda9a2db5`.
- Apply median: `11.2674 s`.
- Destroy median: `14.2319 s`.
- Resource parity: `1.0` in `3/3` measured runs.

## Architecture proof

One shared `application-baseline` module declares S3, SNS, DynamoDB, and CloudWatch Logs. `adapters/kumo` owns local endpoints and non-secret credentials; `adapters/aws` owns real provider configuration. Both expose the same outputs. The benchmark starts Kumo, applies, verifies four state resources, destroys, and verifies empty state.

## Reuse promoted

- Contract set `1.8.0` with `terraform-kumo-lifecycle-v1` and negative proof.
- Mirrored `terraform-kumo-lifecycle` skill for Codex and Claude.
- Kumo recommendation updated to `0.28.1` and immutable digest.
- Provider-cache layer rule and explicit compatibility-exception rule.

## Next action

Audit and close #29 `load-test-suite`. Prove a reusable k6 load curve against a controlled real target, with versioned scenarios, threshold failures, coordinated-omission awareness, V2 publication, and exact-head CI.
