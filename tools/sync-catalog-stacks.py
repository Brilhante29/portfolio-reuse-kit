from __future__ import annotations

import argparse
import json
from pathlib import Path

import yaml


def render_catalog(catalog: dict) -> str:
    lines = ["projects:"]
    for project in catalog["projects"]:
        lines.append(f"  - id: {project['id']}")
        for key in ("name", "domain", "stack", "proves", "benchmark", "reuse_from"):
            lines.append(f"    {key}: {json.dumps(project[key], ensure_ascii=True)}")
    return "\n".join(lines) + "\n"


def render_markdown(catalog: dict) -> str:
    lines = [
        "# Project Catalog",
        "",
        "| # | Project | Domain | Stack | Proves | Benchmark |",
        "|---:|---|---|---|---|---|",
    ]
    for item in catalog["projects"]:
        stack = ", ".join(str(value) for value in item.get("stack", []))
        lines.append(
            f"| {item['id']} | `{item['name']}` | {item['domain']} | {stack} | "
            f"{item['proves']} | {item['benchmark']} |"
        )
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Synchronize catalog stacks from repository project manifests.")
    parser.add_argument("--repo-root", type=Path, required=True)
    parser.add_argument("--catalog", type=Path, required=True)
    parser.add_argument("--markdown", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    catalog = yaml.safe_load(args.catalog.read_text(encoding="utf-8"))
    drift: list[str] = []
    for project in catalog["projects"]:
        manifest_path = args.repo_root / project["name"] / "project.yaml"
        if not manifest_path.is_file():
            continue
        manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
        if manifest.get("id") != project["id"] or manifest.get("name") != project["name"]:
            raise ValueError(f"identity mismatch in {manifest_path}")
        actual = [str(item) for item in manifest.get("stack", [])]
        declared = [str(item) for item in project.get("stack", [])]
        if actual != declared:
            drift.append(f"{project['name']}: catalog={declared} manifest={actual}")
            project["stack"] = actual

    if args.check and drift:
        raise SystemExit("catalog stack drift:\n" + "\n".join(drift))
    if not args.check:
        args.catalog.write_text(render_catalog(catalog), encoding="utf-8", newline="\n")
        if args.markdown:
            args.markdown.write_text(render_markdown(catalog), encoding="utf-8", newline="\n")
    print(f"catalog stack updates={len(drift)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
