# Publish

This kit includes automation so repositories do not need to be created and pushed by hand.

## Recommended Auth

Store a short-lived GitHub token as a Windows environment variable once:

```powershell
powershell -ExecutionPolicy Bypass -File tools/set-github-token.ps1 -Scope User
```

The script prompts for the token with hidden input and writes `GH_TOKEN` to the Windows user environment. Open a new terminal after setting it so new processes inherit the variable.

The publish scripts read `GH_TOKEN` from the process, user, or machine environment. They do not save the token in the Git remote URL.

To remove the token later:

```powershell
powershell -ExecutionPolicy Bypass -File tools/clear-github-token.ps1
```

## One Repo

```powershell
powershell -ExecutionPolicy Bypass -File tools/publish-github.ps1 `
  -RepoPath C:\Users\Guilherme\Desktop\repos-github\portfolio-reuse-kit `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Description "Reusable engineering kit for benchmark-driven portfolio repos" `
  -Visibility public `
  -CommitMessage "Polish portfolio reuse kit"
```

## All Local Repos In A Folder

```powershell
powershell -ExecutionPolicy Bypass -File tools/publish-all.ps1 `
  -RepoRoot C:\Users\Guilherme\Desktop\repos-github `
  -Owner Brilhante29 `
  -Visibility public
```

## Session-Only Auth

For a one-terminal session, set `GH_TOKEN` only for the current process and remove it after publishing:

```powershell
$env:GH_TOKEN = "<new-short-lived-token>"
powershell -ExecutionPolicy Bypass -File tools/publish-github.ps1 `
  -RepoPath C:\Users\Guilherme\Desktop\repos-github\portfolio-reuse-kit `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Visibility public
Remove-Item Env:\GH_TOKEN
```

Do not store GitHub tokens in a virtual environment, README, command history, repository file, or Git remote URL.

## Token Permissions

Use a short-lived token and revoke it after publishing.

For classic PATs, use `repo` for private repositories or `public_repo` for public-only repositories.

For fine-grained tokens, repository creation may be blocked by GitHub. In that case, create the empty repository once in the GitHub UI and rerun the script; the script will configure `origin`, commit local changes, and push.

## Validation Before Push

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-kit.ps1
python harness/bench.py --project kit-smoke --metric latency_ms --unit ms --repeat 1 --warmup 0 --out-dir benchmarks/results python --version
```

The benchmark JSON under `benchmarks/results/` is intentionally ignored by Git.
