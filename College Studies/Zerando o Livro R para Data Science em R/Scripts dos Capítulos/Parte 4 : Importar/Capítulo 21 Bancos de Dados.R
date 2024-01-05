#----Capítulo 21 : Bancos de Dados
#=================================

#----21.1 Introdução----
#-----------------------
"
Uma enorme quantidade de dados está armazenada em bancos de dados, então é essencial que você saiba como acessá-los. Às vezes, você pode pedir a alguém para baixar um instantâneo em um arquivo .csv para você, mas isso rapidamente se torna penoso: toda vez que precisar fazer uma alteração, você terá que se comunicar com outro ser humano. Você quer ser capaz de acessar o banco de dados diretamente para obter os dados de que precisa, quando precisar.

Neste capítulo, você aprenderá primeiro os fundamentos do pacote DBI: como usá-lo para se conectar a um banco de dados e, em seguida, recuperar dados com uma consulta SQL. SQL, abreviação de structured query language (linguagem de consulta estruturada), é a língua franca dos bancos de dados e é uma linguagem importante para todos os cientistas de dados aprenderem. Dito isso, não vamos começar com SQL, mas em vez disso, ensinaremos dbplyr, que pode traduzir seu código dplyr para SQL. Usaremos isso como uma maneira de ensinar algumas das características mais importantes do SQL. Você não se tornará um mestre em SQL ao final do capítulo, mas será capaz de identificar os componentes mais importantes e entender o que eles fazem.
"

#----21.1.1 Pré-requisitos----
#-----------------------------
"
Neste capítulo, apresentaremos o DBI e o dbplyr. O DBI é uma interface de baixo nível que se conecta a bancos de dados e executa SQL; o dbplyr é uma interface de alto nível que traduz seu código dplyr em consultas SQL e depois as executa com o DBI.
"
library(DBI)
library(dbplyr)
library(tidyverse)

#----21.2 Fundamentos de Banco de Dados----
#------------------------------------------
"
No nível mais simples, você pode pensar em um banco de dados como uma coleção de quadros de dados, chamados de tabelas na terminologia de banco de dados. Como um quadro de dados, uma tabela de banco de dados é uma coleção de colunas nomeadas, onde cada valor na coluna é do mesmo tipo. Existem três diferenças de alto nível entre quadros de dados e tabelas de banco de dados:
"
  #1º Tabelas de banco de dados são armazenadas em disco e podem ser arbitrariamente grandes. Quadros de dados são armazenados na memória e são fundamentalmente limitados (embora esse limite ainda seja bastante grande para muitos problemas).
  #2º Tabelas de banco de dados quase sempre têm índices. Muito parecido com o índice de um livro, um índice de banco de dados torna possível encontrar rapidamente linhas de interesse sem ter que olhar para cada linha individual. Quadros de dados e tibbles não têm índices, mas data.tables têm, o que é uma das razões pelas quais são tão rápidos.
  #3º A maioria dos bancos de dados clássicos é otimizada para coletar dados rapidamente, não para analisar dados existentes. Esses bancos de dados são chamados de orientados a linhas porque os dados são armazenados linha por linha, em vez de coluna por coluna como no R. Mais recentemente, houve muito desenvolvimento de bancos de dados orientados a colunas que tornam a análise dos dados existentes muito mais rápida.

"
Os bancos de dados são gerenciados por sistemas de gerenciamento de bancos de dados (SGDBs, abreviados), que vêm em três formas básicas:
"
  #1º SGDBs cliente-servidor são executados em um poderoso servidor central, ao qual você se conecta a partir do seu computador (o cliente). Eles são ótimos para compartilhar dados com várias pessoas em uma organização. SGDBs cliente-servidor populares incluem PostgreSQL, MariaDB, SQL Server e Oracle.
  #2º SGDBs em nuvem, como Snowflake, Amazon's RedShift e Google's BigQuery, são semelhantes aos SGDBs cliente-servidor, mas são executados na nuvem. Isso significa que eles podem lidar facilmente com conjuntos de dados extremamente grandes e podem fornecer automaticamente mais recursos de computação conforme necessário.
  #3º SGDBs em processo, como SQLite ou duckdb, são executados inteiramente no seu computador. Eles são ótimos para trabalhar com grandes conjuntos de dados onde você é o principal usuário.

