#Capítulo 10 : Análise exploratória de dados
#===========================================

#----10.1Introdução----
#----------------------
"
Você agora aprenderá como usar a visualização e a transformação para explorar seus dados de maneira sistemática, uma tarefa que os estatísticos chamam de análise exploratória de dados, ou EDA, abreviadamente. EDA é um ciclo iterativo. Você:
"
  #1º Gera perguntas sobre seus dados.
  #2º Busca respostas visualizando, transformando e modelando seus dados.
  #3º Usa o que aprende para refinar suas perguntas e/ou gerar novas perguntas.

"
EDA não é um processo formal com um conjunto estrito de regras. Mais do que tudo, EDA é um estado de espírito. Durante as fases iniciais da EDA, você deve se sentir livre para investigar todas as ideias que lhe ocorrem. Algumas dessas ideias darão resultados, e algumas serão becos sem saída. À medida que sua exploração continua, você se concentrará em algumas percepções particularmente produtivas que eventualmente irá registrar e comunicar a outros.

EDA é uma parte importante de qualquer análise de dados, mesmo que as principais questões de pesquisa sejam entregues a você de bandeja, porque você sempre precisa investigar a qualidade dos seus dados. A limpeza de dados é apenas uma aplicação de EDA: você faz perguntas sobre se seus dados atendem às suas expectativas ou não. Para fazer a limpeza de dados, você precisará empregar todas as ferramentas de EDA: visualização, transformação e modelagem.
"

#----10.1.1Pré-requisitos----
#----------------------------
"
Agora combinaremos o que você aprendeu sobre dplyr e ggplot2 para fazer perguntas interativas, respondê-las com dados e depois fazer novas perguntas.
"
library(tidyverse)

#----10.2Perguntas----
#---------------------
"
Seu objetivo durante a EDA é desenvolver um entendimento sobre seus dados. A maneira mais fácil de fazer isso é usar perguntas como ferramentas para guiar sua investigação. Quando você faz uma pergunta, ela foca sua atenção em uma parte específica do seu conjunto de dados e ajuda a decidir quais gráficos, modelos ou transformações realizar.

EDA é fundamentalmente um processo criativo. E como a maioria dos processos criativos, a chave para fazer perguntas de qualidade é gerar uma grande quantidade delas. É difícil fazer perguntas reveladoras no início da sua análise porque você não sabe quais insights podem ser obtidos do seu conjunto de dados. Por outro lado, cada nova pergunta que você faz expõe a um novo aspecto dos seus dados e aumenta suas chances de fazer uma descoberta. Você pode rapidamente se aprofundar nas partes mais interessantes dos seus dados e desenvolver um conjunto de perguntas instigantes se seguir cada pergunta com uma nova pergunta baseada no que você encontrar.

Não há uma regra sobre quais perguntas você deve fazer para guiar sua pesquisa. No entanto, dois tipos de perguntas sempre serão úteis para fazer descobertas dentro dos seus dados. Você pode formular essas perguntas de forma mais ou menos assim:
"
  #1º Que tipo de variação ocorre dentro das minhas variáveis?
  #2º Que tipo de covariação ocorre entre as minhas variáveis?

"
De agora em diante examinaremos essas duas perguntas. Explicaremos o que são variação e covariação e mostraremos várias maneiras de responder a cada pergunta.
"

#----10.3Variação----
#--------------------
"
A variação é a tendência dos valores de uma variável mudarem de uma medição para outra. Você pode perceber facilmente a variação na vida real; se você medir qualquer variável contínua duas vezes, obterá resultados diferentes. Isso é verdade mesmo se você medir quantidades que são constantes, como a velocidade da luz. Cada uma de suas medições incluirá uma pequena quantidade de erro que varia de medição para medição. As variáveis também podem variar se você medir em diferentes sujeitos (por exemplo, as cores dos olhos de diferentes pessoas) ou em diferentes momentos (por exemplo, os níveis de energia de um elétron em diferentes momentos). Cada variável tem seu próprio padrão de variação, que pode revelar informações interessantes sobre como ela varia entre medições na mesma observação, bem como entre observações. A melhor maneira de entender esse padrão é visualizar a distribuição dos valores da variável.

