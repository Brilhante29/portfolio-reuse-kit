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
  "catalog/reuse-policy.md",
  "docs/repository-standard.md",
  "docs/usage.md",
  "harness/bench.py",
  "harness/compare_results.py",
  "harness/result.schema.json",
  "harness/k6/http-smoke.js",
  "sdd/templates/spec.md",
  "sdd/templates/benchmark-plan.md",
  "sdd/templates/adr.md",
  "sdd/templates/release-checklist.md",
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
  "tools/validate-kit.ps1"
)

foreach ($file in $requiredFiles) { Require-File $file }

$requiredDirs = @(
  ".codex/skills/portfolio-rochedo",
  ".codex/skills/sdd-rochedo",
  ".codex/skills/benchmark-harness",
  ".claude/skills/portfolio-rochedo",
  ".claude/skills/sdd-rochedo",
  ".claude/skills/benchmark-harness"
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
if ($projectCount -ne 30) {
  $failures.Add("Expected 30 projects in catalog/projects.yaml; found $projectCount")
}

python -m json.tool (Join-Path $root "harness/result.schema.json") | Out-Null
python -c "import ast, pathlib; [ast.parse(pathlib.Path(p).read_text(encoding='utf-8')) for p in [r'$root/harness/bench.py', r'$root/harness/compare_results.py']]; print('python syntax ok')" | Out-Null

$powerShellScripts = @(
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
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

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host "portfolio-reuse-kit validation passed"