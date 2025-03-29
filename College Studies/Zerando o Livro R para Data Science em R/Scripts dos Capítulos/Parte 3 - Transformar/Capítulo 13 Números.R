#Capítulo 13 : Números
#=====================

#----13.1Introdução----
#----------------------
"
Vetores numéricos são a espinha dorsal da ciência de dados, e você já os usou várias vezes anteriormente no livro. Agora é hora de fazer uma revisão sistemática do que você pode fazer com eles em R, garantindo que você esteja bem preparado para enfrentar qualquer problema futuro envolvendo vetores numéricos.

Começaremos fornecendo algumas ferramentas para criar números a partir de strings e, em seguida, entraremos em mais detalhes sobre a função count(). Depois mergulharemos em várias transformações numéricas que combinam bem com mutate(), incluindo transformações mais gerais que podem ser aplicadas a outros tipos de vetores, mas que são frequentemente usadas com vetores numéricos. Concluiremos cobrindo as funções de resumo que combinam bem com summarize() e mostraremos como elas também podem ser usadas com mutate().
"

#----13.1.1Pré-requisitos----
#----------------------------
"
Este capítulo utiliza principalmente funções do R base, que estão disponíveis sem a necessidade de carregar quaisquer pacotes. Mas ainda precisamos do tidyverse, pois usaremos essas funções do R base dentro de funções do tidyverse como mutate() e filter(). Como no último capítulo, usaremos exemplos reais do nycflights13, bem como exemplos fictícios criados com c() e tribble().
"

library(tidyverse)
library(nycflights13)
#----13.2Criando Números----
#---------------------------
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
#---------------------
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
#-----------------------------------
"
As funções de transformação funcionam bem com mutate() porque sua saída tem o mesmo comprimento que a entrada. A grande maioria das funções de transformação já está integrada ao R base. É impraticável listar todas, então esta seção mostrará as mais úteis. Por exemplo, embora o R forneça todas as funções trigonométricas que você possa imaginar, não as listamos aqui porque raramente são necessárias para ciência de dados.
"

#----13.4.1Regras de Aritméticas e Reciclagem----
#------------------------------------------------
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
#-----------------------------
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
#--------------------------------
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
#------------------------
"
Os logaritmos são uma transformação incrivelmente útil para lidar com dados que variam em várias ordens de magnitude e para converter crescimento exponencial em crescimento linear. No R, você tem a escolha de três logaritmos: log() (o logaritmo natural, base e), log2() (base 2) e log10() (base 10). Recomendamos usar log2() ou log10(). log2() é fácil de interpretar porque uma diferença de 1 na escala logarítmica corresponde a dobrar na escala original e uma diferença de -1 corresponde a dividir pela metade; enquanto log10() é fácil de reverter porque (por exemplo) 3 é 10^3 = 1000. O inverso de log() é exp(); para calcular o inverso de log2() ou log10() você precisará usar 2^ ou 10^.
"

#----13.4.5Arredondamento----
#----------------------------
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
#---------------------------------------------
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
#-----------------------------------------------
"
O R base fornece cumsum(), cumprod(), cummin(), cummax() para somas, produtos, mínimos e máximos acumulados ou contínuos. O dplyr fornece cummean() para médias acumulativas. Somas acumulativas tendem a ser as mais utilizadas na prática:
"
x <- 1:10
cumsum(x)

"
Se você precisar de agregações rolantes ou deslizantes mais complexas, experimente o pacote slider(https://slider.r-lib.org/).
"

#----13.5Transformações Gerais----
#---------------------------------
"
As seções seguintes descrevem algumas transformações gerais que são frequentemente usadas com vetores numéricos, mas podem ser aplicadas a todos os outros tipos de colunas.
"
#----13.5.1Classificações----
#----------------------------
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
#---------------------------
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
#------------------------------------------
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
#-----------------------------
"
Apenas usando as contagens, médias e somas que já introduzimos pode levar você longe, mas o R oferece muitas outras funções de resumo úteis. Aqui está uma seleção que você pode achar útil.
"

#----13.6.1Centro----
#--------------------
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
#--------------------------------------
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
#-----------------------
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
#---------------------------
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
#----------------------
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
#--------------------------
"
Como os nomes sugerem, as funções de resumo são tipicamente emparelhadas com summarize(). No entanto, devido às regras de reciclagem que discutimos anteriormente, elas também podem ser úteis em conjunto com mutate(), particularmente quando você quer fazer algum tipo de padronização de grupo. Por exemplo:
"  
  #1º x / sum(x) calcula a proporção de um total.
  #2º (x - mean(x)) / sd(x) calcula um escore Z (padronizado para média 0 e desvio padrão 1).
  #3º (x - min(x)) / (max(x) - min(x)) padroniza para o intervalo [0, 1].
  #4º x / first(x) calcula um índice baseado na primeira observação.
