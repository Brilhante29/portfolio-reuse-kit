$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$failures = New-Object System.Collections.Generic.List[string]

function Require-File {
  param([string]$RelativePath)
  $path = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    $script:failures.Add("Missing file: $RelativePath")
  }
}

function Require-Pattern {
  param([string]$RelativePath, [string]$Pattern)
  if (-not (Select-String -Path (Join-Path $root $RelativePath) -Pattern $Pattern -Quiet)) { $script:failures.Add("Missing pattern '$Pattern' in $RelativePath") }
}

function Invoke-Checked {
  param(
    [string]$Label,
    [scriptblock]$Command
  )
  & $Command
  $exitCode = $LASTEXITCODE
  if ($exitCode -ne 0) {
    $script:failures.Add("$Label failed with exit code $exitCode")
  }
  $global:LASTEXITCODE = 0
}

function Require-Directory {
  param([string]$RelativePath)
  $path = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Container)) {
    $script:failures.Add("Missing directory: $RelativePath")
  }
}

$requiredFiles = @(
  "README.md",
  "PUBLISH.md",
  ".openspec-store/store.yaml",
  "LICENSE",
  ".editorconfig",
  ".gitattributes",
  "catalog/projects.yaml",
  "catalog/projects.md",
  "catalog/programs.yaml",
  "catalog/proficiency.yaml",
  "catalog/reuse-policy.md",
  "architecture/decision-matrix.yaml",
  "component-packs/manifest.yaml",
  "decision-brain/README.md",
  "decision-brain/agent-graph.yaml",
  "decision-brain/agentic-spec-governance.yaml",
  "decision-brain/reuse-improvement-loop.yaml",
  "decision-brain/engineering-principles.yaml",
  "decision-brain/stack-matrix.yaml",
  "decision-brain/api-style-matrix.yaml",
  "decision-brain/cloud-matrix.yaml",
  "decision-brain/messaging-matrix.yaml",
  "decision-brain/library-selection.yaml",
  "design-system/README.md",
  "design-system/tokens.yaml",
  "language-profiles/python.yaml",
  "language-profiles/java.yaml",
  "language-profiles/go.yaml",
  "language-profiles/typescript.yaml",
  "language-profiles/angular.yaml",
  "language-profiles/nextjs.yaml",
  "language-profiles/spring-kotlin.yaml",
  "language-profiles/fastapi-backend.yaml",
  "language-profiles/go-backend.yaml",
  "language-profiles/node-typescript-backend.yaml",
  "language-profiles/terraform.yaml",
  "contracts/project.schema.json",
  "contracts/benchmark-result.schema.json",
  "docs/reuse-layer.md",
  "docs/architecture-decision-guide.md",
  "docs/decision-brain.md",
  "docs/agent-graph.md",
  "docs/reuse-improvement-loop.md",
  "docs/engineering-principles.md",
  "docs/api-style-decision.md",
  "docs/cloud-local-first.md",
  "docs/portfolio-operating-model.md",
  "docs/agentic-spec-governance.md",
  "docs/proficiency-map.md",
  "docs/cross-platform.md",
  "docs/project-lifecycle.md",
  "docs/repository-standard.md",
  "docs/usage.md",
  "harness/bench.py",
  "harness/compare_results.py",
  "harness/result.schema.json",
  "harness/k6/http-smoke.js",
  "metrics/registry.yaml",
  "sdd/templates/spec.md",
  "sdd/templates/benchmark-plan.md",
  "sdd/templates/adr.md",
  "sdd/templates/architecture-decision.md",
  "sdd/templates/technical-decision.md",
  "sdd/templates/agent-handoff.md",
  "sdd/templates/reuse-improvement-review.md",
  "sdd/templates/release-checklist.md",
  "openspec/config.yaml",
  "openspec/schemas/portfolio-system/schema.yaml",
  "openspec/schemas/portfolio-system/templates/intent.md",
  "openspec/schemas/portfolio-system/templates/portfolio-impact.md",
  "openspec/schemas/portfolio-system/templates/architecture-record.md",
  "openspec/schemas/portfolio-system/templates/component-pack.md",
  "openspec/schemas/portfolio-system/templates/reuse-delta.md",
  "openspec/schemas/portfolio-system/templates/benchmark-proof.md",
  "openspec/schemas/portfolio-system/templates/tasks.md",
  "openspec/schemas/portfolio-system/templates/verification.md",
  "templates/openspec-config.yaml",
  "templates/README-project.md",
  "templates/AGENTS.md",
  "templates/validate-project.ps1",
  "templates/project.yaml",
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/backfill-project-standard.ps1",
  "tools/plan-project.ps1",
  "tools/sync-project-reuse.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
  "tools/set-github-token.ps1",
  "tools/clear-github-token.ps1",
  "tools/validate-kit.ps1"
)