Começaremos nossa exploração visualizando a distribuição dos pesos (quilate) de cerca de 54.000 diamantes do conjunto de dados de diamantes. Como o quilate é uma variável numérica, podemos usar um histograma:
"

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

"
Agora que você pode visualizar a variação, o que deve procurar em seus gráficos? E que tipo de perguntas de acompanhamento você deve fazer? Abaixo, reunimos uma lista dos tipos mais úteis de informações que você encontrará em seus gráficos, junto com algumas perguntas de acompanhamento para cada tipo de informação. A chave para fazer boas perguntas de acompanhamento será confiar em sua curiosidade (O que você quer saber mais?) e em seu ceticismo (Como isso pode ser enganoso?).
"
#----10.3.1Valores típicos----
#-----------------------------
"
Tanto em gráficos de barras quanto em histogramas, barras altas mostram os valores comuns de uma variável, e barras mais baixas mostram valores menos comuns. Locais que não têm barras revelam valores que não foram observados em seus dados. Para transformar essas informações em perguntas úteis, procure por qualquer coisa inesperada:
"
  #1º Quais valores são os mais comuns? Por quê?
  #2º Quais valores são raros? Por quê? Isso corresponde às suas expectativas?
  #3º Você pode ver algum padrão incomum? O que pode explicá-los?

"
Vamos dar uma olhada na distribuição de quilates para diamantes menores.
"
smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

"
Este histograma sugere várias perguntas interessantes:
"
  #1º Por que há mais diamantes em quilates inteiros e frações comuns de quilates?
  #2º Por que há mais diamantes ligeiramente à direita de cada pico do que ligeiramente à esquerda de cada pico?

"
Visualizações também podem revelar agrupamentos, que sugerem que existem subgrupos em seus dados. Para entender os subgrupos, pergunte:
"
  #1º Como as observações dentro de cada subgrupo são semelhantes entre si?
  #2º Como as observações em agrupamentos separados são diferentes umas das outras?
  #3º Como você pode explicar ou descrever os agrupamentos?
  #4º Por que a aparência de agrupamentos pode ser enganosa?

"
Algumas dessas perguntas podem ser respondidas com os dados, enquanto algumas exigirão conhecimento especializado sobre os dados. Muitas delas o levarão a explorar uma relação entre variáveis, por exemplo, para ver se os valores de uma variável podem explicar o comportamento de outra variável.
"
#----10.3.2Valores incomuns----
#------------------------------
"
Outliers são observações que são incomuns; pontos de dados que não parecem se encaixar no padrão. Às vezes, outliers são erros de entrada de dados, às vezes são simplesmente valores extremos que aconteceram de ser observados nesta coleta de dados e outras vezes sugerem novas descobertas importantes. Quando você tem muitos dados, às vezes é difícil ver outliers em um histograma. Por exemplo, pegue a distribuição da variável y do conjunto de dados de diamantes. A única evidência de outliers são os limites incomumente amplos no eixo x.
"
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)

"
Há tantas observações nas caixas comuns que as caixas raras são muito curtas, tornando muito difícil vê-las (embora talvez se você olhar intensamente para 0, você poderá notar algo). Para facilitar a visualização dos valores incomuns, precisamos dar zoom nos pequenos valores do eixo y com coord_cartesian():
"
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
"
coord_cartesian() também tem um argumento xlim() para quando você precisa dar zoom no eixo x. O ggplot2 também possui as funções xlim() e ylim() que funcionam de maneira ligeiramente diferente: elas descartam os dados fora dos limites.

Isso nos permite ver que há três valores incomuns: 0, ~30 e ~60. Nós os selecionamos com dplyr:
"
unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |>
  arrange(y)
unusual

