#Capítulo 14 : Strings (Cadeias de Caracteres)
#=============================================

#----14.1 Introdução----
#-----------------------
"
Até agora, você usou várias strings sem aprender muito sobre os detalhes. Agora é hora de mergulhar nelas, aprender o que faz as strings funcionarem e dominar algumas das poderosas ferramentas de manipulação de strings à sua disposição.

Começaremos com os detalhes da criação de strings e vetores de caracteres. Você então mergulhará na criação de strings a partir de dados e, em seguida, o oposto: extrair strings de dados. Discutiremos então ferramentas que trabalham com letras individuais. O capítulo termina com funções que trabalham com letras individuais e uma breve discussão sobre onde suas expectativas do inglês podem levar você a erros ao trabalhar com outros idiomas.

Continuaremos trabalhando com string adiante, onde você aprenderá mais sobre o poder das expressões regulares.
"
#----14.1.1 Pré-requisitos----
#-----------------------------
"
Agora, usaremos funções do pacote stringr, que faz parte do core do tidyverse. Também usaremos os dados do babynames, pois eles fornecem algumas strings divertidas para manipular.
"
library(tidyverse)
library(babynames)

"
Você pode identificar rapidamente quando está usando uma função do stringr porque todas as funções do stringr começam com str_. Isso é particularmente útil se você usa o RStudio, porque digitar str_ acionará o preenchimento automático, permitindo que você relembre as funções disponíveis.
"
#----14.2 Criando uma string----
#-------------------------------
"
Nós criamos strings anteriormente no livro, mas não discutimos os detalhes. Primeiramente, você pode criar uma string usando aspas simples (') ou aspas duplas ('). Não há diferença de comportamento entre as duas, então, em nome da consistência, o guia de estilo do tidyverse recomenda usar as aspas duplas (') a menos que a string contenha múltiplas aspas duplas.
"
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

"
Se você esquecer de fechar uma aspa, verá +, o prompt de continuação:

Se isso acontecer com você e você não conseguir descobrir qual aspa fechar, pressione Escape para cancelar e tente novamente.
"

#----14.2.1 Escapes----
#----------------------
"
Para incluir uma aspa simples ou dupla literal em uma string, você pode usar \ para 'escapá-la':
"
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

"
Então, se você quiser incluir uma barra invertida literal na sua string, precisará escapá-la: '\':
"
backslash <- "\\"

"
Esteja ciente de que a representação impressa de uma string não é a mesma que a própria string porque a representação impressa mostra os escapes (em outras palavras, quando você imprime uma string, pode copiar e colar a saída para recriar essa string). Para ver o conteúdo bruto da string, use str_view():
"
x <- c(single_quote, double_quote, backslash)
x
str_view(x)

#----14.2.2 Strings brutas----
#-----------------------------
"
Criar uma string com várias aspas ou barras invertidas fica confuso rapidamente. Para ilustrar o problema, vamos criar uma string que contém o conteúdo do bloco de código onde definimos as variáveis double_quote e single_quote:
"
tricky <- "double_quote <- \"\\\"\" # or '\"'
single_quote <- '\\'' # or \"'\""
str_view(tricky)

"
Isso é um monte de barras invertidas! (Isso às vezes é chamado de síndrome do palito inclinado.) Para eliminar a necessidade de escapar, você pode, em vez disso, usar uma string bruta:
"
tricky <- r"(double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'")"
str_view(tricky)

"
Uma string bruta normalmente começa com r'( e termina com )'. Mas se a sua string contiver )' você pode, em vez disso, usar r'[]' ou r'{}', e se isso ainda não for suficiente, você pode inserir qualquer número de hifens para tornar os pares de abertura e fechamento únicos, por exemplo, r'--()--', r'---()---', etc. As strings brutas são flexíveis o suficiente para lidar com qualquer texto.
"

#----14.2.3 Outros caracteres especiais----
#------------------------------------------

#Além de ',' e \, há um punhado de outros caracteres especiais que podem ser úteis. Os mais comuns são \n, uma nova linha, e \t, tabulação. Você também verá às vezes strings contendo escapes Unicode que começam com \u ou \U. Esta é uma maneira de escrever caracteres não ingleses que funcionam em todos os sistemas. Você pode ver a lista completa de outros caracteres especiais em ?Quotes.

x <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f604")
x        
"😄"
str_view(x)

