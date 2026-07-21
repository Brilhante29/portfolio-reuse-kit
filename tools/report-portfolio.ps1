param(
  [Parameter(Mandatory=$true)] [string]$RepoRoot,
  [string]$MarkdownPath = "",
  [string]$JsonPath = ""
)

$ErrorActionPreference = "Stop"

function Scalar($body, $pattern, $default = "-") {
  $match = [regex]::Match($body, $pattern)
  if ($match.Success) { return $match.Groups[1].Value.Trim().Trim('"').Trim("'") }
  return $default
}
function Stack($body) {
  $match = [regex]::Match($body, '(?ms)^stack:\s*\r?\n(?<items>(?:\s+-[^\r\n]+\r?\n?)+)')
  if (-not $match.Success) { return "not-selected" }
  return (([regex]::Matches($match.Groups['items'].Value, '(?m)^\s+-\s*(.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() }) -join ', ')
}
function Write-Utf8($path, $content) {
  $parent = Split-Path -Parent $path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  $absolute = if ([IO.Path]::IsPathRooted($path)) { $path } else { Join-Path (Get-Location) $path }
  [IO.File]::WriteAllText($absolute, $content, (New-Object Text.UTF8Encoding($false)))
}

$root = (Resolve-Path -LiteralPath $RepoRoot).Path
$validator = Join-Path $PSScriptRoot 'validate-portfolio.ps1'
$temp = Join-Path ([IO.Path]::GetTempPath()) ("portfolio-validation-{0}.json" -f $PID)
try {
  & $validator -RepoRoot $root -JsonPath $temp | Out-Null
  $audit = Get-Content -Raw -LiteralPath $temp | ConvertFrom-Json
} finally {
  if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Force }
}

$rows = @($audit.repositories | ForEach-Object {
  $repo = Join-Path $root $_.name
  $manifestPath = Join-Path $repo 'project.yaml'
  $manifest = if (Test-Path -LiteralPath $manifestPath -PathType Leaf) { Get-Content -Raw -LiteralPath $manifestPath } else { '' }
  [pscustomobject]@{
    id = [int]$_.id
    name = $_.name
    program = Scalar $manifest '(?ms)^program:\s*\r?\n\s{2}id:\s*([^\r\n]+)' 'unassigned'
    declared_status = $_.declared_status
    language = Scalar $manifest '(?ms)^language_profile:\s*\r?\n\s{2}primary:\s*([^\r\n]+)' 'unassigned'
    stack = Stack $manifest
    architecture = Scalar $manifest '(?ms)^architecture:\s*\r?\n\s{2}style:\s*([^\r\n]+)' 'unassigned'
    api = Scalar $manifest '(?m)^\s{2}api_style:\s*([^\r\n]+)' 'unassigned'
    messaging = Scalar $manifest '(?m)^\s{2}messaging:\s*([^\r\n]+)' 'unassigned'
    cloud = Scalar $manifest '(?ms)^\s{2}cloud:\s*\r?\n\s{4}mode:\s*([^\r\n]+)' 'unassigned'
    database = Scalar $manifest '(?m)^\s{2}database:\s*([^\r\n]+)' 'unassigned'
    docker = $_.docker
    ci = $_.ci
    benchmark_tracked = $_.benchmark_tracked
    benchmark_contract = $_.benchmark_contract
    placeholders = $_.placeholders
    dirty_files = $_.dirty_files
    remote_configured = $_.remote_configured
    upstream_configured = $_.upstream_configured
    local_candidate = $_.local_candidate
    published_verified = $_.published_verified
  }
} | Sort-Object id,name)

$summary = [ordered]@{
  generated_at = (Get-Date).ToUniversalTime().ToString('o')
  repositories = $rows.Count
  docker = @($rows | Where-Object docker).Count
  ci = @($rows | Where-Object ci).Count
  tracked_benchmarks = @($rows | Where-Object benchmark_tracked).Count
  contract_benchmarks = @($rows | Where-Object benchmark_contract).Count
  local_candidates = @($rows | Where-Object local_candidate).Count
  published_verified = @($rows | Where-Object published_verified).Count
  remote_configured = @($rows | Where-Object remote_configured).Count
  upstream_configured = @($rows | Where-Object upstream_configured).Count
  clean = @($rows | Where-Object { $_.dirty_files -eq 0 }).Count
  rows = $rows
}

if ($JsonPath) { Write-Utf8 $JsonPath (($summary | ConvertTo-Json -Depth 8) + [Environment]::NewLine) }
if ($MarkdownPath) {
  $lines = @(
    '# Portfolio Status Report', '',
    ("Generated: {0}" -f $summary.generated_at), '',
    ("Repositories: **{0}** | Docker: **{1}** | CI files: **{2}** | tracked benchmarks: **{3}** | contract-valid benchmarks: **{4}** | local candidates: **{5}** | verified publications: **{6}** | origins: **{7}** | upstreams: **{8}**" -f $summary.repositories,$summary.docker,$summary.ci,$summary.tracked_benchmarks,$summary.contract_benchmarks,$summary.local_candidates,$summary.published_verified,$summary.remote_configured,$summary.upstream_configured), '',
    '| # | Repository | Program | Declared | Language | Stack | Architecture | API | Messaging | Cloud | Database | Benchmark | Contract | Placeholders | Local | Published |',
    '|---:|---|---|---|---|---|---|---|---|---|---|:---:|:---:|---:|:---:|:---:|'
  )
  foreach ($row in $rows) {
    $lines += ("| {0} | `{1}` | `{2}` | `{3}` | `{4}` | {5} | `{6}` | `{7}` | `{8}` | `{9}` | `{10}` | {11} | {12} | {13} | {14} | {15} |" -f $row.id,$row.name,$row.program,$row.declared_status,$row.language,$row.stack,$row.architecture,$row.api,$row.messaging,$row.cloud,$row.database,$row.benchmark_tracked,$row.benchmark_contract,$row.placeholders,$row.local_candidate,$row.published_verified)
  }
  Write-Utf8 $MarkdownPath (($lines -join [Environment]::NewLine) + [Environment]::NewLine)
}
$summary | ConvertTo-Json -Depth 8