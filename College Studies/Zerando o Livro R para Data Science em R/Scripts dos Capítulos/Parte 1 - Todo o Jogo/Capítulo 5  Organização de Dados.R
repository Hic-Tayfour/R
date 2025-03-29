#Capítulo 5 : Organização de Dados
#=================================

#----5.1Introdução----
#---------------------
"
Neste capítulo, você aprenderá uma maneira consistente de organizar seus dados no R usando um sistema chamado dados organizados (tidy data). Colocar seus dados neste formato requer algum trabalho inicial, mas esse esforço compensa a longo prazo. Uma vez que você tenha dados organizados e as ferramentas tidy fornecidas pelos pacotes no tidyverse, você gastará muito menos tempo manipulando dados de uma representação para outra, permitindo que você dedique mais tempo às questões de dados que lhe interessam.

Você primeiro aprenderá a definição de dados organizados e verá sua aplicação em um simples conjunto de dados de exemplo. Depois, mergulharemos na principal ferramenta que você usará para organizar dados: o pivoteamento. O pivoteamento permite que você mude a forma dos seus dados sem alterar nenhum dos valores.
"

#----5.1.1Pré-Requisitos----
#---------------------------
"
Neste capítulo, focaremos no tidyr, um pacote que fornece várias ferramentas para ajudar a organizar seus conjuntos de dados desordenados. tidyr é um membro do núcleo do tidyverse.

A partir deste capítulo, suprimiremos a mensagem de carregamento do library(tidyverse)
"
library(tidyverse)

#----5.2Organizando os Dados----
#-------------------------------
"
Você pode representar os mesmos dados subjacentes de várias maneiras. O exemplo abaixo mostra os mesmos dados organizados de três maneiras diferentes. Cada conjunto de dados mostra os mesmos valores de quatro variáveis: país, ano, população e número de casos documentados de TB (tuberculose), mas cada conjunto de dados organiza os valores de uma maneira diferente.São dados já carregados junto da biblioteca tidyverse
"
table1

table2

table3

"
Estas são todas representações dos mesmos dados subjacentes, mas elas não são igualmente fáceis de usar. Uma delas, a table1, será muito mais fácil de trabalhar dentro do tidyverse porque é organizada (tidy).
"

"
Existem três regras inter-relacionadas que tornam um conjunto de dados organizado:
"

#1º Cada variável é uma coluna; cada coluna é uma variável.
#2º Cada observação é uma linha; cada linha é uma observação.
#3º Cada valor é uma célula; cada célula é um único valor.
"
Por que garantir que seus dados estejam organizados? Há duas vantagens principais:

  1º  Há uma vantagem geral em escolher uma maneira consistente de armazenar dados. Se você tem uma estrutura de dados consistente, é mais fácil aprender as ferramentas que funcionam com ela porque elas têm uma uniformidade subjacente.

  2º Há uma vantagem específica em colocar variáveis em colunas porque isso permite que a natureza vetorizada do R brilhe. Como você aprendeu nas Seções 3.3.1 e 3.5.2, a maioria das funções internas do R trabalha com vetores de valores. Isso faz com que a transformação de dados organizados pareça particularmente natural.

O dplyr, ggplot2 e todos os outros pacotes no tidyverse são projetados para trabalhar com dados organizados. Aqui estão alguns pequenos exemplos mostrando como você pode trabalhar com a table1.
"
#Calcular a taxa por 10.000
table1 |> 
  mutate(rate = cases / population * 10000)

#Calcular o total de casos por ano
table1 |> 
  group_by(year) |> 
  summarize(total_cases=sum(cases))

#Visulizando as mudanças ao longo do tempo
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = 'gray50') +
  geom_point(aes(color = country, shape = country)) + 
  scale_x_continuous(breaks = c(1999,2000))

#----5.3Extenção dos Dados----
#-----------------------------
"
Os princípios de dados organizados podem parecer tão óbvios que você pode se perguntar se algum dia encontrará um conjunto de dados que não seja organizado. Infelizmente, a maioria dos dados reais não é organizada. Há duas razões principais para isso:
"
  #1º Os dados são frequentemente organizados para facilitar algum objetivo que não seja a análise. Por exemplo, é comum que os dados sejam estruturados para facilitar a entrada de dados, não a análise.

  #2º A maioria das pessoas não está familiarizada com os princípios de dados organizados, e é difícil derivá-los por conta própria, a menos que você passe muito tempo trabalhando com dados.

