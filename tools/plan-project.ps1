param(
  [Parameter(Mandatory=$true)]
  [string]$RepoPath,
  [string]$OutputDir = "openspec/artifacts",
  [string[]]$StyleReferences = @("README.md", "sdd/spec.md", "sdd/technical-decision.md"),
  [switch]$Force,
  [switch]$DryRun
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
    [AllowEmptyString()]
    [Parameter(Mandatory=$true)] [string]$Content
  )
  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Clean-Value {
  param([AllowNull()] [string]$Value)
  if ($null -eq $Value) { return "unknown" }
  $clean = $Value.Trim()
  $clean = $clean.Trim('"').Trim("'")
  if ($clean -eq "") { return "unknown" }
  return $clean
}

function Read-MatchValue {
  param(
    [string]$Content,
    [string]$Pattern,
    [string]$Default = "unknown"
  )
  $match = [regex]::Match($Content, $Pattern)
  if ($match.Success) {
    return (Clean-Value $match.Groups[1].Value)
  }
  return $Default
}

function Get-SectionBody {
  param(
    [string]$Content,
    [string]$Section
  )
  $pattern = "(?ms)^" + [regex]::Escape($Section) + ":\s*\r?\n(?<body>.*?)(?=^\S|\z)"
  $match = [regex]::Match($Content, $pattern)
  if ($match.Success) { return $match.Groups["body"].Value }
  return ""
}

function Read-SectionScalar {
  param(
    [string]$Content,
    [string]$Section,
    [string]$Key,
    [string]$Default = "unknown"
  )
  $body = Get-SectionBody -Content $Content -Section $Section
  if ($body -eq "") { return $Default }
  return Read-MatchValue -Content $body -Pattern ("(?m)^\s{2}" + [regex]::Escape($Key) + ":\s*(.+)$") -Default $Default
}

function Read-TopList {
  param(
    [string]$Content,
    [string]$Key
  )
  $pattern = "(?m)^" + [regex]::Escape($Key) + ":\s*\r?\n(?<body>(?:\s{2}- [^\r\n]+\r?\n)+)"
  $match = [regex]::Match($Content, $pattern)
  if (-not $match.Success) { return @() }
  return @($match.Groups["body"].Value -split "\r?\n" | Where-Object { $_ -match "^\s{2}- " } | ForEach-Object { Clean-Value ($_ -replace "^\s{2}-\s*", "") })
}

function Read-SectionList {
  param(
    [string]$Content,
    [string]$Section,
    [string]$Key
  )
  $body = Get-SectionBody -Content $Content -Section $Section
  if ($body -eq "") { return @() }
  $pattern = "(?m)^\s{2}" + [regex]::Escape($Key) + ":\s*\r?\n(?<body>(?:\s{4}- [^\r\n]+\r?\n)+)"
  $match = [regex]::Match($body, $pattern)
  if (-not $match.Success) { return @() }
  return @($match.Groups["body"].Value -split "\r?\n" | Where-Object { $_ -match "^\s{4}- " } | ForEach-Object { Clean-Value ($_ -replace "^\s{4}-\s*", "") })
}

function Format-MarkdownList {
  param([string[]]$Items)
  if (-not $Items -or $Items.Count -eq 0) { return "- none recorded" }
  return (($Items | ForEach-Object { "- $_" }) -join "`n")
}

function Get-ListBlockById {
  param(
    [string]$Content,
    [string]$Id
  )
  $escaped = [regex]::Escape($Id)
  $pattern = "(?ms)^\s{2}- id:\s*" + $escaped + "\s*\r?\n(?<body>.*?)(?=^\s{2}- id:|\z)"
  $match = [regex]::Match($Content, $pattern)
  if ($match.Success) { return $match.Groups["body"].Value }
  return ""
}

function Read-PackList {
  param(
    [string]$Block,
    [string]$Key
  )
  if ($Block -eq "") { return @() }
  $pattern = "(?m)^\s{4}" + [regex]::Escape($Key) + ":\s*\r?\n(?<body>(?:\s{6}- [^\r\n]+\r?\n)+)"
  $match = [regex]::Match($Block, $pattern)
  if (-not $match.Success) { return @() }
  return @($match.Groups["body"].Value -split "\r?\n" | Where-Object { $_ -match "^\s{6}- " } | ForEach-Object { Clean-Value ($_ -replace "^\s{6}-\s*", "") })
}

