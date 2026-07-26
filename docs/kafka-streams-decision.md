# Kafka Streams Decision Guide

Use this guide after `decision-brain/messaging-matrix.yaml` establishes that Kafka semantics are necessary. Kafka is not a default architecture component and must not be selected for resume padding.

## Decision Sequence

1. State the business invariant that requires asynchronous records.
2. Reject a synchronous call, database transaction, transactional outbox without a broker, and a simpler queue when they satisfy the invariant.
3. Choose a simple consumer or Kafka Streams from the processing semantics, not from library preference.
4. Define keys, partitions, schemas, time, state, failure handling, and restoration before implementation.
5. Define what deterministic tests prove and what requires a real broker.
6. Make correctness gates fail before collecting publishable performance numbers.

## Simple Consumer Or Kafka Streams

| Force | Simple consumer | Kafka Streams |
|---|---|---|
| Per-record side effect | Preferred | Usually unnecessary |
| Manual batching or offset control | Preferred | Usually unnecessary |
| External database owns state | Preferred | Use only if topology state is also required |
| Keyed aggregation or materialized view | Manual and risky | Preferred |
| Stream-stream or stream-table join | Manual and risky | Preferred |
| Event-time window and late data | Manual and risky | Preferred |
| Replay rebuilds derived state | Possible | Preferred |
| Local state with changelog recovery | Not provided | Preferred |
| Application-specific delayed retry workflow | Easier to control | Keep outside stream threads |

Choose a simple consumer when each record is independent and the application primarily performs a command or side effect. Choose Kafka Streams when a topology, keyed state, join, table, window, or deterministic replay is the actual solution.

Reject Kafka Streams when the topology is only `consume -> call service -> produce` and no stateful stream semantic is needed. Reject Kafka entirely when a broker does not solve a stated reliability, replay, ordering, fanout, or stream-processing requirement.

## Required Decision Record

Record every field listed in `decision-brain/kafka-streams-matrix.yaml` in `project.yaml` and `sdd/technical-decision.md`. At minimum, make these decisions reviewable:

- problem and rejected simpler alternatives;
- input, output, retry, and dead-letter topics;
- record key, partition count, ordering scope, and hot-key risk;
- SerDes, schema versioning, compatibility, and tombstones;
- stream, table, global table, join, window, grace, and time semantics;
- state stores, changelogs, retention, restore target, and disk policy;
- at-least-once or exactly-once-v2 processing;
- invalid records, transient failures, retry bounds, quarantine, and replay;
- restart, restoration, rebalance, and availability evidence;
- correctness gates, benchmark workload, metrics, and environment.

## Keys And Repartitioning

The key is an architectural invariant. Derive it from the records that must be ordered, joined, co-located, or aggregated. Kafka ordering is only guaranteed within a partition; state claims must identify which records share a key and why.

A key-changing operation before a keyed join or aggregation can create a repartition topic. Document this explicitly. Repartitioning adds network traffic, storage, latency, internal topics, and restoration work. Do not use it to hide a wrong source key. Verify representative key distribution and define behavior for null keys and hot partitions.

For joins, document co-partitioning requirements, partition-count compatibility, unmatched records, duplicate effects, and whether event time or processing time drives the result.

## SerDes And Schema Evolution

Define key and value SerDes at every public topic boundary. Prefer registry-backed Avro, Protobuf, or JSON Schema when cross-team evolution and compatibility enforcement justify the registry. Explicitly versioned JSON plus contract tests is acceptable for a smaller local-first project.

Test the current reader against at least the previous supported schema. Separate these cases:

- bytes cannot be deserialized;
- schema is syntactically valid but incompatible;
- data violates a domain invariant;
- topology processing fails after validation.

Do not silently skip any category. Preserve source topic, partition, offset, timestamp, key, schema version, correlation identifier, and error classification in quarantine metadata. Treat dead-letter payloads according to their data sensitivity.

