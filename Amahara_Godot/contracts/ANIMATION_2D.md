# NexMotion 2D — contrato de intercâmbio v1

Fonte primária: PNGs imutáveis + documento `*.anim.json`. Schema estrutural em `nexmotion2d.schema.json`; validação semântica também obrigatória. Não é um importador Godot e não gera `.tres` nesta etapa.

O documento possui `schema_version=1`, `character_id`, `display_name`, `kind`, `revision`, `status`, `textures`, `animations`, `tags` e `metadata`. IDs técnicos são estáveis, minúsculos, começam por letra e aceitam letras/números/underscore/ponto/hífen (até 128 caracteres). Revisões começam em 1. Estados: Draft, Review, Approved, Rework. Direção é string livre; vazia significa não direcional.

Cada textura declara `texture_id`, caminho PNG relativo ao pacote, largura/altura inteiras positivas e hash SHA-256 opcional. Paths absolutos, traversal e symlinks que escapem do pacote não são arquivos de intercâmbio válidos. Validadores de biblioteca conferem existência, tamanho real e hash quando presente; o validador GDScript de contrato confere metadata, sem importar imagens.

Cada animação declara `animation_id`, nome, revisão/status, `fps` positivo até 240, `duration` total em segundos, `loop`, `direction`, `pivot`, frames ordenados, eventos, tags e metadata. Cada frame declara textura, `rect=[x,y,w,h]` em pixels inteiros, `duration>0` e `offset=[x,y]`; pode substituir o pivot e guardar metadata. A duração total deve ser a soma dos frames. FPS é referência nominal; durações individuais permitem exposições diferentes. Alterar FPS na autoria escala durações proporcionalmente; velocidade de preview pode divergir sem alterar metadata.

**Pivô:** coordenadas em pixels relativas ao canto superior esquerdo do recorte, eixo X para direita/Y para baixo. O anchor mundial representa pés/base do ator. Posição de desenho = `anchor - pivot_do_frame + offset_do_frame`; sem override usa pivot da animação. Se recortar borda esquerda/topo, subtrair esse recorte do pivot; não recentralizar pelo tamanho do frame. Pivot pode estar fora do recorte (efeitos/queda), mas precisa ser finito. Zoom escala imagem, pivot e offset juntos. Não altera PNG. Uma pose de tamanho diferente conserva o mesmo anchor lógico.

**Eventos:** `event_id` único dentro do clip, `frame` zero-based, `name` livre não vazio e `payload` objeto extensível. Exemplos: attack_start, hitbox_on/off, combo_window_open/close, footstep, projectile_spawn, vfx, sfx, invulnerability_on/off. São nomes de dados, nunca execução de código. `payload.hitbox_ref` pode apontar para configuração de gameplay futura; a geometria não é obrigatória nesta versão.

Semântica futura de playback: evento acontece na entrada do frame, inclusive zero ao iniciar/reiniciar; numa volta do loop acontece novamente. Seek/scrub no editor apenas inspeciona, não causa efeitos de jogo. Interromper/trocar animação invalida eventos pendentes; o adaptador futuro deve definir consumo único por instância/ciclo e relógio de hitstop. Nenhum desses eventos controla hoje a katana antiga automaticamente.

Revisão salva deve ser imutável; editar cria novo snapshot. `Approved` identifica a revisão aprovada, sem apagar as anteriores. JSON serializado em UTF-8, chaves ordenadas, números finitos, caminhos relativos e newline final. Campos futuros ficam em `metadata`/`payload` até uma alteração explícita do schema. Schema incompatível é rejeitado, nunca convertido silenciosamente.

`fixture.anim.json` é fixture de metadata, não personagem nem pacote visual aprovado. Na Etapa 2 uma biblioteca real deverá validar PNGs e criar pacotes completos. Etapa 3 permanece responsável por PNG+JSON → SpriteFrames/Resources, resolução de UID e integração de eventos com gameplay.