"
A variável y mede uma das três dimensões desses diamantes, em mm. Sabemos que diamantes não podem ter largura de 0mm, então esses valores devem estar incorretos. Ao fazer EDA, descobrimos dados ausentes que foram codificados como 0, o que nunca teríamos encontrado simplesmente procurando por NAs. Daqui para frente, podemos escolher recodificar esses valores como NAs para evitar cálculos enganosos. Também podemos suspeitar que medições de 32mm e 59mm são implausíveis: esses diamantes têm mais de uma polegada de comprimento, mas não custam centenas de milhares de dólares!

É uma boa prática repetir sua análise com e sem os outliers. Se eles tiverem um efeito mínimo nos resultados, e você não conseguir descobrir por que estão lá, é razoável omiti-los e seguir em frente. No entanto, se eles tiverem um efeito substancial em seus resultados, você não deve descartá-los sem justificativa. Você precisará descobrir o que os causou (por exemplo, um erro de entrada de dados) e divulgar que os removeu em seu relatório.
"

#----10.4Valores incomuns----
#----------------------------
"
Se você encontrou valores incomuns em seu conjunto de dados e simplesmente quer prosseguir para o resto de sua análise, você tem duas opções.
"
  #1º Descartar toda a linha com os valores estranhos:
diamonds2 <- diamonds |> 
  filter(between(y, 3, 20))

  #Não recomendamos esta opção porque um valor inválido não implica que todos os outros valores para aquela observação também sejam inválidos. Além disso, se você tiver dados de baixa qualidade, ao aplicar essa abordagem a cada variável, você pode descobrir que não tem mais dados restantes!

  #2º Em vez disso, recomendamos substituir os valores incomuns por valores ausentes. A maneira mais fácil de fazer isso é usar mutate() para substituir a variável por uma cópia modificada. Você pode usar a função if_else() para substituir valores incomuns por NA:
diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))

"
Não é óbvio onde você deve plotar valores ausentes, então ggplot2 não os inclui no gráfico, mas avisa que eles foram removidos:
"
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point()
"
Para suprimir esse aviso, defina na.rm = TRUE:
"
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

"
Outras vezes, você quer entender o que torna as observações com valores ausentes diferentes das observações com valores registrados. Por exemplo, em nycflights13::flights, valores ausentes na variável dep_time indicam que o voo foi cancelado. Então, você pode querer comparar os horários de partida programados para voos cancelados e não cancelados. Você pode fazer isso criando uma nova variável, usando is.na() para verificar se dep_time está ausente.
"
nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

"
No entanto, esse gráfico não é ótimo porque há muitos mais voos não cancelados do que cancelados. Na próxima seção, exploraremos algumas técnicas para melhorar essa comparação.
"
#----10.5Covariação----
#----------------------
"
Se a variação descreve o comportamento dentro de uma variável, a covariação descreve o comportamento entre variáveis. Covariação é a tendência de os valores de duas ou mais variáveis variarem juntos de uma maneira relacionada. A melhor maneira de identificar a covariação é visualizar a relação entre duas ou mais variáveis.
"

#----10.5.1Uma variável categórica e uma numérica----
#----------------------------------------------------
"
Por exemplo, vamos explorar como o preço de um diamante varia com sua qualidade (medida pelo corte) usando geom_freqpoly():
"
ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

"
Note que o ggplot2 usa uma escala de cores ordenada para o corte porque ele é definido como uma variável de fator ordenado nos dados. 

A aparência padrão do geom_freqpoly() não é muito útil aqui porque a altura, determinada pela contagem geral, difere tanto entre os cortes, tornando difícil ver as diferenças nas formas de suas distribuições.

Para facilitar a comparação, precisamos trocar o que é exibido no eixo y. Em vez de exibir a contagem, exibiremos a densidade, que é a contagem padronizada de modo que a área sob cada polígono de frequência seja um.
"
ggplot(diamonds, aes(x = price, y = after_stat(density))) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

"
Note que estamos mapeando a densidade para y, mas como a densidade não é uma variável no conjunto de dados de diamantes, precisamos calculá-la primeiro. Usamos a função after_stat() para fazer isso.

