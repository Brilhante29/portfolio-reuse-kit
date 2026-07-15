# Plan Project Generator

`tools/plan-project.ps1` turns an existing portfolio repository into a concrete OpenSpec-style planning example.

It does not require OpenSpec to be installed. It uses the schema and component-pack rules already stored in this kit.

## Command

```powershell
$repoRoot = Join-Path $HOME "repos-github"
pwsh -NoProfile -File tools/plan-project.ps1 `
  -RepoPath (Join-Path $repoRoot "rag-knowledge-base")
```

Default output:

```txt
openspec/artifacts/
  intent.md
  portfolio-impact.md
  architecture-record.md
  component-pack.md
  reuse-delta.md
  benchmark-proof.md
  tasks.md
  verification.md
  article-draft.md
  voice-check.md
```

## What It Reads

- `project.yaml`
- `README.md`
- `sdd/spec.md`
- `sdd/technical-decision.md`
- benchmark JSON from `benchmark.result_path`
- `component-packs/manifest.yaml`
- `catalog/programs.yaml`

## What It Decides

- project identity and claim
- portfolio program
- component pack
- architecture, stack, API style, messaging, cloud posture, runtime, and database
- benchmark line and result path
- reusable improvement state
- article/post angle
- voice alignment with existing repository writing

## Voice Check

The voice check is deterministic. It compares the generated article with the existing README and SDD using:

- project number in the first line
- explicit claim
- benchmark evidence in the opening section
- architecture and rejected alternatives
- average sentence length
- bullet density
- hype-word count
- evidence-word count

The desired voice is:

- direct
- evidence-first
- benchmark-heavy
- specific about tradeoffs
- light on adjectives
- consistent across README, SDD, and public article

## Rules

- Do not overwrite existing generated artifacts unless `-Force` is used.
- Do not use external services.
- Do not require paid credentials.
- Treat generated artifacts as a first draft. The agent must still update them when implementation reveals better facts.
