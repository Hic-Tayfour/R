library(readxl)
banco <- read_excel("v3.xlsx")
library(DescTools)

# B - QUANTIDADE DE CLIENTES QUE ADERIRAM E NÃO ADERIRAM A OFERTA DO PRODUTO ----
sub_yes=length(banco$subscribed[banco$subscribed=="yes"])
sub_no=length(banco$subscribed[banco$subscribed=="no"])
tab_adesão=cbind(sub_yes,sub_no)
View(tab_adesão)
colnames(tab_adesão)=c("Qtde. Adesão", "Qtde. Não Adesão")
rownames(tab_adesão)=c("Produto")

# C.1 - PROPORÇÃO DE CADA PROFISSÃO POR AMOSTRA ----
count_job=table(banco$job)
job_prop=round(prop.table(count_job)*100,1)

# C.2 - PROPORÇÃO DE PROFISSÃO (ADERIRAM) ----
count_job_yes=table(banco$job[banco$subscribed=="yes"])
count_job_yes=round(prop.table(count_job_yes)*100,2)

# C.3 - PROPORÇÃO DE PROFISSÃO (NÃO ADERIRAM)----
count_job_no=table(banco$job[banco$subscribed=="no"])
count_job_no=round(prop.table(count_job_no)*100,2)

# C.4-Tabela de Dados----
tab_prof=cbind(count_job,count_job_yes,count_job_no)
colnames(tab_prof)=c("Número de Empregados","Aderiu ao Programa (%)","Não Aderiu ao Programa (%)")
View(tab_prof)
par(mfrow=c(1,2))
pie(round(prop.table(table(banco$job[banco$subscribed=="yes"])),3) * 100,
    col = c("aquamarine","aquamarine1","aquamarine2","aquamarine3","aquamarine4","chartreuse","chartreuse1","chartreuse2","chartreuse3","chartreuse4","green","green1","green2"),
    main = "PROFISSÕES QUE ADERIRAM AO PROGRAMA", 
    cex.main = 1.0, cex.lab = 0.75)
pie(round(prop.table(table(banco$job[banco$subscribed=="no"])),3) * 100,
    col = c("deepskyblue","deepskyblue1","deepskyblue2","deepskyblue3","deepskyblue4","dodgerblue","dodgerblue1", "dodgerblue2","dodgerblue3","dodgerblue4","darkslategray1","darkslategray2","darkslategray3"),
    main = "PROFISSÕES QUE NÃO ADERIRAM AO PROGRAMA", 
    cex.main = 1.0, cex.lab = 0.75)

# D-Estado Civil e adesão a oferta ----
civstt_yes=table(banco$civil_status[banco$subscribed=="yes"])
civstt_no=table(banco$civil_status[banco$subscribed=="no"])
tab_civ_sub=cbind(civstt_yes,civstt_no)
colnames(tab_civ_sub)=c("Aderiu ao Programa","Não Aderiu ao Programa")
View(tab_civ_sub)
par(mfrow=c(1,2))
barplot(round(prop.table(table(banco$subscribed,banco$civil_status)),3)*100,
        col=c("plum4","plum"),
        ylim=c(0,60),
        main="ADESÃO DA OFERTA POR ESTADO CIVIL",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$subscribed),
        beside=TRUE,
        cex.main = 0.75)
legend("topleft",col=c("plum4","plum"),
       legend = c("não aderiu","aderiu"),lwd=c(2,2))


barplot(round(prop.table(table(banco$civil_status,banco$subscribed)),3)*100,
        col=c("steelblue","steelblue2","steelblue4"),
        ylim=c(0,60),
        main="ADESÃO DA OFERTA POR ESTADO CIVIL",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$subscribed),
        beside=TRUE,
        cex.main = 0.75)
legend("topright",col=c("steelblue","steelblue2","steelblue4"),
       legend = c("divorced","married","single"),lwd=c(3,3,3))

