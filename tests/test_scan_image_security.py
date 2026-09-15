import importlib.util
from pathlib import Path
import unittest


spec = importlib.util.spec_from_file_location(
    "scan_security", Path(__file__).parents[1] / "tools/scan-image-security.py")
scanner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scanner)
IMAGE = "sha256:" + "a" * 64


def report(*vulnerabilities):
    return {"SchemaVersion": 2, "ArtifactType": "container_image",
            "Metadata": {"ImageID": IMAGE},
            "Results": [{"Target": "app", "Vulnerabilities": list(vulnerabilities)}]}


def vulnerability(severity="HIGH", fixed="1.2.1"):
    return {"VulnerabilityID": "CVE-2026-0001", "PkgName": "example",
            "InstalledVersion": "1.2.0", "FixedVersion": fixed, "Severity": severity}


class SecurityPolicyTests(unittest.TestCase):
    def test_clean_result(self):
        self.assertEqual("pass", scanner.summarize(report(), IMAGE)["status"])

    def test_fixable_severe_blocks_even_when_documented(self):
        item = vulnerability()
        item["disposition"] = "documented"
        result = scanner.summarize(report(item), IMAGE)
        self.assertEqual("fail", result["status"])
        self.assertEqual(1, result["fixable_severe_count"])

    def test_unpatched_is_not_clean(self):
        result = scanner.summarize(report(vulnerability(fixed="")), IMAGE)
        self.assertEqual("review_required", result["status"])
        self.assertEqual(1, result["unpatched_severe_count"])

    def test_medium_is_outside_blocking_scope(self):
        self.assertEqual("pass", scanner.summarize(report(vulnerability("MEDIUM")), IMAGE)["status"])

    def test_wrong_image_rejected(self):
        with self.assertRaisesRegex(ValueError, "image ID"):
            scanner.summarize(report(), "sha256:" + "b" * 64)

    def test_incomplete_scan_rejected(self):
        for invalid in ({}, {**report(), "Results": []}, {**report(), "Results": None}):
            with self.subTest(report=invalid), self.assertRaises(ValueError):
                scanner.summarize(invalid, IMAGE)

    def test_incomplete_finding_rejected(self):
        item = vulnerability()
        del item["PkgName"]
        with self.assertRaisesRegex(ValueError, "PkgName"):
            scanner.summarize(report(item), IMAGE)


if __name__ == "__main__":
    unittest.main()
