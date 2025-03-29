#Capítulo 8 : Fluxo de Trabalho: Obtendo Ajuda
#=============================================
"
Este livro não é uma ilha; não existe um único recurso que permita dominar o R. À medida que você começar a aplicar as técnicas descritas neste livro aos seus próprios dados, logo encontrará perguntas que não respondemos. Esta seção descreve algumas dicas sobre como obter ajuda e ajudá-lo a continuar aprendendo.
"

#----8.1O Google é seu Amigo----
#-------------------------------
"
Se você ficar preso, comece com o Google. Normalmente, adicionar 'R' a uma consulta é suficiente para restringi-la a resultados relevantes: se a pesquisa não for útil, muitas vezes significa que não há resultados específicos para R disponíveis. Além disso, adicionar nomes de pacotes como 'tidyverse' ou 'ggplot2' ajudará a restringir os resultados para códigos que também parecerão mais familiares para você, por exemplo, 'como fazer um boxplot em R' versus 'como fazer um boxplot em R com ggplot2'. O Google é particularmente útil para mensagens de erro. Se você receber uma mensagem de erro e não tiver ideia do que ela significa, tente pesquisar no Google! É provável que alguém já tenha se confundido com ela no passado, e haverá ajuda em algum lugar na web. (Se a mensagem de erro não estiver em inglês, execute Sys.setenv(LANGUAGE = 'en') e reexecute o código; é mais provável que você encontre ajuda para mensagens de erro em inglês.)

Se o Google não ajudar, tente o Stack Overflow. Comece gastando um pouco de tempo procurando uma resposta existente, incluindo [R], para restringir sua pesquisa a perguntas e respostas que usam R.
"

#----8.2Criando um reprex----
#----------------------------
"
Se a sua busca no Google não encontrar nada útil, é uma ótima ideia preparar um reprex, abreviação de exemplo reproduzível mínimo. Um bom reprex facilita para outras pessoas ajudarem você, e muitas vezes você descobrirá o problema por si mesmo no decorrer da sua criação. Há duas partes para criar um reprex
"

  #1º Primeiro, você precisa tornar seu código reproduzível. Isso significa que você precisa capturar tudo, ou seja, incluir quaisquer chamadas de library() e criar todos os objetos necessários. A maneira mais fácil de garantir que você fez isso é usando o pacote reprex.

  #2º Segundo, você precisa torná-lo minimalista. Elimine tudo que não está diretamente relacionado ao seu problema. Isso geralmente envolve criar um objeto R muito menor e mais simples do que aquele com o qual você está lidando na vida real ou até mesmo usar dados integrados.

"Isso parece muito trabalho! E pode ser, mas tem uma grande recompensa:"

  #1º 80% do tempo, criar um excelente reprex revela a fonte do seu problema. É incrível como muitas vezes o processo de escrever um exemplo autocontido e minimalista permite que você responda à sua própria pergunta.

  #2º Os outros 20% do tempo, você terá capturado a essência do seu problema de uma forma que é fácil para outros brincarem. Isso aumenta substancialmente suas chances de obter ajuda!

"
Ao criar um reprex manualmente, é fácil perder acidentalmente algo, o que significa que seu código não pode ser executado no computador de outra pessoa. Evite esse problema usando o pacote reprex, que é instalado como parte do tidyverse. Digamos que você copie este código para sua área de transferência (ou, no RStudio Server ou Cloud, selecione-o):
"
y <- 1:4
mean(y)

"
Em seguida, chame reprex(), onde a saída padrão é formatada para o GitHub:
"
reprex::reprex()

"
Uma prévia em HTML bem renderizada será exibida no Visualizador do RStudio (se você estiver no RStudio) ou em seu navegador padrão caso contrário. O reprex é automaticamente copiado para sua área de transferência (no RStudio Server ou Cloud, você precisará copiar isso manualmente):
"
#```
y <- 1:4
mean(y)
#```
"
Este texto é formatado de uma maneira especial, chamada Markdown, que pode ser colada em sites como StackOverflow ou Github, e eles o renderizarão automaticamente para parecer código. Aqui está como esse Markdown pareceria renderizado no GitHub:
"
y <- 1:4
mean(y)

"
Qualquer outra pessoa pode copiar, colar e executar isso imediatamente.

Existem três coisas que você precisa incluir para tornar seu exemplo reproduzível: pacotes necessários, dados e código.
"
  #1º Os pacotes devem ser carregados no topo do script para que seja fácil ver quais são necessários para o exemplo. Este é um bom momento para verificar se você está usando a versão mais recente de cada pacote; você pode ter descoberto um bug que foi corrigido desde que instalou ou atualizou o pacote pela última vez. Para pacotes do tidyverse, a maneira mais fácil de verificar é executar tidyverse_update().

  #2º A maneira mais fácil de incluir dados é usar dput() para gerar o código R necessário para recriá-los. Por exemplo, para recriar o conjunto de dados mtcars em R, siga estas etapas:
    #2.1 Execute dput(mtcars) em R.
    #2.2 Copie a saída.
    #2.3 No reprex, digite mtcars <- e, em seguida, cole.
  # Tente usar o menor subconjunto de seus dados que ainda revele o problema.
  
  #3º Gaste um pouco de tempo garantindo que seu código seja fácil de ler para outras pessoas:
    #3.1  Certifique-se de ter usado espaços e seus nomes de variáveis são concisos, mas informativos.
    #3.2  Use comentários para indicar onde está o seu problema.
    #3.3  Faça o seu melhor para remover tudo que não está relacionado ao problema.
  # Quanto mais curto for o seu código, mais fácil ele será de entender e corrigir.

"
Termine verificando se você realmente fez um exemplo reproduzível, iniciando uma nova sessão de R e copiando e colando seu script.

Criar reprexes não é trivial e levará algum tempo para aprender a criar bons reprexes verdadeiramente mínimos. No entanto, aprender a fazer perguntas que incluam o código e investir tempo para torná-lo reproduzível continuará valendo a pena à medida que você aprende e domina o R.
"
#----8.3Investindo em Si Mesmo----
#---------------------------------
"
Você também deve dedicar algum tempo para se preparar para resolver problemas antes que eles ocorram. Investir um pouco de tempo aprendendo R todos os dias trará grandes benefícios a longo prazo. Uma maneira é acompanhar o que a equipe do tidyverse está fazendo no blog do tidyverse. Para se manter atualizado com a comunidade R de forma mais ampla, recomendamos a leitura do R Weekly: é um esforço comunitário para agregar as notícias mais interessantes na comunidade R a cada semana.
"