For compacted topics and tables, define tombstone behavior. For state stores, changing the serialized value format requires a compatible migration, a versioned store, or an explicit rebuild plan.

## Streams, Tables, Windows, And State

Use a stream for immutable event facts and every-record transformations. Use a table for the latest value per key and changelog semantics. Use a global table only when the reference dataset is small enough to replicate to every instance and that cost is measured.

For every window, define:

- window type and size;
- timestamp extractor and event-time source;
- grace period based on observed lateness;
- retention at least as long as window plus grace;
- suppression or intermediate update behavior;
- expected treatment of late and out-of-order records.

For every state store, define its name, key and value types, persistence, cache behavior, commit interval, retention, changelog, disk sizing, and query ownership. Durable materialized state normally requires a changelog. Rebuilding only from input is valid when source retention covers the complete rebuild horizon and restoration time meets the objective.

## Processing Guarantee

Use at-least-once by default and make downstream business effects idempotent. Test duplicate input, replay, restart, and partial failure.

Select exactly-once-v2 only when atomic Kafka read-process-write behavior materially protects the result and relevant state and outputs remain inside Kafka transactions. Prove abort and restart behavior with a real broker and measure its cost against the same at-least-once workload.

Exactly-once-v2 does not make HTTP calls, external database writes, emails, or other non-Kafka side effects exactly once. Never publish a business-level exactly-once claim from configuration alone.

## Failure Handling

Classify failures before assigning retry behavior. Retry only transient failures, with bounded attempts and elapsed time. Long sleeps, unbounded backoff, and slow remote calls must not block stream threads indefinitely.

If retry topics are used, define how they affect ordering and key affinity. A DLQ or quarantine path must support observable, authorized, idempotent replay. Prove that one poison record cannot stall healthy partitions forever and that replay cannot duplicate a business effect.

For stateful applications, test instance termination, replacement, partition reassignment, and state restoration. Observe restore duration, restored records or bytes, lag, and unavailable time. Choose standby replicas from an explicit recovery objective and measure their resource cost.

## Evidence Boundary

`TopologyTestDriver` is a deterministic topology test tool. It can prove transformations, routing, keys, joins, windows, event-time behavior, and state-store results under controlled inputs.

It does not prove:

- broker networking, persistence, retention, or outage recovery;
- partition assignment, group coordination, or rebalancing;
- broker-backed changelog restoration;
- transaction coordinator behavior;
- production serialization infrastructure;
- end-to-end throughput, latency, scalability, or availability.

Use Testcontainers with Kafka or Redpanda for broker integration tests. Use a reproducible Docker Compose or equivalent environment for the published benchmark. Claims about broker throughput, replay, rebalance, restoration, or exactly-once-v2 require real-broker evidence.

## Benchmark Acceptance

Validate output correctness before performance. The benchmark must fail if it loses records, emits unexpected records, violates aggregate results, or creates duplicate business effects.

Run a representative multi-partition workload with warmup outside measured samples and at least five measured repetitions. Record raw samples, workload seed, schemas, partition count, guarantee, JVM settings, CPU and memory limits, commit, dirty flag, and image digest.

Report at least:

- input, output, invalid, and lost record counts;
- duplicate business effects;
- records per second;
- end-to-end p50 and p95 latency;
- consumer lag;
- restore time and unavailable time for stateful or rebalance claims.

Keep `TopologyTestDriver` microbenchmark results separate from real-broker results. Compare alternatives only when workload, topology semantics, partitioning, schemas, processing guarantee, hardware limits, warmup, and measurement windows are identical.

## Rejection Gate

Do not add Kafka or Kafka Streams when the technical decision cannot answer all three questions:

1. Which invariant requires broker or stream semantics?
2. Which simpler valid alternative was rejected, and why?
3. Which real-broker failure scenario will prove the claim?

If any answer is missing, remove Kafka from the design or return the decision to specification.
