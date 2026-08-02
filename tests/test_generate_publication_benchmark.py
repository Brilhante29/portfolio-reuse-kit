from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).parents[1] / "tools" / "generate-publication-benchmark.py"
SPEC = importlib.util.spec_from_file_location("publication_benchmark", MODULE_PATH)
assert SPEC and SPEC.loader
publication_benchmark = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(publication_benchmark)


class PublicationBenchmarkTests(unittest.TestCase):
    def test_explicit_measured_iterations_wins(self) -> None:
        result = {"summary": {"measured_operations": 25}}
        self.assertEqual(
            publication_benchmark.infer_measured_iterations(result, 100),
            100,
        )

    def test_measured_iterations_are_derived_from_matching_count_fields(self) -> None:
        result = {
            "summary": {"measured_operations": 225},
            "measured_iterations": 225,
        }
        self.assertEqual(
            publication_benchmark.infer_measured_iterations(result, None),
            225,
        )

    def test_domain_workload_count_is_supported(self) -> None:
        result = {
            "environment": {"n_plates": 100},
            "metrics": {"total_plates": 100},
        }
        self.assertEqual(
            publication_benchmark.infer_measured_iterations(result, None),
            100,
        )

    def test_ambiguous_workload_counts_are_rejected(self) -> None:
        result = {
            "summary": {"measured_operations": 225},
            "metrics": {"total_queries": 100},
        }
        with self.assertRaisesRegex(SystemExit, "ambiguous measured iteration counts"):
            publication_benchmark.infer_measured_iterations(result, None)

    def test_repeat_is_not_used_as_workload_size(self) -> None:
        with self.assertRaisesRegex(SystemExit, "--measured-iterations"):
            publication_benchmark.infer_measured_iterations({"repeat": 3}, None)

    def test_repo_path_rejects_escape_and_absolute_paths(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            repo = Path(directory).resolve()
            with self.assertRaisesRegex(SystemExit, "escapes the repository"):
                publication_benchmark.repo_path(repo, Path("../outside.json"), "--output")
            with self.assertRaisesRegex(SystemExit, "must be relative"):
                publication_benchmark.repo_path(repo, repo / "absolute.json", "--output")

    def test_load_metrics_preserves_samples_and_failures(self) -> None:
        metrics = publication_benchmark.load_metrics(
            {
                "metric": "latency_ms",
                "value": 2.5,
                "unit": "milliseconds",
                "samples": [2.0, 2.5, 3.0],
                "failures": 1,
                "summary": {"p95": 3.0},
            },
            "lower_is_better",
        )
        self.assertEqual(metrics[0]["samples"], [2.0, 2.5, 3.0])
        self.assertEqual(metrics[0]["failures"], 1)
        self.assertEqual(metrics[0]["summary"], {"p95": 3.0})


if __name__ == "__main__":
    unittest.main()