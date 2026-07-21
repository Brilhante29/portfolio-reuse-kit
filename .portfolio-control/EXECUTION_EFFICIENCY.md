# Execution Efficiency

Generated: 2026-07-21T18:10:38.9984145Z

Excluded: 2026-07-20, attributed by the user to Antigravity/OpenCode.

Hard limits: **4** | wait timeouts: **11** | avoidable occurrences: **37** | tracked duration: **2005 s**

| Category | Event records | Occurrences | Duration (s) |
|---|---:|---:|---:|
| wait-timeout | 1 | 11 | 1510 |
| invalid-command | 2 | 7 | 0 |
| invalid-diagnostic | 1 | 6 | 0 |
| tool-failure | 2 | 5 | 0 |
| authorization-limit | 1 | 4 | 0 |
| command-timeout | 4 | 4 | 226 |
| agent-no-progress | 1 | 3 | 0 |
| redundant-work | 1 | 2 | 269 |

## Prevention Rules

- Budget repository-wide Git scans from a one-repository timing sample.
- Collect read-only Git snapshots through a bounded cross-version runspace pool.
- Delegate read-only audits outside writable roots and reserve edits for writable worktrees.
- Finalize defaults before Docker and verify argument wiring with a tiny smoke workload.
- Pilot one agent after writable-scope preflight; keep external-workspace agents read-only and apply changes from the principal agent.
- Pilot one minimal edit and one failing native Git call before applying a workspace-wide script.
- Read PSVersion first and use Stopwatch plus a PowerShell-5.1-compatible runspace pool.
- Run a one-percent benchmark calibration and estimate the full timeout before the production workload.
- Stage inside one writable worktree and use one supported patch path before starting broad edits.
- Syntax-check generated PowerShell and pilot every inventory transformation on one repository.
- Use a staged single-root edit path and do not retry the same failing tool after the first confirmed platform failure.
- Use one git ls-files and one porcelain-v2 status snapshot per repository, then filter in memory.
- Wait once for at most 60 seconds, inspect progress, and take over after two no-progress observations.
