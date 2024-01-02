#Capítulo 17 : Datas e Horas
#===========================

#----17.1 Introdução----
#-----------------------
"
Este capítulo mostrará como trabalhar com datas e horas em R. À primeira vista, datas e horas parecem simples. Você as usa o tempo todo em sua vida cotidiana, e elas não parecem causar muita confusão. No entanto, quanto mais você aprende sobre datas e horas, mais complicadas elas parecem!

Para aquecer, pense em quantos dias há em um ano e quantas horas há em um dia. Você provavelmente se lembrou de que a maioria dos anos tem 365 dias, mas os anos bissextos têm 366. Você sabe a regra completa para determinar se um ano é um ano bissexto? O número de horas em um dia é um pouco menos óbvio: a maioria dos dias tem 24 horas, mas em lugares que usam o horário de verão (DST), um dia a cada ano tem 23 horas e outro tem 25.

Datas e horas são difíceis porque têm que conciliar dois fenômenos físicos (a rotação da Terra e sua órbita ao redor do sol) com uma série de fenômenos geopolíticos, incluindo meses, fusos horários e horário de verão. Este capítulo não ensinará todos os detalhes sobre datas e horas, mas fornecerá uma base sólida de habilidades práticas que ajudarão você com desafios comuns de análise de dados.

Começaremos mostrando como criar data-horas a partir de várias entradas e, uma vez que você tenha uma data-hora, como extrair componentes como ano, mês e dia. Em seguida, mergulharemos no complicado tópico de trabalhar com intervalos de tempo, que vêm em uma variedade de sabores, dependendo do que você está tentando fazer. Concluiremos com uma breve discussão sobre os desafios adicionais impostos pelos fusos horários.
"

#----17.1.1 Pré-requisitos----
#-----------------------------
"
Este capítulo se concentrará no pacote lubridate, que facilita o trabalho com datas e horas em R. A partir da última versão do tidyverse, o lubridate faz parte do core tidyverse. Também precisaremos do nycflights13 para dados práticos.
"
library(tidyverse)
library(nycflights13)

#----17.2 Criando data/hora----
#------------------------------
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
#-----------------------------------
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
#-------------------------
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
#-----------------------------------------
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
#------------------------------
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
#-------------------------------------
"
Agora que você sabe como inserir dados de data-hora nas estruturas de data-hora do R, vamos explorar o que você pode fazer com eles. Esta seção se concentrará nas funções de acesso que permitem obter e definir componentes individuais. A próxima seção examinará como a aritmética funciona com data-horas.
"

#----17.3.1 Obtendo componentes----
#----------------------------------
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
#---------------------------
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
#-------------------------------------
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
#-------------------------------
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
#-----------------------
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
#-----------------------
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
#------------------------
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
#---------------------------
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