#E-Idade dos Consumidores----
idade=banco$age
par(mfrow=c(1,1))
faixas=seq(0,100,5)
hist(banco$age,probability = TRUE,breaks=faixas,main = "DISTRIBUIÇÃO DAS IDADES",xlab="Idade",ylab="Densidade",col="turquoise2")
lines(density(banco$age),col="thistle4",lwd=5)
média_idade=mean(idade)
mediana_idade=median(idade)
moda_idade=Mode(idade)
mínimo_idade=min(idade)
máximo_idade=max(idade)
amplitude_idade=máximo_idade-mínimo_idade
desviopadrão_idade=sd(idade)
coef.Var_idade=desviopadrão_idade/média_idade
estat_age=cbind(média_idade,mediana_idade,moda_idade,máximo_idade,mínimo_idade,amplitude_idade,desviopadrão_idade,coef.Var_idade)
colnames(estat_age)=c("Média","Mediana","Moda","Máximo","Mínimo","Amplitude","Desvio Padrão","Coef.Var")
View(estat_age)

#F-Relação entre a idades dos clientes e a adesão ao programa----
idade_yes=banco$age[banco$subscribed=="yes"]
idade_no=banco$age[banco$subscribed=="no"]
cortes <- 5
idade=cut(banco$age,breaks = cortes)
tab_age=(cbind(table(idade)))
View(tab_age)
colnames(tab_age)=c("Frequência")
média=c(mean(idade_yes),mean(idade_no))
mediana=c(median(idade_yes),median(idade_no))
moda=c(Mode(idade_yes),Mode(idade_no))
mínimo=c(min(idade_yes),min(idade_no))
máximo=c(max(idade_yes),max(idade_no))
amplitude=máximo-mínimo
desviopadrão=c(sd(idade_yes),sd(idade_no))
coef.Var=desviopadrão/média
tab_estat_age=cbind(média,mediana,moda,máximo,mínimo,amplitude,desviopadrão,coef.Var)
rownames(tab_estat_age)=c("Aderiu ao Programa","Não Aderiu ao programa")
colnames(tab_estat_age)=c("Média","Mediana","Moda","Máximo","Mínimo","Amplitude","Desvio Padrão","Coef.Var")
View(tab_estat_age)
par(mfrow=c(1,2))
hist(idade_yes,probability = TRUE,breaks = faixas,main = "DISTRIBUIÇÃO DAS IDADES QUE ADERIRAM",xlab="Idade",ylab="Densidade",col="darkseagreen3",ylim =c(0,0.05))
lines(density(idade_yes),col="gray33",lwd=3)
hist(idade_no,probability = TRUE,breaks = faixas,main = "DISTRIBUIÇÃO DAS IDADES QUE NÃO ADERIRAM",xlab="Idade",ylab="Densidade",col="darkorchid4",ylim =c(0,0.05))
lines(density(idade_no),col="gray33",lwd=3)
cortes <- 5
idade_yes=table(cut(banco$age[banco$subscribed =="yes"],breaks = cortes))
idade_no=table(cut(banco$age[banco$subscribed =="no"],breaks = cortes))
tab_age_sub=cbind(idade_yes,idade_no)
colnames(tab_age_sub)=c("Aderiu ao programa","Não aderiu ao programa")
View(tab_age_sub)

#G e H-Relação entre ter empréstimo imobiliário e adesão ao programa----
sub_yes_hous=table(banco$housing[banco$subscribed=="yes"])
sub_no_hous=table(banco$housing[banco$subscribed=="no"])
tab_sub_hous=cbind(sub_yes_hous,sub_no_hous)
rownames(tab_sub_hous)=c("Não possui emprestimo imoniliário","Possui emprestimo imobiliário")
colnames(tab_sub_hous)=c("Aderiu ao programa","Não aderiu ao programa")
par(mfrow=c(1,1))
barplot(round(prop.table(table(banco$housing,banco$subscribed)),3)*100,
        col=c("plum4","plum"),
        ylim=c(0,60),
        main="ADESÃO DA OFERTA POR EMPRESTIMO IMOBILIARIO",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$housing),
        beside=TRUE,
        cex.main = 0.75)
legend("topright",col=c("plum4","plum"),
       legend = c("não possui emprestimo","possui emprestimo"),lwd=c(2,2))
View(tab_sub_hous)

