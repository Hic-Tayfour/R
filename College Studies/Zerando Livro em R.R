"Arquivo desenvolvido por Hicham Tayfour, seguindo a apostila 'Tutorial para Análise Descritiva com uso do R' e o 'Livro Curso de R"
#1.Primeiro Contato com RStudio----

#1.1 minha primeira linha de código----
print("Hello World")
1+3
sum(1,2,3,4)
sqrt(9)
cos(3.1415)

#1.2 Criando objetos----
a=3
a <- 3 #essa seta é criada usando as teclas alt e hifén
soma <- sum(1,2,3,4)
raiz <- sqrt(soma)
2+raiz
raiz
print(raiz)

#1.3 Criando Vetores----
c(1,2,3) #criação de um vetor, c vem concatenar, combinar
1:3 # um vetor pode também ser escrito dessa forma
100:200 # ele cria uma sequência de vetores ordenados de um em um , onde o primeiro valoer é o começo e o último é onde o vetor deve terminar
numero <- c(1,2,3) # numero <- 1:3, numero=c(1,2,3), numero=1:3 , varias formas de representar a criação de um vetor e o sua atribuição a variavel numero
media <- mean(numero)
media
soma <- 1+2+3+4
media2 <- soma/5
media2
length(numero) #mensurar a quantidade de termos presentes em um vetor

#1.4 Criando matrizes----
vet <- c(1,3,4,7,10,14) #criando os dados de uma matriz, que deve estra necessariamnete em um formato vetorial
A <- matrix(vet,nrow=3,ncol = 2) #usamos a função matriz para criar a matriz e as as funções nrow para defenir a quantidade de linhas e ncow para definar a quantidade de colunas 
#se quisermos partes especificas de uma matriz vamos usar essa estrutura nome_da_matriz[numero_da_linha,numero_da_coluna]
A[3,2] #elemento da terceira linha e segunda coluna
A[2:3,1] #elementos da segunda até a terceira linha da primeira coluna 

#1.5 Mexendo com DataFrames----
#A função data nos permite carregar dados no formato de um dataframe, na estruta data(nome_dataframe)
data(mtcars) #cria o dataframe
View(mtcars) #cria a tabela do dataframe
head(mtcars) #imprime a tabela do dataframe no console 

#1.6 Subconjuntos ----
numeros <- 20:30
numeros[4] # o colchete indica que vamos retornar uma posição específica do conjunto de de vetores 
numeros[c(1,3,7)] # neste caso criamos um vetor de posições
numeros[-2] #quando temos um sinal de menos , significa que queremos todos os elementos menos o do elemento que esta com o menos 
numeros[-c(2,5,9)]
mtcars[2,3] #queremos o elemento da segunda linha e a terceira coluna 
mtcars[,1]  #queremos todos os elementos da primeira coluna (todas as linhas da primeira coluna)
mtcars[1,]  #queremos todos os elementos da primeira linha (todas as colunas da primeira linha)

#1.7 Colunas de um DataFrame----
#nome_dataframe$nome_da_variavel #essa é formula de mexer com colunas em específico de um dataframe
mtcars$cyl

#1.8 Uso da função help no R
#help(nome_da_função) #formula para usar a função help
help(mean)

#2.DataFrames----

#2.1 Extraindo informações de uma base de dados----
load("C:/Users/Hic_T/Programas R/BankLoan.RData")
load("BankLoan.RData")
dim(dados) #dim(nome_dataframe) serve informa o número de linhas 
names(dados) #names(nome_dataframe) serve para ver o nome de todas colunas do dataframe

#2.2 Salvando uma nova base de dados----
dados2 <- dados[,1:4] #criamos uma nova base de dados apenas com as quatro colunas da base de dados antiga
save(dados2,file = "BankLoan_NAO.RData") #salvando a nova base de dados usando a função save 

#2.3 Filtrando variaveis(Colunas) específicas----
#nome_dataframe$nome_da_variavel # formula geral para manipular uma coluna específica da base de dados 
#nome_dataframe$nome_da_variavel[nome_dataframe$nome_da_variavel_de_filtro==restrição] #caso queremos usar um filtro na nossa base dados , usaremos o que esta entre colchetes
#Testes lógicos #as condições podem ser:(== :igualdade)(>= :maior ou igual)(> :maior)(<= :menor ou igual)(< :menor)(!= :diferente)
#Se a varievel de filtro for uma varaivel qualitativa temos que usar aspas duplas 
#Para incluir mais de uma variavel de filtro, temos que utilizar o condicional E, que nesse caso é dado pelo sinal & ,nome_dataframe$nome_da_variavel[nome_dataframe$nome_da_variavel_de_filtro==restrição & nome_dataframe$nome_da_variavel_de_filtro==restrição]. Podemos usar a condição OU também , nesse caso o sinal será o |, nome_dataframe$nome_da_variavel[nome_dataframe$nome_da_variavel_de_filtro==restrição | nome_dataframe$nome_da_variavel_de_filtro==restrição]
load("C:/Users/Hic_T/Programas R/BankLoan.RData")
load("BankLoan.RData")
dados$DEFAULT==0
dados$individuo[dados$DEFAULT==0]
dados$individuo[dados$DEFAULT==0 & dados$EDUCAÇÃO==1]
dados$individuo[dados$DEFAULT==0 | dados$EDUCAÇÃO==1]

#2.4 Estrutura de Dados----
# as variveis presentes em um banco de dados podem ser qualitativas(factor) ou quantitativas(num)
# o comando str() mostra um resumo das variveis  do banco de dados, inclusevi se são factor ou num 
str(dados) #nesse caso todas as variveis srão num, pois são todas quantitativas

#2.5 Incluindo uma nova variavel no dataframe----
# formula geral nome_dataframe$nome_varivel <- vetor com valores
#GRAU_ENDIV=('DÍVIDAS_CC'+'OUTRAS_DIV')/'RENDA'x 100%
grau_endiv_novo <- ((dados$DÍVIDA_CC+dados$OUTRAS_DIV)/dados$RENDA)*100 #recalcula o grau de endividamento
head(grau_endiv_novo,20) #apresenta os novos vinte primeiros valores
head(dados$GRAU_ENDIV,20) # apresenta os vinte valores presente na base de dados
dados$GRAU_ENDIV_NOVA <- grau_endiv_novo #adiciona os dados à uma nova coluna no dataframe
names(dados)

#2.6 Excluir linhas com dados faltantes (NA)----
load("C:/Users/Hic_T/Programas R/Customer.RData")
load("Customer.RData")
# formula para elminar dados faltantes de um data frame nome_dataframe <- na.omit(nome_dataframe)
Customer <- na.omit(Customer)
View(Customer)

#3.Variaveis Qualitativas----
load("BankLoan.RData")
names(dados) #conhecer o nome das variavéis 
str(dados) #tipo de dados armazenados 

#3.1 Definanindo variavel qualitativa----
#Usando a função as.factor(),utiliza os valores a ela apresentados e classifica os dados por meio de categoria , formula geral nome_dataframe$nome_variavel <- as.factor(nome_dataframe$nome_variavel)
dados$EDUCAÇÃO <- as.factor(dados$EDUCAÇÃO)
#para verificar as catogotias de uma variavel qualitativa usamos a função levels(nome_dataframe$nome_variavel)
levels(dados$EDUCAÇÃO)
#podemos dar novos nomes as categorias da variavel, usando um vetor na ordem que queremos atribuir, aindo usando a função levels()
levels(dados$EDUCAÇÃO) <- c("Analfabeto","1ºGrau","2ºGrau","Graduação","Pós-Graduação")
levels(dados$EDUCAÇÃO)
#Para vermos um resumo da varivel, podemos usar tanto a função summary(nome_dataframe$nome_variavel) ou a função str()
summary(dados$EDUCAÇÃO)
str(dados$EDUCAÇÃO) #nesse caso 0 é Adimplente e 1 é Inadimplente, podemos mudar isso usando a função as.factor() para declarar a varaivel como qualitativa, a função levels() para alterar as categorias e um resumo usamos a função summary()
dados$DEFAULT <- as.factor(dados$DEFAULT)
levels(dados$DEFAULT) <- c("Adimplente", "Inadimplente")
summary(dados$DEFAULT)
str(dados$DEFAULT)

#3.2 Definindo a ordem das categórias de uma variavel qualitativa----
#Vamos usar a função factor() para por na ordem e com argumento levels, de maneira geral temos nome_dataframe$nome_variavel <- factor(nome_dataframe$nome_variavel, levels=c("categoria1","categoria2",etc))
dados$EDUCAÇÃO=factor(dados$EDUCAÇÃO,levels=c("Analfabeto","1ºGrau","2ºGrau","Graduação","Pós-Graduação"))

#3.3Tabelas para Variaveis Qualitativas----

#3.3.1 Tabelas considerando apenas uma variavel(Tabelas Univariadas)----

#3.3.1.1 Frequancias Absolutas----
#A contagem de frequencias absolutas de uma variavel qualitativa pode ser feita atravês da função table(), ficando da seguinte maneira table(nome_dataframe%nome_variavel) , normalmente atribuimos a frequancia absoluta a variavel ni
ni <- table(dados$EDUCAÇÃO)
ni
ni_sum <- addmargins(ni) #esse comando acresenta o total
ni_sum

#3.3.1.2 Frequancias Relativas----
#A contagem de frequancias relativas de uma variavel quantitativa pode ser feita atraves da função pro.table(), ficando da seguinte maneira prop.table(nome_dataframe$nome_variavel) , normalmente atribuimos a frequancia relativa a variavel fi
fi <- prop.table(ni)
fi
fi_percent <- round(fi,3)*100 # usamos a função round para arredondar as casas decimais e multiplicamos por 100 para parecer numeros percentuais 
fi_percent
fi_percent_sum <- addmargins(fi_percent) #usamos novamente o comando de soma usado anteriormente na parte de frequencias relativas 
fi_percent_sum

#3.3.1.3 Frequancias Relativas Acumaladas ----
#Para varaiveis qualitativas do tipo ordinal é util o calculo das frequancias relativas acumuladas, cuja a nomenclatura usual é Fi, calculadas usando a função cumsum(), ficando da seguinte maneira cumsum(table_frequancia_relativas)
Fi <- cumsum(fi)
Fi
Fi_percent <- round(Fi,3)*100 # usamos a função round para arredondar as casas decimais e multiplicamos por 100 para parecer numeros percentuais ou isso pode ser feito usando a função prop.table e ficando da seguinte maneira Fi_percent <- prop.table(Fi)
Fi_percent

#3.3.1.4 Combinando as frequancias em uma única tabela----
#Precisamos agora juntas a frequancia relativa, absoluta e a relativa acumulada tudo em uma única tabela 
#Mas precisamos ajustar uma coisa, a frequancia relativa acumulada possui uma linha a menos que as outras duas, para isso vamos usar a função lenght() para igular essa quantidade de linhas 
length(Fi_percent) = length(fi_percent_sum)
#com esse ajuste feito, vamos compilar as três usando a função cbind() para combinar as colunas 
tabEDUC=cbind(ni_sum,fi_percent_sum,Fi_percent)
tabEDUC
#vamos renomear as colunas usando a função colnames(), o mesmo vale vale para as linhas mas usando o comando rownames()
colnames(tabEDUC) <- c("Freq.ABS","Freq.Rel(%)","Freq.Rel.Acul(%)")
tabEDUC
#caso queira uma melhor vizualização das tabelas, pode usar a função View(nome_tabela)
View(tabEDUC)

#3.3.2 Tabelas considerando duas variaveis(Tabelas Bivariadas)----
#Vamos ver agora o cruzamento de duas variaveis, objeto é analisar o compertamento de uma variavel qualitativa com outra 

#3.3.2.1 Frequancias Absolutas ----
#Para criar uma tabela com duas variveis vamos usar novamente a função table(), porém ela será escrita da seguinte forma table(nome_dataframe$variavel_linha,nome_daytaframe$variavel_coluna)
table(dados$EDUCAÇÃO,dados$DEFAULT)
addmargins(table(dados$EDUCAÇÃO,dados$DEFAULT)) #usamos novamente a função addmargins()

#3.3.2.2 Frequancias Relativas pelo total geral ----
#Repetindo a ideia já vista , vamos usar a função pro.table(), porém seguindo a ideia da função table , ficando da seguite forma prop.table(table(nome_dataframe$variavel_linha,nome_daytaframe$variavel_coluna))
prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT))
round(addmargins(prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT))),4)*100 #repetindo o processo do round e do addmargins para ajustar a tabela 

#3.3.2.3 Frequancias Relativas pelo total de linhas ----
#vamos usar o argumento margins presente na função prop.table, colocando 1 nele para obter a frquencia relativa em relação as linhas 
help("Margins")
prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT),margin = 1)
#vamos aplicar agora os conceitos vistos de construção e organozação de tabelas
round(addmargins(prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT),margin = 1),margin =2,),4)*100

#3.3.2.4 Frequancias Relativas pelo total de colunas ----
#Podemos obter a frequencia relativa as colunas por meio do margins=2 da função prop.table()
prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT),margin = 2)
#podemos ainda usar o que já foi visto anteriormente
round(addmargins(prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT),margin = 2),margin = 1),4)*100

#3.3.2.5 Tabelas cruzadas segmentadas por uma terceira variavel----
#Para envolver uma terceira variavel , será necessário usar um filtro , usando colchetes e aind um operador lógico 
dados$Agência==2 #ele vai indicar se há(true) ou não(false) o 2 presente nos dados da agencia
dados$EDUCAÇÃO[dados$Agência==2] # mostra a educação dos indivíduos com agencia 2
dados$DEFAULT[dados$Agência==2]
table(dados$EDUCAÇÃO[dados$Agência==2],
      dados$DEFAULT[dados$Agência==2]) #tabela de frequencias absolutas
round(prop.table(table(dados$EDUCAÇÃO[dados$Agência==2],
                       dados$DEFAULT[dados$Agência==2])),3)*100 #tabela de frequancias relativas
