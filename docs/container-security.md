# Current Image Security

Publication evidence and current image security are separate gates. A successful
CI run does not make a months-old dependency scan current. A pinned historical
benchmark is immutable evidence, not a reason to ship a known vulnerable runtime.

## Reproducible Audit

Requires Docker, Python 3.12+, Git, and a verified Trivy installation. Pin the
Trivy version in CI and verify the publisher's release checksum when installing.

```powershell
python tools/scan-image-security.py --repo ../llm-eval-harness --image llm-eval-harness:security-audit --out ../security-audit/llm-eval-harness
```

The command always builds the current source, scans the immutable local image ID,
and writes the report outside the repository. It records the source SHA, tracked
worktree cleanliness, scanner/DB version, timestamp, and findings. A dirty-tree
scan is diagnostic evidence, not an exact-commit release attestation.

For a batch, refresh the database once with `trivy image --download-db-only
--cache-dir ../trivy-cache`. Supply `--cache-dir ../trivy-cache --skip-db-update`
only to consumers in that same batch. The harness uses an in-memory analysis
cache so parallel scans do not contend for Trivy's exclusive filesystem cache
lock. The vulnerability database is shared read-only during the batch. See
[Trivy cache behavior](https://trivy.dev/docs/latest/configuration/cache/).

## Gates

- Exit 0: no HIGH/CRITICAL findings in this scanner's scope.
- Exit 1: HIGH/CRITICAL findings with available fixes, or execution failure.
- Exit 2: remaining HIGH/CRITICAL findings have no reported fix and need review.
- Missing results, mismatched image IDs, and scanner errors never count as clean.
- A blanket `documented` disposition never suppresses a finding.

Refresh the official base image digest first; upgrade specific runtime libraries
when needed. Run the affected tests and Docker smoke before publishing. Preserve
the previous benchmark's source SHA, image digest, dependencies, and result JSON.
Do not relabel that historical performance result as a measurement of the patched
runtime. Produce a new benchmark when making a new performance claim.

This vulnerability gate does not replace secret scanning, application review,
authorization tests, threat modelling, or a deployment security assessment.
