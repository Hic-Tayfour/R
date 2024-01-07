#Capítulo 20 : Planilhas----

#----20.1 Introdução----
"
Anteriormente você aprendeu sobre a importação de dados de arquivos de texto simples como .csv e .tsv. Agora é hora de aprender como obter dados de uma planilha, seja uma planilha do Excel ou uma planilha do Google. Isso se baseará em muito do que você aprendeu anteriormente, mas também discutiremos considerações e complexidades adicionais ao trabalhar com dados de planilhas.

Se você ou seus colaboradores estão usando planilhas para organizar dados, recomendamos fortemente a leitura do artigo 'Organização de Dados em Planilhas' de Karl Broman e Kara Woo: 
https://doi.org/10.1080/00031305.2017.1375989. As melhores práticas apresentadas neste artigo evitarão muitas dores de cabeça quando você importar dados de uma planilha para o R para analisar e visualizar.
"


#----20.2 Excel----
"
O Microsoft Excel é um programa de software de planilha amplamente utilizado onde os dados são organizados em planilhas dentro de arquivos de planilha.
"

#----20.2.1 Pré-requisitos----
"
Agora, você aprenderá como carregar dados de planilhas do Excel no R com o pacote readxl. Este pacote não é do núcleo do tidyverse, então você precisa carregá-lo explicitamente, mas ele é instalado automaticamente quando você instala o pacote tidyverse. Mais tarde, também usaremos o pacote writexl, que nos permite criar planilhas do Excel.
"
library(readxl)
library(tidyverse)
library(writexl)

#----20.2.2 Começando----
"
A maioria das funções do readxl permite que você carregue planilhas do Excel no R:
"
#1º read_xls() lê arquivos do Excel no formato xls.
#2º read_xlsx() lê arquivos do Excel no formato xlsx.
#3º read_excel() pode ler arquivos nos formatos xls e xlsx. Ele adivinha o tipo de arquivo com base na entrada.

"
Essas funções têm uma sintaxe semelhante, assim como outras funções que introduzimos anteriormente para ler outros tipos de arquivos, por exemplo, read_csv(), read_table(), etc. Pelo restante do capítulo, focaremos no uso de read_excel().
"

#----20.2.3 Lendo planilhas do Excel----
"
A planilha usada nessa parte pode ser encontrada no link abaixo :
https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w/
O primeiro argumento para read_excel() é o caminho para o arquivo a ser lido.
"
students <- read_excel("students.xlsx")
students


"
read_excel() lerá o arquivo como um tibble.

Temos seis estudantes nos dados e cinco variáveis para cada estudante. No entanto, há algumas coisas que podemos querer abordar neste conjunto de dados:
"
#1º Os nomes das colunas estão todos desorganizados. Você pode fornecer nomes de colunas que sigam um formato consistente; recomendamos snake_case usando o argumento col_names.
read_excel(
  "students.xlsx",
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age")
)
#Infelizmente, isso não resolveu completamente o problema. Agora temos os nomes de variáveis que queremos, mas o que era anteriormente a linha de cabeçalho agora aparece como a primeira observação nos dados. Você pode pular explicitamente essa linha usando o argumento skip.

#2º Na coluna favourite_food, uma das observações é N/A, que significa 'não disponível', mas atualmente não é reconhecida como NA (note o contraste entre este N/A e a idade do quarto estudante na lista). Você pode especificar quais strings de caracteres devem ser reconhecidas como NAs com o argumento na. Por padrão, apenas '' (string vazia, ou, no caso de ler de uma planilha, uma célula vazia ou uma célula com a fórmula =NA()) é reconhecida como um NA.
read_excel(
  "students.xlsx",
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A")
)

#3º Outro problema restante é que a idade é lida como uma variável de caráter, mas realmente deveria ser numérica. Assim como com read_csv() e similares para ler dados de arquivos de texto plano, você pode fornecer um argumento col_types para read_excel() e especificar os tipos de coluna para as variáveis que você lê. A sintaxe é um pouco diferente, porém. Suas opções são 'skip', 'guess', 'logical', 'numeric', 'date', 'text' ou 'list'.
read_excel(
  "students.xlsx",
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A"),
  col_types = c("numeric", "text", "text", "text", "numeric")
)
#No entanto, isso também não produziu o resultado desejado. Ao especificar que a idade deve ser numérica, transformamos a uma célula com a entrada não numérica (que tinha o valor five) em um NA. Neste caso, devemos ler a idade como 'text' e, em seguida, fazer a alteração uma vez que os dados estejam carregados no R.

"
Levou-nos várias etapas e tentativa e erro para carregar os dados exatamente no formato que queremos, e isso não é inesperado. A ciência de dados é um processo iterativo, e o processo de iteração pode ser ainda mais tedioso ao ler dados de planilhas em comparação com outros arquivos de dados retangulares de texto simples porque os humanos tendem a inserir dados em planilhas e usá-las não apenas para armazenamento de dados, mas também para compartilhamento e comunicação.

Não há como saber exatamente como os dados parecerão até que você os carregue e dê uma olhada neles. Bem, há uma maneira, na verdade. Você pode abrir o arquivo no Excel e dar uma espiada. Se você for fazer isso, recomendamos fazer uma cópia do arquivo Excel para abrir e navegar interativamente, deixando o arquivo de dados original intocado e lendo no R a partir do arquivo intocado. Isso garantirá que você não sobrescreva acidentalmente nada na planilha ao inspecioná-la. Você também não deve ter medo de fazer o que fizemos aqui: carregar os dados, dar uma olhada, fazer ajustes no seu código, carregar novamente e repetir até ficar satisfeito com o resultado.
"

#----20.2.4 Lendo planilhas de trabalho----
"
Um recurso importante que distingue planilhas de arquivos planos é a noção de múltiplas folhas, chamadas de planilhas. Os dados vêm do pacote palmerpenguins, e você pode baixar esta planilha como um arquivo Excel de :
https://docs.google.com/spreadsheets/d/1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY/. Cada planilha contém informações sobre pinguins de uma ilha diferente onde os dados foram coletados.
Você pode ler uma única planilha de uma planilha com o argumento sheet em read_excel(). O padrão, no qual confiamos até agora, é a primeira planilha.
"
read_excel("penguins.xlsx", sheet = "Torgersen Island")

"
Algumas variáveis que parecem conter dados numéricos são lidas como caracteres devido à string de caracteres 'NA' não ser reconhecida como um verdadeiro NA.
"
penguins_torgersen <- read_excel("penguins.xlsx", sheet = "Torgersen Island", na = "NA")
penguins_torgersen

"
Alternativamente, você pode usar excel_sheets() para obter informações sobre todas as planilhas em uma planilha do Excel e, em seguida, ler aquela(s) que lhe interessam.
"
excel_sheets("penguins.xlsx")

"
Uma vez que você conhece os nomes das planilhas, você pode lê-las individualmente com read_excel().
"
penguins_biscoe <- read_excel("penguins.xlsx", sheet = "Biscoe Island", na = "NA")
penguins_dream  <- read_excel("penguins.xlsx", sheet = "Dream Island", na = "NA")

"
Neste caso, o conjunto de dados completo de penguins está espalhado por três planilhas na planilha. Cada planilha tem o mesmo número de colunas, mas diferentes números de linhas.
"
dim(penguins_torgersen)
dim(penguins_biscoe)
dim(penguins_dream)

"
Podemos juntá-las com bind_rows().
"
penguins <- bind_rows(penguins_torgersen, penguins_biscoe, penguins_dream)
penguins


#----20.2.5 Lendo parte de uma planilha----
"
Como muitos usam planilhas do Excel para apresentação, além de armazenamento de dados, é bastante comum encontrar entradas de células em uma planilha que não fazem parte dos dados que você deseja ler no R. Por exemplo no meio da planilha parece haver um quadro de dados, mas há texto extraneo em células acima e abaixo dos dados.

Essa planilha é uma das planilhas de exemplo fornecidas no pacote readxl. Você pode usar a função readxl_example() para localizar a planilha em seu sistema no diretório onde o pacote está instalado. Essa função retorna o caminho para a planilha, que você pode usar em read_excel() como de costume.
"
deaths_path <- readxl_example("deaths.xlsx")
deaths <- read_excel(deaths_path)
deaths

"
As três primeiras linhas e as últimas quatro linhas não fazem parte do quadro de dados. É possível eliminar essas linhas extraneas usando os argumentos skip e n_max, mas recomendamos usar intervalos de células. No Excel, a célula superior esquerda é A1. Conforme você se move pelas colunas para a direita, o rótulo da célula avança pelo alfabeto, ou seja, B1, C1, etc. E conforme você desce por uma coluna, o número no rótulo da célula aumenta, ou seja, A2, A3, etc.

Aqui, os dados que queremos ler começam na célula A5 e terminam na célula F15. Na notação de planilha, isso é A5:F15, o qual fornecemos ao argumento range:
"
read_excel(deaths_path, range = "A5:F15")

#----20.2.6 Tipos de dados----
"
Em arquivos CSV, todos os valores são strings. Isso não é particularmente verdadeiro para os dados, mas é simples: tudo é uma string.

Os dados subjacentes em planilhas do Excel são mais complexos. Uma célula pode ser uma de quatro coisas:
"
#1º Um booleano, como TRUE, FALSE ou NA.
#2º Um número, como '10' ou '10.5'.
#3º Um datetime, que também pode incluir tempo como '11/1/21' ou '11/1/21 3:00 PM'.
#4º Uma string de texto, como 'ten'.

