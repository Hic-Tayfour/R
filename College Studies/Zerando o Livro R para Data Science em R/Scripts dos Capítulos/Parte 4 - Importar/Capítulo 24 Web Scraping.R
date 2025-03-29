# Capítulo 24: Web Scraping
# =========================

#----24.1 Introdução----
#-----------------------
"
Este capítulo apresenta os fundamentos da web scraping com o rvest. A web scraping é uma ferramenta muito útil para extrair dados de páginas da web. Alguns sites oferecem uma API, um conjunto de solicitações HTTP estruturadas que retornam dados como JSON, que você pode manipular usando as técnicas vistas anteriormente. Sempre que possível, você deve usar a API, porque normalmente ela fornecerá dados mais confiáveis. Infelizmente, no entanto, programar com APIs da web está fora do escopo deste livro. Em vez disso, estamos ensinando web scraping, uma técnica que funciona independentemente de o site fornecer ou não uma API.

Neste capítulo, discutiremos primeiro a ética e legalidades da web scraping antes de mergulharmos nos fundamentos do HTML. Você aprenderá os conceitos básicos de seletores CSS para localizar elementos específicos na página e como usar as funções do rvest para obter dados de texto e atributos do HTML e levá-los para o R. Em seguida, discutiremos algumas técnicas para descobrir qual seletor CSS você precisa para a página que está raspando, antes de finalizar com alguns estudos de caso e uma breve discussão sobre sites dinâmicos.
"

#----24.1.1 Pré-requisitos----
#-----------------------------
"
Agora, nos concentraremos nas ferramentas fornecidas pelo rvest. O rvest é um membro do tidyverse, mas não é um membro central, então você precisará carregá-lo explicitamente. Também carregaremos o tidyverse completo, pois ele será geralmente útil para trabalhar com os dados que raspamos.
"
library(tidyverse)
library(rvest)

#----24.2 Ética e Legalidades da Raspagem de Dados----
#-----------------------------------------------------
"
Antes de começarmos a discutir o código que você precisará para realizar a web scraping, precisamos falar sobre se é legal e ético fazê-lo. No geral, a situação é complicada em relação a ambos os aspectos.

As legalidades dependem muito de onde você mora. No entanto, como princípio geral, se os dados são públicos, não pessoais e factuais, é provável que você esteja ok. Esses três fatores são importantes porque estão conectados aos termos e condições do site, informações pessoalmente identificáveis e direitos autorais, como discutiremos a seguir.

Se os dados não são públicos, não pessoais ou factuais, ou se você está raspando os dados especificamente para ganhar dinheiro com eles, você precisará conversar com um advogado. Em qualquer caso, você deve ser respeitoso com os recursos do servidor que hospeda as páginas que você está raspando. O mais importante é que, se você está raspando muitas páginas, deve ter certeza de esperar um pouco entre cada solicitação. Uma maneira fácil de fazer isso é usar o pacote polite de Dmytro Perepolkin. Ele pausará automaticamente entre as solicitações e armazenará em cache os resultados, então você nunca pedirá a mesma página duas vezes.
"

#----24.2.1 Termos de Serviço----
#--------------------------------
"
Se você olhar atentamente, encontrará muitos sites que incluem um link de 'termos e condições' ou 'termos de serviço' em algum lugar da página, e se você ler essa página atentamente, muitas vezes descobrirá que o site proíbe especificamente a web scraping. Essas páginas tendem a ser uma apropriação legal onde as empresas fazem reivindicações muito amplas. É educado respeitar esses termos de serviço quando possível, mas leve em consideração qualquer afirmação com um grão de sal.

Os tribunais dos EUA geralmente concluíram que simplesmente colocar os termos de serviço no rodapé do site não é suficiente para você ser vinculado a eles, por exemplo, HiQ Labs v. LinkedIn. Geralmente, para estar vinculado aos termos de serviço, você deve ter tomado alguma ação explícita, como criar uma conta ou marcar uma caixa. É por isso que é importante saber se os dados são públicos ou não; se você não precisa de uma conta para acessá-los, é improvável que você esteja vinculado aos termos de serviço. No entanto, observe que a situação é bastante diferente na Europa, onde os tribunais consideraram que os termos de serviço são aplicáveis mesmo se você não concordar explicitamente com eles.
"

#----24.2.2 Informações Pessoalmente Identificáveis----
#------------------------------------------------------
"
Mesmo que os dados sejam públicos, você deve ter extremo cuidado ao raspar informações pessoalmente identificáveis, como nomes, endereços de e-mail, números de telefone, datas de nascimento, etc. A Europa tem leis particularmente rigorosas sobre a coleta ou armazenamento desses dados (GDPR) e, independentemente de onde você mora, é provável que esteja entrando em um atoleiro ético. Por exemplo, em 2016, um grupo de pesquisadores raspou informações de perfil público (por exemplo, nomes de usuário, idade, gênero, localização, etc.) de cerca de 70.000 pessoas no site de namoro OkCupid e eles divulgaram publicamente esses dados sem qualquer tentativa de anonimização. Embora os pesquisadores acreditassem que não havia nada de errado nisso, já que os dados já eram públicos, esse trabalho foi amplamente condenado devido a preocupações éticas sobre a identificabilidade dos usuários cujas informações foram divulgadas no conjunto de dados. Se o seu trabalho envolve raspar informações pessoalmente identificáveis, recomendamos fortemente a leitura sobre o estudo do OkCupid, bem como estudos semelhantes com ética de pesquisa questionável envolvendo a aquisição e divulgação de informações pessoalmente identificáveis.
"

