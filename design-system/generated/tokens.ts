export const portfolioTokens = {
  "version": 2,
  "brand": {
    "name": "Guilherme Brilhante Portfolio",
    "voice": "technical, measurable, direct"
  },
  "colors": {
    "ink": "#111827",
    "muted": "#64748B",
    "surface": "#F9FAFB",
    "panel": "#FFFFFF",
    "border": "#D1D5DB",
    "border_strong": "#B8C2CF",
    "accent": "#2563EB",
    "accent_soft": "#E8EFFF",
    "success": "#059669",
    "warning": "#D97706",
    "danger": "#DC2626",
    "nav": "#151B24",
    "nav_muted": "#99A6B7"
  },
  "spacing": {
    "xs": "4px",
    "sm": "8px",
    "md": "12px",
    "lg": "16px",
    "xl": "24px",
    "xxl": "32px"
  },
  "radii": {
    "control": "4px",
    "panel": "6px"
  },
  "sizing": {
    "icon_button": "38px",
    "navigation": "228px",
    "content_max": "1480px"
  },
  "breakpoints": {
    "mobile": "620px",
    "tablet": "860px",
    "compact_desktop": "1050px"
  },
  "shadows": {
    "subtle": "0 1px 2px rgba(15, 23, 42, 0.06)"
  },
  "typography": {
    "readme_heading": "short, claim-first, no marketing filler",
    "table_density": "compact",
    "code_font": "monospace"
  },
  "components": {
    "readme_header": {
      "required_items": [
        "project_number",
        "project_name",
        "claim",
        "benchmark_status"
      ]
    },
    "benchmark_card": {
      "required_items": [
        "metric",
        "value",
        "command",
        "dataset_or_fixture",
        "date"
      ]
    },
    "architecture_card": {
      "required_items": [
        "style",
        "reason",
        "dependency_rule",
        "rejected_alternatives"
      ]
    },
    "program_badge": {
      "required_items": [
        "program_id",
        "program_name"
      ]
    },
    "references_table": {
      "required_columns": [
        "source",
        "license",
        "reused_idea",
        "copied_code"
      ]
    }
  },
  "diagrams": {
    "style": "simple boxes, named boundaries, visible dependency direction",
    "required_for": [
      "clean-architecture",
      "hexagonal",
      "modular-monolith",
      "event-driven",
      "cqrs-event-sourcing",
      "pipeline"
    ]
  },
  "dashboards": {
    "default_panels": [
      "throughput",
      "latency",
      "error_rate",
      "benchmark_result"
    ]
  },
  "readme_rules": [
    "open with number, claim, and current benchmark result or pending status",
    "show one reproducible command before deep explanation",
    "include architecture decision summary",
    "include references and reuse disclosure",
    "avoid generic landing-page prose"
  ]
} as const;
