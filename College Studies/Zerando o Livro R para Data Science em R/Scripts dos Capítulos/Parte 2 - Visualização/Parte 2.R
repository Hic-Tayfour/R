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

