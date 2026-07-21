param(
  [string]$RepoPath = "",
  [string]$RepoRoot = "",
  [string[]]$Exclude = @("portfolio-reuse-kit"),
  [switch]$DryRun,
  [switch]$SyncSharedArtifacts
)

$ErrorActionPreference = "Stop"

$kitRoot = Split-Path -Parent $PSScriptRoot
$catalogPath = Join-Path $kitRoot "catalog/projects.yaml"

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory=$true)] [string]$Path,
    [AllowEmptyString()]
    [Parameter(Mandatory=$true)] [string]$Content
  )
  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Join-PortablePath {
  param(
    [Parameter(Mandatory=$true)] [string]$BasePath,
    [Parameter(Mandatory=$true)] [string]$RelativePath
  )
  $current = $BasePath
  foreach ($part in ($RelativePath -split "[/\\]")) {
    if ($part -ne "") {
      $current = Join-Path $current $part
    }
  }
  return $current
}

function Clean-Value {
  param([AllowNull()] [string]$Value)
  if ($null -eq $Value) { return "" }
  return $Value.Trim().Trim('"').Trim("'")
}

function Read-BodyScalar {
  param(
    [string]$Body,
    [string]$Key,
    [string]$Default = ""
  )
  $match = [regex]::Match($Body, "(?m)^\s{4}" + [regex]::Escape($Key) + ":\s*(.+)$")
  if ($match.Success) { return Clean-Value $match.Groups[1].Value }
  return $Default
}

function Get-CatalogProject {
  param([string]$ProjectName)
  if (-not (Test-Path -LiteralPath $catalogPath -PathType Leaf)) {
    return $null
  }

  $catalog = Get-Content -Raw -LiteralPath $catalogPath
  $pattern = "(?ms)^\s{2}- id:\s*(?<id>\d+)\s*\r?\n\s{4}name:\s*(?<name>[^\r\n]+)\r?\n(?<body>.*?)(?=^\s{2}- id:|\z)"
  foreach ($match in [regex]::Matches($catalog, $pattern)) {
    $name = Clean-Value $match.Groups["name"].Value
    if ($name -eq $ProjectName) {
      $body = $match.Groups["body"].Value
      return [pscustomobject]@{
        Id = Clean-Value $match.Groups["id"].Value
        Name = $name
        Proves = Read-BodyScalar -Body $body -Key "proves" -Default "portfolio proof pending"
        Benchmark = Read-BodyScalar -Body $body -Key "benchmark" -Default "benchmark_pending"
      }
    }
  }
  return $null
}

function Get-PrimaryMetric {
  param([string]$Benchmark)
  if ($Benchmark -eq "") { return "benchmark_pending" }
  return (($Benchmark -split ",")[0]).Trim()
}

function Resolve-TargetRepos {
  if ($RepoPath -ne "") {
    return @((Resolve-Path -LiteralPath $RepoPath).Path)
  }

  if ($RepoRoot -eq "") {
    $RepoRoot = Split-Path -Parent $kitRoot
  }

  $resolvedRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
  return @(Get-ChildItem -Directory -LiteralPath $resolvedRoot | Where-Object {
    $Exclude -notcontains $_.Name -and
    (Test-Path -LiteralPath (Join-Path $_.FullName ".git") -PathType Container)
  } | Sort-Object Name | ForEach-Object { $_.FullName })
}

function Expand-TemplateContent {
  param(
    [string]$Content,
    [pscustomobject]$Project
  )
  $metric = Get-PrimaryMetric -Benchmark $Project.Benchmark
  $output = $Content.Replace("<id>", [string]$Project.Id)
  $output = $output.Replace("<project-name>", [string]$Project.Name)
  $output = $output.Replace("<one sentence claim>", [string]$Project.Proves)
  $output = $output.Replace("<metric>", [string]$metric)
  $output = $output.Replace("<unit>", "unit")
  return $output
}

function Copy-TemplateIfMissing {
  param(
    [string]$Repo,
    [string]$SourceRelative,
    [string]$DestinationRelative,
    [pscustomobject]$Project,
    [switch]$ExpandTokens
  )

  $source = Join-PortablePath -BasePath $kitRoot -RelativePath $SourceRelative
  $destination = Join-PortablePath -BasePath $Repo -RelativePath $DestinationRelative
  if (Test-Path -LiteralPath $destination -PathType Leaf) {
    return $false
  }
  if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "Missing kit template: $SourceRelative"
  }

  $parent = Split-Path -Parent $destination
  if ($DryRun) {
    Write-Host "would_backfill=$DestinationRelative"
    return $true
  }

  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  $content = Get-Content -Raw -LiteralPath $source
  if ($ExpandTokens) {
    $content = Expand-TemplateContent -Content $content -Project $Project
  }
  Write-Utf8NoBom -Path $destination -Content $content
  return $true
}

function Sync-SharedArtifact {
  param(
    [string]$Repo,
    [string]$SourceRelative,
    [string]$DestinationRelative
  )

  $source = Join-PortablePath -BasePath $kitRoot -RelativePath $SourceRelative
  $destination = Join-PortablePath -BasePath $Repo -RelativePath $DestinationRelative
  if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "Missing shared kit artifact: $SourceRelative"
  }
  if ($DryRun) {
    Write-Host "would_sync=$DestinationRelative"
    return
  }

  $parent = Split-Path -Parent $destination
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  Copy-Item -LiteralPath $source -Destination $destination -Force
}