"
Ao trabalhar com dados de planilha, é importante ter em mente que os dados subjacentes podem ser muito diferentes do que você vê na célula. Por exemplo, o Excel não tem noção de um inteiro. Todos os números são armazenados como pontos flutuantes, mas você pode escolher exibir os dados com um número personalizável de pontos decimais. Da mesma forma, as datas são na verdade armazenadas como números, especificamente o número de segundos desde 1 de janeiro de 1970. Você pode personalizar como exibe a data aplicando formatação no Excel. Confusamente, também é possível ter algo que parece um número, mas na verdade é uma string (por exemplo, digite '10 em uma célula no Excel).

Essas diferenças entre como os dados subjacentes são armazenados vs. como são exibidos podem causar surpresas quando os dados são carregados no R. Por padrão, o readxl adivinhará o tipo de dados em uma determinada coluna. Um fluxo de trabalho recomendado é deixar o readxl adivinhar os tipos de colunas, confirmar que você está satisfeito com os tipos de colunas adivinhados e, se não, voltar e reimportar especificando col_types conforme mostrado anteriormente.

Outro desafio é quando você tem uma coluna em sua planilha do Excel que tem uma mistura desses tipos, por exemplo, algumas células são numéricas, outras texto, outras datas. Ao importar os dados para o R, o readxl tem que tomar algumas decisões. Nestes casos, você pode definir o tipo para esta coluna como 'list', o que carregará a coluna como uma lista de vetores de comprimento 1, onde o tipo de cada elemento do vetor é adivinhado.
"
"
Às vezes, os dados são armazenados de maneiras mais exóticas, como a cor do fundo da célula ou se o texto está em negrito ou não. Nesses casos, você pode achar o pacote tidyxl útil. Veja https://nacnudus.github.io/spreadsheet-munging-strategies/ para mais estratégias de como trabalhar com dados não-tabulares do Excel.
"

#----20.2.7 Escrevendo no Excel----
"
Vamos criar um pequeno quadro de dados que podemos então escrever. Note que 'item' é um fator e 'quantity' é um inteiro.
"
bake_sale <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5, 8)
)

bake_sale

"
Você pode escrever dados de volta para o disco como um arquivo Excel usando write_xlsx() do pacote writexl:
"
write_xlsx(bake_sale, path = "bake-sale.xlsx")

"
Assim como ao ler de um CSV, as informações sobre o tipo de dados são perdidas quando lemos os dados de volta. Isso torna os arquivos Excel também pouco confiáveis para armazenar resultados intermediários.
"
read_excel("bake-sale.xlsx")


#----20.2.8 Saída formatada----
"
O pacote writexl é uma solução leve para escrever uma planilha do Excel simples, mas se você estiver interessado em recursos adicionais, como escrever em planilhas dentro de uma planilha e estilização, você vai querer usar o pacote openxlsx. Não entraremos nos detalhes de como usar este pacote aqui, mas recomendamos a leitura de 
https://ycphs.github.io/openxlsx/articles/Formatting.html para uma discussão extensiva sobre funcionalidades adicionais de formatação para dados escritos do R para o Excel com openxlsx.

Note que este pacote não faz parte do tidyverse, então as funções e fluxos de trabalho podem parecer pouco familiares. Por exemplo, os nomes das funções são em camelCase, múltiplas funções não podem ser compostas em pipelines, e os argumentos estão em uma ordem diferente do que tendem a estar no tidyverse. No entanto, isso é ok. À medida que sua aprendizagem e uso do R se expandirem fora deste livro, você encontrará muitos estilos diferentes usados em vários pacotes do R que você pode usar para alcançar objetivos específicos no R. Uma boa maneira de se familiarizar com o estilo de codificação usado em um novo pacote é executar os exemplos fornecidos na documentação da função para ter uma ideia da sintaxe e dos formatos de saída, bem como ler quaisquer vinhetas que possam acompanhar o pacote.
"

#----20.3 Google Sheets----
"
O Google Sheets é outro programa de planilha amplamente utilizado. É gratuito e baseado na web. Assim como no Excel, no Google Sheets os dados são organizados em planilhas de trabalho (também chamadas de folhas) dentro de arquivos de planilha.
"

#----20.3.1 Pré-requisitos----
"
Esta seção também se concentrará em planilhas, mas desta vez você estará carregando dados de uma planilha do Google com o pacote googlesheets4. Este pacote também não é do núcleo do tidyverse, então você precisa carregá-lo explicitamente.
"
library(googlesheets4)
library(tidyverse)

"
Uma rápida nota sobre o nome do pacote: googlesheets4 usa a v4 da API Sheets para fornecer uma interface R para o Google Sheets, daí o nome.
"

#----20.3.2 Começando----
"
A principal função do pacote googlesheets4 é read_sheet(), que lê uma planilha do Google a partir de uma URL ou ID de arquivo. Esta função também é conhecida como range_read().

Você também pode criar uma nova planilha com gs4_create() ou escrever em uma planilha existente com sheet_write() e amigos.

Nesta seção, trabalharemos com os mesmos conjuntos de dados da seção do Excel para destacar semelhanças e diferenças entre os fluxos de trabalho para ler dados do Excel e do Google Sheets. Os pacotes readxl e googlesheets4 são ambos projetados para imitar a funcionalidade do pacote readr, que fornece a função read_csv() que você já viu. Portanto, muitas das tarefas podem ser realizadas simplesmente trocando read_excel() por read_sheet(). No entanto, você também verá que o Excel e o Google Sheets não se comportam exatamente da mesma maneira; portanto, outras tarefas podem exigir atualizações adicionais nas chamadas de função.
"

#----20.3.3 Lendo Google Sheets----
"

O primeiro argumento para read_sheet() é a URL do arquivo a ser lido, e ele retorna um tibble: 
https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w. Essas URLs não são agradáveis de se trabalhar, então você geralmente vai querer identificar uma planilha pelo seu ID.  
"
gs4_deauth()
students_sheet_id <- "1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w"
students <- read_sheet(students_sheet_id)

"
Assim como fizemos com read_excel(), podemos fornecer nomes de colunas, strings NA e tipos de colunas para read_sheet().
"
students <- read_sheet(
  students_sheet_id,
  col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A"),
  col_types = "dcccc"
)

students

"
Note que definimos os tipos de colunas de forma um pouco diferente aqui, usando códigos curtos. Por exemplo, 'dcccc' representa 'double, character, character, character, character'.

Também é possível ler planilhas individuais do Google Sheets. Vamos ler a planilha 'Torgersen Island' da planilha do Google dos pinguins:
"
penguins_sheet_id <- "1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY"
read_sheet(penguins_sheet_id, sheet = "Torgersen Island")

"
Você pode obter uma lista de todas as planilhas dentro de uma planilha do Google com sheet_names():
"
sheet_names(penguins_sheet_id)

"
Finalmente, assim como com read_excel(), podemos ler uma parte de uma planilha do Google definindo um intervalo em read_sheet(). Observe que também estamos usando a função gs4_example() abaixo para localizar uma planilha do Google de exemplo que acompanha o pacote googlesheets4.
"
deaths_url <- gs4_example("deaths")
deaths <- read_sheet(deaths_url, range = "A5:F15")
deaths

#----20.3.4 Escrevendo no Google Sheets----
"
Você pode escrever do R para o Google Sheets com write_sheet(). O primeiro argumento é o quadro de dados a ser escrito, e o segundo argumento é o nome (ou outro identificador) da planilha do Google para escrever:
"
write_sheet(bake_sale, ss = "bake-sale")

"
Se você quiser escrever seus dados em uma planilha específica (de trabalho) dentro de uma planilha do Google, você também pode especificar isso com o argumento sheet.
"
write_sheet(bake_sale, ss = "bake-sale", sheet = "Sales")

#----20.3.5 Autenticação----
"
Embora você possa ler de uma planilha do Google pública sem autenticar com sua conta do Google e com gs4_deauth(), ler uma planilha privada ou escrever em uma planilha requer autenticação para que o googlesheets4 possa visualizar e gerenciar suas planilhas do Google.

Quando você tenta ler uma planilha que requer autenticação, o googlesheets4 irá direcioná-lo para um navegador da web com um prompt para fazer login em sua conta do Google e conceder permissão para operar em seu nome com o Google Sheets. No entanto, se você quiser especificar uma conta do Google específica, escopo de autenticação, etc., você pode fazer isso com gs4_auth(), por exemplo, gs4_auth(email = mine@example.com), que forçará o uso de um token associado a um email específico. Para mais detalhes sobre autenticação, recomendamos a leitura da vinheta de autenticação do googlesheets4: https://googlesheets4.tidyverse.org/articles/auth.html.
"

#----Capítulo 21 : Bancos de Dados----

#----21.1 Introdução----
"
Uma enorme quantidade de dados está armazenada em bancos de dados, então é essencial que você saiba como acessá-los. Às vezes, você pode pedir a alguém para baixar um instantâneo em um arquivo .csv para você, mas isso rapidamente se torna penoso: toda vez que precisar fazer uma alteração, você terá que se comunicar com outro ser humano. Você quer ser capaz de acessar o banco de dados diretamente para obter os dados de que precisa, quando precisar.

Neste capítulo, você aprenderá primeiro os fundamentos do pacote DBI: como usá-lo para se conectar a um banco de dados e, em seguida, recuperar dados com uma consulta SQL. SQL, abreviação de structured query language (linguagem de consulta estruturada), é a língua franca dos bancos de dados e é uma linguagem importante para todos os cientistas de dados aprenderem. Dito isso, não vamos começar com SQL, mas em vez disso, ensinaremos dbplyr, que pode traduzir seu código dplyr para SQL. Usaremos isso como uma maneira de ensinar algumas das características mais importantes do SQL. Você não se tornará um mestre em SQL ao final do capítulo, mas será capaz de identificar os componentes mais importantes e entender o que eles fazem.
"

#----21.1.1 Pré-requisitos----
"
Neste capítulo, apresentaremos o DBI e o dbplyr. O DBI é uma interface de baixo nível que se conecta a bancos de dados e executa SQL; o dbplyr é uma interface de alto nível que traduz seu código dplyr em consultas SQL e depois as executa com o DBI.
"
library(DBI)
library(dbplyr)
library(tidyverse)

#----21.2 Fundamentos de Banco de Dados----
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
"
Já que este é um novo banco de dados, precisamos começar adicionando alguns dados. Aqui, adicionaremos os conjuntos de dados mpg e diamonds do ggplot2 usando DBI::dbWriteTable(). O uso mais simples de dbWriteTable() precisa de três argumentos: uma conexão de banco de dados, o nome da tabela a ser criada no banco de dados e um quadro de dados.
"
#dbWriteTable(con, "mpg", ggplot2::mpg)
#dbWriteTable(con, "diamonds", ggplot2::diamonds)

"
Se você estiver usando o duckdb em um projeto real, recomendamos fortemente aprender sobre duckdb_read_csv() e duckdb_register_arrow(). Eles oferecem maneiras poderosas e eficientes de carregar rapidamente dados diretamente no duckdb, sem ter que primeiro carregá-los no R. Também mostraremos uma técnica útil para carregar vários arquivos em um banco de dados.
"

