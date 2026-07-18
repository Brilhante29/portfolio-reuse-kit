param(
  [Parameter(Mandatory=$true)] [string]$RepoRoot,
  [string]$Owner = "Brilhante29",
  [ValidateSet("public", "private")] [string]$Visibility = "public",
  [string]$Token = $env:GH_TOKEN,
  [switch]$NoPush,
  [switch]$IncludeDirty,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $RepoRoot).Path
$kit = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $PSScriptRoot "validate-portfolio.ps1"
$publisher = Join-Path $PSScriptRoot "publish-github.ps1"
$reportPath = Join-Path ([System.IO.Path]::GetTempPath()) ("portfolio-status-{0}.json" -f $PID)

try {
  & $validator -RepoRoot $root -JsonPath $reportPath | Out-Host
  $report = Get-Content -Raw -LiteralPath $reportPath | ConvertFrom-Json
  $reportRows = if ($report.repositories) { $report.repositories } else { $report.rows }
  $candidates = @($reportRows | Where-Object complete_candidate | Sort-Object id)
  if ($candidates.Count -eq 0) { throw "No complete candidate is eligible for publication" }

  foreach ($candidate in $candidates) {
    $repoPath = Join-Path $root $candidate.name
    if ($candidate.dirty_files -gt 0 -and -not $IncludeDirty) {
      Write-Warning ("skip={0}; dirty_files={1}; use -IncludeDirty only after reviewing the tree" -f $candidate.name,$candidate.dirty_files)
      continue
    }
    $branch = ((git -C $repoPath branch --show-current 2>$null) -join "").Trim()
    if (-not $branch) { throw "Cannot determine current branch for $($candidate.name)" }
    if ($DryRun) {
      Write-Host ("eligible={0}; branch={1}; status={2}; benchmark={3}" -f $candidate.name,$branch,$candidate.status,$candidate.benchmark)
      continue
    }
    Write-Host ("publishing={0}; branch={1}" -f $candidate.name,$branch)
    $args = @(
      "-RepoPath", $repoPath,
      "-Owner", $Owner,
      "-RepoName", $candidate.name,
      "-Visibility", $Visibility,
      "-Branch", $branch,
      "-Token", $Token,
      "-NoCommit"
    )
    if ($NoPush) { $args += "-NoPush" }
    & $publisher @args
  }
} finally {
  if (Test-Path -LiteralPath $reportPath) { Remove-Item -LiteralPath $reportPath -Force }
  $Token = $null
}