"
Isso significa que a maioria das análises reais exigirá pelo menos um pouco de organização. Você começará descobrindo quais são as variáveis e observações subjacentes. Às vezes isso é fácil; outras vezes você precisará consultar as pessoas que originalmente geraram os dados. Em seguida, você fará a transformação dos seus dados para uma forma organizada, com variáveis nas colunas e observações nas linhas.

O tidyr fornece duas funções para pivotear dados: pivot_longer() e pivot_wider(). Primeiro, começaremos com pivot_longer(), pois é o caso mais comum. Vamos mergulhar em alguns exemplos.
"

#----5.3.1Dados com Nomes de Colunas----
#---------------------------------------
"
O conjunto de dados do billboard registra a classificação de músicas no ano de 2000:(também é uma base de dados presente na biblioteca tidyverse)
"
billboard

"

Dados em Nomes de Colunas
O conjunto de dados do billboard registra a classificação de músicas no ano de 2000:

Neste conjunto de dados, cada observação é uma música. As primeiras três colunas (artista, faixa e data de entrada) são variáveis que descrevem a música. Em seguida, temos 76 colunas (wk1-wk76) que descrevem a classificação da música em cada semana1. Aqui, os nomes das colunas são uma variável (a semana) e os valores das células são outra (a classificação).

Para organizar esses dados, usaremos pivot_longer():
"
billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )

"
Após os dados, existem três argumentos principais:
"
  #1º cols: especifica quais colunas precisam ser pivotadas, ou seja, quais colunas não são variáveis. Este argumento usa a mesma sintaxe que select(), então aqui poderíamos usar !c(artista, faixa, data.entrada) ou starts_with("wk").

  #2º names_to: nomeia a variável armazenada nos nomes das colunas; nomeamos essa variável como semana.

  #3º values_to: nomeia a variável armazenada nos valores das células; nomeamos essa variável como classificação.

"
Note que nos códigos 'semana' e 'classificação' estão entre aspas porque são novas variáveis que estamos criando; elas ainda não existem nos dados quando executamos a chamada pivot_longer().

Agora vamos nos concentrar no data frame resultante, mais extenso. O que acontece se uma música estiver no top 100 por menos de 76 semanas? Tome como exemplo “Baby Don’t Cry” do 2 Pac. A saída acima sugere que ela estava apenas no top 100 por 7 semanas, e todas as semanas restantes são preenchidas com valores ausentes. Esses NAs não representam realmente observações desconhecidas; eles foram forçados a existir pela estrutura do conjunto de dados2, então podemos pedir ao pivot_longer() para se livrar deles definindo values_drop_na = TRUE:
"
billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )
"
O número de linhas agora é muito menor, indicando que muitas linhas com NAs foram descartadas.

Você também pode se perguntar o que acontece se uma música estiver no top 100 por mais de 76 semanas? Não podemos dizer a partir destes dados, mas você pode adivinhar que colunas adicionais wk77, wk78, ... seriam adicionadas ao conjunto de dados.

Esses dados estão agora organizados, mas podemos facilitar futuros cálculos convertendo os valores da semana de strings para números usando mutate() e readr::parse_number(). parse_number() é uma função útil que extrai o primeiro número de uma string, ignorando todo o texto restante.
"

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

billboard_longer

"
Agora que temos todos os números das semanas em uma variável e todos os valores de classificação em outra, estamos em uma boa posição para visualizar como as classificações das músicas variam ao longo do tempo.Podemos ver que poucas músicas permanecem no top 100 por mais de 20 semanas.
"
billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha=0.25) +
  scale_y_reverse()

