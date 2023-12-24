#Capítulo 7 : Importação de Dados
#================================

#----7.1 Introdução----
#----------------------
"
Trabalhar com dados fornecidos por pacotes do R é uma ótima maneira de aprender ferramentas de ciência de dados, mas você vai querer aplicar o que aprendeu aos seus próprios dados em algum momento. Você aprenderá os conceitos básicos de leitura de arquivos de dados no R.

Especificamente, este capítulo se concentrará na leitura de arquivos retangulares de texto simples. Começaremos com conselhos práticos para lidar com características como nomes de colunas, tipos e dados faltantes. Você então aprenderá sobre a leitura de dados de vários arquivos de uma só vez e a escrita de dados do R para um arquivo. Finalmente, você aprenderá como criar data frames manualmente no R.
"
#----7.1.1 Pré-requisitos----
#----------------------------
"
Você aprenderá como carregar arquivos planos no R com o pacote readr, que faz parte do núcleo do tidyverse.
"
library(tidyverse)

#----7.2 Lendo dados de um arquivo----
#-------------------------------------
"
Para começar, vamos focar no tipo de arquivo de dados retangulares mais comum: CSV, que é a abreviação de valores separados por vírgula. Aqui está como um arquivo CSV simples se parece. A primeira linha, comumente chamada de linha de cabeçalho, fornece os nomes das colunas, e as seis linhas seguintes fornecem os dados. As colunas são separadas, ou delimitadas, por vírgulas.

Podemos ler este arquivo no R usando read_csv(). O primeiro argumento é o mais importante: o caminho para o arquivo. Você pode pensar no caminho como o endereço do arquivo: o arquivo se chama students.csv e está localizado na pasta de dados.

O código acima funcionará se você tiver o arquivo students.csv em uma pasta de dados no seu projeto. Você pode baixar o arquivo students.csv de https://pos.it/r4ds-students-csv ou pode lê-lo diretamente dessa URL com:
"
students <- read_csv("https://pos.it/r4ds-students-csv")
write_csv(students, "students.csv")
"
Quando você executa read_csv(), ele imprime uma mensagem informando o número de linhas e colunas de dados, o delimitador que foi usado e as especificações das colunas (nomes das colunas organizados pelo tipo de dado que a coluna contém). Ele também imprime algumas informações sobre como obter a especificação completa da coluna e como silenciar essa mensagem.
"

#----7.2.1 Conselhos práticos----
#--------------------------------
"
Uma vez que você leu os dados, o primeiro passo geralmente envolve transformá-los de alguma forma para facilitar o trabalho com eles no resto da sua análise. Vamos dar outra olhada nos dados dos estudantes com isso em mente.
"
students

"
Na coluna favourite.food, há uma série de itens alimentares e, em seguida, a string de caracteres N/A, que deveria ter sido um verdadeiro NA que o R reconheceria como 'não disponível'. Isso é algo que podemos abordar usando o argumento na. Por padrão, read_csv() só reconhece strings vazias ('') neste conjunto de dados como NAs, mas queremos que ele também reconheça a string de caracteres 'N/A'.
"
students <- read_csv("students.csv", na = c("N/A", ""))
students

