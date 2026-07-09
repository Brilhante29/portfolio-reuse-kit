param(
  [Parameter(Mandatory=$true)]
  [int]$Id,
  [Parameter(Mandatory=$true)]
  [string]$Name,
  [Parameter(Mandatory=$true)]
  [string]$TargetDir
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$targetRoot = Resolve-Path -LiteralPath $TargetDir
$target = Join-Path $targetRoot $Name

if (Test-Path -LiteralPath $target) {
  throw "Target already exists: $target"
}

New-Item -ItemType Directory -Force -Path $target | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "sdd") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "benchmarks\results") | Out-Null

Copy-Item (Join-Path $root "templates\README-rochedo.md") (Join-Path $target "README.md")
Copy-Item (Join-Path $root "templates\REFERENCES.md") (Join-Path $target "REFERENCES.md")
Copy-Item (Join-Path $root "sdd\templates\spec.md") (Join-Path $target "sdd\spec.md")
Copy-Item (Join-Path $root "sdd\templates\benchmark-plan.md") (Join-Path $target "sdd\benchmark-plan.md")

(Get-Content (Join-Path $target "README.md")) `
  -replace "<id>", $Id `
  -replace "<project-name>", $Name |
  Set-Content (Join-Path $target "README.md")

Write-Host "Created $target"
