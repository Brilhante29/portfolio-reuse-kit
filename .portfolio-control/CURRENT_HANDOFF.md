# Current Handoff

Updated: 2026-08-03
Owner: principal agent
Purpose: observable state for Codex, Claude Code, another AI, or a human. No private chain-of-thought is stored.

## Continuation Order

1. Read `docs/agent-continuation-map.md`.
2. Read `.portfolio-control/TRACKER.json` and `.portfolio-control/PROJECT_QUEUE.md`.
3. Inspect Git status, project manifest, SDD, benchmark, Docker, and CI before editing.
4. Execute one critical-path change, validate it, and refresh this handoff.

## Current Truth

| Scope | State | Evidence |
|---|---|---|
| Portfolio | 30 repositories | 30 Docker, 30 CI, 30 tracked benchmark contracts |
| Published | #3, #5, #11, #13, #21 | exact-head CI and central publication JSON |
| Reuse kit | proven implementation head `129d9b6` | CI `30782110254`; all 12 steps passed |
| Active | #24 `ci-cd-templates` at clean head `141173e` | deterministic V1 scanner; V2 absent |
| Blocking defects | none external | #24 requires audit and publication upgrade |

## Closed: #21 mlops-end2end

- Final head `fb778279f4462f7f478dc34da87c5d2559d4fd5a`; exact-head CI `30781190229`, every step passed.
- Three clean source-image runs: `57.373 s`, `59.140 s`, and `58.696 s`; median `58.696 s`.
- Median ROC AUC `0.928`, accuracy `0.87`, inference p95 `72.733 ms`, throughput `160.275 req/s`.
- Airflow evidence uses `airflow dags test`; MLflow uses direct local SQLite tracking/registry; FastAPI serves the registry alias.
- Source image digest: `sha256:5228391a3b888a26c0fa5263d5a2393694ee6f862a80e48d7839ad22a2fb541f`.
- Generic return to kit: tracked provenance inputs are hashed from source-commit Git blobs; CI fetches source history and runs the provenance gate before expensive builds.

## Active: #24 ci-cd-templates

Known baseline: Python/PyYAML policy pipeline, optional pinned actionlint/zizmor adapters, Docker, GitHub Actions, deterministic fixtures, median scan-time V1.

Audit order:

1. Trace README claim through CLI, policy engine, external-tool adapters, tests, Docker, and workflow.
2. Verify the seven findings are semantic and not fixture-oracle shortcuts.
3. Decide whether the generic single-result V2 producer is sufficient; use project-specific aggregation only if three independent samples are part of the claim.
4. Add provenance, strict validation, current README number, and exact-head CI.
5. Return only generic CI/evidence improvements to the kit.

## Safety

- Do not add services, databases, messaging, cloud, or Kubernetes to a static-analysis CLI.
- Hash versioned fixture/config/lock inputs from Git blobs, not CRLF/LF-sensitive checkout bytes.
- Preserve two known timestamp-only dirty files in `rag-knowledge-base`.
- Never store credentials or private reasoning. Rotate tokens pasted in conversation.

## Exact Next Commands

```powershell
cd $HOME\Desktop\repos-github\ci-cd-templates
git status --short --branch
rg -n "scan_time_ms|findings|benchmark|actionlint|zizmor|validate" src tests tools .github sdd README.md
docker build -t ci-cd-templates .
```