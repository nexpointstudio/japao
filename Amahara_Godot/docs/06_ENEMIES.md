# Inimigos e encontros

| Arquétipo | HP | Velocidade | Postura | Preparação | Comportamento |
|---|---:|---:|---:|---:|---|
| Espadachim | 48 | 42 | 32 | 0,58 s | Pressiona, golpeia e recua |
| Corredor | 38 | 68 | 25 | 0,65 s | Busca flanco vertical e avança a 190 px/s |
| Pesado | 90 | 30 | 66 | 0,90 s | Área maior; não interrompe por dano leve, abre ao quebrar postura |
| Arqueiro | 38 | 40 | 24 | 0,85 s | Mantém distância, exige linha de tiro e lança projétil físico |
| Portador de selo | 62 | 32 | 44 | 1,05 s | Marca posição de Ren; área tem mais 0,85 s de aviso antes do dano |

São guerreiros humanos reanimados, com vestes e armaduras. Portador carrega estandarte/selo; não é um fantasma abstrato. Novos arquétipos têm atlas de quatro poses. Espadachim reutiliza as duas poses da arte aprovada. Morte usa queda/rotação e dissolução; inimigos não possuem quatro orientações desenhadas independentes, usam espelhamento e direção da hitbox.

EncounterDirector limita a duas vagas de agressão e espaça novas autorizações por 0,32 s. Vagas são liberadas ao interromper, recuperar e morrer. Detecção: 225 px; acima de 360, retornam ao ponto inicial. Grupos só são instanciados na aproximação. AStarGrid2D evita obstáculos, a célula livre mais próxima corrige posições junto das bordas e separação local evita sobreposição de perseguidores.

Composições verificadas: dois melee; melee/corredor; melee/arqueiro; pesado/arqueiro; quatro inimigos. A suíte avançada verifica navegação junto a rochas, linha de tiro bloqueada e projétil contra água/colisão.
