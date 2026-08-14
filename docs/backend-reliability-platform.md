# Backend Reliability Platform

The transactional core is a five-repository system, not five unrelated pattern demos:

```text
#14 orders --authorize--> #11 payments
   |                         |
   +--durable events--> #16 saga --transitions--> #20 outbox
   |
   +--read model---------------------------------> #19 cache
```

Each repository owns one proof and one database boundary. Cross-repository behavior uses `contracts/backend-reliability-platform.yaml`, the versioned payment API contract, and `contracts/commerce-event-v1.schema.json`.

The traffic and platform edge is another five-repository slice:

```text
client -> #18 gateway -> #12 distributed quota
                    \-> #17 tenant-isolated upstream

#15 holds protocol semantics constant while comparing REST and gRPC.
#13 proves the local-cloud adapter boundary with pinned Kumo and the AWS SDK.
```

The edge repositories share behavior contracts rather than source code. `#18` owns ingress policy and propagation, `#12` owns quota decisions, and `#17` owns tenant data. `#15` and `#13` are evidence laboratories used to decide transport and cloud-adapter behavior; they are not runtime dependencies of every request.

## Evidence Rule

Infrastructure named in a claim must participate in the measured path. In-memory adapters are valid for unit tests and deterministic fault setup, but they cannot support public PostgreSQL, Redis, Kafka, distributed transaction, or durability claims.

## Failure Matrix

| Repository | Required failure | Required proof |
|---|---|---|
| #11 payments | concurrent duplicate command | one payment identity, conflict on changed payload |
| #14 event sourcing | restart and competing sequence | durable replay and optimistic conflict |
| #16 saga | operation and compensation failure | durable final state and uncompensated count |
| #20 outbox | crash after commit and broker outage | zero loss, explicit duplicates/retries/lag |
| #19 cache | invalidation/write workload | hit/latency/throughput plus zero stale cached values |
| #12 rate limiter | concurrent decisions across nodes and Redis outage | one global quota, explicit rejects, fail-closed store errors |
| #18 gateway | unauthorized request, shared quota, broken upstream | auth/reject/error counts plus direct-vs-gateway overhead |
| #17 multi-tenant | concurrent onboarding and cross-tenant access | rollback-safe onboarding and zero leakage |
| #15 protocols | divergent payload or handler behavior | semantic parity plus p50/p95/p99 and throughput by protocol |
| #13 local cloud | unsupported or divergent AWS operation | scoped conformance failures plus latency and throughput |

No result implies universal performance, multi-region safety, or exactly-once external effects. README limits must state what the workload did not test.
