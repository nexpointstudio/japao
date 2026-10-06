# Migração

| Original / funcionamento | Limitação | Godot / evolução planejada |
|---|---|---|
| World, retângulos por eixo | passagem/IA sem navegação | TileMapLayer, StaticBody2D, CharacterBody2D e grafo AStarGrid2D |
| Player strings + timers | transições e buffer acoplados | estados explícitos, AttackData e janelas temporais |
| Combat.rects | lógica manual monolítica | Hitbox/Hurtbox Area2D, deduplicação e retorno de dano confirmado |
| Quatro arquétipos | runner muda sobretudo números | corredor flanqueia e avança; pesado quebra postura; arqueiro mantém linha; portador cria zonas anunciadas |
| Boss dentro do estado global | reset incompleto | encontro isolado, reset no respawn e invocações limitadas |
| Gamepad API | menus não navegam por controle | Input Map, foco de UI, prompts, rumble opcional |
| DOM/CSS | escala fracionária | CanvasLayer, viewport 640×360 e escala inteira |
| Canvas procedural | poses rudimentares | atlas pixel autoral reproduzível, AnimatedSprite2D, efeitos e luz seletiva |
| Web Audio | sem mixer/opções | WAVs originais, buses e volume salvo |
| Flags voláteis | perde progresso ao fechar | save JSON versionado, escrita temporária, backup e validação |
| Teleporte nos testes | caminho real não exercitado | testes de integração e percurso com movimento/física, evidências separadas |

Os números originais são referência inicial; ajustes desta versão constam nos Resources. Nenhuma fonte HTML será modificada.
