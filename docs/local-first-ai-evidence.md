# Local-first AI Evidence

The reusable boundary is `producer -> versioned artifact -> evaluator`, not a shared runtime library.

- Provider adapters may use Ollama, OpenAI-compatible HTTP, FastEmbed, or cloud equivalents.
- Evaluators consume files and domain ports only.
- Cross-repository consumers pin producer repository, commit, and artifact schema.
- Model identity uses an immutable digest or revision; Docker build/runtime fails on drift.
- Provenance includes source/image/model/input/output/workload/failures/tokens/latency/cost scope.
- Generation may use an explicit local network; evaluation of committed evidence must work offline.

This pattern was extracted from `rag-knowledge-base -> llm-eval-harness`, `prompt-ab-testing`, `llm-agent-eval`, `embeddings-benchmark`, and `cost-aware-inference`.
