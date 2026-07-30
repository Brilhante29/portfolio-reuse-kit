param(
  [Parameter(Mandatory=$true)] [string]$RepoRoot,
  [switch]$AuditOnly
)

$ErrorActionPreference = 'Stop'
$resolvedRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$credentialPattern = '(?im)(https://[^/\s]+@github\.com|x-access-token|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|^\s*extraheader\s*=\s*authorization:)'

function Get-GitValues {
  param([string]$Repo, [string[]]$Arguments)
  $previousPreference = $ErrorActionPreference
  $ErrorActionPreference = 'SilentlyContinue'
  $values = @(& git -C $Repo @Arguments 2>$null)
  $exitCode = $LASTEXITCODE
  $global:LASTEXITCODE = 0
  $ErrorActionPreference = $previousPreference
  if ($exitCode -ne 0) { return @() }
  return @($values | Where-Object { $_ -ne $null -and $_.Trim() })
}

function Invoke-GitConfig {
  param([string]$Repo, [string[]]$Arguments)
  & git -C $Repo config --local @Arguments 2>$null
  $exitCode = $LASTEXITCODE
  $global:LASTEXITCODE = 0
  if ($exitCode -ne 0) { throw "Unable to update local Git configuration for $(Split-Path -Leaf $Repo)." }
}

function Remove-UserInfo {
  param([string]$Url)
  try {
    $builder = [UriBuilder]$Url
  } catch {
    throw 'An authenticated remote URL could not be normalized safely.'
  }
  if ($builder.Scheme -ne 'https' -or $builder.Host -ne 'github.com') {
    throw 'Only HTTPS github.com remotes can be normalized automatically.'
  }
  $builder.UserName = ''
  $builder.Password = ''
  return $builder.Uri.AbsoluteUri.TrimEnd('/')
}

$repositories = @(
  Get-ChildItem -LiteralPath $resolvedRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName '.git/config') -PathType Leaf } |
    Sort-Object Name
)
$affectedBefore = @(
  foreach ($repository in $repositories) {
    $configPath = Join-Path $repository.FullName '.git/config'
    if ([IO.File]::ReadAllText($configPath) -match $credentialPattern) { $repository }
  }
)

$sanitized = 0
if (-not $AuditOnly) {
  foreach ($repository in $affectedBefore) {
    $repo = $repository.FullName
    $cleanOrigin = ''

    $remoteKeys = @(Get-GitValues $repo @('config','--local','--name-only','--get-regexp','^remote\..*\.(url|pushurl)$'))
    foreach ($key in $remoteKeys) {
      $values = @(Get-GitValues $repo @('config','--local','--get-all',$key))
      foreach ($value in $values) {
        if ($value -match $credentialPattern) {
          $clean = Remove-UserInfo $value
          Invoke-GitConfig $repo @('--replace-all',$key,$clean)
          if ($key -eq 'remote.origin.url') { $cleanOrigin = $clean }
          break
        }
      }
    }

    $origin = @(Get-GitValues $repo @('config','--local','--get','remote.origin.url'))
    if ($origin.Count -eq 1) { $cleanOrigin = [string]$origin[0] }

    $branchRemoteKeys = @(Get-GitValues $repo @('config','--local','--name-only','--get-regexp','^branch\..*\.remote$'))
    foreach ($key in $branchRemoteKeys) {
      $values = @(Get-GitValues $repo @('config','--local','--get-all',$key))
      if (@($values | Where-Object { $_ -match $credentialPattern }).Count -gt 0) {
        if (-not $cleanOrigin) { throw "Cannot replace an authenticated branch remote without origin in $($repository.Name)." }
        Invoke-GitConfig $repo @('--replace-all',$key,'origin')
      }
    }

    $extraHeaderKeys = @(Get-GitValues $repo @('config','--local','--name-only','--get-regexp','^http\..*\.extraheader$'))
    foreach ($key in $extraHeaderKeys) {
      & git -C $repo config --local --unset-all $key 2>$null
      $global:LASTEXITCODE = 0
    }

    $configPath = Join-Path $repo '.git/config'
    if ([IO.File]::ReadAllText($configPath) -match $credentialPattern) {
      throw "Credential-like material remains in local Git configuration for $($repository.Name); manual inspection is required."
    }
    $sanitized++
  }
}

$affectedAfter = @(
  foreach ($repository in $repositories) {
    $configPath = Join-Path $repository.FullName '.git/config'
    if ([IO.File]::ReadAllText($configPath) -match $credentialPattern) { $repository.Name }
  }
)

[pscustomobject][ordered]@{
  scanned_repositories = $repositories.Count
  affected_before = $affectedBefore.Count
  sanitized_repositories = $sanitized
  affected_after = $affectedAfter.Count
  affected_repository_names = @($affectedAfter)
  audit_only = [bool]$AuditOnly
}
