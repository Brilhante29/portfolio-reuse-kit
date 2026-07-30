param(
  [ValidateSet("User", "Process", "Machine")]
  [string[]]$Scope = @("User", "Process"),
  [string]$Name = "GH_TOKEN",
  [string]$RepoRoot = "",
  [switch]$SanitizeGitConfig
)

$ErrorActionPreference = "Stop"

foreach ($target in $Scope) {
  [Environment]::SetEnvironmentVariable($Name, $null, $target)
  Write-Host "env_var_cleared=$Name scope=$target"
}

Remove-Item "Env:\$Name" -ErrorAction SilentlyContinue

if ($SanitizeGitConfig) {
  if (-not $RepoRoot) { throw 'RepoRoot is required with SanitizeGitConfig.' }
  $result = & (Join-Path $PSScriptRoot 'sanitize-git-auth.ps1') -RepoRoot $RepoRoot
  Write-Host ("git_config_scanned={0} sanitized={1} remaining={2}" -f $result.scanned_repositories,$result.sanitized_repositories,$result.affected_after)
}
