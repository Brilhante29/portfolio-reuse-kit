import json
import sys
from pathlib import Path


def load(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: compare_results.py old.json new.json")

    old = load(sys.argv[1])
    new = load(sys.argv[2])
    old_value = float(old["value"])
    new_value = float(new["value"])
    delta = new_value - old_value
    pct = (delta / old_value * 100) if old_value else 0.0

    print(f"project: {new.get('project', old.get('project'))}")
    print(f"metric: {new['metric']}")
    print(f"old: {old_value:.4f} {old['unit']}")
    print(f"new: {new_value:.4f} {new['unit']}")
    print(f"delta: {delta:.4f} ({pct:.2f}%)")


if __name__ == "__main__":
    main()
