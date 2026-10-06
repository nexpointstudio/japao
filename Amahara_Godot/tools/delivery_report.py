"""Build final reports from executed evidence. Never promotes missing checks to PASS."""
from pathlib import Path
import json, hashlib, datetime, subprocess

root=Path(__file__).resolve().parents[1]
e=root/'evidence'/'final'/'export'
reports={name:json.loads((e/(name+'.json')).read_text(encoding='utf-8')) for name in ['phase_qa','advanced_qa','settings_qa','playthrough','reopen']}
for name in ['phase_qa','advanced_qa','settings_qa']:
    assert reports[name]['fail']==0,(name,reports[name])
assert reports['playthrough']['pass'] and reports['reopen']['pass']
logs=['qa.log','advanced.log','settings-qa.log','playthrough.log','verify-save.log','capture.log']
for name in logs:
    text=(e/name).read_text(encoding='utf-8')
    assert 'ERROR:' not in text and 'WARNING:' not in text,name
original=json.loads((root/'docs/source_manifest.json').read_text(encoding='utf-8'))
for file in original:
    assert hashlib.sha256((root.parent/file['path']).read_bytes()).hexdigest()==file['sha256'],file['path']
exe=root.parent/'Jogar'/'Amahara.exe'
exe_hash=hashlib.sha256(exe.read_bytes()).hexdigest()
project_files=[root/'project.godot',root/'export_presets.cfg']
for directory in ['scripts','scenes','data','assets','tests']:
    project_files.extend(p for p in (root/directory).rglob('*') if p.is_file() and p.suffix not in ['.import','.uid'])
