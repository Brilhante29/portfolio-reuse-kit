# Cloud Local-First

Cloud-backed portfolio projects must run locally first.

For AWS-like services, the default local provider is [sivchari/kumo](https://github.com/sivchari/kumo). Kumo is a lightweight AWS service emulator written in Go, runs as a single Docker container on port `4566`, supports optional persistence through `KUMO_DATA_DIR`, and exposes many AWS-like services including S3, SQS, DynamoDB, Lambda, API Gateway, SNS, EventBridge, Kinesis, MSK, Secrets Manager, CloudWatch, and more.

## Rule

Use Kumo as the local-first cloud adapter whenever the project touches AWS-like cloud capabilities.

Real cloud must be pluggable behind the same application ports:

```txt
application use case
  -> CloudStoragePort / QueuePort / SecretStorePort / EventBusPort
  -> local adapter: Kumo endpoint http://localhost:4566
  -> real adapter: AWS default endpoint and real credentials
```

## Required Project Artifacts

- `docker-compose.yml` or documented `docker run` command for Kumo.
- Local endpoint configuration: `http://localhost:4566`.
- Local credentials: static `test/test` or equivalent non-secret values.
- Adapter interface for each cloud capability.
- Kumo adapter for local/CI path.
- Real cloud adapter or documented extension point.
- Parity test for core behavior.
- README section explaining local-first and real-cloud switch.

## Default Docker

```powershell
docker run -p 4566:4566 ghcr.io/sivchari/kumo:latest
```

With persistence:

```powershell
docker run -p 4566:4566 -e KUMO_DATA_DIR=/data -v kumo-data:/data ghcr.io/sivchari/kumo:latest
```

## Config Pattern

```txt
CLOUD_PROVIDER=kumo|aws
CLOUD_ENDPOINT=http://localhost:4566
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
```

## Design Rule

Do not put cloud SDK calls in domain entities or use cases. Cloud SDK usage belongs in adapters only.
