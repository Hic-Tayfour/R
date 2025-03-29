# Capítulo 1: Visualização de dados
# =================================

#----1.1. Introdução----
# ---------------------
" 
O R possui diversos sistemas de construção de gráficos, mas o ggplot2 é um dos mais elegantes e versáteis. O ggplot implementa a conhecida gramática dos gráficos, um sistema coerente para descrever e construir gráficos.

Com o ggplot2, você pode fazer mais e mais rápido, ao aprender um sistema e aplicá-lo em muitos lugares.

Este capítulo irá lhe ensinar como visualizar seus dados usando ggplot2. Nós vamos começar criando um gráfico de dispersão simples e usá-lo para introduzir o mapeamento de atributos estéticos e geometrias - os blocos fundamentais na construção do ggplot2.

Nós vamos então orientar você na visualização de distribuições de variáveis individuais, bem como na visualização de relações entre duas ou mais variáveis.

Terminaremos salvando seus gráficos e com dicas de resolução de problemas.
"
#----1.1.1. Pré-Requisitos----
#-----------------------------
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
#----------------------------
"
Os pinguins com nadadeiras mais compridas pesam mais ou menos que pinguins com nadadeiras curtas ?

Você provavelmente játem uma resposta, mas tente torná-la mais precisa. 

Como é relação entre o comprimento da nadadeira e a massa corporal? Ela é positiva? Negativa? Linear? Não linear? A relação varia com a espécie do pinguim? E quanto à ilha onde o pinguim vive?

Vamos criar visualizações que podemos usar para responder essas perguntas.
"

#----1.2.1. O dataframe dos pinguins----
#---------------------------------------
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
#-----------------------------
"
Nosso objetivo final neste capítulo é recriar a seguinte visualização que exibe a relação entre o comprimento da nadadeira e a massa corporal desses pinguins, levando em consideração a espécie do pinguim.
"

#----1.2.3. Criando um gráfico ggplot----
#----------------------------------------
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
#--------------------------------------------------------
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
#------------------------------
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
#--------------------------------------
"
A forma como você visualiza a distribuição de uma variável depende do tipo de variável: categórica ou numérica.
"

#----1.4.1 Uma variável categórica----
#-------------------------------------
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
#-----------------------------------
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
#---------------------------------
"
Para visualizar uma relação, precisamos ter pelo menos duas variáveis mapeadas para os atributos estéticos de um gráfico. Nas seções a seguir, você aprenderá sobre os gráficos comumente usados para visualizarrelações entre duas ou mais variáveis e as geometrias usados para cria-los 
"

#----1.5.1 Uma variável numérica e uma variável categórica----
#-------------------------------------------------------------
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
#----------------------------------------
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
#--------------------------------------
"
Até agora, você aprendeu sobre gráficos de dispersão (criados com geom_point()) e curvas suaves (criadas com geom_smooth()) para visualizar a relação entre duas variáveis numéricas. Um gráfico de dispersão é provavelmente o gráfico mais usado para visualizar a relação entre duas variáveis numéricas
"

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

penguins %>% ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

#----1.5.4 Três ou mais variáveis----
#------------------------------------
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
#---------------------------------
"
Depois de criar um gráfico, talvez você queira tirá-lo do R salvando-o cmo uma imagem que possa ser usada em outro lugar. Esse é o objetivo da função ggsave(), que salvará no computador o gráfico criado mais recentemente:
"
penguins %>% ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)
ggsave(filename = "penguin-plot.png")
#----1.7 Problemas Comuns----
#----------------------------
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
#-----------------
"
Neste capítulo, você aprendeu os fundamentos da visualização de dados com o ggplot2. Começamos com a ideia básica que sustenta o ggplot2: uma visualização é um mapeamento de variáveis em seus dados para atributos estéticos como posição (position), cor (color), tamanho (size) e forma (shape). Em seguida, você aprendeu a aumentar a complexidade e melhorar a apresentação de seus gráficos camada por camada. Você também aprendeu sobre gráficos comumente usados para visualizar a distribuição de uma única variável, bem como para visualizar relações entre duas ou mais variáveis ao utilizar mapeamentos de atributos estéticos adicionais e/ou dividindo seu gráfico em pequenos gráficos usando facetas.
"
