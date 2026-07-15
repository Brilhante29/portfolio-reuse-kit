param(
  [ValidateSet("User", "Process", "Machine")]
  [string]$Scope = "User",
  [string]$Name = "GH_TOKEN",
  [switch]$SkipValidation
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

if (-not $SkipValidation) {
  try {
    $user = Invoke-RestMethod `
      -Method GET `
      -Uri "https://api.github.com/user" `
      -Headers @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
      }
    Write-Host "github_auth=ok login=$($user.login)"
  } catch {
    $token = $null
    throw "Token recusado pelo GitHub. Gere um token novo/completo e tente novamente."
  }
}

[Environment]::SetEnvironmentVariable($Name, $token, $Scope)
Set-Item -Path "Env:\$Name" -Value $token
$token = $null

Write-Host "env_var_set=$Name"
Write-Host "scope=$Scope"
if ($Scope -eq "User") {
  Write-Host "Abra um novo terminal para novos processos herdarem a variavel."
}
