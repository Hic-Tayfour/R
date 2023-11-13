"Estudo sobre pesquisas de preços dos produtos orgânicos, dado diferentes textos motivadores de resposta"

#Grupo----
"
Beatriz Emi Ueda               (beatrizeu@al.insper.edu.br)					
Beatriz Fernandes da Silva      (beatrizfs1@al.insper.edu.br)					
Gabriela Abib                    (gabrielaa6@al.insper.edu.br)					
Hicham Munir Tayfour             (hichamt@al.insper.edu.br)					
Raynnara Silva de Freitas Gurgel (raynnarasf@al.insper.edu.br)
"

#Seprando respostas pelos tipos de texto usado e por turma
texto_1 <- APS2[APS2$Texto==1,]
texto_2 <- APS2[APS2$Texto==2,]

texto_1_A <- APS2[APS2$Texto==1 & APS2$Turma=="A",]
texto_2_A <- APS2[APS2$Texto==2 & APS2$Turma=="A",]

texto_1_B <- APS2[APS2$Texto==1 & APS2$Turma=="B",]
texto_2_B <- APS2[APS2$Texto==2 & APS2$Turma=="B",]

texto_1_C <- APS2[APS2$Texto==1 & APS2$Turma=="C",]
texto_2_C <- APS2[APS2$Texto==2 & APS2$Turma=="C",]

texto_1_D <- APS2[APS2$Texto==1 & APS2$Turma=="D",]
texto_2_D <- APS2[APS2$Texto==2 & APS2$Turma=="D",]

"Conclusão: As turmas 'A' e 'B' ficaram responsáveis pelo texto do Tipo 1
            Enquanto as turmas 'C' e 'D' ficaram responsáveis pelo texto do Tipo 2"
rm(list = c("texto_2_A", "texto_2_B", "texto_1_C", "texto_1_D"))

#Tratando os dados----
"Houve um preenchimento incorreto das respostas, seja na formulação do formulário ou na passagem das respostas para o Excel. Com a finalidade de obter uma resposta mais acertiva, teremos que corrigir os dados de acordo com os padrões pré-estabelecidos"

#Dados do Texto 1 da Turma A----
sort(unique(texto_1_A$P1))
texto_1_A$P1 <- gsub("NAN|Não sei|Não sei.|", "", texto_1_A$P1)
texto_1_A$P1[texto_1_A$P1 == ""] <- NA
texto_1_A$P1 <- as.numeric(texto_1_A$P1)

sort(unique(texto_1_A$P2))
texto_1_A$P2 <- gsub('1. Concordo com a frase|Concordo com a frase', '1', texto_1_A$P2)
texto_1_A$P2 <- gsub('2. Sou indiferente à frase|Sou indiferente à frase', '2', texto_1_A$P2)
texto_1_A$P2 <- gsub('Discordo com a frase', '3', texto_1_A$P2)
texto_1_A$P2 <- as.numeric(texto_1_A$P2)

sort(unique(texto_1_A$P3))
texto_1_A$P3 <- gsub('1. Masculino|Masculino', '1', texto_1_A$P3)
texto_1_A$P3 <- gsub('2. Feminino|Feminino', '2', texto_1_A$P3)
texto_1_A$P3 <- as.numeric(texto_1_A$P3)

sort(unique(texto_1_A$P4))
texto_1_A$P4 <- as.numeric(texto_1_A$P4)

sort(unique(texto_1_A$P5))
texto_1_A$P5 <- gsub('1. Até ensino fundamental completo', '1', texto_1_A$P5)
texto_1_A$P5 <- gsub('2. Até ensino médio completo|Até o ensino médio completo', '2', texto_1_A$P5)
texto_1_A$P5 <- gsub('3. Pelo menos ensino superior completo|Pelo menos ensino superior completo', '3', texto_1_A$P5)
texto_1_A$P5 <- as.numeric(texto_1_A$P5)