table(dados$Agência)
table(dados$EDUCAÇÃO[dados$Agência>=3 & dados$Agência<=6],dados$DEFAULT[dados$Agência>=3 & dados$Agência<=6]) #tabela de frequancias relativas
round(prop.table(table(dados$EDUCAÇÃO[dados$Agência>=3 & dados$Agência<=6],dados$DEFAULT[dados$Agência>=3 & dados$Agência<=6])),3)*100

#3.4 Gráfico para variaveis qualitativas----

#3.4.1 Gráficos considerando apenas uma variavel(Gráficos Univariados)----

#3.4.1.1 Gráficos de Colunas----
#Para criar um gráfico de colunas vamos usar a função barplot(), para freuqncias absolutas no eixo das ordenadas (y) usa-se barplot(table(nome_dataframe$nome_base)),já para grequencias relativas no eixo das ordenadas fica barplot(prop.table(nome_dataframe$nome_base)), caso queira ter um arredondamento ficando  barplot(round(prop.table(nome_dataframe$nome_base)),3)*100)
barplot(round(prop.table(table(dados$DEFAULT)),3)*100)
#podemos salvar o objeto em uma variavel e fazer um gráfico usando essa variavel
fi <- round(prop.table(table(dados$DEFAULT)),3)*100
barplot(fi)
#duvidas sobre o uso do barplot , use a função help(barplot)
help("barplot")
#para melhor visualização e estética do gráfico, vamos colorir o gráfico usando vetor, ordem que você escrever as cores é como ela será preenchida
barplot(fi,col = c("blue","red"))
#para mais informações sobre as cores use a função colors()
colors()
#podemos ainda dar um título ao nosso gráfico usando o main dentro do barplot usando o argumento main
barplot(fi,col = c("blue","red"), main = "Deafault dos clientes")
#podemos ainda dar título ao eixo y usando o argumento ylab
barplot(fi,
        col = c("blue","red"), 
        main = "Deafault dos clientes",ylab = "Quantidade de clientes (%)")
#podemos mexer no tamanho das fontes do titulo e do eixo das ordenadas, usando respectivamente os argumentos cex.main e cex.lab, devem ser números maiores que 1. Ainda podemos mudar o valor da escala do eixo y usando o argumento ylim
barplot(fi,
        col = c("blue","red"), 
        main = "Deafault dos clientes",ylab = "Quantidade de clientes (%)",
        ylim = c(0,100),
        cex.main=1.15,cex.lab=1.10)

#3.4.1.2 Gráficos de Setores(Pizza)----
#Outro gráfico muito usado é o de pizza ou de setores, para isso usaremos a função pie(), de maneira geral fica pie(round(prop.table(table(nome_dataframe$nome_variavel)),3)*100)
pie(fi)
pie(fi,
    col = c("blue","red"), 
    main = "Deafault dos clientes",
    cex.main=1.15,cex.lab=1.10)
#se quisermos comparar gráficos ao mesmo tempo podemos usar a função par(mfrow=c(a,b)) em que a deve ser o numero de linhas e b a quantidade de colunas 
par(mfrow=c(1,1))
#Gráfico de Colunas com Frequencias Relativas no eixo y
barplot(round(prop.table(table(dados$EDUCAÇÃO)),3)* 100,
        col = c("yellow", "salmon", "blue", "red", "green"),
        main = "Nivel Educacional", 
        ylab = "Quantidade de Clientes (Em %)",
        ylim = c(0, 60),
        cex.main = 1.15, cex.lab = 1.10)
par(mfrow=c(1,2))
#Gráfico de Pizza com Frequencias Relativas
pie(round(prop.table(table(dados$EDUCAÇÃO)),3) * 100,
    col = c("yellow", "salmon", "blue", "red", "green"),
    main = "Nivel Educacional", 
    cex.main = 1.15, cex.lab = 1.10)
#ao inves de numerar as cores que queremos usar, podemos usar função rainbow(x), em que x é a quantidade de cores desejadas 
pie(round(prop.table(table(dados$EDUCAÇÃO)),3) * 100,
    col = rainbow(5),
    main = "Nivel Educacional", 
    cex.main = 1.15, cex.lab = 1.10)

#3.4.2 Gráficos considerando duas variaveis(Gráficos bivariados)----

#3.4.2.1 Gráfico de colunas com frequências relativas ao total geral----
#a frquencia relativa de uma variavel qualitativa ficará no eixo (x) enquanto a outra variavel qualitativa ficará no eixo (y)
#de maneira geral fica barplot(prop.table(nome_df$nome_variavel_linha,nome_df$nome_variavel_coluna)),beside=TRUE) , o beside=TRUE é para as colunas ficarem lado a lado e o beside=FALSE é para elas ficarem empilhadas, por padrão o R adota o beside=FALSE
par(mfrow=c(1,1))
barplot(round(prop.table(table(dados$DEFAULT, dados$EDUCAÇÃO)),3)*100,
        col = c("blue", "red"), #Cores utilizadas
        ylim = c(0,50),
        main = "Nivel Educacional x Default", 
        ylab = "Quantidade de clientes (em %)",
        legend.text = levels(dados$DEFAULT), 
        beside = TRUE,
        cex.main = 1.15, cex.lab = 1.10)

#3.4.2.2 Gráfico de colunas com frequências relativas ao total de linhas----
#agora a primeira variavel vai no eixo y, a segunda variavel indicada vai no eixo x para que as frequancias relativas sejam em relação ao total das linhas 
barplot(round(prop.table(table(dados$DEFAULT,dados$EDUCAÇÃO),margin = 2),3)
        *100,col=c("blue","red"),ylim = c(0,100),
        main="Nivel Educacional x Default",
        ylab="Quantidade de Clientes (Em %)",
        legend.text = levels(dados$DEFAULT),
        cex.main=1.15,cex.lab=1.10)
#as colunas no gráfico agora somam 100, devido ao parametro margin=2, e por padrão as colunas seguiram o parametro de beside=FALSE

#3.4.2.3 Gráfico de colunas com frequências relativas ao total de colunas----
#agora a primeira variavel vai no eixo y, a segunda variavel indicada vai no eixo x para que as frequancias relativas sejam em relação ao total das colunas 
barplot(round(prop.table(table(dados$EDUCAÇÃO,dados$DEFAULT),margin = 2),4)
        *100,col=c("yellow","salmon","blue","red","green"),ylim = c(0,100),
        main="Default x Nivel Educacional ",
        ylab="Quantidade de Clientes (Em %)",
        legend.text = levels(dados$EDUCAÇÃO),
        cex.main=1.15,cex.lab=1.10)
#3.4.2.4 Gráfico de setores segmentado por outra variavel qualitativa----
#vamos, nesse caso usar o operador de igualdade dentro de um filtro para pegarmos o que queremos 
load('Customer.RData')
par(mfrow=c(1,2))
pie(round(prop.table(table(Customer$Marital[Customer$Complain==1])),3),
    col = rainbow(5),main = "Fizeram Reclamação",
    cex.main=1.15,cex.lab=1.10)
pie(round(prop.table(table(Customer$Marital[Customer$Complain==0])),3),
    col = rainbow(5),main = "Não Fizeram Reclamação",
    cex.main=1.15,cex.lab=1.10)

#3.5 Tópicos adicionais ----

#3.5.1 Resolvendo problema de legenda sobreposta em gráficos----
#é comum contrua a legenda de um gráfico dentro da área gráfica, e isso pode acabar por colocara aleganda sobreposta no gráfico, como podemos ver aqui
par(mfrow=c(1,1))
tab <- round(prop.table(table(dados$DEFAULT,dados$EDUCAÇÃO),margin = 2),4)*100
barplot(tab, 
        col=c("blue","red"),
        ylim=c(0,100),
        main="Nivel educacional x Default (% do total de cada nivel educacional", 
        ylab="Quantidade de clientes (Em %)", 
        legend.text=levels(dados$DEFAULT),cex.main=1.15,cex.lab=1.10)
#uma solução seria "empurrar" o gráfico para o lado usando o xlim
tab <- round(prop.table(table(dados$DEFAULT,dados$EDUCAÇÃO),margin = 2),4)*100
barplot(tab, 
        col=c("blue","red"),
        ylim=c(0,100),xlim = c(0,ncol(tab)+2), #aumenta o espaço exibido no eixo x
        main="Nivel educacional x Default (% do total de cada nivel educacional", 
        ylab="Quantidade de clientes (Em %)", 
        legend.text=levels(dados$DEFAULT),cex.main=1.15,cex.lab=1.10)

#3.5.2 Adicionando os rótulos no gráfico de pizza---- 
#fica interessante mostrar os rótulos no gráficas de pizza, só precisamos criar uma variavel para receber essas frequências com as respectivas categorias da variavel qualiativa  

#3.5.2.1 Apresentando as frequências relativas----
fi <- round(prop.table(table(dados$DEFAULT)),3)*100
rotulos=paste(names(fi), "\n",fi,sep="","%")
pie(fi, col = c("blue","red"),labels=rotulos,
    main="Default dos clientes",
    cex.main=1.15,cex.lab=1.10)

#3.5.2.2 Apresentando as frequências absolutas----
ni <- table(dados$DEFAULT)
rotulos=paste(names(ni), "\n",ni,sep="")
pie(ni, col = c("blue","red"),labels=rotulos,
    main="Default dos clientes",
    cex.main=1.15,cex.lab=1.10)

#3.5.3 Adicionando os rótulos no gráficos de colunas----
#Para apresentar os rótulos no gráfico de colunas, devemos armazenar o comando do gráfico em uma variavel, para isso vamos usae o comando text para adicionar rótulos, adiciona +quantidade para falar quanto em cima de cada coluna deve adicionar os rótulos

#3.5.3.1 Apresentando as frequências relativas----
fi <- round(prop.table(table(dados$DEFAULT)),3)*100
x=barplot(fi, col = c("blue","red"), main="Default dos Clientes",
          ylab="Quantidade de clientes (Em %)",
          ylim=c(0,80))
text(x,fi+3,labels=paste(fi))

#3.5.3.2 Apresentando as frequências absoluta----
ni <- table(dados$DEFAULT)
x=barplot(ni, col = c("blue","red"), main="Default dos Clientes",
          ylab="Quantidade de clientes",
          ylim=c(0,450))
text(x,ni+20,labels=paste(ni))

#4.Variaveis Quantitaivas----
#No caso das variaveis quantitativas, será necessa´rio um recursos diferentes para serem analisadas devido ao fato de serem numéricas e possuirem diversos valores, sejam elas contínuas ou discretas

#4.1 Definindo uma variavel de quantitativa no R----
#O R não consegue identificar uma variavel numérica como quantitativa, por isso se deve usar a função as.numeric() , para que assim ela seja corretamente identificada, de maneira geral fica nome_dataframe$nome_variavel <- as.numeric(nome_dataframe$nome_variavel)
dados$RENDA <- as.numeric(dados$RENDA)

#4.2 Tabela de variavel de quantitativa no R----
#uma forma de analisar variaveis quantitativas seria usando faixas de valores, podemos criar essas faixas usando a função cut, ficando da sequinte forma cut(nome_dataframe$nome_variavel, breaks=k) primeiro colocamos a coluna que se localizam os valores , depois usando o argumento breaks perimite com que o usuário defina as especificações em relação as faixas 
#para estipular as faixas, podemos fazer de duas formas, primeira k=√n , a segunda seria realizar a ampliutude dos valores para verificar se todos os valores estaram dentro das faixas 

#4.2.1 Criando faixas com amplitudes iguais----
#Para calcular √n , vamos utilizar a função sqr(número_desejado), para obter o número desejado , vamos usar a função length(nome_dataframe$nome_variavel)
k <- sqrt(length(dados$IDADE))
k
#K aproximandamente deu 22, mas esse é um número relativamente alto, por isso usaremos um número próximo , caso 10
k<-10 

#4.2.1.1 R determina automaticamente os limites de cada caixa----
IDADEord0=cut(dados$IDADE, breaks = k)
#vamos obter as frequencias absolutas para a idade 
addmargins(table(IDADEord0))
#vamos obter as frequencias relativas para a idade
round(addmargins(prop.table(table(IDADEord0))),3)*100

#4.2.1.2 O usuário determina o limite de cada faixa ----
#Vamos criar nosso próprio intervalo de faixa, mas de tamanhos iguais, usando a função seq(começo,fim,pulando), para isso vamos precisar saber o mínimo dos dados usando a função min(nome_dataframe$nome_variavel) e o máximo dos dados usando a função max(nome_dataframe$nome_variavel)
min(dados$IDADE)
max(dados$IDADE)
amplitude <-max(dados$IDADE) - min(dados$IDADE)
amplitude
ampfaixas <- amplitude/k
ampfaixas
faixas1=seq(20,58.5,3.5)
faixas1
IDADEord1 <-cut(dados$IDADE,breaks = faixas1)
head(IDADEord1,20) ##exibe os 20 primerios valores do vetor 
#para contruir um intervalo fechado "[" no 1° valor e aberto ")" no 2° valor da amplitude, temos que incluir o argumento right=FALSE dentro do comando cut ()
IDADEord1 <-cut(dados$IDADE,breaks = faixas1, right = FALSE)
head(IDADEord1,20)
#para incluir o objeto IDADEord1 como uma variável qualitativa ordinal na base de dados nomeada dados, basta rodar o comando abaixo 
dados$IDADEord <- IDADEord1
#vamos calcular a as frequencias desses dados e fazer uma tabela
ni <- addmargins(table(IDADEord1))
fi <- round(addmargins(prop.table(table(IDADEord1))),3)*100
Fi <- round(cumsum(prop.table(table(IDADEord1))),3)*100
length(Fi) <- length(fi)
tabIDADE1 <- cbind(ni,fi,Fi)
colnames(tabIDADE1)=c("Freq.Abs","Freq.Rel (%)","Freq.Rel.Acum(%)")
tabIDADE1
#4.2.2 Criando faixas de amplitudes diferentes----
#para criar faixas de amplitude diferente vamos usar vetores c()
faixas2 <- c(min(dados$IDADE),25,30,35,40,max(dados$IDADE)+1) #esse +1 no final serve para garantir que que o valor máximo estja na ultima faixa
faixas2
IDADEord2=cut(dados$IDADE,breaks = faixas2,right = FALSE)
head(IDADEord2,20)
ni <- addmargins(table(IDADEord2))
fi <- round(addmargins(prop.table(table(IDADEord2))),3)*100
Fi <- round(cumsum(prop.table(table(IDADEord2))),3)*100
length(Fi) <- length(fi)
tabIDADE2 <- cbind(ni,fi,Fi)
colnames(tabIDADE2)=c("Freq.Abs","Freq.Rel (%)","Freq.Rel.Acum(%)")
tabIDADE2
#4.3 Gráfico para variaveis quantitaivas----

