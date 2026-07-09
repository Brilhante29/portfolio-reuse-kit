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

- `README.md`
- `REFERENCES.md`
- `sdd/spec.md`
- `sdd/benchmark-plan.md`
- `benchmarks/results/.gitkeep`
- `.codex/skills/*`
- `.claude/skills/*`

## Install Skills Later

```powershell
powershell -ExecutionPolicy Bypass -File tools/install-project-skills.ps1 `
  -TargetRepo C:\path\to\repo
```

## Validate The Kit

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-kit.ps1
```

The validator checks required files, skill frontmatter, JSON schema syntax, Python syntax, PowerShell syntax, and catalog count.

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