#Dados do Texto 1 da Turma B----
sort(unique(texto_1_B$P1))
texto_1_B$P1 <- gsub("Depende|Não me incomodaria de pagar mais|sim|Sim", "", texto_1_B$P1)
texto_1_B$P1 <- gsub("Mesmo valor|O mesmo valor ou até mais pelo benefício ambiental.|O mesmo vl",48, texto_1_B$P1)
texto_1_B$P1 <- gsub("Uns trinta",30, texto_1_B$P1)
texto_1_B$P1 <- as.numeric(texto_1_B$P1)

sort(unique(texto_1_B$P2))
texto_1_B$P2 <- gsub('Concordo com a frase', '1', texto_1_B$P2)
texto_1_B$P2 <- gsub('Sou indiferente à frase', '2', texto_1_B$P2)
texto_1_B$P2 <- gsub('Discordo com a frase', '3', texto_1_B$P2)
texto_1_B$P2 <- as.numeric(texto_1_B$P2)

sort(unique(texto_1_B$P3))
texto_1_B$P3 <- gsub('Masculino', '1', texto_1_B$P3)
texto_1_B$P3 <- gsub('Feminino', '2', texto_1_B$P3)
texto_1_B$P3 <- gsub('Prefiro não dizer|Prefiro não informar', '3', texto_1_B$P3)
texto_1_B$P3 <- gsub("18|19|28|41|44|49|50|51|52|54|56",NA,texto_1_B$P3)
texto_1_B$P3 <- as.numeric(texto_1_B$P3)

sort(unique(texto_1_A$P4))
texto_1_B$P4 <- as.numeric(texto_1_B$P4)

sort(unique(texto_1_B$P5))
texto_1_B$P5 <- gsub('Até ensino fundamental completo', '1', texto_1_B$P5)
texto_1_B$P5 <- gsub('Até ensino médio completo', '2', texto_1_B$P5)
texto_1_B$P5 <- gsub('Pelo menos ensino superior completo|Pelo menos ensino superior completo.', '3', texto_1_B$P5)
texto_1_B$P5 <- as.numeric(texto_1_B$P5)

#Dados do Texto 2 da Turma C----
sort(unique(texto_2_C$P1))
texto_2_C$P1 <- gsub("não compreendi a pergunta... em tese deveria pagar mais pelo produto por ser orgânico. algo como 15 a 20% a mais.|Não pagaria pela embalagem|Não pagaria. Por ser um produto produzido de maneira orgânica, custaria muito mais caro, e eu não teria condições financeiras para comprar, apesar de ser um produto \\\"saudável\\\".|No sistema capitalista o preço certamente é maior por não ser produzido em larga escala. Mas eu gostaria de pagar o mesmo valor ou menos. Mas compreendo que tudo depende de um sistema de custo de produção.|o quanto fosse necessário para que a produção orgânica se mantivesse.|Uma embalagem de um produto agrícola, produzido de maneira convencional, custa R\\$48,00. Quanto você pagaria, em reais, pela embalagem desse produto se ele fosse produzido de maneira orgânica?|Valor justo|?" ,"", texto_2_C$P1)
texto_2_C$P1 <- gsub("\\?","", texto_2_C$P1)
texto_2_C$P1 <- gsub("Até R\\$ 70,00.",70, texto_2_C$P1)
texto_2_C$P1 <- gsub("Até R\\$60,00",60, texto_2_C$P1)
texto_2_C$P1 <- gsub("Em média 62.40R\\$",62.4, texto_2_C$P1)
texto_2_C$P1 <- gsub("O dobro",96, texto_2_C$P1)
texto_2_C$P1 <- gsub("O mesmo preço",48, texto_2_C$P1)
texto_2_C$P1[texto_2_C$P1 == ""] <- NA
texto_2_C$P1 <- as.numeric(gsub(" reais", "", texto_2_C$P1))

