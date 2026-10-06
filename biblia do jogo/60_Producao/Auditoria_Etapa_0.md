---
status: prototype
area: technical-audit
updated: 2026-10-06
read_when: "Avaliar a base Amahara antes de autorizar migração"
---
# Etapa 0 — auditoria técnica

## Conclusão

Amahara reduz trabalho de **fundação de combate e validação**, mas não fornece uma arquitetura de campanha pronta. Reaproveitar colisão, contrato de dano aceito, dados de ataques, evasão, controle de agressão e mecanismo de gravação tem valor. Transportar o controlador de partida, mapa e narrativa integralmente levaria as limitações da fase única para Kuroyomi.

Esta é uma fotografia do código, não aprovação da migração nem certificação comercial. Arquitetura futura e percentuais são propostas técnicas. Nenhum código, asset ou comportamento foi modificado. Fonte de design: [[02_VISAO_DO_JOGO]], [[20_Gameplay/Combate_Core]] e as notas específicas citadas abaixo. Bíblia antiga permanece histórica.

Consultas rápidas: [[60_Producao/Matriz_Reaproveitamento]], [[60_Producao/Plano_Migracao]], [[60_Producao/NexMotion_2D_Requisitos]], [[60_Producao/Baseline_Etapa_0]], [[60_Producao/Inventario_Etapa_0]].

## Método e escopo

Inspecionados integralmente os 23 scripts de runtime Godot, a cena principal, 22 Resources, configurações, nove scripts de testes e os seis geradores/ferramentas quanto a entradas, saídas e efeitos. Inventário recursivo cobre arquivos e hashes, incluindo legado, builds e evidências. O HTML/JS foi examinado como referência histórica, sem fingir uma segunda auditoria funcional equivalente à do Godot. Não foi necessário reler a Bíblia antiga inteira.

Checkout: `D:\NexStudio\projetos\japao`, HEAD `2a904f0f4410e26025193e507ddb2d80be8b4af6`. Havia alterações documentais locais da tarefa anterior. O texto antigo que afirma inexistência de Git está desatualizado; foi preservado como histórico. Testes executados em cópia byte a byte do código, fora do projeto editável, com resultados novos separados dos antigos.

Referências técnicas abaixo são caminhos relativos a `Amahara_Godot/`, com função/linha da versão auditada. [Inventário e hashes](Evidencias_Etapa_0/inventario.json) permitem identificar exatamente essa versão.

## Player e combate

`scripts/player.gd:41–123`: `CharacterBody2D`, cápsula, `move_and_slide`, diagonal limitada por `Input.get_vector`, velocidade proporcional à entrada analógica, quatro direções de facing. Estados são strings em uma máquina simples: idle/move, attack, dash, cast, hurt, dead. Não há controller de arco, lock-on, assistência de alvo ou parry/bloqueio.

`player.gd:141–187` e `attack_data.gd`: preparação/ativo/recuperação definidos em Resource; avanço só no ativo. Leve 1→2→3, pesado 1→2→3 e leve 2→pesado 3. Buffer guarda uma única intenção, substituível, com validade em tempo do ataque. Não guarda direção; `start_attack` não relê analógico. Portanto trocar direção/alvo entre golpes, as duas outras rotas mistas, pesado de dois golpes e ataques específicos pós-dash **não estão implementados**. Métodos públicos permitem iniciar ataques diretamente; a restrição normal depende do fluxo do controller, não de uma API defensiva completa.

`AttackData.cancel_time` é preenchido nos `.tres`, mas não consumido. `start_dash:189` rejeita ataque/cast/hurt/dash: não existe cancelamento por janela. A base de tempos e transições é aproveitável; precisa de regras explícitas de entrada, saída e cancelamento conforme [[20_Gameplay/Katana]]. Sem necessidade de framework gigante de estados.

`hitbox.gd:19–38`: `Area2D` retangular, alvos por instance ID em Dictionary limpo em `begin`. Só `sample` habilitado causa dano. O alvo é registrado **antes** de `receive_hit`; contato recusado também consome a tentativa daquele golpe. Energia/impacto só são confirmados quando o retorno é verdadeiro. Isso é coerente com single-hit, mas a semântica deve ser decidida para inimigos temporariamente invulneráveis. `finish` desabilita a amostragem lógica, não a shape. Overlaps da física não são uma varredura contínua: testes futuros devem cobrir mudança brusca da hitbox e projéteis rápidos.

