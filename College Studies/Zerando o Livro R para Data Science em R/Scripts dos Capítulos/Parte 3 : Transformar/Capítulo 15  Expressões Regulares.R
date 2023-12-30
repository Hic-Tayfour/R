#Capítulo 15 : Expressões Regulares
#==================================

#----15.1 Introdução----
#-------------------------
"
Anteriormente, você aprendeu um monte de funções úteis para trabalhar com strings. Este capítulo se concentrará em funções que usam expressões regulares, uma linguagem concisa e poderosa para descrever padrões dentro de strings. O termo 'expressão regular' é um pouco longo, então a maioria das pessoas o abrevia para 'regex' ou 'regexp'.

O capítulo começa com o básico de expressões regulares e as funções stringr mais úteis para análise de dados. Em seguida, expandiremos seu conhecimento sobre padrões e cobriremos sete tópicos importantes novos (escapar caracteres, ancoragem, classes de caracteres, classes abreviadas, quantificadores, precedência e agrupamento). Depois, falaremos sobre alguns dos outros tipos de padrões com os quais as funções stringr podem trabalhar e as várias 'flags' que permitem ajustar a operação de expressões regulares. Concluiremos com uma pesquisa de outros lugares no tidyverse e no R base onde você pode usar regexes.
"

#----15.1.1 Pré-requisitos----
#-----------------------------
"
Neste capítulo, usaremos funções de expressão regular do stringr e do tidyr, ambos membros centrais do tidyverse, bem como dados do pacote babynames.
"
library(tidyverse)
library(babynames)

"
Ao longo deste capítulo, usaremos uma mistura de exemplos muito simples embutidos para que você possa entender a ideia básica, os dados de nomes de bebês e três vetores de caracteres do stringr:
"
  #1º fruit contém os nomes de 80 frutas.
  #2º words contém 980 palavras comuns em inglês.
  #3º sentences contém 720 frases curtas.


#----15.2 Noções básicas de padrão----
#-------------------------------------
"

Claro, aqui está o texto com as aspas duplas substituídas por aspas simples:

Vamos usar str_view() para aprender como padrões de regex funcionam. Usamos str_view() no último capítulo para entender melhor uma string versus sua representação impressa, e agora o usaremos com seu segundo argumento, uma expressão regular. Quando isso é fornecido, str_view() mostrará apenas os elementos do vetor de string que correspondem, cercando cada correspondência com '<>', e, quando possível, destacando a correspondência em azul.

Os padrões mais simples consistem em letras e números que correspondem exatamente a esses caracteres:
"
str_view(fruit, "berry")

"
Letras e números correspondem exatamente e são chamados de caracteres literais. A maioria dos caracteres de pontuação, como ., +, *, [, ], e ?, têm significados especiais e são chamados de metacaracteres. Por exemplo, . corresponderá a qualquer caractere, então 'a.' corresponderá a qualquer string que contenha um 'a' seguido por outro caractere:
"
str_view(c("a", "ab", "ae", "bd", "ea", "eab"), "a.")

"
Ou poderíamos encontrar todas as frutas que contêm um 'a', seguido por três letras, seguido por um 'e':
"
str_view(fruit, "a...e")

"
Quantificadores controlam quantas vezes um padrão pode corresponder:
"

  #1º '?' torna um padrão opcional (ou seja, corresponde 0 ou 1 vez)
  #2º '+' permite que um padrão se repita (ou seja, corresponde pelo menos uma vez)
  #3º '*' permite que um padrão seja opcional ou se repita (ou seja, corresponde a qualquer número de vezes, incluindo 0).

# ab? corresponde a um 'a', opcionalmente seguido por um 'b
str_view(c("a", "ab", "abb"), "ab?")

# ab+ corresponde a um 'a', seguido por pelo menos um 'b'.
str_view(c("a", "ab", "abb"), "ab+")

# ab* corresponde a um 'a', seguido por qualquer número de 'b's.
str_view(c("a", "ab", "abb"), "ab*")

