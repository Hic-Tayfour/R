#Capítulo 6 : Fluxo de trabalho: scripts e projetos
#==================================================

#----6.1 Scripts----
#-------------------
"
Até agora, você usou o console para executar código. Esse é um ótimo lugar para começar, mas você vai perceber que fica apertado rapidamente à medida que cria gráficos mais complexos com ggplot2 e pipelines mais longos com dplyr. Para dar a si mesmo mais espaço para trabalhar, use o editor de script. Abra-o clicando no menu Arquivo, selecionando Novo Arquivo e, em seguida, R script, ou usando o atalho de teclado Cmd/Ctrl+Shift+N.
O editor de script é um ótimo lugar para experimentar com seu código. Quando você quiser alterar algo, não precisa digitar tudo novamente; você pode apenas editar o script e executá-lo novamente. E uma vez que você tenha escrito um código que funciona e faz o que você quer, pode salvar como um arquivo de script para facilmente retornar a ele mais tarde.
"
#----6.1.1Executando código----
#------------------------------
"
O editor de script é um excelente lugar para construir gráficos complexos com ggplot2 ou longas sequências de manipulações com dplyr. A chave para usar efetivamente o editor de script é memorizar um dos atalhos de teclado mais importantes: Cmd/Ctrl+Enter. Isso executa a expressão R atual no console. Por exemplo, pegue o seguinte código:
"
library(dplyr)
library(nycflights13)

not_cancelled <- flights |> 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled |> 
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))

"
Se o seu cursor estiver em █, pressionando Cmd/Ctrl+Enter executará o comando completo que gera not_cancelled. Ele também moverá o cursor para a seguinte instrução (começando com not_cancelled |>). Isso facilita o passo a passo pelo seu script completo, pressionando repetidamente Cmd/Ctrl+Enter. 
Em vez de executar seu código expressão por expressão, você pode executar o script completo de uma vez com Cmd/Ctrl+Shift+S. Fazer isso regularmente é uma ótima maneira de garantir que você capturou todas as partes importantes do seu código no script. 
Recomendamos sempre iniciar seu script com os pacotes de que precisa. Dessa forma, se você compartilhar seu código com outros, eles podem facilmente ver quais pacotes precisam instalar. Note, no entanto, que você nunca deve incluir install.packages() em um script que compartilha. É indelicado entregar um script que instalará algo no computador deles se não estiverem atentos!
Ao trabalhar em capítulos futuros, recomendamos fortemente começar no editor de script e praticar seus atalhos de teclado. Com o tempo, enviar código para o console desta maneira se tornará tão natural que você nem pensará nisso.
"

#----6.1.2Diagnósticos do RStudio----
#------------------------------------
"
No editor de script, o RStudio destacará erros de sintaxe com uma linha ondulada vermelha e um x na barra lateral:
"
#x y <- 10 "Tire esse script do comentário e apague esse texto para ver como fica"

"
Passe o mouse sobre o x para ver qual é o problema.
O RStudio também o informará sobre problemas potenciais.
"

#----6.1.3Salvando e nomeando----
#--------------------------------
"
O RStudio salva automaticamente o conteúdo do editor de script quando você sai e o recarrega automaticamente quando você reabre. No entanto, é uma boa ideia evitar Untitled1, Untitled2, Untitled3 e assim por diante, e em vez disso, salvar seus scripts com nomes informativos.
Pode ser tentador nomear seus arquivos como code.R ou myscript.R, mas você deve pensar um pouco mais antes de escolher um nome para o seu arquivo. Três princípios importantes para a nomeação de arquivos são os seguintes:
"
  #1º Os nomes dos arquivos devem ser legíveis por máquinas: evite espaços, símbolos e caracteres especiais. Não confie na sensibilidade a maiúsculas e minúsculas para distinguir arquivos.
  #2º Os nomes dos arquivos devem ser legíveis por humanos: use nomes de arquivos para descrever o que está no arquivo.
  #3º Os nomes dos arquivos devem se dar bem com a ordenação padrão: comece os nomes dos arquivos com números para que a ordenação alfabética os coloque na ordem em que são usados.

