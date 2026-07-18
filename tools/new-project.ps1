param(
  [Parameter(Mandatory=$true)]
  [int]$Id,
  [Parameter(Mandatory=$true)]
  [string]$Name,
  [Parameter(Mandatory=$true)]
  [string]$TargetDir,
  [switch]$InstallSkills,
  [switch]$InitializeGit
)

$ErrorActionPreference = "Stop"

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory=$true)] [string]$Path,
    [AllowEmptyString()]
    [Parameter(Mandatory=$true)] [string]$Content
  )
  $encoding = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

$root = Split-Path -Parent $PSScriptRoot
$targetRoot = Resolve-Path -LiteralPath $TargetDir
$target = Join-Path $targetRoot $Name

if (Test-Path -LiteralPath $target) {
  throw "Target already exists: $target"
}

New-Item -ItemType Directory -Force -Path $target | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "sdd") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "tools") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "benchmarks/results") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "openspec") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "openspec/changes") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target ".aitmpl") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target ".portfolio-control/AGENT_HANDOFFS") | Out-Null

Copy-Item (Join-Path $root "templates/README-project.md") (Join-Path $target "README.md")
Copy-Item (Join-Path $root "templates/project.yaml") (Join-Path $target "project.yaml")
Copy-Item (Join-Path $root "templates/REFERENCES.md") (Join-Path $target "REFERENCES.md")
Copy-Item (Join-Path $root "templates/AGENTS.md") (Join-Path $target "AGENTS.md")
Copy-Item (Join-Path $root "templates/CLAUDE.md") (Join-Path $target "CLAUDE.md")
Copy-Item (Join-Path $root "templates/aitmpl-config.yaml") (Join-Path $target ".aitmpl/config.yaml")
Copy-Item (Join-Path $root "templates/validate-project.ps1") (Join-Path $target "tools\validate-project.ps1")
Copy-Item (Join-Path $root "sdd/templates/spec.md") (Join-Path $target "sdd/spec.md")
Copy-Item (Join-Path $root "sdd/templates/benchmark-plan.md") (Join-Path $target "sdd/benchmark-plan.md")
Copy-Item (Join-Path $root "sdd/templates/architecture-decision.md") (Join-Path $target "sdd/architecture-decision.md")
Copy-Item (Join-Path $root "sdd/templates/technical-decision.md") (Join-Path $target "sdd/technical-decision.md")
Copy-Item (Join-Path $root "sdd/templates/agent-handoff.md") (Join-Path $target "sdd/agent-handoff.md")
Copy-Item (Join-Path $root "sdd/templates/reuse-improvement-review.md") (Join-Path $target "sdd/reuse-improvement-review.md")
Copy-Item (Join-Path $root "sdd/templates/release-checklist.md") (Join-Path $target "sdd/release-checklist.md")
Copy-Item (Join-Path $root "LICENSE") (Join-Path $target "LICENSE")
Copy-Item (Join-Path $root ".gitignore") (Join-Path $target ".gitignore")
Copy-Item (Join-Path $root ".gitattributes") (Join-Path $target ".gitattributes")
Copy-Item (Join-Path $root ".editorconfig") (Join-Path $target ".editorconfig")
Copy-Item (Join-Path $root "templates/openspec-config.yaml") (Join-Path $target "openspec/config.yaml")
Copy-Item (Join-Path $root "templates/portfolio-control/INVENTORY.md") (Join-Path $target ".portfolio-control/INVENTORY.md")
Copy-Item (Join-Path $root "templates/portfolio-control/REUSE_MAP.md") (Join-Path $target ".portfolio-control/REUSE_MAP.md")
Copy-Item (Join-Path $root "templates/portfolio-control/CRITICAL_PATH.md") (Join-Path $target ".portfolio-control/CRITICAL_PATH.md")
Copy-Item (Join-Path $root "templates/portfolio-control/DECISIONS.md") (Join-Path $target ".portfolio-control/DECISIONS.md")
Copy-Item (Join-Path $root "templates/portfolio-control/QUALITY_GATES.md") (Join-Path $target ".portfolio-control/QUALITY_GATES.md")
Copy-Item (Join-Path $root "templates/portfolio-control/AGENT_HANDOFFS/README.md") (Join-Path $target ".portfolio-control/AGENT_HANDOFFS/README.md")

$readmeContent = (Get-Content (Join-Path $target "README.md") -Raw) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name
Write-Utf8NoBom -Path (Join-Path $target "README.md") -Content $readmeContent

foreach ($controlFile in @("INVENTORY.md", "REUSE_MAP.md", "CRITICAL_PATH.md", "DECISIONS.md", "QUALITY_GATES.md")) {
  $controlPath = Join-Path $target ".portfolio-control/$controlFile"
  $controlContent = (Get-Content $controlPath -Raw) `
    -replace "<id>", $Id `
    -replace "<project-name>", $Name
  Write-Utf8NoBom -Path $controlPath -Content $controlContent
}

$manifestContent = (Get-Content (Join-Path $target "project.yaml") -Raw) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name
Write-Utf8NoBom -Path (Join-Path $target "project.yaml") -Content $manifestContent

$specContent = (Get-Content (Join-Path $target "sdd/spec.md") -Raw) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name
Write-Utf8NoBom -Path (Join-Path $target "sdd/spec.md") -Content $specContent

$handoffContent = (Get-Content (Join-Path $target "sdd/agent-handoff.md") -Raw) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name
Write-Utf8NoBom -Path (Join-Path $target "sdd/agent-handoff.md") -Content $handoffContent

$reuseReviewContent = (Get-Content (Join-Path $target "sdd/reuse-improvement-review.md") -Raw) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name
Write-Utf8NoBom -Path (Join-Path $target "sdd/reuse-improvement-review.md") -Content $reuseReviewContent

$openSpecConfigContent = (Get-Content (Join-Path $target "openspec/config.yaml") -Raw) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name
Write-Utf8NoBom -Path (Join-Path $target "openspec/config.yaml") -Content $openSpecConfigContent

Write-Utf8NoBom -Path (Join-Path $target "benchmarks/results/.gitkeep") -Content ""

if ($InstallSkills) {
  & (Join-Path $PSScriptRoot "install-project-skills.ps1") -TargetRepo $target
}

if ($InitializeGit) {
  git -C $target init -b main | Out-Null
  git -C $target add . | Out-Null
  git -C $target commit -m "Initial portfolio scaffold" | Out-Null
}

Write-Host "Created $target"