"
Classes de caracteres são definidas por '[]' e permitem que você corresponda a um conjunto de caracteres, por exemplo, '[abcd]' corresponde a 'a', 'b', 'c' ou 'd'. Você também pode inverter a correspondência começando com '^': '[^abcd]' corresponde a qualquer coisa exceto 'a', 'b', 'c' ou 'd'. Podemos usar essa ideia para encontrar as palavras contendo um 'x' cercado por vogais ou um 'y' cercado por consoantes:
"
str_view(words, "[aeiou]x[aeiou]")
str_view(words, "[^aeiou]y[^aeiou]")

"
Você pode usar alternância, '|', para escolher entre um ou mais padrões alternativos. Por exemplo, os seguintes padrões procuram por frutas contendo 'apple', 'melon' ou 'nut', ou uma vogal repetida.
"
str_view(fruit, "apple|melon|nut")
str_view(fruit, "aa|ee|ii|oo|uu")

"
Expressões regulares são muito compactas e usam muitos caracteres de pontuação, então elas podem parecer esmagadoras e difíceis de ler no início. Não se preocupe; você vai melhorar com a prática, e padrões simples logo se tornarão naturais. Vamos iniciar esse processo praticando com algumas funções úteis do stringr.
"

#----15.3 Funções-chave----
#-------------------------
"
Agora que você já tem o básico das expressões regulares, vamos usá-las com algumas funções do stringr e tidyr. Na próxima seção, você aprenderá como detectar a presença ou ausência de uma correspondência, como contar o número de correspondências, como substituir uma correspondência por texto fixo e como extrair texto usando um padrão.
"

#----15.3.1 Detectar correspondências----
#----------------------------------------
"
str_detect() retorna um vetor lógico que é TRUE se o padrão corresponder a um elemento do vetor de caracteres e FALSE caso contrário:
"
str_detect(c("a", "b", "c"), "[aeiou]")

"
Como str_detect() retorna um vetor lógico do mesmo comprimento que o vetor inicial, ele combina bem com filter(). Por exemplo, este código encontra todos os nomes mais populares que contêm um 'x' minúsculo:
"
babynames |> 
  filter(str_detect(name, "x")) |> 
  count(name, wt = n, sort = TRUE)

"
Também podemos usar str_detect() com summarize() emparelhando-o com sum() ou mean(): sum(str_detect(x, pattern)) informa o número de observações que correspondem e mean(str_detect(x, pattern)) informa a proporção que corresponde. Por exemplo, o trecho a seguir calcula e visualiza a proporção de nomes de bebês que contêm 'x', divididos por ano. Parece que eles aumentaram radicalmente em popularidade recentemente!
"
babynames |> 
  group_by(year) |> 
  summarize(prop_x = mean(str_detect(name, "x"))) |> 
  ggplot(aes(x = year, y = prop_x)) + 
  geom_line()

"
Há duas funções que são intimamente relacionadas a str_detect(): str_subset() e str_which(). str_subset() retorna um vetor de caracteres contendo apenas as strings que correspondem. str_which() retorna um vetor inteiro dando as posições das strings que correspondem.
"

#----15.3.2 Contar correspondências----
#--------------------------------------
"
O próximo passo em complexidade após str_detect() é str_count(): em vez de verdadeiro ou falso, ele informa quantas correspondências há em cada string.
"
x <- c("apple", "banana", "pear")
str_count(x, "p")

"
Note que cada correspondência começa no final da correspondência anterior, ou seja, as correspondências de regex nunca se sobrepõem. Por exemplo, em 'abababa', quantas vezes o padrão 'aba' corresponde? Expressões regulares dizem duas, não três:
"
str_count("abababa", "aba")
str_view("abababa", "aba")