sort(unique(texto_2_C$P2))
texto_2_C$P2 <- gsub('Concordo com a frase', '1', texto_2_C$P2)
texto_2_C$P2 <- gsub('Sou indiferente a frase|Sou indiferente à frase', '2', texto_2_C$P2)
texto_2_C$P2 <- gsub('Discordo com a frase', '3', texto_2_C$P2)
texto_2_C$P2[texto_2_C$P2 == "Considero que o consumo de produtos orgânicos deveria ser incentivado na população:"] <- NA
texto_2_C$P2 <- as.numeric(texto_2_C$P2)

sort(unique(texto_2_C$P3))
texto_2_C$P3 <- gsub('Masculino', '1', texto_2_C$P3)
texto_2_C$P3 <- gsub('Feminino', '2', texto_2_C$P3)
texto_2_C$P3 <- gsub('Prefiro não informar', '3', texto_2_C$P3)
texto_2_C$P3 <- as.numeric(texto_2_C$P3)

sort(unique(texto_2_C$P4))
texto_2_C$P4 <- as.numeric(gsub(" anos", "", texto_2_C$P4))

sort(unique(texto_2_C$P5))
texto_2_C$P5 <- gsub('Até ensino fundamental completo|Até o ensino fundamental completo', '1', texto_2_C$P5)
texto_2_C$P5 <- gsub('Até ensino médio completo|Até o ensino médio completo', '2', texto_2_C$P5)
texto_2_C$P5 <- gsub('pelo menos ensino superior completo|Pelo menos ensino superior completo.', '3', texto_2_C$P5)
texto_2_C$P5[texto_2_C$P5 == "Qual seu nível máximo de escolaridade?"] <- NA
texto_2_C$P5 <- as.numeric(texto_2_C$P5)

#Dados do Texto 2 da Turma D----
sort(unique(texto_2_D$P1))
texto_2_D$P1 <- as.numeric(texto_2_D$P1)

sort(unique(texto_2_D$P2))
texto_2_D$P2 <- gsub('Concordo com a frase|Concordo|Concordo com a frase \\(1\\)|1 \\(1\\)', '1', texto_2_D$P2)
texto_2_D$P2 <- gsub('Sou indiferente à frase|Sou indiferente à frase \\(2\\)|Indiferente|2 \\(2\\)', '2', texto_2_D$P2)
texto_2_D$P2 <- gsub('Discordo com a frase|Discordo com a frase \\(3\\)|3 \\(3\\)', '3', texto_2_D$P2)
texto_2_D$P2 <- as.numeric(texto_2_D$P2)

sort(unique(texto_2_D$P3))
texto_2_D$P3 <- gsub('Masculino|Masculino \\(1\\)', '1', texto_2_D$P3)
texto_2_D$P3 <- gsub('Feminino|Feminino \\(2\\)', '2', texto_2_D$P3)
texto_2_D$P3 <- gsub('Prefiro não dizer|Prefiro não informar \\(3\\)', '3', texto_2_D$P3)
texto_2_D$P3 <- as.numeric(texto_2_D$P3)

sort(unique(texto_2_D$P4))
texto_2_D$P4 <- gsub('não informado|não infornado', '', texto_2_D$P4)
texto_2_D$P4[texto_2_D$P4 == ""] <- NA
texto_2_D$P4 <- as.numeric(texto_2_D$P4)

sort(unique(texto_2_D$P5))
texto_2_D$P5 <- gsub('Até ensino fundamental completo|Até o ensino fundamental completo \\(1\\)', '1', texto_2_D$P5)
texto_2_D$P5 <- gsub('Até ensino médio completo|Até ensino médio completo \\(2\\)', '2', texto_2_D$P5)
texto_2_D$P5 <- gsub('Pelo menos ensino superior completo|Pelo menos ensino superior completo \\(3\\)', '3', texto_2_D$P5)
texto_2_D$P5 <- gsub('\\(1\\)', '', texto_2_D$P5)
texto_2_D$P5 <- trimws(texto_2_D$P5)
texto_2_D$P5 <- as.numeric(texto_2_D$P5)

