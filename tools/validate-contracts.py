from __future__ import annotations

import json
import statistics
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

    medical_schema_path = root / "contracts" / "medical-evaluation-report-v1.schema.json"
    medical_valid_path = root / "contracts" / "fixtures" / "medical-evaluation-report-v1.valid.json"
    medical_invalid_path = root / "contracts" / "fixtures" / "medical-evaluation-report-v1.invalid.json"
    try:
        medical_schema = json.loads(medical_schema_path.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(medical_schema)
        medical_validator = Draft202012Validator(
            medical_schema, format_checker=FormatChecker()
        )
        medical_validator.validate(
            json.loads(medical_valid_path.read_text(encoding="utf-8"))
        )
        medical_invalid_errors = list(
            medical_validator.iter_errors(
                json.loads(medical_invalid_path.read_text(encoding="utf-8"))
            )
        )
        if not medical_invalid_errors:
            failures.append("invalid medical evaluation fixture was accepted")
    except Exception as error:
        failures.append(f"medical evaluation contract validation failed: {error}")

    ci_schema_path = root / "contracts" / "ci-profile-v1.schema.json"
    ci_valid_path = root / "contracts" / "fixtures" / "ci-profile-v1.valid.json"
    ci_invalid_path = root / "contracts" / "fixtures" / "ci-profile-v1.invalid.json"
    try:
        ci_schema = json.loads(ci_schema_path.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(ci_schema)
        ci_validator = Draft202012Validator(ci_schema, format_checker=FormatChecker())
        ci_validator.validate(json.loads(ci_valid_path.read_text(encoding="utf-8")))
        ci_invalid_errors = list(
            ci_validator.iter_errors(json.loads(ci_invalid_path.read_text(encoding="utf-8")))
        )
        if not ci_invalid_errors:
            failures.append("invalid CI profile fixture was accepted")
    except Exception as error:
        failures.append(f"CI profile contract validation failed: {error}")

    observability_schema_path = root / "contracts" / "observability-evidence-v1.schema.json"
    observability_valid_path = (
        root / "contracts" / "fixtures" / "observability-evidence-v1.valid.json"
    )
    observability_invalid_path = (
        root / "contracts" / "fixtures" / "observability-evidence-v1.invalid.json"
    )
    try:
        observability_schema = json.loads(
            observability_schema_path.read_text(encoding="utf-8")
        )
        Draft202012Validator.check_schema(observability_schema)
        observability_validator = Draft202012Validator(
            observability_schema, format_checker=FormatChecker()
        )
        observability_valid = json.loads(
            observability_valid_path.read_text(encoding="utf-8")
        )
        observability_validator.validate(observability_valid)
        recovery_samples = observability_valid["benchmark"]["samples"]
        run_samples = [run["recovery_seconds"] for run in observability_valid["runs"]]
        if recovery_samples != run_samples:
            failures.append("observability recovery samples do not match run evidence")
        if observability_valid["benchmark"]["median"] != statistics.median(
            recovery_samples
        ):
            failures.append("observability recovery median does not match samples")
        incident_ids = [run["incident_id"] for run in observability_valid["runs"]]
        if len(incident_ids) != len(set(incident_ids)):
            failures.append("observability incident IDs are not unique")
        observability_invalid_errors = list(
            observability_validator.iter_errors(
                json.loads(observability_invalid_path.read_text(encoding="utf-8"))
            )
        )
        if not observability_invalid_errors:
            failures.append("invalid observability evidence fixture was accepted")
    except Exception as error:
        failures.append(f"observability evidence contract validation failed: {error}")

    terraform_schema_path = root / "contracts" / "terraform-kumo-lifecycle-v1.schema.json"
    terraform_valid_path = (
        root / "contracts" / "fixtures" / "terraform-kumo-lifecycle-v1.valid.json"
    )
    terraform_invalid_path = (
        root / "contracts" / "fixtures" / "terraform-kumo-lifecycle-v1.invalid.json"
    )
    try:
        terraform_schema = json.loads(terraform_schema_path.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(terraform_schema)
        terraform_validator = Draft202012Validator(
            terraform_schema, format_checker=FormatChecker()
        )
        terraform_valid = json.loads(terraform_valid_path.read_text(encoding="utf-8"))
        terraform_validator.validate(terraform_valid)
        repeat = terraform_valid["repeat"]
        sample_sets = (
            terraform_valid["samples"],
            terraform_valid["metrics"]["destroy_seconds"],
            terraform_valid["metrics"]["resource_parity"],
            terraform_valid["operations"]["resource_counts"],
        )
        if any(len(samples) != repeat for samples in sample_sets):
            failures.append("Terraform Kumo sample counts do not match repeat")
        if terraform_valid["value"] != statistics.median(terraform_valid["samples"]):
            failures.append("Terraform Kumo primary value does not match apply median")
        if terraform_valid["summary"]["destroy_median_seconds"] != statistics.median(
            terraform_valid["metrics"]["destroy_seconds"]
        ):
            failures.append("Terraform Kumo destroy median does not match samples")
        expected_resources = terraform_valid["operations"]["resources_per_apply"]
        if any(
            count != expected_resources
            for count in terraform_valid["operations"]["resource_counts"]
        ):
            failures.append("Terraform Kumo resource counts do not prove parity")
        if terraform_valid["operations"]["apply_cycles"] != repeat:
            failures.append("Terraform Kumo apply cycles do not match repeat")
        if terraform_valid["operations"]["destroy_cycles"] != repeat:
            failures.append("Terraform Kumo destroy cycles do not match repeat")
        terraform_invalid_errors = list(
            terraform_validator.iter_errors(
                json.loads(terraform_invalid_path.read_text(encoding="utf-8"))
            )
        )
        if not terraform_invalid_errors:
            failures.append("invalid Terraform Kumo lifecycle fixture was accepted")
    except Exception as error:
        failures.append(f"Terraform Kumo lifecycle contract validation failed: {error}")

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
        f"validated {len(yaml_files)} YAML files, project, benchmark V2, medical, CI, observability, and Terraform Kumo fixtures, "
        "OpenAPI, GraphQL, and contract manifest"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
