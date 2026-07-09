# Portfolio Reuse Kit

Repositorio base para construir os 30 projetos com o mesmo padrao de qualidade: Docker, README com numero, SDD, benchmark reproduzivel, referencias e skills para agentes.

Este repo nao e um dos 30 projetos. Ele e a fabrica dos projetos.

## O que ele prove

- `catalog/`: matriz dos 30 projetos, stacks e metricas.
- `sdd/`: templates de especificacao antes de codar.
- `harness/`: scripts para rodar benchmark e comparar resultados.
- `templates/`: README, Dockerfile, CI e estruturas reutilizaveis.
- `.codex/skills/`: skills para Codex usar dentro do repo.
- `.claude/skills/`: skills equivalentes para Claude Code.
- `tools/`: instaladores e validadores locais.

## Fluxo recomendado

1. Escolha um projeto no `catalog/projects.yaml`.
2. Crie uma pasta nova a partir dos templates.
3. Preencha `sdd/spec.md` antes de implementar.
4. Rode o benchmark com `harness/bench.py` ou um script especifico.
5. Grave o resultado em `benchmarks/results/`.
6. Abra o README com o numero do projeto e o principal resultado.

## Regras dos 30 rochedos

- Um comando Docker documentado.
- Um benchmark reproduzivel.
- Um numero no topo do README.
- Um `REFERENCES.md` com repos e docs usados como referencia.
- Nada vazio, nada pinado sem resultado.

## Skills

As skills estao duplicadas em `.codex/skills` e `.claude/skills` para uso por projeto. Para instalar em outro repo, copie essas pastas para a raiz do repo alvo, ou use:

```powershell
powershell -ExecutionPolicy Bypass -File tools/install-project-skills.ps1 -TargetRepo C:\path\to\repo
```

Para instalacao pessoal, copie cada skill para:

- Codex: `~/.codex/skills/<skill-name>/SKILL.md`
- Claude Code: `~/.claude/skills/<skill-name>/SKILL.md`

As skills usam somente `name` e `description` no frontmatter para manter compatibilidade simples.

## Ordem inicial

1. `rag-knowledge-base`
2. `spring-hexagonal-payments`
3. `mini-aws-emulator`
4. `mlops-end2end`
5. `yolo-training-pipeline`
