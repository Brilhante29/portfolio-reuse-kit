from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

import yaml
from graphql import build_schema, validate_schema
from jsonschema import Draft202012Validator, FormatChecker
from openapi_spec_validator import validate as validate_openapi
from openapi_spec_validator.readers import read_from_filename


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

    project_schema_path = root / "contracts" / "project.schema.json"
    project_fixtures = root / "contracts" / "fixtures"
    project_valid_paths = sorted(project_fixtures.glob("project*.valid.json"))
    project_invalid_paths = sorted(project_fixtures.glob("project*.invalid.json"))
    try:
        project_schema = json.loads(project_schema_path.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(project_schema)
        project_validator = Draft202012Validator(project_schema, format_checker=FormatChecker())
        for project_valid_path in project_valid_paths:
            project_validator.validate(
                json.loads(project_valid_path.read_text(encoding="utf-8"))
            )
        for project_invalid_path in project_invalid_paths:
            invalid_project_errors = list(
                project_validator.iter_errors(
                    json.loads(project_invalid_path.read_text(encoding="utf-8"))
                )
            )
            if not invalid_project_errors:
                failures.append(
                    f"invalid project fixture was accepted: {project_invalid_path.name}"
                )
    except Exception as error:
        failures.append(f"project contract validation failed: {error}")

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

    openapi_path = root / "contracts" / "portfolio-evidence.openapi.yaml"
    try:
        openapi_document, base_uri = read_from_filename(str(openapi_path))
        validate_openapi(openapi_document, base_uri=base_uri)
    except Exception as error:
        failures.append(f"OpenAPI contract validation failed: {error}")

    graphql_path = root / "contracts" / "portfolio-evidence.graphql"
    try:
        graphql_schema = build_schema(graphql_path.read_text(encoding="utf-8"))
        graphql_errors = validate_schema(graphql_schema)
        if graphql_errors:
            failures.extend(f"GraphQL contract validation failed: {error}" for error in graphql_errors)
    except Exception as error:
        failures.append(f"GraphQL contract validation failed: {error}")

    manifest_check = subprocess.run(
        [sys.executable, str(root / "tools" / "generate-contract-manifest.py"), "--check"],
        cwd=root,
        capture_output=True,
        text=True,
        check=False,
    )
    if manifest_check.returncode != 0:
        detail = (manifest_check.stdout + manifest_check.stderr).strip()
        failures.append(f"contract manifest validation failed: {detail}")

    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    print(
        f"validated {len(yaml_files)} YAML files, project and benchmark V2 fixtures, "
        "OpenAPI, GraphQL, and contract manifest"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