foreach ($file in $requiredFiles) { Require-File $file }

$requiredDirs = @(
  ".codex/skills/portfolio-project",
  ".codex/skills/agent-orchestration",
  ".codex/skills/reuse-improvement-review",
  ".codex/skills/spec-driven-project",
  ".codex/skills/agentic-spec-governance",
  ".codex/skills/benchmark-harness",
  ".codex/skills/architecture-selector",
  ".codex/skills/engineering-principles",
  ".codex/skills/stack-decision",
  ".codex/skills/api-style-decision",
  ".codex/skills/cloud-local-first",
  ".codex/skills/messaging-decision",
  ".codex/skills/language-standards",
  ".codex/skills/design-system",
  ".codex/skills/spring-kotlin-backend",
  ".codex/skills/fastapi-backend",
  ".codex/skills/go-backend",
  ".codex/skills/node-typescript-backend",
  ".claude/skills/portfolio-project",
  ".claude/skills/agent-orchestration",
  ".claude/skills/reuse-improvement-review",
  ".claude/skills/spec-driven-project",
  ".claude/skills/agentic-spec-governance",
  ".claude/skills/benchmark-harness",
  ".claude/skills/architecture-selector",
  ".claude/skills/engineering-principles",
  ".claude/skills/stack-decision",
  ".claude/skills/api-style-decision",
  ".claude/skills/cloud-local-first",
  ".claude/skills/messaging-decision",
  ".claude/skills/language-standards",
  ".claude/skills/design-system",
  ".claude/skills/spring-kotlin-backend",
  ".claude/skills/fastapi-backend",
  ".claude/skills/go-backend",
  ".claude/skills/node-typescript-backend"
)

foreach ($dir in $requiredDirs) { Require-Directory $dir }

$skillFiles = Get-ChildItem -Recurse -Filter SKILL.md -Path (Join-Path $root ".codex"), (Join-Path $root ".claude")
foreach ($skill in $skillFiles) {
  $content = Get-Content -Raw -LiteralPath $skill.FullName
  if (-not $content.StartsWith("---`n")) {
    $failures.Add("Skill frontmatter does not start cleanly: $($skill.FullName)")
  }
  if ($content -notmatch "(?m)^name: [a-z0-9-]+$") {
    $failures.Add("Skill missing valid name: $($skill.FullName)")
  }
  if ($content -notmatch "(?m)^description: .+") {
    $failures.Add("Skill missing description: $($skill.FullName)")
  }
}

$projectCount = (Select-String -Path (Join-Path $root "catalog/projects.yaml") -Pattern "^  - id: ").Count
$programCount = (Select-String -Path (Join-Path $root "catalog/programs.yaml") -Pattern "^  - id: ").Count
if ($projectCount -lt 30) {
  $failures.Add("Expected at least the initial 30 projects in catalog/projects.yaml; found $projectCount")
}
if ($programCount -lt 5) {
  $failures.Add("Expected at least 5 programs in catalog/programs.yaml; found $programCount")
}