"
Note que o str_view() usa chaves para as tabulações para torná-las mais fáceis de identificar. Um dos desafios de trabalhar com texto é que há uma variedade de maneiras pelas quais o espaço em branco pode acabar no texto, então esse fundo ajuda você a reconhecer que algo estranho está acontecendo.
"

#----14.3 Criando muitas strings a partir de dados----
#----------------------------------------------------
"
Agora que você aprendeu o básico de criar uma ou duas strings   'manualmente', vamos entrar nos detalhes de criar strings a partir de outras strings. Isso ajudará você a resolver o problema comum onde você tem algum texto que escreveu e quer combiná-lo com strings de um data frame. Por exemplo, você pode combinar 'Olá' com uma variável de nome para criar uma saudação. Mostraremos como fazer isso com str_c() e str_glue() e como você pode usá-los com mutate(). Isso naturalmente levanta a questão de quais funções do stringr você pode usar com summarize(), então vamos terminar esta seção com uma discussão sobre str_flatten(), que é uma função de resumo para strings.
"
#----14.3.1 str_c()----
#----------------------
"
str_c() recebe qualquer número de vetores como argumentos e retorna um vetor de caracteres:
"
str_c("x", "y")
str_c("x", "y", "z")
str_c("Hello ", c("John", "Susan"))

"
str_c() é muito semelhante ao paste0() do R base, mas é projetado para ser usado com mutate(), obedecendo às regras usuais do tidyverse para reciclagem e propagação de valores ausentes:
"
df <- tibble(name = c("Flora", "David", "Terra", NA))
df |> mutate(greeting = str_c("Hi ", name, "!"))

"
Se você deseja que os valores ausentes sejam exibidos de outra forma, use coalesce() para substituí-los. Dependendo do que você deseja, pode usá-lo tanto dentro quanto fora do str_c():
"
df |> 
  mutate(
    greeting1 = str_c("Hi ", coalesce(name, "you"), "!"),
    greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")
  )


#----14.3.2 str_glue()----
#-------------------------
"
Se você está misturando muitas strings fixas e variáveis com str_c(), notará que digita muitos 's', tornando difícil ver o objetivo geral do código. Uma abordagem alternativa é fornecida pelo pacote glue
(https://glue.tidyverse.org/) por meio de str_glue(). Você fornece a ele uma única string que tem um recurso especial: qualquer coisa dentro de {} será avaliada como se estivesse fora das aspas:
"
df |> mutate(greeting = str_glue("Hi {name}!"))

"
Como você pode ver, str_glue() atualmente converte valores ausentes para a string 'NA', infelizmente tornando-o inconsistente com str_c().

Você também pode se perguntar o que acontece se precisar incluir um { ou } regular em sua string. Você está no caminho certo se adivinhar que precisará escapar de alguma forma. O truque é que o glue usa uma técnica de escape um pouco diferente: em vez de prefixar com um caractere especial como , você dobra os caracteres especiais:
"
df |> mutate(greeting = str_glue("{{Hi {name}!}}"))

#----14.3.3 str_flatten()----
#----------------------------
"
str_c() e str_glue() funcionam bem com mutate() porque sua saída tem o mesmo comprimento que suas entradas. E se você quiser uma função que funcione bem com summarize(), ou seja, algo que sempre retorna uma única string? Esse é o trabalho de str_flatten()5: ele pega um vetor de caracteres e combina cada elemento do vetor em uma única string:
"
str_flatten(c("x", "y", "z"))
str_flatten(c("x", "y", "z"), ", ")
str_flatten(c("x", "y", "z"), ", ", last = ", and ")

"
Isso faz com que funcione bem com summarize():
"
df <- tribble(
  ~ name, ~ fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Marvin", "nectarine",
  "Terence", "cantaloupe",
  "Terence", "papaya",
  "Terence", "mandarin"
)
df |>
  group_by(name) |> 
  summarize(fruits = str_flatten(fruit, ", "))

#----14.4 Extraindo dados de strings-----
#----------------------------------------
"
É muito comum que várias variáveis sejam compactadas em uma única string. Nesta seção, você aprenderá a usar quatro funções do tidyr para extraí-las:
"  
  #1º df |> separate_longer_delim(col, delim)
  #2º df |> separate_longer_position(col, width)
  #3º df |> separate_wider_delim(col, delim, names)
  #4º df |> separate_wider_position(col, widths)
"
Se você olhar de perto, pode ver que há um padrão comum aqui: separate_, depois longer ou wider, depois _, então por delim ou position. Isso ocorre porque essas quatro funções são compostas de dois princípios mais simples:
"  
  #1º Assim como com pivot_longer() e pivot_wider(), as funções _longer tornam o data frame de entrada mais longo, criando novas linhas, e as funções _wider tornam o data frame de entrada mais largo, gerando novas colunas.
  #2º delim divide uma string com um delimitador como ", " ou " "; position divide em larguras especificadas, como c(3, 5, 2).
"
Voltaremos ao último membro dessa família, separate_wider_regex(), mais a frente. É a função mais flexível das funções wider, mas você precisa saber algo sobre expressões regulares antes de poder usá-la.

As próximas duas seções lhe darão a ideia básica por trás dessas funções de separação, primeiro separando em linhas (que é um pouco mais simples) e depois separando em colunas. Vamos terminar discutindo as ferramentas que as funções wider fornecem para diagnosticar problemas.
"

#----14.4.1 Separando em linhas----
#----------------------------------
"
Separar uma string em linhas tende a ser mais útil quando o número de componentes varia de linha para linha. O caso mais comum é quando se requer separate_longer_delim() para dividir com base em um delimitador:
"
df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1 |> 
  separate_longer_delim(x, delim = ",")

"
É mais raro ver separate_longer_position() na prática, mas alguns conjuntos de dados mais antigos usam um formato muito compacto onde cada caractere é usado para registrar um valor:
"
df2 <- tibble(x = c("1211", "131", "21"))
df2 |> 
  separate_longer_position(x, width = 1)

#----14.4.2 Separando em colunas----
#-----------------------------------
"
Separar uma string em colunas tende a ser mais útil quando há um número fixo de componentes em cada string e você deseja espalhá-los em colunas. Eles são um pouco mais complicados do que seus equivalentes mais longos porque você precisa nomear as colunas. Por exemplo, neste conjunto de dados a seguir, x é composto por um código, um número de edição e um ano, separados por '.'. Para usar separate_wider_delim(), fornecemos o delimitador e os nomes em dois argumentos:
"
df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", "edition", "year")
  )

