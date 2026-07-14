param(
  [ValidateSet("User", "Process")]
  [string]$Scope = "User",
  [string]$Name = "GH_TOKEN"
)

$ErrorActionPreference = "Stop"

$secure = Read-Host "GitHub token" -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try {
  $token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
} finally {
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
}

if (-not $token) {
  throw "Token vazio. Nenhuma variavel foi gravada."
}

[Environment]::SetEnvironmentVariable($Name, $token, $Scope)
Set-Item -Path "Env:\$Name" -Value $token
$token = $null

Write-Host "env_var_set=$Name"
Write-Host "scope=$Scope"
if ($Scope -eq "User") {
  Write-Host "Abra um novo terminal para novos processos herdarem a variavel."
}