`hurtbox.gd`: excelente peça pequena para reaproveitar; pressupõe ator `CharacterBody2D`. Contrato implícito exige `dead`, `receive_hit` e `confirm_hit`; hitbox não é totalmente desacoplada. Máscaras: mundo=1, corpo Ren=2, hurtbox Ren=4, hurtbox inimigo/boss=8, corpo inimigo=16. Clones exigirão facções/alvos explícitos, não duplicação de Ren com essas mesmas máscaras.

`player.gd:230–270`: dano aceito desconta HP, interrompe golpe, aplica knockback e iframes, emite morte/vida. Dash tem 0,18 s invulnerável, janela perfeita de 0,09 s e +12 energia uma vez; cooldown 0,62 s. Katana dá +6 por alvo aceito e há regeneração passiva 2,2/s. São **baseline antigo**, não números aprovados para Mana. Perfect Dodge/regen não emitem `energy_changed`; HUD lê valores a cada frame, ocultando essa lacuna para futura UI por sinais.

Hitstop é variável de `game.gd`, reduzida no `_process`; player, inimigos e boss retornam cedo, porém sprites, VFX, projéteis, cooldowns/iframes e parte dos timers não seguem todos o mesmo relógio. Não equivale a congelar toda a simulação. Knockback no pesado pode ser calculado sem movimento porque seu estado não entra em hurt; boss ignora força. Postura de inimigos/boss reseta imediatamente ao quebrar, sem regeneração temporal. Boa base de resistência, mas regras não são componentes universais.

## IA, grupos e encontros

`enemy.gd:70–161`: cinco tipos, estados idle/chase/return/telegraph/attack/recover/hurt/stagger/dead. Detecção por distância 225, retorno acima de 360; origem `home`. Todos miram diretamente `game.player`. Arqueiro/selo recuam quando perto **se não obtiveram antes um ataque**; não há seleção entre Ren e aliados. Corredor flanqueia com offset vertical simples; não é planejamento tático.

Rota AStar refeita por inimigo a cada 0,3 s; separação percorre `game.enemies` para cada agente em movimento, custo aproximadamente O(n²). Corpos não bloqueiam uns aos outros; separação não garante ausência de empilhamento. Distantes não surgem até aproximação, mas uma vez instanciados continuam processando idle/return; não há suspensão/despawn por região. Vetor `enemies` conserva referências inválidas até resets, embora os loops as filtrem.

`encounters.gd:33–41`: duas vagas globais, intervalo 0,32 s entre novas concessões, retenção durante telegraph/attack e liberação ao recuperar, interromper ou morrer. `tick` elimina referências inválidas. **Conceito de alto valor** para grupos heterogêneos. Não oferece prioridades, justiça de fila, orçamento por tipo ou limite de perigos persistentes: o token pode ser liberado enquanto a zona espiritual ainda aguarda/causa dano. Boss não solicita token. O limite atual não significa no máximo dois perigos simultâneos.

`encounters.gd:9–30,43–59`: cinco grupos/13 inimigos definidos em constante com coordenadas, vinculados a `story.stage`, cura fixa +18 e saves. Conclusão persiste pelo ID do grupo; morte individual em grupo incompleto não. Separar o coordenador de agressão (B, alto reaproveitamento) do conteúdo de encontros (D para Kuroyomi) e de um futuro `EncounterDefinition`/instância (B).

**Multialvo:** hitboxes e lista de alvos já permitem atingir vários inimigos. Fundação viável para grupos pequenos comprovados; não há evidência de estabilidade com dezenas, clones e múltiplas AoEs. Antes de otimizar, medir tempo de física/rotas, quantidade de perigos, leitura das antecipações e distribuição dos tokens em um slice representativo.

## Boss

