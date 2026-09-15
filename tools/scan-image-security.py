"""Build and scan a current Docker image without rewriting benchmark evidence."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess


def summarize(report: dict, expected_image_id: str) -> dict:
    if report.get("SchemaVersion") != 2 or report.get("ArtifactType") != "container_image":
        raise ValueError("Expected a Trivy schema-2 container image report")
    if report.get("Metadata", {}).get("ImageID") != expected_image_id:
        raise ValueError("Scanned image ID does not match the freshly built image")
    results = report.get("Results")
    if not isinstance(results, list) or not results:
        raise ValueError("Missing scan results; an empty report is not a clean scan")
    findings = []
    for result in results:
        vulnerabilities = result.get("Vulnerabilities") or []
        if not isinstance(vulnerabilities, list):
            raise ValueError("Invalid vulnerabilities collection")
        for item in vulnerabilities:
            if item.get("Severity") not in {"HIGH", "CRITICAL"}:
                continue
            for field in ("VulnerabilityID", "PkgName", "InstalledVersion"):
                if not item.get(field):
                    raise ValueError(f"Missing vulnerability field: {field}")
            findings.append({
                "target": result.get("Target"),
                "id": item["VulnerabilityID"],
                "package": item["PkgName"],
                "installed_version": item["InstalledVersion"],
                "fixed_version": item.get("FixedVersion", ""),
                "severity": item["Severity"],
            })
    fixable = sum(bool(item["fixed_version"].strip()) for item in findings)
    status = "fail" if fixable else "review_required" if findings else "pass"
    return {
        "schema_version": 1,
        "status": status,
        "policy": "fixable-high-critical-block; unpatched-high-critical-require-review",
        "image_id": expected_image_id,
        "severe_count": len(findings),
        "fixable_severe_count": fixable,
        "unpatched_severe_count": len(findings) - fixable,
        "findings": findings,
    }


def capture(*command: str, cwd: Path | None = None) -> str:
    return subprocess.check_output(command, cwd=cwd, text=True, encoding="utf-8").strip()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, required=True)
    parser.add_argument("--image", required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--trivy", default="trivy")
    parser.add_argument("--cache-dir", type=Path)
    parser.add_argument("--skip-db-update", action="store_true",
                        help="Reuse a DB already refreshed by this audit batch")
    args = parser.parse_args()
    repo = args.repo.resolve(strict=True)
    output = args.out.resolve()
    if output == repo or repo in output.parents:
        parser.error("Write scan artifacts outside the repository to preserve its worktree")
    output.mkdir(parents=True, exist_ok=True)
    source_commit = capture("git", "rev-parse", "HEAD", cwd=repo)
    worktree = capture("git", "status", "--porcelain", "--untracked-files=no", cwd=repo)
    # Always rebuild: an old :sec tag is not evidence for current source.
    subprocess.run(["docker", "build", "--pull", "-t", args.image, str(repo)], check=True)
    image_id = capture("docker", "image", "inspect", "--format", "{{.Id}}", args.image)
    report_path = output / "container-scan.json"
    command = [args.trivy, "image", "--cache-backend", "memory", "--scanners", "vuln", "--severity", "HIGH,CRITICAL",
               "--format", "json", "--output", str(report_path), "--timeout", "10m"]
    if args.cache_dir:
        command += ["--cache-dir", str(args.cache_dir.resolve())]
    if args.skip_db_update:
        command.append("--skip-db-update")
    command.append(image_id)
    subprocess.run(command, check=True)
    report = json.loads(report_path.read_text(encoding="utf-8-sig"))
    summary = summarize(report, image_id)
    summary.update({
        "repository": repo.name,
        "source_commit": source_commit,
        "tracked_worktree_clean": not bool(worktree),
        "image_ref": args.image,
        "scanner": capture(args.trivy, "--version"),
        "verified_at": datetime.now(timezone.utc).isoformat(),
        "scope": "OS and application vulnerabilities reported by Trivy; not a penetration test",
        "historical_benchmarks_modified": False,
    })
    (output / "security-summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: summary[key] for key in
                      ("repository", "status", "severe_count", "fixable_severe_count")}))
    return {"pass": 0, "fail": 1, "review_required": 2}[summary["status"]]


if __name__ == "__main__":
    raise SystemExit(main())
