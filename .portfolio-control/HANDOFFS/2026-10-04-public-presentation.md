# Public Presentation Pass: 2026-10-04

Status: changes pushed to branch `ccr-447647b4-ma4w79` in every touched repository; nothing merged to `main`.
Request: make every repository ready to be presented from the author's LinkedIn and GitHub profile.

## What changed

- **README standard (patch_now in the kit).** Public READMEs open with a descriptive title instead of the internal `#<id>`, keep the primary value in the first eight lines, and add: why the project exists, how to read the result, design decisions with rejected alternatives, limitations, project structure, how the repository is built (spec-driven, AI-assisted, human-governed), related work, author links, and license. Kit updates: `templates/README-project.md`, `templates/validate-project.ps1`, `design-system/tokens.yaml` (regenerated artifacts), kit `README.md`, `templates/AGENTS.md`, `templates/portfolio-control/QUALITY_GATES.md`, `sdd/templates/spec.md`, the `design-system` and `portfolio-project` skills (Codex and Claude), and the Next.js scaffold test. Internal control documents keep `#<id>`.
- **32 product READMEs rewritten** under that standard. Six product validators that pinned `#<id>` titles now require the descriptive title with the same strictness: event-sourcing-orders, api-gateway-lite, grpc-vs-rest-bench, load-test-suite, portfolio-evidence-api, portfolio-evidence-console, plus kafka-streams-demo on its main line.
- **30 LICENSE files** now name the holder as "Guilherme Brilhante" instead of "Guilherme"; vision-serving-fastapi's AGPL notice named the wrong project.
- **Defects fixed:**
  - portfolio-evidence-api and portfolio-evidence-console: `main` CI red since 2026-09-15 because `reuse.manifest.yaml` failed `prettier --check`; reformatted (parsed YAML identical).
  - embeddings-benchmark: the image build fetched upstream `main` for `qdrant/bge-small-en-v1.5-onnx-q`, which drifted from the lock; the prefetch now downloads the locked commits and pins `refs/main` (branch CI green; `main` will fail on its next run until merged).
  - kafka-streams-demo and mlops-end2end: branches were cut from stale default branches; mlops merged `main`; kafka adopted `main`'s tree in a merge commit (`ours` strategy plus `read-tree`), so obsolete diagnosis commits remain in branch history. Prefer squash merge.
- **Legacy repositories outside the kit:** lightpanda-mcp-server (host code execution through interpolated JavaScript, shell injection in the Node shim, CDP daemon on 0.0.0.0, unpublished npm/PyPI claims) rebuilt as one safe Go server with tests and CI; llm-based-doc-scan (raw HTML from model output, wrong Compose commands, Python 3.9, unpinned dependencies) restructured with tests, pinning, and CI; fastapi_with_mqtt (paho-mqtt 2 break, destructive Docker cleanup script, committed pickles, logs, and bytecode) rebuilt with tests, build-time training, honest chronological evaluation, and CI; kiri-aws now credits sivchari/kumo near the top and drops a personal `opencode.json` and an inherited upstream note; kiri-gcp gained author links. Yolo-v8-avc-detect-and-segmentation (private, empty) was left untouched.
- **Profile README** (`Brilhante29/Brilhante29`): selected work, a portfolio map by track, and the build approach.

## Verification

- README guard (portfolio validator rules plus per-repository exact-value rules), Python publication validators, and full `validate-project.ps1 -SkipDocker` where toolchains allowed (stroke, drift, event-sourcing, gateway, grpc, load-test, kafka, evidence API and console).
- Branch CI green on GitHub for all pushed repositories whose workflows run on feature branches (alpr, melanoma, yolo, vision, rag, llm-eval, llm-agent, prompt-ab, embeddings, cost-aware).
- Local evidence: kit validation and 21 tests; kafka Gradle `check`; evidence API `npm run check` (35 tests); lightpanda `go test -race`; doc-scan tests plus a Streamlit start on the locked dependencies; MQTT gateway tests plus an end-to-end run against a real Mosquitto broker.
- Not run locally: Docker builds that need apt or module downloads inside containers (proxy limits); these run in CI.

## Required follow-up

1. Switch the GitHub default branch to `main` for mlops-end2end (`agent/complete-mlops-end2end`) and kafka-streams-demo (`agent/sync-agent-contract`); visitors currently see stale READMEs.
2. Review and merge the branches (squash recommended), then refresh the central publication records: every merged README change moves `main` away from the recorded publication SHA.
3. Sync the updated skills and validator template into product repositories with `tools/sync-project-reuse.ps1` when convenient.

## Reuse improvement review

| Finding | Classification | Action |
|---|---|---|
| Public README standard (descriptive title, why, limits, author) | patch_now | Applied in the kit as listed above |
| Generated `reuse.manifest.yaml` must pass Prettier in Node repositories | backlog | Format manifests in the generator or exclude them in `.prettierignore` |
| Default branch drift is invisible to `validate-portfolio.ps1` | backlog | Add a default-branch equals `main` check |
| Model artifacts should be fetched by locked revision, not verified after fetching `main` | backlog | Promote the embeddings prefetch pattern to the computer-vision and AI-evidence skills |
| `plan-project.ps1` article titles still use `#<id>` | reject for now | Internal drafts; revisit if articles become public posts |
