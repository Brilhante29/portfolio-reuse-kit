# Publish

This kit includes automation so repositories do not need to be created and pushed by hand.

## Recommended Auth

Use a short-lived GitHub token through `GH_TOKEN`. The most portable option is a session-only environment variable.

```powershell
$env:GH_TOKEN = "<short-lived-token>"
```

This works the same from PowerShell 7 on Windows, Linux, and macOS. The publish scripts also try process, user, and machine scopes when the platform supports them. They never save the token in the Git remote URL.

To remove the token later:

```powershell
Remove-Item Env:\GH_TOKEN -ErrorAction SilentlyContinue
```

`tools/set-github-token.ps1` remains available as a convenience wrapper, but do not rely on persistent user environment storage across every OS and shell.

## One Repo

```powershell
pwsh -NoProfile -File tools/publish-github.ps1 `
  -RepoPath . `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Description "Reusable engineering kit for benchmark-driven portfolio repos" `
  -Visibility public `
  -CommitMessage "Publish portfolio reuse kit"
```

## All Local Repos In A Folder

```powershell
$repoRoot = Join-Path $HOME "repos-github"
pwsh -NoProfile -File tools/publish-all.ps1 `
  -RepoRoot $repoRoot `
  -Owner Brilhante29 `
  -Visibility public
```

## Session-Only Auth

For a one-terminal session, set `GH_TOKEN`, publish, and clear it:

```powershell
$env:GH_TOKEN = "<new-short-lived-token>"
pwsh -NoProfile -File tools/publish-github.ps1 `
  -RepoPath . `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Visibility public
Remove-Item Env:\GH_TOKEN -ErrorAction SilentlyContinue
```

Do not store GitHub tokens in a virtual environment, README, command history, repository file, or Git remote URL.

## Runtime

Use PowerShell 7+ (`pwsh`) for cross-platform automation. Windows PowerShell (Windows PowerShell) is Windows-only and should not be used in reusable docs or scripts.

## Token Permissions

Use a short-lived token and revoke it after publishing.

For classic PATs, use `repo` for private repositories or `public_repo` for public-only repositories.

For fine-grained tokens, repository creation may be blocked by GitHub. In that case, create the empty repository once in the GitHub UI and rerun the script; the script will configure `origin`, commit local changes, and push.

## Validation Before Push

```powershell
pwsh -NoProfile -File tools/validate-kit.ps1
python harness/bench.py --project kit-smoke --metric latency_ms --unit ms --repeat 1 --warmup 0 --out-dir benchmarks/results python --version
```

The benchmark JSON under `benchmarks/results/` is intentionally ignored by Git.
