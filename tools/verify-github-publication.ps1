param(
  [Parameter(Mandatory=$true)] [string]$RepoRoot,
  [string]$Owner = "Brilhante29",
  [string[]]$Repository = @(),
  [string]$Token = $env:GH_TOKEN
)

$ErrorActionPreference = "Stop"
$kitRoot = Split-Path -Parent $PSScriptRoot
$root = (Resolve-Path -LiteralPath $RepoRoot).Path

function Get-GitValue {
  param([string]$Repo, [string[]]$Arguments)
  $previousPreference = $ErrorActionPreference
  $ErrorActionPreference = 'SilentlyContinue'
  $value = ((& git -C $Repo @Arguments 2>$null) -join '').Trim()
  $code = $LASTEXITCODE
  $global:LASTEXITCODE = 0
  $ErrorActionPreference = $previousPreference
  if ($code -ne 0) { return '' }
  return $value
}

if (-not $Token) {
  foreach ($scope in @('Process','User','Machine')) {
    $Token = [Environment]::GetEnvironmentVariable('GH_TOKEN',$scope)
    if ($Token) { break }
  }
}
if (-not $Token) { throw 'GH_TOKEN is required to verify GitHub Actions publication evidence.' }

$headers = @{
  Authorization = "Bearer $Token"
  Accept = 'application/vnd.github+json'
  'X-GitHub-Api-Version' = '2022-11-28'
}
$names = if ($Repository.Count) { $Repository } else {
  @(Get-ChildItem -LiteralPath $root -Directory | Where-Object { $_.Name -ne 'portfolio-reuse-kit' -and (Test-Path (Join-Path $_.FullName '.git') -PathType Container) } | Select-Object -ExpandProperty Name)
}
$outputDir = Join-Path $kitRoot '.portfolio-control/publications'
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
$verified = 0
$skipped = 0

foreach ($name in $names | Sort-Object -Unique) {
  $repo = Join-Path $root $name
  if (-not (Test-Path -LiteralPath (Join-Path $repo '.git') -PathType Container)) { Write-Warning "skip=$name; reason=not-a-git-repository"; $skipped++; continue }
   $head = Get-GitValue $repo @('rev-parse','HEAD')
    $branch = Get-GitValue $repo @('branch','--show-current')
    $remote = Get-GitValue $repo @('config','--get','remote.origin.url')
    $upstream = Get-GitValue $repo @('rev-parse','--abbrev-ref','--symbolic-full-name','@{u}')
  if (-not $head -or -not $branch -or -not $remote -or -not $upstream) { Write-Warning "skip=$name; reason=missing-head-branch-origin-or-upstream"; $skipped++; continue }
  if ($remote -notmatch '^https://github\.com/') { Write-Warning "skip=$name; reason=non-https-github-origin"; $skipped++; continue }

  $uri = "https://api.github.com/repos/$Owner/$name/actions/runs?head_sha=$head&status=completed&per_page=20"
  $response = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
  $run = @($response.workflow_runs | Where-Object { $_.head_sha -eq $head -and $_.conclusion -eq 'success' } | Sort-Object updated_at -Descending | Select-Object -First 1)
  if (-not $run) { Write-Warning "skip=$name; reason=no-successful-ci-for-head; head=$head"; $skipped++; continue }

  $evidence = [ordered]@{
    schema_version = 1
    repository = $name
    commit_sha = $head
    branch = $branch
    remote_url = $remote
    ci_conclusion = 'success'
    ci_run_url = $run[0].html_url
    workflow = $run[0].name
    verified_at = (Get-Date).ToUniversalTime().ToString('o')
  }
  $path = Join-Path $outputDir "$name.json"
  [IO.File]::WriteAllText($path,(($evidence | ConvertTo-Json -Depth 5)+[Environment]::NewLine),(New-Object Text.UTF8Encoding($false)))
  Write-Host "verified=$name; head=$head; run=$($run[0].html_url)"
  $verified++
}

$Token = $null
Write-Host "verified_count=$verified skipped_count=$skipped"