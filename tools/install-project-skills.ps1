param(
  [Parameter(Mandatory=$true)]
  [string]$TargetRepo
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$target = Resolve-Path -LiteralPath $TargetRepo

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory=$true)] [string]$Path,
    [AllowEmptyString()]
    [Parameter(Mandatory=$true)] [string]$Content
  )
  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

$codexSource = Join-Path $root ".codex/skills"
$claudeSource = Join-Path $root ".claude/skills"
$codexTarget = Join-Path $target ".codex/skills"
$claudeTarget = Join-Path $target ".claude/skills"
$portfolioTarget = Join-Path $target ".portfolio"

foreach ($path in @($codexSource, $claudeSource)) {
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing skill source: $path"
  }
}

function Reset-GeneratedDirectory {
  param([string]$Path)
  if (Test-Path -LiteralPath $Path) {
    $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
    if (-not $resolvedPath.StartsWith($target.Path, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing to remove path outside target repository: $resolvedPath"
    }
    Remove-Item -LiteralPath $resolvedPath -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

Reset-GeneratedDirectory -Path $codexTarget
Reset-GeneratedDirectory -Path $claudeTarget
Reset-GeneratedDirectory -Path $portfolioTarget

Copy-Item -Recurse -Force -Path (Join-Path $codexSource "*") -Destination $codexTarget
Copy-Item -Recurse -Force -Path (Join-Path $claudeSource "*") -Destination $claudeTarget

$standardDirs = @("architecture", "component-packs", "decision-brain", "design-system", "language-profiles")
foreach ($dir in $standardDirs) {
  $source = Join-Path $root $dir
  if (Test-Path -LiteralPath $source) {
    Copy-Item -Recurse -Force -Path $source -Destination $portfolioTarget
  }
}

$openspecSchemasSource = Join-Path $root "openspec/schemas"
if (Test-Path -LiteralPath $openspecSchemasSource) {
  $openspecTarget = Join-Path $portfolioTarget "openspec"
  New-Item -ItemType Directory -Force -Path $openspecTarget | Out-Null
  Copy-Item -Recurse -Force -Path $openspecSchemasSource -Destination $openspecTarget
}

New-Item -ItemType Directory -Force -Path (Join-Path $portfolioTarget "catalog") | Out-Null
Copy-Item -Force -Path (Join-Path $root "catalog/programs.yaml") -Destination (Join-Path $portfolioTarget "catalog/programs.yaml")
Copy-Item -Force -Path (Join-Path $root "catalog/projects.yaml") -Destination (Join-Path $portfolioTarget "catalog/projects.yaml")
Copy-Item -Force -Path (Join-Path $root "catalog/proficiency.yaml") -Destination (Join-Path $portfolioTarget "catalog/proficiency.yaml")

$contractsTarget = Join-Path $portfolioTarget "contracts"
New-Item -ItemType Directory -Force -Path $contractsTarget | Out-Null
Copy-Item -Recurse -Force -Path (Join-Path $root "contracts/*") -Destination $contractsTarget

$projectId = "unknown"
$projectName = Split-Path -Leaf $target.Path
$projectManifest = Join-Path $target "project.yaml"
if (Test-Path -LiteralPath $projectManifest) {
  $idMatch = Select-String -LiteralPath $projectManifest -Pattern "^id:\s*(.+)$" | Select-Object -First 1
  $nameMatch = Select-String -LiteralPath $projectManifest -Pattern "^name:\s*(.+)$" | Select-Object -First 1
  if ($idMatch) { $projectId = $idMatch.Matches[0].Groups[1].Value.Trim() }
  if ($nameMatch) { $projectName = $nameMatch.Matches[0].Groups[1].Value.Trim() }
}

$projectOpenSpecDir = Join-Path $target "openspec"
$projectOpenSpecConfig = Join-Path $projectOpenSpecDir "config.yaml"
if (-not (Test-Path -LiteralPath $projectOpenSpecConfig)) {
  New-Item -ItemType Directory -Force -Path $projectOpenSpecDir | Out-Null
  $configContent = (Get-Content -LiteralPath (Join-Path $root "templates/openspec-config.yaml") -Raw) -replace "<id>", $projectId -replace "<project-name>", $projectName
  Write-Utf8NoBom -Path $projectOpenSpecConfig -Content $configContent
}

Write-Host "Installed project skills and portfolio standards into:"
Write-Host "  $codexTarget"
Write-Host "  $claudeTarget"
Write-Host "  $portfolioTarget"
