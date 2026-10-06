# AMAHARA: JURAMENTO DE GUERRA
## Bíblia Mestra do Jogo, Documento de Design, Lore Completa e Arquivo de Produção

**Versão do documento:** 1.0  
**Data de consolidação:** 04/10/2026  
**Status do projeto documentado:** Vertical slice jogável da Fase 1 concluído; expansão de lore e visão de jogo completo documentadas como proposta canônica.  
**Título atual:** **Amahara: Juramento de Guerra**  
**Gênero:** Action Adventure / Action RPG 2D top-down em tempo real  
**Direção visual:** Pixel Art com linguagem da era 32-bit  
**Ambientação:** Japão antigo fantástico, com mundo humano e espiritual em sobreposição  
**Plataforma atual:** Navegador desktop (HTML/CSS/JavaScript + Canvas)  

---

# 0. COMO LER ESTE DOCUMENTO

Este arquivo foi criado para funcionar como a **fonte única de referência de Amahara**. Ele reúne o pedido original que originou o projeto, as decisões tomadas durante a implementação, a lore existente no vertical slice, uma proposta completa de lore para o jogo inteiro, sistemas de gameplay, balanceamento, controles, arquitetura, testes, limitações, pesquisa cultural, detalhes internos de desenvolvimento e anexos com os arquivos textuais que formam o projeto.

Para evitar misturar o que já existe com o que foi criado agora como expansão, o documento usa estas classificações:

- **[IMPLEMENTADO]**: está no vertical slice entregue e existe no código atual.
- **[DEFINIDO NO PROMPT]**: foi solicitado explicitamente no prompt original.
- **[PESQUISA]**: veio das notas de pesquisa utilizadas durante a criação.
- **[PROPOSTA CANÔNICA]**: expansão criada para responder como seria Amahara caso se tornasse um jogo completo. Ainda não está implementada, mas é escrita para poder ser adotada como canon oficial.
- **[PENDENTE]**: existe como intenção, limitação ou próximo passo, mas não foi validado/implementado por completo.
- **[TÉCNICO]**: detalhe interno de implementação, testes ou infraestrutura.

O objetivo é que este arquivo possa ser usado futuramente por você, por Codex, por outra IA, por um programador, por um artista ou por um game designer sem depender da memória da conversa original.

---

# 1. RESUMO EXECUTIVO

## 1.1 O que é Amahara

**Amahara: Juramento de Guerra** é um action-adventure 2D top-down em Pixel Art ambientado em um Japão antigo fantástico. O jogador controla **Ren Kurogane**, um jovem guerreiro mortal que carrega sangue divino e uma marca ligada a uma antiga força sobrenatural de guerra.

A abertura do jogo acontece na aldeia de Amahara. Uma rotina aparentemente tranquila é interrompida quando guerreiros humanos mortos, ainda vestidos com armaduras antigas, são reanimados e invadem a aldeia. Ren combate os invasores usando katana, dois estilos de combo, um dash e duas magias ligadas à sua natureza divina. A investigação o conduz por uma floresta, um caminho de santuário corrompido e finalmente ao **General Jinzō, o Estandarte Oco**, antigo comandante morto há oitenta anos.

Ao derrotar Jinzō, Ren descobre que ele não foi o responsável por despertar os mortos. Jinzō também foi chamado por uma força externa. Antes de desaparecer, ele fala de **três sinos, três sepulturas e alguém que conhece o sangue de Ren**. Essa revelação encerra o vertical slice e abre a história maior.

## 1.2 O que já existe no vertical slice

**[IMPLEMENTADO]**

- Menu inicial e painel de controles.
- Pausa, reinício de fase e retorno ao menu.
- Movimento em oito direções com diagonal normalizada.
- Facing cardinal: cima, baixo, esquerda e direita.
- Colisão com terreno, água, objetos e limites do mapa.
- Katana com hitbox real, startup, active e recovery.
- Combo rápido de três golpes.
- Combo pesado de três golpes.
- Input buffer para sequência dos combos.
- Proteção single-hit por instância de ataque.
- Dash direcional com i-frames curtos e cooldown.
- Duas magias: Corte Celeste e Selo de Ruptura.
- Recurso de Energia Divina.
- Regeneração passiva de energia e ganho por acertos de katana.
- HP, hit reaction, knockback, invulnerabilidade pós-hit e morte.
- Quatro arquétipos de guerreiros zumbis.
- IA por estados com aggro, telegraph, ataque, recovery e disengage.
- Coordenação simples de combate em grupo para evitar ataques simultâneos excessivos.
- NPC narrativo: Yuna.
- Sistema de diálogo.
- Interação contextual.
- Segredo e upgrade permanente durante a fase.
- Shrine/checkpoint.
- Respawn sem recarregar a página.
- Boss exclusivo em duas fases.
- Boss arena com barreira dinâmica.
- HUD de HP, Energia Divina, objetivo, magias e boss HP.
- Pixel Art procedural por Canvas.
- Efeitos de hit, trails, rings, partículas, hit stop e screen shake.
- Áudio procedural via Web Audio.
- Suporte lógico a DualSense via Gamepad API.
- Debug mode.
- Smoke tests e logic suite em Chromium headless.

## 1.3 Pilares que não devem ser perdidos

Os pilares originais que definem Amahara são:

1. **Japão antigo fantástico.**
2. **Semideus da guerra mortal e vulnerável.**
3. **Katana como coração do combate.**
4. **Guerreiros zumbis como ameaça central inicial.**
5. **Dois combos com funções diferentes.**
6. **Duas magias principais, não simples variações de cor.**
7. **Dash para mobilidade e defesa.**
8. **Exploração top-down, não apenas arenas.**
9. **Pixel Art detalhada e pixel-perfect.**
10. **Bosses com padrões legíveis, fases e janelas de punição.**
11. **Mistério de longo prazo, sem explicar tudo na primeira fase.**
12. **Identidade própria; referências visuais não podem virar cópia.**

---

# 2. IDENTIDADE DO JOGO

## 2.1 Título

**Amahara: Juramento de Guerra**.

“Amahara” é o nome da aldeia que funciona como ponto de origem emocional de Ren. “Juramento de Guerra” resume o conflito central: Ren possui um poder que responde à violência e à guerra, mas precisa decidir qual juramento vai dar sentido a esse poder.

## 2.2 Fantasia central do jogador

O jogador deve sentir que controla um guerreiro extremamente habilidoso, mas não invencível, capaz de alternar rapidamente entre:

- técnica de katana;
- posicionamento;
- esquiva;
- controle de grupo;
- poder sobrenatural;
- exploração;
- leitura dos inimigos.

A fantasia não é “ser um mago que também tem espada”. A katana permanece a base. A magia existe para ampliar opções e expressar a natureza divina de Ren.

## 2.3 Tom

O tom é **melancólico, mítico, violento sem gore extremo e progressivamente sobrenatural**.

A aldeia começa relativamente viva e quente. A floresta introduz silêncio e sinais de anormalidade. O santuário degrada a paleta e a atmosfera. A arena do boss já está dominada por corrupção espiritual.

## 2.4 Temas

Temas centrais propostos:

- guerra como força que continua produzindo consequências depois que a batalha termina;
- diferença entre lutar para proteger e lutar porque a violência passou a definir quem você é;
- memória dos mortos;
- juramentos;
- responsabilidade pelo poder herdado;
- paz imposta versus paz escolhida;
- a tentação de resolver conflitos controlando pessoas;
- identidade humana versus destino divino.

---

# 3. REFERÊNCIAS E LIMITES CRIATIVOS

## 3.1 Referência visual de jogos antigos

**[DEFINIDO NO PROMPT]** Pokémon antigo pode servir de referência apenas para linguagem visual, escala de sprites, perspectiva top-down, uso de tiles e densidade de cenário. O gameplay de Amahara não é baseado em Pokémon: não há batalha por turno, captura de criaturas ou sistemas equivalentes.

A direção busca a legibilidade e o charme de jogos 2D 16/32-bit, mas com combate de ação em tempo real.

## 3.2 Pesquisa histórica/cultural utilizada

**[PESQUISA]** As notas do projeto registram consulta a materiais da Kokugakuin University/Encyclopedia of Shinto e do Metropolitan Museum of Art. Os principais usos foram:

- torii como marcador de entrada e transição para espaço sagrado;
- estrutura de recintos de santuário e caminhos de aproximação;
- ambivalência histórica do conceito de oni, evitando reduzir tudo ao estereótipo de “monstro vermelho”;
- referências visuais de yoroi/dō-maru, placas, laca, cordões e silhuetas de capacetes;
- uso de santuários, lanternas e espaços urbanos como componentes funcionais da composição, e não como símbolos jogados aleatoriamente.

A cosmologia de Amahara é deliberadamente ficcional. O jogo pode se inspirar na estética e em conceitos gerais do Japão antigo, mas não deve apresentar a mitologia inventada como se fosse tradição histórica real.

## 3.3 Regras de originalidade

Não copiar diretamente:

- Pokémon ou qualquer outro jogo;
- personagens existentes;
- mapas;
- sprites;
- UI;
- músicas;
- efeitos sonoros;
- bosses;
- nomes;
- histórias;
- sistemas específicos protegidos como identidade de outra obra.

O objetivo é usar referências como vocabulário de design e pesquisa, nunca como molde para reprodução.

---

# 4. PROTAGONISTA — REN KUROGANE

## 4.1 Estado atual

**[IMPLEMENTADO]** Ren Kurogane é o protagonista do vertical slice. Ele é um jovem guerreiro criado em Amahara por Yuna e carrega a **Marca do Estandarte**, sinal de sua origem divina.

Seu sprite atual o representa com:

- cabelo escuro;
- torso em vermelho profundo;
- hakama escuro;
- katana;
- marca/detalhe dourado;
- silhueta visualmente distinta dos mortos reanimados.

## 4.2 Personalidade

**[PROPOSTA CANÔNICA]**

Ren é observador, contido e muito mais desconfiado do que impulsivo. Ele sabe que existe algo incomum em seu corpo, mas não foi criado para se considerar superior aos humanos. Yuna o ensinou desde cedo que força sem disciplina transforma proteção em dominação.

Ele tende a falar pouco, especialmente sob tensão. Sua raiva aparece mais nas decisões e na maneira de lutar do que em discursos. Seu principal conflito pessoal é descobrir que o poder dentro dele **fica mais forte durante o combate**, o que o obriga a questionar se cada vitória o aproxima de dominar a guerra ou de ser dominado por ela.

## 4.3 Idade e condição

**[PROPOSTA CANÔNICA]** Ren tem aproximadamente 22 anos no início da história. É um semideus, mas continua sujeito a:

- ferimentos;
- cansaço;
- erro;
- medo;
- morte;
- crescimento técnico.

## 4.4 Origem divina completa

**[PROPOSTA CANÔNICA]** A “divindade da guerra” de Amahara não é uma cópia de uma entidade histórica específica. Ela é uma força ficcional conhecida apenas como **O Estandarte**.

O Estandarte nasceu, segundo a tradição do universo, do primeiro juramento coletivo de um grupo humano que escolheu permanecer e defender outros em vez de fugir. Com os séculos, a mesma força passou a absorver juramentos de conquista, vingança e glória. Por isso ela possui duas tendências inseparáveis:

- **o Voto** — coragem, proteção, disciplina, sacrifício e união;
- **a Fome** — escalada, domínio, violência, obsessão por vitória e perpetuação do conflito.

Ren é filho de uma mulher humana e de uma manifestação temporária do Estandarte. Isso o torna um semideus, mas não um avatar completo. A Marca do Estandarte no corpo de Ren é apenas um fragmento da força total.

## 4.5 O juramento de Ren

A frase que resume sua trajetória completa é:

> “Eu não lutarei porque a guerra me chama. Lutarei para que ela termine onde eu estiver.”

Esse é o sentido final de **Juramento de Guerra**: Ren aceita que possui poder ligado à guerra, mas rejeita a ideia de que guerra deva ser o propósito desse poder.

---

# 5. YUNA — GUARDIÃ DE AMAHARA

## 5.1 Estado atual

**[IMPLEMENTADO]** Yuna é a Guardiã do Santuário e o principal NPC narrativo da Fase 1. Ela cria a primeira sensação de rotina e é a pessoa que aponta a ligação das armaduras reanimadas com o General Jinzō.

Diálogos importantes já implementados incluem o sino do santuário tocando sozinho, a lembrança de que Jinzō morreu há oitenta anos e a observação de que a marca de Ren está brilhando como na noite em que sua mãe o levou até Yuna.

## 5.2 Papel na história completa

**[PROPOSTA CANÔNICA]** Yuna era uma jovem guardiã quando conheceu **Mio Kurogane**, mãe de Ren. Mio chegou a Amahara fugindo de uma ordem ritual ligada ao Estandarte e entregou o bebê a Yuna antes de partir para reforçar os selos dos antigos campos de guerra.

Yuna sabe desde o começo que Ren é semidivino, mas não conhece toda a verdade do ritual que originou seu nascimento. Ela esconde parte do passado para impedir que Ren cresça acreditando ter obrigação de cumprir um destino divino.

No jogo completo, Yuna funciona como:

- âncora emocional;
- fonte de contexto histórico;
- personagem que confronta Ren quando ele passa a usar o poder de forma excessiva;
- guardiã do hub reconstruído de Amahara;
- elo com Mio;
- personagem que representa a ideia de que disciplina é tão importante quanto força.

---

# 6. MIO KUROGANE — MÃE DE REN

**[PROPOSTA CANÔNICA]**

Mio Kurogane é a mãe humana de Ren. Antes do nascimento dele, ela fazia parte de uma linhagem de guardiões encarregada de manter selados locais onde milhares de guerreiros morreram durante a antiga guerra civil conhecida como **Guerra dos Sete Estandartes**.

Décadas depois da guerra, o estudioso ritualista Seigan Tsukishiro tentou usar os antigos selos para manifestar novamente o Estandarte. Mio participou inicialmente do trabalho acreditando que o objetivo era impedir novos conflitos. Ao perceber que Seigan queria transformar o poder da guerra em um mecanismo de controle absoluto, ela rompeu o ritual.

Durante essa ruptura, o Estandarte assumiu forma humana por tempo suficiente para gerar Ren. Mio compreendeu que o menino poderia se tornar tanto uma chave para libertar os mortos quanto uma chave para controlá-los.

Ela levou Ren até Yuna e desapareceu para reconstruir os selos. No presente do jogo, Mio não está morta: permanece viva, mas presa a uma rede espiritual que sustenta um dos últimos lacres do ritual de Seigan.

Essa verdade só seria revelada na segunda metade do jogo.

---

# 7. ANTAGONISTA PRINCIPAL — SEIGAN TSUKISHIRO

**[PROPOSTA CANÔNICA]**

Seigan Tsukishiro é o antagonista humano principal da história completa. Ele foi um estudioso de rituais, memória dos mortos e lugares de batalha. Quando jovem, teve contato com registros da Guerra dos Sete Estandartes e concluiu que o ciclo de guerras não terminaria enquanto decisões humanas continuassem sendo guiadas por ambição, medo e vingança.

Sua solução é monstruosa justamente porque nasce de uma intenção compreensível: **criar uma paz que ninguém possa escolher quebrar**.

Seigan descobriu que os mortos de grandes campos de batalha deixam “ecos de juramento”. Os Três Sinos Sepulcrais podem fazer esses ecos retornarem aos corpos. O Estandarte, por sua vez, é capaz de unificar milhares de juramentos sob uma única vontade. Ren é o único ser vivo conhecido cujo sangue pode suportar essa conexão sem ser destruído instantaneamente.

O plano de Seigan é chamado de **Grande Silêncio**:

1. despertar as sepulturas de guerra;
2. transformar os mortos em um exército sem vontade própria;
3. fazer Ren acumular energia e fragmentos do Estandarte durante sua jornada;
4. usar o sangue de Ren como comando central;
5. subjugar exércitos, senhores e rebeliões;
6. impor uma paz permanente pela eliminação da possibilidade de resistência.

Ele não deseja destruir Ren. Ele deseja “completá-lo”. Esse é o motivo pelo qual os eventos parecem conduzir o protagonista de um selo a outro.

---

# 8. GENERAL JINZŌ — O ESTANDARTE OCO

## 8.1 Estado atual

**[IMPLEMENTADO]** General Jinzō é o boss da primeira fase. Foi um comandante morto há aproximadamente oitenta anos, sepultado com seus soldados. Reanimado, tornou-se um foco de comando para outros cadáveres.

Ele possui duas fases de combate e revela que também foi convocado por outra força.

## 8.2 História completa

**[PROPOSTA CANÔNICA]** Durante a Guerra dos Sete Estandartes, Jinzō comandava uma força responsável por proteger um desfiladeiro que dava acesso a comunidades civis. Sua última ordem foi manter a posição até a evacuação terminar. Os superiores alteraram o plano e sacrificaram sua unidade sem avisá-lo.

Jinzō morreu acreditando que ainda protegia alguém. Esse juramento incompleto tornou seu cadáver extremamente receptivo ao Estandarte. Quando Seigan toca o primeiro selo, Jinzō desperta sem sua identidade inteira: sobra a disciplina, a ordem de avançar e a necessidade de obedecer a um comando que ele já não consegue reconhecer.

Por isso o título **Estandarte Oco**: existe um juramento, mas a pessoa que dava sentido ao juramento foi esvaziada.

A derrota de Jinzō é o primeiro sinal de que destruir o corpo não é o mesmo que resolver a causa da reanimação.

---

# 9. COSMOLOGIA E REGRAS SOBRENATURAIS

## 9.1 Mundo humano e espiritual

**[PROPOSTA CANÔNICA]** O mundo espiritual não é uma dimensão separada que simplesmente “abre um portal”. Ele existe sobreposto ao mundo cotidiano e se manifesta com mais intensidade em lugares marcados por repetição de memória, morte, juramento ou culto.

Santuários e ritos ajudam a manter limites e dar destino a essas forças. Quando os limites são corrompidos, lembranças deixam de permanecer apenas como lembranças.

## 9.2 Como funcionam os zumbis

Os guerreiros zumbis não são infectados e não se reproduzem por mordida.

A reanimação exige três elementos:

- um corpo ou restos suficientemente preservados;
- um eco espiritual de juramento ou violência;
- uma força que imponha direção ao eco.

O cadáver recupera fragmentos de técnica, postura e reflexos que possuía em vida, mas não recupera necessariamente personalidade plena. Quanto mais forte era o juramento no momento da morte, mais perigoso o reanimado.

## 9.3 Os Três Sinos Sepulcrais

**[PROPOSTA CANÔNICA]** Os “três sinos” citados por Jinzō são artefatos criados após a Guerra dos Sete Estandartes. Eles não foram feitos originalmente para acordar mortos. Sua função era absorver e dispersar ecos espirituais de campos de batalha.

Seigan inverte o funcionamento deles. Em vez de dispersar, os sinos concentram.

Cada sino está conectado a uma grande sepultura militar e a uma região diferente. Quando todos ressoam na mesma frequência, os ecos de milhares de mortos podem ser organizados como um único exército.

## 9.4 Fragmentos do Estandarte

**[PROPOSTA CANÔNICA]** Fragmentos do Estandarte são concentrações menores da mesma força divina presente em Ren. O altar secreto da Fase 1 já pode ser reinterpretado como o primeiro fragmento opcional descoberto pelo jogador.

Em termos de gameplay, esses fragmentos permitem upgrades. Em termos de história, cada fragmento torna Ren mais capaz de enfrentar Seigan, mas também mais útil ao ritual do antagonista.

Esse conflito impede que a progressão seja apenas “ficar mais forte sem consequência”.

---

# 10. LORE COMPLETA — ESTRUTURA DO JOGO INTEIRO

## 10.1 Prólogo — A calmaria de Amahara

Ren vive com Yuna e ajuda a proteger a aldeia. Pequenos sinais estranhos aparecem: animais deixam a encosta, sinos tocam sem vento e moradores relatam armaduras encontradas fora de antigas sepulturas.

O jogador conhece Amahara ainda viva antes do primeiro ataque.

## 10.2 Capítulo 1 — Amahara e o Estandarte Oco

É a fase já implementada:

Amahara → invasão → investigação → floresta → altar oculto → santuário corrompido → General Jinzō → revelação dos três sinos.

Depois da vitória, Yuna reconhece parte do símbolo deixado pelas cinzas de Jinzō e entrega a Ren um objeto que sua mãe deixou: um fragmento de mapa com três marcas de sino e uma guarda de espada gravada com o mesmo padrão dourado da Marca do Estandarte.

Ren deixa Amahara para impedir os próximos despertares.

## 10.3 Capítulo 2 — O Sino de Ferro

**Região proposta:** Passo de Ashigane, antiga rota fortificada de montanha.

A região foi palco de um cerco prolongado. Soldados enterrados sob muralhas começam a sair do solo ainda presos a armaduras esmagadas e armas quebradas.

Novos perigos:

- arqueiros em posições elevadas;
- pesados com escudos improvisados;
- portadores de estandarte que fortalecem mortos próximos;
- corredores que atacam em grupos coordenados;
- armadilhas e desabamentos.

**Boss proposto:** **Daizen, o Portão de Ferro** — antigo defensor que morreu segurando sozinho o portão interno enquanto os civis fugiam. Em vida era conhecido por não recuar; reanimado, essa virtude vira uma compulsão monstruosa.

Ren descobre que os mortos não estão atacando aleatoriamente. Eles repetem rotas militares antigas como se uma batalha de oitenta anos atrás ainda estivesse acontecendo.

Ao destruir o Sino de Ferro, Ren recebe uma visão de Mio trabalhando ao lado de Seigan anos antes.

## 10.4 Capítulo 3 — O Sino das Marés

**Região proposta:** costa de Shiosai, vilas de pescadores, penhascos, cavernas e restos de embarcações militares.

Parte dos mortos ficou presa em uma tentativa de desembarque durante a guerra. Quando o sino é invertido, cadáveres e armaduras emergem de areia, cavernas e água rasa.

A exploração passa a usar:

- maré como alteração de caminhos;
- pontes danificadas;
- cavernas opcionais;
- áreas de neblina;
- projéteis e inimigos de controle de espaço.

**Boss proposto:** **Ayame, a Bandeira Afogada** — antiga capitã que tentou retirar seus homens de uma batalha perdida e foi executada pelos próprios superiores por desobediência. Reanimada, alterna entre disciplina militar e lampejos de memória que fazem o jogador perceber que alguns mortos ainda possuem fragmentos de consciência.

Ayame é a primeira inimiga a resistir diretamente ao comando de Seigan durante a luta. Sua derrota prova que libertar um morto pode exigir quebrar o juramento que o mantém preso, não apenas reduzir HP.

## 10.5 Capítulo 4 — O Sino de Cinzas

**Região proposta:** planície de Kareha, maior campo de batalha da Guerra dos Sete Estandartes.

É onde o mundo humano e espiritual estão mais misturados. A paisagem apresenta:

- campos queimados que nunca recuperaram completamente a vegetação;
- centenas de pequenos memoriais;
- trincheiras antigas;
- árvores marcadas por energia espiritual;
- ilusões de batalhas passadas sobrepostas ao presente.

Ren descobre a verdade sobre o Estandarte: ele não é uma divindade simplesmente benevolente. Ele cresce quando pessoas transformam violência em identidade.

**Boss proposto:** **Narihira, o Último Comando** — general que deu a ordem que sacrificou Jinzō e outros batalhões. Diferente de Jinzō, ele morreu convencido de que qualquer número de vidas era aceitável para obter vitória. Sua reanimação produz um inimigo que abraça voluntariamente a Fome do Estandarte.

Após vencê-lo, Ren descobre que Mio ainda está viva e que Seigan a mantém ligada ao último selo.

## 10.6 Capítulo 5 — O Caminho para a Capital Silenciosa

Seigan começa o Grande Silêncio. Mortos de todas as regiões passam a caminhar simultaneamente em direção à antiga capital fortificada onde o ritual original foi realizado.

Amahara e outros povoados ficam ameaçados novamente. O jogador precisa escolher caminhos de defesa e pode reencontrar NPCs salvos nos capítulos anteriores.

Yuna revela finalmente tudo que sabe sobre o nascimento de Ren e admite que escondeu a verdade por medo de transformá-lo em uma arma antes mesmo que pudesse escolher quem queria ser.

## 10.7 Capítulo 6 — A Capital Silenciosa

A última grande área mistura:

- distrito urbano abandonado;
- residências nobres;
- quartéis;
- jardins secos;
- passagens subterrâneas;
- mausoléus;
- santuário ritual central.

Os sinos tocam em sequência. Os mortos não atacam apenas Ren; começam a formar fileiras e aguardar ordens. Isso mostra que o plano de Seigan está perto de funcionar.

Ren encontra Mio viva, presa a uma estrutura ritual. Libertá-la enfraquece os selos e acelera o ritual, criando um dilema: salvá-la agora torna a batalha final mais perigosa; deixá-la presa é mais seguro, mas repete a lógica de sacrificar indivíduos “pelo bem maior”. O canon proposto é Ren libertá-la imediatamente.

## 10.8 Confronto final — Seigan Tsukishiro

### Fase 1 — O homem que quer acabar com a guerra

Seigan luta usando:

- selos;
- sinos menores;
- formações de mortos;
- barreiras;
- ataques que tentam limitar movimento em vez de causar apenas dano bruto.

Ele tenta convencer Ren de que todas as batalhas do jogo provaram sua tese: quando ameaçados, humanos escolhem violência, e Ren foi recompensado com mais poder a cada luta.

### Fase 2 — O Comando de Mil Mortos

Seigan conecta-se aos Três Sinos e passa a comandar simultaneamente ecos de vários chefes e soldados. A arena muda, incorporando ataques inspirados em inimigos enfrentados ao longo da campanha.

### Fase 3 — O Estandarte sem Portador

O ritual falha parcialmente porque Ren se recusa a assumir o comando. A energia acumulada tenta formar um avatar próprio: o **Estandarte sem Portador**, manifestação da guerra como impulso que existe mesmo quando ninguém admite desejá-la.

A luta final não é contra um “deus maligno” tradicional. É contra a possibilidade de o conflito ganhar vontade própria através da soma de todos os juramentos de guerra acumulados.

## 10.9 Final canônico

Ren percebe que não pode simplesmente destruir a parte de si ligada ao Estandarte sem libertar a energia acumulada de forma catastrófica. Em vez disso, ele redefine o juramento que dá forma à força.

Ele usa a Marca não para comandar os mortos, mas para devolver a cada eco o direito de terminar seu próprio juramento.

Os mortos finalmente deixam as armas cair. Os sinos racham. A energia divina de Ren não desaparece por completo, mas perde a capacidade de crescer apenas porque há violência ao redor.

