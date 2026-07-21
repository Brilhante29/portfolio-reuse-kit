# Portfolio Control

This is the machine-assisted control plane for the 30-repository portfolio. The kit is the source of truth for templates, skills, decisions, validation, and reusable improvements; each project keeps a local snapshot under `.portfolio-control/`.

## Operating Rule

```text
problem -> architecture -> stack/API/messaging/cloud decision -> implementation -> Docker/CI -> benchmark -> independent review -> publication
```

`tools/validate-portfolio.ps1` audits every repository without requiring `rg`. `tools/backfill-project-standard.ps1` materializes the project snapshot, and `tools/new-project.ps1` creates it for new repositories.

The control plane is advisory about architecture and strict about evidence. A repository is not publishable because it has a plausible design; it needs a clean runtime, a green CI path, a reproducible result, aligned documentation, and a recorded reuse review.

## Truthful Status, Handoff, and Efficiency

`tools/validate-portfolio.ps1` reports separate `local_candidate` and `published_verified` states. A benchmark only counts when it is tracked and follows the shared result contract. Publication only counts when the repository has an upstream and central CI evidence for its current commit.

Keep `.portfolio-control/CURRENT_HANDOFF.md` current before expensive work or a possible limit. It must contain state, evidence, decisions, commands already run, remaining work, and exact continuation steps.

Record execution friction as it happens:

```powershell
./tools/record-execution-event.ps1 -EventId audit.wait-1 -Phase validation -Category wait-timeout -Outcome recovered -Occurrences 1 -DurationSeconds 60 -Avoidable -Evidence "Worker returned no progress" -Cause "Waited without a progress gate" -Remediation "Inspect after one 60-second wait and take over after two no-progress observations"
./tools/report-execution-efficiency.ps1
```

Windows explicitly attributed to the user or external tools remain in the event history with `excluded_from_efficiency=true`; they do not alter the Codex score.

After pushing and after Actions completes, collect current-head evidence:

```powershell
./tools/verify-github-publication.ps1 -RepoRoot <portfolio-root>
```