"
Numerar os scripts-chave torna óbvio em que ordem executá-los, e um esquema de nomeação consistente facilita ver o que varia. Além disso, as figuras são rotuladas de maneira semelhante, os relatórios são distinguidos por datas incluídas nos nomes dos arquivos e temp é renomeado para report-draft-notes para descrever melhor seu conteúdo. Se você tem muitos arquivos em um diretório, organizar ainda mais e colocar diferentes tipos de arquivos (scripts, figuras, etc.) em diretórios diferentes é recomendado.
"


#----6.2Projetos----
#-------------------
"
Um dia, você precisará sair do R, fazer outra coisa e voltar à sua análise mais tarde. Um dia, você estará trabalhando em várias análises simultaneamente e quererá mantê-las separadas. Um dia, você precisará trazer dados do mundo exterior para o R e enviar resultados numéricos e figuras do R de volta para o mundo.
Para lidar com essas situações da vida real, você precisa tomar duas decisões:
    • Qual é a fonte da verdade? O que você salvará como seu registro duradouro do que aconteceu?
    • Onde sua análise vive?
"
#----6.2.1Qual é a fonte da verdade?----
#---------------------------------------
"
Como iniciante, está tudo bem confiar no seu ambiente atual para conter todos os objetos que você criou ao longo de sua análise. No entanto, para facilitar o trabalho em projetos maiores ou colaborar com outros, sua fonte da verdade deve ser os scripts R. Com seus scripts R (e seus arquivos de dados), você pode recriar o ambiente. Com apenas o seu ambiente, é muito mais difícil recriar seus scripts R: ou você terá que digitar muito código de memória (inevitavelmente cometendo erros ao longo do caminho) ou terá que minerar cuidadosamente seu histórico R.

Para ajudar a manter seus scripts R como a fonte da verdade para sua análise, recomendamos veementemente que você instrua o RStudio a não preservar seu espaço de trabalho entre sessões. Você pode fazer isso executando usethis::use_blank_slate() .Isso causará algumas dores de curto prazo, porque agora, quando você reiniciar o RStudio, ele não se lembrará mais do código que você executou da última vez, nem os objetos que você criou ou os conjuntos de dados que você leu estarão disponíveis para usar. Mas essa dor de curto prazo economiza agonia de longo prazo porque força você a capturar todos os procedimentos importantes no seu código. Não há nada pior do que descobrir três meses depois que você armazenou apenas os resultados de um cálculo importante no seu ambiente, não o cálculo em si no seu código.

Existe um ótimo par de atalhos de teclado que funcionarão juntos para garantir que você capturou as partes importantes do seu código no editor:

  - Pressione Cmd/Ctrl + Shift + 0/F10 para reiniciar o R.
  - Pressione Cmd/Ctrl + Shift + S para executar novamente o script atual.

Nós usamos esse padrão coletivamente centenas de vezes por semana.
Alternativamente, se você não usa atalhos de teclado, pode ir a Sessão > Reiniciar R e, em seguida, destacar e executar novamente o script atual.
"
#----6.2.2Onde vive sua análise?----
#-----------------------------------
"
O R tem uma poderosa noção de diretório de trabalho. Este é o lugar onde o R procura por arquivos que você pede para carregar e onde ele colocará quaisquer arquivos que você pedir para salvar. O RStudio mostra seu diretório de trabalho atual no topo do console:
Você pode imprimir isso no código R executando getwd():
"
getwd()

"

