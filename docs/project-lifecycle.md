# Project Lifecycle

Every portfolio project moves through the same lifecycle.

## 1. Registered

The project exists in `catalog/projects.yaml` with:

- id
- name
- domain
- stack
- claim
- benchmark target
- reuse references

## 2. Scaffolded

Generated with `tools/new-project.ps1`.

Required state:

- `project.yaml` exists
- README marks `Status: scaffold`
- SDD files exist
- skills are installed
- Git is initialized when requested

## 3. Specified

Before implementation, fill:

- `project.yaml`
- `sdd/spec.md`
- `sdd/benchmark-plan.md`
- ADRs for material decisions

No major implementation should start before the metric and command are known.

## 4. Implemented

The project has the smallest useful version of the claim.

Required state:

- default path runs locally
- Docker path exists
- tests or smoke checks exist
- no paid secret required for demo

## 5. Benchmarked

The project produces evidence.

Required state:

- benchmark command documented
- benchmark writes JSON under `benchmarks/results/`
- JSON matches `contracts/benchmark-result.schema.json`
- README reports the headline number

## 6. Published

The project is ready to be public.

Required state:

- README first screen is strong
- `REFERENCES.md` is honest
- validation passes
- GitHub remote exists
- push completed

## Status Vocabulary

Use only these status values in `project.yaml`:

- `scaffold`
- `implemented`
- `benchmarked`
- `published`

A project should not be pinned or promoted before `benchmarked`.