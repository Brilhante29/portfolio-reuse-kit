# Repository Standard

This is the minimum bar for each portfolio repository generated or maintained through this kit.

## 1. Manifest

Every project must have `project.yaml`.

It captures:

- id and name
- status
- claim
- stack
- reused kit components
- primary benchmark
- release criteria

The manifest should match `contracts/project.schema.json`. It must include `decision_brain` for stack, messaging, database/runtime, library policy, and rejected options.

## 2. First Screen

The README must open with:

```md
# #<id> <project-name>

**Status:** <scaffold|implemented|benchmarked|published>

**Proves:** <one sentence claim>

**Benchmark:** `<metric> = <value> <unit>` on `<date>`.
```

If the project is only scaffolded, keep `Status: scaffold` and do not present it as finished.

## 3. Docker Path

Every completed repo needs a clean path:

```bash
docker build -t <project-name> .
docker run --rm <project-name>
```

If a service needs dependencies, Docker Compose is acceptable, but the README must still document the default command path.

## 4. Benchmark Contract

A valid benchmark has:

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

Schema:

```txt
contracts/benchmark-result.schema.json for local compatibility
contracts/benchmark-result-v2.schema.json for publication provenance and comparability
```

## 5. SDD Before Code

Each repo starts with:

- `sdd/spec.md`
- `sdd/benchmark-plan.md`

Add ADRs when choosing architecture, storage, model, protocol, benchmark methodology, or major dependency.

## 6. Clean Reuse

Each repo must include `REFERENCES.md` with:

| Reference | License | Used for | Copied code? |
|---|---|---|---|

Good reuse:

- library dependency
- architecture reference
- technical decision reference
- stack/messaging/library decision reference
- benchmark idea
- API contract reference

Bad reuse:

- fork and rename
- copied internals without attribution
- AGPL code copied into a served project without understanding obligations

## 7. Done Means Measured

A repo is done only when:

- language-specific quality gates match detected source files: Python runs compile/tests, Go modules run gofmt/tests/vet, and Gradle projects require the wrapper and run `gradle check`
- Gradle repositories commit `gradlew`, `gradlew.bat`, and `gradle/wrapper/*` so Linux, macOS, and Windows use the same version
- generated caches and outputs such as `.gradle/`, `node_modules/`, `.venv/`, `.terraform/`, root `target/`, root `build/`, `dist/`, `.next/`, and coverage are never tracked
- Docker path works
- tests or smoke checks pass
- benchmark writes JSON
- README reports a real number
- references are documented
- no secret is needed for the default demo
