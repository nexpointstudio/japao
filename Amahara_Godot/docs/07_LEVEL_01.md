# Mapa — Fase 1

Mundo de 3072×768, tiles de 32, navegação de 16. Câmera mostra 640×360, com limites 60..3008 e 65..730. Terreno, partículas, objetos ordenados por Y, atores e HUD são camadas distintas.

| Região / posição aproximada | Conteúdo |
|---|---|
| Praça (512,416) | Yuna, casas, poço, lanternas, inscrição e defesa ao sul |
| Ponte (944,416) | Rio com colisão e travessia estreita |
| Floresta (1250..1800,416) | Sobrevivente, espadachim/corredor, pesado/arqueiro |
| Memorial (1490,265) | Faixa dos ausentes, +35 vida uma vez, texto narrativo |
| Altar (1712,674) | +25 energia máxima, persistente |
| Encosta (1856..2120) | Piso violeta, árvores alteradas, selo/corredor/melee/arqueiro |
| Desvio norte (1820,270) | Contorna a crista de pedras |
| Atalho (1870,576) | Destrava pelo leste; liga o retorno ao altar |
| Santuário (2208,424) | Checkpoint, vida e energia; desbloqueia elite |
| Elite (2380..2450) | Pesado, arqueiro e portador |
| Arena (2552..3008) | Torii, piso pétreo, círculo de juramento e Jinzō |

A saída da aldeia exige defesa e conversa. A arena exige checkpoint e elite; fecha na introdução do boss e reabre ao morrer ou vencer. Passagens utilizam StaticBody2D e atualizam AStar. Interações dos marcos usam Area2D; Yuna usa proximidade ao ator.

Encontros concluídos e segredos persistem imediatamente. Grupos incompletos reaparecem após morrer; os concluídos não. O santuário só permite descanso seguro. A tentativa do boss elimina perseguidores de fora antes de iniciar. Morte restaura o último checkpoint e cancela seus efeitos.
