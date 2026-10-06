# Relatório final — Amahara: O Primeiro Sino

## Entrega

Fase 1 jogável concluída, da abertura à vitória sobre Jinzō, em Godot 4.6.1/GDScript e Windows x64. A amostra visual foi aprovada e sua direção foi estendida à floresta, corrupção, santuário e arena. Projeto editável: `Amahara_Godot/project.godot`. Jogo: `Jogar/Amahara.exe`. Instruções: README.md e Jogar/LEIA-ME.txt. O executável anterior da amostra foi preservado.

## Conteúdo e mudanças

Ren Kurogane, Yuna, katana, dois combos de três golpes, duas magias, general Jinzō e mistério dos três sinos preservados. Implementados buffer limitado, rota mista, dash com colisão, energia em dano aceito, stagger, esquiva perfeita, cinco arquétipos, AStar/separação e vagas de agressão. Jinzō tem seis padrões, duas fases, transição única, invocações limitadas e tentativa totalmente reiniciável.

Jornada: aldeia → defesa → Yuna → ponte/floresta → corrupção → checkpoint → elite → Jinzō → conclusão. Desvios do altar e memorial com recompensas persistentes; atalho destravável; sobrevivente e inscrições; gates impedem eventos finais fora da ordem. Final preserva que Jinzō também respondeu ao chamado. Lore posterior da Bíblia segue como proposta, sem exposição antecipada.

Mundo usa TileMapLayer, corpos nativos e props com Y-sort; área/interação/combate em Area2D; ataques, inimigos, magias, boss e upgrades em Resources. Progressão, encontros, input, áudio, persistência e HUD são módulos próprios. Save v2 validado, temporário, backup e migração da amostra; opções persistem. Menus de início/continuar/controle/opções/pausa/conclusão, foco por teclado/controle e vibração opcional.

Seis imagens originais geradas com imagegen integrada estão em assets; prompts/briefs em ART_PROMPTS.md. Ren tem extensão de poses para dash, magia e queda. Treze WAVs originais e fonte de síntese incluídos. Iluminação seletiva, pisos de corrupção/arena, clareira do altar e HUD revisados em capturas reais. A arte de inimigos é limitada a poses com espelhamento; não promete animação direcional completa para cada inimigo.

## Verificação

**158 PASS / 0 FAIL**, percurso gráfico da exportação até conclusão por comandos de jogo, dois segredos e atalho, novo processo reabrindo save concluído. Nove capturas de apresentação e capturas durante o percurso. Logs finais da exportação sem ERROR/WARNING. Relatório 11 detalha cobertura, fixtures, método e limitações; evidence/final/delivery.json contém os dados verificáveis.

Balanceamento inicial preserva danos originais e ajusta HP/tempos/escala para esta reconstrução. Corrigidos alvos do selo no boss, navegação em borda, reset de tentativa, cancelamento de eventos antigos, save duplicado/inválido, encerramento do áudio e árvores sobre o altar. Os 23 arquivos originais continuam byte a byte intactos segundo source_manifest.json e audit_sources.py.

## Limitações e encerramento

DualSense físico, avaliação humana de dificuldade/feeling, mixagem por audição e revisão por artista continuam não testados. Inimigos usam poucas poses/espelhamento; sobrevivente reutiliza a folha de aldeão com tonalidade. Reencontro final de Yuna ocorre em diálogo sobre a cena da arena. Projeto é editável por GDScript/Resources, com cenário composto em código. Executável não tem assinatura de distribuidor. Não há campanha posterior, multiplayer, crafting ou economia.

A sequência amostra → aprovação → implementação → testes → ajustes de balanceamento → revisão de capturas → polimento → exportação e verificação foi cumprida para a Fase 1. A referência de entrega é este relatório; os documentos anteriores estão arquivados em docs/history. Nenhum repositório Git foi criado; nenhum commit ou push executado.

## Identificação do pacote

Executável: 113,776,800 bytes. SHA-256: `529b2ed1ff3f61037331a4434d3f1f4444433c94413b661dac8873e677443bc4`.

Documentação consolidada: 00 auditoria; 01 migração; 02 pesquisa; 03 design; 04 narrativa; 05 combate; 06 inimigos; 07 mapa; 08 boss; 09 arte; 10 arquitetura; 11 testes. Este arquivo é o relatório de encerramento adicional. Os documentos refletem implementação e evidências, mantendo limites explícitos.
