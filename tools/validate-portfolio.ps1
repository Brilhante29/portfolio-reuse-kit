param(
  [string]$RepoRoot = "",
  [switch]$Strict,
  [switch]$RequirePublished,
  [string]$JsonPath = ""
)

$ErrorActionPreference = "Stop"
$kitRoot = Split-Path -Parent $PSScriptRoot
if (-not $RepoRoot) { $RepoRoot = Split-Path -Parent $kitRoot }
$resolvedRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

function Get-Scalar {
  param([string]$Body, [string]$Pattern, [string]$Default = "")
  $match = [regex]::Match($Body, $Pattern)
  if (-not $match.Success) { return $Default }
  return $match.Groups[1].Value.Trim().Trim('"').Trim("'")
}

function Get-GitLines {
  param([string]$Repo, [string[]]$Arguments)
  $previousPreference = $ErrorActionPreference
  $ErrorActionPreference = 'SilentlyContinue'
  $output = @(& git -C $Repo @Arguments 2>$null)
  $code = $LASTEXITCODE
  $global:LASTEXITCODE = 0
  $ErrorActionPreference = $previousPreference
  if ($code -ne 0) { return @() }
  return @($output | Where-Object { $_ -and $_.Trim() })
}

function Test-BenchmarkContract {
  param([string]$Repo, [string[]]$Files)
  if ($Files.Count -eq 0) { return $false }
  $required = @('project','metric','value','unit','timestamp','command')
  foreach ($file in $Files) {
    try { $result = Get-Content -Raw -LiteralPath (Join-Path $Repo $file) | ConvertFrom-Json }
    catch { return $false }
    $names = @($result.PSObject.Properties.Name)
    foreach ($field in $required) { if ($field -notin $names) { return $false } }
  }
  return $true
}

function Test-BenchmarkContractV2 {
  param([string]$Repo, [string]$File)
  if (-not $File) { return $false }
  try { $result = Get-Content -Raw -LiteralPath (Join-Path $Repo $File) | ConvertFrom-Json }
  catch { return $false }
  $required = @('schema_version','run_id','project','benchmark_id','workload','metrics','execution','environment','provenance','comparability_key')
  $names = @($result.PSObject.Properties.Name)
  foreach ($field in $required) { if ($field -notin $names) { return $false } }
  if ($result.schema_version -ne 2) { return $false }
  if ([string]$result.run_id -notmatch '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-8][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$') { return $false }
  if (-not $result.project -or -not $result.benchmark_id -or [string]$result.comparability_key -notmatch '^[a-z0-9][a-z0-9._:-]*$') { return $false }
  $workloadRequired = @('version','fixture_digest','config_digest','warmup_iterations','measured_iterations','concurrency')
  $workloadNames = @($result.workload.PSObject.Properties.Name)
  foreach ($field in $workloadRequired) { if ($field -notin $workloadNames) { return $false } }
  if ([string]$result.workload.fixture_digest -notmatch '^sha256:[0-9a-f]{64}$' -or [string]$result.workload.config_digest -notmatch '^sha256:[0-9a-f]{64}$') { return $false }
  if ([int]$result.workload.warmup_iterations -lt 0 -or [int]$result.workload.measured_iterations -lt 1 -or [int]$result.workload.concurrency -lt 1) { return $false }
  if (@($result.metrics).Count -lt 1) { return $false }
  foreach ($metric in @($result.metrics)) {
    $metricRequired = @('name','value','unit','direction','samples','failures','summary')
    $metricNames = @($metric.PSObject.Properties.Name)
    foreach ($field in $metricRequired) { if ($field -notin $metricNames) { return $false } }
    if ($metric.direction -notin @('higher_is_better','lower_is_better','target') -or @($metric.samples).Count -lt 1 -or [int]$metric.failures -lt 0) { return $false }
  }
  if (-not $result.execution.command -or [double]$result.execution.duration_seconds -lt 0 -or [int]$result.execution.exit_code -ne 0 -or [int]$result.execution.repeat -lt 1) { return $false }
  if (-not $result.environment.runtime -or -not $result.environment.architecture -or -not $result.environment.hardware_class) { return $false }
  if ([string]$result.provenance.source_commit -notmatch '^[0-9a-f]{40}$' -or $result.provenance.clean_tree -ne $true) { return $false }
  foreach ($digest in @('image_digest','dependency_lock_digest','artifact_digest')) {
    if ([string]$result.provenance.$digest -notmatch '^sha256:[0-9a-f]{64}$') { return $false }
  }
  if (-not $result.provenance.image_ref -or $result.provenance.producer -notin @('local','github-actions','other-ci')) { return $false }
  return $true
}
function Get-PlaceholderCount {
  param([string]$Repo, [string[]]$TrackedFiles)
  $docs = @($TrackedFiles | Where-Object { $_ -match '^(sdd|openspec)/.*\.md$' })
  $count = 0
  foreach ($doc in $docs) {
    $path = Join-Path $Repo $doc
    if (Test-Path -LiteralPath $path -PathType Leaf) {
      $count += @(Select-String -LiteralPath $path -Pattern '<(scope|problem|metric|implementation|verification)>|\b(TODO|TBD)\b' -AllMatches -ErrorAction SilentlyContinue).Count
    }
  }
  return $count
}

