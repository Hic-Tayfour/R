#Capítulo 3 : Transformação de Dados
# ==================================

#----3.1 Introdução----
#----------------------
"
A visualização é uma ferramenta importante para gerar insights, mas é raro obter os dados da maeneira que você precisa para fazer o gráfico que você precisa. As vezes você irá precisar criar novas variáveis para ou resumos (summaries) para responder às suas perguntas com os seus dados, ou talvez você apenas queira renomear as variáveis ou reordenar as observações para tornar os dados mais faceis de serem trabalhados.
Você vai aprender a fazer tudo isso e muito mais neste capítulo, que irá ensinar a transformação de dados atravês do dplyr e uma base de dados sobre voos que partiram de Nova York em 2013.
O objetivo deste capítulo é apresentar uma visão geral de todas as ferramnetas-chave para a transformação de um data frame.
Vamos começar com funções que operam em linhas e depois em colunas de um data frame, depois voltar a falar mais sobre o comando pipe ( %>% ) , uma ferramenta essencial para concatenar ações.
Vamos introduzir a habilidade de trabalhar com grupos.
Terminaremos esse capítulo com estudo de um caso que mostra a aplicação das fuctions.
"


#----3.1.1 Pré-Requisitos----
#----------------------------
"
Vamos nos concentrar no pacote dplyr, constituite do tidyverse. Vamos aplica-lo na base dados nycflights12, e usar o ggplot2 para entender melhor dados
"
library(nycflights13)
library(tidyverse)



#----3.1.2 nycflights13----
#--------------------------
"
Para explorar o básico do dplyr, vamos usar o nycflights::flights. Essa base de dados possui um total de 336776 voos que partiram de Nova York em 2013
"
nycflights13::flights

?flights

"
O flights é um tibble, um tipo especial de data frame usado pelo tidyverse para evitar certos problemas. A principal diferenaça entre os data frames e as tibbles é forma que elas são impressas; Elas são projetadas para grandes dados, então elas só mostram as primeiras linhas e apenas as colunas que cabem na tela. Há formas de visualizar mais dados. No RStudio você pode usar o comando View(flights) , para ver as colunas, você pode usar o glimpse(flights)
"
View(flights)
glimpse(flights)

"Há nesse timbble variáveis inteiras (integer;int) , variáveis reais (double;dbl), variáveis texto (string;str) e variáveis de data-time (dttm)"



#----3.1.3 Básico de Dplyr----
#-----------------------------
"
Vamos começar a aprender as utilidades do dplyr (functions) que permitirão resolver grande parte dos problemas dos desafios de manipulação de dados, mas antes temos que pontuar conceitos essenciais para trabalhar com o comando pipe e a biblioteca dplyr:
  1º O primeiro argumento é sempre um data frame
  2º Os argumentso seguintes serão operações que serão realizadas
  3º O resultado disso será um novo data frame
Veremos mais a frente o funcionamento mais detalhado do comando pipe %>%. Mas trabalhamos ela anteriormente e a seguir haverá um exemplo de sua aplicação de maneira bem intuitiva
"

flights %>% 
  filter(dest== "IAH") %>% 
  group_by(year,month,day) %>% 
  summarise(
    arr_delay=mean(arr_delay, na.rm = TRUE)
  )
"
As funções do dplyr são organizados em quatro grupos com base no que operam : Linhas(row), Colunas(columns), Grupos(groups) e Tabelas(tables). Veremos cada uma delas mais a frente, vendo as functions mais importantes de cada uma e finalizar com as functions de junção para as tabelas
"


#----3.2 Linhas (Row's)----
#--------------------------
"
As functions mais importantes que operam em linhas de um conjunto de dadis são: filter(), que muda quais as linhas que estão presentes sem mudar sua ordem, e arrange() que muda a ordem das linhas sem mudar o que estão presentes nelas.
Ambas as funções só afetam as linhas, as colunas permanecem inalteradas. Vamos falar sobre a função distinct() responsável por achar linhas com valores únicos, mas essa pode acabar por interferindo nas colunas 
"
#3.2.1 Filter()
"
Essa função filter() permite manter as linhas com base nos valores das colunas. O primeiro argumento é o data frame, o segundo e os argumentos subsequentes seriam são condições que deve, ser fidedignos para manter a análise.
Por exemplo, quero encontrar todos os voos que partiram a mais de 120 min de atraso:
"
flights %>% 
  filter(dep_delay > 120)
