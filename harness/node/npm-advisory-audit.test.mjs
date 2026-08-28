import assert from 'node:assert/strict';
import { gzipSync } from 'node:zlib';
import test from 'node:test';

import {
  buildAuditPayload,
  decodeAuditBody,
  fetchAudit,
  findBlockingAdvisories,
} from './npm-advisory-audit.mjs';

test('builds a sorted payload from lockfile package paths', () => {
  const payload = buildAuditPayload({
    packages: {
      '': { name: 'demo' },
      'node_modules/zod': { version: '4.0.2' },
      'node_modules/@scope/pkg': { version: '2.0.0' },
      'node_modules/other/node_modules/zod': { version: '3.25.0' },
    },
  });

  assert.deepEqual(payload, {
    '@scope/pkg': ['2.0.0'],
    zod: ['3.25.0', '4.0.2'],
  });
});

test('decodes identity and gzip advisory bodies', () => {
  const body = Buffer.from('{"pkg":[]}');
  assert.deepEqual(decodeAuditBody(body), { pkg: [] });
  assert.deepEqual(decodeAuditBody(gzipSync(body)), { pkg: [] });
});

test('filters and sorts advisories at the configured severity', () => {
  const blocking = findBlockingAdvisories(
    {
      alpha: [{ id: 1, severity: 'high', title: 'high issue' }],
      beta: [{ id: 2, severity: 'moderate', title: 'moderate issue' }],
      gamma: [{ id: 3, severity: 'critical', title: 'critical issue' }],
    },
    'high',
  );

  assert.deepEqual(
    blocking.map(({ packageName, severity }) => ({ packageName, severity })),
    [
      { packageName: 'gamma', severity: 'critical' },
      { packageName: 'alpha', severity: 'high' },
    ],
  );
});

test('rejects malformed advisory responses', () => {
  assert.throws(() => findBlockingAdvisories({ pkg: {} }, 'high'), /must be an array/);
  assert.throws(() => decodeAuditBody(Buffer.alloc(0)), /empty body/);
});

test('bounds retries and reports transport failure separately', async () => {
  let calls = 0;
  const fetchImpl = async () => {
    calls += 1;
    return {
      ok: false,
      status: 503,
      arrayBuffer: async () => Uint8Array.from(Buffer.from('unavailable')).buffer,
    };
  };

  await assert.rejects(
    fetchAudit({}, { attempts: 2, fetchImpl, sleep: async () => {} }),
    /transport failed after 2 attempts/,
  );
  assert.equal(calls, 2);
});
