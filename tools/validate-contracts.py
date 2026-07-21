from __future__ import annotations

import json
import sys
from pathlib import Path

import yaml
from jsonschema import Draft202012Validator, FormatChecker


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    failures: list[str] = []

    yaml_files = sorted((*root.rglob("*.yaml"), *root.rglob("*.yml")))
    for path in yaml_files:
        if ".git" in path.parts:
            continue
        try:
            yaml.safe_load(path.read_text(encoding="utf-8"))
        except Exception as error:  # report all malformed files in one run
            failures.append(f"invalid YAML {path.relative_to(root)}: {error}")

    schema_path = root / "contracts" / "benchmark-result-v2.schema.json"
    valid_path = root / "contracts" / "fixtures" / "benchmark-result-v2.valid.json"
    invalid_path = root / "contracts" / "fixtures" / "benchmark-result-v2.invalid.json"
    try:
        schema = json.loads(schema_path.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(schema)
        validator = Draft202012Validator(schema, format_checker=FormatChecker())
        validator.validate(json.loads(valid_path.read_text(encoding="utf-8")))
        invalid_errors = list(validator.iter_errors(json.loads(invalid_path.read_text(encoding="utf-8"))))
        if not invalid_errors:
            failures.append("invalid benchmark V2 fixture was accepted")
    except Exception as error:
        failures.append(f"benchmark V2 contract validation failed: {error}")

    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    print(f"validated {len(yaml_files)} YAML files and benchmark-result-v2 fixtures")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
