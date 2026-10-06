---
status: validated
area: delivery
updated: 2026-10-06
---
# Entrega — Foundation e NexMotion 2D

**Etapas 1 e 2 concluídas e testadas sequencialmente.** O [gate da Etapa 1](Evidencias_Etapa_1/GATE_ETAPA_1.json) foi registrado antes de modificar o NexMotion. O [gate final](Evidencias_Etapas_1_2_Final/GATE_FINAL.json) consolida o reteste dos dois projetos.

## Etapa 1 — Foundation

**Implementado:** GameSession para sessão/morte/reset/respawn/checkpoint e invalidação de eventos; CombatHit com origem/atacante/alvo/dano/knockback/postura/direção/tipo/ID/propriedades; facções e registro de alvos sem dependência da classe Ren; IDs persistentes e duplicação detectável; WorldState v3 escalável e validado; contrato de animação PNG + JSON v1.

**Reaproveitado:** CharacterBody2D, hitboxes/hurtboxes Area2D, dados de ataques, dash, Perfect Dodge, energia, controle de agressão, save legado com backup e as 158 verificações anteriores.

**Alterado:** player/inimigo/boss passaram a receber o payload comum; hitbox, projétil e efeitos usam esse contrato; IA/boss consultam alvos hostis válidos; controlador delega ciclo de sessão. Save v3 tem arquivo separado e não converte automaticamente a narrativa v2. O controlador legado ainda contém mundo/progressão por coordenadas, reservados para a etapa futura de mundo.

**Testes:** 123 phase + 29 advanced + 6 settings + 50 Foundation = **208 PASS / 0 FAIL**, executados no projeto e novamente no export Windows. Percurso menu→conclusão, reabertura v2 e reabertura v3 em outro processo passaram nos dois ambientes. Headless import, export e cleanup normal também passaram. Comparação com Etapa 0: os 158 checks antigos continuam PASS.

**Regressões:** nenhuma nos cenários executados. O encerramento forçado `--quit-after` mantém o warning ObjectDB e o erro de recurso em uso que já existiam no baseline. Encerramentos normais dos testes ficaram limpos. O probe v3 precisou de anotação de tipo; como o executável exportado não executa o script standalone, o teste foi adaptado ao dispatcher QA e reexecutado. Tentativas anteriores e correções estão preservadas nos logs da Etapa 1.

**Preservação:** 23 arquivos originais conferidos pelo auditor; 86 arquivos protegidos sem alterações em arte/dados/builds históricos. O reteste final comparou 551 arquivos e não alterou nenhum deles durante os testes; userdata QA foi restaurado. Não houve remapeamento de controles nem novo conteúdo final.

Projeto editável: `D:\NexStudio\projetos\japao\Amahara_Godot`. Novo executável validado, separado dos anteriores: [Amahara_Foundation_Etapas_1_2.exe](<../../Jogar/Amahara_Foundation_Etapas_1_2.exe>). Continua sendo o conteúdo Amahara com a Foundation, não uma fase nova de Kuroyomi. [Hash e tamanho do export](Evidencias_Etapas_1_2_Final/export_entrega.json).

Detalhes técnicos: [[60_Producao/Foundation_Etapa_1]] e `Amahara_Godot/docs/FOUNDATION.md`.

## Etapa 2 — NexMotion 2D

**Implementado na ferramenta real:** `D:\ver animaçao`, aba **2D**, ao lado dos workspaces 3D existentes. Biblioteca de entidades, animações nomeadas, spritesheet/region/order/count, sequência PNG e importação de pacote. Nada foi duplicado dentro do jogo.

**Formato:** PNG + JSON versionado e determinístico, schema v1 formal, engine-agnostic. IDs, tipo, revisões/status, texturas, frames inteiros, durações/FPS, loop, direção opcional, pivôs/offsets, eventos e metadata extensível. O schema é idêntico nos dois projetos. Dois pacotes produzidos pelo NexMotion passaram também no validador GDScript de metadata; nenhum recurso Godot foi gerado.

**Preview:** playback, pausa, restart, frame a frame, scrub e timeline clicável com eventos; FPS/loop temporários, zoom nearest, pan/centralização, Checker/Claro/Escuro/Neutro. Pivot de clip ou de frame e offsets são inspecionáveis/editáveis. Cruz de apoio fixa, desenho em `apoio - pivot + offset`.

