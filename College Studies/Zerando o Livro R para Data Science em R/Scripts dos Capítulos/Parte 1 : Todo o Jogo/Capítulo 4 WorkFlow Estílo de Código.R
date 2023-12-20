#Capítulo 4 : WorkFlow Estílo de Código
# =====================================
"
Um bom estilo de codificação é como a pontuação correta: você pode se virar sem ela, mas ela certamente torna as coisas mais fáceis de ler. Mesmo sendo um programador muito iniciante, é uma boa ideia trabalhar no seu estilo de código. Usar um estilo consistente facilita para outros (incluindo você no futuro!) lerem seu trabalho e é particularmente importante se você precisar de ajuda de outra pessoa. Este capítulo irá introduzir os pontos mais importantes do guia de estilo tidyverse, que é usado ao longo deste livro.

Estilizar seu código pode parecer um pouco tedioso no início, mas se você praticar, logo se tornará algo natural. Além disso, existem ótimas ferramentas para rapidamente reestilizar código existente, como o pacote styler de Lorenz Walthert. Depois de instalá-lo com install.packages('styler'), uma maneira fácil de usá-lo é através da paleta de comandos do RStudio. A paleta de comandos permite que você use qualquer comando embutido do RStudio e muitos complementos fornecidos por pacotes. Abra a paleta pressionando Cmd/Ctrl + Shift + P, e depois digite 'styler' para ver todos os atalhos oferecidos pelo styler.

Nós usaremos os pacotes tidyverse e nycflights13 para construir os exemplos nesse capítulo
"
library(tidyverse)
library(nycflights13)

#----4,1Nomes----
#----------------
"
Falamos brevemente sobre nomes anetriormente. Lembre-se de que nomes de variáveis (aqueles criados por <- e aqueles criados por mutate()) devem usar apenas letras minúsculas, números e _. Use _ para separar palavras dentro de um nome.
"
#Procure:
short_flights <- flights |> 
                    filter(air_time < 60)

#Evite :
SHORTFLIGHTS <- flights |> 
                    filter(air_time < 60)

"
Como regra geral, é melhor preferir nomes longos e descritivos que sejam fáceis de entender do que nomes concisos que são rápidos de digitar. Nomes curtos economizam relativamente pouco tempo ao escrever código (especialmente porque o recurso de preenchimento automático ajuda a terminar de digitá-los), mas pode ser demorado quando você retorna a um código antigo e é forçado a desvendar uma abreviação críptica.

Se você tiver um conjunto de nomes para coisas relacionadas, faça o seu melhor para ser consistente. É fácil para inconsistências surgirem quando você esquece uma convenção anterior, então não se sinta mal se precisar voltar e renomear coisas. Em geral, se você tem um conjunto de variáveis que são uma variação de um tema, você está melhor dando a elas um prefixo comum em vez de um sufixo comum, porque o preenchimento automático funciona melhor no início de uma variável.
"
#----4.2ESpaços----
#------------------
"
Coloque espaços em ambos os lados dos operadores matemáticos, exceto ^ (ou seja, +, -, ==, <, …), e ao redor do operador de atribuição (<-).
"

#Procure:
"z <- (a + b)^2 /d"

#Evite:
"z<-( a + b )^ 2/d"

"
Não coloque espaços dentro ou fora dos parênteses em chamadas de função regulares. Sempre coloque um espaço após uma vírgula, assim como no inglês padrão.
"
#Procure:
"mean(x, na.rm = TRUE)"

#Evite:
"mean (x ,na.rm=TRUE)"

"
É aceitável adicionar espaços extras se isso melhorar o alinhamento. Por exemplo, se você estiver criando várias variáveis em mutate(), você pode querer adicionar espaços para que todos os = fiquem alinhados.1 Isso torna mais fácil percorrer o código rapidamente.
"
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )

#----4.3Pipes----
#----------------
"
O operador |> deve sempre ter um espaço antes dele e, normalmente, ser o último elemento em uma linha. Isso facilita a adição de novas etapas, reorganização das etapas existentes, modificação dos elementos dentro de uma etapa e permite uma visão geral rápida ao examinar os verbos no lado esquerdo.
"
#Procure
flights |> 
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)

#Evite
flights|>filter(!is.na(arr_delay), !is.na(tailnum))|>count(dest)

"
Se a função para a qual você está direcionando os dados tem argumentos nomeados (como mutate() ou summarize()), coloque cada argumento em uma nova linha. Se a função não tem argumentos nomeados (como select() ou filter()), mantenha tudo em uma linha, a menos que não caiba, caso em que você deve colocar cada argumento em sua própria linha.
"
#Procure:
flights |>  
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

#Evite:
flights |>
  group_by(
    tailnum
  ) |> 
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())

"
Após o primeiro passo do pipeline, indente cada linha com dois espaços. O RStudio colocará automaticamente os espaços para você após uma quebra de linha seguindo um |> . Se você estiver colocando cada argumento em sua própria linha, indente com mais dois espaços adicionais. Certifique-se de que ) esteja em sua própria linha e sem indentação para corresponder à posição horizontal do nome da função.
"

#Proure: 
flights |>  
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

#Evite:
flights|>
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )

#Evite
flights|>
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )

"
É aceitável ignorar algumas dessas regras se seu pipeline couber facilmente em uma linha. Mas, na nossa experiência coletiva, é comum que trechos curtos acabem se tornando mais longos, então você geralmente economiza tempo a longo prazo começando com todo o espaço vertical necessário.
"
#Isto cabe compactamente em uma linha
"df |> mutate(y = x + 1)"

#Enquanto isto ocupa 4 vezes mais linhas, é facilmente extensível para mais variáveis e mais etapas no futuro
"
df |>
  mutate(
    y = x + 1
  )
"

"
Por fim, tenha cuidado ao escrever pipelines muito longos, digamos, com mais de 10-15 linhas. Tente dividi-los em sub-tarefas menores, dando a cada tarefa um nome informativo. Os nomes ajudarão a orientar o leitor sobre o que está acontecendo e facilitam a verificação de que os resultados intermediários estão conforme o esperado. Sempre que puder dar um nome informativo a algo, você deve fazê-lo, por exemplo, quando mudar fundamentalmente a estrutura dos dados, como após pivoteamento ou resumo. Não espere acertar na primeira tentativa! Isso significa dividir pipelines longos se houver estados intermediários que possam receber bons nomes.
"
#----4.4GGplt2----
#-----------------
"
As mesmas regras básicas que se aplicam ao pipe também se aplicam ao ggplot2; apenas trate + da mesma maneira que |>.
"
flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()
"
Novamente, se você não conseguir colocar todos os argumentos de uma função em uma única linha, coloque cada argumento em sua própria linha:
"
flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE, 
    color = "white", 
    linewidth = 4
  ) +
  geom_point()

"
Fique atento à transição de |> para +. Gostaríamos que essa transição não fosse necessária, mas infelizmente, o ggplot2 foi escrito antes da descoberta do pipe.
"

#----4.5Seções Comentadas----
#----------------------------
"
À medida que seus scripts ficam mais longos, você pode usar comentários de seção para dividir seu arquivo em partes gerenciáveis:

#Carregar dados --------------------------------------
#Plotar dados --------------------------------------

Todo esse script, os anteriores e os futuros fazem isso disso 

O RStudio oferece um atalho de teclado para criar esses cabeçalhos (Cmd/Ctrl + Shift + R), e os exibirá no menu de navegação de código, localizado no canto inferior esquerdo do editor.
"