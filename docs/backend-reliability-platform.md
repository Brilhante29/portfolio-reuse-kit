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

No result implies universal performance, multi-region safety, or exactly-once external effects. README limits must state what the workload did not test.
