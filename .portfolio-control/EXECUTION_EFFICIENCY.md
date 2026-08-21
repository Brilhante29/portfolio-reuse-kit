# Execution Efficiency

Generated: 2026-08-21T04:20:20.8190674Z

Excluded: 2026-07-20, attributed by the user to Antigravity/OpenCode.

Hard limits: **8** | wait timeouts: **16** | avoidable occurrences: **130** | tracked duration: **4853,05 s**

| Category | Event records | Occurrences | Duration (s) |
|---|---:|---:|---:|
| invalid-command | 31 | 48 | 199,5 |
| tool-failure | 25 | 39 | 788,2 |
| wait-timeout | 3 | 16 | 1820 |
| command-timeout | 7 | 11 | 1225,15 |
| invalid-diagnostic | 6 | 11 | 52,2 |
| authorization-limit | 2 | 8 | 0 |
| agent-no-progress | 2 | 5 | 170 |
| avoidable-retry | 2 | 4 | 0 |
| environment-fallback | 1 | 3 | 0 |
| invalid-assumption | 2 | 2 | 329 |
| invalid-orchestration | 1 | 2 | 0 |
| redundant-work | 1 | 2 | 269 |

## Prevention Rules

- Accept the first isolated passing test as evidence, avoid repeated equivalent runs, and move cross-platform cache design to a separate kit task.
- After the first split-root failure, create one reviewed patch under the writable root and use git apply --check plus approved git apply, or use an isolated clean worktree with one deterministic editor path.
- Always resolve and use the full commit SHA for local-clone integration.
- Always run git rev-parse HEAD before cross-worktree cherry-pick.
- Budget repository-wide Git scans from a one-repository timing sample.
- Cap heavy write delegation at two; preflight one writer; finish and validate the producer/API contract before starting consumers; preserve a handoff before limits approach.
- Collect read-only Git snapshots through a bounded cross-version runspace pool.
- Create destination parents for every sparse-overlay copy or use the official full clone after switching to an isolated branch.
- Create smoke fixtures under the writable workspace and copy only build, source, Wrapper, Docker, and CI files.
- Delegate one repository with a 60-second evidence checkpoint; take over after two empty waits.
- Delegate read-only audits outside writable roots and reserve edits for writable worktrees.
- Derive an effective configuration from actual command arguments, assert raw work-item counts, and regression-test overrides.
- Detect line endings and tool versions, keep rg arguments native, and enumerate wildcard copies explicitly.
- Detect the file line ending or use a structured serializer; then run git diff --check and inspect the exact diff before commit.
- Emit every accumulated validation failure with ErrorAction Continue, then return exit code 1.
- Fetch the source clone first, then perform ff-only merge or compare FETCH_HEAD.
- Finalize defaults before Docker and verify argument wiring with a tiny smoke workload.
- Give a four-case bounded regression checklist, continue local work, and interrupt once after the first long timeout instead of polling repeatedly.
- Hash fixture, config, and lock inputs from Git blobs at source_commit; regression-test LF/CRLF invariance.
- Ignore generated egg-info, coverage, and cache artifacts while preserving the benchmark clean-tree gate.
- Initialize named evidence and result volumes from directories owned by the runtime UID, then copy artifacts explicitly after the container exits.
- Inspect branch, origin, and upstream together before the first push; set upstream explicitly.
- Inspect disjoint worktrees and wait only when integration is blocked.
- Keep PyYAML parsing in CI and count catalog entries independent of valid sequence indentation.
- List image entrypoints before the first build and copy only the source, tests, contracts, and evidence tools each gate executes.
- Maintain language-specific validation lists and parse generated scripts immediately.
- Make fetch-depth 0 a reusable publication-workflow guard whenever evidence references any commit other than the checked-out head.
- Negative-test wrappers must fail fast during setup and assert both the expected message and nonzero exit code.
- Never place Markdown backticks inside JavaScript template literals; use plain payload text or structured file patches.
- Normalize source and replacement anchors to LF before delimiter-based edits.
- Normalize text contracts to LF in the generator and compare manifest hashes against staged Git blobs before commit.
- Parse project.yaml once with PyYAML and consume the resulting object for manifest decisions and lists.
- Pilot one agent after writable-scope preflight; keep external-workspace agents read-only and apply changes from the principal agent.
- Pilot one minimal edit and one failing native Git call before applying a workspace-wide script.
- Pilot the patch wrapper once, then use one supported staged edit path without retrying the same failure.
- Pipe validator output to Out-Null or use its JSON artifact; never truncate Format-* output with Select-Object.
- Prefer a short-path git worktree for local repository isolation on Windows.
- Preflight tracked build caches with git ls-files, reject them in validation, and use a short C:\tmp worktree for cleanup.
- Probe apply_patch once per worktree; after this known signature, use asserted exact-context transformations and review the resulting git diff instead of retrying.
- Put container validation in a checked-in POSIX script and pilot each dynamic Select-String pattern against a known nonmatching string before repository scans.
- Quote Git revspecs such as '@{upstream}' in PowerShell commands.
- Read parameter ValidateSet values once before recording a batch of execution events.
- Read PSVersion first and use Stopwatch plus a PowerShell-5.1-compatible runspace pool.
- Read requires-python and resolve the project runtime before host-side tests; otherwise validate inside Docker.
- Read Select-String.Line and strip non-digits; do not rerun the full validation suite for diagnostic-only failures.
- Read the parameter block before invoking repository scripts and reuse the corrected command.
- Read the V2 semantic contract before producer code and add a unit assertion that measured_iterations equals domain work items while execution.repeat equals independent runs.
- Resolve the absolute interpreter once before running tests.
- Resolve the complete pinned validation set in an isolated venv before editing CI requirements.
- Retain the offline installed wheel and copy only source, tests, and validation tools needed by container gates.
- Run a one-percent benchmark calibration and estimate the full timeout before the production workload.
- Run bounded help output directly; do not truncate a process whose exit code is part of validation.
- Run evidence aggregation inside the pinned image and keep host PowerShell limited to orchestration.
- Run formatter and check independently; never stash evidence that will be regenerated.
- Run one explicit docker build with plain progress to identify dependency resolution or build progress before retrying the full gate
- Run only the benchmark writer with the Linux host UID/GID, preserve non-root service users, upload smoke evidence, and validate these workflow guards.
- Seed coherence smokes directly from the current Docker and GitHub Actions templates.
- Stage inside one writable worktree and use one supported patch path before starting broad edits.
- Syntax-check generated PowerShell and pilot every inventory transformation on one repository.
- Use ${kumoVersion} in colon-delimited identifiers and inspect semantic fields after schema validation.
- Use a staged single-root edit path and do not retry the same failing tool after the first confirmed platform failure.
- Use absolute Go tool paths in minimal images and reserve race tests for a CGO-capable image or GitHub runner.
- Use actual environment newlines or normalize generated text immediately before validation.
- Use checkout fetch-depth 0 for source-commit verification and run the gate before image build.
- Use deterministic exact replacements, GitHub REST with GH_TOKEN, and inspect script parameters before invocation.
- Use exact-context staged edits, inspect git diff immediately, and keep generated document mutations small.
- Use explicit line-ending normalization plus YAML parsing immediately after generated manifest writes.
- Use explicit string conversion in structured diagnostics and validate against benchmark-result-v2.schema.json.
- Use fetch-depth 0 in publication workflows and enforce that guard in repository validation.
- Use Get-Command preflight and call the existing REST client when gh is unavailable.
- Use index-delimited substring replacement for source blocks and parse PowerShell immediately after every generated edit.
- Use one git ls-files and one porcelain-v2 status snapshot per repository, then filter in memory.
- Use ordinary quoted strings or structured items for long agent prompts.
- Use PowerShell-compatible exit handling in Windows workspace commands and keep shell-specific helpers in the kit.
- Use Promise.allSettled or isolate expected failures from positive gates.
- Use readable multiline diagnostic source and avoid assignment expressions in shell one-liners.
- Use staged files and a 30-second floor for multi-file PowerShell edits.
- Use Test-Path and a dated unique worktree directory before git worktree add.
- Use the approved local-clone path on the first attempt for external repository sources.
- Use the documented PYTHONPATH=src path before rerunning tests
- Use the tested writable-stage plus exact-context transformation path immediately in this Windows workspace.
- Validate one complete patch on a single file before incremental fan-out.
- Wait once for at most 60 seconds, inspect progress, and take over after two no-progress observations.