Seigan sobrevive tempo suficiente para ver o exército que pretendia controlar escolher o descanso.

Mio é libertada. Yuna reconstrói o santuário de Amahara. Ren retorna à aldeia, mas não permanece definitivamente. O último plano mostra sua marca dourada quase apagada, reacendendo apenas quando ele decide partir para ajudar outra região ameaçada.

A interpretação final é que Ren continua sendo um semideus da guerra, porém a guerra deixa de ser sua identidade. O poder passa a responder ao **juramento de proteção**.

---

# 11. ESTRUTURA DE GAMEPLAY DO JOGO COMPLETO

## 11.1 Loop principal

1. Explorar uma região.
2. Conversar e investigar sinais da corrupção.
3. Encontrar grupos de mortos e aprender seus padrões.
4. Usar katana para gerar Energia Divina.
5. Usar magia para alcance, controle e quebra de pressão.
6. Descobrir desvios, altares e fragmentos.
7. Ativar santuários/checkpoints.
8. Chegar a uma área de maior corrupção.
9. Enfrentar um boss com regras próprias.
10. Obter informação que muda a leitura da história.
11. Retornar ao hub ou avançar para uma nova região.

## 11.2 Progressão proposta

O jogo completo não precisa virar um looter ou RPG de números excessivos. A progressão ideal mantém o foco em técnica.

### Fragmentos do Estandarte

Podem aumentar:

- Max HP;
- Max Energia Divina;
- eficiência de geração de energia;
- propriedades de Corte Celeste;
- propriedades de Selo de Ruptura;
- janelas de combo;
- opções de cancelamento;
- utilidade do dash.

### Técnicas de katana

Em vez de dezenas de armas, o jogador aprende novas técnicas que se encaixam nos dois estilos base.

Exemplos propostos:

- finalizador alternativo de combo rápido;
- launcher curto para inimigos leves;
- corte de aproximação;
- golpe carregado do combo pesado;
- cancelamento específico após acerto perfeito;
- contra-ataque contextual desbloqueado mais tarde.

### Magias

A identidade do jogo pode permanecer com **duas magias principais** durante toda a campanha, expandindo-as por modificadores em vez de trocar constantemente de habilidade.

**Corte Celeste** pode evoluir para:

- maior alcance;
- segunda onda com dano reduzido;
- perfuração limitada;
- recuperação de pequena quantidade de energia ao acertar múltiplos alvos.

**Selo de Ruptura** pode evoluir para:

- raio maior;
- stun mais eficiente em inimigos leves;
- quebra de armadura de pesados;
- barreira curta após ativação perfeita.

## 11.3 Hub de Amahara

**[PROPOSTA CANÔNICA]** Após o primeiro capítulo, Amahara passa a funcionar como hub entre grandes regiões.

Mudanças visíveis ao longo da história:

- casas reparadas;
- moradores retornando;
- memoriais para mortos;
- novos diálogos;
- ferreiro/treinador opcional;
- Yuna fornecendo contexto;
- objetos encontrados nas regiões sendo exibidos;
- consequências de side quests aparecendo fisicamente.

---

# 12. MECÂNICAS IMPLEMENTADAS — REFERÊNCIA EXATA

# 12.1 Resolução, tile e mundo

**[TÉCNICO / IMPLEMENTADO]**

- Resolução interna: **480 × 270**.
- Tile lógico: **24 px**.
- Mapa: **144 × 92 tiles**.
- Tamanho lógico total do mundo: **3456 × 2208 px**.
- `imageSmoothingEnabled = false`.
- CSS utiliza `image-rendering: pixelated`.
- Seed usada na distribuição procedural de parte dos props: **9042026**.

## 12.2 Player — valores base

| Propriedade | Valor atual |
|---|---:|
| HP máximo | 100 |
| Energia Divina máxima | 100 |
| Velocidade | 82 |
| Velocidade do dash | 270 |
| Duração do dash | 0,18 s |
| Cooldown do dash | 0,58 s |
| I-frames após hit | 0,62 s |
| Regeneração passiva de energia | 2,2/s |
| Energia recebida por hit de katana | +6 |

## 12.3 Combo rápido

### Golpe 1 — Corte Horizontal

- startup: 0,07 s
- active: 0,08 s
- recovery: 0,12 s
- dano: 11
- hitbox: 28 × 18
- reach: 20
- knockback: 42
- avanço: 2
- hitstop: 0,025 s

### Golpe 2 — Corte Reverso

- startup: 0,06 s
- active: 0,09 s
- recovery: 0,13 s
- dano: 12
- hitbox: 30 × 18
- reach: 21
- knockback: 48
- avanço: 3
- hitstop: 0,03 s

### Golpe 3 — Corte Descendente

- startup: 0,10 s
- active: 0,11 s
- recovery: 0,23 s
- dano: 19
- hitbox: 34 × 22
- reach: 23
- knockback: 95
- avanço: 1
- hitstop: 0,055 s

**Dano bruto da sequência completa:** 42.

## 12.4 Combo pesado

### Golpe 1 — Passo de Ferro

- startup: 0,12 s
- active: 0,11 s
- recovery: 0,18 s
- dano: 15
- hitbox: 31 × 20
- reach: 22
- knockback: 60
- avanço: 6
- hitstop: 0,04 s

### Golpe 2 — Ombro da Guerra

- startup: 0,14 s
- active: 0,12 s
- recovery: 0,18 s
- dano: 18
- hitbox: 34 × 22
- reach: 24
- knockback: 80
- avanço: 8
- hitstop: 0,05 s

### Golpe 3 — Lâmina do Estandarte

- startup: 0,20 s
- active: 0,14 s
- recovery: 0,34 s
- dano: 29
- hitbox: 40 × 25
- reach: 27
- knockback: 145
- avanço: 10
- hitstop: 0,075 s

**Dano bruto da sequência completa:** 62.

## 12.5 Input buffer

Durante um ataque do combo atual, pressionar novamente o mesmo tipo de ataque pode armazenar o próximo input. A janela usada no código é **0,32 s**. Pressionar o botão do outro estilo durante a sequência atual não troca automaticamente a cadeia; o buffer é cancelado.

## 12.6 Attack timing

Cada golpe usa três fases:

1. `startup`
2. `active`
3. `recovery`

A hitbox ofensiva só é aplicada durante `active`.

## 12.7 Hitbox / Hurtbox

O ataque não causa dano apenas por distância. O sistema calcula um retângulo ofensivo baseado em:

- posição do atacante;
- direção/facing;
- largura/altura do ataque;
- alcance.

Esse retângulo precisa intersectar a hurtbox do alvo.

## 12.8 Single-hit protection

Cada ataque recebe um `attackId` e mantém um conjunto de alvos já atingidos. O mesmo swing não pode aplicar dano repetidamente ao mesmo inimigo apenas porque a interseção continua ativa por vários frames.

## 12.9 Dash — Passo de Guerra

- velocidade: 270;
- duração: 0,18 s;
- cooldown: 0,58 s;
- direção: input de movimento atual;
- sem input: usa o facing atual;
- i-frames: cobrem a duração ativa do dash;
- colisão: usa o mesmo resolvedor de colisão do movimento comum.

## 12.10 Magia 1 — Corte Celeste

- custo: 25 Energia Divina;
- dano: 24;
- velocidade do projétil: 220;
- vida do projétil: 1,45 s;
- cooldown: 0,9 s;
- função: alcance e finalização fora do alcance da katana.

O projétil é destruído ao acertar um alvo ou ao atingir condições de cleanup. Água elimina o projétil comum.

## 12.11 Magia 2 — Selo de Ruptura

- custo: 35 Energia Divina;
- dano base: 18;
- raio: 52;
- stun: 0,8 s;
- cooldown: 5,0 s;
- função: controle de grupo, empurrão e espaço defensivo.

Contra o boss, o dano é reduzido para 70% do valor base.

## 12.12 Energia Divina

- máximo inicial: 100;
- regeneração passiva: 2,2 por segundo;
- +6 por hit confirmado de katana;
- segredo da fase: +25 de máximo;
- usar magia com energia insuficiente é bloqueado.

O design incentiva ciclo corpo a corpo → geração de energia → magia de suporte → retorno à katana.

## 12.13 HP e reação a dano

Ren possui:

- 100 HP;
- flash curto ao ser atingido;
- knockback;
- estado `hurt`;
- invulnerabilidade pós-hit;
- morte ao atingir 0;
- respawn no último checkpoint.

## 12.14 Hit stop e screen shake

Quando um ataque acerta:

- hit stop mínimo é aplicado;
- ataques mais fortes podem produzir hit stop maior por dados do golpe;
- screen shake aumenta conforme o dano;
- hit sparks são gerados;
- SFX de impacto é reproduzido.

---

# 13. INIMIGOS IMPLEMENTADOS

## 13.1 Espadachim Morto

| Propriedade | Valor |
|---|---:|
| HP | 38 |
| Velocidade | 34 |
| Dano | 10 |
| Alcance | 24 |
| Detection | 175 |
| Disengage | 320 |
| Windup | 0,34 s |
| Recovery | 0,55 s |

Função: inimigo básico, lento, legível e usado para apresentar o combate.

## 13.2 Corredor Morto

| Propriedade | Valor |
|---|---:|
| HP | 25 |
| Velocidade | 56 |
| Dano | 8 |
| Alcance | 21 |
| Detection | 195 |
| Disengage | 340 |
| Windup | 0,22 s |
| Recovery | 0,42 s |

Função: pressão rápida, aproximação agressiva, pouca resistência.

## 13.3 Guardião Pesado

| Propriedade | Valor |
|---|---:|
| HP | 86 |
| Velocidade | 23 |
| Dano | 19 |
| Alcance | 29 |
| Detection | 160 |
| Disengage | 300 |
| Windup | 0,62 s |
| Recovery | 0,88 s |

Possui apenas 35% do knockback normal aplicado a outros inimigos.

Função: pressão lenta, golpe forte, telegraph maior, quebra do ritmo de spam.

## 13.4 Arqueiro Morto

| Propriedade | Valor |
|---|---:|
| HP | 31 |
| Velocidade | 29 |
| Dano | 9 |
| Alcance | 150 |
| Detection | 220 |
| Disengage | 360 |
| Windup | 0,48 s |
| Recovery | 1,05 s |

Comportamento:

- recua se jogador chega a menos de 82;
- aproxima-se se está além de 135;
- tenta atacar dentro do alcance configurado;
- projétil de flecha usa velocidade 120 e vida 2,4 s.

---

# 14. IA E COMBATE EM GRUPO

## 14.1 Estados do inimigo

A implementação usa estados equivalentes a:

- `idle`
- `chase`
- `telegraph`
- `attack`
- `recover`
- `hurt`
- `dead`

O arqueiro adiciona comportamento de manutenção de distância dentro do estado de perseguição.

## 14.2 Aggro

Cada arquétipo tem:

- detection range;
- attack range;
- disengage range.

O inimigo deixa de perseguir quando o jogador ultrapassa seu limite de disengage.

## 14.3 Coordenação de ataques

Para evitar que todos ataquem simultaneamente:

- no máximo **2 inimigos** podem estar em `telegraph` ou `attack` ao mesmo tempo;
- existe cooldown global de solicitação de ataque de **0,22 s**.

Isso cria uma forma simples de attack token sem necessidade de um sistema de formação complexo.

---

# 15. BOSS — GENERAL JINZŌ

## 15.1 Valores base

| Propriedade | Valor |
|---|---:|
| HP | 480 |
| Velocidade | 30 |
| Dano base | 18 |
| Gatilho da Fase 2 | 50% HP |

## 15.2 Estados

- intro
- transition
- recover
- chase
- telegraph
- attack
- dead

## 15.3 Phase 1

Padrões disponíveis:

### Combo melee

Três janelas internas de hit dentro de uma sequência aproximada de 0,52 s. O terceiro hit causa dano e knockback maiores.

### Charge

- telegraph: 0,55 s;
- movimento de carga: 210 de velocidade;
- duração ativa aproximada: 0,38 s;
- dano ao colidir: 22;
- knockback: 150.

### AOE

- telegraph: 0,75 s;
- raio: 78;
- dano na Fase 1: 19;
- knockback: 125.

## 15.4 Transição para Phase 2

Ao atingir 50% de HP:

- boss entra em `transition`;
- ganha invulnerabilidade temporária;
- muda visualmente;
- produz burst e screen shake;
- mostra “FASE 2 — O ESTANDARTE DESPERTOU”;
- invoca uma vez um Corredor Morto e um Espadachim Morto.

## 15.5 Phase 2

Além de maior frequência de ataques, Jinzō desbloqueia `grave`:

- telegraph: 0,8 s;
- dispara 8 projéteis em radial;
- velocidade: 105;
- vida: 2,7 s;
- dano: 12;
- knockback ao jogador: 80.

O AOE passa a causar 23 de dano.

## 15.6 Janelas de punição

Depois dos ataques, Jinzō entra em recovery. O recovery é menor na Fase 2, mas não desaparece. O boss não foi desenhado para atacar continuamente sem espaço de resposta.

---

# 16. MAPA E LEVEL DESIGN IMPLEMENTADOS

## 16.1 Macrofluxo

Casa/centro da aldeia → ataque inicial → ruas de Amahara → saída da aldeia → floresta → ponte/córrego → desvio secreto → santuário → checkpoint → último torii → arena do boss.

## 16.2 Aldeia

Elementos implementados incluem:

- 6 casas principais;
- árvores ao norte e ao sul;
- cercas;
- lanternas;
- plantações;
- poço;
- estradas;
- NPC Yuna;
- primeira wave posicionada dentro da área visível/jogável.

A composição foi ajustada durante testes porque a primeira versão da câmera inicial parecia vazia.

## 16.3 Floresta

Inclui:

- trilha principal;
- árvores;
- bambu;
- pedras;
- rio;
- ponte;
- densidade procedural com corredores preservados;
- wave própria de inimigos;
- caminho opcional para altar secreto.

## 16.4 Segredo

O altar oculto fica ao sul da rota principal, em um corredor de bambu.

Primeira ativação:

- marca o segredo como coletado;
- aumenta Max Energia Divina em +25;
- restaura a energia até o novo máximo;
- reproduz efeito de shrine;
- exibe diálogo de Ren sugerindo que o altar não pertence ao santuário oficial.

Ativações posteriores apenas informam que o altar está silencioso.

## 16.5 Santuário e checkpoint

Ativar o checkpoint:

- define novo respawn em aproximadamente `(2575, 820)`;
- restaura HP;
- restaura energia;
- atualiza a progressão da história;
- libera objetivo de atravessar o último torii.

## 16.6 Arena do boss

A arena utiliza:

- torii;
- lanternas;
- banners;
- árvores antigas;
- shrine de fundo;
- chão corrompido;
- barreira dinâmica no acesso durante a luta.

A posição do boss foi ajustada depois de teste visual para evitar enquadramento ruim perto da borda.

---

# 17. SPAWNS IMPLEMENTADOS

## 17.1 Invasão da aldeia

1. Espadachim — `(645, 1635)`
2. Corredor — `(735, 1700)`
3. Espadachim — `(665, 1540)`
4. Pesado — `(820, 1760)`
5. Arqueiro — `(900, 1600)`

## 17.2 Floresta

1. Corredor — `(1260, 1370)`
2. Espadachim — `(1320, 1450)`
3. Arqueiro — `(1680, 1300)`
4. Espadachim — `(1780, 1450)`
5. Pesado — `(1980, 1280)`
6. Corredor — `(2180, 1390)`

## 17.3 Santuário

1. Espadachim — `(2380, 900)`
2. Pesado — `(2470, 980)`
3. Arqueiro — `(2700, 900)`
4. Corredor — `(2820, 830)`

## 17.4 Boss

Ren é reposicionado para aproximadamente `(3060, 670)` na intro.  
Jinzō nasce em aproximadamente `(3235, 610)`.

---

# 18. HISTÓRIA E DIÁLOGOS IMPLEMENTADOS NA FASE 1

## 18.1 Introdução

**Yuna:** “Ren, o arroz ainda está no fogo. Pela primeira vez em semanas, a aldeia parece em paz.”  
**Ren:** “Paz demais. Os corvos sumiram da encosta.”  
**Yuna:** “Então ouviu também... o sino do santuário tocou sozinho.”  
**Narração:** “Um grito corta a rua. Metal arrasta na terra. Um guerreiro morto atravessa o portão.”

Objetivo seguinte: **Defenda Amahara — derrote os invasores (0/5)**.

## 18.2 Depois da invasão

Quando a primeira wave é derrotada, o objetivo muda para **Fale com Yuna**.

**Yuna:** “As armaduras trazem o selo do general Jinzō. Ele morreu há oitenta anos, no vale acima do santuário.”  
**Ren:** “Então alguém abriu uma sepultura de guerra.”  
**Yuna:** “Siga o rastro. E Ren... sua marca está brilhando como na noite em que sua mãe o trouxe até mim.”

Objetivo: **Siga o rastro pela floresta até o santuário**.

## 18.3 Diálogo opcional com Yuna

“Não deixe a raiva escolher o ritmo da sua espada.”

Essa linha se tornou especialmente importante para a proposta de arco completo de Ren.

## 18.4 Inscrição

“Quando o estandarte sem senhor se erguer, os que morreram pela guerra esquecerão que morreram.”

## 18.5 Checkpoint

**Ren:** “A água de purificação está negra... mas a chama ainda responde.”  
**Narração:** “A marca dourada no braço de Ren reage a algo atrás do último torii.”

## 18.6 Altar secreto

**Ren:** “Este altar não pertence ao santuário. Alguém o escondeu depois da guerra.”

## 18.7 Introdução do boss

**Narração:** “O torii atrás de Ren se fecha em chamas negras.”  
**General Jinzō:** “Sangue do campo de batalha... finalmente veio até mim.”  
**Ren:** “Você trouxe os mortos para Amahara.”  
**General Jinzō:** “Não. Eu fui o primeiro deles.”

## 18.8 Morte do boss e gancho

**General Jinzō:** “Eu não os despertei... eu apenas ouvi o chamado sob a montanha.”  
**Ren:** “Quem chamou os mortos?”  
**General Jinzō:** “Três sinos. Três sepulturas. E alguém que conhece o sangue em suas veias...”  
**Narração:** “O estandarte se desfaz em cinza violeta. Ao longe, três sinos respondem.”

---

# 19. CONTROLES

## 19.1 Teclado

| Ação | Controle |
|---|---|
| Movimento | WASD / Setas |
| Combo rápido | J |
| Combo pesado | K |
| Dash | Espaço |
| Corte Celeste | Q |
| Selo de Ruptura | E |
| Interagir / avançar diálogo | F |
| Pausa | Esc |
| Debug | F3 |

Durante diálogo, o ataque leve também pode avançar a fala.

## 19.2 DualSense / Gamepad API

Mapeamento lógico implementado com layout padrão de Gamepad API:

| Ação | Botão lógico |
|---|---|
| Movimento | Analógico esquerdo |
| Movimento alternativo | D-Pad |
| Ataque principal | Quadrado / button 2 |
| Ataque secundário | Triângulo / button 3 |
| Dash | Círculo / button 1 |
| Magia 1 | L1 / button 4 |
| Magia 2 | R1 / button 5 |
| Interagir | X / button 0 |
| Pause | Options / button 9 |

Deadzone de eixo utilizada: aproximadamente **0,18**.

**[PENDENTE]** O mapeamento lógico passou por validação de código, mas o teste físico com DualSense permaneceu bloqueado no ambiente de entrega.

---

# 20. UI E FLUXO DE TELAS

## 20.1 Menu inicial

- Jogar
- Controles

## 20.2 Pause

- Continuar
- Controles
- Reiniciar fase
- Menu

## 20.3 HUD

Mostra:

- nome REN KUROGANE;
- HP atual e máximo;
- Energia Divina atual e máxima;
- objetivo atual;
- estado/cooldown das duas magias;
- prompt contextual de interação;
- boss name, fase e HP quando boss está ativo.

## 20.4 Vitória

A tela de vitória aparece após a morte de Jinzō e o diálogo final.

---

# 21. MORTE, RESPAWN E CHECKPOINTS

Ao morrer:

1. HP chega a 0;
2. estado vira `dead`;
3. abre diálogo: “A marca divina apaga por um instante...”;
4. após pequena espera, o jogador reaparece no último checkpoint;
5. HP e energia são restaurados;
6. projéteis existentes são limpos;
7. a página não é recarregada.

O respawn não respawna automaticamente todas as waves já derrotadas.

---

# 22. PIXEL ART E DIREÇÃO VISUAL

## 22.1 Abordagem atual

**[IMPLEMENTADO]** Não há pacote de assets de terceiros. Personagens, objetos, cenário e VFX são desenhados proceduralmente no Canvas.

Isso inclui:

- Ren;
- Yuna;
- quatro tipos de inimigos;
- Jinzō;
- casas;
- árvores;
- bambu;
- torii;
- cercas;
- lanternas;
- rochas;
- plantações;
- poço;
- ponte;
- altares;
- banners;
- armaduras abandonadas;
- shrine;
- água animada;
- projéteis;
- rings;
- partículas.

A arte atual é suficiente para leitura e identidade do vertical slice, porém uma produção completa provavelmente substituiria ou refinaria parte dela com spritesheets desenhados à mão mantendo as mesmas proporções e regras.

## 22.2 Paleta e progressão atmosférica

- Aldeia: verdes, marrons, tons quentes de lanternas.
- Floresta: maior densidade de vegetação e corredores.
- Santuário: mais cinza, roxo e sinais de corrupção.
- Boss arena: chão púrpura/escuro, banners e iluminação pontual.

## 22.3 Y-sort

Props, NPC, inimigos, boss e player são reunidos em uma lista e desenhados ordenados pela coordenada Y. Isso permite que personagens passem visualmente à frente ou atrás de objetos conforme a posição.

---

# 23. ÁUDIO

## 23.1 Estado atual

**[IMPLEMENTADO]** O jogo usa Web Audio API e gera áudio proceduralmente, sem arquivos de áudio externos.

SFX existentes:

- slash;
- heavy;
- hit;
- dash;
- magia 1;
- magia 2;
- zombie;
- boss;
- UI;
- shrine.

A ambientação musical usa tons simples com conjuntos diferentes para:

- `calm`;
- `corrupt`;
- `boss`.

## 23.2 Direção para produção completa

**[PROPOSTA]** Uma versão final poderia substituir essa camada por música e SFX produzidos especificamente para o jogo, mantendo a lógica dinâmica de estados. Instrumentação e linguagem sonora devem ser pesquisadas com cuidado para não reduzir “Japão antigo” a clichês musicais genéricos.

---

# 24. CÂMERA

- câmera top-down seguindo o jogador;
- alvo aproximado: jogador centralizado em 480 × 270;
- interpolação suave;
- clamp nos limites do mapa;
- screen shake temporário em hits fortes, magia e eventos do boss;
- câmera é arredondada para pixel para reduzir blur visual.

---

# 25. ARQUITETURA DO PROJETO

Estrutura atual:

```text
index.html
style.css
run.bat

src/
  main.js
  game.js
  input.js
  audio.js
  combat.js
  utils.js

  data/
    balance.js

  entities/
    player.js
    enemies.js
    boss.js

  world.js

docs/
  RESEARCH.md
  FINAL_REPORT.md
  TEST_REPORT.md

tests/
  cdp_smoke.js
  logic_suite.js

screenshots/
  village.png
  boss.png
```

## 25.1 Responsabilidades

- `index.html`: canvas, menus, HUD/painéis e carregamento dos scripts.
- `style.css`: apresentação da página, escala pixelada e UI externa ao Canvas.
- `src/main.js`: inicialização.
- `src/game.js`: loop principal, story state, waves, diálogos, câmera, projectiles, VFX, UI em Canvas e integração dos sistemas.
- `src/input.js`: teclado e Gamepad API.
- `src/audio.js`: síntese procedural de SFX e ambientação.
- `src/combat.js`: cálculo de attack rect, dano, hit stop, shake e hit feedback.
- `src/utils.js`: matemática, clamp, lerp, normalização, colisões e RNG seedado.
- `src/world.js`: tilemap lógico, props, colliders, interações e desenho do cenário.
- `src/entities/player.js`: estados, movimento, combos, dash, magias e dano de Ren.
- `src/entities/enemies.js`: IA e desenho dos quatro arquétipos.
- `src/entities/boss.js`: Jinzō e suas duas fases.
- `src/data/balance.js`: números centralizados de player, ataques, magias, inimigos e boss.
- `tests/cdp_smoke.js`: smoke/end-to-end por Chromium DevTools Protocol.
- `tests/logic_suite.js`: validação de regras lógicas e runtime.

---

# 26. ESTADOS E FLUXOS INTERNOS

## 26.1 Player

Estados principais:

- idle
- move
- attack
- dash
- hurt
- dead

Variáveis auxiliares importantes:

- invuln
- dashTimer
- dashCooldown
- attackPhase
- currentAttack
- comboType
- comboIndex
- bufferedAttack
- bufferTimer
- magic1Cooldown
- magic2Cooldown
- hitTargets
- hasSecret

## 26.2 Progressão da história

O vertical slice usa `story` numérico.

- `0`: intro/antes da invasão.
- `1`: defender Amahara.
- `2`: invasão concluída; falar com Yuna.
- `3`: seguir floresta/santuário.
- `4`: checkpoint purificado; avançar ao boss.

Flags adicionais:

- `spawnedForest`
- `spawnedShrine`
- `bossTriggered`
- `bossDefeated`

---

# 27. DETALHES INTERNOS QUE NORMALMENTE NÃO ENTRARIAM NUM GDD

Esta seção existe porque o pedido deste documento é preservar até detalhes que normalmente seriam descartados.

## 27.1 Seed procedural

`9042026`.

É utilizada pelo RNG seedado do mundo para distribuir árvores, bambus, rochas e alguns objetos de forma reproduzível.

## 27.2 Posição inicial de Ren

Aproximadamente `(500, 1640)`.

## 27.3 Posição de Yuna

Aproximadamente `(700, 1660)`.

## 27.4 Câmera inicial

Aproximadamente `(260, 1505)`.

## 27.5 Checkpoint inicial

Igual à posição inicial de Ren: `(500, 1640)`.

## 27.6 Checkpoint do santuário

Respawn configurado para aproximadamente `(2575, 820)`.

## 27.7 Hitbox corporal do player

Dimensão lógica aproximada: `13 × 18`.

## 27.8 Hitbox corporal dos inimigos comuns

Dimensão lógica aproximada: `14 × 18`.

## 27.9 Hitbox corporal do boss

Dimensão lógica aproximada: `26 × 34`.

## 27.10 Frame delta

O loop limita `dt` a aproximadamente **0,033 s**, reduzindo saltos extremos em atualizações quando a aba ou runtime sofre atraso.