function Get-GitState {
  param([string]$Repo)
  $lines = @(Get-GitLines $Repo @('status','--porcelain=v2','--branch'))
  $head = ''
  $upstream = ''
  $dirty = 0
  foreach ($line in $lines) {
    if ($line -match '^# branch\.oid (.+)$') { $head = $matches[1] }
    elseif ($line -match '^# branch\.upstream (.+)$') { $upstream = $matches[1] }
    elseif (-not $line.StartsWith('#')) { $dirty++ }
  }
  return [pscustomobject]@{ head = $head; upstream = $upstream; dirty_files = $dirty }
}

function Test-PublicationEvidence {
  param([string]$Name,[string]$Head,[string]$Remote,[string]$Upstream,[string[]]$KitTrackedFiles)
  if (-not $Remote -or -not $Upstream -or -not $Head) { return $false }
  $relative = ".portfolio-control/publications/$Name.json"
  if ($relative -notin $KitTrackedFiles) { return $false }
  $evidencePath = Join-Path $kitRoot $relative
  try { $evidence = Get-Content -Raw -LiteralPath $evidencePath | ConvertFrom-Json }
  catch { return $false }
  $normalizedRemote = $Remote.TrimEnd('/').Replace('.git','')
  $normalizedEvidence = ([string]$evidence.remote_url).TrimEnd('/').Replace('.git','')
  return (
    $evidence.repository -eq $Name -and
    $evidence.commit_sha -eq $Head -and
    $evidence.ci_conclusion -eq 'success' -and
    $normalizedEvidence -eq $normalizedRemote -and
    ([string]$evidence.ci_run_url) -match '^https://github\.com/.+/actions/runs/\d+'
  )
}

$kitTrackedFiles = @(Get-GitLines $kitRoot @('ls-files'))
$repositories = @(Get-ChildItem -Directory -LiteralPath $resolvedRoot | Where-Object {
  $_.Name -ne 'portfolio-reuse-kit' -and (Test-Path -LiteralPath (Join-Path $_.FullName '.git') -PathType Container)
} | Sort-Object Name)
$snapshotScript = {
  param($repo,$name)
  $ErrorActionPreference = 'SilentlyContinue'
  $tracked = @(& git -C $repo ls-files 2>$null)
  $statusLines = @(& git -C $repo status --porcelain=v2 --branch 2>$null)
  $head = ''
  $upstream = ''
  $dirty = 0
  foreach ($line in $statusLines) {
    if ($line -match '^# branch\.oid (.+)$') { $head = $matches[1] }
    elseif ($line -match '^# branch\.upstream (.+)$') { $upstream = $matches[1] }
    elseif (-not $line.StartsWith('#')) { $dirty++ }
  }
  $config = Get-Content -Raw -LiteralPath (Join-Path $repo '.git/config') -ErrorAction SilentlyContinue
  $remote = ''
  $remoteSection = [regex]::Match($config,'(?ms)^\[remote "origin"\]\s*(?<body>.*?)(?=^\[|\z)')
  if ($remoteSection.Success) {
    $url = [regex]::Match($remoteSection.Groups['body'].Value,'(?m)^\s*url\s*=\s*(.+)$')
    if ($url.Success) { $remote = $url.Groups[1].Value.Trim() }
  }
  [pscustomobject]@{
    name = $name
    full_name = $repo
    tracked = $tracked
    head = $head
    upstream = $upstream
    dirty_files = $dirty
    remote = $remote
  }
}
$pool = [runspacefactory]::CreateRunspacePool(1,16)
$pool.Open()
$pending = @()
try {
  foreach ($directory in $repositories) {
    $powerShell = [powershell]::Create()
    $powerShell.RunspacePool = $pool
    [void]$powerShell.AddScript($snapshotScript.ToString()).AddArgument($directory.FullName).AddArgument($directory.Name)
    $pending += [pscustomobject]@{ powerShell = $powerShell; async = $powerShell.BeginInvoke() }
  }
  $snapshots = @($pending | ForEach-Object { $_.powerShell.EndInvoke($_.async) })
} finally {
  foreach ($job in $pending) { $job.powerShell.Dispose() }
  $pool.Close()
  $pool.Dispose()
}
$rows = New-Object System.Collections.Generic.List[object]