#----21.3.3 Fundamentos do DBI----
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
"
Daqui em diante vamos ensinar um pouco de SQL através da ótica do dbplyr. É uma introdução bastante não tradicional ao SQL, mas esperamos que ela o ajude a se familiarizar rapidamente com o básico. Felizmente, se você entende dplyr, você está em uma ótima posição para aprender rapidamente SQL, porque muitos dos conceitos são os mesmos.

Exploraremos a relação entre dplyr e SQL usando alguns velhos amigos do pacote nycflights13: flights e planes. Esses conjuntos de dados são fáceis de inserir em nosso banco de dados de aprendizado porque o dbplyr vem com uma função que copia as tabelas de nycflights13 para o nosso banco de dados:
"
dbplyr::copy_nycflights13(con)

flights <- tbl(con, "flights")
planes <- tbl(con, "planes")

#----21.5.1 Fundamentos do SQL----
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
"
A cláusula FROM define a fonte de dados. Ela será um pouco sem graça por um tempo, porque estamos apenas usando tabelas únicas. Você verá exemplos mais complexos quando chegarmos às funções de junção.
"

#----21.5.4 GROUP BY----
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
"
O dbplyr também traduz outros verbos como distinct(), slice_*(), e intersect(), além de uma crescente seleção de funções do tidyr como pivot_longer() e pivot_wider(). A maneira mais fácil de ver o conjunto completo do que está atualmente disponível é visitar o site do dbplyr: https://dbplyr.tidyverse.org/reference/.
"

#----21.6 Traduções de Funções----
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

#Capítulo 22 : Arrow----

#----22.1 Introdução----
"

Arquivos CSV são projetados para serem facilmente lidos por humanos. Eles são um bom formato de intercâmbio porque são muito simples e podem ser lidos por praticamente todas as ferramentas existentes. Mas arquivos CSV não são muito eficientes: é necessário fazer bastante trabalho para ler os dados no R. Neste capítulo, você aprenderá sobre uma alternativa poderosa: o formato parquet, um formato baseado em padrões abertos amplamente utilizado por sistemas de big data.

Vamos combinar arquivos parquet com o Apache Arrow, uma caixa de ferramentas multi-idioma projetada para análise eficiente e transporte de grandes conjuntos de dados. Usaremos o Apache Arrow por meio do pacote arrow, que fornece um backend dplyr permitindo que você analise conjuntos de dados maiores que a memória usando a sintaxe familiar do dplyr. Como benefício adicional, o arrow é extremamente rápido: você verá alguns exemplos mais adiante no capítulo.

Tanto o arrow quanto o dbplyr fornecem backends dplyr, então você pode se perguntar quando usar cada um. Em muitos casos, a escolha já é feita para você, pois os dados já estão em um banco de dados ou em arquivos parquet, e você vai querer trabalhar com eles como estão. Mas se você está começando com seus próprios dados (talvez arquivos CSV), você pode carregá-los em um banco de dados ou convertê-los para parquet. Em geral, é difícil saber o que funcionará melhor, então, nos estágios iniciais de sua análise, encorajamos você a tentar ambos e escolher o que funcionar melhor para você.
"

#----22.1.1 Pré-requisitos----
"
Neste capítulo, continuaremos a usar o tidyverse, particularmente o dplyr, mas o combinaremos com o pacote arrow, que é projetado especificamente para trabalhar com grandes conjuntos de dados.
"
library(tidyverse)
library(arrow)

"
Mais adiante no capítulo, também veremos algumas conexões entre o arrow e o duckdb, então também precisaremos do dbplyr e do duckdb.
"
library(dbplyr, warn.conflicts = FALSE)
library(duckdb)

#----22.2 Obtendo os Dados----
"

Começamos obtendo um conjunto de dados digno dessas ferramentas: um conjunto de dados de empréstimos de itens das bibliotecas públicas de Seattle, disponível online em 
data.seattle.gov/Community/Checkouts-by-Title/tmmm-ytt6. Este conjunto de dados contém 41.389.465 linhas que informam quantas vezes cada livro foi emprestado a cada mês de abril de 2005 a outubro de 2022.

O código a seguir fornecerá uma cópia em cache dos dados. Os dados são um arquivo CSV de 9GB, então levará algum tempo para baixar. Eu recomendo fortemente o uso de curl::multi_download() para obter arquivos muito grandes, pois ele é construído exatamente para esse propósito: ele fornece uma barra de progresso e pode retomar o download se for interrompido.
"
#dir.create("data", showWarnings = FALSE); ele cria um diretório para salvar esse arquivo, vou salvar no meu diretório padrão, por isso não especifiquei onde era para salvar.
#curl::multi_download("https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv","data/seattle-library-checkouts.csv",resume = TRUE)

curl::multi_download(
  "https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv",
  "seattle-library-checkouts.csv",
  resume = TRUE
)

#----22.3 Abrindo um Conjunto de Dados----
"
Vamos começar dando uma olhada nos dados. Com 9 GB, este arquivo é grande o suficiente para que provavelmente não queiramos carregar tudo na memória. Uma boa regra é que você geralmente quer pelo menos o dobro de memória do tamanho dos dados, e muitos laptops têm no máximo 16 GB. Isso significa que queremos evitar read_csv() e, em vez disso, usar arrow::open_dataset():
"
seattle_csv <- open_dataset(
  sources = "seattle-library-checkouts.csv", 
  col_types = schema(ISBN = string()),
  format = "csv"
)

"
O que acontece quando esse código é executado? open_dataset() fará uma varredura em algumas milhares de linhas para descobrir a estrutura do conjunto de dados. A coluna ISBN contém valores em branco para as primeiras 80.000 linhas, então temos que especificar o tipo da coluna para ajudar o arrow a entender a estrutura dos dados. Uma vez que os dados foram escaneados por open_dataset(), ele registra o que encontrou e para; ele só lerá mais linhas conforme você as solicitar especificamente. Esses metadados são o que vemos se imprimirmos seattle_csv:
"
seattle_csv

"
A primeira linha na saída informa que seattle_csv está armazenado localmente em disco como um único arquivo CSV; ele só será carregado na memória conforme necessário. O restante da saída informa o tipo de coluna que o arrow inferiu para cada coluna.

Podemos ver o que está realmente em com glimpse(). Isso revela que há cerca de 41 milhões de linhas e 12 colunas e nos mostra alguns valores.
"
seattle_csv |> glimpse()

"
Podemos começar a usar este conjunto de dados com os verbos dplyr, usando collect() para forçar o arrow a realizar o cálculo e retornar alguns dados. Por exemplo, este código nos informa o número total de empréstimos por ano:
"
seattle_csv |> 
  group_by(CheckoutYear) |> 
  summarise(Checkouts = sum(Checkouts)) |> 
  arrange(CheckoutYear) |> 
  collect()

"
Graças ao arrow, esse código funcionará independentemente de quão grande seja o conjunto de dados subjacente. Mas atualmente é bastante lento: no computador de Hadley, levou cerca de 10s para rodar. Não é terrível, dado a quantidade de dados que temos, mas podemos torná-lo muito mais rápido mudando para um formato melhor.
"

#----22.4 O Formato Parquet----
"
Para tornar esses dados mais fáceis de trabalhar, vamos mudar para o formato de arquivo parquet e dividi-lo em vários arquivos. As próximas seções primeiro apresentarão o parquet e o particionamento e, em seguida, aplicarão o que aprendemos aos dados da biblioteca de Seattle.
"

#----22.4.1 Vantagens do Parquet----
"
Como os arquivos CSV, o parquet é usado para dados retangulares, mas em vez de ser um formato de texto que você pode ler com qualquer editor de arquivo, é um formato binário personalizado projetado especificamente para as necessidades de big data. Isso significa que:
"
#1º Arquivos parquet geralmente são menores que o arquivo CSV equivalente. O parquet depende de codificações eficientes para manter o tamanho do arquivo reduzido e suporta compressão de arquivo. Isso ajuda a tornar os arquivos parquet rápidos porque há menos dados para mover do disco para a memória.
#2º Arquivos parquet têm um rico sistema de tipos. Como discutimos na anteriormente, um arquivo CSV não fornece informações sobre os tipos de colunas. Por exemplo, um leitor de CSV precisa adivinhar se "08-10-2022" deve ser interpretado como uma string ou uma data. Em contraste, os arquivos parquet armazenam dados de uma maneira que registra o tipo junto com os dados.
#3º Arquivos parquet têm um rico sistema de tipos. Como discutimos na Seção 7.3, um arquivo CSV não fornece informações sobre os tipos de colunas. Por exemplo, um leitor de CSV precisa adivinhar se "08-10-2022" deve ser interpretado como uma string ou uma data. Em contraste, os arquivos parquet armazenam dados de uma maneira que registra o tipo junto com os dados.
#4º Arquivos parquet são "fragmentados", o que torna possível trabalhar em diferentes partes do arquivo ao mesmo tempo e, se você tiver sorte, pular alguns fragmentos completamente.

"
Há uma desvantagem primária para arquivos parquet: eles não são mais 'legíveis por humanos', ou seja, se você olhar para um arquivo parquet usando readr::read_file(), você verá apenas um monte de caracteres sem sentido.
"

#----22.4.2 Particionamento----
"
À medida que os conjuntos de dados ficam cada vez maiores, armazenar todos os dados em um único arquivo se torna cada vez mais doloroso, e muitas vezes é útil dividir grandes conjuntos de dados em vários arquivos. Quando essa estruturação é feita de forma inteligente, essa estratégia pode levar a melhorias significativas no desempenho, porque muitas análises exigirão apenas um subconjunto dos arquivos.

Não existem regras rígidas sobre como particionar seu conjunto de dados: os resultados dependerão dos seus dados, padrões de acesso e dos sistemas que leem os dados. Você provavelmente precisará fazer algumas experimentações antes de encontrar a partição ideal para a sua situação. Como um guia geral, o arrow sugere que você evite arquivos menores que 20MB e maiores que 2GB e evite partições que produzam mais de 10.000 arquivos. Você também deve tentar particionar por variáveis pelas quais você filtra; como você verá em breve, isso permite que o arrow pule muito trabalho lendo apenas os arquivos relevantes.
"

