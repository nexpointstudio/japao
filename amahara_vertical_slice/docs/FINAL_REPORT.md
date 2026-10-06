# Relatório final — Amahara: Juramento de Guerra

1. **Nome do jogo:** Amahara: Juramento de Guerra.
2. **História:** a aldeia de Amahara é atacada por guerreiros mortos reanimados. Ren segue o rastro da invasão por uma floresta até um santuário corrompido e descobre o General Jinzō, um comandante morto transformado no foco de comando do exército. Ao derrotá-lo, Ren descobre que Jinzō também foi chamado por uma força externa e que três outros santuários/sepulturas responderam ao mesmo ritual.
3. **Protagonista:** Ren Kurogane, jovem guerreiro mortal com sangue divino, criado em Amahara pela guardiã Yuna.
4. **Origem divina:** Ren carrega a Marca do Estandarte, fragmento ficcional de uma antiga força de guerra associada a conflito, coragem e proteção. Ela não o torna invulnerável.
5. **Referências:** arquitetura e limiares de santuário, torii, lanternas, armaduras japonesas laminadas/lacadas e a ideia de seres sobrenaturais ambivalentes. A cosmologia e personagens são originais.
6. **Mapa da fase:** aldeia → invasão → estrada/floresta → ponte/córrego → desvio secreto → santuário/checkpoint → pátio corrompido → arena do boss.
7. **Áreas:** aldeia habitada, floresta de bambu, curso d’água/ponte, altar oculto, santuário corrompido e arena final.
8. **Controles teclado:** WASD/Setas, J, K, Espaço, Q, E, F e Esc.
9. **DualSense lógico:** analógico/D-pad, Quadrado, Triângulo, Círculo, L1, R1, X e Options via Gamepad API.
10. **Movimentação:** 8 direções com diagonal normalizada, facing cardinal e colisão por eixo.
11. **Combo 1:** Corte Horizontal → Corte Reverso → Corte Descendente; rápido e focado em dano moderado/controle de básicos.
12. **Combo 2:** Passo de Ferro → Ombro da Guerra → Lâmina do Estandarte; maior avanço, dano, knockback e recovery.
13. **Dash:** Passo de Guerra; direcional, curto, cooldown de 0,58 s e i-frames durante a janela ativa.
14. **Magia 1:** Corte Celeste, lâmina de energia à distância.
15. **Magia 2:** Selo de Ruptura, área ao redor de Ren que causa dano, empurra e atordoa.
16. **Energia Divina:** 100 base, regeneração lenta, +6 por acerto de katana; segredo pode elevar máximo para 125.
17. **Zumbis:** Espadachim Morto, Corredor Morto, Guardião Pesado e Arqueiro Morto.
18. **IA:** state machines com idle/chase/telegraph/attack/recover/hurt/dead; arqueiro mantém distância; grupos limitam ataques simultâneos.
19. **Boss:** General Jinzō — O Estandarte Oco, antigo general morto, reanimado e usado como foco para controlar cadáveres.
20. **Phase 1:** combo melee, charge e ataque de área com telegraph e recovery.
21. **Phase 2:** alteração visual, agressividade maior, invocação única de mortos e rajada radial sobrenatural `grave`.
22. **Segredo:** altar oculto ao sul da rota principal da floresta.
23. **Upgrade:** +25 Max Energia Divina.
24. **NPCs:** Yuna possui papel narrativo central; a aldeia inclui sinais de ocupação e vida.
25. **Shrine/checkpoint:** restaura HP/energia e atualiza respawn antes do trecho final.
26. **Morte/respawn:** morte → mensagem/fade narrativo simplificado → respawn no último shrine sem recarregar a página.
27. **UI:** HUD de HP/Energia, cooldowns, objetivo, prompt contextual e barra do boss; menu, controles, pause e vitória.
28. **Pixel Art:** procedural por Canvas, com personagens, casas, árvores, bambu, torii, lanternas, pontes, armaduras, VFX e cenário próprios.
29. **Tile size:** 24 px lógicos.
30. **Resolução interna:** 480×270, 16:9.
31. **Arquitetura:** arquivos separados por dados, input, áudio, combate, mundo, player, inimigos, boss e game loop.
32. **Framework:** Canvas 2D nativo/JavaScript. Phaser foi evitado para eliminar dependência externa e permitir execução local simples.
33. **Áudio:** Web Audio procedural para katana, impacto, dash, magias, UI, zumbis, shrine, boss e ambientação tonal dinâmica.
34. **VFX:** slash arcs, hit sparks, particles, trails, rings, corrupção, screen shake e hit stop.
35. **T01–T70:** ver `docs/TEST_REPORT.md`; todos os testes executáveis passaram, com T20–T28 bloqueados apenas por ausência de DualSense físico.
36. **Edge cases:** revisados em `docs/TEST_REPORT.md`.
37. **Bugs corrigidos:** ring VFX com raio negativo, composição inicial vazia, boss fora de enquadramento e ausência de barreira de arena.
38. **Playthrough:** fluxo menu → intro → aldeia → invasão → floresta → segredo → shrine → boss → vitória foi percorrido por automação de Chromium; helpers foram usados para acelerar combate/progressão.
39. **Limitações:** teste físico de DualSense e playtest humano de balanceamento ainda pendentes; áudio e arte são inteiramente procedurais.
40. **Arquivos principais:** `index.html`, `style.css`, `src/data/balance.js`, `src/input.js`, `src/audio.js`, `src/combat.js`, `src/world.js`, `src/entities/player.js`, `src/entities/enemies.js`, `src/entities/boss.js`, `src/game.js`, `src/main.js`, `docs/RESEARCH.md`, `docs/TEST_REPORT.md`, `tests/cdp_smoke.js`, `tests/logic_suite.js`.
