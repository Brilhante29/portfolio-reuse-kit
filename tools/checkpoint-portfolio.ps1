param(
  [string]$RepoRoot = "",
  [string]$AuditPath = "",
  [string]$StatePath = "",
  [string]$QueuePath = "",
  [string]$StatusPath = "",
  [string]$ActiveProject = "",
  [string]$GeneratedAt = "",
  [hashtable]$RepositoryOverrides = @{}
)

$ErrorActionPreference = "Stop"
$kitRoot = Split-Path -Parent $PSScriptRoot
if (-not $RepoRoot) { $RepoRoot = Split-Path -Parent $kitRoot }
$resolvedRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

function Write-Utf8 {
  param([string]$Path, [string]$Content)
  $parent = Split-Path -Parent $Path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [IO.File]::WriteAllText($Path, $Content, (New-Object Text.UTF8Encoding($false)))
}

function Resolve-OutputPath {
  param([string]$Path, [string]$DefaultRelativePath)
  if (-not $Path) { return Join-Path $resolvedRoot $DefaultRelativePath }
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $resolvedRoot $Path
}

function Get-Priorities {
  param([string]$Path)
  $priorities = @{}
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $priorities }
  foreach ($line in Get-Content -LiteralPath $Path) {
    if ($line -match '^\|\s*(\d+)\s*\|\s*\d+\s*\|\s*([a-z0-9-]+)\s*\|') {
      $priorities[$matches[2]] = [int]$matches[1]
    }
  }
  return $priorities
}

function Get-Status {
  param($Row)
  if ($Row.published_verified) { return 'completed' }
  if ($Row.publication_candidate) { return 'release-candidate' }
  if ($Row.local_candidate) { return 'validation' }
  switch ([string]$Row.declared_status) {
    'scaffold' { return 'scaffold' }
    'specified' { return 'specification' }
    'snapshot' { return 'triage' }
    'blocked' { return 'blocked' }
    default { return 'implementation' }
  }
}

function Get-CompletedGates {
  param($Row)
  $gates = New-Object System.Collections.Generic.List[string]
  if ($Row.docker) { $gates.Add('docker_present') }
  if ($Row.ci) { $gates.Add('ci_workflow_present') }
  if ($Row.control) { $gates.Add('control_files_present') }
  if ($Row.benchmark_tracked) { $gates.Add('benchmark_tracked') }
  if ($Row.benchmark_contract) { $gates.Add('benchmark_contract_v1') }
  if ($Row.benchmark_contract_v2) { $gates.Add('benchmark_contract_v2') }
  if ($Row.publication_evidence) { $gates.Add('current_head_remote_ci') }
  if ($Row.published_verified) { $gates.Add('publication_verified') }
  return @($gates)
}

function Get-PendingGates {
  param($Row)
  $pending = New-Object System.Collections.Generic.List[string]
  if (-not $Row.docker) { $pending.Add('docker_present') }
  if (-not $Row.ci) { $pending.Add('ci_workflow_present') }
  if (-not $Row.control) { $pending.Add('control_files_present') }
  if (-not $Row.benchmark_tracked) { $pending.Add('benchmark_tracked') }
  if (-not $Row.benchmark_contract) { $pending.Add('benchmark_contract_v1') }
  if (-not $Row.benchmark_contract_v2) { $pending.Add('benchmark_contract_v2') }
  if (-not $Row.publication_evidence) { $pending.Add('current_head_remote_ci') }
  if (-not $Row.published_verified) { $pending.Add('publication_verified') }
  return @($pending)
}

function Get-NextAction {
  param([string]$Status, $Row)
  switch ($Status) {
    'completed' { return 'none' }
    'release-candidate' { return 'Push the exact candidate head, observe green remote CI, and record publication evidence.' }
    'validation' { return 'Produce benchmark contract V2 evidence with immutable provenance, then run the release-candidate gates.' }
    'specification' { return 'Implement the smallest complete functional path tied to executable acceptance criteria.' }
    'scaffold' { return 'Audit the repository, write the minimum verifiable SDD, and implement the core path.' }
    'triage' { return 'Audit P0/P1 gaps and select the smallest critical path to implementation.' }
    default {
      if ([int]$Row.placeholders -gt 0) { return 'Remove placeholders by implementing and verifying the promised behavior.' }
      return 'Close local P0/P1 gaps and produce reproducible validation evidence.'
    }
  }
}

$stateOutput = Resolve-OutputPath $StatePath '.portfolio-control/STATE.json'
$queueOutput = Resolve-OutputPath $QueuePath '.portfolio-control/PROJECT_QUEUE.md'
$statusOutput = Resolve-OutputPath $StatusPath 'portfolio-control-status.json'
$priorities = Get-Priorities $queueOutput

$temporaryAudit = ''
try {
  if ($AuditPath) {
    $resolvedAuditPath = (Resolve-Path -LiteralPath $AuditPath).Path
  } else {
    $temporaryAudit = Join-Path ([IO.Path]::GetTempPath()) ("portfolio-checkpoint-audit-{0}.json" -f $PID)
    $global:LASTEXITCODE = 0
    & (Join-Path $PSScriptRoot 'validate-portfolio.ps1') -RepoRoot $resolvedRoot -JsonPath $temporaryAudit -RepositoryOverrides $RepositoryOverrides | Out-Null
    $validationExitCode = $LASTEXITCODE
    $global:LASTEXITCODE = 0
    if ($validationExitCode -ne 0) { throw "Portfolio validation failed with exit code $validationExitCode" }
    $resolvedAuditPath = $temporaryAudit
  }
  $audit = Get-Content -Raw -LiteralPath $resolvedAuditPath | ConvertFrom-Json
} finally {
  if ($temporaryAudit -and (Test-Path -LiteralPath $temporaryAudit)) {
    Remove-Item -LiteralPath $temporaryAudit -Force
  }
}

