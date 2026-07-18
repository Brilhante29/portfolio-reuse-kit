param(
  [string]$RepoPath = ".",
  [string]$Owner = "Brilhante29",
  [string]$RepoName,
  [string]$Description = "",
  [ValidateSet("public", "private")]
  [string]$Visibility = "public",
  [string]$Branch = "",
  [string]$RemoteName = "origin",
  [string]$CommitMessage = "Publish repository",
  [string]$Token = $env:GH_TOKEN,
  [switch]$NoCommit,
  [switch]$NoPush,
  [switch]$AllowIncomplete,
  [switch]$AllowDirty
)

$ErrorActionPreference = "Stop"

function Get-EnvironmentSecret {
  param([string]$Name)

  foreach ($scope in @("Process", "User", "Machine")) {
    $value = [Environment]::GetEnvironmentVariable($Name, $scope)
    if ($value) { return $value }
  }

  return $null
}

function Invoke-Git {
  param([string[]]$Arguments)
  & git @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Arguments -join ' ') failed"
  }
}

function Get-GitOutput {
  param([string[]]$Arguments)
  $output = & git @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Arguments -join ' ') failed"
  }
  return $output
}

function Invoke-GitHubJson {
  param(
    [Parameter(Mandatory=$true)] [string]$Method,
    [Parameter(Mandatory=$true)] [string]$Uri,
    [object]$Body = $null
  )

  $headers = @{
    Authorization = "Bearer $Token"
    Accept = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
  }

  if ($null -eq $Body) {
    return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
  }

  return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body ($Body | ConvertTo-Json -Depth 10) -ContentType "application/json"
}

if (-not $Token) {
  $Token = Get-EnvironmentSecret "GH_TOKEN"
}

if (-not $Token) {
  $secure = Read-Host "GitHub token" -AsSecureString
  $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  try {
    $Token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
  }
}

if (-not $Token) {
  throw "Missing token. Set GH_TOKEN or pass -Token. Prefer a short-lived token; revoke it after publishing."
}

$resolvedRepo = Resolve-Path -LiteralPath $RepoPath
if (-not $Branch) {
  $Branch = ((git branch --show-current 2>$null) -join "").Trim()
  if (-not $Branch) { $Branch = "main" }
}
$isKit = ((Split-Path -Leaf $resolvedRepo) -eq "portfolio-reuse-kit")
if (-not $isKit -and -not $AllowIncomplete) {
  $manifestText = Get-Content -Raw -LiteralPath "project.yaml"
  $projectStatus = [regex]::Match($manifestText, "(?m)^status:\s*(.+)$").Groups[1].Value.Trim()
  if ($projectStatus -notin @("benchmarked", "published")) { throw "Refusing to publish incomplete project status=$projectStatus" }
  $required = @("Dockerfile", "README.md", "sdd/spec.md", "sdd/benchmark-plan.md", "sdd/reuse-improvement-review.md", ".portfolio-control/QUALITY_GATES.md")
  $missing = @($required | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
  if ($missing.Count -gt 0) { throw "Refusing to publish incomplete project; missing=$($missing -join ',')" }
  if (-not (Test-Path -LiteralPath ".github/workflows" -PathType Container)) { throw "Refusing to publish project without CI workflow" }
  $benchmarkCount = @(Get-ChildItem -LiteralPath "benchmarks/results" -Filter *.json -File -ErrorAction SilentlyContinue).Count
  if ($benchmarkCount -eq 0) { throw "Refusing to publish project without benchmark evidence" }
  $firstLine = Get-Content -LiteralPath "README.md" -TotalCount 1
  if ($firstLine -notmatch "^#\s*#?\d+\s+") { throw "Refusing to publish project without a numbered README" }
}
Set-Location $resolvedRepo

if (-not $RepoName) {
  $RepoName = Split-Path -Leaf $resolvedRepo
}

if (-not (Test-Path -LiteralPath ".git" -PathType Container)) {
  Invoke-Git @("init", "-b", $Branch)
}

try {
  Invoke-Git @("checkout", $Branch)
} catch {
  Invoke-Git @("checkout", "-b", $Branch)
}

$user = Invoke-GitHubJson -Method GET -Uri "https://api.github.com/user"
$repoFullName = "$Owner/$RepoName"
$repoUrl = "https://github.com/$repoFullName.git"

try {
  $repo = Invoke-GitHubJson -Method GET -Uri "https://api.github.com/repos/$repoFullName"
  Write-Host "repo_exists=$repoFullName"
} catch {
  $statusCode = $_.Exception.Response.StatusCode.value__
  if ($statusCode -ne 404) { throw }

  $body = @{
    name = $RepoName
    description = $Description
    private = ($Visibility -eq "private")
    auto_init = $false
  }

  try {
    if ($Owner -eq $user.login) {
      $repo = Invoke-GitHubJson -Method POST -Uri "https://api.github.com/user/repos" -Body $body
    } else {
      $repo = Invoke-GitHubJson -Method POST -Uri "https://api.github.com/orgs/$Owner/repos" -Body $body
    }
    Write-Host "repo_created=$repoFullName"
  } catch {
    $message = $_.ErrorDetails.Message
    if (-not $message) { $message = $_.Exception.Message }
    throw "Could not create $repoFullName. Token needs repository creation permission, or create the empty repo once in GitHub. Details: $message"
  }
}

$existingRemote = $null
try { $existingRemote = Get-GitOutput @("remote", "get-url", $RemoteName) } catch { $existingRemote = $null }
if ($existingRemote) {
  Invoke-Git @("remote", "set-url", $RemoteName, $repoUrl)
} else {
  Invoke-Git @("remote", "add", $RemoteName, $repoUrl)
}

$status = Get-GitOutput @("status", "--porcelain")
if ($status -and -not $AllowDirty) { throw "Refusing to publish a dirty tree; review, commit, or pass -AllowDirty explicitly" }
$hasCommit = $true
try { Get-GitOutput @("rev-parse", "--verify", "HEAD") | Out-Null } catch { $hasCommit = $false }

if (-not $NoCommit -and ($status -or -not $hasCommit)) {
  Invoke-Git @("add", ".")
  $postAddStatus = Get-GitOutput @("status", "--porcelain")
  if ($postAddStatus -or -not $hasCommit) {
    Invoke-Git @("commit", "-m", $CommitMessage)
  }
}

if (-not $NoPush) {
  $basic = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("x-access-token:$Token"))
  Invoke-Git @("-c", "http.https://github.com/.extraheader=AUTHORIZATION: basic $basic", "push", "-u", $RemoteName, $Branch)
}

Write-Host "published=$repoUrl"
$Token = $null
