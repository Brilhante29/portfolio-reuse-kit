# Usage

## Create One Project

```powershell
powershell -ExecutionPolicy Bypass -File tools/new-project.ps1 `
  -Id 11 `
  -Name spring-hexagonal-payments `
  -TargetDir C:\Users\Guilherme\Desktop\repos-github `
  -InstallSkills `
  -InitializeGit
```

The generated repo contains:

- `project.yaml`
- `README.md`
- `REFERENCES.md`
- `sdd/spec.md`
- `sdd/benchmark-plan.md`
- `sdd/architecture-decision.md`
- `sdd/technical-decision.md`
- `benchmarks/results/.gitkeep`
- `.codex/skills/*`
- `.claude/skills/*`
- `.portfolio/*` standards snapshot when `-InstallSkills` is used

## Install Skills Later

```powershell
powershell -ExecutionPolicy Bypass -File tools/install-project-skills.ps1 `
  -TargetRepo C:\path\to\repo
```

This installs agent skills and a local `.portfolio/` snapshot with program catalog, proficiency map, decision brain, architecture matrix, API style matrix, Kumo cloud local-first rules, language/framework profiles, design system, and schemas.

## Validate The Kit

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-kit.ps1
```

The validator checks required files, decision brain assets, architecture assets, program catalog, proficiency map, language/framework profiles, design-system assets, skill frontmatter, JSON schema syntax, Python syntax, PowerShell syntax, forbidden legacy wording, and catalog count.

## Benchmark A Command

```powershell
python harness/bench.py --project my-project --metric latency_ms --unit ms --repeat 5 python --version
```

The wrapper measures wall-clock command runtime and writes JSON to `benchmarks/results/` by default.

## Compare Results

```powershell
python harness/compare_results.py old.json new.json
```

Use this for before/after optimization posts.

## Publish To GitHub

Publish the current repo without saving the token in the remote URL:

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

Publish every initialized repo under a folder:

```powershell
$env:GH_TOKEN = "<token>"
powershell -ExecutionPolicy Bypass -File tools/publish-all.ps1 `
  -RepoRoot C:\Users\Guilherme\Desktop\repos-github `
  -Owner Brilhante29 `
  -Visibility public
Remove-Item Env:\GH_TOKEN
```

Use a token that can create repositories. If the token cannot create repositories, create the empty repository once in GitHub and rerun the script; it will configure `origin` and push.