#Remontando o Dataframe após ajuste de respostas----
resp <- rbind(texto_1_A,texto_1_B,texto_2_C,texto_2_D)
resp <- na.omit(resp)
"Remontamos o dataframe, arrumando as respostas possíveis, ou seja, padronizando com estava nas instruções da formulação do formulário. Os dados que não foram possíveis de recuperar substituimos por NA e retiramos eles no final"

# Montando o Perfil da Amostra (Cálculos Gerais) ----

# PREÇO DOS RESPONDENTES

media_preco=mean(resp$P1)
desvio_preco=sd(resp$P1)
variancia_preco=var(resp$P1)
mediana_preco=median(resp$P1)
min_preco=min(resp$P1)
max_preco=max(resp$P1)

TabPreco=cbind(media_preco,desvio_preco,variancia_preco,mediana_preco,min_preco,max_preco)
colnames(TabPreco)=c("Média","Desvio Padrão","Variância","Mediana","Mínimo","Máximo") 
rownames(TabPreco)=c('Preços')
View(TabPreco)

# IDADE DOS RESPONDENTES

media_idade=mean(resp$P4)
desvio_idade=sd(resp$P4)
variancia_idade=var(resp$P4)
mediana_idades=median(resp$P4)
min_idade=min(resp$P4)
max_idade=max(resp$P4)

TabIdadeAmostra=cbind(media_idade,desvio_idade,variancia_idade,mediana_idades)
colnames(TabIdadeAmostra)=c("Média","Desvio Padrão","Variância","Mediana") 
rownames(TabIdadeAmostra)=c('Idade dos Respondentes')
View(TabIdadeAmostra)

# SEXO DOS RESPONDENTES 
total=length(APS2$P3)
mulheres=length(resp$P3[resp$P3==2])
homens=length(resp$P3[resp$P3==1])
neutro=table(resp$P3[resp$P3==3])

# Essa parte eu calculei na mão pq pelo prop.table os resultados estavam esquisitos, se vc conseguir conferir para mim :)

mulheres_prop=round((mulheres/total)*100,2)
homens_prop=round((homens/total)*100,2)
neutro_prop=round((neutro/total)*100,2)

TabSexo=cbind(mulheres_prop,homens_prop,neutro_prop)
colnames(TabSexo)=c("Mulheres","Homens","Não Declarados") 
rownames(TabSexo)=c('%')
View(TabSexo)

mulheres=table(resp$P3==2)
mulheres_prop=round(prop.table(mulheres)*100,2)
homens=table(resp$P3==1)
homens_prop=round(prop.table(homens)*100,2)
neutro=table(resp$P3==3)
neutro_prop=round(prop.table(neutro)*100,2)

# Nível de Escolaridade 

# Essa parte eu calculei na mão pq pelo prop.table os resultados estavam esquisitos, se vc conseguir conferir para mim :)
fundamental=table(resp$P5==1)
fund_prop=round(prop.table(fundamental)*100,2)
medio=table(resp$P5==2)
medio_prop=round(prop.table(medio)*100,2)
superior=table(resp$P5==3)
superior_prop=round(prop.table(superior)*100,2)

TabEscola=cbind(fund_prop,medio_prop,superior_prop)
colnames(TabEscola)=c("Ensino Fundamental Completo","Ensino Médio Completo","Ensino Superior Completo") 
rownames(TabEscola)=c("%")
View(TabEscola)

fundamental=length(resp$P5[resp$P5==1])
medio=length(resp$P5[resp$P5==2])
superior=table(resp$P5[resp$P5==3])

fund_prop=round((fundamental/total)*100,2)
medio_prop=round((medio/total)*100,2)
superior_prop=round((superior/total)*100,2)



#Análise descritiva das respostas----
#a. existe efeito do texto lido sobre as respostas à pergunta P1 ?----
preco_text1 <- resp$P1[resp$Texto==1]
preco_text2 <- resp$P1[resp$Texto==2]