Há algo bastante surpreendente neste gráfico - parece que os diamantes de qualidade baixa (a pior qualidade) têm o preço médio mais alto! Mas talvez isso seja porque os polígonos de frequência são um pouco difíceis de interpretar - há muita coisa acontecendo neste gráfico.

Um gráfico visualmente mais simples para explorar essa relação é usar boxplots lado a lado.
"
ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot()

"
Vemos muito menos informações sobre a distribuição, mas os boxplots são muito mais compactos, então podemos compará-los mais facilmente (e caber mais em um gráfico). Ele apoia a descoberta contra-intuitiva de que diamantes de melhor qualidade são tipicamente mais baratos! Nos exercícios, você será desafiado a descobrir por quê.

Corte é um fator ordenado: justo é pior que bom, que é pior que muito bom e assim por diante. Muitas variáveis categóricas não têm uma ordem intrínseca, então você pode querer reordená-las para fazer uma exibição mais informativa. Uma maneira de fazer isso é com fct_reorder(). Por exemplo, pegue a variável classe no conjunto de dados mpg. Você pode estar interessado em saber como a quilometragem em rodovias varia entre as classes:
"
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

"
Para tornar a tendência mais fácil de ver, podemos reordenar a classe com base no valor mediano de hwy:
"
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot()

"
Se você tem nomes de variáveis longos, geom_boxplot() funcionará melhor se você o virar 90°. Você pode fazer isso trocando os mapeamentos estéticos de x e y.
"
ggplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) +
  geom_boxplot()

#----10.5.2Duas variáveis categóricas----
#----------------------------------------
"
Para visualizar a covariação entre variáveis categóricas, você precisará contar o número de observações para cada combinação de níveis dessas variáveis categóricas. Uma maneira de fazer isso é contar com o geom_count() embutido:
"
ggplot(diamonds, aes(x = cut, y = color)) +
  geom_count()

"
O tamanho de cada círculo no gráfico mostra quantas observações ocorreram em cada combinação de valores. A covariação aparecerá como uma forte correlação entre valores específicos de x e valores específicos de y.

Outra abordagem para explorar a relação entre essas variáveis é calcular as contagens com dplyr:
"
diamonds |> 
  count(color, cut)

"
Depois visualize com geom_tile() e a estética de preenchimento:
"
diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

"
Se as variáveis categóricas não forem ordenadas, você pode querer usar o pacote seriation para reordenar simultaneamente as linhas e colunas para revelar mais claramente padrões interessantes. Para gráficos maiores, você pode querer experimentar o pacote heatmaply, que cria gráficos interativos.
"
#----10.5.3Duas variáveis numéricas----
#--------------------------------------
"

Você já viu uma ótima maneira de visualizar a covariação entre duas variáveis numéricas: desenhar um gráfico de dispersão com geom_point(). Você pode ver a covariação como um padrão nos pontos. Por exemplo, você pode ver uma relação positiva entre o tamanho em quilates e o preço de um diamante: diamantes com mais quilates têm um preço mais alto. A relação é exponencial.
"
ggplot(smaller, aes(x = carat, y = price)) +
  geom_point()
"
(Usaremos o conjunto de dados menor para nos concentrar na maioria dos diamantes que são menores que 3 quilates)

Gráficos de dispersão se tornam menos úteis à medida que o tamanho do seu conjunto de dados cresce, porque os pontos começam a se sobrepor e se acumulam em áreas de preto uniforme, tornando difícil julgar diferenças na densidade dos dados no espaço bidimensional, bem como tornando difícil identificar a tendência. Você já viu uma maneira de corrigir o problema: usando a estética alpha para adicionar transparência.
"
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_point(alpha = 1 / 100)
"
Mas usar transparência pode ser desafiador para conjuntos de dados muito grandes. Outra solução é usar bin. Anteriormente, você usou geom_histogram() e geom_freqpoly() para binar em uma dimensão. Agora, você aprenderá a usar geom_bin2d() e geom_hex() para binar em duas dimensões.

