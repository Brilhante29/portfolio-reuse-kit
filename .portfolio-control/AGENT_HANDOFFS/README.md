# Portfolio Control

This is the machine-assisted control plane for the 30-repository portfolio. The kit is the source of truth for templates, skills, decisions, validation, and reusable improvements; each project keeps a local snapshot under `.portfolio-control/`.

## Operating Rule

```text
problem -> architecture -> stack/API/messaging/cloud decision -> implementation -> Docker/CI -> benchmark -> independent review -> publication
```

`tools/validate-portfolio.ps1` audits every repository without requiring `rg`. `tools/backfill-project-standard.ps1` materializes the project snapshot, and `tools/new-project.ps1` creates it for new repositories.

The control plane is advisory about architecture and strict about evidence. A repository is not publishable because it has a plausible design; it needs a clean runtime, a green CI path, a reproducible result, aligned documentation, and a recorded reuse review.
