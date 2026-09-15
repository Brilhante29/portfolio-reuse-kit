# Portfolio Audit: 2026-09-14

Status: economical close-out requested by the user. No claim of all-clear.

## Scope and Evidence

- Existing portfolio: 32 products, plus the reuse kit; extension #33 remains planned.
- Canonical repos: `repos-github` under the user's Desktop.
- Active kit: `reuse-kit-aligned-checkpoint` under the current Codex workspace.
- Desktop kit's existing work branch and untracked scan-image-security.sh remain untouched.
- Initial remote audit: 31/32 main CIs successful, mini-aws-emulator failed only its README primary-value check.
- Seven recorded product SHAs lagged main: gateway, llm-eval, mini, mlops, rag, spring, stroke.
- All 32 product checkouts aligned to origin/main with fast-forward only; old work branches retained.
- Twenty-three old security-report directories retained pending archival, never silently deleted.

## Ownership

Principal: reuse-kit validator/security harness, mini README, and shared base fixes
for cost, prompt, llm-agent, llm-eval, data-quality, feature-store, drift,
observability, rag, stroke, ci-cd-templates.

Go specialist: gateway, limiter, grpc/rest, mini runtime, load-test, terraform.
Python specialist: alpr, melanoma, vision-serving, yolo, embeddings, mlops.
Remaining specialist: seven JVM repositories and evidence API/console.

Specialists write handoffs in workspace `tmp/`; the principal reviews, commits,
publishes, and records exact-head CI. No force pushes or deletion of prior work.

## Reuse Improvements

`tools/scan-image-security.py` always rebuilds and scans the immutable local
image ID. It rejects malformed or wrong-image reports and distinguishes fixable
severe findings from unpatched findings. Seven policy tests cover fail-closed
behavior. Documentation: `docs/container-security.md`.

`tools/validate-portfolio.ps1` replaces one Git process per SDD/OpenSpec document
with one committed-content search per repository. Regression tests cover dirty
worktrees, multiple placeholders on one line, descriptive H1 titles, and absent
primary benchmark numbers. First optimized run: 18.85 seconds. The earlier
approximately 40-second observation was a single run, not a controlled benchmark.

The final structural audit passed 32/32 in 13.14 seconds after per-SHA blob
caching. These are local observations, not a cross-machine performance claim.

## Security Evidence Rules

New Python base: 3.12.14 slim-trixie, pinned official digest, with distribution
security upgrades because the current official image still had fixable packages.
The first rebuilt llm-eval image reports zero fixable HIGH/CRITICAL findings and
44 unpatched HIGH/CRITICAL findings. It is review-required, not vulnerability-free.

Existing performance evidence remains source-locked and immutable. A patched
runtime is not automatically claimed to reproduce an older performance number.
No historical benchmark JSON may be changed merely to pass validation.

## Close-Out

Published corrections in 20 product repositories: alpr, gateway, ci-cd, cost,
data-quality, embeddings, feature-store, grpc, kafka status, llm-agent, llm-eval,
load-test, melanoma, mini README, mlops, drift, observability, prompt, stroke,
and Terraform README/heading validation. Seventeen updates change runtime or
dependencies; three only align metadata/documentation. See the exact names,
SHAs, CI runs and pending files in `../audit-close-2026-09-14.json`.

Seven worktrees preserve unpublished changes: go-rate-limiter, mini-aws-emulator,
portfolio-evidence-api, rag-knowledge-base, terraform-aws-baseline,
vision-serving-fastapi, and yolo-training-pipeline. Do not bulk-stage or discard
them. The current workspace's `tmp/close-audit/wip` contains tracked patch
backups; original untracked files and old security reports remain in place.

Remaining JVM work: current source/image checks confirmed severe dependencies
in payments, cache, event-sourcing, saga, outbox, and multi-tenant. Kafka's current
image scan found zero severe issues. The evidence API lockfile correction is
unpublished and still needs final tests/runtime validation. The evidence console
has unresolved base/bundled-npm findings. These are not cleared by green CI.

RAG's candidate image tests lack the `httpx2` package required by its currently
resolved Starlette TestClient. Five retrieval tests ran, but the API test module
did not import. Its Dockerfile update remains unpublished; fix the test lock and
run the existing tests before publication. Do not claim the six-test run passed.

The final MLops candidate scan had zero fixable severe findings but 135 severe
findings without a reported fix. Python slim candidate images generally retained
44 unpatched severe findings. All such results remain review-required.

## Efficiency and Limit Record

One account-wide quota event produced three specialist termination notifications;
no specialist was restarted. Avoidable overhead in this audit: one Trivy shared
filesystem-cache timeout (fixed with the documented in-memory analysis cache),
excess concurrent builds (reduced), a transient data-quality dependency-resolution
failure (isolated download and one successful retry), and the Terraform README
validator omitted from the first scoped heading commit (corrected separately).
Do not count these as additional quota events or retry the quota boundary.

## Resume Only When Requested

1. Read the saved specialist handoffs and inspect the seven unpublished diffs.
2. Finish one repository at a time, reusing existing images and test evidence.
3. Address the confirmed JVM vulnerabilities with tested, minimal dependency updates.
4. Publish only verified changes and update exact-head CI evidence.
5. Never label no-fix findings or historical benchmark images as security-cleared.
