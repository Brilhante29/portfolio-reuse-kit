param(
  [ValidateSet("User", "Process", "Machine")]
  [string[]]$Scope = @("User", "Process"),
  [string]$Name = "GH_TOKEN"
)

$ErrorActionPreference = "Stop"

foreach ($target in $Scope) {
  [Environment]::SetEnvironmentVariable($Name, $null, $target)
  Write-Host "env_var_cleared=$Name scope=$target"
}

Remove-Item "Env:\$Name" -ErrorAction SilentlyContinue
