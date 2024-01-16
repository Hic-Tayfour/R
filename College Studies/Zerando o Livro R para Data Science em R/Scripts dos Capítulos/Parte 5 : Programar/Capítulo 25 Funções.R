#----Capítulo 25 : Funções
#=========================

#----25.1 Introdução----
#-----------------------
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
#-----------------------------
"
Nós concluiremos uma variedade de funções de diferentes partes do tidyverse. Também usaremos nycflights13 como uma fonte de dados familiares para aplicar nossas funções.
"
library(tidyverse)
library(nycflights13)

#----25.2 Funções Vetoriais----
#------------------------------
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
#------------------------------------
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
#--------------------------------------
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
#---------------------------------
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
#--------------------------------
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
#---------------------------------------
"
Funções vetoriais são úteis para extrair código que é repetido dentro de um verbo dplyr. Mas você também frequentemente repetirá os próprios verbos, especialmente dentro de um grande pipeline. Quando você se pegar copiando e colando múltiplos verbos várias vezes, você pode pensar em escrever uma função de data frame. Funções de data frame funcionam como verbos dplyr: elas tomam um data frame como primeiro argumento, alguns argumentos extras que dizem o que fazer com ele e retornam um data frame ou um vetor.

Para permitir que você escreva uma função que usa verbos dplyr, primeiro vamos introduzi-lo ao desafio da indireção e como você pode superá-lo com o conceito de 'embracing', {{ }}. Com essa teoria em mente, então mostraremos uma série de exemplos para ilustrar o que você pode fazer com isso.
"


#----25.3.1 Indireção e Avaliação Tidy----
#-----------------------------------------
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
#------------------------------
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
#----------------------------------
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
#-----------------------------------------------------
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
#--------------------------------
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
#-----------------------------
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
#----------------------------------------------
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
#------------------------
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
#-------------------
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