#----21.3 Conectando a um Banco de Dados----
#-------------------------------------------
"
Para se conectar ao banco de dados do R, você usará um par de pacotes:
"
  #1º Você sempre usará o DBI (interface de banco de dados) porque ele fornece um conjunto de funções genéricas que se conectam ao banco de dados, carregam dados, executam consultas SQL, etc.
  #2º Você também usará um pacote personalizado para o SGDB ao qual está se conectando. Este pacote traduz os comandos genéricos do DBI para as especificidades necessárias para um determinado SGDB. Geralmente, há um pacote para cada SGDB, por exemplo, RPostgres para PostgreSQL e RMariaDB para MySQL.

"
Se você não encontrar um pacote específico para o seu SGDB, geralmente pode usar o pacote odbc em vez disso. Isso usa o protocolo ODBC suportado por muitos SGDBs. O odbc requer um pouco mais de configuração porque você também precisará instalar um driver ODBC e informar ao pacote odbc onde encontrá-lo.

Concretamente, você cria uma conexão de banco de dados usando DBI::dbConnect(). O primeiro argumento seleciona o SGDB, e o segundo e os argumentos subsequentes descrevem como se conectar a ele (ou seja, onde ele está localizado e as credenciais necessárias para acessá-lo). O código a seguir mostra alguns exemplos típicos:
"

"con <- DBI::dbConnect(
  RMariaDB::MariaDB(), 
  username = 'foo'
)
#con <- DBI::dbConnect(
  RPostgres::Postgres(), 
  hostname = 'databases.mycompany.com', 
  port = 1234
)"

#----21.3.1 Neste livro----
#--------------------------
"
Configurar um SGDB cliente-servidor ou em nuvem seria complicado para este livro, então, em vez disso, usaremos um SGDB em processo que vive inteiramente em um pacote R: duckdb. Graças à magia do DBI, a única diferença entre usar duckdb e qualquer outro SGDB é como você se conectará ao banco de dados. Isso o torna ótimo para ensinar, porque você pode facilmente executar este código e também aplicar facilmente o que aprendeu em outros lugares.

Conectar-se ao duckdb é particularmente simples porque os padrões criam um banco de dados temporário que é excluído quando você sai do R. Isso é ótimo para aprender, porque garante que você começará do zero toda vez que reiniciar o R:
"
con <- DBI::dbConnect(duckdb::duckdb())

"
O duckdb é um banco de dados de alto desempenho projetado muito para as necessidades de um cientista de dados. Usamo-lo aqui porque é muito fácil começar, mas também é capaz de lidar com gigabytes de dados com grande velocidade. Se você quiser usar o duckdb para um projeto de análise de dados real, também precisará fornecer o argumento dbdir para criar um banco de dados persistente e dizer ao duckdb onde salvá-lo. Supondo que você esteja usando um projeto, é razoável armazená-lo no diretório duckdb do projeto atual.
"
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")

#----21.3.2 Carregar alguns dados----
#------------------------------------
"
Já que este é um novo banco de dados, precisamos começar adicionando alguns dados. Aqui, adicionaremos os conjuntos de dados mpg e diamonds do ggplot2 usando DBI::dbWriteTable(). O uso mais simples de dbWriteTable() precisa de três argumentos: uma conexão de banco de dados, o nome da tabela a ser criada no banco de dados e um quadro de dados.
"
#dbWriteTable(con, "mpg", ggplot2::mpg)
#dbWriteTable(con, "diamonds", ggplot2::diamonds)

"
Se você estiver usando o duckdb em um projeto real, recomendamos fortemente aprender sobre duckdb_read_csv() e duckdb_register_arrow(). Eles oferecem maneiras poderosas e eficientes de carregar rapidamente dados diretamente no duckdb, sem ter que primeiro carregá-los no R. Também mostraremos uma técnica útil para carregar vários arquivos em um banco de dados.
"

