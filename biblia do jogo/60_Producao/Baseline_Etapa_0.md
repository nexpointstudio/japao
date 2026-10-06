---
status: prototype
area: validation
updated: 2026-10-06
read_when: "Consultar testes realmente executados e problemas anteriores à migração"
---
# Baseline executado — Etapa 0

## Ambiente e preservação

Windows 10 build 19045, Godot **4.6.1.stable.official.14d19694e**, Compatibility configurado, execução **headless**. Engine: `D:\NexStudio\tools\godot-4.6.1\Godot_v4.6.1-stable_win64_console.exe`. Templates `4.6.1.stable` existentes. Data 06/10/2026. HEAD `2a904f0`; documentação local ainda não commitada. Sem commit/push nesta auditoria.

Projeto copiado para `.git/etapa0/Amahara_Godot`, sem `.godot`/evidências antigas; fontes/cenas/dados/arte originais não editados. Nova exportação em `.git/etapa0/Amahara_Baseline.exe`, **não substituiu Jogar/Amahara.exe**. Os arquivos QA de userdata preexistentes foram guardados/restaurados; saves normais não foram escritos pelos testes.

Inventário inicial de 367 arquivos, excluindo `.git` e cache `.godot`. Ao terminar as execuções, nenhum desses arquivos mudou; [preservação](Evidencias_Etapa_0/preservacao.json). Auditoria das 23 fontes originais também passou. Mudanças documentais posteriores e hashes finais ficam em `preservacao_final.json` na mesma pasta.

## Comandos e resultados

[execucoes.json](Evidencias_Etapa_0/execucoes.json) registra comandos completos, cwd, duração, código de saída e diagnóstico bruto. `G` abaixo é a engine; `P` a cópia; `E` esta pasta de evidências. Comandos sequenciais, pois o save QA é compartilhado. Para exportação, substituir `G --path P` pelo executável gerado e mudar E para `E/export`.

| Execução real | Comando resumido | Resultado desta auditoria |
|---|---|---|
| Versão | `G --version` | 4.6.1 confirmada |
| Import/editor | `G --headless --editor --path P --import` | Exit 0, sem ERROR/WARNING; importação limpa |
| Boot curto | `G --headless --path P --quit-after 10` | Inicializou, exit 0, **1 WARNING + 1 ERROR de cleanup**; não é encerramento limpo |
| Integração | `G --headless --path P -- --qa --evidence-dir=E` | **123 PASS / 0 FAIL**, sem ERROR/WARNING |
| Avançada | Mesmo prefixo, `--advanced` | **29 PASS / 0 FAIL**, sem ERROR/WARNING |
| Settings/animações | Mesmo prefixo, `--settings-qa` | **6 PASS / 0 FAIL**, sem ERROR/WARNING |
| Percurso | Mesmo prefixo, `--playthrough` | `pass=true`, stage 6, zero mortes, dois segredos, cinco grupos, atalho, uma transição do boss |
| Novo processo/save | Mesmo prefixo, `--verify-save` | `pass=true`, stage 6, 125 energia e dois upgrades |
| Limpeza áudio | `G --headless --path P --script res://tests/audio_cleanup.gd` | Exit 0, sem ERROR/WARNING; smoke de cleanup, não teste auditivo |
| Nova exportação | `G --headless --path P --export-release "Windows Desktop" .../Amahara_Baseline.exe` | Exit 0, sem ERROR/WARNING |
| Export: três suítes | EXE `--headless -- --qa/--advanced/--settings-qa --evidence-dir=E/export` em processos separados | **123+29+6 PASS / 0 FAIL**, sem ERROR/WARNING |
| Export: percurso + reopen | EXE com `--playthrough`, depois `--verify-save` | Ambos `pass=true`, sem ERROR/WARNING |
| Fontes originais | `python Amahara_Godot/tools/audit_sources.py` | **23 arquivos preservados** |
| HTML legado, lógica | `node amahara_vertical_slice/tests/logic_suite.js` | **BLOCKED**: `spawn chromium ENOENT`, exit 1 antes das verificações |
| HTML legado, smoke | `node amahara_vertical_slice/tests/cdp_smoke.js` | **BLOCKED** pelo mesmo requisito ausente; não alterado/instalado para esta auditoria |

São **158 verificações distintas do Godot**, executadas duas vezes (projeto e export), não 316 funcionalidades. Percurso/reopen/cleanup são provas separadas. Cabeçalhos “0 FAIL” constam na lista bruta de diagnósticos porque o coletor busca a palavra FAIL; isso não representa falha. Resultado validado pelos JSONs, não só exit code.

Percurso sem teleporte/edição de stats: começa emitindo o sinal do botão de menu e controla movimento/ações pelo InputMap. Não testa navegação física de menu por controle. Simulação acelerada 3×/180 physics ticks; 40,555 s e 41,708 s internos nos processos de projeto/export. Ambos `rendered=false`: FPS registrado é taxa de processo headless, **não benchmark gráfico**. Não observa necessariamente todos os padrões; fixtures fazem essa cobertura.