$auditRows = @($audit.repositories)
if ($auditRows.Count -eq 0) { throw 'Portfolio audit contains no repositories.' }
if ($ActiveProject -and $ActiveProject -notin @($auditRows | ForEach-Object name)) {
  throw "Active project '$ActiveProject' does not exist in the portfolio audit."
}

$timestamp = if ($GeneratedAt) { $GeneratedAt } else { (Get-Date).ToUniversalTime().ToString('o') }
try { [void][DateTimeOffset]::Parse($timestamp) } catch { throw "GeneratedAt is not a valid timestamp: $timestamp" }

$projects = @(
  foreach ($row in $auditRows) {
    $status = Get-Status $row
    $failed = @()
    if ([int]$row.placeholders -gt 0) { $failed += 'placeholder_scan' }
    if ([int]$row.dirty_files -gt 0) { $failed += 'clean_tree' }
    $blockers = @()
    if ($status -eq 'release-candidate' -and -not $row.remote_configured) { $blockers += 'origin remote is not configured' }
    if ($status -eq 'release-candidate' -and -not $row.upstream_configured) { $blockers += 'upstream branch is not configured' }
    [pscustomobject][ordered]@{
      id = [int]$row.id
      project = [string]$row.name
      status = $status
      phase = $status
      active = ([string]$row.name -eq $ActiveProject)
      declared_status = [string]$row.declared_status
      last_commit = [string]$row.head
      branch = [string]$row.branch
      upstream = [string]$row.upstream
      completed_gates = @(Get-CompletedGates $row)
      pending_gates = @(Get-PendingGates $row)
      failed_gates = @($failed)
      blockers = @($blockers)
      next_action = Get-NextAction $status $row
      evidence = [ordered]@{
        benchmark_contract_v2 = [bool]$row.benchmark_contract_v2
        local_candidate = [bool]$row.local_candidate
        publication_candidate = [bool]$row.publication_candidate
        publication_evidence = [bool]$row.publication_evidence
        published_verified = [bool]$row.published_verified
        dirty_files = [int]$row.dirty_files
      }
      updated_at = $timestamp
    }
  }
)

$allowedStatuses = @('scaffold','triage','specification','implementation','validation','release-candidate','blocked','completed')
$summary = [ordered]@{ total = $projects.Count }
foreach ($status in $allowedStatuses) {
  $summary[$status.Replace('-','_')] = @($projects | Where-Object status -eq $status).Count
}

$state = [ordered]@{
  version = '2.0.0'
  generated_at = $timestamp
  generated_by = 'tools/checkpoint-portfolio.ps1'
  evidence_policy = 'Statuses are derived from tools/validate-portfolio.ps1. File presence alone never means completed.'
  active_project = if ($ActiveProject) { $ActiveProject } else { 'none' }
  wip_limit = [ordered]@{ active_projects = 1; reusable_kit_improvements = 1 }
  summary = $summary
  projects = @($projects | Sort-Object id,project)
}
Write-Utf8 $stateOutput (($state | ConvertTo-Json -Depth 10) + [Environment]::NewLine)

$statusRank = @{
  'release-candidate' = 1
  validation = 2
  implementation = 3
  specification = 4
  triage = 5
  scaffold = 6
  blocked = 7
  completed = 8
}
$ordered = @($projects | Sort-Object @(
  @{ Expression = { if ($_.active) { 0 } else { 1 } } },
  @{ Expression = { if ($priorities.ContainsKey($_.project)) { $priorities[$_.project] } else { 1000 + $_.id } } },
  @{ Expression = { $statusRank[$_.status] } },
  @{ Expression = { $_.id } }
))
$queueLines = @(
  '# Project Queue',
  '',
  "Generated: $timestamp",
  '',
  '> Statuses are evidence-derived. A declared manifest status or the presence of Docker, CI, and a benchmark file is not completion.',
  '',
  '| Priority | ID | Project Name | Status | Publication evidence | Next action |',
  '|---:|---:|---|---|:---:|---|'
)
$priority = 0
foreach ($project in $ordered) {
  $priority++
  $next = ([string]$project.next_action).Replace('|','/')
  $queueLines += "| $priority | $($project.id.ToString('00')) | $($project.project) | $($project.status) | $($project.evidence.published_verified) | $next |"
}
Write-Utf8 $queueOutput (($queueLines -join [Environment]::NewLine) + [Environment]::NewLine)

$compatibilityStatus = [ordered]@{
  version = '2.0.0'
  repository_count = [int]$audit.repository_count
  docker_count = [int]$audit.docker_count
  ci_count = [int]$audit.ci_count
  benchmark_count = [int]$audit.tracked_benchmark_count
  control_count = @($auditRows | Where-Object control).Count
  local_candidate_count = [int]$audit.local_candidate_count
  publication_candidate_count = [int]$audit.publication_candidate_count
  complete_candidate_count = [int]$summary.completed
  active_project = $state.active_project
  last_updated = $timestamp
  generated_by = 'tools/checkpoint-portfolio.ps1'
  evidence_policy = 'complete_candidate_count equals published_verified only'
}
Write-Utf8 $statusOutput (($compatibilityStatus | ConvertTo-Json -Depth 5) + [Environment]::NewLine)

Write-Host ("portfolio checkpoint written: projects={0} completed={1} release_candidates={2} active={3}" -f $summary.total,$summary.completed,$summary.release_candidate,$state.active_project)