function Read-PackScalar {
  param(
    [string]$Block,
    [string]$Key,
    [string]$Default = "unknown"
  )
  if ($Block -eq "") { return $Default }
  return Read-MatchValue -Content $Block -Pattern ("(?m)^\s{4}" + [regex]::Escape($Key) + ":\s*(.+)$") -Default $Default
}

function Get-StyleStats {
  param([string]$Text)
  $sentences = @([regex]::Matches($Text, "[^.!?]+[.!?]") | ForEach-Object { $_.Value.Trim() } | Where-Object { $_ -ne "" })
  $wordMatches = @([regex]::Matches($Text, "\b[\w@/.-]+\b"))
  $sentenceWordCounts = @()
  foreach ($sentence in $sentences) {
    $sentenceWordCounts += @([regex]::Matches($sentence, "\b[\w@/.-]+\b")).Count
  }
  $avgSentence = 0
  if ($sentenceWordCounts.Count -gt 0) {
    $avgSentence = [math]::Round((($sentenceWordCounts | Measure-Object -Average).Average), 1)
  }
  $headings = @([regex]::Matches($Text, "(?m)^#{1,3}\s+")).Count
  $bullets = @([regex]::Matches($Text, "(?m)^\s*-\s+")).Count
  $numbers = @([regex]::Matches($Text, "\d+(?:\.\d+)?")).Count
  $evidence = @([regex]::Matches($Text, "(?i)\b(benchmark|metric|recall|latency|cost|docker|json|architecture|decision|rejected|validation|fixture|claim)\b")).Count
  $hype = @([regex]::Matches($Text, "(?i)\b(amazing|beautiful|powerful|seamless|world-class|cutting-edge|game-changing|robust|innovative|revolutionary)\b")).Count
  return [pscustomobject]@{
    Words = $wordMatches.Count
    Sentences = $sentences.Count
    AverageSentenceWords = $avgSentence
    Headings = $headings
    Bullets = $bullets
    Numbers = $numbers
    EvidenceWords = $evidence
    HypeWords = $hype
  }
}

function Get-RelativePath {
  param(
    [string]$BasePath,
    [string]$TargetPath
  )
  $baseResolved = (Resolve-Path -LiteralPath $BasePath).Path
  $targetResolved = (Resolve-Path -LiteralPath $TargetPath).Path
  $relative = [System.IO.Path]::GetRelativePath($baseResolved, $targetResolved)
  return ($relative -replace "\\", "/")
}

function Format-MetricName {
  param([string]$Metric)
  if ($Metric -match "^recall_at_(\d+)$") { return "Recall@$($Matches[1])" }
  if ($Metric -eq "exact_match") { return "Exact match" }
  if ($Metric -eq "f1") { return "F1" }
  if ($Metric -eq "task_success_rate") { return "Task success rate" }
  return $Metric
}

function Format-MetricValue {
  param([object]$Value)
  if ($null -eq $Value) { return "recorded" }
  $parsed = 0.0
  if ([double]::TryParse([string]$Value, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$parsed)) {
    if ($parsed -ge 0 -and $parsed -le 1) { return $parsed.ToString("0.00", [System.Globalization.CultureInfo]::InvariantCulture) }
    return $parsed.ToString("0.##", [System.Globalization.CultureInfo]::InvariantCulture)
  }
  return [string]$Value
}

function Join-MetricLine {
  param([string]$Metric, [string]$Value, [string]$Unit)
  if ($Unit -eq "ratio" -or $Unit -eq "unknown" -or $Unit -eq "") { return "$Metric = $Value" }
  return "$Metric = $Value $Unit"
}

