$ErrorActionPreference = "Stop"

$kitRoot = Split-Path -Parent $PSScriptRoot
$workspace = Join-Path ([IO.Path]::GetTempPath()) ("portfolio-head-regression-" + [guid]::NewGuid().ToString("N"))
$repo = Join-Path $workspace "published-fixture"

function Write-TestFile {
  param([string]$Path, [string]$Content)
  $parent = Split-Path -Parent $Path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [IO.File]::WriteAllText($Path, $Content, (New-Object Text.UTF8Encoding($false)))
}

try {
  New-Item -ItemType Directory -Force -Path $repo | Out-Null
  Write-TestFile (Join-Path $repo "project.yaml") @"
id: 99
name: published-fixture
status: published
benchmark:
  primary_metric: latency_ms
  result_path: benchmarks/results/baseline.json
  publication_result_path: benchmarks/publication/baseline-v2.json
  evidence_status: current
"@
  Write-TestFile (Join-Path $repo "README.md") ("# Published Fixture: 1 ms latency" + [Environment]::NewLine)
  Write-TestFile (Join-Path $repo "Dockerfile") ("FROM scratch" + [Environment]::NewLine)
  Write-TestFile (Join-Path $repo ".github/workflows/ci.yml") ("name: ci" + [Environment]::NewLine + "on: [push]" + [Environment]::NewLine)
  foreach ($path in @(
    "sdd/spec.md",
    "sdd/benchmark-plan.md",
    "sdd/reuse-improvement-review.md",
    ".portfolio-control/INVENTORY.md",
    ".portfolio-control/REUSE_MAP.md",
    ".portfolio-control/QUALITY_GATES.md"
  )) {
    Write-TestFile (Join-Path $repo $path) ("# Complete" + [Environment]::NewLine)
  }
  $v1 = [ordered]@{
    project = "published-fixture"
    metric = "latency_ms"
    value = 1
    unit = "milliseconds"
    timestamp = "2026-08-02T00:00:00Z"
    command = "fixture"
  }
  Write-TestFile (Join-Path $repo "benchmarks/results/baseline.json") (($v1 | ConvertTo-Json) + [Environment]::NewLine)
  New-Item -ItemType Directory -Force -Path (Join-Path $repo "benchmarks/publication") | Out-Null
  Copy-Item -LiteralPath (Join-Path $kitRoot "contracts/fixtures/benchmark-result-v2.valid.json") -Destination (Join-Path $repo "benchmarks/publication/baseline-v2.json")

  git -C $repo init -b main | Out-Null
  git -C $repo config user.name "Portfolio Test" | Out-Null
  git -C $repo config user.email "portfolio-test@example.invalid" | Out-Null
  git -C $repo config core.autocrlf false | Out-Null
  git -C $repo add . | Out-Null
  git -C $repo commit -m "fixture" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Cannot create published fixture commit" }

  Write-TestFile (Join-Path $repo "benchmarks/results/baseline.json") ('{"invalid_worktree_only":true}' + [Environment]::NewLine)

  $report = Join-Path $workspace "report.json"
  $shell = Get-Command pwsh -ErrorAction SilentlyContinue
  if (-not $shell) { $shell = Get-Command powershell.exe -ErrorAction Stop }
  & $shell.Source -NoProfile -ExecutionPolicy Bypass -File (Join-Path $kitRoot "tools/validate-portfolio.ps1") -RepoRoot $workspace -Strict -JsonPath $report | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Published HEAD regression validator failed" }

  $row = (Get-Content -Raw -LiteralPath $report | ConvertFrom-Json).repositories | Select-Object -First 1
  if ($row.dirty_files -ne 1) { throw "Expected dirty_files=1, got $($row.dirty_files)" }
  if (-not $row.local_candidate) { throw "Published committed HEAD was invalidated by working-tree churn" }
  if (-not $row.benchmark_contract) { throw "Validator read dirty V1 instead of committed HEAD" }
  if (-not $row.publication_candidate) { throw "Committed V2 publication candidate was not recognized" }

  $v1.value = 0.627341
  Write-TestFile (Join-Path $repo "benchmarks/results/baseline.json") (($v1 | ConvertTo-Json) + [Environment]::NewLine)
  Write-TestFile (Join-Path $repo "README.md") ("# Published Fixture`nBenchmark: 62.73%`n")
  git -C $repo add README.md benchmarks/results/baseline.json | Out-Null
  git -C $repo commit -m "rounded percentage evidence" | Out-Null
  & $shell.Source -NoProfile -ExecutionPolicy Bypass -File (Join-Path $kitRoot "tools/validate-portfolio.ps1") -RepoRoot $workspace -Strict -JsonPath $report | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Rounded percentage benchmark should pass" }

  Write-TestFile (Join-Path $repo "README.md") ("# Published Fixture`nNo measured result in the opening.`n")
  git -C $repo add README.md | Out-Null
  git -C $repo commit -m "remove benchmark from opening" | Out-Null
  & $shell.Source -NoProfile -ExecutionPolicy Bypass -File (Join-Path $kitRoot "tools/validate-portfolio.ps1") -RepoRoot $workspace -Strict -JsonPath $report | Out-Null
  if ($LASTEXITCODE -ne 1) { throw "Missing README benchmark must fail strict validation" }
  $row = (Get-Content -Raw -LiteralPath $report | ConvertFrom-Json).repositories | Select-Object -First 1
  if ('readme_benchmark' -notin $row.failed_checks) { throw "Missing actionable README failure" }

  Write-TestFile (Join-Path $repo "sdd/spec.md") ("# Incomplete`nTODO and TBD`n")
  git -C $repo add sdd/spec.md | Out-Null
  git -C $repo commit -m "introduce two placeholders" | Out-Null
  & $shell.Source -NoProfile -ExecutionPolicy Bypass -File (Join-Path $kitRoot "tools/validate-portfolio.ps1") -RepoRoot $workspace -Strict -JsonPath $report | Out-Null
  if ($LASTEXITCODE -ne 1) { throw "Committed placeholders must fail strict validation" }
  $row = (Get-Content -Raw -LiteralPath $report | ConvertFrom-Json).repositories | Select-Object -First 1
  if ($row.placeholders -ne 2) { throw "Expected two placeholders on one line, got $($row.placeholders)" }
  $global:LASTEXITCODE = 0

  Write-Host "published_head_regression=passed"
} finally {
  if (Test-Path -LiteralPath $workspace) {
    $resolvedWorkspace = (Resolve-Path -LiteralPath $workspace).Path
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    if (-not $resolvedWorkspace.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing cleanup outside temp: $resolvedWorkspace"
    }
    Remove-Item -LiteralPath $resolvedWorkspace -Recurse -Force
  }
}