mean_preco_t=c(mean(preco_text1),mean(preco_text2))
median_preco_t=c(median(preco_text1),median(preco_text2))
moda_preco_t=c(Mode(preco_text1),Mode(preco_text2))
min_preco_t=c(min(preco_text1),min(preco_text2))
max_preco_t=c(max(preco_text1),max(preco_text2))
var_preco_t=c(var(preco_text1),var(preco_text2))
sd_preco_t=c(sd(preco_text1),sd(preco_text2))

TabPreço_T=cbind(mean_preco_t,median_preco_t,moda_preco_t,min_preco_t,max_preco_t,var_preco_t,sd_preco_t)
colnames(TabPreço_T)=c("Média","Mediana","Moda","Mínimo","Máximo","Variância Amostral","Desvio Padrão Amostral")
rownames(TabPreço_T)=c("Texto 1","Texto 2")
View(TabPreço_T)

par(mfrow=c(1,2))

hist(preco_text1, main="Histograma dos Preços do Texto 1",
     col = "royalblue2", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.06),breaks = 30)
lines(density(preco_text1),lty = 1, lwd = 3,col = "black") 

hist(preco_text2, main="Histograma dos Preços do Texto 2",
     col = "royalblue2", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.09),breaks = 30)
lines(density(preco_text2),lty = 1, lwd = 3,col = "black") 

par(mfrow=c(1,1))

boxplot(preco_text1,preco_text2,col=c("blue","red"),main="Preços dos produtos orgânicos em diferentes textos",names=c("Texto 1","Texto 2"))

#b. a disposição a pagar por um produto orgânico depende do sexo ?----
preco_s1 <- resp$P1[resp$P3==1]
preco_s2 <- resp$P1[resp$P3==2]
preco_s3 <- resp$P1[resp$P3==3]

mean_preco_s=c(mean(preco_s1),mean(preco_s2),mean(preco_s3))
median_preco_s=c(median(preco_s1),median(preco_s2),median(preco_s3))
moda_preco_s=c(mode(preco_s1),mode(preco_s2),mode(preco_s3))
min_preco_s=c(min(preco_s1),min(preco_s2),min(preco_s3))
max_preco_s=c(max(preco_s1),max(preco_s2),max(preco_s3))
var_preco_s=c(var(preco_s1),var(preco_s2),var(preco_s3))
sd_preco_s=c(sd(preco_s1),sd(preco_s2),sd(preco_s3))

TabPreço_S=cbind(mean_preco_s,median_preco_s,moda_preco_s,min_preco_s,max_preco_s,var_preco_s,sd_preco_s)
colnames(TabPreço_S)=c("Média","Mediana","Moda","Mínimo","Máximo","Variância Amostral","Desvio Padrão Amostral")
rownames(TabPreço_S)=c("1.Masculino","2.Feminimo","3.Não Informado")
View(TabPreço_S)

par(mfrow=c(1,3))
hist(preco_s1, main="Preços do sexo masculino",
     col = "lightblue", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.08),breaks = 30)
lines(density(preco_s1),lty = 1, lwd = 3,col = "lightblue4") 

hist(preco_text2, main="Preços do sexo feminino",
     col = "lightpink2", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.09),breaks = 30)
lines(density(preco_s2),lty = 1, lwd = 3,col = "lightpink4") 

hist(preco_s3, main="Preços do sexo não informado",
     col = "palegreen", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.09),breaks = 30)
lines(density(preco_s2),lty = 1, lwd = 3,col = "palegreen4") 

par(mfrow=c(1,1))

boxplot(preco_s1,preco_s2,preco_s1,col=c("lightblue","lightpink","palegreen"),main="Preços dos produtos orgânicos em diferentes sexos",names=c("1.Masculino","2.Feminino","3.Não Informado"))

#c. a disposição a pagar por um produto orgânico depende da escolaridade ?----
preco_e1 <- resp$P1[resp$P5==1]
preco_e2 <- resp$P1[resp$P5==2]
preco_e3 <- resp$P1[resp$P5==3]