#----22.4.3 Reescrevendo os Dados da Biblioteca de Seattle----
"
Vamos aplicar essas ideias aos dados da biblioteca de Seattle para ver como eles se concretizam na prática. Vamos particionar por CheckoutYear, já que é provável que algumas análises queiram apenas olhar para dados recentes e a partição por ano produz 18 pedaços de tamanho razoável.

Para reescrever os dados, definimos a partição usando dplyr::group_by() e, em seguida, salvamos as partições em um diretório com arrow::write_dataset(). write_dataset() tem dois argumentos importantes: um diretório onde criaremos os arquivos e o formato que usaremos.
"
pq_path <- "seattle-library-checkouts"

seattle_csv |>
  group_by(CheckoutYear) |>
  write_dataset(path = pq_path, format = "parquet")

"
Isso leva cerca de um minuto para ser executado; como veremos em breve, esse é um investimento inicial que compensa ao tornar operações futuras muito mais rápidas.

Vamos dar uma olhada no que acabamos de produzir:
"
tibble(
  files = list.files(pq_path, recursive = TRUE),
  size_MB = file.size(file.path(pq_path, files)) / 1024^2
)

"
Nosso único arquivo CSV de 9GB foi reescrito em 18 arquivos parquet. Os nomes dos arquivos usam uma convenção 'autoexplicativa' usada pelo projeto Apache Hive. Partições no estilo Hive nomeiam pastas com uma convenção 'chave=valor', então, como você pode imaginar, o diretório CheckoutYear=2005 contém todos os dados onde CheckoutYear é 2005. Cada arquivo tem entre 100 e 300 MB e o tamanho total agora é de cerca de 4 GB, pouco mais da metade do tamanho do arquivo CSV original. Isso é o que esperamos, já que o parquet é um formato muito mais eficiente.
"

#----22.5 Usando dplyr com Arrow----
"
Agora que criamos esses arquivos parquet, precisamos lê-los novamente. Usamos open_dataset() novamente, mas desta vez damos a ele um diretório:
"
seattle_pq <- open_dataset(pq_path)

"
Agora que criamos esses arquivos parquet, precisamos lê-los novamente. Usamos open_dataset() novamente, mas desta vez damos a ele um diretório:
"
query <- seattle_pq |> 
  filter(CheckoutYear >= 2018, MaterialType == "BOOK") |>
  group_by(CheckoutYear, CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(CheckoutYear, CheckoutMonth)

"
Escrever código dplyr para dados arrow é conceitualmente semelhante ao dbplyr, Capítulo 21: você escreve código dplyr, que é automaticamente transformado em uma consulta que a biblioteca C++ do Apache Arrow entende, que é então executada quando você chama collect(). Se imprimirmos o objeto de consulta, podemos ver um pouco de informação sobre o que esperamos que o Arrow retorne quando a execução ocorrer:
"
query

"
E podemos obter os resultados chamando collect():
"
query |> collect()

"
Como o dbplyr, o arrow só entende algumas expressões R, então você pode não ser capaz de escrever exatamente o mesmo código que normalmente escreveria. No entanto, a lista de operações e funções suportadas é bastante extensa e continua a crescer; encontre uma lista completa das funções atualmente suportadas em ?acero.
"

#----22.5.1 Desempenho----
"
Vamos dar uma rápida olhada no impacto no desempenho de mudar de CSV para parquet. Primeiro, vamos cronometrar quanto tempo leva para calcular o número de livros emprestados em cada mês de 2021, quando os dados estão armazenados como um único grande arquivo csv:
"
seattle_csv |> 
  filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

"
Agora, vamos usar nossa nova versão do conjunto de dados na qual os dados de empréstimos da biblioteca de Seattle foram particionados em 18 arquivos parquet menores:
"
seattle_pq |> 
  filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

"
O aumento de velocidade de ~100x no desempenho é atribuível a dois fatores: a partição em vários arquivos e o formato dos arquivos individuais:
"
#1º A partição melhora o desempenho porque esta consulta usa CheckoutYear == 2021 para filtrar os dados, e o arrow é inteligente o suficiente para reconhecer que só precisa ler 1 dos 18 arquivos parquet.
#2º O formato parquet melhora o desempenho ao armazenar dados em um formato binário que pode ser lido mais diretamente na memória. O formato colunar e os ricos metadados significam que o arrow só precisa ler as quatro colunas realmente usadas na consulta (CheckoutYear, MaterialType, CheckoutMonth e Checkouts).

"
Essa enorme diferença no desempenho é o motivo pelo qual vale a pena converter grandes CSVs para parquet!
"

#----22.5.2 Usando duckdb com Arrow----
"
Há mais uma vantagem do parquet e do arrow — é muito fácil transformar um conjunto de dados arrow em um banco de dados DuckDB chamando arrow::to_duckdb()
"
seattle_pq |> 
  to_duckdb() |>
  filter(CheckoutYear >= 2018, MaterialType == "BOOK") |>
  group_by(CheckoutYear) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutYear)) |>
  collect()

"
O aspecto interessante de to_duckdb() é que a transferência não envolve cópia de memória e fala sobre os objetivos do ecossistema arrow: permitir transições contínuas de um ambiente de computação para outro.
"

#----Capítulo 23 : Dados Hierárquicos----

#----23.1 Introdução----
"
Agora, você aprenderá a arte de retangularizar dados: pegar dados que são fundamentalmente hierárquicos ou semelhantes a uma árvore e convertê-los em um quadro de dados retangular composto por linhas e colunas. Isso é importante porque dados hierárquicos são surpreendentemente comuns, especialmente ao trabalhar com dados provenientes da web.

Para aprender sobre retangularização, você primeiro precisará aprender sobre listas, a estrutura de dados que torna possível a existência de dados hierárquicos. Depois, você aprenderá sobre duas funções cruciais do tidyr: tidyr::unnest_longer() e tidyr::unnest_wider(). Em seguida, mostraremos alguns estudos de caso, aplicando essas funções simples repetidas vezes para resolver problemas reais. Finalizaremos falando sobre JSON, a fonte mais frequente de conjuntos de dados hierárquicos e um formato comum para troca de dados na web.
"

#----23.1.1 Pré-requisitos----
"
Neste capítulo, usaremos muitas funções do tidyr, um membro fundamental do tidyverse. Também usaremos repurrrsive para fornecer alguns conjuntos de dados interessantes para a prática de retangularização e finalizaremos usando jsonlite para ler arquivos JSON em listas do R.
"
library(tidyverse)
library(repurrrsive)
library(jsonlite)

#----23.2 Listas----
"
Até agora, você trabalhou com quadros de dados que contêm vetores simples como inteiros, números, caracteres, datas-horas e fatores. Esses vetores são simples porque são homogêneos: cada elemento é do mesmo tipo de dado. Se você quiser armazenar elementos de tipos diferentes no mesmo vetor, precisará de uma lista, que você cria com list():
"
x1 <- list(1:4, "a", TRUE)
x1

"
Muitas vezes é conveniente nomear os componentes, ou filhos, de uma lista, o que você pode fazer da mesma maneira que nomear as colunas de um tibble:
"
x2 <- list(a = 1:2, b = 1:3, c = 1:4)
x2

"
Mesmo para essas listas muito simples, a impressão ocupa bastante espaço. Uma alternativa útil é str(), que gera uma exibição compacta da estrutura, desenfatizando o conteúdo:
"
str(x1)
str(x2)

"
Como você pode ver, str() exibe cada filho da lista em sua própria linha. Ele exibe o nome, se presente, depois uma abreviação do tipo e, em seguida, os primeiros valores.
"

#----23.2.1 Hierarquia----
"
As listas podem conter qualquer tipo de objeto, incluindo outras listas. Isso as torna adequadas para representar estruturas hierárquicas (semelhantes a árvores):
"
x3 <- list(list(1, 2), list(3, 4))
str(x3)

"
Isso é notavelmente diferente de c(), que gera um vetor plano:
"
c(c(1, 2), c(3, 4))

x4 <- c(list(1, 2), list(3, 4))
str(x4)

"
À medida que as listas se tornam mais complexas, str() se torna mais útil, pois permite que você veja a hierarquia de relance:
"
x5 <- list(1, list(2, list(3, list(4, list(5)))))
str(x5)

"
À medida que as listas ficam ainda maiores e mais complexas, str() eventualmente começa a falhar, e você precisará mudar para View()1. O visualizador começa mostrando apenas o nível superior da lista, mas você pode expandir interativamente qualquer um dos componentes para ver mais. O RStudio também mostrará o código que você precisa para acessar esse elemento. Voltaremos a como esse código funciona mais a frente.
"

#----23.2.2 Colunas-lista----
"

As listas também podem viver dentro de um tibble, onde as chamamos de colunas-lista. Colunas-lista são úteis porque permitem que você coloque objetos em um tibble que normalmente não pertenceriam ali. Em particular, colunas-lista são muito usadas no ecossistema tidymodels, porque permitem que você armazene coisas como resultados de modelos ou reamostras em um quadro de dados.

Aqui está um exemplo simples de uma coluna-lista:
"
df <- tibble(
  x = 1:2, 
  y = c("a", "b"),
  z = list(list(1, 2), list(3, 4, 5))
)
df

"
Não há nada de especial sobre listas em um tibble; elas se comportam como qualquer outra coluna:
"
df |> 
  filter(x == 1)

"
Computar com colunas-lista é mais difícil, mas isso ocorre porque computar com listas é mais difícil em geral; voltaremos a isso mais a frente. Agora, nos concentraremos em desaninhar colunas-lista em variáveis regulares para que você possa usar suas ferramentas existentes nelas.

O método de impressão padrão apenas exibe um resumo aproximado do conteúdo. A coluna-lista poderia ser arbitrariamente complexa, então não há uma boa maneira de imprimi-la. Se você quiser vê-la, precisará retirar apenas a coluna-lista e aplicar uma das técnicas que aprendeu acima, como df |> pull(z) |> str() ou df |> pull(z) |> View().
"


"
R Base

É possível colocar uma lista em uma coluna de um data.frame, mas é muito mais complicado porque data.frame() trata uma lista como uma lista de colunas:
"
data.frame(x = list(1:3, 3:5))