#----21.3.3 Fundamentos do DBI----
#---------------------------------
"
Você pode verificar se os dados foram carregados corretamente usando algumas outras funções do DBI: dbListTables() lista todas as tabelas no banco de dados e dbReadTable() recupera o conteúdo de uma tabela.
"
dbListTables(con)

con |> 
  dbReadTable("diamonds") |> 
  as_tibble()

"
dbReadTable() retorna um data.frame, então usamos as_tibble() para convertê-lo em um tibble para que ele seja impresso de maneira agradável.

Se você já conhece SQL, pode usar dbGetQuery() para obter os resultados da execução de uma consulta no banco de dados:
"
sql <- "
  SELECT carat, cut, clarity, color, price 
  FROM diamonds 
  WHERE price > 15000
"
as_tibble(dbGetQuery(con, sql))

"
Se você nunca viu SQL antes, não se preocupe! Você aprenderá mais sobre isso em breve. Mas se você lê-lo com atenção, pode adivinhar que ele seleciona cinco colunas do conjunto de dados de diamonds e todas as linhas onde o preço é maior que 15000.
"

#----21.4 Fundamentos do dbplyr----
#----------------------------------
"
Agora que nos conectamos a um banco de dados e carregamos alguns dados, podemos começar a aprender sobre o dbplyr. O dbplyr é um backend do dplyr, o que significa que você continua escrevendo código dplyr, mas o backend executa de forma diferente. Neste caso, o dbplyr traduz para SQL; outros backends incluem dtplyr que traduz para data.table e multidplyr que executa seu código em vários núcleos.

Para usar o dbplyr, você deve primeiro usar tbl() para criar um objeto que representa uma tabela de banco de dados:
"
diamonds_db <- tbl(con, "diamonds")
diamonds_db

"
Existem duas outras maneiras comuns de interagir com um banco de dados. Primeiro, muitos bancos de dados corporativos são muito grandes, então você precisa de alguma hierarquia para manter todas as tabelas organizadas. Nesse caso, você pode precisar fornecer um esquema ou um catálogo e um esquema para escolher a tabela de seu interesse:
"
#diamonds_db <- tbl(con, in_schema("sales", "diamonds"))
#diamonds_db <- tbl(con, in_catalog("north_america", "sales", "diamonds"))

"
Outras vezes, você pode querer usar sua própria consulta SQL como ponto de partida:
"
#diamonds_db <- tbl(con, sql("SELECT * FROM diamonds"))

"
Este objeto é preguiçoso; quando você usa funções dplyr nele, o dplyr não faz nenhum trabalho: ele apenas registra a sequência de operações que você deseja realizar e as executa apenas quando necessário. Por exemplo, pegue o seguinte pipeline:
"
big_diamonds_db <- diamonds_db |> 
  filter(price > 15000) |> 
  select(carat:clarity, price)

big_diamonds_db

"
Você pode dizer que este objeto representa uma consulta de banco de dados porque ele imprime o nome do SGDB no topo, e embora ele informe o número de colunas, normalmente não sabe o número de linhas. Isso ocorre porque encontrar o número total de linhas geralmente requer a execução da consulta completa, algo que estamos tentando evitar.

Você pode ver o código SQL gerado pela função dplyr show_query(). Se você conhece dplyr, esta é uma ótima maneira de aprender SQL! Escreva algum código dplyr, obtenha a tradução para SQL pelo dbplyr e, em seguida, tente descobrir como os dois idiomas se correspondem.
"
big_diamonds_db |>
  show_query()

"
Para obter todos os dados de volta para o R, você chama collect(). Nos bastidores, isso gera o SQL, chama dbGetQuery() para obter os dados e, em seguida, transforma o resultado em um tibble:
"
big_diamonds <- big_diamonds_db |> 
  collect()
big_diamonds

"
Normalmente, você usará o dbplyr para selecionar os dados que deseja do banco de dados, realizando filtragem básica e agregação usando as traduções descritas abaixo. Depois, quando estiver pronto para analisar os dados com funções exclusivas do R, você coletará os dados para obter um tibble na memória e continuará seu trabalho com código R puro.
"

