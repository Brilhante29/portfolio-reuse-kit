from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import yaml


def digest(content: bytes) -> str:
    return "sha256:" + hashlib.sha256(content).hexdigest()


def render(source: Path) -> dict[str, bytes]:
    data = yaml.safe_load(source.read_text(encoding="utf-8"))
    colors = data.get("colors", {})
    css_lines = [":root {"] + [f"  --portfolio-color-{name}: {value};" for name, value in colors.items()] + ["}", ""]
    scss_lines = [f"$portfolio-color-{name}: {value};" for name, value in colors.items()] + [""]
    typescript = "export const portfolioTokens = " + json.dumps(data, indent=2, ensure_ascii=True) + " as const;\n"
    outputs = {
        "tokens.css": "\n".join(css_lines).encode(),
        "tokens.scss": "\n".join(scss_lines).encode(),
        "tokens.ts": typescript.encode(),
    }
    manifest = {
        "schema_version": 1,
        "token_version": data["version"],
        "source": "design-system/tokens.yaml",
        "source_digest": digest(source.read_bytes()),
        "artifacts": {name: digest(content) for name, content in outputs.items()},
    }
    outputs["manifest.json"] = (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode()
    return outputs


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description="Generate framework-neutral portfolio design tokens.")
    parser.add_argument("--source", type=Path, default=root / "design-system" / "tokens.yaml")
    parser.add_argument("--output", type=Path, default=root / "design-system" / "generated")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    outputs = render(args.source)
    mismatches: list[str] = []
    for name, content in outputs.items():
        path = args.output / name
        if args.check:
            if not path.is_file() or path.read_bytes() != content:
                mismatches.append(name)
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(content)
    if mismatches:
        raise SystemExit("generated design tokens are stale: " + ", ".join(mismatches))
    print(("checked" if args.check else "generated") + f" {len(outputs)} design-token artifacts")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