#----24.2.3 Direitos Autorais----
#--------------------------------
"
Finalmente, você também precisa se preocupar com a lei de direitos autorais. A lei de direitos autorais é complicada, mas vale a pena dar uma olhada na lei dos EUA, que descreve exatamente o que está protegido: '[...] obras originais de autoria fixadas em qualquer meio tangível de expressão, [...]'. Em seguida, descreve categorias específicas às quais se aplica, como obras literárias, obras musicais, filmes e mais. Notavelmente ausentes da proteção de direitos autorais estão os dados. Isso significa que, desde que você limite sua raspagem a fatos, a proteção de direitos autorais não se aplica. (Mas observe que a Europa tem um direito 'sui generis' separado que protege bancos de dados.)

Como um breve exemplo, nos EUA, listas de ingredientes e instruções não são protegidas por direitos autorais, então direitos autorais não podem ser usados para proteger uma receita. Mas se essa lista de receitas for acompanhada por um conteúdo literário substancial e original, isso é protegido por direitos autorais. É por isso que, quando você está procurando uma receita na internet, sempre há tanto conteúdo antes.

Se você precisar raspar conteúdo original (como texto ou imagens), ainda pode estar protegido pela doutrina do uso justo. O uso justo não é uma regra rígida e rápida, mas considera uma série de fatores. É mais provável que se aplique se você estiver coletando os dados para fins de pesquisa ou não comerciais e se limitar o que você raspa apenas ao que precisa.
"

#----24.3 Noções Básicas de HTML----
#-----------------------------------
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
#------------------------
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
#------------------------
"
As tags podem ter atributos nomeados que se parecem com name1='value1' name2='value2'. Dois dos atributos mais importantes são id e class, que são usados em conjunto com CSS (Cascading Style Sheets) para controlar a aparência visual da página. Eles são frequentemente úteis ao raspar dados de uma página. Os atributos também são usados para registrar o destino de links (o atributo href de elementos <a>) e a fonte de imagens (o atributo src do elemento <img>).
"

#----24.4 Extração de Dados----
#------------------------------
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
#----------------------------------
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
#---------------------------------
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
#--------------------------------
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
#----------------------
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
#--------------------------------------------
"
Descobrir o seletor de que você precisa para seus dados é normalmente a parte mais difícil do problema. Você geralmente precisará fazer alguns experimentos para encontrar um seletor que seja específico (ou seja, que não selecione coisas que você não se importa) e sensível (ou seja, que selecione tudo que você se importa). Muitas tentativas e erros são uma parte normal do processo! Há duas ferramentas principais disponíveis para ajudá-lo neste processo: o SelectorGadget e as ferramentas de desenvolvedor do seu navegador.

O SelectorGadget é um bookmarklet em javascript que gera automaticamente seletores CSS com base em exemplos positivos e negativos que você fornece. Ele não sempre funciona, mas quando funciona, é mágico! Você pode aprender a instalar e usar o SelectorGadget lendo 
https://rvest.tidyverse.org/articles/selectorgadget.html ou assistindo ao vídeo de Mine em https://www.youtube.com/watch?v=PetWV5g1Xsc.

Todo navegador moderno vem com algum kit de ferramentas para desenvolvedores, mas recomendamos o Chrome, mesmo que não seja seu navegador regular: suas ferramentas de desenvolvedor web são algumas das melhores e estão imediatamente disponíveis. Clique com o botão direito em um elemento na página e clique em Inspecionar. Isso abrirá uma visualização expansível da página HTML completa, centrada no elemento que você acabou de clicar. Você pode usar isso para explorar a página e ter uma ideia do que os seletores podem funcionar. Preste atenção especial aos atributos de classe e id, pois eles são frequentemente usados para formar a estrutura visual da página e, portanto, são boas ferramentas para extrair os dados que você está procurando.

Dentro da visualização de Elementos, você também pode clicar com o botão direito em um elemento e escolher Copiar como seletor para gerar um seletor que identificará exclusivamente o elemento de interesse.

Se o SelectorGadget ou as Ferramentas de Desenvolvedor do Chrome geraram um seletor CSS que você não entende, tente Selectors Explained, que traduz seletores CSS para inglês claro. Se você se encontrar fazendo isso com frequência, pode querer aprender mais sobre seletores CSS em geral. Recomendamos começar com o divertido tutorial CSS dinner e, em seguida, consultar os documentos da web MDN.
"

#----24.6 Colocando Tudo Junto----
#---------------------------------
"
Vamos juntar tudo isso para raspar alguns sites. Há um risco de que esses exemplos possam não funcionar mais quando você executá-los — esse é o desafio fundamental da raspagem de dados da web; se a estrutura do site mudar, você terá que alterar seu código de raspagem.
"

#----24.6.1 StarWars----
#-----------------------
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
#------------------------------------------
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
#----------------------------
"
Até agora, nos concentramos em sites onde `html_elements()` retorna o que você vê no navegador e discutimos como analisar o que ele retorna e como organizar essas informações em data frames organizados. De vez em quando, no entanto, você encontrará um site onde `html_elements()` e amigos não retornam nada parecido com o que você vê no navegador. Em muitos casos, isso ocorre porque você está tentando raspar um site que gera dinamicamente o conteúdo da página com javascript. Isso atualmente não funciona com o rvest, porque o rvest baixa o HTML bruto e não executa nenhum javascript.

Ainda é possível raspar esses tipos de sites, mas o rvest precisa usar um processo mais caro: simular completamente o navegador da web, incluindo a execução de todo o javascript. Essa funcionalidade não está disponível no momento da escrita, mas é algo em que estamos trabalhando ativamente e pode estar disponível quando você ler isso. Ele usa o pacote chromote, que realmente executa o navegador Chrome em segundo plano e oferece ferramentas adicionais para interagir com o site, como um humano digitando texto e clicando em botões. Confira o site do rvest para mais detalhes.
"