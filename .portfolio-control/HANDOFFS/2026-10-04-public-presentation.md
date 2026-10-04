# Public Presentation Pass: 2026-10-04

Status: squash-merged to `main` in every touched repository (37 product repositories, the kit, and the profile repository); `main` CI passed on every merged head, and the central publication records point at those heads.
Request: make every repository ready to be presented from the author's LinkedIn and GitHub profile.

## What changed

- **README standard (patch_now in the kit).** Public READMEs open with a descriptive title instead of the internal `#<id>`, keep the primary value in the first eight lines, and add: why the project exists, how to read the result, design decisions with rejected alternatives, limitations, project structure, how the repository is built (spec-driven, AI-assisted, human-governed), related work, author links, and license. Kit updates: `templates/README-project.md`, `templates/validate-project.ps1`, `design-system/tokens.yaml` (regenerated artifacts), kit `README.md`, `templates/AGENTS.md`, `templates/portfolio-control/QUALITY_GATES.md`, `sdd/templates/spec.md`, the `design-system` and `portfolio-project` skills (Codex and Claude), and the Next.js scaffold test. Internal control documents keep `#<id>`.
- **32 product READMEs rewritten** under that standard. Six product validators that pinned `#<id>` titles now require the descriptive title with the same strictness: event-sourcing-orders, api-gateway-lite, grpc-vs-rest-bench, load-test-suite, portfolio-evidence-api, portfolio-evidence-console, plus kafka-streams-demo on its main line.
- **30 LICENSE files** now name the holder as "Guilherme Brilhante" instead of "Guilherme"; vision-serving-fastapi's AGPL notice named the wrong project.
- **Defects fixed:**
  - portfolio-evidence-api and portfolio-evidence-console: `main` CI red since 2026-09-15 because `reuse.manifest.yaml` failed `prettier --check`; reformatted (parsed YAML identical).
  - embeddings-benchmark: the image build fetched upstream `main` for `qdrant/bge-small-en-v1.5-onnx-q`, which drifted from the lock; the prefetch now downloads the locked commits and pins `refs/main` (merged; `main` CI green).
  - kafka-streams-demo and mlops-end2end: branches were cut from stale default branches; mlops merged `main`; kafka adopted `main`'s tree in a merge commit (`ours` strategy plus `read-tree`), so obsolete diagnosis commits remain in branch history. Both were squash-merged, so `main` carries one commit each.
- **Legacy repositories outside the kit:** lightpanda-mcp-server (host code execution through interpolated JavaScript, shell injection in the Node shim, CDP daemon on 0.0.0.0, unpublished npm/PyPI claims) rebuilt as one safe Go server with tests and CI; llm-based-doc-scan (raw HTML from model output, wrong Compose commands, Python 3.9, unpinned dependencies) restructured with tests, pinning, and CI; fastapi_with_mqtt (paho-mqtt 2 break, destructive Docker cleanup script, committed pickles, logs, and bytecode) rebuilt with tests, build-time training, honest chronological evaluation, and CI; kiri-aws now credits sivchari/kumo near the top and drops a personal `opencode.json` and an inherited upstream note; kiri-gcp, which leads the profile, failed its own README snippets with the official clients: the Go example and its test used a bare-host endpoint (405), Python downloads and Node.js simple uploads failed, resumable uploads and object checksums did not exist, and the examples module never ran in CI. Cloud Storage now passes the Go, Python, and Node.js clients end to end (resumable sessions, `?name=` override, JSON API download path, MD5/CRC32C, bucket ids), CI runs the official Go client checks, and the README gained a Fidelity section measured from the code (55 typed services, 53 generic resource stores, BigQuery placeholder query, Firestore gRPC without `Commit`). Yolo-v8-avc-detect-and-segmentation (private, empty) was left untouched.
- **Profile README** (`Brilhante29/Brilhante29`): selected work, a portfolio map by track, and the build approach.

## Merge-time fixes

Merging surfaced the defects below. The three advisory fixes cover advisories published after the last green `main` runs (2026-09-15), so `main` would have failed the same gates without any change. No fix lowered a gate or touched historical benchmark evidence:

