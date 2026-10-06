# Inimigos — marco 01

**Espadachim implementado:** 58HP, velocidade 42, dano 10, aggro 185, retorno acima de 300, preparação 0,58s, active 0,16s, recovery 0,85s e postura 32. IA idle/chase/return/telegraph/attack/recover/hurt/stagger/dead. Rota AStarGrid2D atualizada a cada 0,3s; movimento/colisão por CharacterBody2D. Recua quando o jogador está muito perto durante recovery. Corpo reanimado com armadura, pele cadavérica e katana.

Morte bloqueia dano/ataques novos, produz partículas, dissolve o sprite e libera o nó. Respawn reconstrói um único encontro quando ainda não concluído.

**Não implementados neste marco:** corredor, pesado, arqueiro, portador de selo e coordenação de grupos. A arquitetura inicial `EnemyData` foi criada, mas o espadachim da amostra ainda centraliza parte de seus valores no script. Migrar os valores restantes para Resources na expansão aprovada.
