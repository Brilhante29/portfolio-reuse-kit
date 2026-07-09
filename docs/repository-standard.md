# Repository Standard

This is the minimum bar for each portfolio repository.

## 1. First Screen

The README must open with:

```md
# #<id> <project-name>

**Proves:** <one sentence claim>

**Benchmark:** `<metric> = <value> <unit>` on `<date>`.
```

If the project is only scaffolded, mark it clearly as `Status: scaffold` and do not pin or promote it.

## 2. Docker Path

Every completed repo needs a clean path:

```bash
docker build -t <project-name> .
docker run --rm <project-name>
```

If a service needs multiple dependencies, use Docker Compose but still document the one command that starts the default path.

## 3. Benchmark Contract

A benchmark is valid only when it has:

- command
- fixture or dataset description
- deterministic seed when applicable
- machine-readable JSON result
- environment metadata
- README table with the headline number

Output path:

```txt
benchmarks/results/*.json
```

## 4. SDD Before Code

Each repo starts with:

- `sdd/spec.md`
- `sdd/benchmark-plan.md`

Add ADRs when choosing architecture, storage, model, protocol, benchmark methodology, or a major dependency.

## 5. Clean Reuse

Each repo must include `REFERENCES.md` with:

| Reference | License | Used for | Copied code? |
|---|---|---|---|

Good reuse:

- library dependency
- architecture reference
- benchmark idea
- API contract reference

Bad reuse:

- fork and rename
- copied internals without attribution
- AGPL code copied into a served project without understanding obligations

## 6. Done Means Measured

A repo is done only when:

- Docker path works
- tests or smoke checks pass
- benchmark writes JSON
- README reports a real number
- references are documented
- no secret is needed for the default demo