"
É natural usar str_count() com mutate(). O seguinte exemplo usa str_count() com classes de caracteres para contar o número de vogais e consoantes em cada nome.
"
babynames |> 
  count(name) |> 
  mutate(
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

"
Se você olhar atentamente, notará que há algo errado com nossos cálculos: 'Aaban' contém três 'a's, mas nosso resumo relata apenas duas vogais. Isso ocorre porque expressões regulares diferenciam maiúsculas de minúsculas. Existem três maneiras de corrigir isso:
"
  #1º Adicione as vogais maiúsculas à classe de caracteres: str_count(name, "[aeiouAEIOU]").
  #2º Diga à expressão regular para ignorar o caso: str_count(name, regex("[aeiou]", ignore_case = TRUE)). 
  #3º Use str_to_lower() para converter os nomes para minúsculas: str_count(str_to_lower(name), "[aeiou]").

"
Essa variedade de abordagens é bastante típica ao trabalhar com strings — muitas vezes há várias maneiras de alcançar seu objetivo, seja tornando seu padrão mais complicado ou fazendo algum pré-processamento na sua string. Se você ficar preso tentando uma abordagem, muitas vezes pode ser útil mudar de estratégia e atacar o problema de uma perspectiva diferente.

Neste caso, como estamos aplicando duas funções ao nome, acho mais fácil transformá-lo primeiro:
"
babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name),
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

#----15.3.3 Substituir valores----
#---------------------------------
"
Além de detectar e contar correspondências, também podemos modificá-las com str_replace() e str_replace_all(). str_replace() substitui a primeira correspondência e, como o nome sugere, str_replace_all() substitui todas as correspondências.
"
x <- c("apple", "pear", "banana")
str_replace_all(x, "[aeiou]", "-")

"
str_remove() e str_remove_all() são atalhos úteis para str_replace(x, pattern, ""):
"
x <- c("apple", "pear", "banana")
str_remove_all(x, "[aeiou]")

"
Essas funções são naturalmente emparelhadas com mutate() ao fazer limpeza de dados, e você frequentemente as aplicará repetidamente para remover camadas de formatação inconsistente.
"

#----15.3.4 Extrair variáveis----
#--------------------------------
"

A última função que discutiremos usa expressões regulares para extrair dados de uma coluna para uma ou mais novas colunas: separate_wider_regex(). É uma função semelhante às separate_wider_position() e separate_wider_delim() que você aprendeu anteriormente. Essas funções estão no tidyr porque operam em (colunas de) data frames, em vez de vetores individuais.

Vamos criar um conjunto de dados simples para mostrar como funciona. Aqui temos alguns dados derivados de babynames onde temos o nome, gênero e idade de várias pessoas em um formato um tanto estranho:
"
df <- tribble(
  ~str,
  "<Sheryl>-F_34",
  "<Kisha>-F_45", 
  "<Brandon>-N_33",
  "<Sharon>-F_38", 
  "<Penny>-F_58",
  "<Justin>-M_41", 
  "<Patricia>-F_84", 
)

"
Para extrair esses dados usando separate_wider_regex(), só precisamos construir uma sequência de expressões regulares que correspondam a cada parte. Se quisermos que o conteúdo dessa parte apareça na saída, damos a ela um nome:
"
df |> 
  separate_wider_regex(
    str,
    patterns = c(
      "<", 
      name = "[A-Za-z]+", 
      ">-", 
      gender = ".",
      "_",
      age = "[0-9]+"
    )
  )

"
Se a correspondência falhar, você pode usar too_short = 'debug' para descobrir o que deu errado, assim como separate_wider_delim() e separate_wider_position().
"

#----15.4 Detalhes do padrão----
#-------------------------------
"
Agora que você entende o básico da linguagem de padrões e como usá-la com algumas funções do stringr e tidyr, é hora de mergulhar em mais detalhes. Primeiro, começaremos com o escaping, que permite corresponder a metacaracteres que, de outra forma, seriam tratados de maneira especial. Em seguida, você aprenderá sobre âncoras, que permitem corresponder ao início ou ao fim da string. Depois, você aprenderá mais sobre classes de caracteres e seus atalhos, que permitem corresponder a qualquer caractere de um conjunto. Em seguida, você aprenderá os detalhes finais dos quantificadores que controlam quantas vezes um padrão pode corresponder. Então, temos que cobrir o importante (mas complexo) tópico da precedência de operadores e parênteses. E terminaremos com alguns detalhes sobre a agrupamento de componentes do padrão.

Os termos que usamos aqui são os nomes técnicos para cada componente. Eles nem sempre são os mais evocativos de seu propósito, mas é muito útil conhecer os termos corretos se você quiser procurar mais detalhes no Google mais tarde.
"

