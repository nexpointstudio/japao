# Arquitetura, persistência e interfaces

`Main.tscn` instancia `game.gd`, que coordena criação da partida, diálogos e transições. A implementação distribui regras em módulos; mundo e entidades são compostos em GDScript e editáveis pelo código, sem cenas individuais para cada prop.

| Módulo | Responsabilidade |
|---|---|
| player / hitbox / hurtbox | Estados, colisão, janelas, deduplicação e sinais |
| enemy / boss / hostile_effect / projectile | Comportamentos, padrões, zonas e projéteis |
| progression | Estágio, upgrades, encontros concluídos, checkpoint, atalho |
| encounters | Composições, aproximação e vagas de agressão |
| world / interaction | TileMapLayer, props, corpos, portões, AStarGrid2D e Area2D |
| ui / input_config | HUD, menus, foco, teclado/controle |
| audio_system / fx | Áudio original e efeitos de combate |
| save_store | JSON v2, validação e recuperação |
| catalog / data | Atlas, SpriteFrames e Resources de ataques/magias/inimigos/boss/upgrades |

Sinais: vida, energia, morte e esquiva perfeita em Ren; morte/stagger nos inimigos; fase/morte no boss; estágio/coleta/checkpoint na progressão. As interfaces de dano retornam bool para confirmar energia. Morte e mudança de partida cancelam timers de morte/toast e callbacks de diálogo. Perigos verificam a validade/morte do emissor antes de atingir.

## Save

`user://amahara_save.json`: version=2, stage 0..6, checkpoint village/sanctuary, upgrades altar/memorial, completed com IDs de encontros e shortcut booleano. Valida tipos, listas permitidas, duplicatas e coerência de marcos. Escrita em .tmp com flush; backup da versão válida anterior; rename para principal. Principal inválido tenta .bak. Nunca substitui backup válido pelo conteúdo inválido principal. Save da amostra v1 migra somente defesa da aldeia; segredos/checkpoint antigos não são promovidos aos novos.

Progresso persiste em eventos, não a cada frame. Vida e energia restauram no checkpoint; posição temporária e golpes pendentes não são serializados. Checkpoint repetido e segredo repetido são idempotentes. ConfigFile separado guarda música, efeitos, vibração e tela cheia. Testes usam amahara_phase_qa.json e phase_qa_settings.cfg, isolados do save real.

Não há serviço externo, rede, conta, telemetria, Git inicializado, commit ou push.