#4.3.1 Dotplot----
#é um gráfico de pontos que  possui a escala quantitativa somente no eixo x, vamos usar a modalidade clevelend do dotplot, que consiste em marcar um ponto acima da coordenada do eixo x correspondente ao valor observado da variavel, garantindo q ue todos os pontos aparecem em alturas diferentes, o ponto mais baixo corresponde a primeira observação e o mais alto a ultima observação. Para para criar o dotplot vamos usar a função dotchart(), ficando da seguinte forma dotchart(nome_dataframe$variavel_quantitativa)
dotchart(dados$IDADE,main="DotPlot variavel Idade",
         xlab="Idade",ylab="Individuos",cex.main=1.15,cex.lab=1.1)
#para auxiliar na ánalise gráfica, podemos ordenar as variveis usando a função order(),ficando da seguinte maneira order(nome_dataframe$nome_variavel)
load("C:/Users/Hic_T/Programas R/BankLoan.RData")
load("BankLoan.RData")
dados2 <- dados[order(dados$IDADE),] #a virgula aqui ao lado serve para dizer que as coluas serão reorganizadas junto da ordenação de linha
dotchart(dados2$IDADE,main="DotPlot variavel Idade",
         xlab="Idade",ylab="Individuos",cex.main=1.15,cex.lab=1.1) #as informações são as mesmas, mas dispostas de maneira diferente, no quesito ordenado
#o dotchart pode mostrar informação sobre tendência central, variabilidade, assimetria dos dados, presença de valores aberrantes, etc
load("IDH.RData")
dotchart(IDH$A17,labels = IDH$UF,
         main = "Dotplot IDH 2017",
         xlab="IDH",ylab="UF",
         cex.main=1.15,cex.lab=1.1)
#vamos reodenar os dados novamente
IDHord <- IDH[order(IDH$A17),]
dotchart(IDHord$A17,labels = IDHord$UF,
         main = "Dotplot IDH 2017",
         xlab="IDH",ylab="UF",
         cex.main=1.15,cex.lab=1.1)
#4.3.2 Histograma ----
#histograma é um gráfico de colunas, sem espaçmento entre as colunas, em que a variavel quantitativa é representada nos intervalos(faixas) no eixo x. Para isso vamos utilizar a função hist(), ficando da seguinte maneira, hist(nome_dataframe$nome_Variavel_quantitativa)
hist(dados$IDADE,
     col = "turquoise",
     xlab = "Idade",
     ylab = "Frequência Absoluta",
     main = "Gráfico de colunas para Idade",
     xlim = c(10,70),ylim = c(0,120),cex.main = 1.15, cex.lab = 1.10)
#é interessante, neste caso, usarmos dois argumentos muito importes, o breaks e o probability. O breaks define as faixas nas quais serão feitas as quebras, pode receber diversas entradas. Já o probability serve para fazer a densidade de frequencia no eixo y 
hist(dados$IDADE,
     breaks = 18,
     col = "turquoise",
     xlab = "Idade",
     ylab = "Frequência Absoluta",
     main = "Gráfico de colunas para Idade",
     xlim = c(10,70),ylim = c(0,120),cex.main = 1.15, cex.lab = 1.10)
hist(dados$IDADE,
     breaks = seq(20,57,1), #podemos usar a função seq() também
     col = "turquoise",
     xlab = "Idade",
     ylab = "Frequência Absoluta",
     main = "Gráfico de colunas para Idade",
     xlim = c(10,70),ylim = c(0,120),cex.main = 1.15, cex.lab = 1.10,
     right = FALSE)
hist(dados$IDADE,
     breaks = faixas2,
     probability = TRUE, #você pode usar tanto o probability=TRUE ou freq=FALSE
     col = "turquoise",
     xlab = "Idade",
     ylab = "Frequência Absoluta",
     main = "Gráfico de colunas para Idade",
     xlim = c(10,70),cex.main = 1.15, cex.lab = 1.10) #no caso do probability=TRUE não precisa do ylim
#Este gráfico faz sentido, tendo em vista que as frequências relativas de cada faixa estão na área da coluna,somando assim uma área total igual 1.
#vale apresentar os limitantes de cada faixa no eixo x. Tal mudança pode ser feita por meio da funçãoaxis(side = 1 ou 2, at = limitantes desejados), que cria um novo eixo x para o gráfico. Utiliza-se side =1 se a inclusão do novo eixo for nas abcissas (x) e, side = 2 caso seja nas ordenadas (y).Para isso é necessário incluir o argumento xaxt="n" na função hist(), para retirar o eixo x que o R colocou 
hist(dados$IDADE,
     breaks = faixas2, # Amplitudes diferentes
     probability = TRUE, # Densidade no eixo y
     col = "turquoise",
     xlab = "Idade",
     ylab = "Densidade",
     main = "Histograma com rótulos nas faixas",
     xlim = c(10,70),
     right = FALSE,
     cex.main = 1.15, cex.lab = 1.10,
     xaxt = "n")
axis(side = 1, # Se side=1: Incluir eixo x; Se side=2: Incluir eixo y
     at = faixas2) # Faz incluir os valores do objeto faixas2 no eixo x

#4.3.2.1 Histograma alisado----
#nada mais é que o contorno do histograma, mas sem a divisão das classes, ele é obtido atravês do comando density, dentro da função plot(), ficando da seguinte maneira plot(density(nome_dataframe$nome_variavel))
plot(density(dados$IDADE),
     main = "Histograma alisado",
     xlab = "Idade",
     ylab = "Densidade",
     xlim = c(10,70),
     cex.main = 1.15, cex.lab = 1.10)
#podemos unir tanto o histogram quanto histograma alisado, usando a função lines
hist(dados$IDADE,probability = TRUE,breaks = faixas2,
     xlab="Idade",ylab="Densidade",
     main = "Histograma com rótulos nas faixas",
     col = "turquoise",
     xlim = c(10,70),ylim=c(0,0.05),right = FALSE)
lines(density(dados$IDADE),col="black",lwd=3)

#4.3.3 Percentis e Ogiva----

#4.3.3.1 Percentis ou quantis----
#quartil ou percentil de ordem p(0<p<100) como o valor que divide as observações ordenadas de uma variavel em duas partes: uma delas p% dos valores menores e outra com (100-p)% dos valores maiores, há diversas maneiras de se esitmar o percentil de um conjunto de dados, no geral, os valores obtidos a partir de difrentes técnicas tendem a se igualar em grandes amostras
#o comando quantile() estima qualquer percentil de um conjunto de dados, de forma geral ele fica quantile(nome_dataframe$nome_variavel, ordem_dos_percentis/100)
quantile(dados$IDADE,0.5) #calcula a mediana (50° do percentil) da variavel
quantile(dados$IDADE,0.9) #calcula a mediana (90° do percentil) da variavel
#uma forma de se compactar isso seria usando um lista de valores em uma varivel
per <- c(0.5,0.9)
quantile(dados$IDADE,per) #calcula a mediana (50° e 90° do percentil) da variavel
#caso não se informe os a ordem dos percentis, ele , por padrão, irá calcular os percentis padrões(25%,50%,75%, conhecidos como quartis), além do mínimo(0%) e máximo(100%)
quantile(dados$IDADE)

#4.3.3.2 Ogivas----
#represantação gráficas dos percentis de uma variavel,construida a partir de pares ordenados , a ordem fica no eixo x e o seu percentil no eixo y
#vamos usar a função plot, mas uma outra formar

#4.3.3.2.1 Opção 1----
#plot(nome_df$nome_variavel_y~nome_df$nome_variavel_x, type="1",lwd=2,col="blue", xlab="nome da variavell x",ylab="ordem do percentil",main="Título do gráfico)
#criando um :
# Gera uma lista que contém os números:0, 0,02, 0,04, ..., 0,98, 1,00
per <- seq(0, 1, .02)
# Objeto com os percentis com ordens dadas na lista per
qIDADE <- quantile(dados$IDADE, per)
# Constrói gráfico
plot(per ~ qIDADE, # Atribui a variável qIDADE ao eixo x e a variável per ao eixo y
     type="l", # Unir os pontos do gráfico com linha
     xlab="Idade", ylab="Ordem do Percentil",
     main="Distribuição acumulada da Idade",
     lwd=2,
     col="blue",
     cex.main = 1.15, cex.lab = 1.10)

#4.3.3.2.1 Opção 2----
#podemos mudar a forma como escreviamos o plot para uma maneira mais enxuta, ficando da seguinte maneira
plot(qIDADE, per,
     type="l",
     xlab="Idade", ylab="Ordem do Percentil",
     main="Distribuição acumulada da Idade",
     lwd=2,
     col="gray5",
     cex.main = 1.15, cex.lab = 1.10)
#1. O argumento type="l" é para que seja feito um gráfico com linhas (l de line).2. O argumento lwd define a espessura da linha e tem por padrão o valor 1, mas você pode aumentar este valor

#4.3.4 Boxplot----
#uma outra forma de avaliar de avaliar a distribuição dos dados se dá por meio de um gráfico de boxplot, o boxplot exibe um retangulo no centro. Ele é limitado superiormente pela posição do terceiro quartil(percentil de ordem 75) e inferiormente  pela posição do primeiro quartil(percentil de ordem 25).A posição da mediana é destacada por uma linha dentro do retangulo, , as linhas verticas acima e abaixo do gráfico(hastes) se estendem até os valores mais extremos dos dados , não considerados pontos suspeitos de serem outliers, de forma que valores atípos são destacados com um pequeno circulo
#de maneira geral ficam boxplot(nome_dataframe$variavel_quantitaiva)
boxplot(dados$TEMPO_EMP)
boxplot(dados$TEMPO_EMP,
        col = "turquoise",
        ylab = "Tempo de emprego (em anos)",
        main = "Boxplot para Tempo_Emp",
        ylim = c(0,30),
        cex.main = 1.15, cex.lab = 1.10)

#4.3.5 Gráficos de segmentação----
#Podemos adaptar gráficos para avaliar/comparar o comportamento de uma variável em diferentes grupos(segmentos)

#4.3.5.1 Segmentação de dotplots----
#Para segmentar o dotplot precisamos formatar a variavel indicadora do grupo como fator, para isso iremos usar a função as.factor()
dados$DEFAULT <- as.factor(dados$DEFAULT)
levels(dados$DEFAULT) <- c("Adimplente","Inadimplente") #esse comando é particular a esse exemplo
dados <- dados[order(dados$IDADE),] #ordena base de dados por idade
gcor <- c("blue","red") #cores diferentes para para os dois niveis
dotchart(dados2$IDADE,groups = dados2$DEFAULT,
         gcolor = gcor,color = gcor[dados2$DEFAULT],
         main = "Dotplot da variavel idade",xlab="Idade",
         cex.main=1.15,cex.lab=1.10)
#as opçoes color e gcolor permitem atribuir cores aos pontos de cada grupo
#o argumento color=gcor[dados2$DEFAULT] está solicitando que as cores guardadas em gcor sejam atribuídas a cada categoria da variável qualitativa (fator) dados2$DEFAULT. A atribuição das cores é feita em ordem alfabética (ou numérica se a variável estiver representada por números)

#4.3.5.2 Segmentação de Histogramas----
par(mfrow=c(1,2))
# Histograma da idade só dos adimplentes
hist(dados$IDADE[dados$DEFAULT=="Adimplente"],
     breaks = faixas2,
     col = "blue",
     xlab = "Idade",
     ylab = "Densidade",
     main = "Histograma para Idade dos Adimplentes",
     xlim = c(10,70),
     ylim = c(0,0.05),
     probability = TRUE,
     right = FALSE,
     cex.main = 1.15, cex.lab = 1.10,
     xaxt = "n")
axis(side = 1,
     at = faixas2)
# Histograma da idade só dos inadimplentes
hist(dados$IDADE[dados$DEFAULT=="Inadimplente"],
     breaks = faixas2,
     col = "red",
     xlab = "Idade",
     ylab = "Densidade",
     main = "Histograma para Idade dos Inadimplentes",
     xlim = c(10,70),
     ylim = c(0,0.05),
     probability = TRUE,
     right = FALSE,
     cex.main = 1.15, cex.lab = 1.10,
     xaxt = "n")
axis(side = 1,
     at = faixas2)

#4.3.5.3 Segmentação de histogramas alisados----
# Adiciona um histograma alisado para a categoria 1 da variável qualitativa
"plot(density(nome_df$nome_var_quanti[nome_df$nome_var_quali == ]),
     lty = 1, # Tipo de linha
     lwd = 3, # Espessura da linha
     col = , # Cor da linha
     xlab = Descrição do eixo x,
     ylab = Descrição do eixo y,
     main = Título do gráfico,
     xlim = c(min_x,max_x),
     ylim = c(min_y,max_y))"
# Adiciona, na mesma janela gráfica anterior, um histograma alisado para a categoria 2
"lines(density(nome_df$nome_var_quanti[nome_df$nome_var_quali ==]),
      lty = 1, # Tipo de linha
      lwd = 3, # Espessura da linha
      col = ) # Cor da linha
# Adiciona a legenda no gráfico
legend(topright,
       col=c(,),
       legend=c(Categoria 1,Categoria 2),
       lty = c(1,1),
       lwd = c(3,3))"