#----15.4.1 Escapando----
#-------------------------
"
Para corresponder a um '.' literal, você precisa de um escape que diga à expressão regular para corresponder aos metacaracteres literalmente. Como nas strings, as regex usam a barra invertida para escaping. Então, para corresponder a um '.', você precisa da regex .. Infelizmente isso cria um problema. Usamos strings para representar expressões regulares, e \ também é usado como um símbolo de escape em strings. Então, para criar a expressão regular . precisamos da string '\.', como o exemplo a seguir mostra.
"

#Para criar a expressão regular ., precisamos usar \\.
dot <- "\\."

# Mas a expressão em si contém apenas uma \
str_view(dot)

# E isso diz ao R para procurar um '.' explícito.
str_view(c("abc", "a.c", "bef"), "a\\.c")

"
Aqui, geralmente escreveremos expressões regulares sem aspas, como .. Se precisarmos enfatizar o que você realmente digitará, cercaremos com aspas e adicionaremos escapes extras, como '\.'.

Se \ é usado como um caractere de escape em expressões regulares, como você corresponde a um \ literal? Bem, você precisa escapá-lo, criando a expressão regular \. Para criar essa expressão regular, você precisa usar uma string, que também precisa escapar . Isso significa que para corresponder a um \ literal você precisa escrever '\\' — você precisa de quatro barras invertidas para corresponder a uma!
"
x <- "a\\b"
str_view(x)
str_view(x, "\\\\")

"
Alternativamente, você pode achar mais fácil usar as strings brutas que aprendeu anteriormente. Isso permite evitar uma camada de escaping:
"
str_view(x, r"{\\}")

"
Se você está tentando corresponder a um '.', '$', '|', '*', '+', '?', '{', '}', '(', ')', literal, há uma alternativa para usar um escape de barra invertida: você pode usar uma classe de caracteres: [.]', '[$]', '[|]', ... todos correspondem aos valores literais.
"
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

#----15.4.2 Âncoras----
#-----------------------
"
By default, regular expressions will match any part of a string. If you want to match at the start or end you need to anchor the regular expression using ^ to match the start or $ to match the end:
"
str_view(fruit, "^a")
str_view(fruit, "a$")

"
É tentador pensar que $ deveria corresponder ao início de uma string, porque é assim que escrevemos valores em dinheiro, mas não é isso que as expressões regulares querem.

Para forçar uma expressão regular a corresponder apenas à string inteira, ancore-a com ambos ^ e $:
"
str_view(fruit, "apple")
str_view(fruit, "^apple$")

"
Você também pode corresponder ao limite entre palavras (ou seja, o início ou o fim de uma palavra) com \b. Isso pode ser particularmente útil ao usar a ferramenta de localizar e substituir do RStudio. Por exemplo, se quiser encontrar todos os usos de sum(), você pode procurar por \bsum\b para evitar corresponder summarize, summary, rowsum e assim por diante:
"
x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(x, "sum")
str_view(x, "\\bsum\\b")

"
Quando usados sozinhos, âncoras produzirão uma correspondência de largura zero:
"
str_view("abc", c("$", "^", "\\b"))

"
Isso ajuda a entender o que acontece quando você substitui uma âncora isolada:
"
str_replace_all("abc", c("$", "^", "\\b"), "--")

#----15.4.3 Classes de caracteres----
#------------------------------------
"
Uma classe de caracteres, ou conjunto de caracteres, permite que você corresponda a qualquer caractere em um conjunto. Como discutimos acima, você pode construir seus próprios conjuntos com '[]', onde '[abc]' corresponde a 'a', 'b' ou 'c' e '[^abc]' corresponde a qualquer caractere exceto 'a', 'b' ou 'c'. Além de '^', há outros dois caracteres que têm significado especial dentro de '[]':
"
  #1º define um intervalo, por exemplo, '[a-z]' corresponde a qualquer letra minúscula e '[0-9]' corresponde a qualquer número.
  #2º \ escapa caracteres especiais, então '[^-]]' corresponde a '^', '-' ou ']'.