"
Você também pode notar que as colunas Student ID e Full Name estão cercadas por crases. Isso acontece porque elas contêm espaços, quebrando as regras usuais do R para nomes de variáveis; são nomes não-sintáticos. Para se referir a essas variáveis, você precisa cercá-las com crases, `:
"
students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

"
Uma abordagem alternativa é usar janitor::clean_names() para usar algumas heurísticas para transformá-los todos em snake case de uma vez.
"
students |> janitor::clean_names()

"
Outra tarefa comum após ler os dados é considerar os tipos de variáveis. Por exemplo, meal_plan é uma variável categórica com um conjunto conhecido de valores possíveis, que no R deve ser representada como um fator:
"
students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

"
Note que os valores na variável meal_plan permaneceram os mesmos, mas o tipo de variável indicado abaixo do nome da variável mudou de caractere (<chr>) para fator (<fct>).

Antes de analisar esses dados, você provavelmente vai querer corrigir as colunas de idade e id. Atualmente, a idade é uma variável de caractere porque uma das observações é digitada como cinco em vez de um número.

Uma nova função aqui é if_else(), que tem três argumentos. O primeiro argumento, test, deve ser um vetor lógico. O resultado conterá o valor do segundo argumento, yes, quando test for TRUE, e o valor do terceiro argumento, no, quando for FALSE. Aqui estamos dizendo que se a idade é a string de caracteres 'five', transforme-a em '5', e se não, deixe-a como idade.
"
students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

students

#----7.2.2 Outros argumentos----
#-------------------------------
"
Existem alguns outros argumentos importantes que precisamos mencionar, e eles serão mais fáceis de demonstrar se primeiro mostrarmos um truque útil: read_csv() pode ler strings de texto que você criou e formatou como um arquivo CSV:
"
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

"  
Normalmente, read_csv() usa a primeira linha dos dados para os nomes das colunas, o que é uma convenção muito comum. Mas não é incomum que algumas linhas de metadados sejam incluídas no topo do arquivo. Você pode usar skip = n para pular as primeiras n linhas ou usar comment = '#' para descartar todas as linhas que começam com (por exemplo) #:
"
read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

"
Em outros casos, os dados podem não ter nomes de colunas. Você pode usar col_names = FALSE para dizer ao read_csv() para não tratar a primeira linha como cabeçalhos e, em vez disso, rotulá-los sequencialmente de X1 a Xn:
"
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)

"
Alternativamente, você pode passar col_names um vetor de caracteres que será usado como os nomes das colunas:
"
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

"
Esses argumentos são tudo o que você precisa saber para ler a maioria dos arquivos CSV que encontrará na prática. (Para o resto, você precisará inspecionar cuidadosamente seu arquivo .csv e ler a documentação para os muitos outros argumentos de read_csv()).
"

#----7.2.3 Outros tipos de arquivos----
#--------------------------------------
"
Uma vez que você dominou read_csv(), usar as outras funções do readr é direto; é apenas uma questão de saber qual função utilizar:
"  
  #1º read_csv2() lê arquivos separados por ponto e vírgula. Eles usam ; em vez de , para separar os campos e são comuns em países que usam , como marcador decimal.

  #2º read_tsv() lê arquivos delimitados por tabulações.

  #3º read_delim() lê arquivos com qualquer delimitador, tentando adivinhar automaticamente o delimitador se você não o especificar.

  #4º read_fwf() lê arquivos de largura fixa. Você pode especificar campos pela largura deles com fwf_widths() ou pelas suas posições com fwf_positions().

  #5º read_table() lê uma variação comum de arquivos de largura fixa onde as colunas são separadas por espaço em branco.

  #6º read_log() lê arquivos de log no estilo Apache.

#----7.3 Controlando tipos de coluna----
#---------------------------------------
"
Um arquivo CSV não contém nenhuma informação sobre o tipo de cada variável (ou seja, se é um valor lógico, numérico, string, etc.), então o readr tentará adivinhar o tipo. Esta seção descreve como o processo de adivinhação funciona, como resolver alguns problemas comuns que fazem com que ele falhe e, se necessário, como fornecer os tipos de coluna você mesmo. Finalmente, mencionaremos algumas estratégias gerais que são úteis se o readr estiver falhando catastroficamente e você precisar obter mais informações sobre a estrutura do seu arquivo.
" 

#----7.3.1 Adivinhando tipos----
#-------------------------------
"
O readr usa uma heurística para descobrir os tipos de coluna. Para cada coluna, ele puxa os valores de 1.000 linhas espaçadas uniformemente da primeira à última, ignorando valores ausentes. Em seguida, ele trabalha com as seguintes perguntas:
"
  #1º Contém apenas F, T, FALSE ou TRUE (ignorando maiúsculas e minúsculas)? Se sim, é um lógico.

  #2º Contém apenas números (por exemplo, 1, -4.5, 5e6, Inf)? Se sim, é um número.

  #3º Corresponde ao padrão ISO8601? Se sim, é uma data ou data-hora.

  #4º Caso contrário, deve ser uma string.

"
Você pode ver esse comportamento em ação neste exemplo simples:
"
read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

"
Essa heurística funciona bem se você tem um conjunto de dados limpo, mas na vida real, você encontrará uma seleção de falhas estranhas e maravilhosas.
"

#----7.3.2 Valores ausentes, tipos de colunas e problemas----
#------------------------------------------------------------
"A maneira mais comum de a detecção de colunas falhar é quando uma coluna contém valores inesperados, e você obtém uma coluna de caracteres em vez de um tipo mais específico. Uma das causas mais comuns para isso é um valor ausente, registrado usando algo diferente do NA que o readr espera.

Pegue este simples arquivo CSV de 1 coluna como exemplo:
"
simple_csv <- "
  x
  10
  .
  20
  30"

"
Se o lermos sem argumentos adicionais, x se torna uma coluna de caracteres:
"
read_csv(simple_csv)

"
Neste caso muito pequeno, você pode facilmente ver o valor ausente .. Mas o que acontece se você tiver milhares de linhas com apenas alguns valores ausentes representados por .s espalhados entre eles? Uma abordagem é dizer ao readr que x é uma coluna numérica e, em seguida, ver onde falha. Você pode fazer isso com o argumento col_types, que recebe uma lista nomeada onde os nomes correspondem aos nomes das colunas no arquivo CSV:
"
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

"
Agora read_csv() relata que houve um problema e nos diz que podemos descobrir mais com problems():
"
problems(df)

"
Isso nos diz que houve um problema na linha 3, col 1 onde o readr esperava um double mas obteve um .. Isso sugere que este conjunto de dados usa . para valores ausentes. Então definimos na = '.', o palpite automático tem sucesso, nos dando a coluna numérica que queremos:
"
read_csv(simple_csv, na = ".")


#----7.3.3 Tipos de colunas----
#------------------------------
"
O readr fornece um total de nove tipos de colunas para você usar:
"  
  #1º col_logical() e col_double()** leem valores lógicos e números reais. Eles são relativamente raramente necessários (exceto como acima), já que o readr geralmente os adivinha para você.

  #2º col_integer()** lê inteiros. Raramente distinguimos inteiros e números reais neste livro porque eles são funcionalmente equivalentes, mas ler inteiros explicitamente pode ocasionalmente ser útil porque eles ocupam metade da memória dos números reais.

  #3º col_character()** lê strings. Isso pode ser útil para especificar explicitamente quando você tem uma coluna que é um identificador numérico, ou seja, uma longa série de dígitos que identifica um objeto, mas não faz sentido aplicar operações matemáticas. Exemplos incluem números de telefone, números de segurança social, números de cartão de crédito, etc.

  #4º col_factor(), col_date() e col_datetime()** criam fatores, datas e data-horas, respectivamente.

  #5º col_number()** é um analisador numérico permissivo que ignorará componentes não numéricos, e é particularmente útil para moedas.

  #6º col_skip()** pula uma coluna para que ela não seja incluída no resultado, o que pode ser útil para acelerar a leitura dos dados se você tiver um arquivo CSV grande e quiser usar apenas algumas das colunas.

"
Também é possível substituir a coluna padrão mudando de list() para cols() e especificando .default:
"
another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

"
Outro auxiliar útil é cols_only(), que lerá apenas as colunas que você especificar:
"
read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)

#----7.4 Lendo dados de múltiplos arquivos----
#---------------------------------------------
"

Às vezes, seus dados estão divididos em vários arquivos em vez de estarem contidos em um único arquivo. Por exemplo, você pode ter dados de vendas para vários meses, com os dados de cada mês em um arquivo separado: 01-sales.csv para janeiro, 02-sales.csv para fevereiro e 03-sales.csv para março. Com read_csv(), você pode ler esses dados de uma vez e empilhá-los uns sobre os outros em um único dataframe.

Mais uma vez, o código acima funcionará se você tiver os arquivos CSV em uma pasta de dados no seu projeto. Você pode baixar esses arquivos de https://pos.it/r4ds-01-sales, https://pos.it/r4ds-02-sales e https://pos.it/r4ds-03-sales ou você pode lê-los diretamente com:
"
sales_01 <- read.csv("https://pos.it/r4ds-01-sales")
write.csv(sales_01,"01-sales.csv")

sales_02 <- read.csv("https://pos.it/r4ds-02-sales")
write.csv(sales_02,"02-sales.csv")

sales_03 <- read.csv("https://pos.it/r4ds-03-sales")
write.csv(sales_03,"03-sales.csv")

sales_files <- c("01-sales.csv", "02-sales.csv", "03-sales.csv")
read_csv(sales_files, id = "file")

"
O argumento id adiciona uma nova coluna chamada file ao dataframe resultante que identifica o arquivo de onde os dados vêm. Isso é especialmente útil em circunstâncias onde os arquivos que você está lendo não têm uma coluna identificadora que possa ajudá-lo a rastrear as observações de volta às suas fontes originais.

Se você tem muitos arquivos que deseja ler, pode ser trabalhoso escrever os nomes deles como uma lista. Em vez disso, você pode usar a função list.files() do base R para encontrar os arquivos para você, combinando um padrão nos nomes dos arquivos.
"
sales_files <- list.files(pattern = "sales\\.csv$", full.names = TRUE)
sales_files

#----7.5 Escrevendo em um arquivo----
#------------------------------------
"
O readr também vem com duas funções úteis para escrever dados de volta no disco: write_csv() e write_tsv(). Os argumentos mais importantes para essas funções são x (o dataframe a ser salvo) e file (o local para salvá-lo). Você também pode especificar como os valores ausentes são escritos com na e se deseja anexar a um arquivo existente.
"
write_csv(students, "students.csv")

"
Agora, vamos ler esse arquivo csv de volta. Note que as informações de tipo de variável que você acabou de configurar são perdidas quando você salva em CSV porque você está começando de novo com a leitura de um arquivo de texto simples novamente:
"
students
write_csv(students, "students-2.csv")
read_csv("students-2.csv")

"
Isso torna os CSVs um pouco confiáveis para armazenar resultados intermediários — você precisa recriar a especificação da coluna toda vez que carregar. Existem duas principais alternativas:
"
  #1º write_rds() e read_rds() são wrappers uniformes em torno das funções base readRDS() e saveRDS(). Estas armazenam dados no formato binário personalizado do R chamado RDS. Isso significa que quando você recarrega o objeto, está carregando exatamente o mesmo objeto R que você armazenou.

write_rds(students, "students.rds")
read_rds("students.rds")

  #2º O pacote arrow permite que você leia e escreva arquivos parquet, um formato de arquivo binário rápido que pode ser compartilhado entre linguagens de programação.
library(arrow)
write_parquet(students, "students.parquet")
read_parquet("students.parquet")

#----7.6 Entrada de dados----
#----------------------------
"
Às vezes, você precisará montar um tibble 'manualmente', fazendo um pouco de entrada de dados no seu script R. Existem duas funções úteis para ajudá-lo nisso, que diferem em se você organiza o tibble por colunas ou por linhas. tibble() funciona por coluna:
"
tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

"
Organizar os dados por coluna pode dificultar a visualização de como as linhas estão relacionadas. Portanto, uma alternativa é tribble(), abreviação de tibble transposto, que permite organizar seus dados linha por linha. tribble() é personalizado para entrada de dados em código: os cabeçalhos das colunas começam com ~ e as entradas são separadas por vírgulas. Isso torna possível organizar pequenas quantidades de dados de forma fácil de ler:
"
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)