## Suíte inventariada e destino

| Arquivo atual | Tipo/cobertura | Destino na migração |
|---|---|---|
| `phase_suite.gd` | 123 verificações de integração: player, colisão, combo/buffer, dano aceito, single-hit, energia, dash, duas magias, cinco arquétipos, cinco composições de grupo, boss, saves e fluxo | B: manter invariantes; adaptar números, IDs, cenas e novos combos |
| `advanced_suite.gd` | 29: hazards, flecha/LOS, rota, pausa, fase 2, reset, checkpoint/recompensa, vitória e callback antigo | B: base forte, trocar Jinzō e mundo; usa helpers herdados de sample |
| `settings_suite.gd` | 6: disco, existência de clips, foco, progressão inválida/duplicada | B: adaptar contratos e ampliar tipos/novo input |
| `playthrough.gd` | Um percurso por bot, objetivos/combate até vitória | B: infraestrutura útil, rota/estratégia específicas viram E |
| `persistence_probe.gd` | Um check agregado em novo processo | B: ampliar estados/slots/migração, preservar prova entre processos |
| `audio_cleanup.gd` | Smoke de liberação de stream | A/B: manter, estender ao novo serviço/buses |
| `phase_capture.gd` | Nove capturas gráficas por fixtures que alteram posição/stage/HP | E/B: harness visual útil; **não executado nesta auditoria**; não é playthrough |
| `capture.gd` | Seis capturas do marco antigo | E: histórico, sem rota normal do game atual; não executado |
| `sample_suite.gd` | Antiga suíte de 53 checks documentados; lê campos antigos (`cleared`, `memorial_found`) e HP antigo | E: run antigo obsoleto, não executado como suíte atual. Helpers ainda usados por advanced; não deletar cegamente |
| `audit_sources.py` | Hashes de 23 arquivos | A: preservar proteção de origem; executado |
| HTML `logic_suite.js` | 47 casos `await t` + indicador PAGE_ERRORS; checks em runtime de browser com fixtures | E: tentativa bloqueada; T01–T70 do relatório antigo não equivalem a 70 testes independentes |
| HTML `cdp_smoke.js` | 9 checks nomeados + 3 saídas de movimento/ataque/dash; inclui teleporte/dano auxiliar | E: tentativa bloqueada; não percurso natural |

Não há suíte unitária pura independente bem separada. Mesmo validação de schema roda dentro de suites com cena completa. Contagens acima são checks de execução, não cobertura de linhas/branches; **cobertura percentual não medida**. Os nove arquivos de teste Godot não são nove suítes atuais equivalentes.

## Baseline issues e lacunas

- **BI-01 — encerramento forçado:** boot com `--quit-after` produz `ObjectDB instances leaked at exit` e `1 resources still in use at exit`. Normal `close_game` e smoke de áudio passam. Evidência em [boot.log](Evidencias_Etapa_0/boot.log). Compatível com bypass da rotina de encerramento, mas recurso exato não identificado; não alegar diagnóstico definitivo ou correção.
- **BI-02 — exit codes insuficientes:** advanced, playthrough e persistence encerram sem propagar resultado negativo ao exit code. Nesta execução seus JSONs passaram; pipeline futuro deve falhar por JSON ausente/negativo, timeout ou ERROR, não apenas por exit 0.
- **BI-03 — suite antiga e report generator:** sample tem expectativas/campos obsoletos; `delivery_report.py:30` exige que Git não exista e escreve manifests antes dessa asserção. Não executado; reexecutar hoje teria efeitos e falharia. Geradores antigos não são pipeline atual confiável.
- **BI-04 — export inclui QA:** preset `all_resources` exclui docs/tools/evidence, mas não `tests`; flags QA disponíveis no game. O export foi testável por isso. Revisar preset/entrypoints no produto futuro, sem removê-los agora.
- **BI-05 — browser histórico:** Chromium não encontrado pelo comando fixo dos dois scripts. Erro de ambiente, não FAIL de regra do jogo. Logs preservados.

Testes novos necessários: direção entre golpes/cancels/pós-dash; janelas sincronizadas com animação/hitstop; tiros rápidos/oclusão e target swap; facções/aggro de clones e cleanup; tornado por alvo; justiça de tokens e perigos concorrentes; todas as formas/bosses; transições/revisitação/mapa/quests; schema expandido/migração/falha de escrita; remapeamento e contextos D-pad; build sem testes. Stress/soak e desempenho renderizado ainda necessários.

DualSense físico USB/Bluetooth **não testado** (`controllers=[]`), sem avaliação humana de feeling/dificuldade, audição, arte final ou teste em outra máquina. Não foi feita nova captura gráfica; evidências visuais antigas continuam históricas. [[60_Producao/Plano_Migracao]] utiliza esse baseline sem promover limites a PASS.