#Os tipos de linha (lty) podem ser definidos como números (0=blank, 1=solid (default), 2=dashed, 3=dotted, 4=dotdash, 5=longdash, 6=twodash) ou como texto entre aspas (“blank”, “solid”, “dashed”, “dotted”,“dotdash”, “longdash”, or “twodash”). Para mais detalhes destas opções, digite help(par) 
# Adiciona um histograma alisado para a idade dos adimplentes
par(mfrow=c(1,1))
plot(density(dados$IDADE[dados$DEFAULT == "Adimplente"]),
     lty = 1, # Tipo de linha
     lwd = 3, # Espessura da linha
     col = "blue", # Cor da linha
     xlab = "Idade (em anos",
     ylab = "Densidade",
     main = "Histograma alisado por DEFAULT ",
     xlim = c(10,70),
     ylim = c(0,0.05),
     cex.main = 1.15, cex.lab = 1.10)
# Adiciona, na mesma janela gráfica anterior, um histograma alisado dos inadimplentes
lines(density(dados$IDADE[dados$DEFAULT == "Inadimplente"]),
      lty = 1, # Tipo de linha
      lwd = 3, # Espessura da linha
      col = "red") # Cor da linha
# Adiciona a legenda no gráfico
legend("topright",
       col=c("blue","red"),
       legend=levels(as.factor(dados$DEFAULT)),
       lty = c(1,1),
       lwd = c(3,3))

#4.3.5.4 Segmentação de ogivas----
#para fazer isso precisamos sobrebor em um mesmo par de eixos 
per <- seq(0, 1, .02)
# Calculando os percentis de idade para os Adimplentes
qIAD <- quantile(dados$IDADE[dados$DEFAULT=="Adimplente"], per)
# Calculando os percentis de idade para os Inadimplentes
qIIN <- quantile(dados$IDADE[dados$DEFAULT=="Inadimplente"], per)
#Em seguida, os gráficos podem ser construídos com os comandos:
# Constrói um gráfico de linha para os Adimplentes
plot(per ~ qIAD,
     type="l", xlab="IDADE", ylab="Ordem do Percentil",
     main="Distribuição acumulada da Idade", lwd=2, col="blue",
     xlim=c(20,60),
     cex.main = 1.15, cex.lab = 1.10)
# Adiciona linha para os Inadimplentes
lines(per ~ qIIN, col="red", lwd=2, xlim=c(20,60))
# Adiciona legenda
legend("bottomright", legend=c("Adimplentes", "Inadimplentes"),
       fill=c("blue", "red"), bty="n")
#ou
plot(qIAD, per,
     type="l", xlab="Idade", ylab="Ordem do Percentil",
     main="Distribuição acumulada da Idade", lwd=2, col="blue",
     xlim=c(20,60))
lines(qIIN, per, col="red", lwd=2, xlim=c(20,60))

#4.3.5.5 Segmentação de boxplots----
#Para incluir mais de um basta incluir uma virgula e adicionar um novo vetor de dados, lembrando de usar um filtro de dados. Utilizaremos a função legend() para adicionar uma legenda no gráfico e o argumento col para colocar um vetor com cores 
boxplot(dados$IDADE[dados$DEFAULT=="Adimplente"],
        dados$IDADE[dados$DEFAULT=="Inadimplente"],
        col = c("blue","red"),
        xlab = "Tipo de cliente",
        ylab = "Idade (em anos)",
        main = "Boxplot para Idade",
        ylim = c(20,70),
        cex.main = 1.15, cex.lab = 1.10)
legend("topright", #Posição da legenda
       legend = c("Adimplente","Inadimplentes"), #Nomes da legenda
       fill = c("blue", "red")) #Cores da legenda
#podemos fazer isso de uma forma usando o ~ , de maneira geral fica boxplot(nome_df$nome_var_quanti ~ nome_df$nome_var_quali)
boxplot(dados$IDADE ~ dados$DEFAULT,
        col = c("blue","red"),
        xlab = "Tipo de cliente",
        ylab = "Idade (em anos)",
        main = "Boxplot para Idade",
        ylim = c(20,70),
        cex.main = 1.15, cex.lab = 1.10) #neste caso não precisamos usar o comando legends() pois o R usa as categorias da varaivel para representar o eixo x
#Atenção, esses comandos só dão certo quando, base de dados, a coluna representa os grupos a serem comparados e outra coluna representa a variavel quantitativa de interesse, de maneira geral fica boxplot(nome_var1,nome_var2,nome_var3,names=c("nome 1","nome 2","nome 3"))
boxplot(IDH$A91, IDH$A00, IDH$A10, IDH$A17,
        main="IDH das UF brasileiras ao longo do tempo",
        xlab="Ano",
        ylab="IDH",
        col="yellow",
        names = c("1991","2000", "2010", "2017"),
        cex.main = 1.15, cex.lab = 1.10)

#4.4 Medidas resumo----
#Uma forma de extrair informação de determinada variavel quantitativa, caso exista os "NA"(não disponivel em portugues), vamos usar o argumentos na.rm=TRUE nas funções para resolver

# 4.4.1 Algumas medidas de poisição: Média, Mediana e Moda

#4.4.1.1 Média----
#mean(nome_da_base$nome_da_variavel), formula para calcular o valor da média de um determinado vetor
mean(dados$IDADE)
#de uma alternativa podemos usar a soma dos elementos do vetor dividida pelo número de elementos do vetor, de maneira geral ficar sum(nome_da_base$nome_da_variavel)/length(nome_da_base$nome_da_variavel)
sum(dados$IDADE)/length(dados$IDADE)

#4.4.1.2 Moda----
#moda é valor mais frequente de uma amostra, ou faixa de valores no caso de uma classe modal
#não temos nativamente uma função Moda no Rstduio/R, mas temos como usar essa função atravês da biblioteca DescTools, verifique se você a possui, caso não use o seguinte comando no console: install.packages("DescTools")
library(DescTools)
#o comando moda neesa blioteca segue esse padrão Mode(nome_df$nome_variavel)
Mode(dados$IDADE) #ele primeiro ira dizer qual o valor moda e depois sua frequência 
#Como, nesse caso estivéssimos lidando com uma variavel quantitativa contínua, é melhor utilizar uma faixa de valores para verificar a maior de frequencia de dados,Nesse caso, nosso obejtivo é encontrar a classe modal
#para isso vamos obter uma tabela de frequências divida em faixas 
table(IDADEord1)
#nesse caso encontrando a classe mais frequente, depois vamos a função names() para selecionar tal elemento, para saber em que posilçao ele etá, vamos usar o operador de igualdade e a função max(), para termos um vetor lógico(TRUE ou FALSE) dos máxiomos vetores, em que true é a posição de um máxiomo
#por fim usaremos a função which(), que retorna em quais posições de um determinado vetor vetor se localizam os TRUE
tab1 <- table(IDADEord1) #armazena a tabela 
names(tab1)[which(tab1==max(tab1))] #encontra a classe modal 
#por fim usaremos o ponto médio da classe em questão como a estimativa da nossa moda mo(x)=28,75
#é possível que a amostra tenha mais de uma classe modal, bastando que os elementos mais frequentes tenha sido observados o mesmo número de vezes

#4.4.1.3 Mediana----
#a mediana é a o ponto em que a amostra é dividida em duas partições de 50%
#no R de maneira geral ela é representada de maneira geral median(nome_df$nome_da_variavel)
median(dados$IDADE)
#podemos ver qual a mediana de uma outra forma, atravês da função quantile()
quantile(dados$IDADE,0.50)

# 4.4.2 Algumas medidas de dispersão:Desvio médio absoluto,variância e desvio padrão ----
#uma forma de explorar e analisar dados, assim como as medidas de resumo

#4.4.2.1 Desvio Médio Absoluto----
#Seu objetivo é encontrar a distanância média das observações em realção a sua média, de maneira geral ela fica MeanAD(nome_da_base$nome_da_variavel), é necessário ter a biblioteca DescTools para usar essa função
library(DescTools)
MeanAD(dados$IDADE)

#4.4.2.2 Variância----
#uma das medidas de resumo mais famasos que existem, ela é um desvio médio absoluto, mas ao invés de ser absoluto, ela é ao quadrado, de maneira geral fica var(nome_da_base$nome_da_variavel)
var(dados$IDADE)

#4.4.2.3 Desvio Padrão----
#é a "correção" da variância, pois como a variância está ao quadrado e precismos analisar dados sem estar ao quadrado, tiramos a raiz quadrada da variância, isso se dá o nome de desvio padrão, ficando da seguinta maneira sd(nome_da_base$nome_da_variavel)
sd(dados$IDADE)
# apenas calcular a raiz quadrada da variância
sqrt(var(dados$IDADE))

#4.4.3 Tópicos adicionais 

#4.4.3.1 Função summary()----
#ela é usada para fazer contagens de observções em cada categoria de uma variavel qualitativa.Mas, seu uso principal é para o calculo de algumas variaveis quantitativas, de maneira geral summmary(nome_dataframe$nome_variavel_quantitativa)
summary(dados$IDADE)
#podemos usar essa simultaneamente para outras variaveis quantitativas, mas para isso temos que remover as variaveis qualitativas
summary(dados2)

#4.4.3.2 Função apply()----
#a ideia do apply é aplicar uma determinada função para linhas ou para colunas de um determinado objeto selecionado, de maniera geral 
"apply(nome_da_base$nome_da_variavel, #Nome da variavel quantitativa
      margin, #margin = 1 para aplicar a função nas linhas
      #margin = 2 para aplicar a função nas colunas
      fun) #Função que será aplicada"
apply(dados2, 2, mean) #Faz a média para cada coluna
apply(dados2, 2, quantile) #calcula os quartis 

#4.4.3.3 Função tapply()----
#a função tapply() serve para aplicar uma dterminada função para uma função quantativa segmentado pelas categorias de uma variavel qualitativa, de maneira geral 
"tapply(nome_da_base$nome_var_quanti, #Nome da variavel quantitativa
       nome_da_base$nome_var_quali, #Nome da variavel qualitativa
       fun)"
tapply(dados$IDADE,dados$DEFAULT,mean) #faz média 
tapply(dados$IDADE,dados$DEFAULT,median) #faz mediana 

#mais informações sobre as funcionalidade de sapply(),apply(),tapply(), use a documentação do R ou help()

#4.4.3.4 Dados Faltantes(NA)----
#as vezes não queremos eliminar todas as informções de uma linha da base de dadosquando ela tem dado faltante(NA) em poucas varievis.Pode ser interessante eliminar essa linha apenas na(s) variavel(is) que será(ão) analisada(s)
#Funções para calculo de medidas resumos de variaveis quantitivas possuem argumento na.rm=TRUE, com isso estamos colocando como verdadeira a opção "remove NA", ficando da seguinte maneira função(nome_dataframe$nome_variavel,na.rm=TRUE)
#caso queira saber quantos valores estão "NA", podemos usar a função !is.na() e a sum() juntas, ficando da seguinte maneira !is.na(nome_dataframe$nome_variavel), retornando com TRUE ou FALSE, sendo FALSE indicando dado faltando
!is.na(Customer$Income)
sum(!is.na(Customer$Income))

#4.5 Análise Bidimencional: medidas de associação e gráfica de dispersão----
load("Veiculos.RData")
#vamos ver quais os nomes das colunas usando a função names() e o tipo de dado usando a função str()
names(Veiculos)
str(Veiculos)

#4.5.1 Gráfico de dispersão e reta de um ajusto linear simples ----

#4.5.1.1 Gráfico(Diagrama) de Dispersão----
#podemos ver a associação entre duas variaveis quantitaveis pode ser feita por meio de um gráfico ou diagrama de dispersão.Ográfico consiste em considerar as informações de cada indivíduo como pares ordenados e posicionar esses pontos no plano cartesiano .A ánalise do gráfico fornece informção sobre a existência de relação entre as variáveis, sua forma e intensidade da associação
#de maneira geral fica 
"plot(nome_df$nome_variavel_y ~ nome_df$nome_variavel_x,
     xlab = Titulo do eixo x,
     ylab = Titulo do eixo y,
     cex = tamanho desejado dos pontos,
     pch = formato desejado dos pontos,
     col = darkblue)"
plot(Veiculos$preco ~ Veiculos$comprimento, # Variável eixo y ~ variável eixo x
     xlab = "Comprimento do Veículo (em metros)", # Descrição do eixo x
     ylab = "Preço do Veículo (em dólares)", # Descrição do eixo y
     cex = 0.7, # Tamanho do ponto
     pch = 16, # Formato dos pontos
     col = "darkblue", # Cor dos pontos
     cex.main = 1.15, cex.lab = 1.10)
#uma versão alternativa seria 
"plot(nome_df$nome_variavel_x, nome_df$nome_variavel_y,
     xlab = Titulo do eixo x,
     ylab = Titulo do eixo y,
     cex = tamanho desejado dos pontos,
     pch = formato desejado dos pontos,
     col = darkblue)"
plot(Veiculos$comprimento, # Variável do eixo x
     Veiculos$preco, # Variável do eixo y
     xlab = "Comprimento do Veículo (em metros)", # Descrição do eixo x
     ylab = "Preço do Veículo (em dólares)", # Descrição do eixo y
     cex = 0.7, # Tamanho do ponto
     pch = 16, # Formato dos pontos
     col = "darkblue", # Cor dos pontos
     cex.main = 1.15, cex.lab = 1.10)
#para saber quais são as possibilidades de formatos dos pontos do gráfico, digite help(points)