`boss.gd:30–193`: controlador exclusivo `GeneralJinzo`. Seis `BossAttackData` parametrizam tempos/dano/raio/pose; comportamento continua em `match pattern.id`. Ciclos determinísticos de quatro e seis padrões, transição única aos 50%, invulnerabilidade durante transição, postura e recuperação. Há combo de três hitboxes, avanço, círculo, zonas, rajada de 12 projéteis e até dois espadachins vivos simultaneamente. Limite de vivos não limita total de invocações por luta.

Fases, antecipação, recuperação, sinal de morte e limpeza são reutilizáveis com adaptação. Atlas, texto, HP, limiar, ordem, poses, coordenadas de summons e nomes são Jinzō. Não existe troca genérica entre duas formas com corpo/visual distintos. `game.gd:136,340–364,383` cria boss, fecha arena, toca música, faz introdução, reseta tentativa inteira e grava vitória por stage=6. UI também conhece Jinzō e fase 1/2.

Vale extrair **um BossController pequeno + BossDefinition/PhaseDefinition + ações por composição**, com arena responsável por introdução/encerramento e escopo de efeitos/summons por tentativa. Não converter cada padrão em subclasses complexas nem criar um controlador inteiro por personagem. O conteúdo é **11 encontros de boss** (6+1 final+4 opcionais), sendo o final com duas formas; não dez frameworks. [[40_Conteudo/Bosses/README]].

## Magias, arco e alvos

`MagicData` contém custo, dano, cooldown, raio, velocidade e stagger. `player.cast` usa dois slots fixos e `if slot==0`; não há seleção, desbloqueios ou executor extensível.

| Magia futura | Base real | Trabalho necessário |
|---|---|---|
| [[20_Gameplay/Magias/Fogo_Azul]] | `CelestialSlash`, Area2D, direção, parede, lifetime e dano | Desacoplar `game.player.magics[0]`, remover texto de dano fixo “24”; dados de dono/facção, eventual burn e interação ambiental são novos |
| [[20_Gameplay/Magias/Onda_de_Impacto]] | Selo percorre todos os alvos em raio e aplica postura/força | Definir resistência, interrupção e alvo ambiental; atualmente ignora paredes/oclusão, não é AoE por overlap |
| [[20_Gameplay/Magias/Tornado]] | Desenho de anel e Area2D de `HostileEffect` servem de exemplo | Novo efeito aliado persistente: ticks por alvo, puxão, duração/limite e cleanup. Hazard atual é hostil e single-hit global |
| [[20_Gameplay/Magias/Clones]] | Corpos, hitbox, navegação e ciclo de spawn/morte são peças | Nova IA aliada e facções; desviar aggro de inimigo/boss, dois clones, vida/duração, somente básico, impedir recursão |

Projétil hostil tem ray/parede via contato de corpo; arqueiro tem raycast de linha de visão. Ambos são peças para arco, **não um arco parcial já jogável**. Inexistem modo L2, troca discreta por analógico direito, outline vermelho, elegibilidade/ordenação de alvos, tiro R2 e mecanismos ambientais acertáveis. Arco/Targeting são sistema novo; reaproveitar collider, lifetime e teste de oclusão após generalização. Não fixar munição/alcance nesta auditoria.

## Mundo, câmera, mapa

`world.gd:20–157`: uma única região física 96×24 tiles de 32 px (3072×768), chão em `TileMapLayer`, objetos Y-sort. **Colisões não são pintadas nos tiles**: `StaticBody2D` retangulares separados, registrados em `blocked`. TileSet de 23×4 variantes gerado em runtime. Casas, vegetação, NPCs, gates e pontos usam coordenadas no script; não há cenas de região/prop editáveis.

`rebuild_navigation:179–203`: grade 192×48 de 16 px, margem de obstáculos 8 px, diagonais sem cortar cantos; gates refazem grade completa. `route/nearest_free:279–303` procuram célula livre num quadrado ±3; se rota vazia, inimigo acaba seguindo direto ao alvo, podendo insistir no obstáculo. Não há streaming nem transição entre mapas. Persistem gate/segredos/grupos limitados ao snapshot; mundo físico é reconstruído a partir deles.

`game.gd:84–91,325–338`: Camera2D segue posição arredondada, sem smoothing, limites fixos; tremor por offset randômico. Nomes de regiões são faixas de X, não entidades de mundo. Não existe minimapa/mapa completo/descoberta; não confundir grade AStar com sistema de mapa. Estes serão novos, usando IDs de região e dados cartográficos próprios.

