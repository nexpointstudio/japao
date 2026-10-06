# Auditoria da fonte — 05/10/2026

Leitura integral dos 21 arquivos textuais e inspeção das duas capturas. Inventário por tamanho e SHA-256 em `source_manifest.json`. A Bíblia tem 4.731 linhas; os 16 arquivos do snapshot técnico correspondem às fontes independentes. Fontes originais preservadas fora de res://. Não há repositório Git nesta pasta.

## EXISTIA NO JOGO

Conceito: action-adventure top-down desktop em Canvas 2D, resolução 480×270, tiles de 24, mundo 3456×2208. Japão fantástico original, katana central e protagonista semidivino mortal.

História/personagens: Ren Kurogane, criado pela guardiã Yuna, defende Amahara. Mortos reanimados conduzem ao General Jinzō, morto há oitenta anos, também convocado por outra força. A vitória revela três sinos/sepulturas e alguém que conhece o sangue de Ren. Mio, Seigan, Voto/Fome e a campanha posterior são PROPOSTAS na Bíblia, não conteúdo executável da fase.

Mapa: aldeia com seis casas, Yuna, cinco invasores; floresta com seis inimigos, rio/ponte, altar secreto; santuário com quatro inimigos, inscrição e checkpoint; arena e Jinzō.

Controles: WASD/setas, J leve, K pesado, espaço dash, Q corte, E selo, F interação, Esc pausa. Gamepad API com mapeamento padrão, sem prova física de DualSense. F3 debug.

Movimento: oito direções, diagonal normalizada, facing cardinal, colisão manual por eixo com retângulos e água. Câmera interpolada com limites.

Combate: retângulos ofensivos e hurtboxes; startup/active/recovery; conjunto de alvos por swing. Leve 11/12/19, pesado 15/18/29; buffer 0,32s sem mistura de cadeias. Dash 270px/s por 0,18s, cooldown 0,58s. HP 100; invulnerabilidade pós-dano 0,62s.

Magias: Corte Celeste custa 25, dano 24, projétil; Selo de Ruptura custa 35, dano 18, raio 52, stun 0,8s. Energia 100, regen 2,2/s, +6 ao contato da katana. Altar aumenta máximo em 25 durante a execução atual.

Inimigos: espadachim (38HP, perseguição/melee), corredor (25HP, mesma estrutura acelerada), pesado (86HP, resistência a knockback), arqueiro (31HP, afasta/aproxima/dispara). Até dois ataques simultâneos e cooldown global de 0,22s. Não há navegação por obstáculos.

Boss: 480HP, combo, charge, área; a 50% entra na fase 2, invoca dois mortos uma vez e acrescenta rajada radial. A IA e arte são próprias, mas simples.

Exploração/itens/progressão: um altar secreto e inscrição. Não existe inventário, loot físico, economia ou save. Flags e estado de história numérico. Checkpoint restaura vida/energia; respawn preserva mundo e boss.

HUD/menu: HP, energia, objetivo, cooldowns, interação, boss; início, controles, pausa e vitória em DOM. Áudio Web Audio sintetizado em tempo real. Arte desenhada no Canvas por retângulos/arcos; sem spritesheets nem áudio externo. As únicas imagens são screenshots de referência, não assets utilizáveis como sprites.

Sistemas: namespace global AMAHARA, Game integra loop, narrativa, ondas, efeitos e HUD; módulos Player/Enemy/Boss/World/Input/Audio/Combat, dados em balance.js. Sem dependências de engine.

## Bugs e limitações

Relatório anterior registra correções de raio negativo em VFX, aldeia vazia, enquadramento do boss e barreira. Os PASS anteriores não foram reexecutados nesta auditoria. Testes usam Chromium por nome e /tmp, injeção de DOM simplificado, teleporte e dano direto; não validam carregamento real do HTML, navegação física integral nem balanceamento humano. Algumas asserções agrupadas não exercitam tudo que seus rótulos sugerem.

Inspeção atual: checkpoint pode avançar história sem requisito; cutscene não bloqueia todo update; timers de morte/vitória não são cancelados ao reiniciar; respawn mantém boss/barreira; ganho de energia não confere resultado do dano; padPrev não reinicia ao desconectar; CSS não garante escala inteira. São riscos identificados por código, não bugs reproduzidos em runtime nesta etapa.

## CRIADO/EVOLUÍDO NESTA VERSÃO

Projeto nativo separado. CharacterBody2D, Area2D hit/hurt, Resources, TileMapLayer, sprites animados, sinais, UI navegável, save versionado. Stagger e esquiva perfeita como evolução limitada; sem adicionar campanha, crafting ou multiplayer. Dois desvios recompensados, atalho e novo portador de selo como guerreiro reanimado sobrenatural. Yuna permanece central; um sobrevivente orienta o desvio. Jinzō mantém identidade e gancho. Cada resultado será documentado após execução.