$manifest = Get-Content -Raw -LiteralPath $manifestPath
$id = Read-MatchValue -Content $manifest -Pattern "(?m)^id:\s*(.+)$"
$name = Read-MatchValue -Content $manifest -Pattern "(?m)^name:\s*(.+)$"
$status = Read-MatchValue -Content $manifest -Pattern "(?m)^status:\s*(.+)$"
$claim = Read-MatchValue -Content $manifest -Pattern "(?m)^claim:\s*(.+)$"
$programId = Read-SectionScalar -Content $manifest -Section "program" -Key "id"
$programFit = Read-SectionScalar -Content $manifest -Section "program" -Key "narrative_fit"
$languagePrimary = Read-SectionScalar -Content $manifest -Section "language_profile" -Key "primary"
$languageReason = Read-SectionScalar -Content $manifest -Section "language_profile" -Key "reason"
$stack = Read-TopList -Content $manifest -Key "stack"
$stackProfile = Read-SectionScalar -Content $manifest -Section "decision_brain" -Key "stack_profile"
$apiStyle = Read-SectionScalar -Content $manifest -Section "decision_brain" -Key "api_style"
$messaging = Read-SectionScalar -Content $manifest -Section "decision_brain" -Key "messaging"
$database = Read-SectionScalar -Content $manifest -Section "decision_brain" -Key "database"
$runtime = Read-SectionScalar -Content $manifest -Section "decision_brain" -Key "runtime"
$libraryPolicy = Read-SectionScalar -Content $manifest -Section "decision_brain" -Key "library_policy"
$architectureStyle = Read-SectionScalar -Content $manifest -Section "architecture" -Key "style"
$architectureReason = Read-SectionScalar -Content $manifest -Section "architecture" -Key "reason"
$dependencyRule = Read-SectionScalar -Content $manifest -Section "architecture" -Key "dependency_rule"
$boundaries = Read-SectionList -Content $manifest -Section "architecture" -Key "boundaries"
$primaryMetric = Read-SectionScalar -Content $manifest -Section "benchmark" -Key "primary_metric"
$unit = Read-SectionScalar -Content $manifest -Section "benchmark" -Key "unit"
$benchmarkCommand = Read-SectionScalar -Content $manifest -Section "benchmark" -Key "command"
$benchmarkResultPath = Read-SectionScalar -Content $manifest -Section "benchmark" -Key "result_path"
$componentPack = Read-MatchValue -Content $manifest -Pattern "(?ms)agentic_spec:\s*\r?\n(?:\s{4}.+\r?\n)*?\s{4}component_pack:\s*(.+)$" -Default $programId
if ($componentPack -like "<*") { $componentPack = $programId }
if ($componentPack -eq "unknown") { $componentPack = $programId }
if ($componentPack -eq "unknown") { $componentPack = "default-portfolio-project" }

$programsPath = Join-Path $kitRoot "catalog/programs.yaml"
$programName = $programId
if (Test-Path -LiteralPath $programsPath) {
  $programs = Get-Content -Raw -LiteralPath $programsPath
  $programBlock = Get-ListBlockById -Content $programs -Id $programId
  $programName = Read-PackScalar -Block $programBlock -Key "name" -Default $programId
}

$componentPackPath = Join-Path $kitRoot "component-packs/manifest.yaml"
$packName = $componentPack
$packProblem = "unknown"
$packBenchmarkFocus = @()
$packArtifacts = @()
$packRejections = @()
if (Test-Path -LiteralPath $componentPackPath) {
  $packManifest = Get-Content -Raw -LiteralPath $componentPackPath
  $packBlock = Get-ListBlockById -Content $packManifest -Id $componentPack
  $packName = Read-PackScalar -Block $packBlock -Key "name" -Default $componentPack
  $packProblem = Read-PackScalar -Block $packBlock -Key "problem" -Default "unknown"
  $packBenchmarkFocus = Read-PackList -Block $packBlock -Key "benchmark_focus"
  $packArtifacts = Read-PackList -Block $packBlock -Key "preferred_artifacts"
  $packRejections = Read-PackList -Block $packBlock -Key "rejection_rules"
}

$resultObject = $null
$resultFile = $null
if ($benchmarkResultPath -ne "unknown" -and $benchmarkResultPath -ne "pending") {
  $candidatePattern = Join-Path $repo $benchmarkResultPath
  $resultFile = Get-ChildItem -Path $candidatePattern -File -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -First 1
  if ($resultFile) {
    try {
      $resultObject = Get-Content -Raw -LiteralPath $resultFile.FullName | ConvertFrom-Json
    } catch {
      $resultObject = $null
    }
  }
}

