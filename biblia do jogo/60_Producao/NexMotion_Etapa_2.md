---
status: implemented
area: animation-pipeline
updated: 2026-10-06
---
# Etapa 2 — NexMotion 2D

Implementado na instalação **real** `D:\ver animaçao` (alias existente `D:\NexAnimationLabDev`). Não foi criado um segundo aplicativo no repositório do jogo. Abra `Abrir NexMotion Studio.cmd` e escolha **2D**. Os workspaces 3D permanecem no mesmo aplicativo.

## Entrega efetiva

Biblioteca de entidades, IDs estáveis, nomes/tipos, thumbnail, contagem de clips e status. Importação de spritesheet por grade/região/ordem/quantidade; sequência PNG em ordem alfabética; pacote JSON. Playback com FPS/loop de preview, scrub, frames clicáveis, eventos, zoom nearest, fundos e centralização. Propriedades autorais de FPS, loop, direção livre, pivô e offsets; override de pivot por frame. Eventos customizados com payload JSON e CRUD. Draft/Review/Approved/Rework; snapshots imutáveis e comparação lado a lado, inclusive de PNGs diferentes.

Fonte canônica: **PNG + JSON v1**, engine-agnostic. Schema formal idêntico em `App/animation2d/schema.json` e `Amahara_Godot/contracts/nexmotion2d.schema.json`. Exporta pacote portátil com caminhos relativos. Dois pacotes produzidos pelo NexMotion também passaram pelo validador de metadata GDScript; isso não é importação para Godot.

## Arquitetura e preservação

Módulo independente `App/animation2d`, UI em `App/ui/animation2d.py`; integração pequena em `nex_window.py`. Biblioteca `Studio/Animation2D/<id>`, PNGs por conteúdo, `character.anim.json`, backup e snapshots `vNNNNNN.anim.json`. Validação antes de substituir, temporário/flush/releitura/replace, lock e detecção de revisão desatualizada. Recuperação explícita preserva o arquivo inválido. Cache de imagens limitado e JSON em memória durante playback.

A correção adicional em `App/library/processing.py` evita cache de hash em arquivos recém-modificados, resolvendo falha reproduzida no baseline Windows. O comportamento de rig/animação 3D não foi redesenhado. Banco autoral comparado logicamente com backup: idêntico. 3.272 fontes protegidas sem alteração.

## Workflow

Artista/gerador → PNG → NexMotion 2D → Review → Approved → PNG + JSON → **Etapa 3 futura: Godot Adapter** → jogo.

Guia completo: `D:\ver animaçao\GUIA_NEXMOTION_2D.md`. Arquitetura e campos: `D:\ver animaçao\App\animation2d\README.md`. Pacote técnico aprovado: `D:\ver animaçao\Exports\Animation2D\FixtureMarker_Approved_v3`. Revisão humana continua necessária; status Approved é autoral.

## Validação e limites

55 testes 2D + 160 existentes: **215 PASS**. Interface real: 33 verificações principais + 9 de importação/revisões + 5 de reabertura em outro processo, todas PASS. Editor nativo 3D: **47 PASS**, export/reimport GLB e integração da janela com edição/autosave/reload passaram. Capturas e logs em `D:\ver animaçao\Reports\Animation2D`, com seleção copiada para `Evidencias_Etapa_2` neste cofre.

Não há `.tres`, adapter Godot, editor de pixel art, hitboxes geométricas ou conteúdo final. Sequência PNG exige canvas uniforme; JSON pode expressar recortes diferentes com pivôs explícitos. Importação/validação e thumbnails são síncronos; não há garantia de latência para pacotes gigantes. Campos de propriedades devem ser **aplicados** antes de salvar. Ao reimportar arte, eventos válidos e pivot do clip são preservados; offsets/overrides de frames novos precisam de revisão.

**Etapa 3 pendente. Novo Ren não iniciado.** [[60_Producao/Relatorio_Etapas_1_2|Relatório consolidado]].
