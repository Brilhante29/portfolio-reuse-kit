from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SPEC_PATH = ROOT / "benchmarks" / "publication-spec.json"
VENDORED_SCHEMA_PATH = ROOT / ".portfolio" / "contracts" / "benchmark-result-v2.schema.json"
ROOT_SCHEMA_PATH = ROOT / "contracts" / "benchmark-result-v2.schema.json"
SCHEMA_PATH = VENDORED_SCHEMA_PATH if VENDORED_SCHEMA_PATH.is_file() else ROOT_SCHEMA_PATH
PRODUCER_PATH = ROOT / "tools" / "generate-publication-benchmark.py"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    require(isinstance(value, dict), f"{path.relative_to(ROOT)} must contain an object")
    return value


def relative_path(value: str) -> Path:
    path = (ROOT / value).resolve()
    path.relative_to(ROOT)
    return path


def sha256_file(path: Path) -> str:
    return f"sha256:{hashlib.sha256(path.read_bytes()).hexdigest()}"


def load_producer() -> Any:
    spec = importlib.util.spec_from_file_location("publication_benchmark", PRODUCER_PATH)
    require(spec is not None and spec.loader is not None, "cannot load publication producer")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def git_has_commit(commit: str) -> bool:
    completed = subprocess.run(
        ["git", "-c", f"safe.directory={ROOT}", "-C", str(ROOT), "cat-file", "-e", f"{commit}^{{commit}}"],
        capture_output=True,
        check=False,
    )
    return completed.returncode == 0


def validate_v2_contract(
    result: dict[str, Any],
    spec: dict[str, Any],
    schema: dict[str, Any],
    *,
    require_all_metrics_clean: bool,
) -> tuple[dict[str, Any], dict[str, Any], dict[str, Any]]:
    import jsonschema

    jsonschema.Draft202012Validator(
        schema, format_checker=jsonschema.FormatChecker()
    ).validate(result)
    require(result.get("project") == spec["project"], "unexpected V2 project")
    require(result.get("benchmark_id") == spec["benchmark_id"], "unexpected benchmark id")
    metrics = [item for item in result["metrics"] if item["name"] == spec["primary_metric"]]
    require(len(metrics) == 1, "V2 must contain the primary metric exactly once")
    if require_all_metrics_clean:
        require(all(item["failures"] == 0 for item in result["metrics"]), "V2 contains failures")
    else:
        require(metrics[0]["failures"] == 0, "V2 contains failures")
    require(result["execution"]["exit_code"] == 0, "benchmark execution failed")
    require(result["execution"]["repeat"] == spec["repeat"], "execution repeat mismatch")
    workload = result["workload"]
    require(workload["measured_iterations"] == spec["measured_iterations"], "measured iteration mismatch")
    require(workload["warmup_iterations"] == spec["warmup_iterations"], "warmup mismatch")
    require(workload["concurrency"] == spec["concurrency"], "concurrency mismatch")
    require(result["comparability_key"] == spec["comparability_key"], "comparability key mismatch")
    provenance = result["provenance"]
    require(re.fullmatch(r"sha256:[0-9a-f]{64}", provenance["image_digest"]) is not None, "invalid image digest")
    return metrics[0], workload, provenance


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--require-git", action="store_true")
    args = parser.parse_args()
    spec = read_json(SPEC_PATH)
    mode = spec.get("mode", "v1-derived")
    require(mode in ("v1-derived", "native-v2"), f"unsupported publication mode: {mode}")
    native_v2 = mode == "native-v2"
    v1_path = None if native_v2 else relative_path(spec["v1_path"])
    result_path = relative_path(spec["result_path"]) if native_v2 else None
    v2_path = relative_path(spec["publication_path"] if native_v2 else spec["v2_path"])
    config_path = relative_path(spec["config_path"])
    fixture_path = relative_path(spec["fixture_path"])
    lock_path = relative_path(spec["lock_path"])
    manifest = (ROOT / "project.yaml").read_text(encoding="utf-8")
    published = re.search(r"(?m)^status:\s*published\s*$", manifest) is not None
    if not v2_path.is_file():
        require(not published, "published project requires V2 evidence")
        print("publication_evidence=not-applicable")
        return

    v1 = None if native_v2 else read_json(v1_path)
    result = read_json(result_path) if native_v2 else None
    v2 = read_json(v2_path)
    schema = read_json(SCHEMA_PATH)
    metric, workload, provenance = validate_v2_contract(
        v2, spec, schema, require_all_metrics_clean=native_v2
    )
    if native_v2:
        require(result == v2, "result and publication artifacts differ")
        require(
            re.fullmatch(r"sha256:[0-9a-f]{64}", provenance["artifact_digest"]) is not None,
            "invalid artifact digest",
        )
        require(f"result_path: {spec['result_path']}" in manifest, "manifest V2 result path mismatch")
        require(
            f"publication_result_path: {spec['publication_path']}" in manifest,
            "manifest V2 publication path mismatch",
        )
    else:
        expected_v1_project = spec.get("v1_project", spec["project"])
        require(v1.get("project") == expected_v1_project, "unexpected V1 project")
        require(v1.get("metric") == spec["primary_metric"], "unexpected V1 metric")
        require(v1.get("failures", 0) == 0, "V1 contains failures")
        samples = list(v1.get("samples") or [v1["value"]])
        require(metric["value"] == v1["value"], "V1/V2 value mismatch")
        require(metric["samples"] == samples, "V1/V2 samples mismatch")
        require(provenance["artifact_digest"] == sha256_file(v1_path), "raw artifact digest mismatch")
        require(f"result_path: {spec['v2_path']}" in manifest, "manifest V2 result path mismatch")
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    if native_v2:
        normalized_readme = readme.replace(",", "")
        require(spec["primary_metric"] in readme, "README is missing the primary metric name")
        for metric_name in spec["readme_metrics"]:
            matching = [item for item in v2["metrics"] if item["name"] == metric_name]
            require(len(matching) == 1, f"publication metric missing or duplicated: {metric_name}")
            value = str(matching[0]["value"])
            require(value in normalized_readme, f"README is missing publication value: {metric_name}={value}")
    else:
        for expected in spec["readme_values"]:
            require(str(expected) in readme, f"README is missing publication value: {expected}")

    if args.require_git:
        source_commit = provenance["source_commit"]
        require(git_has_commit(source_commit), "source commit unavailable; fetch full history")
        producer = load_producer()
        require(
            workload["fixture_digest"] == producer.digest_committed_path(ROOT, fixture_path, source_commit),
            "committed fixture digest mismatch",
        )
        require(
            workload["config_digest"] == producer.digest_committed_path(ROOT, config_path, source_commit),
            "committed config digest mismatch",
        )
        require(
            provenance["dependency_lock_digest"] == producer.digest_committed_path(ROOT, lock_path, source_commit),
            "committed dependency lock digest mismatch",
        )

    serialized = json.dumps({"result": result, "v1": v1, "v2": v2})
    for forbidden in ("C:\\Users\\", "github" + "_pat_", "gh" + "p_"):
        require(forbidden not in serialized, f"forbidden value in evidence: {forbidden}")
    print("publication_evidence=passed")


if __name__ == "__main__":
    main()