Require-Pattern "component-packs/manifest.yaml" "^base_pack:"
Require-Pattern "component-packs/manifest.yaml" "^reuse_priority_order:"
Require-Pattern "component-packs/manifest.yaml" "id: ai-evaluation-retrieval"
Require-Pattern "decision-brain/agentic-spec-governance.yaml" "^artifact_graph:"
Require-Pattern "decision-brain/agentic-spec-governance.yaml" "user-owned skills"
Require-Pattern "catalog/reuse-policy.md" "Priorize as skills"
Require-Pattern "decision-brain/agentic-spec-governance.yaml" "id: benchmark-proof"
Require-Pattern "openspec/schemas/portfolio-system/schema.yaml" "id: intent"
Require-Pattern "openspec/schemas/portfolio-system/schema.yaml" "id: component-pack"
Require-Pattern "openspec/schemas/portfolio-system/schema.yaml" "id: verification"
Require-Pattern "templates/project.yaml" "agentic_spec:"
Require-Pattern "templates/openspec-config.yaml" "schema: portfolio-system"
Require-Pattern "tools/install-project-skills.ps1" "component-packs"
Require-Pattern "tools/plan-project.ps1" "voice_verdict"
Require-Pattern "tools/plan-project.ps1" 'Read ``project.yaml``'
Require-Pattern "tools/plan-project.ps1" 'Keep ``tools/plan-project.ps1`` in the kit.'
Require-Pattern "tools/plan-project.ps1" "Confirm published CI is green."
if (Select-String -Path (Join-Path $root "tools/plan-project.ps1") -Pattern "prove the retrieval layer" -SimpleMatch -Quiet) {
  $failures.Add("Project planner contains a domain-specific default narrative")
}
Require-Pattern "tools/sync-project-reuse.ps1" "BackfillMissing"
Require-Pattern "templates/validate-project.ps1" "go test ./..."
Require-Pattern "templates/validate-project.ps1" "gradle check"
Require-Pattern "templates/validate-project.ps1" "Gradle project is missing wrapper file"
Require-Pattern "templates/validate-project.ps1" "pythonFiles.Count"
Require-Pattern "templates/validate-project.ps1" "openspec/artifacts/verification.md"
Require-Pattern "templates/validate-project.ps1" "openspec/artifacts/voice-check.md"
Require-Pattern "templates/validate-project.ps1" "project YAML parsing"
Require-Pattern "templates/validate-project.ps1" "Benchmark metric mismatch"
Require-Pattern "templates/validate-project.ps1" "README opening does not include primary benchmark value"
Require-Pattern "docs/cross-platform.md" "Windows, Linux, and macOS"

Invoke-Checked "harness result schema JSON" { python -m json.tool (Join-Path $root "harness/result.schema.json") | Out-Null }
Invoke-Checked "project schema JSON" { python -m json.tool (Join-Path $root "contracts/project.schema.json") | Out-Null }
Invoke-Checked "benchmark schema JSON" { python -m json.tool (Join-Path $root "contracts/benchmark-result.schema.json") | Out-Null }
$pythonSyntaxCommand = "import ast, pathlib; [ast.parse(pathlib.Path(p).read_text(encoding='utf-8')) for p in [r'$root/harness/bench.py', r'$root/harness/compare_results.py']]; print('python syntax ok')"
Invoke-Checked "python syntax" { python -c $pythonSyntaxCommand | Out-Null }

$powerShellScripts = @(
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/sync-project-reuse.ps1",
  "tools/backfill-project-standard.ps1",
  "tools/plan-project.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
  "tools/set-github-token.ps1",
  "tools/clear-github-token.ps1",
  "tools/validate-kit.ps1"
)

foreach ($script in $powerShellScripts) {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $root $script), [ref]$tokens, [ref]$errors) | Out-Null
  if ($errors.Count -gt 0) {
    foreach ($err in $errors) { $failures.Add("PowerShell parse error in ${script}: $($err.Message)") }
  }
}

$legacy = ("ro" + "che" + "do")
$patterns = @($legacy, ($legacy.Substring(0,1).ToUpper() + $legacy.Substring(1)))
$searchFiles = Get-ChildItem -Path $root -Recurse -File | Where-Object {
  $normalized = $_.FullName -replace "\\", "/"
  $normalized -notmatch "/.git/" -and
  $normalized -notmatch "/benchmarks/results/" -and
  $_.Extension -in @(".md", ".yaml", ".yml", ".json", ".ps1", ".py", ".js", ".ts", ".tsx", ".go", ".kt", ".java")
}
$forbidden = Select-String -Path $searchFiles.FullName -Pattern $patterns -SimpleMatch -ErrorAction SilentlyContinue
if ($forbidden) {
  $failures.Add("Forbidden legacy project nickname found")
}

$slash = [char]92
$hardcodedPathPatterns = @(
  ("C:" + $slash + "Users" + $slash + "Guilherme"),
  ("Desktop" + $slash + "repos-github"),
  ("/" + "Users/Guilherme"),
  ("/" + "home/guilherme")
)
$hardcodedPaths = Select-String -Path $searchFiles.FullName -Pattern $hardcodedPathPatterns -SimpleMatch -ErrorAction SilentlyContinue
if ($hardcodedPaths) {
  $failures.Add("User-specific absolute path found in reusable files")
}

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host "portfolio-reuse-kit validation passed"
