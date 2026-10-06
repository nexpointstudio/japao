# Relatório de validação — Amahara: Juramento de Guerra

Data da validação: 2026-10-04.

Ambiente: Chromium headless + validação lógica por runtime. O ambiente de execução bloqueia navegação direta para `localhost` e `file://`; por isso os scripts do projeto foram injetados em uma página vazia do Chromium para testar o runtime real de Canvas/JavaScript. Isso não altera o código entregue.

## Resultado T01–T70

| Teste | Resultado | Evidência / observação |
|---|---|---|
| T01 movimento | PASS | Smoke test com KeyboardEvent moveu o jogador. |
| T02 diagonal | PASS | Runtime confirmou vetor diagonal normalizado para magnitude 1. |
| T03 facing | PASS | Movimento à direita atualizou facing para `right`. |
| T04 colisão | PASS | Runtime confirmou bloqueio em água/obstáculo. |
| T05 câmera | PASS | Camera follow respondeu à alteração de posição. |
| T06 Combo 1 | PASS | Cadeia rápida alcançou o 3º golpe `Corte Descendente`. |
| T07 Combo 2 | PASS | Cadeia pesada alcançou `Lâmina do Estandarte`. |
| T08 hitboxes | PASS | Hitbox de ataque reduziu HP de hurtbox inimiga. |
| T09 single-hit protection | PASS | Mesmo attack instance não reaplicou dano ao mesmo alvo. |
| T10 dash | PASS | Smoke test entrou em estado `dash`. |
| T11 dash cooldown/recovery | PASS | Segundo dash imediato foi bloqueado pelo cooldown. |
| T12 dash i-frames | PASS | Dano aplicado durante dash não reduziu HP. |
| T13 magia 1 | PASS | `Corte Celeste` gerou projétil. |
| T14 magia 2 | PASS | `Selo de Ruptura` causou dano em alvo dentro da área. |
| T15 custo de energia | PASS | Energia foi consumida de acordo com balance data. |
| T16 sem energia impede cast | PASS | Com energia 0, projétil não foi criado. |
| T17 receber dano | PASS | HP caiu e estado `hurt` foi acionado. |
| T18 morrer | PASS | HP fatal gerou `dead/dead state`. |
| T19 respawn | PASS | Respawn restaurou HP e posição do checkpoint. |
| T20 analógico | BLOCKED | Physical controller unavailable. Mapeamento lógico Gamepad API implementado. |
| T21 D-pad | BLOCKED | Physical controller unavailable. Mapeamento lógico Gamepad API implementado. |
| T22 ataque principal | BLOCKED | Physical controller unavailable. Botão padrão 2 / Quadrado mapeado. |
| T23 ataque secundário | BLOCKED | Physical controller unavailable. Botão padrão 3 / Triângulo mapeado. |
| T24 dash | BLOCKED | Physical controller unavailable. Botão padrão 1 / Círculo mapeado. |
| T25 magia 1 | BLOCKED | Physical controller unavailable. L1 mapeado. |
| T26 magia 2 | BLOCKED | Physical controller unavailable. R1 mapeado. |
| T27 interação | BLOCKED | Physical controller unavailable. X/A padrão mapeado. |
| T28 pause | BLOCKED | Physical controller unavailable. Options/Start mapeado. |
| T29 spawn | PASS | Validado nos 4 arquétipos. |
| T30 detection | PASS | Validado nos 4 arquétipos. |
| T31 movement | PASS | Validado para melee; archer usa manutenção de distância. |
| T32 attack | PASS | State machines e transições de ataque executadas no runtime. |
| T33 receive damage | PASS | Validado nos 4 arquétipos. |
| T34 knockback/stagger | PASS | Estado `hurt` e vetor de knockback validados; heavy usa resistência. |
| T35 death | PASS | Validado nos 4 arquétipos. |
| T36 cleanup | PASS | Entidades mortas entram em cleanup por `deathTimer`. |
| T37 múltiplos inimigos | PASS | Cinco inimigos coexistiram no runtime. |
| T38 nenhum stun-lock infinito | PASS | I-frames impediram dano imediato duplicado. |
| T39 attack spacing | PASS | Coordenação limitou ataques simultâneos a no máximo 2. |
| T40 ranged + melee juntos | PASS | Arqueiro e espadachim coexistiram/atualizaram sem erro. |
| T41 NPC | PASS | Interação com Yuna abriu diálogo narrativo. |
| T42 diálogo | PASS | Fila de diálogo avançou corretamente. |
| T43 interação | PASS | Detecção contextual de interactable validada. |
| T44 segredo | PASS | Altar secreto foi detectado e ativado. |
| T45 upgrade | PASS | Segredo aumentou Max Divine Energy em +25. |
| T46 shrine | PASS | Shrine restaurou HP e energia. |
| T47 checkpoint | PASS | Checkpoint foi atualizado para o santuário. |
| T48 entrada da arena | PASS | Story gate acionou boss trigger. |
| T49 boss intro | PASS | Intro abriu diálogo e estado inicial do boss. |
| T50 Phase 1 | PASS | Boss iniciou em fase 1. |
| T51 ataques Phase 1 | PASS | Combo melee foi telegraphado e executado. |
| T52 telegraphs | PASS | Telegraph gerou sinal visual/ring antes do ataque. |
| T53 transition Phase 2 | PASS | HP < 50% acionou transição. |
| T54 nova mecânica | PASS | Phase 2 invocou dois mortos uma única vez. |
| T55 ataques Phase 2 | PASS | Ataque `grave` gerou 8 projéteis sobrenaturais. |
| T56 damage | PASS | Boss recebeu dano quando vulnerável. |
| T57 boss death | PASS | HP fatal mudou para estado morto. |
| T58 victory | PASS | Fluxo smoke chegou a `bossDefeated` e abriu vitória. |
| T59 menu | PASS | Menu foi exibido após `returnMenu`. |
| T60 controles | PASS | Painel de controles abriu corretamente. |
| T61 pause | PASS | Pause state e painel foram acionados. |
| T62 HUD | PASS | Render completo executou sem exceção. |
| T63 energy | PASS | HUD usa o mesmo recurso cujo consumo foi validado. |
| T64 boss HP | PASS | Render do HUD com boss ativo executou sem erro e HP inicial correto. |
| T65 victory screen | PASS | Smoke end-to-end confirmou painel de vitória visível. |
| T66 sprites sem blur | PASS | `imageSmoothingEnabled=false` validado no contexto Canvas. |
| T67 integer/pixel scaling adequado | PASS | Canvas interno 480×270 e CSS `image-rendering: pixelated`. |
| T68 cenário coerente | PASS | Revisão visual das capturas de aldeia e arena do boss. |
| T69 personagem legível | PASS | Revisão visual confirmou silhueta distinta do protagonista e inimigos. |
| T70 VFX não escondem gameplay | PASS | VFX limitados a rings/trails/partículas curtas; revisão visual sem obstrução dominante. |

