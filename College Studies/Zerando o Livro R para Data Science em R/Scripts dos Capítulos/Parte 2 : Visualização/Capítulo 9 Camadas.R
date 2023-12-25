#Capítulo 9 : Camadas
#====================

#----9.1Introdução----
#----------------------
"
Você aprendeu muito mais do que apenas como fazer gráficos de dispersão, gráficos de barras e boxplots. Você aprendeu uma base que pode usar para fazer qualquer tipo de gráfico com o ggplot2.

Agora você expandirá essa base à medida que aprende sobre a gramática em camadas dos gráficos. Começaremos com um mergulho mais profundo em mapeamentos estéticos, objetos geométricos e facetas. Em seguida, você aprenderá sobre as transformações estatísticas que o ggplot2 faz por baixo dos panos ao criar um gráfico. Essas transformações são usadas para calcular novos valores para plotar, como as alturas das barras em um gráfico de barras ou as medianas em um boxplot. Você também aprenderá sobre ajustes de posição, que modificam como os geoms são exibidos em seus gráficos. Por fim, introduziremos brevemente os sistemas de coordenadas.

Não abordaremos todas as funções e opções para cada uma dessas camadas, mas guiaremos você pelas funcionalidades mais importantes e comumente usadas fornecidas pelo ggplot2, bem como o apresentaremos a pacotes que estendem o ggplot2.
"

#----9.1.1Pré-Requesitos----
#----------------------------
"
Focaremos no ggplot2. Para acessar os conjuntos de dados, páginas de ajuda e funções usadas neste capítulo, carregue o tidyverse executando este código:
"
library(tidyverse)
#----9.2Mapeamentos Estéticos----
#---------------------------------
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
#-------------------------------
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
#-------------------
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
#--------------------------------------
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
#------------------------------
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
#-----------------------------------
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
#---------------------------------------------
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