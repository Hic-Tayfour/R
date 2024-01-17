# Capítulo 1: Visualização de dados----
#----1.1. Introdução----
" 
O R possui diversos sistemas de construção de gráficos, mas o ggplot2 é um dos mais elegantes e versáteis. O ggplot implementa a conhecida gramática dos gráficos, um sistema coerente para descrever e construir gráficos.

Com o ggplot2, você pode fazer mais e mais rápido, ao aprender um sistema e aplicá-lo em muitos lugares.

Este capítulo irá lhe ensinar como visualizar seus dados usando ggplot2. Nós vamos começar criando um gráfico de dispersão simples e usá-lo para introduzir o mapeamento de atributos estéticos e geometrias - os blocos fundamentais na construção do ggplot2.

Nós vamos então orientar você na visualização de distribuições de variáveis individuais, bem como na visualização de relações entre duas ou mais variáveis.

Terminaremos salvando seus gráficos e com dicas de resolução de problemas.
"
#----1.1.1. Pré-Requisitos----
"
Este capítulo tem foco no ggplot2, um dos principais pacotes do tidyverse. Para acessar os bancos de dados, páginas de ajuda e funções utilizadas neste capítulo, você deve carregar o tidyverse executando o comando:
"

library(tidyverse)

"
Essa única linha de código carrega os pacotes essenciais do tidyverse, que você irá utilizar em quase toda análise de dados. Ele também te diz quais as funções do tidyverse possuem conflitos com funções do R base (ou de outro pacote que você tenha carregado).

Se você rodar este código e receber a mensagem de erro 'there is no package called 'tidyverse'', você precisa instalar o pacote antes, usando a função install.packages() ou a interface de instalação do RStudio, e então rodar library() novamente.

Você só precisa instalar um pacote uma vez, mas precisa carregá-lo sempre que iniciar uma nova sessão.

Além do tidyverse, nós também usaremos o pacote dados, que inclui várias bases de dados, incluindo uma com medidas corporais de pinguins de três ilhas do arquipélago Palmer, junto do pacote ggthemes, que fornece uma paleta de cores segura para pessoas com daltonismo.
"
library(palmerpenguins)
library(ggthemes)

#----1.2 Primeiros Passos----
"
Os pinguins com nadadeiras mais compridas pesam mais ou menos que pinguins com nadadeiras curtas ?

Você provavelmente játem uma resposta, mas tente torná-la mais precisa. 

Como é relação entre o comprimento da nadadeira e a massa corporal? Ela é positiva? Negativa? Linear? Não linear? A relação varia com a espécie do pinguim? E quanto à ilha onde o pinguim vive?

Vamos criar visualizações que podemos usar para responder essas perguntas.
"

#----1.2.1. O dataframe dos pinguins----
"
Você pode testar suas respostas à essas questões usando o dataframe pinguins, encontrado no pacote dados (usando palmerpenguins::penguins).
"
palmerpenguins::penguins

"
Um data frame é uma coleção tabular (formato tabela) de variáveis (nas colunas) e observações (nas linhas).

Penguins contém 344 observações coletadas e disponibilizadas pela Dra. Kristen Gorman e PELD Estação Palmer

Para facilitar a discussão, vamos definir alguns termos:
  1º Uma variável é uma quantidade, qualidade ou propriedade que você pode medir.
  
  2º Um valor é o estado de uma variável quando você a mede. O valor de uma variável pode mudar de medição para medição
  
  3º Uma observação é conjunto de mediações feitas em condições semelhantes (geralmente todas as medições em uma observação são feitas ao mesmo tempo e no mesmo objeto). Uma observação conterá varios valores, cada um associado a uma variável diferente. Às vezes, vamos nos referir a uma observação como um ponto de dados.
  
  4º Dados Tabulares são um conjunto de valores ,cada um associado a uma variável e uma observação. Os dados tabulares estarão no formato tidy (arrumado) se cada valor estiver em sua própria célula, cada variável em sua própria coluna obeservação em sua própria linha.
  
Neste contexto, uma variável refere-se a um atributo de todos os pinguins, e uma observação refere-se a todos os atributos de um único pinguin

Digite o nome do data frame no console e o R mostrará uma visualização de seu conteúdo, Observe que aparece escrito tibble eno topo desta visualização. No tidyverse, usamos data frames especiais chamados tibbles, dos quais você aprenderá mais em breve.
"
penguins <- palmerpenguins::penguins

"
Este data frame contém 8 colunas. Para visualização alternativa, onde você pode ver todas as variáveis e as primeiras observações de cada variável, use glimpse(). Ou , se você estiver no Rstudio, experimente View(penguins) para abrir um visualizador de dados alternativos.
"
glimpse(penguins)
View(penguins)
"
Entre as variáveis em penguins estão:
  1º Espécie: a espécie do pinguin (Adelie, Chinstrap ou Gentoo)
  
  2º Comprimento da Nadadeira: o comprimento da nadadeira de um pinguim, em milímetros
  
  3º Massa Corporal: a massa corporal de um pinguim, em gramas
  
Para saber mais sobre penguins, abra sua página de ajuda executando ?penguins.
"
?penguins

#----1.2.2. Objetivo Final----
"
Nosso objetivo final neste capítulo é recriar a seguinte visualização que exibe a relação entre o comprimento da nadadeira e a massa corporal desses pinguins, levando em consideração a espécie do pinguim.
"

#----1.2.3. Criando um gráfico ggplot----
"
Vamos criar um gráfico passo a passo

No ggplot2, você inicia um gráfico com a função ggplot(), definindo um objeto de gráfico ao qual você adiciona camadas. O primeiro argumento da função ggplot() é o conjunto de dados a ser usados no gráfico e ,portanto, ggplot(data=penguins) cria um gráfico vazio que está preparadi para exibir os dados de penguins, mas, como ainda não dissemos como fazer a vizualização, por enquanto ele está vazio. Esse não é um gráfico muito interessante, mas você pode pensar nele como uma tela vazia na qual você pintará as camadas restantes do seu gráfico.
"
ggplot(data=penguins)
"
Em seguida =, precisamo informar ao ggplot() como as informações dos nossos dados serão representados visualmente. O argumento mapping (mapeamento) da função ggplot() define como as variáveis em seu conjunto de dados são mapeadas para as propriedades visuais (estética) do gráfico. O gráfico argumento mapping é sempre definido na função aes(), e os argumentos x e y da aes(), especificam quais as variáveis devem ser mapeadas nos eixos x e y. Por enquanto, mapearemos apenas o comprimento da nadadeira para o atributo estético x e a massa corporam para o atributo y. O ggplot2 pricura as variáveis mapeadas no argumento beta, nesse caso penguins.

O gráfico a seguir mostra o resultado da adição desses mapeamentos 
"
ggplot(
  data=penguins,
  mapping=aes(x=flipper_length_mm, y=body_mass_g)
)

"
Nossa tela vazia agora está mais estruturada: está claro onde os comprimentos das nadeiras serão exibidos (no eixo x) e onde as massas corporais serão exibidas (no eixo y). Mas os penguins em si não estão no gráfico. Isso ocorre porque ainda não definimos, em nosso código, como representar as observações de nosso data frame em nosso gráfico.

Para isso precisamos definir um geom: A geometria que um gráfico usa para represnatar os dados. Essas são disponibilizadas no ggplot2 com funções que começam com geom_. As pessoas geralmente descrevem  os gráficos pelo tpo de geom que o gráfico usa.Por exemplo, os gráficos de barra (geom_bar()), os gráficos de linhas usam geometrias de linha (geom_line()), os boxplots usam geometria usam geometria de boxplot(geom_boxplot()), os gráficos de dispersão usam geometria de pontos (geom_point()) e assim por diante.

A função geom_point() adiciona uma camada de pontos ao seu gráfico de, o que cria gráfico de dispersão. O ggplot2 vem com muitas funções de geometria, cada uma adicionando um tipo diferente de camada a um gráfico.
"
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()

"
Agora temos algo que se parece com o que poderiámos chamar de 'gráfico de dispersão'. Ele ainda não correponde aonde queremos chegar, mas, usando esse gráfico, podemos comecar a responder à pergunta que motivou nossa exploração: 'Como é a relação entre o comprimento da nadadeira e a massa corporal? A relação parece ser positiva (à medida que o comprimento da nadeira aumenta, a massa corporal também aumenta), razoavelmente linear (os pontos estão agrupados em torno de uma linha  em vez de uma curva) e moderadamente forte (não há muita dispersão em torno dessa linha). Os penguins com nadeiras mais longas geralmente são maiores em termos de massa corporal.

Antes de adicionarmos mais camadas a esse gráfico, vamos parar po rum momento e revisar a mensagem de aviso que recebemos: Removed 2 rows containing missing values (`geom_point()`)

Estamos vendo essa mensagem porque há dois pinguins em nosso conjunto de dados com valores faltantes (missing values -NA) de massa corporal e/ou comprimento de nadadeira e o ggplot não tem como representá-los no gráfico sem esses dois valores. Assim com como o R, o ggplot2 adota a filosofia de que os valores faltantes nunca devem desaparecer silenciosamente. Esse tipo de aviso é provavelmente um dos tipos mais comuns de avisos que você verá ao trabalhar com dados reais- os valores faltantes são um problema muito comum e você aprenderá mais sobre eles. Por enquanto vamos suprimir esse aviso para que ele não seja mostrado em cada gráfico que fizermos 
"

#----1.2.4. Adicionando atributos estéticos e camadas----
"
Gráfico de dispersão são uteis para exibira relação entre duas variáveis numéricas, mas é sempre uma boa ideia ter uma postura cética em relação a qualquer relação aparente entre duas variáveis e perguntar se pode haver outras variáveis que expliquem ou mudem a natureza dessa relação aparente.

Por exemplo, a relação entre o comprimento das nadadeiras e a massa corporal difere de acordo com a espécie? Vamos incluir as espécies em nosso gráfico e ver se isso revela alguma ideia adicional sobre a relação aparente entre essa variáveis. Faremos isso representando as espécies com pontos de cores diferentes.

Para conseguir isso, precisamos modificar o atributo estético ou geometria? Se você pensou no 'mapeamento estético', dentro de aes(), você já está pegando o jeito de criar a visualização de dados com o ggplot2! Caso contrário, não se preocupe. Você criará muito mais visualizações com ggplot e terá muito mais oportunidades de verificar sua intuição.
"
ggplot(
  data=penguins,
  mapping=aes(x=flipper_length_mm, y=body_mass_g,color=species)
)+ 
  geom_point()

"
Quando uma variável categórica é mapeada a um atributo estético, o ggplot2 atribui automaticamente um valor único da estética (aqui uma cor única) a cada nível único da variável (cada uma das três espécies), um processo conhecido como dimensionamento. O ggplot2 também adicionará uma legenda que explica quais os valores correspondem a quais níveis 

Agora vamos adicionar mais uma camada: uma curva suave que exibe a relação entre massa corporal e o comprimento das nadadeiras. Antes de prosseguir, reveja o código já feito e pense no que pode ser melhorado no gráfico.

Como é um nova geometria que representa os dados, adicionaremos um nova geometria como uma camada sobre a nossa geometria de pontos: geom_smooth(). E especificaremos que queremos desenhar a linha de melhor ajuste com base e, um modelo linear (Linear Model em inglês) com method='lm'
"
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth(method = "lm")

"
Adicionamos as linhas com sucesso, mas não é este o gráfico que queremos, queremos um gráfico com uma reta apenas para todo o conjunto de dados, ao invês de linhas separadas por espécies de penguin

Quando os mapeamentos estéticos são definidos em ggplot(), no nível global ,eles são passados para cada uma das camadas de geometria (geom) subsequentes do gráfico. Entretanto, cada função geom no ggplot2 também pode receber um argumento mapping, que permite mapeamentos estéticos em nível local que são adicionados àqueles herdados do nível global. Como queremos que as linhas sejam separadas para eles , devemos especificar color=species somente para o geom_point()
"

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")

"
Estamos chegando mais perto do que queremos. Precisamos usar formas diferentes para cada espécie de penguin e melhorar os rótulos.

Nem é uma boa ideia representar informações usando apenas cores em um gráfico, pois as pessoas percebem as cores de forma difrente devido ao daltonismo ou outras diferenças de visão das cores. Portanto, além da cor, também podemos mapear specie para a estética shape (forma)
"
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")

"
Note que também que a legenda foi atualizada automatiamente para refletir as diferentes formas dos pontos

Por fim podemos melhorar os rótulos do nosso gráfico usando a função labs() em uma nova camada. Alguns dos argumentos de labs() podem ser autoexplicativos: title adiciona um título e subtitle adiciona um subtítulo ao gráfico. Outros argumentos correspondem aos mapeamentos estéticos, x é o rótulo do eixo x, y é o rótulo do eixo y e color e shape definem o rótulo da legenda. Além disso, podemos aprimorar a paleta de cores para que seja segura para pessoas com daltonismo com a função scale_color_colorblind() do pacote ggthemes.
"
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Massa Corporal e Comprimento da Nadadeira",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Tamanho da Nadadeira (mm)", y = "Massa Corporal (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()
"
Por fim chegamos que corresponde com nosso objetivo final
"

#----1.3 Chamadas ggplot 2----
"
À medida que passarmos dessas seções introdutórias, faremos a transição para uma expressão mais concisa do código do ggplot2. Até agora, temos sido muito explícitos, o que é útil quase se está aprendendo: 
"
ggplot(
  data=penguins,
  mapping=aes(x= "comprimento da nadadeira (mm)", y="massa corporal (g)")
)+
  geom_point()

"
Normalmente, o primeiro ou dois primeiros argumentos de uma função são tão importantes qur você logo saberá usar eles de cor. Os dois primeiros argumentos de ggplot() são data e mapping; vamos reduzir essa forma de escrita com o tempo

A forma mais concisa dessa gráfico fica
"
ggplot(penguins, aes(x="comprimento da nadadeira (mm)", y="massa corporal (g)"))+
  geom_point()

"
Vamos com o tempo usar o comando pipe ( %>% ), resultando na seguinte forma de criar esse gráfico 
"

penguins %>% 
  ggplot(aes(x="comprimento da nadadeira (mm)", y="massa corporal (g)"))+
  geom_point()
#----1.4 Visualizindo Distribuições----
"
A forma como você visualiza a distribuição de uma variável depende do tipo de variável: categórica ou numérica.
"

#----1.4.1 Uma variável categórica----
"
Uma variável é categórica se puder assumir apenas um valor de um pequeno conjunto de valores. Para examinar a distribuição de um variável categórica, você pode usar um gráfico de barras. A altura das barras exibe quantas observações ocorreram com cada valor de x
"
ggplot(penguins, aes(x = species))+
  geom_bar()

penguins %>% ggplot(aes(x=species))+
  geom_bar()
"
Em gráficos de barras de variáveis categóricas com niveis não ordenados, como a specie de penguin acima, geralmente é prefirível reordenar as barras com base em suas frequências. Para isso, é necessário transformar cada variável em um fator (como o R lida com dados categóricos)e, em seguida, reordenar os níveis desse fator
"
ggplot(penguins, aes(x = fct_infreq(species)))+
  geom_bar()

penguins %>% ggplot(aes(x = fct_infreq(species)))+
  geom_bar()

"Varemos mais a frente sobre fatores e outras funções para lidar com fatores"

#----1.4.2 Uma variável numérica----
"
Uma variável numérica (ou quantitativa)se puder assumir uma ampla gama de valores numéricos e se for possível adicionar, subtrair  ou calcular médias com esses valores. As variáveis numéricas podem ser contínuas ou discretas.

Uma visualização muito comum para distribuição de variáveis contínuas é um histograma
"
ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram(binwidth = 200)

penguins %>% ggplot(aes(x = body_mass_g))+
  geom_histogram(binwidth = 200)

"
Um histograma divide o eixo x em intervalos igualmente espaçados e, em seguida, usa a altura de uma barra para exibir o número de observações que se enquadram em cada intervalo. No gráfico acima, a barra mais alta mostra que 39 observações têm um valor body mass entre 3500-3700 gramas, que são as bordas esquerda e direita da barra.

Você pode definir a largura dos intervalos em um histograma com o argumento binwidth (largura do intervalo), que é medido nas unidades da variável x. Você deve sempre explorar uma variedade de larguras de intervalos ao trabalhar com histogramas, pois diferentes larguras de intervalos podem revelar padrões diferentes.
Nos gráficos abaixo, uma largura de intervalo de 20 é muito estreita, resultanto em muitas barras, o que dificulta a determinação da forma da distribuição.
Da mesma forma, uma largura de 200o é muito alta, resultando em todos os dados sendo agrupados em apenas três barras, o que também dificulta a determinação da distribuição.
Uma largura de intervalo de 200 proporciona um balanço mais adequado.
"
ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram(binwidth = 20)

ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram(binwidth = 2000)

penguins %>% ggplot(aes(x = body_mass_g))+
  geom_histogram(binwidth = 20)

penguins %>% ggplot(aes(x = body_mass_g))+
  geom_histogram(binwidth = 2000)

"
Uma visualização alternativa para distribuições de variáveis numéricas é um gráfico de densidade. Um gráfico de densidade é uma versão suavizada de um hisotgrama e uma alternativa prática, especialmente para dados contínuos provenientes de uma distribuição suavizada subjacente. A forma como a função geom_density() estima a densidade não será tratada, mas é possivel ver mais sobre ela em sua documentação. Ela mostra menos detalhes que um histograma, mas pode facilitar a obtenção rápida da forma como da distribuição, pricipalmente da moda e à assimetria
"
ggplot(penguins, aes(x = body_mass_g))+
  geom_density()

penguins %>% ggplot(aes(x = body_mass_g))+
  geom_density()

#----1.5 Visualizando Relações----
"
Para visualizar uma relação, precisamos ter pelo menos duas variáveis mapeadas para os atributos estéticos de um gráfico. Nas seções a seguir, você aprenderá sobre os gráficos comumente usados para visualizarrelações entre duas ou mais variáveis e as geometrias usados para cria-los 
"

#----1.5.1 Uma variável numérica e uma variável categórica----
"
Para visualizar a relação entre uma variável numérica e uma variável categórica, podemos usar diagramas de caixa (chamados boxplots) lado a lado. Um boxplot é um tipo de abreviação visual para medidas de posição (percentis) que descrevem uma distribuição. Também é útil para identificar possiveis outliers. Cada boxplot consiste em :
  1º Uma caixa que indica o intervalo da metade intermediária dos dados, uma distância conhecida como intervalo interquartíl (IIQ ou IQR), que se estende do 25º percentil até o 75º percentil. No meio da caixa há uma linha que exibe a mediana, ou seja, 50º percentil, da distribuição e se a distribuição é ou não simétrica em relação a mediana ou inclinada para um lado 
  2º Pontos que apresentam observações com valores 1,5 vezes o IIQ/IQR de qualquer borda da caixa. Esses pontos discrepantes são incomuns e, por isso, são plotados individualmente.
  3º Uma linha que se estende de cada extremidade da caixa e vai até o ponto mais distante( sem considerar os valores discrepantes- outliers) na distribuição

Vamos dar uma olhada na distribuição da massa corporal por espécie usando o geom_boxplot():
"
ggplot(penguins , aes(x= species , y = body_mass_g))+
  geom_boxplot()

penguins %>% ggplot(aes(x = species, y = body_mass_g))+
  geom_boxplot()
"
Como alternativa, podemos criar gráficos de densidade com o geom_density():
"
ggplot(penguins , aes(x= body_mass_g , color = species))+
  geom_density(linewidth=0.75)

penguins %>% ggplot(aes(x= body_mass_g , color = species))+
  geom_density(linewidth=0.75)

"
Também personalizamos a espessura das linhas usando o argumento linewidth para que elas se destaquem um pouco mais contra o plano de fundo.

Além disso, podemos mapear species para atributos estéticos color e fill e usar o atributo alpha para adicionar transparência às curvas de densidade preenchidas. Esse atributo assume valores entre 0 (completamente transparente) e 1 (completamente opaco). 
"
ggplot(penguins , aes(x= body_mass_g , color = species, fill=species))+
  geom_density(alpha=0.5)

penguins %>% ggplot(aes(x= body_mass_g , color = species, fill=species))+
  geom_density(alpha=0.5)

"
bserve a terminologia que usamos aqui:
  1º Nós mapeamos variáveis para atributod estéticos se quisermos que o atributo visual representado por esse atributo varie de acordo com os valores dessa variável.
  2º Caso contrário, definimos o valor de um atributo estético.
"

#----1.5.2 Duas variáveis categóricas----
"
Podemos usar o gráfico de barras empilhadas para visualizar a relação entre variáveis categóricas. Por exemplo, os dois gráficos de barras empilhadas a seguir exibem a relação entre ilha e espécie ou, especificamente, visualização da distribuição de espécie em cada ilha.

O primeiro gráfico mostra as frequências da cada espécie de pinguim em cada ilha. O gráfico de frequências mostra há um número igual de Pinguem de Adélia em cada ilha. Mas não temos uma boa noção do equilíbrio percentual em cada ilha
"
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

penguins %>% ggplot(aes(x = island, fill = species)) +
  geom_bar()

"
O segundo gráfico é um gráfico de frequência relativa, criado pela definição de position = 'fill' na geometria, que é mais útil para comparar as distribuições de espécies entre as ilhas, pois não é afetado pelo número desigual de penguins entre as ilhas. Usando esse gráfico, podemos ver que todos os penguins-gentoo vivem na ilha Biscoe e constituem aproximadamente 75% dos penguins dessa ilha, todos os penguins de chinstrap vivem na ilha dream e constituem 50% dos penguins dessa ilha, e os penguins de adelie vivem nas três ilhas e constituem todos os penhuins de torgersen
"

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")

penguins %>% ggplot(aes(x = island, fill = species)) +
  geom_bar(position = "fill")

"
Ao criar esse gráficos de barras, mapeamos a variável que será separadaem barras para o atributo estético x e a variável que mudará as cores dentro das barras estética fill
"

#----1.5.3 Duas variáveis numéricas----
"
Até agora, você aprendeu sobre gráficos de dispersão (criados com geom_point()) e curvas suaves (criadas com geom_smooth()) para visualizar a relação entre duas variáveis numéricas. Um gráfico de dispersão é provavelmente o gráfico mais usado para visualizar a relação entre duas variáveis numéricas
"

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

penguins %>% ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

#----1.5.4 Três ou mais variáveis----
"
Podemos incorporar mais variáveis em um gráfico mapeando-as para atributos estéticos adicionais. Por exemplo, no gráfico de dispersão a seguir, as cores dos pontos (color) representam species e as formas dos pontos (shapes) representam as ilhas. 
"
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

penguins %>% ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

"
No entanto , mapear muitos atributos estéticos a um gráfico com que ele fique desordenado e difícil de entender. Outro maneira, que é particularmente útil para variáveis categóricas, é dividir seu gráfico em facetas (facets), subdivisões ou janelas que exibem um subconjunto dos dados cada uma.

Para separar seu gráfico em facetas por uma única variável, use facet_wrap(). O primeiro argumento de facet_wrap() é uma formula, que você com ~ seguido do nome de uma variável. A variável que você passa para facet_warp() de ser categórica.
"
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

penguins %>% ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

#----1.6 Salvando seus gráficos----
"
Depois de criar um gráfico, talvez você queira tirá-lo do R salvando-o cmo uma imagem que possa ser usada em outro lugar. Esse é o objetivo da função ggsave(), que salvará no computador o gráfico criado mais recentemente:
"
penguins %>% ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)
ggsave(filename = "penguin-plot.png")
#----1.7 Problemas Comuns----
"
Ao começar a executar o código em R, é provável que você encontre problemas. Não se preocupe, isso acontece com todo mundo. Todos nós estamos escrevendo código em R há anos, mas todos os dias ainda escrevemos códigos que não funciona na primeira tentativa!

Comece comparando cuidadosamente o código que está executando com o código do livro. O R é extremamente exigente, e um caractere mal colocado pode fazer toda a diferença. Certifique-se de que cada ( seja combinado com um ) e que cada 'seja combinado com outra '. Às vezes, você executará o código e nada acontecerá. Verifique o lado esquerdo do console: se houver um +, isso significa que o R acha que você não digitou uma expressão completa e está esperando que você a termine. Nesse caso, geralmente é fácil começar do zero novamente pressionando Esc para interromper o processamento do comando atual.

Um problema comum ao criar gráficos ggplot2 é colocar o + no lugar errado: ele deve vir no final da linha, não no início. Em outras palavras, certifique-se de não ter escrito acidentalmente um código como este:
"
ggplot(data = mpg) 
+ geom_point(mapping = aes(x = displ, y = hwy))

"
Se você ainda estiver com dificuldades, tente a ajuda (painel Help). Você pode obter ajuda sobre qualquer função do R executando ?nome_da_função no console ou selecionando o nome da função e pressionando F1 no RStudio. Não se preocupe se a ajuda não parecer muito útil - em vez disso, pule para os exemplos e procure um código que corresponda ao que você está tentando fazer.

Se isso não ajudar, leia atentamente a mensagem de erro. Às vezes, a resposta estará escondida lá! Mas quando você é iniciante no R, mesmo que a resposta esteja na mensagem de erro, talvez você ainda não saiba como entendê-la. Outra ferramenta excelente é o Google: tente pesquisar a mensagem de erro no Google, pois é provável que outra pessoa tenha tido o mesmo problema e tenha obtido ajuda on-line.
"

#----1.8 Resumo----
"
Neste capítulo, você aprendeu os fundamentos da visualização de dados com o ggplot2. Começamos com a ideia básica que sustenta o ggplot2: uma visualização é um mapeamento de variáveis em seus dados para atributos estéticos como posição (position), cor (color), tamanho (size) e forma (shape). Em seguida, você aprendeu a aumentar a complexidade e melhorar a apresentação de seus gráficos camada por camada. Você também aprendeu sobre gráficos comumente usados para visualizar a distribuição de uma única variável, bem como para visualizar relações entre duas ou mais variáveis ao utilizar mapeamentos de atributos estéticos adicionais e/ou dividindo seu gráfico em pequenos gráficos usando facetas.
"

# Capítulo 2: Fluxo de Trabalho ;Básico----
"
Você agora tem algumo experiência em executar código em R. Não lhe demos muitos detalhes, mas você obviamente decobriu o básico, ou teria se frustrado e jogado este livro fora. Frustração é natural quando você começa a programar em R porque é muito rigoroso com a pontuação, e mesmo um caractere fora do lugar pode fazer com que ele reclame. Mas, embora você deva esperar um pouco de frustração, tenha em mente que essa experiência é normal e temporária: acontece com todo mundo, e a única maneira de superá-la é continuar tentando.

Antes de irmos mais longe, vamos garantir que você tenha base sólida na execução de cógido em R e que conheça alguns dos recursos maus úteis do RStusio.
"
#----2.1 Princípios básicos da programação ----
"
Vamos revisar alguns conceitos básicos que omitimos até agora, no interesse de fazer você plotar gráfios o mais rápido possível. Você pode usar o R para fazer cálculos matemáticos básicos:
"
1/200*30
(59+73+2)/3
sin(pi/2)

"
Você pode criar novos objetos com o operador de atribuição <- :
"
x <- 3*4
"
Note que o valor de x não é impresso, ele é apenas armazenado. Se você quiser ver o valor , digite x no console"

x
"
Você pode combinar vários elementos em um vetor com c()"

primos <- c(2,3,5,7,11,13)

"
É uma aritimética básica em vetores é aplicada a cada elemneto do vetor:"

primos*2
primos-1

"
Todos os comandos em R onde que você cria objetos, comando de atribuição, têm a mesma forma:"
#nome_objeto <- valor

"
Quando ler esse código, diga 'nome do objeto recebe valor' na sua cabeça.
Você fará muitas atribuições, e <-  não é simples de digitar. Você pode usar um atalho 'alt'+'-'.Observe que o RStudio automaticamente coloca espaços em torno de <-, o que é uma boa prática de formatação de código. Ler código pode ser desafiador até mesmo nos melhores dias, então dê descanso para seus olhos e utilize espaço.
"

#----2.2 Comentários----
"
O R ignora qualquer texto após # em uma linha. Isso permite que você escreva comentários, que são textos que são ignorados pelo R, mas podem ser lidos por outros humanos. Às vezes, incluiremos comentários nos exemplos explicando o que está acontecendo com o código.
Comentários podem ser úteis para descrever brevemente o que o código a seguir faz
"
# Cria um vetor de números primos 
primos <- c(2, 3, 5, 7, 11, 13)

#Multiplica primos por 2
primos * 2

"
Em pequenos trechos de código como este, deixar um comentário para cada linha de código pode não ser necessário. Mas, à medida que o código que você está escrevendo fica mais complexo, os comentários podem economizar muito tempo seu (e das pessoas que colaboram com você) para descobrir o que foi feito no código.

Use comentários para explicar o porquê do seu código, não o como ou o o quê. O o quê e o como do seu código são sempre possíveis de descobrir lendo-os cuidadosamente, mesmo que isso possa ser chato. Se você descrever cada etapa nos comentários e, em seguida alterar o código, terá que se lembrar de atualizar os comentários também, caso contrário, será confuso quando você retornar ao seu código no futuro.

Descobrir por que algo foi feito é muito mais difícil, senão impossível. Por exemplo, geom_smooth() tem um argumento chamado span, que controla a suavidade da curva (smoothness), com valores maiores produzindo uma curva mais suave. Suponha que você decida alterar o valor de span de seu padrão de 0.75 para 0.9: é fácil para alguém que está lendo no futuro entender o que está acontecendo, mas a menos que você anote seu pensamento em um comentário, ninguém entenderá o por que de você ter alterado o padrão.

Para código de análise de dados, use comentários para explicar sua abordagem estratégica e registrar informações importantes à medida que as encontrar. Não há como recuperar esse conhecimento do próprio código sem comentários.
"

#----2.3 A Importância dos Nomes----
"
Nomes de objetos devem começar com uma letra e só podem conter letras, números, _ e . > Você quer que os nomes dos seus objetos sejam descritivos, então você precisará adotar uma convenção para várias palavras. Recomendamos o snake_case, onde você separas minúsculas com _ .
"
# eu_uso_snake_case
# outrasPessoasUsamCamelCase
# algumas.pessoas.usam.pontos
# E_aLgumas.Pessoas_nAoUsamConvecao

"
Você pode ver o conteúdo de um objeto (chamamos isso de insppecionar) digitando o seu nome:
"
x

"
Fazendo outra atribuição :
"
esse_e_um_nome_bem_longo <- 2.5

"Para inspecionar esse objeto, experimente o recurso de autocompleter (autocomplete) do RStudio: digite: esse , precione TAB, adicione carteres até ter um prefixo único e precione enter

Vamos supor que você cometeu um erro e que o valor de esse_e_um_nome_bem_longo deveria ser 3.5, não 2.5. Você pode usar outro atalho de teclado para te ajudar a corrigi-lo. Por exemplo, você pode pressionar ↑ para recuperar o último comando que você digitou e editá-lo. Ou, digite “esse” e pressione Cmd/Ctrl + ↑ para listar todos os comandos que você digitou que começam com essas letras. Use as setas para navegar e, em seguida, pressione enter para digitar novamente o comando. Altere 2.5 para 3.5 e execute novamente.

Fazendo mais uma atribuição:
"
r_rocks <- 2^3

"Vamos tentar inspecioná-lo:"

#r_rock
#> Error: object 'r_rock' not found
#R_rocks
#> Error: object 'R_rocks' not found

"
Isso ilustra o contrato implícito entre você e o R: o R fará os cálculos chatos para você, mas em troca, você deve ser escrever suas instruções de forma precisa. Se não, você provavelmente receberá um erro que diz que o objeto que você está procurando não foi encontrado. Erros de digitação importam; o R não pode ler sua mente e dizer: “ah, você provavelmente quis dizer r_rocks quando digitou r_rock”. A caixa alta (letras maiúsculas) importa; da mesma forma, o R não pode ler sua mente e dizer: “ah, você provavelmente quis dizer r_rocks quando digitou R_rocks”.
"

#----2.4 Chamando Funções----
"
O R tem um agrande coleção de funções embutidas que são chamadas assim:
"
#nome_da_função(argumento1 = valor1, argumneto2 = valor2, argumentoN = ValorN)

"
Vamos tentar usar seq(), que faz sequências regulares de números, e enquanto fazemos nisso, vamos aprender mais sobre os recursos do RStudio. Digite se e pressione TAB. Uma janela pop-up mostra as possíveis formas de completar o código. Especifique seq() digitando mais (um q) para especificar ou usando as setas ↑/↓ para selecionar. Observe a janelinha que aparece, mostrando os argumentos e o objetivo da função. Se você quiser mais ajuda, pressione F1 para obter todos os detalhes no painel ajuda (Help) na parte inferior direita.

Quando você selecionar a função que deseja, pressione TAB novamente. O RStudio adicionará os parênteses de abertura (() e fechamento ()) correspondentes para você automaticamente. Digite o nome do primeiro argumento, from, e defina-o como 1. Em seguida, digite o nome do segundo argumento, to, e defina-o como 10. Por último, pressione enter.
"

seq(from = 1, to = 10)

"
Normalmente omitimos os nomes dos primeiros argumentos em chamadas de função, assim podemos reescrever isso da seguinte forma:
"

seq(1, 10)

"
Digite o código a seguir e veja que o RStudio fornece assistência semelhante com as aspas em pares:
" 
x <- "olá mundo"

"
As aspas e parênteses devem sempre vir em pares. O RStudio faz o melhor para te ajudar, mas ainda é possível cometer um erro e acabar com aspas não fechadas. Se isso acontecer, o console do R mostrará o caractere de continuação “+”:
"  
#> x <- "olá"
#+
"
O + indica que o R está esperando mais alguma entrada (input); ele acha que você ainda não terminou de digitar. Normalmente, isso significa que você esqueceu de adicionar um  ou um ). Adicione o par que está faltando ou pressione ESCAPE (ou ESC) para cancelar a expressão e tentar novamente.

Observe que o painel ambiente (Environment) no painel superior direito exibe todos os objetos que você criou
"



#Capítulo 3 : Transformação de Dados----
#----3.1 Introdução----
"
A visualização é uma ferramenta importante para gerar insights, mas é raro obter os dados da maeneira que você precisa para fazer o gráfico que você precisa. As vezes você irá precisar criar novas variáveis para ou resumos (summaries) para responder às suas perguntas com os seus dados, ou talvez você apenas queira renomear as variáveis ou reordenar as observações para tornar os dados mais faceis de serem trabalhados.
Você vai aprender a fazer tudo isso e muito mais neste capítulo, que irá ensinar a transformação de dados atravês do dplyr e uma base de dados sobre voos que partiram de Nova York em 2013.
O objetivo deste capítulo é apresentar uma visão geral de todas as ferramnetas-chave para a transformação de um data frame.
Vamos começar com funções que operam em linhas e depois em colunas de um data frame, depois voltar a falar mais sobre o comando pipe ( %>% ) , uma ferramenta essencial para concatenar ações.
Vamos introduzir a habilidade de trabalhar com grupos.
Terminaremos esse capítulo com estudo de um caso que mostra a aplicação das fuctions.
"


#----3.1.1 Pré-Requisitos----
"
Vamos nos concentrar no pacote dplyr, constituite do tidyverse. Vamos aplica-lo na base dados nycflights12, e usar o ggplot2 para entender melhor dados
"
library(nycflights13)
library(tidyverse)



#----3.1.2 nycflights13----
"
Para explorar o básico do dplyr, vamos usar o nycflights::flights. Essa base de dados possui um total de 336776 voos que partiram de Nova York em 2013
"
nycflights13::flights

?flights

"
O flights é um tibble, um tipo especial de data frame usado pelo tidyverse para evitar certos problemas. A principal diferenaça entre os data frames e as tibbles é forma que elas são impressas; Elas são projetadas para grandes dados, então elas só mostram as primeiras linhas e apenas as colunas que cabem na tela. Há formas de visualizar mais dados. No RStudio você pode usar o comando View(flights) , para ver as colunas, você pode usar o glimpse(flights)
"
View(flights)
glimpse(flights)

"Há nesse timbble variáveis inteiras (integer;int) , variáveis reais (double;dbl), variáveis texto (string;str) e variáveis de data-time (dttm)"



#----3.1.3 Básico de Dplyr----
"
Vamos começar a aprender as utilidades do dplyr (functions) que permitirão resolver grande parte dos problemas dos desafios de manipulação de dados, mas antes temos que pontuar conceitos essenciais para trabalhar com o comando pipe e a biblioteca dplyr:
  1º O primeiro argumento é sempre um data frame
  2º Os argumentso seguintes serão operações que serão realizadas
  3º O resultado disso será um novo data frame
Veremos mais a frente o funcionamento mais detalhado do comando pipe %>%. Mas trabalhamos ela anteriormente e a seguir haverá um exemplo de sua aplicação de maneira bem intuitiva
"

flights %>% 
  filter(dest== "IAH") %>% 
  group_by(year,month,day) %>% 
  summarise(
    arr_delay=mean(arr_delay, na.rm = TRUE)
  )
"
As funções do dplyr são organizados em quatro grupos com base no que operam : Linhas(row), Colunas(columns), Grupos(groups) e Tabelas(tables). Veremos cada uma delas mais a frente, vendo as functions mais importantes de cada uma e finalizar com as functions de junção para as tabelas
"


#----3.2 Linhas (Row's)----
"
As functions mais importantes que operam em linhas de um conjunto de dadis são: filter(), que muda quais as linhas que estão presentes sem mudar sua ordem, e arrange() que muda a ordem das linhas sem mudar o que estão presentes nelas.
Ambas as funções só afetam as linhas, as colunas permanecem inalteradas. Vamos falar sobre a função distinct() responsável por achar linhas com valores únicos, mas essa pode acabar por interferindo nas colunas 
"
#3.2.1 Filter()
"
Essa função filter() permite manter as linhas com base nos valores das colunas. O primeiro argumento é o data frame, o segundo e os argumentos subsequentes seriam são condições que deve, ser fidedignos para manter a análise.
Por exemplo, quero encontrar todos os voos que partiram a mais de 120 min de atraso:
"
flights %>% 
  filter(dep_delay > 120)
"
Os operadores lógicos ainda se mantém  (maior que), você pode usar (maior ou igual a), (menor que), (menor ou igual a), (igual a) e (não igual a). Você também pode combinar condições com ou para indicar 'e' (verifique ambas as condições) ou com para indicar 'ou' (verifique qualquer condição):> >= < <= == != & , |
"
#Voos que partiram primeiro de janeiro
flights %>% 
  filter(month == 1 & day == 1)

#Voos que partiram em Janeiro ou em Fevereiro
flights %>% 
  filter(month == 1 | month == 2)
"
Ao usar a função de filtro do dplyr, você está gerando o novo data frame a partir do original, podemos salvar esse data frame filtrado em uma variável utilizando do operador de atribuiçao '<-' 
"
um_de_janeiro <- flights %>% 
  filter(month == 1 & day == 1)


#----3.2.2 Erros comuns----
"
Os erros mais comuns nessa parte das funções de filtragem são a sintaxe dos operadores lógicos, de maneira geral, tendem ser esses as causas dos erros.
"


#----3.2.3 Arrange()----
"
A funcção arrange() altera a ordem das linhas tomando de base os valores presentes nas colunas. Para isso é necessário um data frame e um conjunto de colunas nomeadas. Se for fornecido mais de uma coluna, cada coluna adicional será usada para quebrar laços nos valores das colunas anteriores.
Por exemplo, os códigos pela hora de partida, que é espalhado em quatro colunas, temos os anos mais rcentes primeiros depois os meses mais recentes de cada ano.
"
flights %>% 
  arrange(year, month, day, dep_time)

"
Você pode também usar a função desc() em uma coluna para reordenar um data frame tomando de base uma coluna em específico, em ordem decrescente. 
Por exemplo, o seguinte código que que ordena os voos dos mais até os menos atrasados.
"
flights %>% 
  arrange(desc(dep_delay))
"
Perceba que o número de linha é o mesmo, porém os a organização dos dados mudou, mas os dados não estão filtrados.
"


#----3.2.4 Distinc()----
"
A função distinc() é responsável por encontrar todas as linhas com valores únicos no data frame, ,por isso, opera principalmente em linhas. Na maioria das vezes, você pode vir a querer uma combinação diferente de algumas variáveis, então você pode optar por fornecer certas colunas. 
"
#Remova as linhas duplicadas, caso haja
flights %>% 
  distinct()

#Encontre todos os pares de voo com origem e destinos únicos 
flights %>% 
  distinct(origin,dest)

"
Caso quera, você pode manter outras colunas ao filtras linhas únicas, para isso, deve se usar o 
.keep_all=TRUE
"
flights %>% 
  distinct(origin, dest, .keep_all = TRUE )
"
Não é coincidência que todos esses voos distintos estejam no dia 1 de janeiro: distinct() encontrará a primeira ocorrência de uma linha única no conjunto de dados e descartará o 
restante.
Caso queira somente o número de ocorrências, basta trocar o distinct() para count(), e coloque sort=TRUE.
"
flights %>% 
  count(origin, dest, sort = TRUE )


#----3.3 Colunas----
"
Há quatro functions muito importantes que afetam as colunas, poré sem alterar as linhas do data frame. Temos o mutate() ,que adiciona novas colunas que derivam das colunas já existentes.Temos o rename() ,que altera o nome das colunas que já existentes.Temos o relocate() ,que altera a ordem que as colunas aparecem.
"


#----3.3.1 Mutate()----
"
A função do mutate() em si é adicionar novas colunas que são calculadas a partir das colunas existentes. Mais a frente veremos outras funções que podemos usar para manipulação de outras viriáveis.
Por enquanto irá ficar com uma algebra básica, que nos permitirá calcular o gain do avião e sua velocidade média em horas
"
flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    speed=distance/air_time * 60
  )
"
Por padrão, as colunas criadas pelo mutate() são adicionadas no lado direito do data frame, o que dificulta a visualização dependendo do tamanho de dados, Para auxiliar na visualizar essas novas colunas, podemos usar a função before para que essas novas colunas sejam adicionadas no lado esquerdo do data frame
"
flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    speed=distance/air_time * 60 ,
    .before = 1
  )
"O . é um sinal de que o .before é um argumento para a função e não o nome de uma terceira variável que criamos. Temos também o .after para adicionar depois de uma variável, podemos usar os dois simultaenamente. Podemos até indicar onde queremos que essas colunas sejam inseridas. Por exemplo queremos que essas variáveis após a coluna day:"

flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    speed=distance/air_time * 60,
    .after=day
  )
"
Além disso, você pode controlar quais serão as variáveis serão mantidas com o .keep como argumento. Um argumento útil é o 'used' que epecifica que só serão mantidas as colunas usadas no mutate(). 
Por exemplo, o seguinte exemplo manterá o dep_delay, arr_delay, air_time, gain, hours, gain_per_hour
"
flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    hours=air_time/60 ,
    gain_per_hour=gain/hours ,
    .keep = "used"
  )
"
Os calculos feitos nas variáveis acima, nãoserão salvos, serão somente impressas. Caso quisermos salvar esses resultados futuros podemos atribuir esses resultados em uma nova variável ou sobrepor esses resultados na mesma base de dados, Mas tenha cuidado caso salvemos na base de dados original, pois estariámos apagando os dados originais. 
"


#----3.3.2 Select()----
"
Não é incomum termos um conjunto de dados com diversas variáveis. Nestes casos, o principal desafio é focar nas pricipais variáveis que te interessa. Select() perimte que você foque nas variáveis que você acha interssante analizar, dando um 'zoom' nos dados.
Há diversas formas de usar essa função:
"
#1º Selecionando as colunas pelos seus nomes
flights %>% 
  select(year, month, day)

#2º Selecionando da primeira até a ultima coluna do intervalo dado
flights %>% 
  select(year:day)

#3º Não selecionando a primeira coluna até a ultima coluna do intervalo dado
flights %>% 
  select(!year:day)

"
Historicamente, está operação de 'exclusão' de colunas é feito com - em vez do ! , então não estranhe quando você encontrar o - em um select.
"
#4º Selecionando todas as colunas que as variáveis são characters
flights %>% 
  select(where(is.character))

#Bonus:
"
starts_with('abc'): corresponde a nomes que começam com 'abc'.
ends_with('xyz''): corresponde a nomes que terminam com 'xyz'.
contains('ijk'): corresponde a nomes que contêm 'ijk'.
num_range('x'', 1:3): partidas , e .x1 x2 x3
"
"Dúvidas pordem ser sanadas usando a função help. 
Conhecendo o funcionamento básico do select, auxiliará no uso da função matches() para selecionar variáveis que tenham o mesmo padrão
"
"
Podemos ainda usar o select() para renomear as colunas usando o operador = . O Novo nome deve ficar do lado esquerdo, enquanto o nome original deve ficar no lado direito do operador.
"
flights %>% 
  select(tail_num = tailnum)


#----3.3.3 Rename()----
"
Se você quiser manter todas as variáveis existentes e apenas deseja renomear algumas, você pode usar rename() em vez de select():
"
flights %>% 
  rename(tail_num = tailnum)
"
Se você tem um monte de colunas com nomes inconsistentes e seria rediso corrigi-las todas manualmente, confira janitor::clean_names(), que oferece algumas opções úteis de limpeza automática.
"
#----3.3.4 Relocate()----
"
Use relocate() para mover variáveis. Você pode querer agrupar variáveis relacionadas ou mover variáveis importantes para a frente. Por padrão, relocate() move variáveis para a frente:
"
flights %>% 
  relocate(time_hour, air_time)

"
Você também pode especificar onde colocá-las usando os argumentos .before e .after, assim como em mutate():
"

flights %>% 
  relocate(year:dep_time, .after = time_hour)

flights %>% 
  relocate(starts_with("arr") , .before = dep_time)

#----3.4 Pipe (Encademaneto)----
"
Nós mostramos exemplos simples do uso do pipe acima, mas seu verdadeiro poder surge quando você começa a combinar múltiplas ações. Por exemplo, imagine que você queria encontrar os voos mais rápidos para o aeroporto IAH de Houston: você precisa combinar filter(), mutate(), select() e arrange():
"
flights %>% 
  filter(dest == "IAH") %>% 
  mutate(speed = distance / air_time * 60) %>% 
  select(year:day, dep_time, carrier, flight, speed) %>% 
  arrange(desc(speed))

"
Embora este pipeline tenha quatro etapas, é fácil de ler porque as ações aparecem no início de cada linha: comece com os dados de voos, depois filtre, depois altere, depois selecione, depois organize.
O que aconteceria se não tivéssemos o pipe? Poderíamos aninhar cada chamada de função dentro da chamada anterior:
"
arrange(
  select(
    mutate(
      filter(
        flights,
        dest == "IAH"
      ),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)

"
Ou poderíamos usar uma série de objetos intermediários:
"
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance/air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))

"
Embora ambas as formas tenham seu tempo e lugar, o pipe geralmente produz código de análise de dados que é mais fácil de escrever e ler.

Para adicionar o pipe ao seu código, recomendamos usar o atalho de teclado integrado Ctrl/Cmd + Shift + M. Você precisará fazer uma alteração nas opções do seu RStudio para usar |> em vez de %>% como usado nos exemplos anteriores.

Para usar o pipe nativo do R, primeiro certifique de ter o R com a versão 4.1 para cima, se for inferior, terá de atualizar o R e o Rstudio para usar o pipe nativo. Atendo ao requisito de versão, você irá em tools -> Global Options -> Code -> e irá marcar a caixa 'Use native pipe operator |> '
"

#----3.5Grupos----
"
Até agora, você aprendeu sobre funções que trabalham com linhas e colunas. dplyr fica ainda mais poderoso quando você adiciona a capacidade de trabalhar com grupos. Nesta seção, focaremos nas funções mais importantes: group_by(), summarize() e a família de funções slice.
"
#----3.5.1Group_by()----
"
Use group_by() para dividir seu conjunto de dados em grupos significativos para sua análise:
"
flights |> 
  group_by(month)

"
group_by() não altera os dados mas, se você observar atentamente a saída, notará que a saída indica que ela está “agrupada por” mês (Grupos: mês [12]). Isso significa que as operações subsequentes agora funcionarão “por mês”. group_by() adiciona esse recurso agrupado (referido como classe) ao data frame, o que muda o comportamento dos verbos subsequentes aplicados aos dados.
"

#----3.5.2Summarize()----
"
A operação agrupada mais importante é um resumo, que, se usado para calcular uma única estatística resumida, reduz o data frame para ter uma única linha para cada grupo. No dplyr, essa operação é realizada por summarize(), como mostrado no seguinte exemplo, que calcula o atraso médio de partida por mês:
"
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )

"
Algo deu errado e todos os nossos resultados são NAs, o símbolo do R para valor ausente. Isso aconteceu porque alguns dos voos observados tinham dados ausentes na coluna de atraso, e então, quando calculamos a média incluindo esses valores, obtivemos um resultado NA. Por agora diremos à função mean() para ignorar todos os valores ausentes definindo o argumento na.rm para TRUE:
"

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )
"
Você pode criar qualquer número de resumos em uma única chamada para summarize(). Você aprenderá vários resumos úteis nos próximos capítulos, mas um resumo muito útil é n(), que retorna o número de linhas em cada grupo:
"
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

"
Médias e contagens podem levar você por um longo caminho na ciência de dados
"

#----3.5.3As funções de separação/partição----
"
Há cinco funções práticas que permitem extrair linhas específicas dentro de cada grupo:
"

#1º df |> slice_head(n = 1) pega a primeira linha de cada grupo.
#2º df |> slice_tail(n = 1) pega a última linha em cada grupo.
#3º df |> slice_min(x, n = 1) pega a linha com o menor valor da coluna x.
#4º df |> slice_max(x, n = 1) pega a linha com o maior valor da coluna x.
#5º df |> slice_sample(n = 1) pega uma linha aleatória.

"
Você pode variar n para selecionar mais de uma linha, ou, em vez de n =, você pode usar prop = 0.1 para selecionar (por exemplo) 10% das linhas em cada grupo. Por exemplo, o seguinte código encontra os voos que estão mais atrasados ​​na chegada a cada destino:
"
flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n=1) |>
  relocate(dest)
"
Note que existem 105 destinos, mas obtemos 108 linhas aqui. O que está acontecendo? slice_min() e slice_max() mantêm valores empatados, então n = 1 significa que nos dê todas as linhas com o valor mais alto. Se você quiser exatamente uma linha por grupo, você pode definir with_ties = FALSE.

Isso é semelhante a calcular o atraso máximo com summarize(), mas você obtém a linha inteira correspondente (ou linhas, se houver um empate) em vez da única estatística resumida
"

#----3.5.4Agrupando por Multiplas Variáveis----
"
Você pode criar grupos usando mais de uma variável. Por exemplo, poderíamos criar um grupo para cada data.
"
daily <- flights |> 
  group_by(year, month, day)

View(daily)
glimpse(daily)

"
Quando você resume um tibble agrupado por mais de uma variável, cada resumo descarta o último grupo. Em retrospecto, essa não foi uma maneira muito boa de fazer essa função funcionar, mas é difícil mudar sem quebrar o código existente. Para tornar óbvio o que está acontecendo, o dplyr exibe uma mensagem que informa como você pode alterar esse comportamento:
"
daily_flights <- daily |> summarize(n = n())

View(daily_flights)
glimpse(daily_flights)

"
Se você estiver satisfeito com esse comportamento, pode solicitá-lo explicitamente para suprimir a mensagem:
"
daily_flights <- daily |> 
  summarize(
    n = n(),
    .groups = "drop_last"
  )
"
Alternativamente, mude o comportamento padrão definindo um valor diferente, por exemplo, 'drop' para descartar todos os agrupamentos ou 'keep' para preservar os mesmos grupos.
"

#----3.5.5Desagrupando----
"
Você também pode querer remover o agrupamento de um data frame sem usar summarize(). Você pode fazer isso com ungroup()
"
daily |> 
  ungroup()

"
Agora vamos ver o que acontece quando você resume um data frame sem agrupamento.
"

daily |> 
  ungroup() |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  )

"
Você recebe uma única linha de volta porque o dplyr trata todas as linhas em um data frame sem agrupamento como pertencentes a um único grupo.
"
#----3.5.6 .by----
"
O dplyr 1.1.0 inclui uma nova sintaxe experimental para agrupamento por operação, o argumento .by. group_by() e ungroup() não vão desaparecer, mas agora você também pode usar o argumento .by para agrupar dentro de uma única operação:
"
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )
"
Ou se você quiser agrupar por múltiplas variáveis:
"
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin,dest)
  )
"
O dplyr 1.1.0 inclui uma nova sintaxe experimental para agrupamento por operação, o argumento .by. group_by() e ungroup() não vão desaparecer, mas agora você também pode usar o argumento .by para agrupar dentro de uma única operação:
  
  Ou se você quiser agrupar por múltiplas variáveis:
  
  .by funciona com todos os verbos e tem a vantagem de que você não precisa usar o argumento .groups para suprimir a mensagem de agrupamento ou ungroup() quando terminar.

Não focamos nessa sintaxe neste capítulo porque ela era muito nova quando escrevemos o livro. No entanto, queríamos mencioná-la porque achamos que ela tem muito potencial e é provável que seja bastante popular.
"

#----3.6 Estudo de Caso : agregados e tamanho da amostra----
"
Sempre que você faz qualquer agregação, é sempre uma boa ideia incluir uma contagem (n()). Assim, você pode garantir que não está tirando conclusões baseadas em quantidades muito pequenas de dados. Demonstraremos isso com alguns dados de beisebol do pacote Lahman. Especificamente, compararemos qual proporção de vezes um jogador consegue um acerto (H) versus o número de vezes que tentam colocar a bola em jogo (AB):
"
batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
batters

"
Quando plotamos a habilidade do rebatedor (medida pela média de rebatidas, desempenho) contra o número de oportunidades de acertar a bola (medido por vezes no bastão, n), você vê dois padrões:
"

# A variação no desempenho é maior entre os jogadores com menos rebatidas. A forma deste gráfico é muito característica: sempre que você plota uma média (ou outras estatísticas resumidas) vs. tamanho do grupo, você verá que a variação diminui à medida que o tamanho da amostra aumenta4.

# Há uma correlação positiva entre habilidade (desempenho) e oportunidades de acertar a bola (n) porque os times querem dar a seus melhores rebatedores as maiores oportunidades de acertar a bola.

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x= n , y = performance))+
  geom_point(alpha = 1 / 10 )+
  geom_smooth(se = FALSE)
"
Note o padrão útil para combinar ggplot2 e dplyr. Você só precisa lembrar de mudar de |>, para processamento de dados, para + para adicionar camadas ao seu gráfico.

Isso também tem implicações importantes para classificação. Se você ordenar ingenuamente por desc(performance), as pessoas com as melhores médias de rebatidas são claramente as que tentaram colocar a bola em jogo poucas vezes e conseguiram um acerto, mas não são necessariamente os jogadores mais habilidosos:
"
batters |>
  arrange(desc(performance))


#Capítulo 4 : WorkFlow Estílo de Código----
"
Um bom estilo de codificação é como a pontuação correta: você pode se virar sem ela, mas ela certamente torna as coisas mais fáceis de ler. Mesmo sendo um programador muito iniciante, é uma boa ideia trabalhar no seu estilo de código. Usar um estilo consistente facilita para outros (incluindo você no futuro!) lerem seu trabalho e é particularmente importante se você precisar de ajuda de outra pessoa. Este capítulo irá introduzir os pontos mais importantes do guia de estilo tidyverse, que é usado ao longo deste livro.

Estilizar seu código pode parecer um pouco tedioso no início, mas se você praticar, logo se tornará algo natural. Além disso, existem ótimas ferramentas para rapidamente reestilizar código existente, como o pacote styler de Lorenz Walthert. Depois de instalá-lo com install.packages('styler'), uma maneira fácil de usá-lo é através da paleta de comandos do RStudio. A paleta de comandos permite que você use qualquer comando embutido do RStudio e muitos complementos fornecidos por pacotes. Abra a paleta pressionando Cmd/Ctrl + Shift + P, e depois digite 'styler' para ver todos os atalhos oferecidos pelo styler.

Nós usaremos os pacotes tidyverse e nycflights13 para construir os exemplos nesse capítulo
"
library(tidyverse)
library(nycflights13)

#----4,1Nomes----
"
Falamos brevemente sobre nomes anetriormente. Lembre-se de que nomes de variáveis (aqueles criados por <- e aqueles criados por mutate()) devem usar apenas letras minúsculas, números e _. Use _ para separar palavras dentro de um nome.
"
#Procure:
short_flights <- flights |> 
  filter(air_time < 60)

#Evite :
SHORTFLIGHTS <- flights |> 
  filter(air_time < 60)

"
Como regra geral, é melhor preferir nomes longos e descritivos que sejam fáceis de entender do que nomes concisos que são rápidos de digitar. Nomes curtos economizam relativamente pouco tempo ao escrever código (especialmente porque o recurso de preenchimento automático ajuda a terminar de digitá-los), mas pode ser demorado quando você retorna a um código antigo e é forçado a desvendar uma abreviação críptica.

Se você tiver um conjunto de nomes para coisas relacionadas, faça o seu melhor para ser consistente. É fácil para inconsistências surgirem quando você esquece uma convenção anterior, então não se sinta mal se precisar voltar e renomear coisas. Em geral, se você tem um conjunto de variáveis que são uma variação de um tema, você está melhor dando a elas um prefixo comum em vez de um sufixo comum, porque o preenchimento automático funciona melhor no início de uma variável.
"
#----4.2ESpaços----
"
Coloque espaços em ambos os lados dos operadores matemáticos, exceto ^ (ou seja, +, -, ==, <, …), e ao redor do operador de atribuição (<-).
"

#Procure:
"z <- (a + b)^2 /d"

#Evite:
"z<-( a + b )^ 2/d"

"
Não coloque espaços dentro ou fora dos parênteses em chamadas de função regulares. Sempre coloque um espaço após uma vírgula, assim como no inglês padrão.
"
#Procure:
"mean(x, na.rm = TRUE)"

#Evite:
"mean (x ,na.rm=TRUE)"

"
É aceitável adicionar espaços extras se isso melhorar o alinhamento. Por exemplo, se você estiver criando várias variáveis em mutate(), você pode querer adicionar espaços para que todos os = fiquem alinhados.1 Isso torna mais fácil percorrer o código rapidamente.
"
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )

#----4.3Pipes----
"
O operador |> deve sempre ter um espaço antes dele e, normalmente, ser o último elemento em uma linha. Isso facilita a adição de novas etapas, reorganização das etapas existentes, modificação dos elementos dentro de uma etapa e permite uma visão geral rápida ao examinar os verbos no lado esquerdo.
"
#Procure
flights |> 
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)

#Evite
flights|>filter(!is.na(arr_delay), !is.na(tailnum))|>count(dest)

"
Se a função para a qual você está direcionando os dados tem argumentos nomeados (como mutate() ou summarize()), coloque cada argumento em uma nova linha. Se a função não tem argumentos nomeados (como select() ou filter()), mantenha tudo em uma linha, a menos que não caiba, caso em que você deve colocar cada argumento em sua própria linha.
"
#Procure:
flights |>  
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

#Evite:
flights |>
  group_by(
    tailnum
  ) |> 
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())

"
Após o primeiro passo do pipeline, indente cada linha com dois espaços. O RStudio colocará automaticamente os espaços para você após uma quebra de linha seguindo um |> . Se você estiver colocando cada argumento em sua própria linha, indente com mais dois espaços adicionais. Certifique-se de que ) esteja em sua própria linha e sem indentação para corresponder à posição horizontal do nome da função.
"

#Proure: 
flights |>  
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

#Evite:
flights|>
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )

#Evite
flights|>
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )

"
É aceitável ignorar algumas dessas regras se seu pipeline couber facilmente em uma linha. Mas, na nossa experiência coletiva, é comum que trechos curtos acabem se tornando mais longos, então você geralmente economiza tempo a longo prazo começando com todo o espaço vertical necessário.
"
#Isto cabe compactamente em uma linha
"df |> mutate(y = x + 1)"

#Enquanto isto ocupa 4 vezes mais linhas, é facilmente extensível para mais variáveis e mais etapas no futuro
"
df |>
  mutate(
    y = x + 1
  )
"

"
Por fim, tenha cuidado ao escrever pipelines muito longos, digamos, com mais de 10-15 linhas. Tente dividi-los em sub-tarefas menores, dando a cada tarefa um nome informativo. Os nomes ajudarão a orientar o leitor sobre o que está acontecendo e facilitam a verificação de que os resultados intermediários estão conforme o esperado. Sempre que puder dar um nome informativo a algo, você deve fazê-lo, por exemplo, quando mudar fundamentalmente a estrutura dos dados, como após pivoteamento ou resumo. Não espere acertar na primeira tentativa! Isso significa dividir pipelines longos se houver estados intermediários que possam receber bons nomes.
"
#----4.4GGplt2----
"
As mesmas regras básicas que se aplicam ao pipe também se aplicam ao ggplot2; apenas trate + da mesma maneira que |>.
"
flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()
"
Novamente, se você não conseguir colocar todos os argumentos de uma função em uma única linha, coloque cada argumento em sua própria linha:
"
flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE, 
    color = "white", 
    linewidth = 4
  ) +
  geom_point()

"
Fique atento à transição de |> para +. Gostaríamos que essa transição não fosse necessária, mas infelizmente, o ggplot2 foi escrito antes da descoberta do pipe.
"

#----4.5Seções Comentadas----
"
À medida que seus scripts ficam mais longos, você pode usar comentários de seção para dividir seu arquivo em partes gerenciáveis:

#Carregar dados --------------------------------------
#Plotar dados --------------------------------------

Todo esse script, os anteriores e os futuros fazem isso disso 

O RStudio oferece um atalho de teclado para criar esses cabeçalhos (Cmd/Ctrl + Shift + R), e os exibirá no menu de navegação de código, localizado no canto inferior esquerdo do editor.
"

#Capítulo 5 : Organização de Dados----
#----5.1Introdução----
"
Neste capítulo, você aprenderá uma maneira consistente de organizar seus dados no R usando um sistema chamado dados organizados (tidy data). Colocar seus dados neste formato requer algum trabalho inicial, mas esse esforço compensa a longo prazo. Uma vez que você tenha dados organizados e as ferramentas tidy fornecidas pelos pacotes no tidyverse, você gastará muito menos tempo manipulando dados de uma representação para outra, permitindo que você dedique mais tempo às questões de dados que lhe interessam.

Você primeiro aprenderá a definição de dados organizados e verá sua aplicação em um simples conjunto de dados de exemplo. Depois, mergulharemos na principal ferramenta que você usará para organizar dados: o pivoteamento. O pivoteamento permite que você mude a forma dos seus dados sem alterar nenhum dos valores.
"

#----5.1.1Pré-Requisitos----
"
Neste capítulo, focaremos no tidyr, um pacote que fornece várias ferramentas para ajudar a organizar seus conjuntos de dados desordenados. tidyr é um membro do núcleo do tidyverse.

A partir deste capítulo, suprimiremos a mensagem de carregamento do library(tidyverse)
"
library(tidyverse)

#----5.2Organizando os Dados----
"
Você pode representar os mesmos dados subjacentes de várias maneiras. O exemplo abaixo mostra os mesmos dados organizados de três maneiras diferentes. Cada conjunto de dados mostra os mesmos valores de quatro variáveis: país, ano, população e número de casos documentados de TB (tuberculose), mas cada conjunto de dados organiza os valores de uma maneira diferente.São dados já carregados junto da biblioteca tidyverse
"
table1

table2

table3

"
Estas são todas representações dos mesmos dados subjacentes, mas elas não são igualmente fáceis de usar. Uma delas, a table1, será muito mais fácil de trabalhar dentro do tidyverse porque é organizada (tidy).
"

"
Existem três regras inter-relacionadas que tornam um conjunto de dados organizado:
"

#1º Cada variável é uma coluna; cada coluna é uma variável.
#2º Cada observação é uma linha; cada linha é uma observação.
#3º Cada valor é uma célula; cada célula é um único valor.
"
Por que garantir que seus dados estejam organizados? Há duas vantagens principais:

  1º  Há uma vantagem geral em escolher uma maneira consistente de armazenar dados. Se você tem uma estrutura de dados consistente, é mais fácil aprender as ferramentas que funcionam com ela porque elas têm uma uniformidade subjacente.

  2º Há uma vantagem específica em colocar variáveis em colunas porque isso permite que a natureza vetorizada do R brilhe. Como você aprendeu nas Seções 3.3.1 e 3.5.2, a maioria das funções internas do R trabalha com vetores de valores. Isso faz com que a transformação de dados organizados pareça particularmente natural.

O dplyr, ggplot2 e todos os outros pacotes no tidyverse são projetados para trabalhar com dados organizados. Aqui estão alguns pequenos exemplos mostrando como você pode trabalhar com a table1.
"
#Calcular a taxa por 10.000
table1 |> 
  mutate(rate = cases / population * 10000)

#Calcular o total de casos por ano
table1 |> 
  group_by(year) |> 
  summarize(total_cases=sum(cases))

#Visulizando as mudanças ao longo do tempo
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = 'gray50') +
  geom_point(aes(color = country, shape = country)) + 
  scale_x_continuous(breaks = c(1999,2000))

#----5.3Extenção dos Dados----
"
Os princípios de dados organizados podem parecer tão óbvios que você pode se perguntar se algum dia encontrará um conjunto de dados que não seja organizado. Infelizmente, a maioria dos dados reais não é organizada. Há duas razões principais para isso:
"
#1º Os dados são frequentemente organizados para facilitar algum objetivo que não seja a análise. Por exemplo, é comum que os dados sejam estruturados para facilitar a entrada de dados, não a análise.

#2º A maioria das pessoas não está familiarizada com os princípios de dados organizados, e é difícil derivá-los por conta própria, a menos que você passe muito tempo trabalhando com dados.

"
Isso significa que a maioria das análises reais exigirá pelo menos um pouco de organização. Você começará descobrindo quais são as variáveis e observações subjacentes. Às vezes isso é fácil; outras vezes você precisará consultar as pessoas que originalmente geraram os dados. Em seguida, você fará a transformação dos seus dados para uma forma organizada, com variáveis nas colunas e observações nas linhas.

O tidyr fornece duas funções para pivotear dados: pivot_longer() e pivot_wider(). Primeiro, começaremos com pivot_longer(), pois é o caso mais comum. Vamos mergulhar em alguns exemplos.
"

#----5.3.1Dados com Nomes de Colunas----
"
O conjunto de dados do billboard registra a classificação de músicas no ano de 2000:(também é uma base de dados presente na biblioteca tidyverse)
"
billboard

"

Dados em Nomes de Colunas
O conjunto de dados do billboard registra a classificação de músicas no ano de 2000:

Neste conjunto de dados, cada observação é uma música. As primeiras três colunas (artista, faixa e data de entrada) são variáveis que descrevem a música. Em seguida, temos 76 colunas (wk1-wk76) que descrevem a classificação da música em cada semana1. Aqui, os nomes das colunas são uma variável (a semana) e os valores das células são outra (a classificação).

Para organizar esses dados, usaremos pivot_longer():
"
billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )

"
Após os dados, existem três argumentos principais:
"
#1º cols: especifica quais colunas precisam ser pivotadas, ou seja, quais colunas não são variáveis. Este argumento usa a mesma sintaxe que select(), então aqui poderíamos usar !c(artista, faixa, data.entrada) ou starts_with("wk").

#2º names_to: nomeia a variável armazenada nos nomes das colunas; nomeamos essa variável como semana.

#3º values_to: nomeia a variável armazenada nos valores das células; nomeamos essa variável como classificação.

"
Note que nos códigos 'semana' e 'classificação' estão entre aspas porque são novas variáveis que estamos criando; elas ainda não existem nos dados quando executamos a chamada pivot_longer().

Agora vamos nos concentrar no data frame resultante, mais extenso. O que acontece se uma música estiver no top 100 por menos de 76 semanas? Tome como exemplo “Baby Don’t Cry” do 2 Pac. A saída acima sugere que ela estava apenas no top 100 por 7 semanas, e todas as semanas restantes são preenchidas com valores ausentes. Esses NAs não representam realmente observações desconhecidas; eles foram forçados a existir pela estrutura do conjunto de dados2, então podemos pedir ao pivot_longer() para se livrar deles definindo values_drop_na = TRUE:
"
billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )
"
O número de linhas agora é muito menor, indicando que muitas linhas com NAs foram descartadas.

Você também pode se perguntar o que acontece se uma música estiver no top 100 por mais de 76 semanas? Não podemos dizer a partir destes dados, mas você pode adivinhar que colunas adicionais wk77, wk78, ... seriam adicionadas ao conjunto de dados.

Esses dados estão agora organizados, mas podemos facilitar futuros cálculos convertendo os valores da semana de strings para números usando mutate() e readr::parse_number(). parse_number() é uma função útil que extrai o primeiro número de uma string, ignorando todo o texto restante.
"

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

billboard_longer

"
Agora que temos todos os números das semanas em uma variável e todos os valores de classificação em outra, estamos em uma boa posição para visualizar como as classificações das músicas variam ao longo do tempo.Podemos ver que poucas músicas permanecem no top 100 por mais de 20 semanas.
"
billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha=0.25) +
  scale_y_reverse()

#----5.3.2 Como Funciona a Transformação de Dados----
"
Agora que você viu como podemos usar o pivoteamento para remodelar nossos dados, vamos dedicar um tempo para ganhar alguma intuição sobre o que o pivoteamento faz com os dados. Vamos começar com um conjunto de dados muito simples para facilitar a visualização do que está acontecendo. Suponha que temos três pacientes com identificações A, B e C, e realizamos duas medições de pressão arterial em cada paciente. Vamos criar os dados com tribble(), uma função prática para construir pequenos tibbles manualmente:
"
df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
) 

"
Queremos que nosso novo conjunto de dados tenha três variáveis: id (que já existe), measurement (os nomes das colunas) e value (os valores das células). Para alcançar isso, precisamos pivotear df para uma forma mais longa:
"
df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

"
Como funciona o redesenho? É mais fácil de ver se pensarmos nisso coluna por coluna. Os valores em uma coluna que já era uma variável no conjunto de dados original (id) precisam ser repetidos, uma vez para cada coluna que é pivotada.

Os nomes das colunas tornam-se valores em uma nova variável, cujo nome é definido por names_to.Eles precisam ser repetidos uma vez para cada linha no conjunto de dados original.

Os valores das células também se tornam valores em uma nova variável, com um nome definido por values_to. Eles são desenrolados linha por linha.
"

#----5.3.3 Muitas Variáveis em Nomes de Colunas----
"
Uma situação mais desafiadora ocorre quando você tem várias informações compactadas nos nomes das colunas e gostaria de armazená-las em variáveis separadas. Por exemplo, pegue o conjunto de dados who2, a fonte da table1 e amigos que você viu acima:
"
who2

"
Este conjunto de dados, coletado pela Organização Mundial da Saúde, registra informações sobre diagnósticos de tuberculose. Há duas colunas que já são variáveis e são fáceis de interpretar: país e ano. Elas são seguidas por 56 colunas como sp_m_014, ep_m_4554 e rel_m_3544. Se você observar essas colunas por tempo suficiente, notará que há um padrão. Cada nome de coluna é composto por três partes separadas por _. A primeira parte, sp/rel/ep, descreve o método usado para o diagnóstico, a segunda parte, m/f, é o gênero (codificado como uma variável binária neste conjunto de dados) e a terceira parte, 014/1524/2534/3544/4554/5564/65, é a faixa etária (014 representa 0-14, por exemplo).

Portanto, neste caso, temos seis informações registradas no who2: o país e o ano (já colunas); o método de diagnóstico, a categoria de gênero e a categoria de faixa etária (contidas nos outros nomes de colunas); e a contagem de pacientes nessa categoria (valores das células). Para organizar essas seis informações em seis colunas separadas, usamos pivot_longer() com um vetor de nomes de colunas para names_to e instruções para dividir os nomes de variáveis originais em pedaços para names_sep, bem como um nome de coluna para values_to:
"
who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )

"
Uma alternativa ao names_sep é names_pattern, que você pode usar para extrair variáveis de cenários de nomes mais complicados.

Conceitualmente, isso é apenas uma variação menor no caso mais simples que você já viu. Agora, em vez dos nomes das colunas pivotarem em uma única coluna, eles pivotam em várias colunas. Você pode imaginar isso acontecendo em dois passos (primeiro pivotando e depois separando), mas nos bastidores acontece em um único passo porque é mais rápido.
"

#----5.3.4Dados e Nomes de Variáveis nos Cabeçalhos das Colunas----
"
O próximo nível de complexidade ocorre quando os nomes das colunas incluem uma mistura de valores de variáveis e nomes de variáveis. Por exemplo, pegue o conjunto de dados da família:
"
household

"
Este conjunto de dados contém informações sobre cinco famílias, com os nomes e datas de nascimento de até dois filhos. O novo desafio neste conjunto de dados é que os nomes das colunas contêm os nomes de duas variáveis (dob, nome) e os valores de outra (filho, com valores 1 ou 2). Para resolver esse problema, novamente precisamos fornecer um vetor para names_to, mas desta vez usamos o sentinela especial '.value'; isso não é o nome de uma variável, mas um valor único que indica ao pivot_longer() para fazer algo diferente. Isso substitui o argumento usual de values_to para usar o primeiro componente do nome da coluna pivotada como um nome de variável na saída.
"
household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

"
Nós novamente usamos values_drop_na = TRUE, já que a forma da entrada força a criação de variáveis ausentes explícitas (por exemplo, para famílias com apenas um filho).
"

#----5.4Ampliação de Dados----
"
Até agora, usamos pivot_longer() para resolver a classe comum de problemas onde os valores acabaram nos nomes das colunas. Agora, vamos 'pivotar' ,para pivot_wider(), que torna os conjuntos de dados mais amplos, aumentando as colunas e reduzindo as linhas, e ajuda quando uma observação está espalhada por várias linhas. Isso parece ocorrer menos comumente na prática, mas parece surgir bastante ao lidar com dados governamentais.

Vamos começar olhando para cms_patient_experience, um conjunto de dados dos Centros de Serviços de Medicare e Medicaid que coleta dados sobre experiências de pacientes:
"
cms_patient_experience

"
A unidade central em estudo é uma organização, mas cada organização está espalhada por seis linhas, com uma linha para cada medição realizada na organização da pesquisa. Podemos ver o conjunto completo de valores para measure_cd e measure_title usando distinct():
"
cms_patient_experience |> 
  distinct(measure_cd, measure_title)

"
Nenhuma dessas colunas será particularmente ótima como nomes de variáveis: measure_cd não dá uma ideia do significado da variável e measure_title é uma longa frase contendo espaços. Usaremos measure_cd como a fonte para nossos novos nomes de colunas por enquanto, mas em uma análise real, você pode querer criar seus próprios nomes de variáveis que sejam curtos e significativos.

pivot_wider() tem a interface oposta ao pivot_longer(): em vez de escolher novos nomes de colunas, precisamos fornecer as colunas existentes que definem os valores (values_from) e o nome da coluna (names_from):
"
cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )
"A saída não parece exatamente correta; ainda parece que temos várias linhas para cada organização. Isso ocorre porque também precisamos informar ao pivot_wider() qual coluna ou colunas têm valores que identificam exclusivamente cada linha; neste caso, essas são as variáveis que começam com 'org':
"  
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )
"
Isso nos dá a saída que estamos procurando.
"

#----5.4.1Como o pivot_wider() funciona?----
"
Para entender como funciona o pivot_wider(), vamos novamente começar com um conjunto de dados muito simples. Desta vez temos dois pacientes com identificações A e B, e temos três medições de pressão arterial no paciente A e duas no paciente B:
"
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

"
Vamos pegar os valores da coluna value e os nomes da coluna measurement:
"
df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

"
Para iniciar o processo, o pivot_wider() precisa primeiro determinar o que estará nas linhas e colunas. Os novos nomes de colunas serão os valores únicos de measurement.
"
df |> 
  distinct(measurement) |> 
  pull()

"
Por padrão, as linhas na saída são determinadas por todas as variáveis que não estão indo para os novos nomes ou valores. Estas são chamadas de id_cols. Aqui há apenas uma coluna, mas em geral pode haver qualquer número.
"
df |> 
  select(-measurement, -value) |> 
  distinct()

"
O pivot_wider() então combina esses resultados para gerar um data frame vazio:
"
df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

"
Em seguida, ele preenche todos os valores ausentes usando os dados da entrada. Neste caso, nem todas as células na saída têm um valor correspondente na entrada, pois não há uma terceira medição de pressão arterial para o paciente B, então essa célula permanece ausente.

Você também pode se perguntar o que acontece se houver várias linhas na entrada que correspondam a uma célula na saída. O exemplo abaixo tem duas linhas que correspondem ao id “A” e à medição “bp1”:
"
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)
"
Se tentarmos pivotar isso, obtemos uma saída que contém list-columns, sobre as quais você aprenderá mais afrente;
"
df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

"
Como você ainda não sabe trabalhar com esse tipo de dados, você vai querer seguir a dica no aviso para descobrir onde está o problema:
"
df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)

"
Cabe a você descobrir o que deu errado com seus dados e reparar o dano subjacente ou usar suas habilidades de agrupamento e sumarização para garantir que cada combinação de valores de linha e coluna tenha apenas uma única linha.
"

#Capítulo 6 : Fluxo de trabalho: scripts e projetos----

#----6.1 Scripts----
"
Até agora, você usou o console para executar código. Esse é um ótimo lugar para começar, mas você vai perceber que fica apertado rapidamente à medida que cria gráficos mais complexos com ggplot2 e pipelines mais longos com dplyr. Para dar a si mesmo mais espaço para trabalhar, use o editor de script. Abra-o clicando no menu Arquivo, selecionando Novo Arquivo e, em seguida, R script, ou usando o atalho de teclado Cmd/Ctrl+Shift+N.
O editor de script é um ótimo lugar para experimentar com seu código. Quando você quiser alterar algo, não precisa digitar tudo novamente; você pode apenas editar o script e executá-lo novamente. E uma vez que você tenha escrito um código que funciona e faz o que você quer, pode salvar como um arquivo de script para facilmente retornar a ele mais tarde.
"
#----6.1.1Executando código----
"
O editor de script é um excelente lugar para construir gráficos complexos com ggplot2 ou longas sequências de manipulações com dplyr. A chave para usar efetivamente o editor de script é memorizar um dos atalhos de teclado mais importantes: Cmd/Ctrl+Enter. Isso executa a expressão R atual no console. Por exemplo, pegue o seguinte código:
"
library(dplyr)
library(nycflights13)

not_cancelled <- flights |> 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled |> 
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))

"
Se o seu cursor estiver em █, pressionando Cmd/Ctrl+Enter executará o comando completo que gera not_cancelled. Ele também moverá o cursor para a seguinte instrução (começando com not_cancelled |>). Isso facilita o passo a passo pelo seu script completo, pressionando repetidamente Cmd/Ctrl+Enter. 
Em vez de executar seu código expressão por expressão, você pode executar o script completo de uma vez com Cmd/Ctrl+Shift+S. Fazer isso regularmente é uma ótima maneira de garantir que você capturou todas as partes importantes do seu código no script. 
Recomendamos sempre iniciar seu script com os pacotes de que precisa. Dessa forma, se você compartilhar seu código com outros, eles podem facilmente ver quais pacotes precisam instalar. Note, no entanto, que você nunca deve incluir install.packages() em um script que compartilha. É indelicado entregar um script que instalará algo no computador deles se não estiverem atentos!
Ao trabalhar em capítulos futuros, recomendamos fortemente começar no editor de script e praticar seus atalhos de teclado. Com o tempo, enviar código para o console desta maneira se tornará tão natural que você nem pensará nisso.
"

#----6.1.2Diagnósticos do RStudio----
"
No editor de script, o RStudio destacará erros de sintaxe com uma linha ondulada vermelha e um x na barra lateral:
"
#x y <- 10 "Tire esse script do comentário e apague esse texto para ver como fica"

"
Passe o mouse sobre o x para ver qual é o problema.
O RStudio também o informará sobre problemas potenciais.
"

#----6.1.3Salvando e nomeando----
"
O RStudio salva automaticamente o conteúdo do editor de script quando você sai e o recarrega automaticamente quando você reabre. No entanto, é uma boa ideia evitar Untitled1, Untitled2, Untitled3 e assim por diante, e em vez disso, salvar seus scripts com nomes informativos.
Pode ser tentador nomear seus arquivos como code.R ou myscript.R, mas você deve pensar um pouco mais antes de escolher um nome para o seu arquivo. Três princípios importantes para a nomeação de arquivos são os seguintes:
"
#1º Os nomes dos arquivos devem ser legíveis por máquinas: evite espaços, símbolos e caracteres especiais. Não confie na sensibilidade a maiúsculas e minúsculas para distinguir arquivos.
#2º Os nomes dos arquivos devem ser legíveis por humanos: use nomes de arquivos para descrever o que está no arquivo.
#3º Os nomes dos arquivos devem se dar bem com a ordenação padrão: comece os nomes dos arquivos com números para que a ordenação alfabética os coloque na ordem em que são usados.

"
Numerar os scripts-chave torna óbvio em que ordem executá-los, e um esquema de nomeação consistente facilita ver o que varia. Além disso, as figuras são rotuladas de maneira semelhante, os relatórios são distinguidos por datas incluídas nos nomes dos arquivos e temp é renomeado para report-draft-notes para descrever melhor seu conteúdo. Se você tem muitos arquivos em um diretório, organizar ainda mais e colocar diferentes tipos de arquivos (scripts, figuras, etc.) em diretórios diferentes é recomendado.
"


#----6.2Projetos----
"
Um dia, você precisará sair do R, fazer outra coisa e voltar à sua análise mais tarde. Um dia, você estará trabalhando em várias análises simultaneamente e quererá mantê-las separadas. Um dia, você precisará trazer dados do mundo exterior para o R e enviar resultados numéricos e figuras do R de volta para o mundo.
Para lidar com essas situações da vida real, você precisa tomar duas decisões:
    • Qual é a fonte da verdade? O que você salvará como seu registro duradouro do que aconteceu?
    • Onde sua análise vive?
"
#----6.2.1Qual é a fonte da verdade?----
"
Como iniciante, está tudo bem confiar no seu ambiente atual para conter todos os objetos que você criou ao longo de sua análise. No entanto, para facilitar o trabalho em projetos maiores ou colaborar com outros, sua fonte da verdade deve ser os scripts R. Com seus scripts R (e seus arquivos de dados), você pode recriar o ambiente. Com apenas o seu ambiente, é muito mais difícil recriar seus scripts R: ou você terá que digitar muito código de memória (inevitavelmente cometendo erros ao longo do caminho) ou terá que minerar cuidadosamente seu histórico R.

Para ajudar a manter seus scripts R como a fonte da verdade para sua análise, recomendamos veementemente que você instrua o RStudio a não preservar seu espaço de trabalho entre sessões. Você pode fazer isso executando usethis::use_blank_slate() .Isso causará algumas dores de curto prazo, porque agora, quando você reiniciar o RStudio, ele não se lembrará mais do código que você executou da última vez, nem os objetos que você criou ou os conjuntos de dados que você leu estarão disponíveis para usar. Mas essa dor de curto prazo economiza agonia de longo prazo porque força você a capturar todos os procedimentos importantes no seu código. Não há nada pior do que descobrir três meses depois que você armazenou apenas os resultados de um cálculo importante no seu ambiente, não o cálculo em si no seu código.

Existe um ótimo par de atalhos de teclado que funcionarão juntos para garantir que você capturou as partes importantes do seu código no editor:

  - Pressione Cmd/Ctrl + Shift + 0/F10 para reiniciar o R.
  - Pressione Cmd/Ctrl + Shift + S para executar novamente o script atual.

Nós usamos esse padrão coletivamente centenas de vezes por semana.
Alternativamente, se você não usa atalhos de teclado, pode ir a Sessão > Reiniciar R e, em seguida, destacar e executar novamente o script atual.
"
#----6.2.2Onde vive sua análise?----
"
O R tem uma poderosa noção de diretório de trabalho. Este é o lugar onde o R procura por arquivos que você pede para carregar e onde ele colocará quaisquer arquivos que você pedir para salvar. O RStudio mostra seu diretório de trabalho atual no topo do console:
Você pode imprimir isso no código R executando getwd():
"
getwd()

"

Scripts
Até agora, você usou o console para executar código. Esse é um ótimo lugar para começar, mas você vai perceber que fica apertado rapidamente à medida que cria gráficos mais complexos com ggplot2 e pipelines mais longos com dplyr. Para dar a si mesmo mais espaço para trabalhar, use o editor de script. Abra-o clicando no menu Arquivo, selecionando Novo Arquivo e, em seguida, R script, ou usando o atalho de teclado Cmd/Ctrl+Shift+N. Agora você verá quatro painéis, como na Figura 6-1. O editor de script é um ótimo lugar para experimentar com seu código. Quando você quiser alterar algo, não precisa digitar tudo novamente; você pode apenas editar o script e executá-lo novamente. E uma vez que você tenha escrito um código que funciona e faz o que você quer, pode salvar como um arquivo de script para facilmente retornar a ele mais tarde.

Executando Código
O editor de script é um excelente lugar para construir gráficos complexos com ggplot2 ou longas sequências de manipulações com dplyr. A chave para usar efetivamente o editor de script é memorizar um dos atalhos de teclado mais importantes: Cmd/Ctrl+Enter. Isso executa a expressão R atual no console. Por exemplo, pegue o seguinte código:

Se o seu cursor estiver em █, pressionando Cmd/Ctrl+Enter executará o comando completo que gera not_cancelled. Ele também moverá o cursor para a seguinte instrução (começando com not_cancelled |>). Isso facilita o passo a passo pelo seu script completo, pressionando repetidamente Cmd/Ctrl+Enter. Em vez de executar seu código expressão por expressão, você pode executar o script completo de uma vez com Cmd/Ctrl+Shift+S. Fazer isso regularmente é uma ótima maneira de garantir que você capturou todas as partes importantes do seu código no script. Recomendamos sempre iniciar seu script com os pacotes de que precisa. Dessa forma, se você compartilhar seu código com outros, eles podem facilmente ver quais pacotes precisam instalar. Note, no entanto, que você nunca deve incluir install.packages() em um script que compartilha. É indelicado entregar um script que instalará algo no computador deles se não estiverem atentos!

Ao trabalhar em capítulos futuros, recomendamos fortemente começar no editor de script e praticar seus atalhos de teclado. Com o tempo, enviar código para o console desta maneira se tornará tão natural que você nem pensará nisso.

Diagnósticos do RStudio
No editor de script, o RStudio destacará erros de sintaxe com uma linha ondulada vermelha e um x na barra lateral:
Passe o mouse sobre o x para ver qual é o problema:
O RStudio também o informará sobre problemas potenciais:

Salvando e Nomeando
O RStudio salva automaticamente o conteúdo do editor de script quando você sai e o recarrega automaticamente quando você reabre. No entanto, é uma boa ideia evitar Untitled1, Untitled2, Untitled3 e assim por diante, e em vez disso, salvar seus scripts com nomes informativos.
Pode ser tentador nomear seus arquivos como code.R ou myscript.R, mas você deve pensar um pouco mais antes de escolher um nome para o seu arquivo. Três princípios importantes para a nomeação de arquivos são os seguintes:

Os nomes dos arquivos devem ser legíveis por máquinas: evite espaços, símbolos e caracteres especiais. Não confie na sensibilidade a maiúsculas e minúsculas para distinguir arquivos.
Os nomes dos arquivos devem ser legíveis por humanos: use nomes de arquivos para descrever o que está no arquivo.
Os nomes dos arquivos devem se dar bem com a ordenação padrão: comece os nomes dos arquivos com números para que a ordenação alfabética os coloque na ordem em que são usados.
Por exemplo, suponha que você tenha os seguintes arquivos em uma pasta de projeto:
Existem vários problemas aqui: é difícil encontrar qual arquivo executar primeiro, os nomes dos arquivos contêm espaços, há dois arquivos com o mesmo nome, mas com capitalização diferente (finalreport versus FinalReport1), e alguns nomes não descrevem seus conteúdos (run-first e temp).
Aqui está uma maneira melhor de nomear e organizar o mesmo conjunto de arquivos:
Numerar os scripts-chave torna óbvio em que ordem executá-los, e um esquema de nomeação consistente facilita ver o que varia. Além disso, as figuras são rotuladas de maneira semelhante, os relatórios são distinguidos por datas incluídas nos nomes dos arquivos e temp é renomeado para report-draft-notes para descrever melhor seu conteúdo. Se você tem muitos arquivos em um diretório, organizar ainda mais e colocar diferentes tipos de arquivos (scripts, figuras, etc.) em diretórios diferentes é recomendado.
Projetos
Um dia, você precisará sair do R, fazer outra coisa e voltar à sua análise mais tarde. Um dia, você estará trabalhando em várias análises simultaneamente e quererá mantê-las separadas. Um dia, você precisará trazer dados do mundo exterior para o R e enviar resultados numéricos e figuras do R de volta para o mundo.
Para lidar com essas situações da vida real, você precisa tomar duas decisões:
• Qual é a fonte da verdade? O que você salvará como seu registro duradouro do que aconteceu?
• Onde sua análise vive?

Qual É a Fonte da Verdade?
Como iniciante, está tudo bem confiar no seu ambiente atual para conter todos os objetos que você criou ao longo de sua análise. No entanto, para facilitar o trabalho em projetos maiores ou colaborar com outros, sua fonte da verdade deve ser os scripts R. Com seus scripts R (e seus arquivos de dados), você pode recriar o ambiente. Com apenas o seu ambiente, é muito mais difícil recriar seus scripts R: ou você terá que digitar muito código de memória (inevitavelmente cometendo erros ao longo do caminho) ou terá que minerar cuidadosamente seu histórico R.
Para ajudar a manter seus scripts R como a fonte da verdade para sua análise, recomendamos veementemente que você instrua o RStudio a não preservar seu espaço de trabalho entre sessões. Você pode fazer isso executando usethis::use_blank_slate() ou imitando as opções mostradas na Figura 6-2. Isso causará algumas dores de curto prazo, porque agora, quando você reiniciar o RStudio, ele não se lembrará mais do código que você executou da última vez, nem os objetos que você criou ou os conjuntos de dados que você leu estarão disponíveis para usar. Mas essa dor de curto prazo economiza agonia de longo prazo porque força você a capturar todos os procedimentos importantes no seu código. Não há nada pior do que descobrir três meses depois que você armazenou apenas os resultados de um cálculo importante no seu ambiente, não o cálculo em si no seu código.

Onde Sua Análise Vive?
O R tem uma poderosa noção de diretório de trabalho. Este é o lugar onde o R procura por arquivos que você pede para carregar e onde ele colocará quaisquer arquivos que você pedir para salvar. O RStudio mostra seu diretório de trabalho atual no topo do console:
Você pode imprimir isso no código R executando getwd():
Nesta sessão R, o diretório de trabalho atual (pense nisso como 'casa') está na pasta Documentos de Hadley, em uma subpasta chamada r4ds. Este código retornará um resultado diferente quando você o executar, porque o seu computador tem uma estrutura de diretório diferente de Hadley!
Como usuário iniciante do R, está tudo bem deixar seu diretório de trabalho ser seu diretório inicial, diretório de documentos ou qualquer outro diretório estranho no seu computador. Mas você já está no sétimo capítulo deste livro e não é mais um iniciante. Em breve, você deverá evoluir para organizar seus projetos em diretórios e, ao trabalhar em um projeto, definir o diretório de trabalho do R para o diretório associado.
Você pode definir o diretório de trabalho de dentro do R, mas não recomendamos isso:
"
#setwd("/path/to/my/CoolProject")
"
Há uma maneira melhor - uma maneira que também o coloca no caminho para gerenciar seu trabalho R como um especialista. Essa maneira é o projeto RStudio.
"
#----6.2.3Projetos do RStudio----
"
Manter todos os arquivos associados a um determinado projeto (dados de entrada, scripts R, resultados analíticos e figuras) em um diretório é uma prática tão sábia e comum que o RStudio tem suporte embutido para isso por meio de projetos. Vamos criar um projeto para você usar enquanto trabalha no resto deste livro. Selecione Arquivo > Novo Projeto.
Chame seu projeto de r4ds e pense cuidadosamente em qual subdiretório você colocará o projeto. Se você não armazená-lo em algum lugar sensato, será difícil encontrá-lo no futuro!
Uma vez que este processo esteja completo, você terá um novo projeto RStudio apenas para este livro. Verifique se o 'lar' do seu projeto é o diretório de trabalho atual:
"
getwd()
"
Agora digite os seguintes comandos no editor de script e salve o arquivo, chamando-o de diamonds.R. Você pode fazer isso clicando no botão Nova Pasta no painel Arquivos no RStudio. Finalmente, execute o script completo, que salvará um arquivo PNG e CSV em seu diretório de projeto. 
"
library(tidyverse)

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_hex()
ggsave("diamonds.png")

write_csv(diamonds, "diamonds.csv")

"
Saia do RStudio. Inspecione a pasta associada ao seu projeto - observe o arquivo .Rproj. Clique duas vezes nesse arquivo para reabrir o projeto. Observe que você volta aonde parou: é o mesmo diretório de trabalho e histórico de comandos, e todos os arquivos em que você estava trabalhando ainda estão abertos. Porque você seguiu nossas instruções, você terá, no entanto, um ambiente completamente novo, garantindo que você esteja começando com uma tela limpa.
Da maneira específica do seu sistema operacional favorito, pesquise no seu computador por diamonds.png e você encontrará o PNG (sem surpresas) mas também o script que o criou (diamonds.R). Isso é uma grande vitória! Um dia, você vai querer refazer uma figura ou apenas entender de onde ela veio. Se você salvar rigorosamente as figuras em arquivos com código R e nunca com o mouse ou a área de transferência, você poderá reproduzir trabalhos antigos com facilidade!
"
#----6.2.4Caminhos relativos e absolutos----
"
Uma vez que você está dentro de um projeto, você deve usar apenas caminhos relativos, não caminhos absolutos. Qual é a diferença? Um caminho relativo é relativo ao diretório de trabalho, ou seja, a casa do projeto. Quando Hadley escreveu data/diamonds.csv anteriormente, foi um atalho para /Users/hadley/Documents/r4ds/data/diamonds.csv. Mas, importante, se Mine executasse esse código no computador dela, apontaria para /Users/Mine/Documents/r4ds/data/diamonds.csv. É por isso que os caminhos relativos são importantes: eles funcionarão independentemente de onde a pasta do projeto R acabar.
Caminhos absolutos apontam para o mesmo lugar, independentemente do seu diretório de trabalho. Eles parecem um pouco diferentes dependendo do seu sistema operacional. No Windows, eles começam com uma letra de unidade (por exemplo, C:) ou dois backslashes (por exemplo, \servername) e no Mac/Linux eles começam com uma barra, / (por exemplo, /users/hadley). Você nunca deve usar caminhos absolutos em seus scripts, porque eles impedem o compartilhamento: ninguém mais terá exatamente a mesma configuração de diretório que você.
Há outra diferença importante entre os sistemas operacionais: como você separa os componentes do caminho. Mac e Linux usam barras (por exemplo, data/diamonds.csv) e Windows usa backslashes (por exemplo, data\diamonds.csv). R pode trabalhar com qualquer tipo (não importa em qual plataforma você está atualmente), mas infelizmente, backslashes significam algo especial para R, e para obter uma única barra invertida no caminho, você precisa digitar duas barras invertidas! Isso torna a vida frustrante, então recomendamos sempre usar o estilo Linux/Mac com barras para frente.
"


#Capítulo 7 : Importação de Dados----
#----7.1 Introdução----
"
Trabalhar com dados fornecidos por pacotes do R é uma ótima maneira de aprender ferramentas de ciência de dados, mas você vai querer aplicar o que aprendeu aos seus próprios dados em algum momento. Você aprenderá os conceitos básicos de leitura de arquivos de dados no R.

Especificamente, este capítulo se concentrará na leitura de arquivos retangulares de texto simples. Começaremos com conselhos práticos para lidar com características como nomes de colunas, tipos e dados faltantes. Você então aprenderá sobre a leitura de dados de vários arquivos de uma só vez e a escrita de dados do R para um arquivo. Finalmente, você aprenderá como criar data frames manualmente no R.
"
#----7.1.1 Pré-requisitos----
"
Você aprenderá como carregar arquivos planos no R com o pacote readr, que faz parte do núcleo do tidyverse.
"
library(tidyverse)

#----7.2 Lendo dados de um arquivo----
"
Para começar, vamos focar no tipo de arquivo de dados retangulares mais comum: CSV, que é a abreviação de valores separados por vírgula. Aqui está como um arquivo CSV simples se parece. A primeira linha, comumente chamada de linha de cabeçalho, fornece os nomes das colunas, e as seis linhas seguintes fornecem os dados. As colunas são separadas, ou delimitadas, por vírgulas.

Podemos ler este arquivo no R usando read_csv(). O primeiro argumento é o mais importante: o caminho para o arquivo. Você pode pensar no caminho como o endereço do arquivo: o arquivo se chama students.csv e está localizado na pasta de dados.

O código acima funcionará se você tiver o arquivo students.csv em uma pasta de dados no seu projeto. Você pode baixar o arquivo students.csv de https://pos.it/r4ds-students-csv ou pode lê-lo diretamente dessa URL com:
"
students <- read_csv("https://pos.it/r4ds-students-csv")
write_csv(students, "students.csv")
"
Quando você executa read_csv(), ele imprime uma mensagem informando o número de linhas e colunas de dados, o delimitador que foi usado e as especificações das colunas (nomes das colunas organizados pelo tipo de dado que a coluna contém). Ele também imprime algumas informações sobre como obter a especificação completa da coluna e como silenciar essa mensagem.
"

#----7.2.1 Conselhos práticos----
"
Uma vez que você leu os dados, o primeiro passo geralmente envolve transformá-los de alguma forma para facilitar o trabalho com eles no resto da sua análise. Vamos dar outra olhada nos dados dos estudantes com isso em mente.
"
students

"
Na coluna favourite.food, há uma série de itens alimentares e, em seguida, a string de caracteres N/A, que deveria ter sido um verdadeiro NA que o R reconheceria como 'não disponível'. Isso é algo que podemos abordar usando o argumento na. Por padrão, read_csv() só reconhece strings vazias ('') neste conjunto de dados como NAs, mas queremos que ele também reconheça a string de caracteres 'N/A'.
"
students <- read_csv("students.csv", na = c("N/A", ""))
students

"
Você também pode notar que as colunas Student ID e Full Name estão cercadas por crases. Isso acontece porque elas contêm espaços, quebrando as regras usuais do R para nomes de variáveis; são nomes não-sintáticos. Para se referir a essas variáveis, você precisa cercá-las com crases, `:
"
students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

"
Uma abordagem alternativa é usar janitor::clean_names() para usar algumas heurísticas para transformá-los todos em snake case de uma vez.
"
students |> janitor::clean_names()

"
Outra tarefa comum após ler os dados é considerar os tipos de variáveis. Por exemplo, meal_plan é uma variável categórica com um conjunto conhecido de valores possíveis, que no R deve ser representada como um fator:
"
students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

"
Note que os valores na variável meal_plan permaneceram os mesmos, mas o tipo de variável indicado abaixo do nome da variável mudou de caractere (<chr>) para fator (<fct>).

Antes de analisar esses dados, você provavelmente vai querer corrigir as colunas de idade e id. Atualmente, a idade é uma variável de caractere porque uma das observações é digitada como cinco em vez de um número.

Uma nova função aqui é if_else(), que tem três argumentos. O primeiro argumento, test, deve ser um vetor lógico. O resultado conterá o valor do segundo argumento, yes, quando test for TRUE, e o valor do terceiro argumento, no, quando for FALSE. Aqui estamos dizendo que se a idade é a string de caracteres 'five', transforme-a em '5', e se não, deixe-a como idade.
"
students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

students

#----7.2.2 Outros argumentos----
"
Existem alguns outros argumentos importantes que precisamos mencionar, e eles serão mais fáceis de demonstrar se primeiro mostrarmos um truque útil: read_csv() pode ler strings de texto que você criou e formatou como um arquivo CSV:
"
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

"  
Normalmente, read_csv() usa a primeira linha dos dados para os nomes das colunas, o que é uma convenção muito comum. Mas não é incomum que algumas linhas de metadados sejam incluídas no topo do arquivo. Você pode usar skip = n para pular as primeiras n linhas ou usar comment = '#' para descartar todas as linhas que começam com (por exemplo) #:
"
read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

"
Em outros casos, os dados podem não ter nomes de colunas. Você pode usar col_names = FALSE para dizer ao read_csv() para não tratar a primeira linha como cabeçalhos e, em vez disso, rotulá-los sequencialmente de X1 a Xn:
"
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)

"
Alternativamente, você pode passar col_names um vetor de caracteres que será usado como os nomes das colunas:
"
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

"
Esses argumentos são tudo o que você precisa saber para ler a maioria dos arquivos CSV que encontrará na prática. (Para o resto, você precisará inspecionar cuidadosamente seu arquivo .csv e ler a documentação para os muitos outros argumentos de read_csv()).
"

#----7.2.3 Outros tipos de arquivos----
"
Uma vez que você dominou read_csv(), usar as outras funções do readr é direto; é apenas uma questão de saber qual função utilizar:
"  
#1º read_csv2() lê arquivos separados por ponto e vírgula. Eles usam ; em vez de , para separar os campos e são comuns em países que usam , como marcador decimal.

#2º read_tsv() lê arquivos delimitados por tabulações.

#3º read_delim() lê arquivos com qualquer delimitador, tentando adivinhar automaticamente o delimitador se você não o especificar.

#4º read_fwf() lê arquivos de largura fixa. Você pode especificar campos pela largura deles com fwf_widths() ou pelas suas posições com fwf_positions().

#5º read_table() lê uma variação comum de arquivos de largura fixa onde as colunas são separadas por espaço em branco.

#6º read_log() lê arquivos de log no estilo Apache.

#----7.3 Controlando tipos de coluna----
"
Um arquivo CSV não contém nenhuma informação sobre o tipo de cada variável (ou seja, se é um valor lógico, numérico, string, etc.), então o readr tentará adivinhar o tipo. Esta seção descreve como o processo de adivinhação funciona, como resolver alguns problemas comuns que fazem com que ele falhe e, se necessário, como fornecer os tipos de coluna você mesmo. Finalmente, mencionaremos algumas estratégias gerais que são úteis se o readr estiver falhando catastroficamente e você precisar obter mais informações sobre a estrutura do seu arquivo.
" 

#----7.3.1 Adivinhando tipos----
"
O readr usa uma heurística para descobrir os tipos de coluna. Para cada coluna, ele puxa os valores de 1.000 linhas espaçadas uniformemente da primeira à última, ignorando valores ausentes. Em seguida, ele trabalha com as seguintes perguntas:
"
#1º Contém apenas F, T, FALSE ou TRUE (ignorando maiúsculas e minúsculas)? Se sim, é um lógico.

#2º Contém apenas números (por exemplo, 1, -4.5, 5e6, Inf)? Se sim, é um número.

#3º Corresponde ao padrão ISO8601? Se sim, é uma data ou data-hora.

#4º Caso contrário, deve ser uma string.

"
Você pode ver esse comportamento em ação neste exemplo simples:
"
read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

"
Essa heurística funciona bem se você tem um conjunto de dados limpo, mas na vida real, você encontrará uma seleção de falhas estranhas e maravilhosas.
"

#----7.3.2 Valores ausentes, tipos de colunas e problemas----
"A maneira mais comum de a detecção de colunas falhar é quando uma coluna contém valores inesperados, e você obtém uma coluna de caracteres em vez de um tipo mais específico. Uma das causas mais comuns para isso é um valor ausente, registrado usando algo diferente do NA que o readr espera.

Pegue este simples arquivo CSV de 1 coluna como exemplo:
"
simple_csv <- "
  x
  10
  .
  20
  30"

"
Se o lermos sem argumentos adicionais, x se torna uma coluna de caracteres:
"
read_csv(simple_csv)

"
Neste caso muito pequeno, você pode facilmente ver o valor ausente .. Mas o que acontece se você tiver milhares de linhas com apenas alguns valores ausentes representados por .s espalhados entre eles? Uma abordagem é dizer ao readr que x é uma coluna numérica e, em seguida, ver onde falha. Você pode fazer isso com o argumento col_types, que recebe uma lista nomeada onde os nomes correspondem aos nomes das colunas no arquivo CSV:
"
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

"
Agora read_csv() relata que houve um problema e nos diz que podemos descobrir mais com problems():
"
problems(df)

"
Isso nos diz que houve um problema na linha 3, col 1 onde o readr esperava um double mas obteve um .. Isso sugere que este conjunto de dados usa . para valores ausentes. Então definimos na = '.', o palpite automático tem sucesso, nos dando a coluna numérica que queremos:
"
read_csv(simple_csv, na = ".")


#----7.3.3 Tipos de colunas----
"
O readr fornece um total de nove tipos de colunas para você usar:
"  
#1º col_logical() e col_double()** leem valores lógicos e números reais. Eles são relativamente raramente necessários (exceto como acima), já que o readr geralmente os adivinha para você.

#2º col_integer()** lê inteiros. Raramente distinguimos inteiros e números reais neste livro porque eles são funcionalmente equivalentes, mas ler inteiros explicitamente pode ocasionalmente ser útil porque eles ocupam metade da memória dos números reais.

#3º col_character()** lê strings. Isso pode ser útil para especificar explicitamente quando você tem uma coluna que é um identificador numérico, ou seja, uma longa série de dígitos que identifica um objeto, mas não faz sentido aplicar operações matemáticas. Exemplos incluem números de telefone, números de segurança social, números de cartão de crédito, etc.

#4º col_factor(), col_date() e col_datetime()** criam fatores, datas e data-horas, respectivamente.

#5º col_number()** é um analisador numérico permissivo que ignorará componentes não numéricos, e é particularmente útil para moedas.

#6º col_skip()** pula uma coluna para que ela não seja incluída no resultado, o que pode ser útil para acelerar a leitura dos dados se você tiver um arquivo CSV grande e quiser usar apenas algumas das colunas.

"
Também é possível substituir a coluna padrão mudando de list() para cols() e especificando .default:
"
another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

"
Outro auxiliar útil é cols_only(), que lerá apenas as colunas que você especificar:
"
read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)

#----7.4 Lendo dados de múltiplos arquivos----
"

Às vezes, seus dados estão divididos em vários arquivos em vez de estarem contidos em um único arquivo. Por exemplo, você pode ter dados de vendas para vários meses, com os dados de cada mês em um arquivo separado: 01-sales.csv para janeiro, 02-sales.csv para fevereiro e 03-sales.csv para março. Com read_csv(), você pode ler esses dados de uma vez e empilhá-los uns sobre os outros em um único dataframe.

Mais uma vez, o código acima funcionará se você tiver os arquivos CSV em uma pasta de dados no seu projeto. Você pode baixar esses arquivos de https://pos.it/r4ds-01-sales, https://pos.it/r4ds-02-sales e https://pos.it/r4ds-03-sales ou você pode lê-los diretamente com:
"
sales_01 <- read.csv("https://pos.it/r4ds-01-sales")
write.csv(sales_01,"01-sales.csv")

sales_02 <- read.csv("https://pos.it/r4ds-02-sales")
write.csv(sales_02,"02-sales.csv")

sales_03 <- read.csv("https://pos.it/r4ds-03-sales")
write.csv(sales_03,"03-sales.csv")

sales_files <- c("01-sales.csv", "02-sales.csv", "03-sales.csv")
read_csv(sales_files, id = "file")

"
O argumento id adiciona uma nova coluna chamada file ao dataframe resultante que identifica o arquivo de onde os dados vêm. Isso é especialmente útil em circunstâncias onde os arquivos que você está lendo não têm uma coluna identificadora que possa ajudá-lo a rastrear as observações de volta às suas fontes originais.

Se você tem muitos arquivos que deseja ler, pode ser trabalhoso escrever os nomes deles como uma lista. Em vez disso, você pode usar a função list.files() do base R para encontrar os arquivos para você, combinando um padrão nos nomes dos arquivos.
"
sales_files <- list.files(pattern = "sales\\.csv$", full.names = TRUE)
sales_files

#----7.5 Escrevendo em um arquivo----
"
O readr também vem com duas funções úteis para escrever dados de volta no disco: write_csv() e write_tsv(). Os argumentos mais importantes para essas funções são x (o dataframe a ser salvo) e file (o local para salvá-lo). Você também pode especificar como os valores ausentes são escritos com na e se deseja anexar a um arquivo existente.
"
write_csv(students, "students.csv")

"
Agora, vamos ler esse arquivo csv de volta. Note que as informações de tipo de variável que você acabou de configurar são perdidas quando você salva em CSV porque você está começando de novo com a leitura de um arquivo de texto simples novamente:
"
students
write_csv(students, "students-2.csv")
read_csv("students-2.csv")

"
Isso torna os CSVs um pouco confiáveis para armazenar resultados intermediários — você precisa recriar a especificação da coluna toda vez que carregar. Existem duas principais alternativas:
"
#1º write_rds() e read_rds() são wrappers uniformes em torno das funções base readRDS() e saveRDS(). Estas armazenam dados no formato binário personalizado do R chamado RDS. Isso significa que quando você recarrega o objeto, está carregando exatamente o mesmo objeto R que você armazenou.

write_rds(students, "students.rds")
read_rds("students.rds")

#2º O pacote arrow permite que você leia e escreva arquivos parquet, um formato de arquivo binário rápido que pode ser compartilhado entre linguagens de programação.
library(arrow)
write_parquet(students, "students.parquet")
read_parquet("students.parquet")

#----7.6 Entrada de dados----
"
Às vezes, você precisará montar um tibble 'manualmente', fazendo um pouco de entrada de dados no seu script R. Existem duas funções úteis para ajudá-lo nisso, que diferem em se você organiza o tibble por colunas ou por linhas. tibble() funciona por coluna:
"
tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

"
Organizar os dados por coluna pode dificultar a visualização de como as linhas estão relacionadas. Portanto, uma alternativa é tribble(), abreviação de tibble transposto, que permite organizar seus dados linha por linha. tribble() é personalizado para entrada de dados em código: os cabeçalhos das colunas começam com ~ e as entradas são separadas por vírgulas. Isso torna possível organizar pequenas quantidades de dados de forma fácil de ler:
"
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)


#Capítulo 8 : Fluxo de Trabalho: Obtendo Ajuda----
"
Este livro não é uma ilha; não existe um único recurso que permita dominar o R. À medida que você começar a aplicar as técnicas descritas neste livro aos seus próprios dados, logo encontrará perguntas que não respondemos. Esta seção descreve algumas dicas sobre como obter ajuda e ajudá-lo a continuar aprendendo.
"

#----8.1O Google é seu Amigo----
"
Se você ficar preso, comece com o Google. Normalmente, adicionar 'R' a uma consulta é suficiente para restringi-la a resultados relevantes: se a pesquisa não for útil, muitas vezes significa que não há resultados específicos para R disponíveis. Além disso, adicionar nomes de pacotes como 'tidyverse' ou 'ggplot2' ajudará a restringir os resultados para códigos que também parecerão mais familiares para você, por exemplo, 'como fazer um boxplot em R' versus 'como fazer um boxplot em R com ggplot2'. O Google é particularmente útil para mensagens de erro. Se você receber uma mensagem de erro e não tiver ideia do que ela significa, tente pesquisar no Google! É provável que alguém já tenha se confundido com ela no passado, e haverá ajuda em algum lugar na web. (Se a mensagem de erro não estiver em inglês, execute Sys.setenv(LANGUAGE = 'en') e reexecute o código; é mais provável que você encontre ajuda para mensagens de erro em inglês.)

Se o Google não ajudar, tente o Stack Overflow. Comece gastando um pouco de tempo procurando uma resposta existente, incluindo [R], para restringir sua pesquisa a perguntas e respostas que usam R.
"

#----8.2Criando um reprex----
"
Se a sua busca no Google não encontrar nada útil, é uma ótima ideia preparar um reprex, abreviação de exemplo reproduzível mínimo. Um bom reprex facilita para outras pessoas ajudarem você, e muitas vezes você descobrirá o problema por si mesmo no decorrer da sua criação. Há duas partes para criar um reprex
"

#1º Primeiro, você precisa tornar seu código reproduzível. Isso significa que você precisa capturar tudo, ou seja, incluir quaisquer chamadas de library() e criar todos os objetos necessários. A maneira mais fácil de garantir que você fez isso é usando o pacote reprex.

#2º Segundo, você precisa torná-lo minimalista. Elimine tudo que não está diretamente relacionado ao seu problema. Isso geralmente envolve criar um objeto R muito menor e mais simples do que aquele com o qual você está lidando na vida real ou até mesmo usar dados integrados.

"Isso parece muito trabalho! E pode ser, mas tem uma grande recompensa:"

#1º 80% do tempo, criar um excelente reprex revela a fonte do seu problema. É incrível como muitas vezes o processo de escrever um exemplo autocontido e minimalista permite que você responda à sua própria pergunta.

#2º Os outros 20% do tempo, você terá capturado a essência do seu problema de uma forma que é fácil para outros brincarem. Isso aumenta substancialmente suas chances de obter ajuda!

"
Ao criar um reprex manualmente, é fácil perder acidentalmente algo, o que significa que seu código não pode ser executado no computador de outra pessoa. Evite esse problema usando o pacote reprex, que é instalado como parte do tidyverse. Digamos que você copie este código para sua área de transferência (ou, no RStudio Server ou Cloud, selecione-o):
"
y <- 1:4
mean(y)

"
Em seguida, chame reprex(), onde a saída padrão é formatada para o GitHub:
"
reprex::reprex()

"
Uma prévia em HTML bem renderizada será exibida no Visualizador do RStudio (se você estiver no RStudio) ou em seu navegador padrão caso contrário. O reprex é automaticamente copiado para sua área de transferência (no RStudio Server ou Cloud, você precisará copiar isso manualmente):
"
#```
y <- 1:4
mean(y)
#```
"
Este texto é formatado de uma maneira especial, chamada Markdown, que pode ser colada em sites como StackOverflow ou Github, e eles o renderizarão automaticamente para parecer código. Aqui está como esse Markdown pareceria renderizado no GitHub:
"
y <- 1:4
mean(y)

"
Qualquer outra pessoa pode copiar, colar e executar isso imediatamente.

Existem três coisas que você precisa incluir para tornar seu exemplo reproduzível: pacotes necessários, dados e código.
"
#1º Os pacotes devem ser carregados no topo do script para que seja fácil ver quais são necessários para o exemplo. Este é um bom momento para verificar se você está usando a versão mais recente de cada pacote; você pode ter descoberto um bug que foi corrigido desde que instalou ou atualizou o pacote pela última vez. Para pacotes do tidyverse, a maneira mais fácil de verificar é executar tidyverse_update().

#2º A maneira mais fácil de incluir dados é usar dput() para gerar o código R necessário para recriá-los. Por exemplo, para recriar o conjunto de dados mtcars em R, siga estas etapas:
#2.1 Execute dput(mtcars) em R.
#2.2 Copie a saída.
#2.3 No reprex, digite mtcars <- e, em seguida, cole.
# Tente usar o menor subconjunto de seus dados que ainda revele o problema.

#3º Gaste um pouco de tempo garantindo que seu código seja fácil de ler para outras pessoas:
#3.1  Certifique-se de ter usado espaços e seus nomes de variáveis são concisos, mas informativos.
#3.2  Use comentários para indicar onde está o seu problema.
#3.3  Faça o seu melhor para remover tudo que não está relacionado ao problema.
# Quanto mais curto for o seu código, mais fácil ele será de entender e corrigir.

"
Termine verificando se você realmente fez um exemplo reproduzível, iniciando uma nova sessão de R e copiando e colando seu script.

Criar reprexes não é trivial e levará algum tempo para aprender a criar bons reprexes verdadeiramente mínimos. No entanto, aprender a fazer perguntas que incluam o código e investir tempo para torná-lo reproduzível continuará valendo a pena à medida que você aprende e domina o R.
"
#----8.3Investindo em Si Mesmo----
"
Você também deve dedicar algum tempo para se preparar para resolver problemas antes que eles ocorram. Investir um pouco de tempo aprendendo R todos os dias trará grandes benefícios a longo prazo. Uma maneira é acompanhar o que a equipe do tidyverse está fazendo no blog do tidyverse. Para se manter atualizado com a comunidade R de forma mais ampla, recomendamos a leitura do R Weekly: é um esforço comunitário para agregar as notícias mais interessantes na comunidade R a cada semana.
"

#Capítulo 9 : Camadas----
#----9.1Introdução----
"
Você aprendeu muito mais do que apenas como fazer gráficos de dispersão, gráficos de barras e boxplots. Você aprendeu uma base que pode usar para fazer qualquer tipo de gráfico com o ggplot2.

Agora você expandirá essa base à medida que aprende sobre a gramática em camadas dos gráficos. Começaremos com um mergulho mais profundo em mapeamentos estéticos, objetos geométricos e facetas. Em seguida, você aprenderá sobre as transformações estatísticas que o ggplot2 faz por baixo dos panos ao criar um gráfico. Essas transformações são usadas para calcular novos valores para plotar, como as alturas das barras em um gráfico de barras ou as medianas em um boxplot. Você também aprenderá sobre ajustes de posição, que modificam como os geoms são exibidos em seus gráficos. Por fim, introduziremos brevemente os sistemas de coordenadas.

Não abordaremos todas as funções e opções para cada uma dessas camadas, mas guiaremos você pelas funcionalidades mais importantes e comumente usadas fornecidas pelo ggplot2, bem como o apresentaremos a pacotes que estendem o ggplot2.
"

#----9.1.1Pré-Requesitos----
"
Focaremos no ggplot2. Para acessar os conjuntos de dados, páginas de ajuda e funções usadas neste capítulo, carregue o tidyverse executando este código:
"
library(tidyverse)
#----9.2Mapeamentos Estéticos----
"
Lembre-se de que o quadro de dados mpg incluído no pacote ggplot2 contém 234 observações em 38 modelos de carros.
"
mpg

"
Dentre as variáveis em mpg estão:
" 
#1º displ: O tamanho do motor de um carro, em litros. Uma variável numérica.

#2º hwy: A eficiência de combustível de um carro na estrada, em milhas por galão (mpg). Um carro com baixa eficiência de combustível consome mais combustível do que um carro com alta eficiência de combustível quando percorrem a mesma distância. Uma variável numérica.

#3º class: Tipo de carro. Uma variável categórica.

"
Vamos começar visualizando a relação entre 'displ' (tamanho do motor) e 'hwy' (eficiência de combustível na estrada) para várias classes de carros. Podemos fazer isso com um gráfico de dispersão onde as variáveis numéricas são mapeadas para as estéticas x e y e a variável categórica é mapeada para uma estética como cor ou forma.
"

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()

"
Como o ggplot2 usará apenas seis formas por vez, por padrão, grupos adicionais não serão plotados quando você usar a estética de forma. O segundo aviso está relacionado – há 62 SUVs no conjunto de dados e eles não estão plotados.

Da mesma forma, podemos mapear a classe para as estéticas de tamanho ou alfa também, que controlam o tamanho e a transparência dos pontos, respectivamente.
"

ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

"
Mapear uma variável discreta não ordenada (categórica) como 'class' para uma estética ordenada como 'size' (tamanho) ou 'alpha' (transparência) geralmente não é uma boa ideia porque implica uma classificação que de fato não existe.

Uma vez que você mapeia uma estética, o ggplot2 cuida do resto. Ele seleciona uma escala razoável para usar com a estética e constrói uma legenda que explica o mapeamento entre níveis e valores. Para as estéticas x e y, o ggplot2 não cria uma legenda, mas cria uma linha de eixo com marcas de escala e um rótulo. A linha do eixo fornece a mesma informação que uma legenda; ela explica o mapeamento entre locais e valores.

Você também pode definir as propriedades visuais do seu geom manualmente como um argumento da sua função geom (fora do aes()) em vez de depender de um mapeamento de variável para determinar a aparência. Por exemplo, podemos fazer todos os pontos no nosso gráfico serem azuis:
"
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")

"
Aqui, a cor não transmite informações sobre uma variável, mas apenas muda a aparência do gráfico. Você precisará escolher um valor que faça sentido para essa estética:
"  
# O nome de uma cor como uma string de caracteres, por exemplo, color = "blue"
# O tamanho de um ponto em milímetros, por exemplo, size = 1
#A forma de um ponto como um número, por exemplo, shape = 1

"https://ggplot2.tidyverse.org/articles/ggplot2-specs.html" 
#Para mais informações de elementos gráficos, verifique esse site

"
Até agora, discutimos as estéticas que podemos mapear ou definir em um gráfico de dispersão, ao usar um geom de ponto. 
As estéticas específicas que você pode usar para um gráfico dependem do geom que você usa para representar os dados. Na próxima seção, mergulharemos mais fundo nos geoms.
"

#----9.3Objetos Geométricos----
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

"
O que há de semelhantes entre os gráficos acima ?

Esses dois gráficos são semelhantes porque ambos contêm a mesma variável x, a mesma variável y e ambos descrevem os mesmos dados. No entanto, os gráficos não são idênticos. Cada um usa um objeto geométrico diferente, ou geom, para representar os dados. O gráfico à esquerda usa o geom de ponto, representando cada observação individualmente, enquanto o gráfico à direita usa o geom suave, que é uma linha ajustada suavemente aos dados para mostrar a tendência geral.
"

"
Cada função geom no ggplot2 recebe um argumento de mapeamento, definido localmente na camada geom ou globalmente na camada ggplot(). No entanto, nem toda estética funciona com cada geom. Você poderia definir a forma de um ponto, mas não poderia definir a 'forma' de uma linha. Se tentar, o ggplot2 simplesmente ignorará esse mapeamento estético. Por outro lado, você poderia definir o tipo de linha de uma linha. O geom_smooth() desenhará uma linha diferente, com um tipo de linha diferente, para cada valor único da variável que você mapear para o tipo de linha.
"
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) + 
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()

"
Aqui, o geom_smooth() separa os carros em três linhas com base no valor de drv, que descreve o sistema de transmissão de um carro. Uma linha descreve todos os pontos que têm um valor 4, outra linha descreve todos os pontos que têm um valor f, e outra linha descreve todos os pontos que têm um valor r. Aqui, 4 representa tração nas quatro rodas, f para tração dianteira e r para tração traseira.

Se isso soa estranho, podemos torná-lo mais claro sobrepondo as linhas em cima dos dados brutos e depois colorindo tudo de acordo com drv.
"

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))

"
Observe que este gráfico contém dois geoms no mesmo gráfico.

Muitos geoms, como o geom_smooth(), usam um único objeto geométrico para exibir várias linhas de dados. Para esses geoms, você pode definir a estética de grupo para uma variável categórica para desenhar múltiplos objetos. O ggplot2 desenhará um objeto separado para cada valor único da variável de agrupamento. Na prática, o ggplot2 agrupará automaticamente os dados para esses geoms sempre que você mapear uma estética para uma variável discreta (como no exemplo do tipo de linha). É conveniente confiar nessa característica porque a estética de grupo por si só não adiciona uma legenda ou características distintivas aos geoms.
"

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

"
Se você colocar mapeamentos em uma função geom, o ggplot2 tratará esses mapeamentos como locais para a camada. Ele usará esses mapeamentos para estender ou sobrescrever os mapeamentos globais apenas para aquela camada. Isso torna possível exibir diferentes estéticas em diferentes camadas. 
"
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth()

"
Você pode usar a mesma ideia para especificar dados diferentes para cada camada. Aqui, usamos pontos vermelhos, bem como círculos abertos para destacar carros de dois lugares. O argumento de dados locais em geom_point() substitui o argumento de dados globais em ggplot() apenas para aquela camada.
"

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open", size = 3, color = "red"
  )

"
Geoms são os blocos de construção fundamentais do ggplot2. Você pode transformar completamente a aparência do seu gráfico alterando seu geom, e diferentes geoms podem revelar diferentes características dos seus dados. Por exemplo, o histograma e o gráfico de densidade abaixo revelam que a distribuição da quilometragem na estrada é bimodal e inclinada para a direita, enquanto o boxplot revela dois possíveis outliers.
"
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

ggplot(mpg, aes(x = hwy)) +
  geom_density()

ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()

"
O ggplot2 oferece mais de 40 geoms, mas estes não cobrem todos os possíveis gráficos que alguém poderia fazer. Se você precisar de um geom diferente, recomendamos primeiro procurar em pacotes de extensão para ver se alguém já o implementou (veja https://exts.ggplot2.tidyverse.org/gallery/ para uma amostra). Por exemplo, o pacote ggridges (https://wilkelab.org/ggridges) é útil para fazer gráficos de linha de crista, que podem ser úteis para visualizar a densidade de uma variável numérica para diferentes níveis de uma variável categórica. No gráfico a seguir, não apenas usamos um novo geom (geom_density_ridges()), mas também mapeamos a mesma variável para múltiplas estéticas (drv para y, fill e color) e definimos uma estética (alpha = 0.5) para tornar as curvas de densidade transparentes.
"

library(ggridges)

ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)

"
O melhor lugar para obter uma visão geral abrangente de todos os geoms que o ggplot2 oferece, bem como todas as funções do pacote, é a página de referência: https://ggplot2.tidyverse.org/reference. Para aprender mais sobre qualquer geom específico, use a ajuda (por exemplo, ?geom_smooth).
"
#----9.4Facetas----
"
Você aprendeu sobre facetas com facet_wrap(), que divide um gráfico em subgráficos, cada um mostrando um subconjunto dos dados baseado em uma variável categórica.
"
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)

"
Para criar facetas no seu gráfico com a combinação de duas variáveis, mude de facet_wrap() para facet_grid(). O primeiro argumento de facet_grid() também é uma fórmula, mas agora é uma fórmula de dois lados: linhas ~ colunas.
"
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)

"
Por padrão, cada uma das facetas compartilha a mesma escala e intervalo para os eixos x e y. Isso é útil quando você quer comparar dados entre facetas, mas pode ser limitante quando você quer visualizar melhor a relação dentro de cada faceta. Definir o argumento de escalas em uma função de facetas para 'free' permitirá escalas diferentes de eixos tanto para linhas quanto para colunas, 'free_x' permitirá escalas diferentes para linhas e 'free_y' permitirá escalas diferentes para colunas.
"
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_y")

#----9.5Tranformações Estatísticas----
"
Considere um gráfico de barras básico, desenhado com geom_bar() ou geom_col(). O gráfico a seguir exibe o número total de diamantes no conjunto de dados diamonds, agrupados por corte. O conjunto de dados diamonds está no pacote ggplot2 e contém informações sobre aproximadamente 54.000 diamantes, incluindo o preço, quilate, cor, clareza e corte de cada diamante. O gráfico mostra que há mais diamantes disponíveis com cortes de alta qualidade do que com cortes de baixa qualidade.
"
ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

"
No eixo x, o gráfico exibe corte, uma variável de diamonds. No eixo y, ele exibe contagem, mas contagem não é uma variável em diamonds! De onde vem a contagem? Muitos gráficos, como gráficos de dispersão, plotam os valores brutos do seu conjunto de dados. Outros gráficos, como gráficos de barras, calculam novos valores para plotar:
"
#1º Gráficos de barras, histogramas e polígonos de frequência agrupam seus dados e depois plotam as contagens de cada grupo, o número de pontos que caem em cada grupo.
#2º Suavizadores ajustam um modelo aos seus dados e depois plotam as previsões desse modelo.
#3ºBoxplots calculam o resumo de cinco números da distribuição e depois exibem esse resumo como uma caixa formatada especialmente.

"
O algoritmo usado para calcular novos valores para um gráfico é chamado de stat, abreviação de transformação estatística.

Você pode descobrir qual stat um geom usa inspecionando o valor padrão para o argumento stat. Por exemplo, ?geom_bar mostra que o valor padrão para stat é 'count', o que significa que geom_bar() usa stat_count(). O stat_count() é documentado na mesma página que geom_bar(). Se você rolar para baixo, a seção chamada 'Computed variables' explica que ele calcula duas novas variáveis: count e prop.

Todo geom tem um stat padrão; e todo stat tem um geom padrão. Isso significa que você normalmente pode usar geoms sem se preocupar com a transformação estatística subjacente. No entanto, há três razões pelas quais você pode precisar usar um stat explicitamente:
"
#1ºVocê pode querer substituir o stat padrão. No código abaixo, mudamos o stat de geom_bar() de count (o padrão) para identity. Isso nos permite mapear a altura das barras para os valores brutos de uma variável y.
diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")
#2º Você pode querer substituir o mapeamento padrão de variáveis transformadas para estéticas. Por exemplo, você pode querer exibir um gráfico de barras de proporções, em vez de contagens:
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()
#Para encontrar as possíveis variáveis que podem ser calculadas pelo stat, procure a seção intitulada "computed variables" na ajuda para geom_bar().
#3ºVocê pode querer chamar mais atenção para a transformação estatística no seu código. Por exemplo, você pode usar stat_summary(), que resume os valores y para cada valor único de x, para chamar atenção para o resumo que você está computando:
ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )
#O ggplot2 oferece mais de 20 stats para você usar. Cada stat é uma função, então você pode obter ajuda da maneira usual, por exemplo, ?stat_bin.

#----9.6Ajustes de Posição----
"
Há mais um truque associado a gráficos de barras. Você pode colorir um gráfico de barras usando a estética de cor ou, de forma mais útil, a estética de preenchimento:
"
ggplot(mpg, aes(x = drv, color = drv)) + 
  geom_bar()


ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar()

"
Observe o que acontece se você mapear a estética de preenchimento para outra variável, como class: as barras são automaticamente empilhadas. Cada retângulo colorido representa uma combinação de drv e class.
"
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar()

"
O empilhamento é realizado automaticamente usando o ajuste de posição especificado pelo argumento position. Se você não quiser um gráfico de barras empilhadas, pode usar uma das três outras opções: 'identity', 'dodge' ou 'fill'.
"
#1º position = "identity" colocará cada objeto exatamente onde ele se encontra no contexto do gráfico. Isso não é muito útil para barras, porque as sobrepõe. Para ver essa sobreposição, precisamos tornar as barras ligeiramente transparentes, definindo alpha para um pequeno valor, ou completamente transparentes, definindo fill = NA.

ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(mpg, aes(x = drv, color = class)) + 
  geom_bar(fill = NA, position = "identity")
#O ajuste de posição de identidade é mais útil para geoms 2d, como pontos, onde é o padrão.
#2º position = "fill" funciona como empilhamento, mas torna cada conjunto de barras empilhadas da mesma altura. Isso facilita a comparação de proporções entre grupos.
#3º position = "dodge" coloca objetos sobrepostos diretamente um ao lado do outro. Isso facilita a comparação de valores individuais.
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")

ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "dodge")

"
Há outro tipo de ajuste que não é útil para gráficos de barras, mas pode ser muito útil para gráficos de dispersão. Lembre-se do nosso primeiro gráfico de dispersão. Você notou que o gráfico mostra apenas 126 pontos, embora haja 234 observações no conjunto de dados?

Os valores subjacentes de hwy e displ são arredondados, fazendo com que os pontos apareçam em uma grade e muitos se sobreponham. Esse problema é conhecido como sobreposição excessiva. Essa disposição torna difícil ver a distribuição dos dados. Os pontos de dados estão distribuídos igualmente por todo o gráfico, ou há uma combinação especial de hwy e displ que contém 109 valores?

Você pode evitar essa grade definindo o ajuste de posição para 'jitter'. position = 'jitter' adiciona uma pequena quantidade de ruído aleatório a cada ponto. Isso espalha os pontos porque é improvável que dois pontos recebam a mesma quantidade de ruído aleatório.
"
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(position = "jitter")

"
Adicionar aleatoriedade pode parecer uma maneira estranha de melhorar seu gráfico, mas, embora torne seu gráfico menos preciso em escalas pequenas, ele o torna mais revelador em escalas maiores. Como esta é uma operação tão útil, o ggplot2 vem com um atalho para geom_point(position = 'jitter'): geom_jitter().

Para aprender mais sobre um ajuste de posição, consulte a página de ajuda associada a cada ajuste: ?position_dodge, ?position_fill, ?position_identity, ?position_jitter e ?position_stack.
"
#----9.7Sistemas de Coordenadas----
"
Os sistemas de coordenadas são provavelmente a parte mais complicada do ggplot2. O sistema de coordenadas padrão é o sistema de coordenadas cartesianas, onde as posições x e y agem independentemente para determinar a localização de cada ponto. Existem outros dois sistemas de coordenadas que são ocasionalmente úteis.
"
#1ºcoord_quickmap() define a proporção correta para mapas geográficos. Isso é muito importante se você estiver plotando dados espaciais com o ggplot2. Não temos espaço para discutir mapas neste livro, mas você pode aprender mais no capítulo de Mapas de ggplot2: Gráficos elegantes para análise de dados.
nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()
#2ºcoord_polar() usa coordenadas polares. Coordenadas polares revelam uma conexão interessante entre um gráfico de barras e um gráfico de Coxcomb.

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()


#----9.8A Grmática em Camadas dos Gráficos----
"
Podemos expandir o modelo de gráficos que você aprendeu adicionando ajustes de posição, stats, sistemas de coordenadas e facetas:

ggplot(data = <DATA>) + 
<GEOM_FUNCTION>(
  mapping = aes(<MAPPINGS>),
  stat = <STAT>, 
  position = <POSITION>
) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
  
Nosso novo modelo leva sete parâmetros, as palavras entre colchetes que aparecem no modelo. Na prática, você raramente precisa fornecer todos os sete parâmetros para fazer um gráfico porque o ggplot2 fornecerá padrões úteis para tudo, exceto os dados, os mapeamentos e a função geom.

Os sete parâmetros no modelo compõem a gramática dos gráficos, um sistema formal para construir gráficos. A gramática dos gráficos é baseada na percepção de que você pode descrever de forma única qualquer gráfico como uma combinação de um conjunto de dados, um geom, um conjunto de mapeamentos, um stat, um ajuste de posição, um sistema de coordenadas, um esquema de facetas e um tema.

Para ver como isso funciona, considere como você poderia construir um gráfico básico do zero: você poderia começar com um conjunto de dados e, em seguida, transformá-lo nas informações que deseja exibir (com um stat). Em seguida, você poderia escolher um objeto geométrico para representar cada observação nos dados transformados. Você poderia então usar as propriedades estéticas dos geoms para representar variáveis nos dados. Você mapearia os valores de cada variável para os níveis de uma estética. Você selecionaria então um sistema de coordenadas para colocar os geoms, usando a localização dos objetos (que é em si uma propriedade estética) para exibir os valores das variáveis x e y.
Neste ponto, você teria um gráfico completo, mas poderia ajustar ainda mais as posições dos geoms dentro do sistema de coordenadas (um ajuste de posição) ou dividir o gráfico em subgráficos (facetas). Você também poderia estender o gráfico adicionando uma ou mais camadas adicionais, onde cada camada adicional usa um conjunto de dados, um geom, um conjunto de mapeamentos, um stat e um ajuste de posição.

Você poderia usar esse método para construir qualquer gráfico que imaginar. Em outras palavras, você pode usar o modelo de código que aprendeu neste capítulo para construir centenas de milhares de gráficos únicos.

Se você quiser aprender mais sobre os fundamentos teóricos do ggplot2, pode gostar de ler 'A Gramática em Camadas dos Gráficos', o artigo científico que descreve a teoria do ggplot2 em detalhes.
"

#Capítulo 10 : Análise exploratória de dados----

#----10.1Introdução----
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
"
Agora combinaremos o que você aprendeu sobre dplyr e ggplot2 para fazer perguntas interativas, respondê-las com dados e depois fazer novas perguntas.
"
library(tidyverse)

#----10.2Perguntas----
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
"
Se a variação descreve o comportamento dentro de uma variável, a covariação descreve o comportamento entre variáveis. Covariação é a tendência de os valores de duas ou mais variáveis variarem juntos de uma maneira relacionada. A melhor maneira de identificar a covariação é visualizar a relação entre duas ou mais variáveis.
"

#----10.5.1Uma variável categórica e uma numérica----
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

#Capítulo 11 : Comunicação----

#----11.1Introdução----
"
Anteriormente, você aprendeu a usar gráficos como ferramentas para exploração. Quando você faz gráficos exploratórios, você sabe — mesmo antes de olhar — quais variáveis o gráfico irá exibir. Você fez cada gráfico com um propósito, podia olhá-lo rapidamente e então passar para o próximo. No decorrer da maioria das análises, você produzirá dezenas ou centenas de gráficos, a maioria dos quais é descartada imediatamente.

Agora que você entende seus dados, precisa comunicar seu entendimento aos outros. Seu público provavelmente não compartilhará seu conhecimento de fundo e não estará profundamente investido nos dados. Para ajudar os outros a construir rapidamente um bom modelo mental dos dados, você precisará investir um esforço considerável para tornar seus gráficos o mais autoexplicativos possível. Neste capítulo, você aprenderá algumas das ferramentas que o ggplot2 fornece para fazer isso.

Este capítulo se concentra nas ferramentas necessárias para criar bons gráficos. Presumimos que você saiba o que quer e apenas precisa saber como fazer. Por essa razão, recomendamos fortemente que você leia este capítulo em conjunto com um bom livro geral sobre visualização. Gostamos particularmente de 'The Truthful Art', de Albert Cairo. Ele não ensina a mecânica de criar visualizações, mas se concentra no que você precisa pensar para criar gráficos eficazes.
"

#----11.1.1Pré-Requesitos----
"Focaremos novamente no ggplot2. Também usaremos um pouco de dplyr para manipulação de dados, scales para substituir as divisões, rótulos, transformações e paletas padrão, e alguns pacotes de extensão do ggplot2, incluindo ggrepel (https://ggrepel.slowkow.com) por Kamil Slowikowski e patchwork (https://patchwork.data-imaginist.com) por Thomas Lin Pedersen. Não se esqueça de que você precisará instalar esses pacotes com install.packages() se ainda não os tiver.
"
#install.packages("ggrepel")
#install.packages("patchwork")

library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)

#----11.2Rótulos----
"
O ponto de partida mais fácil ao transformar um gráfico exploratório em um gráfico expositivo é com bons rótulos. Você adiciona rótulos com a função labs().
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type",
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

"
O propósito de um título de gráfico é resumir a principal descoberta. Evite títulos que apenas descrevam o que o gráfico é, por exemplo,  Um gráfico de dispersão do deslocamento do motor versus economia de combustível.

Se você precisar adicionar mais texto, existem outros dois rótulos úteis: subtitle adiciona detalhes adicionais em uma fonte menor abaixo do título e caption adiciona texto no canto inferior direito do gráfico, muitas vezes usado para descrever a fonte dos dados. Você também pode usar labs() para substituir os títulos dos eixos e da legenda. Geralmente é uma boa ideia substituir nomes de variáveis curtas por descrições mais detalhadas e incluir as unidades.

É possível usar equações matemáticas em vez de strings de texto. Basta trocar as aspas por quote() e ler sobre as opções disponíveis em ?plotmath:
"
df <- tibble(
  x = 1:10,
  y = cumsum(x^2)
)

ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(x[i]),
    y = quote(sum(x[i] ^ 2, i == 1, n))
  )

#----11.3Anotações----
"
Além de rotular os componentes principais do seu gráfico, muitas vezes é útil rotular observações individuais ou grupos de observações. A primeira ferramenta que você tem à sua disposição é o geom_text(). O geom_text() é semelhante ao geom_point(), mas possui uma estética adicional: label. Isso torna possível adicionar rótulos textuais aos seus gráficos.

Existem duas possíveis fontes de rótulos. Primeiro, você pode ter uma tabela que fornece rótulos. No gráfico a seguir, destacamos os carros com o maior tamanho de motor em cada tipo de tração e salvamos suas informações como um novo quadro de dados chamado label_info.
"
label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |>
  select(displ, hwy, drv, drive_type)

label_info

"
Em seguida, usamos esse novo quadro de dados para rotular diretamente os três grupos para substituir a legenda por rótulos colocados diretamente no gráfico. Usando os argumentos fontface e size, podemos personalizar a aparência dos rótulos de texto. Eles são maiores que o restante do texto no gráfico e estão em negrito. (theme(legend.position = 'none') desativa todas as legendas — falaremos mais sobre isso em breve.)
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")

"
Observe o uso de hjust (justificação horizontal) e vjust (justificação vertical) para controlar o alinhamento do rótulo.

No entanto, o gráfico anotado que fizemos acima é difícil de ler porque os rótulos se sobrepõem uns aos outros e aos pontos. Podemos usar a função geom_label_repel() do pacote ggrepel para resolver ambos os problemas. Esse pacote útil ajustará automaticamente os rótulos para que eles não se sobreponham:
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

"
Você também pode usar a mesma ideia para destacar certos pontos em um gráfico com geom_text_repel() do pacote ggrepel. Observe outra técnica útil usada aqui: adicionamos uma segunda camada de pontos grandes e vazios para destacar ainda mais os pontos rotulados.
"
potential_outliers <- mpg |>
  filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text_repel(data = potential_outliers, aes(label = model)) +
  geom_point(data = potential_outliers, color = "red") +
  geom_point(
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )

"
Lembre-se, além de geom_text() e geom_label(), você tem muitos outros geoms no ggplot2 disponíveis para ajudar a anotar seu gráfico. Algumas ideias:
"
#1º Use geom_hline() e geom_vline() para adicionar linhas de referência. Muitas vezes as fazemos grossas (linewidth = 2) e brancas (color = white), e as desenhamos abaixo da camada de dados primários. Isso as torna fáceis de ver, sem desviar a atenção dos dados.
#2º Use geom_rect() para desenhar um retângulo em torno de pontos de interesse. Os limites do retângulo são definidos pelas estéticas xmin, xmax, ymin, ymax. Alternativamente, veja o pacote ggforce, especificamente geom_mark_hull(), que permite anotar subconjuntos de pontos com cascos.
#3º Use geom_segment() com o argumento arrow para chamar a atenção para um ponto com uma seta. Use as estéticas x e y para definir o local de início e xend e yend para definir o local de término.
"
Outra função útil para adicionar anotações aos gráficos é annotate(). Como regra geral, geoms geralmente são úteis para destacar um subconjunto dos dados, enquanto annotate() é útil para adicionar um ou poucos elementos de anotação a um gráfico.

Para demonstrar o uso de annotate(), vamos criar um texto para adicionar ao nosso gráfico. O texto é um pouco longo, então usaremos stringr::str_wrap() para adicionar automaticamente quebras de linha a ele, dado o número de caracteres que você deseja por linha:
"
trend_text <- "Larger engine sizes tend to have lower fuel economy." |>
  str_wrap(width = 30)
trend_text

"
Em seguida, adicionamos duas camadas de anotação: uma com um geom de rótulo e a outra com um geom de segmento. As estéticas x e y em ambos definem onde a anotação deve começar, e as estéticas xend e yend na anotação do segmento definem o local final do segmento. Observe também que o segmento é estilizado como uma seta.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )
"
A anotação é uma ferramenta poderosa para comunicar as principais conclusões e características interessantes de suas visualizações. O único limite é a sua imaginação (e sua paciência com o posicionamento das anotações para que sejam esteticamente agradáveis)!
"

#----11.4Escalas----
"
A terceira maneira de tornar seu gráfico melhor para comunicação é ajustar as escalas. As escalas controlam como as mapeamentos estéticos se manifestam visualmente.
"


#----11.4.1Escalas Padrão----
"
Normalmente, o ggplot2 adiciona automaticamente escalas para você. Por exemplo, ao digitar:
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

"
ggplot2 automaticamente adiciona escalas padrão nos bastidores:
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

"
Observe o esquema de nomenclatura para escalas: scale_ seguido pelo nome da estética, depois _, e então o nome da escala. As escalas padrão são nomeadas de acordo com o tipo de variável com a qual elas se alinham: contínuo, discreto, datetime ou date. scale_x_continuous() coloca os valores numéricos de displ em uma linha numérica contínua no eixo x, scale_color_discrete() escolhe cores para cada classe de carro, etc. Existem muitas escalas não padrão, que você aprenderá abaixo.

As escalas padrão foram cuidadosamente escolhidas para fazer um bom trabalho para uma ampla gama de entradas. No entanto, você pode querer substituir os padrões por dois motivos:
"
#1º Você pode querer ajustar alguns dos parâmetros da escala padrão. Isso permite que você faça coisas como alterar as quebras nos eixos ou as etiquetas das chaves na legenda.
#2º Você pode querer substituir a escala completamente e usar um algoritmo completamente diferente. Muitas vezes você pode fazer melhor do que o padrão porque sabe mais sobre os dados.

#----11.4.2Marcas de eixo e chaves de legenda----
"
Coletivamente, os eixos e legendas são chamados de guias. Os eixos são usados para estéticas x e y; legendas são usadas para todo o resto.

Existem dois argumentos principais que afetam a aparência das marcas nos eixos e as chaves na legenda: breaks e labels. Breaks controla a posição das marcas ou os valores associados às chaves. Labels controla o rótulo de texto associado a cada marca/chave. O uso mais comum de breaks é para substituir a escolha padrão:
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 

"
Você pode usar labels da mesma maneira (um vetor de caracteres do mesmo comprimento que breaks), mas também pode definir para NULL para suprimir completamente os rótulos. Isso pode ser útil para mapas ou para publicar gráficos onde você não pode compartilhar os números absolutos. Você também pode usar breaks e labels para controlar a aparência das legendas. Para escalas discretas de variáveis categóricas, labels pode ser uma lista nomeada dos nomes dos níveis existentes e os rótulos desejados para eles.
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))

"
O argumento labels, juntamente com as funções de rotulagem do pacote scales, também é útil para formatar números como moeda, porcentagem, etc. O gráfico à esquerda mostra a rotulagem padrão com label_dollar(), que adiciona um sinal de dólar, bem como uma vírgula separadora de milhares. O gráfico à direita adiciona mais personalização, dividindo os valores em dólares por 1.000 e adicionando o sufixo 'K' (para 'milhares'), bem como adicionando quebras personalizadas. Note que breaks está na escala original dos dados.  
"
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = label_dollar())

ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
  )

"
Outra função útil de rótulo é label_percent():
"
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = label_percent())

"
Outro uso de breaks é quando você tem relativamente poucos pontos de dados e quer destacar exatamente onde as observações ocorrem. Por exemplo, pegue este gráfico que mostra quando cada presidente dos EUA começou e terminou seu mandato.
"
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")

"
Observe que para o argumento breaks extraímos a variável start como um vetor com presidential$start porque não podemos fazer um mapeamento estético para este argumento. Observe também que a especificação de breaks e labels para escalas de data e datetime é um pouco diferente:
"
#1º date_labels recebe uma especificação de formato, na mesma forma que parse_datetime().
#2º date_breaks (não mostrado aqui), recebe uma string como "2 dias" ou "1 mês".

#----11.4.3Layout da legenda----
"
Você mais frequentemente usará breaks e labels para ajustar os eixos. Embora ambos também funcionem para legendas, existem algumas outras técnicas que você provavelmente usará.

Para controlar a posição geral da legenda, você precisa usar uma configuração de tema(). Voltaremos aos temas no final do capítulo, mas em resumo, eles controlam as partes não relacionadas aos dados do gráfico. A configuração do tema legend.position controla onde a legenda é desenhada:
"
base <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

base + theme(legend.position = "right") # the default
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") +
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 3))

"
Se o seu gráfico for curto e largo, coloque a legenda no topo ou na parte inferior, e se for alto e estreito, coloque a legenda à esquerda ou à direita. Você também pode usar legend.position = 'none' para suprimir completamente a exibição da legenda.

Para controlar a exibição de legendas individuais, use guides() juntamente com guide_legend() ou guide_colorbar(). O exemplo a seguir mostra duas configurações importantes: controlar o número de linhas que a legenda usa com nrow e substituir uma das estéticas para aumentar os pontos. Isso é particularmente útil se você usou um baixo alpha para exibir muitos pontos em um gráfico.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2, override.aes = list(size = 4)))

"
Observe que o nome do argumento em guides() corresponde ao nome da estética, assim como em labs().
"

#----11.4.4Substituindo uma escala----
"
Em vez de apenas ajustar os detalhes um pouco, você pode substituir a escala completamente. Existem dois tipos de escalas que você provavelmente desejará trocar: escalas de posição contínua e escalas de cor. Felizmente, os mesmos princípios se aplicam a todas as outras estéticas, então, uma vez que você tenha dominado posição e cor, será capaz de aprender rapidamente outras substituições de escala.

É muito útil traçar transformações de sua variável. Por exemplo, é mais fácil ver a relação precisa entre quilate e preço se os transformarmos em log:
"
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d()

ggplot(diamonds, aes(x = log10(carat), y = log10(price))) +
  geom_bin2d()

"
No entanto, a desvantagem dessa transformação é que os eixos agora são rotulados com os valores transformados, dificultando a interpretação do gráfico. Em vez de fazer a transformação no mapeamento estético, podemos, em vez disso, fazê-lo com a escala. Isso é visualmente idêntico, exceto que os eixos são rotulados na escala dos dados originais.
"
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

"
Outra escala que é frequentemente personalizada é a cor. A escala categórica padrão escolhe cores que estão igualmente espaçadas ao redor da roda de cores. Alternativas úteis são as escalas ColorBrewer, que foram ajustadas manualmente para funcionar melhor para pessoas com tipos comuns de daltonismo. Os dois gráficos abaixo parecem semelhantes, mas há diferença suficiente nas tonalidades de vermelho e verde que os pontos à direita podem ser distinguidos mesmo por pessoas com daltonismo vermelho-verde.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")

"
Não se esqueça de técnicas mais simples para melhorar a acessibilidade. Se houver apenas algumas cores, você pode adicionar um mapeamento de forma redundante. Isso também ajudará a garantir que seu gráfico seja interpretável em preto e branco.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

"
As escalas ColorBrewer estão documentadas online em 
https://colorbrewer2.org/ e disponíveis em R por meio do pacote RColorBrewer, de Erich Neuwirth. As paletas sequenciais (topo) e divergentes (fundo) são particularmente úteis se seus valores categóricos forem ordenados ou tiverem um 'meio'. Isso geralmente surge se você usou cut() para transformar uma variável contínua em uma variável categórica.

Quando você tem um mapeamento predefinido entre valores e cores, use scale_color_manual(). Por exemplo, se mapearmos o partido presidencial para a cor, queremos usar o mapeamento padrão de vermelho para Republicanos e azul para Democratas. Uma abordagem para atribuir essas cores é usar códigos de cores hexadecimais:
"
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))

"
Outra opção é usar as escalas de cores viridis. Os designers, Nathaniel Smith e Stéfan van der Walt, adaptaram cuidadosamente esquemas de cores contínuas que são perceptíveis para pessoas com várias formas de daltonismo, bem como perceptivelmente uniformes tanto em cores quanto em preto e branco. Essas escalas estão disponíveis como paletas contínuas (c), discretas (d) e agrupadas (b) no ggplot2.
"
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c() +
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, binned", x = NULL, y = NULL)
"
Observe que todas as escalas de cores vêm em duas variedades: scale_color_() e scale_fill_() para as estéticas de cor e preenchimento, respectivamente (as escalas de cores estão disponíveis tanto em ortografias do Reino Unido quanto dos EUA).
"

#----11.4.5Zoom----
"
Existem três maneiras de controlar os limites do gráfico:
"
#1º Ajustando quais dados são plotados.
#2º Definindo os limites em cada escala.
#3º Definindo xlim e ylim em coord_cartesian().

"
Demonstraremos essas opções em uma série de gráficos. O gráfico à esquerda mostra a relação entre o tamanho do motor e a eficiência de combustível, colorido pelo tipo de tração. O gráfico à direita mostra as mesmas variáveis, mas subconjuntos dos dados que são plotados. A subdefinição dos dados afetou as escalas x e y, bem como a curva suave.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

mpg |>
  filter(displ >= 5 & displ <= 6 & hwy >= 10 & hwy <= 25) |>
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

"
Vamos comparar estes com os dois gráficos abaixo, onde o gráfico à esquerda define os limites em escalas individuais e o gráfico à direita os define em coord_cartesian(). Podemos ver que reduzir os limites é equivalente a subconjuntar os dados. Portanto, para ampliar uma região do gráfico, geralmente é melhor usar coord_cartesian().
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  scale_x_continuous(limits = c(5, 6)) +
  scale_y_continuous(limits = c(10, 25))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 6), ylim = c(10, 25))
"
Por outro lado, definir os limites em escalas individuais geralmente é mais útil se você quiser expandir os limites, por exemplo, para combinar escalas entre diferentes gráficos. Por exemplo, se extraímos duas classes de carros e os plotamos separadamente, é difícil comparar os gráficos porque todas as três escalas (o eixo x, o eixo y e a estética de cor) têm diferentes intervalos.
"
suv <- mpg |> filter(class == "suv")
compact <- mpg |> filter(class == "compact")

ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

"
Uma maneira de superar esse problema é compartilhar escalas entre vários gráficos, ajustando as escalas com os limites dos dados completos.
"
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale
"
Neste caso particular, você poderia simplesmente ter usado facetas, mas essa técnica é útil de forma mais geral, por exemplo, se você quiser espalhar gráficos por várias páginas de um relatório. Isso ajuda a garantir que as comparações entre os gráficos sejam válidas e que as diferenças observadas sejam devido às diferenças nos dados, não às diferenças arbitrárias nas escalas dos gráficos. Compartilhar escalas é crucial quando o objetivo é fazer comparações diretas entre diferentes subconjuntos dos dados.
"

#----11.5Temas----
"
Finalmente, você pode personalizar os elementos não relacionados aos dados do seu gráfico com um tema:
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()

"
O ggplot2 inclui os oito temas , sendo theme_gray() o padrão. Muitos mais estão incluídos em pacotes adicionais como ggthemes (https://jrnold.github.io/ggthemes), de Jeffrey Arnold. Você também pode criar seus próprios temas, se estiver tentando corresponder a um estilo corporativo ou de jornal específico.

Também é possível controlar componentes individuais de cada tema, como o tamanho e a cor da fonte usada para o eixo y. Já vimos que legend.position controla onde a legenda é desenhada. Há muitos outros aspectos da legenda que podem ser personalizados com theme(). Por exemplo, no gráfico abaixo, mudamos a direção da legenda e colocamos uma borda preta ao redor dela. Observe que a personalização da caixa de legenda e dos elementos do título do gráfico do tema é feita com funções element_*(). Essas funções especificam o estilo dos componentes não relacionados aos dados, por exemplo, o texto do título é colocado em negrito no argumento face de element_text() e a cor da borda da legenda é definida no argumento color de element_rect(). Os elementos do tema que controlam a posição do título e da legenda são plot.title.position e plot.caption.position, respectivamente. No gráfico a seguir, estes são definidos como 'plot' para indicar que esses elementos estão alinhados a toda a área do gráfico, em vez do painel do gráfico (o padrão). Alguns outros componentes úteis de theme() são usados para alterar a colocação e o formato do texto do título e da legenda.
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  labs(
    title = "Larger engine sizes tend to have lower fuel economy",
    caption = "Source: https://fueleconomy.gov."
  ) +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )
"
Para uma visão geral de todos os componentes de theme(), veja a ajuda com ?theme. O livro ggplot2 também é um ótimo lugar para ir para os detalhes completos sobre temas.
"

#----11.6Layout----
"
Até agora, falamos sobre como criar e modificar um único gráfico. E se você tiver vários gráficos que deseja organizar de uma certa maneira? O pacote patchwork permite combinar gráficos separados no mesmo gráfico. Carregamos este pacote anteriormente no capítulo.

Para colocar dois gráficos lado a lado, você pode simplesmente adicioná-los um ao outro. Observe que você primeiro precisa criar os gráficos e salvá-los como objetos (no exemplo a seguir, eles são chamados de p1 e p2). Então, você os coloca lado a lado com +.
"
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p1 + p2

"
É importante notar que no trecho de código acima, não usamos uma nova função do pacote patchwork. Em vez disso, o pacote adicionou uma nova funcionalidade ao operador +.

Você também pode criar layouts complexos de gráficos com patchwork. No seguinte, | coloca p1 e p3 um ao lado do outro e / move p2 para a próxima linha.
"
p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
(p1 | p3) / p2

"
Além disso, o patchwork permite que você colete legendas de vários gráficos em uma legenda comum, personalize a colocação da legenda, bem como as dimensões dos gráficos, e adicione um título comum, subtítulo, legenda, etc. aos seus gráficos. Abaixo, criamos 5 gráficos. Desativamos as legendas nos boxplots e no gráfico de dispersão e coletamos as legendas para os gráficos de densidade no topo do gráfico com & theme(legend.position = 'top'). Observe o uso do operador & aqui em vez do usual +. Isso ocorre porque estamos modificando o tema para o gráfico patchwork, ao contrário dos ggplots individuais. A legenda é colocada no topo, dentro do guide_area(). Por fim, também personalizamos as alturas dos vários componentes do nosso patchwork — o guia tem uma altura de 1, os boxplots 3, os gráficos de densidade 2 e o gráfico de dispersão facetado 4. O patchwork divide a área que você destinou para o seu gráfico usando essa escala e posiciona os componentes de acordo.
"
p1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")

p3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")

p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")

"
Se você quiser saber mais sobre como combinar e organizar vários gráficos com patchwork, recomendamos que você consulte os guias no site do pacote: https://patchwork.data-imaginist.com.
"

#Capítulo 11 : Comunicação----

#----11.1Introdução----
"
Anteriormente, você aprendeu a usar gráficos como ferramentas para exploração. Quando você faz gráficos exploratórios, você sabe — mesmo antes de olhar — quais variáveis o gráfico irá exibir. Você fez cada gráfico com um propósito, podia olhá-lo rapidamente e então passar para o próximo. No decorrer da maioria das análises, você produzirá dezenas ou centenas de gráficos, a maioria dos quais é descartada imediatamente.

Agora que você entende seus dados, precisa comunicar seu entendimento aos outros. Seu público provavelmente não compartilhará seu conhecimento de fundo e não estará profundamente investido nos dados. Para ajudar os outros a construir rapidamente um bom modelo mental dos dados, você precisará investir um esforço considerável para tornar seus gráficos o mais autoexplicativos possível. Neste capítulo, você aprenderá algumas das ferramentas que o ggplot2 fornece para fazer isso.

Este capítulo se concentra nas ferramentas necessárias para criar bons gráficos. Presumimos que você saiba o que quer e apenas precisa saber como fazer. Por essa razão, recomendamos fortemente que você leia este capítulo em conjunto com um bom livro geral sobre visualização. Gostamos particularmente de 'The Truthful Art', de Albert Cairo. Ele não ensina a mecânica de criar visualizações, mas se concentra no que você precisa pensar para criar gráficos eficazes.
"

#----11.1.1Pré-Requesitos----
"Focaremos novamente no ggplot2. Também usaremos um pouco de dplyr para manipulação de dados, scales para substituir as divisões, rótulos, transformações e paletas padrão, e alguns pacotes de extensão do ggplot2, incluindo ggrepel (https://ggrepel.slowkow.com) por Kamil Slowikowski e patchwork (https://patchwork.data-imaginist.com) por Thomas Lin Pedersen. Não se esqueça de que você precisará instalar esses pacotes com install.packages() se ainda não os tiver.
"
#install.packages("ggrepel")
#install.packages("patchwork")

library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)

#----11.2Rótulos----
"
O ponto de partida mais fácil ao transformar um gráfico exploratório em um gráfico expositivo é com bons rótulos. Você adiciona rótulos com a função labs().
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type",
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

"
O propósito de um título de gráfico é resumir a principal descoberta. Evite títulos que apenas descrevam o que o gráfico é, por exemplo,  Um gráfico de dispersão do deslocamento do motor versus economia de combustível.

Se você precisar adicionar mais texto, existem outros dois rótulos úteis: subtitle adiciona detalhes adicionais em uma fonte menor abaixo do título e caption adiciona texto no canto inferior direito do gráfico, muitas vezes usado para descrever a fonte dos dados. Você também pode usar labs() para substituir os títulos dos eixos e da legenda. Geralmente é uma boa ideia substituir nomes de variáveis curtas por descrições mais detalhadas e incluir as unidades.

É possível usar equações matemáticas em vez de strings de texto. Basta trocar as aspas por quote() e ler sobre as opções disponíveis em ?plotmath:
"
df <- tibble(
  x = 1:10,
  y = cumsum(x^2)
)

ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(x[i]),
    y = quote(sum(x[i] ^ 2, i == 1, n))
  )

#----11.3Anotações----
"
Além de rotular os componentes principais do seu gráfico, muitas vezes é útil rotular observações individuais ou grupos de observações. A primeira ferramenta que você tem à sua disposição é o geom_text(). O geom_text() é semelhante ao geom_point(), mas possui uma estética adicional: label. Isso torna possível adicionar rótulos textuais aos seus gráficos.

Existem duas possíveis fontes de rótulos. Primeiro, você pode ter uma tabela que fornece rótulos. No gráfico a seguir, destacamos os carros com o maior tamanho de motor em cada tipo de tração e salvamos suas informações como um novo quadro de dados chamado label_info.
"
label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |>
  select(displ, hwy, drv, drive_type)

label_info

"
Em seguida, usamos esse novo quadro de dados para rotular diretamente os três grupos para substituir a legenda por rótulos colocados diretamente no gráfico. Usando os argumentos fontface e size, podemos personalizar a aparência dos rótulos de texto. Eles são maiores que o restante do texto no gráfico e estão em negrito. (theme(legend.position = 'none') desativa todas as legendas — falaremos mais sobre isso em breve.)
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")

"
Observe o uso de hjust (justificação horizontal) e vjust (justificação vertical) para controlar o alinhamento do rótulo.

No entanto, o gráfico anotado que fizemos acima é difícil de ler porque os rótulos se sobrepõem uns aos outros e aos pontos. Podemos usar a função geom_label_repel() do pacote ggrepel para resolver ambos os problemas. Esse pacote útil ajustará automaticamente os rótulos para que eles não se sobreponham:
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

"
Você também pode usar a mesma ideia para destacar certos pontos em um gráfico com geom_text_repel() do pacote ggrepel. Observe outra técnica útil usada aqui: adicionamos uma segunda camada de pontos grandes e vazios para destacar ainda mais os pontos rotulados.
"
potential_outliers <- mpg |>
  filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text_repel(data = potential_outliers, aes(label = model)) +
  geom_point(data = potential_outliers, color = "red") +
  geom_point(
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )

"
Lembre-se, além de geom_text() e geom_label(), você tem muitos outros geoms no ggplot2 disponíveis para ajudar a anotar seu gráfico. Algumas ideias:
"
#1º Use geom_hline() e geom_vline() para adicionar linhas de referência. Muitas vezes as fazemos grossas (linewidth = 2) e brancas (color = white), e as desenhamos abaixo da camada de dados primários. Isso as torna fáceis de ver, sem desviar a atenção dos dados.
#2º Use geom_rect() para desenhar um retângulo em torno de pontos de interesse. Os limites do retângulo são definidos pelas estéticas xmin, xmax, ymin, ymax. Alternativamente, veja o pacote ggforce, especificamente geom_mark_hull(), que permite anotar subconjuntos de pontos com cascos.
#3º Use geom_segment() com o argumento arrow para chamar a atenção para um ponto com uma seta. Use as estéticas x e y para definir o local de início e xend e yend para definir o local de término.
"
Outra função útil para adicionar anotações aos gráficos é annotate(). Como regra geral, geoms geralmente são úteis para destacar um subconjunto dos dados, enquanto annotate() é útil para adicionar um ou poucos elementos de anotação a um gráfico.

Para demonstrar o uso de annotate(), vamos criar um texto para adicionar ao nosso gráfico. O texto é um pouco longo, então usaremos stringr::str_wrap() para adicionar automaticamente quebras de linha a ele, dado o número de caracteres que você deseja por linha:
"
trend_text <- "Larger engine sizes tend to have lower fuel economy." |>
  str_wrap(width = 30)
trend_text

"
Em seguida, adicionamos duas camadas de anotação: uma com um geom de rótulo e a outra com um geom de segmento. As estéticas x e y em ambos definem onde a anotação deve começar, e as estéticas xend e yend na anotação do segmento definem o local final do segmento. Observe também que o segmento é estilizado como uma seta.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )
"
A anotação é uma ferramenta poderosa para comunicar as principais conclusões e características interessantes de suas visualizações. O único limite é a sua imaginação (e sua paciência com o posicionamento das anotações para que sejam esteticamente agradáveis)!
"

#----11.4Escalas----
"
A terceira maneira de tornar seu gráfico melhor para comunicação é ajustar as escalas. As escalas controlam como as mapeamentos estéticos se manifestam visualmente.
"


#----11.4.1Escalas Padrão----
"
Normalmente, o ggplot2 adiciona automaticamente escalas para você. Por exemplo, ao digitar:
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

"
ggplot2 automaticamente adiciona escalas padrão nos bastidores:
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

"
Observe o esquema de nomenclatura para escalas: scale_ seguido pelo nome da estética, depois _, e então o nome da escala. As escalas padrão são nomeadas de acordo com o tipo de variável com a qual elas se alinham: contínuo, discreto, datetime ou date. scale_x_continuous() coloca os valores numéricos de displ em uma linha numérica contínua no eixo x, scale_color_discrete() escolhe cores para cada classe de carro, etc. Existem muitas escalas não padrão, que você aprenderá abaixo.

As escalas padrão foram cuidadosamente escolhidas para fazer um bom trabalho para uma ampla gama de entradas. No entanto, você pode querer substituir os padrões por dois motivos:
"
#1º Você pode querer ajustar alguns dos parâmetros da escala padrão. Isso permite que você faça coisas como alterar as quebras nos eixos ou as etiquetas das chaves na legenda.
#2º Você pode querer substituir a escala completamente e usar um algoritmo completamente diferente. Muitas vezes você pode fazer melhor do que o padrão porque sabe mais sobre os dados.

#----11.4.2Marcas de eixo e chaves de legenda----
"
Coletivamente, os eixos e legendas são chamados de guias. Os eixos são usados para estéticas x e y; legendas são usadas para todo o resto.

Existem dois argumentos principais que afetam a aparência das marcas nos eixos e as chaves na legenda: breaks e labels. Breaks controla a posição das marcas ou os valores associados às chaves. Labels controla o rótulo de texto associado a cada marca/chave. O uso mais comum de breaks é para substituir a escolha padrão:
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 

"
Você pode usar labels da mesma maneira (um vetor de caracteres do mesmo comprimento que breaks), mas também pode definir para NULL para suprimir completamente os rótulos. Isso pode ser útil para mapas ou para publicar gráficos onde você não pode compartilhar os números absolutos. Você também pode usar breaks e labels para controlar a aparência das legendas. Para escalas discretas de variáveis categóricas, labels pode ser uma lista nomeada dos nomes dos níveis existentes e os rótulos desejados para eles.
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))

"
O argumento labels, juntamente com as funções de rotulagem do pacote scales, também é útil para formatar números como moeda, porcentagem, etc. O gráfico à esquerda mostra a rotulagem padrão com label_dollar(), que adiciona um sinal de dólar, bem como uma vírgula separadora de milhares. O gráfico à direita adiciona mais personalização, dividindo os valores em dólares por 1.000 e adicionando o sufixo 'K' (para 'milhares'), bem como adicionando quebras personalizadas. Note que breaks está na escala original dos dados.  
"
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = label_dollar())

ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
  )

"
Outra função útil de rótulo é label_percent():
"
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = label_percent())

"
Outro uso de breaks é quando você tem relativamente poucos pontos de dados e quer destacar exatamente onde as observações ocorrem. Por exemplo, pegue este gráfico que mostra quando cada presidente dos EUA começou e terminou seu mandato.
"
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")

"
Observe que para o argumento breaks extraímos a variável start como um vetor com presidential$start porque não podemos fazer um mapeamento estético para este argumento. Observe também que a especificação de breaks e labels para escalas de data e datetime é um pouco diferente:
"
#1º date_labels recebe uma especificação de formato, na mesma forma que parse_datetime().
#2º date_breaks (não mostrado aqui), recebe uma string como "2 dias" ou "1 mês".

#----11.4.3Layout da legenda----
"
Você mais frequentemente usará breaks e labels para ajustar os eixos. Embora ambos também funcionem para legendas, existem algumas outras técnicas que você provavelmente usará.

Para controlar a posição geral da legenda, você precisa usar uma configuração de tema(). Voltaremos aos temas no final do capítulo, mas em resumo, eles controlam as partes não relacionadas aos dados do gráfico. A configuração do tema legend.position controla onde a legenda é desenhada:
"
base <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

base + theme(legend.position = "right") # the default
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") +
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 3))

"
Se o seu gráfico for curto e largo, coloque a legenda no topo ou na parte inferior, e se for alto e estreito, coloque a legenda à esquerda ou à direita. Você também pode usar legend.position = 'none' para suprimir completamente a exibição da legenda.

Para controlar a exibição de legendas individuais, use guides() juntamente com guide_legend() ou guide_colorbar(). O exemplo a seguir mostra duas configurações importantes: controlar o número de linhas que a legenda usa com nrow e substituir uma das estéticas para aumentar os pontos. Isso é particularmente útil se você usou um baixo alpha para exibir muitos pontos em um gráfico.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2, override.aes = list(size = 4)))

"
Observe que o nome do argumento em guides() corresponde ao nome da estética, assim como em labs().
"

#----11.4.4Substituindo uma escala----
"
Em vez de apenas ajustar os detalhes um pouco, você pode substituir a escala completamente. Existem dois tipos de escalas que você provavelmente desejará trocar: escalas de posição contínua e escalas de cor. Felizmente, os mesmos princípios se aplicam a todas as outras estéticas, então, uma vez que você tenha dominado posição e cor, será capaz de aprender rapidamente outras substituições de escala.

É muito útil traçar transformações de sua variável. Por exemplo, é mais fácil ver a relação precisa entre quilate e preço se os transformarmos em log:
"
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d()

ggplot(diamonds, aes(x = log10(carat), y = log10(price))) +
  geom_bin2d()

"
No entanto, a desvantagem dessa transformação é que os eixos agora são rotulados com os valores transformados, dificultando a interpretação do gráfico. Em vez de fazer a transformação no mapeamento estético, podemos, em vez disso, fazê-lo com a escala. Isso é visualmente idêntico, exceto que os eixos são rotulados na escala dos dados originais.
"
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

"
Outra escala que é frequentemente personalizada é a cor. A escala categórica padrão escolhe cores que estão igualmente espaçadas ao redor da roda de cores. Alternativas úteis são as escalas ColorBrewer, que foram ajustadas manualmente para funcionar melhor para pessoas com tipos comuns de daltonismo. Os dois gráficos abaixo parecem semelhantes, mas há diferença suficiente nas tonalidades de vermelho e verde que os pontos à direita podem ser distinguidos mesmo por pessoas com daltonismo vermelho-verde.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")

"
Não se esqueça de técnicas mais simples para melhorar a acessibilidade. Se houver apenas algumas cores, você pode adicionar um mapeamento de forma redundante. Isso também ajudará a garantir que seu gráfico seja interpretável em preto e branco.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

"
As escalas ColorBrewer estão documentadas online em 
https://colorbrewer2.org/ e disponíveis em R por meio do pacote RColorBrewer, de Erich Neuwirth. As paletas sequenciais (topo) e divergentes (fundo) são particularmente úteis se seus valores categóricos forem ordenados ou tiverem um 'meio'. Isso geralmente surge se você usou cut() para transformar uma variável contínua em uma variável categórica.

Quando você tem um mapeamento predefinido entre valores e cores, use scale_color_manual(). Por exemplo, se mapearmos o partido presidencial para a cor, queremos usar o mapeamento padrão de vermelho para Republicanos e azul para Democratas. Uma abordagem para atribuir essas cores é usar códigos de cores hexadecimais:
"
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))

"
Outra opção é usar as escalas de cores viridis. Os designers, Nathaniel Smith e Stéfan van der Walt, adaptaram cuidadosamente esquemas de cores contínuas que são perceptíveis para pessoas com várias formas de daltonismo, bem como perceptivelmente uniformes tanto em cores quanto em preto e branco. Essas escalas estão disponíveis como paletas contínuas (c), discretas (d) e agrupadas (b) no ggplot2.
"
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c() +
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, binned", x = NULL, y = NULL)
"
Observe que todas as escalas de cores vêm em duas variedades: scale_color_() e scale_fill_() para as estéticas de cor e preenchimento, respectivamente (as escalas de cores estão disponíveis tanto em ortografias do Reino Unido quanto dos EUA).
"

#----11.4.5Zoom----
"
Existem três maneiras de controlar os limites do gráfico:
"
#1º Ajustando quais dados são plotados.
#2º Definindo os limites em cada escala.
#3º Definindo xlim e ylim em coord_cartesian().

"
Demonstraremos essas opções em uma série de gráficos. O gráfico à esquerda mostra a relação entre o tamanho do motor e a eficiência de combustível, colorido pelo tipo de tração. O gráfico à direita mostra as mesmas variáveis, mas subconjuntos dos dados que são plotados. A subdefinição dos dados afetou as escalas x e y, bem como a curva suave.
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

mpg |>
  filter(displ >= 5 & displ <= 6 & hwy >= 10 & hwy <= 25) |>
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

"
Vamos comparar estes com os dois gráficos abaixo, onde o gráfico à esquerda define os limites em escalas individuais e o gráfico à direita os define em coord_cartesian(). Podemos ver que reduzir os limites é equivalente a subconjuntar os dados. Portanto, para ampliar uma região do gráfico, geralmente é melhor usar coord_cartesian().
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  scale_x_continuous(limits = c(5, 6)) +
  scale_y_continuous(limits = c(10, 25))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 6), ylim = c(10, 25))
"
Por outro lado, definir os limites em escalas individuais geralmente é mais útil se você quiser expandir os limites, por exemplo, para combinar escalas entre diferentes gráficos. Por exemplo, se extraímos duas classes de carros e os plotamos separadamente, é difícil comparar os gráficos porque todas as três escalas (o eixo x, o eixo y e a estética de cor) têm diferentes intervalos.
"
suv <- mpg |> filter(class == "suv")
compact <- mpg |> filter(class == "compact")

ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

"
Uma maneira de superar esse problema é compartilhar escalas entre vários gráficos, ajustando as escalas com os limites dos dados completos.
"
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale
"
Neste caso particular, você poderia simplesmente ter usado facetas, mas essa técnica é útil de forma mais geral, por exemplo, se você quiser espalhar gráficos por várias páginas de um relatório. Isso ajuda a garantir que as comparações entre os gráficos sejam válidas e que as diferenças observadas sejam devido às diferenças nos dados, não às diferenças arbitrárias nas escalas dos gráficos. Compartilhar escalas é crucial quando o objetivo é fazer comparações diretas entre diferentes subconjuntos dos dados.
"

#----11.5Temas----
"
Finalmente, você pode personalizar os elementos não relacionados aos dados do seu gráfico com um tema:
"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()

"
O ggplot2 inclui os oito temas , sendo theme_gray() o padrão. Muitos mais estão incluídos em pacotes adicionais como ggthemes (https://jrnold.github.io/ggthemes), de Jeffrey Arnold. Você também pode criar seus próprios temas, se estiver tentando corresponder a um estilo corporativo ou de jornal específico.

Também é possível controlar componentes individuais de cada tema, como o tamanho e a cor da fonte usada para o eixo y. Já vimos que legend.position controla onde a legenda é desenhada. Há muitos outros aspectos da legenda que podem ser personalizados com theme(). Por exemplo, no gráfico abaixo, mudamos a direção da legenda e colocamos uma borda preta ao redor dela. Observe que a personalização da caixa de legenda e dos elementos do título do gráfico do tema é feita com funções element_*(). Essas funções especificam o estilo dos componentes não relacionados aos dados, por exemplo, o texto do título é colocado em negrito no argumento face de element_text() e a cor da borda da legenda é definida no argumento color de element_rect(). Os elementos do tema que controlam a posição do título e da legenda são plot.title.position e plot.caption.position, respectivamente. No gráfico a seguir, estes são definidos como 'plot' para indicar que esses elementos estão alinhados a toda a área do gráfico, em vez do painel do gráfico (o padrão). Alguns outros componentes úteis de theme() são usados para alterar a colocação e o formato do texto do título e da legenda.
"
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  labs(
    title = "Larger engine sizes tend to have lower fuel economy",
    caption = "Source: https://fueleconomy.gov."
  ) +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )
"
Para uma visão geral de todos os componentes de theme(), veja a ajuda com ?theme. O livro ggplot2 também é um ótimo lugar para ir para os detalhes completos sobre temas.
"

#----11.6Layout----
"
Até agora, falamos sobre como criar e modificar um único gráfico. E se você tiver vários gráficos que deseja organizar de uma certa maneira? O pacote patchwork permite combinar gráficos separados no mesmo gráfico. Carregamos este pacote anteriormente no capítulo.

Para colocar dois gráficos lado a lado, você pode simplesmente adicioná-los um ao outro. Observe que você primeiro precisa criar os gráficos e salvá-los como objetos (no exemplo a seguir, eles são chamados de p1 e p2). Então, você os coloca lado a lado com +.
"
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p1 + p2

"
É importante notar que no trecho de código acima, não usamos uma nova função do pacote patchwork. Em vez disso, o pacote adicionou uma nova funcionalidade ao operador +.

Você também pode criar layouts complexos de gráficos com patchwork. No seguinte, | coloca p1 e p3 um ao lado do outro e / move p2 para a próxima linha.
"
p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
(p1 | p3) / p2

"
Além disso, o patchwork permite que você colete legendas de vários gráficos em uma legenda comum, personalize a colocação da legenda, bem como as dimensões dos gráficos, e adicione um título comum, subtítulo, legenda, etc. aos seus gráficos. Abaixo, criamos 5 gráficos. Desativamos as legendas nos boxplots e no gráfico de dispersão e coletamos as legendas para os gráficos de densidade no topo do gráfico com & theme(legend.position = 'top'). Observe o uso do operador & aqui em vez do usual +. Isso ocorre porque estamos modificando o tema para o gráfico patchwork, ao contrário dos ggplots individuais. A legenda é colocada no topo, dentro do guide_area(). Por fim, também personalizamos as alturas dos vários componentes do nosso patchwork — o guia tem uma altura de 1, os boxplots 3, os gráficos de densidade 2 e o gráfico de dispersão facetado 4. O patchwork divide a área que você destinou para o seu gráfico usando essa escala e posiciona os componentes de acordo.
"
p1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")

p3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")

p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")

"
Se você quiser saber mais sobre como combinar e organizar vários gráficos com patchwork, recomendamos que você consulte os guias no site do pacote: https://patchwork.data-imaginist.com.
"



#Capítulo 12 : Vetores Lógicos----

#----12.1Introdução----
"
Neste capítulo, você aprenderá ferramentas para trabalhar com vetores lógicos. Vetores lógicos são o tipo mais simples de vetor porque cada elemento só pode ser um de três valores possíveis: TRUE, FALSE e NA. É relativamente raro encontrar vetores lógicos nos seus dados brutos, mas você os criará e manipulará no decorrer de quase todas as análises.

Começaremos discutindo a maneira mais comum de criar vetores lógicos: com comparações numéricas. Então você aprenderá como pode usar a álgebra booleana para combinar diferentes vetores lógicos, bem como alguns resumos úteis. Terminaremos com if_else() e case_when(), duas funções úteis para fazer mudanças condicionais impulsionadas por vetores lógicos.
"

#----12.1.1Pré-requisitos----
"
A maioria das funções que você aprenderá neste capítulo é fornecida pelo R base, então não precisamos do tidyverse, mas ainda o carregaremos para que possamos usar mutate(), filter() e amigos para trabalhar com data frames. Também continuaremos a usar exemplos do conjunto de dados nycflights13::flights.
"
library(tidyverse)
library(nycflights13)
nycflights13::flights

"
No entanto, à medida que começamos a cobrir mais ferramentas, nem sempre haverá um exemplo real perfeito. Então, começaremos a criar alguns dados fictícios com c():
"
x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2

"
Isso facilita a explicação de funções individuais, mas torna mais difícil ver como elas podem se aplicar aos seus problemas de dados. Lembre-se apenas de que qualquer manipulação que fazemos em um vetor livre, você pode fazer em uma variável dentro de um data frame com mutate() e amigos.
"
df <- tibble(x)
df |> 
  mutate(y = x * 2)


#----12.2Comparação----
"
Uma maneira muito comum de criar um vetor lógico é através de uma comparação numérica com <, <=, >, >=, != e ==. Até agora, criamos variáveis lógicas principalmente de forma transitória dentro de filter() — elas são calculadas, usadas e depois descartadas. Por exemplo, o seguinte filtro encontra todas as partidas diurnas que chegam aproximadamente no horário:
"
flights |> 
  filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)

"
É útil saber que isso é um atalho e você pode criar explicitamente as variáveis lógicas subjacentes com mutate():
"
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  )

"
Isso é particularmente útil para lógicas mais complicadas porque nomear as etapas intermediárias facilita tanto a leitura do seu código quanto a verificação de que cada etapa foi calculada corretamente.

No total, o filtro inicial é equivalente a:
"
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
  ) |> 
  filter(daytime & approx_ontime)

#----12.2.1Comparação de ponto flutuante----
"
Tenha cuidado ao usar == com números. Por exemplo, parece que este vetor contém os números 1 e 2:
"
x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x

"
Mas se você testá-los para igualdade, você obtém FALSE:
"
x == c(1, 2)

"
O que está acontecendo? Computadores armazenam números com um número fixo de casas decimais, então não há como representar exatamente 1/49 ou sqrt(2) e cálculos subsequentes serão ligeiramente diferentes. Podemos ver os valores exatos chamando print() com o argumento digits:
"
print(x, digits = 16)

"
Você pode ver por que o R padrão para arredondar esses números; eles realmente estão muito próximos do que você espera.

Agora que você viu por que == está falhando, o que você pode fazer a respeito? Uma opção é usar dplyr::near(), que ignora pequenas diferenças:
"
near(x, c(1, 2))


#----12.2.2Valores ausentes----
"
Valores ausentes representam o desconhecido, então eles são 'contagiosos': quase qualquer operação envolvendo um valor desconhecido também será desconhecida:
"
NA > 5
10 == NA

"
O resultado mais confuso é este:
"
NA == NA

"
É mais fácil entender por que isso é verdadeiro se fornecermos artificialmente um pouco mais de contexto:
"
# We don't know how old Mary is
age_mary <- NA

# We don't know how old John is
age_john <- NA

# Are Mary and John the same age?
age_mary == age_john
# We don't know!

"
Então, se você quiser encontrar todos os voos em que dep_time está ausente, o seguinte código não funcionará porque dep_time == NA resultará em NA para cada linha, e filter() automaticamente descarta valores ausentes:
"
flights |> 
  filter(dep_time == NA)

"
Em vez disso, precisaremos de uma nova ferramenta: is.na().
"
#----12.2.3 is.na()----
"
is.na(x) funciona com qualquer tipo de vetor e retorna TRUE para valores ausentes e FALSE para tudo o mais:
"
is.na(c(TRUE, NA, FALSE))
is.na(c(1, NA, 3))
is.na(c("a", NA, "b"))

"
Podemos usar is.na() para encontrar todas as linhas com um dep_time ausente:
"
flights |> 
  filter(is.na(dep_time))

"
is.na() também pode ser útil em arrange(). arrange() geralmente coloca todos os valores ausentes no final, mas você pode substituir esse padrão primeiro ordenando por is.na():
"
flights |> 
  filter(month == 1, day == 1) |> 
  arrange(dep_time)

flights |> 
  filter(month == 1, day == 1) |> 
  arrange(desc(is.na(dep_time)), dep_time)


#----12.3Álgebra booleana----
"
Uma vez que você tem múltiplos vetores lógicos, pode combiná-los usando álgebra booleana. Em R, & é 'e', | é 'ou', ! é 'não', e xor() é ou exclusivo. Por exemplo, df |> filter(!is.na(x)) encontra todas as linhas onde x não está ausente e df |> filter(x < -10 | x > 0) encontra todas as linhas onde x é menor que -10 ou maior que 0.

Além de & e |, R também tem && e ||. Não os use em funções dplyr! Esses são chamados de operadores de curto-circuito e sempre retornam apenas um TRUE ou FALSE. Eles são importantes para programação, não para ciência de dados.
"
#----12.3.1-Valores ausentes----
"
As regras para valores ausentes em álgebra booleana são um pouco complicadas de explicar porque parecem inconsistentes à primeira vista:"
df <- tibble(x = c(TRUE, FALSE, NA))

df |> 
  mutate(
    and = x & NA,
    or = x | NA
  )

"
Para entender o que está acontecendo, pense em NA | TRUE (NA ou TRUE). Um valor ausente em um vetor lógico significa que o valor pode ser TRUE ou FALSE. TRUE | TRUE e FALSE | TRUE são ambos TRUE porque pelo menos um deles é TRUE. NA | TRUE também deve ser TRUE porque NA pode ser TRUE ou FALSE. No entanto, NA | FALSE é NA porque não sabemos se NA é TRUE ou FALSE. Um raciocínio semelhante se aplica com NA & FALSE.
"

#----12.3.2Ordem das operações----
"
Note que a ordem das operações em R não funciona como em inglês. Pegue o seguinte código que encontra todos os voos que partiram em novembro ou dezembro:
"
flights |> 
  filter(month == 11 | month == 12)

"
Você pode ser tentado a escrevê-lo como diria em inglês: 'Encontre todos os voos que partiram em novembro ou dezembro.':
"
flights |> 
  filter(month == 11 | 12)

"
Este código não dá erro, mas também não parece ter funcionado. O que está acontecendo? Aqui, R primeiro avalia month == 11, criando um vetor lógico, que chamamos de nov. Ele calcula nov | 12. Quando você usa um número com um operador lógico, ele converte tudo, exceto 0, para TRUE, então isso é equivalente a nov | TRUE, o que sempre será TRUE, então cada linha será selecionada:
"
flights |> 
  mutate(
    nov = month == 11,
    final = nov | 12,
    .keep = "used"
  )

#----12.3.3%in%----
"
Uma maneira fácil de evitar o problema de colocar seus ==s e |s na ordem certa é usar %in%. x %in% y retorna um vetor lógico do mesmo comprimento que x, que é TRUE sempre que um valor em x estiver em qualquer lugar em y.
"
1:12 %in% c(1, 5, 11)

"
Então, para encontrar todos os voos em novembro e dezembro, poderíamos escrever:
"
flights |> 
  filter(month %in% c(11, 12))

"
Observe que %in% segue regras diferentes para NA do que ==, pois NA %in% NA é TRUE.
"
c(1, 2, NA) == NA
c(1, 2, NA) %in% NA

"
Isso pode ser um atalho útil:
"
flights |> 
  filter(dep_time %in% c(NA, 0800))


#----12.4Resumos----
"
As seções a seguir descrevem algumas técnicas úteis para resumir vetores lógicos. Além das funções que funcionam especificamente com vetores lógicos, você também pode usar funções que funcionam com vetores numéricos.
"

#----12.4.1Resumos lógicos----
"
Existem dois principais resumos lógicos: any() e all(). any(x) é equivalente a |; ele retornará TRUE se houver algum TRUE em x. all(x) é equivalente a &; ele retornará TRUE apenas se todos os valores de x forem TRUE. Como todas as funções de resumo, eles retornarão NA se houver quaisquer valores ausentes presentes, e, como de costume, você pode fazer os valores ausentes desaparecerem com na.rm = TRUE.

Por exemplo, poderíamos usar all() e any() para descobrir se todos os voos foram atrasados na partida por no máximo uma hora ou se algum voo foi atrasado na chegada por cinco horas ou mais. E usando group_by() nos permite fazer isso por dia:
"

flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

"
Na maioria dos casos, no entanto, any() e all() são um pouco grosseiros, e seria bom poder obter um pouco mais de detalhes sobre quantos valores são TRUE ou FALSE. Isso nos leva aos resumos numéricos.
"

#----12.4.2Resumos numéricos de vetores lógicos----
"
Quando você usa um vetor lógico em um contexto numérico, TRUE se torna 1 e FALSE se torna 0. Isso torna sum() e mean() muito úteis com vetores lógicos porque sum(x) dá o número de TRUEs e mean(x) dá a proporção de TRUEs (porque mean() é apenas sum() dividido por length()).

Isso, por exemplo, nos permite ver a proporção de voos que foram atrasados na partida por no máximo uma hora e o número de voos que foram atrasados na chegada por cinco horas ou mais:
"

flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = mean(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = sum(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

#----12.4.3Subconjunto lógico----
"
Há um uso final para vetores lógicos em resumos: você pode usar um vetor lógico para filtrar uma única variável para um subconjunto de interesse. Isso faz uso do operador base [ (pronunciado como subset).

Imagine que queremos olhar para o atraso médio apenas para voos que realmente foram atrasados. Uma maneira de fazer isso seria primeiro filtrar os voos e depois calcular o atraso médio:
"
flights |> 
  filter(arr_delay > 0) |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay),
    n = n(),
    .groups = "drop"
  )

"
Isso funciona, mas e se quiséssemos também calcular o atraso médio para voos que chegaram cedo? Precisaríamos realizar uma etapa de filtro separada e depois descobrir como combinar os dois data frames. Em vez disso, você poderia usar [ para realizar um filtro inline: arr_delay[arr_delay > 0] fornecerá apenas os atrasos de chegada positivos.

Isso leva a:
"
flights |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay[arr_delay > 0], na.rm = TRUE),
    ahead = mean(arr_delay[arr_delay < 0], na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

"
Também observe a diferença no tamanho do grupo: no primeiro bloco, n() dá o número de voos atrasados por dia; no segundo, n() dá o número total de voos.
"
#----12.5Transformações condicionais----
"
Uma das características mais poderosas dos vetores lógicos é o seu uso para transformações condicionais, ou seja, fazer uma coisa para a condição x e algo diferente para a condição y. Há duas ferramentas importantes para isso: if_else() e case_when().
"

#----12.5.1if_else()----
"
Se você deseja usar um valor quando uma condição é TRUE e outro valor quando é FALSE, pode usar dplyr::if_else(). Você sempre usará os três primeiros argumentos de if_else(). O primeiro argumento, condition, é um vetor lógico, o segundo, true, dá a saída quando a condição é verdadeira, e o terceiro, false, dá a saída se a condição for falsa.

Vamos começar com um exemplo simples de rotular um vetor numérico como “+ve” (positivo) ou “-ve” (negativo):
"
x <- c(-3:3, NA)
if_else(x > 0, "+ve", "-ve")

"
Há um quarto argumento opcional, missing, que será usado se a entrada for NA:
"
if_else(x > 0, "+ve", "-ve", "???")

"
Você também pode usar vetores para os argumentos true e false. Por exemplo, isso nos permite criar uma implementação mínima de abs():
"
if_else(x < 0, -x, x)

"
Até agora, todos os argumentos usaram os mesmos vetores, mas você pode, claro, misturar e combinar. Por exemplo, você poderia implementar uma versão simples de coalesce() assim:
"
x1 <- c(NA, 1, 2, NA)
y1 <- c(3, NA, 4, 6)
if_else(is.na(x1), y1, x1)

"
Você pode ter notado uma pequena imprecisão no nosso exemplo de rotulação acima: zero não é positivo nem negativo. Poderíamos resolver isso adicionando um if_else() adicional:
"
if_else(x == 0, "0", if_else(x < 0, "-ve", "+ve"), "???")

"
Isso já é um pouco difícil de ler, e você pode imaginar que só ficaria mais difícil se você tiver mais condições. Em vez disso, você pode mudar para dplyr::case_when().
"

#----12.5.2case_when()----
"
O case_when() do dplyr é inspirado pela instrução CASE do SQL e fornece uma maneira flexível de realizar diferentes cálculos para diferentes condições. Ele tem uma sintaxe especial que, infelizmente, não se parece com nada que você usará no tidyverse. Ele recebe pares que parecem com condição ~ saída. A condição deve ser um vetor lógico; quando for TRUE, a saída será usada.

Isso significa que poderíamos recriar nosso if_else() aninhado anterior como segue:
"
x <- c(-3:3, NA)
case_when(
  x == 0   ~ "0",
  x < 0    ~ "-ve", 
  x > 0    ~ "+ve",
  is.na(x) ~ "???"
)

"
Isso é mais código, mas também é mais explícito.

Para explicar como o case_when() funciona, vamos explorar alguns casos mais simples. Se nenhum dos casos corresponder, a saída receberá um NA:
"
case_when(
  x < 0 ~ "-ve",
  x > 0 ~ "+ve"
)

"
Use .default se você quiser criar um valor 'padrão'/de captura para todos:
"
case_when(
  x < 0 ~ "-ve",
  x > 0 ~ "+ve",
  .default = "???"
)

"
E note que, se várias condições corresponderem, apenas a primeira será usada:
"
case_when(
  x > 0 ~ "+ve",
  x > 2 ~ "big"
)

"
Assim como com if_else(), você pode usar variáveis em ambos os lados do ~ e pode misturar e combinar variáveis conforme necessário para o seu problema. Por exemplo, poderíamos usar case_when() para fornecer alguns rótulos legíveis para o atraso na chegada:
"
flights |> 
  mutate(
    status = case_when(
      is.na(arr_delay)      ~ "cancelled",
      arr_delay < -30       ~ "very early",
      arr_delay < -15       ~ "early",
      abs(arr_delay) <= 15  ~ "on time",
      arr_delay < 60        ~ "late",
      arr_delay < Inf       ~ "very late",
    ),
    .keep = "used"
  )

"
Tenha cuidado ao escrever esse tipo de instrução complexa case_when(); em minhas duas primeiras tentativas, usei uma mistura de < e > e acidentalmente criei condições sobrepostas.
"

#----12.5.3Tipos compatíveis----
"
Observe que tanto if_else() quanto case_when() requerem tipos compatíveis na saída. Se eles não forem compatíveis, você verá erros como este:
"
if_else(TRUE, "a", 1)

case_when(
  x < -1 ~ TRUE,  
  x > 0  ~ now()
)

"
No geral, relativamente poucos tipos são compatíveis, porque converter automaticamente um tipo de vetor para outro é uma fonte comum de erros. Aqui estão os casos mais importantes que são compatíveis:
"
#1º etores numéricos e lógicos são compatíveis, como discutimos anteriormente
#2º Strings e fatores são compatíveis, porque você pode pensar em um fator como uma string com um conjunto restrito de valores.
#3º Datas e horários são compatíveis porque você pode pensar em uma data como um caso especial de data e hora.
#4º NA, que tecnicamente é um vetor lógico, é compatível com tudo porque todo vetor tem alguma forma de representar um valor ausente.

"
Não esperamos que você memorize essas regras, mas elas devem se tornar uma segunda natureza com o tempo porque são aplicadas consistentemente em todo o tidyverse.
"

#Capítulo 13 : Números----

#----13.1Introdução----
"
Vetores numéricos são a espinha dorsal da ciência de dados, e você já os usou várias vezes anteriormente no livro. Agora é hora de fazer uma revisão sistemática do que você pode fazer com eles em R, garantindo que você esteja bem preparado para enfrentar qualquer problema futuro envolvendo vetores numéricos.

Começaremos fornecendo algumas ferramentas para criar números a partir de strings e, em seguida, entraremos em mais detalhes sobre a função count(). Depois mergulharemos em várias transformações numéricas que combinam bem com mutate(), incluindo transformações mais gerais que podem ser aplicadas a outros tipos de vetores, mas que são frequentemente usadas com vetores numéricos. Concluiremos cobrindo as funções de resumo que combinam bem com summarize() e mostraremos como elas também podem ser usadas com mutate().
"

#----13.1.1Pré-requisitos----
"
Este capítulo utiliza principalmente funções do R base, que estão disponíveis sem a necessidade de carregar quaisquer pacotes. Mas ainda precisamos do tidyverse, pois usaremos essas funções do R base dentro de funções do tidyverse como mutate() e filter(). Como no último capítulo, usaremos exemplos reais do nycflights13, bem como exemplos fictícios criados com c() e tribble().
"

library(tidyverse)
library(nycflights13)
#----13.2Criando Números----
"
Na maioria dos casos, você receberá números já registrados em um dos tipos numéricos do R: inteiro ou duplo. No entanto, em alguns casos, você os encontrará como strings, possivelmente porque os criou ao pivotar de cabeçalhos de colunas ou porque algo deu errado no seu processo de importação de dados.

O pacote readr oferece duas funções úteis para converter strings em números: parse_double() e parse_number(). Use parse_double() quando tiver números que foram escritos como strings:
"
x <- c("1.2", "5.6", "1e3")
parse_double(x)

"
Use parse_number() quando a string contiver texto não numérico que você deseja ignorar. Isso é particularmente útil para dados de moeda e porcentagens:
"
x <- c("$1,234", "USD 3,513", "59%")
parse_number(x)

#----13.3Contagens----
"
É surpreendente quanto da ciência de dados você pode fazer apenas com contagens e um pouco de aritmética básica, então o dplyr se esforça para tornar a contagem o mais fácil possível com count(). Essa função é ótima para exploração rápida e verificações durante a análise:
"
flights |> count(dest)

"
Apesar do conselho visto anteriormente, geralmente colocamos count() em uma única linha porque é frequentemente usado no console para uma rápida verificação de que um cálculo está funcionando conforme o esperado.

Se você quiser ver os valores mais comuns, adicione sort = TRUE:
"
flights |> count(dest, sort = TRUE)

"
E lembre-se de que, se você quiser ver todos os valores, pode usar |> View() ou |> print(n = Inf).

Você pode realizar o mesmo cálculo 'manualmente' com group_by(), summarize() e n(). Isso é útil porque permite que você compute outros resumos ao mesmo tempo:
"
flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )

"
n() é uma função especial de resumo que não recebe argumentos e, em vez disso, acessa informações sobre o 'grupo atual'. Isso significa que só funciona dentro dos verbos dplyr:
"
n()

"
Existem algumas variantes de n() e count() que você pode achar úteis:
"
#1º n_distinct(x) conta o número de valores distintos (únicos) de uma ou mais variáveis. Por exemplo, poderíamos descobrir quais destinos são servidos pelo maior número de transportadoras:
flights |> 
  group_by(dest) |> 
  summarize(carriers = n_distinct(carrier)) |> 
  arrange(desc(carriers))

#2º Uma contagem ponderada é uma soma. Por exemplo, você poderia "contar" o número de milhas que cada avião voou:
flights |> 
  group_by(tailnum) |> 
  summarize(miles = sum(distance))
#Contagens ponderadas são um problema comum, então count() tem um argumento wt que faz a mesma coisa:
flights |> count(tailnum, wt = distance)

#3º Você pode contar valores ausentes combinando sum() e is.na(). No conjunto de dados de voos, isso representa voos que são cancelados:
flights |> 
  group_by(dest) |> 
  summarize(n_cancelled = sum(is.na(dep_time))) 

#----13.4Tranformações Numéricas----
"
As funções de transformação funcionam bem com mutate() porque sua saída tem o mesmo comprimento que a entrada. A grande maioria das funções de transformação já está integrada ao R base. É impraticável listar todas, então esta seção mostrará as mais úteis. Por exemplo, embora o R forneça todas as funções trigonométricas que você possa imaginar, não as listamos aqui porque raramente são necessárias para ciência de dados.
"

#----13.4.1Regras de Aritméticas e Reciclagem----
"
Nós introduzimos os conceitos básicos de aritmética (+, -, *, /, ^) anetriormente e os usamos bastante desde então. Essas funções não precisam de muita explicação porque fazem o que você aprendeu na escola. Mas precisamos falar brevemente sobre as regras de reciclagem, que determinam o que acontece quando os lados esquerdo e direito têm comprimentos diferentes. Isso é importante para operações como flights |> mutate(air_time = air_time / 60) porque há 336.776 números à esquerda de / mas apenas um à direita.

O R lida com comprimentos diferentes reciclando, ou repetindo, o vetor mais curto. Podemos ver isso em operação mais facilmente se criarmos alguns vetores fora de um data frame:
"
x <- c(1, 2, 10, 20)
x / 5
x / c(5, 5, 5, 5)

"
Geralmente, você só quer reciclar números únicos (ou seja, vetores de comprimento 1), mas o R reciclará qualquer vetor de comprimento mais curto. Geralmente (mas nem sempre) ele emite um aviso se o vetor mais longo não for um múltiplo do mais curto:
"
x * c(1, 2)
x * c(1, 2, 3)

"
Essas regras de reciclagem também são aplicadas a comparações lógicas (==, <, <=, >, >=, !=) e podem levar a um resultado surpreendente se você acidentalmente usar == em vez de %in% e o data frame tiver um número infeliz de linhas. Por exemplo, pegue este código que tenta encontrar todos os voos em janeiro e fevereiro:
"
flights |> 
  filter(month == c(1, 2))

"
O código é executado sem erro, mas não retorna o que você deseja. Devido às regras de reciclagem, ele encontra voos em linhas de número ímpar que partiram em janeiro e voos em linhas de número par que partiram em fevereiro. E infelizmente não há aviso porque o data frame tem um número par de linhas.

Para protegê-lo desse tipo de falha silenciosa, a maioria das funções do tidyverse usa uma forma mais rigorosa de reciclagem que recicla apenas valores únicos. Infelizmente isso não ajuda aqui, ou em muitos outros casos, porque o cálculo chave é realizado pela função base R ==, não por filter().
"

#----13.4.2Mínimo e Máximo----
"
As funções aritméticas trabalham com pares de variáveis. Duas funções intimamente relacionadas são pmin() e pmax(), que, quando recebem duas ou mais variáveis, retornarão o menor ou maior valor em cada linha:
"
df <- tribble(
  ~x, ~y,
  1,  3,
  5,  2,
  7, NA,
)

df |> 
  mutate(
    min = pmin(x, y, na.rm = TRUE),
    max = pmax(x, y, na.rm = TRUE)
  )

"
Note que essas são diferentes das funções de resumo min() e max() que recebem múltiplas observações e retornam um único valor. Você pode perceber que usou a forma errada quando todos os mínimos e todos os máximos têm o mesmo valor:
"
df |> 
  mutate(
    min = min(x, y, na.rm = TRUE),
    max = max(x, y, na.rm = TRUE)
  )

#----13.4.3Aritmética Modular----
"
Aritmética modular é o nome técnico para o tipo de matemática que você fazia antes de aprender sobre casas decimais, ou seja, divisão que resulta em um número inteiro e um resto. No R, %/% realiza a divisão inteira e %% calcula o resto:
"
1:10 %/% 3
1:10 %% 3

"
A aritmética modular é útil para o conjunto de dados de voos, porque podemos usá-la para desempacotar a variável sched_dep_time em hora e minuto:
"
flights |> 
  mutate(
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100,
    .keep = "used"
  )

"
Podemos combinar isso com o truque mean(is.na(x)) para ver como a proporção de voos cancelados varia ao longo do dia.
"
flights |> 
  group_by(hour = sched_dep_time %/% 100) |> 
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  filter(hour > 1) |> 
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") + 
  geom_point(aes(size = n))

#----13.4.4Logaritmos----
"
Os logaritmos são uma transformação incrivelmente útil para lidar com dados que variam em várias ordens de magnitude e para converter crescimento exponencial em crescimento linear. No R, você tem a escolha de três logaritmos: log() (o logaritmo natural, base e), log2() (base 2) e log10() (base 10). Recomendamos usar log2() ou log10(). log2() é fácil de interpretar porque uma diferença de 1 na escala logarítmica corresponde a dobrar na escala original e uma diferença de -1 corresponde a dividir pela metade; enquanto log10() é fácil de reverter porque (por exemplo) 3 é 10^3 = 1000. O inverso de log() é exp(); para calcular o inverso de log2() ou log10() você precisará usar 2^ ou 10^.
"

#----13.4.5Arredondamento----
"
Use round(x) para arredondar um número para o inteiro mais próximo:
"
round(123.456)

"
Você pode controlar a precisão do arredondamento com o segundo argumento, digits. round(x, digits) arredonda para o mais próximo de 10^-n, então digits = 2 arredondará para o mais próximo de 0,01. Esta definição é útil porque implica que round(x, -3) arredondará para o milhar mais próximo, o que de fato faz:
"
round(123.456, 2)  # duas casas decimais
round(123.456, 1)  # uma casa decimal
round(123.456, -1) # para a dezena mais próxima
round(123.456, -2) # para a centana mais próxima

"
Há uma peculiaridade com round() que parece surpreendente à primeira vista:
"
round(c(1.5, 2.5))

"
round() usa o que é conhecido como 'arredondamento para o meio par' ou arredondamento bancário: se um número estiver exatamente no meio de dois inteiros, será arredondado para o inteiro par mais próximo. Essa é uma boa estratégia porque mantém o arredondamento imparcial: metade de todos os 0,5s são arredondados para cima e a outra metade para baixo.

round() é complementado por floor() que sempre arredonda para baixo e ceiling() que sempre arredonda para cima:
"
x <- 123.456

floor(x)
ceiling(x)

"
Essas funções não têm um argumento de digits, então, em vez disso, você pode escalar para baixo, arredondar e, em seguida, escalar de volta:
"
#arredondar para baixo até os dois dígitos mais próximos:
floor(x / 0.01) * 0.01
#arredondar para cima até os dois dígitos mais próximos:
ceiling(x / 0.01) * 0.01

"
Você pode usar a mesma técnica se quiser round() para um múltiplo de algum outro número:
"
#Arredondar para o múltiplo de 4 mais próximo:
round(x / 4) * 4
#Arredondar para o 0.25 mais próximo:
round(x / 0.25) * 0.25

#----13.4.6Dividindo Números em Intervalos----
"
Use cut() para dividir (ou 'binarizar') um vetor numérico em intervalos discretos:
"
x <- c(1, 2, 5, 10, 15, 20)
cut(x, breaks = c(0, 5, 10, 15, 20))

"
Os intervalos não precisam ser igualmente espaçados:
"
cut(x, breaks = c(0, 5, 10, 100))

"
Você pode opcionalmente fornecer seus próprios rótulos. Note que deve haver um rótulo a menos que os intervalos.
"
cut(x, 
    breaks = c(0, 5, 10, 15, 20), 
    labels = c("sm", "md", "lg", "xl")
)

"
Quaisquer valores fora do alcance dos intervalos se tornarão NA:
"
y <- c(NA, -10, 5, 10, 30)
cut(y, breaks = c(0, 5, 10, 15, 20))

"
Consulte a documentação para outros argumentos úteis como right e include.lowest, que controlam se os intervalos são [a, b) ou (a, b] e se o intervalo mais baixo deve ser [a, b].
"

#----13.4.7Agregações Cumulativas e Rolantes----
"
O R base fornece cumsum(), cumprod(), cummin(), cummax() para somas, produtos, mínimos e máximos acumulados ou contínuos. O dplyr fornece cummean() para médias acumulativas. Somas acumulativas tendem a ser as mais utilizadas na prática:
"
x <- 1:10
cumsum(x)

"
Se você precisar de agregações rolantes ou deslizantes mais complexas, experimente o pacote slider(https://slider.r-lib.org/).
"

#----13.5Transformações Gerais----
"
As seções seguintes descrevem algumas transformações gerais que são frequentemente usadas com vetores numéricos, mas podem ser aplicadas a todos os outros tipos de colunas.
"
#----13.5.1Classificações----
"
O dplyr fornece várias funções de classificação inspiradas no SQL, mas você deve sempre começar com dplyr::min_rank(). Ele usa o método típico para lidar com empates, por exemplo, 1º, 2º, 2º, 4º.
"
x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)

"
Note que os menores valores recebem os menores ranks; use desc(x) para dar aos maiores valores os menores ranks:
"
min_rank(desc(x))

"
Se min_rank() não fizer o que você precisa, olhe para as variantes dplyr::row_number(), dplyr::dense_rank(), dplyr::percent_rank() e dplyr::cume_dist(). Veja a documentação para detalhes.
"
df <- tibble(x = x)
df |> 
  mutate(
    row_number = row_number(x),
    dense_rank = dense_rank(x),
    percent_rank = percent_rank(x),
    cume_dist = cume_dist(x)
  )

"
Você pode alcançar muitos dos mesmos resultados escolhendo o argumento ties.method apropriado para a função rank() do R base; você provavelmente também vai querer definir na.last = 'keep' para manter NAs como NA.

row_number() também pode ser usado sem nenhum argumento quando dentro de um verbo dplyr. Neste caso, ele fornecerá o número da 'linha atual'. Quando combinado com %% ou %/% isso pode ser uma ferramenta útil para dividir dados em grupos de tamanhos semelhantes:
"
df <- tibble(id = 1:10)

df |> 
  mutate(
    row0 = row_number() - 1,
    three_groups = row0 %% 3,
    three_in_each_group = row0 %/% 3
  )

#----13.5.2Deslocamentos----
"
dplyr::lead() e dplyr::lag() permitem que você se refira aos valores logo antes ou logo após o valor 'atual'. Eles retornam um vetor do mesmo comprimento que a entrada, preenchido com NAs no início ou no final:
"
x <- c(2, 5, 11, 11, 19, 35)
lag(x)
lead(x)

#1º x - lag(x) dá a diferença entre o valor atual e o anterior.
x - lag(x)

#2º x == lag(x) indica quando o valor atual muda.
x == lag(x)

"
Você pode antecipar ou atrasar por mais de uma posição usando o segundo argumento, n.
"

#----13.5.3Identificadores Consecutivos----
"
Às vezes, você quer começar um novo grupo toda vez que algum evento ocorre. Por exemplo, ao analisar dados de um site, é comum querer dividir eventos em sessões, onde você começa uma nova sessão após um intervalo de mais de x minutos desde a última atividade. Por exemplo, imagine que você tem os horários de visitas a um site:
"
events <- tibble(
  time = c(0, 1, 2, 3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)

"
E você calculou o tempo entre cada evento e determinou se há um intervalo suficientemente grande para qualificar:
"
events <- events |> 
  mutate(
    diff = time - lag(time, default = first(time)),
    has_gap = diff >= 5
  )
events

"
Mas como passamos desse vetor lógico para algo que podemos usar em group_by()? cumsum(), vem em nosso socorro, pois gap, ou seja, has_gap é TRUE, incrementará o grupo em um:
"
events |> mutate(
  group = cumsum(has_gap)
)

"
Outra abordagem para criar variáveis de agrupamento é consecutive_id(), que inicia um novo grupo toda vez que um de seus argumentos muda. Por exemplo, inspirado por esta questão do stackoverflow, imagine que você tem um data frame com uma série de valores repetidos:
"
df <- tibble(
  x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
  y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
)

"
Se você quiser manter a primeira linha de cada x repetido, você poderia usar group_by(), consecutive_id() e slice_head():
"
df |> 
  group_by(id = consecutive_id(x)) |> 
  slice_head(n = 1)

#----13.6Resumos Numéricos----
"
Apenas usando as contagens, médias e somas que já introduzimos pode levar você longe, mas o R oferece muitas outras funções de resumo úteis. Aqui está uma seleção que você pode achar útil.
"

#----13.6.1Centro----
"
Até agora, usamos principalmente mean() para resumir o centro de um vetor de valores. Porque a média é a soma dividida pela contagem, ela é sensível até mesmo a alguns valores incomumente altos ou baixos. Uma alternativa é usar a median(), que encontra um valor que está no 'meio' do vetor, ou seja, 50% dos valores estão acima dele e 50% estão abaixo. Dependendo da forma da distribuição da variável de interesse, a média ou a mediana podem ser melhores medidas de centro. Por exemplo, para distribuições simétricas, geralmente relatamos a média, enquanto para distribuições assimétricas, geralmente relatamos a mediana.

O gráfico a seguir compara a média versus a mediana do atraso na partida (em minutos) para cada destino. O atraso mediano é sempre menor que o atraso médio porque os voos às vezes partem várias horas atrasados, mas nunca partem várias horas adiantados.
"
flights |>
  group_by(year, month, day) |>
  summarize(
    mean = mean(dep_delay, na.rm = TRUE),
    median = median(dep_delay, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |> 
  ggplot(aes(x = mean, y = median)) + 
  geom_abline(slope = 1, intercept = 0, color = "white", linewidth = 2) +
  geom_point()

"
Você também pode se perguntar sobre a moda, ou o valor mais comum. Este é um resumo que só funciona bem para casos muito simples (o que é por que você pode ter aprendido sobre isso no ensino médio), mas não funciona bem para muitos conjuntos de dados reais. Se os dados são discretos, pode haver múltiplos valores mais comuns, e se os dados são contínuos, pode não haver valor mais comum porque cada valor é ligeiramente diferente. Por essas razões, a moda tende a não ser usada por estatísticos e não há função de moda incluída no R base.
"
#----13.6.2Mínimo, Máximo e Quantis----
"
Se você estiver interessado em locais além do centro, min() e max() fornecerão os valores maiores e menores. Outra ferramenta poderosa é quantile(), que é uma generalização da mediana: quantile(x, 0.25) encontrará o valor de x que é maior que 25% dos valores, quantile(x, 0.5) é equivalente à mediana, e quantile(x, 0.95) encontrará o valor que é maior que 95% dos valores.

Para os dados de voos, você pode querer olhar para o quantil de 95% dos atrasos em vez do máximo, porque ele ignorará os 5% dos voos mais atrasados, que podem ser extremamente elevados.
"
flights |>
  group_by(year, month, day) |>
  summarize(
    max = max(dep_delay, na.rm = TRUE),
    q95 = quantile(dep_delay, 0.95, na.rm = TRUE),
    .groups = "drop"
  )

#----13.6.3Dispersão----
"
Às vezes você não está tão interessado em onde a maior parte dos dados se encontra, mas em como eles estão distribuídos. Duas medidas comumente usadas são o desvio padrão, sd(x), e a amplitude interquartil, IQR(). Não explicaremos sd() aqui, pois você provavelmente já está familiarizado com ele, mas IQR() pode ser novo para você — é quantile(x, 0.75) - quantile(x, 0.25) e fornece o intervalo que contém os 50% do meio dos dados.

Podemos usar isso para revelar uma pequena peculiaridade nos dados de voos. Você pode esperar que a dispersão da distância entre a origem e o destino seja zero, já que os aeroportos estão sempre no mesmo lugar. Mas o código abaixo revela uma peculiaridade nos dados para o aeroporto EGE:
"
flights |> 
  group_by(origin, dest) |> 
  summarize(
    distance_sd = IQR(distance), 
    n = n(),
    .groups = "drop"
  ) |> 
  filter(distance_sd > 0)

#----13.6.4Distribuições----
"
Vale lembrar que todas as estatísticas resumidas descritas acima são uma forma de reduzir a distribuição a um único número. Isso significa que elas são fundamentalmente redutivas, e se você escolher o resumo errado, pode facilmente perder diferenças importantes entre os grupos. É por isso que sempre é uma boa ideia visualizar a distribuição antes de se comprometer com suas estatísticas resumidas.

Também é uma boa ideia verificar se as distribuições para subgrupos se assemelham ao todo. No gráfico a seguir, 365 polígonos de frequência de dep_delay, um para cada dia, são sobrepostos. As distribuições parecem seguir um padrão comum, sugerindo que está tudo bem em usar o mesmo resumo para cada dia.
"
flights |>
  filter(dep_delay < 120) |> 
  ggplot(aes(x = dep_delay, group = interaction(day, month))) + 
  geom_freqpoly(binwidth = 5, alpha = 1/5)

"
Não tenha medo de explorar seus próprios resumos personalizados especificamente adaptados para os dados com os quais você está trabalhando. Neste caso, isso pode significar resumir separadamente os voos que partiram cedo versus os voos que partiram tarde, ou, dado que os valores são tão fortemente assimétricos, você pode tentar uma transformação logarítmica. Por fim, não se esqueça do que aprendeu anteriormente: sempre que criar resumos numéricos, é uma boa ideia incluir o número de observações em cada grupo.
"

#----13.6.5Posições----
"

Há um último tipo de resumo que é útil para vetores numéricos, mas também funciona com todos os outros tipos de valores: extrair um valor em uma posição específica: first(x), last(x) e nth(x, n).

Por exemplo, podemos encontrar a primeira e a última partida para cada dia:
"
flights |> 
  group_by(year, month, day) |> 
  summarize(
    first_dep = first(dep_time, na_rm = TRUE), 
    fifth_dep = nth(dep_time, 5, na_rm = TRUE),
    last_dep = last(dep_time, na_rm = TRUE)
  )

"
Se você está familiarizado com [, ao qual retornaremos mais a frente, você pode se perguntar se alguma vez precisará dessas funções. Há três razões: o argumento padrão permite fornecer um padrão se a posição especificada não existir, o argumento order_by permite substituir localmente a ordem das linhas, e o argumento na_rm permite descartar valores ausentes.

Extrair valores em posições é complementar a filtrar por classificações. Filtrar fornece todas as variáveis, com cada observação em uma linha separada:
"
flights |> 
  group_by(year, month, day) |> 
  mutate(r = min_rank(sched_dep_time)) |> 
  filter(r %in% c(1, max(r)))

#----13.6.6Com mutate()----
"
Como os nomes sugerem, as funções de resumo são tipicamente emparelhadas com summarize(). No entanto, devido às regras de reciclagem que discutimos anteriormente, elas também podem ser úteis em conjunto com mutate(), particularmente quando você quer fazer algum tipo de padronização de grupo. Por exemplo:
"  
#1º x / sum(x) calcula a proporção de um total.
#2º (x - mean(x)) / sd(x) calcula um escore Z (padronizado para média 0 e desvio padrão 1).
#3º (x - min(x)) / (max(x) - min(x)) padroniza para o intervalo [0, 1].
#4º x / first(x) calcula um índice baseado na primeira observação.


#Capítulo 14 : Strings (Cadeias de Caracteres)----

#----14.1 Introdução----
"
Até agora, você usou várias strings sem aprender muito sobre os detalhes. Agora é hora de mergulhar nelas, aprender o que faz as strings funcionarem e dominar algumas das poderosas ferramentas de manipulação de strings à sua disposição.

Começaremos com os detalhes da criação de strings e vetores de caracteres. Você então mergulhará na criação de strings a partir de dados e, em seguida, o oposto: extrair strings de dados. Discutiremos então ferramentas que trabalham com letras individuais. O capítulo termina com funções que trabalham com letras individuais e uma breve discussão sobre onde suas expectativas do inglês podem levar você a erros ao trabalhar com outros idiomas.

Continuaremos trabalhando com string adiante, onde você aprenderá mais sobre o poder das expressões regulares.
"
#----14.1.1 Pré-requisitos----
"
Agora, usaremos funções do pacote stringr, que faz parte do core do tidyverse. Também usaremos os dados do babynames, pois eles fornecem algumas strings divertidas para manipular.
"
library(tidyverse)
library(babynames)

"
Você pode identificar rapidamente quando está usando uma função do stringr porque todas as funções do stringr começam com str_. Isso é particularmente útil se você usa o RStudio, porque digitar str_ acionará o preenchimento automático, permitindo que você relembre as funções disponíveis.
"
#----14.2 Criando uma string----
"
Nós criamos strings anteriormente no livro, mas não discutimos os detalhes. Primeiramente, você pode criar uma string usando aspas simples (') ou aspas duplas ('). Não há diferença de comportamento entre as duas, então, em nome da consistência, o guia de estilo do tidyverse recomenda usar as aspas duplas (') a menos que a string contenha múltiplas aspas duplas.
"
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

"
Se você esquecer de fechar uma aspa, verá +, o prompt de continuação:

Se isso acontecer com você e você não conseguir descobrir qual aspa fechar, pressione Escape para cancelar e tente novamente.
"

#----14.2.1 Escapes----
"
Para incluir uma aspa simples ou dupla literal em uma string, você pode usar \ para 'escapá-la':
"
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

"
Então, se você quiser incluir uma barra invertida literal na sua string, precisará escapá-la: '\':
"
backslash <- "\\"

"
Esteja ciente de que a representação impressa de uma string não é a mesma que a própria string porque a representação impressa mostra os escapes (em outras palavras, quando você imprime uma string, pode copiar e colar a saída para recriar essa string). Para ver o conteúdo bruto da string, use str_view():
"
x <- c(single_quote, double_quote, backslash)
x
str_view(x)

#----14.2.2 Strings brutas----
"
Criar uma string com várias aspas ou barras invertidas fica confuso rapidamente. Para ilustrar o problema, vamos criar uma string que contém o conteúdo do bloco de código onde definimos as variáveis double_quote e single_quote:
"
tricky <- "double_quote <- \"\\\"\" # or '\"'
single_quote <- '\\'' # or \"'\""
str_view(tricky)

"
Isso é um monte de barras invertidas! (Isso às vezes é chamado de síndrome do palito inclinado.) Para eliminar a necessidade de escapar, você pode, em vez disso, usar uma string bruta:
"
tricky <- r"(double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'")"
str_view(tricky)

"
Uma string bruta normalmente começa com r'( e termina com )'. Mas se a sua string contiver )' você pode, em vez disso, usar r'[]' ou r'{}', e se isso ainda não for suficiente, você pode inserir qualquer número de hifens para tornar os pares de abertura e fechamento únicos, por exemplo, r'--()--', r'---()---', etc. As strings brutas são flexíveis o suficiente para lidar com qualquer texto.
"

#----14.2.3 Outros caracteres especiais----

#Além de ',' e \, há um punhado de outros caracteres especiais que podem ser úteis. Os mais comuns são \n, uma nova linha, e \t, tabulação. Você também verá às vezes strings contendo escapes Unicode que começam com \u ou \U. Esta é uma maneira de escrever caracteres não ingleses que funcionam em todos os sistemas. Você pode ver a lista completa de outros caracteres especiais em ?Quotes.

x <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f604")
x        
"😄"
str_view(x)

"
Note que o str_view() usa chaves para as tabulações para torná-las mais fáceis de identificar. Um dos desafios de trabalhar com texto é que há uma variedade de maneiras pelas quais o espaço em branco pode acabar no texto, então esse fundo ajuda você a reconhecer que algo estranho está acontecendo.
"

#----14.3 Criando muitas strings a partir de dados----
"
Agora que você aprendeu o básico de criar uma ou duas strings   'manualmente', vamos entrar nos detalhes de criar strings a partir de outras strings. Isso ajudará você a resolver o problema comum onde você tem algum texto que escreveu e quer combiná-lo com strings de um data frame. Por exemplo, você pode combinar 'Olá' com uma variável de nome para criar uma saudação. Mostraremos como fazer isso com str_c() e str_glue() e como você pode usá-los com mutate(). Isso naturalmente levanta a questão de quais funções do stringr você pode usar com summarize(), então vamos terminar esta seção com uma discussão sobre str_flatten(), que é uma função de resumo para strings.
"
#----14.3.1 str_c()----
"
str_c() recebe qualquer número de vetores como argumentos e retorna um vetor de caracteres:
"
str_c("x", "y")
str_c("x", "y", "z")
str_c("Hello ", c("John", "Susan"))

"
str_c() é muito semelhante ao paste0() do R base, mas é projetado para ser usado com mutate(), obedecendo às regras usuais do tidyverse para reciclagem e propagação de valores ausentes:
"
df <- tibble(name = c("Flora", "David", "Terra", NA))
df |> mutate(greeting = str_c("Hi ", name, "!"))

"
Se você deseja que os valores ausentes sejam exibidos de outra forma, use coalesce() para substituí-los. Dependendo do que você deseja, pode usá-lo tanto dentro quanto fora do str_c():
"
df |> 
  mutate(
    greeting1 = str_c("Hi ", coalesce(name, "you"), "!"),
    greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")
  )


#----14.3.2 str_glue()----
"
Se você está misturando muitas strings fixas e variáveis com str_c(), notará que digita muitos 's', tornando difícil ver o objetivo geral do código. Uma abordagem alternativa é fornecida pelo pacote glue
(https://glue.tidyverse.org/) por meio de str_glue(). Você fornece a ele uma única string que tem um recurso especial: qualquer coisa dentro de {} será avaliada como se estivesse fora das aspas:
"
df |> mutate(greeting = str_glue("Hi {name}!"))

"
Como você pode ver, str_glue() atualmente converte valores ausentes para a string 'NA', infelizmente tornando-o inconsistente com str_c().

Você também pode se perguntar o que acontece se precisar incluir um { ou } regular em sua string. Você está no caminho certo se adivinhar que precisará escapar de alguma forma. O truque é que o glue usa uma técnica de escape um pouco diferente: em vez de prefixar com um caractere especial como , você dobra os caracteres especiais:
"
df |> mutate(greeting = str_glue("{{Hi {name}!}}"))

#----14.3.3 str_flatten()----
"
str_c() e str_glue() funcionam bem com mutate() porque sua saída tem o mesmo comprimento que suas entradas. E se você quiser uma função que funcione bem com summarize(), ou seja, algo que sempre retorna uma única string? Esse é o trabalho de str_flatten()5: ele pega um vetor de caracteres e combina cada elemento do vetor em uma única string:
"
str_flatten(c("x", "y", "z"))
str_flatten(c("x", "y", "z"), ", ")
str_flatten(c("x", "y", "z"), ", ", last = ", and ")

"
Isso faz com que funcione bem com summarize():
"
df <- tribble(
  ~ name, ~ fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Marvin", "nectarine",
  "Terence", "cantaloupe",
  "Terence", "papaya",
  "Terence", "mandarin"
)
df |>
  group_by(name) |> 
  summarize(fruits = str_flatten(fruit, ", "))

#----14.4 Extraindo dados de strings-----
"
É muito comum que várias variáveis sejam compactadas em uma única string. Nesta seção, você aprenderá a usar quatro funções do tidyr para extraí-las:
"  
#1º df |> separate_longer_delim(col, delim)
#2º df |> separate_longer_position(col, width)
#3º df |> separate_wider_delim(col, delim, names)
#4º df |> separate_wider_position(col, widths)
"
Se você olhar de perto, pode ver que há um padrão comum aqui: separate_, depois longer ou wider, depois _, então por delim ou position. Isso ocorre porque essas quatro funções são compostas de dois princípios mais simples:
"  
#1º Assim como com pivot_longer() e pivot_wider(), as funções _longer tornam o data frame de entrada mais longo, criando novas linhas, e as funções _wider tornam o data frame de entrada mais largo, gerando novas colunas.
#2º delim divide uma string com um delimitador como ", " ou " "; position divide em larguras especificadas, como c(3, 5, 2).
"
Voltaremos ao último membro dessa família, separate_wider_regex(), mais a frente. É a função mais flexível das funções wider, mas você precisa saber algo sobre expressões regulares antes de poder usá-la.

As próximas duas seções lhe darão a ideia básica por trás dessas funções de separação, primeiro separando em linhas (que é um pouco mais simples) e depois separando em colunas. Vamos terminar discutindo as ferramentas que as funções wider fornecem para diagnosticar problemas.
"

#----14.4.1 Separando em linhas----
"
Separar uma string em linhas tende a ser mais útil quando o número de componentes varia de linha para linha. O caso mais comum é quando se requer separate_longer_delim() para dividir com base em um delimitador:
"
df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1 |> 
  separate_longer_delim(x, delim = ",")

"
É mais raro ver separate_longer_position() na prática, mas alguns conjuntos de dados mais antigos usam um formato muito compacto onde cada caractere é usado para registrar um valor:
"
df2 <- tibble(x = c("1211", "131", "21"))
df2 |> 
  separate_longer_position(x, width = 1)

#----14.4.2 Separando em colunas----
"
Separar uma string em colunas tende a ser mais útil quando há um número fixo de componentes em cada string e você deseja espalhá-los em colunas. Eles são um pouco mais complicados do que seus equivalentes mais longos porque você precisa nomear as colunas. Por exemplo, neste conjunto de dados a seguir, x é composto por um código, um número de edição e um ano, separados por '.'. Para usar separate_wider_delim(), fornecemos o delimitador e os nomes em dois argumentos:
"
df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", "edition", "year")
  )

"
Se uma peça específica não for útil, você pode usar um nome NA para omiti-la dos resultados:
"
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", NA, "year")
  )

"
separate_wider_position() funciona um pouco diferente porque normalmente você deseja especificar a largura de cada coluna. Então, você fornece um vetor inteiro nomeado, onde o nome dá o nome da nova coluna e o valor é o número de caracteres que ocupa. Você pode omitir valores da saída não os nomeando:
"
df4 <- tibble(x = c("202215TX", "202122LA", "202325CA")) 
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, age = 2, state = 2)
  )

#----14.4.3 Diagnosticando problemas de expansão----
"
separate_wider_delim()6 requer um conjunto fixo e conhecido de colunas. O que acontece se algumas das linhas não tiverem o número esperado de peças? Há dois possíveis problemas, peças de menos ou peças demais, então separate_wider_delim() fornece dois argumentos para ajudar: too_few (poucas) e too_many (demais). Vamos primeiro olhar para o caso de too_few com o seguinte conjunto de dados de amostra:
"
df <- tibble(x = c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))

df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z")
  )

"
Você notará que recebemos um erro, mas o erro nos dá algumas sugestões sobre como você pode proceder. Vamos começar depurando o problema:
"
debug <- df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "debug"
  )

debug

"
Quando você usa o modo de depuração, três colunas extras são adicionadas à saída: x_ok, x_pieces e x_remainder (se você separar uma variável com um nome diferente, você obterá um prefixo diferente). Aqui, x_ok permite que você encontre rapidamente as entradas que falharam:
"
debug |> filter(!x_ok)

"
x_pieces nos diz quantas peças foram encontradas, comparadas às 3 esperadas (o comprimento de names). x_remainder não é útil quando há peças de menos, mas veremos novamente em breve.

Às vezes, olhar para essas informações de depuração revelará um problema com sua estratégia de delimitador ou sugerirá que você precisa fazer mais pré-processamento antes de separar. Nesse caso, corrija o problema a montante e certifique-se de remover too_few = 'debug' para garantir que novos problemas se tornem erros.

Em outros casos, você pode querer preencher as peças ausentes com NAs e seguir em frente. Esse é o trabalho de too_few = 'align_start' e too_few = 'align_end', que permitem controlar onde os NAs devem ir:
"
df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start"
  )

"
Os mesmos princípios se aplicam se você tiver peças demais:
"
df <- tibble(x = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))

df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z")
  )

"
Mas agora, quando depuramos o resultado, você pode ver a finalidade de x_remainder:
"
debug <- df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "debug"
  )
debug |> filter(!x_ok)

"
Você tem um conjunto ligeiramente diferente de opções para lidar com peças demais: você pode 'descartar' silenciosamente qualquer peça adicional ou 'mesclar' todas elas na coluna final:
"
df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "drop"
  )


df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "merge"
  )

#----14.5 Letras----
"
Nesta seção, apresentaremos funções que permitem trabalhar com as letras individuais dentro de uma string. Você aprenderá como encontrar o comprimento de uma string, extrair substrings e lidar com strings longas em gráficos e tabelas.
"

#----14.5.1 Comprimento----
"
str_length() informa o número de letras na string:
"
str_length(c("a", "R for data science", NA))

"
Você poderia usar isso com count() para encontrar a distribuição de comprimentos de nomes de bebês nos EUA e, em seguida, com filter() para olhar os nomes mais longos, que por acaso têm 15 letras7:
"
babynames |>
  count(length = str_length(name), wt = n)

babynames |> 
  filter(str_length(name) == 15) |> 
  count(name, wt = n, sort = TRUE)


#----14.5.2 Subconjunto----
"
Você pode extrair partes de uma string usando str_sub(string, start, end), onde start e end são as posições onde a substring deve começar e terminar. Os argumentos start e end são inclusivos, então o comprimento da string retornada será end - start + 1:
"
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

"
Você pode usar valores negativos para contar a partir do final da string: -1 é o último caractere, -2 é o penúltimo caractere, etc.
"
str_sub(x, -3, -1)

"
Note que str_sub() não falhará se a string for muito curta: ele apenas retornará o máximo possível:
"
str_sub("a", 1, 5)

"
Poderíamos usar str_sub() com mutate() para encontrar a primeira e a última letra de cada nome:
"
babynames |> 
  mutate(
    first = str_sub(name, 1, 1),
    last = str_sub(name, -1, -1)
  )

#----14.6 Texto não inglês----
"
Até agora, nos concentramos em texto em língua inglesa, que é particularmente fácil de trabalhar por dois motivos. Primeiramente, o alfabeto inglês é relativamente simples: são apenas 26 letras. Em segundo lugar (e talvez mais importante), a infraestrutura de computação que usamos hoje foi predominantemente projetada por falantes de inglês. Infelizmente, não temos espaço para um tratamento completo de idiomas não ingleses. Ainda assim, queríamos chamar sua atenção para alguns dos maiores desafios que você pode encontrar: codificação, variações de letras e funções dependentes de localidade.
"

#----14.6.1 Codificação----
"
Ao trabalhar com texto em idioma não inglês, o primeiro desafio é frequentemente a codificação. Para entender o que está acontecendo, precisamos mergulhar em como os computadores representam strings. No R, podemos acessar a representação subjacente de uma string usando charToRaw():
"
charToRaw("Hadley")

"
Cada um desses seis números hexadecimais representa uma letra: 48 é H, 61 é a, e assim por diante. O mapeamento de número hexadecimal para caractere é chamado de codificação, e neste caso, a codificação é chamada ASCII. ASCII faz um ótimo trabalho ao representar caracteres em inglês porque é o American Standard Code for Information Interchange (Código Americano Padrão para Troca de Informações).

As coisas não são tão fáceis para idiomas além do inglês. Nos primórdios da computação, havia muitos padrões concorrentes para a codificação de caracteres não ingleses. Por exemplo, havia duas codificações diferentes para a Europa: Latin1 (também conhecido como ISO-8859-1) era usado para idiomas da Europa Ocidental, e Latin2 (também conhecido como ISO-8859-2) era usado para idiomas da Europa Central. No Latin1, o byte b1 é “±”, mas no Latin2, é “ą”! Felizmente, hoje existe um padrão que é suportado quase em todos os lugares: UTF-8. UTF-8 pode codificar quase todos os caracteres usados por humanos hoje e muitos símbolos extras como emojis.

O readr usa UTF-8 em todos os lugares. Este é um bom padrão, mas falhará para dados produzidos por sistemas mais antigos que não usam UTF-8. Se isso acontecer, suas strings parecerão estranhas quando você as imprimir. Às vezes, apenas um ou dois caracteres podem estar bagunçados; outras vezes, você terá um completo absurdo. Por exemplo, aqui estão dois CSVs embutidos com codificações incomuns:
"
x1 <- "text\nEl Ni\xf1o was particularly bad this year"
read_csv(x1)$text

x2 <- "text\n\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
read_csv(x2)$text

"
Para lê-los corretamente, você especifica a codificação através do argumento locale:
"
read_csv(x1, locale = locale(encoding = "Latin1"))$text

read_csv(x2, locale = locale(encoding = "Shift-JIS"))$text

"
Como você encontra a codificação correta? Se tiver sorte, ela estará incluída em algum lugar na documentação dos dados. Infelizmente, raramente é o caso, então o readr fornece guess_encoding() para ajudá-lo a descobrir. Não é infalível e funciona melhor quando você tem muito texto (diferente daqui), mas é um ponto de partida razoável. Espere tentar algumas codificações diferentes antes de encontrar a certa.

Codificações são um tópico rico e complexo; só arranhamos a superfície aqui. Se você quiser aprender mais, recomendamos ler a explicação detalhada em http://kunststube.net/encoding/.
"
#----14.6.2 Variações de letras----
"
Trabalhar em idiomas com acentos representa um desafio significativo ao determinar a posição das letras (por exemplo, com str_length() e str_sub()), pois letras acentuadas podem ser codificadas como um único caractere individual (por exemplo, ü) ou como dois caracteres combinando uma letra não acentuada (por exemplo, u) com um sinal diacrítico (por exemplo, ¨). Por exemplo, este código mostra duas maneiras de representar ü que parecem idênticas:
"
u <- c("\u00fc", "u\u0308")
str_view(u)

"
Mas ambas as strings diferem em comprimento, e seus primeiros caracteres são diferentes:
"
str_length(u)
str_sub(u, 1, 1)

"
Finalmente, observe que uma comparação dessas strings com == interpreta essas strings como diferentes, enquanto a prática função str_equal() no stringr reconhece que ambas têm a mesma aparência:
"
u[[1]] == u[[2]]

str_equal(u[[1]], u[[2]])

#----14.6.3 Funções dependentes de localidade----
"
Finalmente, há um punhado de funções stringr cujo comportamento depende do seu local (locale). Um local é semelhante a um idioma, mas inclui um especificador de região opcional para lidar com variações regionais dentro de um idioma. Um local é especificado por uma abreviação de idioma em letras minúsculas, seguida opcionalmente por um _ e um identificador de região em letras maiúsculas. Por exemplo, 'en' é inglês, 'en_GB' é inglês britânico e 'en_US' é inglês americano. Se você não sabe o código do seu idioma, a Wikipedia tem uma boa lista, e você pode ver quais são suportados no stringr olhando para stringi::stri_locale_list().

As funções de string do R base usam automaticamente o local definido pelo seu sistema operacional. Isso significa que as funções de string do R base fazem o que você espera para o seu idioma, mas seu código pode funcionar de maneira diferente se você compartilhá-lo com alguém que mora em um país diferente. Para evitar esse problema, o stringr usa como padrão as regras em inglês, usando o local 'en' e exige que você especifique o argumento locale para substituí-lo. Felizmente, existem dois conjuntos de funções onde o local realmente importa: alterar o caso e ordenar.

As regras para alterar os casos diferem entre os idiomas. Por exemplo, o turco tem dois i’s: com e sem ponto. Já que são duas letras distintas, elas são capitalizadas de maneira diferente:
"
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

"
Ordenar strings depende da ordem do alfabeto, e a ordem do alfabeto não é a mesma em todos os idiomas! Aqui está um exemplo: em tcheco, 'ch' é uma letra composta que aparece após o h no alfabeto.
"
str_sort(c("a", "c", "ch", "h", "z"))
str_sort(c("a", "c", "ch", "h", "z"), locale = "cs")

"
Isso também acontece ao ordenar strings com dplyr::arrange(), razão pela qual também tem um argumento de local.
"

#Capítulo 15 : Expressões Regulares----

#----15.1 Introdução----
"
Anteriormente, você aprendeu um monte de funções úteis para trabalhar com strings. Este capítulo se concentrará em funções que usam expressões regulares, uma linguagem concisa e poderosa para descrever padrões dentro de strings. O termo 'expressão regular' é um pouco longo, então a maioria das pessoas o abrevia para 'regex' ou 'regexp'.

O capítulo começa com o básico de expressões regulares e as funções stringr mais úteis para análise de dados. Em seguida, expandiremos seu conhecimento sobre padrões e cobriremos sete tópicos importantes novos (escapar caracteres, ancoragem, classes de caracteres, classes abreviadas, quantificadores, precedência e agrupamento). Depois, falaremos sobre alguns dos outros tipos de padrões com os quais as funções stringr podem trabalhar e as várias 'flags' que permitem ajustar a operação de expressões regulares. Concluiremos com uma pesquisa de outros lugares no tidyverse e no R base onde você pode usar regexes.
"

#----15.1.1 Pré-requisitos----
"
Neste capítulo, usaremos funções de expressão regular do stringr e do tidyr, ambos membros centrais do tidyverse, bem como dados do pacote babynames.
"
library(tidyverse)
library(babynames)

"
Ao longo deste capítulo, usaremos uma mistura de exemplos muito simples embutidos para que você possa entender a ideia básica, os dados de nomes de bebês e três vetores de caracteres do stringr:
"
#1º fruit contém os nomes de 80 frutas.
#2º words contém 980 palavras comuns em inglês.
#3º sentences contém 720 frases curtas.


#----15.2 Noções básicas de padrão----
"

Claro, aqui está o texto com as aspas duplas substituídas por aspas simples:

Vamos usar str_view() para aprender como padrões de regex funcionam. Usamos str_view() no último capítulo para entender melhor uma string versus sua representação impressa, e agora o usaremos com seu segundo argumento, uma expressão regular. Quando isso é fornecido, str_view() mostrará apenas os elementos do vetor de string que correspondem, cercando cada correspondência com '<>', e, quando possível, destacando a correspondência em azul.

Os padrões mais simples consistem em letras e números que correspondem exatamente a esses caracteres:
"
str_view(fruit, "berry")

"
Letras e números correspondem exatamente e são chamados de caracteres literais. A maioria dos caracteres de pontuação, como ., +, *, [, ], e ?, têm significados especiais e são chamados de metacaracteres. Por exemplo, . corresponderá a qualquer caractere, então 'a.' corresponderá a qualquer string que contenha um 'a' seguido por outro caractere:
"
str_view(c("a", "ab", "ae", "bd", "ea", "eab"), "a.")

"
Ou poderíamos encontrar todas as frutas que contêm um 'a', seguido por três letras, seguido por um 'e':
"
str_view(fruit, "a...e")

"
Quantificadores controlam quantas vezes um padrão pode corresponder:
"

#1º '?' torna um padrão opcional (ou seja, corresponde 0 ou 1 vez)
#2º '+' permite que um padrão se repita (ou seja, corresponde pelo menos uma vez)
#3º '*' permite que um padrão seja opcional ou se repita (ou seja, corresponde a qualquer número de vezes, incluindo 0).

# ab? corresponde a um 'a', opcionalmente seguido por um 'b
str_view(c("a", "ab", "abb"), "ab?")

# ab+ corresponde a um 'a', seguido por pelo menos um 'b'.
str_view(c("a", "ab", "abb"), "ab+")

# ab* corresponde a um 'a', seguido por qualquer número de 'b's.
str_view(c("a", "ab", "abb"), "ab*")

"
Classes de caracteres são definidas por '[]' e permitem que você corresponda a um conjunto de caracteres, por exemplo, '[abcd]' corresponde a 'a', 'b', 'c' ou 'd'. Você também pode inverter a correspondência começando com '^': '[^abcd]' corresponde a qualquer coisa exceto 'a', 'b', 'c' ou 'd'. Podemos usar essa ideia para encontrar as palavras contendo um 'x' cercado por vogais ou um 'y' cercado por consoantes:
"
str_view(words, "[aeiou]x[aeiou]")
str_view(words, "[^aeiou]y[^aeiou]")

"
Você pode usar alternância, '|', para escolher entre um ou mais padrões alternativos. Por exemplo, os seguintes padrões procuram por frutas contendo 'apple', 'melon' ou 'nut', ou uma vogal repetida.
"
str_view(fruit, "apple|melon|nut")
str_view(fruit, "aa|ee|ii|oo|uu")

"
Expressões regulares são muito compactas e usam muitos caracteres de pontuação, então elas podem parecer esmagadoras e difíceis de ler no início. Não se preocupe; você vai melhorar com a prática, e padrões simples logo se tornarão naturais. Vamos iniciar esse processo praticando com algumas funções úteis do stringr.
"

#----15.3 Funções-chave----
"
Agora que você já tem o básico das expressões regulares, vamos usá-las com algumas funções do stringr e tidyr. Na próxima seção, você aprenderá como detectar a presença ou ausência de uma correspondência, como contar o número de correspondências, como substituir uma correspondência por texto fixo e como extrair texto usando um padrão.
"

#----15.3.1 Detectar correspondências----
"
str_detect() retorna um vetor lógico que é TRUE se o padrão corresponder a um elemento do vetor de caracteres e FALSE caso contrário:
"
str_detect(c("a", "b", "c"), "[aeiou]")

"
Como str_detect() retorna um vetor lógico do mesmo comprimento que o vetor inicial, ele combina bem com filter(). Por exemplo, este código encontra todos os nomes mais populares que contêm um 'x' minúsculo:
"
babynames |> 
  filter(str_detect(name, "x")) |> 
  count(name, wt = n, sort = TRUE)

"
Também podemos usar str_detect() com summarize() emparelhando-o com sum() ou mean(): sum(str_detect(x, pattern)) informa o número de observações que correspondem e mean(str_detect(x, pattern)) informa a proporção que corresponde. Por exemplo, o trecho a seguir calcula e visualiza a proporção de nomes de bebês que contêm 'x', divididos por ano. Parece que eles aumentaram radicalmente em popularidade recentemente!
"
babynames |> 
  group_by(year) |> 
  summarize(prop_x = mean(str_detect(name, "x"))) |> 
  ggplot(aes(x = year, y = prop_x)) + 
  geom_line()

"
Há duas funções que são intimamente relacionadas a str_detect(): str_subset() e str_which(). str_subset() retorna um vetor de caracteres contendo apenas as strings que correspondem. str_which() retorna um vetor inteiro dando as posições das strings que correspondem.
"

#----15.3.2 Contar correspondências----
"
O próximo passo em complexidade após str_detect() é str_count(): em vez de verdadeiro ou falso, ele informa quantas correspondências há em cada string.
"
x <- c("apple", "banana", "pear")
str_count(x, "p")

"
Note que cada correspondência começa no final da correspondência anterior, ou seja, as correspondências de regex nunca se sobrepõem. Por exemplo, em 'abababa', quantas vezes o padrão 'aba' corresponde? Expressões regulares dizem duas, não três:
"
str_count("abababa", "aba")
str_view("abababa", "aba")

"
É natural usar str_count() com mutate(). O seguinte exemplo usa str_count() com classes de caracteres para contar o número de vogais e consoantes em cada nome.
"
babynames |> 
  count(name) |> 
  mutate(
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

"
Se você olhar atentamente, notará que há algo errado com nossos cálculos: 'Aaban' contém três 'a's, mas nosso resumo relata apenas duas vogais. Isso ocorre porque expressões regulares diferenciam maiúsculas de minúsculas. Existem três maneiras de corrigir isso:
"
#1º Adicione as vogais maiúsculas à classe de caracteres: str_count(name, "[aeiouAEIOU]").
#2º Diga à expressão regular para ignorar o caso: str_count(name, regex("[aeiou]", ignore_case = TRUE)). 
#3º Use str_to_lower() para converter os nomes para minúsculas: str_count(str_to_lower(name), "[aeiou]").

"
Essa variedade de abordagens é bastante típica ao trabalhar com strings — muitas vezes há várias maneiras de alcançar seu objetivo, seja tornando seu padrão mais complicado ou fazendo algum pré-processamento na sua string. Se você ficar preso tentando uma abordagem, muitas vezes pode ser útil mudar de estratégia e atacar o problema de uma perspectiva diferente.

Neste caso, como estamos aplicando duas funções ao nome, acho mais fácil transformá-lo primeiro:
"
babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name),
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

#----15.3.3 Substituir valores----
"
Além de detectar e contar correspondências, também podemos modificá-las com str_replace() e str_replace_all(). str_replace() substitui a primeira correspondência e, como o nome sugere, str_replace_all() substitui todas as correspondências.
"
x <- c("apple", "pear", "banana")
str_replace_all(x, "[aeiou]", "-")

"
str_remove() e str_remove_all() são atalhos úteis para str_replace(x, pattern, ""):
"
x <- c("apple", "pear", "banana")
str_remove_all(x, "[aeiou]")

"
Essas funções são naturalmente emparelhadas com mutate() ao fazer limpeza de dados, e você frequentemente as aplicará repetidamente para remover camadas de formatação inconsistente.
"

#----15.3.4 Extrair variáveis----
"

A última função que discutiremos usa expressões regulares para extrair dados de uma coluna para uma ou mais novas colunas: separate_wider_regex(). É uma função semelhante às separate_wider_position() e separate_wider_delim() que você aprendeu anteriormente. Essas funções estão no tidyr porque operam em (colunas de) data frames, em vez de vetores individuais.

Vamos criar um conjunto de dados simples para mostrar como funciona. Aqui temos alguns dados derivados de babynames onde temos o nome, gênero e idade de várias pessoas em um formato um tanto estranho:
"
df <- tribble(
  ~str,
  "<Sheryl>-F_34",
  "<Kisha>-F_45", 
  "<Brandon>-N_33",
  "<Sharon>-F_38", 
  "<Penny>-F_58",
  "<Justin>-M_41", 
  "<Patricia>-F_84", 
)

"
Para extrair esses dados usando separate_wider_regex(), só precisamos construir uma sequência de expressões regulares que correspondam a cada parte. Se quisermos que o conteúdo dessa parte apareça na saída, damos a ela um nome:
"
df |> 
  separate_wider_regex(
    str,
    patterns = c(
      "<", 
      name = "[A-Za-z]+", 
      ">-", 
      gender = ".",
      "_",
      age = "[0-9]+"
    )
  )

"
Se a correspondência falhar, você pode usar too_short = 'debug' para descobrir o que deu errado, assim como separate_wider_delim() e separate_wider_position().
"

#----15.4 Detalhes do padrão----
"
Agora que você entende o básico da linguagem de padrões e como usá-la com algumas funções do stringr e tidyr, é hora de mergulhar em mais detalhes. Primeiro, começaremos com o escaping, que permite corresponder a metacaracteres que, de outra forma, seriam tratados de maneira especial. Em seguida, você aprenderá sobre âncoras, que permitem corresponder ao início ou ao fim da string. Depois, você aprenderá mais sobre classes de caracteres e seus atalhos, que permitem corresponder a qualquer caractere de um conjunto. Em seguida, você aprenderá os detalhes finais dos quantificadores que controlam quantas vezes um padrão pode corresponder. Então, temos que cobrir o importante (mas complexo) tópico da precedência de operadores e parênteses. E terminaremos com alguns detalhes sobre a agrupamento de componentes do padrão.

Os termos que usamos aqui são os nomes técnicos para cada componente. Eles nem sempre são os mais evocativos de seu propósito, mas é muito útil conhecer os termos corretos se você quiser procurar mais detalhes no Google mais tarde.
"

#----15.4.1 Escapando----
"
Para corresponder a um '.' literal, você precisa de um escape que diga à expressão regular para corresponder aos metacaracteres literalmente. Como nas strings, as regex usam a barra invertida para escaping. Então, para corresponder a um '.', você precisa da regex .. Infelizmente isso cria um problema. Usamos strings para representar expressões regulares, e \ também é usado como um símbolo de escape em strings. Então, para criar a expressão regular . precisamos da string '\.', como o exemplo a seguir mostra.
"

#Para criar a expressão regular ., precisamos usar \\.
dot <- "\\."

# Mas a expressão em si contém apenas uma \
str_view(dot)

# E isso diz ao R para procurar um '.' explícito.
str_view(c("abc", "a.c", "bef"), "a\\.c")

"
Aqui, geralmente escreveremos expressões regulares sem aspas, como .. Se precisarmos enfatizar o que você realmente digitará, cercaremos com aspas e adicionaremos escapes extras, como '\.'.

Se \ é usado como um caractere de escape em expressões regulares, como você corresponde a um \ literal? Bem, você precisa escapá-lo, criando a expressão regular \. Para criar essa expressão regular, você precisa usar uma string, que também precisa escapar . Isso significa que para corresponder a um \ literal você precisa escrever '\\' — você precisa de quatro barras invertidas para corresponder a uma!
"
x <- "a\\b"
str_view(x)
str_view(x, "\\\\")

"
Alternativamente, você pode achar mais fácil usar as strings brutas que aprendeu anteriormente. Isso permite evitar uma camada de escaping:
"
str_view(x, r"{\\}")

"
Se você está tentando corresponder a um '.', '$', '|', '*', '+', '?', '{', '}', '(', ')', literal, há uma alternativa para usar um escape de barra invertida: você pode usar uma classe de caracteres: [.]', '[$]', '[|]', ... todos correspondem aos valores literais.
"
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

#----15.4.2 Âncoras----
"
By default, regular expressions will match any part of a string. If you want to match at the start or end you need to anchor the regular expression using ^ to match the start or $ to match the end:
"
str_view(fruit, "^a")
str_view(fruit, "a$")

"
É tentador pensar que $ deveria corresponder ao início de uma string, porque é assim que escrevemos valores em dinheiro, mas não é isso que as expressões regulares querem.

Para forçar uma expressão regular a corresponder apenas à string inteira, ancore-a com ambos ^ e $:
"
str_view(fruit, "apple")
str_view(fruit, "^apple$")

"
Você também pode corresponder ao limite entre palavras (ou seja, o início ou o fim de uma palavra) com \b. Isso pode ser particularmente útil ao usar a ferramenta de localizar e substituir do RStudio. Por exemplo, se quiser encontrar todos os usos de sum(), você pode procurar por \bsum\b para evitar corresponder summarize, summary, rowsum e assim por diante:
"
x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(x, "sum")
str_view(x, "\\bsum\\b")

"
Quando usados sozinhos, âncoras produzirão uma correspondência de largura zero:
"
str_view("abc", c("$", "^", "\\b"))

"
Isso ajuda a entender o que acontece quando você substitui uma âncora isolada:
"
str_replace_all("abc", c("$", "^", "\\b"), "--")

#----15.4.3 Classes de caracteres----
"
Uma classe de caracteres, ou conjunto de caracteres, permite que você corresponda a qualquer caractere em um conjunto. Como discutimos acima, você pode construir seus próprios conjuntos com '[]', onde '[abc]' corresponde a 'a', 'b' ou 'c' e '[^abc]' corresponde a qualquer caractere exceto 'a', 'b' ou 'c'. Além de '^', há outros dois caracteres que têm significado especial dentro de '[]':
"
#1º define um intervalo, por exemplo, '[a-z]' corresponde a qualquer letra minúscula e '[0-9]' corresponde a qualquer número.
#2º \ escapa caracteres especiais, então '[^-]]' corresponde a '^', '-' ou ']'.

"
Aqui estão alguns exemplos:
"
x <- "abcd ABCD 12345 -!@#%."
str_view(x, "[abc]+")
str_view(x, "[a-z]+")
str_view(x, "[^a-z0-9]+")

# Você precisa de um escape para corresponder a caracteres que são
#especiais dentro de []
str_view("a-b-c", "[a-c]")
str_view("a-b-c", "[a\\-c]")

"
Algumas classes de caracteres são usadas tão comumente que recebem seu próprio atalho. Você já viu '.', que corresponde a qualquer caractere exceto uma nova linha. Há três outros pares particularmente úteis:
"
#1º \d corresponde a qualquer dígito; \D corresponde a qualquer coisa que não seja um dígito.

#2º \s corresponde a qualquer espaço em branco (por exemplo, espaço, tabulação, nova linha); \S corresponde a qualquer coisa que não seja espaço em branco.

#3º \w corresponde a qualquer caractere de 'palavra', ou seja, letras e números; \W corresponde a qualquer caractere de 'não palavra'.


"
O seguinte código demonstra os seis atalhos com uma seleção de letras, números e caracteres de pontuação.
"
x <- "abcd ABCD 12345 -!@#%."
str_view(x, "\\d+")
str_view(x, "\\D+")
str_view(x, "\\s+")
str_view(x, "\\S+")
str_view(x, "\\w+")
str_view(x, "\\W+")

#----15.4.4 Quantificadores----
"
Quantificadores controlam quantas vezes um padrão corresponde. Na Seção 15.2 você aprendeu sobre '?' (0 ou 1 correspondência), '+' (1 ou mais correspondências) e '*' (0 ou mais correspondências). Por exemplo, 'colou?r' corresponderá à ortografia americana ou britânica, '\d+' corresponderá a um ou mais dígitos, e '\s?' corresponderá opcionalmente a um único item de espaço em branco. Você também pode especificar o número exato de correspondências com '{}':
"
#1º {n} corresponde exatamente n vezes.
#2º {n,} corresponde pelo menos n vezes.
#3º {n,m} corresponde entre n e m vezes.

#----15.4.5 Precedência de operadores e parênteses----
"
O que 'ab+' corresponde? Ele corresponde a 'a' seguido por um ou mais 'b's, ou corresponde a 'ab' repetido qualquer número de vezes? O que '^a|b$' corresponde? Ele corresponde à string completa 'a' ou à string completa 'b', ou ele corresponde a uma string que começa com 'a' ou uma string que termina com 'b'?

A resposta para essas perguntas é determinada pela precedência de operadores, semelhante às regras PEMDAS ou BEDMAS que você pode ter aprendido na escola. Você sabe que 'a + b * c' é equivalente a 'a + (b * c)' e não '(a + b) * c' porque '' tem maior precedência e '+' tem menor precedência: você calcula '' antes de '+'.

Da mesma forma, expressões regulares têm suas próprias regras de precedência: quantificadores têm alta precedência e alternância tem baixa precedência, o que significa que 'ab+' é equivalente a 'a(b+)', e '^a|b$' é equivalente a '(^a)|(b$)'. Assim como na álgebra, você pode usar parênteses para substituir a ordem usual. Mas, ao contrário da álgebra, é improvável que você lembre das regras de precedência para regexes, então sinta-se à vontade para usar parênteses liberalmente.
"

#----15.4.6 Agrupamento e captura----
"
Além de substituir a precedência de operadores, os parênteses têm outro efeito importante: eles criam grupos de captura que permitem que você use subcomponentes da correspondência.

A primeira maneira de usar um grupo de captura é referir-se a ele dentro de uma correspondência com uma referência de volta: \1 refere-se à correspondência contida no primeiro parêntese, \2 no segundo parêntese, e assim por diante. Por exemplo, o seguinte padrão encontra todas as frutas que têm um par de letras repetido:
"
str_view(fruit, "(..)\\1")

"
E este encontra todas as palavras que começam e terminam com o mesmo par de letras:
"
str_view(words, "^(..).*\\1$")

"
Você também pode usar referências de volta em str_replace(). Por exemplo, este código troca a ordem da segunda e terceira palavras em frases:
"
sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()

"
Se você quiser extrair as correspondências para cada grupo, pode usar str_match(). Mas str_match() retorna uma matriz, então não é particularmente fácil de trabalhar com:
"
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  head()

"
Você poderia converter em uma tibble e nomear as colunas:
"
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  as_tibble(.name_repair = "minimal") |> 
  set_names("match", "word1", "word2")

"
Mas então você basicamente recriou sua própria versão de separate_wider_regex(). De fato, por trás dos bastidores, separate_wider_regex() converte seu vetor de padrões em uma única regex que usa agrupamento para capturar os componentes nomeados.

Ocasionalmente, você vai querer usar parênteses sem criar grupos de correspondência. Você pode criar um grupo não capturante com (?:).
"
x <- c("a gray cat", "a grey dog")
str_match(x, "gr(e|a)y")
str_match(x, "gr(?:e|a)y")

#----15.5 Controle de padrão----
"
É possível exercer controle extra sobre os detalhes da correspondência usando um objeto de padrão em vez de apenas uma string. Isso permite controlar as chamadas flags de regex e corresponder a vários tipos de strings fixas, conforme descrito abaixo.
"

#----15.5.1 Regex flags----
"
Existem várias configurações que podem ser usadas para controlar os detalhes da expressão regular. Essas configurações são frequentemente chamadas de flags em outras linguagens de programação. No stringr, você pode usar essas configurações envolvendo o padrão em uma chamada para regex(). A flag mais útil é provavelmente ignore_case = TRUE, porque permite que os caracteres correspondam tanto às suas formas maiúsculas quanto minúsculas:
"
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

"
Se você estiver trabalhando muito com strings multilinha (ou seja, strings que contêm \n), dotall e multiline também podem ser úteis:
"
#1º dotall = TRUE permite que . corresponda a tudo, incluindo \n:
x <- "Line 1\nLine 2\nLine 3"
str_view(x, ".Line")
str_view(x, regex(".Line", dotall = TRUE))

#2º multiline = TRUE faz com que ^ e $ correspondam ao início e ao fim de cada linha, em vez do início e do fim da string completa:
x <- "Line 1\nLine 2\nLine 3"
str_view(x, "^Line")
str_view(x, regex("^Line", multiline = TRUE))

"
Finalmente, se você estiver escrevendo uma expressão regular complicada e estiver preocupado que possa não entender no futuro, você pode tentar comments = TRUE. Isso ajusta a linguagem de padrões para ignorar espaços e novas linhas, bem como tudo depois de #. Isso permite que você use comentários e espaços em branco para tornar expressões regulares complexas mais compreensíveis, como no seguinte exemplo:
"
phone <- regex(
  r"(
    \(?     # optional opening parens
    (\d{3}) # area code
    [)\-]?  # optional closing parens or dash
    \ ?     # optional space
    (\d{3}) # another three numbers
    [\ -]?  # optional space or dash
    (\d{4}) # four more numbers
  )", 
  comments = TRUE
)

str_extract(c("514-791-8141", "(123) 456 7890", "123456"), phone)

"
Se você estiver usando comentários e quiser corresponder a um espaço, nova linha ou #, precisará escapar com \.
"

#----15.5.2 Fixed matches----
"
Você pode optar por não usar as regras de expressão regular usando fixed():
"
str_view(c("", "a", "."), fixed("."))

"
fixed() também lhe dá a capacidade de ignorar maiúsculas e minúsculas:
"
str_view("x X", "X")
str_view("x X", fixed("X", ignore_case = TRUE))

"
Se você estiver trabalhando com texto em idioma não inglês, provavelmente vai querer coll() em vez de fixed(), pois ele implementa as regras completas de capitalização usadas pelo local que você especificar.
"
str_view("i İ ı I", fixed("İ", ignore_case = TRUE))
str_view("i İ ı I", coll("İ", ignore_case = TRUE, locale = "tr"))

#----15.6 Prática----
"
Para colocar essas ideias em prática, resolveremos alguns problemas semi-autênticos a seguir. Discutiremos três técnicas gerais:
"
#1º Verificar seu trabalho criando controles positivos e negativos simples
#2º Combinar expressões regulares com álgebra booleana
#3º Criar padrões complexos usando manipulação de string

#----15.6.1 Check your work----
"
Primeiro, vamos encontrar todas as frases que começam com 'The'. Usar apenas o âncora '^' não é suficiente
"
str_view(sentences, "^The")

"
Porque esse padrão também corresponde a frases que começam com palavras como 'They' ou 'These'. Precisamos garantir que o 'e' seja a última letra da palavra, o que podemos fazer adicionando um limite de palavra:
"
str_view(sentences, "^The\\b")

"
E quanto a encontrar todas as frases que começam com um pronome?
"
str_view(sentences, "^She|He|It|They\\b")

"
Uma rápida inspeção dos resultados mostra que estamos obtendo algumas correspondências espúrias. Isso ocorre porque esquecemos de usar parênteses:
"
str_view(sentences, "^(She|He|It|They)\\b")

"
Você pode se perguntar como poderia detectar esse tipo de erro se ele não ocorresse nas primeiras correspondências. Uma boa técnica é criar alguns exemplos positivos e negativos e usá-los para testar se seu padrão funciona conforme o esperado:
"
pos <- c("He is a boy", "She had a good time")
neg <- c("Shells come from the sea", "Hadley said 'It's a great day'")

pattern <- "^(She|He|It|They)\\b"
str_detect(pos, pattern)
str_detect(neg, pattern)

"
Geralmente é muito mais fácil encontrar bons exemplos positivos do que negativos, porque leva um tempo até que você seja bom o suficiente com expressões regulares para prever onde estão suas fraquezas. No entanto, eles ainda são úteis: à medida que você trabalha no problema, você pode acumular lentamente uma coleção de seus erros, garantindo que nunca cometa o mesmo erro duas vezes.
"

#----15.6.2 Boolean operations----
"
Imagine que queremos encontrar palavras que contenham apenas consoantes. Uma técnica é criar uma classe de caracteres que contenha todas as letras, exceto as vogais ('[^aeiou]'), permitir que isso corresponda a qualquer número de letras ('[^aeiou]+'), depois forçá-la a corresponder a toda a string ancorando no início e no fim ('^[^aeiou]+$'):
"
str_view(words, "^[^aeiou]+$")

"
Mas você pode tornar esse problema um pouco mais fácil invertendo a questão. Em vez de procurar por palavras que contenham apenas consoantes, poderíamos procurar por palavras que não contenham nenhuma vogal:
"
str_view(words[!str_detect(words, "[aeiou]")])

"
Essa é uma técnica útil sempre que você estiver lidando com combinações lógicas, particularmente aquelas envolvendo 'e' ou 'não'. Por exemplo, imagine se você quiser encontrar todas as palavras que contêm 'a' e 'b'. Não há um operador 'e' incorporado nas expressões regulares, então temos que abordar isso procurando todas as palavras que contêm um 'a' seguido por um 'b' ou um 'b' seguido por um 'a':
"
str_view(words, "a.*b|b.*a")

"
É mais simples combinar os resultados de duas chamadas para str_detect():
"
words[str_detect(words, "a") & str_detect(words, "b")]

"
E se quiséssemos ver se há uma palavra que contém todas as vogais? Se fizéssemos isso com padrões, precisaríamos gerar 5! (120) padrões diferentes:
"
words[str_detect(words, "a.*e.*i.*o.*u")]
words[str_detect(words, "u.*o.*i.*e.*a")]

"
É muito mais simples combinar cinco chamadas para str_detect():
"
words[
  str_detect(words, "a") &
    str_detect(words, "e") &
    str_detect(words, "i") &
    str_detect(words, "o") &
    str_detect(words, "u")
]

"
Em geral, se você ficar preso tentando criar uma única regexp que resolva seu problema, dê um passo para trás e pense se você poderia dividir o problema em partes menores, resolvendo cada desafio antes de passar para o próximo.
"

#----15.6.3 Creating a pattern with code----
"
E se quiséssemos encontrar todas as frases que mencionam uma cor? A ideia básica é simples: nós apenas combinamos alternância com limites de palavras.
"
str_view(sentences, "\\b(red|green|blue)\\b")

"
Mas à medida que o número de cores aumenta, rapidamente se tornaria tedioso construir esse padrão manualmente. Não seria bom se pudéssemos armazenar as cores em um vetor?
"
rgb <- c("red", "green", "blue")

"
Bem, podemos! Só precisaríamos criar o padrão a partir do vetor usando str_c() e str_flatten():
"
str_c("\\b(", str_flatten(rgb, "|"), ")\\b")

"
Poderíamos tornar esse padrão mais abrangente se tivéssemos uma boa lista de cores. Um ponto de partida poderia ser a lista de cores integradas que o R pode usar para gráficos:
"
str_view(colors())

"
Mas primeiro vamos eliminar as variantes numeradas:
"
cols <- colors()
cols <- cols[!str_detect(cols, "\\d")]
str_view(cols)

"
Então, podemos transformar isso em um grande padrão. Não mostraremos o padrão aqui porque é enorme, mas você pode ver como ele funciona:
"
pattern <- str_c("\\b(", str_flatten(cols, "|"), ")\\b")
str_view(sentences, pattern)

"
Neste exemplo, 'cols' contém apenas números e letras, então você não precisa se preocupar com metacaracteres. Mas, em geral, sempre que você criar padrões a partir de strings existentes, é prudente executá-los através de str_escape() para garantir que eles correspondam literalmente.
"

#----15.7 Regular expressions in other places----
"
Assim como nas funções stringr e tidyr, há muitos outros lugares no R onde você pode usar expressões regulares. As seções a seguir descrevem algumas outras funções úteis no tidyverse mais amplo e no R base.
"

#----15.7.1 tidyverse----
"
Há três outros lugares particularmente úteis onde você pode querer usar expressões regulares:
"
#1º matches(pattern) selecionará todas as variáveis cujo nome corresponde ao padrão fornecido. É uma função 'tidyselect' que você pode usar em qualquer lugar, em qualquer função do tidyverse que selecione variáveis (por exemplo, select(), rename_with() e across()).
#2º O argumento names_pattern de pivot_longer() aceita um vetor de expressões regulares, assim como separate_wider_regex(). É útil ao extrair dados de nomes de variáveis com uma estrutura complexa.
#3º O argumento delim em separate_longer_delim() e separate_wider_delim() geralmente corresponde a uma string fixa, mas você pode usar regex() para fazer com que corresponda a um padrão. Isso é útil, por exemplo, se você quiser corresponder a uma vírgula que é opcionalmente seguida por um espaço, ou seja, regex(', ?').

#----15.7.2 Base R----
"
apropos(pattern) busca todos os objetos disponíveis no ambiente global que correspondem ao padrão fornecido. Isso é útil se você não se lembra exatamente do nome de uma função:
"
apropos("replace")

"
list.files(path, pattern) lista todos os arquivos em path que correspondem a um padrão de expressão regular. Por exemplo, você pode encontrar todos os arquivos R Markdown no diretório atual com:
"
head(list.files(pattern = "\\.Rmd$"))

"
Vale a pena notar que a linguagem de padrões usada pelo R base é ligeiramente diferente da usada pelo stringr. Isso porque o stringr é construído em cima do pacote stringi, que por sua vez é construído em cima do motor ICU, enquanto as funções do R base usam o motor TRE ou o motor PCRE, dependendo de você ter definido perl = TRUE ou não. Felizmente, os fundamentos das expressões regulares são tão bem estabelecidos que você encontrará poucas variações ao trabalhar com os padrões que você aprenderá neste livro. Você só precisa estar ciente da diferença quando começar a confiar em recursos avançados como complexos intervalos de caracteres Unicode ou recursos especiais que usam a sintaxe (?...).
"

#Capítulo 16: Fatores----

#----16.1 Introdução----
"
Os fatores são usados para variáveis categóricas, variáveis que têm um conjunto fixo e conhecido de valores possíveis. Eles também são úteis quando você deseja exibir vetores de caracteres em uma ordem não alfabética.

Começaremos motivando por que os fatores são necessários para análise de dados e como você pode criá-los com factor(). Em seguida, vamos apresentá-lo ao conjunto de dados gss_cat, que contém um monte de variáveis categóricas para experimentar. Você usará esse conjunto de dados para praticar a modificação da ordem e dos valores dos fatores, antes de terminarmos com uma discussão sobre fatores ordenados.
"

#----16.1.1 Pré-requisitos----
"
O R base fornece algumas ferramentas básicas para criar e manipular fatores. Vamos complementar essas ferramentas com o pacote forcats, que faz parte do core tidyverse. Ele fornece ferramentas para lidar com variáveis categóricas (e é um anagrama de fatores!) usando uma ampla gama de ajudantes para trabalhar com fatores.
"
library(tidyverse)

#----16.2 Noções básicas de fatores----
"
Imagine que você tem uma variável que registra o mês:
"
x1 <- c("Dec", "Apr", "Jan", "Mar")

"
Usar uma string para registrar essa variável tem dois problemas:
"
#1º Há apenas doze meses possíveis, e não há nada que o proteja de erros de digitação:
x2 <- c("Dec", "Apr", "Jam", "Mar")

#2º Não é ordenado de uma maneira útil:
sort(x1)

"
Você pode corrigir ambos os problemas com um fator. Para criar um fator, você deve começar criando uma lista dos níveis válidos:
"
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

"
Agora você pode criar um fator:
"
y1 <- factor(x1, levels = month_levels)
y1

sort(y1)

"
E quaisquer valores que não estejam no nível serão silenciosamente convertidos em NA:
"
y2 <- factor(x2, levels = month_levels)
y2

"
Isso parece arriscado, então você pode querer usar forcats::fct() em vez disso:
"
y2 <- fct(x2, levels = month_levels)

"
Se você omitir os níveis, eles serão retirados dos dados em ordem alfabética:
"
factor(x1)

"
Ordenar alfabeticamente é um pouco arriscado porque nem todo computador ordenará strings da mesma maneira. Então forcats::fct() ordena pela primeira aparição:
"
fct(x1)

"
Se você precisar acessar o conjunto de níveis válidos diretamente, pode fazer isso com levels():
"
levels(y2)

"
Você também pode criar um fator ao ler seus dados com readr com col_factor():
"
csv <- "
month,value
Jan,12
Feb,56
Mar,12"

df <- read_csv(csv, col_types = cols(month = col_factor(month_levels)))
df$month

#----16.3 Pesquisa Social Geral----
"
Daqui em diante, vamos usar forcats::gss_cat. É uma amostra de dados da Pesquisa Social Geral, uma pesquisa de longa duração nos EUA conduzida pela organização independente de pesquisa NORC na Universidade de Chicago. A pesquisa tem milhares de perguntas, então em gss_cat, Hadley selecionou algumas que ilustrarão alguns desafios comuns que você encontrará ao trabalhar com fatores.
"
gss_cat

"
(Lembre-se, como este conjunto de dados é fornecido por um pacote, você pode obter mais informações sobre as variáveis com ?gss_cat.)

Quando fatores são armazenados em um tibble, você não pode ver seus níveis tão facilmente. Uma maneira de visualizá-los é com count():
"
gss_cat |>
  count(race)

"
Ao trabalhar com fatores, as duas operações mais comuns são mudar a ordem dos níveis e mudar os valores dos níveis. Essas operações são descritas nas seções abaixo.
"

#----16.4 Modificando a ordem dos fatores----
"
Frequentemente, é útil alterar a ordem dos níveis dos fatores em uma visualização. Por exemplo, imagine que você queira explorar a média de horas gastas assistindo TV por dia entre as religiões:
"
relig_summary <- gss_cat |>
  group_by(relig) |>
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(x = tvhours, y = relig)) + 
  geom_point()

"
É difícil ler este gráfico porque não há um padrão geral. Podemos melhorá-lo reordenando os níveis de 'relig' usando fct_reorder(). fct_reorder() recebe três argumentos:
"
#1º f, o fator cujos níveis você deseja modificar.
#2º x, um vetor numérico que você deseja usar para reordenar os níveis.
#3º Opcionalmente, fun, uma função que é usada se houver vários valores de x para cada valor de f. O valor padrão é mediana.

ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) +
  geom_point()

"
Reordenar a religião facilita muito ver que as pessoas na categoria 'Não sei' assistem muito mais TV, e o Hinduísmo e outras religiões orientais assistem muito menos.

À medida que você começa a fazer transformações mais complicadas, recomendamos movê-las para fora de aes() e para um passo de mutate() separado. Por exemplo, você poderia reescrever o gráfico acima como:
"
relig_summary |>
  mutate(
    relig = fct_reorder(relig, tvhours)
  ) |>
  ggplot(aes(x = tvhours, y = relig)) +
  geom_point()

"
E se criarmos um gráfico semelhante olhando como a idade média varia de acordo com o nível de renda relatado?
"
rincome_summary <- gss_cat |>
  group_by(rincome) |>
  summarize(
    age = mean(age, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(x = age, y = fct_reorder(rincome, age))) + 
  geom_point()

"
Aqui, reordenar arbitrariamente os níveis não é uma boa ideia! Isso porque 'rincome' já tem uma ordem fundamentada que não devemos mexer. Reserve fct_reorder() para fatores cujos níveis são ordenados arbitrariamente.

No entanto, faz sentido trazer 'Não aplicável' para a frente com os outros níveis especiais. Você pode usar fct_relevel(). Ele recebe um fator, f, e então qualquer número de níveis que você deseja mover para a frente da linha.
"
ggplot(rincome_summary, aes(x = age, y = fct_relevel(rincome, "Not applicable"))) +
  geom_point()

"
Por que você acha que a idade média para 'Não aplicável' é tão alta?

Outro tipo de reordenação é útil quando você está colorindo as linhas em um gráfico. fct_reorder2(f, x, y) reordena o fator f pelos valores de y associados aos maiores valores de x. Isso torna o gráfico mais fácil de ler porque as cores da linha no canto direito do gráfico se alinharão com a legenda.
"
by_age <- gss_cat |>
  filter(!is.na(age)) |> 
  count(age, marital) |>
  group_by(age) |>
  mutate(
    prop = n / sum(n)
  )

ggplot(by_age, aes(x = age, y = prop, color = marital)) +
  geom_line(linewidth = 1) + 
  scale_color_brewer(palette = "Set1")

ggplot(by_age, aes(x = age, y = prop, color = fct_reorder2(marital, age, prop))) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1") + 
  labs(color = "marital") 

"
Finalmente, para gráficos de barras, você pode usar fct_infreq() para ordenar os níveis em frequência decrescente: este é o tipo mais simples de reordenação porque não precisa de variáveis extras. Combine-o com fct_rev() se você quiser que eles estejam em frequência crescente, para que no gráfico de barras os maiores valores estejam à direita, não à esquerda.
"
gss_cat |>
  mutate(marital = marital |> fct_infreq() |> fct_rev()) |>
  ggplot(aes(x = marital)) +
  geom_bar()

#----16.5 Modificando os níveis dos fatores----
"
Mais poderoso do que alterar a ordem dos níveis é mudar seus valores. Isso permite esclarecer rótulos para publicação e colapsar níveis para exibições de alto nível. A ferramenta mais geral e poderosa é fct_recode(). Ela permite que você recodifique ou altere o valor de cada nível. Por exemplo, pegue a variável partyid do data frame gss_cat:
"
gss_cat |> count(partyid)

"
Os níveis são concisos e inconsistentes. Vamos ajustá-los para serem mais longos e usar uma construção paralela. Como a maioria das funções de renomear e recodificar no tidyverse, os novos valores vão à esquerda e os valores antigos à direita:
"
gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat"
    )
  ) |>
  count(partyid)

"
fct_recode() deixará os níveis que não são explicitamente mencionados como estão e avisará se você acidentalmente se referir a um nível que não existe.

Para combinar grupos, você pode atribuir vários níveis antigos ao mesmo novo nível:
"
gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat",
                         "Other"                 = "No answer",
                         "Other"                 = "Don't know",
                         "Other"                 = "Other party"
    )
  )

"
Use essa técnica com cuidado: se você agrupar categorias que são verdadeiramente diferentes, acabará com resultados enganosos.

Se você quiser colapsar muitos níveis, fct_collapse() é uma variante útil de fct_recode(). Para cada nova variável, você pode fornecer um vetor de níveis antigos:
"
gss_cat |>
  mutate(
    partyid = fct_collapse(partyid,
                           "other" = c("No answer", "Don't know", "Other party"),
                           "rep" = c("Strong republican", "Not str republican"),
                           "ind" = c("Ind,near rep", "Independent", "Ind,near dem"),
                           "dem" = c("Not str democrat", "Strong democrat")
    )
  ) |>
  count(partyid)

"
Às vezes, você só quer agrupar os pequenos grupos para simplificar um gráfico ou tabela. Esse é o trabalho da família de funções fct_lump_*(). fct_lump_lowfreq() é um ponto de partida simples que agrupa progressivamente as menores categorias em 'Outros', sempre mantendo 'Outros' como a menor categoria.
"
gss_cat |>
  mutate(relig = fct_lump_lowfreq(relig)) |>
  count(relig)

"
Neste caso, não é muito útil: é verdade que a maioria dos americanos nesta pesquisa são protestantes, mas provavelmente gostaríamos de ver mais detalhes! Em vez disso, podemos usar fct_lump_n() para especificar que queremos exatamente 10 grupos:
"
gss_cat |>
  mutate(relig = fct_lump_n(relig, n = 10)) |>
  count(relig, sort = TRUE)

"
Leia a documentação para aprender sobre fct_lump_min() e fct_lump_prop() que são úteis em outros casos.
"

#----16.6 Fatores ordenados----
"
Antes de continuarmos, há um tipo especial de fator que precisa ser mencionado brevemente: fatores ordenados. Fatores ordenados, criados com ordered(), implicam uma ordenação estrita e uma distância igual entre os níveis: o primeiro nível é 'menor que' o segundo nível pela mesma quantidade que o segundo nível é 'menor que' o terceiro nível, e assim por diante. Você pode reconhecê-los ao imprimir porque eles usam '<' entre os níveis do fator:
"
ordered(c("a", "b", "c"))

"
Na prática, os fatores ordenados se comportam de maneira muito semelhante aos fatores regulares. Há apenas dois lugares onde você pode notar um comportamento diferente:
"
#1º Se você mapear um fator ordenado para cor ou preenchimento no ggplot2, ele usará por padrão scale_color_viridis()/scale_fill_viridis(), uma escala de cores que implica uma classificação.
#2º Se você usar uma função ordenada em um modelo linear, ele usará "contrastes poligonais". Estes são moderadamente úteis, mas é improvável que você tenha ouvido falar deles, a menos que tenha um PhD em Estatística, e mesmo assim, provavelmente não os interpreta rotineiramente. Se você quiser aprender mais, recomendamos vignette("contrasts", package = "faux") por Lisa DeBruine.

"
Dada a utilidade questionável dessas diferenças, geralmente não recomendamos o uso de fatores ordenados.
"

#Capítulo 17 : Datas e Horas----

#----17.1 Introdução----
"
Este capítulo mostrará como trabalhar com datas e horas em R. À primeira vista, datas e horas parecem simples. Você as usa o tempo todo em sua vida cotidiana, e elas não parecem causar muita confusão. No entanto, quanto mais você aprende sobre datas e horas, mais complicadas elas parecem!

Para aquecer, pense em quantos dias há em um ano e quantas horas há em um dia. Você provavelmente se lembrou de que a maioria dos anos tem 365 dias, mas os anos bissextos têm 366. Você sabe a regra completa para determinar se um ano é um ano bissexto? O número de horas em um dia é um pouco menos óbvio: a maioria dos dias tem 24 horas, mas em lugares que usam o horário de verão (DST), um dia a cada ano tem 23 horas e outro tem 25.

Datas e horas são difíceis porque têm que conciliar dois fenômenos físicos (a rotação da Terra e sua órbita ao redor do sol) com uma série de fenômenos geopolíticos, incluindo meses, fusos horários e horário de verão. Este capítulo não ensinará todos os detalhes sobre datas e horas, mas fornecerá uma base sólida de habilidades práticas que ajudarão você com desafios comuns de análise de dados.

Começaremos mostrando como criar data-horas a partir de várias entradas e, uma vez que você tenha uma data-hora, como extrair componentes como ano, mês e dia. Em seguida, mergulharemos no complicado tópico de trabalhar com intervalos de tempo, que vêm em uma variedade de sabores, dependendo do que você está tentando fazer. Concluiremos com uma breve discussão sobre os desafios adicionais impostos pelos fusos horários.
"

#----17.1.1 Pré-requisitos----
"
Este capítulo se concentrará no pacote lubridate, que facilita o trabalho com datas e horas em R. A partir da última versão do tidyverse, o lubridate faz parte do core tidyverse. Também precisaremos do nycflights13 para dados práticos.
"
library(tidyverse)
library(nycflights13)

#----17.2 Criando data/hora----
"
Existem três tipos de dados de data/hora que se referem a um instante no tempo:
"
#1º Uma data. Tibbles imprime isso como <date>.
#2º Um tempo dentro de um dia. Tibbles imprime isso como <time>.
#3º Uma data-hora é uma data mais um tempo: ela identifica exclusivamente um instante no tempo (normalmente até o segundo mais próximo). Tibbles imprime isso como <dttm>. O R base chama esses de POSIXct, mas isso não é exatamente fácil de pronunciar.

"
Aqui, vamos nos concentrar em datas e data-horas, pois o R não tem uma classe nativa para armazenar tempos. Se você precisar de uma, pode usar o pacote hms.

Você deve sempre usar o tipo de dados mais simples possível que atenda às suas necessidades. Isso significa que se você pode usar uma data em vez de uma data-hora, você deve. Data-horas são substancialmente mais complicadas por causa da necessidade de lidar com fusos horários, aos quais voltaremos no final do capítulo.

Para obter a data ou data-hora atual, você pode usar today() ou now():
"
today()
now()

"
Caso contrário, as seções a seguir descrevem as quatro maneiras pelas quais você provavelmente criará uma data/hora:
"
#1º Enquanto lê um arquivo com readr.
#2º A partir de uma string.
#3º A partir de componentes individuais de data-hora.
#4º A partir de um objeto de data/hora existente.

#----17.2.1 Durante a importação----
"
Se o seu CSV contém uma data ou data-hora no formato ISO8601, você não precisa fazer nada; o readr reconhecerá automaticamente:
"
csv <- "
  date,datetime
  2022-01-02,2022-01-02 05:12
"
read_csv(csv)

"
Se você nunca ouviu falar de ISO8601 antes, é um padrão internacional para escrever datas onde os componentes de uma data são organizados do maior para o menor separados por '-'. Por exemplo, em ISO8601, 3 de maio de 2022 é 2022-05-03. Datas ISO8601 também podem incluir horas, onde hora, minuto e segundo são separados por ':', e os componentes de data e hora são separados por um 'T' ou um espaço. Por exemplo, você poderia escrever 16:26 do dia 3 de maio de 2022 como 2022-05-03 16:26 ou 2022-05-03T16:26.

Para outros formatos de data-hora, você precisará usar col_types mais col_date() ou col_datetime() junto com um formato de data-hora. O formato de data-hora usado pelo readr é um padrão usado em muitas linguagens de programação, descrevendo um componente de data com um '%' seguido por um único caractere.

E este código mostra algumas opções aplicadas a uma data muito ambígua:
"
csv <- "
  date
  01/02/15
"

read_csv(csv, col_types = cols(date = col_date("%m/%d/%y")))

read_csv(csv, col_types = cols(date = col_date("%d/%m/%y")))

read_csv(csv, col_types = cols(date = col_date("%y/%m/%d")))

"
Observe que, não importa como você especifique o formato da data, ela sempre será exibida da mesma maneira assim que você a inserir no R.

Se você estiver usando %b ou %B e trabalhando com datas não inglesas, também precisará fornecer um locale(). Veja a lista de idiomas integrados em date_names_langs(), ou crie o seu próprio com date_names().
"

#----17.2.2 De strings----
"
A linguagem de especificação de data-hora é poderosa, mas requer uma análise cuidadosa do formato da data. Uma abordagem alternativa é usar os auxiliares do lubridate, que tentam determinar automaticamente o formato uma vez que você especifica a ordem dos componentes. Para usá-los, identifique a ordem em que o ano, mês e dia aparecem em suas datas e, em seguida, organize 'y', 'm' e 'd' na mesma ordem. Isso lhe dará o nome da função lubridate que irá analisar sua data. Por exemplo:
"
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

"
ymd() e amigos criam datas. Para criar uma data-hora, adicione um sublinhado e um ou mais de 'h', 'm' e 's' ao nome da função de análise:
"
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

"
Você também pode forçar a criação de uma data-hora a partir de uma data fornecendo um fuso horário:
"
ymd("2017-01-31", tz = "UTC")

"
Aqui eu uso o fuso horário UTC, que você também pode conhecer como GMT, ou Horário Médio de Greenwich, o horário a 0° de longitude. Ele não usa horário de verão, tornando-o um pouco mais fácil de calcular.
"

#----17.2.3 De componentes individuais----
"
Às vezes, em vez de uma única string, você terá os componentes individuais da data-hora distribuídos em várias colunas. É isso que temos nos dados dos voos:
"
flights |> 
  select(year, month, day, hour, minute)

"
Para criar uma data/hora a partir desse tipo de entrada, use make_date() para datas ou make_datetime() para data-horas:
"
flights |> 
  select(year, month, day, hour, minute) |> 
  mutate(departure = make_datetime(year, month, day, hour, minute))

"
Vamos fazer o mesmo para cada uma das quatro colunas de tempo nos voos. Os tempos são representados em um formato um pouco estranho, então usamos aritmética modular para extrair os componentes de hora e minuto. Depois de criarmos as variáveis de data-hora, nos concentramos nas variáveis que exploraremos daqui em diante
"
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights |> 
  filter(!is.na(dep_time), !is.na(arr_time)) |> 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) |> 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

"
Com esses dados, podemos visualizar a distribuição dos horários de partida ao longo do ano:
"
flights_dt |> 
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 segundos = 1 dia

"
Ou em um único dia:
"
flights_dt |> 
  filter(dep_time < ymd(20130102)) |> 
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 segundos = 10 minutos

"
Observe que quando você usa data-horas em um contexto numérico (como em um histograma), 1 significa 1 segundo, então um binwidth de 86400 significa um dia. Para datas, 1 significa 1 dia.
"

#----17.2.4 De outros tipos----
"
Você pode querer alternar entre uma data-hora e uma data. Essa é a função de as_datetime() e as_date():
"
as_datetime(today())
as_date(now())

"
Às vezes, você receberá data/horas como deslocamentos numéricos da 'Era Unix', 1970-01-01. Se o deslocamento for em segundos, use as_datetime(); se for em dias, use as_date().
"
as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)

#----17.3 Componentes de data-hora----
"
Agora que você sabe como inserir dados de data-hora nas estruturas de data-hora do R, vamos explorar o que você pode fazer com eles. Esta seção se concentrará nas funções de acesso que permitem obter e definir componentes individuais. A próxima seção examinará como a aritmética funciona com data-horas.
"

#----17.3.1 Obtendo componentes----
"
Você pode extrair partes individuais da data com as funções de acesso year(), month(), mday() (dia do mês), yday() (dia do ano), wday() (dia da semana), hour(), minute() e second(). Estas são efetivamente o oposto de make_datetime().
"
datetime <- ymd_hms("2026-07-08 12:34:56")

year(datetime)
month(datetime)
mday(datetime)

yday(datetime)
wday(datetime)

"
Para month() e wday(), você pode definir label = TRUE para retornar o nome abreviado do mês ou dia da semana. Defina abbr = FALSE para retornar o nome completo.
"
month(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)

"
Podemos usar wday() para ver que mais voos partem durante a semana do que no fim de semana:
"
flights_dt |> 
  mutate(wday = wday(dep_time, label = TRUE)) |> 
  ggplot(aes(x = wday)) +
  geom_bar()

"
Também podemos olhar para o atraso médio de partida por minuto dentro da hora. Há um padrão interessante: voos que partem nos minutos 20-30 e 50-60 têm muito menos atrasos do que o restante da hora!
"
flights_dt |> 
  mutate(minute = minute(dep_time)) |> 
  group_by(minute) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  ) |> 
  ggplot(aes(x = minute, y = avg_delay)) +
  geom_line()

"
Curiosamente, se olharmos para o horário de partida programado, não vemos um padrão tão forte:
"
sched_dep <- flights_dt |> 
  mutate(minute = minute(sched_dep_time)) |> 
  group_by(minute) |> 
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(sched_dep, aes(x = minute, y = avg_delay)) +
  geom_line()


#----17.3.2 Arredondando----
"
Uma abordagem alternativa para traçar componentes individuais é arredondar a data para uma unidade de tempo próxima, com floor_date(), round_date() e ceiling_date(). Cada função recebe um vetor de datas para ajustar e, em seguida, o nome da unidade para arredondar para baixo (floor), arredondar para cima (ceiling) ou arredondar. Isso, por exemplo, nos permite traçar o número de voos por semana:
"
flights_dt |> 
  count(week = floor_date(dep_time, "week")) |> 
  ggplot(aes(x = week, y = n)) +
  geom_line() + 
  geom_point()

"
Você pode usar o arredondamento para mostrar a distribuição de voos ao longo do curso de um dia calculando a diferença entre dep_time e o instante mais cedo daquele dia:
"
flights_dt |> 
  mutate(dep_hour = dep_time - floor_date(dep_time, "day")) |> 
  ggplot(aes(x = dep_hour)) +
  geom_freqpoly(binwidth = 60 * 30)

"
Calcular a diferença entre um par de datas-horas resulta em um difftime. Podemos converter isso em um objeto hms para obter um eixo x mais útil:
"
flights_dt |> 
  mutate(dep_hour = hms::as_hms(dep_time - floor_date(dep_time, "day"))) |> 
  ggplot(aes(x = dep_hour)) +
  geom_freqpoly(binwidth = 60 * 30)

#----17.3.3 Modificando componentes----
"
Você também pode usar cada função de acesso para modificar os componentes de uma data/hora. Isso não ocorre muito em análise de dados, mas pode ser útil ao limpar dados que têm datas claramente incorretas.
"
(datetime <- ymd_hms("2026-07-08 12:34:56"))

year(datetime) <- 2030
datetime
month(datetime) <- 01
datetime
hour(datetime) <- hour(datetime) + 1
datetime

"
Alternativamente, em vez de modificar uma variável existente, você pode criar uma nova data-hora com update(). Isso também permite que você defina vários valores em uma etapa:
"
update(datetime, year = 2030, month = 2, mday = 2, hour = 2)

"
Se os valores forem muito grandes, eles passarão para o próximo valor:
"
update(ymd("2023-02-01"), mday = 30)
update(ymd("2023-02-01"), hour = 400)

#----17.4 Intervalos de tempo----
"
Em seguida, você aprenderá sobre como a aritmética com datas funciona, incluindo subtração, adição e divisão. Ao longo do caminho, você aprenderá sobre três classes importantes que representam intervalos de tempo:
"
#1º Durações, que representam um número exato de segundos.
#2º Períodos, que representam unidades humanas como semanas e meses.
#3º Intervalos, que representam um ponto inicial e final.

"
Como escolher entre duração, períodos e intervalos? Como sempre, escolha a estrutura de dados mais simples que resolve seu problema. Se você se preocupa apenas com o tempo físico, use uma duração; se precisar adicionar tempos humanos, use um período; se precisar descobrir quanto tempo um intervalo dura em unidades humanas, use um intervalo.
"

#----17.4.1 Durações----
"
No R, quando você subtrai duas datas, você obtém um objeto difftime:
"
# Qual a idade de Hadley?
h_age <- today() - ymd("1979-10-14")
h_age

"
Um objeto de classe difftime registra um intervalo de tempo em segundos, minutos, horas, dias ou semanas. Essa ambiguidade pode tornar difftimes um pouco difícil de trabalhar, então o lubridate fornece uma alternativa que sempre usa segundos: a duração.
"
as.duration(h_age)

"
Durações vêm com uma série de construtores convenientes:
"
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)

"
Durações sempre registram o intervalo de tempo em segundos. Unidades maiores são criadas convertendo minutos, horas, dias, semanas e anos em segundos: 60 segundos em um minuto, 60 minutos em uma hora, 24 horas em um dia e 7 dias em uma semana. Unidades de tempo maiores são mais problemáticas. Um ano usa o número 'médio' de dias em um ano, ou seja, 365,25. Não há como converter um mês em duração, porque há muita variação.

Você pode adicionar e multiplicar durações:
"
2 * dyears(1)
dyears(1) + dweeks(12) + dhours(15)

"
Você pode adicionar e subtrair durações de e para dias:
"
tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

"
No entanto, porque as durações representam um número exato de segundos, às vezes você pode obter um resultado inesperado:
"
one_am <- ymd_hms("2026-03-08 01:00:00", tz = "America/New_York")

one_am
one_am + ddays(1)

"
Por que um dia após 1h de 8 de março é 2h de 9 de março? Se você olhar atentamente para a data, também poderá notar que os fusos horários mudaram. 8 de março tem apenas 23 horas porque é quando o horário de verão começa, então, se adicionarmos um dia inteiro de segundos, acabaremos com um horário diferente.
"

#----17.4.2 Períodos----
"
Para resolver esse problema, o lubridate fornece períodos. Períodos são intervalos de tempo, mas não têm um comprimento fixo em segundos, em vez disso, eles trabalham com tempos 'humanos', como dias e meses. Isso permite que eles funcionem de uma maneira mais intuitiva:
"
one_am
one_am + days(1)

"
Como as durações, os períodos podem ser criados com uma série de funções construtoras amigáveis.
"
hours(c(12, 24))
days(7)
months(1:6)

"
Você pode adicionar e multiplicar períodos:
"
10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)

"
E, claro, adicioná-los a datas. Comparados com durações, os períodos têm mais probabilidade de fazer o que você espera:
"
# Um ano bissexto
ymd("2024-01-01") + dyears(1)
ymd("2024-01-01") + years(1)

# Horário de Verão
one_am + ddays(1)
one_am + days(1)

"
Vamos usar períodos para corrigir uma peculiaridade relacionada às nossas datas de voo. Alguns aviões parecem ter chegado ao destino antes de partirem de Nova York.
"
flights_dt |> 
  filter(arr_time < dep_time) 

"
Esses são voos noturnos. Usamos a mesma informação de data para os horários de partida e chegada, mas esses voos chegaram no dia seguinte. Podemos corrigir isso adicionando days(1) ao horário de chegada de cada voo noturno.
"
flights_dt <- flights_dt |> 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight),
    sched_arr_time = sched_arr_time + days(overnight)
  )

"
Agora todos os nossos voos obedecem às leis da física.
"
flights_dt |> 
  filter(arr_time < dep_time) 


#----17.4.3 Intervalos----
"
O que dyears(1) / ddays(365) retorna? Não é exatamente um, porque dyears() é definido como o número de segundos por ano médio, que é 365,25 dias.

O que years(1) / days(1) retorna? Bem, se o ano fosse 2015, deveria retornar 365, mas se fosse 2016, deveria retornar 366! Não há informações suficientes para que o lubridate dê uma única resposta clara. O que ele faz, em vez disso, é dar uma estimativa:
"
years(1) / days(1)

"
Se você quiser uma medição mais precisa, terá que usar um intervalo. Um intervalo é um par de datas de início e término, ou você pode pensar nele como uma duração com um ponto de partida.

Você pode criar um intervalo escrevendo inicio %--% fim:
"
y2023 <- ymd("2023-01-01") %--% ymd("2024-01-01")
y2024 <- ymd("2024-01-01") %--% ymd("2025-01-01")

y2023
y2024

"
Você poderia então dividi-lo por days() para descobrir quantos dias cabem no ano:
"
y2023 / days(1)
y2024 / days(1)

#----17.5 Fusos horários----
"
Os fusos horários são um tópico extremamente complicado por causa de sua interação com entidades geopolíticas. Felizmente, não precisamos mergulhar em todos os detalhes, pois nem todos são importantes para a análise de dados, mas há alguns desafios que precisaremos enfrentar diretamente.

O primeiro desafio é que os nomes comuns de fusos horários tendem a ser ambíguos. Por exemplo, se você é americano, provavelmente está familiarizado com o EST, ou Eastern Standard Time. No entanto, tanto a Austrália quanto o Canadá também têm EST! Para evitar confusão, o R usa os fusos horários padrão internacionais da IANA. Eles usam um esquema de nomenclatura consistente {área}/{localização}, tipicamente na forma {continente}/{cidade} ou {oceano}/{cidade}. Exemplos incluem 'America/New_York', 'Europe/Paris' e 'Pacific/Auckland'.

Você pode se perguntar por que o fuso horário usa uma cidade, quando normalmente pensa-se em fusos horários associados a um país ou região dentro de um país. Isso ocorre porque o banco de dados da IANA precisa registrar décadas de regras de fuso horário. Ao longo de décadas, os países mudam de nome (ou se separam) com bastante frequência, mas os nomes das cidades tendem a permanecer os mesmos. Outro problema é que o nome precisa refletir não apenas o comportamento atual, mas também a história completa. Por exemplo, existem fusos horários tanto para 'America/New_York' quanto para 'America/Detroit'. Essas cidades atualmente usam o Eastern Standard Time, mas de 1969 a 1972, Michigan (estado onde Detroit está localizada) não seguiu o horário de verão (DST), então precisa de um nome diferente. Vale a pena ler o banco de dados de fuso horário bruto (disponível em https://www.iana.org/time-zones) apenas para ler algumas dessas histórias!

Você pode descobrir o que o R pensa que é o seu fuso horário atual com Sys.timezone():
"
Sys.timezone()

"
(Se o R não souber, você receberá um NA.)

E veja a lista completa de todos os nomes de fuso horário com OlsonNames():
"
length(OlsonNames())
head(OlsonNames())

"
No R, o fuso horário é um atributo da data-hora que controla apenas a impressão. Por exemplo, estes três objetos representam o mesmo instante no tempo:
"
x1 <- ymd_hms("2024-06-01 12:00:00", tz = "America/New_York")
x1

x2 <- ymd_hms("2024-06-01 18:00:00", tz = "Europe/Copenhagen")
x2

x3 <- ymd_hms("2024-06-02 04:00:00", tz = "Pacific/Auckland")
x3

"
Você pode verificar que são o mesmo tempo usando a subtração:
"
x1 - x2
x1 - x3

"
A menos que especificado de outra forma, o lubridate sempre usa UTC. UTC (Coordinated Universal Time) é o fuso horário padrão usado pela comunidade científica e é aproximadamente equivalente ao GMT (Greenwich Mean Time). Ele não tem DST, o que o torna uma representação conveniente para cálculos. Operações que combinam data-horas, como c(), muitas vezes eliminarão o fuso horário. Nesse caso, as data-horas serão exibidas no fuso horário do primeiro elemento:
"
x4 <- c(x1, x2, x3)
x4
"
Você pode alterar o fuso horário de duas maneiras:
"
#1º Mantenha o mesmo instante no tempo e altere como ele é exibido. Use isso quando o instante estiver correto, mas você quiser uma exibição mais natural.
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe")
x4a

x4a - x4

#(Isso também ilustra outro desafio dos fusos horários: nem todos são deslocamentos de hora inteira!)

#2º Altere o instante subjacente no tempo. Use isso quando você tem um instante que foi rotulado com o fuso horário incorreto e precisa corrigi-lo.
x4b <- force_tz(x4, tzone = "Australia/Lord_Howe")
x4b

x4b - x4

#----Capítulo 18 : Valores Ausentes----

#----18.1 Introdução----
"
Você já aprendeu o básico sobre valores ausentes anteriormente no livro. Agora, voltaremos a eles com mais profundidade, para que você possa aprender mais detalhes.

Começaremos discutindo algumas ferramentas gerais para trabalhar com valores ausentes registrados como NAs. Em seguida, exploraremos a ideia de valores implicitamente ausentes, valores que simplesmente não estão presentes nos seus dados, e mostraremos algumas ferramentas que você pode usar para torná-los explícitos. Finalizaremos com uma discussão relacionada sobre grupos vazios, causados por níveis de fatores que não aparecem nos dados.
"


#----18.1.1 Pré-requisitos----
"
As funções para trabalhar com dados ausentes vêm principalmente do dplyr e tidyr, que são membros essenciais do tidyverse.
"
library(tidyverse)

#----18.2 Valores ausentes explícitos----
"
Para começar, vamos explorar algumas ferramentas úteis para criar ou eliminar valores explícitos ausentes, ou seja, células onde você vê um NA.
"

#----18.2.1 Última observação transportada para frente----
"

Um uso comum para valores ausentes é como uma conveniência na entrada de dados. Quando os dados são inseridos manualmente, valores ausentes às vezes indicam que o valor na linha anterior foi repetido (ou transferido):
"
treatment <- tribble(
  ~person,           ~treatment, ~response,
  "Derrick Whitmore", 1,         7,
  NA,                 2,         10,
  NA,                 3,         NA,
  "Katherine Burke",  1,         4
)
treatment

"
Você pode preencher esses valores ausentes com tidyr::fill(). Ele funciona como select(), tomando um conjunto de colunas:
"
treatment |>
  fill(everything())

"
Esse tratamento é às vezes chamado de 'última observação transferida para frente', ou locf, abreviadamente. Você pode usar o argumento .direction para preencher valores ausentes que foram gerados de formas mais exóticas.
"


#----18.2.2 Valores fixos----
"
Às vezes, valores ausentes representam um valor fixo e conhecido, mais comumente 0. Você pode usar dplyr::coalesce() para substituí-los:
"
x <- c(1, 4, 5, 7, NA)
coalesce(x, 0)

"
Às vezes, você encontrará o problema oposto, onde algum valor concreto representa, na verdade, um valor ausente. Isso geralmente surge em dados gerados por softwares mais antigos que não têm uma maneira adequada de representar valores ausentes, então, em vez disso, deve-se usar algum valor especial como 99 ou -999.

Se possível, trate isso ao ler os dados, por exemplo, usando o argumento na em readr::read_csv(), por exemplo, read_csv(caminho, na = '99'). Se você descobrir o problema mais tarde, ou sua fonte de dados não fornecer uma maneira de lidar com isso na leitura, você pode usar dplyr::na_if():
"
x <- c(1, 4, 5, 7, -99)
na_if(x, -99)

#----18.2.3 NaN----
"
Antes de continuarmos, há um tipo especial de valor ausente que você encontrará de vez em quando: um NaN (pronunciado 'nan'), ou não é um número. Não é tão importante saber disso porque geralmente se comporta exatamente como NA:
"
x <- c(NA, NaN)
x * 10
x == 1
is.na(x)

"
No raro caso em que você precise distinguir um NA de um NaN, você pode usar is.nan(x).

Você geralmente encontrará um NaN quando realizar uma operação matemática que tem um resultado indeterminado:
"
0 / 0 
0 * Inf
Inf - Inf
sqrt(-1)

#----18.3 Valores ausentes implícitos----
"
Até agora, falamos sobre valores ausentes que são explicitamente ausentes, ou seja, você pode ver um NA nos seus dados. Mas os valores ausentes também podem ser implicitamente ausentes, se uma linha inteira de dados simplesmente não estiver presente nos dados. Vamos ilustrar a diferença com um conjunto de dados simples que registra o preço de algumas ações a cada trimestre:
"
stocks <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(   1,    2,    3,    4,    2,    3,    4),
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks

"
Este conjunto de dados tem duas observações ausentes:
"
#1º O preço no quarto trimestre de 2020 está explicitamente ausente, porque seu valor é NA.
#2º O preço para o primeiro trimestre de 2021 está implicitamente ausente, porque simplesmente não aparece no conjunto de dados.

"
Uma maneira de pensar sobre a diferença é com este koan Zen-like:
"
# Um valor ausente explícito é a presença de uma ausência.
# Um valor ausente implícito é a ausência de uma presença.

"
Às vezes você quer tornar as ausências implícitas explícitas para ter algo físico com o qual trabalhar. Em outros casos, ausências explícitas são impostas a você pela estrutura dos dados e você quer se livrar delas. As seções seguintes discutem algumas ferramentas para mover entre ausências implícitas e explícitas.
"

#----18.3.1 Pivotando----
"
Você já viu uma ferramenta que pode tornar as ausências implícitas explícitas e vice-versa: pivoteamento. Tornar os dados mais amplos pode tornar valores ausentes implícitos explícitos porque cada combinação das linhas e novas colunas deve ter algum valor. Por exemplo, se pivotarmos as ações para colocar o trimestre nas colunas, ambos os valores ausentes se tornam explícitos:
"
stocks |>
  pivot_wider(
    names_from = qtr, 
    values_from = price
  )

"
Por padrão, tornar os dados mais longos preserva valores ausentes explícitos, mas se eles são valores ausentes estruturalmente que existem apenas porque os dados não estão organizados, você pode descartá-los (torná-los implícitos) definindo values_drop_na = TRUE.
"

#----18.3.2 Completo----
"
tidyr::complete() permite que você gere valores ausentes explícitos fornecendo um conjunto de variáveis que definem a combinação de linhas que deveriam existir. Por exemplo, sabemos que todas as combinações de ano e trimestre devem existir nos dados de ações:
"
stocks |>
  complete(year, qtr)

"
Normalmente, você chamará complete() com nomes de variáveis existentes, preenchendo as combinações ausentes. No entanto, às vezes as próprias variáveis são incompletas, então você pode fornecer seus próprios dados. Por exemplo, você pode saber que o conjunto de dados de ações deve ir de 2019 a 2021, então você poderia fornecer explicitamente esses valores para o ano:
"
stocks |>
  complete(year = 2019:2021, qtr)

"
Se a faixa de uma variável estiver correta, mas nem todos os valores estiverem presentes, você poderia usar full_seq(x, 1) para gerar todos os valores de min(x) a max(x) espaçados por 1.

Em alguns casos, o conjunto completo de observações não pode ser gerado por uma simples combinação de variáveis. Nesse caso, você pode fazer manualmente o que complete() faz por você: criar um quadro de dados que contenha todas as linhas que deveriam existir (usando qualquer combinação de técnicas que você precise), e então combiná-lo com seu conjunto de dados original com dplyr::full_join().
"

#----18.3.3 Junções----
"
Isso nos leva a outra maneira importante de revelar observações implicitamente ausentes: junções. Você aprenderá mais sobre junções mais a frente, mas queríamos mencioná-las rapidamente aqui, pois muitas vezes você só pode saber que os valores estão ausentes de um conjunto de dados quando o compara a outro.

dplyr::anti_join(x, y) é uma ferramenta particularmente útil aqui porque seleciona apenas as linhas em x que não têm correspondência em y. Por exemplo, podemos usar dois anti_join()s para revelar que estamos com informações ausentes para quatro aeroportos e 722 aviões mencionados em voos:
"
library(nycflights13)

flights |> 
  distinct(faa = dest) |> 
  anti_join(airports)


flights |> 
  distinct(tailnum) |> 
  anti_join(planes)


#----18.4 Fatores e grupos vazios----
"
Um tipo final de ausência é o grupo vazio, um grupo que não contém nenhuma observação, o que pode surgir ao trabalhar com fatores. Por exemplo, imagine que temos um conjunto de dados que contém algumas informações de saúde sobre pessoas:
"
health <- tibble(
  name   = c("Ikaia", "Oletta", "Leriah", "Dashay", "Tresaun"),
  smoker = factor(c("no", "no", "no", "no", "no"), levels = c("yes", "no")),
  age    = c(34, 88, 75, 47, 56),
)

health

"
E queremos contar o número de fumantes com dplyr::count():
"
health |> count(smoker)

"
Este conjunto de dados contém apenas não-fumantes, mas sabemos que existem fumantes; o grupo de não-fumantes está vazio. Podemos solicitar que count() mantenha todos os grupos, mesmo aqueles não vistos nos dados, usando .drop = FALSE:
"
health |> count(smoker, .drop = FALSE)

"
O mesmo princípio se aplica aos eixos discretos do ggplot2, que também eliminarão níveis que não têm valores. Você pode forçá-los a exibir, fornecendo drop = FALSE ao eixo discreto apropriado:
"
ggplot(health, aes(x = smoker)) +
  geom_bar() +
  scale_x_discrete()

ggplot(health, aes(x = smoker)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

"
O mesmo problema surge de forma mais geral com dplyr::group_by(). E novamente você pode usar .drop = FALSE para preservar todos os níveis de fatores:
"
health |> 
  group_by(smoker, .drop = FALSE) |> 
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  )

"
Obtemos alguns resultados interessantes aqui porque, ao resumir um grupo vazio, as funções de resumo são aplicadas a vetores de comprimento zero. Há uma distinção importante entre vetores vazios, que têm comprimento 0, e valores ausentes, cada um dos quais tem comprimento 1.
"
# Um vetor contendo dois valores ausentes
x1 <- c(NA, NA)
length(x1)

# Um vetor que não contém nada
x2 <- numeric()
length(x2)

"
Todas as funções de resumo funcionam com vetores de comprimento zero, mas podem retornar resultados que são surpreendentes à primeira vista. Aqui vemos mean(age) retornando NaN porque mean(age) = sum(age)/length(age) que aqui é 0/0. max() e min() retornam -Inf e Inf para vetores vazios, então se você combinar os resultados com um novo conjunto de dados não vazio e recalcular, você obterá o mínimo ou máximo do novo dado1.

Às vezes, uma abordagem mais simples é realizar o resumo e depois tornar os ausentes implícitos com complete().
"
health |> 
  group_by(smoker) |> 
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  ) |> 
  complete(smoker)

"
A principal desvantagem dessa abordagem é que você obtém um NA para a contagem, mesmo sabendo que deveria ser zero.
"

#----Capítulo 19 : Junções----

#----19.1 Introdução----
"
É raro que uma análise de dados envolva apenas um único quadro de dados. Normalmente você tem muitos quadros de dados e deve juntá-los para responder às perguntas que lhe interessam. Este capítulo apresentará a você dois tipos importantes de junções:
"
#1º Junções mutantes, que adicionam novas variáveis a um quadro de dados a partir de observações correspondentes em outro.
#2º Junções de filtragem, que filtram observações de um quadro de dados com base em se correspondem ou não a uma observação em outro.

"
Começaremos discutindo chaves, as variáveis usadas para conectar um par de quadros de dados em uma junção. Solidificamos a teoria com uma análise das chaves nos conjuntos de dados do pacote nycflights13, e então usamos esse conhecimento para começar a juntar quadros de dados. Em seguida, discutiremos como as junções funcionam, focando em sua ação nas linhas. Concluiremos com uma discussão sobre junções não-equivalentes, uma família de junções que oferece uma maneira mais flexível de combinar chaves do que a relação de igualdade padrão.
"

#----19.1.1 Pré-requisitos----
"
Neste capítulo, exploraremos os cinco conjuntos de dados relacionados de nycflights13 usando as funções de junção do dplyr.
"
library(tidyverse)
library(nycflights13)

#----19.2 Chaves----
"
Para entender junções, você precisa primeiro entender como duas tabelas podem ser conectadas por meio de um par de chaves, dentro de cada tabela. Nesta seção, você aprenderá sobre os dois tipos de chaves e verá exemplos de ambos nos conjuntos de dados do pacote nycflights13. Você também aprenderá como verificar se suas chaves são válidas e o que fazer se sua tabela não tiver uma chave.
"

#----19.2.1 Chaves primárias e estrangeiras----
"
Toda junção envolve um par de chaves: uma chave primária e uma chave estrangeira. Uma chave primária é uma variável ou conjunto de variáveis que identifica exclusivamente cada observação. Quando mais de uma variável é necessária, a chave é chamada de chave composta. Por exemplo, em nycflights13:
"
#1º airlines registra dois dados sobre cada companhia aérea: seu código de transportadora e seu nome completo. Você pode identificar uma companhia aérea com seu código de transportadora de duas letras, tornando 'carrier' a chave primária.
airlines

#2º airports registra dados sobre cada aeroporto. Você pode identificar cada aeroporto pelo seu código de aeroporto de três letras, tornando 'faa' a chave primária.
airports

#3º planes registra dados sobre cada avião. Você pode identificar um avião pelo seu número de cauda, tornando 'tailnum' a chave primária.
planes

#4º weather registra dados sobre o clima nos aeroportos de origem. Você pode identificar cada observação pela combinação de localização e hora, tornando 'origin' e 'time_hour' a chave primária composta.
weather

"
Uma chave estrangeira é uma variável (ou conjunto de variáveis) que corresponde a uma chave primária em outra tabela. Por exemplo:
"
#1º flights$tailnum é uma chave estrangeira que corresponde à chave primária planes$tailnum.
#2º lights$carrier é uma chave estrangeira que corresponde à chave primária airlines$carrier.
#3º flights$origin é uma chave estrangeira que corresponde à chave primária airports$faa.
#4º flights$dest é uma chave estrangeira que corresponde à chave primária airports$faa.
#5º flights$origin-flights$time_hour é uma chave estrangeira composta que corresponde à chave primária composta weather$origin-weather$time_hour.

"
Você notará um bom recurso no design dessas chaves: as chaves primárias e estrangeiras quase sempre têm os mesmos nomes, o que, como você verá em breve, tornará sua vida de junção muito mais fácil. Também vale a pena notar o relacionamento oposto: quase todos os nomes de variáveis usados em várias tabelas têm o mesmo significado em cada lugar. Há apenas uma exceção: 'year' significa ano de partida em flights e ano de fabricação em planes. Isso se tornará importante quando começarmos a juntar as tabelas.
"

#----19.2.2 Verificação de chaves primárias----
"
Agora que identificamos as chaves primárias em cada tabela, é uma boa prática verificar se elas realmente identificam exclusivamente cada observação. Uma maneira de fazer isso é contar (count()) as chaves primárias e procurar por entradas onde n é maior que um. Isso revela que planes e weather parecem bons:
"
planes |> 
  count(tailnum) |> 
  filter(n > 1)

weather |> 
  count(time_hour, origin) |> 
  filter(n > 1)

"
Você também deve verificar se há valores ausentes em suas chaves primárias — se um valor está ausente, então ele não pode identificar uma observação!
"
planes |> 
  filter(is.na(tailnum))

weather |> 
  filter(is.na(time_hour) | is.na(origin))


#----19.2.3 Chaves substitutas----
"
Até agora, não falamos sobre a chave primária para flights. Não é super importante aqui, porque não há quadros de dados que a utilizem como chave estrangeira, mas ainda é útil considerar porque é mais fácil trabalhar com observações se tivermos alguma maneira de descrevê-las para os outros.

Após um pouco de reflexão e experimentação, determinamos que há três variáveis que juntas identificam exclusivamente cada voo:
"
flights |> 
  count(time_hour, carrier, flight) |> 
  filter(n > 1)

"
A ausência de duplicatas automaticamente torna time_hour-carrier-flight uma chave primária? Certamente é um bom começo, mas não garante isso. Por exemplo, altitude e latitude são uma boa chave primária para aeroportos?
"
airports |>
  count(alt, lat) |> 
  filter(n > 1)

"
Identificar um aeroporto pela sua altitude e latitude é claramente uma má ideia, e em geral não é possível saber apenas pelos dados se uma combinação de variáveis é uma boa chave primária. Mas para flights, a combinação de time_hour, carrier e flight parece razoável porque seria realmente confuso para uma companhia aérea e seus clientes se houvesse vários voos com o mesmo número de voo no ar ao mesmo tempo.

Dito isso, talvez seja melhor introduzir uma simples chave substituta numérica usando o número da linha:
"
flights2 <- flights |> 
  mutate(id = row_number(), .before = 1)
flights2

"
Chaves substitutas podem ser particularmente úteis ao se comunicar com outros humanos: é muito mais fácil dizer a alguém para dar uma olhada no voo 2001 do que dizer olhe para o UA430 que partiu às 9h de 2013-01-03.
"

#----19.3 Junções básicas----
"
Agora que você entende como os quadros de dados estão conectados por meio de chaves, podemos começar a usar junções para entender melhor o conjunto de dados de voos. O dplyr fornece seis funções de junção: left_join(), inner_join(), right_join(), full_join(), semi_join() e anti_join(). Todas têm a mesma interface: elas recebem um par de quadros de dados (x e y) e retornam um quadro de dados. A ordem das linhas e colunas na saída é determinada principalmente por x.

Nesta seção, você aprenderá como usar uma junção mutante, left_join(), e duas junções de filtragem, semi_join() e anti_join(). Na próxima seção, você aprenderá exatamente como essas funções funcionam e sobre as restantes inner_join(), right_join() e full_join().
"

#----19.3.1 Junções mutantes----
"
Uma junção mutante permite combinar variáveis de dois quadros de dados: primeiro, ela combina observações pelas suas chaves e, em seguida, copia as variáveis de um quadro de dados para o outro. Como o mutate(), as funções de junção adicionam variáveis à direita, então se seu conjunto de dados tem muitas variáveis, você não verá as novas. Para esses exemplos, facilitaremos a visualização do que está acontecendo criando um conjunto de dados mais estreito com apenas seis variáveis:
"
flights2 <- flights |> 
  select(year, time_hour, origin, dest, tailnum, carrier)
flights2

"
Existem quatro tipos de junção mutante, mas há uma que você usará quase todo o tempo: left_join(). Ela é especial porque a saída sempre terá as mesmas linhas de x, o quadro de dados ao qual você está se juntando. O principal uso de left_join() é adicionar metadados adicionais. Por exemplo, podemos usar left_join() para adicionar o nome completo da companhia aérea aos dados flights2:
"
flights2 |>
  left_join(airlines)

"
Ou poderíamos descobrir a temperatura e a velocidade do vento quando cada avião partiu:
"
flights2 |> 
  left_join(weather |> select(origin, time_hour, temp, wind_speed))

"
Ou que tipo de avião estava voando:
"
flights2 |> 
  left_join(planes |> select(tailnum, type, engines, seats))

"
Quando left_join() não encontra uma correspondência para uma linha em x, ela preenche as novas variáveis com valores ausentes. Por exemplo, não há informações sobre o avião com número de cauda N3ALAA, então o tipo, motores e assentos estarão ausentes:
"
flights2 |> 
  filter(tailnum == "N3ALAA") |> 
  left_join(planes |> select(tailnum, type, engines, seats))

"
Voltaremos a este problema algumas vezes no restante do capítulo.
"

#----19.3.2 Especificando chaves de junção----
"
Por padrão, left_join() usará todas as variáveis que aparecem em ambos os quadros de dados como a chave de junção, a chamada junção natural. Essa é uma heurística útil, mas nem sempre funciona. Por exemplo, o que acontece se tentarmos juntar flights2 com o conjunto de dados completo de planes?
"
flights2 |> 
  left_join(planes)

"
Obtemos muitas correspondências ausentes porque nossa junção está tentando usar tailnum e year como uma chave composta. Tanto flights quanto planes têm uma coluna year, mas elas significam coisas diferentes: flights$year é o ano em que o voo ocorreu e planes$year é o ano em que o avião foi construído. Queremos apenas juntar pelo tailnum, então precisamos fornecer uma especificação explícita com join_by():
"
flights2 |> 
  left_join(planes, join_by(tailnum))

"
Observe que as variáveis year são desambiguadas na saída com um sufixo (year.x e year.y), que indica se a variável veio do argumento x ou y. Você pode substituir os sufixos padrão com o argumento suffix.

join_by(tailnum) é uma abreviação de join_by(tailnum == tailnum). É importante saber sobre essa forma mais completa por dois motivos. Primeiramente, ela descreve a relação entre as duas tabelas: as chaves devem ser iguais. É por isso que esse tipo de junção é frequentemente chamado de junção equi.

Em segundo lugar, é assim que você especifica diferentes chaves de junção em cada tabela. Por exemplo, existem duas maneiras de juntar a tabela flight2 e airports: seja por dest ou por origin:
"
flights2 |> 
  left_join(airports, join_by(dest == faa))

flights2 |> 
  left_join(airports, join_by(dest == faa))

"
Em códigos mais antigos, você pode ver uma maneira diferente de especificar as chaves de junção, usando um vetor de caracteres:
"
#1º by = "x" corresponde a join_by(x).
#2º by = c("a" = "x") corresponde a join_by(a == x).

"
Agora que existe, preferimos join_by() já que ele fornece uma especificação mais clara e flexível.

inner_join(), right_join(), full_join() têm a mesma interface que left_join(). A diferença é quais linhas eles mantêm: o left join mantém todas as linhas em x, o right join mantém todas as linhas em y, o full join mantém todas as linhas em x ou y, e o inner join apenas mantém linhas que ocorrem em ambos x e y.
"

#----19.3.3 Junções de filtragem----
"
Como você pode imaginar, a ação principal de uma junção de filtragem é filtrar as linhas. Existem dois tipos: semi-junções e anti-junções. As semi-junções mantêm todas as linhas em x que têm uma correspondência em y. Por exemplo, poderíamos usar uma semi-junção para filtrar o conjunto de dados de aeroportos para mostrar apenas os aeroportos de origem:
"
airports |> 
  semi_join(flights2, join_by(faa == origin))

"
Ou apenas os destinos:
"
airports |> 
  semi_join(flights2, join_by(faa == dest))

"
As anti-junções são o oposto: elas retornam todas as linhas em x que não têm uma correspondência em y. Elas são úteis para encontrar valores ausentes que são implícitos nos dados. Valores ausentes implicitamente não aparecem como NAs, mas em vez disso existem apenas como uma ausência. Por exemplo, podemos encontrar linhas que estão ausentes em aeroportos procurando por voos que não têm um aeroporto de destino correspondente:
"
flights2 |> 
  anti_join(airports, join_by(dest == faa)) |> 
  distinct(dest)

"
Ou podemos encontrar quais tailnums estão ausentes de planes:
"
flights2 |>
  anti_join(planes, join_by(tailnum)) |> 
  distinct(tailnum)


#----19.4 Como funcionam as junções?----
"
Agora que você já usou junções algumas vezes, é hora de aprender mais sobre como elas funcionam, focando em como cada linha em x corresponde às linhas em y. Começaremos introduzindo uma representação visual das junções, usando tibbles simples definidos abaixo . Nestes exemplos, usaremos uma única chave chamada 'key' e uma única coluna de valor (val_x e val_y), mas as ideias se generalizam para múltiplas chaves e múltiplos valores.
"
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

"
Para descrever um tipo específico de junção, indicamos as correspondências com pontos. As correspondências determinam as linhas na saída, um novo quadro de dados que contém a chave, os valores x e os valores y. 

Podemos aplicar os mesmos princípios para explicar as junções externas, que mantêm observações que aparecem em pelo menos um dos quadros de dados. Essas junções funcionam adicionando uma observação 'virtual' adicional a cada quadro de dados. Esta observação tem uma chave que corresponde se nenhuma outra chave corresponder, e valores preenchidos com NA. Existem três tipos de junções externas:
"
#1º Uma junção à esquerda mantém todas as observações em x. Cada linha de x é preservada na saída porque pode recorrer a corresponder a uma linha de NAs em y.
#2º Uma junção à direita mantém todas as observações em y. Cada linha de y é preservada na saída porque pode recorrer a corresponder a uma linha de NAs em x. A saída ainda corresponde a x tanto quanto possível; quaisquer linhas extras de y são adicionadas ao final.
#3º Uma junção completa mantém todas as observações que aparecem em x ou y. Cada linha de x e y é incluída na saída porque tanto x quanto y têm uma linha de reserva de NAs. Novamente, a saída começa com todas as linhas de x, seguidas pelas linhas de y não correspondidas restantes.

"
Outra maneira de mostrar como os tipos de junção externa diferem é com um diagrama de Venn. No entanto, esta não é uma ótima representação porque, embora possa lembrar quais linhas são preservadas, ela não ilustra o que está acontecendo com as colunas.

As junções mostradas aqui são as chamadas junções equi, onde as linhas correspondem se as chaves forem iguais. As junções equi são o tipo mais comum de junção, então normalmente omitiremos o prefixo equi e diremos apenas 'junção interna' em vez de 'junção interna equi'. Voltaremos às junções não-equi mais a frente.
"

#----19.4.1 Correspondência de linhas----
"
Até agora, exploramos o que acontece se uma linha em x corresponder a zero ou uma linha em y. O que acontece se ela corresponder a mais de uma linha? Para entender o que está acontecendo, vamos primeiro restringir nosso foco para o inner_join().

Existem três resultados possíveis para uma linha em x:
"
#1º Existem três resultados possíveis para uma linha em x:
#2º Se corresponder a 1 linha em y, será preservada.
#3º Se corresponder a mais de 1 linha em y, será duplicada uma vez para cada correspondência.

"
Em princípio, isso significa que não há uma correspondência garantida entre as linhas na saída e as linhas em x, mas na prática, isso raramente causa problemas. No entanto, há um caso particularmente perigoso que pode causar uma explosão combinatória de linhas. Imagine juntar as seguintes duas tabelas:
"
df1 <- tibble(key = c(1, 2, 2), val_x = c("x1", "x2", "x3"))
df1

df2 <- tibble(key = c(1, 2, 2), val_y = c("y1", "y2", "y3"))
df2

"
Enquanto a primeira linha em df1 corresponde apenas a uma linha em df2, a segunda e terceira linhas correspondem a duas linhas. Isso às vezes é chamado de junção muitos-para-muitos e fará com que o dplyr emita um aviso:
"
df1 |> 
  inner_join(df2, join_by(key))

"
Se você estiver fazendo isso deliberadamente, você pode definir relationship = 'many-to-many', como o aviso sugere.
"

#----19.4.2 Junções de filtragem----
"
O número de correspondências também determina o comportamento das junções de filtragem. A semi-junção mantém linhas em x que têm uma ou mais correspondências em y. A anti-junção mantém linhas em x que correspondem a zero linhas em y. Em ambos os casos, apenas a existência de uma correspondência é importante; não importa quantas vezes ela corresponde. Isso significa que as junções de filtragem nunca duplicam linhas como as junções mutantes fazem.
"

#----19.5 Junções não-equivalentes----
"
Até agora, você só viu junções equi, junções onde as linhas correspondem se a chave x for igual à chave y. Agora vamos relaxar essa restrição e discutir outras maneiras de determinar se um par de linhas corresponde.

Mas antes de fazer isso, precisamos revisitar uma simplificação que fizemos acima. Em junções equi, as chaves x e y são sempre iguais, então só precisamos mostrar uma na saída. Podemos solicitar que o dplyr mantenha ambas as chaves com keep = TRUE, levando ao código abaixo e ao inner_join() redesenhado.
"
x |> inner_join(y, join_by(key == key), keep = TRUE)

"
Quando nos afastamos das junções equi, sempre mostraremos as chaves, porque os valores das chaves geralmente serão diferentes. Por exemplo, em vez de corresponder apenas quando x$key e y$key são iguais, poderíamos corresponder sempre que x$key for maior ou igual a y$key. As funções de junção do dplyr entendem essa distinção entre junções equi e não equi, então sempre mostrarão ambas as chaves quando você realizar uma junção não equi.

Junção não equi não é um termo particularmente útil porque só diz o que a junção não é, não o que ela é. O dplyr ajuda identificando quatro tipos particularmente úteis de junção não equi:
"
#1º Junções cruzadas correspondem a cada par de linhas.
#2º Junções de desigualdade usam <, <=, > e >= em vez de ==.
#3º Junções rolantes são semelhantes às junções de desigualdade, mas só encontram a correspondência mais próxima.
#4º Junções de sobreposição são um tipo especial de junção de desigualdade projetada para trabalhar com intervalos.

"
Cada uma delas é descrita em mais detalhes nas seções seguintes.
"

#----19.5.1 Junções cruzadas----
"
Uma junção cruzada corresponde a tudo gerando o produto cartesiano de linhas. Isso significa que a saída terá nrow(x) * nrow(y) linhas.

Junções cruzadas são úteis ao gerar permutações. Por exemplo, o código abaixo gera todos os possíveis pares de nomes. Como estamos juntando df a si mesmo, isso às vezes é chamado de auto-junção. Junções cruzadas usam uma função de junção diferente porque não há distinção entre inner/left/right/full quando você está correspondendo a cada linha.
"
df <- tibble(name = c("John", "Simon", "Tracy", "Max"))
df |> cross_join(df)

#----19.5.2 Junções de desigualdade----
"
Junções de desigualdade usam <, <=, >= ou > para restringir o conjunto de correspondências possíveis.

Junções de desigualdade são extremamente gerais, tão gerais que é difícil encontrar casos de uso específicos significativos. Uma pequena técnica útil é usá-las para restringir a junção cruzada, de modo que, em vez de gerar todas as permutações, geramos todas as combinações:
"
df <- tibble(id = 1:4, name = c("John", "Simon", "Tracy", "Max"))

df |> inner_join(df, join_by(id < id))

#----19.5.3 Junções rolantes----
"
Junções rolantes são um tipo especial de junção de desigualdade onde, em vez de obter todas as linhas que satisfazem a desigualdade, você obtém apenas a linha mais próxima. Você pode transformar qualquer junção de desigualdade em uma junção rolante adicionando closest(). Por exemplo, join_by(closest(x <= y)) corresponde ao menor y que é maior ou igual a x, e join_by(closest(x > y)) corresponde ao maior y que é menor que x.

Junções rolantes são particularmente úteis quando você tem duas tabelas de datas que não se alinham perfeitamente e você quer encontrar (por exemplo) a data mais próxima na tabela 1 que vem antes (ou depois) de alguma data na tabela 2.

Por exemplo, imagine que você está encarregado da comissão de planejamento de festas do seu escritório. Sua empresa é um pouco econômica, então, em vez de ter festas individuais, você só tem uma festa a cada trimestre. As regras para determinar quando uma festa será realizada são um pouco complexas: festas são sempre às segundas-feiras, você pula a primeira semana de janeiro, já que muitas pessoas estão de férias, e a primeira segunda-feira do terceiro trimestre de 2022 é 4 de julho, então isso precisa ser adiado uma semana. Isso leva aos seguintes dias de festa:
"
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03"))
)

"
Agora imagine que você tem uma tabela de aniversários dos funcionários:
"
set.seed(123)
employees <- tibble(
  name = sample(babynames::babynames$name, 100),
  birthday = ymd("2022-01-01") + (sample(365, 100, replace = TRUE) - 1)
)
employees

"
E para cada funcionário, queremos encontrar a primeira data de festa que vem depois (ou no) aniversário deles. Podemos expressar isso com uma junção rolante:
"
employees |> 
  left_join(parties, join_by(closest(birthday >= party)))

"
No entanto, há um problema com essa abordagem: as pessoas com aniversários antes de 10 de janeiro não têm festa:
"
employees |> 
  anti_join(parties, join_by(closest(birthday >= party)))

"
Para resolver essa questão, precisaremos abordar o problema de uma maneira diferente, com junções de sobreposição.
"

#----19.5.4 Junções de sobreposição----
"
As junções de sobreposição fornecem três ajudantes que usam junções de desigualdade para facilitar o trabalho com intervalos:
"
#1º between(x, y_lower, y_upper) é uma abreviação para x >= y_lower, x <= y_upper.
#2º within(x_lower, x_upper, y_lower, y_upper) é uma abreviação para x_lower >= y_lower, x_upper <= y_upper.
#3º within(x_lower, x_upper, y_lower, y_upper) é uma abreviação para x_lower >= y_lower, x_upper <= y_upper.

"
Vamos continuar o exemplo de aniversário para ver como você pode usá-los. Há um problema com a estratégia que usamos acima: não há festa antes dos aniversários de 1 a 9 de janeiro. Então, talvez seja melhor ser explícito sobre os intervalos de datas que cada festa abrange e fazer um caso especial para esses aniversários no início do ano:
"
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
  start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
  end = ymd(c("2022-04-03", "2022-07-11", "2022-10-02", "2022-12-31"))
)
parties

"
Hadley é terrivelmente ruim em inserir dados, então ele também queria verificar se os períodos das festas não se sobrepõem. Uma maneira de fazer isso é usar uma auto-junção para verificar se algum intervalo de início e fim se sobrepõe a outro:
"
parties |> 
  inner_join(parties, join_by(overlaps(start, end, start, end), q < q)) |> 
  select(start.x, end.x, start.y, end.y)

"
Opa, há uma sobreposição, então vamos corrigir esse problema e continuar:
"
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
  start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
  end = ymd(c("2022-04-03", "2022-07-10", "2022-10-02", "2022-12-31"))
)

parties

"
Agora podemos combinar cada funcionário com sua festa. Este é um bom lugar para usar unmatched = 'error' porque queremos descobrir rapidamente se algum funcionário não foi designado para uma festa.
"
employees |> 
  inner_join(parties, join_by(between(birthday, start, end)), unmatched = "error")

#Capítulo 20 : Planilhas----

#----20.1 Introdução----
"
Anteriormente você aprendeu sobre a importação de dados de arquivos de texto simples como .csv e .tsv. Agora é hora de aprender como obter dados de uma planilha, seja uma planilha do Excel ou uma planilha do Google. Isso se baseará em muito do que você aprendeu anteriormente, mas também discutiremos considerações e complexidades adicionais ao trabalhar com dados de planilhas.

Se você ou seus colaboradores estão usando planilhas para organizar dados, recomendamos fortemente a leitura do artigo 'Organização de Dados em Planilhas' de Karl Broman e Kara Woo: 
https://doi.org/10.1080/00031305.2017.1375989. As melhores práticas apresentadas neste artigo evitarão muitas dores de cabeça quando você importar dados de uma planilha para o R para analisar e visualizar.
"


#----20.2 Excel----
"
O Microsoft Excel é um programa de software de planilha amplamente utilizado onde os dados são organizados em planilhas dentro de arquivos de planilha.
"

#----20.2.1 Pré-requisitos----
"
Agora, você aprenderá como carregar dados de planilhas do Excel no R com o pacote readxl. Este pacote não é do núcleo do tidyverse, então você precisa carregá-lo explicitamente, mas ele é instalado automaticamente quando você instala o pacote tidyverse. Mais tarde, também usaremos o pacote writexl, que nos permite criar planilhas do Excel.
"
library(readxl)
library(tidyverse)
library(writexl)

#----20.2.2 Começando----
"
A maioria das funções do readxl permite que você carregue planilhas do Excel no R:
"
#1º read_xls() lê arquivos do Excel no formato xls.
#2º read_xlsx() lê arquivos do Excel no formato xlsx.
#3º read_excel() pode ler arquivos nos formatos xls e xlsx. Ele adivinha o tipo de arquivo com base na entrada.

"
Essas funções têm uma sintaxe semelhante, assim como outras funções que introduzimos anteriormente para ler outros tipos de arquivos, por exemplo, read_csv(), read_table(), etc. Pelo restante do capítulo, focaremos no uso de read_excel().
"

#----20.2.3 Lendo planilhas do Excel----
"
A planilha usada nessa parte pode ser encontrada no link abaixo :
https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w/
O primeiro argumento para read_excel() é o caminho para o arquivo a ser lido.
"
students <- read_excel("students.xlsx")
students


"
read_excel() lerá o arquivo como um tibble.

Temos seis estudantes nos dados e cinco variáveis para cada estudante. No entanto, há algumas coisas que podemos querer abordar neste conjunto de dados:
"
#1º Os nomes das colunas estão todos desorganizados. Você pode fornecer nomes de colunas que sigam um formato consistente; recomendamos snake_case usando o argumento col_names.
read_excel(
  "students.xlsx",
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age")
)
#Infelizmente, isso não resolveu completamente o problema. Agora temos os nomes de variáveis que queremos, mas o que era anteriormente a linha de cabeçalho agora aparece como a primeira observação nos dados. Você pode pular explicitamente essa linha usando o argumento skip.

#2º Na coluna favourite_food, uma das observações é N/A, que significa 'não disponível', mas atualmente não é reconhecida como NA (note o contraste entre este N/A e a idade do quarto estudante na lista). Você pode especificar quais strings de caracteres devem ser reconhecidas como NAs com o argumento na. Por padrão, apenas '' (string vazia, ou, no caso de ler de uma planilha, uma célula vazia ou uma célula com a fórmula =NA()) é reconhecida como um NA.
read_excel(
  "students.xlsx",
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A")
)

#3º Outro problema restante é que a idade é lida como uma variável de caráter, mas realmente deveria ser numérica. Assim como com read_csv() e similares para ler dados de arquivos de texto plano, você pode fornecer um argumento col_types para read_excel() e especificar os tipos de coluna para as variáveis que você lê. A sintaxe é um pouco diferente, porém. Suas opções são 'skip', 'guess', 'logical', 'numeric', 'date', 'text' ou 'list'.
read_excel(
  "students.xlsx",
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A"),
  col_types = c("numeric", "text", "text", "text", "numeric")
)
#No entanto, isso também não produziu o resultado desejado. Ao especificar que a idade deve ser numérica, transformamos a uma célula com a entrada não numérica (que tinha o valor five) em um NA. Neste caso, devemos ler a idade como 'text' e, em seguida, fazer a alteração uma vez que os dados estejam carregados no R.

"
Levou-nos várias etapas e tentativa e erro para carregar os dados exatamente no formato que queremos, e isso não é inesperado. A ciência de dados é um processo iterativo, e o processo de iteração pode ser ainda mais tedioso ao ler dados de planilhas em comparação com outros arquivos de dados retangulares de texto simples porque os humanos tendem a inserir dados em planilhas e usá-las não apenas para armazenamento de dados, mas também para compartilhamento e comunicação.

Não há como saber exatamente como os dados parecerão até que você os carregue e dê uma olhada neles. Bem, há uma maneira, na verdade. Você pode abrir o arquivo no Excel e dar uma espiada. Se você for fazer isso, recomendamos fazer uma cópia do arquivo Excel para abrir e navegar interativamente, deixando o arquivo de dados original intocado e lendo no R a partir do arquivo intocado. Isso garantirá que você não sobrescreva acidentalmente nada na planilha ao inspecioná-la. Você também não deve ter medo de fazer o que fizemos aqui: carregar os dados, dar uma olhada, fazer ajustes no seu código, carregar novamente e repetir até ficar satisfeito com o resultado.
"

#----20.2.4 Lendo planilhas de trabalho----
"
Um recurso importante que distingue planilhas de arquivos planos é a noção de múltiplas folhas, chamadas de planilhas. Os dados vêm do pacote palmerpenguins, e você pode baixar esta planilha como um arquivo Excel de :
https://docs.google.com/spreadsheets/d/1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY/. Cada planilha contém informações sobre pinguins de uma ilha diferente onde os dados foram coletados.
Você pode ler uma única planilha de uma planilha com o argumento sheet em read_excel(). O padrão, no qual confiamos até agora, é a primeira planilha.
"
read_excel("penguins.xlsx", sheet = "Torgersen Island")

"
Algumas variáveis que parecem conter dados numéricos são lidas como caracteres devido à string de caracteres 'NA' não ser reconhecida como um verdadeiro NA.
"
penguins_torgersen <- read_excel("penguins.xlsx", sheet = "Torgersen Island", na = "NA")
penguins_torgersen

"
Alternativamente, você pode usar excel_sheets() para obter informações sobre todas as planilhas em uma planilha do Excel e, em seguida, ler aquela(s) que lhe interessam.
"
excel_sheets("penguins.xlsx")

"
Uma vez que você conhece os nomes das planilhas, você pode lê-las individualmente com read_excel().
"
penguins_biscoe <- read_excel("penguins.xlsx", sheet = "Biscoe Island", na = "NA")
penguins_dream  <- read_excel("penguins.xlsx", sheet = "Dream Island", na = "NA")

"
Neste caso, o conjunto de dados completo de penguins está espalhado por três planilhas na planilha. Cada planilha tem o mesmo número de colunas, mas diferentes números de linhas.
"
dim(penguins_torgersen)
dim(penguins_biscoe)
dim(penguins_dream)

"
Podemos juntá-las com bind_rows().
"
penguins <- bind_rows(penguins_torgersen, penguins_biscoe, penguins_dream)
penguins


#----20.2.5 Lendo parte de uma planilha----
"
Como muitos usam planilhas do Excel para apresentação, além de armazenamento de dados, é bastante comum encontrar entradas de células em uma planilha que não fazem parte dos dados que você deseja ler no R. Por exemplo no meio da planilha parece haver um quadro de dados, mas há texto extraneo em células acima e abaixo dos dados.

Essa planilha é uma das planilhas de exemplo fornecidas no pacote readxl. Você pode usar a função readxl_example() para localizar a planilha em seu sistema no diretório onde o pacote está instalado. Essa função retorna o caminho para a planilha, que você pode usar em read_excel() como de costume.
"
deaths_path <- readxl_example("deaths.xlsx")
deaths <- read_excel(deaths_path)
deaths

"
As três primeiras linhas e as últimas quatro linhas não fazem parte do quadro de dados. É possível eliminar essas linhas extraneas usando os argumentos skip e n_max, mas recomendamos usar intervalos de células. No Excel, a célula superior esquerda é A1. Conforme você se move pelas colunas para a direita, o rótulo da célula avança pelo alfabeto, ou seja, B1, C1, etc. E conforme você desce por uma coluna, o número no rótulo da célula aumenta, ou seja, A2, A3, etc.

Aqui, os dados que queremos ler começam na célula A5 e terminam na célula F15. Na notação de planilha, isso é A5:F15, o qual fornecemos ao argumento range:
"
read_excel(deaths_path, range = "A5:F15")

#----20.2.6 Tipos de dados----
"
Em arquivos CSV, todos os valores são strings. Isso não é particularmente verdadeiro para os dados, mas é simples: tudo é uma string.

Os dados subjacentes em planilhas do Excel são mais complexos. Uma célula pode ser uma de quatro coisas:
"
#1º Um booleano, como TRUE, FALSE ou NA.
#2º Um número, como '10' ou '10.5'.
#3º Um datetime, que também pode incluir tempo como '11/1/21' ou '11/1/21 3:00 PM'.
#4º Uma string de texto, como 'ten'.

"
Ao trabalhar com dados de planilha, é importante ter em mente que os dados subjacentes podem ser muito diferentes do que você vê na célula. Por exemplo, o Excel não tem noção de um inteiro. Todos os números são armazenados como pontos flutuantes, mas você pode escolher exibir os dados com um número personalizável de pontos decimais. Da mesma forma, as datas são na verdade armazenadas como números, especificamente o número de segundos desde 1 de janeiro de 1970. Você pode personalizar como exibe a data aplicando formatação no Excel. Confusamente, também é possível ter algo que parece um número, mas na verdade é uma string (por exemplo, digite '10 em uma célula no Excel).

Essas diferenças entre como os dados subjacentes são armazenados vs. como são exibidos podem causar surpresas quando os dados são carregados no R. Por padrão, o readxl adivinhará o tipo de dados em uma determinada coluna. Um fluxo de trabalho recomendado é deixar o readxl adivinhar os tipos de colunas, confirmar que você está satisfeito com os tipos de colunas adivinhados e, se não, voltar e reimportar especificando col_types conforme mostrado anteriormente.

Outro desafio é quando você tem uma coluna em sua planilha do Excel que tem uma mistura desses tipos, por exemplo, algumas células são numéricas, outras texto, outras datas. Ao importar os dados para o R, o readxl tem que tomar algumas decisões. Nestes casos, você pode definir o tipo para esta coluna como 'list', o que carregará a coluna como uma lista de vetores de comprimento 1, onde o tipo de cada elemento do vetor é adivinhado.
"
"
Às vezes, os dados são armazenados de maneiras mais exóticas, como a cor do fundo da célula ou se o texto está em negrito ou não. Nesses casos, você pode achar o pacote tidyxl útil. Veja https://nacnudus.github.io/spreadsheet-munging-strategies/ para mais estratégias de como trabalhar com dados não-tabulares do Excel.
"

#----20.2.7 Escrevendo no Excel----
"
Vamos criar um pequeno quadro de dados que podemos então escrever. Note que 'item' é um fator e 'quantity' é um inteiro.
"
bake_sale <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5, 8)
)

bake_sale

"
Você pode escrever dados de volta para o disco como um arquivo Excel usando write_xlsx() do pacote writexl:
"
write_xlsx(bake_sale, path = "bake-sale.xlsx")

"
Assim como ao ler de um CSV, as informações sobre o tipo de dados são perdidas quando lemos os dados de volta. Isso torna os arquivos Excel também pouco confiáveis para armazenar resultados intermediários.
"
read_excel("bake-sale.xlsx")


#----20.2.8 Saída formatada----
"
O pacote writexl é uma solução leve para escrever uma planilha do Excel simples, mas se você estiver interessado em recursos adicionais, como escrever em planilhas dentro de uma planilha e estilização, você vai querer usar o pacote openxlsx. Não entraremos nos detalhes de como usar este pacote aqui, mas recomendamos a leitura de 
https://ycphs.github.io/openxlsx/articles/Formatting.html para uma discussão extensiva sobre funcionalidades adicionais de formatação para dados escritos do R para o Excel com openxlsx.

Note que este pacote não faz parte do tidyverse, então as funções e fluxos de trabalho podem parecer pouco familiares. Por exemplo, os nomes das funções são em camelCase, múltiplas funções não podem ser compostas em pipelines, e os argumentos estão em uma ordem diferente do que tendem a estar no tidyverse. No entanto, isso é ok. À medida que sua aprendizagem e uso do R se expandirem fora deste livro, você encontrará muitos estilos diferentes usados em vários pacotes do R que você pode usar para alcançar objetivos específicos no R. Uma boa maneira de se familiarizar com o estilo de codificação usado em um novo pacote é executar os exemplos fornecidos na documentação da função para ter uma ideia da sintaxe e dos formatos de saída, bem como ler quaisquer vinhetas que possam acompanhar o pacote.
"

#----20.3 Google Sheets----
"
O Google Sheets é outro programa de planilha amplamente utilizado. É gratuito e baseado na web. Assim como no Excel, no Google Sheets os dados são organizados em planilhas de trabalho (também chamadas de folhas) dentro de arquivos de planilha.
"

#----20.3.1 Pré-requisitos----
"
Esta seção também se concentrará em planilhas, mas desta vez você estará carregando dados de uma planilha do Google com o pacote googlesheets4. Este pacote também não é do núcleo do tidyverse, então você precisa carregá-lo explicitamente.
"
library(googlesheets4)
library(tidyverse)

"
Uma rápida nota sobre o nome do pacote: googlesheets4 usa a v4 da API Sheets para fornecer uma interface R para o Google Sheets, daí o nome.
"

#----20.3.2 Começando----
"
A principal função do pacote googlesheets4 é read_sheet(), que lê uma planilha do Google a partir de uma URL ou ID de arquivo. Esta função também é conhecida como range_read().

Você também pode criar uma nova planilha com gs4_create() ou escrever em uma planilha existente com sheet_write() e amigos.

Nesta seção, trabalharemos com os mesmos conjuntos de dados da seção do Excel para destacar semelhanças e diferenças entre os fluxos de trabalho para ler dados do Excel e do Google Sheets. Os pacotes readxl e googlesheets4 são ambos projetados para imitar a funcionalidade do pacote readr, que fornece a função read_csv() que você já viu. Portanto, muitas das tarefas podem ser realizadas simplesmente trocando read_excel() por read_sheet(). No entanto, você também verá que o Excel e o Google Sheets não se comportam exatamente da mesma maneira; portanto, outras tarefas podem exigir atualizações adicionais nas chamadas de função.
"

#----20.3.3 Lendo Google Sheets----
"

O primeiro argumento para read_sheet() é a URL do arquivo a ser lido, e ele retorna um tibble: 
https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w. Essas URLs não são agradáveis de se trabalhar, então você geralmente vai querer identificar uma planilha pelo seu ID.  
"
gs4_deauth()
students_sheet_id <- "1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w"
students <- read_sheet(students_sheet_id)

"
Assim como fizemos com read_excel(), podemos fornecer nomes de colunas, strings NA e tipos de colunas para read_sheet().
"
students <- read_sheet(
  students_sheet_id,
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A"),
  col_types = "dcccc"
)

students

"
Note que definimos os tipos de colunas de forma um pouco diferente aqui, usando códigos curtos. Por exemplo, 'dcccc' representa 'double, character, character, character, character'.

Também é possível ler planilhas individuais do Google Sheets. Vamos ler a planilha 'Torgersen Island' da planilha do Google dos pinguins:
"
penguins_sheet_id <- "1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY"
read_sheet(penguins_sheet_id, sheet = "Torgersen Island")

"
Você pode obter uma lista de todas as planilhas dentro de uma planilha do Google com sheet_names():
"
sheet_names(penguins_sheet_id)

"
Finalmente, assim como com read_excel(), podemos ler uma parte de uma planilha do Google definindo um intervalo em read_sheet(). Observe que também estamos usando a função gs4_example() abaixo para localizar uma planilha do Google de exemplo que acompanha o pacote googlesheets4.
"
deaths_url <- gs4_example("deaths")
deaths <- read_sheet(deaths_url, range = "A5:F15")
deaths

#----20.3.4 Escrevendo no Google Sheets----
"
Você pode escrever do R para o Google Sheets com write_sheet(). O primeiro argumento é o quadro de dados a ser escrito, e o segundo argumento é o nome (ou outro identificador) da planilha do Google para escrever:
"
write_sheet(bake_sale, ss = "bake-sale")

"
Se você quiser escrever seus dados em uma planilha específica (de trabalho) dentro de uma planilha do Google, você também pode especificar isso com o argumento sheet.
"
write_sheet(bake_sale, ss = "bake-sale", sheet = "Sales")

#----20.3.5 Autenticação----
"
Embora você possa ler de uma planilha do Google pública sem autenticar com sua conta do Google e com gs4_deauth(), ler uma planilha privada ou escrever em uma planilha requer autenticação para que o googlesheets4 possa visualizar e gerenciar suas planilhas do Google.

Quando você tenta ler uma planilha que requer autenticação, o googlesheets4 irá direcioná-lo para um navegador da web com um prompt para fazer login em sua conta do Google e conceder permissão para operar em seu nome com o Google Sheets. No entanto, se você quiser especificar uma conta do Google específica, escopo de autenticação, etc., você pode fazer isso com gs4_auth(), por exemplo, gs4_auth(email = mine@example.com), que forçará o uso de um token associado a um email específico. Para mais detalhes sobre autenticação, recomendamos a leitura da vinheta de autenticação do googlesheets4: https://googlesheets4.tidyverse.org/articles/auth.html.
"

#----Capítulo 21 : Bancos de Dados----

#----21.1 Introdução----
"
Uma enorme quantidade de dados está armazenada em bancos de dados, então é essencial que você saiba como acessá-los. Às vezes, você pode pedir a alguém para baixar um instantâneo em um arquivo .csv para você, mas isso rapidamente se torna penoso: toda vez que precisar fazer uma alteração, você terá que se comunicar com outro ser humano. Você quer ser capaz de acessar o banco de dados diretamente para obter os dados de que precisa, quando precisar.

Neste capítulo, você aprenderá primeiro os fundamentos do pacote DBI: como usá-lo para se conectar a um banco de dados e, em seguida, recuperar dados com uma consulta SQL. SQL, abreviação de structured query language (linguagem de consulta estruturada), é a língua franca dos bancos de dados e é uma linguagem importante para todos os cientistas de dados aprenderem. Dito isso, não vamos começar com SQL, mas em vez disso, ensinaremos dbplyr, que pode traduzir seu código dplyr para SQL. Usaremos isso como uma maneira de ensinar algumas das características mais importantes do SQL. Você não se tornará um mestre em SQL ao final do capítulo, mas será capaz de identificar os componentes mais importantes e entender o que eles fazem.
"

#----21.1.1 Pré-requisitos----
"
Neste capítulo, apresentaremos o DBI e o dbplyr. O DBI é uma interface de baixo nível que se conecta a bancos de dados e executa SQL; o dbplyr é uma interface de alto nível que traduz seu código dplyr em consultas SQL e depois as executa com o DBI.
"
library(DBI)
library(dbplyr)
library(tidyverse)

#----21.2 Fundamentos de Banco de Dados----
"
No nível mais simples, você pode pensar em um banco de dados como uma coleção de quadros de dados, chamados de tabelas na terminologia de banco de dados. Como um quadro de dados, uma tabela de banco de dados é uma coleção de colunas nomeadas, onde cada valor na coluna é do mesmo tipo. Existem três diferenças de alto nível entre quadros de dados e tabelas de banco de dados:
"
#1º Tabelas de banco de dados são armazenadas em disco e podem ser arbitrariamente grandes. Quadros de dados são armazenados na memória e são fundamentalmente limitados (embora esse limite ainda seja bastante grande para muitos problemas).
#2º Tabelas de banco de dados quase sempre têm índices. Muito parecido com o índice de um livro, um índice de banco de dados torna possível encontrar rapidamente linhas de interesse sem ter que olhar para cada linha individual. Quadros de dados e tibbles não têm índices, mas data.tables têm, o que é uma das razões pelas quais são tão rápidos.
#3º A maioria dos bancos de dados clássicos é otimizada para coletar dados rapidamente, não para analisar dados existentes. Esses bancos de dados são chamados de orientados a linhas porque os dados são armazenados linha por linha, em vez de coluna por coluna como no R. Mais recentemente, houve muito desenvolvimento de bancos de dados orientados a colunas que tornam a análise dos dados existentes muito mais rápida.

"
Os bancos de dados são gerenciados por sistemas de gerenciamento de bancos de dados (SGDBs, abreviados), que vêm em três formas básicas:
"
#1º SGDBs cliente-servidor são executados em um poderoso servidor central, ao qual você se conecta a partir do seu computador (o cliente). Eles são ótimos para compartilhar dados com várias pessoas em uma organização. SGDBs cliente-servidor populares incluem PostgreSQL, MariaDB, SQL Server e Oracle.
#2º SGDBs em nuvem, como Snowflake, Amazon's RedShift e Google's BigQuery, são semelhantes aos SGDBs cliente-servidor, mas são executados na nuvem. Isso significa que eles podem lidar facilmente com conjuntos de dados extremamente grandes e podem fornecer automaticamente mais recursos de computação conforme necessário.
#3º SGDBs em processo, como SQLite ou duckdb, são executados inteiramente no seu computador. Eles são ótimos para trabalhar com grandes conjuntos de dados onde você é o principal usuário.

#----21.3 Conectando a um Banco de Dados----
"
Para se conectar ao banco de dados do R, você usará um par de pacotes:
"
#1º Você sempre usará o DBI (interface de banco de dados) porque ele fornece um conjunto de funções genéricas que se conectam ao banco de dados, carregam dados, executam consultas SQL, etc.
#2º Você também usará um pacote personalizado para o SGDB ao qual está se conectando. Este pacote traduz os comandos genéricos do DBI para as especificidades necessárias para um determinado SGDB. Geralmente, há um pacote para cada SGDB, por exemplo, RPostgres para PostgreSQL e RMariaDB para MySQL.

"
Se você não encontrar um pacote específico para o seu SGDB, geralmente pode usar o pacote odbc em vez disso. Isso usa o protocolo ODBC suportado por muitos SGDBs. O odbc requer um pouco mais de configuração porque você também precisará instalar um driver ODBC e informar ao pacote odbc onde encontrá-lo.

Concretamente, você cria uma conexão de banco de dados usando DBI::dbConnect(). O primeiro argumento seleciona o SGDB, e o segundo e os argumentos subsequentes descrevem como se conectar a ele (ou seja, onde ele está localizado e as credenciais necessárias para acessá-lo). O código a seguir mostra alguns exemplos típicos:
"

"con <- DBI::dbConnect(
  RMariaDB::MariaDB(), 
  username = 'foo'
)
#con <- DBI::dbConnect(
  RPostgres::Postgres(), 
  hostname = 'databases.mycompany.com', 
  port = 1234
)"

#----21.3.1 Neste livro----
"
Configurar um SGDB cliente-servidor ou em nuvem seria complicado para este livro, então, em vez disso, usaremos um SGDB em processo que vive inteiramente em um pacote R: duckdb. Graças à magia do DBI, a única diferença entre usar duckdb e qualquer outro SGDB é como você se conectará ao banco de dados. Isso o torna ótimo para ensinar, porque você pode facilmente executar este código e também aplicar facilmente o que aprendeu em outros lugares.

Conectar-se ao duckdb é particularmente simples porque os padrões criam um banco de dados temporário que é excluído quando você sai do R. Isso é ótimo para aprender, porque garante que você começará do zero toda vez que reiniciar o R:
"
con <- DBI::dbConnect(duckdb::duckdb())

"
O duckdb é um banco de dados de alto desempenho projetado muito para as necessidades de um cientista de dados. Usamo-lo aqui porque é muito fácil começar, mas também é capaz de lidar com gigabytes de dados com grande velocidade. Se você quiser usar o duckdb para um projeto de análise de dados real, também precisará fornecer o argumento dbdir para criar um banco de dados persistente e dizer ao duckdb onde salvá-lo. Supondo que você esteja usando um projeto, é razoável armazená-lo no diretório duckdb do projeto atual.
"
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")

#----21.3.2 Carregar alguns dados----
"
Já que este é um novo banco de dados, precisamos começar adicionando alguns dados. Aqui, adicionaremos os conjuntos de dados mpg e diamonds do ggplot2 usando DBI::dbWriteTable(). O uso mais simples de dbWriteTable() precisa de três argumentos: uma conexão de banco de dados, o nome da tabela a ser criada no banco de dados e um quadro de dados.
"
#dbWriteTable(con, "mpg", ggplot2::mpg)
#dbWriteTable(con, "diamonds", ggplot2::diamonds)

"
Se você estiver usando o duckdb em um projeto real, recomendamos fortemente aprender sobre duckdb_read_csv() e duckdb_register_arrow(). Eles oferecem maneiras poderosas e eficientes de carregar rapidamente dados diretamente no duckdb, sem ter que primeiro carregá-los no R. Também mostraremos uma técnica útil para carregar vários arquivos em um banco de dados.
"

#----21.3.3 Fundamentos do DBI----
"
Você pode verificar se os dados foram carregados corretamente usando algumas outras funções do DBI: dbListTables() lista todas as tabelas no banco de dados e dbReadTable() recupera o conteúdo de uma tabela.
"
dbListTables(con)

con |> 
  dbReadTable("diamonds") |> 
  as_tibble()

"
dbReadTable() retorna um data.frame, então usamos as_tibble() para convertê-lo em um tibble para que ele seja impresso de maneira agradável.

Se você já conhece SQL, pode usar dbGetQuery() para obter os resultados da execução de uma consulta no banco de dados:
"
sql <- "
  SELECT carat, cut, clarity, color, price 
  FROM diamonds 
  WHERE price > 15000
"
as_tibble(dbGetQuery(con, sql))

"
Se você nunca viu SQL antes, não se preocupe! Você aprenderá mais sobre isso em breve. Mas se você lê-lo com atenção, pode adivinhar que ele seleciona cinco colunas do conjunto de dados de diamonds e todas as linhas onde o preço é maior que 15000.
"

#----21.4 Fundamentos do dbplyr----
"
Agora que nos conectamos a um banco de dados e carregamos alguns dados, podemos começar a aprender sobre o dbplyr. O dbplyr é um backend do dplyr, o que significa que você continua escrevendo código dplyr, mas o backend executa de forma diferente. Neste caso, o dbplyr traduz para SQL; outros backends incluem dtplyr que traduz para data.table e multidplyr que executa seu código em vários núcleos.

Para usar o dbplyr, você deve primeiro usar tbl() para criar um objeto que representa uma tabela de banco de dados:
"
diamonds_db <- tbl(con, "diamonds")
diamonds_db

"
Existem duas outras maneiras comuns de interagir com um banco de dados. Primeiro, muitos bancos de dados corporativos são muito grandes, então você precisa de alguma hierarquia para manter todas as tabelas organizadas. Nesse caso, você pode precisar fornecer um esquema ou um catálogo e um esquema para escolher a tabela de seu interesse:
"
#diamonds_db <- tbl(con, in_schema("sales", "diamonds"))
#diamonds_db <- tbl(con, in_catalog("north_america", "sales", "diamonds"))

"
Outras vezes, você pode querer usar sua própria consulta SQL como ponto de partida:
"
#diamonds_db <- tbl(con, sql("SELECT * FROM diamonds"))

"
Este objeto é preguiçoso; quando você usa funções dplyr nele, o dplyr não faz nenhum trabalho: ele apenas registra a sequência de operações que você deseja realizar e as executa apenas quando necessário. Por exemplo, pegue o seguinte pipeline:
"
big_diamonds_db <- diamonds_db |> 
  filter(price > 15000) |> 
  select(carat:clarity, price)

big_diamonds_db

"
Você pode dizer que este objeto representa uma consulta de banco de dados porque ele imprime o nome do SGDB no topo, e embora ele informe o número de colunas, normalmente não sabe o número de linhas. Isso ocorre porque encontrar o número total de linhas geralmente requer a execução da consulta completa, algo que estamos tentando evitar.

Você pode ver o código SQL gerado pela função dplyr show_query(). Se você conhece dplyr, esta é uma ótima maneira de aprender SQL! Escreva algum código dplyr, obtenha a tradução para SQL pelo dbplyr e, em seguida, tente descobrir como os dois idiomas se correspondem.
"
big_diamonds_db |>
  show_query()

"
Para obter todos os dados de volta para o R, você chama collect(). Nos bastidores, isso gera o SQL, chama dbGetQuery() para obter os dados e, em seguida, transforma o resultado em um tibble:
"
big_diamonds <- big_diamonds_db |> 
  collect()
big_diamonds

"
Normalmente, você usará o dbplyr para selecionar os dados que deseja do banco de dados, realizando filtragem básica e agregação usando as traduções descritas abaixo. Depois, quando estiver pronto para analisar os dados com funções exclusivas do R, você coletará os dados para obter um tibble na memória e continuará seu trabalho com código R puro.
"

#----21.5 SQL----
"
Daqui em diante vamos ensinar um pouco de SQL através da ótica do dbplyr. É uma introdução bastante não tradicional ao SQL, mas esperamos que ela o ajude a se familiarizar rapidamente com o básico. Felizmente, se você entende dplyr, você está em uma ótima posição para aprender rapidamente SQL, porque muitos dos conceitos são os mesmos.

Exploraremos a relação entre dplyr e SQL usando alguns velhos amigos do pacote nycflights13: flights e planes. Esses conjuntos de dados são fáceis de inserir em nosso banco de dados de aprendizado porque o dbplyr vem com uma função que copia as tabelas de nycflights13 para o nosso banco de dados:
"
dbplyr::copy_nycflights13(con)

flights <- tbl(con, "flights")
planes <- tbl(con, "planes")

#----21.5.1 Fundamentos do SQL----
"
Os componentes de nível superior do SQL são chamados de instruções. Instruções comuns incluem CREATE para definir novas tabelas, INSERT para adicionar dados e SELECT para recuperar dados. Nos concentraremos nas instruções SELECT, também chamadas de consultas, porque são quase exclusivamente o que você usará como cientista de dados.

Uma consulta é composta de cláusulas. Há cinco cláusulas importantes: SELECT, FROM, WHERE, ORDER BY e GROUP BY. Toda consulta deve ter as cláusulas SELECT e FROM, e a consulta mais simples é SELECT * FROM table, que seleciona todas as colunas da tabela especificada. Isso é o que o dbplyr gera para uma tabela não modificada:
"
flights |> show_query()
planes |> show_query()

"
WHERE e ORDER BY controlam quais linhas são incluídas e como são ordenadas:
"
flights |> 
  filter(dest == "IAH") |> 
  arrange(dep_delay) |>
  show_query()

"
GROUP BY converte a consulta em um resumo, fazendo com que a agregação aconteça:
"
flights |> 
  group_by(dest) |> 
  summarize(dep_delay = mean(dep_delay, na.rm = TRUE)) |> 
  show_query()

"
Há duas diferenças importantes entre os funções dplyr e as cláusulas SELECT:
"
#1º No SQL, o caso não importa: você pode escrever select, SELECT ou até SeLeCt. Neste livro, vamos seguir a convenção comum de escrever palavras-chave SQL em maiúsculas para distingui-las de nomes de tabelas ou variáveis.
#2º No SQL, a ordem importa: você deve sempre escrever as cláusulas na ordem SELECT, FROM, WHERE, GROUP BY, ORDER BY. Confusamente, essa ordem não corresponde a como as cláusulas são realmente avaliadas, que é primeiro FROM, depois WHERE, GROUP BY, SELECT e ORDER BY.

"
As seções seguintes exploram cada cláusula em mais detalhes.

Note que, embora o SQL seja um padrão, ele é extremamente complexo e nenhum banco de dados o segue exatamente. Embora os principais componentes em que nos concentraremos neste livro sejam muito semelhantes entre os SGDBs, há muitas variações menores. Felizmente, o dbplyr foi projetado para lidar com esse problema e gera diferentes traduções para diferentes bancos de dados. Não é perfeito, mas está continuamente melhorando, e se você encontrar um problema, pode abrir um problema no GitHub para nos ajudar a fazer melhor.
"

#----21.5.2 SELECT----
"
A cláusula SELECT é o cavalo de batalha das consultas e realiza o mesmo trabalho que select(), mutate(), rename(), relocate() e, como você aprenderá na próxima seção, summarize().

select(), rename() e relocate() têm traduções muito diretas para SELECT, pois afetam apenas onde uma coluna aparece (se aparecer) junto com seu nome:
"
planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  show_query()

planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  rename(year_built = year) |> 
  show_query()

planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  relocate(manufacturer, model, .before = type) |> 
  show_query()

"
Este exemplo também mostra como o SQL faz a renomeação. No SQL, a renomeação é chamada de aliasing e é feita com AS. Observe que, ao contrário de mutate(), o nome antigo está à esquerda e o novo nome está à direita.

Nos exemplos acima, note que 'year' e 'type' estão envolvidos em aspas duplas. Isso ocorre porque são palavras reservadas no duckdb, então o dbplyr as coloca entre aspas para evitar qualquer confusão potencial entre nomes de colunas/tabelas e operadores SQL.

Ao trabalhar com outros bancos de dados, é provável que você veja todos os nomes de variáveis entre aspas, porque apenas alguns pacotes clientes, como duckdb, sabem quais são todas as palavras reservadas, então eles colocam tudo entre aspas para garantir a segurança.
"
#SELECT "tailnum", "type", "manufacturer", "model", "year"
#FROM "planes"

"
Alguns outros sistemas de banco de dados usam crases em vez de aspas:
"
#SELECT `tailnum`, `type`, `manufacturer`, `model`, `year`
#FROM `planes`

"
As traduções para mutate() são igualmente diretas: cada variável se torna uma nova expressão em SELECT:
"
flights |> 
  mutate(
    speed = distance / (air_time / 60)
  ) |> 
  show_query()

"
Voltaremos à tradução de componentes individuais (como /) posteriormente.
"

#----21.5.3 FROM----
"
A cláusula FROM define a fonte de dados. Ela será um pouco sem graça por um tempo, porque estamos apenas usando tabelas únicas. Você verá exemplos mais complexos quando chegarmos às funções de junção.
"

#----21.5.4 GROUP BY----
"
group_by() é traduzido para a cláusula GROUP BY e summarize() é traduzido para a cláusula SELECT:
"
diamonds_db |> 
  group_by(cut) |> 
  summarize(
    n = n(),
    avg_price = mean(price, na.rm = TRUE)
  ) |> 
  show_query()

"
Voltaremos ao que está acontecendo com a tradução de n() e mean().
"

#----21.5.5 WHERE----
"
filter() é traduzido para a cláusula WHERE:
"
flights |> 
  filter(dest == "IAH" | dest == "HOU") |> 
  show_query()


flights |> 
  filter(arr_delay > 0 & arr_delay < 20) |> 
  show_query()

"
Há alguns detalhes importantes a serem observados aqui:
"
#1º | se torna OR e & se torna AND.
#2º SQL usa = para comparação, não ==. SQL não tem atribuição, então não há potencial para confusão.
#3º SQL usa apenas '' para strings, não "". No SQL, "" é usado para identificar variáveis, como o `` do R.

"
Outro operador SQL útil é IN, que é muito próximo do %in% do R:
"
flights |> 
  filter(dest %in% c("IAH", "HOU")) |> 
  show_query()

"
SQL usa NULL em vez de NA. Os NULLs se comportam de maneira semelhante aos NAs. A principal diferença é que, enquanto eles são 'infecciosos' em comparações e aritmética, eles são silenciosamente descartados ao resumir. O dbplyr lembrará você sobre esse comportamento na primeira vez que você o encontrar:
"
flights |> 
  group_by(dest) |> 
  summarize(delay = mean(arr_delay))

"
Se você quiser aprender mais sobre como os NULLs funcionam, pode gostar de 'Three valued logic' de Markus Winand.

Em geral, você pode trabalhar com NULLs usando as funções que usaria para NAs no R:
"
flights |> 
  filter(!is.na(dep_delay)) |> 
  show_query()

"
Esta consulta SQL ilustra uma das desvantagens do dbplyr: embora o SQL esteja correto, não é tão simples quanto você poderia escrever à mão. Neste caso, você poderia remover os parênteses e usar um operador especial que é mais fácil de ler:
"
#WHERE "dep_delay" IS NOT NULL

"
Observe que, se você usar filter() em uma variável que você criou usando summarize, o dbplyr gerará uma cláusula HAVING, em vez de uma cláusula WHERE. Essa é uma das idiossincrasias do SQL: WHERE é avaliado antes de SELECT e GROUP BY, então o SQL precisa de outra cláusula que seja avaliada posteriormente.
"
diamonds_db |> 
  group_by(cut) |> 
  summarize(n = n()) |> 
  filter(n > 100) |> 
  show_query()

#----21.5.6 ORDER BY----
"
Ordenar linhas envolve uma tradução direta de arrange() para a cláusula ORDER BY:
"
flights |> 
  arrange(year, month, day, desc(dep_delay)) |> 
  show_query()

"
Observe como desc() é traduzido para DESC: essa é uma das muitas funções dplyr cujo nome foi diretamente inspirado pelo SQL.
"

#----21.5.7 Subconsultas----
"
Às vezes, não é possível traduzir um pipeline dplyr em uma única instrução SELECT e você precisa usar uma subconsulta. Uma subconsulta é apenas uma consulta usada como fonte de dados na cláusula FROM, em vez da tabela usual.

O dbplyr normalmente usa subconsultas para contornar limitações do SQL. Por exemplo, expressões na cláusula SELECT não podem se referir a colunas que acabaram de ser criadas. Isso significa que o seguinte pipeline dplyr (tolo) precisa acontecer em duas etapas: a primeira consulta (interna) calcula year1 e, em seguida, a segunda consulta (externa) pode calcular year2.
"
flights |> 
  mutate(
    year1 = year + 1,
    year2 = year1 + 1
  ) |> 
  show_query()

"
Você também verá isso se tentar filtrar uma variável que acabou de criar. Lembre-se de que, mesmo que WHERE seja escrito após SELECT, ele é avaliado antes dele, então precisamos de uma subconsulta neste exemplo (tolo):
"
flights |> 
  mutate(year1 = year + 1) |> 
  filter(year1 == 2014) |> 
  show_query()

"
Às vezes, o dbplyr criará uma subconsulta onde não é necessário porque ainda não sabe como otimizar essa tradução. À medida que o dbplyr melhora com o tempo, esses casos se tornarão mais raros, mas provavelmente nunca desaparecerão.
"
#----21.5.8 Junções----
"
Se você está familiarizado com as junções do dplyr, as junções SQL são muito semelhantes. Aqui está um exemplo simples:
"
flights |> 
  left_join(planes |> rename(year_built = year), by = "tailnum") |> 
  show_query()

"
A principal coisa a se notar aqui é a sintaxe: as junções SQL usam subcláusulas da cláusula FROM para trazer tabelas adicionais, usando ON para definir como as tabelas estão relacionadas.

Os nomes do dplyr para essas funções estão tão intimamente conectados ao SQL que você pode facilmente adivinhar o SQL equivalente para inner_join(), right_join() e full_join():
"
#SELECT flights.*, "type", manufacturer, model, engines, seats, speed
#FROM flights
#INNER JOIN planes ON (flights.tailnum = planes.tailnum)

#SELECT flights.*, "type", manufacturer, model, engines, seats, speed
#FROM flights
#RIGHT JOIN planes ON (flights.tailnum = planes.tailnum)

#SELECT flights.*, "type", manufacturer, model, engines, seats, speed
#FROM flights
#FULL JOIN planes ON (flights.tailnum = planes.tailnum)

"
Você provavelmente precisará de muitas junções ao trabalhar com dados de um banco de dados. Isso ocorre porque as tabelas de banco de dados geralmente são armazenadas em uma forma altamente normalizada, onde cada 'fato' é armazenado em um único lugar e para manter um conjunto de dados completo para análise, você precisa navegar por uma rede complexa de tabelas conectadas por chaves primárias e estrangeiras. Se você encontrar esse cenário, o https://dm.cynkra.com/, por Tobias Schieferdecker, Kirill Müller e Darko Bergant, é um salva-vidas. Ele pode determinar automaticamente as conexões entre as tabelas usando as restrições que os administradores de banco de dados frequentemente fornecem, visualizar as conexões para que você possa ver o que está acontecendo e gerar as junções necessárias para conectar uma tabela a outra.
"

#----21.5.9 Outros verbos----
"
O dbplyr também traduz outros verbos como distinct(), slice_*(), e intersect(), além de uma crescente seleção de funções do tidyr como pivot_longer() e pivot_wider(). A maneira mais fácil de ver o conjunto completo do que está atualmente disponível é visitar o site do dbplyr: https://dbplyr.tidyverse.org/reference/.
"

#----21.6 Traduções de Funções----
"

Até agora, nos concentramos na visão geral de como os verbos do dplyr são traduzidos para as cláusulas de uma consulta. Agora, vamos nos aprofundar um pouco e falar sobre a tradução das funções do R que trabalham com colunas individuais, por exemplo, o que acontece quando você usa mean(x) em um summarize()?

Para ajudar a ver o que está acontecendo, usaremos algumas pequenas funções auxiliares que executam um summarize() ou mutate() e mostram o SQL gerado. Isso tornará um pouco mais fácil explorar algumas variações e ver como os resumos e transformações podem diferir.
"
summarize_query <- function(df, ...) {
  df |> 
    summarize(...) |> 
    show_query()
}

mutate_query <- function(df, ...) {
  df |> 
    mutate(..., .keep = "none") |> 
    show_query()
}

"
Vamos mergulhar em alguns resumos! Olhando o código abaixo, você notará que algumas funções de resumo, como mean(), têm uma tradução relativamente simples, enquanto outras, como median(), são muito mais complexas. A complexidade é tipicamente maior para operações comuns em estatísticas, mas menos comuns em bancos de dados.
"
flights |> 
  group_by(year, month, day) |>  
  summarize_query(
    mean = mean(arr_delay, na.rm = TRUE),
    median = median(arr_delay, na.rm = TRUE)
  )

"
A tradução de funções de resumo se torna mais complicada quando você as usa dentro de um mutate() porque elas precisam se transformar em chamadas funções de janela. No SQL, você transforma uma função de agregação comum em uma função de janela adicionando OVER depois dela:
"
flights |> 
  group_by(year, month, day) |>  
  mutate_query(
    mean = mean(arr_delay, na.rm = TRUE),
  )

"
No SQL, a cláusula GROUP BY é usada exclusivamente para resumos, então aqui você pode ver que o agrupamento mudou do argumento PARTITION BY para OVER.

Funções de janela incluem todas as funções que olham para frente ou para trás, como lead() e lag(), que olham para o valor 'anterior' ou 'próximo', respectivamente:
"
flights |> 
  group_by(dest) |>  
  arrange(time_hour) |> 
  mutate_query(
    lead = lead(arr_delay),
    lag = lag(arr_delay)
  )

"
Aqui é importante usar arrange() nos dados, porque as tabelas SQL não têm ordem intrínseca. De fato, se você não usar arrange(), pode receber as linhas em uma ordem diferente a cada vez! Observe que, para funções de janela, as informações de ordenação são repetidas: a cláusula ORDER BY da consulta principal não se aplica automaticamente a funções de janela.

Outra função SQL importante é CASE WHEN. É usada como a tradução de if_else() e case_when(), a função dplyr que ela diretamente inspirou. Aqui estão alguns exemplos simples:
"
flights |> 
  mutate_query(
    description = if_else(arr_delay > 0, "delayed", "on-time")
  )

flights |> 
  mutate_query(
    description = 
      case_when(
        arr_delay < -5 ~ "early", 
        arr_delay < 5 ~ "on-time",
        arr_delay >= 5 ~ "late"
      )
  )

"
CASE WHEN também é usado para algumas outras funções que não têm uma tradução direta do R para SQL. Um bom exemplo disso é cut():
"
flights |> 
  mutate_query(
    description =  cut(
      arr_delay, 
      breaks = c(-Inf, -5, 5, Inf), 
      labels = c("early", "on-time", "late")
    )
  )

"
O dbplyr também traduz funções comuns de manipulação de strings e datas, sobre as quais você pode aprender no vignette('translation-function', package = 'dbplyr'). As traduções do dbplyr certamente não são perfeitas, e há muitas funções do R que ainda não são traduzidas, mas o dbplyr faz um trabalho surpreendentemente bom cobrindo as funções que você usará na maior parte do tempo.
"

#Capítulo 22 : Arrow----

#----22.1 Introdução----
"

Arquivos CSV são projetados para serem facilmente lidos por humanos. Eles são um bom formato de intercâmbio porque são muito simples e podem ser lidos por praticamente todas as ferramentas existentes. Mas arquivos CSV não são muito eficientes: é necessário fazer bastante trabalho para ler os dados no R. Neste capítulo, você aprenderá sobre uma alternativa poderosa: o formato parquet, um formato baseado em padrões abertos amplamente utilizado por sistemas de big data.

Vamos combinar arquivos parquet com o Apache Arrow, uma caixa de ferramentas multi-idioma projetada para análise eficiente e transporte de grandes conjuntos de dados. Usaremos o Apache Arrow por meio do pacote arrow, que fornece um backend dplyr permitindo que você analise conjuntos de dados maiores que a memória usando a sintaxe familiar do dplyr. Como benefício adicional, o arrow é extremamente rápido: você verá alguns exemplos mais adiante no capítulo.

Tanto o arrow quanto o dbplyr fornecem backends dplyr, então você pode se perguntar quando usar cada um. Em muitos casos, a escolha já é feita para você, pois os dados já estão em um banco de dados ou em arquivos parquet, e você vai querer trabalhar com eles como estão. Mas se você está começando com seus próprios dados (talvez arquivos CSV), você pode carregá-los em um banco de dados ou convertê-los para parquet. Em geral, é difícil saber o que funcionará melhor, então, nos estágios iniciais de sua análise, encorajamos você a tentar ambos e escolher o que funcionar melhor para você.
"

#----22.1.1 Pré-requisitos----
"
Neste capítulo, continuaremos a usar o tidyverse, particularmente o dplyr, mas o combinaremos com o pacote arrow, que é projetado especificamente para trabalhar com grandes conjuntos de dados.
"
library(tidyverse)
library(arrow)

"
Mais adiante no capítulo, também veremos algumas conexões entre o arrow e o duckdb, então também precisaremos do dbplyr e do duckdb.
"
library(dbplyr, warn.conflicts = FALSE)
library(duckdb)

#----22.2 Obtendo os Dados----
"

Começamos obtendo um conjunto de dados digno dessas ferramentas: um conjunto de dados de empréstimos de itens das bibliotecas públicas de Seattle, disponível online em 
data.seattle.gov/Community/Checkouts-by-Title/tmmm-ytt6. Este conjunto de dados contém 41.389.465 linhas que informam quantas vezes cada livro foi emprestado a cada mês de abril de 2005 a outubro de 2022.

O código a seguir fornecerá uma cópia em cache dos dados. Os dados são um arquivo CSV de 9GB, então levará algum tempo para baixar. Eu recomendo fortemente o uso de curl::multi_download() para obter arquivos muito grandes, pois ele é construído exatamente para esse propósito: ele fornece uma barra de progresso e pode retomar o download se for interrompido.
"
#dir.create("data", showWarnings = FALSE); ele cria um diretório para salvar esse arquivo, vou salvar no meu diretório padrão, por isso não especifiquei onde era para salvar.
#curl::multi_download("https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv","data/seattle-library-checkouts.csv",resume = TRUE)

curl::multi_download(
  "https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv",
  "seattle-library-checkouts.csv",
  resume = TRUE
)

#----22.3 Abrindo um Conjunto de Dados----
"
Vamos começar dando uma olhada nos dados. Com 9 GB, este arquivo é grande o suficiente para que provavelmente não queiramos carregar tudo na memória. Uma boa regra é que você geralmente quer pelo menos o dobro de memória do tamanho dos dados, e muitos laptops têm no máximo 16 GB. Isso significa que queremos evitar read_csv() e, em vez disso, usar arrow::open_dataset():
"
seattle_csv <- open_dataset(
  sources = "seattle-library-checkouts.csv", 
  col_types = schema(ISBN = string()),
  format = "csv"
)

"
O que acontece quando esse código é executado? open_dataset() fará uma varredura em algumas milhares de linhas para descobrir a estrutura do conjunto de dados. A coluna ISBN contém valores em branco para as primeiras 80.000 linhas, então temos que especificar o tipo da coluna para ajudar o arrow a entender a estrutura dos dados. Uma vez que os dados foram escaneados por open_dataset(), ele registra o que encontrou e para; ele só lerá mais linhas conforme você as solicitar especificamente. Esses metadados são o que vemos se imprimirmos seattle_csv:
"
seattle_csv

"
A primeira linha na saída informa que seattle_csv está armazenado localmente em disco como um único arquivo CSV; ele só será carregado na memória conforme necessário. O restante da saída informa o tipo de coluna que o arrow inferiu para cada coluna.

Podemos ver o que está realmente em com glimpse(). Isso revela que há cerca de 41 milhões de linhas e 12 colunas e nos mostra alguns valores.
"
seattle_csv |> glimpse()

"
Podemos começar a usar este conjunto de dados com os verbos dplyr, usando collect() para forçar o arrow a realizar o cálculo e retornar alguns dados. Por exemplo, este código nos informa o número total de empréstimos por ano:
"
seattle_csv |> 
  group_by(CheckoutYear) |> 
  summarise(Checkouts = sum(Checkouts)) |> 
  arrange(CheckoutYear) |> 
  collect()

"
Graças ao arrow, esse código funcionará independentemente de quão grande seja o conjunto de dados subjacente. Mas atualmente é bastante lento: no computador de Hadley, levou cerca de 10s para rodar. Não é terrível, dado a quantidade de dados que temos, mas podemos torná-lo muito mais rápido mudando para um formato melhor.
"

#----22.4 O Formato Parquet----
"
Para tornar esses dados mais fáceis de trabalhar, vamos mudar para o formato de arquivo parquet e dividi-lo em vários arquivos. As próximas seções primeiro apresentarão o parquet e o particionamento e, em seguida, aplicarão o que aprendemos aos dados da biblioteca de Seattle.
"

#----22.4.1 Vantagens do Parquet----
"
Como os arquivos CSV, o parquet é usado para dados retangulares, mas em vez de ser um formato de texto que você pode ler com qualquer editor de arquivo, é um formato binário personalizado projetado especificamente para as necessidades de big data. Isso significa que:
"
#1º Arquivos parquet geralmente são menores que o arquivo CSV equivalente. O parquet depende de codificações eficientes para manter o tamanho do arquivo reduzido e suporta compressão de arquivo. Isso ajuda a tornar os arquivos parquet rápidos porque há menos dados para mover do disco para a memória.
#2º Arquivos parquet têm um rico sistema de tipos. Como discutimos na anteriormente, um arquivo CSV não fornece informações sobre os tipos de colunas. Por exemplo, um leitor de CSV precisa adivinhar se "08-10-2022" deve ser interpretado como uma string ou uma data. Em contraste, os arquivos parquet armazenam dados de uma maneira que registra o tipo junto com os dados.
#3º Arquivos parquet têm um rico sistema de tipos. Como discutimos na Seção 7.3, um arquivo CSV não fornece informações sobre os tipos de colunas. Por exemplo, um leitor de CSV precisa adivinhar se "08-10-2022" deve ser interpretado como uma string ou uma data. Em contraste, os arquivos parquet armazenam dados de uma maneira que registra o tipo junto com os dados.
#4º Arquivos parquet são "fragmentados", o que torna possível trabalhar em diferentes partes do arquivo ao mesmo tempo e, se você tiver sorte, pular alguns fragmentos completamente.

"
Há uma desvantagem primária para arquivos parquet: eles não são mais 'legíveis por humanos', ou seja, se você olhar para um arquivo parquet usando readr::read_file(), você verá apenas um monte de caracteres sem sentido.
"

#----22.4.2 Particionamento----
"
À medida que os conjuntos de dados ficam cada vez maiores, armazenar todos os dados em um único arquivo se torna cada vez mais doloroso, e muitas vezes é útil dividir grandes conjuntos de dados em vários arquivos. Quando essa estruturação é feita de forma inteligente, essa estratégia pode levar a melhorias significativas no desempenho, porque muitas análises exigirão apenas um subconjunto dos arquivos.

Não existem regras rígidas sobre como particionar seu conjunto de dados: os resultados dependerão dos seus dados, padrões de acesso e dos sistemas que leem os dados. Você provavelmente precisará fazer algumas experimentações antes de encontrar a partição ideal para a sua situação. Como um guia geral, o arrow sugere que você evite arquivos menores que 20MB e maiores que 2GB e evite partições que produzam mais de 10.000 arquivos. Você também deve tentar particionar por variáveis pelas quais você filtra; como você verá em breve, isso permite que o arrow pule muito trabalho lendo apenas os arquivos relevantes.
"

#----22.4.3 Reescrevendo os Dados da Biblioteca de Seattle----
"
Vamos aplicar essas ideias aos dados da biblioteca de Seattle para ver como eles se concretizam na prática. Vamos particionar por CheckoutYear, já que é provável que algumas análises queiram apenas olhar para dados recentes e a partição por ano produz 18 pedaços de tamanho razoável.

Para reescrever os dados, definimos a partição usando dplyr::group_by() e, em seguida, salvamos as partições em um diretório com arrow::write_dataset(). write_dataset() tem dois argumentos importantes: um diretório onde criaremos os arquivos e o formato que usaremos.
"
pq_path <- "seattle-library-checkouts"

seattle_csv |>
  group_by(CheckoutYear) |>
  write_dataset(path = pq_path, format = "parquet")

"
Isso leva cerca de um minuto para ser executado; como veremos em breve, esse é um investimento inicial que compensa ao tornar operações futuras muito mais rápidas.

Vamos dar uma olhada no que acabamos de produzir:
"
tibble(
  files = list.files(pq_path, recursive = TRUE),
  size_MB = file.size(file.path(pq_path, files)) / 1024^2
)

"
Nosso único arquivo CSV de 9GB foi reescrito em 18 arquivos parquet. Os nomes dos arquivos usam uma convenção 'autoexplicativa' usada pelo projeto Apache Hive. Partições no estilo Hive nomeiam pastas com uma convenção 'chave=valor', então, como você pode imaginar, o diretório CheckoutYear=2005 contém todos os dados onde CheckoutYear é 2005. Cada arquivo tem entre 100 e 300 MB e o tamanho total agora é de cerca de 4 GB, pouco mais da metade do tamanho do arquivo CSV original. Isso é o que esperamos, já que o parquet é um formato muito mais eficiente.
"

#----22.5 Usando dplyr com Arrow----
"
Agora que criamos esses arquivos parquet, precisamos lê-los novamente. Usamos open_dataset() novamente, mas desta vez damos a ele um diretório:
"
seattle_pq <- open_dataset(pq_path)

"
Agora que criamos esses arquivos parquet, precisamos lê-los novamente. Usamos open_dataset() novamente, mas desta vez damos a ele um diretório:
"
query <- seattle_pq |> 
  filter(CheckoutYear >= 2018, MaterialType == "BOOK") |>
  group_by(CheckoutYear, CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(CheckoutYear, CheckoutMonth)

"
Escrever código dplyr para dados arrow é conceitualmente semelhante ao dbplyr, Capítulo 21: você escreve código dplyr, que é automaticamente transformado em uma consulta que a biblioteca C++ do Apache Arrow entende, que é então executada quando você chama collect(). Se imprimirmos o objeto de consulta, podemos ver um pouco de informação sobre o que esperamos que o Arrow retorne quando a execução ocorrer:
"
query

"
E podemos obter os resultados chamando collect():
"
query |> collect()

"
Como o dbplyr, o arrow só entende algumas expressões R, então você pode não ser capaz de escrever exatamente o mesmo código que normalmente escreveria. No entanto, a lista de operações e funções suportadas é bastante extensa e continua a crescer; encontre uma lista completa das funções atualmente suportadas em ?acero.
"

#----22.5.1 Desempenho----
"
Vamos dar uma rápida olhada no impacto no desempenho de mudar de CSV para parquet. Primeiro, vamos cronometrar quanto tempo leva para calcular o número de livros emprestados em cada mês de 2021, quando os dados estão armazenados como um único grande arquivo csv:
"
seattle_csv |> 
  filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

"
Agora, vamos usar nossa nova versão do conjunto de dados na qual os dados de empréstimos da biblioteca de Seattle foram particionados em 18 arquivos parquet menores:
"
seattle_pq |> 
  filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

"
O aumento de velocidade de ~100x no desempenho é atribuível a dois fatores: a partição em vários arquivos e o formato dos arquivos individuais:
"
#1º A partição melhora o desempenho porque esta consulta usa CheckoutYear == 2021 para filtrar os dados, e o arrow é inteligente o suficiente para reconhecer que só precisa ler 1 dos 18 arquivos parquet.
#2º O formato parquet melhora o desempenho ao armazenar dados em um formato binário que pode ser lido mais diretamente na memória. O formato colunar e os ricos metadados significam que o arrow só precisa ler as quatro colunas realmente usadas na consulta (CheckoutYear, MaterialType, CheckoutMonth e Checkouts).

"
Essa enorme diferença no desempenho é o motivo pelo qual vale a pena converter grandes CSVs para parquet!
"

#----22.5.2 Usando duckdb com Arrow----
"
Há mais uma vantagem do parquet e do arrow — é muito fácil transformar um conjunto de dados arrow em um banco de dados DuckDB chamando arrow::to_duckdb()
"
seattle_pq |> 
  to_duckdb() |>
  filter(CheckoutYear >= 2018, MaterialType == "BOOK") |>
  group_by(CheckoutYear) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutYear)) |>
  collect()

"
O aspecto interessante de to_duckdb() é que a transferência não envolve cópia de memória e fala sobre os objetivos do ecossistema arrow: permitir transições contínuas de um ambiente de computação para outro.
"

#----Capítulo 23 : Dados Hierárquicos----

#----23.1 Introdução----
"
Agora, você aprenderá a arte de retangularizar dados: pegar dados que são fundamentalmente hierárquicos ou semelhantes a uma árvore e convertê-los em um quadro de dados retangular composto por linhas e colunas. Isso é importante porque dados hierárquicos são surpreendentemente comuns, especialmente ao trabalhar com dados provenientes da web.

Para aprender sobre retangularização, você primeiro precisará aprender sobre listas, a estrutura de dados que torna possível a existência de dados hierárquicos. Depois, você aprenderá sobre duas funções cruciais do tidyr: tidyr::unnest_longer() e tidyr::unnest_wider(). Em seguida, mostraremos alguns estudos de caso, aplicando essas funções simples repetidas vezes para resolver problemas reais. Finalizaremos falando sobre JSON, a fonte mais frequente de conjuntos de dados hierárquicos e um formato comum para troca de dados na web.
"

#----23.1.1 Pré-requisitos----
"
Neste capítulo, usaremos muitas funções do tidyr, um membro fundamental do tidyverse. Também usaremos repurrrsive para fornecer alguns conjuntos de dados interessantes para a prática de retangularização e finalizaremos usando jsonlite para ler arquivos JSON em listas do R.
"
library(tidyverse)
library(repurrrsive)
library(jsonlite)

#----23.2 Listas----
"
Até agora, você trabalhou com quadros de dados que contêm vetores simples como inteiros, números, caracteres, datas-horas e fatores. Esses vetores são simples porque são homogêneos: cada elemento é do mesmo tipo de dado. Se você quiser armazenar elementos de tipos diferentes no mesmo vetor, precisará de uma lista, que você cria com list():
"
x1 <- list(1:4, "a", TRUE)
x1

"
Muitas vezes é conveniente nomear os componentes, ou filhos, de uma lista, o que você pode fazer da mesma maneira que nomear as colunas de um tibble:
"
x2 <- list(a = 1:2, b = 1:3, c = 1:4)
x2

"
Mesmo para essas listas muito simples, a impressão ocupa bastante espaço. Uma alternativa útil é str(), que gera uma exibição compacta da estrutura, desenfatizando o conteúdo:
"
str(x1)
str(x2)

"
Como você pode ver, str() exibe cada filho da lista em sua própria linha. Ele exibe o nome, se presente, depois uma abreviação do tipo e, em seguida, os primeiros valores.
"

#----23.2.1 Hierarquia----
"
As listas podem conter qualquer tipo de objeto, incluindo outras listas. Isso as torna adequadas para representar estruturas hierárquicas (semelhantes a árvores):
"
x3 <- list(list(1, 2), list(3, 4))
str(x3)

"
Isso é notavelmente diferente de c(), que gera um vetor plano:
"
c(c(1, 2), c(3, 4))

x4 <- c(list(1, 2), list(3, 4))
str(x4)

"
À medida que as listas se tornam mais complexas, str() se torna mais útil, pois permite que você veja a hierarquia de relance:
"
x5 <- list(1, list(2, list(3, list(4, list(5)))))
str(x5)

"
À medida que as listas ficam ainda maiores e mais complexas, str() eventualmente começa a falhar, e você precisará mudar para View()1. O visualizador começa mostrando apenas o nível superior da lista, mas você pode expandir interativamente qualquer um dos componentes para ver mais. O RStudio também mostrará o código que você precisa para acessar esse elemento. Voltaremos a como esse código funciona mais a frente.
"

#----23.2.2 Colunas-lista----
"

As listas também podem viver dentro de um tibble, onde as chamamos de colunas-lista. Colunas-lista são úteis porque permitem que você coloque objetos em um tibble que normalmente não pertenceriam ali. Em particular, colunas-lista são muito usadas no ecossistema tidymodels, porque permitem que você armazene coisas como resultados de modelos ou reamostras em um quadro de dados.

Aqui está um exemplo simples de uma coluna-lista:
"
df <- tibble(
  x = 1:2, 
  y = c("a", "b"),
  z = list(list(1, 2), list(3, 4, 5))
)
df

"
Não há nada de especial sobre listas em um tibble; elas se comportam como qualquer outra coluna:
"
df |> 
  filter(x == 1)

"
Computar com colunas-lista é mais difícil, mas isso ocorre porque computar com listas é mais difícil em geral; voltaremos a isso mais a frente. Agora, nos concentraremos em desaninhar colunas-lista em variáveis regulares para que você possa usar suas ferramentas existentes nelas.

O método de impressão padrão apenas exibe um resumo aproximado do conteúdo. A coluna-lista poderia ser arbitrariamente complexa, então não há uma boa maneira de imprimi-la. Se você quiser vê-la, precisará retirar apenas a coluna-lista e aplicar uma das técnicas que aprendeu acima, como df |> pull(z) |> str() ou df |> pull(z) |> View().
"


"
R Base

É possível colocar uma lista em uma coluna de um data.frame, mas é muito mais complicado porque data.frame() trata uma lista como uma lista de colunas:
"
data.frame(x = list(1:3, 3:5))

"
Você pode forçar data.frame() a tratar uma lista como uma lista de linhas envolvendo-a em I(), mas o resultado não é impresso particularmente bem:
"
data.frame(
  x = I(list(1:2, 3:5)), 
  y = c("1, 2", "3, 4, 5")
)

"
É mais fácil usar colunas-lista com tibbles porque tibble() trata listas como vetores e o método de impressão foi projetado tendo em mente as listas.
"

#----23.3 Desaninhando----
"
Agora que você aprendeu o básico sobre listas e colunas-lista, vamos explorar como você pode transformá-las novamente em linhas e colunas regulares. Aqui usaremos dados de amostra muito simples para que você possa entender a ideia básica; na próxima seção, mudaremos para dados reais.

Colunas-lista tendem a vir em duas formas básicas: nomeadas e não nomeadas. Quando os filhos são nomeados, eles tendem a ter os mesmos nomes em cada linha. Por exemplo, em df1, cada elemento da coluna-lista y tem dois elementos nomeados a e b. Colunas-lista nomeadas naturalmente se desaninham em colunas: cada elemento nomeado se torna uma nova coluna nomeada.
"
df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32),
)

"
Quando os filhos são não nomeados, o número de elementos tende a variar de linha para linha. Por exemplo, em df2, os elementos da coluna-lista y são não nomeados e variam em comprimento de um a três. Colunas-lista não nomeadas naturalmente se desaninham em linhas: você obterá uma linha para cada filho.
"

df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32),
)

"
O tidyr fornece duas funções para esses dois casos: unnest_wider() e unnest_longer(). As seções seguintes explicam como elas funcionam.
"

#----23.3.1 unnest_wider()----
"
By default, the names of the new columns come exclusively from the names of the list elements, but you can use the names_sep argument to request that they combine the column name and the element name. This is useful for disambiguating repeated names.
"
df1 |> 
  unnest_wider(y)

"
Por padrão, os nomes das novas colunas vêm exclusivamente dos nomes dos elementos da lista, mas você pode usar o argumento names_sep para solicitar que eles combinem o nome da coluna e o nome do elemento. Isso é útil para desambiguar nomes repetidos.
"
df1 |> 
  unnest_wider(y, names_sep = "_")

#----23.3.2 unnest_longer()----
"
Quando cada linha contém uma lista não nomeada, é mais natural colocar cada elemento em sua própria linha com unnest_longer():
"
df2 |> 
  unnest_longer(y)

"
Observe como x é duplicado para cada elemento dentro de y: obtemos uma linha de saída para cada elemento dentro da coluna-lista. Mas o que acontece se um dos elementos estiver vazio, como no exemplo a seguir?
"
df6 <- tribble(
  ~x, ~y,
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df6 |> unnest_longer(y)

"
Obtemos zero linhas na saída, então a linha efetivamente desaparece. Se você quiser preservar essa linha, adicionando NA em y, defina keep_empty = TRUE.
"

#----23.3.3 Tipos Inconsistentes----
"
O que acontece se você desaninhar uma coluna-lista que contém diferentes tipos de vetor? Por exemplo, pegue o seguinte conjunto de dados onde a coluna-lista y contém dois números, um caractere e um lógico, que normalmente não podem ser misturados em uma única coluna.
"
df4 <- tribble(
  ~x, ~y,
  "a", list(1),
  "b", list("a", TRUE, 5)
)

"
unnest_longer() sempre mantém o conjunto de colunas inalterado, enquanto muda o número de linhas. Então, o que acontece? Como o unnest_longer() produz cinco linhas enquanto mantém tudo em y?
"
df4 |> 
  unnest_longer(y)

"
Como você pode ver, a saída contém uma coluna-lista, mas cada elemento da coluna-lista contém um único elemento. Como o unnest_longer() não consegue encontrar um tipo comum de vetor, ele mantém os tipos originais em uma coluna-lista. Você pode se perguntar se isso viola o mandamento de que cada elemento de uma coluna deve ser do mesmo tipo. Não viola: cada elemento é uma lista, mesmo que o conteúdo seja de tipos diferentes.

Lidar com tipos inconsistentes é desafiador e os detalhes dependem da natureza precisa do problema e de seus objetivos, mas você provavelmente precisará de ferramentas futuras
"

#----23.3.4 Outras Funções----
"
O tidyr possui algumas outras funções úteis de retangularização que não irei tratar:
"
#1º unnest_auto() escolhe automaticamente entre unnest_longer() e unnest_wider() com base na estrutura da coluna-lista. É ótimo para exploração rápida, mas, no final das contas, é uma má ideia porque não o força a entender como seus dados estão estruturados e torna seu código mais difícil de entender.
#2º unnest() expande tanto linhas quanto colunas. É útil quando você tem uma coluna-lista que contém uma estrutura 2D, como um quadro de dados, o que você não vê neste livro, mas pode encontrar se usar o ecossistema tidymodels.

"
Essas funções são boas para saber, pois você pode encontrá-las ao ler o código de outras pessoas ou enfrentar desafios mais raros de retangularização por conta própria.
"

#----23.4 Estudos de Caso----
"
A principal diferença entre os exemplos simples que usamos acima e dados reais é que dados reais normalmente contêm vários níveis de aninhamento que requerem múltiplas chamadas para unnest_longer() e/ou unnest_wider(). Para mostrar isso na prática, esta seção trabalha através de três desafios reais de retangularização usando conjuntos de dados do pacote repurrrsive.
"

#----23.4.1 Dados Muito Amplos----
"
Vamos começar com gh_repos. Esta é uma lista que contém dados sobre uma coleção de repositórios do GitHub recuperados usando a API do GitHub. É uma lista muito aninhada, então é difícil mostrar a estrutura neste livro; recomendamos explorar um pouco por conta própria com View(gh_repos) antes de continuarmos.

gh_repos é uma lista, mas nossas ferramentas trabalham com colunas-lista, então começaremos colocando-a em um tibble. Chamamos essa coluna de json por razões que abordaremos mais tarde.
"
repos <- tibble(json = gh_repos)
repos

"
Este tibble contém 6 linhas, uma linha para cada filho de gh_repos. Cada linha contém uma lista não nomeada com 26 ou 30 linhas. Como elas são não nomeadas, começaremos com unnest_longer() para colocar cada filho em sua própria linha:
"
repos |> 
  unnest_longer(json)

"
À primeira vista, pode parecer que não melhoramos a situação: embora tenhamos mais linhas (176 em vez de 6), cada elemento de json ainda é uma lista. No entanto, há uma diferença importante: agora cada elemento é uma lista nomeada, então podemos usar unnest_wider() para colocar cada elemento em sua própria coluna:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) 

"
Isso funcionou, mas o resultado é um pouco esmagador: há tantas colunas que o tibble nem mesmo imprime todas! Podemos vê-las todas com names(); e aqui olhamos para as primeiras 10:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  names() |> 
  head(10)

"
Vamos selecionar algumas que parecem interessantes:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description)

"
Você pode usar isso para voltar e entender como gh_repos foi estruturado: cada filho era um usuário do GitHub contendo uma lista de até 30 repositórios do GitHub que eles criaram.

owner é outra coluna-lista, e como ela contém uma lista nomeada, podemos usar unnest_wider() para acessar os valores:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner)

"
Uh oh, esta coluna-lista também contém uma coluna id e não podemos ter duas colunas id no mesmo quadro de dados. Como sugerido, vamos usar names_sep para resolver o problema:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner, names_sep = "_")

"
Isso nos dá outro conjunto de dados amplo, mas você pode perceber que owner parece conter muitos dados adicionais sobre a pessoa que 'possui' o repositório.
"

#----23.4.2 Dados Relacionais----
"
Dados aninhados às vezes são usados para representar dados que normalmente espalharíamos por vários quadros de dados. Por exemplo, pegue got_chars, que contém dados sobre personagens que aparecem nos livros e na série de TV Game of Thrones. Como gh_repos, é uma lista, então começamos transformando-a em uma coluna-lista de um tibble:
"
chars <- tibble(json = got_chars)
chars

"
A coluna json contém elementos nomeados, então começaremos ampliando-a:
"
chars |> 
  unnest_wider(json)

"
E selecionando algumas colunas para facilitar a leitura:
"
characters <- chars |> 
  unnest_wider(json) |> 
  select(id, name, gender, culture, born, died, alive)
characters

"
Este conjunto de dados também contém muitas colunas-lista:
"
chars |> 
  unnest_wider(json) |> 
  select(id, where(is.list))

"
Vamos explorar a coluna titles. É uma coluna-lista não nomeada, então vamos desaninhá-la em linhas:
"
chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles)

"
Você pode esperar ver esses dados em sua própria tabela porque seria fácil juntá-los aos dados dos personagens conforme necessário. Vamos fazer isso, o que requer uma pequena limpeza: removendo as linhas que contêm strings vazias e renomeando titles para title, pois cada linha agora contém apenas um título.
"
titles <- chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles) |> 
  filter(titles != "") |> 
  rename(title = titles)
titles

"
Você pode imaginar criar uma tabela como essa para cada uma das colunas-lista e, em seguida, usar junções para combiná-las com os dados dos personagens conforme necessário.
"

#----23.4.3 Profundamente Aninhados----
"
Vamos encerrar esses estudos de caso com uma coluna-lista que é muito profundamente aninhada e requer rodadas repetidas de unnest_wider() e unnest_longer() para desvendar: gmaps_cities. Este é um tibble de duas colunas contendo cinco nomes de cidades e os resultados de usar a API de geocodificação do Google para determinar a localização deles:
"
gmaps_cities

"
json é uma coluna-lista com nomes internos, então começamos com um unnest_wider():
"
gmaps_cities |> 
  unnest_wider(json)

"
Isso nos dá o status e os resultados. Vamos descartar a coluna de status, já que todos estão 'OK'; em uma análise real, você também desejaria capturar todas as linhas onde status != 'OK' e descobrir o que deu errado. results é uma lista não nomeada, com um ou dois elementos (veremos o motivo em breve), então vamos desaninhá-la em linhas:
"
gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results)

"
Agora results é uma lista nomeada, então usaremos unnest_wider():
"
locations <- gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) |> 
  unnest_wider(results)
locations

"
Agora podemos ver por que duas cidades obtiveram dois resultados: Washington correspondeu tanto ao estado de Washington quanto a Washington, DC, e Arlington correspondeu a Arlington, Virgínia e Arlington, Texas.

Há alguns lugares diferentes para onde poderíamos ir a partir daqui. Podemos querer determinar a localização exata da correspondência, que está armazenada na coluna-lista geometry:
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry)

"
Isso nos dá novos bounds (uma região retangular) e location (um ponto). Podemos desaninhar location para ver a latitude (lat) e longitude (lng):
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  unnest_wider(location)

"
Extrair os bounds requer mais algumas etapas:
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  # foco na variável de interesse
  select(!location:viewport) |>
  unnest_wider(bounds)

"
Em seguida, renomeamos southwest e northeast (os cantos do retângulo) para que possamos usar names_sep para criar nomes curtos, mas evocativos:
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  select(!location:viewport) |>
  unnest_wider(bounds) |> 
  rename(ne = northeast, sw = southwest) |> 
  unnest_wider(c(ne, sw), names_sep = "_") 

"
Observe como desaninhamos duas colunas simultaneamente fornecendo um vetor de nomes de variáveis para unnest_wider().

Depois de descobrir o caminho para chegar aos componentes de interesse, você pode extraí-los diretamente usando outra função do tidyr, hoist():
"
locations |> 
  select(city, formatted_address, geometry) |> 
  hoist(
    geometry,
    ne_lat = c("bounds", "northeast", "lat"),
    sw_lat = c("bounds", "southwest", "lat"),
    ne_lng = c("bounds", "northeast", "lng"),
    sw_lng = c("bounds", "southwest", "lng"),
  )

"
Se esses estudos de caso aguçaram seu apetite por mais retangularização da vida real, você pode ver mais alguns exemplos em vignette('rectangling', package = 'tidyr').
"

#----23.5 JSON----
"
Todos os estudos de caso na seção anterior foram originados de JSON capturado na 'natureza'. JSON é a abreviação de javascript object notation e é a maneira como a maioria das APIs da web retorna dados. É importante entendê-lo porque, embora JSON e os tipos de dados do R sejam bastante semelhantes, não há um mapeamento perfeito de 1 para 1, então é bom entender um pouco sobre JSON se as coisas derem errado.
"

#----23.5.1 Tipos de Dados----
"
JSON é um formato simples projetado para ser facilmente lido e escrito por máquinas, não por humanos. Ele possui seis tipos de dados principais. Quatro deles são escalares:
"
#1º O tipo mais simples é um nulo (null), que desempenha o mesmo papel que o NA no R. Ele representa a ausência de dados.
#2º Uma string é muito parecida com uma string no R, mas deve sempre usar aspas duplas.
#3º Um número é semelhante aos números do R: eles podem usar notação inteira (por exemplo, 123), decimal (por exemplo, 123.45) ou científica (por exemplo, 1.23e3). JSON não suporta Inf, -Inf ou NaN.
#4º Um booleano é semelhante aos TRUE e FALSE do R, mas usa true e false em minúsculas.

"
Tanto arrays quanto objetos são semelhantes a listas no R; a diferença é se eles são nomeados ou não. Um array é como uma lista sem nome e é escrito com []. Por exemplo, [1, 2, 3] é um array contendo 3 números, e [null, 1, 'string', false] é um array que contém um nulo, um número, uma string e um booleano. Um objeto é como uma lista nomeada e é escrito com {}. Os nomes (chaves na terminologia JSON) são strings, então devem ser cercados por aspas. Por exemplo, {'x': 1, 'y': 2} é um objeto que mapeia x para 1 e y para 2.

Observe que o JSON não possui nenhuma maneira nativa de representar datas ou horários, então eles geralmente são armazenados como strings, e você precisará usar readr::parse_date() ou readr::parse_datetime() para convertê-los na estrutura de dados correta. Da mesma forma, as regras do JSON para representar números de ponto flutuante são um pouco imprecisas, então você também encontrará números armazenados em strings. Aplique readr::parse_double() conforme necessário para obter o tipo de variável correto.
"

#----23.5.2 jsonlite----
"
Para converter JSON em estruturas de dados do R, recomendamos o pacote jsonlite, de Jeroen Ooms. Usaremos apenas duas funções do jsonlite: read_json() e parse_json(). Na vida real, você usará read_json() para ler um arquivo JSON do disco. Por exemplo, o pacote repurrrsive também fornece a fonte para gh_user como um arquivo JSON e você pode lê-lo com read_json():
"
# Um caminho para um arquivo json dentro do pacote:
gh_users_json()

# Um caminho para um arquivo json dentro do pacote:
gh_users2 <- read_json(gh_users_json())

# Um caminho para um arquivo json dentro do pacote:
identical(gh_users, gh_users2)

"
Neste livro, também usaremos parse_json(), pois ele recebe uma string contendo JSON, o que o torna bom para gerar exemplos simples. Para começar, aqui estão três conjuntos de dados JSON simples, começando com um número, depois colocando alguns números em um array e, em seguida, colocando esse array em um objeto:
"
str(parse_json('1'))
str(parse_json('[1, 2, 3]'))
str(parse_json('{"x": [1, 2, 3]}'))

"
O jsonlite tem outra função importante chamada fromJSON(). Não a usamos aqui porque ela realiza simplificação automática (simplifyVector = TRUE). Isso geralmente funciona bem, especialmente em casos simples, mas achamos que você se sairá melhor fazendo a retangularização você mesmo para saber exatamente o que está acontecendo e poder lidar mais facilmente com as estruturas aninhadas mais complicadas.
"

#----23.5.3 Iniciando o Processo de Retangularização----
"
Na maioria dos casos, os arquivos JSON contêm um único array de nível superior, porque são projetados para fornecer dados sobre várias 'coisas', por exemplo, várias páginas, registros ou resultados. Neste caso, você começará a retangularização com tibble(json) para que cada elemento se torne uma linha:
"
json <- '[
  {"name": "John", "age": 34},
  {"name": "Susan", "age": 27}
]'
df <- tibble(json = parse_json(json))
df

df |> 
  unnest_wider(json)

"
Em casos mais raros, o arquivo JSON consiste em um único objeto JSON de nível superior, representando uma 'coisa'. Neste caso, você precisará iniciar o processo de retangularização envolvendo-o em uma lista, antes de colocá-lo em um tibble.
"
json <- '{
  "status": "OK", 
  "results": [
    {"name": "John", "age": 34},
    {"name": "Susan", "age": 27}
 ]
}
'
df <- tibble(json = list(parse_json(json)))
df


df |> 
  unnest_wider(json) |> 
  unnest_longer(results) |> 
  unnest_wider(results)

"
Alternativamente, você pode acessar o JSON analisado e começar com a parte que realmente lhe interessa:
"
df <- tibble(results = parse_json(json)$results)
df |> 
  unnest_wider(results)

# Capítulo 24: Web Scraping----

#----24.1 Introdução----
"
Este capítulo apresenta os fundamentos da web scraping com o rvest. A web scraping é uma ferramenta muito útil para extrair dados de páginas da web. Alguns sites oferecem uma API, um conjunto de solicitações HTTP estruturadas que retornam dados como JSON, que você pode manipular usando as técnicas vistas anteriormente. Sempre que possível, você deve usar a API, porque normalmente ela fornecerá dados mais confiáveis. Infelizmente, no entanto, programar com APIs da web está fora do escopo deste livro. Em vez disso, estamos ensinando web scraping, uma técnica que funciona independentemente de o site fornecer ou não uma API.

Neste capítulo, discutiremos primeiro a ética e legalidades da web scraping antes de mergulharmos nos fundamentos do HTML. Você aprenderá os conceitos básicos de seletores CSS para localizar elementos específicos na página e como usar as funções do rvest para obter dados de texto e atributos do HTML e levá-los para o R. Em seguida, discutiremos algumas técnicas para descobrir qual seletor CSS você precisa para a página que está raspando, antes de finalizar com alguns estudos de caso e uma breve discussão sobre sites dinâmicos.
"

#----24.1.1 Pré-requisitos----
"
Agora, nos concentraremos nas ferramentas fornecidas pelo rvest. O rvest é um membro do tidyverse, mas não é um membro central, então você precisará carregá-lo explicitamente. Também carregaremos o tidyverse completo, pois ele será geralmente útil para trabalhar com os dados que raspamos.
"
library(tidyverse)
library(rvest)

#----24.2 Ética e Legalidades da Raspagem de Dados----
"
Antes de começarmos a discutir o código que você precisará para realizar a web scraping, precisamos falar sobre se é legal e ético fazê-lo. No geral, a situação é complicada em relação a ambos os aspectos.

As legalidades dependem muito de onde você mora. No entanto, como princípio geral, se os dados são públicos, não pessoais e factuais, é provável que você esteja ok. Esses três fatores são importantes porque estão conectados aos termos e condições do site, informações pessoalmente identificáveis e direitos autorais, como discutiremos a seguir.

Se os dados não são públicos, não pessoais ou factuais, ou se você está raspando os dados especificamente para ganhar dinheiro com eles, você precisará conversar com um advogado. Em qualquer caso, você deve ser respeitoso com os recursos do servidor que hospeda as páginas que você está raspando. O mais importante é que, se você está raspando muitas páginas, deve ter certeza de esperar um pouco entre cada solicitação. Uma maneira fácil de fazer isso é usar o pacote polite de Dmytro Perepolkin. Ele pausará automaticamente entre as solicitações e armazenará em cache os resultados, então você nunca pedirá a mesma página duas vezes.
"

#----24.2.1 Termos de Serviço----
"
Se você olhar atentamente, encontrará muitos sites que incluem um link de 'termos e condições' ou 'termos de serviço' em algum lugar da página, e se você ler essa página atentamente, muitas vezes descobrirá que o site proíbe especificamente a web scraping. Essas páginas tendem a ser uma apropriação legal onde as empresas fazem reivindicações muito amplas. É educado respeitar esses termos de serviço quando possível, mas leve em consideração qualquer afirmação com um grão de sal.

Os tribunais dos EUA geralmente concluíram que simplesmente colocar os termos de serviço no rodapé do site não é suficiente para você ser vinculado a eles, por exemplo, HiQ Labs v. LinkedIn. Geralmente, para estar vinculado aos termos de serviço, você deve ter tomado alguma ação explícita, como criar uma conta ou marcar uma caixa. É por isso que é importante saber se os dados são públicos ou não; se você não precisa de uma conta para acessá-los, é improvável que você esteja vinculado aos termos de serviço. No entanto, observe que a situação é bastante diferente na Europa, onde os tribunais consideraram que os termos de serviço são aplicáveis mesmo se você não concordar explicitamente com eles.
"

#----24.2.2 Informações Pessoalmente Identificáveis----
"
Mesmo que os dados sejam públicos, você deve ter extremo cuidado ao raspar informações pessoalmente identificáveis, como nomes, endereços de e-mail, números de telefone, datas de nascimento, etc. A Europa tem leis particularmente rigorosas sobre a coleta ou armazenamento desses dados (GDPR) e, independentemente de onde você mora, é provável que esteja entrando em um atoleiro ético. Por exemplo, em 2016, um grupo de pesquisadores raspou informações de perfil público (por exemplo, nomes de usuário, idade, gênero, localização, etc.) de cerca de 70.000 pessoas no site de namoro OkCupid e eles divulgaram publicamente esses dados sem qualquer tentativa de anonimização. Embora os pesquisadores acreditassem que não havia nada de errado nisso, já que os dados já eram públicos, esse trabalho foi amplamente condenado devido a preocupações éticas sobre a identificabilidade dos usuários cujas informações foram divulgadas no conjunto de dados. Se o seu trabalho envolve raspar informações pessoalmente identificáveis, recomendamos fortemente a leitura sobre o estudo do OkCupid, bem como estudos semelhantes com ética de pesquisa questionável envolvendo a aquisição e divulgação de informações pessoalmente identificáveis.
"

#----24.2.3 Direitos Autorais----
"
Finalmente, você também precisa se preocupar com a lei de direitos autorais. A lei de direitos autorais é complicada, mas vale a pena dar uma olhada na lei dos EUA, que descreve exatamente o que está protegido: '[...] obras originais de autoria fixadas em qualquer meio tangível de expressão, [...]'. Em seguida, descreve categorias específicas às quais se aplica, como obras literárias, obras musicais, filmes e mais. Notavelmente ausentes da proteção de direitos autorais estão os dados. Isso significa que, desde que você limite sua raspagem a fatos, a proteção de direitos autorais não se aplica. (Mas observe que a Europa tem um direito 'sui generis' separado que protege bancos de dados.)

Como um breve exemplo, nos EUA, listas de ingredientes e instruções não são protegidas por direitos autorais, então direitos autorais não podem ser usados para proteger uma receita. Mas se essa lista de receitas for acompanhada por um conteúdo literário substancial e original, isso é protegido por direitos autorais. É por isso que, quando você está procurando uma receita na internet, sempre há tanto conteúdo antes.

Se você precisar raspar conteúdo original (como texto ou imagens), ainda pode estar protegido pela doutrina do uso justo. O uso justo não é uma regra rígida e rápida, mas considera uma série de fatores. É mais provável que se aplique se você estiver coletando os dados para fins de pesquisa ou não comerciais e se limitar o que você raspa apenas ao que precisa.
"

#----24.3 Noções Básicas de HTML----
"
To scrape webpages, you need to first understand a little bit about HTML, the language that describes web pages. HTML stands for HyperText Markup Language and looks something like this:
"

"
<html>
<head>
  <title>Page title</title>
</head>
<body>
  <h1 id='first'>A heading</h1>
  <p>Some text &amp; <b>some bold text.</b></p>
  <img src='myimg.png' width='100' height='100'>
</body>
"

"
O HTML possui uma estrutura hierárquica formada por elementos que consistem em uma tag de início (por exemplo, <tag>), atributos opcionais (id='first'), uma tag de fim4 (como </tag>) e conteúdo (tudo entre a tag de início e de fim).

Como < e > são usados para tags de início e fim, você não pode escrevê-los diretamente. Em vez disso, você deve usar os escapes HTML &gt; (maior que) e &lt; (menor que). E como esses escapes usam &, se você quiser um e comercial literal, você deve escapá-lo como &amp;. Há uma ampla gama de escapes HTML possíveis, mas você não precisa se preocupar muito com eles porque o rvest os trata automaticamente para você.

A raspagem de dados é possível porque a maioria das páginas que contêm dados que você deseja raspar geralmente têm uma estrutura consistente.
"

#----24.3.1 Elementos----
"
Existem mais de 100 elementos HTML. Alguns dos mais importantes são:  
"
#1º Toda página HTML deve estar em um elemento <html>, e deve ter dois filhos: <head>, que contém metadados do documento, como o título da página, e <body>, que contém o conteúdo que você vê no navegador.
#2º Tags de bloco como <h1> (cabeçalho 1), <section> (seção), <p> (parágrafo) e <ol> (lista ordenada) formam a estrutura geral da página.
#3º Tags inline como <b> (negrito), <i> (itálico) e <a> (link) formatam o texto dentro das tags de bloco.

"
Se você encontrar uma tag que nunca viu antes, pode descobrir o que ela faz com uma rápida pesquisa no Google. Outro bom lugar para começar são os MDN Web Docs, que descrevem praticamente todos os aspectos da programação web.

A maioria dos elementos pode ter conteúdo entre suas tags de início e fim. Esse conteúdo pode ser texto ou mais elementos. Por exemplo, o HTML a seguir contém um parágrafo de texto, com uma palavra em negrito:
"

"
<p>
  Hi! My <b>name</b> is Hadley.
</p>
"

"
Os filhos são os elementos que ele contém, então o elemento <p> acima tem um filho, o elemento <b>. O elemento <b> não tem filhos, mas tem conteúdos (o texto 'name').
"

#----24.3.2 Atributos----
"
As tags podem ter atributos nomeados que se parecem com name1='value1' name2='value2'. Dois dos atributos mais importantes são id e class, que são usados em conjunto com CSS (Cascading Style Sheets) para controlar a aparência visual da página. Eles são frequentemente úteis ao raspar dados de uma página. Os atributos também são usados para registrar o destino de links (o atributo href de elementos <a>) e a fonte de imagens (o atributo src do elemento <img>).
"

#----24.4 Extração de Dados----
"
Para começar o scraping, você precisará do URL da página que deseja raspar, que geralmente pode copiar do seu navegador web. Em seguida, você precisará ler o HTML dessa página no R com read_html(). Isso retorna um objeto xml_document5 que você manipulará usando as funções do rvest:
"
html <- read_html("http://rvest.tidyverse.org/")
html

"
O rvest também inclui uma função que permite escrever HTML inline. Usaremos isso bastante por agora enquanto ensinamos como as várias funções do rvest funcionam com exemplos simples.
"
html <- minimal_html("
  <p>This is a paragraph</p>
  <ul>
    <li>This is a bulleted list</li>
  </ul>
")
html

"
Agora que você tem o HTML no R, é hora de extrair os dados de interesse. Você aprenderá primeiro sobre os seletores CSS que permitem identificar os elementos de interesse e as funções rvest que você pode usar para extrair dados deles. Em seguida, abordaremos brevemente as tabelas HTML, que possuem algumas ferramentas especiais.
"

#----24.4.1 Encontrar Elementos----
"
CSS é a abreviação de cascading style sheets (folhas de estilo em cascata) e é uma ferramenta para definir o estilo visual de documentos HTML. O CSS inclui uma linguagem miniatura para selecionar elementos em uma página chamada seletores CSS. Os seletores CSS definem padrões para localizar elementos HTML e são úteis para a raspagem de dados porque fornecem uma maneira concisa de descrever quais elementos você deseja extrair.

Voltaremos aos seletores CSS com mais detalhes na Seção 24.5, mas felizmente você pode avançar bastante com apenas três:
"
#1º 'p' seleciona todos os elementos <p>.
#2º '.title' seleciona todos os elementos com a classe "title".
#3º '#title' seleciona o elemento com o atributo id igual a "title". Os atributos de id devem ser únicos dentro de um documento, então isso sempre selecionará um único elemento.

"
Vamos testar esses seletores com um exemplo simples:
"
html <- minimal_html("
  <h1>This is a heading</h1>
  <p id='first'>This is a paragraph</p>
  <p class='important'>This is an important paragraph</p>
")
html

"
Use html_elements() para encontrar todos os elementos que correspondem ao seletor:
"
html |> html_elements("p")
html |> html_elements(".important")
html |> html_elements("#first")

"
Outra função importante é html_element(), que sempre retorna o mesmo número de saídas que as entradas. Se você aplicá-la a um documento inteiro, ela fornecerá a primeira correspondência:
"
html |> html_element("p")

"
Há uma diferença importante entre html_element() e html_elements() quando você usa um seletor que não corresponde a nenhum elemento. html_elements() retorna um vetor de comprimento 0, enquanto html_element() retorna um valor ausente. Isso será importante em breve.
"
html |> html_elements("b")
html |> html_element("b")

#----24.4.2 Seleções Aninhadas----
"

Na maioria dos casos, você usará html_elements() e html_element() juntos, normalmente usando html_elements() para identificar elementos que se tornarão observações e então usando html_element() para encontrar elementos que se tornarão variáveis. Vamos ver isso em ação usando um exemplo simples. Aqui temos uma lista não ordenada (<ul>) onde cada item da lista (<li>) contém algumas informações sobre quatro personagens de StarWars:
"
html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
  ")
html

"
Podemos usar html_elements() para criar um vetor onde cada elemento corresponde a um personagem diferente:
"
characters <- html |> html_elements("li")
characters

"
Para extrair o nome de cada personagem, usamos html_element(), pois quando aplicado à saída de html_elements() ele garante uma resposta por elemento:
"
characters |> html_element("b")

"
A distinção entre html_element() e html_elements() não é importante para o nome, mas é importante para o peso. Queremos obter um peso para cada personagem, mesmo se não houver um <span> de peso. Isso é o que html_element() faz:
"
characters |> html_element(".weight")

"
html_elements() encontra todos os <span> de peso que são filhos de personagens. Há apenas três desses, então perdemos a conexão entre nomes e pesos:
"
characters |> html_elements(".weight")

"
Agora que você selecionou os elementos de interesse, precisará extrair os dados, seja do conteúdo do texto ou de alguns atributos.
"

#----24.4.3 Texto e Atributos----
"
html_text2() extrai o conteúdo de texto simples de um elemento HTML:
"
characters |> 
  html_element("b") |> 
  html_text2()

characters |> 
  html_element(".weight") |> 
  html_text2()

"
Observe que qualquer escape será automaticamente tratado; você só verá escapes HTML no HTML fonte, não nos dados retornados pelo rvest.

html_attr() extrai dados de atributos:
"

html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")

html |> 
  html_elements("p") |> 
  html_element("a") |> 
  html_attr("href")

"
html_attr() sempre retorna uma string, então, se você estiver extraindo números ou datas, precisará fazer algum pós-processamento.
"

#----24.4.4 Tabelas----
"
Se você tiver sorte, seus dados já estarão armazenados em uma tabela HTML, e será apenas uma questão de lê-los dessa tabela. Geralmente é fácil reconhecer uma tabela no seu navegador: ela terá uma estrutura retangular de linhas e colunas, e você poderá copiar e colar em uma ferramenta como o Excel.

As tabelas HTML são construídas a partir de quatro elementos principais: <table>, <tr> (linha da tabela), <th> (cabeçalho da tabela) e <td> (dados da tabela). Aqui está uma tabela HTML simples com duas colunas e três linhas:
"
html <- minimal_html("
  <table class='mytable'>
    <tr><th>x</th>   <th>y</th></tr>
    <tr><td>1.5</td> <td>2.7</td></tr>
    <tr><td>4.9</td> <td>1.3</td></tr>
    <tr><td>7.2</td> <td>8.1</td></tr>
  </table>
  ")

"
O rvest fornece uma função que sabe como ler esse tipo de dados: html_table(). Ela retorna uma lista contendo um tibble para cada tabela encontrada na página. Use html_element() para identificar a tabela que você deseja extrair:
"

html |> 
  html_element(".mytable") |> 
  html_table()

"
Observe que x e y foram automaticamente convertidos para números. Essa conversão automática nem sempre funciona, então, em cenários mais complexos, você pode querer desativá-la com convert = FALSE e depois fazer sua própria conversão.
"

#----24.5 Encontrando os Seletores Certos----
"
Descobrir o seletor de que você precisa para seus dados é normalmente a parte mais difícil do problema. Você geralmente precisará fazer alguns experimentos para encontrar um seletor que seja específico (ou seja, que não selecione coisas que você não se importa) e sensível (ou seja, que selecione tudo que você se importa). Muitas tentativas e erros são uma parte normal do processo! Há duas ferramentas principais disponíveis para ajudá-lo neste processo: o SelectorGadget e as ferramentas de desenvolvedor do seu navegador.

O SelectorGadget é um bookmarklet em javascript que gera automaticamente seletores CSS com base em exemplos positivos e negativos que você fornece. Ele não sempre funciona, mas quando funciona, é mágico! Você pode aprender a instalar e usar o SelectorGadget lendo 
https://rvest.tidyverse.org/articles/selectorgadget.html ou assistindo ao vídeo de Mine em https://www.youtube.com/watch?v=PetWV5g1Xsc.

Todo navegador moderno vem com algum kit de ferramentas para desenvolvedores, mas recomendamos o Chrome, mesmo que não seja seu navegador regular: suas ferramentas de desenvolvedor web são algumas das melhores e estão imediatamente disponíveis. Clique com o botão direito em um elemento na página e clique em Inspecionar. Isso abrirá uma visualização expansível da página HTML completa, centrada no elemento que você acabou de clicar. Você pode usar isso para explorar a página e ter uma ideia do que os seletores podem funcionar. Preste atenção especial aos atributos de classe e id, pois eles são frequentemente usados para formar a estrutura visual da página e, portanto, são boas ferramentas para extrair os dados que você está procurando.

Dentro da visualização de Elementos, você também pode clicar com o botão direito em um elemento e escolher Copiar como seletor para gerar um seletor que identificará exclusivamente o elemento de interesse.

Se o SelectorGadget ou as Ferramentas de Desenvolvedor do Chrome geraram um seletor CSS que você não entende, tente Selectors Explained, que traduz seletores CSS para inglês claro. Se você se encontrar fazendo isso com frequência, pode querer aprender mais sobre seletores CSS em geral. Recomendamos começar com o divertido tutorial CSS dinner e, em seguida, consultar os documentos da web MDN.
"

#----24.6 Colocando Tudo Junto----
"
Vamos juntar tudo isso para raspar alguns sites. Há um risco de que esses exemplos possam não funcionar mais quando você executá-los — esse é o desafio fundamental da raspagem de dados da web; se a estrutura do site mudar, você terá que alterar seu código de raspagem.
"

#----24.6.1 StarWars----
"
O rvest inclui um exemplo muito simples na vinhetta('starwars'). Esta é uma página simples com HTML mínimo, então é um bom lugar para começar. Eu o encorajaria a navegar até essa página agora e usar 'Inspecionar Elemento' para inspecionar um dos títulos que é o título de um filme de Star Wars. Use o teclado ou o mouse para explorar a hierarquia do HTML e ver se você consegue entender a estrutura compartilhada usada por cada filme.

Você deve ser capaz de ver que cada filme tem uma estrutura compartilhada que se parece com isso:
"

#<section>
#  <h2 data-id="1">The Phantom Menace</h2>
#  <p>Released: 1999-05-19</p>
# <p>Director: <span class="director">George Lucas</span></p>

#  <div class="crawl">
#  <p>...</p>
#  <p>...</p>
#  <p>...</p>
#  </div>
#  </section>

"
Nosso objetivo é transformar esses dados em um data frame de 7 linhas com as variáveis title, year, director e intro. Começaremos lendo o HTML e extraindo todos os elementos <section>:
"
url <- "https://rvest.tidyverse.org/articles/starwars.html"
html <- read_html(url)

section <- html |> html_elements("section")
section

"
Isso recupera sete elementos correspondentes aos sete filmes encontrados naquela página, sugerindo que usar a seção como seletor é bom. Extrair os elementos individuais é direto, pois os dados sempre são encontrados no texto. É apenas uma questão de encontrar o seletor certo:
"
section |> html_element("h2") |> html_text2()

section |> html_element(".director") |> html_text2()

"
Depois de fazer isso para cada componente, podemos embrulhar todos os resultados em um tibble:
"
tibble(
  title = section |> 
    html_element("h2") |> 
    html_text2(),
  released = section |> 
    html_element("p") |> 
    html_text2() |> 
    str_remove("Released: ") |> 
    parse_date(),
  director = section |> 
    html_element(".director") |> 
    html_text2(),
  intro = section |> 
    html_element(".crawl") |> 
    html_text2()
)

"
Fizemos um pouco mais de processamento de 'released' para obter uma variável que será fácil de usar mais tarde em nossa análise.
"

#----24.6.2 Filmes Mais Votados do IMDB----
"
Esses dados têm uma estrutura claramente tabular, então vale a pena começar com html_table():
"
url <- "https://web.archive.org/web/20220201012049/https://www.imdb.com/chart/top/"
html <- read_html(url)

table <- html |> 
  html_element("table") |> 
  html_table()
table

"
Isso inclui algumas colunas vazias, mas no geral faz um bom trabalho ao capturar as informações da tabela. No entanto, precisamos fazer mais processamento para facilitar o uso. Primeiro, renomearemos as colunas para serem mais fáceis de trabalhar e removeremos os espaços em branco extras em rank e title. Faremos isso com select() (em vez de rename()) para fazer a renomeação e a seleção de apenas essas duas colunas em uma etapa. Em seguida, removeremos as novas linhas e espaços extras e aplicaremos separate_wider_regex() para separar o título, o ano e o rank em suas próprias variáveis.
"
ratings <- table |>
  select(
    rank_title_year = `Rank & Title`,
    rating = `IMDb Rating`
  ) |> 
  mutate(
    rank_title_year = str_replace_all(rank_title_year, "\n +", " ")
  ) |> 
  separate_wider_regex(
    rank_title_year,
    patterns = c(
      rank = "\\d+", "\\. ",
      title = ".+", " +\\(",
      year = "\\d+", "\\)"
    )
  )
ratings

"
Mesmo nesse caso, onde a maioria dos dados vem de células de tabela, ainda vale a pena olhar para o HTML bruto. Se você fizer isso, descobrirá que podemos adicionar um pouco mais de dados usando um dos atributos. Esta é uma das razões pelas quais vale a pena gastar um pouco de tempo explorando a fonte da página; você pode encontrar dados extras ou pode encontrar um caminho de análise que seja um pouco mais fácil.
"
html |> 
  html_elements("td strong") |> 
  head() |> 
  html_attr("title")

"
Podemos combinar isso com os dados tabulares e novamente aplicar separate_wider_regex() para extrair a parte dos dados que nos interessa:
"
ratings |>
  mutate(
    rating_n = html |> html_elements("td strong") |> html_attr("title")
  ) |> 
  separate_wider_regex(
    rating_n,
    patterns = c(
      "[0-9.]+ based on ",
      number = "[0-9,]+",
      " user ratings"
    )
  ) |> 
  mutate(
    number = parse_number(number)
  )

#----24.7 Sites Dinâmicos----
"
Até agora, nos concentramos em sites onde `html_elements()` retorna o que você vê no navegador e discutimos como analisar o que ele retorna e como organizar essas informações em data frames organizados. De vez em quando, no entanto, você encontrará um site onde `html_elements()` e amigos não retornam nada parecido com o que você vê no navegador. Em muitos casos, isso ocorre porque você está tentando raspar um site que gera dinamicamente o conteúdo da página com javascript. Isso atualmente não funciona com o rvest, porque o rvest baixa o HTML bruto e não executa nenhum javascript.

Ainda é possível raspar esses tipos de sites, mas o rvest precisa usar um processo mais caro: simular completamente o navegador da web, incluindo a execução de todo o javascript. Essa funcionalidade não está disponível no momento da escrita, mas é algo em que estamos trabalhando ativamente e pode estar disponível quando você ler isso. Ele usa o pacote chromote, que realmente executa o navegador Chrome em segundo plano e oferece ferramentas adicionais para interagir com o site, como um humano digitando texto e clicando em botões. Confira o site do rvest para mais detalhes.
"

#----Capítulo 25 : Funções----

#----25.1 Introdução----
"
Uma das melhores maneiras de melhorar seu alcance como cientista de dados é escrever funções. Funções permitem que você automatize tarefas comuns de uma maneira mais poderosa e geral do que copiar e colar. Escrever uma função tem quatro grandes vantagens sobre o uso de cópia e cola:
"
#1º Você pode dar um nome sugestivo à função que torna seu código mais fácil de entender.
#2º À medida que os requisitos mudam, você só precisa atualizar o código em um lugar, em vez de vários.
#3º Você elimina a chance de cometer erros incidentais ao copiar e colar (por exemplo, atualizar um nome de variável em um lugar, mas não em outro).
#4º Facilita a reutilização do trabalho de projeto para projeto, aumentando sua produtividade ao longo do tempo.

"
Uma boa regra é considerar escrever uma função sempre que você copiou e colou um bloco de código mais de duas vezes (ou seja, você agora tem três cópias do mesmo código). Neste capítulo, você aprenderá sobre três tipos úteis de funções:
"
#1º Funções vetoriais recebem um ou mais vetores como entrada e retornam um vetor como saída.
#2º Funções de data frame recebem um data frame como entrada e retornam um data frame como saída.
#3º Funções de plotagem que recebem um data frame como entrada e retornam um gráfico como saída.


"
Os tópicos mais afrente incluem muitos exemplos para ajudá-lo a generalizar os padrões que você vê.
"

#----25.1.1 Pré-requisitos----
"
Nós concluiremos uma variedade de funções de diferentes partes do tidyverse. Também usaremos nycflights13 como uma fonte de dados familiares para aplicar nossas funções.
"
library(tidyverse)
library(nycflights13)

#----25.2 Funções Vetoriais----
"
Começaremos com funções vetoriais: funções que recebem um ou mais vetores e retornam um resultado vetorial. Por exemplo, dê uma olhada neste código. O que ele faz?
"
df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5),
)

df |> mutate(
  a = (a - min(a, na.rm = TRUE)) / 
    (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)),
  b = (b - min(b, na.rm = TRUE)) / 
    (max(b, na.rm = TRUE) - min(a, na.rm = TRUE)),
  c = (c - min(c, na.rm = TRUE)) / 
    (max(c, na.rm = TRUE) - min(c, na.rm = TRUE)),
  d = (d - min(d, na.rm = TRUE)) / 
    (max(d, na.rm = TRUE) - min(d, na.rm = TRUE)),
)

"
Você pode ser capaz de deduzir que este código redimensiona cada coluna para ter uma escala de 0 a 1. Mas você percebeu o erro? Quando Hadley escreveu este código, ele cometeu um erro ao copiar e colar e esqueceu de mudar um 'a' para um 'b'. Prevenir esse tipo de erro é um motivo muito bom para aprender a escrever funções.
"

#----25.2.1 Escrevendo uma Função----
"
Para escrever uma função, você precisa primeiro analisar seu código repetido para descobrir quais partes são constantes e quais partes variam. Se pegarmos o código acima e retirá-lo de dentro de mutate(), fica um pouco mais fácil ver o padrão, pois cada repetição agora está em uma linha:
"
(a - min(a, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(a, na.rm = TRUE))
(b - min(b, na.rm = TRUE)) / (max(b, na.rm = TRUE) - min(b, na.rm = TRUE))
(c - min(c, na.rm = TRUE)) / (max(c, na.rm = TRUE) - min(c, na.rm = TRUE))
(d - min(d, na.rm = TRUE)) / (max(d, na.rm = TRUE) - min(d, na.rm = TRUE))  
"
Para tornar isso um pouco mais claro, podemos substituir a parte que varia por █:
"
#(█ - min(█, na.rm = TRUE)) / (max(█, na.rm = TRUE) - min(█, na.rm = TRUE))

"
Para transformar isso em uma função, você precisa de três coisas:
"

#1º Um nome. Aqui usaremos rescale01, pois esta função redimensiona um vetor para ficar entre 0 e 1.
#2º Os argumentos. Os argumentos são coisas que variam entre as chamadas, e nossa análise acima nos diz que temos apenas um. Chamaremos isso de x, pois este é o nome convencional para um vetor numérico.
#3º O corpo. O corpo é o código que é repetido em todas as chamadas.
"
Então você cria uma função seguindo o modelo:

name <- function(arguments) {
  body
}

Para este caso, isso leva a:
"
rescale01 <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

"
Neste ponto, você pode testar com algumas entradas simples para garantir que capturou a lógica corretamente:
"
rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))

"
Então, você pode reescrever a chamada para mutate() como:
"
df |> mutate(
  a = rescale01(a),
  b = rescale01(b),
  c = rescale01(c),
  d = rescale01(d),
)

"
Futuramente, você aprenderá a usar across() para reduzir ainda mais a duplicação, de modo que tudo o que você precisa é df |> mutate(across(a:d, rescale01))
"

#----25.2.2 Melhorando Nossa Função----
"
Você pode notar que a função rescale01() faz um trabalho desnecessário — em vez de calcular min() duas vezes e max() uma vez, poderíamos calcular o mínimo e o máximo em uma etapa com range():
"
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

"
Ou você pode tentar essa função em um vetor que inclui um valor infinito:
"
x <- c(1:10, Inf)
rescale01(x)

"
Esse resultado não é particularmente útil, então poderíamos pedir para range() ignorar valores infinitos:
"
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(x)

"
Essas mudanças ilustram um benefício importante das funções: como movemos o código repetido para uma função, só precisamos fazer a mudança em um lugar.
"

#----25.2.3 Funções de Mutação----
"
Agora que você entendeu a ideia básica das funções, vamos dar uma olhada em vários exemplos. Começaremos analisando as funções 'mutate', ou seja, funções que funcionam bem dentro de mutate() e filter() porque retornam uma saída do mesmo comprimento que a entrada.

Vamos começar com uma variação simples de rescale01(). Talvez você queira calcular o escore Z, redimensionando um vetor para ter uma média de zero e um desvio padrão de um:
"
z_score <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

"
Ou talvez você queira encapsular um caso simples de case_when() e dar a ele um nome útil. Por exemplo, esta função clamp() garante que todos os valores de um vetor estejam entre um mínimo ou um máximo:
"
clamp <- function(x, min, max) {
  case_when(
    x < min ~ min,
    x > max ~ max,
    .default = x
  )
}

clamp(1:10, min = 3, max = 7)

"
Claro que as funções não precisam trabalhar apenas com variáveis numéricas. Você pode querer fazer alguma manipulação de string repetida. Talvez você precise tornar a primeira letra maiúscula:
"
first_upper <- function(x) {
  str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
  x
}

first_upper("hello")

"
Ou talvez você queira remover sinais de porcentagem, vírgulas e cifrões de uma string antes de convertê-la em um número:
"
clean_number <- function(x) {
  is_pct <- str_detect(x, "%")
  num <- x |> 
    str_remove_all("%") |> 
    str_remove_all(",") |> 
    str_remove_all(fixed("$")) |> 
    as.numeric()
  if_else(is_pct, num / 100, num)
}

clean_number("$12,300")
clean_number("45%")

"
Às vezes, suas funções serão altamente especializadas para uma etapa de análise de dados. Por exemplo, se você tem um monte de variáveis que registram valores ausentes como 997, 998 ou 999, você pode querer escrever uma função para substituí-los por NA:
"
fix_na <- function(x) {
  if_else(x %in% c(997, 998, 999), NA, x)
}

"
Nós nos concentramos em exemplos que pegam um único vetor porque achamos que são os mais comuns. Mas não há razão para que sua função não possa receber múltiplas entradas vetoriais.
"

#----25.2.4 Funções de Resumo----
"
Outra família importante de funções vetoriais são as funções de resumo, que retornam um único valor para uso em summarize(). Às vezes, isso pode ser apenas uma questão de definir um ou dois argumentos padrão:
"
commas <- function(x) {
  str_flatten(x, collapse = ", ", last = " and ")
}

commas(c("cat", "dog", "pigeon"))

"
Ou você pode encapsular um cálculo simples, como para o coeficiente de variação, que divide o desvio padrão pela média:
"
cv <- function(x, na.rm = FALSE) {
  sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}

cv(runif(100, min = 0, max = 50))
cv(runif(100, min = 0, max = 500))

"
Ou talvez você queira tornar um padrão comum mais fácil de lembrar, dando a ele um nome memorável:
"
n_missing <- function(x) {
  sum(is.na(x))
} 

"
Você também pode escrever funções com múltiplas entradas vetoriais. Por exemplo, talvez você queira calcular o erro percentual médio absoluto para ajudá-lo a comparar previsões de modelos com valores reais:
"
mape <- function(actual, predicted) {
  sum(abs((actual - predicted) / actual)) / length(actual)
}

"
RStudio
Uma vez que você começa a escrever funções, existem dois atalhos no RStudio que são super úteis:

  # Para encontrar a definição de uma função que você escreveu, coloque o cursor sobre o nome da função e pressione F2.

  # Para acessar rapidamente uma função, pressione 'Ctrl + .' para abrir o localizador de arquivos e funções e digite as primeiras letras do nome da sua função. Você também pode navegar até arquivos, seções do Quarto e mais, tornando-o uma ferramenta de navegação muito útil.
"


#----25.3 Funções de DataFrames----
"
Funções vetoriais são úteis para extrair código que é repetido dentro de um verbo dplyr. Mas você também frequentemente repetirá os próprios verbos, especialmente dentro de um grande pipeline. Quando você se pegar copiando e colando múltiplos verbos várias vezes, você pode pensar em escrever uma função de data frame. Funções de data frame funcionam como verbos dplyr: elas tomam um data frame como primeiro argumento, alguns argumentos extras que dizem o que fazer com ele e retornam um data frame ou um vetor.

Para permitir que você escreva uma função que usa verbos dplyr, primeiro vamos introduzi-lo ao desafio da indireção e como você pode superá-lo com o conceito de 'embracing', {{ }}. Com essa teoria em mente, então mostraremos uma série de exemplos para ilustrar o que você pode fazer com isso.
"


#----25.3.1 Indireção e Avaliação Tidy----
"
Quando você começa a escrever funções que usam funções dplyr, rapidamente se depara com o problema da indireção. Vamos ilustrar o problema com uma função muito simples: grouped_mean(). O objetivo desta função é calcular a média de mean_var agrupada por group_var:
"
grouped_mean <- function(df, group_var, mean_var) {
  df |> 
    group_by(group_var) |> 
    summarize(mean(mean_var))
}

"
Se tentarmos usá-la, recebemos um erro:
"
diamonds |> grouped_mean(cut, carat)

"
Para tornar o problema um pouco mais claro, podemos usar um data frame fictício:
"
df <- tibble(
  mean_var = 1,
  group_var = "g",
  group = 1,
  x = 10,
  y = 100
)

df |> grouped_mean(group, x)
df |> grouped_mean(group, y)

"
Independentemente de como chamamos grouped_mean(), ela sempre executa df |> group_by(group_var) |> summarize(mean(mean_var)), em vez de df |> group_by(group) |> summarize(mean(x)) ou df |> group_by(group) |> summarize(mean(y)). Este é um problema de indireção e surge porque o dplyr usa avaliação arrumada (tidy evaluation) para permitir que você se refira aos nomes das variáveis dentro do seu data frame sem nenhum tratamento especial.

A avaliação arrumada é ótima 95% do tempo porque torna suas análises de dados muito concisas, pois você nunca precisa dizer de qual data frame uma variável vem; isso é óbvio pelo contexto. A desvantagem da avaliação arrumada surge quando queremos encapsular código repetido do tidyverse em uma função. Aqui precisamos de alguma forma de dizer a group_by() e summarize() para não tratar group_var e mean_var como o nome das variáveis, mas sim olhar dentro delas para a variável que realmente queremos usar.

A avaliação arrumada inclui uma solução para esse problema chamada 'embracing' 🤗. Abraçar uma variável significa envolvê-la em chaves, então (por exemplo) var se torna {{ var }}. Abraçar uma variável diz ao dplyr para usar o valor armazenado dentro do argumento, não o argumento como o nome literal da variável. Uma maneira de lembrar o que está acontecendo é pensar em {{ }} como olhando por um túnel — {{ var }} fará uma função dplyr olhar dentro de var em vez de procurar uma variável chamada var.

Então, para fazer grouped_mean() funcionar, precisamos cercar group_var e mean_var com {{ }}:
"
grouped_mean <- function(df, group_var, mean_var) {
  df |> 
    group_by({{ group_var }}) |> 
    summarize(mean({{ mean_var }}))
}

df |> grouped_mean(group, x)

"
Sucesso!
"

#----25.3.2 Quando Abraçar?----
"
Portanto, o principal desafio ao escrever funções de data frame é descobrir quais argumentos precisam ser 'embraced' (abraçados). Felizmente, isso é fácil porque você pode consultar a documentação 😄. Há dois termos para procurar nos documentos que correspondem aos dois subtipos mais comuns de avaliação arrumada (tidy evaluation):
"
#1º Data-masking (mascaramento de dados): é usado em funções como arrange(), filter() e summarize() que calculam com variáveis.
#2º Data-masking (mascaramento de dados): é usado em funções como arrange(), filter() e summarize() que calculam com variáveis.

"
Sua intuição sobre quais argumentos usam avaliação arrumada deve ser boa para muitas funções comuns — basta pensar se você pode calcular (por exemplo, x + 1) ou selecionar (por exemplo, a:x).

Nas próximas seções, exploraremos os tipos de funções úteis que você pode escrever uma vez que entenda o conceito de 'embracing'.
"

#----25.3.3 Casos de Uso Comuns----
"
Se você comumente realiza o mesmo conjunto de resumos ao fazer a exploração inicial de dados, pode considerar agrupá-los em uma função auxiliar:
"
summary6 <- function(data, var) {
  data |> summarize(
    min = min({{ var }}, na.rm = TRUE),
    mean = mean({{ var }}, na.rm = TRUE),
    median = median({{ var }}, na.rm = TRUE),
    max = max({{ var }}, na.rm = TRUE),
    n = n(),
    n_miss = sum(is.na({{ var }})),
    .groups = "drop"
  )
}

diamonds |> summary6(carat)

"
Sempre que você encapsula summarize() em um auxiliar, achamos que é uma boa prática definir .groups = 'drop' para evitar a mensagem e deixar os dados em um estado não agrupado.

O bom dessa função é que, como ela encapsula summarize(), você pode usá-la em dados agrupados:
"
diamonds |> 
  group_by(cut) |> 
  summary6(carat)

"
Além disso, como os argumentos para summarize são de mascaramento de dados, isso também significa que o argumento var para summary6() é de mascaramento de dados. Isso significa que você também pode resumir variáveis calculadas:
"
diamonds |> 
  group_by(cut) |> 
  summary6(log10(carat))

"
Para resumir múltiplas variáveis, você precisará esperar um pouco, onde aprenderá a usar across().

Outra função auxiliar popular de summarize() é uma versão de count() que também calcula proporções:
"
count_prop <- function(df, var, sort = FALSE) {
  df |>
    count({{ var }}, sort = sort) |>
    mutate(prop = n / sum(n))
}

diamonds |> count_prop(clarity)

"
Esta função tem três argumentos: df, var e sort, e apenas var precisa ser abraçado porque é passado para count(), que usa mascaramento de dados para todas as variáveis. Observe que usamos um valor padrão para sort, de modo que, se o usuário não fornecer seu próprio valor, ele será definido como FALSE por padrão.

Ou talvez você queira encontrar os valores únicos ordenados de uma variável para um subconjunto dos dados. Em vez de fornecer uma variável e um valor para fazer o filtro, permitiremos que o usuário forneça uma condição:
"
unique_where <- function(df, condition, var) {
  df |> 
    filter({{ condition }}) |> 
    distinct({{ var }}) |> 
    arrange({{ var }})
}

# Encontre todos os destinos em dezembro.
flights |> unique_where(month == 12, dest)

"
Aqui abraçamos condition porque é passado para filter() e var porque é passado para distinct() e arrange().

Fizemos todos esses exemplos para receber um data frame como primeiro argumento, mas se você está trabalhando repetidamente com os mesmos dados, pode fazer sentido codificá-los diretamente. Por exemplo, a função a seguir sempre trabalha com o conjunto de dados flights e sempre seleciona time_hour, carrier e flight, já que eles formam a chave primária composta que permite identificar uma linha.
"
subset_flights <- function(rows, cols) {
  flights |> 
    filter({{ rows }}) |> 
    select(time_hour, carrier, flight, {{ cols }})
}

#----25.3.4 Mascaramento de Dados vs. Seleção Tidy----
"
Às vezes você quer selecionar variáveis dentro de uma função que usa mascaramento de dados. Por exemplo, imagine que você quer escrever uma count_missing() que conta o número de observações ausentes em linhas. Você pode tentar escrever algo como:
"
count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by({{ group_vars }}) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}

flights |> 
  count_missing(c(year, month, day), dep_time)

"
Isso não funciona porque group_by() usa mascaramento de dados, não seleção arrumada. Podemos contornar esse problema usando a função útil pick(), que permite usar seleção arrumada dentro de funções de mascaramento de dados:
"
count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by(pick({{ group_vars }})) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}

flights |> 
  count_missing(c(year, month, day), dep_time)

"
Outro uso conveniente de pick() é fazer uma tabela 2D de contagens. Aqui contamos usando todas as variáveis nas linhas e colunas, e depois usamos pivot_wider() para rearranjar as contagens em uma grade:
"
count_wide <- function(data, rows, cols) {
  data |> 
    count(pick(c({{ rows }}, {{ cols }}))) |> 
    pivot_wider(
      names_from = {{ cols }}, 
      values_from = n,
      names_sort = TRUE,
      values_fill = 0
    )
}

diamonds |> count_wide(c(clarity, color), cut)

"
Embora nossos exemplos tenham se concentrado principalmente no dplyr, a avaliação arrumada também sustenta o tidyr, e se você olhar os documentos de pivot_wider() pode ver que names_from usa seleção arrumada.
"

#----25.4 Funções de Gráficos----
"
Em vez de retornar um data frame, você pode querer retornar um gráfico. Felizmente, você pode usar as mesmas técnicas com o ggplot2, porque aes() é uma função de mascaramento de dados. Por exemplo, imagine que você está fazendo muitos histogramas:
"
diamonds |> 
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

diamonds |> 
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.05)

"
Não seria bom se você pudesse encapsular isso em uma função de histograma? Isso é fácil como um passeio no parque uma vez que você sabe que aes() é uma função de mascaramento de dados e você precisa abraçar:
"
histogram <- function(df, var, binwidth = NULL) {
  df |> 
    ggplot(aes(x = {{ var }})) + 
    geom_histogram(binwidth = binwidth)
}

diamonds |> histogram(carat, 0.1)

"
Note que histogram() retorna um gráfico ggplot2, o que significa que você ainda pode adicionar componentes adicionais se quiser. Apenas lembre-se de trocar de |> para +:
"
diamonds |> 
  histogram(carat, 0.1) +
  labs(x = "Size (in carats)", y = "Number of diamonds")

#----25.4.1 Mais Variáveis----
"
É simples adicionar mais variáveis à mistura. Por exemplo, talvez você queira uma maneira fácil de avaliar visualmente se um conjunto de dados é linear ou não, sobrepondo uma linha suave e uma linha reta:
"
linearity_check <- function(df, x, y) {
  df |>
    ggplot(aes(x = {{ x }}, y = {{ y }})) +
    geom_point() +
    geom_smooth(method = "loess", formula = y ~ x, color = "red", se = FALSE) +
    geom_smooth(method = "lm", formula = y ~ x, color = "blue", se = FALSE) 
}

starwars |> 
  filter(mass < 1000) |> 
  linearity_check(mass, height)

"
Ou talvez você queira uma alternativa para gráficos de dispersão coloridos para conjuntos de dados muito grandes onde a sobreposição é um problema:
"
hex_plot <- function(df, x, y, z, bins = 20, fun = "mean") {
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }}, z = {{ z }})) + 
    stat_summary_hex(
      aes(color = after_scale(fill)), # make border same color as fill
      bins = bins, 
      fun = fun,
    )
}

diamonds |> hex_plot(carat, price, depth)

#----25.4.2 Combinando com Outros Tidyverse----
"
Algumas das ajudas mais úteis combinam um pouco de manipulação de dados com o ggplot2. Por exemplo, se você quiser fazer um gráfico de barras vertical onde automaticamente ordena as barras em ordem de frequência usando fct_infreq(). Como o gráfico de barras é vertical, também precisamos reverter a ordem usual para obter os valores mais altos no topo:
"
sorted_bars <- function(df, var) {
  df |> 
    mutate({{ var }} := fct_rev(fct_infreq({{ var }})))  |>
    ggplot(aes(y = {{ var }})) +
    geom_bar()
}

diamonds |> sorted_bars(clarity)

"
Temos que usar um novo operador aqui, := (comumente referido como o 'operador morsa'), porque estamos gerando o nome da variável com base em dados fornecidos pelo usuário. Nomes de variáveis vão à esquerda do =, mas a sintaxe do R não permite nada à esquerda do =, exceto por um único nome literal. Para contornar esse problema, usamos o operador especial := que a avaliação arrumada trata exatamente da mesma maneira que =.

Ou talvez você queira facilitar o desenho de um gráfico de barras apenas para um subconjunto dos dados:
"
conditional_bars <- function(df, condition, var) {
  df |> 
    filter({{ condition }}) |> 
    ggplot(aes(x = {{ var }})) + 
    geom_bar()
}

diamonds |> conditional_bars(cut == "Good", clarity)

"
Você também pode ser criativo e exibir resumos de dados de outras maneiras. Você pode encontrar uma aplicação legal em 
https://gist.github.com/GShotwell/b19ef520b6d56f61a830fabb3454965b; ela usa os rótulos dos eixos para exibir o valor mais alto. À medida que você aprende mais sobre o ggplot2, o poder das suas funções continuará aumentando.

Vamos terminar com um caso mais complicado: rotulando os gráficos que você cria.
"

#----25.4.3 Rotulagem----
"
Lembra da função de histograma que mostramos anteriormente?
"
histogram <- function(df, var, binwidth = NULL) {
  df |> 
    ggplot(aes(x = {{ var }})) + 
    geom_histogram(binwidth = binwidth)
}

"
Não seria bom se pudéssemos rotular a saída com a variável e a largura do intervalo que foi usada? Para fazer isso, vamos ter que explorar os bastidores da avaliação arrumada e usar uma função de um pacote sobre o qual ainda não falamos: rlang. Rlang é um pacote de baixo nível que é usado por praticamente todos os outros pacotes no tidyverse porque implementa a avaliação arrumada (além de muitas outras ferramentas úteis).

Para resolver o problema de rotulagem, podemos usar rlang::englue(). Isso funciona de maneira semelhante a str_glue(), então qualquer valor envolvido em {} será inserido na string. Mas ele também entende {{}}, que automaticamente insere o nome da variável apropriado:
"
histogram <- function(df, var, binwidth) {
  label <- rlang::englue("A histogram of {{var}} with binwidth {binwidth}")
  
  df |> 
    ggplot(aes(x = {{ var }})) + 
    geom_histogram(binwidth = binwidth) + 
    labs(title = label)
}

diamonds |> histogram(carat, 0.1)

"
Você pode usar a mesma abordagem em qualquer outro lugar onde deseja fornecer uma string em um gráfico ggplot2.
"

#----25.5 Estilo----
"
O R não se importa com o nome da sua função ou argumentos, mas os nomes fazem uma grande diferença para os humanos. Idealmente, o nome da sua função será curto, mas claramente evocará o que a função faz. Isso é difícil! Mas é melhor ser claro do que curto, já que o autocomplete do RStudio facilita digitar nomes longos.

Geralmente, os nomes das funções devem ser verbos, e os argumentos devem ser substantivos. Há algumas exceções: substantivos são aceitáveis se a função calcular um substantivo muito conhecido (ou seja, mean() é melhor do que compute_mean()), ou acessar alguma propriedade de um objeto (ou seja, coef() é melhor do que get_coefficients()). Use seu melhor julgamento e não tenha medo de renomear uma função se você descobrir um nome melhor mais tarde.
"
# Muito curta
f()

# Sem função, ou descrição
my_awesome_function()

# Longa, mas clara
impute_missing()
collapse_years()

"
O R também não se importa com a forma como você usa espaços em branco em suas funções, mas os leitores futuros se importarão. Continue seguindo as regras vistas anteriormente. Além disso, function() deve sempre ser seguido por chaves ({}), e o conteúdo deve ser indentado por dois espaços adicionais. Isso facilita ver a hierarquia no seu código ao olhar rapidamente para a margem esquerda.
"
# Missing extra two spaces
density <- function(color, facets, binwidth = 0.1) {
  diamonds |> 
    ggplot(aes(x = carat, y = after_stat(density), color = {{ color }})) +
    geom_freqpoly(binwidth = binwidth) +
    facet_wrap(vars({{ facets }}))
}

# Pipe indented incorrectly
density <- function(color, facets, binwidth = 0.1) {
  diamonds |> 
    ggplot(aes(x = carat, y = after_stat(density), color = {{ color }})) +
    geom_freqpoly(binwidth = binwidth) +
    facet_wrap(vars({{ facets }}))
}

"
Como você pode ver, recomendamos colocar espaços extras dentro de {{ }}. Isso torna muito óbvio que algo incomum está acontecendo.
"

#----Capítulo 26 : Iteração----

#----26.1 Introdução----
"
Agora você aprenderá ferramentas para iteração, realizando repetidamente a mesma ação em diferentes objetos. A iteração em R geralmente tende a parecer bastante diferente de outras linguagens de programação porque grande parte dela é implícita e obtemos de graça. Por exemplo, se você quiser dobrar um vetor numérico x em R, você pode simplesmente escrever 2 * x. Na maioria das outras linguagens, você precisaria dobrar explicitamente cada elemento de x usando algum tipo de loop for.

Este livro já lhe deu um pequeno, mas poderoso número de ferramentas que realizam a mesma ação para múltiplas 'coisas':
"
#1º facet_wrap() e facet_grid() desenham um gráfico para cada subconjunto.
#2º group_by() mais summarize() calculam estatísticas resumidas para cada subconjunto. 
#3º unnest_wider() e unnest_longer() criam novas linhas e colunas para cada elemento de uma coluna-lista.

"
Agora é hora de aprender algumas ferramentas mais gerais, frequentemente chamadas de ferramentas de programação funcional, porque são construídas em torno de funções que recebem outras funções como entradas. Aprender programação funcional pode facilmente se desviar para o abstrato, mas neste capítulo manteremos as coisas concretas, focando em três tarefas comuns: modificar múltiplas colunas, ler múltiplos arquivos e salvar múltiplos objetos.
"

#----26.1.1 Pré-requisitos----
"
Aqui nos concentraremos em ferramentas fornecidas pelo dplyr e purrr, ambos membros centrais do tidyverse. Você já viu o dplyr antes, mas o purrr é novidade. Vamos usar apenas algumas funções do purrr neste capítulo, mas é um ótimo pacote para explorar à medida que você aprimora suas habilidades de programação.
"
library(tidyverse)

#----26.2 Modificando múltiplas colunas----
"
Imagine que você tem este simples tibble e quer contar o número de observações e calcular a mediana de cada coluna.
"
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

"
Você poderia fazer isso com copiar e colar:
"
df |> summarize(
  n = n(),
  a = median(a),
  b = median(b),
  c = median(c),
  d = median(d),
)

"
Isso quebra nossa regra de nunca copiar e colar mais de duas vezes, e você pode imaginar que isso se tornará muito tedioso se você tiver dezenas ou até centenas de colunas. Em vez disso, você pode usar across():
"
df |> summarize(
  n = n(),
  across(a:d, median),
)

"
across() tem três argumentos particularmente importantes, que discutiremos em detalhes nas próximas seções. Você usará os dois primeiros sempre que usar across(): o primeiro argumento, .cols, especifica quais colunas você quer iterar, e o segundo argumento, .fns, especifica o que fazer com cada coluna. Você pode usar o argumento .names quando precisar de controle adicional sobre os nomes das colunas de saída, o que é particularmente importante quando você usa across() com mutate(). Também discutiremos duas variações importantes, if_any() e if_all(), que funcionam com filter().
"

#----26.2.1 Selecionando colunas com .cols----
"
O primeiro argumento para across(), .cols, seleciona as colunas a serem transformadas. Isso usa as mesmas especificações que select(), Seção 3.3.2, então você pode usar funções como starts_with() e ends_with() para selecionar colunas baseadas em seus nomes.

Há duas técnicas adicionais de seleção que são particularmente úteis para across(): everything() e where(). everything() é direto: seleciona todas as colunas (não agrupadas):
"
df <- tibble(
  grp = sample(2, 10, replace = TRUE),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df |> 
  group_by(grp) |> 
  summarize(across(everything(), median))

"
Note que as colunas de agrupamento (grp aqui) não são incluídas em across(), porque são automaticamente preservadas por summarize().

where() permite que você selecione colunas baseadas em seu tipo:
"
#1º where(is.numeric) seleciona todas as colunas numéricas.
#2º where(is.character) seleciona todas as colunas de string.
#3º where(is.Date) seleciona todas as colunas de data.
#4º where(is.POSIXct) seleciona todas as colunas de data-hora.
#5º where(is.logical) seleciona todas as colunas lógicas.

"
Assim como outros seletores, você pode combinar esses com álgebra booleana. Por exemplo, !where(is.numeric) seleciona todas as colunas não numéricas, e starts_with('a') & where(is.logical) seleciona todas as colunas lógicas cujo nome começa com 'a'.
"

#----26.2.2 Chamando uma única função----
"
O segundo argumento para across() define como cada coluna será transformada. Em casos simples, como acima, será uma única função existente. Esta é uma característica bastante especial do R: estamos passando uma função (median, mean, str_flatten, ...) para outra função (across). Esta é uma das características que fazem do R uma linguagem de programação funcional.

É importante notar que estamos passando essa função para across(), para que across() possa chamá-la; nós mesmos não estamos chamando. Isso significa que o nome da função nunca deve ser seguido por (). Se você esquecer, receberá um erro:
"
df |> 
  group_by(grp) |> 
  summarize(across(everything(), median()))

"
Este erro surge porque você está chamando a função sem entrada, por exemplo:
"
median()


#----26.2.3 Chamando múltiplas funções----
"
Em casos mais complexos, você pode querer fornecer argumentos adicionais ou realizar múltiplas transformações. Vamos motivar esse problema com um exemplo simples: o que acontece se tivermos alguns valores ausentes em nossos dados? median() propaga esses valores ausentes, nos dando uma saída subótima:
"
rnorm_na <- function(n, n_na, mean = 0, sd = 1) {
  sample(c(rnorm(n - n_na, mean = mean, sd = sd), rep(NA, n_na)))
}

df_miss <- tibble(
  a = rnorm_na(5, 1),
  b = rnorm_na(5, 1),
  c = rnorm_na(5, 2),
  d = rnorm(5)
)
df_miss |> 
  summarize(
    across(a:d, median),
    n = n()
  )

"
Seria bom se pudéssemos passar na.rm = TRUE para median() para remover esses valores ausentes. Para fazer isso, em vez de chamar median() diretamente, precisamos criar uma nova função que chame median() com os argumentos desejados:
"
df_miss |> 
  summarize(
    across(a:d, function(x) median(x, na.rm = TRUE)),
    n = n()
  )

"
Isso é um pouco prolixo, então o R vem com um atalho útil: para este tipo de função descartável ou anônima, você pode substituir function por \2:
"
df_miss |> 
  summarize(
    across(a:d, \(x) median(x, na.rm = TRUE)),
    n = n()
  )

"
Em qualquer caso, across() se expande efetivamente para o seguinte código:
"
df_miss |> 
  summarize(
    a = median(a, na.rm = TRUE),
    b = median(b, na.rm = TRUE),
    c = median(c, na.rm = TRUE),
    d = median(d, na.rm = TRUE),
    n = n()
  )

"
Quando removemos os valores ausentes da mediana, seria bom saber quantos valores foram removidos. Podemos descobrir isso fornecendo duas funções para across(): uma para calcular a mediana e a outra para contar os valores ausentes. Você fornece múltiplas funções usando uma lista nomeada para .fns:
"
df_miss |> 
  summarize(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),
      n_miss = \(x) sum(is.na(x))
    )),
    n = n()
  )

"
Se você olhar com atenção, pode intuir que as colunas são nomeadas usando uma especificação de cola como {.col}_{.fn} onde .col é o nome da coluna original e .fn é o nome da função. Isso não é coincidência! Como você aprenderá na próxima seção, você pode usar o argumento .names para fornecer sua própria especificação de cola.
"

#----26.2.4 Nomes de colunas----
"
O resultado de across() é nomeado de acordo com a especificação fornecida no argumento .names. Poderíamos especificar o nosso próprio se quiséssemos que o nome da função viesse primeiro:
"
df_miss |> 
  summarize(
    across(
      a:d,
      list(
        median = \(x) median(x, na.rm = TRUE),
        n_miss = \(x) sum(is.na(x))
      ),
      .names = "{.fn}_{.col}"
    ),
    n = n(),
  )


"
O argumento .names é particularmente importante quando você usa across() com mutate(). Por padrão, a saída de across() é dada os mesmos nomes que as entradas. Isso significa que across() dentro de mutate() substituirá colunas existentes. Por exemplo, aqui usamos coalesce() para substituir NAs por 0:
"
df_miss |> 
  mutate(
    across(a:d, \(x) coalesce(x, 0))
  )

"
Se você quiser, em vez disso, criar novas colunas, você pode usar o argumento .names para dar novos nomes à saída:
"
df_miss |> 
  mutate(
    across(a:d, \(x) coalesce(x, 0), .names = "{.col}_na_zero")
  )

#----26.2.5 Filtragem----
"
across() é uma ótima combinação para summarize() e mutate(), mas é mais complicado de usar com filter(), porque você geralmente combina múltiplas condições com | ou &. É claro que across() pode ajudar a criar múltiplas colunas lógicas, mas e depois? Então, o dplyr fornece duas variantes de across() chamadas if_any() e if_all():
"
# same as df_miss |> filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))
df_miss |> filter(if_any(a:d, is.na))

# same as df_miss |> filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))
df_miss |> filter(if_all(a:d, is.na))

#----26.2.6 across() em funções----
"
across() é particularmente útil para programar porque permite operar em múltiplas colunas. Por exemplo, Jacob Scott usa este pequeno auxiliar que envolve várias funções do lubridate para expandir todas as colunas de data em colunas de ano, mês e dia:
"
expand_dates <- function(df) {
  df |> 
    mutate(
      across(where(is.Date), list(year = year, month = month, day = mday))
    )
}

df_date <- tibble(
  name = c("Amy", "Bob"),
  date = ymd(c("2009-08-03", "2010-01-16"))
)

df_date |> 
  expand_dates()

"
across() também facilita o fornecimento de múltiplas colunas em um único argumento, porque o primeiro argumento usa seleção arrumada (tidy-select); você só precisa lembrar de abraçar esse argumento, como discutimos anteriormente. Por exemplo, esta função calculará as médias das colunas numéricas por padrão. Mas, fornecendo o segundo argumento, você pode escolher resumir apenas colunas selecionadas:
"
summarize_means <- function(df, summary_vars = where(is.numeric)) {
  df |> 
    summarize(
      across({{ summary_vars }}, \(x) mean(x, na.rm = TRUE)),
      n = n(),
      .groups = "drop"
    )
}
diamonds |> 
  group_by(cut) |> 
  summarize_means()

diamonds |> 
  group_by(cut) |> 
  summarize_means(c(carat, x:z))


#----26.2.7 Vs pivot_longer()----
"
Antes de continuarmos, vale a pena apontar uma conexão interessante entre across() e pivot_longer() (Seção 5.3). Em muitos casos, você realiza os mesmos cálculos primeiro pivotando os dados e, em seguida, realizando as operações por grupo em vez de por coluna. Por exemplo, pegue este resumo multi-função:
"
df |> 
  summarize(across(a:d, list(median = median, mean = mean)))

"
Poderíamos calcular os mesmos valores pivotando mais longo e depois resumindo:
"
long <- df |> 
  pivot_longer(a:d) |> 
  group_by(name) |> 
  summarize(
    median = median(value),
    mean = mean(value)
  )
long

"
E se você quisesse a mesma estrutura que across(), você poderia pivotar novamente:
"
long |> 
  pivot_wider(
    names_from = name,
    values_from = c(median, mean),
    names_vary = "slowest",
    names_glue = "{name}_{.value}"
  )

"
Esta é uma técnica útil para conhecer, porque às vezes você encontrará um problema que atualmente não é possível resolver com across(): quando você tem grupos de colunas com os quais deseja calcular simultaneamente. Por exemplo, imagine que nosso data frame contém tanto valores quanto pesos e queremos calcular uma média ponderada:
"
df_paired <- tibble(
  a_val = rnorm(10),
  a_wts = runif(10),
  b_val = rnorm(10),
  b_wts = runif(10),
  c_val = rnorm(10),
  c_wts = runif(10),
  d_val = rnorm(10),
  d_wts = runif(10)
)

"
Atualmente, não há como fazer isso com across(), mas é relativamente simples com pivot_longer():
"
df_long <- df_paired |> 
  pivot_longer(
    everything(), 
    names_to = c("group", ".value"), 
    names_sep = "_"
  )
df_long

df_long |> 
  group_by(group) |> 
  summarize(mean = weighted.mean(val, wts))

"
Se necessário, você poderia pivotar mais largo (pivot_wider()) isso de volta para a forma original.
"

#----26.3 Lendo múltiplos arquivos----
"
Anteriormente, você aprendeu a usar dplyr::across() para repetir uma transformação em várias colunas. Nesta seção, você aprenderá a usar purrr::map() para fazer algo com cada arquivo em um diretório. Vamos começar com um pouco de motivação: imagine que você tem um diretório cheio de planilhas do Excel5 que deseja ler. Você poderia fazer isso com copiar e colar:
"
data2019 <- readxl::read_excel("y2019.xlsx")
data2020 <- readxl::read_excel("y2020.xlsx")
data2021 <- readxl::read_excel("y2021.xlsx")
data2022 <- readxl::read_excel("y2022.xlsx")

"
E depois usar dplyr::bind_rows() para combiná-las todas juntas:
"
data <- bind_rows(data2019, data2020, data2021, data2022)

"
Você pode imaginar que isso se tornaria tedioso rapidamente, especialmente se você tivesse centenas de arquivos, não apenas quatro. As próximas seções mostram como automatizar esse tipo de tarefa. Há três etapas básicas: usar list.files() para listar todos os arquivos em um diretório, depois usar purrr::map() para ler cada um deles em uma lista, e então usar purrr::list_rbind() para combiná-los em um único data frame. Em seguida, discutiremos como você pode lidar com situações de heterogeneidade crescente, onde você não pode fazer exatamente a mesma coisa com cada arquivo.
"

#----26.3.1 Listando arquivos em um diretório----
"
Como o nome sugere, list.files() lista os arquivos em um diretório. Você quase sempre usará três argumentos:
"
#1º O primeiro argumento, path, é o diretório a ser pesquisado. (Como eu fixei o meu diretório, eu não preciso especificar)
#2º pattern é uma expressão regular usada para filtrar os nomes dos arquivos. O padrão mais comum é algo como [.]xlsx$ ou [.]csv$ para encontrar todos os arquivos com uma extensão especificada.
#3º full.names determina se o nome do diretório deve ser incluído na saída. Quase sempre você vai querer que isso seja TRUE.

"
Para tornar nosso exemplo motivador concreto, este livro contém uma pasta com 12 planilhas do Excel contendo dados do pacote gapminder. Cada arquivo contém um ano de dados para 142 países. Podemos listá-los todos com a chamada apropriada para list.files():
"
paths <- list.files("gapminder", pattern = "[.]xlsx$", full.names = TRUE)
paths

#----26.3.2 Listas----
"
Agora que temos esses 12 caminhos, poderíamos chamar read_excel() 12 vezes para obter 12 data frames:
"
gapminder_1952 <- readxl::read_excel("data/gapminder/1952.xlsx")
gapminder_1957 <- readxl::read_excel("data/gapminder/1957.xlsx")
gapminder_1962 <- readxl::read_excel("data/gapminder/1962.xlsx")
#...,
gapminder_2007 <- readxl::read_excel("data/gapminder/2007.xlsx")

"
Mas colocar cada planilha em sua própria variável vai dificultar o trabalho com elas alguns passos adiante. Em vez disso, será mais fácil trabalhar com elas se as colocarmos em um único objeto. Uma lista é a ferramenta perfeita para este trabalho:
"
files <- list(
  readxl::read_excel("data/gapminder/1952.xlsx"),
  readxl::read_excel("data/gapminder/1957.xlsx"),
  readxl::read_excel("data/gapminder/1962.xlsx"),
  #...,
  readxl::read_excel("data/gapminder/2007.xlsx")
)

"
Agora que você tem esses data frames em uma lista, como você tira um deles? Você pode usar files[[i]] para extrair o i-ésimo elemento:
"
files[[i]] #files[[3]]

"
Voltaremos a [[ com mais detalhes futuramente.
"

#----26.3.3 purrr::map() e list_rbind()----
"
O código para coletar esses data frames em uma lista 'manualmente' é basicamente tão tedioso de digitar quanto o código que lê os arquivos um por um. Felizmente, podemos usar purrr::map() para fazer um uso ainda melhor do nosso vetor de caminhos. map() é semelhante a across(), mas em vez de fazer algo para cada coluna em um data frame, faz algo para cada elemento de um vetor. map(x, f) é uma abreviação para:
"
list(
  f(x[[1]]),
  f(x[[2]]),
  #...,
  f(x[[n]])
)

"
Portanto, podemos usar map() para obter uma lista de 12 data frames:
"
files <- map(paths, readxl::read_excel)
length(files)

files[[1]]

"
Esta é outra estrutura de dados que não se exibe particularmente de forma compacta com str(), então você pode querer carregá-la no RStudio e inspecioná-la com View().

Agora podemos usar purrr::list_rbind() para combinar essa lista de data frames em um único data frame:
"
list_rbind(files)

"
Ou poderíamos fazer as duas etapas de uma vez em um pipeline:
"
paths |> 
  map(readxl::read_excel) |> 
  list_rbind()

"
E se quisermos passar argumentos extras para read_excel()? Usamos a mesma técnica que usamos com across(). Por exemplo, é frequentemente útil dar uma espiada nas primeiras linhas dos dados com n_max = 1:
"
paths |> 
  map(\(path) readxl::read_excel(path, n_max = 1)) |> 
  list_rbind()

"
Isso deixa claro que algo está faltando: não há coluna de ano porque esse valor é registrado no caminho, não nos arquivos individuais. Vamos abordar esse problema a seguir.
"

#----26.3.4 Dados no caminho----
"
Às vezes, o nome do arquivo é um dado em si. Neste exemplo, o nome do arquivo contém o ano, que não é registrado nos arquivos individuais. Para obter essa coluna no data frame final, precisamos fazer duas coisas:

Primeiro, nomeamos o vetor de caminhos. A maneira mais fácil de fazer isso é com a função set_names(), que pode receber uma função. Aqui usamos basename() para extrair apenas o nome do arquivo do caminho completo:
"
paths |> set_names(basename) 

"
Esses nomes são automaticamente levados adiante por todas as funções map(), então a lista de data frames terá esses mesmos nomes:
"
files <- paths |> 
  set_names(basename) |> 
  map(readxl::read_excel)

"
Isso torna esta chamada para map() uma abreviação para:
"
files <- list(
  "1952.xlsx" = readxl::read_excel("data/gapminder/1952.xlsx"),
  "1957.xlsx" = readxl::read_excel("data/gapminder/1957.xlsx"),
  "1962.xlsx" = readxl::read_excel("data/gapminder/1962.xlsx"),
  #...,
  "2007.xlsx" = readxl::read_excel("data/gapminder/2007.xlsx")
)

"
Você também pode usar [[ para extrair elementos pelo nome:
"
files[["1962.xlsx"]]

"
Depois, usamos o argumento names_to em list_rbind() para dizer que salve os nomes em uma nova coluna chamada ano, e então usamos readr::parse_number() para extrair o número da string.
"
paths |> 
  set_names(basename) |> 
  map(readxl::read_excel) |> 
  list_rbind(names_to = "year") |> 
  mutate(year = parse_number(year))

"
Em casos mais complicados, pode haver outras variáveis armazenadas no nome do diretório, ou talvez o nome do arquivo contenha vários pedaços de dados. Nesse caso, use set_names() (sem argumentos) para registrar o caminho completo e, em seguida, use tidyr::separate_wider_delim() e similares para transformá-los em colunas úteis.
"
paths |> 
  set_names() |> 
  map(readxl::read_excel) |> 
  list_rbind(names_to = "year") |> 
  separate_wider_delim(year, delim = "/", names = c(NA, "dir", "file")) |> 
  separate_wider_delim(file, delim = ".", names = c("file", "ext"))

#----26.3.5 Salve seu trabalho----
"
Agora que você fez todo esse trabalho duro para chegar a um data frame organizado e agradável, é um ótimo momento para salvar seu trabalho:
"
gapminder <- paths |> 
  set_names(basename) |> 
  map(readxl::read_excel) |> 
  list_rbind(names_to = "year") |> 
  mutate(year = parse_number(year))

write_csv(gapminder, "gapminder.csv")

"
Agora, quando você voltar a este problema no futuro, poderá ler um único arquivo csv. Para conjuntos de dados grandes e mais ricos, usar parquet pode ser uma escolha melhor do que .csv, como discutido anteriormente.

Se você está trabalhando em um projeto, sugerimos nomear o arquivo que faz esse tipo de trabalho de preparação de dados como 0-cleanup.R. O 0 no nome do arquivo sugere que isso deve ser executado antes de qualquer outra coisa.

Se seus arquivos de dados de entrada mudarem ao longo do tempo, você pode considerar aprender uma ferramenta como targets para configurar seu código de limpeza de dados para ser executado automaticamente sempre que um dos arquivos de entrada for modificado.
"

#----26.3.6 Muitas iterações simples----
"
Aqui nós apenas carregamos os dados diretamente do disco e tivemos a sorte de obter um conjunto de dados organizado. Na maioria dos casos, você precisará fazer alguma organização adicional, e você tem duas opções básicas: você pode fazer uma rodada de iteração com uma função complexa, ou fazer várias rodadas de iteração com funções simples. Na nossa experiência, a maioria das pessoas opta primeiro por uma iteração complexa, mas muitas vezes é melhor fazer várias iterações simples.

Por exemplo, imagine que você quer ler um monte de arquivos, filtrar valores ausentes, pivotar e depois combinar. Uma maneira de abordar o problema é escrever uma função que pega um arquivo e realiza todas essas etapas e então chamar map() uma vez:
"
process_file <- function(path) {
  df <- read_csv(path)
  
  df |> 
    filter(!is.na(id)) |> 
    mutate(id = tolower(id)) |> 
    pivot_longer(jan:dec, names_to = "month")
}

paths |> 
  map(process_file) |> 
  list_rbind()

"
Alternativamente, você poderia aplicar cada etapa de process_file() a cada arquivo:
"
paths |> 
  map(read_csv) |> 
  map(\(df) df |> filter(!is.na(id))) |> 
  map(\(df) df |> mutate(id = tolower(id))) |> 
  map(\(df) df |> pivot_longer(jan:dec, names_to = "month")) |> 
  list_rbind()

"
Recomendamos esta abordagem porque impede que você fique fixado em acertar o primeiro arquivo antes de passar para o resto. Ao considerar todos os dados ao fazer a organização e limpeza, você tem mais chances de pensar de forma holística e acabar com um resultado de maior qualidade.

Neste exemplo particular, há outra otimização que você poderia fazer, unindo todos os data frames mais cedo. Assim, você pode confiar no comportamento regular do dplyr:
"
paths |> 
  map(read_csv) |> 
  list_rbind() |> 
  filter(!is.na(id)) |> 
  mutate(id = tolower(id)) |> 
  pivot_longer(jan:dec, names_to = "month")

#----26.3.7 Dados heterogêneos----
"
Infelizmente, às vezes não é possível ir direto de map() para list_rbind() porque os data frames são tão heterogêneos que list_rbind() falha ou produz um data frame que não é muito útil. Nesse caso, ainda é útil começar carregando todos os arquivos:
"
files <- paths |> 
  map(readxl::read_excel) 

"
Então, uma estratégia muito útil é capturar a estrutura dos data frames para que você possa explorá-la usando suas habilidades de ciência de dados. Uma maneira de fazer isso é com esta prática função df_types que retorna um tibble com uma linha para cada coluna:
"
df_types <- function(df) {
  tibble(
    col_name = names(df), 
    col_type = map_chr(df, vctrs::vec_ptype_full),
    n_miss = map_int(df, \(x) sum(is.na(x)))
  )
}

df_types(gapminder)

"
Você pode então aplicar esta função a todos os arquivos, e talvez fazer algum pivotamento para facilitar a visualização das diferenças. Por exemplo, isso torna fácil verificar que as planilhas gapminder com as quais estamos trabalhando são todas bastante homogêneas:
"
files |> 
  map(df_types) |> 
  list_rbind(names_to = "file_name") |> 
  select(-n_miss) |> 
  pivot_wider(names_from = col_name, values_from = col_type)

"
Se os arquivos tiverem formatos heterogêneos, você pode precisar fazer mais processamento antes de conseguir mesclá-los com sucesso. Infelizmente, agora vamos deixar você descobrir isso por conta própria, mas você pode querer ler sobre map_if() e map_at(). map_if() permite modificar seletivamente elementos de uma lista com base em seus valores; map_at() permite modificar seletivamente elementos com base em seus nomes.
"

#----26.3.8 Lidando com falhas----
"
Às vezes, a estrutura dos seus dados pode ser tão complexa que você não consegue ler todos os arquivos com um único comando. E então você encontrará uma das desvantagens do map(): ele tem sucesso ou falha como um todo. map() ou lerá com sucesso todos os arquivos em um diretório ou falhará com um erro, lendo zero arquivos. Isso é irritante: por que uma falha impede você de acessar todos os outros sucessos?

Felizmente, o purrr vem com um auxiliar para enfrentar este problema: possibly(). possibly() é o que é conhecido como um operador de função: ele pega uma função e retorna uma função com comportamento modificado. Em particular, possibly() muda uma função de dar erro para retornar um valor que você especifica:
"
files <- paths |> 
  map(possibly(\(path) readxl::read_excel(path), NULL))

data <- files |> list_rbind()

"
Isso funciona particularmente bem aqui porque list_rbind(), como muitas funções do tidyverse, automaticamente ignora NULLs.

Agora você tem todos os dados que podem ser lidos facilmente, e é hora de enfrentar a parte difícil de descobrir por que alguns arquivos falharam ao carregar e o que fazer a respeito. Comece obtendo os caminhos que falharam:
"
failed <- map_vec(files, is.null)
paths[failed]

"
Em seguida, chame a função de importação novamente para cada falha e descubra o que deu errado.
"

#----26.4 Salvando múltiplas saídas----
"
Você aprendeu sobre map(), que é útil para ler vários arquivos em um único objeto. Nesta seção, agora exploraremos o tipo oposto de problema: como você pode pegar um ou mais objetos R e salvá-los em um ou mais arquivos? Vamos explorar esse desafio usando três exemplos:
"
#1º Salvando múltiplos data frames em um único banco de dados.
#2º Salvando múltiplos data frames em vários arquivos .csv.
#3º Salvando múltiplos gráficos em vários arquivos .png.

#----26.4.1 Escrevendo em um banco de dados----
"
Às vezes, ao trabalhar com muitos arquivos de uma vez, não é possível ajustar todos os seus dados na memória de uma só vez, e você não pode usar map(files, read_csv). Uma abordagem para lidar com esse problema é carregar seus dados em um banco de dados para que você possa acessar apenas as partes de que precisa com dbplyr.

Se você tiver sorte, o pacote de banco de dados que você está usando fornecerá uma função prática que recebe um vetor de caminhos e carrega todos no banco de dados. Este é o caso com duckdb_read_csv() do duckdb:
"
con <- DBI::dbConnect(duckdb::duckdb())
duckdb::duckdb_read_csv(con, "gapminder", paths)

"
Isso funcionaria bem aqui, mas não temos arquivos csv, e sim planilhas do Excel. Então, vamos ter que fazer isso 'manualmente'. Aprender a fazer isso manualmente também ajudará quando você tiver um monte de csvs e o banco de dados com o qual está trabalhando não tiver uma função única que carregue todos eles.

Precisamos começar criando uma tabela que preencheremos com dados. A maneira mais fácil de fazer isso é criando um template, um data frame fictício que contém todas as colunas que queremos, mas apenas uma amostra dos dados. Para os dados do gapminder, podemos fazer esse template lendo um único arquivo e adicionando o ano a ele:
"
template <- readxl::read_excel(paths[[1]])
template$year <- 1952
template

"
Agora podemos nos conectar ao banco de dados e usar DBI::dbCreateTable() para transformar nosso template em uma tabela de banco de dados:
"
con <- DBI::dbConnect(duckdb::duckdb())
DBI::dbCreateTable(con, "gapminder", template)

"
dbCreateTable() não usa os dados em template, apenas os nomes e tipos das variáveis. Então, se inspecionarmos a tabela gapminder agora, você verá que ela está vazia, mas tem as variáveis que precisamos com os tipos que esperamos:
"
con |> tbl("gapminder")

"
Em seguida, precisamos de uma função que pegue um único caminho de arquivo, leia-o no R e adicione o resultado à tabela gapminder. Podemos fazer isso combinando read_excel() com DBI::dbAppendTable():
"
append_file <- function(path) {
  df <- readxl::read_excel(path)
  df$year <- parse_number(basename(path))
  
  DBI::dbAppendTable(con, "gapminder", df)
}

"
Agora precisamos chamar append_file() uma vez para cada elemento de paths. Isso certamente é possível com map():
"
paths |> map(append_file)

"
Mas não nos importamos com a saída de append_file(), então, em vez de map(), é um pouco melhor usar walk(). walk() faz exatamente a mesma coisa que map(), mas descarta a saída:
"
paths |> walk(append_file)

"
Agora podemos ver se temos todos os dados em nossa tabela:
"
con |> 
  tbl("gapminder") |> 
  count(year)

#----26.4.2 Escrevendo arquivos csv----
"
O mesmo princípio básico se aplica se quisermos escrever vários arquivos csv, um para cada grupo. Vamos imaginar que queremos pegar os dados de ggplot2::diamonds e salvar um arquivo csv para cada tipo de clareza (clarity). Primeiro, precisamos fazer esses conjuntos de dados individuais. Há muitas maneiras de fazer isso, mas há uma maneira que gostamos particularmente: group_nest().
"
by_clarity <- diamonds |> 
  group_nest(clarity)

by_clarity

"
Isso nos dá um novo tibble com oito linhas e duas colunas. clarity é a nossa variável de agrupamento e data é uma coluna-lista contendo um tibble para cada valor único de clarity:
"
by_clarity$data[[1]]

"
Enquanto estamos aqui, vamos criar uma coluna que dê o nome do arquivo de saída, usando mutate() e str_glue():
"
by_clarity <- by_clarity |> 
  mutate(path = str_glue("diamonds-{clarity}.csv"))

by_clarity

"
Então, se fôssemos salvar esses data frames manualmente, poderíamos escrever algo como:
"
write_csv(by_clarity$data[[1]], by_clarity$path[[1]])
write_csv(by_clarity$data[[2]], by_clarity$path[[2]])
write_csv(by_clarity$data[[3]], by_clarity$path[[3]])
#...
write_csv(by_clarity$by_clarity[[8]], by_clarity$path[[8]])

"
Isso é um pouco diferente dos nossos usos anteriores de map() porque há dois argumentos que estão mudando, não apenas um. Isso significa que precisamos de uma nova função: map2(), que varia tanto o primeiro quanto o segundo argumento. E como novamente não nos importamos com a saída, queremos walk2() em vez de map2(). Isso nos dá:
"
walk2(by_clarity$data, by_clarity$path, write_csv)

#----26.4.3 Salvando gráficos----
"
Podemos adotar a mesma abordagem básica para criar muitos gráficos. Primeiro, vamos fazer uma função que desenhe o gráfico que queremos:
"
carat_histogram <- function(df) {
  ggplot(df, aes(x = carat)) + geom_histogram(binwidth = 0.1)  
}

carat_histogram(by_clarity$data[[1]])

"
Agora podemos usar map() para criar uma lista de muitos gráficos7 e seus caminhos de arquivo finais:
"
by_clarity <- by_clarity |> 
  mutate(
    plot = map(data, carat_histogram),
    path = str_glue("clarity-{clarity}.png")
  )

"
Então use walk2() com ggsave() para salvar cada gráfico:
"
walk2(
  by_clarity$path,
  by_clarity$plot,
  \(path, plot) ggsave(path, plot, width = 6, height = 6)
)

"
Isso é uma abreviação para:
"
ggsave(by_clarity$path[[1]], by_clarity$plot[[1]], width = 6, height = 6)
ggsave(by_clarity$path[[2]], by_clarity$plot[[2]], width = 6, height = 6)
ggsave(by_clarity$path[[3]], by_clarity$plot[[3]], width = 6, height = 6)
#...
ggsave(by_clarity$path[[8]], by_clarity$plot[[8]], width = 6, height = 6)

#----Capítulo 27 : Um Guia de Campo para o R Base----

#----27.1 Introdução----
"
Para finalizar a seção de programação, vamos dar um rápido tour pelas funções mais importantes do R base que não discutimos em outro lugar no livro. Essas ferramentas são particularmente úteis à medida que você faz mais programação e ajudarão você a ler o código que encontrará na prática.

Este é um bom lugar para lembrar que o tidyverse não é a única maneira de resolver problemas de ciência de dados. Nós ensinamos o tidyverse neste
livro porque os pacotes do tidyverse compartilham uma filosofia de design comum, aumentando a consistência entre as funções e tornando cada nova função ou pacote um pouco mais fácil de aprender e usar. Não é possível usar o tidyverse sem usar o R base, então na verdade já ensinamos muitas funções do R base: desde library() para carregar pacotes, até sum() e mean() para resumos numéricos, até os tipos de dados factor, date e POSIXct, e claro, todos os operadores básicos como +, -, /, *, |, &, e !. O que não focamos até agora são os fluxos de trabalho do R base, então vamos destacar alguns deles neste capítulo.

Depois de ler este livro, você aprenderá outras abordagens para os mesmos problemas usando R base, data.table e outros pacotes. Você certamente encontrará essas outras abordagens quando começar a ler o código R escrito por outros, especialmente se estiver usando o StackOverflow. É 100% aceitável escrever código que usa uma mistura de abordagens, e não deixe ninguém lhe dizer o contrário!

Agora vamos nos concentrar em quatro grandes tópicos: subconjunto com [, subconjunto com [[ e $, a família de funções apply e loops for. Para finalizar, discutiremos brevemente duas funções essenciais de plotagem.
"

#----27.1.1 Pré-requisitos----
"
Este pacote se concentra no R base, portanto não tem pré-requisitos reais, mas carregaremos o tidyverse para explicar algumas das diferenças.
"
library(tidyverse)

#----27.2 Selecionando múltiplos elementos com [----
"
[ é usado para extrair subcomponentes de vetores e data frames, e é chamado como x[i] ou x[i, j]. Nesta seção, apresentaremos a você o poder do [, mostrando primeiro como você pode usá-lo com vetores e, em seguida, como os mesmos princípios se estendem de maneira direta para estruturas bidimensionais (2d) como data frames. Então, ajudaremos você a consolidar esse conhecimento, mostrando como vários verbos do dplyr são casos especiais de [.
"

#----27.2.1 Subconjuntos de vetores----
"
Existem cinco tipos principais de elementos que você pode usar para fazer subconjuntos de um vetor, ou seja, o que pode ser o i em x[i]:
"
#1º Existem cinco tipos principais de elementos que você pode usar para fazer subconjuntos de um vetor, ou seja, o que pode ser o i em x[i]:
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]
# Ao repetir uma posição, você pode realmente fazer uma saída mais longa do que a entrada, tornando o termo "subconjunto" um pouco inadequado.
x[c(1, 1, 5, 5, 5, 2)]
#2º Um vetor de inteiros negativos. Valores negativos descartam os elementos nas posições especificadas:
x[c(-1, -3, -5)]
#3º Um vetor lógico. Fazer subconjuntos com um vetor lógico mantém todos os valores correspondentes a um valor TRUE. Isso é mais útil em conjunto com as funções de comparação.
x <- c(10, 3, NA, 5, 8, 1, NA)

# All non-missing values of x
x[!is.na(x)]

# All even (or missing!) values of x
x[x %% 2 == 0]

# Ao contrário do filter(), índices NA serão incluídos na saída como NAs.
#4º Um vetor de caracteres. Se você tem um vetor nomeado, pode fazer subconjuntos dele com um vetor de caracteres:
x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]
# Assim como ao fazer subconjuntos com inteiros positivos, você pode usar um vetor de caracteres para duplicar entradas individuais.
#5º Nada. O tipo final de subconjunto é nada, x[], que retorna o x completo. Isso não é útil para subconjuntos de vetores, mas, como veremos em breve, é útil ao fazer subconjuntos de estruturas 2d como tibbles.

#----27.2.2 Subconjuntos de data frames----
"
Existem várias maneiras1 diferentes de usar [ com um data frame, mas a mais importante é selecionar linhas e colunas independentemente com df[rows, cols]. Aqui, rows e cols são vetores como descrito acima. Por exemplo, df[rows, ] e df[, cols] selecionam apenas linhas ou apenas colunas, usando o subconjunto vazio para preservar a outra dimensão.

Aqui estão alguns exemplos:
"
df <- tibble(
  x = 1:3, 
  y = c("a", "e", "f"), 
  z = runif(3)
)

# Select first row and second column
df[1, 2]

# Select all rows and columns x and y
df[, c("x" , "y")]

# Select rows where `x` is greater than 1 and all columns
df[df$x > 1, ]

"
Voltaremos ao $ em breve, mas você deve ser capaz de adivinhar o que df$x faz a partir do contexto: ele extrai a variável x de df. Precisamos usá-lo aqui porque [ não usa avaliação arrumada (tidy evaluation), então você precisa ser explícito sobre a fonte da variável x.

Há uma diferença importante entre tibbles e data frames quando se trata de [. Neste livro, usamos principalmente tibbles, que são data frames, mas eles ajustam alguns comportamentos para tornar sua vida um pouco mais fácil. Na maioria dos lugares, você pode usar 'tibble' e 'data frame' de forma intercambiável, então quando queremos chamar atenção especial para o data frame integrado do R, escreveremos data.frame. Se df é um data.frame, então df[, cols] retornará um vetor se cols selecionar uma única coluna e um data frame se selecionar mais de uma coluna. Se df é um tibble, então [ sempre retornará um tibble.
"
df1 <- data.frame(x = 1:3)
df1[, "x"]

df2 <- tibble(x = 1:3)
df2[, "x"]

"
Uma maneira de evitar essa ambiguidade com data.frames é especificar explicitamente drop = FALSE:
"
df1[, "x" , drop = FALSE]

#----27.2.3 Equivalentes dplyr----
"
Vários verbos do dplyr são casos especiais de [:
"
#1º filter() é equivalente a subconjuntar as linhas com um vetor lógico, tomando cuidado para excluir valores ausentes:
df <- tibble(
  x = c(2, 3, 1, 1, NA), 
  y = letters[1:5], 
  z = runif(5)
)
df |> filter(x > 1)

# same as
df[!is.na(df$x) & df$x > 1, ]
# Outra técnica comum na prática é usar which() pelo seu efeito colateral de descartar valores ausentes: df[which(df$x > 1), ].
#2º arrange() é equivalente a subconjuntar as linhas com um vetor de inteiros, geralmente criado com order():
df |> arrange(x, y)

# same as
df[order(df$x, df$y), ]

# Você pode usar order(decreasing = TRUE) para ordenar todas as colunas em ordem decrescente ou -rank(col) para ordenar colunas em ordem decrescente individualmente.
#3º Tanto select() quanto relocate() são semelhantes a subconjuntar as colunas com um vetor de caracteres:
df |> select(x, z)

# same as
df[, c("x", "z")]

"
O R base também fornece uma função que combina as características de filter() e select() chamada subset():
"
df |> 
  filter(x > 1) |> 
  select(y, z)

# same as 
df |> subset(x > 1, c(y, z))

"
Essa função foi a inspiração para grande parte da sintaxe do dplyr.
"

#----27.3 Selecionando um único elemento com $ e [[----
"
[, que seleciona muitos elementos, é pareado com [[ e $, que extraem um único elemento. Nesta seção, mostraremos como usar [[ e $ para extrair colunas de data frames, discutiremos mais algumas diferenças entre data.frames e tibbles, e enfatizaremos algumas diferenças importantes entre [ e [[ quando usados com listas.
"

#----27.3.1 Data frames----
"
[[ e $ podem ser usados para extrair colunas de um data frame. [[ pode acessar por posição ou por nome, e $ é especializado para acesso por nome:
"
tb <- tibble(
  x = 1:4,
  y = c(10, 4, 1, 21)
)

# by position
tb[[1]]

# by name
tb[["x"]]
tb$x

"
Eles também podem ser usados para criar novas colunas, o equivalente no R base do mutate():
"
tb$z <- tb$x + tb$y
tb

"
Existem várias outras abordagens no R base para criar novas colunas, incluindo transform(), with() e within(). Hadley coletou alguns exemplos em https://gist.github.com/hadley/1986a273e384fb2d4d752c18ed71bedf.

Usar $ diretamente é conveniente ao realizar resumos rápidos. Por exemplo, se você só quer encontrar o tamanho do maior diamante ou os possíveis valores de corte, não há necessidade de usar summarize():
"
max(diamonds$carat)

levels(diamonds$cut)

"
O dplyr também fornece um equivalente a [[/$ que não mencionamos no início: pull(). pull() aceita um nome de variável ou posição de variável e retorna apenas aquela coluna. Isso significa que poderíamos reescrever o código acima para usar o pipe:
"
diamonds |> pull(carat) |> max()

diamonds |> pull(cut) |> levels()

#----27.3.2 Tibbles----
"
Há algumas diferenças importantes entre tibbles e data.frames base no que diz respeito ao $. Data frames correspondem ao prefixo de qualquer nome de variável (o chamado correspondência parcial) e não reclamam se uma coluna não existir:
"
df <- data.frame(x1 = 1)
df$x
df$z

"
Tibbles são mais rigorosos: eles só correspondem exatamente aos nomes das variáveis e gerarão um aviso se a coluna que você está tentando acessar não existir:
"
tb <- tibble(x1 = 1)

tb$x
tb$z

"
Por essa razão, às vezes brincamos que tibbles são preguiçosos e mal-humorados: eles fazem menos e reclamam mais.
"

#----27.3.3 Listas----
"
[[ e $ também são realmente importantes para trabalhar com listas, e é importante entender como eles diferem de [. Vamos ilustrar as diferenças com uma lista chamada l:
"
l <- list(
  a = 1:3, 
  b = "a string", 
  c = pi, 
  d = list(-1, -5)
)

#1º [ extrai uma sublista. Não importa quantos elementos você extraia, o resultado será sempre uma lista.
str(l[1:2])

str(l[1])

str(l[4])
# Assim como com vetores, você pode fazer subconjuntos com um vetor lógico, inteiro ou de caracteres.
#2º [[ e $ extraem um único componente de uma lista. Eles removem um nível de hierarquia da lista.
str(l[[1]])

str(l[[4]])

str(l$a)

"
A diferença entre [ e [[ é particularmente importante para listas porque [[ penetra na lista, enquanto [ retorna uma nova lista, menor.

Esse mesmo princípio se aplica quando você usa [ 1d com um data frame: df['x'] retorna um data frame de uma coluna e df[['x']] retorna um vetor.
"

#----27.4 Família Apply----
"
Anteriormente, você aprendeu técnicas do tidyverse para iteração como dplyr::across() e a família de funções map. Nesta seção, você aprenderá sobre seus equivalentes no R base, a família apply. Neste contexto, apply e map são sinônimos porque outra maneira de dizer 'mapear uma função sobre cada elemento de um vetor' é 'aplicar uma função sobre cada elemento de um vetor'. Aqui daremos a você uma visão geral rápida dessa família para que você possa reconhecê-los na prática.

O membro mais importante desta família é lapply(), que é muito semelhante a purrr::map(). Na verdade, como não usamos nenhum dos recursos mais avançados de map(), você pode substituir cada chamada de map() por lapply().

Não há um equivalente exato no R base para across(), mas você pode chegar perto usando [ com lapply(). Isso funciona porque, por baixo dos panos, os data frames são listas de colunas, então chamar lapply() em um data frame aplica a função a cada coluna.
"
df <- tibble(a = 1, b = 2, c = "a", d = "b", e = 4)

# First find numeric columns
num_cols <- sapply(df, is.numeric)
num_cols

df[, num_cols] <- lapply(df[, num_cols, drop = FALSE], \(x) x * 2)
df

"
O código acima usa uma nova função, sapply(). É semelhante a lapply(), mas sempre tenta simplificar o resultado, daí o s em seu nome, produzindo aqui um vetor lógico em vez de uma lista. Não recomendamos usá-lo para programação, porque a simplificação pode falhar e dar um tipo inesperado, mas geralmente é bom para uso interativo. O purrr tem uma função semelhante chamada map_vec() que não mencionamos antes.

O R base fornece uma versão mais rigorosa do sapply() chamada vapply(), abreviação de vector apply. Ele recebe um argumento adicional que especifica o tipo esperado, garantindo que a simplificação ocorra da mesma forma, independentemente da entrada. Por exemplo, poderíamos substituir a chamada de sapply() acima com este vapply() onde especificamos que esperamos que is.numeric() retorne um vetor lógico de comprimento 1:
"
vapply(df, is.numeric, logical(1))

"
A distinção entre sapply() e vapply() é realmente importante quando estão dentro de uma função (porque faz uma grande diferença na robustez da função a entradas incomuns), mas geralmente não importa na análise de dados.

Outro membro importante da família apply é tapply(), que calcula um resumo agrupado único:
"
diamonds |> 
  group_by(cut) |> 
  summarize(price = mean(price))

tapply(diamonds$price, diamonds$cut, mean)

"
Infelizmente, tapply() retorna seus resultados em um vetor nomeado, o que requer algumas ginásticas se você quiser coletar vários resumos e variáveis de agrupamento em um data frame (certamente é possível não fazer isso e apenas trabalhar com vetores soltos, mas em nossa experiência isso apenas adia o trabalho). Se você quiser ver como pode usar tapply() ou outras técnicas do R base para realizar outros resumos agrupados, Hadley coletou algumas técnicas em um gist.

O membro final da família apply é o próprio apply(), que funciona com matrizes e arrays. Em particular, cuidado com apply(df, 2, something), que é uma maneira lenta e potencialmente perigosa de fazer lapply(df, something). Isso raramente surge na ciência de dados porque geralmente trabalhamos com data frames e não matrizes.
"

#----27.5 Loops for----
"
Os loops for são o bloco fundamental de construção da iteração que tanto as famílias apply quanto map usam por baixo dos panos. Os loops for são ferramentas poderosas e gerais que são importantes de aprender à medida que você se torna um programador R mais experiente. 

A estrutura básica de um loop for é assim:

for (element in vector) {
  # do something with element
}

O uso mais direto de loops for é para alcançar o mesmo efeito que walk(): chamar alguma função com um efeito colateral em cada elemento de uma lista. Por exemplo, em vez de usar walk():
"
paths |> walk(append_file)

"
Poderíamos ter usado um loop for:
"
for (path in paths) {
  append_file(path)
}

"
As coisas ficam um pouco mais complicadas se você quiser salvar a saída do loop for, por exemplo, lendo todos os arquivos do Excel em um diretório como fizemos.
"
paths <- dir("gapminder", pattern = "\\.xlsx$", full.names = TRUE)
files <- map(paths, readxl::read_excel)

"
Há algumas técnicas diferentes que você pode usar, mas recomendamos ser explícito sobre como será a saída antecipadamente. Neste caso, vamos querer uma lista do mesmo comprimento que paths, que podemos criar com vector():
"
files <- vector("list", length(paths))

"
Então, em vez de iterar sobre os elementos de paths, vamos iterar sobre seus índices, usando seq_along() para gerar um índice para cada elemento de paths:
"
seq_along(paths)

"
Usar os índices é importante porque nos permite vincular cada posição na entrada com a posição correspondente na saída:
"
for (i in seq_along(paths)) {
  files[[i]] <- readxl::read_excel(paths[[i]])
}

"
Para combinar a lista de tibbles em um único tibble, você pode usar do.call() + rbind():
"
do.call(rbind, files)

"
Em vez de criar uma lista e salvar os resultados à medida que avançamos, uma abordagem mais simples é construir o data frame peça por peça:
"
out <- NULL
for (path in paths) {
  out <- rbind(out, readxl::read_excel(path))
}

"
Recomendamos evitar este padrão porque ele pode se tornar muito lento quando o vetor é muito longo. Esta é a fonte do mito persistente de que os loops for são lentos: eles não são, mas crescer um vetor iterativamente é.
"

#----27.6 Gráficos----
"
Muitos usuários de R que não usam o tidyverse preferem o ggplot2 para plotagem devido a recursos úteis como padrões sensatos, legendas automáticas e uma aparência moderna. No entanto, as funções de plotagem do R base ainda podem ser úteis porque são muito concisas — é preciso muito pouco digitação para fazer um gráfico exploratório básico.

Há dois tipos principais de gráficos base que você verá na prática: gráficos de dispersão e histogramas, produzidos com plot() e hist() respectivamente. Aqui está um exemplo rápido do conjunto de dados diamonds:
"
hist(diamonds$carat)

plot(diamonds$carat, diamonds$price)

"
Observe que as funções de plotagem base funcionam com vetores, então você precisa extrair colunas do data frame usando $ ou alguma outra técnica.
"