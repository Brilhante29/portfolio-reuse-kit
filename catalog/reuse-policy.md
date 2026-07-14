# Reuse Policy

Priorize as skills, templates, decision brain, SDD e harness deste kit. Use repos publicos como referencia e acelerador, nao como copia.

## Prioridade

1. Skills proprias em `.codex/skills/` e `.claude/skills/`.
2. Decisoes canonicas do kit: `decision-brain/`, `component-packs/`, `architecture/`, `language-profiles/`, `design-system/`, `sdd/`, `harness/` e `templates/`.
3. Padroes de repos externos que melhorem organizacao, contratos, testes, benchmarks, docs, agent workflow, schema ou DX.
4. Bibliotecas oficiais e dependencias quando resolverem melhor o problema do projeto.

Se uma referencia externa contradizer uma skill propria, a skill propria vence. Se a referencia externa for claramente melhor, atualize o kit primeiro ou registre backlog em `sdd/reuse-improvement-review.md`.

## Permitido

- Usar repos externos para aprender organizacao, fronteiras, padroes de pastas, workflow, SDD, validadores e benchmark.
- Usar bibliotecas oficiais como dependencia.
- Recriar arquitetura em outro dominio.
- Reaproveitar ideias de benchmark e contratos de API.
- Citar referencias em `REFERENCES.md`.
- Usar trechos pequenos somente se a licenca permitir e houver atribuicao.

## Evitar

- Substituir as skills proprias por componentes externos sem decisao registrada.
- Forkar exemplo e trocar nomes.
- Copiar estrutura inteira sem motivo.
- Usar codigo AGPL internamente sem entender obrigacoes.
- Publicar repo sem resultado reproduzivel.

## Obrigatorio em cada projeto

```md
## References

This project was informed by:
- <repo/doc>: <what was reused>

Implementation, fixtures, benchmark scripts and reported results are project-specific.
```