"
Você pode forçar data.frame() a tratar uma lista como uma lista de linhas envolvendo-a em I(), mas o resultado não é impresso particularmente bem:
"
data.frame(
  x = I(list(1:2, 3:5)), 
  y = c("1, 2", "3, 4, 5")
)

"
É mais fácil usar colunas-lista com tibbles porque tibble() trata listas como vetores e o método de impressão foi projetado tendo em mente as listas.
"

#----23.3 Desaninhando----
"
Agora que você aprendeu o básico sobre listas e colunas-lista, vamos explorar como você pode transformá-las novamente em linhas e colunas regulares. Aqui usaremos dados de amostra muito simples para que você possa entender a ideia básica; na próxima seção, mudaremos para dados reais.

Colunas-lista tendem a vir em duas formas básicas: nomeadas e não nomeadas. Quando os filhos são nomeados, eles tendem a ter os mesmos nomes em cada linha. Por exemplo, em df1, cada elemento da coluna-lista y tem dois elementos nomeados a e b. Colunas-lista nomeadas naturalmente se desaninham em colunas: cada elemento nomeado se torna uma nova coluna nomeada.
"
df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32),
)

"
Quando os filhos são não nomeados, o número de elementos tende a variar de linha para linha. Por exemplo, em df2, os elementos da coluna-lista y são não nomeados e variam em comprimento de um a três. Colunas-lista não nomeadas naturalmente se desaninham em linhas: você obterá uma linha para cada filho.
"

df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32),
)

"
O tidyr fornece duas funções para esses dois casos: unnest_wider() e unnest_longer(). As seções seguintes explicam como elas funcionam.
"

#----23.3.1 unnest_wider()----
"
By default, the names of the new columns come exclusively from the names of the list elements, but you can use the names_sep argument to request that they combine the column name and the element name. This is useful for disambiguating repeated names.
"
df1 |> 
  unnest_wider(y)

"
Por padrão, os nomes das novas colunas vêm exclusivamente dos nomes dos elementos da lista, mas você pode usar o argumento names_sep para solicitar que eles combinem o nome da coluna e o nome do elemento. Isso é útil para desambiguar nomes repetidos.
"
df1 |> 
  unnest_wider(y, names_sep = "_")

#----23.3.2 unnest_longer()----
"
Quando cada linha contém uma lista não nomeada, é mais natural colocar cada elemento em sua própria linha com unnest_longer():
"
df2 |> 
  unnest_longer(y)

"
Observe como x é duplicado para cada elemento dentro de y: obtemos uma linha de saída para cada elemento dentro da coluna-lista. Mas o que acontece se um dos elementos estiver vazio, como no exemplo a seguir?
"
df6 <- tribble(
  ~x, ~y,
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df6 |> unnest_longer(y)

"
Obtemos zero linhas na saída, então a linha efetivamente desaparece. Se você quiser preservar essa linha, adicionando NA em y, defina keep_empty = TRUE.
"

#----23.3.3 Tipos Inconsistentes----
"
O que acontece se você desaninhar uma coluna-lista que contém diferentes tipos de vetor? Por exemplo, pegue o seguinte conjunto de dados onde a coluna-lista y contém dois números, um caractere e um lógico, que normalmente não podem ser misturados em uma única coluna.
"
df4 <- tribble(
  ~x, ~y,
  "a", list(1),
  "b", list("a", TRUE, 5)
)

"
unnest_longer() sempre mantém o conjunto de colunas inalterado, enquanto muda o número de linhas. Então, o que acontece? Como o unnest_longer() produz cinco linhas enquanto mantém tudo em y?
"
df4 |> 
  unnest_longer(y)

"
Como você pode ver, a saída contém uma coluna-lista, mas cada elemento da coluna-lista contém um único elemento. Como o unnest_longer() não consegue encontrar um tipo comum de vetor, ele mantém os tipos originais em uma coluna-lista. Você pode se perguntar se isso viola o mandamento de que cada elemento de uma coluna deve ser do mesmo tipo. Não viola: cada elemento é uma lista, mesmo que o conteúdo seja de tipos diferentes.

Lidar com tipos inconsistentes é desafiador e os detalhes dependem da natureza precisa do problema e de seus objetivos, mas você provavelmente precisará de ferramentas futuras
"

#----23.3.4 Outras Funções----
"
O tidyr possui algumas outras funções úteis de retangularização que não irei tratar:
"
#1º unnest_auto() escolhe automaticamente entre unnest_longer() e unnest_wider() com base na estrutura da coluna-lista. É ótimo para exploração rápida, mas, no final das contas, é uma má ideia porque não o força a entender como seus dados estão estruturados e torna seu código mais difícil de entender.
#2º unnest() expande tanto linhas quanto colunas. É útil quando você tem uma coluna-lista que contém uma estrutura 2D, como um quadro de dados, o que você não vê neste livro, mas pode encontrar se usar o ecossistema tidymodels.

"
Essas funções são boas para saber, pois você pode encontrá-las ao ler o código de outras pessoas ou enfrentar desafios mais raros de retangularização por conta própria.
"

#----23.4 Estudos de Caso----
"
A principal diferença entre os exemplos simples que usamos acima e dados reais é que dados reais normalmente contêm vários níveis de aninhamento que requerem múltiplas chamadas para unnest_longer() e/ou unnest_wider(). Para mostrar isso na prática, esta seção trabalha através de três desafios reais de retangularização usando conjuntos de dados do pacote repurrrsive.
"

#----23.4.1 Dados Muito Amplos----
"
Vamos começar com gh_repos. Esta é uma lista que contém dados sobre uma coleção de repositórios do GitHub recuperados usando a API do GitHub. É uma lista muito aninhada, então é difícil mostrar a estrutura neste livro; recomendamos explorar um pouco por conta própria com View(gh_repos) antes de continuarmos.

gh_repos é uma lista, mas nossas ferramentas trabalham com colunas-lista, então começaremos colocando-a em um tibble. Chamamos essa coluna de json por razões que abordaremos mais tarde.
"
repos <- tibble(json = gh_repos)
repos

"
Este tibble contém 6 linhas, uma linha para cada filho de gh_repos. Cada linha contém uma lista não nomeada com 26 ou 30 linhas. Como elas são não nomeadas, começaremos com unnest_longer() para colocar cada filho em sua própria linha:
"
repos |> 
  unnest_longer(json)

"
À primeira vista, pode parecer que não melhoramos a situação: embora tenhamos mais linhas (176 em vez de 6), cada elemento de json ainda é uma lista. No entanto, há uma diferença importante: agora cada elemento é uma lista nomeada, então podemos usar unnest_wider() para colocar cada elemento em sua própria coluna:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) 

"
Isso funcionou, mas o resultado é um pouco esmagador: há tantas colunas que o tibble nem mesmo imprime todas! Podemos vê-las todas com names(); e aqui olhamos para as primeiras 10:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  names() |> 
  head(10)

"
Vamos selecionar algumas que parecem interessantes:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description)

"
Você pode usar isso para voltar e entender como gh_repos foi estruturado: cada filho era um usuário do GitHub contendo uma lista de até 30 repositórios do GitHub que eles criaram.

owner é outra coluna-lista, e como ela contém uma lista nomeada, podemos usar unnest_wider() para acessar os valores:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner)

"
Uh oh, esta coluna-lista também contém uma coluna id e não podemos ter duas colunas id no mesmo quadro de dados. Como sugerido, vamos usar names_sep para resolver o problema:
"
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner, names_sep = "_")

"
Isso nos dá outro conjunto de dados amplo, mas você pode perceber que owner parece conter muitos dados adicionais sobre a pessoa que 'possui' o repositório.
"

#----23.4.2 Dados Relacionais----
"
Dados aninhados às vezes são usados para representar dados que normalmente espalharíamos por vários quadros de dados. Por exemplo, pegue got_chars, que contém dados sobre personagens que aparecem nos livros e na série de TV Game of Thrones. Como gh_repos, é uma lista, então começamos transformando-a em uma coluna-lista de um tibble:
"
chars <- tibble(json = got_chars)
chars

"
A coluna json contém elementos nomeados, então começaremos ampliando-a:
"
chars |> 
  unnest_wider(json)

"
E selecionando algumas colunas para facilitar a leitura:
"
characters <- chars |> 
  unnest_wider(json) |> 
  select(id, name, gender, culture, born, died, alive)
characters

"
Este conjunto de dados também contém muitas colunas-lista:
"
chars |> 
  unnest_wider(json) |> 
  select(id, where(is.list))

"
Vamos explorar a coluna titles. É uma coluna-lista não nomeada, então vamos desaninhá-la em linhas:
"
chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles)

"
Você pode esperar ver esses dados em sua própria tabela porque seria fácil juntá-los aos dados dos personagens conforme necessário. Vamos fazer isso, o que requer uma pequena limpeza: removendo as linhas que contêm strings vazias e renomeando titles para title, pois cada linha agora contém apenas um título.
"
titles <- chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles) |> 
  filter(titles != "") |> 
  rename(title = titles)
titles

"
Você pode imaginar criar uma tabela como essa para cada uma das colunas-lista e, em seguida, usar junções para combiná-las com os dados dos personagens conforme necessário.
"

#----23.4.3 Profundamente Aninhados----
"
Vamos encerrar esses estudos de caso com uma coluna-lista que é muito profundamente aninhada e requer rodadas repetidas de unnest_wider() e unnest_longer() para desvendar: gmaps_cities. Este é um tibble de duas colunas contendo cinco nomes de cidades e os resultados de usar a API de geocodificação do Google para determinar a localização deles:
"
gmaps_cities

"
json é uma coluna-lista com nomes internos, então começamos com um unnest_wider():
"
gmaps_cities |> 
  unnest_wider(json)

"
Isso nos dá o status e os resultados. Vamos descartar a coluna de status, já que todos estão 'OK'; em uma análise real, você também desejaria capturar todas as linhas onde status != 'OK' e descobrir o que deu errado. results é uma lista não nomeada, com um ou dois elementos (veremos o motivo em breve), então vamos desaninhá-la em linhas:
"
gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results)

"
Agora results é uma lista nomeada, então usaremos unnest_wider():
"
locations <- gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) |> 
  unnest_wider(results)
locations

