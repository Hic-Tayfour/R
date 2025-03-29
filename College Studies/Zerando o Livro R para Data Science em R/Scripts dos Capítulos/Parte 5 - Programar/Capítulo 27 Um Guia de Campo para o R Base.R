#----Capítulo 27 : Um Guia de Campo para o R Base
#================================================

#----27.1 Introdução----
#-----------------------
"
Para finalizar a seção de programação, vamos dar um rápido tour pelas funções mais importantes do R base que não discutimos em outro lugar no livro. Essas ferramentas são particularmente úteis à medida que você faz mais programação e ajudarão você a ler o código que encontrará na prática.

Este é um bom lugar para lembrar que o tidyverse não é a única maneira de resolver problemas de ciência de dados. Nós ensinamos o tidyverse neste
livro porque os pacotes do tidyverse compartilham uma filosofia de design comum, aumentando a consistência entre as funções e tornando cada nova função ou pacote um pouco mais fácil de aprender e usar. Não é possível usar o tidyverse sem usar o R base, então na verdade já ensinamos muitas funções do R base: desde library() para carregar pacotes, até sum() e mean() para resumos numéricos, até os tipos de dados factor, date e POSIXct, e claro, todos os operadores básicos como +, -, /, *, |, &, e !. O que não focamos até agora são os fluxos de trabalho do R base, então vamos destacar alguns deles neste capítulo.

Depois de ler este livro, você aprenderá outras abordagens para os mesmos problemas usando R base, data.table e outros pacotes. Você certamente encontrará essas outras abordagens quando começar a ler o código R escrito por outros, especialmente se estiver usando o StackOverflow. É 100% aceitável escrever código que usa uma mistura de abordagens, e não deixe ninguém lhe dizer o contrário!

Agora vamos nos concentrar em quatro grandes tópicos: subconjunto com [, subconjunto com [[ e $, a família de funções apply e loops for. Para finalizar, discutiremos brevemente duas funções essenciais de plotagem.
"

#----27.1.1 Pré-requisitos----
#-----------------------------
"
Este pacote se concentra no R base, portanto não tem pré-requisitos reais, mas carregaremos o tidyverse para explicar algumas das diferenças.
"
library(tidyverse)

#----27.2 Selecionando múltiplos elementos com [----
#---------------------------------------------------
"
[ é usado para extrair subcomponentes de vetores e data frames, e é chamado como x[i] ou x[i, j]. Nesta seção, apresentaremos a você o poder do [, mostrando primeiro como você pode usá-lo com vetores e, em seguida, como os mesmos princípios se estendem de maneira direta para estruturas bidimensionais (2d) como data frames. Então, ajudaremos você a consolidar esse conhecimento, mostrando como vários verbos do dplyr são casos especiais de [.
"

#----27.2.1 Subconjuntos de vetores----
#-------------------------------------
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
#-----------------------------------------
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
#--------------------------------
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
#------------------------------------------------------
"
[, que seleciona muitos elementos, é pareado com [[ e $, que extraem um único elemento. Nesta seção, mostraremos como usar [[ e $ para extrair colunas de data frames, discutiremos mais algumas diferenças entre data.frames e tibbles, e enfatizaremos algumas diferenças importantes entre [ e [[ quando usados com listas.
"

#----27.3.1 Data frames----
#-------------------------
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
#---------------------
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
#---------------------
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
#-------------------------
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
#---------------------
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
#--------------------
"
Muitos usuários de R que não usam o tidyverse preferem o ggplot2 para plotagem devido a recursos úteis como padrões sensatos, legendas automáticas e uma aparência moderna. No entanto, as funções de plotagem do R base ainda podem ser úteis porque são muito concisas — é preciso muito pouco digitação para fazer um gráfico exploratório básico.

Há dois tipos principais de gráficos base que você verá na prática: gráficos de dispersão e histogramas, produzidos com plot() e hist() respectivamente. Aqui está um exemplo rápido do conjunto de dados diamonds:
"
hist(diamonds$carat)

plot(diamonds$carat, diamonds$price)

"
Observe que as funções de plotagem base funcionam com vetores, então você precisa extrair colunas do data frame usando $ ou alguma outra técnica.
"