## 27.11 Debug

`F3` alterna debug. O HUD de debug pode mostrar:

- posição do player;
- estado do player;
- quantidade de inimigos vivos;
- story state;
- presença de gamepad.

## 27.12 API de testes interna

`window.__GAME_TEST__` expõe funções de automação, incluindo:

- consultar estado;
- simular tecla;
- teleportar player;
- causar dano ao boss;
- matar inimigos;
- ativar debug;
- interagir;
- iniciar jogo.

Essa API existe para os testes e não faz parte da interface destinada ao jogador.

---

# 28. TESTES E VALIDAÇÃO

## 28.1 Ambiente

A validação registrada foi realizada em **04/10/2026** usando Chromium headless e testes de runtime JavaScript.

O ambiente utilizado durante a entrega bloqueava navegação direta para `localhost` e `file://`, então os scripts do jogo foram injetados em uma página vazia de Chromium para validar o runtime real de Canvas/JavaScript.

## 28.2 Resultado geral

- T01–T19: PASS.
- T20–T28: BLOCKED por ausência de controle físico.
- T29–T70: PASS.
- Smoke end-to-end: **12/12 PASS**.
- Logic suite: checks executados em PASS.
- `PAGE_ERRORS`: PASS após correções.

## 28.3 Fluxo validado

Menu → intro → aldeia → invasão → combate → floresta → segredo → shrine → santuário → boss → Phase 2 → vitória.

A automação usou helpers para acelerar combate e progressão, portanto não substitui playtest humano de feeling e balanceamento.

---

# 29. BUGS ENCONTRADOS E CORRIGIDOS

1. **Ring VFX com raio negativo.** Após a morte do boss, um ring podia chegar a raio negativo no Canvas e causar `IndexSizeError`, interrompendo o game loop. Foi corrigido armazenando `startLife` e limitando o raio mínimo.
2. **Composição inicial vazia.** A aldeia possuía leitura visual fraca na câmera inicial. Casas, árvores, cercas e lanternas foram redistribuídas e a wave foi aproximada.
3. **Boss mal enquadrado.** A posição inicial de Jinzō e elementos da arena foram ajustados para melhor leitura visual.
4. **Recuo pela entrada da arena.** Foi adicionada barreira dinâmica para impedir que o jogador saísse pelo torii durante a boss fight.

---

# 30. EDGE CASES REVISADOS

- atacar durante morte;
- lançar magia sem energia;
- dash para dentro de parede/água;
- inimigo morto continuar atacando;
- projétil existir para sempre;
- Phase 2 do boss disparar duas vezes;
- morte durante boss;
- pausa durante diálogo;
- respawn duplicar waves;
- inimigo ficar processando após morte;
- jogador sair do mapa;
- diálogo deixar movimento ativo;
- gamepad desconectar;
- vários inimigos atacarem simultaneamente;
- mesma hitbox causar múltiplos hits em um swing.

---

# 31. LIMITAÇÕES REAIS DA VERSÃO ATUAL

1. O DualSense não foi validado fisicamente durante a entrega; apenas a integração lógica via Gamepad API.
2. O playthrough automatizado não substitui teste humano de dificuldade, ritmo e sensação de controle.
3. Áudio é procedural e não representa uma trilha final produzida.
4. Pixel Art é desenhada por código; não utiliza spritesheets finais produzidos por artista.
5. Não existe save persistente de campanha porque o vertical slice funciona como uma fase fechada.
6. Não existe sistema de opções avançadas, remapeamento, volume independente ou acessibilidade completa.
7. O vertical slice não representa ainda a escala de conteúdo de um jogo comercial completo.

---

# 32. EVOLUÇÃO RECOMENDADA PARA PRODUÇÃO COMPLETA

## 32.1 Prioridade técnica

1. Migrar arte procedural crítica para pipeline de spritesheets sem quebrar os dados de combate.
2. Manter `balance.js` data-driven ou migrar para JSON/configuração equivalente.
3. Criar sistema de save.
4. Criar remapeamento de inputs.
5. Testar DualSense fisicamente.
6. Adicionar opções de áudio.
7. Criar sistema de capítulos/regiões.
8. Separar `game.js` em controladores menores conforme o projeto crescer.
9. Criar ferramentas de visualização de hitbox e spawn para produção de conteúdo.
10. Expandir suíte de testes para progressão persistente.

## 32.2 Prioridade de game design

1. Playtest humano de 10–15 min da Fase 1.
2. Ajustar velocidade, hitstop e recovery conforme sensação real.
3. Definir número final de upgrades.
4. Testar se duas magias permanecem interessantes ao longo da campanha.
5. Prototipar primeiro boss pós-Jinzō antes de produzir múltiplas regiões.
6. Validar ritmo entre combate, exploração e narrativa.

## 32.3 Prioridade artística

1. Model sheet definitivo de Ren.
2. Model sheet de Yuna.
3. Quatro inimigos básicos com spritesheets completos.
4. Jinzō com spritesheet e transição visual de Phase 2.
5. Tileset modular de Amahara.
6. Tileset de floresta e santuário.
7. VFX frame a frame para katana e magias.
8. UI final mantendo legibilidade em 480 × 270.

---

# 33. CONTEÚDO FUTURO QUE COMBINA COM A IDENTIDADE

Possibilidades coerentes, ainda não implementadas:

- reconstrução visual de Amahara ao longo da campanha;
- side quests curtas ligadas a memórias de mortos;
- bosses cujo juramento em vida define a mecânica da luta;
- fragmentos opcionais que tornam Ren mais forte, mas alteram diálogos sobre a influência do Estandarte;
- finais alternativos baseados em quanto poder divino foi acumulado, desde que exista um final canônico claro;
- arena de desafio pós-jogo;
- New Game+ com padrões de boss expandidos;
- bestiário/arquivo de guerra com contexto de cada arquétipo;
- galeria de inscrições e memórias;
- modo de treino para praticar combos e timings.

---

# 34. COISAS QUE NÃO DEVEM ACONTECER COM O PROJETO

- transformar a experiência em RPG por turno;
- fazer a magia substituir a katana;
- adicionar loot em excesso apenas para inflar progressão;
- transformar os guerreiros zumbis em esqueletos/fantasmas genéricos sem motivo;
- usar símbolos japoneses sem função ou pesquisa;
- copiar mapa/UI/sprites de Pokémon;
- transformar Jinzō em apenas um inimigo comum ampliado;
- remover telegraphs em nome de dificuldade;
- permitir spam infinito de dash ou magia;
- quebrar pixel-perfect com filtros de suavização;
- esconder decisões de balanceamento espalhando números pelo código;
- marcar teste como PASS quando o ambiente não permitiu executá-lo.

---

# 35. CRITÉRIOS DE QUALIDADE PARA UMA VERSÃO FINAL

A versão comercial ideal só deve ser considerada madura quando:

- controle responde imediatamente;
- katana possui peso e feedback distintos entre golpes;
- dash não substitui leitura de ataque;
- magias são úteis sem dominar todo o combate;
- grupos de inimigos criam pressão sem caos injusto;
- cada boss possui linguagem própria;
- exploração recompensa atenção;
- o jogador entende visualmente o caminho principal, mas percebe desvios;
- história pode ser acompanhada sem depender de texto excessivo;
- o Japão fantástico parece um mundo coerente, não um conjunto de adereços;
- a lore dos mortos está conectada às mecânicas;
- upgrades reforçam a fantasia de guerreiro semideus;
- efeitos não escondem hitboxes ou telegraphs;
- performance é estável;
- teclado e controle são igualmente utilizáveis;
- saves não corrompem progressão;
- o jogo inteiro pode ser terminado do início ao fim sem erros críticos.

---

# 36. SNAPSHOT DE PRODUÇÃO

## 36.1 Como executar a build atual

No Windows:

```bat
run.bat
```

Ou manualmente dentro da pasta:

```bash
python -m http.server 8000
```

Depois abrir:

```text
http://localhost:8000
```

## 36.2 Testes disponíveis

```bash
node tests/cdp_smoke.js
node tests/logic_suite.js
```

## 36.3 Capturas existentes no projeto

- `screenshots/village.png` — captura da aldeia durante a primeira defesa, com HUD e inimigos.
- `screenshots/boss.png` — captura da arena de Jinzō, com barra de boss e atmosfera corrompida.

As imagens não são incorporadas em base64 neste arquivo para manter o Markdown legível e versionável. Os arquivos originais permanecem no projeto.

---

# 37. STATUS CANÔNICO — O QUE É OFICIAL AGORA

Para evitar confusão futura:

## Canon já existente no jogo

- Amahara é a aldeia inicial.
- Ren Kurogane é o protagonista.
- Yuna é Guardiã do Santuário e criou Ren.
- Ren possui a Marca do Estandarte e sangue divino.
- guerreiros mortos são reanimados;
- General Jinzō morreu há oitenta anos;
- Jinzō foi reanimado antes dos outros e funciona como foco de comando;
- existem três sinos/três sepulturas ligados ao mistério;
- alguém conhece o sangue de Ren;
- a mãe de Ren entregou-o a Yuna no passado;
- o altar secreto está ligado a algo anterior à configuração atual do santuário;
- o protagonista luta com katana, dois combos, dash e duas magias;
- energia divina é reforçada por combate de katana.

## Proposta canônica criada neste documento

- Mio Kurogane como nome e papel completo da mãe;
- O Estandarte como força divina de duas tendências, Voto e Fome;
- Guerra dos Sete Estandartes;
- Seigan Tsukishiro;
- Grande Silêncio;
- três grandes regiões/sinos posteriores;
- Daizen, Ayame e Narihira;
- Mio ainda viva;
- Estandarte sem Portador como manifestação final;
- final em que Ren redefine o juramento do poder.

Esses elementos podem ser adotados integralmente, alterados ou descartados antes de produção futura. Eles foram criados para fechar a história de maneira coerente com tudo que o vertical slice já estabeleceu.

---

# 38. APÊNDICES

Os apêndices abaixo preservam as fontes originais e o snapshot textual do projeto. A intenção é que este único arquivo continue útil mesmo que uma conversa antiga, prompt ou documento separado deixe de estar disponível.


---

# APÊNDICE A — PROMPT ORIGINAL INTEGRAL

`````text
# JOGO 2D PIXEL ART — JAPÃO ANTIGO
## HTML / JavaScript — Action Adventure top-down com katana, magia, zumbis e boss

Crie do zero um **jogo 2D completo e jogável para navegador**, com estética **Pixel Art inspirada na era 32-bit**, ambientado em um Japão antigo mitológico.

Não quero apenas uma tech demo, mapa vazio, quadrados coloridos ou personagem andando.

Quero uma **primeira fase completa, bonita, funcional e polida**, com exploração, combate, inimigos, história, magia, boss e conclusão.

O resultado deve funcionar como um **vertical slice real do jogo** e servir de base para futuras fases.

---

# 1. TECNOLOGIA

Utilize:

- HTML;
- CSS;
- JavaScript;
- Canvas/WebGL.

Preferencialmente use uma engine/framework apropriado para jogos 2D no navegador, como **Phaser**, se isso melhorar:

- tilemaps;
- animações;
- física;
- colisões;
- input;
- partículas;
- câmera;
- áudio;
- gerenciamento de cenas.

Escolha a arquitetura tecnicamente mais adequada.

Não coloque todo o jogo dentro de um único `index.html` gigantesco.

Organize o projeto profissionalmente.

---

# 2. PESQUISA ANTES DA IMPLEMENTAÇÃO

Antes de desenvolver, faça uma pesquisa curta e objetiva em duas áreas.

## A — REFERÊNCIAS DE GAME DESIGN

Estude jogos 2D top-down/action-adventure e RPGs visuais da era 16/32-bit para entender:

- construção de mapas;
- proporção personagem/cenário;
- exploração;
- tilemaps;
- combate top-down;
- Pixel Art;
- leitura visual;
- animações;
- progressão;
- boss design;
- game feel.

Pokémon antigo pode ser utilizado como referência apenas para:

- linguagem visual;
- escala dos sprites;
- construção por tiles;
- perspectiva top-down;
- densidade dos cenários.

Também pode estudar outros jogos semelhantes que tenham soluções úteis para:

- exploração;
- action combat;
- magia;
- ambientes japoneses.

NÃO copiar personagens, mapas, sprites, UI, músicas ou assets.

## B — JAPÃO ANTIGO E MITOLOGIA

Pesquise referências confiáveis sobre:

- Japão antigo;
- aldeias;
- guerreiros;
- samurais;
- santuários;
- torii;
- arquitetura;
- armas;
- espiritualidade;
- crenças;
- kami;
- yōkai;
- oni;
- morte;
- guerra;
- corrupção espiritual;
- folclore japonês.

Use a pesquisa para construir um mundo coerente.

Não apenas espalhe símbolos japoneses aleatoriamente.

---

# 3. DOCUMENTAR A PESQUISA

Criar:

`docs/RESEARCH.md`

Registrar resumidamente:

- referências estudadas;
- decisões visuais;
- decisões de level design;
- referências históricas/mitológicas utilizadas;
- como essas referências foram adaptadas para um universo fantástico original.

Não gastar tempo excessivo documentando.

A pesquisa serve para melhorar o jogo.

---

# 4. IDENTIDADE ORIGINAL

O jogo deve possuir identidade própria.

NÃO copiar de Pokémon:

- gameplay;
- personagens;
- criaturas;
- mapas;
- tiles;
- interface;
- sons;
- música;
- nomes;
- sistemas.

Também não copiar diretamente personagens ou histórias de outros jogos.

A referência Pokémon é principalmente:

**Pixel Art top-down da era portátil/32-bit.**

O gameplay será diferente.

---

# 5. GÊNERO

O jogo deve ser um:

# ACTION ADVENTURE / ACTION RPG TOP-DOWN

Combate em tempo real diretamente no mapa.

Não implementar batalhas por turno.

---

# 6. CONCEITO

O jogo se passa em um **Japão antigo fantástico**, onde o mundo dos humanos e o mundo espiritual começaram a se misturar.

O protagonista vive em uma pequena aldeia.

Ele é um:

# SEMIDEUS DA GUERRA

Não é um deus completo.

Possui origem divina, mas ainda pode:

- se ferir;
- morrer;
- falhar;
- evoluir.

Sua principal arma é:

# KATANA

Além da espada, possui poderes sobrenaturais relacionados à sua natureza divina.

---

# 7. LORE PRINCIPAL DA FASE 1

A aldeia onde o protagonista vive é atacada inesperadamente por:

# GUERREIROS ZUMBIS

IMPORTANTE:

eles são **zumbis/guerreiros mortos reanimados**.

Não transformar todos automaticamente em:

- fantasmas;
- esqueletos;
- múmias.

Eles eram guerreiros humanos mortos e foram reanimados por uma força sobrenatural.

Durante o ataque, o protagonista percebe que aquilo não é uma invasão comum.

Alguma entidade ou poder está:

- reanimando guerreiros mortos;
- corrompendo a região;
- atraindo energia espiritual;
- atacando especificamente aquela aldeia por algum motivo.

Crie uma história que explique gradualmente:

- quem é o protagonista;
- sua relação com a aldeia;
- por que ele possui sangue divino;
- de onde vêm os guerreiros mortos;
- quem os controla;
- por que o boss está envolvido;
- qual mistério maior pode continuar nas próximas fases.

---

# 8. NÃO EXPLICAR TUDO NA PRIMEIRA FASE

A Fase 1 deve revelar apenas parte do mistério.

Ao final:

o jogador derrota o boss, salva temporariamente a aldeia e descobre que o ataque fazia parte de algo muito maior.

Deixe um gancho para continuação.

---

# 9. PROTAGONISTA

Crie:

- nome original;
- aparência;
- pequena história;
- personalidade;
- motivo para proteger a aldeia;
- origem divina.

Visualmente ele deve parecer:

- jovem/adulto guerreiro;
- habilidoso;
- sobrenatural;
- japonês;
- apropriado ao período fantástico;
- reconhecível em Pixel Art.

Não criar uma cópia de samurai famoso ou personagem existente.

---

# 10. DESIGN DO PROTAGONISTA

Sua identidade visual deve combinar:

- guerreiro japonês;
- katana;
- elementos associados à guerra;
- algum detalhe visual que indique origem divina.

Exemplos conceituais:

- marcas;
- energia;
- acessório;
- olhos;
- ornamentos;
- aura durante magia.

Escolha algo coerente e não exagerado.

---

# 11. PIXEL ART

O jogo deve usar:

# PIXEL ART 2D COM ESTÉTICA 32-BIT

Por “32-bit” quero dizer a linguagem visual da era de jogos 2D mais detalhados, não simplesmente profundidade de cor.

Características:

- sprites detalhados;
- pixels nítidos;
- boa silhueta;
- cores bem escolhidas;
- cenário rico;
- animações claras;
- tiles consistentes;
- efeitos em Pixel Art.

---

# 12. PIXEL PERFECT

Configurar corretamente:

- nearest-neighbor;
- image smoothing desativado;
- `image-rendering: pixelated`;
- escala coerente;
- câmera sem blur;
- sprites alinhados ao pixel quando apropriado.

Não entregar Pixel Art borrada.

---

# 13. RESOLUÇÃO INTERNA

Escolha uma resolução interna apropriada para Pixel Art.

Exemplos:

```text
320x180
480x270
640x360
```

Escolha conforme sprites/mapa.

Escalar mantendo proporção.

Priorizar integer scaling quando possível.

---

# 14. TILEMAP

Construa o mapa utilizando tiles.

Camadas recomendadas:

```text
Ground
Terrain
Details
Collision
Objects Back
Characters
Objects Front
Effects
```

Use depth/Y sorting apropriado.

Personagem deve conseguir:

- passar atrás da copa de árvores;
- aparecer na frente de objetos quando estiver abaixo deles.

---

# 15. MAPA DA FASE 1

A fase deve parecer uma pequena jornada.

Não crie uma única arena.

Estrutura sugerida:

```text
CASA / CENTRO DA ALDEIA
↓
ATAQUE INICIAL
↓
RUAS DA ALDEIA
↓
ARREDORES
↓
CAMINHO NA FLORESTA
↓
SANTUÁRIO CORROMPIDO
↓
BOSS
```

Você pode evoluir esse layout após a pesquisa.

---

# 16. ÁREA — ALDEIA

A aldeia deve conter:

- casas;
- árvores;
- cercas;
- estradas;
- pequenas hortas;
- lanternas;
- detalhes;
- habitantes;
- objetos;
- sinais de vida.

Antes ou durante o ataque, mostrar brevemente que aquele lugar era habitado.

Isso aumenta o impacto da invasão.

---

# 17. ATAQUE À ALDEIA

O começo da fase deve possuir um evento claro.

Exemplo:

```text
rotina normal / pequena introdução
→ sinal de perigo
→ primeiro zumbi
→ invasão
→ jogador aprende combate
```

Não precisa ser uma cutscene longa.

Pode acontecer diretamente pelo gameplay.

---

# 18. FLORESTA / CAMINHO

Depois da defesa inicial da aldeia:

o protagonista segue rastros dos invasores.

Criar área com:

- árvores;
- bambu;
- pedras;
- rio/córrego;
- pequenas pontes;
- vegetação;
- caminhos secundários;
- inimigos;
- segredo.

---

# 19. SANTUÁRIO

Área final antes do boss.

Visual mais espiritual e ameaçador.

Adicionar:

- torii;
- lanternas;
- estátuas;
- inscrições;
- árvores antigas;
- corrupção sobrenatural;
- energia estranha;
- corpos/armaduras de guerreiros;
- sinais do boss.

---

# 20. EXPLORAÇÃO

Não transformar fase em corredor.

Adicionar:

- caminho principal;
- pelo menos 2 pequenos desvios;
- 1 segredo importante;
- 1 recompensa opcional;
- objetos interativos;
- pequenos elementos narrativos.

---

# 21. INTERAÇÃO

Criar botão:

`INTERACT`

Pode ser usado para:

- falar;
- abrir;
- investigar;
- ativar santuário;
- ler inscrição.

Mostrar indicação contextual quando próximo.

---

# 22. NPCs

Adicionar alguns moradores.

Pelo menos um NPC deve possuir papel narrativo real.

Exemplos:

- ancião;
- ferreiro;
- sobrevivente;
- familiar/amigo do protagonista.

Não criar dezenas de NPCs vazios.

---

# 23. DIÁLOGO

Sistema simples.

Caixa de texto original.

Diálogos curtos.

Não copiar interface de Pokémon.

---

# 24. MOVIMENTAÇÃO

Movimento top-down responsivo.

Permitir:

- cima;
- baixo;
- esquerda;
- direita;
- diagonais.

Diagonal deve ser normalizada para não ficar mais rápida.

---

# 25. INPUT

Suportar:

# TECLADO

e:

# CONTROLE PS5 / DUALSENSE

Utilize Gamepad API ou suporte fornecido pela engine escolhida.

---

# 26. CONTROLE DUALSENSE

Crie mapeamento confortável.

Sugestão:

```text
Analógico esquerdo
Movimento

D-Pad
Movimento alternativo

Quadrado
Ataque / Combo principal

Triângulo
Ataque secundário / combo alternativo

Círculo
Dash

L1
Magia 1

R1
Magia 2

X
Interagir

Options
Pause
```

Pode melhorar o mapeamento após testar.

Não dependa de nomes específicos do browser se o controller for reportado genericamente.

---

# 27. CONTROLES DE TECLADO

Fornecer equivalentes.

Exemplo:

```text
WASD / Setas = Movimento

J = Ataque principal

K = Ataque secundário

Space = Dash

Q = Magia 1

E = Magia 2 / Interação conforme layout escolhido

Esc = Pause
```

Evite conflito entre magia e interação.

---

# 28. FACING

O protagonista possui direção:

```text
UP
DOWN
LEFT
RIGHT
```

Movimento diagonal pode reutilizar sprite de direção predominante.

Ataques precisam respeitar facing.

---

# 29. KATANA

A katana é o coração do combate.

Não tratar como simples hitbox genérica.

Criar:

- animações;
- arco visual;
- trail;
- som;
- impacto;
- diferentes golpes.

---

# 30. COMBO 1

O protagonista deve possuir pelo menos dois combos diferentes.

Crie o primeiro como combo rápido.

Exemplo conceitual:

```text
CORTE HORIZONTAL
→ CORTE REVERSO
→ CORTE DESCENDENTE
```

Características:

- rápido;
- fácil;
- dano moderado;
- bom contra inimigos básicos.

---

# 31. COMBO 2

Segundo combo deve possuir função diferente.

Exemplo:

```text
CORTE
→ AVANÇO
→ GOLPE FORTE
```

Pode possuir:

- mais dano;
- maior deslocamento;
- knockback;
- recovery maior.

Não fazer apenas as mesmas animações em ordem diferente.

---

# 32. INPUT DOS COMBOS

Pode usar botões diferentes ou sequências.

Exemplo:

```text
Quadrado
→ Quadrado
→ Quadrado

