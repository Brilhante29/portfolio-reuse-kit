# Publish

This kit includes automation so repositories do not need to be created and pushed by hand.

## One Repo

```powershell
$env:GH_TOKEN = "<token>"
powershell -ExecutionPolicy Bypass -File tools/publish-github.ps1 `
  -RepoPath C:\Users\Guilherme\Desktop\repos-github\portfolio-reuse-kit `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Description "Reusable engineering kit for benchmark-driven portfolio repos" `
  -Visibility public `
  -CommitMessage "Polish portfolio reuse kit"
Remove-Item Env:\GH_TOKEN
```

## All Local Repos In A Folder

```powershell
$env:GH_TOKEN = "<token>"
powershell -ExecutionPolicy Bypass -File tools/publish-all.ps1 `
  -RepoRoot C:\Users\Guilherme\Desktop\repos-github `
  -Owner Brilhante29 `
  -Visibility public
Remove-Item Env:\GH_TOKEN
```

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