#----5.3.2 Como Funciona a Transformação de Dados----
#----------------------------------------------------
"
Agora que você viu como podemos usar o pivoteamento para remodelar nossos dados, vamos dedicar um tempo para ganhar alguma intuição sobre o que o pivoteamento faz com os dados. Vamos começar com um conjunto de dados muito simples para facilitar a visualização do que está acontecendo. Suponha que temos três pacientes com identificações A, B e C, e realizamos duas medições de pressão arterial em cada paciente. Vamos criar os dados com tribble(), uma função prática para construir pequenos tibbles manualmente:
"
df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
) 

"
Queremos que nosso novo conjunto de dados tenha três variáveis: id (que já existe), measurement (os nomes das colunas) e value (os valores das células). Para alcançar isso, precisamos pivotear df para uma forma mais longa:
"
df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

"
Como funciona o redesenho? É mais fácil de ver se pensarmos nisso coluna por coluna. Os valores em uma coluna que já era uma variável no conjunto de dados original (id) precisam ser repetidos, uma vez para cada coluna que é pivotada.

Os nomes das colunas tornam-se valores em uma nova variável, cujo nome é definido por names_to.Eles precisam ser repetidos uma vez para cada linha no conjunto de dados original.

Os valores das células também se tornam valores em uma nova variável, com um nome definido por values_to. Eles são desenrolados linha por linha.
"

#----5.3.3 Muitas Variáveis em Nomes de Colunas----
#----------------------------------------------------
"
Uma situação mais desafiadora ocorre quando você tem várias informações compactadas nos nomes das colunas e gostaria de armazená-las em variáveis separadas. Por exemplo, pegue o conjunto de dados who2, a fonte da table1 e amigos que você viu acima:
"
who2

"
Este conjunto de dados, coletado pela Organização Mundial da Saúde, registra informações sobre diagnósticos de tuberculose. Há duas colunas que já são variáveis e são fáceis de interpretar: país e ano. Elas são seguidas por 56 colunas como sp_m_014, ep_m_4554 e rel_m_3544. Se você observar essas colunas por tempo suficiente, notará que há um padrão. Cada nome de coluna é composto por três partes separadas por _. A primeira parte, sp/rel/ep, descreve o método usado para o diagnóstico, a segunda parte, m/f, é o gênero (codificado como uma variável binária neste conjunto de dados) e a terceira parte, 014/1524/2534/3544/4554/5564/65, é a faixa etária (014 representa 0-14, por exemplo).

Portanto, neste caso, temos seis informações registradas no who2: o país e o ano (já colunas); o método de diagnóstico, a categoria de gênero e a categoria de faixa etária (contidas nos outros nomes de colunas); e a contagem de pacientes nessa categoria (valores das células). Para organizar essas seis informações em seis colunas separadas, usamos pivot_longer() com um vetor de nomes de colunas para names_to e instruções para dividir os nomes de variáveis originais em pedaços para names_sep, bem como um nome de coluna para values_to:
"
who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )

"
Uma alternativa ao names_sep é names_pattern, que você pode usar para extrair variáveis de cenários de nomes mais complicados.

Conceitualmente, isso é apenas uma variação menor no caso mais simples que você já viu. Agora, em vez dos nomes das colunas pivotarem em uma única coluna, eles pivotam em várias colunas. Você pode imaginar isso acontecendo em dois passos (primeiro pivotando e depois separando), mas nos bastidores acontece em um único passo porque é mais rápido.
"

#----5.3.4Dados e Nomes de Variáveis nos Cabeçalhos das Colunas----
#------------------------------------------------------------------
"
O próximo nível de complexidade ocorre quando os nomes das colunas incluem uma mistura de valores de variáveis e nomes de variáveis. Por exemplo, pegue o conjunto de dados da família:
"
household

"
Este conjunto de dados contém informações sobre cinco famílias, com os nomes e datas de nascimento de até dois filhos. O novo desafio neste conjunto de dados é que os nomes das colunas contêm os nomes de duas variáveis (dob, nome) e os valores de outra (filho, com valores 1 ou 2). Para resolver esse problema, novamente precisamos fornecer um vetor para names_to, mas desta vez usamos o sentinela especial '.value'; isso não é o nome de uma variável, mas um valor único que indica ao pivot_longer() para fazer algo diferente. Isso substitui o argumento usual de values_to para usar o primeiro componente do nome da coluna pivotada como um nome de variável na saída.
"
household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

