param(
  [Parameter(Mandatory=$true)] [string]$RepoRoot,
  [string]$MarkdownPath = "",
  [string]$JsonPath = ""
)

$ErrorActionPreference = "Stop"

function Text($value) { return (($value -join "").Trim()) }
function Scalar($body, $pattern, $default = "-") {
  $match = [regex]::Match($body, $pattern)
  if ($match.Success) { return $match.Groups[1].Value.Trim().Trim('"').Trim("'") }
  return $default
}
function Stack($body) {
  $match = [regex]::Match($body, '(?ms)^stack:\s*\r?\n(?<items>(?:\s+-[^\r\n]+\r?\n?)+)')
  if (-not $match.Success) { return "not-selected" }
  return (([regex]::Matches($match.Groups["items"].Value, '(?m)^\s+-\s*(.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() }) -join ", ")
}
function CatalogId($catalog, $name) {
  $match = [regex]::Match($catalog, "(?ms)^\s{2}- id:\s*(\d+)\s*\r?\n\s{4}name:\s*" + [regex]::Escape($name) + "\s*$")
  if ($match.Success) { return [int]$match.Groups[1].Value }
  return 0
}
function Write-Utf8($path, $content) {
  $parent = Split-Path -Parent $path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $parent).Path + "\" + (Split-Path -Leaf $path), $content, (New-Object System.Text.UTF8Encoding($false)))
}

$root = (Resolve-Path -LiteralPath $RepoRoot).Path
$catalogPath = Join-Path $root "portfolio-reuse-kit/catalog/projects.yaml"
$catalog = if (Test-Path -LiteralPath $catalogPath -PathType Leaf) { Get-Content -Raw -LiteralPath $catalogPath } else { "" }
$rows = @(
  Get-ChildItem -Directory -LiteralPath $root |
    Where-Object { $_.Name -ne "portfolio-reuse-kit" -and (Test-Path (Join-Path $_.FullName ".git") -PathType Container) } |
    ForEach-Object {
      $repo = $_.FullName
      $manifestPath = Join-Path $repo "project.yaml"
      $manifest = if (Test-Path $manifestPath -PathType Leaf) { Get-Content -Raw $manifestPath } else { "" }
      $docker = Test-Path (Join-Path $repo "Dockerfile") -PathType Leaf
      $ci = Test-Path (Join-Path $repo ".github/workflows") -PathType Container
      $benchmark = (@(Get-ChildItem (Join-Path $repo "benchmarks/results") -Filter *.json -File -ErrorAction SilentlyContinue)).Count -gt 0
      $control = Test-Path (Join-Path $repo ".portfolio-control/QUALITY_GATES.md") -PathType Leaf
      $readme = if (Test-Path (Join-Path $repo "README.md") -PathType Leaf) { Get-Content (Join-Path $repo "README.md") -TotalCount 1 } else { "" }
      $status = Scalar $manifest '(?m)^status:\s*([^\r\n]+)' 'missing'
      $remote = Text (git -C $repo config --get remote.origin.url 2>$null)
      $upstream = ""
      try {
        $upstream = Text (git -C $repo rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null)
      } catch { $upstream = "" }
      [pscustomobject]@{
        id = CatalogId $catalog $_.Name
        name = $_.Name
        program = Scalar $manifest '(?ms)^program:\s*\r?\n\s{2}id:\s*([^\r\n]+)' "unassigned"
        status = Scalar $manifest '(?m)^status:\s*([^\r\n]+)' "missing"
        language = Scalar $manifest '(?ms)^language_profile:\s*\r?\n\s{2}primary:\s*([^\r\n]+)' "unassigned"
        stack = Stack $manifest
        architecture = Scalar $manifest '(?ms)^architecture:\s*\r?\n\s{2}style:\s*([^\r\n]+)' "unassigned"
        api = Scalar $manifest '(?m)^\s{2}api_style:\s*([^\r\n]+)' "unassigned"
        messaging = Scalar $manifest '(?m)^\s{2}messaging:\s*([^\r\n]+)' "unassigned"
        cloud = Scalar $manifest '(?ms)^\s{2}cloud:\s*\r?\n\s{4}mode:\s*([^\r\n]+)' "unassigned"
        database = Scalar $manifest '(?m)^\s{2}database:\s*([^\r\n]+)' "unassigned"
        branch = Text (git -C $repo branch --show-current 2>$null)
        remote_configured = [bool]$remote
        upstream = if ($upstream) { $upstream } else { "none" }
        dirty_files = @(git -C $repo status --porcelain 2>$null).Count
        docker = $docker
        ci = $ci
        benchmark = $benchmark
        control = $control
        complete_candidate = ($status -in @("benchmarked", "published") -and $docker -and $ci -and $benchmark -and $control -and ($readme -match '^#\s*#?\d+\s+') -and (Test-Path (Join-Path $repo "sdd") -PathType Container))
      }
    } | Sort-Object id, name
)
$summary = [ordered]@{
  generated_at = (Get-Date).ToUniversalTime().ToString("o")
  repositories = $rows.Count
  docker = @($rows | Where-Object docker).Count
  ci = @($rows | Where-Object ci).Count
  benchmarks = @($rows | Where-Object benchmark).Count
  control = @($rows | Where-Object control).Count
  complete_candidates = @($rows | Where-Object complete_candidate).Count
  upstream_configured = @($rows | Where-Object { $_.upstream -ne "none" }).Count
  clean = @($rows | Where-Object { $_.dirty_files -eq 0 }).Count
  dirty = @($rows | Where-Object { $_.dirty_files -gt 0 }).Count
  rows = $rows
}
if ($JsonPath) { Write-Utf8 $JsonPath ($summary | ConvertTo-Json -Depth 8) }
if ($MarkdownPath) {
  $lines = @(
    "# Portfolio Status Report", "",
    ("Generated: {0}" -f $summary.generated_at), "",
    ("Repositories: **{0}** | Docker: **{1}** | CI: **{2}** | benchmarks: **{3}** | control: **{4}** | complete candidates: **{5}** | upstream: **{6}**" -f $summary.repositories,$summary.docker,$summary.ci,$summary.benchmarks,$summary.control,$summary.complete_candidates,$summary.upstream_configured), "",
    "| # | Repository | Program | Status | Language | Stack | Architecture | API | Messaging | Cloud | Database | Docker | CI | Benchmark | Upstream | Dirty |",
    "|---:|---|---|---|---|---|---|---|---|---|---|:---:|:---:|:---:|---|---:|"
  )
  foreach ($row in $rows) { $lines += ("| {0} | `{1}` | `{2}` | `{3}` | `{4}` | `{5}` | `{6}` | `{7}` | `{8}` | `{9}` | `{10}` | {11} | {12} | {13} | `{14}` | {15} |" -f $row.id,$row.name,$row.program,$row.status,$row.language,$row.stack,$row.architecture,$row.api,$row.messaging,$row.cloud,$row.database,$row.docker,$row.ci,$row.benchmark,$row.upstream,$row.dirty_files) }
  Write-Utf8 $MarkdownPath (($lines -join [Environment]::NewLine) + [Environment]::NewLine)
}
$summary | ConvertTo-Json -Depth 8