#I-Tempo de ligação por adesão ao programa----
call_yes=banco$call[banco$subscribed=="yes"]
call_no=banco$call[banco$subscribed=="no"]
média_c=c(mean(call_yes),mean(call_no))
mediana_c=c(median(call_yes),median(call_no))
máximo_c=c(max(call_yes),max(call_no))
mínimo_c=c(min(call_yes),min(call_no))
tab_estat_call=cbind(média_c,mediana_c,máximo_c,mínimo_c)
View(tab_estat_call)
colnames(tab_estat_call)=c("Média das ligações (em seg)","Mediana das ligações (em seg)","Máximo das ligações (em seg)","Mínimo das ligações (em seg)")
rownames(tab_estat_call)=c("Aderiu ao programa","Não aderiu ao programa")
par(mfrow=c(1,2))
hist(call_yes,probability = TRUE,breaks = seq(0,4000,250),main = "DISTRUIBUIÇÃO DAS LIGAÇÕES QUE ADERIRAM",xlab="Tempo das ligações",ylab="Densidade",col="turquoise2",ylim =c(0,0.003))
hist(call_no,probability = TRUE,breaks = seq(0,4000,250),main = "DISTRUIBUIÇÃO DAS LIGAÇÕES QUE NÃO ADERIRAM",xlab="Tempo das ligações",ylab="Densidade",col="turquoise2",ylim =c(0,0.003))
#K- Relações entre variaves não usadas----
prev_yes=(length(banco$previous[banco$subscribed=="yes"]))
prev_no=(length(banco$previous[banco$subscribed=="no"]))
camp_yes=(length(banco$campaign[banco$subscribed=="yes"]))
camp_no=(length(banco$campaign[banco$subscribed=="no"]))

# ANÁLISE VARIÁVEL EDUCATION


education_yes=table(banco$education[banco$subscribed=="yes"])
education_no=table(banco$education[banco$subscribed=="no"])
tab_education=cbind(education_yes,education_no)
colnames(tab_education)=c("Aderiu ao Programa","Não Aderiu ao Programa")
View(tab_education)
par(mfrow=c(1,2))
barplot(round(prop.table(table(banco$subscribed,banco$education)),3)*100,
        col=c("plum4","plum"),
        ylim=c(0,60),
        main="ADESÃO DA OFERTA POR NÍVEL DE EDUCAÇÃO",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$subscribed),
        beside=TRUE,
        cex.main = 0.75)
legend("topright",col=c("plum4","plum"),
       legend = c("não aderiu","aderiu"),lwd=c(2,2))

barplot(round(prop.table(table(banco$education,banco$subscribed)),3)*100,
        col=c("steelblue","steelblue2","steelblue3", "steelblue4"),
        ylim=c(0,60),
        main="ADESÃO DA OFERTA POR NÍVEL DE EDUCAÇÃO",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$subscribed),
        beside=TRUE,
        cex.main = 0.75)
legend("topright",col=c("steelblue","steelblue2","steelblue3", "steelblue4"),
       legend = c("Primary","Secondary","Terciary", "Unknown"),lwd=c(3,3,3))

# ANÁLISE LOAN

loan_yes=table(banco$loan[banco$subscribed=="yes"])
loan_no=table(banco$loan[banco$subscribed=="no"])
tab_loan=cbind(loan_yes,loan_no)
View(tab_loan)
colnames(tab_loan)=c("Possui Empréstimo Pessoal","Não Possui Empréstimo Pessoal")
rownames(tab_loan)=c("Aderiu ao Programa", "Não Aderiu ao Programa")

# de acordo com análises feitas, podemos concluir que, a maioria dos clientes que aderiram ao programa tendem a não possui empréstimos imobiliários. Isso pode ser identficado na tabela "tab_loan" que faz uma comparação entre com clientes que possuem ou não empréstimo imobiliário e como foi o seu comportamento perante a adesão do programa.

# K - ANÁLISE DEFAULT ----
default_yes=table(banco$default[banco$subscribed=="yes"])
default_no=table(banco$default[banco$subscribed=="no"])
tab_default=cbind(default_yes,default_no)
colnames(tab_default)=c("Possui Empréstimo Pessoal","Não Possui Empréstimo Pessoal")
rownames(tab_default)=c("Não Aderiu", "Aderiu")
View(tab_default)
par(mfrow=c(1,1))

barplot(round(prop.table(table(banco$default, banco$subscribed)),3)*100,
        col=c("plum4", "plum"),
        ylim=c(0,100),
        main="ADESÃO DA OFERTA DOS INADIMPLENTES",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$subscribed),
        beside=TRUE,
        cex.main = 0.75)
legend("topright",col=c("plum4", "plum"),
       legend = c("não aderiu","aderiu"),lwd=c(2,2))

# Podemos ver de acordo com o gráfico e tabela que quando o cliente é inadimplente ele tende a não aderir ao programa.