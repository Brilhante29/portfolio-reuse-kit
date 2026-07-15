# Cloud Local-First

Cloud-backed portfolio projects must run locally first.

For AWS-compatible services, the default local provider is [sivchari/kumo](https://github.com/sivchari/kumo). Real AWS remains pluggable through the same SDK-facing adapter boundary.

## Rule

Use Kumo when a project needs AWS-like behavior without a cloud account. Keep the provider switch at composition/configuration boundaries:

```txt
application use case
  -> ObjectStorage / Queue / KeyValue ports
  -> AWS SDK adapter
  -> local: Kumo endpoint override
  -> real: AWS default endpoint and credentials
```

The domain and application layers must not import AWS SDK packages.

## Reviewed Provider Snapshot

The kit's reviewed snapshot on 2026-07-15 is:

- Kumo release: `v0.25.3`
- Container tag: `0.25.3`
- OCI version label: `0.25.3`
- Manifest digest: `sha256:7ea090ae0b6d1d34615e8b7bd04a2f1cd864ec640a6826a91e90f40e975e196b`

The release tag includes a leading `v`, while Kumo's GoReleaser image tag does not. Pin both the readable image tag and immutable digest:

```powershell
docker run -p 4566:4566 ghcr.io/sivchari/kumo:0.25.3@sha256:7ea090ae0b6d1d34615e8b7bd04a2f1cd864ec640a6826a91e90f40e975e196b
```

Do not use a mutable `:latest` reference in committed Dockerfiles, Compose files, CI, README commands, or benchmark evidence. It is acceptable only during an explicit dependency-update investigation.

## Required Project Artifacts

- A one-command Docker path with the Kumo image pinned by tag and digest.
- Static local credentials such as `test/test`; no secret on the default path.
- Narrow ports for each capability and SDK calls contained in adapters.
- `CLOUD_PROVIDER=kumo|aws` or an equivalent explicit switch.
- A destructive-action guard before real AWS can be selected.
- Scoped parity/conformance checks for every claimed service behavior.
- Provider release, digest, SDK version, and region in benchmark JSON.
- Numeric compatibility diagnostics when an SDK warning is intentionally handled.
- Documented unsupported Kumo or real-cloud behaviors.

## Persistent Local Path

```powershell
docker run -p 4566:4566 -e KUMO_DATA_DIR=/data -v kumo-data:/data ghcr.io/sivchari/kumo:0.25.3@sha256:7ea090ae0b6d1d34615e8b7bd04a2f1cd864ec640a6826a91e90f40e975e196b
```

## Configuration Pattern

```txt
CLOUD_PROVIDER=kumo|aws
CLOUD_ENDPOINT=http://localhost:4566
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
ALLOW_REAL_AWS=false
RUN_ID=explicit-unique-id-for-real-cloud
```

Local mode supplies non-secret credentials and an endpoint override. Real mode uses the SDK's default endpoint and credential chain only after an explicit opt-in.

## Conformance Scope

Do not claim full AWS conformance from a small suite. Name the exact services and operations measured, fail on functional mismatches, and keep optional protocol/SDK warnings visible as numeric diagnostics. A local emulator is a development substitute, not proof of IAM, quotas, multi-region behavior, managed durability, or production failure semantics.

## Dependency Update Procedure

1. Review the official Kumo release and `.goreleaser.yml`.
2. Pull the version tag without the release's leading `v`.
3. Inspect `org.opencontainers.image.version` and the repository digest.
4. Run the project's parity suite and benchmark twice.
5. Update the kit snapshot, project lock, benchmark JSON, and reuse review together.
