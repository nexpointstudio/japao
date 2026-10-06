# Combate executável

| Golpe | Dano | Preparação / ativo / recuperação (s) |
|---|---:|---|
| Leve 1 / 2 / 3 | 11 / 12 / 19 | 0,07/0,12/0,15 · 0,08/0,12/0,17 · 0,13/0,14/0,27 |
| Pesado 1 / 2 / 3 | 15 / 18 / 29 | 0,17/0,15/0,25 · 0,18/0,16/0,25 · 0,25/0,18/0,38 |

`data/*.tres` define alcance, área, avanço, knockback, postura, hitstop e encadeamento. Somente a janela ativa amostra Area2D. Cada instância de ataque registra alvos já atingidos; energia só é concedida quando `receive_hit` aceita o dano. Leve 1→2→3; pesado 1→2→3; leve 1→2→pesado 3. Buffer expira em 0,25 s; não há cancelamento livre do ataque por dash.

Dash direcional tem colisão nativa, 0,18 s de invulnerabilidade e cooldown 0,62 s. Evitar dano nos primeiros 0,09 s concede 12 de energia uma única vez. Invulnerabilidade após dano: 0,62 s. Recuperação de dano: 0,22 s. Movimento diagonal normalizado e quatro orientações de sprite.

Corte Celeste: custo 25, dano 24, velocidade 240, cooldown 0,9 s, colisão com cenário. Selo de Ruptura: custo 35, dano 18, raio 62, dano de postura 38, cooldown 5 s. Ambos usam MagicData. Selo inclui Jinzō. Pesados retiram 24/30/42 de postura. Inimigos quebrados ficam expostos 1,15 s; Jinzō, 1,35 s.

Ren usa poses próprias de movimento, golpes, dash, magia, dano e queda em quatro direções. VFX, som, texto, tremor leve e vibração opcional reforçam o contato. Não há dano fora da janela nem energia em contato recusado. Sem Momentum ou execução.
