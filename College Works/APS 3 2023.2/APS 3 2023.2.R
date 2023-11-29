#APS 3 2023.2 Estatística 2
"Estudo sobre pesquisas de preços dos produtos orgânicos, dado diferentes textos motivadores de resposta, agora utilizando tecnicas para Análise Inferencial dos Dados"

#Grupo----
"
Beatriz Emi Ueda                 (beatrizeu@al.insper.edu.br)					
Beatriz Fernandes da Silva       (beatrizfs1@al.insper.edu.br)					
Gabriela Abib                    (gabrielaa6@al.insper.edu.br)					
Hicham Munir Tayfour             (hichamt@al.insper.edu.br)					
Raynnara Silva de Freitas Gurgel (raynnarasf@al.insper.edu.br)
"
#Bibliotecas Usadas----
library(readxl)
library(DescTools)
library(moments)
library(DT)


#Importação dos dados----
aps <- read_excel("APS2023_2_FASE_3.xlsx")

#Análise Inferêncial dos Dados----

#1) Verifique por meio de técnicas inferenciais adequadas se existe efeito dos textos na disposição pagar por produtos orgânicos----
"Seperando os dados pelos tipos de texto"
texto1 <- aps[aps$Texto == 1,]
texto2 <- aps[aps$Texto == 2,]

media=c(round(mean(aps$P1),2),round(mean(texto1$P1),2),round(mean(texto2$P1),2))
mediana=c(median(aps$P1),median(texto1$P1),median(texto2$P1))
minimo=c(min(aps$P1),min(texto1$P1),min(texto2$P1))
maximo=c(max(aps$P1),max(texto1$P1),max(texto2$P1))
moda=c(Mode(aps$P1),Mode(texto1$P1),Mode(texto2$P1))
variancia=c(round(var(aps$P1),2),round(var(texto1$P1),2),round(var(texto2$P1),2))
desvio=c(round(sd(aps$P1),2),round(sd(texto1$P1),2),round(sd(texto2$P1),2))
coef_var=round(100*desvio/media,2)

"Construindo a tabela"
TabPreco_T <- cbind(media,mediana,minimo,maximo,moda,variancia,desvio,coef_var)
rownames(TabPreco_T) <- c("Geral","Texto 1","Texto 2")
colnames(TabPreco_T) <- c("Média","Mediana","Mínimo","Máximo",
                          "Moda","Variância","Desvio Padrão","Coeficiente de Variação (%)")

View(TabPreco_T)
datatable(TabPreco_T)

"Histograma e Histograma Alisado dos dados dos textos"
par(mfrow=c(1,2))
hist(texto1$P1,main="Histograma dos prços do texto 1",
     xlab="Preço",ylab="Densidade",col="lightblue",probability =  TRUE,ylim = c(0,0.07))
lines(density(texto1$P1),col="lightblue4")
hist(texto2$P1,main="Histograma dos preços do texto 2",
     xlab="Preço",ylab="Densidade",col="lightblue",probability  = TRUE,ylim = c(0,0.07))
lines(density(texto2$P1),col="lightblue4",lwd=2)
par(mfrow=c(1,1))

"Boxplot dos dados dos textos"
boxplot(texto1$P1,texto2$P1,main="Boxplot dos Preços em cada Texto",
        names=c("Texto 1","Texto 2"),col=c("lightblue","lightblue4"),ylab="Preço",xlab="Texto")

"Teste de Normalidade"
jb_t1=jarque.test(texto1$P1)
jb_t2=jarque.test(texto2$P1)
jb_t1[1]
jb_t2[1]

"Adotando o nível de significância de 5%, temos que o valor crítico é 5,99. Como o valor de jb_t1[1] e jb_t2[1] são maiores que o valor crítico, então não podemos afirmar que os dados são normalmente distribuidos."

#Caso os dados fossem distribuidos normalmente, poderiamos utilizar o teste de variância e o teste de média para verificar se existe efeito dos textos na disposição pagar por produtos orgânicos. Faremos isso apenas por não sabermos o que fazer quando as variáveis não seguem uma distribuição normal. Mas como elas não seguem uma distribuição normal, os testes abaixos são teoricamente inválidos.

"Teste de Variância"
var.test(texto1$P1,texto2$P1,conf.level = 0.95,alternative = "two.sided")

"Adotando o nível de significância de 5%, temos que o valor p é 0.4656 ou 46,56%. Como o valor p é maior que o nível de significância, então não podemos concluir que as variâncias são iguais."

"Teste de Média"
t.test(texto1$P1,texto2$P1,conf.level = 0.95,alternative = "two.sided",var.equal = TRUE)

"Adotando o nível de significância de 5%, temos que o valor p é 0.01996 ou 1,996%. Como o valor p é menor que o nível de significância, então podemos concluir que as médias são diferentes."


