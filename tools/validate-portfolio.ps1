param(
  [string]$RepoRoot = "",
  [switch]$Strict,
  [string]$JsonPath = ""
)

$ErrorActionPreference = "Stop"
$kitRoot = Split-Path -Parent $PSScriptRoot
if ($RepoRoot -eq "") { $RepoRoot = Split-Path -Parent $kitRoot }
$resolvedRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

function Get-Scalar {
  param([string]$Body, [string]$Pattern, [string]$Default = "")
  $match = [regex]::Match($Body, $Pattern)
  if (-not $match.Success) { return $Default }
  return $match.Groups[1].Value.Trim().Trim('"').Trim("'")
}

function Has-File {
  param([string]$Repo, [string]$RelativePath)
  return Test-Path -LiteralPath (Join-Path $Repo $RelativePath) -PathType Leaf
}

$repositories = @(Get-ChildItem -Directory -LiteralPath $resolvedRoot | Where-Object {
  $_.Name -ne "portfolio-reuse-kit" -and (Test-Path -LiteralPath (Join-Path $_.FullName ".git") -PathType Container)
} | Sort-Object Name)
$rows = New-Object System.Collections.Generic.List[object]

foreach ($directory in $repositories) {
  $repo = $directory.FullName
  $manifestPath = Join-Path $repo "project.yaml"
  $manifest = if (Test-Path -LiteralPath $manifestPath -PathType Leaf) { Get-Content -Raw -LiteralPath $manifestPath } else { "" }
  $status = Get-Scalar -Body $manifest -Pattern "(?m)^status:\s*(.+)$" -Default "missing"
  $benchmarkDir = Join-Path $repo "benchmarks/results"
  $benchmarkFiles = if (Test-Path -LiteralPath $benchmarkDir -PathType Container) { @(Get-ChildItem -LiteralPath $benchmarkDir -Filter *.json -File) } else { @() }
  $workflowDir = Join-Path $repo ".github/workflows"
  $hasCi = $false
  if (Test-Path -LiteralPath $workflowDir -PathType Container) {
    $hasCi = @(Get-ChildItem -LiteralPath $workflowDir -File | Where-Object { $_.Extension -in @(".yml", ".yaml") }).Count -gt 0
  }
  $hasReadme = Has-File $repo "README.md"
  $numberedReadme = $false
  if ($hasReadme) { $numberedReadme = (Get-Content -LiteralPath (Join-Path $repo "README.md") -TotalCount 1) -match "^#\s*#?\d+\s+" }
  $checks = [ordered]@{
    readme = $hasReadme
    numbered_readme = $numberedReadme
    docker = Has-File $repo "Dockerfile"
    ci = $hasCi
    sdd = (Has-File $repo "sdd/spec.md") -and (Has-File $repo "sdd/benchmark-plan.md") -and (Has-File $repo "sdd/reuse-improvement-review.md")
    benchmark = $benchmarkFiles.Count -gt 0
    control = (Has-File $repo ".portfolio-control/INVENTORY.md") -and (Has-File $repo ".portfolio-control/REUSE_MAP.md") -and (Has-File $repo ".portfolio-control/QUALITY_GATES.md")
  }
  $allGates = $true
  foreach ($value in $checks.Values) { if (-not [bool]$value) { $allGates = $false } }
  $rows.Add([pscustomobject]@{
    id = Get-Scalar $manifest "(?m)^id:\s*(.+)$" "?"
    name = $directory.Name
    status = $status
    docker = [bool]$checks.docker
    ci = [bool]$checks.ci
    benchmark = [bool]$checks.benchmark
    control = [bool]$checks.control
    complete_candidate = ($allGates -and $status -in @("benchmarked", "published"))
  })
}

$rows | Format-Table -AutoSize
$summary = [pscustomobject]@{
  repository_count = $rows.Count
  docker_count = @($rows | Where-Object { $_.docker }).Count
  ci_count = @($rows | Where-Object { $_.ci }).Count
  benchmark_count = @($rows | Where-Object { $_.benchmark }).Count
  control_count = @($rows | Where-Object { $_.control }).Count
  complete_candidate_count = @($rows | Where-Object { $_.complete_candidate }).Count
  repositories = $rows
}
if ($JsonPath -ne "") {
  $parent = Split-Path -Parent $JsonPath
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  $summary | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $JsonPath -Encoding utf8
}
Write-Host "repositories=$($summary.repository_count) docker=$($summary.docker_count) ci=$($summary.ci_count) benchmarks=$($summary.benchmark_count) control=$($summary.control_count) complete_candidates=$($summary.complete_candidate_count)"
if ($Strict -and $summary.complete_candidate_count -ne $summary.repository_count) { exit 1 }
