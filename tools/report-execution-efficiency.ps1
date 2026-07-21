param(
  [string]$LogPath = "",
  [string]$MarkdownPath = "",
  [string]$JsonPath = ""
)

$ErrorActionPreference = "Stop"
$kitRoot = Split-Path -Parent $PSScriptRoot
if (-not $LogPath) { $LogPath = Join-Path $kitRoot ".portfolio-control/EXECUTION_EVENTS.jsonl" }
if (-not $MarkdownPath) { $MarkdownPath = Join-Path $kitRoot ".portfolio-control/EXECUTION_EFFICIENCY.md" }

$events = @()
if (Test-Path -LiteralPath $LogPath -PathType Leaf) {
  $lineNumber = 0
  foreach ($line in Get-Content -LiteralPath $LogPath) {
    $lineNumber++
    if (-not $line.Trim()) { continue }
    try { $events += ($line | ConvertFrom-Json) }
    catch { throw "Invalid execution event JSON at line $lineNumber" }
  }
}

$included = @($events | Where-Object { -not $_.excluded_from_efficiency })
$hardLimits = ($included | Where-Object { $_.category -eq "authorization-limit" } | Measure-Object -Property occurrences -Sum).Sum
$waitTimeouts = ($included | Where-Object { $_.category -eq "wait-timeout" } | Measure-Object -Property occurrences -Sum).Sum
$avoidable = ($included | Where-Object { $_.avoidable } | Measure-Object -Property occurrences -Sum).Sum
$duration = ($included | Measure-Object -Property duration_seconds -Sum).Sum
if ($null -eq $hardLimits) { $hardLimits = 0 }
if ($null -eq $waitTimeouts) { $waitTimeouts = 0 }
if ($null -eq $avoidable) { $avoidable = 0 }
if ($null -eq $duration) { $duration = 0 }

$categories = @($included | Group-Object category | ForEach-Object {
  [pscustomobject]@{
    category = $_.Name
    events = $_.Count
    occurrences = ($_.Group | Measure-Object -Property occurrences -Sum).Sum
    duration_seconds = [math]::Round(($_.Group | Measure-Object -Property duration_seconds -Sum).Sum, 3)
  }
} | Sort-Object -Property @{ Expression = "occurrences"; Descending = $true }, @{ Expression = "category"; Descending = $false })

$summary = [ordered]@{
  generated_at = (Get-Date).ToUniversalTime().ToString("o")
  excluded_windows = @("2026-07-20: user-operated Antigravity/OpenCode activity")
  event_records = $included.Count
  occurrence_count = ($included | Measure-Object -Property occurrences -Sum).Sum
  hard_limit_occurrences = $hardLimits
  wait_timeout_occurrences = $waitTimeouts
  avoidable_occurrences = $avoidable
  tracked_duration_seconds = [math]::Round($duration, 3)
  categories = $categories
}

$lines = @(
  "# Execution Efficiency", "",
  ("Generated: {0}" -f $summary.generated_at), "",
  "Excluded: 2026-07-20, attributed by the user to Antigravity/OpenCode.", "",
  ("Hard limits: **{0}** | wait timeouts: **{1}** | avoidable occurrences: **{2}** | tracked duration: **{3} s**" -f $hardLimits,$waitTimeouts,$avoidable,$summary.tracked_duration_seconds), "",
  "| Category | Event records | Occurrences | Duration (s) |", "|---|---:|---:|---:|"
)
foreach ($row in $categories) { $lines += ("| {0} | {1} | {2} | {3} |" -f $row.category,$row.events,$row.occurrences,$row.duration_seconds) }
$lines += @("", "## Prevention Rules", "")
foreach ($rule in @($included.remediation | Where-Object { $_ } | Sort-Object -Unique)) { $lines += "- $rule" }

[System.IO.File]::WriteAllText($MarkdownPath, (($lines -join [Environment]::NewLine) + [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false)))
if ($JsonPath) { [System.IO.File]::WriteAllText($JsonPath, (($summary | ConvertTo-Json -Depth 8) + [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false))) }
$summary | ConvertTo-Json -Depth 8