project_manifest=[{'path':str(p.relative_to(root)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(project_files)]
(root/'evidence/final/project_manifest.json').write_text(json.dumps(project_manifest,ensure_ascii=False,indent=2),encoding='utf-8')
count=sum(reports[name]['pass'] for name in ['phase_qa','advanced_qa','settings_qa'])
run=reports['playthrough']
git=subprocess.run(['git','rev-parse','--show-toplevel'],cwd=root.parent,capture_output=True,text=True)
assert git.returncode != 0, 'Repository state changed; inspect before reporting'
delivery={
 'date':datetime.datetime.now().isoformat(timespec='seconds'),
 'scope':'Fase 1 — O Primeiro Sino', 'engine':'Godot 4.6.1',
 'executable':str(exe),'bytes':exe.stat().st_size,'sha256':exe_hash,
 'automated_checks':count,'failures':0,'rendered_playthrough':run,
 'save_reopen':reports['reopen'],'preserved_original_files':len(original),
 'logs_clean':logs,'physical_dualsense':'NOT_TESTED','human_balance':'NOT_TESTED',
 'git':'not a repository; no init, commit or push',
 'art_assets':['title.png','ren_atlas.png','ren_actions.png','props_atlas.png','enemies_atlas.png','jinzo_atlas.png']}
(root/'evidence/final/delivery.json').write_text(json.dumps(delivery,ensure_ascii=False,indent=2),encoding='utf-8')
(root/'evidence/final/preservation.json').write_text(json.dumps({'result':'PASS','originals':len(original),'changed':0,'manifest':'docs/source_manifest.json'},indent=2),encoding='utf-8')
test_report=f'''# Relatório de testes — Fase 1

## Resultado executado

Godot 4.6.1, Windows x64. **{count} verificações automatizadas aprovadas, zero falhas** na soma das suítes. 123 de integração, 29 avançadas e 6 de configurações/animações. As suítes de integração e avançada também passaram no projeto editável (evidence/phase_qa.log e evidence/advanced_qa.log); a versão Windows tem registros separados em evidence/final/export. Suite settings também executada nos dois formatos.

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

O bot começou pelo botão do menu e usou eventos Input Map para movimento, interação, ataques e magias. Não alterou posição, dano, vida, energia, cooldown ou marcos. Lê estado para decidir; não representa uma pessoa jogando. A simulação foi acelerada 3× com 180 ticks/s. Chegou à tela final com {run['deaths']} mortes, dois segredos, atalho aberto e cinco encontros concluídos. A transição de Jinzō ocorreu {run['boss_transitions']} vez. Nem todos os padrões precisam aparecer neste percurso: cobertura completa de padrões vem das fixtures.

A execução gráfica da exportação durou {run['wall_seconds']:.1f} s de relógio e registrou média de {run['average_process_fps']:.1f} frames de processo/s, em OpenGL Compatibility / AMD Radeon RX 7600. É uma medição do percurso acelerado, não benchmark de hardware mínimo, latência de controle, 1% lows ou teste prolongado. O percurso headless do projeto também terminou antes da exportação, com evidência em evidence/final/playthrough.json.

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
'''
(root/'docs/11_TEST_REPORT.md').write_text(test_report,encoding='utf-8')
final=f'''# Relatório final — Amahara: O Primeiro Sino

## Entrega

Fase 1 jogável concluída, da abertura à vitória sobre Jinzō, em Godot 4.6.1/GDScript e Windows x64. A amostra visual foi aprovada e sua direção foi estendida à floresta, corrupção, santuário e arena. Projeto editável: `Amahara_Godot/project.godot`. Jogo: `Jogar/Amahara.exe`. Instruções: README.md e Jogar/LEIA-ME.txt. O executável anterior da amostra foi preservado.

## Conteúdo e mudanças

Ren Kurogane, Yuna, katana, dois combos de três golpes, duas magias, general Jinzō e mistério dos três sinos preservados. Implementados buffer limitado, rota mista, dash com colisão, energia em dano aceito, stagger, esquiva perfeita, cinco arquétipos, AStar/separação e vagas de agressão. Jinzō tem seis padrões, duas fases, transição única, invocações limitadas e tentativa totalmente reiniciável.

Jornada: aldeia → defesa → Yuna → ponte/floresta → corrupção → checkpoint → elite → Jinzō → conclusão. Desvios do altar e memorial com recompensas persistentes; atalho destravável; sobrevivente e inscrições; gates impedem eventos finais fora da ordem. Final preserva que Jinzō também respondeu ao chamado. Lore posterior da Bíblia segue como proposta, sem exposição antecipada.

Mundo usa TileMapLayer, corpos nativos e props com Y-sort; área/interação/combate em Area2D; ataques, inimigos, magias, boss e upgrades em Resources. Progressão, encontros, input, áudio, persistência e HUD são módulos próprios. Save v2 validado, temporário, backup e migração da amostra; opções persistem. Menus de início/continuar/controle/opções/pausa/conclusão, foco por teclado/controle e vibração opcional.

Seis imagens originais geradas com imagegen integrada estão em assets; prompts/briefs em ART_PROMPTS.md. Ren tem extensão de poses para dash, magia e queda. Treze WAVs originais e fonte de síntese incluídos. Iluminação seletiva, pisos de corrupção/arena, clareira do altar e HUD revisados em capturas reais. A arte de inimigos é limitada a poses com espelhamento; não promete animação direcional completa para cada inimigo.

## Verificação

**{count} PASS / 0 FAIL**, percurso gráfico da exportação até conclusão por comandos de jogo, dois segredos e atalho, novo processo reabrindo save concluído. Nove capturas de apresentação e capturas durante o percurso. Logs finais da exportação sem ERROR/WARNING. Relatório 11 detalha cobertura, fixtures, método e limitações; evidence/final/delivery.json contém os dados verificáveis.

Balanceamento inicial preserva danos originais e ajusta HP/tempos/escala para esta reconstrução. Corrigidos alvos do selo no boss, navegação em borda, reset de tentativa, cancelamento de eventos antigos, save duplicado/inválido, encerramento do áudio e árvores sobre o altar. Os 23 arquivos originais continuam byte a byte intactos segundo source_manifest.json e audit_sources.py.

## Limitações e encerramento

DualSense físico, avaliação humana de dificuldade/feeling, mixagem por audição e revisão por artista continuam não testados. Inimigos usam poucas poses/espelhamento; sobrevivente reutiliza a folha de aldeão com tonalidade. Reencontro final de Yuna ocorre em diálogo sobre a cena da arena. Projeto é editável por GDScript/Resources, com cenário composto em código. Executável não tem assinatura de distribuidor. Não há campanha posterior, multiplayer, crafting ou economia.

A sequência amostra → aprovação → implementação → testes → ajustes de balanceamento → revisão de capturas → polimento → exportação e verificação foi cumprida para a Fase 1. A referência de entrega é este relatório; os documentos anteriores estão arquivados em docs/history. Nenhum repositório Git foi criado; nenhum commit ou push executado.

## Identificação do pacote

Executável: {exe.stat().st_size:,} bytes. SHA-256: `{exe_hash}`.

Documentação consolidada: 00 auditoria; 01 migração; 02 pesquisa; 03 design; 04 narrativa; 05 combate; 06 inimigos; 07 mapa; 08 boss; 09 arte; 10 arquitetura; 11 testes. Este arquivo é o relatório de encerramento adicional. Os documentos refletem implementação e evidências, mantendo limites explícitos.
'''
(root/'docs/12_MILESTONE_REPORT.md').write_text(final,encoding='utf-8')
print(f'DELIVERY VERIFIED: {count} checks, 23 sources, executable {exe_hash}')
