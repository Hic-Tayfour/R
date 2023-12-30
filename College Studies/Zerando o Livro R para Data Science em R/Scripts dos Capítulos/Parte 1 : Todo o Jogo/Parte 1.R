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