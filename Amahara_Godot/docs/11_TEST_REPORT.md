# Relatório de testes — Fase 1

## Resultado executado

Godot 4.6.1, Windows x64. **158 verificações automatizadas aprovadas, zero falhas** na soma das suítes. 123 de integração, 29 avançadas e 6 de configurações/animações. As suítes de integração e avançada também passaram no projeto editável (evidence/phase_qa.log e evidence/advanced_qa.log); a versão Windows tem registros separados em evidence/final/export. Suite settings também executada nos dois formatos.

| Evidência da exportação | Resultado |
|---|---|
| phase_qa.json / qa.log | 123 PASS, 0 FAIL |
| advanced_qa.json / advanced.log | 29 PASS, 0 FAIL |
| settings_qa.json / settings-qa.log | 6 PASS, 0 FAIL |
| playthrough.json / playthrough.log | Menu até conclusão com Input Map; stage 6 |
| reopen.json / verify-save.log | Novo processo carregou conclusão, 125 energia e dois segredos |
| capture.log / 01..09 PNG | Nove capturas renderizadas de apresentação |
| run_stage_*.png / run_victory.png | Capturas durante o percurso automatizado |
| ../preservation.json | 23 arquivos originais, zero alterações |

## Método e cobertura

Fixtures isoladas reposicionam entidades e chamam métodos para avaliar regras. Elas cobrem movimento, diagonal, facing, água/paredes, dois combos completos, rota mista, expiração de buffer, janelas ativas, deduplicação, energia só em dano aceito, dash/iframes/cooldown, esquiva perfeita uma vez, duas magias, dano/morte, retorno ao checkpoint e limpeza. Cinco arquétipos são instanciados com preparação/ação/recuperação, resistência, stagger e morte. Grupos testados: dois melee; melee/corredor; melee/arqueiro; pesado/arqueiro; quatro ou mais.

Avançada cobre dano de zona somente após aviso, um dano por zona, flecha bloqueada, linha de tiro, navegação junto de pedra, pausa na transição, os seis padrões do boss em fase 2 e recuperação. Integração cobre seis padrões, mudança aos 50%, transição única e limite de invocações. Morte real de Ren durante a tentativa recria boss/arena/summons/perigos. Vitória, retorno ao menu, novo jogo e callback antigo cancelado também foram exercitados.

Save: ida/volta em disco, conteúdo inválido, backup, checkpoint repetido, segredo repetido, recompensa uma vez, preservação de upgrades e fechamento/reabertura em outro processo. Configurações de música/efeitos/vibração são gravadas e relidas; não foi alegado teste físico de vibração. Menus têm foco exercitado e todos os Input Maps incluem teclado e controle.

## Percurso completo separado

O bot começou pelo botão do menu e usou eventos Input Map para movimento, interação, ataques e magias. Não alterou posição, dano, vida, energia, cooldown ou marcos. Lê estado para decidir; não representa uma pessoa jogando. A simulação foi acelerada 3× com 180 ticks/s. Chegou à tela final com 0 mortes, dois segredos, atalho aberto e cinco encontros concluídos. A transição de Jinzō ocorreu 1 vez. Nem todos os padrões precisam aparecer neste percurso: cobertura completa de padrões vem das fixtures.

A execução gráfica da exportação durou 41.0 s de relógio e registrou média de 73.8 frames de processo/s, em OpenGL Compatibility / AMD Radeon RX 7600. É uma medição do percurso acelerado, não benchmark de hardware mínimo, latência de controle, 1% lows ou teste prolongado. O percurso headless do projeto também terminou antes da exportação, com evidência em evidence/final/playthrough.json.

## Correções verificadas

1. Selo não conseguia acrescentar Jinzō a um Array tipado de VillageEnemy: lista de alvos agora é heterogênea explicitamente construída.
2. Posição empurrada para margem de célula sólida podia produzir caminho vazio: navegação resolve célula livre próxima.
3. Fixtures de arqueiro/selo esperavam além da janela ativa: passaram a usar o tempo restante da preparação, conservando o comportamento do jogo.
4. Áudio da exportação mantinha um WAV ao encerrar: parada, desligamento de reinício automático, liberação dos players/streams e 0,5 s antes do quit. Logs finais sem ERROR/WARNING.
5. Árvores encobriam altar/Ren: clareira ampliada; captura e percurso repetidos após ajuste.

## Limites explícitos

DualSense físico USB/Bluetooth: **NÃO TESTADO**, runtime reportou controllers=[]. Dificuldade, ergonomia, sensação do controle, audição da mixagem e revisão por artista humano: **NÃO VALIDADAS por estes testes**. A direção da amostra foi aprovada pelo usuário; compilação e automação não certificam qualidade artística. Não houve soak test prolongado nem teste em outra máquina. A Fase 1 é o limite, sem campanha posterior.

O marco anterior de 53 verificações continua em evidence/sample_qa.json e evidence/export; não foi contado de novo como cobertura adicional da fase. Logs de desenvolvimento podem conservar erros já corrigidos; os seis logs listados acima são a referência final.

Git não disponível nesta pasta: comandos de status/diff/commit não fornecem comparação de repositório. Nenhum init, commit ou push. Preservação comprovada por SHA-256 das 23 fontes.
