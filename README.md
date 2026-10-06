# DARK: KUROYOMI

Nome atual do projeto: **Dark: Kuroyomi**. A Bíblia oficial de design e narrativa está no cofre Obsidian [biblia do jogo](biblia%20do%20jogo/00_INDEX.md).

- [Comece pelo índice](biblia%20do%20jogo/00_INDEX.md): encontre o domínio necessário sem ler toda a Bíblia.
- [Estado atual](biblia%20do%20jogo/01_ESTADO_ATUAL.md): decidido, aberto e fase de produção.
- [Contexto para IA](biblia%20do%20jogo/AI_CONTEXT.md): regras de leitura mínima e atualização.
- [Convenções do cofre](biblia%20do%20jogo/README.md) e [decisões](biblia%20do%20jogo/90_Decisoes/README.md).

## Design atual e implementação existente

A nova direção foi consolidada em documentação. O jogo existente continua sendo o **protótipo Amahara**, em `Amahara_Godot/`; gameplay, código, artes e nome do projeto Godot não foram alterados nesta reorganização. O repositório permanece `japao`.

Abra `biblia do jogo` como cofre no Obsidian. Para executar o protótipo, importe [project.godot](Amahara_Godot/project.godot) no Godot 4.6.1 e pressione F5; veja as [instruções técnicas históricas](Amahara_Godot/README.md). Executáveis locais continuam em `Jogar` e fora do Git; cache `.godot` é regenerado pela engine.

Diferenças entre o novo design e o código: [Estado do protótipo](biblia%20do%20jogo/60_Producao/Estado_do_Prototipo.md). Relatórios e resultados de Amahara descrevem execuções antigas, não validação de Dark: Kuroyomi.

## Histórico preservado

[Bíblia Amahara](AMAHARA_BIBLIA_MESTRA_COMPLETA.md), [documentos do protótipo](Amahara_Godot/docs/), [evidências](Amahara_Godot/evidence/) e [original HTML/JS](amahara_vertical_slice/) permanecem intactos. São fontes históricas, não canon novo. A classificação e cópias dos antigos pontos de entrada estão no [arquivo](biblia%20do%20jogo/99_Arquivo_Amahara/README.md).

Antes de avaliar comercialização ou planejar código, separe decisões atuais, propostas e o que de fato está implementado. Não trate metas de produção como promessa nem testes antigos como certificação comercial.
