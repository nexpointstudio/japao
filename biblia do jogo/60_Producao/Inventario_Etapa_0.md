---
status: prototype
area: repository-inventory
updated: 2026-10-06
read_when: "Localizar código, dados, assets, ferramentas e evidências do baseline"
---
# Inventário técnico — Etapa 0

Fotografia de 06/10/2026. Inventário completo: [367 arquivos, tamanhos e SHA-256](Evidencias_Etapa_0/inventario.json), excluindo `.git`, `.godot` e a própria pasta de novas evidências. A lista inclui documentos locais ainda não versionados; não equivale à lista de arquivos do commit. [Classificação por arquivo](Evidencias_Etapa_0/classificacao_arquivos.json) complementa a [[60_Producao/Matriz_Reaproveitamento|matriz por sistema]].

## Estrutura e runtime

| Caminho relativo ao repositório | Conteúdo / papel |
|---|---|
| `Amahara_Godot/project.godot` | Godot 4.6, main scene, Compatibility, viewport 640×360/janela 1280×720, nearest, escala inteira; sem autoloads/plugins definidos |
| `Amahara_Godot/scenes/Main.tscn` | Única cena serializada: Node2D com game.gd. Demais Nodes criados em código |
| `Amahara_Godot/scripts/` | 23 GDScripts, 2.355 linhas; não são 23 sistemas independentes |
| `Amahara_Godot/data/` | 22 Resources `.tres`, sem banco/plugin externo |
| `Amahara_Godot/assets/` | Seis PNGs + 13 WAVs e seus `.import`; classificação abaixo |
| `Amahara_Godot/tests/` | Nove scripts Godot e UIDs; cobertura/destino em [[60_Producao/Baseline_Etapa_0]] |
| `Amahara_Godot/tools/` | Seis scripts Python, leitura/geração descritas abaixo |
| `Amahara_Godot/evidence/` | Logs/JSON/PNG de amostra e fase; `final/export` é prova histórica da entrega anterior |
| `Amahara_Godot/docs/` | 00–12, ART_PROMPTS e manifesto de fontes; `history` conserva marco anterior |
| `Amahara_Godot/export_presets.cfg` | Windows x86_64 release, PCK embutido, sem assinatura; testes incluídos pelo filtro atual |
| `Jogar/` | Amahara.exe, Amahara_Amostra.exe, instruções; builds locais ignorados pelo Git, preservados |
| `amahara_vertical_slice/` | 22 arquivos originais HTML/CSS/JS/docs/tests/launcher: referência E, não runtime Godot |
| `AMAHARA_BIBLIA_MESTRA_COMPLETA.md` | 23ª fonte protegida; histórica, não canon Kuroyomi |
| `biblia do jogo/` | Cofre atual, fontes canônicas, propostas e arquivo; `.obsidian` configurações locais |
| `README.md`, `AGENTS.md`, `.gitignore`, `.gitattributes` | Roteamento/convencões e controle de fontes; não são gameplay |

Não encontrados framework de mapa/minimapa, editor de quests, pipeline NexMotion, CI/workflow de build, addon de testes ou gerenciador de dependências do runtime. Cache `.godot` é derivado local e não fonte. Não existe infraestrutura de rede/contas necessária ao jogo auditado.

## Índice de scripts

| Arquivos em `Amahara_Godot/scripts` | Responsabilidade real |
|---|---|
| `game.gd` (445 linhas) | Sessão, construção, câmera, diálogo/conteúdo, entrada global, morte, save/settings e boot QA |
| `player.gd` (295) | Movimento/estados/combos/dash/magias/HP/energia e apresentação |
| `attack_data`, `hitbox`, `hurtbox` | Tempos/configuração e contato/dano aceito |
| `enemy`, `enemy_data`, `encounters` | Cinco papéis, IA, slots, spawns e conclusão de grupos |
| `boss`, `boss_attack_data` | Jinzō e seis padrões, duas fases |
| `projectile`, `hostile_effect`, `magic_data` | Corte Celeste, tiros/zonas hostis e dados das duas magias |
| `world` (340), `interaction` | Mapa programático, TileSet, colliders, AStar, luz e sensores |
| `progression`, `upgrade_data`, `save_store` | Stage/segredos/checkpoint, recompensas e JSON/backup |
| `catalog` | Carregamento fixo de ataques e recortes/animações |
| `input_config`, `ui` (276) | InputMap runtime e controles/telas construídos por código |
| `audio_system`, `fx` | Players e vozes; partículas/figuras/texto desenhados |

