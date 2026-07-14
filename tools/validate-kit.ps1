$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$failures = New-Object System.Collections.Generic.List[string]

function Require-File {
  param([string]$RelativePath)
  $path = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    $script:failures.Add("Missing file: $RelativePath")
  }
}

function Require-Directory {
  param([string]$RelativePath)
  $path = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Container)) {
    $script:failures.Add("Missing directory: $RelativePath")
  }
}

$requiredFiles = @(
  "README.md",
  "PUBLISH.md",
  "LICENSE",
  ".editorconfig",
  ".gitattributes",
  "catalog/projects.yaml",
  "catalog/projects.md",
  "catalog/programs.yaml",
  "catalog/proficiency.yaml",
  "catalog/reuse-policy.md",
  "architecture/decision-matrix.yaml",
  "decision-brain/README.md",
  "decision-brain/agent-graph.yaml",
  "decision-brain/reuse-improvement-loop.yaml",
  "decision-brain/engineering-principles.yaml",
  "decision-brain/stack-matrix.yaml",
  "decision-brain/api-style-matrix.yaml",
  "decision-brain/cloud-matrix.yaml",
  "decision-brain/messaging-matrix.yaml",
  "decision-brain/library-selection.yaml",
  "design-system/README.md",
  "design-system/tokens.yaml",
  "language-profiles/python.yaml",
  "language-profiles/java.yaml",
  "language-profiles/go.yaml",
  "language-profiles/typescript.yaml",
  "language-profiles/angular.yaml",
  "language-profiles/nextjs.yaml",
  "language-profiles/spring-kotlin.yaml",
  "language-profiles/fastapi-backend.yaml",
  "language-profiles/go-backend.yaml",
  "language-profiles/node-typescript-backend.yaml",
  "language-profiles/terraform.yaml",
  "contracts/project.schema.json",
  "contracts/benchmark-result.schema.json",
  "docs/reuse-layer.md",
  "docs/architecture-decision-guide.md",
  "docs/decision-brain.md",
  "docs/agent-graph.md",
  "docs/reuse-improvement-loop.md",
  "docs/engineering-principles.md",
  "docs/api-style-decision.md",
  "docs/cloud-local-first.md",
  "docs/portfolio-operating-model.md",
  "docs/proficiency-map.md",
  "docs/project-lifecycle.md",
  "docs/repository-standard.md",
  "docs/usage.md",
  "harness/bench.py",
  "harness/compare_results.py",
  "harness/result.schema.json",
  "harness/k6/http-smoke.js",
  "metrics/registry.yaml",
  "sdd/templates/spec.md",
  "sdd/templates/benchmark-plan.md",
  "sdd/templates/adr.md",
  "sdd/templates/architecture-decision.md",
  "sdd/templates/technical-decision.md",
  "sdd/templates/agent-handoff.md",
  "sdd/templates/reuse-improvement-review.md",
  "sdd/templates/release-checklist.md",
  "templates/README-project.md",
  "templates/AGENTS.md",
  "templates/validate-project.ps1",
  "templates/project.yaml",
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
  "tools/set-github-token.ps1",
  "tools/clear-github-token.ps1",
  "tools/validate-kit.ps1"
)

foreach ($file in $requiredFiles) { Require-File $file }