Triângulo
→ Quadrado
→ Triângulo
```

ou solução ergonomicamente melhor.

---

# 33. COMBO BUFFER

Criar pequena janela de input.

Jogador não precisa apertar no frame exato.

Mas também não deve conseguir spam infinito.

---

# 34. ATTACK TIMING

Cada ataque deve possuir:

```text
STARTUP
ACTIVE
RECOVERY
```

Hitbox ofensiva ativa somente durante Active.

---

# 35. HITBOX / HURTBOX

Criar sistema verdadeiro.

Ataque só acerta quando:

```text
Attack Hitbox
intersecta
Enemy Hurtbox
```

Evitar dano baseado apenas na distância.

---

# 36. SINGLE-HIT PROTECTION

Cada swing não pode causar dezenas de hits ao mesmo inimigo.

Registrar targets atingidos durante aquele attack instance.

---

# 37. DASH

O protagonista possui dash/esquiva.

Objetivo:

- reposicionamento;
- escapar de ataques;
- atravessar pequenas distâncias rapidamente.

Adicionar:

- duração;
- velocidade;
- recovery/cooldown;
- i-frames moderados se fizer sentido.

Não permitir spam infinito.

---

# 38. DASH DIRECTION

Dash deve respeitar direção pressionada.

Se nenhuma direção estiver ativa:

pode utilizar facing atual.

---

# 39. MAGIA

O protagonista possui exatamente duas magias principais nesta Fase 1.

As duas precisam ser funcionalmente diferentes.

---

# 40. MAGIA 1 — OFENSIVA

Crie uma magia de ataque.

Pode ser, por exemplo:

- corte espiritual lançado;
- onda de energia divina;
- projétil;
- lâmina de energia.

Deve permitir atingir inimigo fora do alcance da katana.

---

# 41. MAGIA 2 — CONTROLE / DEFESA / ÁREA

A segunda magia deve possuir outro papel.

Exemplos:

- explosão ao redor;
- onda que empurra inimigos;
- campo divino;
- stun curto;
- proteção;
- ataque em área.

Escolha algo coerente com um semideus da guerra.

---

# 42. IDENTIDADE DAS MAGIAS

Não use simplesmente:

```text
bola azul
bola vermelha
```

Crie nomes próprios e VFX diferentes.

Relacione os poderes:

- à guerra;
- à natureza divina;
- à mitologia/lore criada.

---

# 43. RECURSO MÁGICO

Criar:

`DIVINE ENERGY`

ou nome original mais coerente com a lore.

Magias consomem energia.

HUD mostra recurso.

---

# 44. RECUPERAÇÃO DE ENERGIA

Escolha uma combinação equilibrada de:

- regeneração lenta;
- dano causado com katana;
- pickups;
- shrine.

Isso incentiva uso da katana.

---

# 45. SINERGIA

Katana e magia devem funcionar juntas.

Exemplo:

```text
combate corpo a corpo
→ gera energia
→ magia ajuda controle
→ jogador retorna à katana
```

Evite gameplay onde a melhor estratégia seja ficar longe apertando magia.

---

# 46. HP

Criar sistema de vida.

Jogador pode:

- receber dano;
- ficar invulnerável brevemente após hit;
- morrer.

---

# 47. HIT REACTION

Ao receber dano:

- pequena reação;
- flash;
- knockback;
- breve invulnerability.

Evitar stun-lock injusto.

---

# 48. GAME FEEL

Este ponto é importante.

Implementar:

- hit stop;
- hit sparks;
- slash trails;
- blood/corruption particles estilizadas quando adequado;
- knockback;
- screen shake moderado;
- som;
- flashes;
- animações de impacto.

Light attack e golpe final de combo devem parecer diferentes.

---

# 49. ZUMBIS

Os inimigos principais desta fase são:

# GUERREIROS ZUMBIS

Eles eram guerreiros humanos.

Devem visualmente apresentar:

- armaduras danificadas;
- roupas antigas;
- armas quebradas;
- ferimentos;
- corrupção;
- pele cadavérica;
- energia sobrenatural.

Não precisam ser gore extremo.

---

# 50. VARIEDADE DE ZUMBIS

Criar no mínimo 4 arquétipos.

---

# 51. ZUMBI BÁSICO

Espadachim morto.

Características:

- melee;
- lento;
- ataque simples;
- HP baixo/médio.

Serve como primeiro inimigo.

---

# 52. ZUMBI RÁPIDO

Antigo guerreiro leve.

Características:

- mais velocidade;
- HP menor;
- ataques rápidos;
- aproximação agressiva.

---

# 53. ZUMBI PESADO

Antigo samurai/guardião com armadura.

Características:

- lento;
- HP alto;
- golpe forte;
- bom telegraph;
- resistência a knockback.

---

# 54. ZUMBI À DISTÂNCIA

Pode ser:

- arqueiro morto;
- guerreiro corrompido que utiliza energia;
- outro conceito coerente.

Deve obrigar o jogador a se movimentar.

---

# 55. IA

Usar state machine.

Exemplo:

```text
IDLE
PATROL
ALERT
CHASE
POSITION
ATTACK
RECOVER
HURT
DEAD
```

Ranged pode utilizar:

`KEEP_DISTANCE`

Heavy pode possuir:

`HEAVY_ATTACK`

---

# 56. AGGRO

Inimigos possuem:

- Detection Range;
- Attack Range;
- Disengage Range.

Não perseguem jogador pelo mapa inteiro.

---

# 57. COMBATE CONTRA GRUPOS

Não deixar todos atacarem simultaneamente sem coordenação.

Quando vários inimigos estiverem próximos:

use solução simples para espaçar ataques.

Pode ser:

- cooldown compartilhado;
- attack token;
- pequena hesitação;
- posição preferencial.

---

# 58. TELEGRAPH

Ataques fortes precisam dar oportunidade de reação.

Use:

- preparação;
- pose;
- brilho;
- som;
- pausa curta.

---

# 59. BOSS

Crie um boss original para encerrar a fase.

Ele deve estar diretamente ligado à reanimação dos guerreiros mortos.

---

# 60. CONCEITO DO BOSS

Pesquise mitologia japonesa e crie algo original baseado nela.

Pode ser:

- um general morto corrompido;
- entidade da guerra;
- oni que manipula cadáveres;
- antigo guerreiro possuído por um espírito;
- outra ideia melhor.

Não copie boss de jogo existente.

---

# 61. BOSS E A LORE

O boss deve revelar alguma informação importante.

Exemplo conceitual:

os zumbis não surgiram espontaneamente.

Eles foram:

- chamados;
- despertados;
- controlados;
- utilizados.

Derrotar o boss revela quem ou o que iniciou isso — parcialmente.

---

# 62. BOSS FIGHT

Boss precisa possuir padrões reais.

Mínimo:

- combo melee;
- ataque de área;
- avanço;
- habilidade sobrenatural.

---

# 63. DUAS FASES

A luta deve possuir pelo menos duas fases.

## PHASE 1

Boss luta de forma relativamente controlada.

## PHASE 2

Após perder parte do HP:

- mudança visual;
- nova habilidade;
- novo padrão;
- maior agressividade.

Não apenas aumentar números.

---

# 64. SUMMON

Se combinar com o boss:

ele pode invocar alguns guerreiros zumbis.

Use com moderação.

Não transformar boss fight em caos injusto.

---

# 65. BOSS TELEGRAPHS

Todo ataque poderoso deve ser legível.

O jogador precisa aprender padrões.

---

# 66. PUNISH WINDOWS

Depois de ataques importantes:

boss precisa possuir janelas onde pode ser atacado.

Não criar boss que ataca continuamente.

---

# 67. BOSS ARENA

Criar arena própria.

Elementos:

- santuário;
- pátio;
- ruínas;
- corrupção;
- árvores antigas;
- lanternas;
- símbolos;
- efeitos sobrenaturais.

Arena visualmente diferente do resto da fase.

---

# 68. BOSS INTRO

Entrada curta e impactante.

Exemplo:

```text
player entra
→ saída bloqueada
→ silêncio
→ boss aparece
→ nome do boss
→ música
→ luta
```

---

# 69. BOSS DEATH

Criar conclusão satisfatória:

- animação;
- VFX;
- energia escapando;
- pequena pausa;
- diálogo/lore;
- fim da fase.

---

# 70. CHECKPOINT

Criar pelo menos um checkpoint antes da região final.

Pode ser:

# SANTUÁRIO

Ao ativar:

- salva respawn;
- restaura HP;
- restaura energia.

---

# 71. MORTE

Ao morrer:

```text
death
→ fade
→ respawn no último shrine
```

Não recarregar página inteira.

---

# 72. PICKUPS

Pode incluir:

- cura;
- Divine Energy;
- essência.

Não criar economia complexa nesta etapa.

---

# 73. SEGREDO

Criar pelo menos um segredo real.

Exemplo:

- passagem escondida;
- trilha lateral;
- pequena caverna;
- altar.

Recompensa significativa.

---

# 74. UPGRADE

O segredo ou exploração deve conceder uma pequena melhoria.

Exemplo:

```text
+ Max HP
```

ou:

```text
+ Max Divine Energy
```

ou:

```text
upgrade de uma magia
```

---

# 75. CENÁRIO

Mapa deve parecer artesanal.

Adicionar:

- variação de terreno;
- grama;
- bambu;
- árvores;
- pedras;
- água;
- pontes;
- casas;
- santuários;
- lanternas;
- torii;
- cercas;
- plantações;
- flores;
- detalhes de destruição.

---

# 76. ÁGUA

Água deve possuir animação simples.

Não usar textura estática sem vida se puder evitar.

---

# 77. AMBIENTE VIVO

Adicionar discretamente:

- folhas;
- vento;
- partículas;
- fumaça;
- pássaros;
- lanternas;
- água;
- vegetação animada.

Sem prejudicar performance.

---

# 78. CLIMA / ATMOSFERA

Escolha uma atmosfera coerente.

Exemplo:

começo mais tranquilo;

conforme jogador se aproxima do santuário:

- cores mudam;
- névoa aumenta;
- partículas sobrenaturais aparecem;
- música fica mais ameaçadora.

Isso ajuda contar história.

---

# 79. CÂMERA

Top-down Camera Follow.

Adicionar:

- smooth follow moderado;
- map bounds;
- screen shake;
- pequenas transições.

Não criar câmera flutuante demais.

---

# 80. UI

Criar identidade própria.

HUD deve mostrar:

- HP;
- Divine Energy;
- Magia 1;
- Magia 2;
- cooldowns quando necessários.

Durante boss:

- nome;
- barra de HP.

---

# 81. MENU INICIAL

Criar:

```text
JOGAR
CONTROLES
```

Opcional:

`CRÉDITOS`

---

# 82. PAUSE

Options / Escape:

```text
CONTINUAR
CONTROLES
REINICIAR FASE
MENU
```

---

# 83. ÁUDIO

Adicionar áudio apropriado se houver meios de criar/utilizar assets legais.

No mínimo:

- katana;
- hit;
- zombie;
- dash;
- magia;
- UI;
- boss.

Adicionar música/ambientação se possível.

Não copiar áudio de jogos existentes.

---

# 84. ARQUITETURA

Organização sugerida:

```text
index.html

src/
  main.js

  scenes/
    BootScene.js
    MenuScene.js
    GameScene.js
    UIScene.js
    VictoryScene.js

  entities/
    Player.js
    enemies/
    boss/

  combat/
    Attack.js
    Hitbox.js
    Damage.js
    ComboSystem.js

  abilities/
    MagicSystem.js
    Dash.js

  world/
    Interactable.js
    Shrine.js
    NPC.js

  data/
    attacks.js
    enemies.js
    boss.js
    balance.js

assets/
  characters/
  enemies/
  boss/
  tiles/
  environment/
  vfx/
  ui/
  audio/

docs/
```

Adapte se encontrar estrutura melhor.

---

# 85. DATA-DRIVEN

Centralizar números.

Não espalhar valores pelo código.

Exemplos:

```text
PlayerHP
PlayerSpeed

AttackDamage
Startup
Active
Recovery

MagicDamage
MagicCost

EnemyHP
EnemyDamage

BossHP
```

---

# 86. STATE MACHINES

Player, inimigos e boss devem possuir estados claros.

Evitar centenas de booleans contraditórios.

---

# 87. PERFORMANCE

O jogo deve rodar suavemente em navegador desktop comum.

Evitar:

- particles nunca destruídas;
- projectiles eternos;
- listeners duplicados;
- inimigos mortos processando;
- milhares de objetos invisíveis atualizando;
- arrays crescendo infinitamente.

---

# 88. DEBUG

Criar modo debug desligado por padrão.

Pode exibir:

- FPS;
- Hitboxes;
- Hurtboxes;
- Player State;
- Enemy State;
- coordinates;
- collision.

---

# 89. TESTES — PLAYER

Validar:

```text
T01 movimento
T02 diagonal
T03 facing
T04 colisão
T05 câmera

T06 Combo 1
T07 Combo 2
T08 hitboxes
T09 single-hit protection

T10 dash
T11 dash cooldown/recovery
T12 dash i-frames se existirem

T13 magia 1
T14 magia 2
T15 custo de energia
T16 sem energia impede cast

T17 receber dano
T18 morrer
T19 respawn
```

---

# 90. TESTES — CONTROLE PS5

Com DualSense quando ambiente permitir:

```text
T20 analógico
T21 D-pad
T22 ataque principal
T23 ataque secundário
T24 dash
T25 magia 1
T26 magia 2
T27 interação
T28 pause
```

Se teste físico não for possível:

não inventar PASS.

Marcar:

`BLOCKED — physical controller unavailable`

e validar logicamente via Gamepad API.

---

# 91. TESTES — INIMIGOS

Para CADA arquétipo:

```text
T29 spawn
T30 detection
T31 movement
T32 attack
T33 receive damage
T34 knockback/stagger
T35 death
T36 cleanup
```

---

# 92. TESTES — GRUPOS

```text
T37 múltiplos inimigos
T38 nenhum stun-lock infinito
T39 attack spacing
T40 ranged + melee juntos
```

---

# 93. TESTES — EXPLORAÇÃO

```text
T41 NPC
T42 diálogo
T43 interação
T44 segredo
T45 upgrade
T46 shrine
T47 checkpoint
```

---

# 94. TESTES — BOSS

```text
T48 entrada da arena
T49 boss intro
T50 Phase 1
T51 ataques Phase 1
T52 telegraphs
T53 transition Phase 2
T54 nova mecânica
T55 ataques Phase 2
T56 damage
T57 boss death
T58 victory
```

---

# 95. TESTES — UI/MENU

```text
T59 menu
T60 controles
T61 pause
T62 HUD
T63 energy
T64 boss HP
T65 victory screen
```

---

# 96. TESTES — PIXEL ART

```text
T66 sprites sem blur
T67 integer/pixel scaling adequado
T68 cenário coerente
T69 personagem legível
T70 VFX não escondem gameplay
```

---

# 97. EDGE CASES

Procure bugs além dos testes básicos.

Exemplos:

- atacar durante morte;
- magia com energia insuficiente;
- dash dentro da parede;
- inimigo morto atacando;
- projectile atravessando mapa para sempre;
- boss Phase 2 disparando duas vezes;
- morrer durante transition do boss;
- pausar durante cutscene;
- respawn duplicando inimigos;
- inimigos presos;
- jogador saindo do mapa;
- diálogo deixando movimento ativo;
- controle desconectando.

Corrigir problemas reproduzíveis importantes.

---

# 98. PLAYTHROUGH COMPLETO

Obrigatório.

Jogar:

```text
MENU
→ INTRO
→ ALDEIA
→ INVASÃO
→ COMBATE
→ EXPLORAÇÃO
→ FLORESTA
→ SEGREDO
→ SHRINE
→ SANTUÁRIO
→ BOSS
→ VITÓRIA
```

Não considerar terminado sem validar começo ao fim.

---

# 99. BALANCEAMENTO

Depois de completar o jogo:

revisar:

- HP do jogador;
- dano;
- inimigos;
- custo das magias;
- dash;
- drops;
- boss;
- duração da fase.

Evitar extremos.

---

# 100. ART PASS

Depois que gameplay funcionar:

revisar cada tela.

Pergunte:

- cenário está vazio?
- tiles estão repetitivos?
- inimigos estão visualmente distintos?
- protagonista chama atenção?
- magia parece poderosa?
- boss parece boss?
- há profundidade visual?
- há elementos quebrando escala?
- existe blur?

Corrigir.

---

# 101. POLISH PASS

Faça uma etapa separada de:

```text
ANIMATION
VFX
AUDIO
CAMERA
LIGHTING
UI
HIT FEEDBACK
LEVEL DETAILS
```

Não finalize imediatamente após sistemas básicos funcionarem.

---

# 102. QUALIDADE MÍNIMA

Não quero:

- quadrados como personagens;
- circles como inimigos;
- cenário vazio;
- boss ampliado do inimigo comum;
- combate sem animação;
- magia sem feedback;
- controles ruins;
- fase de 2 minutos;
- código inteiro em um arquivo;
- console cheio de erros.

---

# 103. LIBERDADE CRIATIVA

Você possui liberdade para melhorar:

- nomes;
- história;
- diálogos;
- boss;
- áreas;
- inimigos;
- magias;
- cenário;
- segredos;
- pequenas mecânicas.

Mas preserve os pilares:

```text
Japão Antigo Fantástico
+
Semideus da Guerra
+
Katana
+
Guerreiros Zumbis
+
2 Combos
+
2 Magias
+
Dash
+
Pixel Art 32-bit
+
Exploração Top-down
+
Boss
```

---

# 104. CRITÉRIOS DE CONCLUSÃO

Só considerar pronto se:

[ ] roda no navegador;

[ ] possui identidade visual própria;

[ ] Pixel Art está coerente;

[ ] Japão antigo é reconhecível;

[ ] história existe;

[ ] protagonista está definido;

[ ] aldeia está construída;

[ ] invasão ocorre;

[ ] movimentação funciona;

[ ] DualSense está suportado logicamente;

[ ] katana funciona;

[ ] Combo 1 funciona;

[ ] Combo 2 funciona;

[ ] Dash funciona;

[ ] Magia 1 funciona;

[ ] Magia 2 funciona;

[ ] Divine Energy funciona;

[ ] existem pelo menos 4 variantes de guerreiros zumbis;

[ ] IA funciona;

[ ] exploração existe;

[ ] segredo existe;

[ ] NPC/interação existe;

[ ] shrine/checkpoint existe;

[ ] morte/respawn funciona;

[ ] boss é único;

[ ] boss possui pelo menos duas fases;

[ ] conclusão existe;

[ ] HUD funciona;

[ ] menu/pause funciona;

[ ] VFX/game feel foram aplicados;

[ ] assets finais não são simples placeholders geométricos;

[ ] playthrough completo foi realizado;

[ ] console não apresenta erros críticos.

---

# 105. RELATÓRIO FINAL

Ao terminar informe:

1. nome do jogo;
2. resumo da história;
3. protagonista;
4. origem divina;
5. referências históricas/mitológicas utilizadas;
6. mapa da fase;
7. áreas;
8. controles teclado;
9. controles DualSense;
10. movimentação;
11. Combo 1;
12. Combo 2;
13. Dash;
14. Magia 1;
15. Magia 2;
16. Divine Energy;
17. cada tipo de zumbi;
18. IA;
19. boss;
20. Phase 1;
21. Phase 2;
22. segredo;
23. upgrade;
24. NPCs;
25. shrine/checkpoint;
26. morte/respawn;
27. UI;
28. Pixel Art;
29. tile size;
30. resolução interna;
31. arquitetura;
32. framework escolhido;
33. áudio;
34. VFX;
35. resultado T01–T70;
36. edge cases encontrados;
37. bugs corrigidos;
38. resultado do playthrough completo;
39. limitações reais restantes;
40. arquivos principais criados.

Para testes:

```text
PASS
FAIL
BLOCKED
```

Nunca inventar `PASS`.

---

# 106. REGRA FINAL

Não trate esta tarefa como:

> "Faça um joguinho HTML retrô."

Trate como:

> "Construa a primeira fase de um action-adventure Pixel Art que possa servir como fundação de um jogo maior."

Fluxo final esperado:

```text
PESQUISAR
↓
DEFINIR IDENTIDADE
↓
CRIAR ARQUITETURA
↓
CRIAR PIXEL ART
↓
CONSTRUIR MAPA
↓
IMPLEMENTAR COMBATE
↓
IMPLEMENTAR MAGIA
↓
IMPLEMENTAR INIMIGOS
↓
CRIAR EXPLORAÇÃO
↓
CRIAR BOSS
↓
TESTAR
↓
BALANCEAR
↓
POLIR
↓
JOGAR DO INÍCIO AO FIM
```

Se precisar tomar pequenas decisões de design durante o desenvolvimento:

tome-as autonomamente.

Não pare a implementação para perguntar detalhes menores.

Pesquise quando necessário.

Crie soluções coerentes com a direção definida.

Não copie jogos existentes.

E, principalmente:

**não pare quando o jogo apenas funcionar — continue até a Fase 1 ter aparência, combate, exploração e apresentação dignos de um vertical slice bem produzido.**
`````


---

# APÊNDICE B — NOTAS ORIGINAIS DE PESQUISA

`````markdown
# Pesquisa curta — Amahara: Juramento de Guerra

## Direção de game design

A fase foi estruturada como um pequeno percurso legível: aldeia habitada → invasão/tutorial → floresta com desvio secreto → santuário/checkpoint → arena do boss. A linguagem visual usa tiles pequenos, silhuetas fortes, profundidade por Y-sort e resolução interna fixa de 480×270 para preservar leitura de Pixel Art.

O combate foi desenhado como action-adventure top-down em tempo real, não como RPG por turno. A katana é o loop principal: dois combos com funções distintas alimentam a Energia Divina; as magias são suporte ofensivo/controle e não substituem o corpo a corpo.

## Referências históricas e culturais

Fontes consultadas:

- Kokugakuin University — Encyclopedia of Shinto, “Torii”: descreve torii como portal que marca a entrada em espaço sagrado e o avanço em níveis de sacralidade dentro do recinto.
- Kokugakuin University — “History and Typology of Shrine Architecture”: recintos de santuário são demarcados; caminhos de aproximação, torii, cercas, fontes de purificação e lanternas podem estruturar o espaço.
- Kokugakuin University — “Oni”: registra a ambivalência histórica do conceito de oni, associado a seres sobrenaturais de poder temido, não simplesmente a um “monstro vermelho”.
- The Metropolitan Museum of Art — “Art of the Samurai” e peças de yoroi/dō-maru: referência para camadas de placas, laca, cordões, silhuetas de capacete e armaduras de guerreiros.
- The Met — “The Torii Gate of Gion Shrine”: referência visual para entrada de santuário inserida em espaço urbano vivo.

## Adaptação para o universo fantástico

Amahara, Ren Kurogane, Yuna, o General Jinzō e a divindade/linhagem de guerra são ficcionais. O jogo não afirma que o folclore real contenha a cosmologia inventada aqui.

O torii funciona narrativamente como transição da aldeia/floresta para um espaço progressivamente corrompido. A corrupção espiritual muda piso, partículas e música, mas o mapa preserva elementos de recinto sagrado em vez de apenas espalhar símbolos japoneses como decoração.

Os guerreiros zumbis permanecem cadáveres humanos reanimados em armaduras danificadas; a estética sobrenatural é uma corrupção adicionada à condição física deles, não uma troca por fantasmas/esqueletos.

## Identidade original

Título: **Amahara: Juramento de Guerra**.

Protagonista: **Ren Kurogane**, jovem guerreiro criado em Amahara. Sua mãe humana o confiou à guardiã Yuna após perceber que ele carregava a “Marca do Estandarte”, fragmento de uma antiga força divina associada ao impulso de conflito e proteção. Ren é um semideus no sentido ficcional do universo: poderoso, mas mortal.

Boss: **General Jinzō — O Estandarte Oco**, antigo comandante sepultado com seus soldados. Ele foi o primeiro cadáver reanimado e serve como foco de comando para os demais, mas revela que outra força tocou três sepulturas/santuários.

Magias:
- **Corte Celeste**: lâmina de energia projetada pela katana.
- **Selo de Ruptura**: expansão circular da Marca do Estandarte que causa dano, empurra e atordoa inimigos próximos.

Recurso: **Energia Divina**, recuperada lentamente e acelerada por golpes de katana.
`````


---

# APÊNDICE C — RELATÓRIO FINAL ORIGINAL

`````markdown
# Relatório final — Amahara: Juramento de Guerra

1. **Nome do jogo:** Amahara: Juramento de Guerra.
2. **História:** a aldeia de Amahara é atacada por guerreiros mortos reanimados. Ren segue o rastro da invasão por uma floresta até um santuário corrompido e descobre o General Jinzō, um comandante morto transformado no foco de comando do exército. Ao derrotá-lo, Ren descobre que Jinzō também foi chamado por uma força externa e que três outros santuários/sepulturas responderam ao mesmo ritual.
3. **Protagonista:** Ren Kurogane, jovem guerreiro mortal com sangue divino, criado em Amahara pela guardiã Yuna.
4. **Origem divina:** Ren carrega a Marca do Estandarte, fragmento ficcional de uma antiga força de guerra associada a conflito, coragem e proteção. Ela não o torna invulnerável.
5. **Referências:** arquitetura e limiares de santuário, torii, lanternas, armaduras japonesas laminadas/lacadas e a ideia de seres sobrenaturais ambivalentes. A cosmologia e personagens são originais.
6. **Mapa da fase:** aldeia → invasão → estrada/floresta → ponte/córrego → desvio secreto → santuário/checkpoint → pátio corrompido → arena do boss.
7. **Áreas:** aldeia habitada, floresta de bambu, curso d’água/ponte, altar oculto, santuário corrompido e arena final.
8. **Controles teclado:** WASD/Setas, J, K, Espaço, Q, E, F e Esc.
9. **DualSense lógico:** analógico/D-pad, Quadrado, Triângulo, Círculo, L1, R1, X e Options via Gamepad API.
10. **Movimentação:** 8 direções com diagonal normalizada, facing cardinal e colisão por eixo.
11. **Combo 1:** Corte Horizontal → Corte Reverso → Corte Descendente; rápido e focado em dano moderado/controle de básicos.
12. **Combo 2:** Passo de Ferro → Ombro da Guerra → Lâmina do Estandarte; maior avanço, dano, knockback e recovery.
13. **Dash:** Passo de Guerra; direcional, curto, cooldown de 0,58 s e i-frames durante a janela ativa.
14. **Magia 1:** Corte Celeste, lâmina de energia à distância.
15. **Magia 2:** Selo de Ruptura, área ao redor de Ren que causa dano, empurra e atordoa.
16. **Energia Divina:** 100 base, regeneração lenta, +6 por acerto de katana; segredo pode elevar máximo para 125.
17. **Zumbis:** Espadachim Morto, Corredor Morto, Guardião Pesado e Arqueiro Morto.
18. **IA:** state machines com idle/chase/telegraph/attack/recover/hurt/dead; arqueiro mantém distância; grupos limitam ataques simultâneos.
19. **Boss:** General Jinzō — O Estandarte Oco, antigo general morto, reanimado e usado como foco para controlar cadáveres.
20. **Phase 1:** combo melee, charge e ataque de área com telegraph e recovery.
21. **Phase 2:** alteração visual, agressividade maior, invocação única de mortos e rajada radial sobrenatural `grave`.
22. **Segredo:** altar oculto ao sul da rota principal da floresta.
23. **Upgrade:** +25 Max Energia Divina.
24. **NPCs:** Yuna possui papel narrativo central; a aldeia inclui sinais de ocupação e vida.
25. **Shrine/checkpoint:** restaura HP/energia e atualiza respawn antes do trecho final.
26. **Morte/respawn:** morte → mensagem/fade narrativo simplificado → respawn no último shrine sem recarregar a página.
27. **UI:** HUD de HP/Energia, cooldowns, objetivo, prompt contextual e barra do boss; menu, controles, pause e vitória.
28. **Pixel Art:** procedural por Canvas, com personagens, casas, árvores, bambu, torii, lanternas, pontes, armaduras, VFX e cenário próprios.
29. **Tile size:** 24 px lógicos.
30. **Resolução interna:** 480×270, 16:9.
31. **Arquitetura:** arquivos separados por dados, input, áudio, combate, mundo, player, inimigos, boss e game loop.
32. **Framework:** Canvas 2D nativo/JavaScript. Phaser foi evitado para eliminar dependência externa e permitir execução local simples.
33. **Áudio:** Web Audio procedural para katana, impacto, dash, magias, UI, zumbis, shrine, boss e ambientação tonal dinâmica.
34. **VFX:** slash arcs, hit sparks, particles, trails, rings, corrupção, screen shake e hit stop.
35. **T01–T70:** ver `docs/TEST_REPORT.md`; todos os testes executáveis passaram, com T20–T28 bloqueados apenas por ausência de DualSense físico.
36. **Edge cases:** revisados em `docs/TEST_REPORT.md`.
37. **Bugs corrigidos:** ring VFX com raio negativo, composição inicial vazia, boss fora de enquadramento e ausência de barreira de arena.
38. **Playthrough:** fluxo menu → intro → aldeia → invasão → floresta → segredo → shrine → boss → vitória foi percorrido por automação de Chromium; helpers foram usados para acelerar combate/progressão.
39. **Limitações:** teste físico de DualSense e playtest humano de balanceamento ainda pendentes; áudio e arte são inteiramente procedurais.
40. **Arquivos principais:** `index.html`, `style.css`, `src/data/balance.js`, `src/input.js`, `src/audio.js`, `src/combat.js`, `src/world.js`, `src/entities/player.js`, `src/entities/enemies.js`, `src/entities/boss.js`, `src/game.js`, `src/main.js`, `docs/RESEARCH.md`, `docs/TEST_REPORT.md`, `tests/cdp_smoke.js`, `tests/logic_suite.js`.
`````


---

# APÊNDICE D — RELATÓRIO DE TESTES ORIGINAL

`````markdown
# Relatório de validação — Amahara: Juramento de Guerra

Data da validação: 2026-10-04.

Ambiente: Chromium headless + validação lógica por runtime. O ambiente de execução bloqueia navegação direta para `localhost` e `file://`; por isso os scripts do projeto foram injetados em uma página vazia do Chromium para testar o runtime real de Canvas/JavaScript. Isso não altera o código entregue.

## Resultado T01–T70

