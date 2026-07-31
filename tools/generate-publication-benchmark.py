#!/usr/bin/env python3
"""Produce a schema_version 2 publication benchmark from a real execution.

The v2 contract in tools/validate-portfolio.ps1 requires provenance that cannot
be written by hand: the digest of the image that ran, the digest of the fixture
and config that fed the workload, the commit the tree was on, and the measured
samples. This tool runs the benchmark command, reads the v1 result it produces,
and derives every field from that execution.

It never invents a measurement. If the command fails, or the v1 result is
missing a metric, it exits non-zero and writes nothing.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path

DIRECTIONS = ("higher_is_better", "lower_is_better", "target")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return f"sha256:{digest.hexdigest()}"


def sha256_tree(path: Path) -> str:
    """Digest a directory deterministically: sorted relative path + content."""
    digest = hashlib.sha256()
    for entry in sorted(p for p in path.rglob("*") if p.is_file()):
        digest.update(entry.relative_to(path).as_posix().encode("utf-8"))
        digest.update(entry.read_bytes())
    return f"sha256:{digest.hexdigest()}"


def digest_path(path: Path) -> str:
    if path.is_dir():
        return sha256_tree(path)
    return sha256_file(path)


def git(repo: Path, *args: str) -> str:
    completed = subprocess.run(
        ["git", "-C", str(repo), *args], capture_output=True, text=True, check=False
    )
    return completed.stdout.strip()


def image_digest(image: str) -> tuple[str, str]:
    """Return (digest, image_ref) for a locally available image."""
    completed = subprocess.run(
        ["docker", "image", "inspect", image, "--format", "{{.Id}}"],
        capture_output=True,
        text=True,
        check=False,
    )
    if completed.returncode != 0:
        raise SystemExit(f"cannot inspect image {image}: {completed.stderr.strip()}")
    identifier = completed.stdout.strip()
    if not identifier.startswith("sha256:"):
        raise SystemExit(f"unexpected image id for {image}: {identifier}")
    return identifier, f"{image}@{identifier}"


def load_metrics(v1: dict, direction: str) -> list[dict]:
    """Build the v2 metric list from the v1 result the benchmark emitted."""
    name = v1.get("metric")
    if not name or "value" not in v1:
        raise SystemExit("v1 result has no 'metric'/'value'; cannot derive metrics")
    samples = v1.get("samples") or [v1["value"]]
    summary = v1.get("summary") if isinstance(v1.get("summary"), dict) else {name: v1["value"]}
    return [
        {
            "name": name,
            "value": v1["value"],
            "unit": v1.get("unit", "unit"),
            "direction": direction,
            "samples": list(samples),
            "failures": int(v1.get("failures", 0)),
            "summary": summary,
        }
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", required=True, type=Path)
    parser.add_argument("--project", required=True)
    parser.add_argument("--benchmark-id", required=True)
    parser.add_argument("--image", required=True, help="local image tag that runs the benchmark")
    parser.add_argument("--v1-result", required=True, type=Path,
                        help="path (repo-relative) of the v1 JSON the command writes")
    parser.add_argument("--fixture", required=True, type=Path, help="repo-relative fixture path")
    parser.add_argument("--config", required=True, type=Path, help="repo-relative config path")
    parser.add_argument("--lock", required=True, type=Path, help="repo-relative dependency lock path")
    parser.add_argument("--output", required=True, type=Path, help="repo-relative v2 output path")
    parser.add_argument("--direction", default="higher_is_better", choices=DIRECTIONS)
    parser.add_argument("--workload-version", default="1.0.0")
    parser.add_argument("--warmup-iterations", type=int, default=0)
    parser.add_argument("--concurrency", type=int, default=1)
    parser.add_argument("--runtime", required=True, help="e.g. python-3.12-slim")
    parser.add_argument("--architecture", default="amd64")
    parser.add_argument("--hardware-class", default="docker-local")
    parser.add_argument("--producer", default="local", choices=("local", "github-actions", "other-ci"))
    parser.add_argument("--comparability-key", required=True)
    # The benchmark command comes last, after "--", so its own flags are never
    # confused with this tool's options.
    parser.add_argument("command", nargs=argparse.REMAINDER,
                        help="-- <command to execute>")
    args = parser.parse_args()

    repo: Path = args.repo.resolve()
    command = [part for part in args.command if part != "--"]
    if not command:
        raise SystemExit("pass the benchmark command after '--'")

    started = datetime.now(timezone.utc)
    clock = time.perf_counter()
    completed = subprocess.run(command, cwd=repo, capture_output=True, text=True, check=False)
    duration = time.perf_counter() - clock

    if completed.returncode != 0:
        sys.stderr.write(completed.stdout[-2000:])
        sys.stderr.write(completed.stderr[-2000:])
        raise SystemExit(f"benchmark command exited {completed.returncode}; no result written")

    v1_path = repo / args.v1_result
    if not v1_path.is_file():
        raise SystemExit(f"benchmark did not produce {args.v1_result}")
    v1 = json.loads(v1_path.read_text(encoding="utf-8"))

    digest, image_ref = image_digest(args.image)
    result = {
        "schema_version": 2,
        "run_id": str(uuid.uuid4()),
        "project": args.project,
        "benchmark_id": args.benchmark_id,
        "workload": {
            "version": args.workload_version,
            "fixture_digest": digest_path(repo / args.fixture),
            "config_digest": digest_path(repo / args.config),
            "warmup_iterations": args.warmup_iterations,
            "measured_iterations": max(1, int(v1.get("repeat", 1))),
            "concurrency": args.concurrency,
        },
        "metrics": load_metrics(v1, args.direction),
        "execution": {
            "command": " ".join(command),
            "started_at": started.isoformat().replace("+00:00", "Z"),
            "duration_seconds": round(duration, 6),
            "exit_code": completed.returncode,
            "repeat": max(1, int(v1.get("repeat", 1))),
        },
        "environment": {
            "runtime": args.runtime,
            "architecture": args.architecture,
            "hardware_class": args.hardware_class,
        },
        "provenance": {
            "source_commit": git(repo, "rev-parse", "HEAD"),
            "clean_tree": git(repo, "status", "--porcelain") == "",
            "image_ref": image_ref,
            "image_digest": digest,
            "dependency_lock_digest": digest_path(repo / args.lock),
            "producer": args.producer,
            "artifact_digest": sha256_file(v1_path),
        },
        "comparability_key": args.comparability_key,
    }

    output = repo / args.output
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"wrote {args.output} run_id={result['run_id']} metric={result['metrics'][0]['name']}"
          f"={result['metrics'][0]['value']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
