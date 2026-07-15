# Cross-Platform Operation

The kit must run from Windows, Linux, and macOS without changing repository contents.

## Runtime

Use PowerShell 7+:

```powershell
pwsh -NoProfile -File tools/validate-kit.ps1
```

Do not use Windows PowerShell in reusable docs or automation. It is Windows-only. `pwsh` is the cross-platform runtime.

## Paths

Use variables and `Join-Path`:

```powershell
$repoRoot = Join-Path $HOME "repos-github"
$repoPath = Join-Path $repoRoot "rag-knowledge-base"
pwsh -NoProfile -File tools/plan-project.ps1 -RepoPath $repoPath
```

Do not commit user-specific absolute paths such as local desktop paths, home-folder paths, or drive-letter paths. Documentation should use `$HOME`, `Join-Path`, `.`, or placeholders like `<repo-path>`.

## Repository Root

Set `PORTFOLIO_REPO_ROOT` when a script needs to operate across multiple local repositories:

```powershell
$env:PORTFOLIO_REPO_ROOT = Join-Path $HOME "repos-github"
pwsh -NoProfile -File tools/sync-project-reuse.ps1
```

If `PORTFOLIO_REPO_ROOT` is not set, sync scripts default to the parent folder of the kit repository.

## Secrets

Use process-local environment variables:

```powershell
$env:GH_TOKEN = "<short-lived-token>"
pwsh -NoProfile -File tools/publish-github.ps1 -RepoPath . -Owner Brilhante29 -RepoName portfolio-reuse-kit
Remove-Item Env:\GH_TOKEN -ErrorAction SilentlyContinue
```

Do not write tokens into shell profiles, virtual environments, README files, command history, Git remotes, or repository files.

## Validation Rule

`tools/validate-kit.ps1` rejects user-specific absolute paths in reusable files. If a future script or doc needs an OS-specific example, use a placeholder and explain the variable instead of committing the real path.