"
Se uma peça específica não for útil, você pode usar um nome NA para omiti-la dos resultados:
"
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", NA, "year")
  )

"
separate_wider_position() funciona um pouco diferente porque normalmente você deseja especificar a largura de cada coluna. Então, você fornece um vetor inteiro nomeado, onde o nome dá o nome da nova coluna e o valor é o número de caracteres que ocupa. Você pode omitir valores da saída não os nomeando:
"
df4 <- tibble(x = c("202215TX", "202122LA", "202325CA")) 
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, age = 2, state = 2)
  )

#----14.4.3 Diagnosticando problemas de expansão----
#---------------------------------------------------
"
separate_wider_delim()6 requer um conjunto fixo e conhecido de colunas. O que acontece se algumas das linhas não tiverem o número esperado de peças? Há dois possíveis problemas, peças de menos ou peças demais, então separate_wider_delim() fornece dois argumentos para ajudar: too_few (poucas) e too_many (demais). Vamos primeiro olhar para o caso de too_few com o seguinte conjunto de dados de amostra:
"
df <- tibble(x = c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))

df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z")
  )

"
Você notará que recebemos um erro, mas o erro nos dá algumas sugestões sobre como você pode proceder. Vamos começar depurando o problema:
"
debug <- df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "debug"
  )

debug

"
Quando você usa o modo de depuração, três colunas extras são adicionadas à saída: x_ok, x_pieces e x_remainder (se você separar uma variável com um nome diferente, você obterá um prefixo diferente). Aqui, x_ok permite que você encontre rapidamente as entradas que falharam:
"
debug |> filter(!x_ok)

"
x_pieces nos diz quantas peças foram encontradas, comparadas às 3 esperadas (o comprimento de names). x_remainder não é útil quando há peças de menos, mas veremos novamente em breve.

Às vezes, olhar para essas informações de depuração revelará um problema com sua estratégia de delimitador ou sugerirá que você precisa fazer mais pré-processamento antes de separar. Nesse caso, corrija o problema a montante e certifique-se de remover too_few = 'debug' para garantir que novos problemas se tornem erros.