#4.5.1.2 Ajustando uma reta aos dados----
#para obter a equação da reta(ajuste linear), vamos utilizar a função lm() de linear model, a partir dos x e y, esse comando gera os coeficintes a e b da reta, de maneira geral fica lm(nome_variavel_EIXOy ~ nome_variavel_EIXOx)
lm(Veiculos$preco~Veiculos$comprimento)
#y=91858x-23828 , 'y' represanta o preço e 'x' representa o comprimento
#a função abline() é responsavel por plotar a reta no ultimo gráfico feito, de maneira geral fica abline(lm(y~x)), depois da criação do gráfico de dispersão, a reta será inclusa no ultimo gráfico
plot(Veiculos$preco ~ Veiculos$comprimento,
     xlab = "Comprimento do Veículo (em metros)", # Descrição do eixo x
     ylab = "Preço do Veículo (em dólares)", # Descrição do eixo y
     cex = 0.7, # Tamanho do ponto
     pch = 16, # Formato dos pontos
     col = "darkblue", # Cor dos pontos
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(Veiculos$preco ~ Veiculos$comprimento)) # Plota linha de tendência
#podemos armazenar os coeficientes da equação de ajuste linear em um objeto do R para que possa, no futuro, fazer uma previsão. Para isso é só armazenar o resultado do lm() é um objeto, ficando da seguinte maneira Reta = lm(nome_variavel_EIXOy~nome_variavel_EIXOx)
#Os coeficientes da reta podem ser salvos em outro objeto, ficando da seguinte maneira A=coef(Reta), A[1] é o intercepto (coeficinte linear)da reta e A[2] é o coeficinte de inclinação (coeficinte angular)da reta 
Reta = lm(Veiculos$preco ~ Veiculos$comprimento) # Calcula e guarda ajuste linear
Reta
A = coef(Reta) # Guarda apenas os coeficientes da reta em A
A
a = A[2] # Guarda o valor da inclinação da reta em a
a
b = A[1] # Guarda o valor do intercepto em b
b
#para fazermos a previsão de alogo ,basta escolher o ponto e substituir na reta
Reta = lm(Veiculos$preco ~ Veiculos$comprimento) # Calcula e guarda ajuste linear
A = coef(Reta) # Guarda apenas os coeficientes da reta em A
a = A[2] # Guarda o valor da inclinação da reta em a
b = A[1] # Guarda o valor do intercepto em b
x = 4 # Guarda o valor do comprimento do veículo no objeto x
yp=a*x+b # Faz o cálculo do valor previsto do preço do veículo e armazena no objeto yp
yp # Mostra o resultado de yp

#4.5.2 Análise Bidimencional com Segmentação----

#4.5.2.1 Gráficos de Dispersão segmentados por uma Varaivel Qualitativa----
#vamos comparar a associação existente entre duas variaveis quantitativas em diferentes grupos de um conjunto de dados 
#de maneira geral vamos contruir gráficos de dispersão segmentado da seguinte forma:
# Adiciona pontos diferenciando as cores pelos níveis da variável qualitativa
# (usualmente, em ordem alfabética)
# Transforma variável qualitativa em fator
"nome_df$variavel_qualitativa=as.factor(nome_df$variavel_qualitativa)
# Constrói gráfico
plot(nome_df$variavel_y ~ nome_df$variavel_x,
     col=c(red,blue)[nome_df$variavel_qualitativa], # Escolha das cores para cada
     # categoria da variável qualitativa
     cex = 0.7, # Tamanho dos pontos
     xlim = c(min_x, max_x), # Limites que quiser no eixo x
     # (mínimo e máximo)
     ylim = c(min_y, max_y), # Limites que quiser no eixo y
     # (mínimo e máximo)
     xlab = título eixo x, # Descrição do eixo x
     ylab = título eixo y) # Descrição do eixo y
# Adiciona legenda
legend(bottomright , # Localização da legenda na janela gráfica
       pch = c(1,1), # Formato dos pontos (FIXO!!! NÃO MUDE!!!)
       col = c(red,blue), # Cores que foram escolhidas no gráfico
       legend = lev)"
#observações
#1. Para constuir o gráfico de dispersão segmentado pelas categorias de uma variável qualitativa pela opção apresentada anteriormente, você NÃO PODE utilizar a opção pch para alterar os formatos dos pontos, pois irá dar conflito com o uso da legenda.
#2. O R utilizará as cores escolhidas em col para atribuir às categorias da variável qualitativa em ordem alfabética (lembre-se de utilizar a mesma ordem das cores na legenda!!!).
#3. Utilize em xlim e ylim os valores mínimo e máximo que quiser observar no gráfico nos eixos x e y,respectivamente (não precisa ser necessariamente o mínimo e o máximo da base de dados). Esses argumentos são opcionais.
#4. As opções para localização da legenda na janela gráfica são “bottomright”, “bottom”, “bottomleft”, “left”, “topleft”, “top”, “topright”, “right” and “center"
# Adiciona pontos diferenciando as cores pelos níveis da variável qualitativa (em ordem
# alfabética)
# Transforma variável qualitativa em fator
Veiculos$categoria=as.factor(Veiculos$categoria)
# Constrói gráfico
plot(Veiculos$preco ~ Veiculos$comprimento,
     col=c("red","blue")[Veiculos$categoria], # Escolha das cores para cada
     # categoria da variável qualitativa
     cex = 0.7, # Tamanho dos pontos
     xlim = c(3, 5), # Limites que quiser no eixo x
     # (mínimo e máximo)
     ylim = c(5000, 40000), # Limites que quiser no eixo y
     # (mínimo e máximo)
     xlab = "Comprimento do veículo (em metros)", # Descrição do eixo x
     ylab = "Preço do veículo (em dólares)", # Descrição do eixo y
     cex.main = 1.15, cex.lab = 1.10)
# Adiciona legenda
legend("topleft" , # Localização da legenda na janela gráfica
       pch = c(1,1), # Formato dos pontos (FIXO!!! NÃO MUDE!!!)
       col = c("red", "blue"), # Cores que foram escolhidas no gráfico
       legend = levels(Veiculos$categoria), # Texto com os níveis da var quali
       cex = 0.7) 
#uma forma alternativa seria
# Adiciona pontos e reta da categoria 1
"plot(nome_df$variavel_y[nome_df$variavel_qualitativa==nome categoria 1]
     ~ nome_df$variavel_x[nome_df$variavel_qualitativa==nome categoria 1],
     cex = 0.7, # Tamanho dos pontos
     col = red, # Cor dos pontos da categoria 1
     pch = 16, # Formato dos pontos da categoria 1
     xlim = c(min_x, max_x), # Limites que quiser no eixo x
     # (mínimo e máximo)
     ylim = c(min_y, max_y), # Limites que quiser no eixo y
     # (mínimo e máximo)
     xlab = título eixo x, # Descrição do eixo x
     ylab = título eixo y # Descrição do eixo y)"
# Transforma variável qualitativa em fator
"nome_df$variavel_qualitativa=as.factor(nome_df$variavel_qualitativa)"
# Adiciona pontos da categoria 2
"points(nome_df$variavel_y[nome_df$variavel_qualitativa==nome categoria 2]
       ~ nome_df$variavel_x[nome_df$variavel_qualitativa==nome categoria 2],
       cex=0.7, # Tamanho dos pontos
       col = blue, # Cor dos pontos da categoria 2
       pch = 1) # Formato dos pontos da categoria 2"
# Adiciona legenda
"legend(topleft , # Localização da legenda na janela gráfica
       pch = c(16,1), # Formatos dos pontos de cada categoria
       col = c(red,blue), # Cores que foram escolhidas no gráfico
       legend = levels(nome_df$variavel_qualitativa), # Texto com os níveis da var quali
       cex = 0.7) # Tamanho dos pontos"
#observções
#1. Diferente da primeira opção apresentada para o gráfico de dispersão segmentado pelas categorias de uma variável qualitativa, nesta segunda opção você PODE utilizar a opção pch para alterar os formatos dos pontos (basta que utilize também os mesmos formatos na legenda).
#2. Não é necessário utilizar novamente xlim e ylim em points.
#3. As opções para localização da legenda na janela gráfica são as mesmas já apresentadas anteriores:“bottomright”, “bottom”, “bottomleft”, “left”, “topleft”, “top”, “topright”, “right” and “center” (digite help(legend) no Console para mais informações).
#4. Você pode utilizar points mais vezes para adicionar pontos de uma variável qualitativa que tenha 3 ou mais categorias e fazer os ajustes necessários nas cores, formatos dos pontos e legenda.
#adicionando as linhas de tendência
# Adiciona a linha de tendência para a categoria 1
"abline(lm(nome_df$variavel_y[nome_df$variavel_qualitativa==nome categoria 1]
          ~ nome_df$variavel_x[nome_df$variavel_qualitativa==nome categoria 1]),
       col = red, # Cor da linha da categoria 1
       lwd = 3, # Espessura da linha
       lty = 1) # Tipo da linha"
# Adiciona a linha de tendência para a categoria 2
"abline(lm(nome_df$variavel_y[nome_df$variavel_qualitativa==nome categoria 2]
          ~ nome_df$variavel_x[nome_df$variavel_qualitativa==nome categoria 2]),col = blue, # Cor da linha da categoria 2
       lwd = 3, # Espessura da linha
       lty = 1) "
#observações
#1. A espessura da linha (lwd) tem por padrão o valor 1, mas você pode aumentar este valor (faça o teste e verifique como fica no gráfico!).
#2. Os tipos de linha (lty) podem ser definidos como números (0=blank, 1=solid (default), 2=dashed, 3=dotted,=longdash, 6=twodash) ou como texto entre aspas (“blank”, “solid”, “dashed”, “dotted”,“dotdash”, “longdash”, or “twodash”). Para mais detalhes destas opções, digite help(par) no Console.
#3. Adicione mais abline se tiver 3 ou mais categorias da variável qualitativa e siga o mesmo raciocínio.
# Adiciona Pontos dos Carros Importados:
plot(Veiculos$preco[Veiculos$categoria == "Importado"]
     ~ Veiculos$comprimento[Veiculos$categoria == "Importado"],
     xlab = "Comprimento do veículo (em metros)",
     ylab = "Preço do veículo (em dólares)",
     pch = 19, # Formato: círculos
     col = "red", # Cor: vermelho
     xlim = range(Veiculos$comprimento), #Limites do eixo x
     ylim = range(Veiculos$preco), #Limites do eixo y
     cex.main = 1.15, cex.lab = 1.10)
# Adiciona Pontos dos Carros Importados:
plot(Veiculos$preco[Veiculos$categoria == "Importado"]
     ~ Veiculos$comprimento[Veiculos$categoria == "Importado"],
     xlab = "Comprimento do veículo (em metros)",
     ylab = "Preço do veículo (em dólares)",
     pch = 19, # Formato: círculos
     col = "red", # Cor: vermelho
     xlim = range(Veiculos$comprimento), # Limites do eixo x
     ylim = range(Veiculos$preco), # Limites do eixo y
     cex.main = 1.15, cex.lab = 1.10)
# Adiciona Pontos dos Carros Nacionais:
points(Veiculos$preco[Veiculos$categoria == "Nacional"]
       ~ Veiculos$comprimento[Veiculos$categoria == "Nacional"],
       pch = 17, # Formato: triângulos
       col = "blue") # Cor: azul
# Adiciona Legenda no Gráfico:
legend("topleft", # Posição no gráfico (topleft)
       c("Importado", "Nacional"),# Nome das categorias na legenda
       pch = c(19, 17), # Formato dos pontos
       col = c("red", "blue")) # Cor dos pontos
# Adiciona Pontos dos Carros Importados:
plot(Veiculos$preco[Veiculos$categoria == "Importado"]
     ~ Veiculos$comprimento[Veiculos$categoria == "Importado"],
     xlab = "Comprimento do veículo (em metros)",
     ylab = "Preço do veículo (em dólares)",
     pch = 19,
     col = "red",
     xlim = range(Veiculos$comprimento),
     ylim = range(Veiculos$preco),
     cex.main = 1.15, cex.lab = 1.10)
# Adiciona Pontos dos Carros Nacionais:
points(Veiculos$preco[Veiculos$categoria == "Nacional"]
       ~ Veiculos$comprimento[Veiculos$categoria == "Nacional"],
       pch = 17,
       col = "blue")
# Adiciona Linha de Tendência para os Carros Importados:
abline(lm(Veiculos$preco[Veiculos$categoria == "Importado"]
          ~ Veiculos$comprimento[Veiculos$categoria == "Importado"]),
       col = "red",
       lwd = 3, # Espessura da linha
       lty = 1) # Tipo da linha
# Adiciona Linha de Tendência para os Carros Nacionais
abline(lm(Veiculos$preco[Veiculos$categoria == "Nacional"]
          ~ Veiculos$comprimento[Veiculos$categoria == "Nacional"]),
       col = "blue",
       lwd = 3, # Espessura da linha
       lty = 1) # Tipo da linha
# Adiciona Legenda no Gráfico:
legend("topleft", # Posição no gráfico (topleft)
       c("Importado", "Nacional"), # Nome das categorias na legenda
       pch = c(19, 17), # Formato dos pontos
       col = c("red", "blue")) # Cor dos pontos

#4.5.2.2 Obtendo a Reta de um Ajuste Linear (y = ax+b) segmentando por uma Variável Qualitativa----
# Para os Veículos Nacionais:
Reta_N = lm(Veiculos$preco[Veiculos$categoria == "Nacional"]
            ~ Veiculos$comprimento[Veiculos$categoria == "Nacional"])
# Para os Veículos Importados:
Reta_I = lm(Veiculos$preco[Veiculos$categoria == "Importado"]
            ~ Veiculos$comprimento[Veiculos$categoria == "Importado"])
Reta_I
#Nacional: y = 8596 x − 25407
#Importado: y = 19442 x − 59453

#4.5.3 Medidas de Associação entre Duas Variáveis----
#uma outra forma de encontrar possiveis associações entre variaveis quantitativas é atravês de medidas de associção como a covariância e o coeficinete de correlação lienar

#4.5.3.1 Covatiância----
#para calcular a covariância de duas variaveis vamos usar a função cov(), ficando a seguinte maneira cov(nome_df$variavel_x,nome_dfvariavel_y)
#ela mede a associção linear(positiva, negativa ou ausência)
cov(Veiculos$comprimento,Veiculos$preco)
#podemos usar filtros dentro da correlação
cov_nac <- cov(Veiculos$comprimento[Veiculos$categoria == "Nacional"],
               Veiculos$preco[Veiculos$categoria == "Nacional"])
cov_imp <- cov(Veiculos$comprimento[Veiculos$categoria == "Importado"],
               Veiculos$preco[Veiculos$categoria == "Importado"])
