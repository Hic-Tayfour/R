#Capítulo 22 : Arrow
#===================

#----22.1 Introdução----
#-----------------------
"

Arquivos CSV são projetados para serem facilmente lidos por humanos. Eles são um bom formato de intercâmbio porque são muito simples e podem ser lidos por praticamente todas as ferramentas existentes. Mas arquivos CSV não são muito eficientes: é necessário fazer bastante trabalho para ler os dados no R. Neste capítulo, você aprenderá sobre uma alternativa poderosa: o formato parquet, um formato baseado em padrões abertos amplamente utilizado por sistemas de big data.

Vamos combinar arquivos parquet com o Apache Arrow, uma caixa de ferramentas multi-idioma projetada para análise eficiente e transporte de grandes conjuntos de dados. Usaremos o Apache Arrow por meio do pacote arrow, que fornece um backend dplyr permitindo que você analise conjuntos de dados maiores que a memória usando a sintaxe familiar do dplyr. Como benefício adicional, o arrow é extremamente rápido: você verá alguns exemplos mais adiante no capítulo.

Tanto o arrow quanto o dbplyr fornecem backends dplyr, então você pode se perguntar quando usar cada um. Em muitos casos, a escolha já é feita para você, pois os dados já estão em um banco de dados ou em arquivos parquet, e você vai querer trabalhar com eles como estão. Mas se você está começando com seus próprios dados (talvez arquivos CSV), você pode carregá-los em um banco de dados ou convertê-los para parquet. Em geral, é difícil saber o que funcionará melhor, então, nos estágios iniciais de sua análise, encorajamos você a tentar ambos e escolher o que funcionar melhor para você.
"

#----22.1.1 Pré-requisitos----
#-----------------------------
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
#-----------------------------
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
#-----------------------------------------
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
#------------------------------
"
Para tornar esses dados mais fáceis de trabalhar, vamos mudar para o formato de arquivo parquet e dividi-lo em vários arquivos. As próximas seções primeiro apresentarão o parquet e o particionamento e, em seguida, aplicarão o que aprendemos aos dados da biblioteca de Seattle.
"

#----22.4.1 Vantagens do Parquet----
#-----------------------------------
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
#------------------------------
"
À medida que os conjuntos de dados ficam cada vez maiores, armazenar todos os dados em um único arquivo se torna cada vez mais doloroso, e muitas vezes é útil dividir grandes conjuntos de dados em vários arquivos. Quando essa estruturação é feita de forma inteligente, essa estratégia pode levar a melhorias significativas no desempenho, porque muitas análises exigirão apenas um subconjunto dos arquivos.

Não existem regras rígidas sobre como particionar seu conjunto de dados: os resultados dependerão dos seus dados, padrões de acesso e dos sistemas que leem os dados. Você provavelmente precisará fazer algumas experimentações antes de encontrar a partição ideal para a sua situação. Como um guia geral, o arrow sugere que você evite arquivos menores que 20MB e maiores que 2GB e evite partições que produzam mais de 10.000 arquivos. Você também deve tentar particionar por variáveis pelas quais você filtra; como você verá em breve, isso permite que o arrow pule muito trabalho lendo apenas os arquivos relevantes.
"

#----22.4.3 Reescrevendo os Dados da Biblioteca de Seattle----
#-------------------------------------------------------------
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
#-----------------------------------
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
#-------------------------
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
#--------------------------------------
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