"
Os operadores lógicos ainda se mantém  (maior que), você pode usar (maior ou igual a), (menor que), (menor ou igual a), (igual a) e (não igual a). Você também pode combinar condições com ou para indicar 'e' (verifique ambas as condições) ou com para indicar 'ou' (verifique qualquer condição):> >= < <= == != & , |
"
#Voos que partiram primeiro de janeiro
flights %>% 
  filter(month == 1 & day == 1)

#Voos que partiram em Janeiro ou em Fevereiro
flights %>% 
  filter(month == 1 | month == 2)
"
Ao usar a função de filtro do dplyr, você está gerando o novo data frame a partir do original, podemos salvar esse data frame filtrado em uma variável utilizando do operador de atribuiçao '<-' 
"
um_de_janeiro <- flights %>% 
  filter(month == 1 & day == 1)


#----3.2.2 Erros comuns----
#--------------------------
"
Os erros mais comuns nessa parte das funções de filtragem são a sintaxe dos operadores lógicos, de maneira geral, tendem ser esses as causas dos erros.
"


#----3.2.3 Arrange()----
#-----------------------
"
A funcção arrange() altera a ordem das linhas tomando de base os valores presentes nas colunas. Para isso é necessário um data frame e um conjunto de colunas nomeadas. Se for fornecido mais de uma coluna, cada coluna adicional será usada para quebrar laços nos valores das colunas anteriores.
Por exemplo, os códigos pela hora de partida, que é espalhado em quatro colunas, temos os anos mais rcentes primeiros depois os meses mais recentes de cada ano.
"
flights %>% 
  arrange(year, month, day, dep_time)

"
Você pode também usar a função desc() em uma coluna para reordenar um data frame tomando de base uma coluna em específico, em ordem decrescente. 
Por exemplo, o seguinte código que que ordena os voos dos mais até os menos atrasados.
"
flights %>% 
  arrange(desc(dep_delay))
"
Perceba que o número de linha é o mesmo, porém os a organização dos dados mudou, mas os dados não estão filtrados.
"


#----3.2.4 Distinc()----
#-----------------------
"
A função distinc() é responsável por encontrar todas as linhas com valores únicos no data frame, ,por isso, opera principalmente em linhas. Na maioria das vezes, você pode vir a querer uma combinação diferente de algumas variáveis, então você pode optar por fornecer certas colunas. 
"
#Remova as linhas duplicadas, caso haja
flights %>% 
  distinct()

#Encontre todos os pares de voo com origem e destinos únicos 
flights %>% 
  distinct(origin,dest)

"
Caso quera, você pode manter outras colunas ao filtras linhas únicas, para isso, deve se usar o 
.keep_all=TRUE
"
flights %>% 
  distinct(origin, dest, .keep_all = TRUE )
"
Não é coincidência que todos esses voos distintos estejam no dia 1 de janeiro: distinct() encontrará a primeira ocorrência de uma linha única no conjunto de dados e descartará o 
restante.
Caso queira somente o número de ocorrências, basta trocar o distinct() para count(), e coloque sort=TRUE.
"
flights %>% 
  count(origin, dest, sort = TRUE )


#----3.3 Colunas----
#-------------------
"
Há quatro functions muito importantes que afetam as colunas, poré sem alterar as linhas do data frame. Temos o mutate() ,que adiciona novas colunas que derivam das colunas já existentes.Temos o rename() ,que altera o nome das colunas que já existentes.Temos o relocate() ,que altera a ordem que as colunas aparecem.
"


#----3.3.1 Mutate()----
#----------------------
"
A função do mutate() em si é adicionar novas colunas que são calculadas a partir das colunas existentes. Mais a frente veremos outras funções que podemos usar para manipulação de outras viriáveis.
Por enquanto irá ficar com uma algebra básica, que nos permitirá calcular o gain do avião e sua velocidade média em horas
"
flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    speed=distance/air_time * 60
  )
"
Por padrão, as colunas criadas pelo mutate() são adicionadas no lado direito do data frame, o que dificulta a visualização dependendo do tamanho de dados, Para auxiliar na visualizar essas novas colunas, podemos usar a função before para que essas novas colunas sejam adicionadas no lado esquerdo do data frame
"
flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    speed=distance/air_time * 60 ,
    .before = 1
  )
"O . é um sinal de que o .before é um argumento para a função e não o nome de uma terceira variável que criamos. Temos também o .after para adicionar depois de uma variável, podemos usar os dois simultaenamente. Podemos até indicar onde queremos que essas colunas sejam inseridas. Por exemplo queremos que essas variáveis após a coluna day:"

flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    speed=distance/air_time * 60,
    .after=day
  )
"
Além disso, você pode controlar quais serão as variáveis serão mantidas com o .keep como argumento. Um argumento útil é o 'used' que epecifica que só serão mantidas as colunas usadas no mutate(). 
Por exemplo, o seguinte exemplo manterá o dep_delay, arr_delay, air_time, gain, hours, gain_per_hour
"
flights %>% 
  mutate(
    gain=dep_delay - arr_delay ,
    hours=air_time/60 ,
    gain_per_hour=gain/hours ,
    .keep = "used"
  )
"
Os calculos feitos nas variáveis acima, nãoserão salvos, serão somente impressas. Caso quisermos salvar esses resultados futuros podemos atribuir esses resultados em uma nova variável ou sobrepor esses resultados na mesma base de dados, Mas tenha cuidado caso salvemos na base de dados original, pois estariámos apagando os dados originais. 
"


#----3.3.2 Select()----
#----------------------
"
Não é incomum termos um conjunto de dados com diversas variáveis. Nestes casos, o principal desafio é focar nas pricipais variáveis que te interessa. Select() perimte que você foque nas variáveis que você acha interssante analizar, dando um 'zoom' nos dados.
Há diversas formas de usar essa função:
"
#1º Selecionando as colunas pelos seus nomes
flights %>% 
  select(year, month, day)

#2º Selecionando da primeira até a ultima coluna do intervalo dado
flights %>% 
  select(year:day)

#3º Não selecionando a primeira coluna até a ultima coluna do intervalo dado
flights %>% 
  select(!year:day)

"
Historicamente, está operação de 'exclusão' de colunas é feito com - em vez do ! , então não estranhe quando você encontrar o - em um select.
"
#4º Selecionando todas as colunas que as variáveis são characters
flights %>% 
  select(where(is.character))

