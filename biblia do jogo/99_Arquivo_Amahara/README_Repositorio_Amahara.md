# Amahara — Juramento de Guerra

Projeto Godot 4.6.1/GDScript de um action-adventure top-down. A implementação atual cobre a **Fase 1: O Primeiro Sino**, da aldeia ao encontro com Jinzō e sua conclusão. A campanha expandida descrita na Bíblia contém propostas que não fazem parte do jogo implementado.

Este repositório reúne código-fonte, cenas, Resources de balanceamento, artes, áudio, testes, capturas e documentação. Executáveis Windows e o cache `.godot` ficam fora do Git. Os executáveis locais continuam na pasta `Jogar`; a pessoa que clonar o repositório pode abrir o projeto no Godot e exportá-los novamente.

## Abrir o projeto

1. Instale Godot 4.6.1.
2. Importe [Amahara_Godot/project.godot](Amahara_Godot/project.godot).
3. Aguarde a importação das imagens e sons e pressione F5.
4. Para gerar Windows, instale os templates de exportação da mesma versão e use o preset `Windows Desktop`.

Controles e comandos de teste: [README do jogo](Amahara_Godot/README.md).

## Por onde começar a análise

| Conteúdo | Local |
|---|---|
| Resultado implementado e limites da entrega | [Relatório final](Amahara_Godot/docs/12_MILESTONE_REPORT.md) |
| Cobertura dos testes e validações não realizadas | [Relatório de testes](Amahara_Godot/docs/11_TEST_REPORT.md) |
| Arquitetura e persistência | [Arquitetura](Amahara_Godot/docs/10_ARCHITECTURE.md) |
| Regras executáveis | [scripts](Amahara_Godot/scripts) e [data](Amahara_Godot/data) |
| Testes reproduzíveis | [tests](Amahara_Godot/tests) |
| Capturas, logs e resultados registrados | [evidence/final](Amahara_Godot/evidence/final) |
| Arte, origem e prompts | [Direção de arte](Amahara_Godot/docs/09_ART_DIRECTION.md) e [ART_PROMPTS](Amahara_Godot/docs/ART_PROMPTS.md) |
| Código original preservado | [amahara_vertical_slice](amahara_vertical_slice) |
| Lore e propostas de campanha | [Bíblia](AMAHARA_BIBLIA_MESTRA_COMPLETA.md) |

Os relatórios da entrega registram 158 verificações automatizadas aprovadas, um percurso até a conclusão e recuperação do save em outro processo. São evidências daquela execução, não uma certificação comercial. Teste físico de DualSense, avaliação humana de dificuldade, sensação do controle e mixagem permanecem identificados como não validados.

## Roteiro para uma revisão independente

Ao pedir análise a uma IA ou a outra pessoa, use uma solicitação como esta:

> Analise o código e as evidências deste repositório para avaliar a maturidade da Fase 1 e o trabalho necessário antes de uma possível comercialização. Comece pelo relatório final e pelo relatório de testes, mas confira as afirmações no código. Separe implementado, proposta e não verificado. Cite arquivos e linhas para problemas técnicos. Avalie combate, progressão, save, interface, desempenho, acessibilidade, qualidade/consistência da arte e áudio, testes e processo de distribuição. Identifique quais informações sobre origem e direitos dos assets ainda precisam ser verificadas. Não trate testes automatizados nem texto da Bíblia como prova de qualidade, aprovação jurídica ou demanda comercial. Entregue prioridades e um plano de playtest humano; não invente resultados de execução.

A análise de código é uma parte da avaliação. O jogo precisa também ser jogado por pessoas para avaliar ritmo, dificuldade, clareza e interesse. A origem e as condições de uso dos assets precisam ser verificadas separadamente de sua qualidade visual.

## Histórico e arquivos grandes

Os documentos da primeira entrega mencionam uma pasta sem Git e um caminho anterior. São registros históricos. O projeto agora está versionado neste repositório, após a mudança para `D:\NexStudio\projetos\japao`.

O primeiro commit local de conteúdo foi ajustado antes do envio para excluir apenas executáveis, cache do Godot e layout local do Obsidian. Código, artes de origem, áudio, documentos e evidências foram mantidos. Os `.exe` não são necessários para analisar o código. Para distribuir builds no GitHub, use arquivos de uma Release, conforme a [documentação de arquivos grandes do GitHub](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github); nenhuma Release é criada por este README.