Em outros casos, você pode querer preencher as peças ausentes com NAs e seguir em frente. Esse é o trabalho de too_few = 'align_start' e too_few = 'align_end', que permitem controlar onde os NAs devem ir:
"
df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start"
  )

"
Os mesmos princípios se aplicam se você tiver peças demais:
"
df <- tibble(x = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))

df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z")
  )

"
Mas agora, quando depuramos o resultado, você pode ver a finalidade de x_remainder:
"
debug <- df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "debug"
  )
debug |> filter(!x_ok)

"
Você tem um conjunto ligeiramente diferente de opções para lidar com peças demais: você pode 'descartar' silenciosamente qualquer peça adicional ou 'mesclar' todas elas na coluna final:
"
df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "drop"
  )


df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "merge"
  )

#----14.5 Letras----
#-------------------
"
Nesta seção, apresentaremos funções que permitem trabalhar com as letras individuais dentro de uma string. Você aprenderá como encontrar o comprimento de uma string, extrair substrings e lidar com strings longas em gráficos e tabelas.
"

#----14.5.1 Comprimento----
#--------------------------
"
str_length() informa o número de letras na string:
"
str_length(c("a", "R for data science", NA))

"
Você poderia usar isso com count() para encontrar a distribuição de comprimentos de nomes de bebês nos EUA e, em seguida, com filter() para olhar os nomes mais longos, que por acaso têm 15 letras7:
"
babynames |>
  count(length = str_length(name), wt = n)

babynames |> 
  filter(str_length(name) == 15) |> 
  count(name, wt = n, sort = TRUE)


#----14.5.2 Subconjunto----
#--------------------------
"
Você pode extrair partes de uma string usando str_sub(string, start, end), onde start e end são as posições onde a substring deve começar e terminar. Os argumentos start e end são inclusivos, então o comprimento da string retornada será end - start + 1:
"
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

"
Você pode usar valores negativos para contar a partir do final da string: -1 é o último caractere, -2 é o penúltimo caractere, etc.
"
str_sub(x, -3, -1)

"
Note que str_sub() não falhará se a string for muito curta: ele apenas retornará o máximo possível:
"
str_sub("a", 1, 5)

"
Poderíamos usar str_sub() com mutate() para encontrar a primeira e a última letra de cada nome:
"
babynames |> 
  mutate(
    first = str_sub(name, 1, 1),
    last = str_sub(name, -1, -1)
  )

#----14.6 Texto não inglês----
#----------------------------
"
Até agora, nos concentramos em texto em língua inglesa, que é particularmente fácil de trabalhar por dois motivos. Primeiramente, o alfabeto inglês é relativamente simples: são apenas 26 letras. Em segundo lugar (e talvez mais importante), a infraestrutura de computação que usamos hoje foi predominantemente projetada por falantes de inglês. Infelizmente, não temos espaço para um tratamento completo de idiomas não ingleses. Ainda assim, queríamos chamar sua atenção para alguns dos maiores desafios que você pode encontrar: codificação, variações de letras e funções dependentes de localidade.
"

#----14.6.1 Codificação----
#--------------------------
"
Ao trabalhar com texto em idioma não inglês, o primeiro desafio é frequentemente a codificação. Para entender o que está acontecendo, precisamos mergulhar em como os computadores representam strings. No R, podemos acessar a representação subjacente de uma string usando charToRaw():
"
charToRaw("Hadley")

"
Cada um desses seis números hexadecimais representa uma letra: 48 é H, 61 é a, e assim por diante. O mapeamento de número hexadecimal para caractere é chamado de codificação, e neste caso, a codificação é chamada ASCII. ASCII faz um ótimo trabalho ao representar caracteres em inglês porque é o American Standard Code for Information Interchange (Código Americano Padrão para Troca de Informações).

As coisas não são tão fáceis para idiomas além do inglês. Nos primórdios da computação, havia muitos padrões concorrentes para a codificação de caracteres não ingleses. Por exemplo, havia duas codificações diferentes para a Europa: Latin1 (também conhecido como ISO-8859-1) era usado para idiomas da Europa Ocidental, e Latin2 (também conhecido como ISO-8859-2) era usado para idiomas da Europa Central. No Latin1, o byte b1 é “±”, mas no Latin2, é “ą”! Felizmente, hoje existe um padrão que é suportado quase em todos os lugares: UTF-8. UTF-8 pode codificar quase todos os caracteres usados por humanos hoje e muitos símbolos extras como emojis.

