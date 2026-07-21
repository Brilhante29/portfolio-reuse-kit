# Usage

## Create One Project

Use PowerShell 7+ (`pwsh`) on Windows, Linux, and macOS.

```powershell
$repoRoot = Join-Path $HOME "repos-github"
pwsh -NoProfile -File tools/new-project.ps1 `
  -Id 11 `
  -Name spring-hexagonal-payments `
  -TargetDir $repoRoot `
  -InstallSkills `
  -InitializeGit
```

The generated repo contains:

- `project.yaml`
- `README.md`
- `REFERENCES.md`
- `AGENTS.md`
- `CLAUDE.md`
- `.aitmpl/config.yaml`
- `sdd/spec.md`
- `sdd/benchmark-plan.md`
- `sdd/architecture-decision.md`
- `sdd/technical-decision.md`
- `sdd/agent-handoff.md`
- `sdd/reuse-improvement-review.md`
- `tools/validate-project.ps1`
- `benchmarks/results/.gitkeep`
- `.codex/skills/*`
- `.claude/skills/*`
- `.portfolio/*` standards snapshot when `-InstallSkills` is used

## Prepare A Project For Agents

After the manifest and first architecture decision are ready, run one command:

```powershell
powershell -ExecutionPolicy Bypass -File tools/prepare-project.ps1 `
  -RepoPath (Join-Path $repoRoot "spring-hexagonal-payments") `
  -ChangeId baseline `
  -Force `
  -Validate
```

It generates the context card for Codex and Claude Code, the OpenSpec change
package, the reusable planning artifacts, the article draft, and the voice
check. The default path has no dependency on external CLIs. Add
`-OpenSpecValidate` only when the OpenSpec CLI is installed. Add
`-UseAitmpl -AitmplArgs ...` only when deliberately installing external Claude
Code Templates components.

## Sync Reuse Into Existing Projects

```powershell
$env:PORTFOLIO_REPO_ROOT = Join-Path $HOME "repos-github"
pwsh -NoProfile -File tools/sync-project-reuse.ps1
```

This updates each project repo with current Codex/Claude skills, `.portfolio/` standards, and `tools/validate-project.ps1`. Use `-UpdateAgents` when the root `AGENTS.md` should also be refreshed from the kit template.
## Install Skills Later

```powershell
$repoPath = Join-Path (Join-Path $HOME "repos-github") "my-project"
pwsh -NoProfile -File tools/install-project-skills.ps1 `
  -TargetRepo $repoPath
```

This installs agent skills and a local `.portfolio/` snapshot with agent graph, reuse-improvement loop, program catalog, proficiency map, decision brain, architecture matrix, API style matrix, Kumo cloud local-first rules, language/framework profiles, design system, and schemas.

## Validate One Project

```powershell
pwsh -NoProfile -File tools/validate-project.ps1
```

Use `-SkipDocker` while iterating quickly.

Final validation requires `openspec/config.yaml` and the complete generated artifact graph under `openspec/artifacts/`. Run `tools/plan-project.ps1` after the implementation and benchmark stabilize, then review the generated evidence before publication.

The same gate checks top-level manifest structure, performs full YAML parsing when PyYAML is available, matches the manifest primary metric to the committed JSON result, and requires that measured value near the top of the README.

## Validate The Kit

```powershell
pwsh -NoProfile -File tools/validate-kit.ps1
```

The validator checks required files, agent graph assets, reuse-improvement assets, decision brain assets, architecture assets, program catalog, proficiency map, language/framework profiles, design-system assets, skill frontmatter, JSON schema syntax, Python syntax, PowerShell syntax, forbidden legacy wording, and catalog count.

## Benchmark A Command

```bash
python harness/bench.py --project my-project --metric latency_ms --unit ms --repeat 5 python --version
```

The wrapper measures wall-clock command runtime and writes JSON to `benchmarks/results/` by default.

## Compare Results

```bash
python harness/compare_results.py old.json new.json
```

Use this for before/after optimization posts.

## Publish To GitHub

Use a session-only token for maximum portability:

```powershell
$env:GH_TOKEN = "<short-lived-token>"
```

The publish scripts read `GH_TOKEN` from the process, user, or machine environment when the platform supports those scopes. They do not save the token in the remote URL.

Publish the current repo:

```powershell
pwsh -NoProfile -File tools/publish-github.ps1 `
  -RepoPath . `
  -Owner Brilhante29 `
  -RepoName portfolio-reuse-kit `
  -Description "Reusable engineering kit for benchmark-driven portfolio repos" `
  -Visibility public `
  -CommitMessage "Publish portfolio reuse kit"
```

Publish every initialized repo under a folder:

```powershell
$repoRoot = Join-Path $HOME "repos-github"
pwsh -NoProfile -File tools/publish-all.ps1 `
  -RepoRoot $repoRoot `
  -Owner Brilhante29 `
  -Visibility public
```

Clear the stored token when needed:

```powershell
Remove-Item Env:\GH_TOKEN -ErrorAction SilentlyContinue
```

Use a token that can create repositories. If the token cannot create repositories, create the empty repository once in GitHub and rerun the script; it will configure `origin` and push.