## Smoke end-to-end executado

O script `tests/cdp_smoke.js` validou: boot, invasão da aldeia, limpeza da primeira onda, liberação da floresta, segredo, checkpoint, boss spawn, Phase 2, vitória, movimento, estado de ataque e dash. Resultado final: **12/12 checks PASS**, sem exceções de página após a correção do ring VFX.

O script `tests/logic_suite.js` validou lógica de movimentação, normalização diagonal, facing, colisão, câmera, combos, hitbox, single-hit protection, dash, i-frames, magias, energia, morte/respawn, quatro arquétipos de inimigos, combate em grupo, exploração, checkpoint, boss, UI e pixel-perfect. Resultado: todos os checks executados em **PASS** e `PAGE_ERRORS: PASS`.

## Edge cases revisados

- atacar durante morte: estado `dead` impede update de ação;
- magia sem energia: bloqueada;
- dash em parede/água: usa o mesmo resolvedor de colisão da movimentação;
- inimigo morto atacando: `dead` retorna antes da IA;
- projectile eterno: todo projétil possui `life` e bounds cleanup;
- Phase 2 duplicada: protegida por `phase===1` e flag `summoned`;
- morrer durante boss: fluxo de morte mantém checkpoint; boss permanece no mundo;
- pausa durante diálogo/cutscene: pause manual é bloqueado enquanto diálogo está ativo;
- respawn duplicando inimigos: respawn não chama spawn de waves;
- jogador fora do mapa: clamp + borders;
- diálogo com movimento ativo: update do jogador é interrompido durante diálogo;
- controle desconectando: ausência de gamepad volta naturalmente ao teclado.

## Bugs encontrados e corrigidos durante validação

1. Um ring de VFX podia produzir raio negativo no Canvas após a morte do boss e interromper o game loop com `IndexSizeError`. Corrigido armazenando `startLife` e clampando o raio mínimo.
2. A primeira composição da aldeia ficava visualmente vazia na câmera inicial. Casas, árvores, cercas e lanternas foram redistribuídas e a primeira wave aproximada do jogador.
3. O boss aparecia muito próximo da borda direita da câmera na intro. Sua posição e decoração da arena foram ajustadas.
4. Foi adicionada barreira de arena dinâmica para impedir recuo pelo torii durante a boss fight.

## Limitações reais restantes

- T20–T28 continuam `BLOCKED` até teste físico com um DualSense conectado em navegador compatível.
- O playthrough completo foi validado de forma automatizada com helpers de teste para acelerar combate/progressão. Não substitui um playtest humano de balanceamento e sensação de 10–15 minutos.
- Áudio é procedural via Web Audio; não há trilha musical gravada nem pacote externo de SFX.
- A Pixel Art é procedural/desenhada por código. Não usa spritesheets desenhados à mão por artista, embora já evite placeholders geométricos puros e apresente personagens, armaduras, casas, torii, vegetação, lanternas e cenário identificáveis.
