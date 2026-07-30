# Portfolio Control

This is the machine-assisted control plane for the 30-repository portfolio. The kit is the source of truth for templates, skills, decisions, validation, and reusable improvements; each project keeps a local snapshot under `.portfolio-control/`.

## Operating Rule

```text
problem -> architecture -> stack/API/messaging/cloud decision -> implementation -> Docker/CI -> benchmark -> independent review -> publication
```

`tools/validate-portfolio.ps1` audits every repository without requiring `rg`. `tools/backfill-project-standard.ps1` materializes the project snapshot, and `tools/new-project.ps1` creates it for new repositories.

The control plane is advisory about architecture and strict about evidence. A repository is not publishable because it has a plausible design; it needs a clean runtime, a green CI path, a reproducible result, aligned documentation, and a recorded reuse review.

## Truthful Status, Handoff, and Efficiency

`tools/validate-portfolio.ps1` reports separate `local_candidate` and `published_verified` states. A benchmark only counts when it is tracked and follows the shared result contract. Publication only counts when the repository has an upstream and central CI evidence for its current commit.

Generate the root state and queue from that audit instead of counting file presence:

```powershell
./tools/checkpoint-portfolio.ps1 -RepoRoot <portfolio-root> -ActiveProject kafka-streams-demo
```

The checkpoint always emits every audited repository. It uses only `published_verified` for `completed`, preserves the existing queue order, places the active project first, and records head, branch, upstream, pending gates, and the exact next action. It also rewrites the legacy `portfolio-control-status.json` with the same verified completion count. A declared `benchmarked` status, Dockerfile, workflow, or arbitrary benchmark JSON can never produce a completed state.

When the active source is a linked worktree instead of the canonical portfolio directory, pass it explicitly:

```powershell
$overrides = @{ 'kafka-streams-demo' = '<worktree-path>' }
./tools/checkpoint-portfolio.ps1 -RepoRoot <portfolio-root> -ActiveProject kafka-streams-demo -RepositoryOverrides $overrides
```

The override must match an existing canonical repository name and point to a Git worktree root. This prevents a stale checkout from replacing current branch, head, benchmark, and remote facts.

Keep `.portfolio-control/CURRENT_HANDOFF.md` current before expensive work or a possible limit. It must contain state, evidence, decisions, commands already run, remaining work, and exact continuation steps.

Record execution friction as it happens:

```powershell
./tools/record-execution-event.ps1 -EventId audit.wait-1 -Phase validation -Category wait-timeout -Outcome recovered -Occurrences 1 -DurationSeconds 60 -Avoidable -Evidence "Worker returned no progress" -Cause "Waited without a progress gate" -Remediation "Inspect after one 60-second wait and take over after two no-progress observations"
./tools/report-execution-efficiency.ps1
```

Windows explicitly attributed to the user or external tools remain in the event history with `excluded_from_efficiency=true`; they do not alter the Codex score.

After pushing and after Actions completes, collect current-head evidence:

```powershell
./tools/verify-github-publication.ps1 -RepoRoot <portfolio-root>
```

Publication candidates must validate their declared primary `benchmark.result_path` against `contracts/benchmark-result-v2.schema.json`, including direction, samples, failures, clean source provenance, fixture digest, and immutable image digest.
