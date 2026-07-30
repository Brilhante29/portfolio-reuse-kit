# Portfolio Project Queue

The queue is critical-path driven. A project is not complete because its
manifest says `benchmarked`; current Docker, benchmark, CI, publication, and
reuse evidence must agree.

## Active

| Priority | Project | Current evidence | Next action |
|---:|---|---|---|
| 1 | `spring-hexagonal-payments` (#11) | not audited in the current control cycle | audit repository, architecture, benchmark, and reusable gaps |

## Completed In This Cycle

| Project | Evidence |
|---|---|
| `rag-knowledge-base` (#3) | published; V2 schema-valid result, Docker provenance, exact-head CI, and central publication evidence |

## Next

| Priority | Project | Reason |
|---:|---|---|
| 2 | `mini-aws-emulator` (#13) | local-first Kumo and adapter interoperability proof |
| 3 | `mlops-end2end` (#21) | connect Airflow, MLflow, serving, and monitoring truthfully |
| 4 | `ci-cd-templates` (#24) | make CI/security/reuse automation portable |
| 5 | `yolo-training-pipeline` (#1) | strengthen the applied computer-vision family |

## Selection Rules

- Keep one active implementation project and one reusable-kit improvement.
- Skip a project only when its current evidence proves the required gates.
- Repair false claims before adding repository breadth.
- Reorder only with a recorded dependency, risk, or reuse reason.
- Read `catalog/projects.yaml` and `.portfolio-control/PORTFOLIO_STATUS.md` before changing this queue.