$benchmarkLine = "$primaryMetric = pending $unit"
$latencyLine = ""
if ($resultObject) {
  $jsonMetric = if ($resultObject.metric) { $resultObject.metric } elseif ($resultObject.primary_metric) { $resultObject.primary_metric } else { $primaryMetric }
  $jsonValue = if ($null -ne $resultObject.value) { $resultObject.value } elseif ($resultObject.$primaryMetric) { $resultObject.$primaryMetric } else { "recorded" }
  $jsonUnit = if ($resultObject.unit) { $resultObject.unit } else { $unit }
  $benchmarkLine = Join-MetricLine -Metric (Format-MetricName -Metric $jsonMetric) -Value (Format-MetricValue -Value $jsonValue) -Unit $jsonUnit
  if ($resultObject.summary -and $null -ne $resultObject.summary.avg_latency_ms) {
    $latencyLine = "Average latency: $([math]::Round([double]$resultObject.summary.avg_latency_ms, 2)) ms. P95 latency: $([math]::Round([double]$resultObject.summary.p95_latency_ms, 2)) ms."
  } elseif ($null -ne $resultObject.avg_latency_ms) {
    $latencyLine = "Average latency: $([math]::Round([double]$resultObject.avg_latency_ms, 2)) ms."
  }
} else {
  $benchmarkLine = Join-MetricLine -Metric (Format-MetricName -Metric $primaryMetric) -Value "pending" -Unit $unit
}

$referenceTextBuilder = New-Object System.Text.StringBuilder
$referencePathsUsed = New-Object System.Collections.Generic.List[string]
foreach ($reference in $StyleReferences) {
  $referencePath = Join-Path $repo $reference
  if (Test-Path -LiteralPath $referencePath -PathType Leaf) {
    [void]$referenceTextBuilder.AppendLine((Get-Content -Raw -LiteralPath $referencePath))
    $referencePathsUsed.Add($reference)
  }
}
$referenceText = $referenceTextBuilder.ToString()
$referenceStats = Get-StyleStats -Text $referenceText

if ([System.IO.Path]::IsPathRooted($OutputDir)) {
  $outputPath = $OutputDir
} else {
  $outputPath = Join-Path $repo $OutputDir
}

$stackList = Format-MarkdownList -Items $stack
$boundariesList = Format-MarkdownList -Items $boundaries
$packBenchmarkList = Format-MarkdownList -Items $packBenchmarkFocus
$packArtifactList = Format-MarkdownList -Items $packArtifacts
$packRejectionList = Format-MarkdownList -Items $packRejections
$styleRefsList = Format-MarkdownList -Items @($referencePathsUsed)

$article = @"
# #$id ${name}: $benchmarkLine

$claim

This repository belongs to the $programName program. Its job is narrow: prove the retrieval layer before adding generation, managed services, or distributed infrastructure.

The benchmark is the proof. $benchmarkLine. $latencyLine The result is stored in ``$benchmarkResultPath`` and can be reproduced from the Docker/local path.

The important architecture decision is $architectureStyle. $architectureReason

The default path stays local-first. The project uses $stackProfile, exposes $apiStyle, uses messaging mode ``$messaging``, and stores data with ``$database``. The dependency rule is explicit: $dependencyRule

The rejected work matters as much as the implemented work. Anything that does not improve the benchmark stays out of the first version.

Post angle: start with the number, show the architecture boundary, then explain which future adapter can be added without changing the core use cases.
"@

$articleStats = Get-StyleStats -Text $article
$score = 0
$maxScore = 7
$checks = New-Object System.Collections.Generic.List[string]