O readr usa UTF-8 em todos os lugares. Este é um bom padrão, mas falhará para dados produzidos por sistemas mais antigos que não usam UTF-8. Se isso acontecer, suas strings parecerão estranhas quando você as imprimir. Às vezes, apenas um ou dois caracteres podem estar bagunçados; outras vezes, você terá um completo absurdo. Por exemplo, aqui estão dois CSVs embutidos com codificações incomuns:
"
x1 <- "text\nEl Ni\xf1o was particularly bad this year"
read_csv(x1)$text

x2 <- "text\n\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
read_csv(x2)$text

"
Para lê-los corretamente, você especifica a codificação através do argumento locale:
"
read_csv(x1, locale = locale(encoding = "Latin1"))$text

read_csv(x2, locale = locale(encoding = "Shift-JIS"))$text

"
Como você encontra a codificação correta? Se tiver sorte, ela estará incluída em algum lugar na documentação dos dados. Infelizmente, raramente é o caso, então o readr fornece guess_encoding() para ajudá-lo a descobrir. Não é infalível e funciona melhor quando você tem muito texto (diferente daqui), mas é um ponto de partida razoável. Espere tentar algumas codificações diferentes antes de encontrar a certa.

Codificações são um tópico rico e complexo; só arranhamos a superfície aqui. Se você quiser aprender mais, recomendamos ler a explicação detalhada em http://kunststube.net/encoding/.
"
#----14.6.2 Variações de letras----
#---------------------------------
"
Trabalhar em idiomas com acentos representa um desafio significativo ao determinar a posição das letras (por exemplo, com str_length() e str_sub()), pois letras acentuadas podem ser codificadas como um único caractere individual (por exemplo, ü) ou como dois caracteres combinando uma letra não acentuada (por exemplo, u) com um sinal diacrítico (por exemplo, ¨). Por exemplo, este código mostra duas maneiras de representar ü que parecem idênticas:
"
u <- c("\u00fc", "u\u0308")
str_view(u)

"
Mas ambas as strings diferem em comprimento, e seus primeiros caracteres são diferentes:
"
str_length(u)
str_sub(u, 1, 1)

"
Finalmente, observe que uma comparação dessas strings com == interpreta essas strings como diferentes, enquanto a prática função str_equal() no stringr reconhece que ambas têm a mesma aparência:
"
u[[1]] == u[[2]]

str_equal(u[[1]], u[[2]])

#----14.6.3 Funções dependentes de localidade----
#------------------------------------------------
"
Finalmente, há um punhado de funções stringr cujo comportamento depende do seu local (locale). Um local é semelhante a um idioma, mas inclui um especificador de região opcional para lidar com variações regionais dentro de um idioma. Um local é especificado por uma abreviação de idioma em letras minúsculas, seguida opcionalmente por um _ e um identificador de região em letras maiúsculas. Por exemplo, 'en' é inglês, 'en_GB' é inglês britânico e 'en_US' é inglês americano. Se você não sabe o código do seu idioma, a Wikipedia tem uma boa lista, e você pode ver quais são suportados no stringr olhando para stringi::stri_locale_list().

As funções de string do R base usam automaticamente o local definido pelo seu sistema operacional. Isso significa que as funções de string do R base fazem o que você espera para o seu idioma, mas seu código pode funcionar de maneira diferente se você compartilhá-lo com alguém que mora em um país diferente. Para evitar esse problema, o stringr usa como padrão as regras em inglês, usando o local 'en' e exige que você especifique o argumento locale para substituí-lo. Felizmente, existem dois conjuntos de funções onde o local realmente importa: alterar o caso e ordenar.

As regras para alterar os casos diferem entre os idiomas. Por exemplo, o turco tem dois i’s: com e sem ponto. Já que são duas letras distintas, elas são capitalizadas de maneira diferente:
"
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

"
Ordenar strings depende da ordem do alfabeto, e a ordem do alfabeto não é a mesma em todos os idiomas! Aqui está um exemplo: em tcheco, 'ch' é uma letra composta que aparece após o h no alfabeto.
"
str_sort(c("a", "c", "ch", "h", "z"))
str_sort(c("a", "c", "ch", "h", "z"), locale = "cs")

"
Isso também acontece ao ordenar strings com dplyr::arrange(), razão pela qual também tem um argumento de local.
"