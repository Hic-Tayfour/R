#Capítulo 16: Fatores
#====================

#----16.1 Introdução----
#-----------------------
"
Os fatores são usados para variáveis categóricas, variáveis que têm um conjunto fixo e conhecido de valores possíveis. Eles também são úteis quando você deseja exibir vetores de caracteres em uma ordem não alfabética.

Começaremos motivando por que os fatores são necessários para análise de dados e como você pode criá-los com factor(). Em seguida, vamos apresentá-lo ao conjunto de dados gss_cat, que contém um monte de variáveis categóricas para experimentar. Você usará esse conjunto de dados para praticar a modificação da ordem e dos valores dos fatores, antes de terminarmos com uma discussão sobre fatores ordenados.
"

#----16.1.1 Pré-requisitos----
#-----------------------------
"
O R base fornece algumas ferramentas básicas para criar e manipular fatores. Vamos complementar essas ferramentas com o pacote forcats, que faz parte do core tidyverse. Ele fornece ferramentas para lidar com variáveis categóricas (e é um anagrama de fatores!) usando uma ampla gama de ajudantes para trabalhar com fatores.
"
library(tidyverse)

#----16.2 Noções básicas de fatores----
#-------------------------------------
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
#----------------------------------
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
#-------------------------------------------
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
#---------------------------------------------
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
#-----------------------------
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