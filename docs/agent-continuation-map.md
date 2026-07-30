# Agent Continuation Map

This document is the durable, reviewable map of the portfolio decisions. It
exists so Codex, Claude Code, another agent runtime, or a human can continue
the work without relying on conversation memory.

It does not expose private chain-of-thought. It records observable goals,
constraints, decisions, evidence locations, rejected alternatives, open risks,
and exact continuation rules.

## How To Use This Map

Read the files in this order before changing the kit or a project:

1. `AGENTS.md` and `CLAUDE.md`
2. `.portfolio-control/CURRENT_HANDOFF.md` for current engineering state
3. `.portfolio-control/CONTINUITY_STATE.md` for mechanical Git/worktree state
4. this file for the durable decision lineage
5. the relevant files listed in `decision-brain/continuity-protocol.yaml`
6. the target project's `project.yaml`, SDD, OpenSpec artifacts, and local
   `.portfolio/` snapshot

The current handoff wins over this document when counts, branches, benchmark
results, blockers, or publication status have changed. Refresh the handoff
after every milestone or before a context, quota, or tool-limit risk.

## Decision Lineage

```text
portfolio ambition
  -> 30 repositories with a coherent portfolio story
  -> macro programs instead of isolated demos
  -> one reusable repository as the decision brain
  -> shared skills, SDD, OpenSpec-style artifacts, harness, contracts, and design system
  -> problem-first architecture and stack decisions
  -> local-first Docker execution with pluggable cloud adapters
  -> reproducible benchmark evidence before publication
  -> continuity state that another agent can verify and resume
```

### 1. Portfolio Goal

The portfolio is intended to demonstrate proficiency through connected systems
and measurable engineering claims. A repository is valuable when it strengthens
a program, reuses the kit, proves one meaningful concept, and produces a
number that can become a truthful post.

The initial roadmap contains 30 numbered repositories. Additional evidence
platform repositories are allowed only when they close a demonstrated portfolio
gap and are recorded separately in the catalog. Do not increase repository
count merely to add a technology keyword.

### 2. Reuse Kit Role

`portfolio-reuse-kit` is the shared operating system of the portfolio. It owns:

- catalog and macro-program grouping
- architecture and stack decision matrices
- engineering-principle rules
- API, messaging, cloud, library, and JVM language decisions
- agent graph and continuation protocol
- Codex and Claude Code skills
- SDD and OpenSpec-style artifact templates
- project and benchmark contracts
- Docker, CI, validation, benchmark, publication, and telemetry tooling
- design-system tokens and documentation standards

The kit must evolve when a project exposes a repeated, low-risk, reusable gap.
Project-specific business logic stays in the project.

### 3. Problem Before Stack

Architecture and technology are consequences of the problem and proof target.
The decision order is:

```text
program fit
  -> problem forces and acceptance criteria
  -> architecture and dependency direction
  -> decoupling and engineering-principle checks
  -> language/framework profile
  -> API style
  -> messaging mode
  -> local-first/cloud mode
  -> database and library choices
  -> benchmark workload and evidence contract
```

Framework familiarity or a desired portfolio signal can break a tie between
valid options. It cannot justify an unnecessary broker, cloud service,
framework, language migration, or repository.

### 4. Boundary Rules

The architecture must make the following claims observable in code and tests:

- domain and application policy do not import transport, framework, ORM,
  database driver, cloud SDK, broker SDK, environment access, or UI rendering
- ports belong to the policy-owning boundary; adapters depend inward
- local fakes, Kumo adapters, real-cloud adapters, persistence adapters, and
  broker adapters preserve the same port contract and failure semantics
- SRP, OCP, LSP, ISP, and DIP are evidenced at real module boundaries
- KISS, YAGNI, DRY, Law of Demeter, and testability prevent speculative design
- integration complexity is measured when it is the subject of the repository,
  not hidden behind a convenience library

### 5. Stack And Protocol Policy

The kit has profiles for the user's target skills: Kotlin and Spring with
Gradle, Java where it proves a distinct JVM point, Python with FastAPI for ML,
RAG and data APIs, Go for low-overhead services and infrastructure, Node.js
with TypeScript and NestJS for modular product APIs, GraphQL when flexible
read composition is the actual problem, Angular for operations consoles, and
React/Next.js for public product-facing interfaces.

The protocol decision is workload-driven:

| Need | Default candidate | Required proof |
|---|---|---|
| Commands, CRUD, simple public API | REST/HTTP | contract and request benchmark |
| Flexible nested reads or BFF | GraphQL | schema ownership, depth/complexity controls, resolver benchmark |
| Typed service-to-service calls | gRPC | `.proto`, compatibility, and latency benchmark |
| Bidirectional live interaction | WebSocket | connection and message behavior |
| Server-to-client updates | SSE | stream lifecycle and delivery behavior |
| Automation or harness | CLI | deterministic exit codes and result files |