Scripts
Até agora, você usou o console para executar código. Esse é um ótimo lugar para começar, mas você vai perceber que fica apertado rapidamente à medida que cria gráficos mais complexos com ggplot2 e pipelines mais longos com dplyr. Para dar a si mesmo mais espaço para trabalhar, use o editor de script. Abra-o clicando no menu Arquivo, selecionando Novo Arquivo e, em seguida, R script, ou usando o atalho de teclado Cmd/Ctrl+Shift+N. Agora você verá quatro painéis, como na Figura 6-1. O editor de script é um ótimo lugar para experimentar com seu código. Quando você quiser alterar algo, não precisa digitar tudo novamente; você pode apenas editar o script e executá-lo novamente. E uma vez que você tenha escrito um código que funciona e faz o que você quer, pode salvar como um arquivo de script para facilmente retornar a ele mais tarde.

Executando Código
O editor de script é um excelente lugar para construir gráficos complexos com ggplot2 ou longas sequências de manipulações com dplyr. A chave para usar efetivamente o editor de script é memorizar um dos atalhos de teclado mais importantes: Cmd/Ctrl+Enter. Isso executa a expressão R atual no console. Por exemplo, pegue o seguinte código:

Se o seu cursor estiver em █, pressionando Cmd/Ctrl+Enter executará o comando completo que gera not_cancelled. Ele também moverá o cursor para a seguinte instrução (começando com not_cancelled |>). Isso facilita o passo a passo pelo seu script completo, pressionando repetidamente Cmd/Ctrl+Enter. Em vez de executar seu código expressão por expressão, você pode executar o script completo de uma vez com Cmd/Ctrl+Shift+S. Fazer isso regularmente é uma ótima maneira de garantir que você capturou todas as partes importantes do seu código no script. Recomendamos sempre iniciar seu script com os pacotes de que precisa. Dessa forma, se você compartilhar seu código com outros, eles podem facilmente ver quais pacotes precisam instalar. Note, no entanto, que você nunca deve incluir install.packages() em um script que compartilha. É indelicado entregar um script que instalará algo no computador deles se não estiverem atentos!

Ao trabalhar em capítulos futuros, recomendamos fortemente começar no editor de script e praticar seus atalhos de teclado. Com o tempo, enviar código para o console desta maneira se tornará tão natural que você nem pensará nisso.

Diagnósticos do RStudio
No editor de script, o RStudio destacará erros de sintaxe com uma linha ondulada vermelha e um x na barra lateral:
Passe o mouse sobre o x para ver qual é o problema:
O RStudio também o informará sobre problemas potenciais:

Salvando e Nomeando
O RStudio salva automaticamente o conteúdo do editor de script quando você sai e o recarrega automaticamente quando você reabre. No entanto, é uma boa ideia evitar Untitled1, Untitled2, Untitled3 e assim por diante, e em vez disso, salvar seus scripts com nomes informativos.
Pode ser tentador nomear seus arquivos como code.R ou myscript.R, mas você deve pensar um pouco mais antes de escolher um nome para o seu arquivo. Três princípios importantes para a nomeação de arquivos são os seguintes:

