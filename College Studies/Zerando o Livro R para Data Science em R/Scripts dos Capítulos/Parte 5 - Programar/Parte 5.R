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