# Migração concluída — Fase 1

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