**Escala comercial:** construir mapas por código é tecnicamente possível, mas o modelo atual mistura autoria, colisão, navegação, narrativa e coordenadas em quatro arquivos. Para 10–12 capítulos/regiões, dificulta edição visual, revisão, diffs e teste de revisitação. Recomenda-se cenas de região com TileMapLayers, TileSet compartilhado, cenas de props/interações/spawn e Resources de conexões/encontros. Código fica com geração de variações, carregamento e regras, não com cada árvore. Carregar região atual e conexões necessárias; não adotar streaming complexo antes de medir. Capítulo não precisa corresponder a arquivo de região.

## NPC, diálogo, missões e progressão

`interaction.gd` é Area2D com info Dictionary e raio 44: detector reaproveitável. `nearest_interaction` prioriza Yuna por distância e depois o primeiro overlap, apesar do nome não ordenar por proximidade. Yuna/sobrevivente são props, sem controller de NPC.

`game.gd:203–282`: diálogos Array de pares falante/texto, pausa global e callback final. `match` por ID de interação contém narrativa e recompensas. Funciona na fase única, mas condições, conteúdo e execução não estão separados. Não há parser de diálogo, escolhas, quest journal nem definições de missão.

`StoryProgression`: stage monotônico 0–6, listas de upgrades/grupos e um boolean de atalho. `advance` aceita saltos, sem validar pré-condições; o bloqueio normal está no fluxo do jogo e parte da validação de save. `collect` deduplica IDs, mas não valida catálogo. Objetivos são sete strings indexadas. Para Kuroyomi, substituir essa orquestração linear por flags/IDs, estado de quest pequeno e condições/recompensas idempotentes. Reaproveitar snapshot, sinais e deduplicação como conceitos; não transportar índices numéricos como campanha nova.

Missões/desafios novos podem compartilhar `ObjectiveDefinition` (evento, condição, contagem), `QuestState` e recompensas por ID único. Eventos de combate, interação, ferramenta ambiental e descoberta cobrem os tipos pedidos. Nada exige linguagem de scripting de quests ou editor de grafos nesta fundação.

## Save, checkpoint e morte

`save_store.gd:13–58`: JSON versão 2, valida tipos, intervalo inteiro de stage, IDs permitidos, duplicados e algumas relações stage/checkpoint/encontros. Lê principal e depois backup. Migra v1 (`cleared`) de forma restrita para início/defesa da aldeia, não migração geral. Grava cópia de dados, força versão 2, valida, escreve `.tmp`, flush/close, copia principal **válido** para `.bak` e renomeia temporário sobre destino. Esta sequência tem alto valor de reaproveitamento.

Limites: rename testado no ambiente atual não prova durabilidade em perda de energia; não há fault injection, locking concorrente, checksum, validação de escrita relida nem cadeia geral de migrações. `.tmp` órfão não é recuperado. Campos desconhecidos não são rejeitados; consistência valida só parte dos estados. Backup recuperado é devolvido, não promove automaticamente o arquivo. Não alegar proteção absoluta contra corrupção.

Schema guarda checkpoint (dois IDs), stage, lista de upgrades (altar/memorial), grupos concluídos e atalho. Não guarda HP/posição arbitrária (restaura cheio), flags por boss, magias desbloqueadas, quests, mapa revelado ou vários atalhos. Não há save manual em menu/slots. Configurações em ConfigFile separado; erro de gravação de settings não é tratado.

Morte usa timer de 1,1 s, mantém progresso em memória, restaura checkpoint/HP/energia, recria boss e grupos incompletos, limpa projéteis/VFX. Não relê save em cada morte. `cancel_events` interrompe timers, limpa callback de diálogo e hitstop; `generation` é incrementado, mas não há checagem de geração em callbacks. A limpeza atual funciona para eventos conhecidos; não é ainda um cancelamento genérico de tarefas de região.

