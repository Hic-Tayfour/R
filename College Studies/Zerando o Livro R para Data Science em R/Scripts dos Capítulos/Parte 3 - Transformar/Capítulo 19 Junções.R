#----Capítulo 19 : Junções----
#=============================

#----19.1 Introdução----
#-----------------------
"
É raro que uma análise de dados envolva apenas um único quadro de dados. Normalmente você tem muitos quadros de dados e deve juntá-los para responder às perguntas que lhe interessam. Este capítulo apresentará a você dois tipos importantes de junções:
"
  #1º Junções mutantes, que adicionam novas variáveis a um quadro de dados a partir de observações correspondentes em outro.
  #2º Junções de filtragem, que filtram observações de um quadro de dados com base em se correspondem ou não a uma observação em outro.

"
Começaremos discutindo chaves, as variáveis usadas para conectar um par de quadros de dados em uma junção. Solidificamos a teoria com uma análise das chaves nos conjuntos de dados do pacote nycflights13, e então usamos esse conhecimento para começar a juntar quadros de dados. Em seguida, discutiremos como as junções funcionam, focando em sua ação nas linhas. Concluiremos com uma discussão sobre junções não-equivalentes, uma família de junções que oferece uma maneira mais flexível de combinar chaves do que a relação de igualdade padrão.
"

#----19.1.1 Pré-requisitos----
#-----------------------------
"
Neste capítulo, exploraremos os cinco conjuntos de dados relacionados de nycflights13 usando as funções de junção do dplyr.
"
library(tidyverse)
library(nycflights13)

#----19.2 Chaves----
#-------------------
"
Para entender junções, você precisa primeiro entender como duas tabelas podem ser conectadas por meio de um par de chaves, dentro de cada tabela. Nesta seção, você aprenderá sobre os dois tipos de chaves e verá exemplos de ambos nos conjuntos de dados do pacote nycflights13. Você também aprenderá como verificar se suas chaves são válidas e o que fazer se sua tabela não tiver uma chave.
"

#----19.2.1 Chaves primárias e estrangeiras----
#----------------------------------------------
"
Toda junção envolve um par de chaves: uma chave primária e uma chave estrangeira. Uma chave primária é uma variável ou conjunto de variáveis que identifica exclusivamente cada observação. Quando mais de uma variável é necessária, a chave é chamada de chave composta. Por exemplo, em nycflights13:
"
  #1º airlines registra dois dados sobre cada companhia aérea: seu código de transportadora e seu nome completo. Você pode identificar uma companhia aérea com seu código de transportadora de duas letras, tornando 'carrier' a chave primária.
airlines

  #2º airports registra dados sobre cada aeroporto. Você pode identificar cada aeroporto pelo seu código de aeroporto de três letras, tornando 'faa' a chave primária.
airports

  #3º planes registra dados sobre cada avião. Você pode identificar um avião pelo seu número de cauda, tornando 'tailnum' a chave primária.
planes

  #4º weather registra dados sobre o clima nos aeroportos de origem. Você pode identificar cada observação pela combinação de localização e hora, tornando 'origin' e 'time_hour' a chave primária composta.
weather

"
Uma chave estrangeira é uma variável (ou conjunto de variáveis) que corresponde a uma chave primária em outra tabela. Por exemplo:
"
  #1º flights$tailnum é uma chave estrangeira que corresponde à chave primária planes$tailnum.
  #2º lights$carrier é uma chave estrangeira que corresponde à chave primária airlines$carrier.
  #3º flights$origin é uma chave estrangeira que corresponde à chave primária airports$faa.
  #4º flights$dest é uma chave estrangeira que corresponde à chave primária airports$faa.
  #5º flights$origin-flights$time_hour é uma chave estrangeira composta que corresponde à chave primária composta weather$origin-weather$time_hour.

"
Você notará um bom recurso no design dessas chaves: as chaves primárias e estrangeiras quase sempre têm os mesmos nomes, o que, como você verá em breve, tornará sua vida de junção muito mais fácil. Também vale a pena notar o relacionamento oposto: quase todos os nomes de variáveis usados em várias tabelas têm o mesmo significado em cada lugar. Há apenas uma exceção: 'year' significa ano de partida em flights e ano de fabricação em planes. Isso se tornará importante quando começarmos a juntar as tabelas.
"

