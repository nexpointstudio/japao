---
status: canon
area: operations
updated: 2026-10-06
read_when: "Mudanças da Bíblia"
---
# Mudanças da Bíblia

## 2026-10-06 — Etapas 1 e 2: Foundation e NexMotion 2D

- [[60_Producao/Foundation_Etapa_1|Foundation]] implementada e validada antes de iniciar a ferramenta: sessão/reset, dano, facções/alvos, IDs, WorldState v3 e contrato de animação v1.
- [[60_Producao/NexMotion_Etapa_2|Área 2D]] adicionada ao NexMotion real, preservando o módulo 3D: PNG + JSON, importações, playback, eventos, pivôs, status e snapshots comparáveis.
- [[60_Producao/Relatorio_Etapas_1_2|Validação final]]: Godot 208 PASS em projeto/export; NexMotion 215 testes Python e 47 verificações UI 2D PASS, além de 47 checks nativos 3D e integração/reabertura.
- Falha preexistente de cache de hash no Windows corrigida e retestada; diagnósticos residuais de encerramento forçado Godot e DirectComposition Qt registrados. Fontes protegidas e dados 3D preservados.
- Etapa 3 pendente. Novo Ren e conteúdo final não iniciados. Nenhum commit ou push.

## 2026-10-06 — Etapa 0: auditoria técnica e plano de migração

- Criados [[60_Producao/Auditoria_Etapa_0]], [[60_Producao/Matriz_Reaproveitamento]] e [[60_Producao/Plano_Migracao]].
- Inventariados fontes/assets/ferramentas em [[60_Producao/Inventario_Etapa_0]]; requisitos futuros em [[60_Producao/NexMotion_2D_Requisitos]].
- Executado [[60_Producao/Baseline_Etapa_0|baseline]] em cópia preservando projeto/builds: 158 checks passaram no projeto e no export, percurso e reabertura passaram. Encerramento forçado tem diagnóstico de cleanup; scripts web históricos bloqueados por Chromium ausente.
- Atualizados apenas roteamento e estado. Nenhuma implementação de Kuroyomi, remapeamento, asset novo, refatoração, commit ou push. Plano permanece `proposal`.

## 2026-10-06 — Fundação oficial de Dark: Kuroyomi

- Canon fornecido pelo usuário separado por narrativa, gameplay, mundo, conteúdo e arte/UI.
- Criados [[00_INDEX]], [[01_ESTADO_ATUAL]], [[AI_CONTEXT]] e fontes locais por domínio.
- Registradas [[90_Decisoes/README|quatro decisões estruturais]].
- Classificados documentos antigos sem promoção automática de lore/valores; [[99_Arquivo_Amahara/README]].
- README raiz passou a distinguir projeto atual e implementação do protótipo; cópia anterior preservada.
- Nenhum gameplay, código do jogo, asset, projeto Godot ou nome do repositório alterado.
- Validação documental em [[60_Producao/Validacao_Documental]]. Testes de gameplay não reexecutados.

Manter só mudanças relevantes; detalhes pertencem às notas de domínio.
