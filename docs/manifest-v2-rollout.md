# Manifest v2 rollout

The project manifest schema supports two governance levels so the reuse kit can evolve without breaking every repository in one sync.

- Missing manifest_version or manifest_version 1 preserves legacy compatibility.
- manifest_version 2 enables strict stack, SOLID, problem-force, evidence, JVM, and Kafka consistency gates.
- New repositories start at v2.
- Existing repositories move to v2 only after their decisions and evidence are real. Versioning is not an allowlist and does not turn an invalid legacy manifest into a valid one.

## Audit

Run:

~~~powershell
python tools/audit-manifest-rollout.py <portfolio-root>
~~~

The report separates three facts:

- compatible: valid under the version currently declared.
- v2_ready: valid after forcing manifest_version 2.
- v2_pending: requires an explicit migration before the version can change.

Use --json for machine-readable coordination and --strict when current-version invalidity must fail CI.

## Migration order

1. Repair existing legacy-schema failures first.
2. Record problem forces, rejected alternatives, and all five SOLID responsibilities.
3. For JVM projects, align project.yaml, Gradle Wrapper, Kotlin DSL, toolchains, Docker, and CI.
4. For Kafka projects, record topics, keys, SerDes, topology semantics, state/changelog, failure handling, rebalance, and both driver and broker evidence.
5. Set manifest_version to 2.
6. Run project validation and retain the resulting benchmark or CI evidence.

Do not add placeholder decisions merely to satisfy the schema. A project that cannot justify a v2 field remains on the migration backlog.
