param(
  [Parameter(Mandatory=$true)]
  [string]$RepoRoot,
  [string]$Owner = "Brilhante29",
  [ValidateSet("public", "private")]
  [string]$Visibility = "public",
  [string]$Branch = "main",
  [string]$Token = $env:GH_TOKEN,
  [switch]$NoCommit,
  [switch]$NoPush
)

$ErrorActionPreference = "Stop"

if (-not $Token) {
  $secure = Read-Host "GitHub token" -AsSecureString
  $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  try {
    $Token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
  }
}

$root = Resolve-Path -LiteralPath $RepoRoot
$script = Join-Path $PSScriptRoot "publish-github.ps1"
$repos = Get-ChildItem -Directory -LiteralPath $root | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName ".git") }

foreach ($repo in $repos) {
  Write-Host "Publishing $($repo.Name)"
  & $script `
    -RepoPath $repo.FullName `
    -Owner $Owner `
    -RepoName $repo.Name `
    -Visibility $Visibility `
    -Branch $Branch `
    -Token $Token `
    -CommitMessage "Publish $($repo.Name)" `
    -NoCommit:$NoCommit `
    -NoPush:$NoPush
}

$Token = $null