- portfolio-evidence-console: GHSA-vcvr-r3jv-pc5j, a critical remote code execution in `next/og` `ImageResponse` (Next.js 16.2.0 to 16.3.5); `next` and `eslint-config-next` pinned to 16.3.8, production audit at 0.
- portfolio-evidence-api: 27 advisories at the high audit threshold; fastify 5.12.5, fast-uri 3.1.8, js-yaml 4.3.2, and brace-expansion, with an `overrides` entry so `@nestjs/platform-fastify` uses the patched top-level fastify. One moderate vitest advisory needs a major upgrade and stays below the threshold.
- kafka-streams-demo: jackson-core and jackson-databind 2.21.4 (five HIGH CVEs) raised to 2.21.7 through the pinned BOM and a regenerated lock; the runtime base `eclipse-temurin:21-jre` carried OpenSSL 3.5.5-1ubuntu3.2 (CVE-2026-84782, HIGH), so its digest pin moved to the current upstream index with OpenSSL 3.5.5-1ubuntu3.7 and Temurin 21.0.12.1, verified from the image's dpkg status. The base stays pinned by digest; no `apt-get upgrade`.
- ci-cd-templates: `tools/validate-publication.py` compared a CRLF-hashed digest with the LF bytes Git stores, so it failed on every Linux checkout; it now accepts either line ending of the same content, and a changed byte still fails.
- fastapi_with_mqtt (after merge, #2): Dependabot's dependency-graph job on `main` failed with `Could not open requirements file: requirements.lock`, because Dependabot fetches only `.txt` and `.in` requirement files and the rebuilt `requirements-dev.txt` and `requirements-notebook.txt` included the lock with `-r`. They now list only their extra packages, and CI and the README install the lock next to them, which resolves the same set.
- observability-stack (pre-existing, open): the same Dependabot job has failed since 2026-08-21 on `-c constraints.lock` in `requirements.txt`, so its pip dependency graph stays empty. `main` CI is green. Renaming the constraints file touches the dependency-lock provenance, so it was left for a scoped change.

## Verification

- README guard (portfolio validator rules plus per-repository exact-value rules), Python publication validators, and full `validate-project.ps1 -SkipDocker` where toolchains allowed (stroke, drift, event-sourcing, gateway, grpc, load-test, kafka, evidence API and console).
- Branch CI green on GitHub for all pushed repositories whose workflows run on feature branches (alpr, melanoma, yolo, vision, rag, llm-eval, llm-agent, prompt-ab, embeddings, cost-aware).
- Local evidence: kit validation and 21 tests; kafka Gradle `check`; evidence API `npm run check` (35 tests); lightpanda `go test -race`; doc-scan tests plus a Streamlit start on the locked dependencies; MQTT gateway tests plus an end-to-end run against a real Mosquitto broker.
- kiri-gcp: `go test -race ./...`, `golangci-lint run` (0 issues), the examples module with cloud.google.com/go/storage 1.68 (including a chunked resumable upload), and live checks with the Python (storage, Pub/Sub sync and streaming pull) and Node.js (simple and resumable) clients. Pull request and `main` CI passed, including the official Go client checks from the examples module.
- Not run locally: Docker builds that need apt or module downloads inside containers (proxy limits); these run in CI.
- After merge: `main` CI passed on the exact merged head of every repository; the run of record for each governed repository is in `.portfolio-control/publications/`. `validate-portfolio.ps1` over the 32 governed checkouts aligned to `origin/main`: 32/32 Docker, CI, tracked benchmarks, V2 contracts, local and publication candidates, and published and verified.

## Required follow-up

1. Switch the GitHub default branch to `main` for mlops-end2end (`agent/complete-mlops-end2end`) and kafka-streams-demo (`agent/sync-agent-contract`); visitors currently see stale READMEs. The available GitHub tooling cannot change repository settings.
2. Sync the updated skills and validator template into product repositories with `tools/sync-project-reuse.ps1` when convenient.
3. kiri-gcp next depth: Firestore gRPC `Commit`, `BatchGetDocuments`, and `RunQuery`; a real BigQuery query path or an explicit error; re-grade the 12 generic-store services whose `Meta()` declares fidelity A or B (they surface through `--fidelity`).
4. Run kiri-aws through the same official-client check before featuring it.
5. The merged `ccr-447647b4-ma4w79` branches remain on GitHub; the squash commits on `main` contain all their changes, so they can be deleted.

## Reuse improvement review

| Finding | Classification | Action |
|---|---|---|
| Public README standard (descriptive title, why, limits, author) | patch_now | Applied in the kit as listed above |
| Generated `reuse.manifest.yaml` must pass Prettier in Node repositories | backlog | Format manifests in the generator or exclude them in `.prettierignore` |
| Default branch drift is invisible to `validate-portfolio.ps1` | backlog | Add a default-branch equals `main` check |
| Model artifacts should be fetched by locked revision, not verified after fetching `main` | backlog | Promote the embeddings prefetch pattern to the computer-vision and AI-evidence skills |
| A README compatibility claim with no real-client test in CI shipped broken (kiri-gcp) | patch_now | `templates/portfolio-control/QUALITY_GATES.md` now requires a CI test that drives the real client for every SDK, CLI, or protocol claim |
| `plan-project.ps1` article titles still use `#<id>` | reject for now | Internal drafts; revisit if articles become public posts |
| A requirement file that includes a non-`.txt` file (`-r requirements.lock`, `-c constraints.lock`) breaks Dependabot's pip dependency graph, and the failure appears only as a Dependabot run, not in CI | backlog | Python templates keep lock includes out of requirement files (install the lock explicitly) or name the lock `*.txt`; fix observability-stack without changing its recorded lock digest semantics |
| Advisories published after the last green runs failed the security gates of three repositories, and this surfaced only when the next pull request ran (Next.js, fastify, Jackson, OpenSSL in a digest-pinned base) | backlog | Add a weekly `schedule:` trigger to the CI templates so dependency and image scans run on `main` without waiting for a change; refresh pinned base digests through a reviewed pull request gated by the same scan |