#usamos a função cat para mostrar os resultados de maneira mais organizada
cat("Covariancia: \n",
    "Nacional: ", round(cov_nac, 2), "\n",
    "Importado: ", round(cov_imp, 2))

#4.5.3.2 Coefiente de Correção Linear----
#ela nos dá o grau de associação linear entre duas variavéis quantitaivas, ficando no intervalo [-1,1], -1 é relação inversamente proporcional perfeita e 1 é relação diretamente proporcional perfeita
#é dada pela função cor(), ficando da seguintre maneira cor(nome_df$variavel_x,nome_df$variavel_y) 
#ou cov(nome_df$variavel_x,nome_df$variavel_y)/sqrt(var(nome_df$variavel_x)sqrt(var(nome_df$variavel_y)))
# Pelo primeiro método
cor(Veiculos$comprimento, Veiculos$preco)
# Pelo segundo método
cov(Veiculos$comprimento, Veiculos$preco)/
  (sqrt(var(Veiculos$comprimento))*sqrt(var(Veiculos$preco)))
#filtros podem ser aplicados aqui também
cor_nac <- cor(Veiculos$comprimento[Veiculos$categoria == "Nacional"],
               Veiculos$preco[Veiculos$categoria == "Nacional"])
cor_nac
cor_imp <- cor(Veiculos$comprimento[Veiculos$categoria == "Importado"],
               Veiculos$preco[Veiculos$categoria == "Importado"])
cor_imp
cat("Correlção: \n",
    "Nacional: ", round(cor_nac, 3), "\n",
    "Importado: ", round(cor_imp, 3))

#4.5.3.3 Covariância e Correlação Linear com dados falatantes(NA)----
#caso queira os coeficintes de covariancia e correlação quando a dados "NA", deve se usar o argumento use="completo.obs" nas funções
#cov(nome_dataframe$nome_variavel1,nome_dataframe$nome_variavel2,use="complete.obs")
#cor(nome_dataframe$nome_variavel1,nome_dataframe$nome_variavel2,use="complete.obs")

#4.6 Aderência de dados a distribuições de proabilidades----
#há técnicas que permite avaliar se um conjunto de dados poder ter sido gerado a partir de determinada distribuição de probabilidades
#vamos verificar se um conjunto de dados pode ter sido geral a partir de uma distibuição normal

#4.6.1 Métodos Gráficos

#4.6.1.1 Opção 1:Histograma com curva da densidade da distribuição Normal----
#A lógica do gráfico é:
  #1. Construir um histograma com argumento probability=TRUE para forçar área igual a 1.
  #2. Calcular média e desvio padrão amostrais (x¯ e s) para serem estimativas de µ e σ da Normal.
  #3. Criar um vetor com possíveis valores de x (se basear nos valores mínimo e máximo da amostra).
  #4. Para cada valor de x, calcular o valor de f(x) através da função: dnorm(x, mean = ¯x, sd = s)
  #5. Adicione ao histograma, a curva (linha) dessa f(x).
#de modo geral
# Etapa 1 - Construção do histograma
"minimo = min(nome_df$nome_variavel) # Mínimo amostral
maximo = max(nome_df$nome_variavel) # Máximo amostral
nfaixas = 5 # Definindo o número de faixas do histograma (por exemplo, 5 faixas)
amplitude = (maximo-minimo)/nfaixas # Cálculo da amplitude de cada faixa
faixas = seq(minimo, maximo, amplitude) # Cria as faixas (início e fim de cada faixa)
hist(nome_df$nome_variavel, # Indica a variável para construção do histograma
     probability = TRUE, # Forçando o uso de densidade no histograma
     breaks = faixas,
     main = título principal do gráfico,# Descrição principal do gráfico
     xlab = título do eixo x, # Descrição do eixo x
     ylab = título do eixo y, # Descrição do eixo y
     xlim = c(min_x, max_x), # Limites que quiser no eixo x (mínimo e máximo)
     ylim = c(min_y, max_y)) # Limites que quiser no eixo y (Mínimo e máximo)"
"# Etapa 2 - Cálculo da média e desvio-padrão amostrais
media = mean(nome_dataframe$nome_variavel) # Média amostral
dp = sd(nome_dataframe$nome_variavel) # Desvio padrão amostral
# Etapa 3 - Criando um vetor com possíveis valores de x
x = seq(min_x, max_x, salto) # Defina saltos com intervalos bem pequenos"
"# Uma maneira - com dnorm() dentro da função curve
curve(dnorm(x, mean = media, sd = dp), # dnorm calcula o f(x) da distribuição Normal
      from = min_x, to = max_x, # Indique o intervalo de valores de x
      add = T, # Se T, adiciona em gráfico já existente
      col = red, # Cor para a linha de densidade no gráfico
      lwd = 2) # Espessura da linha
# Outra maneira - calcula a densidade e, então, solicita um gráfico de linha x versus f(x)
fx = dnorm(x, mean = media, sd = dp) # dnorm calcula o f(x) da distribuição Normal
lines(x, fx,
      col = blue, # Cor para a linha de densidade no gráfico
      lwd = 2) # Espessura da linha"
# Etapa 1 - Construção do histograma
minimo = min(dados$IDADE)
maximo = max(dados$IDADE)
nfaixas = 5 # Numero de faixas (por exemplo, 5 faixas)
amplitude = (maximo - minimo)/nfaixas
faixas = seq(minimo, maximo, amplitude)
hist(dados$IDADE,
     breaks = faixas,
     probability = TRUE,
     main = "Histograma dos dados e densidade da Normal",
     xlab = "Idade (em anos)",
     ylab = "Densidade",
     xlim = c(10,70),
     ylim = c(0,0.05),
     cex.main = 1.15, cex.lab = 1.10)
# Etapa 2 - Cálculo da média e desvio-padrão amostrais
media = mean(dados$IDADE) # Média amostral
dp = sd(dados$IDADE) # Desvio padrão amostral
# Etapa 3 - Criando um vetor com possíveis valores de x
x = seq(10, 70, 0.25) # Defina saltos com intervalos bem pequenos
# Etapas 4 e 5
# Uma maneira - com dnorm() dentro da função curve()
curve(dnorm(x, mean = media, sd = dp), # dnorm calcula o f(x) da distribuição Normal
      from = 10, to = 70, # Indique o intervalo de valores de x
      add = T, # Se T, adiciona em gráfico já existente
      col = "red", # Cor para a linha de densidade no gráfico
      lwd = 2) # Espessura da linha
# Etapa 1 - Construção do histograma
minimo = min(dados$IDADE)
maximo = max(dados$IDADE)
nfaixas = 5 # Numero de faixas (por exemplo, 5 faixas)
amplitude = (maximo - minimo)/nfaixas
faixas = seq(minimo, maximo, amplitude)
hist(dados$IDADE,
     breaks = faixas,
     probability = TRUE,
     main = "Histograma dos dados e densidade da Normal",
     xlab = "Idade (em anos)",
     ylab = "Densidade",
     xlim = c(10,70),
     ylim = c(0,0.05),
     cex.main = 1.15, cex.lab = 1.10)
# Etapa 2 - Cálculo da média e desvio-padrão amostrais
media = mean(dados$IDADE) # Média amostral
dp = sd(dados$IDADE) # Desvio padrão amostral
# Etapa 3 - Criando um vetor com possíveis valores de x
x = seq(10, 70, 0.25) # Defina saltos com intervalos bem pequenos
# Etapas 4 e 5
# Outra maneira - calcula densidade e, então, solicita gráfico de linha x versus f(x)
fx = dnorm(x, mean = media, sd = dp) # dnorm calcula o f(x) da distribuição Normal
lines(x, fx,
      col = "blue", # Cor para a linha de densidade no gráfico
      lwd = 2) # Espessura da linha

#4.6.1.2 Opção 2:Densidade dos dados e densidade da distribuição Normal----
#A lógica do gráfico é:
  #1. Construir um alisamento do histograma utilizando o comando geral: plot(density(nome_dataframe$nome_variavel))
  #2. Calcular média e desvio padrão amostrais (x¯ e s) para serem estimativas de µ e σ da Normal.
  #3. Criar um vetor com possíveis valores de x (se basear nos valores mínimo e máximo da amostra).
  #4. Para cada valor de x, calcular o valor de f(x): dnorm(x, mean = ¯x, sd = s)
  #5. Adicione ao gráfico anterior, a curva (linha) dessa f(x).
# Etapa 1 - Densidade dos dados
"plot(density(nome_df$nome_variavel),
     main = título do gráfico,
     xlab = título do eixo x,
     ylab = título do eixo y,
     xlim = c(min_x,max_x), # Limites que quiser no eixo x (conforme mínimo e máximo)
     ylim = c(min_y,max_y), # Limites que quiser no eixo y (conforme mínimo e máximo)
     col = green,
     lwd = 2)"
# Etapa 1 - Densidade dos dados
plot(density(dados$IDADE),
     main = "Densidade dos dados e da Normal",
     xlab = "Idade (em anos)",
     ylab = "Densidade",
     xlim = c(10,70),
     ylim = c(0,0.05),
     col = "green",
     lwd = 2,
     cex.main = 1.15, cex.lab = 1.10)
# Etapa 2 - Calcula média e desvio-padrão amostrais
media = mean(dados$IDADE) # Média amostral
dp = sd(dados$IDADE) # Desvio padrão amostral
# Etapa 3 - Criando um vetor com possíveis valores de x
x = seq(10, 70, 0.25) # Defina saltos com intervalos bem pequenos
# Etapas 4 e 5 - Calcula a densidade da dist. Normal e adicionando no gráfico
fx = dnorm(x, mean = media, sd = dp)# dnorm calcula o f(x) da distribuição Normal
lines(x, fx,
      col = "blue", # Cor para a linha de densidade no gráfico
      lwd = 2) # Espessura da linha
# Adiciona legenda
legend("topright",
       legend = c("Dados","Normal"),
       col = c("green","blue"),
       lwd = c(2,2))

#4.6.1.3 Opção 3: Gráfico de Probabilidade Normal----
#A lógica deste gráfico é:
  #1. Calcular média e desvio padrão amostrais (x¯ e s) para serem estimativas de µ e σ da Normal.
#2. Para cada observação i, calcular cada quantil teórico pela Normal assumindo cada probabilidade acumulada até (i-0.5)/n , i=1,2,...,n
#3. Por meio de um diagrama de dispersão, comparar quantil teórico com a amostra efetivamente observada. Se os dados de fato seguirem uma distribuição normal, os pontos devem estar próximos a uma reta.
# Obtém os quantis amostrais (eixo y) e os teóricos da Normal Padrão (eixo x)
"qqnorm(nome_dataframe$nome_variavel,
       col=blue,
       pch=16)
# Adiciona uma linha de referência caso a dist. Normal ser adequada
qqline(nome_dataframe$nome_variavel,
       col=red,
       lwd=2)"
# Obtém os quantis amostrais (eixo y) e os teóricos da Normal Padrão (eixo x)
qqnorm(dados$IDADE,
       col="blue",
       pch=16,
       cex.main = 1.15, cex.lab = 1.10)
# Adiciona uma linha de referência caso a dist. Normal ser adequada
qqline(dados$IDADE,
       col="red",
       lwd=2)

#4.6.2 Métodos Numéricos----
#é necessário fazer a instalação de uma biblioteca moments: install.packages("moments")
library(moments)

#4.6.2.1 Opção 1: Coeficientes de Assimetria e de Curtose----
#Normal é simétrica e, portanto, podemos calcular o coeficiente de assimetria (b1) para verificar, descritivamente, se uma variável quantitativa tem distribuição simétrica.
#de maneira geral skewness(nome_dataframe$nome_variavel)
#terceiro momento central(m3), somatório(i=1 até n) de ((xi - xm)^3)/n----
"se m3=0, distribuição simétrica
m3>0, distribuição assimétrica à direita, ou positiva
m3<0, distribuição assimétrica à esquerda, ou negativa"
#Para tiraramos o efeito da potência,tirar a unidade de medida e medirmos de maneira mais correta, temos que pegar esse m3 e dividir pelo (desvio padrão de x)^3, resultando no b1, coeficinte de assimteria 
"se b1=0, distribuição simétrica
b1>0, distribuição assimétrica à direita, ou positiva
b1<0, distribuição assimétrica à esquerda, ou negativa"
b1 = skewness(dados$IDADE)
b1
#COEFICIENTE DE CURTOSE:
#Na teoria, sabemos que a distribuição normal possui curtose (peso das caudas) de exatamente 3.
#g2=b2-3 , verifica o quão distante da curtose da distribuição normal está a curtose dos dadoss da amostra
"g2=0, caudas iguais a distribuição normal
g2>0, caudas mais pesadas que a distribuição normal
g2<0 caudas mais leves que a distribuição normal"
#g2=kurtosis(base$variavel)-3
#De maneira geral,kurtosis(nome_dataframe$nome_variavel)
b2 = kurtosis(dados$IDADE)
b2
#o excesso de curtose (em relação à distribuição Normal), ou seja,
g2 = b2 - 3
g2

#4.6.2.2 Opção 2: Estatística de JARQUE-BERA----
#Como é necessário que uma variável quantitativa tenha b1 ≈ 0 e g2 ≈ 0, podemos utilizar a estatística de Jarque-Bera que combina estas duas quantidades.
#podemos calculá-la da seguinte maneira geral: jarque.test(nome_dataframe$nome_variavel)
#JB=(n/6)*(b1^2+0,25*(b2-3)^2)
#jb<5,991 será um modelo próximo ao distribuição normal, regra de bolso 
jarque.test(dados$IDADE)

#5.Tópicos Adicionais sobre Gráficos----

#5.1 Como transferir um gráfico para outro documento (por exemplo, Word)

#5.1.1 Opção Export do painel Plots----
#Uma opção é utilizar Export no painel Plots, em que podemos Salvar como imagem, Salvar como pdf ou Copiar para a área de transferência (Copy to clipboard):
#Utilizando a terceira opção (Copy to clipboard), o gráfico será aberto em uma janela maior:e, então, clicamos em Copy Plot (é análogo a um Ctrl+C). Por fim, basta abrir o documento para o qual quer copiar o gráfico e Ctrl+V.(Caso opte por Salvar como imagem, será necessário escolher a opção de inserir uma imagem no Word, por exemplo.)

