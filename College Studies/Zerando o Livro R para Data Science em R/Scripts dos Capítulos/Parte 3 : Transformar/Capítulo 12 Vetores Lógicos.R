#Capítulo 12 : Vetores Lógicos 
#=============================

#----12.1Introdução----
#----------------------
"
Neste capítulo, você aprenderá ferramentas para trabalhar com vetores lógicos. Vetores lógicos são o tipo mais simples de vetor porque cada elemento só pode ser um de três valores possíveis: TRUE, FALSE e NA. É relativamente raro encontrar vetores lógicos nos seus dados brutos, mas você os criará e manipulará no decorrer de quase todas as análises.

Começaremos discutindo a maneira mais comum de criar vetores lógicos: com comparações numéricas. Então você aprenderá como pode usar a álgebra booleana para combinar diferentes vetores lógicos, bem como alguns resumos úteis. Terminaremos com if_else() e case_when(), duas funções úteis para fazer mudanças condicionais impulsionadas por vetores lógicos.
"

#----12.1.1Pré-requisitos----
#----------------------------
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
#----------------------
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
#-------------------------------------------
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
#------------------------------
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
#----------------------
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
#----------------------------
"
Uma vez que você tem múltiplos vetores lógicos, pode combiná-los usando álgebra booleana. Em R, & é 'e', | é 'ou', ! é 'não', e xor() é ou exclusivo. Por exemplo, df |> filter(!is.na(x)) encontra todas as linhas onde x não está ausente e df |> filter(x < -10 | x > 0) encontra todas as linhas onde x é menor que -10 ou maior que 0.

Além de & e |, R também tem && e ||. Não os use em funções dplyr! Esses são chamados de operadores de curto-circuito e sempre retornam apenas um TRUE ou FALSE. Eles são importantes para programação, não para ciência de dados.
"
#----12.3.1-Valores ausentes----
#-------------------------------
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
#---------------------------------
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
#------------------
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
#-------------------
"
As seções a seguir descrevem algumas técnicas úteis para resumir vetores lógicos. Além das funções que funcionam especificamente com vetores lógicos, você também pode usar funções que funcionam com vetores numéricos.
"

#----12.4.1Resumos lógicos----
#-----------------------------
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
#--------------------------------------------------
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
#--------------------------------
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
#---------------------------------------
"
Uma das características mais poderosas dos vetores lógicos é o seu uso para transformações condicionais, ou seja, fazer uma coisa para a condição x e algo diferente para a condição y. Há duas ferramentas importantes para isso: if_else() e case_when().
"

#----12.5.1if_else()----
#-----------------------
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
#-------------------------
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
#-------------------------------
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