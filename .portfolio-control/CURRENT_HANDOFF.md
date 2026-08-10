# Current Handoff

Updated: 2026-08-10
Purpose: observable continuation state; no private chain-of-thought.

## Continuation Order

1. Read this file, `TRACKER.json`, `PROJECT_QUEUE.md`, and the active program document.
2. Verify final `main` SHA and exact-head CI before changing a completed repository.
3. Keep one macro active and apply only reuse improvements observed in multiple repositories.

## Current Truth

AI Evaluation and Retrieval Systems is complete:

| # | Repository | `main` head | CI run |
|---:|---|---|---:|
| 2 | `llm-eval-harness` | `5aaf544` | `31347740607` |
| 3 | `rag-knowledge-base` | `ee46136` | `31347697814` |
| 8 | `embeddings-benchmark` | `bfff98e` | `31347801700` |
| 9 | `llm-agent-eval` | `6d10362` | `31347790507` |
| 10 | `prompt-ab-testing` | `0971e12` | `31347782233` |
| 30 | `cost-aware-inference` | `90f8a0d` | `31347773690` |

## Decisions

- Use exact producer SHA plus versioned artifact for cross-repository edges.
- Keep provider execution outside evaluator cores; local Ollama/OpenAI-compatible adapters remain replaceable.
- Preserve ties, low scores, planner errors, and tool errors as evidence.
- Pin model digest/revision and fail on drift.

## Exact Next Action

Publish this kit branch to `main`, require exact-head CI green, then select one next macro. Do not reopen these six unless CI regresses or a new workload version is approved.
