# Portfolio Decision Register

## i-have-adhd

- Source: `https://github.com/ayghri/i-have-adhd`
- Skill: `skills/i-have-adhd/SKILL.md`
- Commit: `07684c4ab625dd7d1ea6e99e065f60bc0ac6a1ba`
- Scope: workspace
- Status: active
- Verification: public `main` resolved with `git ls-remote`; local SKILL.md was read in full.

## Operating Decisions

| Decision | Selected option | Evidence | Revisit trigger |
|---|---|---|---|
| Work order | one active project plus one kit improvement | goal objective and `PROJECT_QUEUE.md` | external blocker or dependency change |
| Project selection | #3 first | local status: code, Docker, and exact-head CI are present; V2 is missing | V2 producer and publication evidence pass |
| Architecture | problem-first; clean/hexagonal/modular as forces require | `decision-brain/` and each project's SDD | coupling or proof target changes |
| Local-first | Docker by default; Kumo only for AWS-like behavior | `decision-brain/cloud-matrix.yaml` | parity gap is measured |
| Publication result | keep v1 execution evidence and V2 provenance evidence separate | central validator currently conflates one path; fix is generic | contract model changes |
| Secrets | environment only; never write token values | `AGENTS.md`, continuity protocol | none |

## Engineering Principles

- Domain and application policy stay independent from transport and infrastructure.
- Ports own contracts; adapters depend inward and preserve failure semantics.
- SOLID, LSP, KISS, YAGNI, DRY, and testability must be evidenced in code and tests.
- A benchmark number is valid only when its command, inputs, environment, and provenance are reproducible.

## 2026-07-30 #3 publication closure

- #3 produced a separate contract-valid V2 publication result and passed exact-head CI.
- The central kit now tracks publication evidence by repository and exact HEAD.
- The next active project is #11; its architecture and evidence must be audited before implementation.

## 2026-07-30 #11 publication closure

- #11 published with Kotlin/Gradle dependency locking and three-run V2 benchmark provenance.
- The next active project is #13; audit Kumo/local-first boundaries before implementation.

## 2026-08-02 V2 semantic integrity

- `execution.repeat` records independent run repetitions; it never substitutes for `workload.measured_iterations`.
- The generic producer is selected only for one V1 metric/value result with an explicit or unambiguous workload count.
- Multi-run, multi-metric, provider-diagnostic, and domain-specific aggregation remain project-owned producers behind the shared V2 contract.
- A schema pass is necessary but not sufficient; agents inspect workload size, samples, units, aggregation, provider identity, and exact-head CI.