"
Aqui estão alguns exemplos:
"
x <- "abcd ABCD 12345 -!@#%."
str_view(x, "[abc]+")
str_view(x, "[a-z]+")
str_view(x, "[^a-z0-9]+")

# Você precisa de um escape para corresponder a caracteres que são
#especiais dentro de []
str_view("a-b-c", "[a-c]")
str_view("a-b-c", "[a\\-c]")

"
Algumas classes de caracteres são usadas tão comumente que recebem seu próprio atalho. Você já viu '.', que corresponde a qualquer caractere exceto uma nova linha. Há três outros pares particularmente úteis:
"
  #1º \d corresponde a qualquer dígito; \D corresponde a qualquer coisa que não seja um dígito.

  #2º \s corresponde a qualquer espaço em branco (por exemplo, espaço, tabulação, nova linha); \S corresponde a qualquer coisa que não seja espaço em branco.

  #3º \w corresponde a qualquer caractere de 'palavra', ou seja, letras e números; \W corresponde a qualquer caractere de 'não palavra'.


"
O seguinte código demonstra os seis atalhos com uma seleção de letras, números e caracteres de pontuação.
"
x <- "abcd ABCD 12345 -!@#%."
str_view(x, "\\d+")
str_view(x, "\\D+")
str_view(x, "\\s+")
str_view(x, "\\S+")
str_view(x, "\\w+")
str_view(x, "\\W+")

#----15.4.4 Quantificadores----
#-------------------------------
"
Quantificadores controlam quantas vezes um padrão corresponde. Na Seção 15.2 você aprendeu sobre '?' (0 ou 1 correspondência), '+' (1 ou mais correspondências) e '*' (0 ou mais correspondências). Por exemplo, 'colou?r' corresponderá à ortografia americana ou britânica, '\d+' corresponderá a um ou mais dígitos, e '\s?' corresponderá opcionalmente a um único item de espaço em branco. Você também pode especificar o número exato de correspondências com '{}':
"
  #1º {n} corresponde exatamente n vezes.
  #2º {n,} corresponde pelo menos n vezes.
  #3º {n,m} corresponde entre n e m vezes.

#----15.4.5 Precedência de operadores e parênteses----
#----------------------------------------------------
"
O que 'ab+' corresponde? Ele corresponde a 'a' seguido por um ou mais 'b's, ou corresponde a 'ab' repetido qualquer número de vezes? O que '^a|b$' corresponde? Ele corresponde à string completa 'a' ou à string completa 'b', ou ele corresponde a uma string que começa com 'a' ou uma string que termina com 'b'?

A resposta para essas perguntas é determinada pela precedência de operadores, semelhante às regras PEMDAS ou BEDMAS que você pode ter aprendido na escola. Você sabe que 'a + b * c' é equivalente a 'a + (b * c)' e não '(a + b) * c' porque '' tem maior precedência e '+' tem menor precedência: você calcula '' antes de '+'.

Da mesma forma, expressões regulares têm suas próprias regras de precedência: quantificadores têm alta precedência e alternância tem baixa precedência, o que significa que 'ab+' é equivalente a 'a(b+)', e '^a|b$' é equivalente a '(^a)|(b$)'. Assim como na álgebra, você pode usar parênteses para substituir a ordem usual. Mas, ao contrário da álgebra, é improvável que você lembre das regras de precedência para regexes, então sinta-se à vontade para usar parênteses liberalmente.
"

#----15.4.6 Agrupamento e captura----
#------------------------------------
"
Além de substituir a precedência de operadores, os parênteses têm outro efeito importante: eles criam grupos de captura que permitem que você use subcomponentes da correspondência.

A primeira maneira de usar um grupo de captura é referir-se a ele dentro de uma correspondência com uma referência de volta: \1 refere-se à correspondência contida no primeiro parêntese, \2 no segundo parêntese, e assim por diante. Por exemplo, o seguinte padrão encontra todas as frutas que têm um par de letras repetido:
"
str_view(fruit, "(..)\\1")

"
E este encontra todas as palavras que começam e terminam com o mesmo par de letras:
"
str_view(words, "^(..).*\\1$")