Os nomes dos arquivos devem ser legíveis por máquinas: evite espaços, símbolos e caracteres especiais. Não confie na sensibilidade a maiúsculas e minúsculas para distinguir arquivos.
Os nomes dos arquivos devem ser legíveis por humanos: use nomes de arquivos para descrever o que está no arquivo.
Os nomes dos arquivos devem se dar bem com a ordenação padrão: comece os nomes dos arquivos com números para que a ordenação alfabética os coloque na ordem em que são usados.
Por exemplo, suponha que você tenha os seguintes arquivos em uma pasta de projeto:
Existem vários problemas aqui: é difícil encontrar qual arquivo executar primeiro, os nomes dos arquivos contêm espaços, há dois arquivos com o mesmo nome, mas com capitalização diferente (finalreport versus FinalReport1), e alguns nomes não descrevem seus conteúdos (run-first e temp).
Aqui está uma maneira melhor de nomear e organizar o mesmo conjunto de arquivos:
Numerar os scripts-chave torna óbvio em que ordem executá-los, e um esquema de nomeação consistente facilita ver o que varia. Além disso, as figuras são rotuladas de maneira semelhante, os relatórios são distinguidos por datas incluídas nos nomes dos arquivos e temp é renomeado para report-draft-notes para descrever melhor seu conteúdo. Se você tem muitos arquivos em um diretório, organizar ainda mais e colocar diferentes tipos de arquivos (scripts, figuras, etc.) em diretórios diferentes é recomendado.
Projetos
Um dia, você precisará sair do R, fazer outra coisa e voltar à sua análise mais tarde. Um dia, você estará trabalhando em várias análises simultaneamente e quererá mantê-las separadas. Um dia, você precisará trazer dados do mundo exterior para o R e enviar resultados numéricos e figuras do R de volta para o mundo.
Para lidar com essas situações da vida real, você precisa tomar duas decisões:
• Qual é a fonte da verdade? O que você salvará como seu registro duradouro do que aconteceu?
• Onde sua análise vive?

Qual É a Fonte da Verdade?
Como iniciante, está tudo bem confiar no seu ambiente atual para conter todos os objetos que você criou ao longo de sua análise. No entanto, para facilitar o trabalho em projetos maiores ou colaborar com outros, sua fonte da verdade deve ser os scripts R. Com seus scripts R (e seus arquivos de dados), você pode recriar o ambiente. Com apenas o seu ambiente, é muito mais difícil recriar seus scripts R: ou você terá que digitar muito código de memória (inevitavelmente cometendo erros ao longo do caminho) ou terá que minerar cuidadosamente seu histórico R.
Para ajudar a manter seus scripts R como a fonte da verdade para sua análise, recomendamos veementemente que você instrua o RStudio a não preservar seu espaço de trabalho entre sessões. Você pode fazer isso executando usethis::use_blank_slate() ou imitando as opções mostradas na Figura 6-2. Isso causará algumas dores de curto prazo, porque agora, quando você reiniciar o RStudio, ele não se lembrará mais do código que você executou da última vez, nem os objetos que você criou ou os conjuntos de dados que você leu estarão disponíveis para usar. Mas essa dor de curto prazo economiza agonia de longo prazo porque força você a capturar todos os procedimentos importantes no seu código. Não há nada pior do que descobrir três meses depois que você armazenou apenas os resultados de um cálculo importante no seu ambiente, não o cálculo em si no seu código.

Onde Sua Análise Vive?
O R tem uma poderosa noção de diretório de trabalho. Este é o lugar onde o R procura por arquivos que você pede para carregar e onde ele colocará quaisquer arquivos que você pedir para salvar. O RStudio mostra seu diretório de trabalho atual no topo do console:
Você pode imprimir isso no código R executando getwd():
Nesta sessão R, o diretório de trabalho atual (pense nisso como 'casa') está na pasta Documentos de Hadley, em uma subpasta chamada r4ds. Este código retornará um resultado diferente quando você o executar, porque o seu computador tem uma estrutura de diretório diferente de Hadley!
Como usuário iniciante do R, está tudo bem deixar seu diretório de trabalho ser seu diretório inicial, diretório de documentos ou qualquer outro diretório estranho no seu computador. Mas você já está no sétimo capítulo deste livro e não é mais um iniciante. Em breve, você deverá evoluir para organizar seus projetos em diretórios e, ao trabalhar em um projeto, definir o diretório de trabalho do R para o diretório associado.
Você pode definir o diretório de trabalho de dentro do R, mas não recomendamos isso:
"
#setwd("/path/to/my/CoolProject")
"
Há uma maneira melhor - uma maneira que também o coloca no caminho para gerenciar seu trabalho R como um especialista. Essa maneira é o projeto RStudio.
"
#----6.2.3Projetos do RStudio----
#--------------------------------
"
Manter todos os arquivos associados a um determinado projeto (dados de entrada, scripts R, resultados analíticos e figuras) em um diretório é uma prática tão sábia e comum que o RStudio tem suporte embutido para isso por meio de projetos. Vamos criar um projeto para você usar enquanto trabalha no resto deste livro. Selecione Arquivo > Novo Projeto.
Chame seu projeto de r4ds e pense cuidadosamente em qual subdiretório você colocará o projeto. Se você não armazená-lo em algum lugar sensato, será difícil encontrá-lo no futuro!
Uma vez que este processo esteja completo, você terá um novo projeto RStudio apenas para este livro. Verifique se o 'lar' do seu projeto é o diretório de trabalho atual:
"
getwd()
"
Agora digite os seguintes comandos no editor de script e salve o arquivo, chamando-o de diamonds.R. Você pode fazer isso clicando no botão Nova Pasta no painel Arquivos no RStudio. Finalmente, execute o script completo, que salvará um arquivo PNG e CSV em seu diretório de projeto. 
"
library(tidyverse)

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_hex()
ggsave("diamonds.png")