#Conclusão
"Como as médias são diferentes, então podemos concluir que existe efeito dos textos na disposição pagar por produtos orgânicos."

#2)Verifique utilizando um teste qui-quadrado de homogeneidade (pesquise – esse conteúdo não foi e não será dado em sala) se há relação entre o texto lido pelo entrevistado e a resposta à pergunta 2 (P2).----

"Leituras sobre o teste qui-quadrado de homogeneidade
https://www.ime.usp.br/~sandoval/mae5755/TesteQui-quadrado.pdf 
https://rpubs.com/jarrais/GET00130_Topico21
"

"Separando os dados por texto e por resposta"
texto1_p2_1 <- texto1[texto1$P2 == 1,]
texto1_p2_2 <- texto1[texto1$P2 == 2,]
texto1_p2_3 <- texto1[texto1$P2 == 3,]

texto2_p2_1 <- texto2[texto2$P2 == 1,]
texto2_p2_2 <- texto2[texto2$P2 == 2,]
texto2_p2_3 <- texto2[texto2$P2 == 3,]

"Gráfico de setores e de barras das respostas separado por texto"
par(mfrow=c(1,2))
pie(c(nrow(texto1_p2_1),nrow(texto1_p2_2),nrow(texto1_p2_3)),main="Texto 1",col=c("darkblue","royalblue2","royalblue4"))
pie(c(nrow(texto2_p2_1),nrow(texto2_p2_2),nrow(texto2_p2_3)),main="Texto 2",col=c("darkblue","royalblue2","royalblue4"))
barplot(c(nrow(texto1_p2_1),nrow(texto1_p2_2),nrow(texto1_p2_3)),main="Texto 1",col=c("royalblue","royalblue2","royalblue4"),names=c("1.Concordo com a frase","2.Sou indiferente à frase","3.Discordo da frase"),ylim=c(0,700))
barplot(c(nrow(texto2_p2_1),nrow(texto2_p2_2),nrow(texto2_p2_3)),main="Texto 2",col=c("royalblue","royalblue2","royalblue4"),names=c("1.Concordo com a frase","2.Sou indiferente à frase","3.Discordo da frase"),ylim=c(0,700))
par(mfrow=c(1,1))

"Construindo a tabela de qproporções dos tipos de respostas por texto"
TabResp <- cbind(c(nrow(texto1_p2_1),nrow(texto1_p2_2),nrow(texto1_p2_3)), c(nrow(texto2_p2_1),nrow(texto2_p2_2),nrow(texto2_p2_3)))
colnames(TabResp) <- c("Texto 1","Texto 2")
rownames(TabResp) <- c("1.Concordo com a frase","2.Sou indiferente à frase","3.Discordo da frase")
View(TabResp)
datatable(TabResp)

TabResp_prop <- prop.table(TabResp)
TabResp_prop <- round(TabResp_prop * 100, 2)
colnames(TabResp_prop) <- c("Texto 1","Texto 2")
rownames(TabResp_prop) <- c("1.Concordo com a frase (%)","2.Sou indiferente à frase(%)","3.Discordo da frase(%)")
View(TabResp_prop)
datatable(TabResp_prop)

barplot(TabResp_prop, col = c("royalblue","royalblue2","royalblue4"),legend = rownames(TabResp_prop), args.legend = list(x = "topleft"),beside = TRUE,ylim = c(0,60))

"Teste Qui-Quadrado Homogeneidade"
chisq.test(TabResp,correct = FALSE)

"Adotando o nível de significância de 5%, temos que o valor p é 0.3851 ou 38,51%. Como o valor p é maior que o nível de significância, então não podemos concluir que as proporções são iguais."
""

#Conclusão
"Como as proporções não são iguais, então podemos concluir que existe relação entre o texto lido pelo entrevistado e a resposta à pergunta 2 (P2)."

#3)Verifique as suposições necessárias para a validade dos métodos inferenciais utilizados. Deixe   claro em qual contexto teórico foi necessário utilizá-las. Verifique a validade das que for possível, segundo seus conhecimentos.---- 

"Suposições necessárias para a validade dos métodos inferenciais utilizados
1)Independência das observações
2)Amostras aleatórias
3)Distribuição normal das variáveis
4)Homogeneidade das variâncias
"

#4) Critique o método de coleta de dados e sua implicação sobre a validade das técnicas inferenciais que você utilizou.----
" O método de coleta de dados foi feito por meio de um questionário online, o questionário foi divulgado por meio de um grupo específico de uma sociedade, o que pode ter gerado uma amostra enviesada, pois nem todos os indivíduos tem acesso as mesmas coisas.
Em suma: os testes de média e variância não são válidos pois as variáveis não seguem uma distribuição normal. E as amostras não são aletórias 

"