## Resources

7 AttackData: `light_1/2/3`, `heavy_1/2/3`, `enemy_slash`.
5 EnemyData: `enemy_swordsman/runner/heavy/archer/seal`.
6 BossAttackData: `boss_combo/charge/wide/spirit/radial/summon`.
2 MagicData: `celestial`, `rupture`.
2 UpgradeData: `altar`, `memorial`.

Tipos de Resource são código B (adaptar). Os valores/IDs atuais são protótipo E; não exportar automaticamente como balanceamento aprovado de Kuroyomi. `cancel_time` é exemplo de campo existente que não governa o runtime. Não há Resource serializado de região, diálogo, quest, boss completo, SpriteFrames ou save schema.

## Assets e proveniência

| Asset/grupo | Classificação e uso possível |
|---|---|
| `ren_atlas.png` 1774×887 e `ren_actions.png` 1254×1254 | E: protótipo para exercitar importação/poses; não Ren final |
| `enemies_atlas.png` 1254×1254 | E: papéis como comparação; revisão/substituição visual futura |
| `jinzo_atlas.png` 1774×887 | E: referência histórica do boss antigo, não reutilizar identidade como novo boss |
| `props_atlas.png` 1254×1254 | E: cenário/NPC/inimigo; alguns props potencialmente reutilizáveis após aprovação individual, pivôs/recortes e revisão de escala |
| `title.png` 1672×941 | E: ilustração de menu antigo; não define Visual Target comercial |
| `audio/village.wav`, `boss.wav` | E: música de protótipo; gerador disponível, não avaliação sonora final |
| 11 WAVs `slash/heavy/hit/hurt/dash/magic1/magic2/perfect/warn/ui/shrine` | E: placeholders; infraestrutura/gerador potencialmente reaproveitáveis, seleção sonora depende de revisão |
| `.import` e `.uid` | Metadados técnicos a preservar; .godot importado é regenerável |
| Chão/água/luz/VFX em código | B para mecanismos; aparência E. Não há sprites de tiles externos omitidos |
| Capturas em `evidence` e executáveis em `Jogar` | E: evidência/histórico, não fonte de arte final |

`docs/ART_PROMPTS.md` registra seis imagens geradas e desvios de dimensão; este é registro de proveniência do protótipo, não auditoria independente de direitos. `create_audio.py` permite verificar a origem sintetizada dos 13 WAVs. Não foi feita inspeção artística quadro a quadro ou avaliação jurídica/comercial nesta Etapa 0. Nenhum asset substituído/deletado.

## Ferramentas e efeitos colaterais

| Python em `tools/` | Comportamento / classificação |
|---|---|
| `audit_sources.py` | A: compara 23 hashes; cria manifesto só se ausente. Manifesto existia, execução não o alterou |
| `create_resources.py` | E: sobrescreve sete AttackData a partir de valores antigos; não executar para simples auditoria |
| `phase_resources.py` | E: sobrescreve outros 15 Resources de fase; duas fontes de verdade se .tres editado à mão |
| `create_audio.py` | B/E: síntese determinística, escreve 13 WAVs; potencial utilitário, não executado |
| `finalize_docs.py` | E: sobrescreve documentos antigos, traz afirmações históricas como “sem Git”; não executar |
| `delivery_report.py` | E: lê resultados antigos, escreve manifest/relatórios e exige ausência de Git; incompatível com contexto atual |

Harness temporário desta auditoria em `.git/etapa0_baseline.py`; cópia e export também em `.git/etapa0`. São instrumentos locais, não adicionados ao produto. Comandos completos reprodutíveis e resultados estão no [registro de execuções](Evidencias_Etapa_0/execucoes.json). Evidências novas ficam somente nesta pasta de produção, sem regravar evidências antigas.
