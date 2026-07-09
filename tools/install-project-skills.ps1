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

New-Item -ItemType Directory -Force -Path $codexTarget | Out-Null
New-Item -ItemType Directory -Force -Path $claudeTarget | Out-Null

Copy-Item -Recurse -Force -Path (Join-Path $codexSource "*") -Destination $codexTarget
Copy-Item -Recurse -Force -Path (Join-Path $claudeSource "*") -Destination $claudeTarget

Write-Host "Installed project skills into:"
Write-Host "  $codexTarget"
Write-Host "  $claudeTarget"