foreach ($snapshot in $snapshots | Sort-Object name) {
  $repo = $snapshot.full_name
  $tracked = @($snapshot.tracked)
  $gitState = $snapshot
  $remote = $snapshot.remote
  $manifestPath = Join-Path $repo 'project.yaml'
  $manifest = if (Test-Path -LiteralPath $manifestPath -PathType Leaf) { Get-Content -Raw -LiteralPath $manifestPath } else { '' }
  $status = Get-Scalar $manifest '(?m)^status:\s*(.+)$' 'missing'
  $benchmarkResultPath = Get-Scalar $manifest '(?m)^\s{2}result_path:\s*(.+)$' ''
  $benchmarkFiles = if ($benchmarkResultPath -and $benchmarkResultPath -in $tracked) { @($benchmarkResultPath) } else { @() }
  $workflowFiles = @($tracked | Where-Object { $_ -match '^\.github/workflows/.+\.ya?ml$' })
  $requiredSdd = @('sdd/spec.md','sdd/benchmark-plan.md','sdd/reuse-improvement-review.md')
  $requiredControl = @('.portfolio-control/INVENTORY.md','.portfolio-control/REUSE_MAP.md','.portfolio-control/QUALITY_GATES.md')
  $firstLine = if ('README.md' -in $tracked) { Get-Content -LiteralPath (Join-Path $repo 'README.md') -TotalCount 1 } else { '' }
  $benchmarkContract = Test-BenchmarkContract $repo $benchmarkFiles
  $benchmarkContractV2 = Test-BenchmarkContractV2 $repo $benchmarkResultPath
  $placeholderCount = Get-PlaceholderCount $repo $tracked

  $checks = [ordered]@{
    numbered_readme = ('README.md' -in $tracked -and $firstLine -match '^#\s*#?\d+\s+')
    docker = 'Dockerfile' -in $tracked
    ci = $workflowFiles.Count -gt 0
    sdd = @($requiredSdd | Where-Object { $_ -in $tracked }).Count -eq $requiredSdd.Count
    benchmark_tracked = $benchmarkFiles.Count -gt 0
    benchmark_contract = $benchmarkContract
    control = @($requiredControl | Where-Object { $_ -in $tracked }).Count -eq $requiredControl.Count
    no_placeholders = $placeholderCount -eq 0
    clean = $gitState.dirty_files -eq 0
  }
  $allLocalGates = -not ($checks.Values -contains $false)
  $localCandidate = $allLocalGates -and $status -in @('benchmarked','published')
  $publicationCandidate = $localCandidate -and $benchmarkContractV2
  $publicationEvidence = Test-PublicationEvidence $snapshot.name $gitState.head $remote $gitState.upstream $kitTrackedFiles
  $publishedVerified = $publicationCandidate -and $publicationEvidence

  $rows.Add([pscustomobject]@{
    id = Get-Scalar $manifest '(?m)^id:\s*(.+)$' '?'
    name = $snapshot.name
    declared_status = $status
    docker = [bool]$checks.docker
    ci = [bool]$checks.ci
    benchmark_tracked = [bool]$checks.benchmark_tracked
    benchmark_contract = [bool]$checks.benchmark_contract
    benchmark_contract_v2 = [bool]$benchmarkContractV2
    control = [bool]$checks.control
    placeholders = $placeholderCount
    dirty_files = $gitState.dirty_files
    remote_configured = [bool]$remote
    upstream_configured = [bool]$gitState.upstream
    local_candidate = $localCandidate
    publication_candidate = $publicationCandidate
    publication_evidence = $publicationEvidence
    published_verified = $publishedVerified
    complete_candidate = $publishedVerified
    declared_published_unverified = ($status -eq 'published' -and -not $publishedVerified)
  })
}

$summary = [pscustomobject]@{
  generated_at = (Get-Date).ToUniversalTime().ToString('o')
  repository_count = $rows.Count
  docker_count = @($rows | Where-Object docker).Count
  ci_count = @($rows | Where-Object ci).Count
  tracked_benchmark_count = @($rows | Where-Object benchmark_tracked).Count
  contract_benchmark_count = @($rows | Where-Object benchmark_contract).Count
  contract_v2_benchmark_count = @($rows | Where-Object benchmark_contract_v2).Count
  publication_candidate_count = @($rows | Where-Object publication_candidate).Count
  control_count = @($rows | Where-Object control).Count
  local_candidate_count = @($rows | Where-Object local_candidate).Count
  published_verified_count = @($rows | Where-Object published_verified).Count
  declared_published_unverified_count = @($rows | Where-Object declared_published_unverified).Count
  repositories = $rows
}

$rows | Format-Table id,name,declared_status,benchmark_tracked,benchmark_contract,benchmark_contract_v2,placeholders,local_candidate,publication_candidate,published_verified -AutoSize
if ($JsonPath) {
  $parent = Split-Path -Parent $JsonPath
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [IO.File]::WriteAllText($JsonPath,(($summary | ConvertTo-Json -Depth 8)+[Environment]::NewLine),(New-Object Text.UTF8Encoding($false)))
}
Write-Host ("repositories={0} docker={1} ci={2} tracked_benchmarks={3} contract_benchmarks={4} contract_v2={5} local_candidates={6} publication_candidates={7} published_verified={8} declared_published_unverified={9}" -f $summary.repository_count,$summary.docker_count,$summary.ci_count,$summary.tracked_benchmark_count,$summary.contract_benchmark_count,$summary.contract_v2_benchmark_count,$summary.local_candidate_count,$summary.publication_candidate_count,$summary.published_verified_count,$summary.declared_published_unverified_count)
if ($Strict -and $summary.local_candidate_count -ne $summary.repository_count) { exit 1 }
if ($RequirePublished -and $summary.published_verified_count -ne $summary.repository_count) { exit 1 }