#5.1.2 Opção Shift+Windows+s----

#5.1.3 Opção Print Screen----

#5.2 Alternativa Avançada para Gráficos via biblioteca ggplot2----
#Muitas vezes as ferramentas disponibilizadas pelas funções mais simples do sistema para a apresentação gráfica não nos agradará muito. Nesse caso, existem alternativas criadas por usuários, como a biblioteca ggplot2.
#A introdução deste pacote pode ser desafiadora para novos usuários, mas é uma alternativa muito mais flexível com relação à idealização de novos tipos de gráficos.
#Para saber mais sobre a biblioteca, suas funções e argumentos, utilize a documentação da biblioteca ou algum material disponilizado por outros usuários na internet.

#6.Biblioteca GGPLOT2----
#para usar essa biblioteca gráfica, é necessário instalar ela install.packages("ggplot2")
library(ggplot2) #importando a biblioteca
"https://raw.githubusercontent.com/curso-r/livro-material/master/assets/data/imdb.rds" #link da base de dados a ser usada para a  construção dos gráficos da biblioteca ggplot2
imdb <- readRDS("C:/Users/Hic_T/Programas R/imdb.rds")
#Gráficos da biblioteca ggplot2 funcionam atravês da consrução de camadas

# 6.1 Gráfico de Pontos(Dispersão)----
ggplot(data = imdb) #isso nos dara a primeira camada, que será um painel em branco
library(dplyr,warn.conflicts = FALSE)
#É preciso especificar como as as observações serão mapeadas nos aspectos visuais do gráfico e quais as formas geometricas que serão utilizadas 
#Vamos construir um gráfico de dispersão, com as variáveis orçamento e receita
ggplot(imdb)+geom_point(mapping = aes(x=orcamento, y=receita))
#a primeira camada é dada pela função ggplot() e recebe a nossa base imbd
#a segunda camada é dada pela função geom_point() , especificando a forma geométrica utilizada no mapeamento das observações (pontos); as camadas são unidas com um +
#o mapeamento na função geom_point() recebe a função aes() , responsável por descrever como as variáveis serão mapeadas nos aspectos visuais dos pontos (a forma geométrica escolhida);
#neste caso, os aspectos visuais mapeados são a posição do ponto no eixo x e a posição do ponto no eixo y
#o Warning nos avisa sobre a exclusão das observações que possuem NA na variável receita e/ou orcamento ;
#todas essas funções são do pacote {ggplot2}
# combinação da função ggplot() e de uma ou mais funções geom_() definirá o tipo de gráfico gerado.

#primeiro argumento de qualquer função geom é o mapping . Esse argumento serve para mapear os dados nos atributos estéticos da forma geométrica escolhida
#ele sempre receberá a função aes() , cujos argumentos vão sempre depender da forma geométrica que estamos utilizando
#No caso de um gráfico de dispersão, precisamos definir a posição dos pontos nos eixos x e y

#Podemos acrescentar uma terceira camada ao gráfico, desenhando a reta y =x para visualizarmos os filmes que não se pagaram.
ggplot(imdb) +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  geom_abline(intercept = 0, slope = 1, color = "red")
#pontos abaixo da reta representam os filmes com orçamento maior que a receita, isto é, aqueles que deram prejuízo
#A reta x = y foi acrescentada ao gráfico pela função geom_abline()
#Esse geom pode ser utilizado para desenhar qualquer reta do tipo y =a +b*x ,sendo a o intercepto (intercept) da reta e b o seu coeficiente angular (slope)
#Neste caso, como não estamos mapeando colunas da base a essa reta (isto é, essa reta não depende dos dados), não precisamos utilizar o argumento mapping da função geom_abline() , tampouco a função aes().

#Para ver como um ggplot realmente é construído por camadas, veja o que acontece quando colocamos a camada da reta antes da camada dos pontos

ggplot(imdb) +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  geom_point(mapping = aes(x = orcamento, y = receita)) 
library(dplyr, warn.conflicts = FALSE)
imdb %>%
  mutate(lucro = receita - orcamento) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucro))
#a cor dos pontos definida pelo valor da variável lucro.Como a coluna lucro é numérica, um degradê é criado para a cor dos pontos. O azul é a cor padrão nesses casos (veremos mais adiante com escolher a cor)
# criamos a coluna lucro utilizando a função mutate() antes de iniciarmos a construção do gráfico. O fluxo base %>% manipulação %>% ggplot é muito comum no dia-a-dia.

#Poderíamos também classificar os filmes entre aqueles que lucraram ou não. Neste caso, como a coluna lucrou é textual, uma cor é atribuída a cada categoria

imdb %>%
  mutate(
    lucro = receita - orcamento,
    lucro = ifelse(lucro <= 0, "Não", "Sim")
  ) %>%
  filter(!is.na(lucro)) %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita, color = lucro))

#erro comum na hora de definir atributos estéticos de um gráfico é definir valores para atributos estéticos dentro da função aes() . Repare o que acontece quando tentamos definir diretamente a cor dos pontos dentro dessa função.
ggplot(imdb) +
  geom_point(aes(x = orcamento, y = receita, color = "blue"))

#O que aconteceu foi o seguinte: a função aes() espera uma coluna para ser mapeada a cada atributo, então o valor blue é tratado como uma nova variável/coluna que tem essa string para todas as observações. Assim, todos pontos têm a mesma cor (vermelha, padrão do ggplot) pois pertencem todos à essa “categoria blue”.

#No caso, o que gostaríamos é de ter pintado todos os pontos de azul. A forma certa de fazer isso é colocando o atributo color= fora da função aes() :
ggplot(imdb) +
  geom_point(aes(x = orcamento, y = receita), color = "blue")

#6.2 Gráfico de Linhas----
#Utilizamos o geom_line para fazer gráficos de linhas. Assim como nos gráficos de pontos, precisamos definir as posições x e y
#O gráfico abaixo representa a evolução da nota média dos filmes ao longo dos anos.
imdb %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))
#utilizamos gráficos de linha para representar séries temporais séries temporais, isto é, observações medidas repetidamente em intervalos equidistantes de tempo
#Podemos colocar pontos e retas no mesmo gráfico. Basta acrescentar os dois geoms
#gráfico abaixo mostra a nota média anual dos filmes do dirigidos por Steven Spielber
imdb %>%
  filter(direcao == "Steven Spielberg") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  geom_point(aes(x = ano, y = nota_media))
#Quando precisamos usar o mesmo aes() em vários geoms , podemos defini-lo dentro da função ggplot() . Esse aes() será então distribuído para todo geom do gráfico.
#O código anterior pode ser reescrito da seguinte forma:
imdb %>%
  filter(direcao == "Steven Spielberg") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_point()
#Se algum geom necessitar de um atributo que os outros não precisam, esse atributo pode ser especificado normalmente dentro dele. Abaixo, utilizamos o geom_label para colocar as notas médias no gráfico
imdb %>%
  filter(direcao == "Steven Spielberg") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  mutate(nota_media = round(nota_media, 1)) %>%
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_label(aes(label = nota_media))

#6.3 Gráfico de Barras----
#Para construir gráficos de barras, utilizamos o geom_col
#construíremos um gráfico de barras do número de filmes das 10 pessoas que dirigiram mais filmes na nossa base do IMDB
imdb %>%
  count(direcao) %>%
  slice_max(order_by = n, n = 10) %>%
  ggplot() +
  geom_col(aes(x = direcao, y = n))

#Gráficos de barras também precisam dos atributos x e y, sendo que o atributo y representará a altura de cada barra.
#No gráfico anterior, vemos que o NA é considerado uma “categoria” de direção e entra no gráfico. Podemos retirar os NAs dessa coluna previamente utilizando a função filter().
#A seguir, além de retirar os NAs, atribuímos a coluna direcao à cor das colunas. Repare que, nesse caso, não utilizamos o atributo color e sim fill. A regra é a seguinte: o atributo color colore objetos sem área (pontos, linhas, contornos), o atributo fill preenche objetos com cor (barras, áreas, polígonos em geral).
imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  slice_max(order_by = n, n = 10) %>% 
  ggplot() +
  geom_col(
    aes(x = direcao, y = n, fill = direcao),
    show.legend = FALSE)

#Para consertar as labels do eixo x, a melhor prática é invertermos os eixos do gráfico, construindo barras horizontais.

imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  slice_max(order_by = n, n = 10) %>% 
  ggplot() +
  geom_col(
    aes(y = direcao, x = n, fill = direcao),
    show.legend = FALSE)

#Para ordenar as colunas, precisamos mudar a ordem dos níveis do fator direcao. Para isso, utilizamos a função fct_reorder() do pacote forcats. A nova ordem será estabelecida pela coluna n (quantidade de filmes).
#Fatores dentro do R são números inteiros (1, 2, 3, …) que possuem uma representação textual (Ver Seção 7.6). Variáveis categóricas são transformadas em fatores pelo ggplot pois todo eixo cartesiano é numérico. Assim, os textos de uma variável categórica são, internamente, números inteiros.
#Por padrão, os inteiros são atribuídos a cada categoria de uma variável pela ordem alfabética (repare na ordem das pessoas que aparecem na direcao nos gráficos anteriores)

imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  slice_max(order_by = n, n = 10) %>% 
  mutate(direcao = forcats::fct_reorder(direcao, n)) %>% 
  ggplot() +
  geom_col(
    aes(y = direcao, x = n, fill = direcao),
    show.legend = FALSE) 
#Por fim, podemos colocar uma label com o número de filmes de cada diretor(a) dentro de cada barra.

imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  slice_max(order_by = n, n = 10) %>% 
  mutate(direcao = forcats::fct_reorder(direcao, n)) %>% 
  ggplot() +
  geom_col(aes(x = direcao, y = n, fill = direcao), show.legend = FALSE) +
  geom_label(aes(x = direcao, y = n/2, label = n)) +
  coord_flip()

#6.4 Histograma e Boxplot----
#Para construir histogramas, usamos o geom_histogram. Esse geom só precisa do atributo x (o eixo y é construído automaticamente). Histogramas são úteis para avaliarmos a distribuição de uma variável.

imdb %>% 
  filter(direcao == "Steven Spielberg") %>%
  mutate(lucro = receita - orcamento) %>% 
  ggplot() +
  geom_histogram(aes(x = lucro))

#Para definir o tamanho de cada intervalo, podemos utilizar o argumento bindwidth.

imdb %>% 
  filter(direcao == "Steven Spielberg") %>%
  mutate(lucro = receita - orcamento) %>% 
  ggplot() +
  geom_histogram(
    aes(x = lucro), 
    binwidth = 100000000,
    color = "white")

#Boxplots também são úteis para estudarmos a distribuição de uma variável, principalmente quando queremos comparar várias distribuições.
#Para construir um boxplot no ggplot, utilizamos a função geom_boxplot. Ele precisa dos atributos x e y, sendo que ao atributo x devemos mapear uma variável categórica.

imdb %>% 
  filter(!is.na(direcao)) %>%
  group_by(direcao) %>% 
  filter(n() >= 30) %>% 
  mutate(lucro = receita - orcamento) %>% 
  ggplot() +
  geom_boxplot(aes(x = direcao, y = lucro))

#Também podemos reordenar a ordem dos boxplots utilizando a função forcats::fct_reorder. Neste caso, a direcao é ordenada pela mediana do lucro13.

imdb %>% 
  filter(!is.na(direcao)) %>%
  group_by(direcao) %>% 
  filter(n() >= 30) %>% 
  ungroup() %>% 
  mutate(
    lucro = receita - orcamento,
    direcao = forcats::fct_reorder(direcao, lucro, na.rm = TRUE)
  ) %>% 
  ggplot() +
  geom_boxplot(aes(x = direcao, y = lucro))

#6.5 Título e Labels----
#Os títulos e labels do gráfico também são considerados camadas e são criados ou modificados pela função labs(). O exemplo a seguir coloca um título e um subtítulo no gráfico, além de modificar os labels do eixo x e y e da legenda.

imdb %>%
  mutate(lucro = receita - orcamento) %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita, color = lucro)) +
  labs(
    x = "Orçamento ($)",
    y = "Receita ($)",
    color = "Lucro ($)",
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento")

#6.6 Escalas----
#O pacote {ggplot2} possui uma família de funções scale_ para modificarmos propriedades referentes às escalas do gráfico. Como podemos ter escalas de números, categorias, cores, datas, entre outras, temos uma função específica para cada tipo de escala.

imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

#Vamos redefinir as quebras dos eixos x e y.

imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1916, 2016, 10)) +
  scale_y_continuous(breaks = seq(0, 10, 2))

#Como as escalas dos eixos x e y são numéricas, utilizamos nesse caso as funções scale_x_continuous() e scale_y_continuous(). Veja que, mesmo definindo as quebras entre 0 e 10, o limite do eixo y não é alterado. Para alterá-lo, usamos a função coord_cartesian().

imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1916, 2016, 10)) +
  scale_y_continuous(breaks = seq(0, 10, 2)) +
  coord_cartesian(ylim = c(0, 10))

#Para mudarmos as escalas de cores, usamos as funções do tipo: scale_color_ e scale_fill_.
#Para escolher manualmente as cores de um gráfico, utilize as funções scale_color_manual() e scale_fill_manual(). A seguir substituímos as cores padrão do gráfico por um outro conjunto de cores.

imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  slice_max(order_by = n, n = 6) %>% 
  ggplot() +
  geom_col(
    aes(x = direcao, y = n, fill = direcao),
    show.legend = FALSE
  ) +
  coord_flip() +
  scale_fill_manual(values = c("red", "blue", "green", "pink", "purple", "black" ))

#Também podemos usar códigos hexadecimais.

imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  slice_max(order_by = n, n = 6) %>% 
  ggplot() +
  geom_col(
    aes(x = direcao, y = n, fill = direcao),
    show.legend = FALSE
  ) +
  coord_flip() +
  scale_fill_manual(
    values = c("#ff4500", "#268b07", "#ff7400", "#0befff", "#a4bdba", "#b1f91a"))

#Para trocar as cores de um gradiente, utilize as funções scale_color_gradient() e scale_fill_gradient().

imdb %>% 
  mutate(lucro = receita - orcamento) %>% 
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucro)) +
  scale_color_gradient(low = "red", high = "green")

#Para trocar o nome das categorias de uma legenda de cores, utilize as funções scale_color_discrete() e scale_fill_discrete().

imdb %>% 
  mutate(nota_maior_que_8 = ifelse(nota_imdb > 8, "Nota maior que 8", "Nota menor que 8")) %>% 
  group_by(ano, nota_maior_que_8) %>% 
  summarise(num_filmes = n()) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes, color = nota_maior_que_8)) +
  scale_color_discrete(labels = c("Sim", "Não"))

#6.7 Temas----
#Os gráficos que vimos até agora usam o tema padrão do ggplot2. Existem outros temas prontos para utilizarmos presentes na família de funções theme_.

"theme_minimal()"
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  theme_minimal()

"theme_bw()"
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  theme_bw()

"theme_classic()"
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  theme_classic()

"theme_classic()"
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  theme_classic()

#Você também pode criar o seu próprio tema utilizando a função theme(). Nesse caso, para trocar os elementos estéticos do gráfico precisamos usar as funções element_text() para textos, element_line() para linhas, element_rect() para áreas e element_blank() para remover elementos.

"No exemplo a seguir, fizemos as seguintes modificações no tema padrão:
  
Alinhamos o título no centro do gráfico.
Alinhamos o subtítulo no centro do gráfico.
Pintamos o título dos eixos de roxo.
Preenchemos o fundo do gráfico de preto.
Removemos o grid do gráfico."

imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita), color = "white") +
  labs(title = "Gráfico de dispersão", subtitle = "Receita vs Orçamento") +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    axis.title = element_text(color = "purple"),
    panel.background = element_rect(fill = "black"),
    panel.grid = element_blank())

#6.8 Juntando Gráficos----
#No ggplot2, temos várias formas de juntar gráficos. Vamos apresentar a seguir as principais.

#Vários geoms no mesmo gráfico
#Como vimos anteriormente, podemos acrescentar vários geoms em um mesmo gráfico, apenas adicionando novas camadas. No código a seguir, construímos o gráfico de dispersão da receita pelo orçamento dos filmes, acrescentando também uma reta de tendência linear aos pontos.

ggplot(imdb, aes(x = orcamento, y = receita)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm")

#Replicando um gráfico para cada categoria de uma variável
#Uma funcionalidade muito útil do ggplot2 é a possibilidade de usar facets para replicar um gráfico para cada categoria de uma variável.

imdb %>%
  filter(producao %in% c("Walt Disney Animation Studios", "Walt Disney Pictures")) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = nota_imdb)) +
  facet_wrap(~producao, nrow = 2)

#Podemos especificar se queremos os gráficos lado a lado ou um embaixo do outro pelos argumentos nrow= e ncol=.

imdb %>%
  filter(producao %in% c("Walt Disney Animation Studios", "Walt Disney Pictures")) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = nota_imdb)) +
  facet_wrap(~producao, ncol = 2)

#Juntando gráficos diferentes
#Diversos outros pacotes trazem ferramentas super úteis para trabalharmos com o ggplot2. Um deles é o pacote {patchwork}. Após carregá-lo, podemos juntar dois gráficos em uma mesma figura com um simples +.
# Instale antes de carregar
# install.packages("patchwork")
library(patchwork)

p1 <- imdb %>% 
  filter(direcao == "Steven Spielberg") %>%
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))
p2 <- imdb %>% 
  mutate(lucro = receita - orcamento) %>% 
  filter(direcao == "Steven Spielberg") %>% 
  ggplot() +
  geom_histogram(
    aes(x = lucro),
    fill = "lightblue", 
    color = "darkblue", 
    binwidth = 100000000)
p1 + p2

#6.9 Extensões GGPLOT2----
#6.9.1gghighlight----
#O gghighlight é uma extensões do {ggplot2} que serve para realçar partes de um gráfico feito com ggplot.
#A seguir, mostramos como utilizar essa extensão para realçar gráficos de pontos e linhas.
#Realçando pontos
#Muitas vezes temos um gráfico de dispersão em que queremos realçar alguns pontos de acordo com alguma característica. Por exemplo, abaixo estamos realçando os pontos que possuem carat > 4, além disso colocamos uma label em cada um.
# Instale antes de carregar
# install.packages("gghighlight")
diamonds %>% 
  ggplot(aes(x = carat, y = price)) +
  geom_point() +
  gghighlight::gghighlight(carat > 4, label_key = carat)

#Também é possível configurar a cor dos pontos que serão realçados e dos que não serão, bem como o estilo das labels.

diamonds %>% 
  ggplot(aes(x = carat, y = price)) +
  geom_point(color = "red") +
  gghighlight::gghighlight(
    carat > 4, 
    label_key = carat,
    unhighlighted_params = list(colour = "black"),
    label_params = list(size = 10, fill = "grey"))

#Realçando linhas
#Com o {gghighlight} também é possível realçar linhas em um gráfico que possui varias linhas. Isso é interessante quando você quer ver como uma série temporal se compara com relação à um conjunto de outras séries.
#No gráfico a seguir mostramos o número de downloads de cada um dos pacotes do tidyverse no ano de 2019. Uma das séries se destaca por mudar de padrão no meio do ano. Usamos o {gghighlight} para destacá-la no gráfico.
# install.packages("cranlogs")

tab <- cranlogs::cran_downloads(
  packages = tidyverse::tidyverse_deps()$package,
  from = "2019-01-01", to = "2019-12-31")
tab %>% 
  ggplot(aes(x = date, y = count, group = package)) +
  geom_line() +
  gghighlight::gghighlight(max(count) > 100000, label_key = package)

#6.9.2 ggridges
#A extensão {ggridges} é uma ótima alternativa para histogramas e boxplots, quando queremos comparar a distribuição de uma variável A em vários níveis de uma variável B.
#Primeiro, instale o pacote.
#install.packages("ggridges")
#No gráfico abaixo, comparamos a distribuição da receita dos filmes em cada um dos anos de 2005 a 2016. Para isso, utilizamos o novo geom_density_ridges(), disponibilizado pelo pacote {ggridges}.

library(ggridges)
imdb %>%
  filter(ano > 2005) %>% 
  mutate(ano = as.factor(ano)) %>% 
  ggplot(aes(y = ano, x = receita, fill = ano)) +
  geom_density_ridges(na.rm = TRUE, show.legend = FALSE)



#Modulo de Probabilidade----
#Distribuição Binomial no Rstudio----
"Determinado produto é vendido em caixas com 1000 peças. É
uma característica da fabricação produzir 10% defeituosos.
Normalmente, cada caixa é vendida por 12,00 unidades
monetárias (u.m.).
Um comprador faz a seguinte proposta: de cada caixa, ele
escolhe uma amostra de 20 peças (com reposição); se tiver 0
defeituoso, ele paga 18,00 u.m.; 1 ou 2 defeituosos, ele paga
12,00 u.m.; 3 ou mais defeituosos ele paga 6,00 u.m.. Qual
alternativa é a mais vantajosa para o fabricante?
Admita independência entre as peças."
#P(Y=y)=dbinom(y,n,p) ; sendo y: evento de interesse a ser analise , sendo n: numéro de tentativas ,sendo p: a probylidade do sucesso(interesse)
w=dbinom(0,20,0.1)
w
#P(Y<=y)=P(Y=0)+P(Y=1)+...+(PY=y)->pbinom(y,n,p,lower.tail=TRUE); sendo y: evento de interesse a ser analise , sendo n: numéro de tentativas ,sendo p: a probylidade do sucesso(interesse); lower.tail=TRUE é para falar que é a parte menor ou igual
w=pbinom(2,20,0.1,lower.tail = TRUE)-dbinom(0,20,0.1)
w
#P(Y>y)=P(Y=y+1)+P(Y=y+2)+...+(PY=n)->pbinom(y,n,p,lower.tail=FALSE); sendo y: evento de interesse a ser analise , sendo n: numéro de tentativas ,sendo p: a probylidade do sucesso(interesse); lower.tail=False é para falar que é a parte maior
w=pbinom(2,20,0.1,lower.tail = FALSE) # tem que ser um y tem que ser -1 devido ao fato dele pegar maior que o número
w
"A mortalidade de microempresas no 1º ano de
funcionamento é da ordem de 55%. Deseja-se avaliar
as causas da mortalidade. Numa amostra de 10
empresas"
"a. qual á a probabilidade de exatamente 5 terem falido
ao final do 1º ano?"
a=dbinom(5,10,0.55)
a
"b. qual é a probabilidade de pelo menos 3 virem a falir
no 1º ano?"
b= pbinom(2,10,0.55,lower.tail = FALSE)
b
"c. sabe-se que pelo menos 3 faliram no 1º ano, qual é
a probabilidade de no máximo 5 terem falido?"
c=(pbinom(5,10,0.55,lower.tail = TRUE)-pbinom(2,10,0.55,lower.tail = TRUE))/ pbinom(2,10,0.55,lower.tail = FALSE)
c
"d. qual o número esperado de empresas que irão à
falência no 1º ano na amostra? E o desvio padrão?"

#Distribuição hipergemétrica no Rstudio----
"A distribuição hipergeométrica é parecida com a binomial só que
as replicações não são independentes."
"r : número de sucessos numa população de tamanho N."
"𝑁 − r ∶ número de fracassos nesta população."
"n ∶ tamanho da amostra sem reposição."
"y: número de sucessos na amostra."
"n − y: número de fracassos na amostra"
"max{0,n+r-N}<=y<=min{r,n}"
#P(Y=Y)=dhyper(y,r,N-r,n)
#P(Y<=y)=phyper(y,r,N-r,n) ou phyper(y,r,N-r,n,lower.tail=TRUE)
#P(Y>y)=phyper(y,r,N-r,n,lower.tail=FALSE)
#Proporção de sucessos na população p=r/N
#Então E(Y)=n(r/N)=np
#Então Var(Y)=np(1-p)((N-n)/(N-1))

#Distribuição poisson no Rstudio----
"𝝀 é o número médio de eventos ocorrendo no
intervalo considerado."
#dpois(x,𝜆)
#ppois(x,𝝀,lower.tail=TRUE) ou ppois(x,𝝀)
#ppois(x,𝝀,lower.tail=FALSE)

#Distribuição geometrica no Rstudio----
"Quando 𝑿 = 𝒙, indica que o evento A ocorre na 𝒙-ésima
repetição e nas primeiras 𝒙 − 𝟏 repetições"
#dgeom(x−1, p)
#pgeom(x−1, p,lower.tail=TRUE) ou pgeom(x−1, p)
#pgeom(x−1, p,lower.tail=FALSE)

#Distribuição Uniforme----
"distribuição uniforme definida no intervalo [a;b],dada por: 1/(b-a)"
#𝑿 ~ Uniforme(a;b)
#P(X<=x)=punif(x,min=a,max=b)=punif(x,min=a,max=b,lower.tail=TRUE)
#P(X>x)=punif(x,min=a,max=b,lower.tail=FALSE)

#Percentil na Distribuição Uniforme----
"encontrar o valor de 𝑥 tal queaté esse valor tenha probabilidade acumulada igual a p=P(X<=x)"
#x=qunif(p,in=a,max=b,lower.tail=TRUE)

#Distribuição Exponencial
#X~Exp(𝜷)
#P(X<=x)=pexp(x,1/𝜷)=pexp(x,1/𝜷,lower.tail=TRUE)
#P(X>x)=pexp(x,1/𝜷,lower.tail=FALSE)

#Percentil na Distribuição Exponencial----
"encontrar o valor de 𝑥 tal que até esse valor tenha probabilidade acumulada igual a p=P(X<=x)"
#x=qexp(p,1/𝜷,lower.tail=TRUE)

#Distribuição da Norma Padrão----
"X~N(𝜇;𝜎^2), distribuição normal
Z=(X-𝜇)/𝜎
Z~N(0,1)"
#P(Z<=z)=pnorm(z)=pnorm(z,lower.tail=TRUE)
#P(Z>z)=pnorm(z,lower.tail=FALSE)

#Percentil na Distribuição Normal----
"encontrar o valor de 𝑥 tal que até esse valor tenha probabilidade acumulada igual a p=P(Z<=z)"
#z=qnorm(p)=qnorm(p,lower.tail=TRUE)

#Distribuição da Qui-Quadrado----
#p=P(Y<=c)=pchisq(c,k), onde k é o grau de liberdade
#p=P(Y>c)=1-pchisq(c,k)=pchisq(c,k,lower.tail=FALSE)
#c=P(Y<=c)=qchisq(p,k)
#c=P(Y>c)=qchisq(1-p,k)=qchisq(p,k,lower.tail=FALSE)

#Distribuição T-Student----
#P(T<t)=pt(t,v), onde v é o grau de liberdade
#P(T>t)=pt(t,v, lower.tail=FALSE)
# Se p=P(T<t), então t=qt(p,v)
# Se p=P(T>t), então t=qt(p,v,lower.tail=FALSE)

#Teste de Hipóetese no RStudio para a distribuição T e T-pareado
"Caso o teste seja bilateral"
t.test(BaseDeDados$Variável,mu=Ho,alternative=c("tow.sided"),conf.level="alfa") #o default dele é o biliateral
"Caso o teste seja unilateral a esquarda"
t.test(BaseDeDados$Variável,mu=Ho,alternative=c("less"),conf.level="alfa")
"Caso o teste seja unilateral a direita"
t.test(BaseDeDados$Variável,mu=Ho,alternative=c("greater"),conf.level="alfa") 
t.test(BaseDeDados$Variável,mu=Ho,alternative=c("lateralidade"),conf.level="alfa",paired=TRUE)
