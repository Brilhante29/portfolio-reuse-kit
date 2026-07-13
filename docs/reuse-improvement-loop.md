# Reuse Improvement Loop

The reuse kit must improve while portfolio projects are built.

Every project cycle includes a review that asks whether the current work exposed something reusable: a missing template, weak validation, unclear skill, repeated decision, missing metric, local-first adapter pattern, or benchmark helper.

## Rule

Do not keep repeating friction manually. If a project reveals a reusable improvement, classify it:

| Classification | Meaning | Action |
|---|---|---|
| `patch_now` | Low-risk and clearly reusable. | Patch `portfolio-reuse-kit`, validate, commit, and push before publishing the dependent project. |
| `backlog` | Useful but needs broader design. | Record it in `sdd/reuse-improvement-review.md`. |
| `reject` | Project-specific, premature, duplicated, or harmful. | Document the rejection briefly. |

## Trigger Points

Run the review:

- after scaffold
- after architecture decision
- after the first working slice
- after the benchmark result
- before publication
- after CI failure

## Questions

- Did this project reveal a repeated decision that belongs in the kit?
- Did it need a template, schema, script, Docker pattern, benchmark helper, or skill future projects will need?
- Did any agent instruction feel ambiguous enough to cause a bad implementation choice?
- Did local-first execution need a reusable adapter or parity-test pattern?
- Did the benchmark expose a missing metric or result shape?
- Did validation miss something that should become a gate?

## Boundary

Upstream reusable process and infrastructure. Do not upstream project-specific business/domain code.
