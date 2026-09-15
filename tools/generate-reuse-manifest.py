#!/usr/bin/env python3
"""Derive reuse.manifest.yaml from what a repository actually shares with the kit.

The contract requires every project to declare what it consumed from
portfolio-reuse-kit, where it deliberately diverged, and what it contributed
back. Writing that by hand invites drift, so this compares tracked bytes:

  consumed        tracked file identical to its kit counterpart
  local_overrides tracked file that exists in the kit but differs here

contributed_back is never guessed. An existing manifest's contributed_back
block is preserved, because only a human knows what was actually upstreamed.
"""

from __future__ import annotations

import argparse
import hashlib
import subprocess
import sys
from pathlib import Path

# Repo path -> kit path. Only files the kit genuinely owns a baseline for.
CANDIDATES = {
    "AGENTS.md": "templates/AGENTS.md",
    "CLAUDE.md": "templates/CLAUDE.md",
    "tools/validate-project.ps1": "templates/validate-project.ps1",
    "REFERENCES.md": "templates/REFERENCES.md",
    ".editorconfig": ".editorconfig",
    ".gitattributes": ".gitattributes",
}


def digest(path: Path) -> str | None:
    if not path.is_file():
        return None
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tracked(repo: Path) -> set[str]:
    out = subprocess.run(["git", "-C", str(repo), "ls-files"],
                         capture_output=True, text=True, check=False)
    return set(out.stdout.split())


def kit_head(kit: Path) -> str:
    out = subprocess.run(["git", "-C", str(kit), "rev-parse", "HEAD"],
                         capture_output=True, text=True, check=False)
    return out.stdout.strip()


def keep_contributed(path: Path) -> list[str]:
    """Carry an existing contributed_back block through verbatim."""
    if not path.is_file():
        return []
    lines = path.read_text(encoding="utf-8").splitlines()
    for i, line in enumerate(lines):
        if line.startswith("contributed_back:"):
            return lines[i:]
    return []


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", required=True, type=Path)
    parser.add_argument("--kit", required=True, type=Path)
    parser.add_argument("--force", action="store_true",
                        help="regenerate even if a manifest exists")
    args = parser.parse_args()

    repo, kit = args.repo.resolve(), args.kit.resolve()

    # A hand-curated manifest carries reasoning this tool cannot reconstruct:
    # overwriting rag-knowledge-base replaced a detailed consumed list with a
    # thinner derived one. Never clobber an existing manifest.
    existing = repo / "reuse.manifest.yaml"
    if existing.is_file() and not args.force:
        print(f"{repo.name} | SKIP already has a manifest")
        return 0

    files = tracked(repo)
    if not files:
        print(f"{repo.name} | NOT_A_REPO")
        return 1

    consumed: list[tuple[str, str]] = []
    overrides: list[str] = []
    for rel, kit_rel in CANDIDATES.items():
        if rel not in files:
            continue
        here, there = digest(repo / rel), digest(kit / kit_rel)
        if there is None:
            continue
        if here == there:
            consumed.append((kit_rel, rel))
        else:
            overrides.append(rel)

    snapshot = sorted(f for f in files if f.startswith(".portfolio/"))
    head = kit_head(kit)

    out = [f'kit_version: "portfolio-reuse-kit@{head}"', "", "consumed:"]
    for kit_rel, rel in consumed:
        out += [f'  - source: "{kit_rel}"', f'    version: "{head}"',
                f'    files: ["{rel}"]']
    if snapshot:
        out += [f'  - source: "kit snapshot ({len(snapshot)} files)"',
                f'    version: "{head}"', '    files: [".portfolio/"]']
    if not consumed and not snapshot:
        out += ["  []"]

    out += ["", "local_overrides:"]
    if overrides:
        for rel in overrides:
            out += [f'  - path: "{rel}"',
                    '    reason: "Diverges from the kit baseline; carries '
                    'project-specific content."']
    else:
        out += ["  []"]

    tail = keep_contributed(repo / "reuse.manifest.yaml")
    out += [""] + (tail if tail else ["contributed_back:", "  []"])

    (repo / "reuse.manifest.yaml").write_text("\n".join(out) + "\n",
                                              encoding="utf-8", newline="")
    print(f"{repo.name} | OK consumed={len(consumed)} snapshot={len(snapshot)} "
          f"overrides={len(overrides)} contributed_preserved={bool(tail)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
