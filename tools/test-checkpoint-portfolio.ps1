$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$sandbox = [IO.Path]::GetFullPath((Join-Path $tempRoot ("portfolio-checkpoint-test-{0}" -f $PID)))
if (-not $sandbox.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to use a checkpoint fixture directory outside the system temp directory: $sandbox"
}
try {
  New-Item -ItemType Directory -Force -Path (Join-Path $sandbox '.portfolio-control') | Out-Null
  $seedQueue = @(
    '# Project Queue',
    '',
    '| Priority | ID | Project Name | Status |',
    '|---:|---:|---|---|',
    '| 1 | 03 | release-project | release-candidate |',
    '| 2 | 04 | completed-project | completed |',
    '| 3 | 02 | validation-project | validation |',
    '| 4 | 01 | scaffold-project | scaffold |'
  ) -join [Environment]::NewLine
  [IO.File]::WriteAllText(
    (Join-Path $sandbox '.portfolio-control/PROJECT_QUEUE.md'),
    $seedQueue,
    (New-Object Text.UTF8Encoding($false))
  )

  $arguments = @{
    RepoRoot = $sandbox
    AuditPath = (Join-Path $root 'contracts/fixtures/portfolio-audit.valid.json')
    ActiveProject = 'release-project'
    GeneratedAt = '2026-07-30T00:00:00Z'
  }
  & (Join-Path $root 'tools/checkpoint-portfolio.ps1') @arguments

  $state = Get-Content -Raw -LiteralPath (Join-Path $sandbox '.portfolio-control/STATE.json') | ConvertFrom-Json
  if ($state.summary.total -ne 4) { throw 'Fixture checkpoint did not retain every repository.' }
  if ($state.summary.completed -ne 1) { throw 'Checkpoint counted a project as completed without publication evidence.' }
  if ($state.summary.release_candidate -ne 1 -or $state.summary.validation -ne 1 -or $state.summary.scaffold -ne 1) {
    throw 'Checkpoint status derivation does not match evidence.'
  }
  if ($state.active_project -ne 'release-project') { throw 'Checkpoint did not retain the active project.' }
  $compatibility = Get-Content -Raw -LiteralPath (Join-Path $sandbox 'portfolio-control-status.json') | ConvertFrom-Json
  if ($compatibility.complete_candidate_count -ne 1 -or $compatibility.generated_by -ne 'tools/checkpoint-portfolio.ps1') {
    throw 'Compatibility status does not use verified completion evidence.'
  }
  $release = @($state.projects | Where-Object project -eq 'release-project')
  if ($release.Count -ne 1 -or $release[0].status -ne 'release-candidate') { throw 'Release candidate fixture was misclassified.' }
  $queue = Get-Content -Raw -LiteralPath (Join-Path $sandbox '.portfolio-control/PROJECT_QUEUE.md')
  if ($queue -notmatch '(?m)^\| 1 \| 03 \| release-project \| release-candidate \|') {
    throw 'Active project was not retained at the head of the queue.'
  }
  Write-Host 'portfolio checkpoint fixture passed'
} finally {
  if (Test-Path -LiteralPath $sandbox) { Remove-Item -LiteralPath $sandbox -Recurse -Force }
}