#----19.2.2 Verificação de chaves primárias----
#----------------------------------------------
"
Agora que identificamos as chaves primárias em cada tabela, é uma boa prática verificar se elas realmente identificam exclusivamente cada observação. Uma maneira de fazer isso é contar (count()) as chaves primárias e procurar por entradas onde n é maior que um. Isso revela que planes e weather parecem bons:
"
planes |> 
  count(tailnum) |> 
  filter(n > 1)

weather |> 
  count(time_hour, origin) |> 
  filter(n > 1)

"
Você também deve verificar se há valores ausentes em suas chaves primárias — se um valor está ausente, então ele não pode identificar uma observação!
"
planes |> 
  filter(is.na(tailnum))

weather |> 
  filter(is.na(time_hour) | is.na(origin))


#----19.2.3 Chaves substitutas----
#---------------------------------
"
Até agora, não falamos sobre a chave primária para flights. Não é super importante aqui, porque não há quadros de dados que a utilizem como chave estrangeira, mas ainda é útil considerar porque é mais fácil trabalhar com observações se tivermos alguma maneira de descrevê-las para os outros.

Após um pouco de reflexão e experimentação, determinamos que há três variáveis que juntas identificam exclusivamente cada voo:
"
flights |> 
  count(time_hour, carrier, flight) |> 
  filter(n > 1)

"
A ausência de duplicatas automaticamente torna time_hour-carrier-flight uma chave primária? Certamente é um bom começo, mas não garante isso. Por exemplo, altitude e latitude são uma boa chave primária para aeroportos?
"
airports |>
  count(alt, lat) |> 
  filter(n > 1)

"
Identificar um aeroporto pela sua altitude e latitude é claramente uma má ideia, e em geral não é possível saber apenas pelos dados se uma combinação de variáveis é uma boa chave primária. Mas para flights, a combinação de time_hour, carrier e flight parece razoável porque seria realmente confuso para uma companhia aérea e seus clientes se houvesse vários voos com o mesmo número de voo no ar ao mesmo tempo.

Dito isso, talvez seja melhor introduzir uma simples chave substituta numérica usando o número da linha:
"
flights2 <- flights |> 
  mutate(id = row_number(), .before = 1)
flights2

"
Chaves substitutas podem ser particularmente úteis ao se comunicar com outros humanos: é muito mais fácil dizer a alguém para dar uma olhada no voo 2001 do que dizer olhe para o UA430 que partiu às 9h de 2013-01-03.
"

#----19.3 Junções básicas----
#----------------------------
"
Agora que você entende como os quadros de dados estão conectados por meio de chaves, podemos começar a usar junções para entender melhor o conjunto de dados de voos. O dplyr fornece seis funções de junção: left_join(), inner_join(), right_join(), full_join(), semi_join() e anti_join(). Todas têm a mesma interface: elas recebem um par de quadros de dados (x e y) e retornam um quadro de dados. A ordem das linhas e colunas na saída é determinada principalmente por x.

Nesta seção, você aprenderá como usar uma junção mutante, left_join(), e duas junções de filtragem, semi_join() e anti_join(). Na próxima seção, você aprenderá exatamente como essas funções funcionam e sobre as restantes inner_join(), right_join() e full_join().
"

#----19.3.1 Junções mutantes----
#-------------------------------
"
Uma junção mutante permite combinar variáveis de dois quadros de dados: primeiro, ela combina observações pelas suas chaves e, em seguida, copia as variáveis de um quadro de dados para o outro. Como o mutate(), as funções de junção adicionam variáveis à direita, então se seu conjunto de dados tem muitas variáveis, você não verá as novas. Para esses exemplos, facilitaremos a visualização do que está acontecendo criando um conjunto de dados mais estreito com apenas seis variáveis:
"
flights2 <- flights |> 
  select(year, time_hour, origin, dest, tailnum, carrier)
flights2

