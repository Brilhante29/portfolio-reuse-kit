# Design System

This folder defines a unified visual and documentation language for all portfolio repositories.

It is intentionally lightweight: README structure, benchmark cards, architecture cards, badges, diagram rules, dashboard defaults, and color tokens. The goal is consistency across GitHub, posts, screenshots, and dashboards without forcing every project into the same stack.

Agents should consult `design-system/tokens.yaml` when creating:

- README headers
- benchmark tables
- architecture summaries
- dashboard screenshots
- Mermaid diagrams
- docs pages
- release notes

The design system is not decoration. It exists so every repository looks like part of the same engineering portfolio and exposes evidence quickly.

## Generated Web Tokens

`python tools/generate-design-tokens.py` emits CSS custom properties, SCSS variables, typed TypeScript data, and a digest manifest. Version 2 covers semantic colors, spacing, radii, stable control/layout sizes, responsive breakpoints, and restrained shadows.

Applications may compose their own layout, but should consume these primitives instead of copying ad hoc values. Project-specific components, page structure, and domain colors stay in the consuming repository.