if ($article -match "^# #$id ") { $score++; $checks.Add("PASS: article starts with project number and name.") } else { $checks.Add("FAIL: article should start with project number and name.") }
if ($article -match [regex]::Escape($claim)) { $score++; $checks.Add("PASS: claim appears verbatim.") } else { $checks.Add("FAIL: claim is missing or rewritten too loosely.") }
if ($article -match "(?i)benchmark|recall|latency|cost|metric") { $score++; $checks.Add("PASS: benchmark evidence appears early.") } else { $checks.Add("FAIL: benchmark evidence is not visible enough.") }
if ($article -match "(?i)architecture|dependency rule|rejected") { $score++; $checks.Add("PASS: architecture and rejected alternatives are part of the story.") } else { $checks.Add("FAIL: architecture tradeoffs are missing.") }
if ($articleStats.HypeWords -le 1) { $score++; $checks.Add("PASS: hype-word count is low.") } else { $checks.Add("FAIL: article uses too many hype words.") }
if ([math]::Abs($articleStats.AverageSentenceWords - $referenceStats.AverageSentenceWords) -le 8) { $score++; $checks.Add("PASS: average sentence length is close to the existing docs.") } else { $checks.Add("WARN: sentence length differs from existing docs.") }
if ($articleStats.EvidenceWords -ge 6) { $score++; $checks.Add("PASS: evidence-word density is high enough.") } else { $checks.Add("FAIL: article needs more concrete evidence words.") }

$voiceVerdict = if ($score -ge 6) { "aligned" } elseif ($score -ge 4) { "mostly aligned" } else { "needs rewrite" }
$checksText = ($checks | ForEach-Object { "- $_" }) -join "`n"

