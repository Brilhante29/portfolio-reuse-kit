from __future__ import annotations

import copy
import importlib.util
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = ROOT / "tools" / "validate-publication.py"
SCHEMA = json.loads((ROOT / "contracts" / "benchmark-result-v2.schema.json").read_text(encoding="utf-8"))
SPEC = {
    "project": "native-v2-test",
    "benchmark_id": "browser-v1",
    "primary_metric": "interaction_p95_ms",
    "repeat": 1,
    "measured_iterations": 2,
    "warmup_iterations": 1,
    "concurrency": 1,
    "comparability_key": "browser-v1",
}
SHA = "0" * 64
RESULT = {
    "schema_version": 2,
    "run_id": "11111111-1111-4111-8111-111111111111",
    "project": "native-v2-test",
    "benchmark_id": "browser-v1",
    "workload": {
        "version": "1.0.0",
        "fixture_digest": f"sha256:{SHA}",
        "config_digest": f"sha256:{SHA}",
        "warmup_iterations": 1,
        "measured_iterations": 2,
        "concurrency": 1,
    },
    "metrics": [
        {
            "name": "interaction_p95_ms",
            "value": 12.5,
            "unit": "ms",
            "direction": "lower_is_better",
            "samples": [10.0, 12.5],
            "failures": 0,
            "summary": {},
        },
        {
            "name": "secondary",
            "value": 1.0,
            "unit": "score",
            "direction": "lower_is_better",
            "samples": [1.0],
            "failures": 0,
            "summary": {},
        },
    ],
    "execution": {
        "command": "benchmark",
        "started_at": "2026-08-28T00:00:00Z",
        "duration_seconds": 1.0,
        "exit_code": 0,
        "repeat": 1,
    },
    "environment": {"runtime": "node-24", "architecture": "amd64", "hardware_class": "test"},
    "provenance": {
        "source_commit": "a" * 40,
        "clean_tree": True,
        "image_ref": "test@sha256",
        "image_digest": f"sha256:{SHA}",
        "dependency_lock_digest": f"sha256:{SHA}",
        "producer": "local",
        "artifact_digest": f"sha256:{SHA}",
    },
    "comparability_key": "browser-v1",
}

module_spec = importlib.util.spec_from_file_location("validate_publication", MODULE_PATH)
assert module_spec is not None and module_spec.loader is not None
validator = importlib.util.module_from_spec(module_spec)
module_spec.loader.exec_module(validator)


class ValidatePublicationTest(unittest.TestCase):
    def test_native_v2_passes(self) -> None:
        validator.validate_v2_contract(RESULT, SPEC, SCHEMA, require_all_metrics_clean=True)

    def test_native_v2_rejects_secondary_failure(self) -> None:
        candidate = copy.deepcopy(RESULT)
        candidate["metrics"][1]["failures"] = 1
        with self.assertRaisesRegex(AssertionError, "contains failures"):
            validator.validate_v2_contract(candidate, SPEC, SCHEMA, require_all_metrics_clean=True)

    def test_legacy_mode_preserves_primary_only_behavior(self) -> None:
        candidate = copy.deepcopy(RESULT)
        candidate["metrics"][1]["failures"] = 1
        validator.validate_v2_contract(candidate, SPEC, SCHEMA, require_all_metrics_clean=False)


if __name__ == "__main__":
    unittest.main()
