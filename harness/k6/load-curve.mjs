export function median(values) {
  if (!Array.isArray(values) || values.length === 0) {
    throw new Error("median requires at least one sample");
  }
  const sorted = [...values].sort((left, right) => left - right);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2 === 1
    ? sorted[middle]
    : (sorted[middle - 1] + sorted[middle]) / 2;
}

export function aggregateLoadCurve(runs, windowSeconds) {
  if (!Array.isArray(runs) || runs.length < 2) {
    throw new Error("load curve requires at least two repetitions");
  }
  if (!Number.isFinite(windowSeconds) || windowSeconds <= 0) {
    throw new Error("windowSeconds must be positive");
  }

  const levels = runs[0].curve.map((point) => point.vus);
  if (new Set(levels).size !== levels.length || levels.some((level) => level < 1)) {
    throw new Error("VU levels must be unique positive integers");
  }
  const curve = levels.map((vus) => {
    const points = runs.map((run) => {
      const point = run.curve.find((candidate) => candidate.vus === vus);
      if (!point || point.requests < 1 || point.p95_ms <= 0 || point.error_rate !== 0) {
        throw new Error(`invalid run point for ${vus} VUs`);
      }
      return point;
    });
    const requests = points.reduce((total, point) => total + point.requests, 0);
    const p95Samples = points.map((point) => point.p95_ms);
    return {
      vus,
      requests,
      requests_per_second: requests / (windowSeconds * runs.length),
      p95_ms: median(p95Samples),
      p95_samples_ms: p95Samples,
      error_rate: 0
    };
  });
  const maxVus = Math.max(...levels);
  const samples = runs.map(
    (run) => run.curve.find((point) => point.vus === maxVus).p95_ms
  );
  return {
    value: median(samples),
    samples,
    curve,
    summary: {
      levels: levels.length,
      repeats: runs.length,
      max_vus: maxVus,
      total_requests: curve.reduce((total, point) => total + point.requests, 0),
      error_rate: 0
    }
  };
}
