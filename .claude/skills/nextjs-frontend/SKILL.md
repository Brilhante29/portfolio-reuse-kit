---
name: nextjs-frontend
description: Build or review Next.js portfolio products with SSR composition, framework-independent application policy, fixture/live adapters, production standalone output, browser workflows, and measurable UI completion.
---

# Next.js Frontend

Choose Next.js because the problem needs public server rendering plus rich browser interaction, not merely because React is available.

1. Read `language-profiles/nextjs.yaml` and the architecture decision before selecting folders or libraries.
2. Keep domain types and application policy independent from React, Next.js, fetch, browser APIs, and transport envelopes.
3. Let the application boundary own capability-specific ports. Fixture and live adapters must preserve observable semantics and fail closed on malformed remote data.
4. Server-render the initial read when inspectability matters. Keep filters and short-lived selection state local unless cross-route persistence is a measured requirement.
5. Use URL-addressable routes or query parameters for detail and comparison workflows that reviewers need to share.
6. Reject Apollo, Redux, a BFF, mutations, brokers, databases, auth, and cloud adapters until a concrete workflow or benchmark requires each one.
7. Build with `output: standalone`; copy `.next/static` into `.next/standalone/.next/static` for local standalone execution.
8. Use the same standalone server for E2E, screenshots, benchmark, and Docker smoke so development behavior cannot hide packaging defects.
9. Test pure policy in Node, adapter mapping/failure paths at the boundary, and complete browser workflows in Playwright.
10. For canvas or WebGL output, assert painted pixels and stable framing in desktop and mobile screenshots. Reject viewport scroll and overlapping controls.
11. Measure interaction to an explicit product completion marker, such as a chart `finished` event or committed view revision. Do not substitute click-dispatch time.
12. Publish benchmark V2 only from a clean source commit and record the exact runtime image digest.
13. npm install scripts remain denied by default. Approve only reviewed, version-pinned transitive scripts and record the reason.

Use `templates/Dockerfile.nextjs`, `templates/github-actions-nextjs.yml`, and `templates/prepare-standalone.mjs` through `tools/new-project.ps1 -Profile nextjs` after the product spec names Next.js.