#Bonus:
"
starts_with('abc'): corresponde a nomes que começam com 'abc'.
ends_with('xyz''): corresponde a nomes que terminam com 'xyz'.
contains('ijk'): corresponde a nomes que contêm 'ijk'.
num_range('x'', 1:3): partidas , e .x1 x2 x3
"
"Dúvidas pordem ser sanadas usando a função help. 
Conhecendo o funcionamento básico do select, auxiliará no uso da função matches() para selecionar variáveis que tenham o mesmo padrão
"
"
Podemos ainda usar o select() para renomear as colunas usando o operador = . O Novo nome deve ficar do lado esquerdo, enquanto o nome original deve ficar no lado direito do operador.
"
flights %>% 
  select(tail_num = tailnum)


#----3.3.3 Rename()----
"
Se você quiser manter todas as variáveis existentes e apenas deseja renomear algumas, você pode usar rename() em vez de select():
"
flights %>% 
  rename(tail_num = tailnum)
"
Se você tem um monte de colunas com nomes inconsistentes e seria rediso corrigi-las todas manualmente, confira janitor::clean_names(), que oferece algumas opções úteis de limpeza automática.
"
#----3.3.4 Relocate()----
#------------------------
"
Use relocate() para mover variáveis. Você pode querer agrupar variáveis relacionadas ou mover variáveis importantes para a frente. Por padrão, relocate() move variáveis para a frente:
"
flights %>% 
  relocate(time_hour, air_time)

"
Você também pode especificar onde colocá-las usando os argumentos .before e .after, assim como em mutate():
"

flights %>% 
  relocate(year:dep_time, .after = time_hour)

flights %>% 
  relocate(starts_with("arr") , .before = dep_time)

#----3.4 Pipe (Encademaneto)----
#-------------------------------
"
Nós mostramos exemplos simples do uso do pipe acima, mas seu verdadeiro poder surge quando você começa a combinar múltiplas ações. Por exemplo, imagine que você queria encontrar os voos mais rápidos para o aeroporto IAH de Houston: você precisa combinar filter(), mutate(), select() e arrange():
"
flights %>% 
  filter(dest == "IAH") %>% 
  mutate(speed = distance / air_time * 60) %>% 
  select(year:day, dep_time, carrier, flight, speed) %>% 
  arrange(desc(speed))

"
Embora este pipeline tenha quatro etapas, é fácil de ler porque as ações aparecem no início de cada linha: comece com os dados de voos, depois filtre, depois altere, depois selecione, depois organize.
O que aconteceria se não tivéssemos o pipe? Poderíamos aninhar cada chamada de função dentro da chamada anterior:
"
arrange(
  select(
    mutate(
      filter(
        flights,
        dest == "IAH"
      ),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)

"
Ou poderíamos usar uma série de objetos intermediários:
"
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance/air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))

"
Embora ambas as formas tenham seu tempo e lugar, o pipe geralmente produz código de análise de dados que é mais fácil de escrever e ler.

Para adicionar o pipe ao seu código, recomendamos usar o atalho de teclado integrado Ctrl/Cmd + Shift + M. Você precisará fazer uma alteração nas opções do seu RStudio para usar |> em vez de %>% como usado nos exemplos anteriores.

Para usar o pipe nativo do R, primeiro certifique de ter o R com a versão 4.1 para cima, se for inferior, terá de atualizar o R e o Rstudio para usar o pipe nativo. Atendo ao requisito de versão, você irá em tools -> Global Options -> Code -> e irá marcar a caixa 'Use native pipe operator |> '
"

#----3.5Grupos----
#-------------------
"
Até agora, você aprendeu sobre funções que trabalham com linhas e colunas. dplyr fica ainda mais poderoso quando você adiciona a capacidade de trabalhar com grupos. Nesta seção, focaremos nas funções mais importantes: group_by(), summarize() e a família de funções slice.
"
#----3.5.1Group_by()----
#------------------------
"
Use group_by() para dividir seu conjunto de dados em grupos significativos para sua análise:
"
flights |> 
  group_by(month)

"
group_by() não altera os dados mas, se você observar atentamente a saída, notará que a saída indica que ela está “agrupada por” mês (Grupos: mês [12]). Isso significa que as operações subsequentes agora funcionarão “por mês”. group_by() adiciona esse recurso agrupado (referido como classe) ao data frame, o que muda o comportamento dos verbos subsequentes aplicados aos dados.
"

#----3.5.2Summarize()----
#------------------------
"
A operação agrupada mais importante é um resumo, que, se usado para calcular uma única estatística resumida, reduz o data frame para ter uma única linha para cada grupo. No dplyr, essa operação é realizada por summarize(), como mostrado no seguinte exemplo, que calcula o atraso médio de partida por mês:
"
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )

"
Algo deu errado e todos os nossos resultados são NAs, o símbolo do R para valor ausente. Isso aconteceu porque alguns dos voos observados tinham dados ausentes na coluna de atraso, e então, quando calculamos a média incluindo esses valores, obtivemos um resultado NA. Por agora diremos à função mean() para ignorar todos os valores ausentes definindo o argumento na.rm para TRUE:
"

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )
"
Você pode criar qualquer número de resumos em uma única chamada para summarize(). Você aprenderá vários resumos úteis nos próximos capítulos, mas um resumo muito útil é n(), que retorna o número de linhas em cada grupo:
"
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

"
Médias e contagens podem levar você por um longo caminho na ciência de dados
"

#----3.5.3As funções de separação/partição----
#---------------------------------------------
"
Há cinco funções práticas que permitem extrair linhas específicas dentro de cada grupo:
"

#1º df |> slice_head(n = 1) pega a primeira linha de cada grupo.
#2º df |> slice_tail(n = 1) pega a última linha em cada grupo.
#3º df |> slice_min(x, n = 1) pega a linha com o menor valor da coluna x.
#4º df |> slice_max(x, n = 1) pega a linha com o maior valor da coluna x.
#5º df |> slice_sample(n = 1) pega uma linha aleatória.

"
Você pode variar n para selecionar mais de uma linha, ou, em vez de n =, você pode usar prop = 0.1 para selecionar (por exemplo) 10% das linhas em cada grupo. Por exemplo, o seguinte código encontra os voos que estão mais atrasados ​​na chegada a cada destino:
"
flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n=1) |>
  relocate(dest)
"
Note que existem 105 destinos, mas obtemos 108 linhas aqui. O que está acontecendo? slice_min() e slice_max() mantêm valores empatados, então n = 1 significa que nos dê todas as linhas com o valor mais alto. Se você quiser exatamente uma linha por grupo, você pode definir with_ties = FALSE.

Isso é semelhante a calcular o atraso máximo com summarize(), mas você obtém a linha inteira correspondente (ou linhas, se houver um empate) em vez da única estatística resumida
"

#----3.5.4Agrupando por Multiplas Variáveis----
#----------------------------------------------
"
Você pode criar grupos usando mais de uma variável. Por exemplo, poderíamos criar um grupo para cada data.
"
daily <- flights |> 
  group_by(year, month, day)