"
Você também pode usar referências de volta em str_replace(). Por exemplo, este código troca a ordem da segunda e terceira palavras em frases:
"
sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()

"
Se você quiser extrair as correspondências para cada grupo, pode usar str_match(). Mas str_match() retorna uma matriz, então não é particularmente fácil de trabalhar com:
"
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  head()

"
Você poderia converter em uma tibble e nomear as colunas:
"
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  as_tibble(.name_repair = "minimal") |> 
  set_names("match", "word1", "word2")

"
Mas então você basicamente recriou sua própria versão de separate_wider_regex(). De fato, por trás dos bastidores, separate_wider_regex() converte seu vetor de padrões em uma única regex que usa agrupamento para capturar os componentes nomeados.

Ocasionalmente, você vai querer usar parênteses sem criar grupos de correspondência. Você pode criar um grupo não capturante com (?:).
"
x <- c("a gray cat", "a grey dog")
str_match(x, "gr(e|a)y")
str_match(x, "gr(?:e|a)y")

#----15.5 Controle de padrão----
#-------------------------------
"
É possível exercer controle extra sobre os detalhes da correspondência usando um objeto de padrão em vez de apenas uma string. Isso permite controlar as chamadas flags de regex e corresponder a vários tipos de strings fixas, conforme descrito abaixo.
"

#----15.5.1 Regex flags----
#---------------------------
"
Existem várias configurações que podem ser usadas para controlar os detalhes da expressão regular. Essas configurações são frequentemente chamadas de flags em outras linguagens de programação. No stringr, você pode usar essas configurações envolvendo o padrão em uma chamada para regex(). A flag mais útil é provavelmente ignore_case = TRUE, porque permite que os caracteres correspondam tanto às suas formas maiúsculas quanto minúsculas:
"
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

"
Se você estiver trabalhando muito com strings multilinha (ou seja, strings que contêm \n), dotall e multiline também podem ser úteis:
"
  #1º dotall = TRUE permite que . corresponda a tudo, incluindo \n:
x <- "Line 1\nLine 2\nLine 3"
str_view(x, ".Line")
str_view(x, regex(".Line", dotall = TRUE))

  #2º multiline = TRUE faz com que ^ e $ correspondam ao início e ao fim de cada linha, em vez do início e do fim da string completa:
x <- "Line 1\nLine 2\nLine 3"
str_view(x, "^Line")
str_view(x, regex("^Line", multiline = TRUE))

"
Finalmente, se você estiver escrevendo uma expressão regular complicada e estiver preocupado que possa não entender no futuro, você pode tentar comments = TRUE. Isso ajusta a linguagem de padrões para ignorar espaços e novas linhas, bem como tudo depois de #. Isso permite que você use comentários e espaços em branco para tornar expressões regulares complexas mais compreensíveis, como no seguinte exemplo:
"
phone <- regex(
  r"(
    \(?     # optional opening parens
    (\d{3}) # area code
    [)\-]?  # optional closing parens or dash
    \ ?     # optional space
    (\d{3}) # another three numbers
    [\ -]?  # optional space or dash
    (\d{4}) # four more numbers
  )", 
  comments = TRUE
)

str_extract(c("514-791-8141", "(123) 456 7890", "123456"), phone)

"
Se você estiver usando comentários e quiser corresponder a um espaço, nova linha ou #, precisará escapar com \.
"

#----15.5.2 Fixed matches----
#----------------------------
"
Você pode optar por não usar as regras de expressão regular usando fixed():
"
str_view(c("", "a", "."), fixed("."))

"
fixed() também lhe dá a capacidade de ignorar maiúsculas e minúsculas:
"
str_view("x X", "X")
str_view("x X", fixed("X", ignore_case = TRUE))

"
Se você estiver trabalhando com texto em idioma não inglês, provavelmente vai querer coll() em vez de fixed(), pois ele implementa as regras completas de capitalização usadas pelo local que você especificar.
"
str_view("i İ ı I", fixed("İ", ignore_case = TRUE))
str_view("i İ ı I", coll("İ", ignore_case = TRUE, locale = "tr"))