geom_bin2d() e geom_hex() dividem o plano de coordenadas em bins 2d e, em seguida, usam uma cor de preenchimento para mostrar quantos pontos caem em cada bin. geom_bin2d() cria bins retangulares. geom_hex() cria bins hexagonais. Você precisará instalar o pacote hexbin para usar geom_hex().
"
ggplot(smaller, aes(x = carat, y = price)) +
  geom_bin2d()

# install.packages("hexbin")
ggplot(smaller, aes(x = carat, y = price)) +
  geom_hex()

"
Outra opção é binar uma variável contínua para que ela atue como uma variável categórica. Então, você pode usar uma das técnicas para visualizar a combinação de uma variável categórica e uma contínua que aprendeu. Por exemplo, você poderia binar quilates e então, para cada grupo, exibir um boxplot:
"
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))
"
cut_width(x, width), como usado acima, divide x em bins de largura width. Por padrão, os boxplots parecem aproximadamente iguais (exceto pelo número de outliers), independentemente de quantas observações existam, então é difícil dizer que cada boxplot resume um número diferente de pontos. Uma maneira de mostrar isso é fazer a largura do boxplot proporcional ao número de pontos com varwidth = TRUE.
"
#----10.6Padrões e modelos----
#-----------------------------
"
Se um relacionamento sistemático existe entre duas variáveis, ele aparecerá como um padrão nos dados. Se você identificar um padrão, pergunte a si mesmo:
"
  #1º Esse padrão poderia ser devido ao acaso (ou seja, chance aleatória)?
  #2º Como você pode descrever o relacionamento implícito pelo padrão?
  #3º Quão forte é o relacionamento implícito pelo padrão?
  #4º Quais outras variáveis podem afetar o relacionamento?
  #5º O relacionamento muda se você olhar para subgrupos individuais dos dados?
"
Padrões em seus dados fornecem pistas sobre relacionamentos, ou seja, revelam covariação. Se você pensar na variação como um fenômeno que cria incerteza, a covariação é um fenômeno que a reduz. Se duas variáveis covariam, você pode usar os valores de uma variável para fazer melhores previsões sobre os valores da segunda. Se a covariação for devido a um relacionamento causal (um caso especial), então você pode usar o valor de uma variável para controlar o valor da segunda.

Modelos são uma ferramenta para extrair padrões dos dados. Por exemplo, considere os dados dos diamantes. É difícil entender o relacionamento entre corte e preço, porque corte e quilate, e quilate e preço estão fortemente relacionados. É possível usar um modelo para remover o relacionamento muito forte entre preço e quilate para que possamos explorar as sutilezas que restam. O código a seguir ajusta um modelo que prevê o preço a partir do quilate e depois calcula os resíduos (a diferença entre o valor previsto e o valor real). Os resíduos nos dão uma visão do preço do diamante, uma vez que o efeito do quilate foi removido. Note que, em vez de usar os valores brutos de preço e quilate, primeiro os transformamos em log e ajustamos um modelo aos valores transformados em log. Depois, exponenciamos os resíduos para colocá-los de volta na escala de preços brutos.
"
library(tidymodels)

diamonds <- diamonds |>
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

diamonds_fit <- linear_reg() |>
  fit(log_price ~ log_carat, data = diamonds)

diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |>
  mutate(.resid = exp(.resid))

ggplot(diamonds_aug, aes(x = carat, y = .resid)) + 
  geom_point()

"
Depois de remover o relacionamento forte entre quilate e preço, você pode ver o que espera na relação entre corte e preço: em relação ao seu tamanho, diamantes de melhor qualidade são mais caros.
"
ggplot(diamonds_aug, aes(x = cut, y = .resid)) + 
  geom_boxplot()

"
Não estamos discutindo modelagem neste livro porque entender o que são modelos e como eles funcionam é mais fácil uma vez que você tenha as ferramentas de manipulação de dados e programação em mãos.
"