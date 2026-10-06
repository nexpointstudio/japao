# Direção visual — aguardando revisão do marco 01

Paleta de jade, madeira, índigo, vermelho profundo e dourado. Ren usa veste vermelha, hakama escuro, katana e marca dourada discreta. Yuna em azul/cinza e tecido claro. Espadachim em armadura verde desgastada, com sinais violetas de reanimação.

O mapa usa TileMapLayer, atlas com textura alpha, ordenação por Y, resolução interna 640×360, nearest e escala inteira. Luzes pontuais iluminam lanternas, o CanvasModulate ajusta a atmosfera. Água e folhas são animadas por pixels; **não há water shader** neste marco. Terreno usa textura determinística gerada por código, com bordas irregulares e variação discreta.

Ren possui 4 direções × 8 poses-base em atlas; AnimatedSprite2D monta idle, walk, windup, slash, reverse, finish, hurt, dash, cast e death. Walk reaproveita poses em ciclo; ataques têm três silhuetas. Morte/cast/dash ainda reutilizam poses. Yuna e inimigo têm animação limitada. Isso é uma amostra para validação, não um conjunto final de animações aprovado.

## Assets e origem

Usada a skill imagegen em modo **ferramenta integrada**, sem CLI nem chave de API. Arte original gerada para este projeto:

- `assets/title.png`: cenário panorâmico ilustrativo do menu.
- `assets/ren_atlas.png`: atlas de Ren, 8×4, recortado em runtime por AtlasTexture.
- `assets/props_atlas.png`: casas, árvore, bambu, santuário, torii, lanterna, poço, pedras, horta, cerca, memorial, Yuna e espadachim.

Os PNG originais gerados foram copiados sem alteração destrutiva; seus recortes são metadados no catálogo. A ferramenta não respeitou exatamente a dimensão solicitada; o catálogo usa dimensões reais e regiões ajustadas. Algumas poses e detalhamento poderão ser retrabalhados conforme a avaliação do usuário.

Prompts completos em `ART_PROMPTS.md`. Sem assets extraídos de Pokémon ou outros jogos, sem imagens de museu incorporadas. Áudio: 12 WAVs sintetizados originalmente pelo script reproduzível, não gravações tradicionais japonesas. Fontes de sistema são consultadas via SystemFont, sem redistribuição de arquivos do Windows.

## Art pass executado

Inspeção das capturas reais de menu, diálogo, praça, ponte, combate e controles. Corrigidos enquadramento do fundo, altura das barras, bordas da estrada, alinhamento dos recortes e sobreposição de textos de postura/dano. A imagem do menu não é captura do gameplay.

**Revisão do usuário pendente:** escala, legibilidade de Ren, densidade de cenário, desenho da arquitetura, paleta, animações e HUD. A qualidade de jogo comercial e o padrão visual final não estão certificados.
