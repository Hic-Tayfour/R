# Capítulo 2: Fluxo de Trabalho ;Básico
# =================================
"
Você agora tem algumo experiência em executar código em R. Não lhe demos muitos detalhes, mas você obviamente decobriu o básico, ou teria se frustrado e jogado este livro fora. Frustração é natural quando você começa a programar em R porque é muito rigoroso com a pontuação, e mesmo um caractere fora do lugar pode fazer com que ele reclame. Mas, embora você deva esperar um pouco de frustração, tenha em mente que essa experiência é normal e temporária: acontece com todo mundo, e a única maneira de superá-la é continuar tentando.

Antes de irmos mais longe, vamos garantir que você tenha base sólida na execução de cógido em R e que conheça alguns dos recursos maus úteis do RStusio.
"
#----2.1 Princípios básicos da programação ----
#----------------------------------------------
"
Vamos revisar alguns conceitos básicos que omitimos até agora, no interesse de fazer você plotar gráfios o mais rápido possível. Você pode usar o R para fazer cálculos matemáticos básicos:
"
1/200*30
(59+73+2)/3
sin(pi/2)

"
Você pode criar novos objetos com o operador de atribuição <- :
"
x <- 3*4
"
Note que o valor de x não é impresso, ele é apenas armazenado. Se você quiser ver o valor , digite x no console"

x
"
Você pode combinar vários elementos em um vetor com c()"

primos <- c(2,3,5,7,11,13)

"
É uma aritimética básica em vetores é aplicada a cada elemneto do vetor:"

primos*2
primos-1

"
Todos os comandos em R onde que você cria objetos, comando de atribuição, têm a mesma forma:"
#nome_objeto <- valor

"
Quando ler esse código, diga 'nome do objeto recebe valor' na sua cabeça.
Você fará muitas atribuições, e <-  não é simples de digitar. Você pode usar um atalho 'alt'+'-'.Observe que o RStudio automaticamente coloca espaços em torno de <-, o que é uma boa prática de formatação de código. Ler código pode ser desafiador até mesmo nos melhores dias, então dê descanso para seus olhos e utilize espaço.
"

#----2.2 Comentários----
#-----------------------
"
O R ignora qualquer texto após # em uma linha. Isso permite que você escreva comentários, que são textos que são ignorados pelo R, mas podem ser lidos por outros humanos. Às vezes, incluiremos comentários nos exemplos explicando o que está acontecendo com o código.
Comentários podem ser úteis para descrever brevemente o que o código a seguir faz
"
# Cria um vetor de números primos 
primos <- c(2, 3, 5, 7, 11, 13)

#Multiplica primos por 2
primos * 2

"
Em pequenos trechos de código como este, deixar um comentário para cada linha de código pode não ser necessário. Mas, à medida que o código que você está escrevendo fica mais complexo, os comentários podem economizar muito tempo seu (e das pessoas que colaboram com você) para descobrir o que foi feito no código.

Use comentários para explicar o porquê do seu código, não o como ou o o quê. O o quê e o como do seu código são sempre possíveis de descobrir lendo-os cuidadosamente, mesmo que isso possa ser chato. Se você descrever cada etapa nos comentários e, em seguida alterar o código, terá que se lembrar de atualizar os comentários também, caso contrário, será confuso quando você retornar ao seu código no futuro.

Descobrir por que algo foi feito é muito mais difícil, senão impossível. Por exemplo, geom_smooth() tem um argumento chamado span, que controla a suavidade da curva (smoothness), com valores maiores produzindo uma curva mais suave. Suponha que você decida alterar o valor de span de seu padrão de 0.75 para 0.9: é fácil para alguém que está lendo no futuro entender o que está acontecendo, mas a menos que você anote seu pensamento em um comentário, ninguém entenderá o por que de você ter alterado o padrão.

Para código de análise de dados, use comentários para explicar sua abordagem estratégica e registrar informações importantes à medida que as encontrar. Não há como recuperar esse conhecimento do próprio código sem comentários.
"