"
Agora podemos ver por que duas cidades obtiveram dois resultados: Washington correspondeu tanto ao estado de Washington quanto a Washington, DC, e Arlington correspondeu a Arlington, Virgínia e Arlington, Texas.

Há alguns lugares diferentes para onde poderíamos ir a partir daqui. Podemos querer determinar a localização exata da correspondência, que está armazenada na coluna-lista geometry:
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry)

"
Isso nos dá novos bounds (uma região retangular) e location (um ponto). Podemos desaninhar location para ver a latitude (lat) e longitude (lng):
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  unnest_wider(location)

"
Extrair os bounds requer mais algumas etapas:
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  # foco na variável de interesse
  select(!location:viewport) |>
  unnest_wider(bounds)

"
Em seguida, renomeamos southwest e northeast (os cantos do retângulo) para que possamos usar names_sep para criar nomes curtos, mas evocativos:
"
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  select(!location:viewport) |>
  unnest_wider(bounds) |> 
  rename(ne = northeast, sw = southwest) |> 
  unnest_wider(c(ne, sw), names_sep = "_") 

"
Observe como desaninhamos duas colunas simultaneamente fornecendo um vetor de nomes de variáveis para unnest_wider().

Depois de descobrir o caminho para chegar aos componentes de interesse, você pode extraí-los diretamente usando outra função do tidyr, hoist():
"
locations |> 
  select(city, formatted_address, geometry) |> 
  hoist(
    geometry,
    ne_lat = c("bounds", "northeast", "lat"),
    sw_lat = c("bounds", "southwest", "lat"),
    ne_lng = c("bounds", "northeast", "lng"),
    sw_lng = c("bounds", "southwest", "lng"),
  )

"
Se esses estudos de caso aguçaram seu apetite por mais retangularização da vida real, você pode ver mais alguns exemplos em vignette('rectangling', package = 'tidyr').
"

#----23.5 JSON----
"
Todos os estudos de caso na seção anterior foram originados de JSON capturado na 'natureza'. JSON é a abreviação de javascript object notation e é a maneira como a maioria das APIs da web retorna dados. É importante entendê-lo porque, embora JSON e os tipos de dados do R sejam bastante semelhantes, não há um mapeamento perfeito de 1 para 1, então é bom entender um pouco sobre JSON se as coisas derem errado.
"

#----23.5.1 Tipos de Dados----
"
JSON é um formato simples projetado para ser facilmente lido e escrito por máquinas, não por humanos. Ele possui seis tipos de dados principais. Quatro deles são escalares:
"
#1º O tipo mais simples é um nulo (null), que desempenha o mesmo papel que o NA no R. Ele representa a ausência de dados.
#2º Uma string é muito parecida com uma string no R, mas deve sempre usar aspas duplas.
#3º Um número é semelhante aos números do R: eles podem usar notação inteira (por exemplo, 123), decimal (por exemplo, 123.45) ou científica (por exemplo, 1.23e3). JSON não suporta Inf, -Inf ou NaN.
#4º Um booleano é semelhante aos TRUE e FALSE do R, mas usa true e false em minúsculas.

"
Tanto arrays quanto objetos são semelhantes a listas no R; a diferença é se eles são nomeados ou não. Um array é como uma lista sem nome e é escrito com []. Por exemplo, [1, 2, 3] é um array contendo 3 números, e [null, 1, 'string', false] é um array que contém um nulo, um número, uma string e um booleano. Um objeto é como uma lista nomeada e é escrito com {}. Os nomes (chaves na terminologia JSON) são strings, então devem ser cercados por aspas. Por exemplo, {'x': 1, 'y': 2} é um objeto que mapeia x para 1 e y para 2.

Observe que o JSON não possui nenhuma maneira nativa de representar datas ou horários, então eles geralmente são armazenados como strings, e você precisará usar readr::parse_date() ou readr::parse_datetime() para convertê-los na estrutura de dados correta. Da mesma forma, as regras do JSON para representar números de ponto flutuante são um pouco imprecisas, então você também encontrará números armazenados em strings. Aplique readr::parse_double() conforme necessário para obter o tipo de variável correto.
"

#----23.5.2 jsonlite----
"
Para converter JSON em estruturas de dados do R, recomendamos o pacote jsonlite, de Jeroen Ooms. Usaremos apenas duas funções do jsonlite: read_json() e parse_json(). Na vida real, você usará read_json() para ler um arquivo JSON do disco. Por exemplo, o pacote repurrrsive também fornece a fonte para gh_user como um arquivo JSON e você pode lê-lo com read_json():
"
# Um caminho para um arquivo json dentro do pacote:
gh_users_json()

# Um caminho para um arquivo json dentro do pacote:
gh_users2 <- read_json(gh_users_json())

# Um caminho para um arquivo json dentro do pacote:
identical(gh_users, gh_users2)

"
Neste livro, também usaremos parse_json(), pois ele recebe uma string contendo JSON, o que o torna bom para gerar exemplos simples. Para começar, aqui estão três conjuntos de dados JSON simples, começando com um número, depois colocando alguns números em um array e, em seguida, colocando esse array em um objeto:
"
str(parse_json('1'))
str(parse_json('[1, 2, 3]'))
str(parse_json('{"x": [1, 2, 3]}'))

"
O jsonlite tem outra função importante chamada fromJSON(). Não a usamos aqui porque ela realiza simplificação automática (simplifyVector = TRUE). Isso geralmente funciona bem, especialmente em casos simples, mas achamos que você se sairá melhor fazendo a retangularização você mesmo para saber exatamente o que está acontecendo e poder lidar mais facilmente com as estruturas aninhadas mais complicadas.
"

#----23.5.3 Iniciando o Processo de Retangularização----
"
Na maioria dos casos, os arquivos JSON contêm um único array de nível superior, porque são projetados para fornecer dados sobre várias 'coisas', por exemplo, várias páginas, registros ou resultados. Neste caso, você começará a retangularização com tibble(json) para que cada elemento se torne uma linha:
"
json <- '[
  {"name": "John", "age": 34},
  {"name": "Susan", "age": 27}
]'
df <- tibble(json = parse_json(json))
df

df |> 
  unnest_wider(json)

"
Em casos mais raros, o arquivo JSON consiste em um único objeto JSON de nível superior, representando uma 'coisa'. Neste caso, você precisará iniciar o processo de retangularização envolvendo-o em uma lista, antes de colocá-lo em um tibble.
"
json <- '{
  "status": "OK", 
  "results": [
    {"name": "John", "age": 34},
    {"name": "Susan", "age": 27}
 ]
}
'
df <- tibble(json = list(parse_json(json)))
df


df |> 
  unnest_wider(json) |> 
  unnest_longer(results) |> 
  unnest_wider(results)

"
Alternativamente, você pode acessar o JSON analisado e começar com a parte que realmente lhe interessa:
"
df <- tibble(results = parse_json(json)$results)
df |> 
  unnest_wider(results)

# Capítulo 24: Web Scraping----

#----24.1 Introdução----
"
Este capítulo apresenta os fundamentos da web scraping com o rvest. A web scraping é uma ferramenta muito útil para extrair dados de páginas da web. Alguns sites oferecem uma API, um conjunto de solicitações HTTP estruturadas que retornam dados como JSON, que você pode manipular usando as técnicas vistas anteriormente. Sempre que possível, você deve usar a API, porque normalmente ela fornecerá dados mais confiáveis. Infelizmente, no entanto, programar com APIs da web está fora do escopo deste livro. Em vez disso, estamos ensinando web scraping, uma técnica que funciona independentemente de o site fornecer ou não uma API.

Neste capítulo, discutiremos primeiro a ética e legalidades da web scraping antes de mergulharmos nos fundamentos do HTML. Você aprenderá os conceitos básicos de seletores CSS para localizar elementos específicos na página e como usar as funções do rvest para obter dados de texto e atributos do HTML e levá-los para o R. Em seguida, discutiremos algumas técnicas para descobrir qual seletor CSS você precisa para a página que está raspando, antes de finalizar com alguns estudos de caso e uma breve discussão sobre sites dinâmicos.
"

#----24.1.1 Pré-requisitos----
"
Agora, nos concentraremos nas ferramentas fornecidas pelo rvest. O rvest é um membro do tidyverse, mas não é um membro central, então você precisará carregá-lo explicitamente. Também carregaremos o tidyverse completo, pois ele será geralmente útil para trabalhar com os dados que raspamos.
"
library(tidyverse)
library(rvest)

#----24.2 Ética e Legalidades da Raspagem de Dados----
"
Antes de começarmos a discutir o código que você precisará para realizar a web scraping, precisamos falar sobre se é legal e ético fazê-lo. No geral, a situação é complicada em relação a ambos os aspectos.

As legalidades dependem muito de onde você mora. No entanto, como princípio geral, se os dados são públicos, não pessoais e factuais, é provável que você esteja ok. Esses três fatores são importantes porque estão conectados aos termos e condições do site, informações pessoalmente identificáveis e direitos autorais, como discutiremos a seguir.

Se os dados não são públicos, não pessoais ou factuais, ou se você está raspando os dados especificamente para ganhar dinheiro com eles, você precisará conversar com um advogado. Em qualquer caso, você deve ser respeitoso com os recursos do servidor que hospeda as páginas que você está raspando. O mais importante é que, se você está raspando muitas páginas, deve ter certeza de esperar um pouco entre cada solicitação. Uma maneira fácil de fazer isso é usar o pacote polite de Dmytro Perepolkin. Ele pausará automaticamente entre as solicitações e armazenará em cache os resultados, então você nunca pedirá a mesma página duas vezes.
"

#----24.2.1 Termos de Serviço----
"
Se você olhar atentamente, encontrará muitos sites que incluem um link de 'termos e condições' ou 'termos de serviço' em algum lugar da página, e se você ler essa página atentamente, muitas vezes descobrirá que o site proíbe especificamente a web scraping. Essas páginas tendem a ser uma apropriação legal onde as empresas fazem reivindicações muito amplas. É educado respeitar esses termos de serviço quando possível, mas leve em consideração qualquer afirmação com um grão de sal.

