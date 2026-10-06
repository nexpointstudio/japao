---
status: proposal
area: animation-pipeline
updated: 2026-10-06
read_when: "Planejar NexMotion 2D e contrato de exportação Godot"
---
# NexMotion 2D — requisitos da auditoria

**Não implementado.** Não foi inspecionado/alterado outro repositório NexMotion. Este documento deriva do consumidor Godot e do pedido, não afirma compatibilidade com uma API existente do NexMotion.

## Consumidor atual e lacunas

`Amahara_Godot/scripts/catalog.gd:10–48` recorta `AtlasTexture` e constrói `SpriteFrames` em memória. Ren usa `AnimatedSprite2D`, dez nomes de pose × quatro direções (`down`, `left`, `right`, `up`), 9 FPS em walk e 5 nas demais. Dash/cast/death não repetem; morte tem dois frames. Outras poses usam loop padrão, inclusive windup/ataques de um frame. Não há `AnimationPlayer`, timeline exportada, root motion, eventos de frame nem hitboxes por frame.

Ataques são relógios de segundos em `AttackData`; sprite é apresentação e não autoridade da janela ativa. O hitstop interrompe lógica mas não uniformemente a reprodução visual. Escala de Ren é `48 / largura da célula`, offset Y=-20; hit/hurtboxes têm offsets próprios. Inimigos usam `Sprite2D` com quatro poses e flip, boss oito poses; não possuem a mesma estrutura direcional de Ren.

Metadados PNG verificados: Ren 1774×887 em grade 8×4 → células fracionárias 221,75 px; ações/inimigos 1254×1254 em 4×4 → 313,5 px; Jinzō 1774×887 em 4×2 → 443,5 px. Recorte atual aceita frações, mas isso não é contrato robusto de pixel art. Props usam 16 retângulos manuais, não uma grade uniforme. Ver [inventário](Evidencias_Etapa_0/inventario.json). Import atual: compressão lossless, sem mipmaps, `fix_alpha_border=true`; filtro nearest e snap definidos no projeto. Não inferir que toda arte atual já respeita pixels uniformes pela configuração nearest.

## Estado após a Etapa 2

O escopo 2D autorizado foi implementado na ferramenta real, documentado em [[60_Producao/NexMotion_Etapa_2]]. O contrato efetivo v1 está em `Amahara_Godot/contracts/nexmotion2d.schema.json`: usa `animations`, pivôs e eventos extensíveis. Geometria de hitboxes, geração de Resources e adapter Godot continuam futuros; não confundir a lista ampliada abaixo, produzida na auditoria, com funcionalidades entregues.

## Requisitos mínimos propostos na auditoria

1. Biblioteca com ID estável de personagem/clip, versões, autoria/proveniência e status (rascunho, revisão, aprovado, rejeitado). Imutabilidade de origem e exportação derivada; nenhuma edição destrutiva silenciosa.
2. Nomes sem depender de linha/coluna: ação + direção, duração por frame/FPS, loop explícito, clips de um frame válidos, fallback direcional declarado. Não fixar contagem de direções para todos os atores.
3. Preview individual, play/pause, frame a frame, timeline/scrub, FPS, loop, zoom nearest, fundos sólido/quadriculado/cenário de teste, comparação de versões alinhadas pelo mesmo pivô. Revisão humana permanece necessária.
4. Entrada por spritesheet/atlas ou sequência PNG RGBA. Retângulos inteiros dentro da imagem, padding/extrusão e ordem explícitos; validar dimensão, transparência, frame ausente/duplicado e recortes sobrepostos indesejados.
5. Pivô/pés, origem, offset por frame, tamanho lógico, escala de pixels e offset de arma. Frame trim precisa conservar source size e pivot para não fazer Ren saltar no chão.
6. Trilhas opcionais de hurtbox/hitbox e pontos de arma/efeito por frame, com coordenadas locais e preview de colisão; não bakear colisão em pixels da imagem.
7. Eventos sem executar código arbitrário: marcadores de preparação/ativo/recuperação, som/VFX e janelas de cancelamento com IDs. Definir evento em frame zero, repetição, seek e interrupção. Scrub de preview não deve causar dano no runtime.
8. Fonte única de timing: `AttackData` referencia clip/marcadores ou importador deriva janelas. Não manter valores divergentes em editor e GDScript. Relógio de gameplay continua controlado pela simulação; interrupção/dash/morte invalidam eventos pendentes.
9. Exportação determinística, versão de schema, hash dos PNGs, caminhos relativos e validação automatizada. Reimportar sem perder links/UIDs nem sobrescrever ajustes manuais fora da pasta gerada.
10. Validação no Godot: todos os clips/direções resolvem, pivôs estáveis, loop/FPS corretos, bounds/colliders corretos; testes de dano só na janela, single-hit e cancelamento. Aprovação de arte separada de sucesso do importador.

## Formatos comparados

| Saída | Vantagem | Limite |
|---|---|---|
| PNG atlas + JSON versionado | Portável, legível, retângulos/pivôs/eventos, serve de fonte neutra | Exige importador Godot e validação do contrato |
| Spritesheet uniforme + JSON | Simples para personagens com grade consistente | Padding/desperdício; inadequado se frames variam muito sem source size/pivot |
| Sequência PNG + manifesto | Edição/versionamento individual fáceis | Muitos arquivos; empacotamento posterior desejável |
| SpriteFrames `.tres` direto | Godot consome naturalmente, sem montar tabela em runtime | Não representa sozinho hitboxes/eventos/pivôs por frame; vincula ferramenta à serialização/paths da engine |
| Resource próprio | Reúne clips, sockets, eventos e colisões | Schema/plugin GDScript precisam evoluir; não deve ser o único original editável |

**Recomendação:** fonte de intercâmbio **PNG atlas/frames + JSON versionado**; adaptador Godot gera `SpriteFrames.tres` + um Resource pequeno `CharacterAnimationSet`/metadados de eventos e pivôs. Assets e `.tres` gerados em diretório próprio, junto a manifesto de hashes e versão do importador. Não gerar `.godot` ou código de gameplay pelo NexMotion.

Contrato mínimo proposto: `schema_version`, `character_id`, `revision`, `textures`, `clips`; cada clip tem `action`, `direction`, `fps` ou durações, `loop`, `frames` (rect, pivot, source_size, offset), `events` e tracks de shapes. Unidades de arte são pixels locais; unidade/escala de mundo declarada uma vez. Nomes finais dos campos são proposta, não API aprovada.

Antes de personagens finais: testar o contrato com arte já existente em cópia derivada, detectar recortes fracionários como diagnóstico e provar round-trip/preview/import. Não consertar PNGs antigos nesta etapa. Pipeline precede produção de Ren final, mas a definição de escala/pivô deve preceder a ferramenta. Dependências: [[60_Producao/Plano_Migracao]].