| Teste | Resultado | Evidência / observação |
|---|---|---|
| T01 movimento | PASS | Smoke test com KeyboardEvent moveu o jogador. |
| T02 diagonal | PASS | Runtime confirmou vetor diagonal normalizado para magnitude 1. |
| T03 facing | PASS | Movimento à direita atualizou facing para `right`. |
| T04 colisão | PASS | Runtime confirmou bloqueio em água/obstáculo. |
| T05 câmera | PASS | Camera follow respondeu à alteração de posição. |
| T06 Combo 1 | PASS | Cadeia rápida alcançou o 3º golpe `Corte Descendente`. |
| T07 Combo 2 | PASS | Cadeia pesada alcançou `Lâmina do Estandarte`. |
| T08 hitboxes | PASS | Hitbox de ataque reduziu HP de hurtbox inimiga. |
| T09 single-hit protection | PASS | Mesmo attack instance não reaplicou dano ao mesmo alvo. |
| T10 dash | PASS | Smoke test entrou em estado `dash`. |
| T11 dash cooldown/recovery | PASS | Segundo dash imediato foi bloqueado pelo cooldown. |
| T12 dash i-frames | PASS | Dano aplicado durante dash não reduziu HP. |
| T13 magia 1 | PASS | `Corte Celeste` gerou projétil. |
| T14 magia 2 | PASS | `Selo de Ruptura` causou dano em alvo dentro da área. |
| T15 custo de energia | PASS | Energia foi consumida de acordo com balance data. |
| T16 sem energia impede cast | PASS | Com energia 0, projétil não foi criado. |
| T17 receber dano | PASS | HP caiu e estado `hurt` foi acionado. |
| T18 morrer | PASS | HP fatal gerou `dead/dead state`. |
| T19 respawn | PASS | Respawn restaurou HP e posição do checkpoint. |
| T20 analógico | BLOCKED | Physical controller unavailable. Mapeamento lógico Gamepad API implementado. |
| T21 D-pad | BLOCKED | Physical controller unavailable. Mapeamento lógico Gamepad API implementado. |
| T22 ataque principal | BLOCKED | Physical controller unavailable. Botão padrão 2 / Quadrado mapeado. |
| T23 ataque secundário | BLOCKED | Physical controller unavailable. Botão padrão 3 / Triângulo mapeado. |
| T24 dash | BLOCKED | Physical controller unavailable. Botão padrão 1 / Círculo mapeado. |
| T25 magia 1 | BLOCKED | Physical controller unavailable. L1 mapeado. |
| T26 magia 2 | BLOCKED | Physical controller unavailable. R1 mapeado. |
| T27 interação | BLOCKED | Physical controller unavailable. X/A padrão mapeado. |
| T28 pause | BLOCKED | Physical controller unavailable. Options/Start mapeado. |
| T29 spawn | PASS | Validado nos 4 arquétipos. |
| T30 detection | PASS | Validado nos 4 arquétipos. |
| T31 movement | PASS | Validado para melee; archer usa manutenção de distância. |
| T32 attack | PASS | State machines e transições de ataque executadas no runtime. |
| T33 receive damage | PASS | Validado nos 4 arquétipos. |
| T34 knockback/stagger | PASS | Estado `hurt` e vetor de knockback validados; heavy usa resistência. |
| T35 death | PASS | Validado nos 4 arquétipos. |
| T36 cleanup | PASS | Entidades mortas entram em cleanup por `deathTimer`. |
| T37 múltiplos inimigos | PASS | Cinco inimigos coexistiram no runtime. |
| T38 nenhum stun-lock infinito | PASS | I-frames impediram dano imediato duplicado. |
| T39 attack spacing | PASS | Coordenação limitou ataques simultâneos a no máximo 2. |
| T40 ranged + melee juntos | PASS | Arqueiro e espadachim coexistiram/atualizaram sem erro. |
| T41 NPC | PASS | Interação com Yuna abriu diálogo narrativo. |
| T42 diálogo | PASS | Fila de diálogo avançou corretamente. |
| T43 interação | PASS | Detecção contextual de interactable validada. |
| T44 segredo | PASS | Altar secreto foi detectado e ativado. |
| T45 upgrade | PASS | Segredo aumentou Max Divine Energy em +25. |
| T46 shrine | PASS | Shrine restaurou HP e energia. |
| T47 checkpoint | PASS | Checkpoint foi atualizado para o santuário. |
| T48 entrada da arena | PASS | Story gate acionou boss trigger. |
| T49 boss intro | PASS | Intro abriu diálogo e estado inicial do boss. |
| T50 Phase 1 | PASS | Boss iniciou em fase 1. |
| T51 ataques Phase 1 | PASS | Combo melee foi telegraphado e executado. |
| T52 telegraphs | PASS | Telegraph gerou sinal visual/ring antes do ataque. |
| T53 transition Phase 2 | PASS | HP < 50% acionou transição. |
| T54 nova mecânica | PASS | Phase 2 invocou dois mortos uma única vez. |
| T55 ataques Phase 2 | PASS | Ataque `grave` gerou 8 projéteis sobrenaturais. |
| T56 damage | PASS | Boss recebeu dano quando vulnerável. |
| T57 boss death | PASS | HP fatal mudou para estado morto. |
| T58 victory | PASS | Fluxo smoke chegou a `bossDefeated` e abriu vitória. |
| T59 menu | PASS | Menu foi exibido após `returnMenu`. |
| T60 controles | PASS | Painel de controles abriu corretamente. |
| T61 pause | PASS | Pause state e painel foram acionados. |
| T62 HUD | PASS | Render completo executou sem exceção. |
| T63 energy | PASS | HUD usa o mesmo recurso cujo consumo foi validado. |
| T64 boss HP | PASS | Render do HUD com boss ativo executou sem erro e HP inicial correto. |
| T65 victory screen | PASS | Smoke end-to-end confirmou painel de vitória visível. |
| T66 sprites sem blur | PASS | `imageSmoothingEnabled=false` validado no contexto Canvas. |
| T67 integer/pixel scaling adequado | PASS | Canvas interno 480×270 e CSS `image-rendering: pixelated`. |
| T68 cenário coerente | PASS | Revisão visual das capturas de aldeia e arena do boss. |
| T69 personagem legível | PASS | Revisão visual confirmou silhueta distinta do protagonista e inimigos. |
| T70 VFX não escondem gameplay | PASS | VFX limitados a rings/trails/partículas curtas; revisão visual sem obstrução dominante. |

## Smoke end-to-end executado

O script `tests/cdp_smoke.js` validou: boot, invasão da aldeia, limpeza da primeira onda, liberação da floresta, segredo, checkpoint, boss spawn, Phase 2, vitória, movimento, estado de ataque e dash. Resultado final: **12/12 checks PASS**, sem exceções de página após a correção do ring VFX.

O script `tests/logic_suite.js` validou lógica de movimentação, normalização diagonal, facing, colisão, câmera, combos, hitbox, single-hit protection, dash, i-frames, magias, energia, morte/respawn, quatro arquétipos de inimigos, combate em grupo, exploração, checkpoint, boss, UI e pixel-perfect. Resultado: todos os checks executados em **PASS** e `PAGE_ERRORS: PASS`.

## Edge cases revisados

- atacar durante morte: estado `dead` impede update de ação;
- magia sem energia: bloqueada;
- dash em parede/água: usa o mesmo resolvedor de colisão da movimentação;
- inimigo morto atacando: `dead` retorna antes da IA;
- projectile eterno: todo projétil possui `life` e bounds cleanup;
- Phase 2 duplicada: protegida por `phase===1` e flag `summoned`;
- morrer durante boss: fluxo de morte mantém checkpoint; boss permanece no mundo;
- pausa durante diálogo/cutscene: pause manual é bloqueado enquanto diálogo está ativo;
- respawn duplicando inimigos: respawn não chama spawn de waves;
- jogador fora do mapa: clamp + borders;
- diálogo com movimento ativo: update do jogador é interrompido durante diálogo;
- controle desconectando: ausência de gamepad volta naturalmente ao teclado.

## Bugs encontrados e corrigidos durante validação

1. Um ring de VFX podia produzir raio negativo no Canvas após a morte do boss e interromper o game loop com `IndexSizeError`. Corrigido armazenando `startLife` e clampando o raio mínimo.
2. A primeira composição da aldeia ficava visualmente vazia na câmera inicial. Casas, árvores, cercas e lanternas foram redistribuídas e a primeira wave aproximada do jogador.
3. O boss aparecia muito próximo da borda direita da câmera na intro. Sua posição e decoração da arena foram ajustadas.
4. Foi adicionada barreira de arena dinâmica para impedir recuo pelo torii durante a boss fight.

## Limitações reais restantes

- T20–T28 continuam `BLOCKED` até teste físico com um DualSense conectado em navegador compatível.
- O playthrough completo foi validado de forma automatizada com helpers de teste para acelerar combate/progressão. Não substitui um playtest humano de balanceamento e sensação de 10–15 minutos.
- Áudio é procedural via Web Audio; não há trilha musical gravada nem pacote externo de SFX.
- A Pixel Art é procedural/desenhada por código. Não usa spritesheets desenhados à mão por artista, embora já evite placeholders geométricos puros e apresente personagens, armaduras, casas, torii, vegetação, lanternas e cenário identificáveis.
`````


---

# APÊNDICE E — README ORIGINAL

`````markdown
# Amahara: Juramento de Guerra

Vertical slice de action-adventure 2D top-down em Pixel Art, ambientado em um Japão antigo fantástico.

## Executar

Opção mais simples no Windows:

```bat
run.bat
```

Ou, dentro da pasta do projeto:

```bash
python -m http.server 8000
```

Depois abra `http://localhost:8000`.

## Controles

- WASD / Setas: movimento
- J: Combo rápido — 3 cortes
- K: Combo pesado — 3 golpes com avanço/knockback
- Espaço: Passo de Guerra (dash com i-frames curtos)
- Q: Corte Celeste (projétil)
- E: Selo de Ruptura (área/stun)
- F: interagir
- Esc: pausa

DualSense lógico via Gamepad API: analógico/D-pad, Quadrado, Triângulo, Círculo, L1, R1, X e Options.

## Estrutura

- `src/data/balance.js`: números centralizados
- `src/world.js`: tilemap, colisão, props e interações
- `src/entities/player.js`: estados do jogador, combos, dash, magia
- `src/entities/enemies.js`: quatro arquétipos e IA
- `src/entities/boss.js`: boss em duas fases
- `src/combat.js`: hitbox/hurtbox e dano
- `src/input.js`: teclado + Gamepad API
- `src/audio.js`: SFX e ambientação procedural
- `docs/RESEARCH.md`: referências e decisões
- `docs/TEST_REPORT.md`: validação realizada

Não há assets de terceiros: os sprites e cenários são desenhados em Pixel Art procedural diretamente no Canvas, sem placeholders geométricos simples como identidade final.

## Validação técnica

Os testes usados durante a entrega ficam em `tests/`:

```bash
node tests/cdp_smoke.js
node tests/logic_suite.js
```

Eles usam Chromium headless através do Chrome DevTools Protocol. O relatório consolidado está em `docs/TEST_REPORT.md`.
`````


---

# APÊNDICE F — SNAPSHOT TEXTUAL DA IMPLEMENTAÇÃO

Este apêndice preserva o conteúdo dos principais arquivos de código e execução da versão documentada. Arquivos binários de imagem não são convertidos para texto.

## Arquivo: `index.html`

`````html
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no" />
  <title>Amahara: Juramento de Guerra</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <main id="frame">
    <canvas id="game" width="480" height="270" aria-label="Amahara: Juramento de Guerra"></canvas>
    <section id="menu" class="panel active">
      <div class="crest">戦</div>
      <h1>AMAHARA</h1>
      <p class="subtitle">JURAMENTO DE GUERRA</p>
      <button id="playBtn">JOGAR</button>
      <button id="controlsBtn">CONTROLES</button>
      <small>Vertical slice — Fase 1: O Estandarte Oco</small>
    </section>
    <section id="controls" class="panel hidden compact">
      <h2>CONTROLES</h2>
      <div class="controls-grid">
        <b>Movimento</b><span>WASD / Setas · Analógico / D-Pad</span>
        <b>Katana rápida</b><span>J · Quadrado</span>
        <b>Katana pesada</b><span>K · Triângulo</span>
        <b>Dash</b><span>Espaço · Círculo</span>
        <b>Corte Celeste</b><span>Q · L1</span>
        <b>Selo de Ruptura</b><span>E · R1</span>
        <b>Interagir</b><span>F · X</span>
        <b>Pausa</b><span>Esc · Options</span>
      </div>
      <button data-close="controls">VOLTAR</button>
    </section>
    <section id="pause" class="panel hidden compact">
      <h2>PAUSADO</h2>
      <button id="resumeBtn">CONTINUAR</button>
      <button id="pauseControlsBtn">CONTROLES</button>
      <button id="restartBtn">REINICIAR FASE</button>
      <button id="menuBtn">MENU</button>
    </section>
    <section id="dialogue" class="dialogue hidden">
      <div id="speaker"></div>
      <div id="dialogueText"></div>
      <div class="prompt">F / X — continuar</div>
    </section>
    <section id="victory" class="panel hidden victory">
      <div class="crest">破</div>
      <h2>O ESTANDARTE CAIU</h2>
      <p>Amahara respira outra vez — mas os mortos marcharam por ordem de alguém.</p>
      <p class="hook">Ao norte, três sinos respondem de santuários que deveriam estar vazios.</p>
      <button id="victoryRestartBtn">JOGAR NOVAMENTE</button>
      <button id="victoryMenuBtn">MENU</button>
    </section>
    <div id="toast" class="toast hidden"></div>
  </main>
  <script defer src="src/data/balance.js"></script>
  <script defer src="src/utils.js"></script>
  <script defer src="src/audio.js"></script>
  <script defer src="src/input.js"></script>
  <script defer src="src/combat.js"></script>
  <script defer src="src/world.js"></script>
  <script defer src="src/entities/player.js"></script>
  <script defer src="src/entities/enemies.js"></script>
  <script defer src="src/entities/boss.js"></script>
  <script defer src="src/game.js"></script>
  <script defer src="src/main.js"></script>
