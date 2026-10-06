# Executar Amahara

Abra **Jogar/Amahara.exe** para jogar a Fase 1 completa. Não exige Godot instalado. A versão anterior da amostra foi mantida como Amahara_Amostra.exe.

Para editar, importe `project.godot` no Godot 4.6.1 e execute com F5 a cena Main. Código em scripts; dados de combate em data; arte em assets. A cena é construída por scripts nativos da engine.

| Ação | Teclado | DualSense / layout padrão |
|---|---|---|
| Mover | WASD / setas | Analógico esquerdo / direcional |
| Combo leve | J | Quadrado |
| Combo pesado | K | Triângulo |
| Esquiva | Espaço | Círculo |
| Corte Celeste | Q | L1 |
| Selo de Ruptura | E | R1 |
| Interagir / diálogo | F | X |
| Pausa | Esc | Options |
| Tela cheia | F11 / Opções | Opções |

Repita o ataque perto do fim do golpe para encadear. Dois cortes leves aceitam um finalizador pesado. Pesados e selo quebram postura. Esquivar no início de um ataque dá energia. Magias consomem energia; a katana recupera energia ao acertar.

Defenda a praça ao sul e volte a Yuna antes de seguir para leste. A ponte conduz à floresta. A crista de pedras tem passagem pelo norte. Descanse no santuário antes de enfrentar a elite. O altar ao sul dá +25 energia máxima; o memorial ao norte dá item narrativo e +35 vida. O atalho abre pelo lado leste. Cada grupo eliminado recupera 18 de vida.

Continuar restaura o último checkpoint com segredos e encontros concluídos preservados. Morte reinicia grupos incompletos e toda a luta do boss. Novo jogo substitui o progresso atual. Save em `%APPDATA%/Godot/app_userdata/Amahara_ Juramento de Guerra/` (o nome exato saneado é informado pelo Godot); principal `amahara_save.json`, cópia `.bak`, configurações em `settings.cfg`. Não é necessário editar esses arquivos.

Resolução lógica 640×360, janela 1280×720 e escala inteira. Use música/efeitos e vibração opcionais em Opções. Os mapeamentos estão implementados; teste físico de DualSense USB/Bluetooth não foi realizado.

Relatório final em docs/12_MILESTONE_REPORT.md; testes em docs/11_TEST_REPORT.md; capturas e JSONs em evidence/final. `docs/history` e evidence/export preservam o marco anterior.

## Reproduzir a validação

Com o executável Godot 4.6.1 disponível:

```powershell
godot --headless --path . -- --qa
godot --headless --path . -- --advanced
godot --headless --path . -- --settings-qa
godot --path . -- --playthrough
godot --headless --path . -- --verify-save
godot --path . -- --capture
python tools/audit_sources.py
```

Execute na ordem acima: `--verify-save` lê o save deixado pelo percurso. Não execute simultaneamente suítes, pois compartilham apenas o save de QA (isolado do save real). `--playthrough` acelera a simulação em 3×, usa 180 ticks/s e controla por InputMap; não altera vida, posição ou dano. Os demais testes incluem fixtures com reposicionamento explícito. `--capture` é ensaio visual por fixtures, não comprova o percurso. Para a exportação, use os mesmos argumentos em Amahara.exe e `--evidence-dir=CAMINHO_ABSOLUTO`.

A pasta não possui repositório Git. Nenhum init, commit ou push foi realizado. Os 23 arquivos originais seguem separados e preservados.