#----2.3 A Importância dos Nomes----
#-----------------------------------
"
Nomes de objetos devem começar com uma letra e só podem conter letras, números, _ e . > Você quer que os nomes dos seus objetos sejam descritivos, então você precisará adotar uma convenção para várias palavras. Recomendamos o snake_case, onde você separas minúsculas com _ .
"
# eu_uso_snake_case
# outrasPessoasUsamCamelCase
# algumas.pessoas.usam.pontos
# E_aLgumas.Pessoas_nAoUsamConvecao

"
Você pode ver o conteúdo de um objeto (chamamos isso de insppecionar) digitando o seu nome:
"
x

"
Fazendo outra atribuição :
"
esse_e_um_nome_bem_longo <- 2.5

"Para inspecionar esse objeto, experimente o recurso de autocompleter (autocomplete) do RStudio: digite: esse , precione TAB, adicione carteres até ter um prefixo único e precione enter

Vamos supor que você cometeu um erro e que o valor de esse_e_um_nome_bem_longo deveria ser 3.5, não 2.5. Você pode usar outro atalho de teclado para te ajudar a corrigi-lo. Por exemplo, você pode pressionar ↑ para recuperar o último comando que você digitou e editá-lo. Ou, digite “esse” e pressione Cmd/Ctrl + ↑ para listar todos os comandos que você digitou que começam com essas letras. Use as setas para navegar e, em seguida, pressione enter para digitar novamente o comando. Altere 2.5 para 3.5 e execute novamente.

Fazendo mais uma atribuição:
"
r_rocks <- 2^3

"Vamos tentar inspecioná-lo:"

r_rock
#> Error: object 'r_rock' not found
R_rocks
#> Error: object 'R_rocks' not found

"
Isso ilustra o contrato implícito entre você e o R: o R fará os cálculos chatos para você, mas em troca, você deve ser escrever suas instruções de forma precisa. Se não, você provavelmente receberá um erro que diz que o objeto que você está procurando não foi encontrado. Erros de digitação importam; o R não pode ler sua mente e dizer: “ah, você provavelmente quis dizer r_rocks quando digitou r_rock”. A caixa alta (letras maiúsculas) importa; da mesma forma, o R não pode ler sua mente e dizer: “ah, você provavelmente quis dizer r_rocks quando digitou R_rocks”.
"

#----2.4 Chamando Funções----
#---------------------------
"
O R tem um agrande coleção de funções embutidas que são chamadas assim:
"
nome_da_função(argumento1 = valor1, argumneto2 = valor2, argumentoN = ValorN)

"
Vamos tentar usar seq(), que faz sequências regulares de números, e enquanto fazemos nisso, vamos aprender mais sobre os recursos do RStudio. Digite se e pressione TAB. Uma janela pop-up mostra as possíveis formas de completar o código. Especifique seq() digitando mais (um q) para especificar ou usando as setas ↑/↓ para selecionar. Observe a janelinha que aparece, mostrando os argumentos e o objetivo da função. Se você quiser mais ajuda, pressione F1 para obter todos os detalhes no painel ajuda (Help) na parte inferior direita.

Quando você selecionar a função que deseja, pressione TAB novamente. O RStudio adicionará os parênteses de abertura (() e fechamento ()) correspondentes para você automaticamente. Digite o nome do primeiro argumento, from, e defina-o como 1. Em seguida, digite o nome do segundo argumento, to, e defina-o como 10. Por último, pressione enter.
"

seq(from = 1, to = 10)

"
Normalmente omitimos os nomes dos primeiros argumentos em chamadas de função, assim podemos reescrever isso da seguinte forma:
"

seq(1, 10)

"
Digite o código a seguir e veja que o RStudio fornece assistência semelhante com as aspas em pares:
" 
x <- "olá mundo"

"
As aspas e parênteses devem sempre vir em pares. O RStudio faz o melhor para te ajudar, mas ainda é possível cometer um erro e acabar com aspas não fechadas. Se isso acontecer, o console do R mostrará o caractere de continuação “+”:
"  
#> x <- "olá"
#+
"
O + indica que o R está esperando mais alguma entrada (input); ele acha que você ainda não terminou de digitar. Normalmente, isso significa que você esqueceu de adicionar um  ou um ). Adicione o par que está faltando ou pressione ESCAPE (ou ESC) para cancelar a expressão e tentar novamente.

Observe que o painel ambiente (Environment) no painel superior direito exibe todos os objetos que você criou
"
