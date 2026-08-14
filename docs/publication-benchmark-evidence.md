# Publication Benchmark Evidence

A V2 result is publication evidence, not a formatting upgrade from V1. The producer must execute the workload and preserve enough provenance to reproduce and compare the claim.

## Semantic Contract

| Field | Meaning |
|---|---|
| `execution.repeat` | Number of independent command repetitions represented by the artifact. |
| `workload.measured_iterations` | Work items measured in one repetition, such as queries, images, plates, rows, requests, or operations. |
| `metrics[].samples` | Raw observed metric values used by the stated aggregation. |
| `provenance.source_commit` | Clean source commit captured before execution. |
| `workload.fixture_digest`, `workload.config_digest`, `provenance.dependency_lock_digest` | SHA-256 of canonical Git blobs at the source commit, independent of checkout line endings. |
| `provenance.artifact_digest` | Digest of the raw V1 result consumed by the producer. |
| `comparability_key` | Stable workload/runtime/provider identity; never a free-form run label. |

`repeat` is not workload size. A run that evaluates 100 plates once has `execution.repeat=1` and `workload.measured_iterations=100`.

## Producer Selection

Use `tools/generate-publication-benchmark.py` for a single V1 `metric`/`value` result whose workload count is explicit. Pass `--measured-iterations` when the V1 file does not expose an unambiguous count.

Every project keeps `benchmarks/publication-spec.json` as the machine-readable bridge between V1, V2, README and `project.yaml`. Set optional `v1_project` only when a legacy raw result uses an older identifier such as a numeric prefix; V2 always uses the canonical repository name. `tools/validate-publication.py --require-git` verifies raw/V2 agreement and hashes fixture, configuration and lock inputs from source-commit Git blobs.

Keep a project-specific V2 producer when the publication claim needs:

- three or more independent repetitions with a documented aggregation policy;
- multiple metrics or metric-specific samples;
- provider diagnostics such as a pinned Kumo digest;
- domain-specific failure accounting;
- provenance beyond the common source/image/dependency/input fields.

Project-specific producers still validate against `contracts/benchmark-result-v2.schema.json` and use the exact-head publication verifier.

## Generic Command

    python tools/generate-publication-benchmark.py \
      --repo . \
      --project <name> \
      --benchmark-id <stable-id> \
      --image <local-image-tag> \
      --v1-result benchmarks/results/<raw>.json \
      --fixture <fixture-path> \
      --config <config-path> \
      --lock <dependency-lock-path> \
      --output benchmarks/publication/<name>-v2.json \
      --measured-iterations <work-items> \
      --direction <higher_is_better|lower_is_better|target> \
      --runtime <runtime> \
      --comparability-key <stable-key> \
      -- <benchmark-command>

The repository must be clean before the command. Inputs and outputs must remain inside the repository. Fixture, config, and dependency-lock digests come from canonical Git blobs at the source commit, so CI must fetch that commit; the generated raw artifact is hashed from its actual output bytes. The image must already exist locally and is captured by immutable digest. Use `--from-container name:/path` for a non-root container and `--timeout-seconds` to bound the run.

## Publication Gates

1. Execute from a clean source commit.
2. Preserve the raw result and V2 artifact.
3. Validate the artifact against the V2 schema.
4. Inspect workload size, samples, aggregation, units, provider mode, and comparability key.
5. Match README, manifest, SDD, and OpenSpec to the committed result.
6. Push without force and verify GitHub Actions on the exact evidence SHA.
7. Store the publication evidence JSON in the project and central control plane.

Schema validity alone does not prove semantic validity.

For a published repository, `benchmark.result_path` may point directly to V2. The portfolio validator recognizes either legacy V1 or V2 as the canonical result and treats a separate `publication_result_path` as backward-compatible metadata.

For a repository already marked `published`, central validation reads the committed Git `HEAD` for the manifest, README, benchmark artifacts, and placeholders. Uncommitted local files remain visible through `dirty_files` but cannot rewrite or revoke exact-head remote evidence. A `benchmarked` publication candidate still requires a clean working tree.

## Stable Publication And CI Smoke Evidence

The canonical result named by `project.yaml` is stable publication evidence. Validate its README metric, schema, and provenance before starting a variable CI smoke benchmark.

A CI smoke run must write to a different path, such as `benchmarks/results/<benchmark>-ci-smoke.json`, and upload that file as a workflow artifact. Validate the smoke file independently for schema, source SHA, workload, failure gates, and infrastructure participation. Do not overwrite the canonical result and then compare its runner-specific latency with static README text.

On Linux, a short-lived benchmark writer that targets a bind-mounted host directory must use the host UID/GID or an explicit equivalent ownership setup. Keep service containers on their declared non-root image users. This makes artifact writes portable without broadening runtime privileges.

## Effective Workload Overrides

Runtime overrides are part of the measured configuration. When a smoke run changes rows, requests, duration, repetitions, concurrency, or provider, the producer must derive an effective workload from the executed arguments and encode it in `workload`, `comparability_key`, and `workload.config_digest`. It must also assert that the raw result reports the requested work item count.

Never copy canonical workload values into a smaller CI smoke artifact. The canonical and smoke runs can share a schema and producer, but they are not comparable unless their effective workload identity matches.

For Python repositories that install with `pip install -e`, generated `*.egg-info/`, coverage files, and caches must be ignored before the clean-tree benchmark gate runs. Preserve the clean-tree gate because it protects provenance; generated installer metadata is the item to isolate.
