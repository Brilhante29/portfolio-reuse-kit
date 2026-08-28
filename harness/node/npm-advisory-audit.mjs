import { readFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import { pathToFileURL } from 'node:url';

const defaultEndpoint = 'https://registry.npmjs.org/-/npm/v1/security/advisories/bulk';
const severityOrder = ['info', 'low', 'moderate', 'high', 'critical'];

export function buildAuditPayload(lockfile) {
  if (!isRecord(lockfile) || !isRecord(lockfile.packages)) {
    throw new Error('package-lock.json must contain a packages object');
  }

  const versionsByPackage = new Map();
  for (const [packagePath, value] of Object.entries(lockfile.packages)) {
    if (!packagePath || !isRecord(value) || typeof value.version !== 'string') continue;

    const marker = 'node_modules/';
    const markerIndex = packagePath.lastIndexOf(marker);
    if (markerIndex < 0) continue;

    const packageName = packagePath.slice(markerIndex + marker.length);
    if (!packageName || packageName.includes('/node_modules/')) {
      throw new Error(`cannot derive package name from lockfile path: ${packagePath}`);
    }

    const versions = versionsByPackage.get(packageName) ?? new Set();
    versions.add(value.version);
    versionsByPackage.set(packageName, versions);
  }

  return Object.fromEntries(
    [...versionsByPackage.entries()]
      .sort(([left], [right]) => left.localeCompare(right))
      .map(([name, versions]) => [name, [...versions].sort()]),
  );
}

export function decodeAuditBody(body) {
  const encoded = Buffer.from(body);
  const decoded =
    encoded.length >= 2 && encoded[0] === 0x1f && encoded[1] === 0x8b
      ? gunzipSync(encoded)
      : encoded;

  if (decoded.length === 0) throw new Error('npm audit endpoint returned an empty body');
  return JSON.parse(decoded.toString('utf8'));
}

export function findBlockingAdvisories(response, minimumSeverity) {
  if (!isRecord(response)) {
    throw new Error('npm audit endpoint returned a non-object response');
  }

  const threshold = severityIndex(minimumSeverity);
  const blocking = [];
  for (const [packageName, value] of Object.entries(response)) {
    if (!Array.isArray(value)) {
      throw new Error(`npm audit advisories for ${packageName} must be an array`);
    }

    for (const candidate of value) {
      if (!isRecord(candidate) || typeof candidate.severity !== 'string') {
        throw new Error('npm audit endpoint returned a malformed advisory');
      }

      const severity = parseSeverity(candidate.severity);
      if (severityIndex(severity) < threshold) continue;
      blocking.push({
        packageName,
        id: scalarString(candidate.id, 'unknown'),
        severity,
        title: scalarString(candidate.title, 'untitled advisory'),
        url: scalarString(candidate.url, ''),
      });
    }
  }

  return blocking.sort(
    (left, right) =>
      severityIndex(right.severity) - severityIndex(left.severity) ||
      left.packageName.localeCompare(right.packageName),
  );
}

export async function fetchAudit(
  payload,
  { attempts = 3, endpoint = defaultEndpoint, fetchImpl = globalThis.fetch, sleep = delay } = {},
) {
  if (!Number.isInteger(attempts) || attempts < 1) {
    throw new Error('audit attempts must be a positive integer');
  }

  let lastError;
  for (let attempt = 1; attempt <= attempts; attempt += 1) {
    try {
      const response = await fetchImpl(endpoint, {
        method: 'POST',
        headers: {
          accept: 'application/json',
          'accept-encoding': 'identity',
          'content-type': 'application/json',
          'npm-in-ci': process.env.CI ? 'true' : 'false',
        },
        body: JSON.stringify(payload),
      });
      const body = new Uint8Array(await response.arrayBuffer());
      if (!response.ok) {
        throw new Error(
          `npm audit endpoint returned HTTP ${response.status}: ${Buffer.from(body).toString('utf8').slice(0, 200)}`,
        );
      }
      return decodeAuditBody(body);
    } catch (error) {
      lastError = error;
      if (attempt < attempts) await sleep(attempt * 1000);
    }
  }

  throw new Error(`npm audit transport failed after ${attempts} attempts: ${errorMessage(lastError)}`);
}

async function main() {
  const minimumSeverity = parseSeverity(
    process.argv.find((argument) => argument.startsWith('--level='))?.slice('--level='.length) ??
      'high',
  );
  const lockfile = JSON.parse(await readFile('package-lock.json', 'utf8'));
  const payload = buildAuditPayload(lockfile);
  const blocking = findBlockingAdvisories(await fetchAudit(payload), minimumSeverity);

  for (const advisory of blocking) {
    console.error(
      `${advisory.severity.toUpperCase()} ${advisory.packageName} ${advisory.id}: ${advisory.title}${advisory.url ? ` (${advisory.url})` : ''}`,
    );
  }
  if (blocking.length > 0) {
    throw new Error(`${blocking.length} advisories meet the ${minimumSeverity} failure threshold`);
  }

  console.log(
    `dependency audit passed: ${Object.keys(payload).length} packages, threshold=${minimumSeverity}`,
  );
}

function parseSeverity(value) {
  severityIndex(value);
  return value;
}

function severityIndex(value) {
  const index = severityOrder.indexOf(value);
  if (index < 0) throw new Error(`unsupported advisory severity: ${value}`);
  return index;
}

function isRecord(value) {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function scalarString(value, fallback) {
  return typeof value === 'string' || typeof value === 'number' ? String(value) : fallback;
}

function errorMessage(error) {
  return error instanceof Error ? error.message : String(error);
}

function delay(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds));
}

const entrypoint = process.argv[1];
if (entrypoint && pathToFileURL(entrypoint).href === import.meta.url) {
  main().catch((error) => {
    console.error(errorMessage(error));
    process.exitCode = 1;
  });
}