write_csv(diamonds, "diamonds.csv")

"
Saia do RStudio. Inspecione a pasta associada ao seu projeto - observe o arquivo .Rproj. Clique duas vezes nesse arquivo para reabrir o projeto. Observe que você volta aonde parou: é o mesmo diretório de trabalho e histórico de comandos, e todos os arquivos em que você estava trabalhando ainda estão abertos. Porque você seguiu nossas instruções, você terá, no entanto, um ambiente completamente novo, garantindo que você esteja começando com uma tela limpa.
Da maneira específica do seu sistema operacional favorito, pesquise no seu computador por diamonds.png e você encontrará o PNG (sem surpresas) mas também o script que o criou (diamonds.R). Isso é uma grande vitória! Um dia, você vai querer refazer uma figura ou apenas entender de onde ela veio. Se você salvar rigorosamente as figuras em arquivos com código R e nunca com o mouse ou a área de transferência, você poderá reproduzir trabalhos antigos com facilidade!
"
#----6.2.4Caminhos relativos e absolutos----
#-------------------------------------------
"
Uma vez que você está dentro de um projeto, você deve usar apenas caminhos relativos, não caminhos absolutos. Qual é a diferença? Um caminho relativo é relativo ao diretório de trabalho, ou seja, a casa do projeto. Quando Hadley escreveu data/diamonds.csv anteriormente, foi um atalho para /Users/hadley/Documents/r4ds/data/diamonds.csv. Mas, importante, se Mine executasse esse código no computador dela, apontaria para /Users/Mine/Documents/r4ds/data/diamonds.csv. É por isso que os caminhos relativos são importantes: eles funcionarão independentemente de onde a pasta do projeto R acabar.
Caminhos absolutos apontam para o mesmo lugar, independentemente do seu diretório de trabalho. Eles parecem um pouco diferentes dependendo do seu sistema operacional. No Windows, eles começam com uma letra de unidade (por exemplo, C:) ou dois backslashes (por exemplo, \servername) e no Mac/Linux eles começam com uma barra, / (por exemplo, /users/hadley). Você nunca deve usar caminhos absolutos em seus scripts, porque eles impedem o compartilhamento: ninguém mais terá exatamente a mesma configuração de diretório que você.
Há outra diferença importante entre os sistemas operacionais: como você separa os componentes do caminho. Mac e Linux usam barras (por exemplo, data/diamonds.csv) e Windows usa backslashes (por exemplo, data\diamonds.csv). R pode trabalhar com qualquer tipo (não importa em qual plataforma você está atualmente), mas infelizmente, backslashes significam algo especial para R, e para obter uma única barra invertida no caminho, você precisa digitar duas barras invertidas! Isso torna a vida frustrante, então recomendamos sempre usar o estilo Linux/Mac com barras para frente.
"
