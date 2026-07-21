param(
  [Parameter(Mandatory=$true)] [string]$EventId,
  [ValidateSet("principal-agent", "subagent", "user", "external-tool")] [string]$Actor = "principal-agent",
  [string]$Tool = "unknown",
  [string]$Repository = "",
  [ValidateSet("discovery", "delegation", "implementation", "validation", "benchmark", "docker", "publication", "reporting")] [string]$Phase,
  [ValidateSet("authorization-limit", "wait-timeout", "command-timeout", "agent-no-progress", "tool-failure", "invalid-command", "invalid-diagnostic", "redundant-work", "external-auth-failure", "excluded-window")] [string]$Category,
  [ValidateSet("blocked", "no-progress", "partial", "recovered")] [string]$Outcome,
  [ValidateRange(1, 1000000)] [int]$Occurrences = 1,
  [ValidateRange(0, 31536000)] [double]$DurationSeconds = 0,
  [switch]$Avoidable,
  [switch]$ExcludedFromEfficiency,
  [string]$SourceWindow = "",
  [Parameter(Mandatory=$true)] [string]$Evidence,
  [Parameter(Mandatory=$true)] [string]$Cause,
  [Parameter(Mandatory=$true)] [string]$Remediation,
  [string]$LogPath = ""
)

$ErrorActionPreference = "Stop"
$kitRoot = Split-Path -Parent $PSScriptRoot
if (-not $LogPath) { $LogPath = Join-Path $kitRoot ".portfolio-control/EXECUTION_EVENTS.jsonl" }
if ($EventId -notmatch "^[a-z0-9][a-z0-9._-]{2,127}$") { throw "Invalid EventId" }
if ($Repository -and $Repository -notmatch "^[a-z0-9][a-z0-9._-]*$") { throw "Invalid Repository" }

$event = [ordered]@{
  schema_version = 1
  event_id = $EventId
  recorded_at = (Get-Date).ToUniversalTime().ToString("o")
  source_window = $SourceWindow
  actor = $Actor
  tool = $Tool
  repository = $Repository
  phase = $Phase
  category = $Category
  outcome = $Outcome
  occurrences = $Occurrences
  duration_seconds = $DurationSeconds
  avoidable = [bool]$Avoidable
  excluded_from_efficiency = [bool]$ExcludedFromEfficiency
  evidence = $Evidence
  cause = $Cause
  remediation = $Remediation
}

$parent = Split-Path -Parent $LogPath
if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
$line = $event | ConvertTo-Json -Compress
[System.IO.File]::AppendAllText($LogPath, $line + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
Write-Host ("recorded={0}; category={1}; occurrences={2}" -f $EventId,$Category,$Occurrences)
