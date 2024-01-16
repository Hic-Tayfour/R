#----Capítulo 26 : Iteração
#==========================

#----26.1 Introdução----
#-----------------------
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
#-----------------------------
"
Aqui nos concentraremos em ferramentas fornecidas pelo dplyr e purrr, ambos membros centrais do tidyverse. Você já viu o dplyr antes, mas o purrr é novidade. Vamos usar apenas algumas funções do purrr neste capítulo, mas é um ótimo pacote para explorar à medida que você aprimora suas habilidades de programação.
"
library(tidyverse)

#----26.2 Modificando múltiplas colunas----
#------------------------------------------
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
#---------------------------------------------
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
#----------------------------------------
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
#-----------------------------------------
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
#-------------------------------
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
#------------------------
"
across() é uma ótima combinação para summarize() e mutate(), mas é mais complicado de usar com filter(), porque você geralmente combina múltiplas condições com | ou &. É claro que across() pode ajudar a criar múltiplas colunas lógicas, mas e depois? Então, o dplyr fornece duas variantes de across() chamadas if_any() e if_all():
"
# same as df_miss |> filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))
df_miss |> filter(if_any(a:d, is.na))

# same as df_miss |> filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))
df_miss |> filter(if_all(a:d, is.na))

#----26.2.6 across() em funções----
#----------------------------------
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
#--------------------------------
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
#-------------------------------------
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
#------------------------------------------------
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
#---------------------
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
#------------------------------------------
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
#-------------------------------
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
#--------------------------------
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
#---------------------------------------
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
#---------------------------------
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
#--------------------------------
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
#--------------------------------------
"
Você aprendeu sobre map(), que é útil para ler vários arquivos em um único objeto. Nesta seção, agora exploraremos o tipo oposto de problema: como você pode pegar um ou mais objetos R e salvá-los em um ou mais arquivos? Vamos explorar esse desafio usando três exemplos:
"
  #1º Salvando múltiplos data frames em um único banco de dados.
  #2º Salvando múltiplos data frames em vários arquivos .csv.
  #3º Salvando múltiplos gráficos em vários arquivos .png.

#----26.4.1 Escrevendo em um banco de dados----
#----------------------------------------------
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
#-------------------------------------
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
#--------------------------------
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
