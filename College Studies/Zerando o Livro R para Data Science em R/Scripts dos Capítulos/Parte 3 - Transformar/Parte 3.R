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
