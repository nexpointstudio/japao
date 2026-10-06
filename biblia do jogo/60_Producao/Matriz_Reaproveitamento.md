---
status: proposal
area: technical-audit
updated: 2026-10-06
read_when: "Consultar aproveitamento de um sistema sem carregar a auditoria inteira"
---
# Matriz de reaproveitamento

**Estimativas de engenharia, não medição de linhas nem porcentagem de jogo pronto.** Faixas expressam quanto da peça atual parece aproveitável após adaptação, não desconto de prazo. Não somar nem fazer média: os sistemas têm custos diferentes e faltam conteúdo e sistemas novos. Fundamentação em [[60_Producao/Auditoria_Etapa_0]]. Nenhuma decisão de reaproveitar foi executada.

A = reutilizar quase intacto; B = reutilizar com adaptação; C = substituir implementação; D = descontinuar no novo produto; E = referência/protótipo preservado. “Novo” indica ausência, não uma sexta categoria para código existente.

| Sistema / fonte | Estado atual | Kuroyomi precisa | Classe | Estimativa | Próxima ação / dependência / risco |
|---|---|---|---|---:|---|
| Hurtbox (`hurtbox.gd`) | Area2D mínima | Receptores de dano | A | 85–95% | Manter collider/ponte; explicitar contrato de ator. Baixo |
| Hitbox (`hitbox.gd`) | Dedupe e dano aceito | Multialvo e facções | B | 70–85% | Preservar begin/sample/finish; dados de hit/dono. Depende de Damageable. Médio |
| AttackData | Janelas, avanço, links | Combos/cancels/timeline | B | 65–80% | Manter tempos/shape; consumir cancelamento e direção. Pipeline/combate. Médio |
| Player | Corpo/estados misturados | Novo core ágil | B | 40–60% | Extrair combate/apresentação; manter movimento e morte. Input/contratos. Alto |
| Katana/buffer | Três leves/pesados, uma rota mista | Novas rotas, pós-dash | B | 45–65% | Reusar janela/dedupe; mudar transições. AttackData. Alto |
| Dash/Perfect Dodge | Colisão/iframes/recompensa | Evasão e maior Mana | B | 70–85% | Preservar validação, integrar cancelamentos e sinais. Player/Mana. Médio |
| Energia | Valor/custo/regen no player | Mana agressiva | B | 50–70% | Separar recurso e emissão; valores pendentes. Dano/dodge. Médio |
| Postura/knockback | Repetidos por ator | Resistências e interrupções | B | 50–70% | Reaproveitar matemática; política por alvo. Dano/AI. Médio |
| Hitstop/feedback | Freeze parcial via game | Feedback consistente | B | 45–65% | Definir relógios afetados, sinais de impacto. Combate/animação. Médio |
| EnemyData + IA | Cinco tipos num script | Papéis variados/aliados como alvo | B | 45–65% | Dados de papel e ações pequenas; target provider. Alto |
| Aggression tokens | Duas vagas/intervalo | Controle de pressão | B | 75–90% | Extrair de encounters; escopo local, fairness e hazards. AI/arena. Médio |
| EncounterDirector | Spawn/complete/reset + conteúdo | Encontros por região | B | 40–60% | Separar definição/estado/recompensa. WorldState. Médio |
| ENCOUNTERS e stages antigos | Coordenadas e cura fixa | Conteúdo novo | D | 0% direto | Preservar em legado; não levar regras/conteúdo por padrão |
| AStar/nearest_free | Grade estática por mapa | Rotas por região | B | 60–80% | Manter busca; dados de colisão/gates locais. Mundo. Médio |
| Separação local | Varredura O(n²) | Grupos legíveis | B | 40–60% | Manter para slice, medir antes de otimizar. IA. Médio |
| Boss runtime | Jinzō com seis padrões | 11 encontros, duas formas finais | B | 35–55% | Extrair fases/ações/reset e dados de arena. Dano/AI/WorldState. Alto |
| Conteúdo Jinzō | Falas, poses, ciclos específicos | Novos bosses | E | 0–10% direto | Caso de teste de framework; não canon |
| MagicData/cast | Dois slots e branches | Quatro magias/desbloqueios | B | 35–55% | Catálogo fixo e executor por magia. Mana/input/save. Médio |
| Projectile CelestialSlash | Slot 0 acoplado | Fogo Azul/arco | B | 45–65% | Dono, payload, colisão e lifetime por dados. Facções. Médio |
| AoE Selo | Busca por distância | Onda de Impacto | B | 40–60% | Resistência, oclusão e interação. Dano/ambiente. Médio |
| HostileEffect | Hazard/tiro contra Ren | Perigos reutilizáveis | B | 45–65% | Target mask, dano por alvo, ownership. AI/boss. Médio |
| Tornado/clones | Não implementados | Área persistente/aliados | Novo | 0% direto | Reusar peças acima, criar comportamento dedicado. Alto |
| Arco/targeting/outline | Não implementados | L2/right stick/R2 | Novo | 0% direto | Reusar projectile/raycast, novo targeting/UI. Médio |
| Mundo autorado em código | Única região e props hardcoded | Semiaberto editável | C | 10–25% | Preservar helpers, substituir forma de autoria. Scenes/Resources. Alto |
| TileMapLayer/colliders/Y-sort | Nativos e funcionais | Mundo/câmera | B | 65–80% | Manter tecnologias, migrar dados para cenas. Médio |
| Câmera | Follow/limites/shake fixos | Limites por região | B | 65–85% | Extrair rig/configuração. Scene de região. Baixo |
| Gates/interação/segredos | IDs locais, Area2D, flags | Revisitação persistente | B | 50–70% | IDs estáveis/condições; separar visual. WorldState. Médio |
| Mapa/minimapa/descoberta | Ausentes | Cartografia persistente | Novo | 0% direto | Dados por região e visualização. WorldState/UI. Médio |
| StoryProgression | Índice linear 0–6 | Flags/quests/eventos | C | 10–25% | Preservar padrões de snapshot/sinais; novo modelo. Alto |
| Diálogo/NPC controller | Arrays/callback/match em game | Condições e estados de NPC | C | 15–30% | Reusar painel/detector; dados de diálogo e resolver condições. Médio |
| Quests/desafios | Somente objetivo linear | Pequeno framework variado | Novo | 0% direto | Eventos/objetivos/recompensas idempotentes. WorldState. Médio |
| SaveStore I/O | Temporário/backup/validação | Persistência extensível | B | 70–85% | Manter fluxo; codec/schema separado e fault tests. Médio |
| Schema de save | IDs Amahara, v1→v2 | Magias/bosses/mapa/quests | C | 15–30% | Nova versão/namespace; política de legado explícita. Médio |
| Checkpoint/respawn | Dois pontos e reset | Estátuas por região | B | 50–70% | Reusar ciclo, IDs/ownership e estado persistente. Save/mundo. Médio |
| InputConfig | Teclado/pad padrão | Novo mapa/contextos | B | 55–75% | Manter abstração, rever D-pad/shoulders/triggers; hardware. Médio |
| UI widgets/menus | Foco, barras, opções | Novos layouts e telas | B | 40–60% | Componentizar em Scenes; dados por sinais. Médio |
| Layout/conteúdo antigo | Posições/textos específicos | Direção nova | E | 0–15% | Referência funcional; futuro redesign |
| Áudio runtime | 8 vozes + música | Buses/limites/transições | B | 60–80% | Manter ciclo/cleanup; buses e mute. Baixo |
| FX runtime | Desenho/arrays | Efeitos configuráveis | B | 50–70% | Manter helpers; centralizar payload e limites. Médio |
| Catalog.frame | Recorte AtlasTexture | Atlas formal | A | 80–95% | Helper aproveitável; exigir retângulos/pivôs validados. Baixo |
| Catalog.player_frames | Tabelas específicas | Pipeline NexMotion | C | 15–30% | Substituir autoria hardcoded por importador; reaproveitar SpriteFrames. Médio |
| Arte e WAVs atuais | Protótipo documentado | Assets aprovados futuros | E | Sem estimativa | Não produzir nem substituir agora |
| Export Windows | Preset funciona, PCK embutido | Build de produto | B | 65–85% | Excluir QA/imports indevidos; identidade/licenças/assinatura futuras. Médio |
| Testes Godot atuais | 158 checks + fluxos | Regressão e nova cobertura | B | 45–65% | Manter invariantes, trocar fixtures hardcoded. Médio |
| Sample/captures/HTML | Histórico | Comparação | E | Sem estimativa | Preservar; não contar como cobertura nova |
| Geradores de docs/dados | Escrevem arquivos antigos | Pipeline com fonte única | E | Sem estimativa | Não reexecutar; reavaliar antes de automação futura |

Maior economia está nas pequenas peças e nos cenários de regressão. Não há base para dizer “70% do novo jogo pronto”: mapa/campanha, conteúdo, alvos aliados, arco, missões e pipeline artístico ainda representam trabalho substancial. Dependências e ordem: [[60_Producao/Plano_Migracao]].