#----21.5 SQL----
#----------------
"
Daqui em diante vamos ensinar um pouco de SQL através da ótica do dbplyr. É uma introdução bastante não tradicional ao SQL, mas esperamos que ela o ajude a se familiarizar rapidamente com o básico. Felizmente, se você entende dplyr, você está em uma ótima posição para aprender rapidamente SQL, porque muitos dos conceitos são os mesmos.

Exploraremos a relação entre dplyr e SQL usando alguns velhos amigos do pacote nycflights13: flights e planes. Esses conjuntos de dados são fáceis de inserir em nosso banco de dados de aprendizado porque o dbplyr vem com uma função que copia as tabelas de nycflights13 para o nosso banco de dados:
"
dbplyr::copy_nycflights13(con)

flights <- tbl(con, "flights")
planes <- tbl(con, "planes")

#----21.5.1 Fundamentos do SQL----
#---------------------------------
"
Os componentes de nível superior do SQL são chamados de instruções. Instruções comuns incluem CREATE para definir novas tabelas, INSERT para adicionar dados e SELECT para recuperar dados. Nos concentraremos nas instruções SELECT, também chamadas de consultas, porque são quase exclusivamente o que você usará como cientista de dados.

Uma consulta é composta de cláusulas. Há cinco cláusulas importantes: SELECT, FROM, WHERE, ORDER BY e GROUP BY. Toda consulta deve ter as cláusulas SELECT e FROM, e a consulta mais simples é SELECT * FROM table, que seleciona todas as colunas da tabela especificada. Isso é o que o dbplyr gera para uma tabela não modificada:
"
flights |> show_query()
planes |> show_query()

"
WHERE e ORDER BY controlam quais linhas são incluídas e como são ordenadas:
"
flights |> 
  filter(dest == "IAH") |> 
  arrange(dep_delay) |>
  show_query()

"
GROUP BY converte a consulta em um resumo, fazendo com que a agregação aconteça:
"
flights |> 
  group_by(dest) |> 
  summarize(dep_delay = mean(dep_delay, na.rm = TRUE)) |> 
  show_query()

"
Há duas diferenças importantes entre os funções dplyr e as cláusulas SELECT:
"
  #1º No SQL, o caso não importa: você pode escrever select, SELECT ou até SeLeCt. Neste livro, vamos seguir a convenção comum de escrever palavras-chave SQL em maiúsculas para distingui-las de nomes de tabelas ou variáveis.
  #2º No SQL, a ordem importa: você deve sempre escrever as cláusulas na ordem SELECT, FROM, WHERE, GROUP BY, ORDER BY. Confusamente, essa ordem não corresponde a como as cláusulas são realmente avaliadas, que é primeiro FROM, depois WHERE, GROUP BY, SELECT e ORDER BY.

"
As seções seguintes exploram cada cláusula em mais detalhes.

Note que, embora o SQL seja um padrão, ele é extremamente complexo e nenhum banco de dados o segue exatamente. Embora os principais componentes em que nos concentraremos neste livro sejam muito semelhantes entre os SGDBs, há muitas variações menores. Felizmente, o dbplyr foi projetado para lidar com esse problema e gera diferentes traduções para diferentes bancos de dados. Não é perfeito, mas está continuamente melhorando, e se você encontrar um problema, pode abrir um problema no GitHub para nos ajudar a fazer melhor.
"

#----21.5.2 SELECT----
#---------------------
"
A cláusula SELECT é o cavalo de batalha das consultas e realiza o mesmo trabalho que select(), mutate(), rename(), relocate() e, como você aprenderá na próxima seção, summarize().

select(), rename() e relocate() têm traduções muito diretas para SELECT, pois afetam apenas onde uma coluna aparece (se aparecer) junto com seu nome:
"
planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  show_query()

planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  rename(year_built = year) |> 
  show_query()

planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  relocate(manufacturer, model, .before = type) |> 
  show_query()

"
Este exemplo também mostra como o SQL faz a renomeação. No SQL, a renomeação é chamada de aliasing e é feita com AS. Observe que, ao contrário de mutate(), o nome antigo está à esquerda e o novo nome está à direita.

