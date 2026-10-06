# Amahara: Juramento de Guerra

Vertical slice de action-adventure 2D top-down em Pixel Art, ambientado em um Japão antigo fantástico.

## Executar

Opção mais simples no Windows:

```bat
run.bat
```

Ou, dentro da pasta do projeto:

```bash
python -m http.server 8000
```

Depois abra `http://localhost:8000`.

## Controles

- WASD / Setas: movimento
- J: Combo rápido — 3 cortes
- K: Combo pesado — 3 golpes com avanço/knockback
- Espaço: Passo de Guerra (dash com i-frames curtos)
- Q: Corte Celeste (projétil)
- E: Selo de Ruptura (área/stun)
- F: interagir
- Esc: pausa

DualSense lógico via Gamepad API: analógico/D-pad, Quadrado, Triângulo, Círculo, L1, R1, X e Options.

## Estrutura

- `src/data/balance.js`: números centralizados
- `src/world.js`: tilemap, colisão, props e interações
- `src/entities/player.js`: estados do jogador, combos, dash, magia
- `src/entities/enemies.js`: quatro arquétipos e IA
- `src/entities/boss.js`: boss em duas fases
- `src/combat.js`: hitbox/hurtbox e dano
- `src/input.js`: teclado + Gamepad API
- `src/audio.js`: SFX e ambientação procedural
- `docs/RESEARCH.md`: referências e decisões
- `docs/TEST_REPORT.md`: validação realizada

Não há assets de terceiros: os sprites e cenários são desenhados em Pixel Art procedural diretamente no Canvas, sem placeholders geométricos simples como identidade final.

## Validação técnica

Os testes usados durante a entrega ficam em `tests/`:

```bash
node tests/cdp_smoke.js
node tests/logic_suite.js
```

Eles usam Chromium headless através do Chrome DevTools Protocol. O relatório consolidado está em `docs/TEST_REPORT.md`.
