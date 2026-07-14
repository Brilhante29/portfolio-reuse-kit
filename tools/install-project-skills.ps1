param(
  [Parameter(Mandatory=$true)]
  [string]$TargetRepo
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$target = Resolve-Path -LiteralPath $TargetRepo

$codexSource = Join-Path $root ".codex\skills"
$claudeSource = Join-Path $root ".claude\skills"
$codexTarget = Join-Path $target ".codex\skills"
$claudeTarget = Join-Path $target ".claude\skills"
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

$standardDirs = @("architecture", "decision-brain", "design-system", "language-profiles")
foreach ($dir in $standardDirs) {
  $source = Join-Path $root $dir
  if (Test-Path -LiteralPath $source) {
    Copy-Item -Recurse -Force -Path $source -Destination $portfolioTarget
  }
}

New-Item -ItemType Directory -Force -Path (Join-Path $portfolioTarget "catalog") | Out-Null
Copy-Item -Force -Path (Join-Path $root "catalog\programs.yaml") -Destination (Join-Path $portfolioTarget "catalog\programs.yaml")
Copy-Item -Force -Path (Join-Path $root "catalog\projects.yaml") -Destination (Join-Path $portfolioTarget "catalog\projects.yaml")
Copy-Item -Force -Path (Join-Path $root "catalog\proficiency.yaml") -Destination (Join-Path $portfolioTarget "catalog\proficiency.yaml")

New-Item -ItemType Directory -Force -Path (Join-Path $portfolioTarget "contracts") | Out-Null
Copy-Item -Force -Path (Join-Path $root "contracts\project.schema.json") -Destination (Join-Path $portfolioTarget "contracts\project.schema.json")
Copy-Item -Force -Path (Join-Path $root "contracts\benchmark-result.schema.json") -Destination (Join-Path $portfolioTarget "contracts\benchmark-result.schema.json")

Write-Host "Installed project skills and portfolio standards into:"
Write-Host "  $codexTarget"
Write-Host "  $claudeTarget"
Write-Host "  $portfolioTarget"