Nos exemplos acima, note que 'year' e 'type' estão envolvidos em aspas duplas. Isso ocorre porque são palavras reservadas no duckdb, então o dbplyr as coloca entre aspas para evitar qualquer confusão potencial entre nomes de colunas/tabelas e operadores SQL.

Ao trabalhar com outros bancos de dados, é provável que você veja todos os nomes de variáveis entre aspas, porque apenas alguns pacotes clientes, como duckdb, sabem quais são todas as palavras reservadas, então eles colocam tudo entre aspas para garantir a segurança.
"
#SELECT "tailnum", "type", "manufacturer", "model", "year"
#FROM "planes"

"
Alguns outros sistemas de banco de dados usam crases em vez de aspas:
"
#SELECT `tailnum`, `type`, `manufacturer`, `model`, `year`
#FROM `planes`

"
As traduções para mutate() são igualmente diretas: cada variável se torna uma nova expressão em SELECT:
"
flights |> 
  mutate(
    speed = distance / (air_time / 60)
  ) |> 
  show_query()

"
Voltaremos à tradução de componentes individuais (como /) posteriormente.
"

#----21.5.3 FROM----
#-------------------
"
A cláusula FROM define a fonte de dados. Ela será um pouco sem graça por um tempo, porque estamos apenas usando tabelas únicas. Você verá exemplos mais complexos quando chegarmos às funções de junção.
"

#----21.5.4 GROUP BY----
#-----------------------
"
group_by() é traduzido para a cláusula GROUP BY e summarize() é traduzido para a cláusula SELECT:
"
diamonds_db |> 
  group_by(cut) |> 
  summarize(
    n = n(),
    avg_price = mean(price, na.rm = TRUE)
  ) |> 
  show_query()

"
Voltaremos ao que está acontecendo com a tradução de n() e mean().
"

#----21.5.5 WHERE----
#--------------------
"
filter() é traduzido para a cláusula WHERE:
"
flights |> 
  filter(dest == "IAH" | dest == "HOU") |> 
  show_query()


flights |> 
  filter(arr_delay > 0 & arr_delay < 20) |> 
  show_query()

"
Há alguns detalhes importantes a serem observados aqui:
"
  #1º | se torna OR e & se torna AND.
  #2º SQL usa = para comparação, não ==. SQL não tem atribuição, então não há potencial para confusão.
  #3º SQL usa apenas '' para strings, não "". No SQL, "" é usado para identificar variáveis, como o `` do R.

"
Outro operador SQL útil é IN, que é muito próximo do %in% do R:
"
flights |> 
  filter(dest %in% c("IAH", "HOU")) |> 
  show_query()

"
SQL usa NULL em vez de NA. Os NULLs se comportam de maneira semelhante aos NAs. A principal diferença é que, enquanto eles são 'infecciosos' em comparações e aritmética, eles são silenciosamente descartados ao resumir. O dbplyr lembrará você sobre esse comportamento na primeira vez que você o encontrar:
"
flights |> 
  group_by(dest) |> 
  summarize(delay = mean(arr_delay))

"
Se você quiser aprender mais sobre como os NULLs funcionam, pode gostar de 'Three valued logic' de Markus Winand.

Em geral, você pode trabalhar com NULLs usando as funções que usaria para NAs no R:
"
flights |> 
  filter(!is.na(dep_delay)) |> 
  show_query()

"
Esta consulta SQL ilustra uma das desvantagens do dbplyr: embora o SQL esteja correto, não é tão simples quanto você poderia escrever à mão. Neste caso, você poderia remover os parênteses e usar um operador especial que é mais fácil de ler:
"
#WHERE "dep_delay" IS NOT NULL

"
Observe que, se você usar filter() em uma variável que você criou usando summarize, o dbplyr gerará uma cláusula HAVING, em vez de uma cláusula WHERE. Essa é uma das idiossincrasias do SQL: WHERE é avaliado antes de SELECT e GROUP BY, então o SQL precisa de outra cláusula que seja avaliada posteriormente.
"
diamonds_db |> 
  group_by(cut) |> 
  summarize(n = n()) |> 
  filter(n > 100) |> 
  show_query()