**Versões:** snapshots `vNNNNNN.anim.json`, ponteiro atual, backup, gravação validada/atômica e recuperação explícita. Arte nova no mesmo ID cria revisão sem apagar a anterior. Comparação lado a lado de PNGs diferentes foi executada. Status Draft/Review/Approved/Rework identificados; versões Approved antigas permanecem acessíveis.

**Eventos:** CRUD com ID, frame, nome customizado e payload JSON. Preview não executa ações do jogo. PNGs originais permanecem intactos. Cache evita parsing e recarga contínuos durante playback.

**Testes:** **215 testes Python PASS / 0 FAIL** (160 existentes + 55 novos). UI real: **47 verificações PASS** (33 principais, 9 de importação/versões, 5 de reabertura em processo separado). Editor nativo 3D: **47 checks PASS**, export/reimport GLB aprovado. Integração da janela 3D com novo clip, edição, autosave e reload também passou.

**Correção do baseline:** antes da integração, 159 dos 160 testes antigos passaram. A falha preexistente de hash em gravações rápidas no Windows foi corrigida com uma mudança localizada no cache; reteste antigo e reprodução com 200 mudanças consecutivas passaram. Não houve redesenho do comportamento 3D.

**Compatibilidade e preservação:** catálogo autoral com 3.103 animações preservado, banco logicamente idêntico ao backup, 3.272 fontes protegidas intactas. De 3.339 arquivos comparados, somente os dois arquivos de código previstos mudaram (`nex_window.py` e `processing.py`). O Qt registra diagnóstico DirectComposition `0x80004002`, mas WebGL/capturas/testes/export funcionaram; o log está preservado.

Guia: `D:\ver animaçao\GUIA_NEXMOTION_2D.md`. Relatório detalhado: `D:\ver animaçao\Reports\ANIMATION2D_FINAL.md`. Pacote técnico aprovado: `D:\ver animaçao\Exports\Animation2D\FixtureMarker_Approved_v3` — JSON e PNGs juntos. [[60_Producao/NexMotion_Etapa_2|Arquitetura e workflow]].

## Evidências

- Godot: [comandos e exit codes](Evidencias_Etapas_1_2_Final/execucoes.json), [preservação](Evidencias_Etapas_1_2_Final/preservacao.json), [contrato interoperável](Evidencias_Etapas_1_2_Final/contract_interop.json), JSONs de suites/percurso/reopen em `Evidencias_Etapas_1_2_Final` e `export/`.
- NexMotion: [execuções](Evidencias_Etapa_2/runs_final.json), [preservação](Evidencias_Etapa_2/preservation.json), [UI](Evidencias_Etapa_2/UI/result.json), [importação](Evidencias_Etapa_2/ImportUI/result.json), [reabertura](Evidencias_Etapa_2/ImportUI/reopen_result.json), [3D](Evidencias_Etapa_2/Regression3DFinal/browser_tests.json). Logs completos na instalação real, em `Reports/Animation2D`.
- Capturas reais: [biblioteca/playback/pivot](Evidencias_Etapa_2/UI/01_playback_library_pivot.png), [evento/timeline](Evidencias_Etapa_2/UI/02_event_timeline.png), [Approved/Rework](Evidencias_Etapa_2/UI/04_versions_comparison.png), [artes diferentes](Evidencias_Etapa_2/ImportUI/02_distinct_art_versions.png), [reabertura](Evidencias_Etapa_2/ImportUI/04_reopened_application.png).

## Limites e próxima etapa

Testes automatizados não certificam arte, dificuldade, sensação de controle ou DualSense físico. A auditoria web histórica continua com sua limitação de Chromium, separada dos testes Godot e Qt executados aqui. Importações e thumbnails grandes no NexMotion são síncronos; não foi certificada latência universal. Sequências PNG exigem canvas uniforme. Campos do inspector precisam ser aplicados antes de salvar. Novas revisões de arte exigem revisão de offsets/overrides.

**Etapa 3 — Pipeline NexMotion 2D ↔ Godot — pendente, não implementada.** Deverá validar pacotes aprovados e produzir derivados em pasta separada, preservar IDs/revisões/hashes, converter durações e pivôs corretamente e definir a política de emissão/cancelamento de eventos no gameplay. Fonte continuará PNG + JSON; `.tres` será derivado. Não presumir quatro direções nem pivô central.

**Novo Ren não iniciado.** Nenhum personagem final, mapa, boss, arco, quatro magias ou quests foi criado. Nenhum commit, push ou rename de repositório foi executado.
