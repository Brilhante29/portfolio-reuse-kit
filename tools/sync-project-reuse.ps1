param(
  [string]$RepoRoot = "",
  [string[]]$Exclude = @("portfolio-reuse-kit"),
  [switch]$UpdateAgents,
  [switch]$BackfillMissing,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$kitRoot = Split-Path -Parent $PSScriptRoot
$resolvedRepoRoot = Resolve-Path -LiteralPath $RepoRoot
$installScript = Join-Path $PSScriptRoot "install-project-skills.ps1"
$backfillScript = Join-Path $PSScriptRoot "backfill-project-standard.ps1"
$validatorSource = Join-Path $kitRoot "templates/validate-project.ps1"
$gradleValidatorSource = Join-Path $kitRoot "templates/validate-gradle-project.ps1"
$continuityScriptSource = Join-Path $kitRoot "tools/capture-continuity-state.ps1"
$publicationBenchmarkSource = Join-Path $kitRoot "tools/generate-publication-benchmark.py"
$agentsSource = Join-Path $kitRoot "templates/AGENTS.md"

$repos = Get-ChildItem -Directory -LiteralPath $resolvedRepoRoot | Where-Object {
  $Exclude -notcontains $_.Name -and
  (Test-Path -LiteralPath (Join-Path $_.FullName ".git") -PathType Container)
} | Sort-Object Name

foreach ($repo in $repos) {
  Write-Host "syncing=$($repo.Name)"

  if ($BackfillMissing) {
    & $backfillScript -RepoPath $repo.FullName -DryRun:$DryRun
  }

  if ($DryRun) { continue }

  & $installScript -TargetRepo $repo.FullName

  $toolsDir = Join-Path $repo.FullName "tools"
  New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
  Copy-Item -Force -Path $validatorSource -Destination (Join-Path $toolsDir "validate-project.ps1")
  Copy-Item -Force -Path $gradleValidatorSource -Destination (Join-Path $toolsDir "validate-gradle-project.ps1")
  Copy-Item -Force -Path $continuityScriptSource -Destination (Join-Path $toolsDir "capture-continuity-state.ps1")
  Copy-Item -Force -Path $publicationBenchmarkSource -Destination (Join-Path $toolsDir "generate-publication-benchmark.py")

  if ($UpdateAgents) {
    Copy-Item -Force -Path $agentsSource -Destination (Join-Path $repo.FullName "AGENTS.md")
  }
}

Write-Host "synced_repositories=$($repos.Count)"
