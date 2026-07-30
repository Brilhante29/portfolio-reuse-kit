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
  "AGENTS.md",
  "CLAUDE.md",
  "requirements-ci.txt",
  "PUBLISH.md",
  ".openspec-store/store.yaml",
  "LICENSE",
  ".editorconfig",
  ".gitattributes",
  "catalog/projects.yaml",
  "catalog/projects.md",
  "catalog/programs.yaml",
  "catalog/proficiency.yaml",
  "catalog/technology-coverage.yaml",
  "catalog/reuse-policy.md",
  "architecture/decision-matrix.yaml",
  "component-packs/manifest.yaml",
  "decision-brain/README.md",
  "decision-brain/agent-graph.yaml",
  "decision-brain/agentic-spec-governance.yaml",
  "decision-brain/reuse-improvement-loop.yaml",
  "decision-brain/continuity-protocol.yaml",
  "decision-brain/engineering-principles.yaml",
  "decision-brain/stack-matrix.yaml",
  "decision-brain/jvm-language-matrix.yaml",
  "decision-brain/kafka-streams-matrix.yaml",
  "decision-brain/api-style-matrix.yaml",
  "decision-brain/cloud-matrix.yaml",
  "decision-brain/messaging-matrix.yaml",
  "decision-brain/library-selection.yaml",
  "design-system/README.md",
  "design-system/tokens.yaml",
  "design-system/generated/tokens.css",
  "design-system/generated/tokens.scss",
  "design-system/generated/tokens.ts",
  "design-system/generated/manifest.json",
  "language-profiles/python.yaml",
  "language-profiles/java.yaml",
  "language-profiles/kotlin-jvm.yaml",
  "language-profiles/java-spring.yaml",
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
  "contracts/benchmark-result-v2.schema.json",
  "contracts/fixtures/project.valid.json",
  "contracts/fixtures/project.non-jvm.valid.json",
  "contracts/fixtures/project.legacy.valid.json",
  "contracts/fixtures/project.invalid.json",
  "contracts/fixtures/project.jvm-profile-missing-jvm.invalid.json",
  "contracts/fixtures/project.kafka-mode-mismatch.invalid.json",
  "contracts/fixtures/project.kafka-selected-brain-none.invalid.json",
  "contracts/fixtures/project.kafka-streams-orphan.invalid.json",
  "contracts/fixtures/project.unknown-wrapper-checksum.invalid.json",
  "contracts/fixtures/project.wrapper-pair-mismatch.invalid.json",
  "contracts/fixtures/benchmark-result-v2.valid.json",
  "contracts/fixtures/benchmark-result-v2.invalid.json",
  "contracts/fixtures/portfolio-audit.valid.json",
  "contracts/portfolio-evidence.openapi.yaml",
  "contracts/portfolio-evidence.graphql",
  "contracts/manifest.json",
  "contracts/monitoring-batch.schema.json",
  "contracts/execution-event.schema.json",
  "contracts/publication-evidence.schema.json",
  "docs/reuse-layer.md",
  "docs/architecture-decision-guide.md",
  "docs/decision-brain.md",
  "docs/kafka-streams-decision.md",
  "docs/manifest-v2-rollout.md",
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
  "docs/ai-evaluation-retrieval.md",
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
  ".portfolio-control/README.md",
  ".portfolio-control/control.yaml",
  ".portfolio-control/AGENT_HANDOFFS/README.md",
  ".portfolio-control/CURRENT_HANDOFF.md",
  ".portfolio-control/CONTINUITY_STATE.md",
  ".portfolio-control/EXECUTION_EVENTS.jsonl",
  ".portfolio-control/EXECUTION_EFFICIENCY.md",
  ".portfolio-control/execution-efficiency.json",
  ".portfolio-control/portfolio-audit.json",
  ".portfolio-control/PORTFOLIO_STATUS.md",
  ".portfolio-control/PORTFOLIO_STATUS.json",
  "docs/audits/portfolio-implementation-audit-2026-07-21.md",
  "docs/architecture/technology-coverage-and-interoperability.md",
  "templates/openspec-config.yaml",
  "templates/README-project.md",
  "templates/portfolio-control/INVENTORY.md",
  "templates/portfolio-control/REUSE_MAP.md",
  "templates/portfolio-control/CRITICAL_PATH.md",
  "templates/portfolio-control/CONTINUITY_STATE.md",
  "templates/portfolio-control/DECISIONS.md",
  "templates/portfolio-control/QUALITY_GATES.md",
  "templates/portfolio-control/AGENT_HANDOFFS/README.md",
  "templates/AGENTS.md",
  "templates/CLAUDE.md",
  "templates/aitmpl-config.yaml",
  "templates/aitmpl-context-card.md",
  "templates/openspec-change-proposal.md",
  "templates/openspec-change-design.md",
  "templates/openspec-change-tasks.md",
  "templates/openspec-change-spec.md",
  "templates/validate-project.ps1",
  "templates/validate-gradle-project.ps1",
  "templates/project.yaml",
  "tools/new-project.ps1",
  "tools/install-project-skills.ps1",
  "tools/backfill-project-standard.ps1",
  "tools/plan-project.ps1",
  "tools/prepare-project.ps1",
  "tools/sync-project-reuse.ps1",
  "tools/publish-github.ps1",
  "tools/publish-all.ps1",
  "tools/set-github-token.ps1",
  "tools/clear-github-token.ps1",
  "tools/validate-portfolio.ps1",
  "tools/validate-contracts.py",
  "tools/audit-manifest-rollout.py",
  "tools/validate-gradle-project.ps1",
  "tools/generate-contract-manifest.py",
  "tools/generate-design-tokens.py",
  "tools/sync-catalog-stacks.py",
  "tools/record-execution-event.ps1",
  "tools/report-execution-efficiency.ps1",
  "tools/capture-continuity-state.ps1",
  "tools/verify-github-publication.ps1",
  "tools/report-portfolio.ps1",
  "tools/checkpoint-portfolio.ps1",
  "tools/test-checkpoint-portfolio.ps1",
  "tools/validate-kit.ps1"
)

