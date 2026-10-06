# Combate — comportamento implementado

Player: idle/move/attack/dash/cast/hurt/dead. Os ataques usam Resources editáveis em `data/`. Cada instância limpa seu conjunto de alvos. Area2D coleta sobreposição apenas durante active; não se usa apenas distância para katana.

| Cadeia | Danos | Papel |
|---|---|---|
| Corte Horizontal → Reverso → Descendente | 11 / 12 / 19 | Velocidade e energia |
| Passo de Ferro → Ombro → Lâmina do Estandarte | 15 / 18 / 29 | Avanço e quebra de postura |
| Leve → Leve → finalizador pesado | 11 / 12 / 29 | Rota alternativa comprometida |

Buffer expira em 0,25s. O próximo golpe deve ser inserido no fim do atual. Não há cancelamento de ataque em dash nesta amostra: o campo `cancel_time` existe na estrutura inicial mas não é usado. Direção permanece fixa durante o swing.

Dash: 0,18s, velocidade 330, cooldown 0,62s, invulnerabilidade ativa. Esquiva perfeita exige tentativa real de dano nos primeiros 0,09s; concede +12 energia uma vez por dash e feedback visual/sonoro. Não há slow-motion global.

Corte Celeste: custo 25, dano 24, velocidade 240, vida 1,35s, cooldown 0,9s, colide com alvos e cenário. Selo: custo 35, dano 18, raio 62, postura 38, cooldown 5s. Custo e cooldown têm mensagens distintas.

Energia: máximo 100, regen 2,2/s e +6 somente se o alvo aceitar dano da katana. Postura do espadachim: 32; quebra deixa 0,9s de vulnerabilidade. Pós-hit do player: 0,62s invulnerável, reação de 0,22s. Morte impede ações e respawn ocorre após 1,1s.

Hitstop: 0,025s leve e 0,065s pesado; shake reservado a pesado e dano recebido. VFX usam arcos, partículas e números curtos sem substituir sprites.