Os tribunais dos EUA geralmente concluíram que simplesmente colocar os termos de serviço no rodapé do site não é suficiente para você ser vinculado a eles, por exemplo, HiQ Labs v. LinkedIn. Geralmente, para estar vinculado aos termos de serviço, você deve ter tomado alguma ação explícita, como criar uma conta ou marcar uma caixa. É por isso que é importante saber se os dados são públicos ou não; se você não precisa de uma conta para acessá-los, é improvável que você esteja vinculado aos termos de serviço. No entanto, observe que a situação é bastante diferente na Europa, onde os tribunais consideraram que os termos de serviço são aplicáveis mesmo se você não concordar explicitamente com eles.
"

#----24.2.2 Informações Pessoalmente Identificáveis----
"
Mesmo que os dados sejam públicos, você deve ter extremo cuidado ao raspar informações pessoalmente identificáveis, como nomes, endereços de e-mail, números de telefone, datas de nascimento, etc. A Europa tem leis particularmente rigorosas sobre a coleta ou armazenamento desses dados (GDPR) e, independentemente de onde você mora, é provável que esteja entrando em um atoleiro ético. Por exemplo, em 2016, um grupo de pesquisadores raspou informações de perfil público (por exemplo, nomes de usuário, idade, gênero, localização, etc.) de cerca de 70.000 pessoas no site de namoro OkCupid e eles divulgaram publicamente esses dados sem qualquer tentativa de anonimização. Embora os pesquisadores acreditassem que não havia nada de errado nisso, já que os dados já eram públicos, esse trabalho foi amplamente condenado devido a preocupações éticas sobre a identificabilidade dos usuários cujas informações foram divulgadas no conjunto de dados. Se o seu trabalho envolve raspar informações pessoalmente identificáveis, recomendamos fortemente a leitura sobre o estudo do OkCupid, bem como estudos semelhantes com ética de pesquisa questionável envolvendo a aquisição e divulgação de informações pessoalmente identificáveis.
"

#----24.2.3 Direitos Autorais----
"
Finalmente, você também precisa se preocupar com a lei de direitos autorais. A lei de direitos autorais é complicada, mas vale a pena dar uma olhada na lei dos EUA, que descreve exatamente o que está protegido: '[...] obras originais de autoria fixadas em qualquer meio tangível de expressão, [...]'. Em seguida, descreve categorias específicas às quais se aplica, como obras literárias, obras musicais, filmes e mais. Notavelmente ausentes da proteção de direitos autorais estão os dados. Isso significa que, desde que você limite sua raspagem a fatos, a proteção de direitos autorais não se aplica. (Mas observe que a Europa tem um direito 'sui generis' separado que protege bancos de dados.)

Como um breve exemplo, nos EUA, listas de ingredientes e instruções não são protegidas por direitos autorais, então direitos autorais não podem ser usados para proteger uma receita. Mas se essa lista de receitas for acompanhada por um conteúdo literário substancial e original, isso é protegido por direitos autorais. É por isso que, quando você está procurando uma receita na internet, sempre há tanto conteúdo antes.

Se você precisar raspar conteúdo original (como texto ou imagens), ainda pode estar protegido pela doutrina do uso justo. O uso justo não é uma regra rígida e rápida, mas considera uma série de fatores. É mais provável que se aplique se você estiver coletando os dados para fins de pesquisa ou não comerciais e se limitar o que você raspa apenas ao que precisa.
"

#----24.3 Noções Básicas de HTML----
"
To scrape webpages, you need to first understand a little bit about HTML, the language that describes web pages. HTML stands for HyperText Markup Language and looks something like this:
"

"
<html>
<head>
  <title>Page title</title>
</head>
<body>
  <h1 id='first'>A heading</h1>
  <p>Some text &amp; <b>some bold text.</b></p>
  <img src='myimg.png' width='100' height='100'>
</body>
"

"
O HTML possui uma estrutura hierárquica formada por elementos que consistem em uma tag de início (por exemplo, <tag>), atributos opcionais (id='first'), uma tag de fim4 (como </tag>) e conteúdo (tudo entre a tag de início e de fim).

Como < e > são usados para tags de início e fim, você não pode escrevê-los diretamente. Em vez disso, você deve usar os escapes HTML &gt; (maior que) e &lt; (menor que). E como esses escapes usam &, se você quiser um e comercial literal, você deve escapá-lo como &amp;. Há uma ampla gama de escapes HTML possíveis, mas você não precisa se preocupar muito com eles porque o rvest os trata automaticamente para você.

A raspagem de dados é possível porque a maioria das páginas que contêm dados que você deseja raspar geralmente têm uma estrutura consistente.
"

#----24.3.1 Elementos----
"
Existem mais de 100 elementos HTML. Alguns dos mais importantes são:  
"
#1º Toda página HTML deve estar em um elemento <html>, e deve ter dois filhos: <head>, que contém metadados do documento, como o título da página, e <body>, que contém o conteúdo que você vê no navegador.
#2º Tags de bloco como <h1> (cabeçalho 1), <section> (seção), <p> (parágrafo) e <ol> (lista ordenada) formam a estrutura geral da página.
#3º Tags inline como <b> (negrito), <i> (itálico) e <a> (link) formatam o texto dentro das tags de bloco.

"
Se você encontrar uma tag que nunca viu antes, pode descobrir o que ela faz com uma rápida pesquisa no Google. Outro bom lugar para começar são os MDN Web Docs, que descrevem praticamente todos os aspectos da programação web.

A maioria dos elementos pode ter conteúdo entre suas tags de início e fim. Esse conteúdo pode ser texto ou mais elementos. Por exemplo, o HTML a seguir contém um parágrafo de texto, com uma palavra em negrito:
"

"
<p>
  Hi! My <b>name</b> is Hadley.
</p>
"

"
Os filhos são os elementos que ele contém, então o elemento <p> acima tem um filho, o elemento <b>. O elemento <b> não tem filhos, mas tem conteúdos (o texto 'name').
"

#----24.3.2 Atributos----
"
As tags podem ter atributos nomeados que se parecem com name1='value1' name2='value2'. Dois dos atributos mais importantes são id e class, que são usados em conjunto com CSS (Cascading Style Sheets) para controlar a aparência visual da página. Eles são frequentemente úteis ao raspar dados de uma página. Os atributos também são usados para registrar o destino de links (o atributo href de elementos <a>) e a fonte de imagens (o atributo src do elemento <img>).
"

#----24.4 Extração de Dados----
"
Para começar o scraping, você precisará do URL da página que deseja raspar, que geralmente pode copiar do seu navegador web. Em seguida, você precisará ler o HTML dessa página no R com read_html(). Isso retorna um objeto xml_document5 que você manipulará usando as funções do rvest:
"
html <- read_html("http://rvest.tidyverse.org/")
html

