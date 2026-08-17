# Stroke Signal Publication Handoff

## Published State

- Repository: `Brilhante29/stroke-signal-demo`
- Source commit: `ed1c8aee181b195d4aceeba9d08221486ee6b6ba`
- Final commit: `187466c4b47b50a1ebb2491d3ae60c0561aeebd6`
- Exact-head CI: `31998068664`, success
- Canonical image: `sha256:0127593111e44059f0bc358f3eb629ab563ff550faac2765375def485b39f89d`

## Proof

- Three deterministic Docker runs over 30 synthetic patients and 120 slices.
- Patient split `18 / 6 / 6`, zero overlap, validation-only threshold selection, untouched test patients.
- Synthetic Dice `0.9424706943`, sensitivity `0.9047783934`, specificity `0.9997984388`, and accuracy `0.9985577619`.
- Test confusion `TN / FP / FN / TP = 218252 / 44 / 275 / 2613`.
- 21 tests, 97.26% coverage, zero benchmark failures, non-root offline Docker, and strict V2 provenance.

## Scope

This is a paper-inspired synthetic methodology reconstruction, not a clinical reproduction. The private paper dataset and Detectron2 weights are not distributed, and the result does not establish diagnostic performance.

## Reuse Promoted

- Added `medical-evaluation-report-v1` with valid and leakage-invalid fixtures.
- Added central medical evaluation guidance and strengthened the mirrored Codex/Claude skill.
- Closed MLOps and Data Platform at 6/6 without claiming an unimplemented clinical-data integration.

## Next Action

Start Delivery, Observability, and Infrastructure with #24 `ci-cd-templates`; audit its reusable workflow security, deterministic build-time benchmark, V2 provenance, and exact-head CI before editing.