"
Existem quatro tipos de junção mutante, mas há uma que você usará quase todo o tempo: left_join(). Ela é especial porque a saída sempre terá as mesmas linhas de x, o quadro de dados ao qual você está se juntando. O principal uso de left_join() é adicionar metadados adicionais. Por exemplo, podemos usar left_join() para adicionar o nome completo da companhia aérea aos dados flights2:
"
flights2 |>
  left_join(airlines)

"
Ou poderíamos descobrir a temperatura e a velocidade do vento quando cada avião partiu:
"
flights2 |> 
  left_join(weather |> select(origin, time_hour, temp, wind_speed))

"
Ou que tipo de avião estava voando:
"
flights2 |> 
  left_join(planes |> select(tailnum, type, engines, seats))

"
Quando left_join() não encontra uma correspondência para uma linha em x, ela preenche as novas variáveis com valores ausentes. Por exemplo, não há informações sobre o avião com número de cauda N3ALAA, então o tipo, motores e assentos estarão ausentes:
"
flights2 |> 
  filter(tailnum == "N3ALAA") |> 
  left_join(planes |> select(tailnum, type, engines, seats))

"
Voltaremos a este problema algumas vezes no restante do capítulo.
"

#----19.3.2 Especificando chaves de junção----
#---------------------------------------------
"
Por padrão, left_join() usará todas as variáveis que aparecem em ambos os quadros de dados como a chave de junção, a chamada junção natural. Essa é uma heurística útil, mas nem sempre funciona. Por exemplo, o que acontece se tentarmos juntar flights2 com o conjunto de dados completo de planes?
"
flights2 |> 
  left_join(planes)

"
Obtemos muitas correspondências ausentes porque nossa junção está tentando usar tailnum e year como uma chave composta. Tanto flights quanto planes têm uma coluna year, mas elas significam coisas diferentes: flights$year é o ano em que o voo ocorreu e planes$year é o ano em que o avião foi construído. Queremos apenas juntar pelo tailnum, então precisamos fornecer uma especificação explícita com join_by():
"
flights2 |> 
  left_join(planes, join_by(tailnum))

"
Observe que as variáveis year são desambiguadas na saída com um sufixo (year.x e year.y), que indica se a variável veio do argumento x ou y. Você pode substituir os sufixos padrão com o argumento suffix.

join_by(tailnum) é uma abreviação de join_by(tailnum == tailnum). É importante saber sobre essa forma mais completa por dois motivos. Primeiramente, ela descreve a relação entre as duas tabelas: as chaves devem ser iguais. É por isso que esse tipo de junção é frequentemente chamado de junção equi.

Em segundo lugar, é assim que você especifica diferentes chaves de junção em cada tabela. Por exemplo, existem duas maneiras de juntar a tabela flight2 e airports: seja por dest ou por origin:
"
flights2 |> 
  left_join(airports, join_by(dest == faa))

flights2 |> 
  left_join(airports, join_by(dest == faa))

"
Em códigos mais antigos, você pode ver uma maneira diferente de especificar as chaves de junção, usando um vetor de caracteres:
"
  #1º by = "x" corresponde a join_by(x).
  #2º by = c("a" = "x") corresponde a join_by(a == x).

"
Agora que existe, preferimos join_by() já que ele fornece uma especificação mais clara e flexível.

inner_join(), right_join(), full_join() têm a mesma interface que left_join(). A diferença é quais linhas eles mantêm: o left join mantém todas as linhas em x, o right join mantém todas as linhas em y, o full join mantém todas as linhas em x ou y, e o inner join apenas mantém linhas que ocorrem em ambos x e y.
"

#----19.3.3 Junções de filtragem----
#-----------------------------------
"
Como você pode imaginar, a ação principal de uma junção de filtragem é filtrar as linhas. Existem dois tipos: semi-junções e anti-junções. As semi-junções mantêm todas as linhas em x que têm uma correspondência em y. Por exemplo, poderíamos usar uma semi-junção para filtrar o conjunto de dados de aeroportos para mostrar apenas os aeroportos de origem:
"
airports |> 
  semi_join(flights2, join_by(faa == origin))

