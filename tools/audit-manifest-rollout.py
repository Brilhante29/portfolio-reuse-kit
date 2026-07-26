from __future__ import annotations

import argparse
import copy
import json
from pathlib import Path

import yaml
from jsonschema import Draft202012Validator


def compact_errors(errors: list[object], limit: int = 5) -> list[str]:
    rendered: list[str] = []
    for error in errors[:limit]:
        path = ".".join(str(part) for part in error.absolute_path) or "<root>"
        rendered.append(f"{path}: {error.message}")
    if len(errors) > limit:
        rendered.append(f"... {len(errors) - limit} additional errors")
    return rendered


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Audit legacy compatibility and manifest v2 migration readiness."
    )
    parser.add_argument("repo_root", type=Path)
    parser.add_argument(
        "--schema",
        type=Path,
        default=Path(__file__).resolve().parents[1] / "contracts" / "project.schema.json",
    )
    parser.add_argument("--json", action="store_true", dest="as_json")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Exit non-zero when an existing manifest is invalid under its declared version.",
    )
    args = parser.parse_args()

    schema = json.loads(args.schema.read_text(encoding="utf-8"))
    validator = Draft202012Validator(schema)
    reports: list[dict[str, object]] = []

    for manifest_path in sorted(args.repo_root.glob("*/project.yaml")):
        try:
            manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
        except Exception as error:
            reports.append(
                {
                    "repository": manifest_path.parent.name,
                    "declared_version": "unreadable",
                    "compatible": False,
                    "v2_ready": False,
                    "errors": [str(error)],
                    "v2_errors": [],
                }
            )
            continue
        if not isinstance(manifest, dict):
            continue

        actual_errors = sorted(
            validator.iter_errors(manifest), key=lambda error: list(error.absolute_path)
        )
        candidate = copy.deepcopy(manifest)
        candidate["manifest_version"] = 2
        v2_errors = sorted(
            validator.iter_errors(candidate), key=lambda error: list(error.absolute_path)
        )
        reports.append(
            {
                "repository": manifest_path.parent.name,
                "project_id": manifest.get("id"),
                "declared_version": manifest.get("manifest_version", 1),
                "compatible": not actual_errors,
                "v2_ready": not v2_errors,
                "errors": compact_errors(actual_errors),
                "v2_errors": compact_errors(v2_errors),
            }
        )

    summary = {
        "repositories": len(reports),
        "compatible": sum(bool(report["compatible"]) for report in reports),
        "invalid": sum(not bool(report["compatible"]) for report in reports),
        "v2_ready": sum(bool(report["v2_ready"]) for report in reports),
        "v2_pending": sum(not bool(report["v2_ready"]) for report in reports),
    }
    payload = {"summary": summary, "repositories": reports}

    if args.as_json:
        print(json.dumps(payload, indent=2, sort_keys=True))
    else:
        print(
            "repositories={repositories} compatible={compatible} invalid={invalid} "
            "v2_ready={v2_ready} v2_pending={v2_pending}".format(**summary)
        )
        for report in reports:
            print(
                f"{report.get('project_id', '?')} {report['repository']}: "
                f"version={report['declared_version']} compatible={report['compatible']} "
                f"v2_ready={report['v2_ready']}"
            )

    return 1 if args.strict and summary["invalid"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