foreach ($file in $requiredFiles) { Require-File $file }

$requiredDirs = @(
  ".codex/skills/portfolio-project",
  ".codex/skills/agent-orchestration",
  ".codex/skills/reuse-improvement-review",
  ".codex/skills/continuity-checkpoint",
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
  ".codex/skills/jvm-language-decision",
  ".codex/skills/kafka-streams",
  ".codex/skills/design-system",
  ".codex/skills/spring-kotlin-backend",
  ".codex/skills/fastapi-backend",
  ".codex/skills/go-backend",
  ".codex/skills/node-typescript-backend",
  ".claude/skills/portfolio-project",
  ".claude/skills/agent-orchestration",
  ".claude/skills/reuse-improvement-review",
  ".claude/skills/continuity-checkpoint",
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
  ".claude/skills/jvm-language-decision",
  ".claude/skills/kafka-streams",
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

$projectCount = (Select-String -Path (Join-Path $root "catalog/projects.yaml") -Pattern "^\s*- id: ").Count
$programCount = (Select-String -Path (Join-Path $root "catalog/programs.yaml") -Pattern "^\s*- id: ").Count
if ($projectCount -lt 33) {
  $failures.Add("Expected the approved 33 projects in catalog/projects.yaml; found $projectCount")
}
if ($programCount -lt 6) {
  $failures.Add("Expected at least 6 programs in catalog/programs.yaml; found $programCount")
}

Require-Pattern "component-packs/manifest.yaml" "^base_pack:"
Require-Pattern "component-packs/manifest.yaml" "^reuse_priority_order:"
Require-Pattern "component-packs/manifest.yaml" "id: ai-evaluation-retrieval"
Require-Pattern "decision-brain/agentic-spec-governance.yaml" "^artifact_graph:"
Require-Pattern "decision-brain/cloud-matrix.yaml" "image_digest:"
Require-Pattern "templates/validate-project.ps1" "Mutable Kumo image reference found"
Require-Pattern "decision-brain/agentic-spec-governance.yaml" "user-owned skills"
Require-Pattern "catalog/reuse-policy.md" "Priorize as skills"
Require-Pattern "decision-brain/agentic-spec-governance.yaml" "id: benchmark-proof"
Require-Pattern "openspec/schemas/portfolio-system/schema.yaml" "id: intent"
Require-Pattern "openspec/schemas/portfolio-system/schema.yaml" "id: component-pack"
Require-Pattern "openspec/schemas/portfolio-system/schema.yaml" "id: verification"
Require-Pattern "templates/project.yaml" "agentic_spec:"
Require-Pattern "templates/openspec-config.yaml" "schema: portfolio-system"
Require-Pattern "tools/install-project-skills.ps1" "component-packs"
Require-Pattern "tools/install-project-skills.ps1" 'contracts/\*'
Require-Pattern "tools/new-project.ps1" 'design-system/\*'
Require-Pattern "tools/new-project.ps1" "capture-continuity-state.ps1"
Require-Pattern "tools/sync-project-reuse.ps1" "validate-gradle-project.ps1"
Require-Pattern "tools/sync-project-reuse.ps1" "capture-continuity-state.ps1"
Require-Pattern "tools/plan-project.ps1" "voice_verdict"
Require-Pattern "tools/prepare-project.ps1" "OpenSpec CLI was requested"
Require-Pattern "tools/prepare-project.ps1" "UseAitmpl requires explicit"
Require-Pattern "templates/CLAUDE.md" "Read"
Require-Pattern "templates/aitmpl-config.yaml" "External components are optional"
Require-Pattern "tools/plan-project.ps1" 'Read ``project.yaml``'
Require-Pattern "tools/plan-project.ps1" 'Keep ``tools/plan-project.ps1`` in the kit.'
Require-Pattern "tools/plan-project.ps1" "Confirm published CI is green."
Require-Pattern "tools/plan-project.ps1" '\$implementationCheck = if \(\$status -in'
Require-Pattern "tools/plan-project.ps1" '\$benchmarkCheck = if \(\$status -in'
Require-Pattern "tools/plan-project.ps1" '\$publicationCheck = if \(\$status -eq "published"\)'
Require-Pattern "tools/plan-project.ps1" '- \[\$publicationCheck\] Confirm published CI is green\.'
if (Select-String -Path (Join-Path $root "tools/plan-project.ps1") -Pattern "prove the retrieval layer" -SimpleMatch -Quiet) {
  $failures.Add("Project planner contains a domain-specific default narrative")
}
Require-Pattern "tools/sync-project-reuse.ps1" "BackfillMissing"
Require-Pattern "templates/validate-project.ps1" "go test ./..."
Require-Pattern "templates/validate-gradle-project.ps1" "Gradle clean check failed"
Require-Pattern "templates/validate-gradle-project.ps1" "Missing Gradle file"
Require-Pattern "templates/validate-project.ps1" "Tracked build/cache artifacts must be removed"
Require-Pattern ".gitignore" "^.gradle/"
Require-Pattern "templates/validate-project.ps1" "pythonFiles.Count"
Require-Pattern "templates/validate-project.ps1" "openspec/artifacts/verification.md"
Require-Pattern "templates/validate-project.ps1" "openspec/artifacts/voice-check.md"
Require-Pattern "templates/validate-project.ps1" "project YAML parsing"
Require-Pattern "templates/validate-project.ps1" "Benchmark metric mismatch"
Require-Pattern "templates/validate-project.ps1" "ls-files --cached --others --exclude-standard"
Require-Pattern "templates/validate-project.ps1" '-contains "metrics"'
Require-Pattern "templates/validate-project.ps1" "README opening does not include primary benchmark value"
Require-Pattern "docs/cross-platform.md" "Windows, Linux, and macOS"
Require-Pattern "language-profiles/spring-kotlin.yaml" "spring_boot_4:"
Require-Pattern "language-profiles/spring-kotlin.yaml" "spring-boot-starter-flyway"
Require-Pattern "language-profiles/spring-kotlin.yaml" "tools.jackson.module:jackson-module-kotlin"
Require-Pattern "language-profiles/spring-kotlin.yaml" "summaryTrendStats"
Require-Pattern ".codex/skills/spring-kotlin-backend/SKILL.md" "Gradle wrappers for Windows and POSIX"
Require-Pattern ".claude/skills/spring-kotlin-backend/SKILL.md" "Gradle wrappers for Windows and POSIX"
Require-Pattern ".codex/skills/benchmark-harness/SKILL.md" "setup-inclusive k6 rates"
Require-Pattern ".claude/skills/benchmark-harness/SKILL.md" "setup-inclusive k6 rates"
Require-Pattern ".codex/skills/agent-orchestration/SKILL.md" "Efficiency and Limit Gate"
Require-Pattern ".claude/skills/agent-orchestration/SKILL.md" "Efficiency and Limit Gate"
Require-Pattern "decision-brain/agent-graph.yaml" "execution_efficiency:"
Require-Pattern "decision-brain/jvm-language-matrix.yaml" "outbox-pattern:"
Require-Pattern "decision-brain/continuity-protocol.yaml" "exit_loop_rules"
Require-Pattern "decision-brain/continuity-protocol.yaml" "completion_requires: published_verified"
Require-Pattern "tools/checkpoint-portfolio.ps1" "Statuses are derived from tools/validate-portfolio.ps1"
Require-Pattern "tools/checkpoint-portfolio.ps1" "published_verified"
Require-Pattern "tools/checkpoint-portfolio.ps1" "RepositoryOverrides"
Require-Pattern "tools/validate-portfolio.ps1" "remote get-url origin"
Require-Pattern "tools/validate-portfolio.ps1" 'benchmarkContract -or \$benchmarkContractV2'
Require-Pattern "tools/capture-continuity-state.ps1" "Sanitize-Line"
Require-Pattern "tools/audit-manifest-rollout.py" "v2_ready"
Require-Pattern "docs/manifest-v2-rollout.md" "legacy compatibility"
Require-Pattern "AGENTS.md" "CURRENT_HANDOFF.md"
Require-Pattern "CLAUDE.md" "CURRENT_HANDOFF.md"
Require-Pattern "decision-brain/kafka-streams-matrix.yaml" "topology_test_driver"
Require-Pattern "decision-brain/stack-matrix.yaml" "technical_validity_before_portfolio_signal"
Require-Pattern "templates/validate-gradle-project.ps1" "distributionSha256Sum"
Require-Pattern "templates/validate-gradle-project.ps1" "gradle/actions/setup-gradle"
Require-Pattern "templates/Dockerfile.spring" "ARG JVM_VERSION=21"
Require-Pattern "tools/validate-gradle-project.ps1" "java-version must be static"
Require-Pattern "tools/validate-gradle-project.ps1" '(?:-\\s*)?run'
Require-Pattern "tools/plan-project.ps1" "interoperabilityBoundary"
Require-Pattern "tools/plan-project.ps1" "yaml.safe_load"
Require-Pattern "tools/plan-project.ps1" "kafkaRebalancePlan"
Require-Pattern "tools/validate-gradle-project.ps1" "jvm.toolchain_version does not match"
Require-Pattern "tools/validate-gradle-project.ps1" "wrapper_distribution_sha256 does not match"
Require-Pattern "contracts/project.schema.json" '"manifest_version"'
Require-Pattern "contracts/project.schema.json" '"rebalance_plan"'
Require-Pattern "docs/architecture/technology-coverage-and-interoperability.md" "portfolio-evidence-api"
Require-Pattern "catalog/programs.yaml" "id: portfolio-evidence-platform"
Require-Pattern "catalog/technology-coverage.yaml" "planned_repository: portfolio-evidence-api"
Require-Pattern ".portfolio-control/CURRENT_HANDOFF.md" "## Continuation Order"
Require-Pattern "contracts/benchmark-result-v2.schema.json" '"clean_tree": \{ "const": true \}'
Require-Pattern "contracts/portfolio-evidence.openapi.yaml" "operationId: ingestBenchmarkRun"
Require-Pattern "contracts/portfolio-evidence.openapi.yaml" "Idempotency-Key"
Require-Pattern "contracts/portfolio-evidence.openapi.yaml" "InvalidOperation"
Require-Pattern "contracts/portfolio-evidence.graphql" "compareBenchmarkRuns"
Require-Pattern "contracts/manifest.json" '"contract_set_version": "1.2.0"'
Require-Pattern "templates/validate-project.ps1" "Vendored contract drift"
Require-Pattern "templates/validate-project.ps1" '\.portfolio/contracts/project\.schema\.json'
Require-Pattern "tools/publish-all.ps1" "publication_candidate"

Invoke-Checked "harness result schema JSON" { python -m json.tool (Join-Path $root "harness/result.schema.json") | Out-Null }
Invoke-Checked "project schema JSON" { python -m json.tool (Join-Path $root "contracts/project.schema.json") | Out-Null }
Invoke-Checked "benchmark schema JSON" { python -m json.tool (Join-Path $root "contracts/benchmark-result.schema.json") | Out-Null }
Invoke-Checked "benchmark v2 schema JSON" { python -m json.tool (Join-Path $root "contracts/benchmark-result-v2.schema.json") | Out-Null }
Invoke-Checked "monitoring batch schema JSON" { python -m json.tool (Join-Path $root "contracts/monitoring-batch.schema.json") | Out-Null }
Invoke-Checked "execution event schema JSON" { python -m json.tool (Join-Path $root "contracts/execution-event.schema.json") | Out-Null }
Invoke-Checked "publication evidence schema JSON" { python -m json.tool (Join-Path $root "contracts/publication-evidence.schema.json") | Out-Null }
Invoke-Checked "interoperability contracts" { python (Join-Path $root "tools/validate-contracts.py") | Out-Null }
Invoke-Checked "generated contract manifest" { python (Join-Path $root "tools/generate-contract-manifest.py") --check | Out-Null }
Invoke-Checked "generated design tokens" { python (Join-Path $root "tools/generate-design-tokens.py") --check | Out-Null }
Invoke-Checked "portfolio checkpoint fixture" { & (Join-Path $root "tools/test-checkpoint-portfolio.ps1") | Out-Null }
$executionLine = 0
foreach ($line in Get-Content -LiteralPath (Join-Path $root ".portfolio-control/EXECUTION_EVENTS.jsonl")) {
  $executionLine++
  if (-not $line.Trim()) { continue }
  try { $event = $line | ConvertFrom-Json } catch { $failures.Add("Invalid execution JSONL at line $executionLine"); continue }
  foreach ($field in @("schema_version","event_id","recorded_at","actor","phase","category","outcome","occurrences","duration_seconds","avoidable","excluded_from_efficiency","evidence","cause","remediation")) {
    if ($field -notin @($event.PSObject.Properties.Name)) { $failures.Add("Execution event line $executionLine missing $field") }
  }
}
$pythonSyntaxCommand = "import ast, pathlib; [ast.parse(pathlib.Path(p).read_text(encoding='utf-8')) for p in [r'$root/harness/bench.py', r'$root/harness/compare_results.py', r'$root/tools/validate-contracts.py', r'$root/tools/audit-manifest-rollout.py', r'$root/tools/generate-contract-manifest.py', r'$root/tools/generate-design-tokens.py', r'$root/tools/sync-catalog-stacks.py']]; print('python syntax ok')"
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
  "tools/validate-portfolio.ps1",
  "tools/record-execution-event.ps1",
  "tools/report-execution-efficiency.ps1",
  "tools/verify-github-publication.ps1",
  "tools/report-portfolio.ps1",
  "tools/checkpoint-portfolio.ps1",
  "tools/test-checkpoint-portfolio.ps1",
  "tools/capture-continuity-state.ps1",
  "tools/validate-gradle-project.ps1",
  "templates/validate-project.ps1",
  "templates/validate-gradle-project.ps1",
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
$publicRelativeFiles = @(& git -C $root ls-files --cached --others --exclude-standard)
$publicFileExit = $LASTEXITCODE
$global:LASTEXITCODE = 0
if ($publicFileExit -ne 0) {
  $failures.Add("Cannot enumerate public tracked and untracked files")
}
$searchExtensions = @(".md", ".yaml", ".yml", ".json", ".ps1", ".py", ".js", ".ts", ".tsx", ".go", ".kt", ".java")
$searchFiles = @(
  foreach ($relativePath in $publicRelativeFiles) {
    $candidate = Join-Path $root ($relativePath -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (
      (Test-Path -LiteralPath $candidate -PathType Leaf) -and
      ([IO.Path]::GetExtension($candidate) -in $searchExtensions) -and
      ($relativePath -notmatch "^benchmarks/results/")
    ) {
      Get-Item -LiteralPath $candidate
    }
  }
)
$forbidden = Select-String -Path $searchFiles.FullName -Pattern $patterns -SimpleMatch -ErrorAction SilentlyContinue
if ($forbidden) {
  $failures.Add("Forbidden legacy project nickname found")
}

$mutableKumoPattern = "ghcr.io/sivchari/kumo:" + "latest"
$mutableKumo = Select-String -Path $searchFiles.FullName -Pattern $mutableKumoPattern -SimpleMatch -ErrorAction SilentlyContinue
if ($mutableKumo) {
  $failures.Add("Mutable Kumo image reference found; pin a reviewed tag and digest")
}

$slash = [char]92
$forwardSlash = [char]47
$hardcodedPathPatterns = @(
  ("C:" + $slash + "Users" + $slash),
  ("C:" + $forwardSlash + "Users" + $forwardSlash),
  ($forwardSlash + "Users" + $forwardSlash),
  ($forwardSlash + "home" + $forwardSlash)
)
$hardcodedPaths = Select-String -Path $searchFiles.FullName -Pattern $hardcodedPathPatterns -SimpleMatch -ErrorAction SilentlyContinue
if ($hardcodedPaths) {
  $failures.Add("Personal absolute path found in public repository files")
}

$liveTokenPattern = "(ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})"
$liveTokens = Select-String -Path $searchFiles.FullName -Pattern $liveTokenPattern -ErrorAction SilentlyContinue
if ($liveTokens) {
  $failures.Add("Live GitHub token pattern found in public repository files")
}
if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host "portfolio-reuse-kit validation passed"
