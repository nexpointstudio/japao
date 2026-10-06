---
status: implemented
area: technical
updated: 2026-10-06
---
# Etapa 1 - Foundation tecnica

Gate executado: **208 PASS / 0 FAIL** (158 verificacoes herdadas + 50 novas), no projeto e no export Windows. Percurso completo, reabertura v2 e reabertura do estado generico v3 passaram em processos separados. Evidencia: [GATE_ETAPA_1.json](Evidencias_Etapa_1/GATE_ETAPA_1.json).

## Implementado
- GameSession controla estado, morte/respawn, checkpoint, reset e invalidacao por geracao; contrato para futura troca de regiao.
- CombatHit transporta atacante/alvo/dano/knockback/postura/direcao/tipo/ID/propriedades; Hitbox/Hurtbox nativas preservadas.
- Faccoes PLAYER/ALLY/ENEMY/NEUTRAL e registro generico de alvos. IA e boss aceitam alvos aliados sem depender da classe Ren.
- IDs persistentes com convencao e deteccao de duplicacao.
- WorldState v3 separado do save Amahara v2; validacao, temporario, backup, recuperacao. Sem conversao automatica de progresso narrativo legado.
- Contrato engine-agnostic de animacao PNG + JSON v1: frames, tempos, direcao, pivots, offsets, eventos extensivos, revisoes e status. Schema formal em Amahara_Godot/contracts.

## Preservacao e limites
Combos, dash, Perfect Dodge, energia, dados de ataques, arte, encounter e percurso antigos preservados. 86 arquivos protegidos sem mudancas; originais conferidos pelo auditor. Mundo por coordenadas e narrativa permanecem no adaptador legado; reconstruir regioes fica para etapa futura. Nenhum novo conteudo final foi criado.

## Testes e diagnosticos
Baseline antes da alteracao: 158 PASS em projeto/export, percurso e reopen aprovados. Resultado final: 208 PASS nos dois ambientes. Execucoes e JSONs em Evidencias_Etapa_1/final; correcoes adicionais registradas em correction_commands.json e foundation_reopen_corrected_command.json.
O encerramento forcado com --quit-after conserva o diagnostico preexistente ObjectDB/resources in use. Encerramentos normais das suites ficaram limpos. Uma anotacao de tipo do probe foi corrigida; export ignora --script standalone, portanto a reabertura v3 exportada foi comprovada pelo dispatcher --verify-save --verify-world. As tentativas malsucedidas continuam nos logs.

Nao houve regressao nos cenarios executados. Testes automatizados nao certificam arte, sensacao de controle ou DualSense fisico. Detalhes dos contratos: Amahara_Godot/docs/FOUNDATION.md.

**Etapa 2 autorizada pelo gate. Etapa 3 e novo Ren nao iniciados.**