Messaging follows the same rule: no broker by default; outbox for atomic
transaction-plus-publish; RabbitMQ for routed jobs, acknowledgements, retry,
and DLQ; Kafka/Redpanda for event logs, replay, partitions, or stream
processing. A benchmark must prove the selected semantics.

### 6. Local-First Cloud Policy

Docker is the default execution boundary. For AWS-like behavior, Kumo is the
local-first provider. Real cloud providers remain adapters behind the same
ports and are never required for the default demo. Parity tests cover the
behavior relevant to the benchmark. No secret is committed or needed for the
default path.

### 7. Evidence And Publication Policy

Each repository must open its README with its number, claim, and measured
benchmark. The benchmark command must be reproducible and write a contract-
validated JSON result. Publication status requires current-head evidence, not
just a manifest value or a historical green workflow.

The minimum project evidence graph is:

```text
project.yaml
  -> sdd/spec.md
  -> sdd/architecture-decision.md
  -> sdd/technical-decision.md
  -> sdd/benchmark-plan.md
  -> sdd/agent-handoff.md
  -> sdd/reuse-improvement-review.md
  -> Docker + tests + CI
  -> benchmarks/results/*.json
  -> README result table + REFERENCES.md
```

OpenSpec-compatible changes use the same facts as SDD; they are not a second
source of truth. AITmpl-style context cards are generated adapters for agent
runtimes, not permission to install external tooling or replace local skills.

### 8. Continuity And Efficiency Policy

Continuity has three layers:

| Layer | File | Purpose | Volatility |
|---|---|---|---|
| Durable rationale | `docs/agent-continuation-map.md` | Why the portfolio and kit make these decisions | low |
| Engineering handoff | `.portfolio-control/CURRENT_HANDOFF.md` | What is true now, what failed, and what happens next | medium/high |
| Mechanical snapshot | `.portfolio-control/CONTINUITY_STATE.md` | Branch, head, dirty files, remotes, worktrees | generated |

Before a limit or handoff, capture exact commands, observed output, dirty
files, blockers, and next actions. Never capture secrets, private reasoning,
invented benchmark values, or stale status as current.

When execution is inefficient, record one event with the failure, cause, and
remediation. Do not rerun an unchanged expensive check without a changed head
or a new hypothesis. Prefer a bounded progress check after long-running work.

## Decision Record Format

Every material decision should be recoverable with this compact structure:

```text
Context: what problem and proof target forced the decision?
Constraints: runtime, compatibility, security, portfolio, or benchmark limits.
Options: the small set of technically viable choices considered.
Decision: the selected option and its boundary.
Rejected: why the other viable options were not selected.
Evidence: file, command, test, benchmark, or primary reference.
Revisit trigger: what measured change would invalidate the choice?
Reuse impact: patch_now, backlog, or reject, with reason.
Next action: one concrete command or file-level action.
```

Do not write a stream of speculative thoughts. Write the smallest explanation
that lets a reviewer reproduce the decision and challenge it.

## Continuation Algorithm

When another agent takes over:

1. Confirm the repository, branch, head, and dirty files.
2. Read the canonical handoff and classify every item as fact, decision,
   blocker, or next action.
3. Select exactly one critical-path action.
4. Read only the decision matrices and project artifacts needed for that action.
5. Make the smallest change that preserves the contract.
6. Run targeted checks first, then the relevant full gate.
7. Update evidence, reuse review, and handoff with exact results.
8. Capture a continuity snapshot before ending or switching repositories.

If the same blocker repeats three times without a meaningful external-state
change, mark it as blocked and state the required user action. Do not disguise
uncertainty as completion.

## Security Boundary

Credentials, personal access tokens, environment variable values, and private
agent reasoning never belong in this map, a handoff, a benchmark artifact, or
Git history. Use environment-based authentication ephemerally and sanitize
continuity output before publication. Any token pasted into conversation or
logs must be revoked and rotated by the owner.

## Source Of Truth Map

| Question | Authoritative source |
|---|---|
| What is true now? | `.portfolio-control/CURRENT_HANDOFF.md` |
| What is the current branch/head/worktree state? | `.portfolio-control/CONTINUITY_STATE.md` |
| What is the portfolio program and project inventory? | `catalog/` |
| Which architecture fits the problem? | `architecture/decision-matrix.yaml` |
| Which stack/API/messaging/cloud/library choices are allowed? | `decision-brain/` and `language-profiles/` |
| What must a project prove? | `contracts/`, `metrics/`, and the project's SDD |
| What should be reused? | `component-packs/`, `templates/`, `skills/`, and `docs/reuse-layer.md` |
| What should improve the kit? | `sdd/reuse-improvement-review.md` in the project plus `docs/reuse-improvement-loop.md` |

This document is a map between those sources. It is not a substitute for
reading the source file that owns a decision.