$files = [ordered]@{
  "intent.md" = @"
# Intent: $name

## Measurable Claim

$claim

## Problem

$programFit

## In Scope

- Use the selected component pack: ``$componentPack``.
- Keep the project under the $programName program.
- Preserve the benchmark contract: ``$primaryMetric`` in ``$benchmarkResultPath``.
- Keep the default path local-first and reproducible.

## Out Of Scope

- Paid credentials for the default demo.
- External infrastructure that is not required by the benchmark.
- Replacing local portfolio skills with external components silently.

## Default Demo Path

- Status: $status
- Runtime: $runtime
- Benchmark command: ``$benchmarkCommand``

## Public Proof

- Benchmark: $benchmarkLine
- Result path: ``$benchmarkResultPath``
"@
  "portfolio-impact.md" = @"
# Portfolio Impact: $name

## Program

- Program id: ``$programId``
- Program name: $programName
- Component pack: ``$componentPack``

## System Story

$programFit

This repository is not a standalone demo. It is one part of the $programName system and should produce reusable fixtures, benchmark patterns, and decisions for later repositories.

## Proficiency Signal

- Primary profile: ``$languagePrimary``
- Stack profile: ``$stackProfile``
- Stack:
$stackList

## Post Angle

Open with $benchmarkLine, then explain why the architecture and local-first path make the result reproducible.
"@
  "architecture-record.md" = @"
# Architecture Record: $name

## Decision

- Architecture: ``$architectureStyle``
- Stack profile: ``$stackProfile``
- API style: ``$apiStyle``
- Messaging: ``$messaging``
- Database/runtime: ``$database`` / ``$runtime``

## Reason

$architectureReason

## Dependency Direction

$dependencyRule

## Boundaries

$boundariesList

## Library Policy

$libraryPolicy

## Principle Check

- SRP: keep benchmark, API, use cases, and adapters separate.
- OCP: new providers must be adapters, not domain rewrites.
- LSP: replacement providers must preserve observable behavior.
- ISP: ports stay narrow.
- DIP: application depends on behavior, not infrastructure.
- KISS/YAGNI: leave out anything that does not improve the benchmark.
"@
  "component-pack.md" = @"
# Component Pack: $name

## Selected Pack

- Pack id: ``$componentPack``
- Pack name: $packName
- Problem: $packProblem

## Benchmark Focus

$packBenchmarkList

## Preferred Artifacts

$packArtifactList

## Rejection Rules

$packRejectionList

## Reuse Priority

1. Use repo-local `.codex/skills/` and `.claude/skills/`.
2. Use `.portfolio/` and upstream `portfolio-reuse-kit`.
3. Use external repositories as references for organization, workflow, schemas, tests, benchmarks, and docs.
4. Use external code only with license compatibility, attribution, and a decision record.
"@
  "reuse-delta.md" = @"
# Reuse Delta: $name

## Reusable Discoveries

| Candidate | Decision | Reason | Follow-up |
|---|---|---|---|
| generated OpenSpec-style plan | patch-now | Repeated project planning should not be recreated by hand. | Keep `tools/plan-project.ps1` in the kit. |
| article voice check | patch-now | Posts should sound consistent with README/SDD evidence. | Use `voice-check.md` before publishing articles. |
| external repo patterns | guarded-use | External repositories may improve organization and benchmark design. | Record reference and update kit before spreading the pattern. |

## Final Gate

- [x] Reuse improvement considered.
- [x] Local skills remain primary.
- [x] External references stay attributed and problem-driven.
"@
  "benchmark-proof.md" = @"
# Benchmark Proof: $name

## Primary Metric

- Metric: ``$primaryMetric``
- Unit: ``$unit``
- Result: $benchmarkLine
- Result path: ``$benchmarkResultPath``

## Command

```powershell
$benchmarkCommand
```

## Evidence

$latencyLine

The README/post number must come from the committed benchmark JSON, not from manual text.
"@
  "tasks.md" = @"
# Tasks: $name

## Planning

- [x] Read `project.yaml`.
- [x] Select component pack `$componentPack`.
- [x] Generate OpenSpec-style artifacts.
- [x] Generate article draft.
- [x] Compare article voice against existing docs.

## Implementation

- [ ] Update generated artifacts if the architecture or benchmark changes.
- [ ] Keep local skills and `.portfolio/` as primary.
- [ ] Record any external reference in `REFERENCES.md`.

## Publication

- [ ] Validate project.
- [ ] Confirm article uses committed benchmark result.
- [ ] Confirm `voice-check.md` verdict is aligned or intentionally overridden.
"@
  "verification.md" = @"
# Verification: $name

## Generated By

`tools/plan-project.ps1`

## Inputs

- Manifest: `project.yaml`
- References:
$styleRefsList
- Benchmark result: ``$benchmarkResultPath``

## Checks

- Component pack selected: ``$componentPack``
- Benchmark line: $benchmarkLine
- Voice verdict: $voiceVerdict

## Remaining Risk

The generated plan is a starting point. Re-run this tool or edit the artifacts when code, benchmark, or architecture decisions change.
"@
  "article-draft.md" = $article
  "voice-check.md" = @"
# Voice Check: $name

## Verdict

$voiceVerdict ($score/$maxScore)

## Reference Files

$styleRefsList

## Style Stats

| Source | Words | Avg sentence words | Headings | Bullets | Numbers | Evidence words | Hype words |
|---|---:|---:|---:|---:|---:|---:|---:|
| existing docs | $($referenceStats.Words) | $($referenceStats.AverageSentenceWords) | $($referenceStats.Headings) | $($referenceStats.Bullets) | $($referenceStats.Numbers) | $($referenceStats.EvidenceWords) | $($referenceStats.HypeWords) |
| generated article | $($articleStats.Words) | $($articleStats.AverageSentenceWords) | $($articleStats.Headings) | $($articleStats.Bullets) | $($articleStats.Numbers) | $($articleStats.EvidenceWords) | $($articleStats.HypeWords) |

## Checks

$checksText

## Interpretation

The desired portfolio voice is direct, evidence-first, benchmark-heavy, specific about tradeoffs, and light on adjectives. A generated article should sound like the README and SDD were written by the same engineer: first the number, then the claim, then the architectural tradeoff.
"@
}

if ($DryRun) {
  Write-Host "dry_run=true"
  Write-Host "repo=$repo"
  Write-Host "output=$outputPath"
  Write-Host "component_pack=$componentPack"
  Write-Host "voice_verdict=$voiceVerdict"
  $files.Keys | ForEach-Object { Write-Host "would_write=$_" }
  exit 0
}

New-Item -ItemType Directory -Force -Path $outputPath | Out-Null

foreach ($entry in $files.GetEnumerator()) {
  $target = Join-Path $outputPath $entry.Key
  if ((Test-Path -LiteralPath $target) -and -not $Force) {
    throw "Refusing to overwrite existing artifact without -Force: $target"
  }
  Write-Utf8NoBom -Path $target -Content ($entry.Value.TrimEnd() + "`n")
}

Write-Host "planned_project=$name"
Write-Host "component_pack=$componentPack"
Write-Host "output=$outputPath"
Write-Host "voice_verdict=$voiceVerdict"
