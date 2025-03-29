#Capítulo 20 : Planilhas
#=======================

#----20.1 Introdução----
#----------------------
"
Anteriormente você aprendeu sobre a importação de dados de arquivos de texto simples como .csv e .tsv. Agora é hora de aprender como obter dados de uma planilha, seja uma planilha do Excel ou uma planilha do Google. Isso se baseará em muito do que você aprendeu anteriormente, mas também discutiremos considerações e complexidades adicionais ao trabalhar com dados de planilhas.

Se você ou seus colaboradores estão usando planilhas para organizar dados, recomendamos fortemente a leitura do artigo 'Organização de Dados em Planilhas' de Karl Broman e Kara Woo: 
https://doi.org/10.1080/00031305.2017.1375989. As melhores práticas apresentadas neste artigo evitarão muitas dores de cabeça quando você importar dados de uma planilha para o R para analisar e visualizar.
"


#----20.2 Excel----
#----------------------
"
O Microsoft Excel é um programa de software de planilha amplamente utilizado onde os dados são organizados em planilhas dentro de arquivos de planilha.
"

#----20.2.1 Pré-requisitos----
#-----------------------------
"
Agora, você aprenderá como carregar dados de planilhas do Excel no R com o pacote readxl. Este pacote não é do núcleo do tidyverse, então você precisa carregá-lo explicitamente, mas ele é instalado automaticamente quando você instala o pacote tidyverse. Mais tarde, também usaremos o pacote writexl, que nos permite criar planilhas do Excel.
"
library(readxl)
library(tidyverse)
library(writexl)

#----20.2.2 Começando----
#------------------------
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
#---------------------------------------
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
#------------------------------------------
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
#------------------------------------------
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
#-----------------------------
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
#----------------------------------
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
#------------------------------
"
O pacote writexl é uma solução leve para escrever uma planilha do Excel simples, mas se você estiver interessado em recursos adicionais, como escrever em planilhas dentro de uma planilha e estilização, você vai querer usar o pacote openxlsx. Não entraremos nos detalhes de como usar este pacote aqui, mas recomendamos a leitura de 
https://ycphs.github.io/openxlsx/articles/Formatting.html para uma discussão extensiva sobre funcionalidades adicionais de formatação para dados escritos do R para o Excel com openxlsx.

Note que este pacote não faz parte do tidyverse, então as funções e fluxos de trabalho podem parecer pouco familiares. Por exemplo, os nomes das funções são em camelCase, múltiplas funções não podem ser compostas em pipelines, e os argumentos estão em uma ordem diferente do que tendem a estar no tidyverse. No entanto, isso é ok. À medida que sua aprendizagem e uso do R se expandirem fora deste livro, você encontrará muitos estilos diferentes usados em vários pacotes do R que você pode usar para alcançar objetivos específicos no R. Uma boa maneira de se familiarizar com o estilo de codificação usado em um novo pacote é executar os exemplos fornecidos na documentação da função para ter uma ideia da sintaxe e dos formatos de saída, bem como ler quaisquer vinhetas que possam acompanhar o pacote.
"

#----20.3 Google Sheets----
#--------------------------
"
O Google Sheets é outro programa de planilha amplamente utilizado. É gratuito e baseado na web. Assim como no Excel, no Google Sheets os dados são organizados em planilhas de trabalho (também chamadas de folhas) dentro de arquivos de planilha.
"

#----20.3.1 Pré-requisitos----
#-----------------------------
"
Esta seção também se concentrará em planilhas, mas desta vez você estará carregando dados de uma planilha do Google com o pacote googlesheets4. Este pacote também não é do núcleo do tidyverse, então você precisa carregá-lo explicitamente.
"
library(googlesheets4)
library(tidyverse)

"
Uma rápida nota sobre o nome do pacote: googlesheets4 usa a v4 da API Sheets para fornecer uma interface R para o Google Sheets, daí o nome.
"

#----20.3.2 Começando----
#------------------------
"
A principal função do pacote googlesheets4 é read_sheet(), que lê uma planilha do Google a partir de uma URL ou ID de arquivo. Esta função também é conhecida como range_read().

Você também pode criar uma nova planilha com gs4_create() ou escrever em uma planilha existente com sheet_write() e amigos.

Nesta seção, trabalharemos com os mesmos conjuntos de dados da seção do Excel para destacar semelhanças e diferenças entre os fluxos de trabalho para ler dados do Excel e do Google Sheets. Os pacotes readxl e googlesheets4 são ambos projetados para imitar a funcionalidade do pacote readr, que fornece a função read_csv() que você já viu. Portanto, muitas das tarefas podem ser realizadas simplesmente trocando read_excel() por read_sheet(). No entanto, você também verá que o Excel e o Google Sheets não se comportam exatamente da mesma maneira; portanto, outras tarefas podem exigir atualizações adicionais nas chamadas de função.
"

#----20.3.3 Lendo Google Sheets----
#----------------------------------
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
#------------------------------------------
"
Você pode escrever do R para o Google Sheets com write_sheet(). O primeiro argumento é o quadro de dados a ser escrito, e o segundo argumento é o nome (ou outro identificador) da planilha do Google para escrever:
"
write_sheet(bake_sale, ss = "bake-sale")

"
Se você quiser escrever seus dados em uma planilha específica (de trabalho) dentro de uma planilha do Google, você também pode especificar isso com o argumento sheet.
"
write_sheet(bake_sale, ss = "bake-sale", sheet = "Sales")

#----20.3.5 Autenticação----
#---------------------------
"
Embora você possa ler de uma planilha do Google pública sem autenticar com sua conta do Google e com gs4_deauth(), ler uma planilha privada ou escrever em uma planilha requer autenticação para que o googlesheets4 possa visualizar e gerenciar suas planilhas do Google.

Quando você tenta ler uma planilha que requer autenticação, o googlesheets4 irá direcioná-lo para um navegador da web com um prompt para fazer login em sua conta do Google e conceder permissão para operar em seu nome com o Google Sheets. No entanto, se você quiser especificar uma conta do Google específica, escopo de autenticação, etc., você pode fazer isso com gs4_auth(), por exemplo, gs4_auth(email = mine@example.com), que forçará o uso de um token associado a um email específico. Para mais detalhes sobre autenticação, recomendamos a leitura da vinheta de autenticação do googlesheets4: https://googlesheets4.tidyverse.org/articles/auth.html.
"