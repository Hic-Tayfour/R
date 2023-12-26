#Capítulo 11 : Comunicação
#=========================

#----11.1Introdução----
#----------------------
"
Anteriormente, você aprendeu a usar gráficos como ferramentas para exploração. Quando você faz gráficos exploratórios, você sabe — mesmo antes de olhar — quais variáveis o gráfico irá exibir. Você fez cada gráfico com um propósito, podia olhá-lo rapidamente e então passar para o próximo. No decorrer da maioria das análises, você produzirá dezenas ou centenas de gráficos, a maioria dos quais é descartada imediatamente.

Agora que você entende seus dados, precisa comunicar seu entendimento aos outros. Seu público provavelmente não compartilhará seu conhecimento de fundo e não estará profundamente investido nos dados. Para ajudar os outros a construir rapidamente um bom modelo mental dos dados, você precisará investir um esforço considerável para tornar seus gráficos o mais autoexplicativos possível. Neste capítulo, você aprenderá algumas das ferramentas que o ggplot2 fornece para fazer isso.

Este capítulo se concentra nas ferramentas necessárias para criar bons gráficos. Presumimos que você saiba o que quer e apenas precisa saber como fazer. Por essa razão, recomendamos fortemente que você leia este capítulo em conjunto com um bom livro geral sobre visualização. Gostamos particularmente de 'The Truthful Art', de Albert Cairo. Ele não ensina a mecânica de criar visualizações, mas se concentra no que você precisa pensar para criar gráficos eficazes.
"

#----11.1.1Pré-Requesitos----
#----------------------------
"Focaremos novamente no ggplot2. Também usaremos um pouco de dplyr para manipulação de dados, scales para substituir as divisões, rótulos, transformações e paletas padrão, e alguns pacotes de extensão do ggplot2, incluindo ggrepel (https://ggrepel.slowkow.com) por Kamil Slowikowski e patchwork (https://patchwork.data-imaginist.com) por Thomas Lin Pedersen. Não se esqueça de que você precisará instalar esses pacotes com install.packages() se ainda não os tiver.
"
#install.packages("ggrepel")
#install.packages("patchwork")

library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)

#----11.2Rótulos----
#-------------------
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
#---------------------
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
#-------------------
"
A terceira maneira de tornar seu gráfico melhor para comunicação é ajustar as escalas. As escalas controlam como as mapeamentos estéticos se manifestam visualmente.
"


#----11.4.1Escalas Padrão----
#----------------------------
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
#------------------------------------------------
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
#-------------------------------
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
#-------------------------------------
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
#------------------
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
#-----------------
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
#------------------
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