$templateFiles = @(
  @{ Source = "templates/README-project.md"; Destination = "README.md"; Expand = $true },
  @{ Source = "templates/project.yaml"; Destination = "project.yaml"; Expand = $true },
  @{ Source = "templates/REFERENCES.md"; Destination = "REFERENCES.md"; Expand = $false },
  @{ Source = "templates/AGENTS.md"; Destination = "AGENTS.md"; Expand = $false },
  @{ Source = "templates/CLAUDE.md"; Destination = "CLAUDE.md"; Expand = $false },
  @{ Source = "templates/aitmpl-config.yaml"; Destination = ".aitmpl/config.yaml"; Expand = $false },
  @{ Source = "templates/validate-project.ps1"; Destination = "tools/validate-project.ps1"; Expand = $false },
  @{ Source = "templates/openspec-config.yaml"; Destination = "openspec/config.yaml"; Expand = $true },
  @{ Source = "templates/portfolio-control/INVENTORY.md"; Destination = ".portfolio-control/INVENTORY.md"; Expand = $true },
  @{ Source = "templates/portfolio-control/REUSE_MAP.md"; Destination = ".portfolio-control/REUSE_MAP.md"; Expand = $false },
  @{ Source = "templates/portfolio-control/CRITICAL_PATH.md"; Destination = ".portfolio-control/CRITICAL_PATH.md"; Expand = $true },
  @{ Source = "templates/portfolio-control/DECISIONS.md"; Destination = ".portfolio-control/DECISIONS.md"; Expand = $true },
  @{ Source = "templates/portfolio-control/QUALITY_GATES.md"; Destination = ".portfolio-control/QUALITY_GATES.md"; Expand = $true },
  @{ Source = "templates/portfolio-control/AGENT_HANDOFFS/README.md"; Destination = ".portfolio-control/AGENT_HANDOFFS/README.md"; Expand = $false },
  @{ Source = "sdd/templates/spec.md"; Destination = "sdd/spec.md"; Expand = $true },
  @{ Source = "sdd/templates/benchmark-plan.md"; Destination = "sdd/benchmark-plan.md"; Expand = $false },
  @{ Source = "sdd/templates/architecture-decision.md"; Destination = "sdd/architecture-decision.md"; Expand = $false },
  @{ Source = "sdd/templates/technical-decision.md"; Destination = "sdd/technical-decision.md"; Expand = $false },
  @{ Source = "sdd/templates/agent-handoff.md"; Destination = "sdd/agent-handoff.md"; Expand = $true },
  @{ Source = "sdd/templates/reuse-improvement-review.md"; Destination = "sdd/reuse-improvement-review.md"; Expand = $true },
  @{ Source = "sdd/templates/release-checklist.md"; Destination = "sdd/release-checklist.md"; Expand = $false },
  @{ Source = "LICENSE"; Destination = "LICENSE"; Expand = $false },
  @{ Source = ".gitignore"; Destination = ".gitignore"; Expand = $false },
  @{ Source = ".gitattributes"; Destination = ".gitattributes"; Expand = $false },
  @{ Source = ".editorconfig"; Destination = ".editorconfig"; Expand = $false }
)

$repos = Resolve-TargetRepos
$totalFiles = 0

foreach ($repo in $repos) {
  $repoName = Split-Path -Leaf $repo
  $project = Get-CatalogProject -ProjectName $repoName
  if ($null -eq $project) {
    throw "Project not found in catalog: $repoName. Register it before backfilling project standards."
  }

  Write-Host "checking=$repoName"
  foreach ($directory in @("sdd", "tools", "benchmarks/results", "openspec", ".portfolio-control", ".portfolio-control/AGENT_HANDOFFS")) {
    $targetDirectory = Join-PortablePath -BasePath $repo -RelativePath $directory
    if ($DryRun) {
      if (-not (Test-Path -LiteralPath $targetDirectory -PathType Container)) {
        Write-Host "would_create_dir=$directory"
      }
    } else {
      New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
    }
  }

  foreach ($item in $templateFiles) {
    $created = Copy-TemplateIfMissing `
      -Repo $repo `
      -SourceRelative $item.Source `
      -DestinationRelative $item.Destination `
      -Project $project `
      -ExpandTokens:([bool]$item.Expand)
    if ($created) { $totalFiles++ }
  }

  if ($SyncSharedArtifacts) {
    foreach ($shared in @(
      @{ Source = ".claude/skills/cloud-local-first/SKILL.md"; Destination = ".claude/skills/cloud-local-first/SKILL.md" },
      @{ Source = ".codex/skills/cloud-local-first/SKILL.md"; Destination = ".codex/skills/cloud-local-first/SKILL.md" },
      @{ Source = "decision-brain/cloud-matrix.yaml"; Destination = ".portfolio/decision-brain/cloud-matrix.yaml" }
    )) {
      Sync-SharedArtifact -Repo $repo -SourceRelative $shared.Source -DestinationRelative $shared.Destination
      $totalFiles++
    }
  }

  $gitkeep = Join-PortablePath -BasePath $repo -RelativePath "benchmarks/results/.gitkeep"
  if (-not (Test-Path -LiteralPath $gitkeep -PathType Leaf)) {
    if ($DryRun) {
      Write-Host "would_backfill=benchmarks/results/.gitkeep"
    } else {
      Write-Utf8NoBom -Path $gitkeep -Content ""
    }
    $totalFiles++
  }
}

Write-Host "checked_repositories=$($repos.Count)"
Write-Host "backfilled_files=$totalFiles"
