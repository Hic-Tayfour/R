#----Capítulo 18 : Valores Ausentes
#==================================

#----18.1 Introdução----
#-----------------------
"
Você já aprendeu o básico sobre valores ausentes anteriormente no livro. Agora, voltaremos a eles com mais profundidade, para que você possa aprender mais detalhes.

Começaremos discutindo algumas ferramentas gerais para trabalhar com valores ausentes registrados como NAs. Em seguida, exploraremos a ideia de valores implicitamente ausentes, valores que simplesmente não estão presentes nos seus dados, e mostraremos algumas ferramentas que você pode usar para torná-los explícitos. Finalizaremos com uma discussão relacionada sobre grupos vazios, causados por níveis de fatores que não aparecem nos dados.
"


#----18.1.1 Pré-requisitos----
#-----------------------------
"
As funções para trabalhar com dados ausentes vêm principalmente do dplyr e tidyr, que são membros essenciais do tidyverse.
"
library(tidyverse)

#----18.2 Valores ausentes explícitos----
#---------------------------------------
"
Para começar, vamos explorar algumas ferramentas úteis para criar ou eliminar valores explícitos ausentes, ou seja, células onde você vê um NA.
"

#----18.2.1 Última observação transportada para frente----
#---------------------------------------------------------
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
#----------------------------
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
#------------------
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
#---------------------------------------
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
#-----------------------
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
#----------------------
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
#---------------------
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
#-----------------------------------
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