#----15.6 Prática----
#--------------------
"
Para colocar essas ideias em prática, resolveremos alguns problemas semi-autênticos a seguir. Discutiremos três técnicas gerais:
"
  #1º Verificar seu trabalho criando controles positivos e negativos simples
  #2º Combinar expressões regulares com álgebra booleana
  #3º Criar padrões complexos usando manipulação de string

#----15.6.1 Check your work----
#------------------------------
"
Primeiro, vamos encontrar todas as frases que começam com 'The'. Usar apenas o âncora '^' não é suficiente
"
str_view(sentences, "^The")

"
Porque esse padrão também corresponde a frases que começam com palavras como 'They' ou 'These'. Precisamos garantir que o 'e' seja a última letra da palavra, o que podemos fazer adicionando um limite de palavra:
"
str_view(sentences, "^The\\b")

"
E quanto a encontrar todas as frases que começam com um pronome?
"
str_view(sentences, "^She|He|It|They\\b")

"
Uma rápida inspeção dos resultados mostra que estamos obtendo algumas correspondências espúrias. Isso ocorre porque esquecemos de usar parênteses:
"
str_view(sentences, "^(She|He|It|They)\\b")

"
Você pode se perguntar como poderia detectar esse tipo de erro se ele não ocorresse nas primeiras correspondências. Uma boa técnica é criar alguns exemplos positivos e negativos e usá-los para testar se seu padrão funciona conforme o esperado:
"
pos <- c("He is a boy", "She had a good time")
neg <- c("Shells come from the sea", "Hadley said 'It's a great day'")

pattern <- "^(She|He|It|They)\\b"
str_detect(pos, pattern)
str_detect(neg, pattern)

"
Geralmente é muito mais fácil encontrar bons exemplos positivos do que negativos, porque leva um tempo até que você seja bom o suficiente com expressões regulares para prever onde estão suas fraquezas. No entanto, eles ainda são úteis: à medida que você trabalha no problema, você pode acumular lentamente uma coleção de seus erros, garantindo que nunca cometa o mesmo erro duas vezes.
"

#----15.6.2 Boolean operations----
#--------------------------------
"
Imagine que queremos encontrar palavras que contenham apenas consoantes. Uma técnica é criar uma classe de caracteres que contenha todas as letras, exceto as vogais ('[^aeiou]'), permitir que isso corresponda a qualquer número de letras ('[^aeiou]+'), depois forçá-la a corresponder a toda a string ancorando no início e no fim ('^[^aeiou]+$'):
"
str_view(words, "^[^aeiou]+$")

"
Mas você pode tornar esse problema um pouco mais fácil invertendo a questão. Em vez de procurar por palavras que contenham apenas consoantes, poderíamos procurar por palavras que não contenham nenhuma vogal:
"
str_view(words[!str_detect(words, "[aeiou]")])

"
Essa é uma técnica útil sempre que você estiver lidando com combinações lógicas, particularmente aquelas envolvendo 'e' ou 'não'. Por exemplo, imagine se você quiser encontrar todas as palavras que contêm 'a' e 'b'. Não há um operador 'e' incorporado nas expressões regulares, então temos que abordar isso procurando todas as palavras que contêm um 'a' seguido por um 'b' ou um 'b' seguido por um 'a':
"
str_view(words, "a.*b|b.*a")

"
É mais simples combinar os resultados de duas chamadas para str_detect():
"
words[str_detect(words, "a") & str_detect(words, "b")]

"
E se quiséssemos ver se há uma palavra que contém todas as vogais? Se fizéssemos isso com padrões, precisaríamos gerar 5! (120) padrões diferentes:
"
words[str_detect(words, "a.*e.*i.*o.*u")]
words[str_detect(words, "u.*o.*i.*e.*a")]

"
É muito mais simples combinar cinco chamadas para str_detect():
"
words[
  str_detect(words, "a") &
    str_detect(words, "e") &
    str_detect(words, "i") &
    str_detect(words, "o") &
    str_detect(words, "u")
]

"
Em geral, se você ficar preso tentando criar uma única regexp que resolva seu problema, dê um passo para trás e pense se você poderia dividir o problema em partes menores, resolvendo cada desafio antes de passar para o próximo.
"