mean_preco_e=c(mean(preco_e1),mean(preco_e2),mean(preco_e3))
median_preco_e=c(median(preco_e1),median(preco_e2),median(preco_e3))
moda_preco_e=c(Mode(preco_e1),Mode(preco_e2),Mode(preco_e3))
min_preco_e=c(min(preco_e1),min(preco_e2),min(preco_e3))
max_preco_e=c(max(preco_e1),max(preco_e2),max(preco_e3))
var_preco_e=c(var(preco_e1),var(preco_e2),var(preco_e3))
sd_preco_e=c(sd(preco_e1),sd(preco_e2),sd(preco_e3))

TabPreço_E=cbind(mean_preco_e,median_preco_e,moda_preco_e[1],min_preco_e, max_preco_e,var_preco_e,sd_preco_e)
colnames(TabPreço_E)=c("Média","Mediana","Moda","Mínimo","Máximo","Variância Amostral","Desvio Padrão Amostral")
rownames(TabPreço_E)=c("1.Até o Ensino Fundamental","2.Até o Ensino Médio","3.Pelo Menos o Ensino Superior")
View(TabPreço_E)

par(mfrow=c(1,3))
hist(preco_s1, main="Histograma dos Preços do sexo masculino",
     col = "royalblue2", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.08),breaks = 30)
lines(density(preco_s1),lty = 1, lwd = 3,col = "black") 

hist(preco_text2, main="Histograma dos Preços do sexo feminino",
     col = "royalblue2", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.09),breaks = 30)
lines(density(preco_s2),lty = 1, lwd = 3,col = "black") 

hist(preco_s3, main="Histograma dos Preços do sexo não informado",
     col = "royalblue2", ylab = "Densidade",xlab = "Preço",probability = TRUE,ylim=c(0,0.09),breaks = 30)
lines(density(preco_s2),lty = 1, lwd = 3,col = "black") 

par(mfrow=c(1,1))

boxplot(preco_s1,preco_s2,preco_s1,col=c("blue","red","purple"),main="Preços dos produtos orgânicos em diferentes sexos",names=c("1.Masculino","2.Feminino","3.Não Informado"))

#d. a disposição a pagar por um produto orgânico depende da idade ?----
cor(resp$P1,resp$P4)
plot(resp$P1~resp$P4,xlab="Idades",ylab="Preços",
     col="darkblue",main="Relação entre idade e preço")
abline(lm(resp$P1~resp$P4),lwd=3,col="red") 


#3) Há relação entre o texto apresentado e a resposta dada à pergunta 3 (P2) ?----
resp_1_t1=length(resp$P2[resp$P2==1 & resp$Texto==1])
resp_2_t1=length(resp$P2[resp$P2==2 & resp$Texto==1])
resp_3_t1=length(resp$P2[resp$P2==3 & resp$Texto==1])
resp_1_t2=length(resp$P2[resp$P2==1 & resp$Texto==2])
resp_2_t2=length(resp$P2[resp$P2==2 & resp$Texto==2])
resp_3_t2=length(resp$P2[resp$P2==3 & resp$Texto==2])
resp_t1=cbind(resp_1_t1,resp_2_t1,resp_3_t1)
resp_t2=cbind(resp_1_t2,resp_2_t2,resp_3_t2)
TabResp=rbind(resp_t1,resp_t2)
TabResp=prop.table(TabResp)
TabResp=round(100*TabResp,2)
colnames(TabResp)=c("Resposta 1 (%)","Resposta 2 (%)","Resposta 3 (%)")
rownames(TabResp)=c("Texto 1","Texto 2")
View(TabResp)

par(mfrow=c(1,2))
barplot(prop.table(resp_t1),ylim=c(0,1),main = "Tipos de Respostas no Texto 1", col = "green",ylab = "Proporção das Respostas",names=c("Resposta 1 (%)","Resposta 2 (%)","Resposta 3 (%)"))

barplot(prop.table(resp_t2),ylim=c(0,1),main = "Tipos de Respostas no Texto 2", col = "green",ylab = "Proporção das Respostas",names=c("Resposta 1 (%)","Resposta 2 (%)","Resposta 3 (%)"))