"
Ou apenas os destinos:
"
airports |> 
  semi_join(flights2, join_by(faa == dest))

"
As anti-junções são o oposto: elas retornam todas as linhas em x que não têm uma correspondência em y. Elas são úteis para encontrar valores ausentes que são implícitos nos dados. Valores ausentes implicitamente não aparecem como NAs, mas em vez disso existem apenas como uma ausência. Por exemplo, podemos encontrar linhas que estão ausentes em aeroportos procurando por voos que não têm um aeroporto de destino correspondente:
"
flights2 |> 
  anti_join(airports, join_by(dest == faa)) |> 
  distinct(dest)

"
Ou podemos encontrar quais tailnums estão ausentes de planes:
"
flights2 |>
  anti_join(planes, join_by(tailnum)) |> 
  distinct(tailnum)


#----19.4 Como funcionam as junções?----
#---------------------------------------
"
Agora que você já usou junções algumas vezes, é hora de aprender mais sobre como elas funcionam, focando em como cada linha em x corresponde às linhas em y. Começaremos introduzindo uma representação visual das junções, usando tibbles simples definidos abaixo . Nestes exemplos, usaremos uma única chave chamada 'key' e uma única coluna de valor (val_x e val_y), mas as ideias se generalizam para múltiplas chaves e múltiplos valores.
"
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

"
Para descrever um tipo específico de junção, indicamos as correspondências com pontos. As correspondências determinam as linhas na saída, um novo quadro de dados que contém a chave, os valores x e os valores y. 

Podemos aplicar os mesmos princípios para explicar as junções externas, que mantêm observações que aparecem em pelo menos um dos quadros de dados. Essas junções funcionam adicionando uma observação 'virtual' adicional a cada quadro de dados. Esta observação tem uma chave que corresponde se nenhuma outra chave corresponder, e valores preenchidos com NA. Existem três tipos de junções externas:
"
  #1º Uma junção à esquerda mantém todas as observações em x. Cada linha de x é preservada na saída porque pode recorrer a corresponder a uma linha de NAs em y.
  #2º Uma junção à direita mantém todas as observações em y. Cada linha de y é preservada na saída porque pode recorrer a corresponder a uma linha de NAs em x. A saída ainda corresponde a x tanto quanto possível; quaisquer linhas extras de y são adicionadas ao final.
  #3º Uma junção completa mantém todas as observações que aparecem em x ou y. Cada linha de x e y é incluída na saída porque tanto x quanto y têm uma linha de reserva de NAs. Novamente, a saída começa com todas as linhas de x, seguidas pelas linhas de y não correspondidas restantes.

"
Outra maneira de mostrar como os tipos de junção externa diferem é com um diagrama de Venn. No entanto, esta não é uma ótima representação porque, embora possa lembrar quais linhas são preservadas, ela não ilustra o que está acontecendo com as colunas.

As junções mostradas aqui são as chamadas junções equi, onde as linhas correspondem se as chaves forem iguais. As junções equi são o tipo mais comum de junção, então normalmente omitiremos o prefixo equi e diremos apenas 'junção interna' em vez de 'junção interna equi'. Voltaremos às junções não-equi mais a frente.
"

#----19.4.1 Correspondência de linhas----
#----------------------------------------
"
Até agora, exploramos o que acontece se uma linha em x corresponder a zero ou uma linha em y. O que acontece se ela corresponder a mais de uma linha? Para entender o que está acontecendo, vamos primeiro restringir nosso foco para o inner_join().

Existem três resultados possíveis para uma linha em x:
"
  #1º Existem três resultados possíveis para uma linha em x:
  #2º Se corresponder a 1 linha em y, será preservada.
  #3º Se corresponder a mais de 1 linha em y, será duplicada uma vez para cada correspondência.

"
Em princípio, isso significa que não há uma correspondência garantida entre as linhas na saída e as linhas em x, mas na prática, isso raramente causa problemas. No entanto, há um caso particularmente perigoso que pode causar uma explosão combinatória de linhas. Imagine juntar as seguintes duas tabelas:
"
df1 <- tibble(key = c(1, 2, 2), val_x = c("x1", "x2", "x3"))
df1

