# Agentic Spec Governance

This kit now treats portfolio planning as two connected layers:

1. A component-pack catalog that selects the right agent skills, templates, benchmark assets, and validation gates for each macro program.
2. An OpenSpec-compatible planning schema that turns intent, portfolio impact, architecture, reuse, benchmark proof, tasks, and verification into explicit artifacts.

The goal is not to copy external tools. The goal is to absorb the useful operating model: reusable components from AI Tmpl-style catalogs and versioned, iterative specs from OpenSpec-style stores.

## What Changes

Before a project is implemented, the agent must select:

- the portfolio program from `catalog/programs.yaml`
- the component pack from `component-packs/manifest.yaml`
- the artifact graph from `decision-brain/agentic-spec-governance.yaml`
- the architecture and stack decision from the existing decision brain
- the benchmark proof that will become the README result

That makes a repo less likely to become an isolated demo. It must explain which system it belongs to and what reusable capability it adds.

## Priority Rule

The portfolio uses your skills first:

1. Use the repo-local `.codex/skills/` and `.claude/skills/`.
2. Use the local `.portfolio/` snapshot and upstream `portfolio-reuse-kit`.
3. Use external repositories as references for organization, schemas, workflows, tests, benchmarks, docs, and proven patterns.
4. Use external code/components only with license compatibility, attribution, and a decision record.

When an external repo exposes a better repeatable pattern, update this kit or record the improvement backlog before spreading the pattern across portfolio projects.

## Why Component Packs

AI-agent projects tend to fail when every repo invents its own prompt stack. The component-pack layer solves that by declaring a program-specific bundle:

- skills to load
- decision files to consult
- templates to copy
- benchmark metrics to favor
- rejection rules for overengineering or weak claims
- publication gates

The pack is a recommendation surface, not an installer that silently changes the machine. MCPs, hooks, settings, and external tools require explicit approval before being installed.

## Why OpenSpec-Style Artifacts

A multi-repo portfolio has cross-repo requirements: one backend decision can affect load tests, observability, documentation, and future projects. A planning store keeps that thinking versioned instead of buried in chat history.

This repo is the central planning store:

- `.openspec-store/store.yaml` identifies the store.
- `openspec/config.yaml` defines the portfolio context.
- `openspec/schemas/portfolio-system/` defines the custom artifact graph.
- generated repos get `openspec/config.yaml` and a `.portfolio/` snapshot.

If OpenSpec is installed, the schema can be used directly. If it is not installed, agents still follow the same graph through `sdd/` and `project.yaml`.

## Artifact Graph

```txt
intent
  -> portfolio-impact
  -> architecture-record
  -> component-pack
  -> reuse-delta
  -> benchmark-proof
  -> tasks
  -> verification
```

This is deliberately iterative. If implementation reveals that the architecture, stack, library, broker, cloud adapter, or benchmark was wrong, update the artifact and continue. Do not force the code to match an outdated plan.

## Operating Rules

- Select components by problem and benchmark, not by preferred stack.
- Keep domain/use-case code independent from framework, database, broker, cloud SDK, transport, and UI.
- Record rejected alternatives for architecture, stack, API style, broker, cloud, and important libraries.
- Prefer local-first demos; use Kumo for AWS-like behavior and keep real cloud behind adapters.
- Treat every repeated project pain as a possible kit improvement.
- Before publication, resolve the reuse delta as patch-now, backlog, or rejected.

## Automation

Use `tools/plan-project.ps1` to generate the first OpenSpec-style artifact set for an existing project. The tool reads `project.yaml`, selects the component pack, reads the benchmark result when present, writes planning artifacts under `openspec/artifacts/`, generates an `article-draft.md`, and creates a deterministic `voice-check.md` against the existing README/SDD voice.

The generated files are starting evidence, not a replacement for engineering judgment. Update them when implementation changes the architecture, benchmark, or reuse decision.

## Source Ideas

The component-pack layer is inspired by the AI Tmpl / Claude Code Templates model of reusable agents, commands, MCPs, hooks, settings, templates, workflows, and health checks.

The planning layer is inspired by OpenSpec's store model, custom schemas, artifact graph, and fluid OPSX workflow.

Useful references:

- AI Tmpl / Claude Code Templates docs: https://docs.aitmpl.com/introduction
- AI Tmpl component system: https://docs.aitmpl.com/concepts/components
- OpenSpec repository and docs: https://github.com/Fission-AI/OpenSpec
- OpenSpec stores guide: https://github.com/Fission-AI/OpenSpec/blob/main/docs/stores-beta/user-guide.md
