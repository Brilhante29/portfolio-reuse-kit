from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


MANIFEST_NAME = "manifest.json"
CONTRACT_SET_VERSION = "1.5.0"
TEXT_SUFFIXES = {".json", ".yaml", ".yml", ".graphql"}


def normalize_text_assets(contracts_dir: Path) -> None:
    for path in sorted(contracts_dir.rglob("*")):
        if not path.is_file() or path == contracts_dir / MANIFEST_NAME:
            continue
        if path.suffix.lower() not in TEXT_SUFFIXES:
            continue
        content = path.read_bytes()
        normalized = content.replace(b"\r\n", b"\n").replace(b"\r", b"\n")
        if content != normalized:
            path.write_bytes(normalized)


def build_manifest(contracts_dir: Path) -> dict[str, object]:
    assets: dict[str, dict[str, object]] = {}
    for path in sorted(contracts_dir.rglob("*")):
        if not path.is_file() or path == contracts_dir / MANIFEST_NAME:
            continue
        relative = path.relative_to(contracts_dir).as_posix()
        content = path.read_bytes()
        if path.suffix.lower() in TEXT_SUFFIXES and b"\r" in content:
            raise ValueError(f"{relative} must use LF line endings")
        assets[relative] = {
            "sha256": f"sha256:{hashlib.sha256(content).hexdigest()}",
            "bytes": len(content),
        }
    return {
        "schema_version": 1,
        "contract_set": "portfolio-interoperability",
        "contract_set_version": CONTRACT_SET_VERSION,
        "assets": assets,
    }


def render(manifest: dict[str, object]) -> str:
    return json.dumps(manifest, indent=2, sort_keys=True) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate or verify the vendored contract manifest.")
    parser.add_argument("--check", action="store_true", help="Fail when contracts/manifest.json has drifted.")
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[1]
    contracts_dir = root / "contracts"
    manifest_path = contracts_dir / MANIFEST_NAME
    if not args.check:
        normalize_text_assets(contracts_dir)
    try:
        expected = render(build_manifest(contracts_dir))
    except ValueError as error:
        print(error)
        return 1

    if args.check:
        if not manifest_path.exists():
            print(f"missing {manifest_path.relative_to(root)}")
            return 1
        actual = manifest_path.read_text(encoding="utf-8")
        if actual != expected:
            print("contracts/manifest.json is stale; run python tools/generate-contract-manifest.py")
            return 1
        print("contract manifest is current")
        return 0

    manifest_path.write_text(expected, encoding="utf-8", newline="\n")
    print(f"wrote {manifest_path.relative_to(root)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