</body>
</html>
`````

## Arquivo: `style.css`

`````css
:root{background:#0b0d0c;color:#f3ead7;font-family:"Courier New",monospace;--gold:#e7c66c;--red:#8b2c2b;--ink:#111411;--paper:#e9dfc6}
*{box-sizing:border-box}html,body{height:100%;margin:0;overflow:hidden;background:radial-gradient(circle at 50% 35%,#242a22,#080a09 72%)}body{display:grid;place-items:center}
#frame{position:relative;width:min(100vw,177.78vh);aspect-ratio:16/9;max-height:100vh;overflow:hidden;box-shadow:0 0 0 2px #2b312b,0 24px 80px #000}
canvas{width:100%;height:100%;display:block;background:#1b261a;image-rendering:pixelated;image-rendering:crisp-edges}
.panel{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px;background:linear-gradient(#0c100ed8,#0a0c0bed),repeating-linear-gradient(90deg,#151914 0 2px,#111510 2px 4px);text-align:center;padding:24px;z-index:20;text-shadow:2px 2px #000}
.panel h1{font-size:clamp(38px,7vw,86px);letter-spacing:.18em;margin:0;color:#f4e9cf}.panel h2{font-size:clamp(26px,4vw,52px);letter-spacing:.12em;margin:0 0 14px;color:#f4e9cf}.subtitle{color:var(--gold);letter-spacing:.32em;margin:-4px 0 18px}.crest{width:72px;height:72px;display:grid;place-items:center;border:3px solid #a13c32;transform:rotate(45deg);font-size:38px;color:#f6d985;margin-bottom:6px}.crest::first-letter{transform:rotate(-45deg)}button{min-width:220px;padding:12px 18px;background:#1a201b;border:1px solid #6f765f;border-bottom:3px solid #0a0c0a;color:#efe7d4;font:700 16px "Courier New",monospace;letter-spacing:.08em;cursor:pointer}button:hover,button:focus{outline:none;background:#792d2b;border-color:#e0b35c}.panel small{margin-top:10px;color:#8f9a89}.hidden{display:none!important}.compact{background:#0a0d0bea;gap:8px}.controls-grid{display:grid;grid-template-columns:auto 1fr;gap:7px 20px;max-width:720px;text-align:left;margin-bottom:12px}.controls-grid b{color:#e0b35c}.dialogue{position:absolute;left:5%;right:5%;bottom:5%;z-index:15;background:#171b18f2;border:2px solid #d7c49b;box-shadow:inset 0 0 0 3px #4b2d26,0 7px 24px #000;padding:14px 18px;min-height:86px;text-shadow:1px 1px #000}.dialogue #speaker{color:#e6c76f;font-weight:bold;letter-spacing:.08em;margin-bottom:6px}.dialogue #dialogueText{line-height:1.35;font-size:clamp(12px,1.6vw,18px)}.dialogue .prompt{position:absolute;right:12px;bottom:8px;font-size:10px;color:#a7b09f}.toast{position:absolute;top:14%;left:50%;transform:translateX(-50%);z-index:18;background:#151915e8;border:1px solid #caa95f;color:#f2e4c8;padding:8px 12px;font-size:12px;box-shadow:0 5px 18px #000;white-space:nowrap}.victory p{max-width:720px;line-height:1.5}.victory .hook{color:#d0ae62}
@media(max-width:700px){.controls-grid{font-size:11px;gap:5px 10px}.panel{padding:10px}.dialogue{padding:9px 12px;min-height:72px}}
`````

## Arquivo: `run.bat`

`````bat
@echo off
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  set "PY=py"
) else (
  set "PY=python"
)
start "Amahara Server" /min cmd /c "%PY% -m http.server 8000"
timeout /t 1 /nobreak >nul
start "" http://localhost:8000
exit
`````

## Arquivo: `src/main.js`

`````javascript
addEventListener('DOMContentLoaded',()=>{const game=new AMAHARA.Game(document.getElementById('game'));window.__GAME__=game;requestAnimationFrame(t=>{game.last=t;game.frame(t)})});
`````

## Arquivo: `src/utils.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.U = {
  clamp:(v,a,b)=>Math.max(a,Math.min(b,v)),
  lerp:(a,b,t)=>a+(b-a)*t,
  len:(x,y)=>Math.hypot(x,y),
  norm(x,y){const l=Math.hypot(x,y)||1;return{x:x/l,y:y/l}},
  rects(a,b){return a.x < b.x+b.w && a.x+a.w > b.x && a.y < b.y+b.h && a.y+a.h > b.y},
  dist(a,b){return Math.hypot(a.x-b.x,a.y-b.y)},
  seeded(seed){let s=seed>>>0;return()=>((s=(s*1664525+1013904223)>>>0)/4294967296)},
  approach(v,t,a){return v<t?Math.min(t,v+a):Math.max(t,v-a)},
  now:()=>performance.now()/1000,
  pointInRect(x,y,r){return x>=r.x&&x<=r.x+r.w&&y>=r.y&&y<=r.y+r.h}
};
`````

## Arquivo: `src/data/balance.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.BALANCE = {
  internal: { width: 480, height: 270, tile: 24 },
  player: { hp: 100, energy: 100, speed: 82, dashSpeed: 270, dashDuration: .18, dashCooldown: .58, hitIFrames: .62, energyRegen: 2.2, energyOnHit: 6 },
  combos: {
    light: [
      {name:'Corte Horizontal',startup:.07,active:.08,recovery:.12,damage:11,w:28,h:18,reach:20,knockback:42,step:2,hitstop:.025},
      {name:'Corte Reverso',startup:.06,active:.09,recovery:.13,damage:12,w:30,h:18,reach:21,knockback:48,step:3,hitstop:.03},
      {name:'Corte Descendente',startup:.10,active:.11,recovery:.23,damage:19,w:34,h:22,reach:23,knockback:95,step:1,hitstop:.055}
    ],
    heavy: [
      {name:'Passo de Ferro',startup:.12,active:.11,recovery:.18,damage:15,w:31,h:20,reach:22,knockback:60,step:6,hitstop:.04},
      {name:'Ombro da Guerra',startup:.14,active:.12,recovery:.18,damage:18,w:34,h:22,reach:24,knockback:80,step:8,hitstop:.05},
      {name:'Lâmina do Estandarte',startup:.20,active:.14,recovery:.34,damage:29,w:40,h:25,reach:27,knockback:145,step:10,hitstop:.075}
    ]
  },
  magic: {
    slash: { name:'Corte Celeste', cost:25, damage:24, speed:220, life:1.45, cooldown:.9 },
    seal: { name:'Selo de Ruptura', cost:35, damage:18, radius:52, stun:.8, cooldown:5.0 }
  },
  enemies: {
    swordsman:{hp:38,speed:34,damage:10,range:24,detection:175,disengage:320,windup:.34,recovery:.55,color:'#66715c'},
    runner:{hp:25,speed:56,damage:8,range:21,detection:195,disengage:340,windup:.22,recovery:.42,color:'#7c6257'},
    heavy:{hp:86,speed:23,damage:19,range:29,detection:160,disengage:300,windup:.62,recovery:.88,color:'#4e5662'},
    archer:{hp:31,speed:29,damage:9,range:150,detection:220,disengage:360,windup:.48,recovery:1.05,color:'#64536e'}
  },
  boss:{hp:480,speed:30,damage:18,phase2:0.5}
};
`````

## Arquivo: `src/input.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.Input = class {
  constructor(){this.keys=new Set();this.pressed=new Set();this.padPrev=[];this.padPressed=new Set();this.axis={x:0,y:0};this.anyGamepad=false;this.bind()}
  bind(){addEventListener('keydown',e=>{if(!this.keys.has(e.code))this.pressed.add(e.code);this.keys.add(e.code);if(['ArrowUp','ArrowDown','ArrowLeft','ArrowRight','Space'].includes(e.code))e.preventDefault()},{passive:false});addEventListener('keyup',e=>this.keys.delete(e.code));addEventListener('blur',()=>{this.keys.clear();this.pressed.clear()})}
  update(){this.padPressed.clear();this.axis.x=0;this.axis.y=0;const pads=navigator.getGamepads?navigator.getGamepads():[];const p=[...pads].find(Boolean);this.anyGamepad=!!p;if(!p)return;let x=Math.abs(p.axes[0]||0)>.18?(p.axes[0]||0):0,y=Math.abs(p.axes[1]||0)>.18?(p.axes[1]||0):0;const b=p.buttons.map(v=>v.pressed);if(b[14])x=-1;if(b[15])x=1;if(b[12])y=-1;if(b[13])y=1;this.axis={x,y};for(let i=0;i<b.length;i++)if(b[i]&&!this.padPrev[i])this.padPressed.add(i);this.padPrev=b}
  move(){let x=0,y=0;if(this.keys.has('KeyA')||this.keys.has('ArrowLeft'))x--;if(this.keys.has('KeyD')||this.keys.has('ArrowRight'))x++;if(this.keys.has('KeyW')||this.keys.has('ArrowUp'))y--;if(this.keys.has('KeyS')||this.keys.has('ArrowDown'))y++;if(Math.abs(this.axis.x)>.05||Math.abs(this.axis.y)>.05){x=this.axis.x;y=this.axis.y}const l=Math.hypot(x,y);return l>1?{x:x/l,y:y/l}:{x,y}}
  take(action){const key={light:'KeyJ',heavy:'KeyK',dash:'Space',magic1:'KeyQ',magic2:'KeyE',interact:'KeyF',pause:'Escape'}[action];const pad={light:2,heavy:3,dash:1,magic1:4,magic2:5,interact:0,pause:9}[action];const yes=this.pressed.has(key)||this.padPressed.has(pad);if(yes)this.pressed.delete(key);return yes}
  held(code){return this.keys.has(code)}
  endFrame(){this.pressed.clear()}
};
`````

## Arquivo: `src/audio.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.Audio = class {
  constructor(){this.ctx=null;this.master=null;this.musicTimer=0;this.enabled=true}
  init(){if(this.ctx)return;const C=window.AudioContext||window.webkitAudioContext;if(!C)return;this.ctx=new C();this.master=this.ctx.createGain();this.master.gain.value=.18;this.master.connect(this.ctx.destination)}
  tone(freq=220,dur=.08,type='square',vol=.18,slide=0){if(!this.enabled)return;this.init();if(!this.ctx)return;const t=this.ctx.currentTime,o=this.ctx.createOscillator(),g=this.ctx.createGain();o.type=type;o.frequency.setValueAtTime(freq,t);if(slide)o.frequency.exponentialRampToValueAtTime(Math.max(30,freq+slide),t+dur);g.gain.setValueAtTime(vol,t);g.gain.exponentialRampToValueAtTime(.001,t+dur);o.connect(g);g.connect(this.master);o.start(t);o.stop(t+dur+.02)}
  noise(dur=.06,vol=.08){this.init();if(!this.ctx)return;const n=Math.ceil(this.ctx.sampleRate*dur),b=this.ctx.createBuffer(1,n,this.ctx.sampleRate),d=b.getChannelData(0);for(let i=0;i<n;i++)d[i]=(Math.random()*2-1)*(1-i/n);const s=this.ctx.createBufferSource(),g=this.ctx.createGain();s.buffer=b;g.gain.value=vol;s.connect(g);g.connect(this.master);s.start()}
  sfx(name){switch(name){case'slash':this.tone(330,.07,'sawtooth',.13,-140);this.noise(.04,.04);break;case'heavy':this.tone(180,.11,'square',.17,-80);this.noise(.08,.06);break;case'hit':this.tone(90,.055,'square',.15,-35);this.noise(.035,.09);break;case'dash':this.tone(520,.09,'triangle',.1,-240);break;case'magic1':this.tone(700,.18,'triangle',.13,-300);break;case'magic2':this.tone(140,.35,'sine',.16,180);break;case'zombie':this.tone(72,.24,'sawtooth',.08,-12);break;case'boss':this.tone(55,.7,'sawtooth',.18,-10);break;case'ui':this.tone(480,.05,'square',.07,50);break;case'shrine':this.tone(660,.6,'sine',.11,-120);setTimeout(()=>this.tone(880,.55,'sine',.08,-200),100);break}}
  update(dt,mode='calm'){if(!this.ctx)return;this.musicTimer-=dt;if(this.musicTimer>0)return;this.musicTimer=mode==='boss'?.42:mode==='corrupt'?.75:1.2;const notes=mode==='boss'?[82,98,110,123]:mode==='corrupt'?[110,130,146,164]:[164,196,220,246];this.tone(notes[(Math.random()*notes.length)|0],mode==='boss'?.3:.55,'sine',.025,0)}
};
`````

## Arquivo: `src/combat.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.Combat = {
  attackRect(owner,a){const f=owner.facing;const cx=owner.x,cy=owner.y-4;let w=a.w,h=a.h,x=cx-w/2,y=cy-h/2;if(f==='right')x=cx+a.reach-w*.15;if(f==='left')x=cx-a.reach-w*.85;if(f==='down')y=cy+a.reach-h*.15;if(f==='up')y=cy-a.reach-h*.85;return{x,y,w,h}},
  pushVector(owner,target,mag){const n=AMAHARA.U.norm(target.x-owner.x,target.y-owner.y);return{x:n.x*mag,y:n.y*mag}},
  damage(game,target,amount,source,knock=0,id=''){if(!target||target.dead)return false;if(target.invuln&&target.invuln>0)return false;const ok=target.takeDamage(amount,source,knock,id);if(ok){game.hitstop=Math.max(game.hitstop,source?.currentAttack?.hitstop||.025);game.shake=Math.max(game.shake,amount>20?5:3);game.spawnHit(target.x,target.y-8,amount>18?'#f4d07c':'#ded4bb');game.audio.sfx('hit')}return ok}
};
`````

## Arquivo: `src/world.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.World = class {
  constructor(game){this.game=game;this.T=24;this.cols=144;this.rows=92;this.w=this.cols*this.T;this.h=this.rows*this.T;this.tiles=new Uint8Array(this.cols*this.rows);this.props=[];this.colliders=[];this.interactables=[];this.rng=AMAHARA.U.seeded(9042026);this.build()}
  idx(x,y){return y*this.cols+x} setTile(x,y,v){if(x>=0&&y>=0&&x<this.cols&&y<this.rows)this.tiles[this.idx(x,y)]=v}
  fill(x0,y0,x1,y1,v){for(let y=y0;y<=y1;y++)for(let x=x0;x<=x1;x++)this.setTile(x,y,v)}
  road(points,r=2){for(const [cx,cy] of points)for(let y=-r;y<=r;y++)for(let x=-r;x<=r;x++)if(x*x+y*y<=r*r+1)this.setTile(cx+x,cy+y,1)}
  addProp(type,x,y,opt={}){const p={type,x,y,...opt};this.props.push(p);if(opt.collider)this.colliders.push({x:x+opt.collider.x,y:y+opt.collider.y,w:opt.collider.w,h:opt.collider.h,type});return p}
  build(){
    this.fill(0,0,this.cols-1,this.rows-1,0);
    this.fill(95,12,130,44,3); this.fill(118,14,143,38,4);
    // Village roads.
    for(let x=12;x<58;x++)this.road([[x,68]],2);for(let y=50;y<77;y++)this.road([[30,y]],2);
    // Forest trail east then north to shrine.
    for(let x=50;x<100;x++)this.road([[x,58]],2);for(let y=30;y<59;y++)this.road([[96,y]],2);for(let x=96;x<119;x++)this.road([[x,30]],2);
    // River.
    for(let x=62;x<=65;x++)for(let y=18;y<82;y++)this.setTile(x,y,2);for(let y=55;y<=61;y++)for(let x=62;x<=65;x++)this.setTile(x,y,1);
    // Village houses.
    const houses=[[300,1570],[590,1555],[865,1635],[345,1765],[700,1780],[1010,1740]];
    houses.forEach((p,i)=>this.addProp('house',p[0],p[1],{variant:i%3,collider:{x:-34,y:-40,w:68,h:46}}));
    for(let i=0;i<9;i++)this.addProp('tree',140+i*118,1460+(i%2)*38,{collider:{x:-11,y:-8,w:22,h:18}});
    for(let i=0;i<8;i++)this.addProp('tree',170+i*132,1880-(i%2)*35,{collider:{x:-11,y:-8,w:22,h:18}});
    for(let i=0;i<7;i++){this.addProp('fence',170+i*48,1702,{});this.addProp('fence',820+i*48,1702,{})}
    for(let i=0;i<5;i++)this.addProp('lantern',430+i*96,1602,{});
    for(let i=0;i<7;i++)this.addProp('crop',230+i*32,1730,{variant:i%2});
    this.addProp('well',610,1698,{collider:{x:-14,y:-10,w:28,h:20}});
    this.addProp('lantern',1020,1638,{collider:{x:-5,y:-5,w:10,h:8}});
    // Forest density, leaving path clearance.
    for(let i=0;i<110;i++){const x=1120+this.rng()*1200,y=790+this.rng()*1120;if(Math.abs(y-1392)<92||Math.abs(x-2304)<85||Math.abs(x-1512)<95)continue;this.addProp(i%5===0?'bamboo':'tree',x,y,{collider:{x:-10,y:-8,w:20,h:18}})}
    for(let i=0;i<18;i++)this.addProp('rock',1120+this.rng()*1150,820+this.rng()*1050,{variant:i%3,collider:{x:-8,y:-6,w:16,h:12}});
    // Bridge and river banks.
    this.addProp('bridge',1518,1395,{});
    // Secret southern altar and bamboo corridor.
    for(let i=0;i<18;i++){this.addProp('bamboo',1800+i*26,1830+(i%2)*34,{collider:{x:-7,y:-6,w:14,h:14}})}
    this.addProp('altar',2085,1930,{collider:{x:-17,y:-10,w:34,h:18}});
    this.interactables.push({id:'secretAltar',x:2085,y:1912,r:36,label:'Examinar altar oculto'});
    // Shrine approach.
    this.addProp('torii',2355,744,{collider:{x:-36,y:-8,w:72,h:12}});
    this.addProp('shrine',2700,620,{collider:{x:-56,y:-38,w:112,h:50}});
    this.addProp('shrine',2880,620,{small:true,collider:{x:-38,y:-27,w:76,h:36}});
    for(let i=0;i<12;i++)this.addProp('lantern',2420+(i%6)*88,760+Math.floor(i/6)*210,{collider:{x:-5,y:-5,w:10,h:8}});
    for(let i=0;i<20;i++)this.addProp('deadArmor',2400+this.rng()*520,440+this.rng()*500,{variant:i%3});
    this.addProp('checkpoint',2575,780,{collider:{x:-12,y:-7,w:24,h:14}});
    this.interactables.push({id:'checkpoint',x:2575,y:760,r:38,label:'Purificar santuário'});
    this.interactables.push({id:'inscription',x:2740,y:695,r:30,label:'Ler inscrição'});
    // Boss arena.
    this.addProp('torii',2990,680,{collider:{x:-36,y:-8,w:72,h:12}});
    for(let i=0;i<8;i++)this.addProp('lantern',3050+(i%4)*92,420+Math.floor(i/4)*350,{});
    this.addProp('banner',3100,520,{});this.addProp('banner',3370,520,{});this.addProp('banner',3120,785,{});this.addProp('banner',3350,785,{});
    for(let i=0;i<7;i++)this.addProp('oldTree',3020+i*64,320+(i%2)*500,{collider:{x:-14,y:-10,w:28,h:20}});
    this.addProp('bossShrine',3270,350,{collider:{x:-62,y:-35,w:124,h:45}});
    // World borders.
    this.colliders.push({x:-20,y:0,w:20,h:this.h},{x:this.w,y:0,w:20,h:this.h},{x:0,y:-20,w:this.w,h:20},{x:0,y:this.h,w:this.w,h:20});
  }
  groundType(tx,ty){return this.tiles[this.idx(tx,ty)]}
  isWaterAt(x,y){const tx=(x/this.T)|0,ty=(y/this.T)|0;return this.groundType(tx,ty)===2}
  bodyRect(e,x=e.x,y=e.y){return{x:x-e.w/2,y:y-e.h/2,w:e.w,h:e.h}}
  collides(e,x,y){const r=this.bodyRect(e,x,y);if(this.isWaterAt(x,y+e.h*.25))return true;for(const c of this.colliders)if(AMAHARA.U.rects(r,c))return true;if(this.game.arenaBarrier&&AMAHARA.U.rects(r,this.game.arenaBarrier))return true;return false}
  move(e,dx,dy){let nx=e.x+dx,ny=e.y;if(!this.collides(e,nx,ny))e.x=nx;nx=e.x;ny=e.y+dy;if(!this.collides(e,nx,ny))e.y=ny;e.x=AMAHARA.U.clamp(e.x,8,this.w-8);e.y=AMAHARA.U.clamp(e.y,8,this.h-8)}
  nearestInteractable(p){let best=null,bd=999;for(const it of this.interactables){const d=Math.hypot(p.x-it.x,p.y-it.y);if(d<it.r&&d<bd){best=it;bd=d}}const y=this.game.npc;if(y){const d=Math.hypot(p.x-y.x,p.y-y.y);if(d<42&&d<bd)best={id:'npcYuna',label:'Falar com Yuna'};}return best}
  drawGround(ctx,cam){const T=this.T,sx=Math.max(0,Math.floor(cam.x/T)-1),sy=Math.max(0,Math.floor(cam.y/T)-1),ex=Math.min(this.cols,Math.ceil((cam.x+480)/T)+1),ey=Math.min(this.rows,Math.ceil((cam.y+270)/T)+1);for(let y=sy;y<ey;y++)for(let x=sx;x<ex;x++){const t=this.groundType(x,y),px=x*T,py=y*T;ctx.fillStyle=t===0?'#536a3d':t===1?'#8a6a49':t===2?'#385d69':t===3?'#6a685d':'#3f3345';ctx.fillRect(px,py,T,T);const h=((x*17+y*31)%11);if(t===0){ctx.fillStyle=h<5?'#5f7845':'#485f37';ctx.fillRect(px+(h*3)%20,py+(h*7)%20,2,3)}else if(t===1){ctx.fillStyle='#74563d';ctx.fillRect(px+(h*5)%20,py+(h*2)%20,3,2)}else if(t===2){ctx.fillStyle=((x+y+(performance.now()/350|0))%3===0)?'#5d8790':'#476f79';ctx.fillRect(px+2,py+8,T-4,2)}else if(t===4){ctx.fillStyle='#68415b';ctx.fillRect(px+(h*3)%18,py+(h*4)%18,3,3)}}}
  drawProp(ctx,p){const x=Math.round(p.x),y=Math.round(p.y);ctx.save();ctx.translate(x,y);
    if(p.type==='tree'||p.type==='oldTree'){ctx.fillStyle=p.type==='oldTree'?'#3b2b25':'#4d3826';ctx.fillRect(-4,-28,8,28);ctx.fillStyle=p.type==='oldTree'?'#354534':'#2f5a34';ctx.fillRect(-18,-46,36,24);ctx.fillStyle=p.type==='oldTree'?'#42523b':'#3e7040';ctx.fillRect(-13,-53,26,18);ctx.fillStyle='#6f8a50';ctx.fillRect(-8,-49,7,4)}
    if(p.type==='bamboo'){ctx.fillStyle='#506c39';ctx.fillRect(-7,-38,3,38);ctx.fillRect(3,-44,3,44);ctx.fillStyle='#75914a';ctx.fillRect(-11,-28,8,3);ctx.fillRect(4,-18,9,3)}
    if(p.type==='house'||p.type==='shrine'||p.type==='bossShrine'){const small=p.small;const w=p.type==='bossShrine'?124:small?76:p.type==='shrine'?112:72;const h=p.type==='bossShrine'?68:small?48:p.type==='shrine'?64:58;ctx.fillStyle=p.type==='house'?'#b9a77a':'#9a8e68';ctx.fillRect(-w/2,-h,w,h-16);ctx.fillStyle=p.type==='house'?'#443a33':'#582e2e';ctx.fillRect(-w/2-6,-h-8,w+12,14);ctx.fillStyle='#302a26';ctx.fillRect(-8,-28,16,28);ctx.fillStyle='#d1c39c';ctx.fillRect(-w/2+8,-h+10,10,12);ctx.fillRect(w/2-18,-h+10,10,12)}
    if(p.type==='torii'){ctx.fillStyle='#9c3d32';ctx.fillRect(-30,-54,7,54);ctx.fillRect(23,-54,7,54);ctx.fillRect(-38,-58,76,7);ctx.fillRect(-32,-47,64,5);ctx.fillStyle='#42221f';ctx.fillRect(-40,-60,80,3)}
    if(p.type==='fence'){ctx.fillStyle='#6d5438';ctx.fillRect(-20,-8,40,4);ctx.fillRect(-16,-14,4,14);ctx.fillRect(12,-14,4,14)}
    if(p.type==='lantern'){ctx.fillStyle='#50483d';ctx.fillRect(-2,-18,4,18);ctx.fillStyle='#d29a45';ctx.fillRect(-6,-26,12,10);ctx.fillStyle='#f0d97a';ctx.fillRect(-4,-24,8,6)}
    if(p.type==='rock'){ctx.fillStyle=['#697068','#5b625c','#77776d'][p.variant||0];ctx.fillRect(-9,-8,18,8);ctx.fillRect(-6,-12,12,5)}
    if(p.type==='crop'){ctx.fillStyle='#6b8b43';for(let i=-8;i<=8;i+=4){ctx.fillRect(i,-13,2,13);ctx.fillRect(i-2,-10,6,2)}}
    if(p.type==='well'){ctx.fillStyle='#66665c';ctx.fillRect(-14,-12,28,12);ctx.fillStyle='#282f30';ctx.fillRect(-10,-10,20,7);ctx.fillStyle='#7f7769';ctx.fillRect(-16,-15,32,4)}
    if(p.type==='bridge'){ctx.fillStyle='#7a5639';ctx.fillRect(-50,-38,100,76);ctx.fillStyle='#a2774b';for(let x=-48;x<50;x+=8)ctx.fillRect(x,-35,6,70);ctx.fillStyle='#4e362a';ctx.fillRect(-50,-39,100,4);ctx.fillRect(-50,35,100,4)}
    if(p.type==='altar'||p.type==='checkpoint'){ctx.fillStyle=p.type==='altar'?'#4b4540':'#6b6152';ctx.fillRect(-17,-9,34,9);ctx.fillRect(-12,-16,24,7);ctx.fillStyle=p.type==='altar'?'#c55c4d':'#65b6a0';ctx.fillRect(-3,-24,6,8)}
    if(p.type==='banner'){ctx.fillStyle='#514537';ctx.fillRect(-2,-42,4,42);ctx.fillStyle='#6f2f52';ctx.fillRect(2,-39,18,22);ctx.fillStyle='#a85176';ctx.fillRect(5,-35,3,13)}
    if(p.type==='deadArmor'){ctx.fillStyle='#4b4747';ctx.fillRect(-8,-4,16,4);ctx.fillStyle='#59444b';ctx.fillRect(-5,-12,10,8);ctx.fillStyle='#7b604d';ctx.fillRect(5,-13,2,10)}
    ctx.restore()}
  visibleProps(cam){return this.props.filter(p=>p.x>cam.x-100&&p.x<cam.x+580&&p.y>cam.y-100&&p.y<cam.y+370)}
};
`````

## Arquivo: `src/entities/player.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.Player = class {
  constructor(game){this.game=game;this.x=500;this.y=1640;this.w=13;this.h=18;this.maxHp=AMAHARA.BALANCE.player.hp;this.hp=this.maxHp;this.maxEnergy=AMAHARA.BALANCE.player.energy;this.energy=this.maxEnergy;this.speed=AMAHARA.BALANCE.player.speed;this.facing='right';this.state='idle';this.dead=false;this.invuln=0;this.hurtTimer=0;this.dashTimer=0;this.dashCooldown=0;this.dashDir={x:1,y:0};this.attack=null;this.currentAttack=null;this.attackTimer=0;this.attackId=0;this.hitTargets=new Set();this.comboType=null;this.comboIndex=0;this.bufferedAttack=null;this.bufferTimer=0;this.magic1Cooldown=0;this.magic2Cooldown=0;this.flash=0;this.knock={x:0,y:0};this.hasSecret=false}
  reset(x=500,y=1640){this.x=x;this.y=y;this.hp=this.maxHp;this.energy=this.maxEnergy;this.dead=false;this.state='idle';this.attack=null;this.currentAttack=null;this.invuln=.8;this.knock={x:0,y:0}}
  canAct(){return !this.dead&&!['hurt','dash','attack'].includes(this.state)&&!this.game.dialogueActive&&!this.game.cutscene}
  update(dt,input){this.invuln=Math.max(0,this.invuln-dt);this.flash=Math.max(0,this.flash-dt);this.dashCooldown=Math.max(0,this.dashCooldown-dt);this.magic1Cooldown=Math.max(0,this.magic1Cooldown-dt);this.magic2Cooldown=Math.max(0,this.magic2Cooldown-dt);this.energy=Math.min(this.maxEnergy,this.energy+AMAHARA.BALANCE.player.energyRegen*dt);if(this.bufferTimer>0)this.bufferTimer-=dt;else this.bufferedAttack=null;
    if(this.dead)return;if(this.state==='hurt'){this.hurtTimer-=dt;this.game.world.move(this,this.knock.x*dt,this.knock.y*dt);this.knock.x*=.88;this.knock.y*=.88;if(this.hurtTimer<=0)this.state='idle';return}
    if(this.state==='dash'){this.dashTimer-=dt;this.game.world.move(this,this.dashDir.x*AMAHARA.BALANCE.player.dashSpeed*dt,this.dashDir.y*AMAHARA.BALANCE.player.dashSpeed*dt);this.game.spawnTrail(this.x,this.y,'#d7d7c8');if(this.dashTimer<=0)this.state='idle';return}
    if(this.state==='attack'){this.updateAttack(dt,input);return}
    const m=input.move();if(Math.abs(m.x)+Math.abs(m.y)>.05){this.state='move';this.game.world.move(this,m.x*this.speed*dt,m.y*this.speed*dt);if(Math.abs(m.x)>Math.abs(m.y))this.facing=m.x>0?'right':'left';else this.facing=m.y>0?'down':'up'}else this.state='idle';
    if(input.take('dash'))this.startDash(m);else if(input.take('light'))this.startCombo('light');else if(input.take('heavy'))this.startCombo('heavy');else if(input.take('magic1'))this.castSlash();else if(input.take('magic2'))this.castSeal();
  }
  startDash(m){if(this.dashCooldown>0)return;let d=m;if(Math.hypot(d.x,d.y)<.1)d=this.facing==='right'?{x:1,y:0}:this.facing==='left'?{x:-1,y:0}:this.facing==='down'?{x:0,y:1}:{x:0,y:-1};this.dashDir=AMAHARA.U.norm(d.x,d.y);this.state='dash';this.dashTimer=AMAHARA.BALANCE.player.dashDuration;this.dashCooldown=AMAHARA.BALANCE.player.dashCooldown;this.invuln=this.dashTimer;this.game.audio.sfx('dash')}
  startCombo(type){this.comboType=type;this.comboIndex=0;this.beginAttack(AMAHARA.BALANCE.combos[type][0])}
  beginAttack(a){this.state='attack';this.currentAttack=a;this.attackTimer=0;this.attackPhase='startup';this.attackId++;this.hitTargets.clear();this.bufferedAttack=null;this.game.audio.sfx(this.comboType==='heavy'?'heavy':'slash')}
  updateAttack(dt,input){this.attackTimer+=dt;const a=this.currentAttack;if(input.take(this.comboType)){this.bufferedAttack=this.comboType;this.bufferTimer=.32}else if(input.take(this.comboType==='light'?'heavy':'light')){this.bufferedAttack=null}
    if(this.attackPhase==='startup'&&this.attackTimer>=a.startup){this.attackPhase='active';this.attackTimer=0;this.game.world.move(this,(this.facing==='right'?1:this.facing==='left'?-1:0)*a.step,(this.facing==='down'?1:this.facing==='up'?-1:0)*a.step)}
    else if(this.attackPhase==='active'){this.applyAttackHit();if(this.attackTimer>=a.active){this.attackPhase='recovery';this.attackTimer=0}}
    else if(this.attackPhase==='recovery'&&this.attackTimer>=a.recovery){if(this.bufferedAttack&&this.comboIndex<AMAHARA.BALANCE.combos[this.comboType].length-1){this.comboIndex++;this.beginAttack(AMAHARA.BALANCE.combos[this.comboType][this.comboIndex])}else{this.state='idle';this.currentAttack=null;this.comboType=null;this.comboIndex=0}}
  }
  applyAttackHit(){const rect=AMAHARA.Combat.attackRect(this,this.currentAttack);for(const e of this.game.enemies){if(e.dead||this.hitTargets.has(e.id))continue;if(AMAHARA.U.rects(rect,e.hurtbox())){this.hitTargets.add(e.id);AMAHARA.Combat.damage(this.game,e,this.currentAttack.damage,this,this.currentAttack.knockback,this.attackId);this.energy=Math.min(this.maxEnergy,this.energy+AMAHARA.BALANCE.player.energyOnHit)}}const b=this.game.boss;if(b&&!b.dead&&!this.hitTargets.has(b.id)&&AMAHARA.U.rects(rect,b.hurtbox())){this.hitTargets.add(b.id);AMAHARA.Combat.damage(this.game,b,this.currentAttack.damage,this,this.currentAttack.knockback,this.attackId);this.energy=Math.min(this.maxEnergy,this.energy+AMAHARA.BALANCE.player.energyOnHit)}}
  castSlash(){const m=AMAHARA.BALANCE.magic.slash;if(this.magic1Cooldown>0||this.energy<m.cost)return this.game.toast('Energia divina insuficiente');this.energy-=m.cost;this.magic1Cooldown=m.cooldown;const d=this.facing==='right'?{x:1,y:0}:this.facing==='left'?{x:-1,y:0}:this.facing==='down'?{x:0,y:1}:{x:0,y:-1};this.game.projectiles.push({type:'playerSlash',x:this.x+d.x*18,y:this.y-4+d.y*18,vx:d.x*m.speed,vy:d.y*m.speed,w:20,h:12,life:m.life,damage:m.damage,owner:this,hit:new Set()});this.game.audio.sfx('magic1');this.game.spawnBurst(this.x,this.y,'#9de3e0',8)}
  castSeal(){const m=AMAHARA.BALANCE.magic.seal;if(this.magic2Cooldown>0||this.energy<m.cost)return this.game.toast('Energia divina insuficiente');this.energy-=m.cost;this.magic2Cooldown=m.cooldown;this.game.rings.push({x:this.x,y:this.y,r:4,max:m.radius,life:.4,color:'#d59b59'});for(const e of this.game.enemies)if(!e.dead&&AMAHARA.U.dist(this,e)<m.radius){AMAHARA.Combat.damage(this.game,e,m.damage,this,75,'seal');e.stun=Math.max(e.stun||0,m.stun)}if(this.game.boss&&!this.game.boss.dead&&AMAHARA.U.dist(this,this.game.boss)<m.radius)AMAHARA.Combat.damage(this.game,this.game.boss,m.damage*.7,this,40,'seal');this.game.audio.sfx('magic2');this.game.spawnBurst(this.x,this.y,'#e6b55f',18)}
  takeDamage(amount,source,knock=0,id=''){if(this.invuln>0||this.dead)return false;this.hp=Math.max(0,this.hp-amount);this.flash=.15;this.invuln=AMAHARA.BALANCE.player.hitIFrames;const n=source?AMAHARA.U.norm(this.x-source.x,this.y-source.y):{x:0,y:0};this.knock={x:n.x*knock,y:n.y*knock};if(this.hp<=0){this.dead=true;this.state='dead';this.game.onPlayerDeath()}else{this.state='hurt';this.hurtTimer=.22}return true}
  hurtbox(){return{x:this.x-this.w/2,y:this.y-this.h/2,w:this.w,h:this.h}}
  draw(ctx){const x=Math.round(this.x),y=Math.round(this.y);ctx.save();ctx.translate(x,y);if(this.invuln>0&&Math.floor(this.invuln*20)%2===0)ctx.globalAlpha=.55; // shadow
    ctx.fillStyle='#1a1c19';ctx.fillRect(-8,7,16,4); // legs
    const step=this.state==='move'?(Math.sin(performance.now()/75)>0?1:-1):0;
    ctx.fillStyle='#2b3133';ctx.fillRect(-6,2+step,5,9);ctx.fillRect(1,2-step,5,9); // hakama
    ctx.fillStyle='#6b2630';ctx.fillRect(-7,-9,14,12);ctx.fillStyle='#a23b39';ctx.fillRect(-6,-8,5,9); // torso
    ctx.fillStyle='#c7a07d';ctx.fillRect(-4,-15,8,6);ctx.fillStyle='#1e2325';ctx.fillRect(-5,-18,10,4); // hair
    ctx.fillStyle='#d9b05e';ctx.fillRect(4,-9,2,10);ctx.fillStyle='#d9b05e';ctx.fillRect(5,-18,2,3); // divine mark
    // katana
    const fx=this.facing==='left'?-1:1;ctx.fillStyle='#d8d8d1';ctx.fillRect(fx>0?7:-18,-4,11,2);ctx.fillStyle='#72502d';ctx.fillRect(fx>0?5:-8,-3,3,4);
    if(this.state==='attack'&&this.attackPhase==='active'){ctx.strokeStyle=this.comboType==='heavy'?'#f1c46b':'#e7ebe1';ctx.lineWidth=2;ctx.beginPath();ctx.arc(0,-4,this.currentAttack.reach+9,this.facing==='up'?Math.PI*1.1:this.facing==='down'?.1:this.facing==='left'?Math.PI*.65:-Math.PI*.35,this.facing==='up'?Math.PI*1.9:this.facing==='down'?Math.PI*.9:this.facing==='left'?Math.PI*1.35:Math.PI*.35);ctx.stroke()}
    ctx.restore()}
};
`````

## Arquivo: `src/entities/enemies.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
let enemySeq=1;
AMAHARA.Enemy = class {
  constructor(game,type,x,y){this.game=game;this.type=type;this.id='e'+enemySeq++;this.x=x;this.y=y;this.w=14;this.h=18;const d=AMAHARA.BALANCE.enemies[type];Object.assign(this,{maxHp:d.hp,hp:d.hp,speed:d.speed,damage:d.damage,range:d.range,detection:d.detection,disengage:d.disengage,windup:d.windup,recovery:d.recovery,color:d.color});this.state='idle';this.timer=Math.random();this.dead=false;this.invuln=0;this.stun=0;this.flash=0;this.attackId=0;this.hitDone=false;this.facing='left';this.knock={x:0,y:0};this.deathTimer=0}
  hurtbox(){return{x:this.x-this.w/2,y:this.y-this.h/2,w:this.w,h:this.h}}
  takeDamage(amount,source,knock=0,id=''){if(this.dead||this.invuln>0)return false;this.hp-=amount;this.flash=.12;this.invuln=.08;const n=AMAHARA.U.norm(this.x-source.x,this.y-source.y);const resist=this.type==='heavy'?.35:1;this.knock={x:n.x*knock*resist,y:n.y*knock*resist};if(this.hp<=0){this.dead=true;this.state='dead';this.deathTimer=.5;this.game.onEnemyKilled(this);this.game.spawnBurst(this.x,this.y,'#6b3658',10)}else{this.state='hurt';this.timer=this.type==='heavy'?.08:.16}return true}
  update(dt){if(this.dead){this.deathTimer-=dt;return}this.invuln=Math.max(0,this.invuln-dt);this.flash=Math.max(0,this.flash-dt);if(this.stun>0){this.stun-=dt;return}if(this.state==='hurt'){this.timer-=dt;this.game.world.move(this,this.knock.x*dt,this.knock.y*dt);this.knock.x*=.82;this.knock.y*=.82;if(this.timer<=0)this.state='chase';return}const p=this.game.player,d=AMAHARA.U.dist(this,p);if(p.dead){this.state='idle';return}if(this.state==='idle'){this.timer-=dt;if(d<this.detection)this.state='chase';else if(this.timer<=0){this.timer=1+Math.random()*1.5}}
    else if(this.state==='chase'){if(d>this.disengage){this.state='idle';return}if(this.type==='archer'){if(d<82){const n=AMAHARA.U.norm(this.x-p.x,this.y-p.y);this.game.world.move(this,n.x*this.speed*dt,n.y*this.speed*dt)}else if(d>135){const n=AMAHARA.U.norm(p.x-this.x,p.y-this.y);this.game.world.move(this,n.x*this.speed*dt,n.y*this.speed*dt)}if(d<this.range&&this.game.requestEnemyAttack(this))this.startTelegraph()}else if(d>this.range){const n=AMAHARA.U.norm(p.x-this.x,p.y-this.y);this.game.world.move(this,n.x*this.speed*dt,n.y*this.speed*dt);this.facing=n.x>0?'right':'left'}else if(this.game.requestEnemyAttack(this))this.startTelegraph()}
    else if(this.state==='telegraph'){this.timer-=dt;if(this.timer<=0){this.state='attack';this.timer=this.type==='heavy'?.18:.12;this.attackId++;this.hitDone=false;if(this.type==='archer')this.fireArrow()}}
    else if(this.state==='attack'){this.timer-=dt;if(this.type!=='archer'&&!this.hitDone){const r={x:this.x-(this.facing==='left'?this.range:0),y:this.y-12,w:this.range+10,h:24};if(AMAHARA.U.rects(r,p.hurtbox())){this.hitDone=true;AMAHARA.Combat.damage(this.game,p,this.damage,this,this.type==='heavy'?110:65,this.attackId)}}if(this.timer<=0){this.state='recover';this.timer=this.recovery}}
    else if(this.state==='recover'){this.timer-=dt;if(this.timer<=0)this.state='chase'}
  }
  startTelegraph(){this.state='telegraph';this.timer=this.windup;this.facing=this.game.player.x>this.x?'right':'left'}
  fireArrow(){const p=this.game.player,n=AMAHARA.U.norm(p.x-this.x,p.y-this.y);this.game.projectiles.push({type:'arrow',x:this.x,y:this.y-8,vx:n.x*120,vy:n.y*120,w:8,h:4,life:2.4,damage:this.damage,owner:this,hit:new Set()});this.game.audio.tone(280,.08,'square',.05,-80)}
  draw(ctx){const x=Math.round(this.x),y=Math.round(this.y);ctx.save();ctx.translate(x,y);if(this.flash>0)ctx.globalAlpha=.55;ctx.fillStyle='#171a17';ctx.fillRect(-7,7,14,4);const c=this.type==='heavy'?'#505765':this.type==='runner'?'#6e524b':this.type==='archer'?'#55475f':'#5a6655';ctx.fillStyle=c;ctx.fillRect(-6,-8,12,14);ctx.fillStyle='#879174';ctx.fillRect(-4,-14,8,6);ctx.fillStyle='#402f35';ctx.fillRect(-5,-17,10,4);ctx.fillStyle='#7b365a';ctx.fillRect(-2,-12,3,3);if(this.type==='heavy'){ctx.fillStyle='#707985';ctx.fillRect(-9,-9,18,6);ctx.fillRect(-8,-16,16,4);ctx.fillStyle='#a48e64';ctx.fillRect(8,-7,3,13)}else if(this.type==='runner'){ctx.fillStyle='#9f7a5f';ctx.fillRect(6,-7,10,2)}else if(this.type==='archer'){ctx.strokeStyle='#9a7951';ctx.lineWidth=2;ctx.beginPath();ctx.arc(8,-6,8,-1.2,1.2);ctx.stroke()}else{ctx.fillStyle='#9d9b8d';ctx.fillRect(6,-6,10,2)}if(this.state==='telegraph'){ctx.fillStyle=this.type==='heavy'?'#f2b45a':'#d56b5f';ctx.fillRect(-7,-24,14,2)}ctx.restore();if(this.hp<this.maxHp&&!this.dead){ctx.fillStyle='#181818';ctx.fillRect(x-9,y-25,18,2);ctx.fillStyle='#9e3d3d';ctx.fillRect(x-9,y-25,18*(this.hp/this.maxHp),2)}}
};
`````

## Arquivo: `src/entities/boss.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.Boss = class {
  constructor(game,x,y){this.game=game;this.id='boss';this.x=x;this.y=y;this.w=26;this.h=34;this.maxHp=AMAHARA.BALANCE.boss.hp;this.hp=this.maxHp;this.speed=AMAHARA.BALANCE.boss.speed;this.damage=AMAHARA.BALANCE.boss.damage;this.phase=1;this.state='intro';this.timer=1.5;this.dead=false;this.invuln=1.7;this.flash=0;this.attackName='';this.attackId=0;this.hitDone=false;this.facing='left';this.chargeDir={x:-1,y:0};this.summoned=false;this.deathTimer=0}
  hurtbox(){return{x:this.x-this.w/2,y:this.y-this.h/2,w:this.w,h:this.h}}
  takeDamage(amount,source,knock=0,id=''){if(this.dead||this.invuln>0)return false;this.hp-=amount;this.flash=.11;this.invuln=.05;if(this.phase===1&&this.hp/this.maxHp<=AMAHARA.BALANCE.boss.phase2){this.phase=2;this.state='transition';this.timer=1.7;this.invuln=1.8;this.game.toast('FASE 2 — O ESTANDARTE DESPERTOU');this.game.spawnBurst(this.x,this.y,'#a24a73',32);this.game.shake=8;this.game.audio.sfx('boss')}if(this.hp<=0){this.hp=0;this.dead=true;this.state='dead';this.deathTimer=2.4;this.game.onBossDeath()}return true}
  update(dt){this.invuln=Math.max(0,this.invuln-dt);this.flash=Math.max(0,this.flash-dt);if(this.dead){this.deathTimer-=dt;return}const p=this.game.player,d=AMAHARA.U.dist(this,p);this.facing=p.x>this.x?'right':'left';if(this.state==='intro'){this.timer-=dt;if(this.timer<=0)this.recover(.6);return}if(this.state==='transition'){this.timer-=dt;if(this.timer<=0){if(!this.summoned){this.summoned=true;this.game.spawnEnemy('runner',this.x-55,this.y+35);this.game.spawnEnemy('swordsman',this.x+55,this.y+35)}this.recover(.55)}return}if(this.state==='recover'){this.timer-=dt;if(this.timer<=0)this.chooseAttack(d);return}if(this.state==='chase'){if(d>66){const n=AMAHARA.U.norm(p.x-this.x,p.y-this.y);this.game.world.move(this,n.x*this.speed*dt,n.y*this.speed*dt)}else this.chooseAttack(d);return}if(this.state==='telegraph'){this.timer-=dt;if(this.timer<=0)this.executeAttack();return}if(this.state==='attack'){this.updateAttack(dt);return}}
  chooseAttack(d){if(d>150){this.state='chase';return}const r=Math.random();let name;if(this.phase===1)name=r<.46?'combo':r<.76?'charge':'aoe';else name=r<.30?'combo':r<.53?'charge':r<.76?'aoe':'grave';this.telegraph(name)}
  telegraph(name){this.attackName=name;this.state='telegraph';this.timer=name==='aoe'?.75:name==='charge'?.55:name==='grave'?.8:.34;this.game.rings.push({x:this.x,y:this.y,r:6,max:name==='aoe'?78:36,life:this.timer,color:name==='grave'?'#9d477b':'#c66b54'})}
  executeAttack(){this.state='attack';this.attackId++;this.hitDone=false;const p=this.game.player;if(this.attackName==='charge'){this.chargeDir=AMAHARA.U.norm(p.x-this.x,p.y-this.y);this.timer=.38}else if(this.attackName==='combo')this.timer=.52;else if(this.attackName==='aoe'){this.timer=.18;this.areaHit(78,this.phase===2?23:19,125)}else if(this.attackName==='grave'){this.timer=.28;for(let i=0;i<8;i++){const a=i*Math.PI/4+(this.phase===2?.15:0);this.game.projectiles.push({type:'grave',x:this.x,y:this.y-8,vx:Math.cos(a)*105,vy:Math.sin(a)*105,w:9,h:9,life:2.7,damage:12,owner:this,hit:new Set()})}this.game.spawnBurst(this.x,this.y,'#9d477b',20)}}
  updateAttack(dt){this.timer-=dt;const p=this.game.player;if(this.attackName==='charge'){this.game.world.move(this,this.chargeDir.x*210*dt,this.chargeDir.y*210*dt);if(!this.hitDone&&AMAHARA.U.rects(this.hurtbox(),p.hurtbox())){this.hitDone=true;AMAHARA.Combat.damage(this.game,p,22,this,150,this.attackId)}}else if(this.attackName==='combo'){const rel=.52-this.timer;const hitWindows=[[.08,.14],[.22,.29],[.38,.46]];for(let i=0;i<hitWindows.length;i++){if(rel>=hitWindows[i][0]&&rel<=hitWindows[i][1]&&!this['h'+i]){this['h'+i]=true;const r={x:this.x+(this.facing==='right'?8:-50),y:this.y-24,w:42,h:42};if(AMAHARA.U.rects(r,p.hurtbox()))AMAHARA.Combat.damage(this.game,p,10+(i===2?8:0),this,i===2?120:70,this.attackId+'-'+i)}}}if(this.timer<=0){this.h0=this.h1=this.h2=false;this.recover(this.phase===2?.55:.78)}}
  areaHit(rad,dmg,knock){const p=this.game.player;if(AMAHARA.U.dist(this,p)<=rad)AMAHARA.Combat.damage(this.game,p,dmg,this,knock,this.attackId)}
  recover(t){this.state='recover';this.timer=t}
  draw(ctx){const x=Math.round(this.x),y=Math.round(this.y);ctx.save();ctx.translate(x,y);if(this.flash>0)ctx.globalAlpha=.55;ctx.fillStyle='#161616';ctx.fillRect(-16,13,32,6);ctx.fillStyle=this.phase===2?'#54273f':'#323c42';ctx.fillRect(-13,-14,26,28);ctx.fillStyle='#636b70';ctx.fillRect(-17,-13,34,8);ctx.fillStyle='#73534a';ctx.fillRect(-8,-24,16,10);ctx.fillStyle='#2a2428';ctx.fillRect(-12,-29,24,6);ctx.fillStyle='#b14661';ctx.fillRect(-2,-20,4,4);ctx.fillStyle='#a78959';ctx.fillRect(13,-9,4,23);ctx.fillStyle='#c8c6b9';ctx.fillRect(this.facing==='right'?16:-38,-6,22,3);ctx.fillStyle=this.phase===2?'#c14e83':'#7d3252';ctx.fillRect(-5,-38,10,10);if(this.state==='telegraph'){ctx.fillStyle='#efc56b';ctx.fillRect(-18,-43,36,3)}ctx.restore()}
};
`````

## Arquivo: `src/game.js`

`````javascript
window.AMAHARA = window.AMAHARA || {};
AMAHARA.Game = class {
  constructor(canvas){this.canvas=canvas;this.ctx=canvas.getContext('2d');this.ctx.imageSmoothingEnabled=false;this.input=new AMAHARA.Input();this.audio=new AMAHARA.Audio();this.world=new AMAHARA.World(this);this.player=new AMAHARA.Player(this);this.enemies=[];this.boss=null;this.npc={x:700,y:1660,name:'Yuna',role:'Guardiã do Santuário'};this.projectiles=[];this.particles=[];this.rings=[];this.camera={x:260,y:1505};this.shake=0;this.hitstop=0;this.paused=true;this.started=false;this.dialogueActive=false;this.dialogueQueue=[];this.cutscene=false;this.story=0;this.kills=0;this.checkpoint={x:500,y:1640};this.objective='';this.spawnedForest=false;this.spawnedShrine=false;this.bossTriggered=false;this.bossDefeated=false;this.enemyAttackCooldown=0;this.arenaBarrier=null;this.debug=false;this.last=performance.now();this.bindUI();this.installTestAPI()}
  bindUI(){const q=id=>document.getElementById(id);q('playBtn').onclick=()=>this.start();q('controlsBtn').onclick=()=>this.showPanel('controls');document.querySelector('[data-close="controls"]').onclick=()=>this.showPanel(this.started&&this.paused?'pause':'menu');q('resumeBtn').onclick=()=>this.togglePause(false);q('pauseControlsBtn').onclick=()=>this.showPanel('controls');q('restartBtn').onclick=()=>this.restart();q('menuBtn').onclick=()=>this.returnMenu();q('victoryRestartBtn').onclick=()=>this.restart(true);q('victoryMenuBtn').onclick=()=>this.returnMenu()}
  showPanel(id){for(const p of ['menu','controls','pause','victory'])document.getElementById(p).classList.add('hidden');document.getElementById(id).classList.remove('hidden')}
  start(){this.audio.init();this.audio.sfx('ui');document.getElementById('menu').classList.add('hidden');this.started=true;this.paused=false;this.resetState();this.openDialogue([
    ['Yuna','Ren, o arroz ainda está no fogo. Pela primeira vez em semanas, a aldeia parece em paz.'],
    ['Ren','Paz demais. Os corvos sumiram da encosta.'],
    ['Yuna','Então ouviu também... o sino do santuário tocou sozinho.'],
    ['','Um grito corta a rua. Metal arrasta na terra. Um guerreiro morto atravessa o portão.']
  ],()=>{this.story=1;this.objective='Defenda Amahara — derrote os invasores (0/5)';this.spawnVillageWave()})}
  resetState(){this.world=new AMAHARA.World(this);this.player=new AMAHARA.Player(this);this.enemies=[];this.boss=null;this.projectiles=[];this.particles=[];this.rings=[];this.camera={x:260,y:1505};this.story=0;this.kills=0;this.checkpoint={x:500,y:1640};this.objective='';this.spawnedForest=false;this.spawnedShrine=false;this.bossTriggered=false;this.bossDefeated=false;this.enemyAttackCooldown=0;this.arenaBarrier=null;this.cutscene=false;this.dialogueActive=false;document.getElementById('dialogue').classList.add('hidden');document.getElementById('victory').classList.add('hidden')}
  restart(skipIntro=false){this.showPanel('pause');document.getElementById('pause').classList.add('hidden');this.started=true;this.paused=false;this.resetState();if(skipIntro){this.story=1;this.objective='Defenda Amahara — derrote os invasores (0/5)';this.spawnVillageWave()}else this.start()}
  returnMenu(){this.started=false;this.paused=true;this.resetState();this.showPanel('menu')}
  spawnVillageWave(){[[645,1635,'swordsman'],[735,1700,'runner'],[665,1540,'swordsman'],[820,1760,'heavy'],[900,1600,'archer']].forEach(a=>this.spawnEnemy(a[2],a[0],a[1]));this.audio.sfx('zombie')}
  spawnForest(){if(this.spawnedForest)return;this.spawnedForest=true;[[1260,1370,'runner'],[1320,1450,'swordsman'],[1680,1300,'archer'],[1780,1450,'swordsman'],[1980,1280,'heavy'],[2180,1390,'runner']].forEach(a=>this.spawnEnemy(a[2],a[0],a[1]))}
  spawnShrine(){if(this.spawnedShrine)return;this.spawnedShrine=true;[[2380,900,'swordsman'],[2470,980,'heavy'],[2700,900,'archer'],[2820,830,'runner']].forEach(a=>this.spawnEnemy(a[2],a[0],a[1]))}
  spawnEnemy(type,x,y){const e=new AMAHARA.Enemy(this,type,x,y);this.enemies.push(e);return e}
  requestEnemyAttack(e){if(this.enemyAttackCooldown>0)return false;const active=this.enemies.filter(x=>!x.dead&&['telegraph','attack'].includes(x.state)).length;if(active>=2)return false;this.enemyAttackCooldown=.22;return true}
  onEnemyKilled(e){this.kills++;if(this.story===1){const n=Math.min(this.kills,5);this.objective=`Defenda Amahara — derrote os invasores (${n}/5)`;if(this.enemies.filter(x=>!x.dead).length===0){this.story=2;this.objective='Fale com Yuna';this.toast('A última lâmina morta cai. Yuna chama você.')}}}
  onPlayerDeath(){this.openDialogue([['','A marca divina apaga por um instante...']],()=>setTimeout(()=>this.respawn(),250))}
  respawn(){this.player.reset(this.checkpoint.x,this.checkpoint.y);this.projectiles=[];this.toast('Você despertou no último santuário.')}
  onBossDeath(){this.bossDefeated=true;this.objective='';this.cutscene=true;this.arenaBarrier=null;this.audio.sfx('boss');this.spawnBurst(this.boss.x,this.boss.y,'#c75a8c',36);this.rings.push({x:this.boss.x,y:this.boss.y,r:8,max:92,life:.9,color:'#d78bb0'});setTimeout(()=>this.openDialogue([
    ['General Jinzō','Eu não os despertei... eu apenas ouvi o chamado sob a montanha.'],
    ['Ren','Quem chamou os mortos?'],
    ['General Jinzō','Três sinos. Três sepulturas. E alguém que conhece o sangue em suas veias...'],
    ['','O estandarte se desfaz em cinza violeta. Ao longe, três sinos respondem.']
  ],()=>{this.cutscene=false;this.paused=true;this.showPanel('victory')}),900)}
  openDialogue(lines,onDone=null){this.dialogueQueue=lines.slice();this.dialogueDone=onDone;this.dialogueActive=true;this.nextDialogue()}
  nextDialogue(){if(!this.dialogueQueue.length){this.dialogueActive=false;document.getElementById('dialogue').classList.add('hidden');const cb=this.dialogueDone;this.dialogueDone=null;if(cb)cb();return}const [s,t]=this.dialogueQueue.shift();document.getElementById('speaker').textContent=s;document.getElementById('dialogueText').textContent=t;document.getElementById('dialogue').classList.remove('hidden')}
  interact(){const it=this.world.nearestInteractable(this.player);if(!it)return;const id=it.id;if(id==='npcYuna'){if(this.story===2){this.openDialogue([['Yuna','As armaduras trazem o selo do general Jinzō. Ele morreu há oitenta anos, no vale acima do santuário.'],['Ren','Então alguém abriu uma sepultura de guerra.'],['Yuna','Siga o rastro. E Ren... sua marca está brilhando como na noite em que sua mãe o trouxe até mim.']],()=>{this.story=3;this.objective='Siga o rastro pela floresta até o santuário';this.spawnForest()})}else this.openDialogue([['Yuna','Não deixe a raiva escolher o ritmo da sua espada.']])}
    else if(id==='checkpoint'){this.checkpoint={x:2575,y:820};this.player.hp=this.player.maxHp;this.player.energy=this.player.maxEnergy;this.audio.sfx('shrine');this.toast('Santuário purificado — checkpoint restaurado');if(this.story<4){this.story=4;this.objective='Atravesse o torii e encontre a origem da corrupção';this.openDialogue([['Ren','A água de purificação está negra... mas a chama ainda responde.'],['','A marca dourada no braço de Ren reage a algo atrás do último torii.']])}}
    else if(id==='inscription')this.openDialogue([['Inscrição','“Quando o estandarte sem senhor se erguer, os que morreram pela guerra esquecerão que morreram.”']]);
    else if(id==='secretAltar'){if(!this.player.hasSecret){this.player.hasSecret=true;this.player.maxEnergy+=25;this.player.energy=this.player.maxEnergy;this.audio.sfx('shrine');this.toast('SEGREDO — Fragmento do Estandarte: +25 Energia Divina');this.openDialogue([['Ren','Este altar não pertence ao santuário. Alguém o escondeu depois da guerra.']])}else this.toast('O altar está silencioso.')}}
  triggerBoss(){if(this.bossTriggered)return;this.bossTriggered=true;this.cutscene=true;this.objective='';this.arenaBarrier={x:2978,y:520,w:18,h:330,type:'sealedGate'};this.player.x=3060;this.player.y=670;this.boss=new AMAHARA.Boss(this,3235,610);this.audio.sfx('boss');this.openDialogue([['','O torii atrás de Ren se fecha em chamas negras.'],['General Jinzō','Sangue do campo de batalha... finalmente veio até mim.'],['Ren','Você trouxe os mortos para Amahara.'],['General Jinzō','Não. Eu fui o primeiro deles.']],()=>{this.cutscene=false;this.boss.state='recover';this.boss.timer=.5;this.objective='Derrote General Jinzō — O Estandarte Oco'})}
  update(dt){this.input.update();if(this.input.pressed&&this.input.pressed.has('F3')){this.debug=!this.debug;this.input.pressed.delete('F3')}if(this.started&&this.input.take('pause')&&!this.dialogueActive){this.togglePause(!this.paused);this.input.endFrame();return}if(this.dialogueActive){if(this.input.take('interact')||this.input.take('light'))this.nextDialogue();this.input.endFrame();return}if(this.paused||!this.started){this.input.endFrame();return}if(this.hitstop>0){this.hitstop-=dt;this.input.endFrame();return}this.enemyAttackCooldown=Math.max(0,this.enemyAttackCooldown-dt);this.player.update(dt,this.input);if(this.input.take('interact'))this.interact();if(this.player.x>1120&&this.story>=3)this.spawnForest();if(this.player.x>2280&&this.player.y<1150&&this.story>=3)this.spawnShrine();if(this.player.x>2960&&this.player.y<900&&this.story>=4)this.triggerBoss();for(const e of this.enemies)e.update(dt);this.enemies=this.enemies.filter(e=>!e.dead||e.deathTimer>0);if(this.boss)this.boss.update(dt);this.updateProjectiles(dt);this.updateFx(dt);this.updateCamera(dt);this.audio.update(dt,this.boss&&!this.boss.dead?'boss':this.player.x>2250?'corrupt':'calm');this.input.endFrame()}
  togglePause(v){if(!this.started)return;this.paused=v;if(v)this.showPanel('pause');else document.getElementById('pause').classList.add('hidden')}
  updateProjectiles(dt){for(const p of this.projectiles){p.life-=dt;p.x+=p.vx*dt;p.y+=p.vy*dt;if(this.world.isWaterAt(p.x,p.y)&&p.type!=='grave')p.life=0;if(p.type==='playerSlash'){for(const e of this.enemies)if(!e.dead&&!p.hit.has(e.id)&&AMAHARA.U.rects({x:p.x-p.w/2,y:p.y-p.h/2,w:p.w,h:p.h},e.hurtbox())){p.hit.add(e.id);AMAHARA.Combat.damage(this,e,p.damage,this.player,80,'proj');p.life=0}if(this.boss&&!this.boss.dead&&AMAHARA.U.rects({x:p.x-p.w/2,y:p.y-p.h/2,w:p.w,h:p.h},this.boss.hurtbox())){AMAHARA.Combat.damage(this,this.boss,p.damage,this.player,35,'proj');p.life=0}}else if((p.type==='arrow'||p.type==='grave')&&!this.player.dead&&AMAHARA.U.rects({x:p.x-p.w/2,y:p.y-p.h/2,w:p.w,h:p.h},this.player.hurtbox())){AMAHARA.Combat.damage(this,this.player,p.damage,p.owner,p.type==='grave'?80:45,'ep');p.life=0}}this.projectiles=this.projectiles.filter(p=>p.life>0&&p.x>0&&p.y>0&&p.x<this.world.w&&p.y<this.world.h)}
  updateFx(dt){for(const p of this.particles){p.life-=dt;p.x+=p.vx*dt;p.y+=p.vy*dt;p.vx*=.96;p.vy*=.96}this.particles=this.particles.filter(p=>p.life>0);for(const r of this.rings){if(r.startLife==null)r.startLife=r.life;r.life-=dt}this.rings=this.rings.filter(r=>r.life>0);this.shake=Math.max(0,this.shake-dt*18)}
  updateCamera(dt){const tx=this.player.x-240,ty=this.player.y-135;this.camera.x=AMAHARA.U.clamp(AMAHARA.U.lerp(this.camera.x,tx,1-Math.pow(.001,dt)),0,this.world.w-480);this.camera.y=AMAHARA.U.clamp(AMAHARA.U.lerp(this.camera.y,ty,1-Math.pow(.001,dt)),0,this.world.h-270)}
  spawnHit(x,y,c){this.spawnBurst(x,y,c,6)} spawnTrail(x,y,c){this.particles.push({x,y:y+4,vx:(Math.random()-.5)*8,vy:(Math.random()-.5)*8,life:.18,max:.18,color:c,size:2})}
  spawnBurst(x,y,c,n=10){for(let i=0;i<n;i++){const a=Math.random()*Math.PI*2,s=25+Math.random()*75;this.particles.push({x,y,vx:Math.cos(a)*s,vy:Math.sin(a)*s,life:.22+Math.random()*.28,max:.5,color:c,size:1+Math.random()*2|0})}}
  toast(t){const el=document.getElementById('toast');el.textContent=t;el.classList.remove('hidden');clearTimeout(this.toastTimer);this.toastTimer=setTimeout(()=>el.classList.add('hidden'),1800)}
  drawNPC(ctx){const n=this.npc;ctx.save();ctx.translate(Math.round(n.x),Math.round(n.y));ctx.fillStyle='#171817';ctx.fillRect(-7,7,14,3);ctx.fillStyle='#536a78';ctx.fillRect(-7,-9,14,16);ctx.fillStyle='#c9a487';ctx.fillRect(-4,-15,8,6);ctx.fillStyle='#36302c';ctx.fillRect(-5,-18,10,4);ctx.fillStyle='#d8c28a';ctx.fillRect(5,-8,2,12);ctx.restore()}
  drawProjectile(ctx,p){ctx.save();ctx.translate(Math.round(p.x),Math.round(p.y));if(p.type==='playerSlash'){ctx.fillStyle='#b8f2ed';ctx.fillRect(-10,-2,20,4);ctx.fillStyle='#f2e7b8';ctx.fillRect(-6,-4,12,2)}else if(p.type==='arrow'){ctx.fillStyle='#c3a16a';ctx.fillRect(-5,-1,10,2)}else{ctx.fillStyle='#8f4778';ctx.fillRect(-4,-4,8,8);ctx.fillStyle='#d27baa';ctx.fillRect(-2,-2,4,4)}ctx.restore()}
  render(){const ctx=this.ctx;ctx.clearRect(0,0,480,270);let sx=this.shake?(Math.random()-.5)*this.shake:0,sy=this.shake?(Math.random()-.5)*this.shake:0;ctx.save();ctx.translate(-Math.floor(this.camera.x)+Math.floor(sx),-Math.floor(this.camera.y)+Math.floor(sy));this.world.drawGround(ctx,this.camera);const drawables=[];for(const p of this.world.visibleProps(this.camera))drawables.push({y:p.y,draw:()=>this.world.drawProp(ctx,p)});drawables.push({y:this.npc.y,draw:()=>this.drawNPC(ctx)});for(const e of this.enemies)drawables.push({y:e.y,draw:()=>e.draw(ctx)});if(this.boss)drawables.push({y:this.boss.y,draw:()=>this.boss.draw(ctx)});drawables.push({y:this.player.y,draw:()=>this.player.draw(ctx)});drawables.sort((a,b)=>a.y-b.y);for(const d of drawables)d.draw();for(const r of this.rings){const k=1-r.life/Math.max(r.life,.0001);ctx.strokeStyle=r.color;ctx.lineWidth=2;ctx.beginPath();const rr=Math.max(1,r.max*(1-r.life/Math.max(.001,r.startLife||r.life)));ctx.arc(r.x,r.y,rr,0,Math.PI*2);ctx.stroke()}for(const p of this.projectiles)this.drawProjectile(ctx,p);for(const p of this.particles){ctx.globalAlpha=Math.max(0,p.life/(p.max||.5));ctx.fillStyle=p.color;ctx.fillRect(Math.round(p.x),Math.round(p.y),p.size,p.size)}ctx.globalAlpha=1;ctx.restore();this.drawHUD(ctx)}
  drawHUD(ctx){if(!this.started)return;const p=this.player;ctx.fillStyle='#101310db';ctx.fillRect(8,8,144,39);ctx.fillStyle='#d6c39a';ctx.font='7px monospace';ctx.fillText('REN KUROGANE',14,17);ctx.fillStyle='#3a1717';ctx.fillRect(14,22,120,7);ctx.fillStyle='#b94b46';ctx.fillRect(14,22,120*(p.hp/p.maxHp),7);ctx.fillStyle='#1f3540';ctx.fillRect(14,33,120,6);ctx.fillStyle='#67c7bf';ctx.fillRect(14,33,120*(p.energy/p.maxEnergy),6);ctx.fillStyle='#d6c39a';ctx.fillText(`${Math.ceil(p.hp)}/${p.maxHp}`,138,28);ctx.fillText(`DIV ${Math.floor(p.energy)}/${p.maxEnergy}`,138,39);ctx.textAlign='center';ctx.fillStyle='#111510dd';ctx.fillRect(160,8,160,18);ctx.fillStyle='#eadcb9';ctx.font='7px monospace';ctx.fillText(this.objective||'',240,19);ctx.textAlign='left';const it=this.world.nearestInteractable(p);if(it&&!this.dialogueActive){ctx.fillStyle='#111510df';ctx.fillRect(176,238,128,20);ctx.fillStyle='#e9d59c';ctx.textAlign='center';ctx.fillText(`F / X — ${it.label}`,240,251);ctx.textAlign='left'}ctx.fillStyle='#111510d9';ctx.fillRect(336,8,136,28);ctx.fillStyle='#eadcb9';ctx.fillText(`Q Corte ${p.magic1Cooldown>0?p.magic1Cooldown.toFixed(1):'OK'}`,342,18);ctx.fillText(`E Selo  ${p.magic2Cooldown>0?p.magic2Cooldown.toFixed(1):'OK'}`,342,29);if(this.boss&&!this.boss.dead){ctx.fillStyle='#0c0d0cdd';ctx.fillRect(82,243,316,19);ctx.fillStyle='#d9c4a0';ctx.textAlign='center';ctx.fillText(`GENERAL JINZŌ — ESTANDARTE OCO · FASE ${this.boss.phase}`,240,250);ctx.fillStyle='#38172a';ctx.fillRect(98,254,284,5);ctx.fillStyle='#a7446b';ctx.fillRect(98,254,284*(this.boss.hp/this.boss.maxHp),5);ctx.textAlign='left'}if(this.debug){ctx.fillStyle='#000c';ctx.fillRect(5,220,150,45);ctx.fillStyle='#9fe594';ctx.fillText(`P ${p.x|0},${p.y|0} ${p.state}`,8,229);ctx.fillText(`Enemies ${this.enemies.filter(e=>!e.dead).length} story ${this.story}`,8,239);ctx.fillText(`Pad ${this.input.anyGamepad?'YES':'NO'}`,8,249)}}
  frame(t){const dt=Math.min(.033,(t-this.last)/1000||.016);this.last=t;this.update(dt);this.render();requestAnimationFrame(x=>this.frame(x))}
  installTestAPI(){window.__GAME_TEST__={state:()=>({started:this.started,paused:this.paused,story:this.story,objective:this.objective,player:{x:this.player.x,y:this.player.y,hp:this.player.hp,energy:this.player.energy,state:this.player.state,maxEnergy:this.player.maxEnergy},enemies:this.enemies.filter(e=>!e.dead).map(e=>({id:e.id,type:e.type,x:e.x,y:e.y,hp:e.hp,state:e.state})),boss:this.boss?{hp:this.boss.hp,phase:this.boss.phase,state:this.boss.state,dead:this.boss.dead}:null,victory:this.bossDefeated}),press:(code)=>{dispatchEvent(new KeyboardEvent('keydown',{code}));dispatchEvent(new KeyboardEvent('keyup',{code}))},teleport:(x,y)=>{this.player.x=x;this.player.y=y},damageBoss:(n)=>{if(this.boss)this.boss.takeDamage(n,this.player,0,'test')},killEnemies:()=>{for(const e of this.enemies.slice())if(!e.dead)e.takeDamage(999,this.player,0,'test')},setDebug:(v)=>this.debug=!!v,interact:()=>this.interact(),start:()=>this.start()}}
};
`````

## Arquivo: `tests/cdp_smoke.js`

`````javascript
const http=require('http');
const cp=require('child_process');
const fs=require('fs');
const path=require('path');
const root=path.resolve(__dirname,'..');
const wait=ms=>new Promise(r=>setTimeout(r,ms));
async function json(url){return new Promise((resolve,reject)=>http.get(url,r=>{let d='';r.on('data',c=>d+=c);r.on('end',()=>{try{resolve(JSON.parse(d))}catch(e){reject(e)}})}).on('error',reject))}
const scripts=['src/data/balance.js','src/utils.js','src/audio.js','src/input.js','src/combat.js','src/world.js','src/entities/player.js','src/entities/enemies.js','src/entities/boss.js','src/game.js'];
async function main(){let chrome=null;try{
 chrome=cp.spawn('chromium',['--headless=new','--disable-gpu','--no-sandbox','--remote-debugging-port=9333','--user-data-dir=/tmp/amahara-chrome-test','about:blank'],{stdio:'ignore'});await wait(1000);
 const tabs=await json('http://127.0.0.1:9333/json');const page=tabs.find(t=>t.type==='page');if(!page)throw Error('No page target');
 const ws=new WebSocket(page.webSocketDebuggerUrl);let seq=0,pending=new Map();ws.onmessage=e=>{const m=JSON.parse(e.data);if(m.id&&pending.has(m.id)){pending.get(m.id)(m);pending.delete(m.id)}else if(m.method==='Runtime.exceptionThrown'){console.error('PAGEEX',JSON.stringify(m.params.exceptionDetails))}};await new Promise(r=>ws.onopen=r);
 const call=(method,params={})=>new Promise(res=>{const id=++seq;pending.set(id,res);ws.send(JSON.stringify({id,method,params}))});
 const evaljs=async exp=>{const r=await call('Runtime.evaluate',{expression:exp,returnByValue:true,awaitPromise:true});if(r.result.exceptionDetails)throw Error(JSON.stringify(r.result.exceptionDetails));return r.result.result.value};
 await call('Runtime.enable');
 const body=`<main id="frame"><canvas id="game" width="480" height="270"></canvas><section id="menu"><button id="playBtn">JOGAR</button><button id="controlsBtn">CONTROLES</button></section><section id="controls" class="hidden"><button data-close="controls">VOLTAR</button></section><section id="pause" class="hidden"><button id="resumeBtn">CONTINUAR</button><button id="pauseControlsBtn">CONTROLES</button><button id="restartBtn">REINICIAR</button><button id="menuBtn">MENU</button></section><section id="dialogue" class="hidden"><div id="speaker"></div><div id="dialogueText"></div></section><section id="victory" class="hidden"><button id="victoryRestartBtn">NOVAMENTE</button><button id="victoryMenuBtn">MENU</button></section><div id="toast" class="hidden"></div></main>`;
 await evaljs(`document.body.innerHTML=${JSON.stringify(body)};`);
 for(const s of scripts){const code=fs.readFileSync(path.join(root,s),'utf8');await evaljs(`eval(${JSON.stringify(code)})`)}
 await evaljs(`window.__GAME__=new AMAHARA.Game(document.getElementById('game')); window.__GAME__.last=performance.now(); requestAnimationFrame(t=>window.__GAME__.frame(t));`);
 const out=[];const test=async(name,fn)=>{try{const v=await fn();out.push([name,v?'PASS':'FAIL']);}catch(e){out.push([name,'FAIL',e.message])}};
 await test('boot',async()=>await evaljs('!!window.__GAME_TEST__'));
 await evaljs('window.__GAME_TEST__.start()');await wait(160);for(let i=0;i<4;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 await test('village wave',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===1&&s.enemies.length===5});
 await evaljs('window.__GAME_TEST__.killEnemies()');await wait(250);await test('village clear',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===2});
 await evaljs('window.__GAME_TEST__.teleport(700,1660); window.__GAME_TEST__.interact()');await wait(100);for(let i=0;i<3;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(80)}
 await test('forest unlocked',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===3});
 await evaljs('window.__GAME_TEST__.teleport(2085,1912); window.__GAME_TEST__.interact()');await wait(100);await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(80);await test('secret upgrade',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.player.maxEnergy===125});
 await evaljs('window.__GAME_TEST__.teleport(2575,760); window.__GAME_TEST__.interact()');await wait(100);for(let i=0;i<2;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(80)}
 await test('checkpoint',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===4});
 await evaljs('window.__GAME_TEST__.teleport(3050,670)');await wait(250);for(let i=0;i<4;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 await test('boss spawn',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return !!s.boss&&s.boss.phase===1});
 await wait(1900); await evaljs('window.__GAME_TEST__.damageBoss(260)');await wait(250);await test('boss phase2',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.boss.phase===2});
 await wait(1900); await evaljs('window.__GAME_TEST__.damageBoss(999)');await wait(1200);for(let i=0;i<4;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 await test('victory flow',async()=>await evaljs("window.__GAME_TEST__.state().victory===true&&!document.getElementById('victory').classList.contains('hidden')"));
 await evaljs('window.__GAME__.returnMenu(); window.__GAME_TEST__.start()');await wait(120);for(let i=0;i<6;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 const p0=await evaljs('window.__GAME_TEST__.state().player.x');await evaljs("dispatchEvent(new KeyboardEvent('keydown',{code:'KeyD'}))");await wait(250);await evaljs("dispatchEvent(new KeyboardEvent('keyup',{code:'KeyD'}))");await wait(80);const p1=await evaljs('window.__GAME_TEST__.state().player.x');out.push(['movement',p1>p0?'PASS':'FAIL']);
 await evaljs("window.__GAME_TEST__.press('KeyJ')");await wait(90);const st=await evaljs('window.__GAME_TEST__.state().player.state');out.push(['light attack state',st==='attack'?'PASS':'FAIL']);
 await wait(500);await evaljs("window.__GAME_TEST__.press('Space')");await wait(60);const ds=await evaljs('window.__GAME_TEST__.state().player.state');out.push(['dash state',ds==='dash'?'PASS':'FAIL']);
 console.log(JSON.stringify(out));ws.close();
}finally{if(chrome)chrome.kill('SIGKILL')}}
main().catch(e=>{console.error(e);process.exitCode=1});
`````

## Arquivo: `tests/logic_suite.js`

`````javascript
const http=require('http'),cp=require('child_process'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..'),wait=ms=>new Promise(r=>setTimeout(r,ms));
function json(url){return new Promise((res,rej)=>{const q=http.get(url,r=>{let d='';r.on('data',c=>d+=c);r.on('end',()=>res(JSON.parse(d)))});q.on('error',rej)})}
const scripts=['src/data/balance.js','src/utils.js','src/audio.js','src/input.js','src/combat.js','src/world.js','src/entities/player.js','src/entities/enemies.js','src/entities/boss.js','src/game.js'];
(async()=>{let chrome;try{chrome=cp.spawn('chromium',['--headless=new','--disable-gpu','--no-sandbox','--remote-debugging-port=9777','--user-data-dir=/tmp/amahara-logic','about:blank'],{stdio:'ignore'});await wait(900);const tabs=await json('http://127.0.0.1:9777/json'),page=tabs.find(t=>t.type==='page'),ws=new WebSocket(page.webSocketDebuggerUrl);let id=0,pending=new Map(),pageErrors=[];ws.onmessage=e=>{const m=JSON.parse(e.data);if(m.id&&pending.has(m.id)){pending.get(m.id)(m);pending.delete(m.id)}else if(m.method==='Runtime.exceptionThrown')pageErrors.push(m.params.exceptionDetails.text)};await new Promise(r=>ws.onopen=r);const call=(method,params={})=>new Promise(r=>{const i=++id;pending.set(i,r);ws.send(JSON.stringify({id:i,method,params}))});const ev=async exp=>{const r=await call('Runtime.evaluate',{expression:exp,returnByValue:true,awaitPromise:true});if(!r.result)throw Error(JSON.stringify(r));if(r.result.exceptionDetails)throw Error(JSON.stringify(r.result.exceptionDetails));return r.result.result.value};await call('Runtime.enable');const body=`<canvas id="game" width="480" height="270"></canvas><section id="menu"><button id="playBtn"></button><button id="controlsBtn"></button></section><section id="controls" class="hidden"><button data-close="controls"></button></section><section id="pause" class="hidden"><button id="resumeBtn"></button><button id="pauseControlsBtn"></button><button id="restartBtn"></button><button id="menuBtn"></button></section><section id="dialogue" class="hidden"><div id="speaker"></div><div id="dialogueText"></div></section><section id="victory" class="hidden"><button id="victoryRestartBtn"></button><button id="victoryMenuBtn"></button></section><div id="toast" class="hidden"></div>`;await ev(`document.body.innerHTML=${JSON.stringify(body)}`);for(const s of scripts)await ev(`eval(${JSON.stringify(fs.readFileSync(path.join(root,s),'utf8'))})`);await ev(`window.__GAME__=new AMAHARA.Game(document.getElementById('game')); true`);
const R={};async function t(id,exp){try{R[id]=(await ev(exp))?'PASS':'FAIL'}catch(e){R[id]='FAIL';R[id+'_error']=e.message}}
const fresh=`(()=>{const g=window.__GAME__;g.resetState();g.started=true;g.paused=false;g.dialogueActive=false;g.cutscene=false;g.input.keys.clear();g.input.pressed.clear();return g})()`;
await t('T02',`(()=>{const g=${fresh};g.input.keys.add('KeyW');g.input.keys.add('KeyD');const m=g.input.move();return Math.abs(Math.hypot(m.x,m.y)-1)<0.001})()`);
await t('T03',`(()=>{const g=${fresh};g.input.keys.add('KeyD');g.player.update(.1,g.input);return g.player.facing==='right'})()`);
await t('T04',`(()=>{const g=${fresh};return g.world.collides(g.player,1512,1000)===true})()`);
await t('T05',`(()=>{const g=${fresh};const x=g.camera.x;g.player.x=1800;g.player.y=1200;g.updateCamera(.2);return g.camera.x!==x})()`);
await t('T06',`(()=>{const g=${fresh},p=g.player,inp={take:()=>false};p.startCombo('light');function advance(){p.bufferedAttack='light';p.bufferTimer=1;p.updateAttack(p.currentAttack.startup+.01,inp);p.updateAttack(p.currentAttack.active+.01,inp);p.updateAttack(p.currentAttack.recovery+.01,inp)}advance();advance();return p.comboIndex===2&&p.currentAttack.name==='Corte Descendente'})()`);
await t('T07',`(()=>{const g=${fresh},p=g.player,inp={take:()=>false};p.startCombo('heavy');function advance(){p.bufferedAttack='heavy';p.bufferTimer=1;p.updateAttack(p.currentAttack.startup+.01,inp);p.updateAttack(p.currentAttack.active+.01,inp);p.updateAttack(p.currentAttack.recovery+.01,inp)}advance();advance();return p.comboIndex===2&&p.currentAttack.name==='Lâmina do Estandarte'})()`);
await t('T08',`(()=>{const g=${fresh},p=g.player,e=g.spawnEnemy('swordsman',p.x+24,p.y);p.facing='right';p.currentAttack=AMAHARA.BALANCE.combos.light[0];p.attackId=1;p.hitTargets.clear();const h=e.hp;p.applyAttackHit();return e.hp<h})()`);
await t('T09',`(()=>{const g=${fresh},p=g.player,e=g.spawnEnemy('swordsman',p.x+24,p.y);p.facing='right';p.currentAttack=AMAHARA.BALANCE.combos.light[0];p.attackId=1;p.hitTargets.clear();p.applyAttackHit();const h=e.hp;p.applyAttackHit();return e.hp===h})()`);
await t('T11',`(()=>{const g=${fresh},p=g.player;p.startDash({x:1,y:0});const cd=p.dashCooldown;p.state='idle';p.startDash({x:1,y:0});return cd>0&&p.state==='idle'})()`);
await t('T12',`(()=>{const g=${fresh},p=g.player;p.startDash({x:1,y:0});const h=p.hp;p.takeDamage(20,{x:p.x-10,y:p.y},50,'x');return p.hp===h})()`);
await t('T13',`(()=>{const g=${fresh},p=g.player,e=p.energy;p.castSlash();return g.projectiles.some(x=>x.type==='playerSlash')&&p.energy===e-AMAHARA.BALANCE.magic.slash.cost})()`);
await t('T14',`(()=>{const g=${fresh},p=g.player,e=g.spawnEnemy('runner',p.x+20,p.y),h=e.hp;p.castSeal();return e.hp<h})()`);
await t('T15',`(()=>{const g=${fresh},p=g.player,e=p.energy;p.castSeal();return p.energy===e-AMAHARA.BALANCE.magic.seal.cost})()`);
await t('T16',`(()=>{const g=${fresh},p=g.player;p.energy=0;p.castSlash();return g.projectiles.length===0&&p.energy===0})()`);
await t('T17',`(()=>{const g=${fresh},p=g.player,h=p.hp;p.takeDamage(10,{x:p.x-20,y:p.y},0,'x');return p.hp===h-10&&p.state==='hurt'})()`);
await t('T18',`(()=>{const g=${fresh},p=g.player;p.hp=1;p.takeDamage(10,{x:p.x-20,y:p.y},0,'x');return p.dead&&p.state==='dead'})()`);
await t('T19',`(()=>{const g=${fresh},p=g.player;g.checkpoint={x:800,y:900};p.hp=0;p.dead=true;g.respawn();return !p.dead&&p.hp===p.maxHp&&p.x===800&&p.y===900})()`);
await t('T29_36',`(()=>{const g=${fresh},types=['swordsman','runner','heavy','archer'];for(const type of types){const e=g.spawnEnemy(type,700,700);if(e.dead||e.hp<=0)return false;g.player.x=750;g.player.y=700;e.state='idle';e.update(.1);if(e.state!=='chase')return false;const x=e.x;e.update(.2);if(type!=='archer'&&e.x===x)return false;const h=e.hp;e.takeDamage(3,g.player,40,'x');if(e.hp>=h||e.state!=='hurt')return false;e.hp=1;e.invuln=0;e.takeDamage(10,g.player,0,'y');if(!e.dead)return false;}g.enemies=g.enemies.filter(e=>!e.dead||e.deathTimer>0);return true})()`);
await t('T37',`(()=>{const g=${fresh};for(let i=0;i<5;i++)g.spawnEnemy('swordsman',550+i*10,1640);return g.enemies.length===5})()`);
await t('T38',`(()=>{const g=${fresh},p=g.player,h=p.hp,src={x:p.x-10,y:p.y};p.takeDamage(10,src,0,'1');p.takeDamage(10,src,0,'2');return p.hp===h-10})()`);
await t('T39',`(()=>{const g=${fresh};g.player.x=600;g.player.y=600;for(let i=0;i<5;i++){const e=g.spawnEnemy('swordsman',610+i*3,600);e.state='chase'}for(const e of g.enemies)e.update(.05);return g.enemies.filter(e=>['telegraph','attack'].includes(e.state)).length<=2})()`);
await t('T40',`(()=>{const g=${fresh};g.spawnEnemy('archer',650,600);g.spawnEnemy('swordsman',620,600);for(const e of g.enemies)e.update(.05);return g.enemies.some(e=>e.type==='archer')&&g.enemies.some(e=>e.type==='swordsman')})()`);
await t('T41',`(()=>{const g=${fresh};g.story=2;g.player.x=g.npc.x;g.player.y=g.npc.y;g.interact();return g.dialogueActive})()`);
await t('T42',`(()=>{const g=${fresh};g.openDialogue([['A','1'],['B','2']]);const n=g.dialogueQueue.length;g.nextDialogue();return g.dialogueQueue.length===n-1})()`);
await t('T43',`(()=>{const g=${fresh};g.player.x=2575;g.player.y=760;const it=g.world.nearestInteractable(g.player);return it&&it.id==='checkpoint'})()`);
await t('T44',`(()=>{const g=${fresh};g.player.x=2085;g.player.y=1912;const m=g.player.maxEnergy;g.interact();return g.player.maxEnergy===m+25})()`);
await t('T45',`(()=>{const g=${fresh};g.player.x=2085;g.player.y=1912;g.interact();return g.player.hasSecret===true})()`);
await t('T46',`(()=>{const g=${fresh};g.player.hp=5;g.player.energy=3;g.player.x=2575;g.player.y=760;g.interact();return g.player.hp===g.player.maxHp&&g.player.energy===g.player.maxEnergy})()`);
await t('T47',`(()=>{const g=${fresh};g.player.x=2575;g.player.y=760;g.interact();return g.checkpoint.x===2575&&g.checkpoint.y===820})()`);
await t('T48',`(()=>{const g=${fresh};g.story=4;g.player.x=3050;g.player.y=670;g.triggerBoss();return g.bossTriggered&&!!g.boss})()`);
await t('T49',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();return g.dialogueActive&&g.boss.state==='intro'})()`);
await t('T50',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();return g.boss.phase===1})()`);
await t('T51',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss;b.invuln=0;b.telegraph('combo');b.timer=0;b.update(.01);return b.state==='attack'&&b.attackName==='combo'})()`);
await t('T52',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss,n=g.rings.length;b.telegraph('aoe');return g.rings.length===n+1&&b.state==='telegraph'})()`);
await t('T53',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss;b.invuln=0;b.takeDamage(250,g.player,0,'x');return b.phase===2&&b.state==='transition'})()`);
await t('T54',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss;b.phase=2;b.state='transition';b.timer=.01;b.summoned=false;const n=g.enemies.length;b.update(.02);return g.enemies.length===n+2&&b.summoned})()`);
await t('T55',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss;b.phase=2;b.telegraph('grave');b.timer=0;b.update(.01);return g.projectiles.filter(p=>p.type==='grave').length===8})()`);
await t('T56',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss;b.invuln=0;const h=b.hp;b.takeDamage(20,g.player,0,'x');return b.hp===h-20})()`);
await t('T57',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();const b=g.boss;b.invuln=0;b.hp=10;b.takeDamage(20,g.player,0,'x');return b.dead&&b.hp===0})()`);
await t('T59',`(()=>{const g=window.__GAME__;g.returnMenu();return !document.getElementById('menu').classList.contains('hidden')})()`);
await t('T60',`(()=>{const g=window.__GAME__;g.showPanel('controls');return !document.getElementById('controls').classList.contains('hidden')})()`);
await t('T61',`(()=>{const g=window.__GAME__;g.started=true;g.togglePause(true);return g.paused&&!document.getElementById('pause').classList.contains('hidden')})()`);
await t('T62',`(()=>{const g=${fresh};g.render();return true})()`);
await t('T63',`(()=>{const g=${fresh};const e=g.player.energy;g.player.castSlash();return g.player.energy<e})()`);
await t('T64',`(()=>{const g=${fresh};g.story=4;g.triggerBoss();g.render();return !!g.boss&&g.boss.hp===g.boss.maxHp})()`);
await t('T66',`(()=>{const g=window.__GAME__;return g.ctx.imageSmoothingEnabled===false})()`);
await t('T67',`(()=>{const c=document.getElementById('game');return c.width===480&&c.height===270})()`);
R.PAGE_ERRORS=pageErrors.length?`FAIL:${pageErrors.join('|')}`:'PASS';console.log(JSON.stringify(R,null,2));ws.close();}finally{if(chrome)chrome.kill('SIGKILL')}})().catch(e=>{console.error(e);process.exitCode=1});
`````


---

# APÊNDICE G — MANIFESTO DE ARQUIVOS DO PROJETO

```text
README.md
index.html
run.bat
style.css

docs/FINAL_REPORT.md
docs/RESEARCH.md
docs/TEST_REPORT.md

screenshots/boss.png
screenshots/village.png

src/audio.js
src/combat.js
src/game.js
src/input.js
src/main.js
src/utils.js
src/world.js
src/data/balance.js
src/entities/boss.js
src/entities/enemies.js
src/entities/player.js

tests/cdp_smoke.js
tests/logic_suite.js
```

---

# ENCERRAMENTO

Este arquivo consolida o estado de Amahara em 04/10/2026 e foi pensado para sobreviver à perda de contexto de conversa. O vertical slice continua sendo a implementação executável de referência; este documento funciona como referência narrativa, técnica, histórica e de design.

Ao retomar o projeto, a regra recomendada é comparar qualquer mudança importante com três coisas antes de implementá-la:

1. os pilares do capítulo 1;
2. o comportamento real registrado nas seções técnicas;
3. o status canônico da seção 37.

Assim é possível expandir o jogo sem apagar acidentalmente a identidade que já foi construída.
