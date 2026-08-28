# Portfolio Evidence Console Reuse Delta

Date: 2026-08-28

## Project Proof

- #32 `portfolio-evidence-console` is locally implemented and benchmarked from clean source `f887d2143013cdbd586a7fc4a29709d2726bc7b0`.
- Browser result: filter-to-chart p95 41.72 ms over 30 interactions, LCP 372 ms, CLS 0.0859, 318,437 transferred bytes, zero failures.
- Runtime image digest: `sha256:626d5a6ba263476a9e463957ac18046e7773bda6a3974298fb1c7d62fbb01049`.
- Final main `ae22e864b605907c2c61403950173977a5271404` passed exact-head CI `33217542452`; the published count is 32.

## Promoted Reuse

- Mirrored `nextjs-frontend` skill for Codex and Claude.
- `tools/new-project.ps1 -Profile nextjs` plus tested Docker, GitHub Actions, standalone preparation, and formatter templates.
- Design tokens v2 with semantic colors, spacing, radii, stable sizes, breakpoints, shadows, and generator tests.
- Browser benchmark rules for rendered completion markers, nonblank canvas pixels, viewport containment, clean source, and real image digests.
- Portfolio Evidence Platform component pack and truthful #32 catalog stack/result.

Project-specific evidence fixtures, React views, chart composition, and comparison presentation remain in #32.
