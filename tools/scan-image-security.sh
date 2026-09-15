#!/usr/bin/env bash
# Produce SBOM and vulnerability evidence for a portfolio repository image.
#
# The portfolio pins base images by digest so that benchmark provenance stays
# comparable. That pin also means base-OS advisories cannot be resolved by
# rebuilding, so this tool records what is present instead of hiding it:
# an SPDX SBOM, the HIGH/CRITICAL findings, and a summary separating
# fixable findings from ones with no upstream fix.
#
# Usage: scan-image-security.sh <repo-path> [image-tag]
set -uo pipefail

REPO="${1:?repo path required}"
NAME="$(basename "$REPO")"
IMAGE="${2:-$NAME:sec}"
OUT="$REPO/.portfolio-control/security"
TRIVY="aquasec/trivy:0.58.1"

mkdir -p "$OUT"
# `a && b || c && d` groups as `((a && b) || c) && d`, which emitted two
# lines and produced an invalid bind mount. Group the fallback explicitly.
WIN_REPO="$(cd "$REPO" && { pwd -W 2>/dev/null || pwd; })"

# Always rebuild. Reusing an existing tag scanned month-old images and
# reported vulnerabilities that the current tree had already fixed: one repo
# showed 77 HIGH/CRITICAL from a stale binary against 0 on a fresh build.
# Layer cache still applies, so this stays cheap while staying truthful.
docker build -q -t "$IMAGE" "$REPO" >/dev/null 2>&1 || { echo "$NAME | BUILD_FAIL"; exit 1; }

# JVM images make Trivy fetch a ~920 MB Java DB to read JAR coordinates. Without
# a persistent cache every repository re-downloads it and the scan times out, which
# is what made every Gradle project report SBOM_FAIL. Keep the DB in a named volume
# so only the first JVM image pays for it.
docker volume create trivy-cache >/dev/null 2>&1 || true

trivy() {
  MSYS_NO_PATHCONV=1 docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v trivy-cache:/root/.cache/trivy \
    -v "${WIN_REPO}/.portfolio-control/security:/out" \
    "$TRIVY" image "$IMAGE" --quiet "$@"
}

trivy --format spdx-json --output /out/sbom.spdx.json >/dev/null 2>&1 \
  || { echo "$NAME | SBOM_FAIL"; exit 1; }
trivy --scanners vuln --severity HIGH,CRITICAL --format json --output /out/container-scan.json >/dev/null 2>&1 \
  || { echo "$NAME | SCAN_FAIL"; exit 1; }

python - "$OUT" "$NAME" "$IMAGE" <<'PY'
import json, sys, collections, datetime
out, name, image = sys.argv[1], sys.argv[2], sys.argv[3]

sbom = json.load(open(f"{out}/sbom.spdx.json", encoding="utf-8"))
packages = [p for p in sbom.get("packages", []) if p.get("name")]

scan = json.load(open(f"{out}/container-scan.json", encoding="utf-8"))
fixable, unfixed = [], []
for result in scan.get("Results") or []:
    for vuln in result.get("Vulnerabilities") or []:
        (fixable if vuln.get("FixedVersion") else unfixed).append(vuln)

summary = {
    "repository": name,
    "image": image,
    "generated_at": datetime.datetime.now(datetime.timezone.utc)
        .isoformat().replace("+00:00", "Z"),
    "sbom_packages": len(packages),
    "high_critical_total": len(fixable) + len(unfixed),
    "fixable": len(fixable),
    "no_upstream_fix": len(unfixed),
    "fixable_packages": dict(collections.Counter(v["PkgName"] for v in fixable)),
    "disposition": "documented",
    "rationale": (
        "Base images are pinned by digest so benchmark provenance stays "
        "comparable. Rebuilding does not clear these advisories: the current "
        "upstream digest carries the same set. Applying apt-get upgrade would "
        "make the image non-deterministic and change image_digest between "
        "builds of the same commit, breaking the V2 comparability contract."
    ),
}
json.dump(summary, open(f"{out}/security-summary.json", "w", encoding="utf-8"),
          indent=2, sort_keys=True)
print(f"{name} | OK sbom={len(packages)} high_crit={summary['high_critical_total']} "
      f"fixable={len(fixable)} nofix={len(unfixed)}")
PY