"
Nós novamente usamos values_drop_na = TRUE, já que a forma da entrada força a criação de variáveis ausentes explícitas (por exemplo, para famílias com apenas um filho).
"

#----5.4Ampliação de Dados----
#-----------------------------
"
Até agora, usamos pivot_longer() para resolver a classe comum de problemas onde os valores acabaram nos nomes das colunas. Agora, vamos 'pivotar' ,para pivot_wider(), que torna os conjuntos de dados mais amplos, aumentando as colunas e reduzindo as linhas, e ajuda quando uma observação está espalhada por várias linhas. Isso parece ocorrer menos comumente na prática, mas parece surgir bastante ao lidar com dados governamentais.

Vamos começar olhando para cms_patient_experience, um conjunto de dados dos Centros de Serviços de Medicare e Medicaid que coleta dados sobre experiências de pacientes:
"
cms_patient_experience

"
A unidade central em estudo é uma organização, mas cada organização está espalhada por seis linhas, com uma linha para cada medição realizada na organização da pesquisa. Podemos ver o conjunto completo de valores para measure_cd e measure_title usando distinct():
"
cms_patient_experience |> 
  distinct(measure_cd, measure_title)

"
Nenhuma dessas colunas será particularmente ótima como nomes de variáveis: measure_cd não dá uma ideia do significado da variável e measure_title é uma longa frase contendo espaços. Usaremos measure_cd como a fonte para nossos novos nomes de colunas por enquanto, mas em uma análise real, você pode querer criar seus próprios nomes de variáveis que sejam curtos e significativos.

pivot_wider() tem a interface oposta ao pivot_longer(): em vez de escolher novos nomes de colunas, precisamos fornecer as colunas existentes que definem os valores (values_from) e o nome da coluna (names_from):
"
cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )
"A saída não parece exatamente correta; ainda parece que temos várias linhas para cada organização. Isso ocorre porque também precisamos informar ao pivot_wider() qual coluna ou colunas têm valores que identificam exclusivamente cada linha; neste caso, essas são as variáveis que começam com 'org':
"  
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )
"
Isso nos dá a saída que estamos procurando.
"

#----5.4.1Como o pivot_wider() funciona?----
#-------------------------------------------
"
Para entender como funciona o pivot_wider(), vamos novamente começar com um conjunto de dados muito simples. Desta vez temos dois pacientes com identificações A e B, e temos três medições de pressão arterial no paciente A e duas no paciente B:
"
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

"
Vamos pegar os valores da coluna value e os nomes da coluna measurement:
"
df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

"
Para iniciar o processo, o pivot_wider() precisa primeiro determinar o que estará nas linhas e colunas. Os novos nomes de colunas serão os valores únicos de measurement.
"
df |> 
  distinct(measurement) |> 
  pull()

"
Por padrão, as linhas na saída são determinadas por todas as variáveis que não estão indo para os novos nomes ou valores. Estas são chamadas de id_cols. Aqui há apenas uma coluna, mas em geral pode haver qualquer número.
"
df |> 
  select(-measurement, -value) |> 
  distinct()

"
O pivot_wider() então combina esses resultados para gerar um data frame vazio:
"
df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

"
Em seguida, ele preenche todos os valores ausentes usando os dados da entrada. Neste caso, nem todas as células na saída têm um valor correspondente na entrada, pois não há uma terceira medição de pressão arterial para o paciente B, então essa célula permanece ausente.

Você também pode se perguntar o que acontece se houver várias linhas na entrada que correspondam a uma célula na saída. O exemplo abaixo tem duas linhas que correspondem ao id “A” e à medição “bp1”:
"
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)
"
Se tentarmos pivotar isso, obtemos uma saída que contém list-columns, sobre as quais você aprenderá mais afrente;
"
df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

"
Como você ainda não sabe trabalhar com esse tipo de dados, você vai querer seguir a dica no aviso para descobrir onde está o problema:
"
df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)

"
Cabe a você descobrir o que deu errado com seus dados e reparar o dano subjacente ou usar suas habilidades de agrupamento e sumarização para garantir que cada combinação de valores de linha e coluna tenha apenas uma única linha.
"