#----15.6.3 Creating a pattern with code----
#-------------------------------------------
"
E se quiséssemos encontrar todas as frases que mencionam uma cor? A ideia básica é simples: nós apenas combinamos alternância com limites de palavras.
"
str_view(sentences, "\\b(red|green|blue)\\b")

"
Mas à medida que o número de cores aumenta, rapidamente se tornaria tedioso construir esse padrão manualmente. Não seria bom se pudéssemos armazenar as cores em um vetor?
"
rgb <- c("red", "green", "blue")

"
Bem, podemos! Só precisaríamos criar o padrão a partir do vetor usando str_c() e str_flatten():
"
str_c("\\b(", str_flatten(rgb, "|"), ")\\b")

"
Poderíamos tornar esse padrão mais abrangente se tivéssemos uma boa lista de cores. Um ponto de partida poderia ser a lista de cores integradas que o R pode usar para gráficos:
"
str_view(colors())

"
Mas primeiro vamos eliminar as variantes numeradas:
"
cols <- colors()
cols <- cols[!str_detect(cols, "\\d")]
str_view(cols)

"
Então, podemos transformar isso em um grande padrão. Não mostraremos o padrão aqui porque é enorme, mas você pode ver como ele funciona:
"
pattern <- str_c("\\b(", str_flatten(cols, "|"), ")\\b")
str_view(sentences, pattern)

"
Neste exemplo, 'cols' contém apenas números e letras, então você não precisa se preocupar com metacaracteres. Mas, em geral, sempre que você criar padrões a partir de strings existentes, é prudente executá-los através de str_escape() para garantir que eles correspondam literalmente.
"

#----15.7 Regular expressions in other places----
#------------------------------------------------
"
Assim como nas funções stringr e tidyr, há muitos outros lugares no R onde você pode usar expressões regulares. As seções a seguir descrevem algumas outras funções úteis no tidyverse mais amplo e no R base.
"

#----15.7.1 tidyverse----
#------------------------
"
Há três outros lugares particularmente úteis onde você pode querer usar expressões regulares:
"
  #1º matches(pattern) selecionará todas as variáveis cujo nome corresponde ao padrão fornecido. É uma função 'tidyselect' que você pode usar em qualquer lugar, em qualquer função do tidyverse que selecione variáveis (por exemplo, select(), rename_with() e across()).
  #2º O argumento names_pattern de pivot_longer() aceita um vetor de expressões regulares, assim como separate_wider_regex(). É útil ao extrair dados de nomes de variáveis com uma estrutura complexa.
  #3º O argumento delim em separate_longer_delim() e separate_wider_delim() geralmente corresponde a uma string fixa, mas você pode usar regex() para fazer com que corresponda a um padrão. Isso é útil, por exemplo, se você quiser corresponder a uma vírgula que é opcionalmente seguida por um espaço, ou seja, regex(', ?').

#----15.7.2 Base R----
#----------------------
"
apropos(pattern) busca todos os objetos disponíveis no ambiente global que correspondem ao padrão fornecido. Isso é útil se você não se lembra exatamente do nome de uma função:
"
apropos("replace")

"
list.files(path, pattern) lista todos os arquivos em path que correspondem a um padrão de expressão regular. Por exemplo, você pode encontrar todos os arquivos R Markdown no diretório atual com:
"
head(list.files(pattern = "\\.Rmd$"))

"
Vale a pena notar que a linguagem de padrões usada pelo R base é ligeiramente diferente da usada pelo stringr. Isso porque o stringr é construído em cima do pacote stringi, que por sua vez é construído em cima do motor ICU, enquanto as funções do R base usam o motor TRE ou o motor PCRE, dependendo de você ter definido perl = TRUE ou não. Felizmente, os fundamentos das expressões regulares são tão bem estabelecidos que você encontrará poucas variações ao trabalhar com os padrões que você aprenderá neste livro. Você só precisa estar ciente da diferença quando começar a confiar em recursos avançados como complexos intervalos de caracteres Unicode ou recursos especiais que usam a sintaxe (?...).
"