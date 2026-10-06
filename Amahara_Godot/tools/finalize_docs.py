from pathlib import Path
import json
root=Path(__file__).resolve().parents[1]
docs=root/'docs'
texts={
'01_MIGRATION.md':'''# Migração concluída — Fase 1

O snapshot HTML/JS foi preservado. A versão Godot é um projeto nativo independente, em GDScript 4.6.1, sem dependências do navegador.

| Fonte original | Implementação atual |
|---|---|
| Canvas / colisão por retângulos | TileMapLayer 32 px, CharacterBody2D, StaticBody2D e Area2D |
| World / perseguição direta | AStarGrid2D 16 px, ajuste para célula livre e separação local |
| Player / balance.js | RenPlayer e sete AttackData editáveis |
| Combat / alvos por golpe | HitboxComponent, HurtboxComponent, retorno de dano aceito |
| Quatro inimigos | Cinco EnemyData, portador de selo, corredor com flanco e avanço |
| Boss global | GeneralJinzo e seis BossAttackData, reset integral |
| Flags voláteis | StoryProgression, SaveStore v2 com temporário e backup |
| DOM / Gamepad API | CanvasLayer, Input Map e foco nativo de controles |
| Web Audio | Treze WAVs sintetizados originais, música/efeitos independentes |
| Arte procedural | Seis PNGs gerados, atlas de poses e cenário com ordenação por Y |

A praça da amostra aprovada permanece como início. O executável histórico `Amahara_Amostra.exe` foi preservado; a entrega atual é `Amahara.exe`. Git não foi inicializado; commit e push não se aplicam à pasta sem repositório.
''',
'03_GAME_DESIGN.md':'''# Game design — O Primeiro Sino

Action-adventure top-down para Windows. Fase 1 completa: Ren protege Amahara, segue os mortos e enfrenta o general Jinzō. O objetivo sempre aparece no HUD. A aventura termina com o primeiro sino silenciado e permite continuar explorando.

## Ciclo

Ler a antecipação, posicionar Ren, encadear katana, esquivar e usar Energia Divina. Golpes confirmados recuperam energia. Pesados e selo quebram postura, criando uma abertura; a esquiva perfeita recompensa leitura temporal. Não há Momentum, execução, crafting, economia ou multiplayer.

## Progressão

Defesa de dois espadachins → conversa obrigatória com Yuna → ponte/floresta → encosta corrompida → descanso no santuário → três guardas de elite → Jinzō → conclusão. Encontros de campo podem ser evitados; os bloqueios exigem defesa, conversa, checkpoint e elite. O jogador pode procurar dois segredos e abrir o atalho.

São 13 inimigos nos cinco encontros, mais até dois invocados simultaneamente pelo boss. Cada encontro concluído recupera 18 de vida. Descanso seguro recupera toda vida/energia. Vida de Ren: 100; energia inicial: 100, ou 125 após o altar. Recompensas e encontros concluídos persistem. A morte reinicia grupos incompletos e toda a tentativa do boss.

## Ajustes

Danos da katana e magias preservados. Movimento 108 px/s; dash 330 px/s por 0,18 s e cooldown 0,62 s. Buffer reduzido para 0,25 s. Espadachim passou de 38 HP no original para 48 (a amostra usava 58); corredor 25→38; pesado 86→90; arqueiro 31→38. Portador novo: 62 HP. Mudanças acomodam a escala, postura e variedade de encontros. Regeneração de energia 2,2/s, +6 por contato aceito, +12 pela esquiva perfeita.

Os testes automatizados comprovam regras e um percurso completo. Dificuldade e sensação de controle ainda precisam de avaliação humana; os números são balanceamento inicial da entrega.
''',
'04_STORY_AND_LORE.md':'''# Narrativa implementada e limites da Bíblia

## Existia e foi preservado

Ren Kurogane, criado por Yuna, carrega uma marca dourada ligada ao Estandarte. Ele é mortal: recebe dano, cai e retorna ao juramento do checkpoint. A aldeia é atacada por guerreiros humanos reanimados. Jinzō, general morto há oitenta anos, também respondeu ao chamado. Três sinos e três sepulturas formam o mistério; alguém conhece o sangue de Ren.

## Abertura e jornada

Yuna percebe o sino sem vento; Ren promete voltar. Após defender a praça, ela reconhece as armaduras e orienta a busca do santuário. Um sobrevivente explica o desvio ao norte das pedras, o altar ao sul e o memorial. Inscrição na aldeia menciona três sinos; memorial preserva nomes, não vitórias. A faixa dos ausentes é um item narrativo registrado no save. Jinzō reconhece a marca, mas não identifica quem o convocou. Após sua derrota, Ren reencontra Yuna por diálogo e a Fase 1 termina.

## Criado nesta reconstrução

Diálogos de vínculo e promessa com Yuna, sobrevivente, faixa com recuperação, altar persistente, trilha de corrupção e atalho. O reencontro final é apresentado em diálogo sobre a cena da arena, sem uma cutscene de deslocamento físico de Yuna. O jogador pode retornar à aldeia depois.

## Proposta, não campanha confirmada

Mio, Seigan, Voto/Fome, revelações sobre linhagens e capítulos posteriores da Bíblia permanecem propostas. Não são apresentados como fatos resolvidos na abertura nem implementados além do gancho dos três sinos. Esta entrega se limita à Fase 1.
''',
'05_COMBAT.md':'''# Combate executável

| Golpe | Dano | Preparação / ativo / recuperação (s) |
|---|---:|---|
| Leve 1 / 2 / 3 | 11 / 12 / 19 | 0,07/0,12/0,15 · 0,08/0,12/0,17 · 0,13/0,14/0,27 |
| Pesado 1 / 2 / 3 | 15 / 18 / 29 | 0,17/0,15/0,25 · 0,18/0,16/0,25 · 0,25/0,18/0,38 |

`data/*.tres` define alcance, área, avanço, knockback, postura, hitstop e encadeamento. Somente a janela ativa amostra Area2D. Cada instância de ataque registra alvos já atingidos; energia só é concedida quando `receive_hit` aceita o dano. Leve 1→2→3; pesado 1→2→3; leve 1→2→pesado 3. Buffer expira em 0,25 s; não há cancelamento livre do ataque por dash.

Dash direcional tem colisão nativa, 0,18 s de invulnerabilidade e cooldown 0,62 s. Evitar dano nos primeiros 0,09 s concede 12 de energia uma única vez. Invulnerabilidade após dano: 0,62 s. Recuperação de dano: 0,22 s. Movimento diagonal normalizado e quatro orientações de sprite.

Corte Celeste: custo 25, dano 24, velocidade 240, cooldown 0,9 s, colisão com cenário. Selo de Ruptura: custo 35, dano 18, raio 62, dano de postura 38, cooldown 5 s. Ambos usam MagicData. Selo inclui Jinzō. Pesados retiram 24/30/42 de postura. Inimigos quebrados ficam expostos 1,15 s; Jinzō, 1,35 s.

Ren usa poses próprias de movimento, golpes, dash, magia, dano e queda em quatro direções. VFX, som, texto, tremor leve e vibração opcional reforçam o contato. Não há dano fora da janela nem energia em contato recusado. Sem Momentum ou execução.
''',
'06_ENEMIES.md':'''# Inimigos e encontros

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
''',
'07_LEVEL_01.md':'''# Mapa — Fase 1

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
''',
'08_BOSS.md':'''# General Jinzō

480 HP, postura 100, atlas exclusivo de oito poses: comandante de armadura escura e dourada, bandeira violeta rasgada e katana. Introdução: ele reconhece a marca e revela que também respondeu ao chamado.

| Padrão | Aviso | Ação | Recuperação |
|---|---:|---|---:|
| Três juramentos | 0,65 s | Três cortes, dano 13 cada | 1,10 s |
| Marcha do general | 0,90 s | Avanço 230 px/s por 0,55 s, dano 18 | 1,20 s |
| Círculo de ferro | 1,00 s | Área 84 px, dano 20 | 1,35 s |
| Sepultura desperta | 0,80 s | Zona espiritual, dano 15 | 1,15 s |
| Estandarte partido | 1,10 s | Doze projéteis radiais, dano 12 | 1,40 s |
| Chamado dos juramentados | 1,20 s | Invoca até dois espadachins vivos | 1,50 s |

Fase 1 alterna combo, avanço, área e espiritual. Ao chegar a 50%, uma transição única de 1,8 s suspende ataques e dano recebido. Fase 2 acrescenta radial/invocações, segunda zona espiritual e velocidade maior. Todas as ações têm antecipação e recuperação. Quebra de postura abre 1,35 s de punição.

Reset recria o boss com 480 HP/fase 1, remove invocações/projéteis/áreas, libera a barreira e retorna Ren ao santuário. Pausa suspende a transição. Vitória cancela perigos, registra estágio 6 e mostra o gancho dos três sinos seguido de tela de conclusão. Padrões nas duas fases, transição única, invocações, morte, reinício e vitória foram exercitados por fixtures; o percurso completo também vence usando Input Map.
''',
'09_ART_DIRECTION.md':'''# Direção visual aplicada

A amostra foi aceita pelo usuário, que autorizou seguir até o fim da Fase 1 com essa arte. Paleta de jade, madeira, vermelho profundo e dourado; corrupção violeta/cinza azulado. Viewport 640×360, janela 1280×720, nearest, escala inteira e barras fora da proporção. Tiles 32; Ren usa quadros normalizados para 48 px; inimigos 53/59; Jinzō 91.

Seis PNGs autorais gerados com a ferramenta imagegen integrada: ilustração de menu, Ren, extensão de ações de Ren, objetos/aldeia, quatro novos inimigos e Jinzō. Originais preservados, recorte por AtlasTexture em runtime; sem edição raster por Python. Prompts/briefs em ART_PROMPTS.md. Cenário em camadas, props com Y-sort e colisão na base, luz seletiva de lanternas, água e folhas discretas. Região corrompida e arena recebem pisos específicos.

Ren possui quatro direções com caminhar, preparação, três poses de corte, dano, dash, magia e queda. Inimigos têm animação limitada por poses e espelhamento; não são folhas direcionais completas como Ren. General tem desenho e poses próprios. O sobrevivente reutiliza uma figura de aldeão da folha de props com outra tonalidade. Estes limites são visuais, não bloqueiam a jornada.

VFX não cobrem o corpo inteiro: arcos da katana, partículas pontuais, círculos de área com enchimento discreto e sinais de aviso. O menu é complemento. Capturas reais revisadas em evidence/final e evidence/final/export; fixtures de apresentação são identificadas separadamente do percurso.

Áudio: treze WAVs sintetizados em tools/create_audio.py, incluindo tema de aldeia e tema de boss. Efeitos e música com volumes independentes persistentes; sem gravações de terceiros. Reprodução/encerramento verificados em runtime; mixagem e sensação sonora não passaram por audição humana certificada.
''',
'10_ARCHITECTURE.md':'''# Arquitetura, persistência e interfaces

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
'''
}
for name,text in texts.items(): (docs/name).write_text(text,encoding='utf-8')
# Preserve research sources; bring scope labels up to date.
p=docs/'02_RESEARCH.md'
s=p.read_text(encoding='utf-8').replace('Pesquisa aplicada — marco 01','Pesquisa aplicada — Fase 1').replace('ameaça desta amostra','ameaça desta fase').replace('A amostra não introduz','A fase não introduz')
p.write_text(s,encoding='utf-8')
p=docs/'00_SOURCE_AUDIT.md'
s=p.read_text(encoding='utf-8').replace('Cada resultado será documentado após execução.','Resultados de execução e preservação final constam nos relatórios 11 e 12.')
p.write_text(s,encoding='utf-8')
print('Design and architecture documents consolidated')