Recomendação: manter I/O e estratégia de backup com adaptação, separar codec/validador/migrações do modelo `WorldState`. Nova identidade de save e política explícita para legado; não mapear stage 6 de Amahara para campanha Kuroyomi automaticamente. Definir contrato cedo para todos os sistemas; implementar experiência completa de estátuas/save manual depois de mundo/quests.

## Input, UI, áudio e efeitos

InputMap é instalado em runtime por `input_config.gd`, não seção `[input]` do projeto. Movimento, quadrado/triângulo/círculo/X/Options e teclado já são base. L1/R1 lançam diretamente duas magias, D-pad move. Novo L1+D-pad exige impedir movimento enquanto seleciona; L2/R2 e right stick não existem. Instalação não elimina eventos antigos: chamá-la repetidamente pode duplicar bindings. F11 está fora do mapa, no controlador global. Sem remapeamento persistente, seleção de dispositivo ou recursos específicos DualSense.

O pedido desta auditoria apresenta Touchpad=mapa/Options=pausa como **mapeamento planejado**; a nota canônica ainda deixa Touchpad e menus pendentes. Não alterada silenciosamente: consolidar decisão na Etapa 1 antes do remapeamento. Referência: [[20_Gameplay/Controles]]. Testes sintéticos não equivalem a USB/Bluetooth físico.

`ui.gd`: CanvasLayer/Controls, tema e menus criados por código; foco de botões/sliders, pausa, continuar, opções, diálogo, objetivo, toast, boss HP/postura. Vida/energia já no superior esquerdo. Dois cooldowns textuais ficam embaixo à direita; nenhum seletor de quatro magias, minimapa, mapa, quests ou save manual. Atualização por polling, dimensões fixas 640×360 e textos de Jinzō. Reaproveitar controles/fluxos, extrair cenas de widgets e modelos de apresentação. Redesign visual é futuro, não concluído aqui.

`audio_system.gd`: um player de música com repetição em `finished`, oito vozes SFX reutilizadas em round-robin, controle de volumes e shutdown que libera streams. **Não existem buses Music/SFX dedicados**, todos usam bus padrão; volumes são propriedades dos players. Sem áudio posicional, crossfade/prioridades; valor zero vira 0,001 (não mute absoluto). Infra útil com adaptação; WAVs permanecem protótipo.

`fx.gd`: arrays de partículas desenhadas, arcos, anéis e números flutuantes; dash deixa bursts, projétil deixa rastro pontual. Não usa GPUParticles2D nem trails de geometria. `reverse` é armazenado mas `_draw` não muda o arco por ele. Fade de morte, tint/lanternas e camera shake existem. Não há screen shader/pós-processamento elaborado. Preservar helpers e configurar efeitos por dados; medir lotes/limites antes de pooling.

## Riscos e questões de baseline

| Sistema | Risco de migração | Evidência / mitigação proposta |
|---|---|---|
| Mundo e campanha | alto | Coordenadas/stage em world/game/director; migrar autoria para cenas e IDs antes de produzir regiões |
| Combate e animação | alto | Cancelamento não implementado, direção travada, arte e tempo desacoplados; contrato de timeline e teste em arena |
| IA/boss/clones | alto | Alvo único `game.player`, facções fixas, boss específico; separar alvos, orçamento de perigos e ciclo de tentativa |
| Persistência | médio | I/O útil, schema fechado e sem falhas de energia simuladas; namespace/versionamento cedo, fixtures de migração e corrupção |
| Validação/export | médio | Saída 0 não basta, testes antigos acoplados, QA incluído no export; gates por JSON/log e preset de produto futuro |

Nenhum risco crítico foi comprovado nesta auditoria. Observações estáticas não são bugs reproduzidos: avanço público pode reiniciar ataque, ray/overlap discreto, sinal de energia incompleto, mute mínimo, referências mortas e slot liberado antes de hazard terminar precisam testes direcionados conforme prioridade. Divergências de design (arco ausente, duas magias etc.) são escopo futuro, não falhas escondidas do baseline.

Problemas observados em execução e limites dos testes ficam em [[60_Producao/Baseline_Etapa_0]]. Não corrigidos para fazer a auditoria parecer verde. Arquitetura recomendada, dependências e critérios de cada etapa: [[60_Producao/Plano_Migracao]].