$requiredDirs = @(
  ".codex/skills/portfolio-project",
  ".codex/skills/agent-orchestration",
  ".codex/skills/reuse-improvement-review",
  ".codex/skills/spec-driven-project",
  ".codex/skills/benchmark-harness",
  ".codex/skills/architecture-selector",
  ".codex/skills/engineering-principles",
  ".codex/skills/stack-decision",
  ".codex/skills/api-style-decision",
  ".codex/skills/cloud-local-first",
  ".codex/skills/messaging-decision",
  ".codex/skills/language-standards",
  ".codex/skills/design-system",
  ".codex/skills/spring-kotlin-backend",
  ".codex/skills/fastapi-backend",
  ".codex/skills/go-backend",
  ".codex/skills/node-typescript-backend",
  ".claude/skills/portfolio-project",
  ".claude/skills/agent-orchestration",
  ".claude/skills/reuse-improvement-review",
  ".claude/skills/spec-driven-project",
  ".claude/skills/benchmark-harness",
  ".claude/skills/architecture-selector",
  ".claude/skills/engineering-principles",
  ".claude/skills/stack-decision",
  ".claude/skills/api-style-decision",
  ".claude/skills/cloud-local-first",
  ".claude/skills/messaging-decision",
  ".claude/skills/language-standards",
  ".claude/skills/design-system",
  ".claude/skills/spring-kotlin-backend",
  ".claude/skills/fastapi-backend",
  ".claude/skills/go-backend",
  ".claude/skills/node-typescript-backend"
)

foreach ($dir in $requiredDirs) { Require-Directory $dir }

$skillFiles = Get-ChildItem -Recurse -Filter SKILL.md -Path (Join-Path $root ".codex"), (Join-Path $root ".claude")
foreach ($skill in $skillFiles) {
  $content = Get-Content -Raw -LiteralPath $skill.FullName
  if (-not $content.StartsWith("---`n")) {
    $failures.Add("Skill frontmatter does not start cleanly: $($skill.FullName)")
  }
  if ($content -notmatch "(?m)^name: [a-z0-9-]+$") {
    $failures.Add("Skill missing valid name: $($skill.FullName)")
  }
  if ($content -notmatch "(?m)^description: .+") {
    $failures.Add("Skill missing description: $($skill.FullName)")
  }
}

$projectCount = (Select-String -Path (Join-Path $root "catalog/projects.yaml") -Pattern "^  - id: ").Count
$programCount = (Select-String -Path (Join-Path $root "catalog/programs.yaml") -Pattern "^  - id: ").Count
if ($projectCount -ne 30) {
  $failures.Add("Expected 30 projects in catalog/projects.yaml; found $projectCount")
}
if ($programCount -lt 5) {
  $failures.Add("Expected at least 5 programs in catalog/programs.yaml; found $programCount")
}

python -m json.tool (Join-Path $root "harness/result.schema.json") | Out-Null
python -m json.tool (Join-Path $root "contracts/project.schema.json") | Out-Null
python -m json.tool (Join-Path $root "contracts/benchmark-result.schema.json") | Out-Null
python -c "import ast, pathlib; [ast.parse(pathlib.Path(p).read_text(encoding='utf-8')) for p in [r'$root/harness/bench.py', r'$root/harness/compare_results.py']]; print('python syntax ok')" | Out-Null

$powerShellScripts = @(
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
  "tools/set-github-token.ps1",
  "tools/clear-github-token.ps1",
  "tools/validate-kit.ps1"
)

foreach ($script in $powerShellScripts) {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $root $script), [ref]$tokens, [ref]$errors) | Out-Null
  if ($errors.Count -gt 0) {
    foreach ($err in $errors) { $failures.Add("PowerShell parse error in ${script}: $($err.Message)") }
  }
}

$legacy = ("ro" + "che" + "do")
$patterns = @($legacy, ($legacy.Substring(0,1).ToUpper() + $legacy.Substring(1)))
$searchFiles = Get-ChildItem -Path $root -Recurse -File | Where-Object {
  $_.FullName -notmatch "\\.git\\" -and
  $_.FullName -notmatch "\\benchmarks\\results\\" -and
  $_.Extension -in @(".md", ".yaml", ".yml", ".json", ".ps1", ".py", ".js", ".ts", ".tsx", ".go", ".kt", ".java")
}
$forbidden = Select-String -Path $searchFiles.FullName -Pattern $patterns -SimpleMatch -ErrorAction SilentlyContinue
if ($forbidden) {
  $failures.Add("Forbidden legacy project nickname found")
}

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host "portfolio-reuse-kit validation passed"
