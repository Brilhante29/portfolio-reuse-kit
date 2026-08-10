$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$sandbox = [IO.Path]::GetFullPath((Join-Path $tempRoot ("git-auth-sanitizer-test-{0}" -f $PID)))
if (-not $sandbox.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to use a sanitizer fixture outside the system temp directory: $sandbox"
}

try {
  $repo = Join-Path $sandbox 'fixture-project'
  New-Item -ItemType Directory -Force -Path $repo | Out-Null
  & git init -b main $repo 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'Unable to initialize sanitizer Git fixture.' }

  $fakeToken = ('gh' + 'p_' + ('A' * 36))
  $authenticatedUrl = "https://x-access-token:$fakeToken@github.com/example/fixture-project.git"
  & git -C $repo config --local remote.origin.url $authenticatedUrl
  & git -C $repo config --local remote.origin.pushurl $authenticatedUrl
  & git -C $repo config --local branch.main.remote $authenticatedUrl
  & git -C $repo config --local branch.main.merge refs/heads/main
  & git -C $repo config --local 'http.https://github.com/.extraheader' ('AUTHORIZATION: basic ' + ('B' * 24))

  $headerOnlyRepo = Join-Path $sandbox 'extraheader-only'
  New-Item -ItemType Directory -Force -Path $headerOnlyRepo | Out-Null
  & git init -b main $headerOnlyRepo 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'Unable to initialize extraheader-only Git fixture.' }
  & git -C $headerOnlyRepo config --local remote.origin.url 'https://github.com/example/extraheader-only.git'
  & git -C $headerOnlyRepo config --local 'http.https://github.com/.extraheader' ('AUTHORIZATION: basic ' + ('C' * 24))

  $audit = & (Join-Path $root 'tools/sanitize-git-auth.ps1') -RepoRoot $sandbox -AuditOnly
  if ($audit.affected_before -ne 2 -or $audit.affected_after -ne 2 -or $audit.sanitized_repositories -ne 0) {
    throw 'Audit-only mode did not report the authenticated Git fixture without changing it.'
  }

  $result = & (Join-Path $root 'tools/sanitize-git-auth.ps1') -RepoRoot $sandbox
  if ($result.affected_before -ne 2 -or $result.affected_after -ne 0 -or $result.sanitized_repositories -ne 2) {
    throw 'Sanitizer did not remove credential-like Git configuration.'
  }

  $origin = (& git -C $repo config --local --get remote.origin.url).Trim()
  $pushUrl = (& git -C $repo config --local --get remote.origin.pushurl).Trim()
  $branchRemote = (& git -C $repo config --local --get branch.main.remote).Trim()
  $extraHeader = @(& git -C $repo config --local --get-all 'http.https://github.com/.extraheader' 2>$null)
  $global:LASTEXITCODE = 0
  if ($origin -ne 'https://github.com/example/fixture-project.git') { throw 'Sanitizer changed the fetch remote target.' }
  if ($pushUrl -ne 'https://github.com/example/fixture-project.git') { throw 'Sanitizer changed the push remote target.' }
  if ($branchRemote -ne 'origin') { throw 'Sanitizer did not normalize the branch remote.' }
  if ($extraHeader.Count -ne 0) { throw 'Sanitizer retained a local HTTP extraheader.' }
  $headerOnlyExtraHeader = @(& git -C $headerOnlyRepo config --local --get-all 'http.https://github.com/.extraheader' 2>$null)
  $global:LASTEXITCODE = 0
  if ($headerOnlyExtraHeader.Count -ne 0) { throw 'Sanitizer missed an authorization extraheader without an authenticated remote URL.' }

  Write-Host 'git auth sanitizer fixture passed'
} finally {
  if (Test-Path -LiteralPath $sandbox) { Remove-Item -LiteralPath $sandbox -Recurse -Force }
}
