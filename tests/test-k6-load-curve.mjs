import assert from "node:assert/strict";
import { aggregateLoadCurve, median } from "../harness/k6/load-curve.mjs";

assert.equal(median([12, 10]), 11);
const runs = [
  { repeat: 1, curve: [{ vus: 1, requests: 100, p95_ms: 2, error_rate: 0 }, { vus: 20, requests: 200, p95_ms: 10, error_rate: 0 }] },
  { repeat: 2, curve: [{ vus: 1, requests: 100, p95_ms: 4, error_rate: 0 }, { vus: 20, requests: 200, p95_ms: 12, error_rate: 0 }] }
];
const result = aggregateLoadCurve(runs, 3);
assert.equal(result.value, 11);
assert.deepEqual(result.samples, [10, 12]);
assert.equal(result.curve[1].requests_per_second, 400 / 6);
assert.equal(result.summary.total_requests, 600);
assert.throws(
  () => aggregateLoadCurve([{ repeat: 1, curve: runs[0].curve }], 3),
  /at least two repetitions/
);
console.log("k6 load curve tests passed");