#----21.5.6 ORDER BY----
#-----------------------
"
Ordenar linhas envolve uma tradução direta de arrange() para a cláusula ORDER BY:
"
flights |> 
  arrange(year, month, day, desc(dep_delay)) |> 
  show_query()

"
Observe como desc() é traduzido para DESC: essa é uma das muitas funções dplyr cujo nome foi diretamente inspirado pelo SQL.
"

#----21.5.7 Subconsultas----
#---------------------------
"
Às vezes, não é possível traduzir um pipeline dplyr em uma única instrução SELECT e você precisa usar uma subconsulta. Uma subconsulta é apenas uma consulta usada como fonte de dados na cláusula FROM, em vez da tabela usual.

O dbplyr normalmente usa subconsultas para contornar limitações do SQL. Por exemplo, expressões na cláusula SELECT não podem se referir a colunas que acabaram de ser criadas. Isso significa que o seguinte pipeline dplyr (tolo) precisa acontecer em duas etapas: a primeira consulta (interna) calcula year1 e, em seguida, a segunda consulta (externa) pode calcular year2.
"
flights |> 
  mutate(
    year1 = year + 1,
    year2 = year1 + 1
  ) |> 
  show_query()

"
Você também verá isso se tentar filtrar uma variável que acabou de criar. Lembre-se de que, mesmo que WHERE seja escrito após SELECT, ele é avaliado antes dele, então precisamos de uma subconsulta neste exemplo (tolo):
"
flights |> 
  mutate(year1 = year + 1) |> 
  filter(year1 == 2014) |> 
  show_query()

"
Às vezes, o dbplyr criará uma subconsulta onde não é necessário porque ainda não sabe como otimizar essa tradução. À medida que o dbplyr melhora com o tempo, esses casos se tornarão mais raros, mas provavelmente nunca desaparecerão.
"
#----21.5.8 Junções----
#----------------------
"
Se você está familiarizado com as junções do dplyr, as junções SQL são muito semelhantes. Aqui está um exemplo simples:
"
flights |> 
  left_join(planes |> rename(year_built = year), by = "tailnum") |> 
  show_query()

"
A principal coisa a se notar aqui é a sintaxe: as junções SQL usam subcláusulas da cláusula FROM para trazer tabelas adicionais, usando ON para definir como as tabelas estão relacionadas.

Os nomes do dplyr para essas funções estão tão intimamente conectados ao SQL que você pode facilmente adivinhar o SQL equivalente para inner_join(), right_join() e full_join():
"
#SELECT flights.*, "type", manufacturer, model, engines, seats, speed
#FROM flights
#INNER JOIN planes ON (flights.tailnum = planes.tailnum)

#SELECT flights.*, "type", manufacturer, model, engines, seats, speed
#FROM flights
#RIGHT JOIN planes ON (flights.tailnum = planes.tailnum)

#SELECT flights.*, "type", manufacturer, model, engines, seats, speed
#FROM flights
#FULL JOIN planes ON (flights.tailnum = planes.tailnum)

"
Você provavelmente precisará de muitas junções ao trabalhar com dados de um banco de dados. Isso ocorre porque as tabelas de banco de dados geralmente são armazenadas em uma forma altamente normalizada, onde cada 'fato' é armazenado em um único lugar e para manter um conjunto de dados completo para análise, você precisa navegar por uma rede complexa de tabelas conectadas por chaves primárias e estrangeiras. Se você encontrar esse cenário, o https://dm.cynkra.com/, por Tobias Schieferdecker, Kirill Müller e Darko Bergant, é um salva-vidas. Ele pode determinar automaticamente as conexões entre as tabelas usando as restrições que os administradores de banco de dados frequentemente fornecem, visualizar as conexões para que você possa ver o que está acontecendo e gerar as junções necessárias para conectar uma tabela a outra.
"