View(daily)
glimpse(daily)

"
Quando você resume um tibble agrupado por mais de uma variável, cada resumo descarta o último grupo. Em retrospecto, essa não foi uma maneira muito boa de fazer essa função funcionar, mas é difícil mudar sem quebrar o código existente. Para tornar óbvio o que está acontecendo, o dplyr exibe uma mensagem que informa como você pode alterar esse comportamento:
"
daily_flights <- daily |> summarize(n = n())

View(daily_flights)
glimpse(daily_flights)

"
Se você estiver satisfeito com esse comportamento, pode solicitá-lo explicitamente para suprimir a mensagem:
"
daily_flights <- daily |> 
  summarize(
    n = n(),
    .groups = "drop_last"
  )
"
Alternativamente, mude o comportamento padrão definindo um valor diferente, por exemplo, 'drop' para descartar todos os agrupamentos ou 'keep' para preservar os mesmos grupos.
"

#----3.5.5Desagrupando----
#-------------------------
"
Você também pode querer remover o agrupamento de um data frame sem usar summarize(). Você pode fazer isso com ungroup()
"
daily |> 
  ungroup()

"
Agora vamos ver o que acontece quando você resume um data frame sem agrupamento.
"

daily |> 
  ungroup() |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  )

"
Você recebe uma única linha de volta porque o dplyr trata todas as linhas em um data frame sem agrupamento como pertencentes a um único grupo.
"
#----3.5.6 .by----
#-------------------------
"
O dplyr 1.1.0 inclui uma nova sintaxe experimental para agrupamento por operação, o argumento .by. group_by() e ungroup() não vão desaparecer, mas agora você também pode usar o argumento .by para agrupar dentro de uma única operação:
"
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )
"
Ou se você quiser agrupar por múltiplas variáveis:
"
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin,dest)
  )
"
O dplyr 1.1.0 inclui uma nova sintaxe experimental para agrupamento por operação, o argumento .by. group_by() e ungroup() não vão desaparecer, mas agora você também pode usar o argumento .by para agrupar dentro de uma única operação:
  
  Ou se você quiser agrupar por múltiplas variáveis:
  
  .by funciona com todos os verbos e tem a vantagem de que você não precisa usar o argumento .groups para suprimir a mensagem de agrupamento ou ungroup() quando terminar.

Não focamos nessa sintaxe neste capítulo porque ela era muito nova quando escrevemos o livro. No entanto, queríamos mencioná-la porque achamos que ela tem muito potencial e é provável que seja bastante popular.
"

#----3.6 Estudo de Caso : agregados e tamanho da amostra----
#-----------------------------------------------------------
"
Sempre que você faz qualquer agregação, é sempre uma boa ideia incluir uma contagem (n()). Assim, você pode garantir que não está tirando conclusões baseadas em quantidades muito pequenas de dados. Demonstraremos isso com alguns dados de beisebol do pacote Lahman. Especificamente, compararemos qual proporção de vezes um jogador consegue um acerto (H) versus o número de vezes que tentam colocar a bola em jogo (AB):
"
batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
batters

"
Quando plotamos a habilidade do rebatedor (medida pela média de rebatidas, desempenho) contra o número de oportunidades de acertar a bola (medido por vezes no bastão, n), você vê dois padrões:
"

# A variação no desempenho é maior entre os jogadores com menos rebatidas. A forma deste gráfico é muito característica: sempre que você plota uma média (ou outras estatísticas resumidas) vs. tamanho do grupo, você verá que a variação diminui à medida que o tamanho da amostra aumenta4.

# Há uma correlação positiva entre habilidade (desempenho) e oportunidades de acertar a bola (n) porque os times querem dar a seus melhores rebatedores as maiores oportunidades de acertar a bola.

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x= n , y = performance))+
  geom_point(alpha = 1 / 10 )+
  geom_smooth(se = FALSE)
"
Note o padrão útil para combinar ggplot2 e dplyr. Você só precisa lembrar de mudar de |>, para processamento de dados, para + para adicionar camadas ao seu gráfico.

Isso também tem implicações importantes para classificação. Se você ordenar ingenuamente por desc(performance), as pessoas com as melhores médias de rebatidas são claramente as que tentaram colocar a bola em jogo poucas vezes e conseguiram um acerto, mas não são necessariamente os jogadores mais habilidosos:
"
batters |>
  arrange(desc(performance))
