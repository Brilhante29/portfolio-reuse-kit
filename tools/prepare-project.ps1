param(
  [Parameter(Mandatory=$true)]
  [string]$RepoPath,
  [string]$ChangeId = "",
  [switch]$Force,
  [switch]$Validate,
  [switch]$OpenSpecValidate,
  [switch]$UseAitmpl,
  [string[]]$AitmplArgs = @()
)

$ErrorActionPreference = "Stop"

$kitRoot = Split-Path -Parent $PSScriptRoot
$repo = (Resolve-Path -LiteralPath $RepoPath).Path
$manifestPath = Join-Path $repo "project.yaml"

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
  throw "Missing project manifest: $manifestPath"
}

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory=$true)] [string]$Path,
    [AllowEmptyString()] [Parameter(Mandatory=$true)] [string]$Content
  )
  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Read-Scalar {
  param(
    [Parameter(Mandatory=$true)] [string]$Content,
    [Parameter(Mandatory=$true)] [string]$Pattern,
    [string]$Default = "pending"
  )
  $match = [regex]::Match($Content, $Pattern)
  if (-not $match.Success) { return $Default }
  $value = $match.Groups[1].Value.Trim().Trim('"').Trim("'")
  if ($value -eq "") { return $Default }
  return $value
}

function Expand-Template {
  param(
    [Parameter(Mandatory=$true)] [string]$Content,
    [Parameter(Mandatory=$true)] [hashtable]$Values
  )
  $output = $Content
  foreach ($key in $Values.Keys) {
    $output = $output.Replace($key, [string]$Values[$key])
  }
  return $output
}

function Write-GeneratedFile {
  param(
    [Parameter(Mandatory=$true)] [string]$Path,
    [Parameter(Mandatory=$true)] [string]$Content
  )
  if ((Test-Path -LiteralPath $Path -PathType Leaf) -and -not $Force) {
    throw "Generated file already exists. Use -Force only when replacing generated artifacts: $Path"
  }
  $parent = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  Write-Utf8NoBom -Path $Path -Content ($Content.TrimEnd() + "`n")
}

$manifest = Get-Content -Raw -LiteralPath $manifestPath
$id = Read-Scalar -Content $manifest -Pattern "(?m)^id:\s*(.+)$" -Default "unknown"
$name = Read-Scalar -Content $manifest -Pattern "(?m)^name:\s*(.+)$" -Default (Split-Path -Leaf $repo)
$claim = Read-Scalar -Content $manifest -Pattern "(?m)^claim:\s*(.+)$"
$programId = Read-Scalar -Content $manifest -Pattern "(?m)^program:[ \t]*\r?\n[ \t]{2}id:[ \t]*([^\r\n]+)"
$architecture = Read-Scalar -Content $manifest -Pattern "(?m)^architecture:[ \t]*\r?\n[ \t]{2}style:[ \t]*([^\r\n]+)"
$apiStyle = Read-Scalar -Content $manifest -Pattern "(?m)^\s{2}api_style:\s*([^\r\n]+)"
$messaging = Read-Scalar -Content $manifest -Pattern "(?m)^\s{2}messaging:\s*([^\r\n]+)"
$metric = Read-Scalar -Content $manifest -Pattern "(?m)^benchmark:[ \t]*\r?\n[ \t]{2}primary_metric:[ \t]*([^\r\n]+)"
$unit = Read-Scalar -Content $manifest -Pattern "(?m)^benchmark:[ \t]*\r?\n[ \t]{2}unit:[ \t]*([^\r\n]+)"

if ($ChangeId -eq "") { $ChangeId = "baseline" }
$ChangeId = $ChangeId.ToLowerInvariant() -replace "[^a-z0-9-]", "-"
$ChangeId = $ChangeId.Trim("-")
if ($ChangeId -eq "") { throw "ChangeId must contain at least one letter, number, or hyphen." }