#----21.5.9 Outros verbos----
#----------------------------
"
O dbplyr também traduz outros verbos como distinct(), slice_*(), e intersect(), além de uma crescente seleção de funções do tidyr como pivot_longer() e pivot_wider(). A maneira mais fácil de ver o conjunto completo do que está atualmente disponível é visitar o site do dbplyr: https://dbplyr.tidyverse.org/reference/.
"

#----21.6 Traduções de Funções----
#---------------------------------
"

Até agora, nos concentramos na visão geral de como os verbos do dplyr são traduzidos para as cláusulas de uma consulta. Agora, vamos nos aprofundar um pouco e falar sobre a tradução das funções do R que trabalham com colunas individuais, por exemplo, o que acontece quando você usa mean(x) em um summarize()?

Para ajudar a ver o que está acontecendo, usaremos algumas pequenas funções auxiliares que executam um summarize() ou mutate() e mostram o SQL gerado. Isso tornará um pouco mais fácil explorar algumas variações e ver como os resumos e transformações podem diferir.
"
summarize_query <- function(df, ...) {
  df |> 
    summarize(...) |> 
    show_query()
}

mutate_query <- function(df, ...) {
  df |> 
    mutate(..., .keep = "none") |> 
    show_query()
}

"
Vamos mergulhar em alguns resumos! Olhando o código abaixo, você notará que algumas funções de resumo, como mean(), têm uma tradução relativamente simples, enquanto outras, como median(), são muito mais complexas. A complexidade é tipicamente maior para operações comuns em estatísticas, mas menos comuns em bancos de dados.
"
flights |> 
  group_by(year, month, day) |>  
  summarize_query(
    mean = mean(arr_delay, na.rm = TRUE),
    median = median(arr_delay, na.rm = TRUE)
  )

"
A tradução de funções de resumo se torna mais complicada quando você as usa dentro de um mutate() porque elas precisam se transformar em chamadas funções de janela. No SQL, você transforma uma função de agregação comum em uma função de janela adicionando OVER depois dela:
"
flights |> 
  group_by(year, month, day) |>  
  mutate_query(
    mean = mean(arr_delay, na.rm = TRUE),
  )

"
No SQL, a cláusula GROUP BY é usada exclusivamente para resumos, então aqui você pode ver que o agrupamento mudou do argumento PARTITION BY para OVER.

Funções de janela incluem todas as funções que olham para frente ou para trás, como lead() e lag(), que olham para o valor 'anterior' ou 'próximo', respectivamente:
"
flights |> 
  group_by(dest) |>  
  arrange(time_hour) |> 
  mutate_query(
    lead = lead(arr_delay),
    lag = lag(arr_delay)
  )

"
Aqui é importante usar arrange() nos dados, porque as tabelas SQL não têm ordem intrínseca. De fato, se você não usar arrange(), pode receber as linhas em uma ordem diferente a cada vez! Observe que, para funções de janela, as informações de ordenação são repetidas: a cláusula ORDER BY da consulta principal não se aplica automaticamente a funções de janela.

Outra função SQL importante é CASE WHEN. É usada como a tradução de if_else() e case_when(), a função dplyr que ela diretamente inspirou. Aqui estão alguns exemplos simples:
"
flights |> 
  mutate_query(
    description = if_else(arr_delay > 0, "delayed", "on-time")
  )

flights |> 
  mutate_query(
    description = 
      case_when(
        arr_delay < -5 ~ "early", 
        arr_delay < 5 ~ "on-time",
        arr_delay >= 5 ~ "late"
      )
  )

"
CASE WHEN também é usado para algumas outras funções que não têm uma tradução direta do R para SQL. Um bom exemplo disso é cut():
"
flights |> 
  mutate_query(
    description =  cut(
      arr_delay, 
      breaks = c(-Inf, -5, 5, Inf), 
      labels = c("early", "on-time", "late")
    )
  )

"
O dbplyr também traduz funções comuns de manipulação de strings e datas, sobre as quais você pode aprender no vignette('translation-function', package = 'dbplyr'). As traduções do dbplyr certamente não são perfeitas, e há muitas funções do R que ainda não são traduzidas, mas o dbplyr faz um trabalho surpreendentemente bom cobrindo as funções que você usará na maior parte do tempo.
"
