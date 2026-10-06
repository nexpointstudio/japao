# Arquitetura — marco 01

Main.tscn instancia o controlador da amostra. World constrói TileMapLayer, StaticBody2D, atores com Y-sort, luzes e AStarGrid2D. Ren e espadachim usam CharacterBody2D com colisão de pés e hurtbox separada. Hitbox Area2D gerencia alvos atingidos durante active. Corte Celeste é outra Area2D com vida limitada e colisão com cenário.

UI em CanvasLayer separada do mundo, com menus, opções, foco de controles, diálogo e HUD. Game permanece ativo durante pausa e bloqueia o mundo; diálogos também pausam física. Morte possui Timer próprio cancelado em reinícios. FX e Audio são sistemas separados. O encerramento normal para áudio e aguarda o processamento antes de fechar.

Resources implementados: AttackData e sete instâncias .tres (seis golpes de Ren e um do morto). EnemyData e MagicData existem como estruturas iniciais, **ainda não integradas**; BossAttackData e UpgradeData ainda não existem. Parte do balanceamento permanece nos scripts nesta amostra.

Sinais ativos: vida, energia, morte, esquiva perfeita e stagger. A UI da amostra lê o estado a cada frame; a separação completa de controladores de encontros/narrativa é trabalho da expansão, não deve ser anunciada como concluída.

SaveStore usa JSON com versão, estado de encontro, checkpoint conhecido e flag do memorial. Escreve temporário, copia backup, renomeia. Leitura inválida tenta backup sem lançar erro de parser no log. Settings usam ConfigFile separado. Testes isolam seus arquivos com override_path e QA settings.

Camadas: 1 cenário; 2 corpo de Ren; 4 hurtbox de Ren; 8 hurtbox de inimigos; 16 corpo inimigo. Hitboxes não colidem fisicamente. Navegação é calculada a partir dos mesmos footprints usados pelas colisões.

Não há dependência externa para executar a build. Python/Pillow foi usado apenas para verificar metadados dos PNG; criação de Resources e áudio usa biblioteca padrão. Os scripts de teste podem ser acionados por argumentos de linha de comando e não aparecem nos menus de jogo.
