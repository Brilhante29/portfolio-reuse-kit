# Execution Efficiency

Generated: 2026-07-26T03:43:25.4896820Z

Excluded: 2026-07-20, attributed by the user to Antigravity/OpenCode.

Hard limits: **8** | wait timeouts: **13** | avoidable occurrences: **72** | tracked duration: **2940,95 s**

| Category | Event records | Occurrences | Duration (s) |
|---|---:|---:|---:|
| tool-failure | 13 | 23 | 35,2 |
| invalid-command | 12 | 20 | 14,8 |
| wait-timeout | 2 | 13 | 1580 |
| command-timeout | 6 | 10 | 1041,15 |
| authorization-limit | 2 | 8 | 0 |
| invalid-diagnostic | 2 | 7 | 0,8 |
| agent-no-progress | 1 | 3 | 0 |
| redundant-work | 1 | 2 | 269 |

## Prevention Rules

- Accept the first isolated passing test as evidence, avoid repeated equivalent runs, and move cross-platform cache design to a separate kit task.
- Always resolve and use the full commit SHA for local-clone integration.
- Budget repository-wide Git scans from a one-repository timing sample.
- Cap heavy write delegation at two; preflight one writer; finish and validate the producer/API contract before starting consumers; preserve a handoff before limits approach.
- Collect read-only Git snapshots through a bounded cross-version runspace pool.
- Create destination parents for every sparse-overlay copy or use the official full clone after switching to an isolated branch.
- Delegate read-only audits outside writable roots and reserve edits for writable worktrees.
- Emit every accumulated validation failure with ErrorAction Continue, then return exit code 1.
- Fetch the source clone first, then perform ff-only merge or compare FETCH_HEAD.
- Finalize defaults before Docker and verify argument wiring with a tiny smoke workload.
- Inspect disjoint worktrees and wait only when integration is blocked.
- Keep PyYAML parsing in CI and count catalog entries independent of valid sequence indentation.
- Maintain language-specific validation lists and parse generated scripts immediately.
- Negative-test wrappers must fail fast during setup and assert both the expected message and nonzero exit code.
- Never place Markdown backticks inside JavaScript template literals; use plain payload text or structured file patches.
- Normalize source and replacement anchors to LF before delimiter-based edits.
- Normalize text contracts to LF in the generator and compare manifest hashes against staged Git blobs before commit.
- Pilot one agent after writable-scope preflight; keep external-workspace agents read-only and apply changes from the principal agent.
- Pilot one minimal edit and one failing native Git call before applying a workspace-wide script.
- Pilot the patch wrapper once, then use one supported staged edit path without retrying the same failure.
- Prefer a short-path git worktree for local repository isolation on Windows.
- Preflight tracked build caches with git ls-files, reject them in validation, and use a short C:\tmp worktree for cleanup.
- Read PSVersion first and use Stopwatch plus a PowerShell-5.1-compatible runspace pool.
- Read the parameter block before invoking repository scripts and reuse the corrected command.
- Resolve the absolute interpreter once before running tests.
- Resolve the complete pinned validation set in an isolated venv before editing CI requirements.
- Run a one-percent benchmark calibration and estimate the full timeout before the production workload.
- Stage inside one writable worktree and use one supported patch path before starting broad edits.
- Syntax-check generated PowerShell and pilot every inventory transformation on one repository.
- Use a staged single-root edit path and do not retry the same failing tool after the first confirmed platform failure.
- Use Get-Command preflight and call the existing REST client when gh is unavailable.
- Use index-delimited substring replacement for source blocks and parse PowerShell immediately after every generated edit.
- Use one git ls-files and one porcelain-v2 status snapshot per repository, then filter in memory.
- Use ordinary quoted strings or structured items for long agent prompts.
- Use readable multiline diagnostic source and avoid assignment expressions in shell one-liners.
- Use staged files and a 30-second floor for multi-file PowerShell edits.
- Use the approved local-clone path on the first attempt for external repository sources.
- Validate one complete patch on a single file before incremental fan-out.
- Wait once for at most 60 seconds, inspect progress, and take over after two no-progress observations.
