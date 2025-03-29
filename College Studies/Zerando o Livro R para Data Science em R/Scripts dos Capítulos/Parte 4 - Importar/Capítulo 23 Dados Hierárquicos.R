#----Capítulo 23 : Dados Hierárquicos
#====================================

#----23.1 Introdução----
#-----------------------
"
Agora, você aprenderá a arte de retangularizar dados: pegar dados que são fundamentalmente hierárquicos ou semelhantes a uma árvore e convertê-los em um quadro de dados retangular composto por linhas e colunas. Isso é importante porque dados hierárquicos são surpreendentemente comuns, especialmente ao trabalhar com dados provenientes da web.

Para aprender sobre retangularização, você primeiro precisará aprender sobre listas, a estrutura de dados que torna possível a existência de dados hierárquicos. Depois, você aprenderá sobre duas funções cruciais do tidyr: tidyr::unnest_longer() e tidyr::unnest_wider(). Em seguida, mostraremos alguns estudos de caso, aplicando essas funções simples repetidas vezes para resolver problemas reais. Finalizaremos falando sobre JSON, a fonte mais frequente de conjuntos de dados hierárquicos e um formato comum para troca de dados na web.
"

#----23.1.1 Pré-requisitos----
#-----------------------------
"
Neste capítulo, usaremos muitas funções do tidyr, um membro fundamental do tidyverse. Também usaremos repurrrsive para fornecer alguns conjuntos de dados interessantes para a prática de retangularização e finalizaremos usando jsonlite para ler arquivos JSON em listas do R.
"
library(tidyverse)
library(repurrrsive)
library(jsonlite)

#----23.2 Listas----
#-------------------
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
#-------------------------
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
#----------------------------
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
#-------------------------
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
#-----------------------------
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
#------------------------------
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
#-----------------------------------
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
#-----------------------------
"
O tidyr possui algumas outras funções úteis de retangularização que não irei tratar:
"
  #1º unnest_auto() escolhe automaticamente entre unnest_longer() e unnest_wider() com base na estrutura da coluna-lista. É ótimo para exploração rápida, mas, no final das contas, é uma má ideia porque não o força a entender como seus dados estão estruturados e torna seu código mais difícil de entender.
  #2º unnest() expande tanto linhas quanto colunas. É útil quando você tem uma coluna-lista que contém uma estrutura 2D, como um quadro de dados, o que você não vê neste livro, mas pode encontrar se usar o ecossistema tidymodels.

"
Essas funções são boas para saber, pois você pode encontrá-las ao ler o código de outras pessoas ou enfrentar desafios mais raros de retangularização por conta própria.
"

#----23.4 Estudos de Caso----
#----------------------------
"
A principal diferença entre os exemplos simples que usamos acima e dados reais é que dados reais normalmente contêm vários níveis de aninhamento que requerem múltiplas chamadas para unnest_longer() e/ou unnest_wider(). Para mostrar isso na prática, esta seção trabalha através de três desafios reais de retangularização usando conjuntos de dados do pacote repurrrsive.
"

#----23.4.1 Dados Muito Amplos----
#---------------------------------
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
#--------------------------------
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
#--------------------------------------
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
#-----------------
"
Todos os estudos de caso na seção anterior foram originados de JSON capturado na 'natureza'. JSON é a abreviação de javascript object notation e é a maneira como a maioria das APIs da web retorna dados. É importante entendê-lo porque, embora JSON e os tipos de dados do R sejam bastante semelhantes, não há um mapeamento perfeito de 1 para 1, então é bom entender um pouco sobre JSON se as coisas derem errado.
"

#----23.5.1 Tipos de Dados----
#-----------------------------
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
#-----------------------
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
#-------------------------------------------------------
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