df2 <- tibble(key = c(1, 2, 2), val_y = c("y1", "y2", "y3"))
df2

"
Enquanto a primeira linha em df1 corresponde apenas a uma linha em df2, a segunda e terceira linhas correspondem a duas linhas. Isso às vezes é chamado de junção muitos-para-muitos e fará com que o dplyr emita um aviso:
"
df1 |> 
  inner_join(df2, join_by(key))

"
Se você estiver fazendo isso deliberadamente, você pode definir relationship = 'many-to-many', como o aviso sugere.
"

#----19.4.2 Junções de filtragem----
#-----------------------------------
"
O número de correspondências também determina o comportamento das junções de filtragem. A semi-junção mantém linhas em x que têm uma ou mais correspondências em y. A anti-junção mantém linhas em x que correspondem a zero linhas em y. Em ambos os casos, apenas a existência de uma correspondência é importante; não importa quantas vezes ela corresponde. Isso significa que as junções de filtragem nunca duplicam linhas como as junções mutantes fazem.
"

#----19.5 Junções não-equivalentes----
#-------------------------------------
"
Até agora, você só viu junções equi, junções onde as linhas correspondem se a chave x for igual à chave y. Agora vamos relaxar essa restrição e discutir outras maneiras de determinar se um par de linhas corresponde.

Mas antes de fazer isso, precisamos revisitar uma simplificação que fizemos acima. Em junções equi, as chaves x e y são sempre iguais, então só precisamos mostrar uma na saída. Podemos solicitar que o dplyr mantenha ambas as chaves com keep = TRUE, levando ao código abaixo e ao inner_join() redesenhado.
"
x |> inner_join(y, join_by(key == key), keep = TRUE)

"
Quando nos afastamos das junções equi, sempre mostraremos as chaves, porque os valores das chaves geralmente serão diferentes. Por exemplo, em vez de corresponder apenas quando x$key e y$key são iguais, poderíamos corresponder sempre que x$key for maior ou igual a y$key. As funções de junção do dplyr entendem essa distinção entre junções equi e não equi, então sempre mostrarão ambas as chaves quando você realizar uma junção não equi.

Junção não equi não é um termo particularmente útil porque só diz o que a junção não é, não o que ela é. O dplyr ajuda identificando quatro tipos particularmente úteis de junção não equi:
"
  #1º Junções cruzadas correspondem a cada par de linhas.
  #2º Junções de desigualdade usam <, <=, > e >= em vez de ==.
  #3º Junções rolantes são semelhantes às junções de desigualdade, mas só encontram a correspondência mais próxima.
  #4º Junções de sobreposição são um tipo especial de junção de desigualdade projetada para trabalhar com intervalos.

"
Cada uma delas é descrita em mais detalhes nas seções seguintes.
"

#----19.5.1 Junções cruzadas----
#-------------------------------
"
Uma junção cruzada corresponde a tudo gerando o produto cartesiano de linhas. Isso significa que a saída terá nrow(x) * nrow(y) linhas.

Junções cruzadas são úteis ao gerar permutações. Por exemplo, o código abaixo gera todos os possíveis pares de nomes. Como estamos juntando df a si mesmo, isso às vezes é chamado de auto-junção. Junções cruzadas usam uma função de junção diferente porque não há distinção entre inner/left/right/full quando você está correspondendo a cada linha.
"
df <- tibble(name = c("John", "Simon", "Tracy", "Max"))
df |> cross_join(df)

#----19.5.2 Junções de desigualdade----
#--------------------------------------
"
Junções de desigualdade usam <, <=, >= ou > para restringir o conjunto de correspondências possíveis.

Junções de desigualdade são extremamente gerais, tão gerais que é difícil encontrar casos de uso específicos significativos. Uma pequena técnica útil é usá-las para restringir a junção cruzada, de modo que, em vez de gerar todas as permutações, geramos todas as combinações:
"
df <- tibble(id = 1:4, name = c("John", "Simon", "Tracy", "Max"))

df |> inner_join(df, join_by(id < id))

