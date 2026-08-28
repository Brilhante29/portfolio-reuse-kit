$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$workspace = Join-Path ([IO.Path]::GetTempPath()) ("portfolio-nextjs-profile-" + [guid]::NewGuid().ToString("N"))
$name = "nextjs-profile-smoke"
$target = Join-Path $workspace $name

try {
  New-Item -ItemType Directory -Force -Path $workspace | Out-Null
  & (Join-Path $PSScriptRoot "new-project.ps1") -Id 999 -Name $name -TargetDir $workspace -Profile nextjs

  foreach ($file in @(
    "Dockerfile",
    ".github/workflows/ci.yml",
    "tools/prepare-standalone.mjs",
    ".prettierignore"
  )) {
    if (-not (Test-Path -LiteralPath (Join-Path $target $file) -PathType Leaf)) {
      throw "Next.js profile did not generate $file"
    }
  }
  $firstLine = Get-Content -LiteralPath (Join-Path $target "README.md") -TotalCount 1
  if ($firstLine -ne "# #999 $name") {
    throw "Next.js profile README identity mismatch: $firstLine"
  }
  Write-Host "nextjs profile scaffold fixture passed"
} finally {
  if (Test-Path -LiteralPath $workspace) {
    $resolvedWorkspace = (Resolve-Path -LiteralPath $workspace).Path
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    if (-not $resolvedWorkspace.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing cleanup outside temp: $resolvedWorkspace"
    }
    Remove-Item -LiteralPath $resolvedWorkspace -Recurse -Force
  }
}
