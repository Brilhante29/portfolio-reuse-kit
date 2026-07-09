import argparse
import json
import platform
import statistics
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


def percentile(values, pct):
    if not values:
        return 0.0
    ordered = sorted(values)
    index = (len(ordered) - 1) * (pct / 100)
    lower = int(index)
    upper = min(lower + 1, len(ordered) - 1)
    weight = index - lower
    return ordered[lower] * (1 - weight) + ordered[upper] * weight


def run_command(command):
    start = time.perf_counter()
    completed = subprocess.run(command, text=True, capture_output=True)
    elapsed_ms = (time.perf_counter() - start) * 1000
    return completed.returncode, elapsed_ms, completed.stdout, completed.stderr


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", required=True)
    parser.add_argument("--metric", default="latency_ms")
    parser.add_argument("--unit", default="ms")
    parser.add_argument("--repeat", type=int, default=5)
    parser.add_argument("--warmup", type=int, default=1)
    parser.add_argument("--out-dir", default="benchmarks/results")
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()

    command = args.command
    if command and command[0] == "--":
        command = command[1:]
    if not command:
        raise SystemExit("missing benchmark command after --")

    for _ in range(args.warmup):
        code, _, _, stderr = run_command(command)
        if code != 0:
            raise SystemExit(stderr)

    samples = []
    last_stdout = ""
    for _ in range(args.repeat):
        code, elapsed_ms, stdout, stderr = run_command(command)
        if code != 0:
            raise SystemExit(stderr)
        samples.append(elapsed_ms)
        last_stdout = stdout

    summary = {
        "mean": statistics.fmean(samples),
        "median": statistics.median(samples),
        "p95": percentile(samples, 95),
        "min": min(samples),
        "max": max(samples),
    }

    result = {
        "project": args.project,
        "metric": args.metric,
        "value": summary["p95"],
        "unit": args.unit,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "command": " ".join(command),
        "repeat": args.repeat,
        "samples": samples,
        "summary": summary,
        "environment": {
            "os": platform.platform(),
            "python": platform.python_version(),
            "processor": platform.processor(),
        },
        "stdout_tail": last_stdout[-1000:],
    }

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    safe_time = result["timestamp"].replace(":", "").replace("+", "Z")
    out_file = out_dir / f"{args.project}-{args.metric}-{safe_time}.json"
    out_file.write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))
    print(f"\nWrote {out_file}", file=sys.stderr)


if __name__ == "__main__":
    main()
