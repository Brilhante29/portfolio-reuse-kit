# Current Handoff

Updated: 2026-07-21
Owner: principal agent
Goal: finish the 30-repository portfolio with truthful, reproducible evidence and keep the reuse kit as the decision and continuation brain.

## Current State

- 30 repositories detected; all declare `published`.
- Structural truth: Docker 30/30, CI workflow 30/30, tracked benchmark 22/30, shared benchmark contract 15/30.
- Only 9/30 pass the current local structural gates; 0/30 have verified publication evidence.
- All 30 `published` declarations are currently unverified.
- 20 repositories have no `origin`; none of the 30 has an upstream branch.
- Eight repositories have benchmark JSON only in ignored/local files.
- Fourteen repositories contain stale or placeholder SDD/OpenSpec evidence.
- Credentialed `pushurl` values were removed from six local Git configs. Previously exposed PATs still require revocation in GitHub.

## Audit Verdict

The portfolio has substantial implementation, but it is not 30 finished products. The main defect is claim-to-evidence mismatch: multiple benchmarks are tautological, fixture-only, circular, or do not execute the technology named by the repository. Scaffold uniformity currently exceeds technical reuse and cross-repository integration.

### P0

- `saga-orchestrator`: empty compensation logic and tautological consistency benchmark.
- `multi-tenant-starter`: in-memory maps presented as PostgreSQL/Flyway tenant isolation.
- `outbox-pattern`: no business write and outbox write in one real transaction; failure benchmark is guaranteed by construction.
- `load-test-suite`: required `internal/target` source is ignored, so a clean clone cannot build.
- Security: PATs were stored in local Git push URLs; local copies were removed, remote revocation remains mandatory.

### P1 Programs

- AI Evaluation and Retrieval: only RAG is close to a functional product; Recall@k is wrong in RAG and embeddings, four evaluators measure fixtures/heuristics, and five results break the common contract.
- Applied CV: YOLO is a useful training foundation; serving does not load its artifact, ALPR uses the label as prediction, melanoma is circular synthetic data, and stroke is tabular ML rather than CV.
- Backend Reliability: payments, rate limiter, and Kumo emulator are the strongest components. Event sourcing, saga, multi-tenant, and outbox overstate in-memory demos.
- MLOps/Data/Delivery: repositories are not connected by versioned artifacts; Airflow is not exercised as an orchestrator, CI guardrails report 20 high and 14 medium findings, and several README metrics diverge from tracked baselines.

## Reuse-Kit Changes In Progress

- Add execution-event schema, recorder, and efficiency report.
- Add a permanent handoff contract for any next AI.
- Separate `local_candidate` from `published_verified`.
- Require tracked benchmark JSON and the shared benchmark contract.
- Require upstream plus CI evidence before accepting `published`.
- Add agent preflight, one-agent pilot, 60-second progress gate, benchmark calibration, and static-before-Docker rules.
- Fix publisher validation order and make portfolio reporting consume the same source of truth.

## Efficiency Baseline

Excluded: all work on 2026-07-20, attributed by the user to Antigravity/OpenCode.

- Hard authorization limits: 4.
- Wait timeouts: 11, totaling about 1510 seconds.
- No-progress agents taken over: 3.
- Command timeouts: 4, totaling 226 seconds.
- Redundant expensive runs: 2, totaling 269 seconds.
- Tracked duration lost or consumed by these events: 2005 seconds.
- Exact machine-readable history: `.portfolio-control/EXECUTION_EVENTS.jsonl`.

## Continuation Order

1. Finish and validate the reuse-kit control-plane changes.
2. Commit and push the reuse kit only after `tools/validate-kit.ps1` passes.
3. Downgrade unverified `published` statuses and attach audit verdicts without deleting implementation.
4. Fix P0 security/reproducibility defects first.
5. Repair AI Evaluation and Retrieval as the first macro system: common contracts, correct Recall@k, real embedding model adapter, real tool traces, unbiased prompt evaluation, and cross-repo integration test.
6. Repair the YOLO-to-serving artifact path.
7. Fix backend transactional claims with real local PostgreSQL/Redpanda paths.
8. Connect `data-quality -> feature-store -> mlops -> monitoring-batch -> drift`, then add observability and load tests.
9. Publish only repositories with current-head CI success and store central publication evidence.

## Restart Commands

```powershell
./tools/validate-kit.ps1
./tools/validate-portfolio.ps1 -RepoRoot <portfolio-root> -JsonPath .portfolio-control/portfolio-audit.json
./tools/report-execution-efficiency.ps1
./tools/report-portfolio.ps1 -RepoRoot <portfolio-root> -MarkdownPath .portfolio-control/PORTFOLIO_STATUS.md -JsonPath .portfolio-control/PORTFOLIO_STATUS.json
```

Do not repeat the full structural scan unless repository heads changed. Read the machine reports and this handoff first.