# API Style Decision

Every API project must choose its interface intentionally.

The default for public and simple backend APIs is REST/HTTP with OpenAPI. GraphQL is selected when the client genuinely benefits from flexible field selection, nested graph traversal, schema-driven workflows, or BFF aggregation. gRPC is selected for service-to-service typed contracts and protocol benchmarks. WebSocket/SSE are selected only for real-time behavior.

## Decision Table

| Problem | Prefer | Reason |
|---|---|---|
| CRUD, commands, simple public API | REST/HTTP | Simple operations, status codes, OpenAPI, cache-friendly, easy to benchmark. |
| Client needs different nested data shapes | GraphQL | Client asks for exactly the graph shape it needs. |
| BFF aggregating multiple backing services | GraphQL | One schema can hide multiple sources behind resolvers. |
| Service-to-service typed contract | gRPC | Protobuf contracts, low overhead, streaming RPC. |
| Bidirectional live interaction | WebSocket | Full duplex real-time communication. |
| Server-only live updates | SSE | Simpler server-to-client stream over HTTP. |
| Harness/generator/local tool | CLI | Command surface and output schema are the product. |

## GraphQL Requirements

GraphQL is never selected just because it looks impressive. A GraphQL repo must include:

- schema ownership decision: code-first or schema-first
- resolver-to-use-case mapping
- N+1 prevention plan, usually batching/DataLoader
- query depth or complexity limit
- auth rule for sensitive fields
- benchmark comparing payload/latency against the relevant REST shape when useful

## REST Requirements

REST projects should include:

- OpenAPI when the API is public or integration-facing
- status code policy
- request/response DTO validation
- endpoint p95/p99 benchmark

## Rule

Do not expose both REST and GraphQL for the same use case unless the project explicitly proves the tradeoff.