"
O rvest também inclui uma função que permite escrever HTML inline. Usaremos isso bastante por agora enquanto ensinamos como as várias funções do rvest funcionam com exemplos simples.
"
html <- minimal_html("
  <p>This is a paragraph</p>
  <ul>
    <li>This is a bulleted list</li>
  </ul>
")
html

"
Agora que você tem o HTML no R, é hora de extrair os dados de interesse. Você aprenderá primeiro sobre os seletores CSS que permitem identificar os elementos de interesse e as funções rvest que você pode usar para extrair dados deles. Em seguida, abordaremos brevemente as tabelas HTML, que possuem algumas ferramentas especiais.
"

#----24.4.1 Encontrar Elementos----
"
CSS é a abreviação de cascading style sheets (folhas de estilo em cascata) e é uma ferramenta para definir o estilo visual de documentos HTML. O CSS inclui uma linguagem miniatura para selecionar elementos em uma página chamada seletores CSS. Os seletores CSS definem padrões para localizar elementos HTML e são úteis para a raspagem de dados porque fornecem uma maneira concisa de descrever quais elementos você deseja extrair.

Voltaremos aos seletores CSS com mais detalhes na Seção 24.5, mas felizmente você pode avançar bastante com apenas três:
"
#1º 'p' seleciona todos os elementos <p>.
#2º '.title' seleciona todos os elementos com a classe "title".
#3º '#title' seleciona o elemento com o atributo id igual a "title". Os atributos de id devem ser únicos dentro de um documento, então isso sempre selecionará um único elemento.

"
Vamos testar esses seletores com um exemplo simples:
"
html <- minimal_html("
  <h1>This is a heading</h1>
  <p id='first'>This is a paragraph</p>
  <p class='important'>This is an important paragraph</p>
")
html

"
Use html_elements() para encontrar todos os elementos que correspondem ao seletor:
"
html |> html_elements("p")
html |> html_elements(".important")
html |> html_elements("#first")

"
Outra função importante é html_element(), que sempre retorna o mesmo número de saídas que as entradas. Se você aplicá-la a um documento inteiro, ela fornecerá a primeira correspondência:
"
html |> html_element("p")

"
Há uma diferença importante entre html_element() e html_elements() quando você usa um seletor que não corresponde a nenhum elemento. html_elements() retorna um vetor de comprimento 0, enquanto html_element() retorna um valor ausente. Isso será importante em breve.
"
html |> html_elements("b")
html |> html_element("b")

#----24.4.2 Seleções Aninhadas----
"

Na maioria dos casos, você usará html_elements() e html_element() juntos, normalmente usando html_elements() para identificar elementos que se tornarão observações e então usando html_element() para encontrar elementos que se tornarão variáveis. Vamos ver isso em ação usando um exemplo simples. Aqui temos uma lista não ordenada (<ul>) onde cada item da lista (<li>) contém algumas informações sobre quatro personagens de StarWars:
"
html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
  ")
html

"
Podemos usar html_elements() para criar um vetor onde cada elemento corresponde a um personagem diferente:
"
characters <- html |> html_elements("li")
characters

"
Para extrair o nome de cada personagem, usamos html_element(), pois quando aplicado à saída de html_elements() ele garante uma resposta por elemento:
"
characters |> html_element("b")

"
A distinção entre html_element() e html_elements() não é importante para o nome, mas é importante para o peso. Queremos obter um peso para cada personagem, mesmo se não houver um <span> de peso. Isso é o que html_element() faz:
"
characters |> html_element(".weight")

"
html_elements() encontra todos os <span> de peso que são filhos de personagens. Há apenas três desses, então perdemos a conexão entre nomes e pesos:
"
characters |> html_elements(".weight")

"
Agora que você selecionou os elementos de interesse, precisará extrair os dados, seja do conteúdo do texto ou de alguns atributos.
"

#----24.4.3 Texto e Atributos----
"
html_text2() extrai o conteúdo de texto simples de um elemento HTML:
"
characters |> 
  html_element("b") |> 
  html_text2()

characters |> 
  html_element(".weight") |> 
  html_text2()

"
Observe que qualquer escape será automaticamente tratado; você só verá escapes HTML no HTML fonte, não nos dados retornados pelo rvest.

html_attr() extrai dados de atributos:
"

html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")

html |> 
  html_elements("p") |> 
  html_element("a") |> 
  html_attr("href")

"
html_attr() sempre retorna uma string, então, se você estiver extraindo números ou datas, precisará fazer algum pós-processamento.
"

#----24.4.4 Tabelas----
"
Se você tiver sorte, seus dados já estarão armazenados em uma tabela HTML, e será apenas uma questão de lê-los dessa tabela. Geralmente é fácil reconhecer uma tabela no seu navegador: ela terá uma estrutura retangular de linhas e colunas, e você poderá copiar e colar em uma ferramenta como o Excel.

As tabelas HTML são construídas a partir de quatro elementos principais: <table>, <tr> (linha da tabela), <th> (cabeçalho da tabela) e <td> (dados da tabela). Aqui está uma tabela HTML simples com duas colunas e três linhas:
"
html <- minimal_html("
  <table class='mytable'>
    <tr><th>x</th>   <th>y</th></tr>
    <tr><td>1.5</td> <td>2.7</td></tr>
    <tr><td>4.9</td> <td>1.3</td></tr>
    <tr><td>7.2</td> <td>8.1</td></tr>
  </table>
  ")

"
O rvest fornece uma função que sabe como ler esse tipo de dados: html_table(). Ela retorna uma lista contendo um tibble para cada tabela encontrada na página. Use html_element() para identificar a tabela que você deseja extrair:
"

html |> 
  html_element(".mytable") |> 
  html_table()

"
Observe que x e y foram automaticamente convertidos para números. Essa conversão automática nem sempre funciona, então, em cenários mais complexos, você pode querer desativá-la com convert = FALSE e depois fazer sua própria conversão.
"

#----24.5 Encontrando os Seletores Certos----
"
Descobrir o seletor de que você precisa para seus dados é normalmente a parte mais difícil do problema. Você geralmente precisará fazer alguns experimentos para encontrar um seletor que seja específico (ou seja, que não selecione coisas que você não se importa) e sensível (ou seja, que selecione tudo que você se importa). Muitas tentativas e erros são uma parte normal do processo! Há duas ferramentas principais disponíveis para ajudá-lo neste processo: o SelectorGadget e as ferramentas de desenvolvedor do seu navegador.

O SelectorGadget é um bookmarklet em javascript que gera automaticamente seletores CSS com base em exemplos positivos e negativos que você fornece. Ele não sempre funciona, mas quando funciona, é mágico! Você pode aprender a instalar e usar o SelectorGadget lendo 
https://rvest.tidyverse.org/articles/selectorgadget.html ou assistindo ao vídeo de Mine em https://www.youtube.com/watch?v=PetWV5g1Xsc.

Todo navegador moderno vem com algum kit de ferramentas para desenvolvedores, mas recomendamos o Chrome, mesmo que não seja seu navegador regular: suas ferramentas de desenvolvedor web são algumas das melhores e estão imediatamente disponíveis. Clique com o botão direito em um elemento na página e clique em Inspecionar. Isso abrirá uma visualização expansível da página HTML completa, centrada no elemento que você acabou de clicar. Você pode usar isso para explorar a página e ter uma ideia do que os seletores podem funcionar. Preste atenção especial aos atributos de classe e id, pois eles são frequentemente usados para formar a estrutura visual da página e, portanto, são boas ferramentas para extrair os dados que você está procurando.

Dentro da visualização de Elementos, você também pode clicar com o botão direito em um elemento e escolher Copiar como seletor para gerar um seletor que identificará exclusivamente o elemento de interesse.

Se o SelectorGadget ou as Ferramentas de Desenvolvedor do Chrome geraram um seletor CSS que você não entende, tente Selectors Explained, que traduz seletores CSS para inglês claro. Se você se encontrar fazendo isso com frequência, pode querer aprender mais sobre seletores CSS em geral. Recomendamos começar com o divertido tutorial CSS dinner e, em seguida, consultar os documentos da web MDN.
"

#----24.6 Colocando Tudo Junto----
"
Vamos juntar tudo isso para raspar alguns sites. Há um risco de que esses exemplos possam não funcionar mais quando você executá-los — esse é o desafio fundamental da raspagem de dados da web; se a estrutura do site mudar, você terá que alterar seu código de raspagem.
"

#----24.6.1 StarWars----
"
O rvest inclui um exemplo muito simples na vinhetta('starwars'). Esta é uma página simples com HTML mínimo, então é um bom lugar para começar. Eu o encorajaria a navegar até essa página agora e usar 'Inspecionar Elemento' para inspecionar um dos títulos que é o título de um filme de Star Wars. Use o teclado ou o mouse para explorar a hierarquia do HTML e ver se você consegue entender a estrutura compartilhada usada por cada filme.

Você deve ser capaz de ver que cada filme tem uma estrutura compartilhada que se parece com isso:
"

#<section>
#  <h2 data-id="1">The Phantom Menace</h2>
#  <p>Released: 1999-05-19</p>
# <p>Director: <span class="director">George Lucas</span></p>

#  <div class="crawl">
#  <p>...</p>
#  <p>...</p>
#  <p>...</p>
#  </div>
#  </section>

"
Nosso objetivo é transformar esses dados em um data frame de 7 linhas com as variáveis title, year, director e intro. Começaremos lendo o HTML e extraindo todos os elementos <section>:
"
url <- "https://rvest.tidyverse.org/articles/starwars.html"
html <- read_html(url)

section <- html |> html_elements("section")
section

"
Isso recupera sete elementos correspondentes aos sete filmes encontrados naquela página, sugerindo que usar a seção como seletor é bom. Extrair os elementos individuais é direto, pois os dados sempre são encontrados no texto. É apenas uma questão de encontrar o seletor certo:
"
section |> html_element("h2") |> html_text2()

section |> html_element(".director") |> html_text2()

"
Depois de fazer isso para cada componente, podemos embrulhar todos os resultados em um tibble:
"
tibble(
  title = section |> 
    html_element("h2") |> 
    html_text2(),
  released = section |> 
    html_element("p") |> 
    html_text2() |> 
    str_remove("Released: ") |> 
    parse_date(),
  director = section |> 
    html_element(".director") |> 
    html_text2(),
  intro = section |> 
    html_element(".crawl") |> 
    html_text2()
)

"
Fizemos um pouco mais de processamento de 'released' para obter uma variável que será fácil de usar mais tarde em nossa análise.
"

#----24.6.2 Filmes Mais Votados do IMDB----
"
Esses dados têm uma estrutura claramente tabular, então vale a pena começar com html_table():
"
url <- "https://web.archive.org/web/20220201012049/https://www.imdb.com/chart/top/"
html <- read_html(url)

table <- html |> 
  html_element("table") |> 
  html_table()
table

"
Isso inclui algumas colunas vazias, mas no geral faz um bom trabalho ao capturar as informações da tabela. No entanto, precisamos fazer mais processamento para facilitar o uso. Primeiro, renomearemos as colunas para serem mais fáceis de trabalhar e removeremos os espaços em branco extras em rank e title. Faremos isso com select() (em vez de rename()) para fazer a renomeação e a seleção de apenas essas duas colunas em uma etapa. Em seguida, removeremos as novas linhas e espaços extras e aplicaremos separate_wider_regex() para separar o título, o ano e o rank em suas próprias variáveis.
"
ratings <- table |>
  select(
    rank_title_year = `Rank & Title`,
    rating = `IMDb Rating`
  ) |> 
  mutate(
    rank_title_year = str_replace_all(rank_title_year, "\n +", " ")
  ) |> 
  separate_wider_regex(
    rank_title_year,
    patterns = c(
      rank = "\\d+", "\\. ",
      title = ".+", " +\\(",
      year = "\\d+", "\\)"
    )
  )
ratings

"
Mesmo nesse caso, onde a maioria dos dados vem de células de tabela, ainda vale a pena olhar para o HTML bruto. Se você fizer isso, descobrirá que podemos adicionar um pouco mais de dados usando um dos atributos. Esta é uma das razões pelas quais vale a pena gastar um pouco de tempo explorando a fonte da página; você pode encontrar dados extras ou pode encontrar um caminho de análise que seja um pouco mais fácil.
"
html |> 
  html_elements("td strong") |> 
  head() |> 
  html_attr("title")

"
Podemos combinar isso com os dados tabulares e novamente aplicar separate_wider_regex() para extrair a parte dos dados que nos interessa:
"
ratings |>
  mutate(
    rating_n = html |> html_elements("td strong") |> html_attr("title")
  ) |> 
  separate_wider_regex(
    rating_n,
    patterns = c(
      "[0-9.]+ based on ",
      number = "[0-9,]+",
      " user ratings"
    )
  ) |> 
  mutate(
    number = parse_number(number)
  )

#----24.7 Sites Dinâmicos----
"
Até agora, nos concentramos em sites onde `html_elements()` retorna o que você vê no navegador e discutimos como analisar o que ele retorna e como organizar essas informações em data frames organizados. De vez em quando, no entanto, você encontrará um site onde `html_elements()` e amigos não retornam nada parecido com o que você vê no navegador. Em muitos casos, isso ocorre porque você está tentando raspar um site que gera dinamicamente o conteúdo da página com javascript. Isso atualmente não funciona com o rvest, porque o rvest baixa o HTML bruto e não executa nenhum javascript.

Ainda é possível raspar esses tipos de sites, mas o rvest precisa usar um processo mais caro: simular completamente o navegador da web, incluindo a execução de todo o javascript. Essa funcionalidade não está disponível no momento da escrita, mas é algo em que estamos trabalhando ativamente e pode estar disponível quando você ler isso. Ele usa o pacote chromote, que realmente executa o navegador Chrome em segundo plano e oferece ferramentas adicionais para interagir com o site, como um humano digitando texto e clicando em botões. Confira o site do rvest para mais detalhes.
"