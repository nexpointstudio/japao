# Entrega do marco 01 — revisão visual

## Resultado

Amostra editável e executável da Praça do Sino. Este marco não representa a conclusão da Fase 1. O plano aprovado exige apresentar uma amostra e aguardar avaliação antes de expandir artisticamente a fase.

## Preservação e origem

23 fontes estudadas e preservadas, incluindo Bíblia, HTML/CSS/JS, testes e duas capturas antigas. Inventário em source_manifest.json. A versão original é action-adventure Canvas com Ren, Yuna, invasão, floresta, um segredo, checkpoint e Jinzō em duas fases. Não foi substituída nem apagada.

## Implementado neste marco

Godot 4.6.1/GDScript, cena Main, TileMapLayer, corpos e áreas de colisão nativas, AStarGrid2D, Y-sort, sprites em atlas, luzes pontuais, Camera2D, CanvasLayer, sete Resources de ataques e sistemas separados para input, combate, áudio, efeitos e save. Movimento em oito direções, facing cardinal, dois combos, rota mista, pesado, dash, magias, energia, hit feedback, postura e esquiva perfeita. Momentum e finisher não foram incluídos.

Praça com casas, vegetação, água animada, ponte, poço, cercas, jardim, santuário e memorial. Yuna tem diálogo contextual; espadachim tem aproximação por navegação, preparação, ataque, recuo e retorno. Save registra encontro, memorial e checkpoint; áudio tem dois volumes persistentes. Menus funcionam com foco e Input Map centralizado.

Arte usa três imagens originais geradas com imagegen integrada; áudio usa doze WAVs sintetizados e script de origem. Origem e prompts documentados. Não há shaders de água ou spritesheets finais aprovados por artista. A animação do inimigo é limitada e a morte de Ren reutiliza pose de dano nesta amostra.

## Testes e limites

53 verificações de integração do projeto passaram; as mesmas 53 passaram no executável Windows exportado. Há percurso automatizado da amostra com física e ataques reais, além de fixtures isoladas. Capturas reais do projeto e executável inspecionadas. Ajustes de HUD, enquadramento, bordas, texto, leitura de save e encerramento de áudio aplicados. Os logs finais de QA e captura não contêm ERROR/WARNING. Os resultados exportados são registrados separadamente em evidence/export.

Balanceamento inicial da amostra mantém danos originais e aumenta o espadachim para 58HP; movimentos e timings foram ajustados para a nova escala. Não substitui playtest humano. O art pass cobre somente a praça; o polish pass final da Fase 1 ainda não foi executado.

## Próxima etapa após a revisão

Expandir o mapa e arquitetura de encontros, integrar os dados restantes aos Resources, implementar os outros quatro arquétipos e coordenação de grupos, os dois segredos/recompensas, atalho, NPC sobrevivente, arena/Jinzō em duas fases, reset de boss e conclusão com três sinos. Depois executar QA integral, balanceamento e polimento. Nada disso está marcado como concluído neste marco.

## Arquivos e entrega

Criados exclusivamente na nova pasta Amahara_Godot e em Jogar; arquivos iniciais dessa nova estrutura evoluídos. Nenhuma fonte original modificada. Executável: `Jogar/Amahara_Amostra.exe`. Projeto: `Amahara_Godot/project.godot`. README e LEIA-ME trazem instruções e controles. Documentos 00–11 refletem estado atual ou identificam explicitamente o que está pendente; fontes, prompts, logs e capturas permanecem disponíveis.

Git não inicializado; comandos solicitados retornam ausência de repositório. Nenhum commit. Nenhum push. A revisão solicitada vem do plano do usuário, não de uma exigência da skill.