#----19.5.3 Junções rolantes----
#-------------------------------
"
Junções rolantes são um tipo especial de junção de desigualdade onde, em vez de obter todas as linhas que satisfazem a desigualdade, você obtém apenas a linha mais próxima. Você pode transformar qualquer junção de desigualdade em uma junção rolante adicionando closest(). Por exemplo, join_by(closest(x <= y)) corresponde ao menor y que é maior ou igual a x, e join_by(closest(x > y)) corresponde ao maior y que é menor que x.

Junções rolantes são particularmente úteis quando você tem duas tabelas de datas que não se alinham perfeitamente e você quer encontrar (por exemplo) a data mais próxima na tabela 1 que vem antes (ou depois) de alguma data na tabela 2.

Por exemplo, imagine que você está encarregado da comissão de planejamento de festas do seu escritório. Sua empresa é um pouco econômica, então, em vez de ter festas individuais, você só tem uma festa a cada trimestre. As regras para determinar quando uma festa será realizada são um pouco complexas: festas são sempre às segundas-feiras, você pula a primeira semana de janeiro, já que muitas pessoas estão de férias, e a primeira segunda-feira do terceiro trimestre de 2022 é 4 de julho, então isso precisa ser adiado uma semana. Isso leva aos seguintes dias de festa:
"
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03"))
)

"
Agora imagine que você tem uma tabela de aniversários dos funcionários:
"
set.seed(123)
employees <- tibble(
  name = sample(babynames::babynames$name, 100),
  birthday = ymd("2022-01-01") + (sample(365, 100, replace = TRUE) - 1)
)
employees

"
E para cada funcionário, queremos encontrar a primeira data de festa que vem depois (ou no) aniversário deles. Podemos expressar isso com uma junção rolante:
"
employees |> 
  left_join(parties, join_by(closest(birthday >= party)))

"
No entanto, há um problema com essa abordagem: as pessoas com aniversários antes de 10 de janeiro não têm festa:
"
employees |> 
  anti_join(parties, join_by(closest(birthday >= party)))

"
Para resolver essa questão, precisaremos abordar o problema de uma maneira diferente, com junções de sobreposição.
"

#----19.5.4 Junções de sobreposição----
#--------------------------------------
"
As junções de sobreposição fornecem três ajudantes que usam junções de desigualdade para facilitar o trabalho com intervalos:
"
  #1º between(x, y_lower, y_upper) é uma abreviação para x >= y_lower, x <= y_upper.
  #2º within(x_lower, x_upper, y_lower, y_upper) é uma abreviação para x_lower >= y_lower, x_upper <= y_upper.
  #3º within(x_lower, x_upper, y_lower, y_upper) é uma abreviação para x_lower >= y_lower, x_upper <= y_upper.

"
Vamos continuar o exemplo de aniversário para ver como você pode usá-los. Há um problema com a estratégia que usamos acima: não há festa antes dos aniversários de 1 a 9 de janeiro. Então, talvez seja melhor ser explícito sobre os intervalos de datas que cada festa abrange e fazer um caso especial para esses aniversários no início do ano:
"
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
  start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
  end = ymd(c("2022-04-03", "2022-07-11", "2022-10-02", "2022-12-31"))
)
parties

"
Hadley é terrivelmente ruim em inserir dados, então ele também queria verificar se os períodos das festas não se sobrepõem. Uma maneira de fazer isso é usar uma auto-junção para verificar se algum intervalo de início e fim se sobrepõe a outro:
"
parties |> 
  inner_join(parties, join_by(overlaps(start, end, start, end), q < q)) |> 
  select(start.x, end.x, start.y, end.y)

"
Opa, há uma sobreposição, então vamos corrigir esse problema e continuar:
"
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
  start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
  end = ymd(c("2022-04-03", "2022-07-10", "2022-10-02", "2022-12-31"))
)

parties

"
Agora podemos combinar cada funcionário com sua festa. Este é um bom lugar para usar unmatched = 'error' porque queremos descobrir rapidamente se algum funcionário não foi designado para uma festa.
"
employees |> 
  inner_join(parties, join_by(between(birthday, start, end)), unmatched = "error")