$planScript = Join-Path $PSScriptRoot "plan-project.ps1"
if ($Force) {
  & $planScript -RepoPath $repo -OutputDir "openspec/artifacts" -Force
} else {
  & $planScript -RepoPath $repo -OutputDir "openspec/artifacts"
}
$planExitCode = $LASTEXITCODE
if ($null -ne $planExitCode -and $planExitCode -ne 0) { throw "Project planning failed with exit code $planExitCode" }

$values = @{
  "<id>" = $id
  "<project-name>" = $name
  "<change-id>" = $ChangeId
  "<claim>" = $claim
  "<program-id>" = $programId
  "<architecture>" = $architecture
  "<stack>" = (Read-Scalar -Content $manifest -Pattern "(?m)^\s{2}- (.+)$" -Default "recorded in project.yaml")
  "<api-style>" = $apiStyle
  "<messaging>" = $messaging
}

$contextTemplate = Get-Content -Raw -LiteralPath (Join-Path $kitRoot "templates/aitmpl-context-card.md")
$contextPath = Join-Path $repo ".aitmpl/context-card.md"
Write-GeneratedFile -Path $contextPath -Content (Expand-Template -Content $contextTemplate -Values $values)

$changeRoot = Join-Path $repo (Join-Path "openspec/changes" $ChangeId)
$changeTemplates = @(
  @{ Template = "openspec-change-proposal.md"; Destination = "proposal.md" },
  @{ Template = "openspec-change-design.md"; Destination = "design.md" },
  @{ Template = "openspec-change-tasks.md"; Destination = "tasks.md" },
  @{ Template = "openspec-change-spec.md"; Destination = (Join-Path (Join-Path "specs" $name) "spec.md") }
)
foreach ($item in $changeTemplates) {
  $templatePath = Join-Path $kitRoot (Join-Path "templates" $item.Template)
  $destinationPath = Join-Path $changeRoot $item.Destination
  $content = Get-Content -Raw -LiteralPath $templatePath
  Write-GeneratedFile -Path $destinationPath -Content (Expand-Template -Content $content -Values $values)
}

if ($OpenSpecValidate) {
  $openSpec = Get-Command openspec -ErrorAction SilentlyContinue
  if ($null -eq $openSpec) { throw "OpenSpec CLI was requested but is not installed. Install it separately, then rerun with -OpenSpecValidate." }
  Push-Location -LiteralPath $repo
  try {
    & $openSpec.Source validate --strict
    $openSpecExitCode = $LASTEXITCODE
    if ($null -ne $openSpecExitCode -and $openSpecExitCode -ne 0) { throw "OpenSpec validation failed with exit code $openSpecExitCode" }
  } finally {
    Pop-Location
  }
}

if ($UseAitmpl) {
  if ($AitmplArgs.Count -eq 0) {
    throw "UseAitmpl requires explicit -AitmplArgs so external components are selected intentionally."
  }
  $npx = Get-Command npx -ErrorAction SilentlyContinue
  if ($null -eq $npx) { throw "AITmpl was requested but npx is not installed." }
  Push-Location -LiteralPath $repo
  try {
    $externalArgs = @("claude-code-templates@latest") + $AitmplArgs + @("--yes")
    & $npx.Source @externalArgs
    $aitmplExitCode = $LASTEXITCODE
    if ($null -ne $aitmplExitCode -and $aitmplExitCode -ne 0) { throw "AITmpl installation failed with exit code $aitmplExitCode" }
  } finally {
    Pop-Location
  }
}

if ($Validate) {
  $validator = Join-Path $repo "tools/validate-project.ps1"
  if (Test-Path -LiteralPath $validator -PathType Leaf) {
    & $validator -SkipDocker
    $validationExitCode = $LASTEXITCODE
    if ($null -ne $validationExitCode -and $validationExitCode -ne 0) { throw "Project validation failed with exit code $validationExitCode" }
  }
}

Write-Host "prepared_project=$name"
Write-Host "change_id=$ChangeId"
Write-Host "context_card=.aitmpl/context-card.md"
Write-Host "openspec_change=openspec/changes/$ChangeId"
