# Validação da amostra — 05/10/2026

Escopo: **marco visual/jogável 01**, não toda a Fase 1. Godot 4.6.1. A execução gráfica usou OpenGL Compatibility na AMD Radeon RX 7600. Testes isolam seus saves do usuário.

## Resultado automatizado

**53 PASS / 0 FAIL** na suíte do projeto. JSON: `evidence/sample_qa.json`; log: `evidence/sample_qa.log`. A suíte executa sistemas de Godot reais, inclusive física/Area2D, e contém dois grupos distintos:

1. Fixtures de integração: reposicionam entidades e chamam métodos para isolar regras, timings, dano, buffer, energia e save.
2. Percurso da amostra: reinicia o jogo e usa entradas de movimento, caminhos físicos e ataques para visitar Yuna, combater, visitar memorial/santuário e atravessar a ponte. Não usa teleporte nem dano direto nesse trecho. Direção de ataque e avanço de diálogo são controlados pela automação.

## Cobertura executada

Menu, viewport, TileMapLayer, Resources e Input Map; abertura e bloqueio de movimento durante diálogo; movimento e facing; diagonal normalizada; colisão com água e dash contra margem; três golpes leves e três pesados; ramificação ao finalizador pesado; expiração do buffer; dano por Area2D; dano único por ataque; energia por dano confirmado e ausência de ganho em dano rejeitado; dash e cooldown; esquiva perfeita e recompensa única; custo/bloqueio das magias; projétil acertando alvo real; selo e stagger; hurt, invulnerabilidade, morte, ações bloqueadas ao morrer, respawn e ausência de duplicação; pausa e controles; navegação aos pontos de interesse; eliminação do inimigo por ataques; cleanup; memorial, checkpoint; save/load, fallback de backup e continuar; retorno ao menu.

## Inspeção visual executada

Seis capturas do runtime: menu, diálogo, praça, ponte, combate e controles. Corrigidos: fundo de menu recortado indevidamente; barras que mantinham tamanho mínimo inadequado; textos de dano/postura sobrepostos; bordas artificiais do caminho. Arte atual é amostra para revisão, não aprovação humana de qualidade final.

## Problemas encontrados e tratamento

- O primeiro teste do projétil posicionava Yuna entre Ren e o alvo. O bloqueio era legítimo; o fixture foi movido para linha livre e passou.
- JSON inválido era corretamente recuperado por backup, mas a API estática imprimia ERROR. Leitura agora usa objeto JSON e resultado de parse, sem poluir o debugger.
- Encerramento de captura fechava antes de finalizar buffers de áudio. O fluxo normal agora para áudio e aguarda 150ms; capturas finais encerraram sem avisos de recursos pendentes.
- Um ajuste de indentação introduziu erro de parser durante desenvolvimento; corrigido antes da execução final.

## Limitações e testes pendentes

**BLOCKED:** validação física de DualSense. O runtime reportou lista de controles vazia. Mapeamentos existem e foram inspecionados por teste; isso não prova hardware, vibração ou ergonomia.

**PENDENTE:** avaliação humana de arte, animação, áudio e feeling; os outros arquétipos, combate em grupos, boss, dois segredos com recompensas, atalho e percurso da Fase 1 completa. Não atribuir PASS a conteúdo ausente. Não há benchmark prolongado de desempenho.

Git: pasta sem repositório. `git status`, `git diff --check` e `git diff --stat` não fornecem uma comparação válida aqui. Preservação das fontes é verificada por 23 hashes SHA-256. Nenhum commit ou push.

## Executável Windows

**53 PASS / 0 FAIL também no executável Windows exportado**, exit code 0. Evidências: `evidence/export/sample_qa.json` e `evidence/export/qa.log`. Executável aberto com renderização real produziu seis capturas adicionais e encerrou com exit code 0, sem ERROR/WARNING no log `evidence/export/capture.log`. Artefato de 109.599.848 bytes, com recursos incorporados. As capturas não usam nenhum asset solto externo ao pacote.
