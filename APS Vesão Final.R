library(DescTools)


# B - QUANTIDADE DE CLIENTES QUE ADERIRAM E NÃO ADERIRAM A OFERTA DO PRODUTO ----
f_absoluta=table(banco$subscribed)
ni=table(banco$subscribed)
f_relativa=round(prop.table(ni)*100,2)
tab_adesão=cbind(f_absoluta,f_relativa)
colnames(tab_adesão)=c("Frequência Absoluta", "Frequência Relativa (%)")
rownames(tab_adesão)=c("Não aderiu","Aderiu")
View(tab_adesão)

# C - PROPORÇÃO DE CADA PROFISSÃO POR AMOSTRA ----
table_job1=table(banco$subscribed[banco$job=="admin"])
table_job2=table(banco$subscribed[banco$job=="blue-collar"])
table_job3=table(banco$subscribed[banco$job=="entrepreneur"])
table_job4=table(banco$subscribed[banco$job=="housemaid"])
table_job5=table(banco$subscribed[banco$job=="management"])
table_job6=table(banco$subscribed[banco$job=="retired"])
table_job7=table(banco$subscribed[banco$job=="self-employed"])
table_job8=table(banco$subscribed[banco$job=="services"])
table_job9=table(banco$subscribed[banco$job=="student"])
table_job10=table(banco$subscribed[banco$job=="technician"])
table_job11=table(banco$subscribed[banco$job=="unemployed"])
table_job12=table(banco$subscribed[banco$job=="unknown"])

prop_job1=round(prop.table(table_job1)*100,2)
prop_job2=round(prop.table(table_job2)*100,2)
prop_job3=round(prop.table(table_job3)*100,2)
prop_job4=round(prop.table(table_job4)*100,2)
prop_job5=round(prop.table(table_job5)*100,2)
prop_job6=round(prop.table(table_job6)*100,2)
prop_job7=round(prop.table(table_job7)*100,2)
prop_job8=round(prop.table(table_job8)*100,2)
prop_job9=round(prop.table(table_job9)*100,2)
prop_job10=round(prop.table(table_job10)*100,2)
prop_job11=round(prop.table(table_job11)*100,2)
prop_job12=round(prop.table(table_job12)*100,2)

tab_job=rbind(prop_job1,prop_job2,prop_job3,prop_job4,
              prop_job5,prop_job6,prop_job7,prop_job8,
              prop_job9,prop_job10,prop_job11,prop_job12)
rownames(tab_job)=c("admin","blue-collar","entrepreneur","housemaid",
                    "management","retired","self-employed","services",
                    "student","technician","unemployed","unknown")
colnames(tab_job)=c("Não aderiu (%)","Aderiu (%)")
View(tab_job)

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
tab_prof=cbind(count_job,job_prop,count_job_yes,count_job_no)
colnames(tab_prof)=c("Número de Empregados","Participação na amostra (%)","Aderiu ao Programa (%)","Não Aderiu ao Programa (%)")
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

# D - Estado Civil e adesão a oferta ----
table_single=table(banco$subscribed[banco$civil_status=="single"])
table_married=table(banco$subscribed[banco$civil_status=="married"])
table_divorced=table(banco$subscribed[banco$civil_status=="divorced"])
prop_table_single=round(prop.table(table_single)*100,2)
prop_table_married=round(prop.table(table_married)*100,2)
prop_table_divorced=round(prop.table(table_divorced)*100,2)
tab_civil=cbind(table_single,table_married,table_divorced,
                prop_table_single,prop_table_married,prop_table_divorced)
colnames(tab_civil)=c("Single (ni)","Married (ni)", "Divorced (ni)",
                      "Single (fi)","Married (fi)", "Divorced (fi)")
rownames(tab_civil)=c("Aderiu","Não aderiu")
View(tab_civil)

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

# E - Idade dos Consumidores----

table_idade1=table(cut(banco$age, breaks= c(10,20,30,40,50,60,70,80,90,100),
                       labels = c("[10,20[","[20,30[","[30,40[",
                                  "[40,50[","[50,60[","[60,70[",
                                  "[70,80[","[80,90[","[90,100[")))
table_idade2=round(prop.table(table_idade1)*100,2)
table_age1=table(banco$subscribed[banco$age>10&banco$age<=20])
table_age2=table(banco$subscribed[banco$age>20&banco$age<=30])
table_age3=table(banco$subscribed[banco$age>30&banco$age<=40])
table_age4=table(banco$subscribed[banco$age>40&banco$age<=50])
table_age5=table(banco$subscribed[banco$age>50&banco$age<=60])
table_age6=table(banco$subscribed[banco$age>60&banco$age<=70])
table_age7=table(banco$subscribed[banco$age>70&banco$age<=80])
table_age8=table(banco$subscribed[banco$age>80&banco$age<=90])
table_age9=table(banco$subscribed[banco$age>90&banco$age<=100])
prop_age1=round(prop.table(table_age1)*100,2)
prop_age2=round(prop.table(table_age2)*100,2)
prop_age3=round(prop.table(table_age3)*100,2)
prop_age4=round(prop.table(table_age4)*100,2)
prop_age5=round(prop.table(table_age5)*100,2)
prop_age6=round(prop.table(table_age6)*100,2)
prop_age7=round(prop.table(table_age7)*100,2)
prop_age8=round(prop.table(table_age8)*100,2)
prop_age9=round(prop.table(table_age9)*100,2)
tab_age=rbind(prop_age1,prop_age2,prop_age3,
              prop_age4,prop_age5,prop_age6,
              prop_age7,prop_age8,prop_age9)
rownames(tab_age)=c("[10,20[","[20,30[","[30,40[",
                    "[40,50[","[50,60[","[60,70[",
                    "[70,80[","[80,90[","[90,100[")
tab_age=cbind(tab_age,
              table_idade1,table_idade2)
colnames(tab_age)=c("Percentual que não aderiu","Percentual que aderiu","Frequência absoluta", "Frequência relativa")
View(tab_age)

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


# F - Relação entre a idades dos clientes e a adesão ao programa----
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

# G e H - Relação entre ter empréstimo imobiliário e adesão ao programa----
table_imob_yes=table(banco$subscribed[banco$housing=="yes"])
table_imob_no=table(banco$subscribed[banco$housing=="no"])
prop_imob_yes=round(prop.table(table_imob_yes)*100,2)
prop_imob_no=round(prop.table(table_imob_no)*100,2)
tab_imob=cbind(table_imob_yes,table_imob_no,prop_imob_yes,prop_imob_no)
colnames(tab_imob)=c("Com empréstimo imobiliário(ni)","Sem empréstimo imobiliário (ni)", 
                     "Com empréstimo imobiliário (fi)", "Sem empréstimo imobiliário(fi)")
rownames(tab_imob)=c("Não aderiu","Aderiu")
View(tab_imob)

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

#I - Tempo de ligação por adesão ao programa ----
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

#  K.1 - ANÁLISE EDUCATION ----
table_primary=table(banco$subscribed[banco$education=="primary"])
table_secondary=table(banco$subscribed[banco$education=="secondary"])
table_tertiary=table(banco$subscribed[banco$education=="tertiary"])
table_unknown=table(banco$subscribed[banco$education=="unknown"])
prop_table_primary=round(prop.table(table_primary)*100,2)
prop_table_secondary=round(prop.table(table_secondary)*100,2)
prop_table_tertiary=round(prop.table(table_tertiary)*100,2)
prop_table_unknown=round(prop.table(table_unknown)*100,2)
tab_education=cbind(table_primary,table_secondary,table_tertiary,table_unknown,
                    prop_table_primary,prop_table_secondary,prop_table_tertiary,prop_table_unknown)
colnames(tab_education)=c("Primary (ni)","Secondary (ni)", "Tertiary (ni)","Unknown (ni)",
                          "Primary (fi)","Secondary (fi)", "Tertiary (fi)", "Unknown (fi)")
rownames(tab_education)=c("Não aderiu","Aderiu")
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
        col=c("steelblue","steelblue4","aquamarine3", "turquoise"),
        ylim=c(0,60),
        main="ADESÃO DA OFERTA POR NÍVEL DE EDUCAÇÃO",
        ylab="Proporção da Adesão",
        legend.text=levels(banco$subscribed),
        beside=TRUE,
        cex.main = 0.75)
legend("topright",col=c("steelblue","steelblue4","aquamarine3", "turquoise"),
       legend = c("Primary","Secondary","Terciary", "Unknown"),lwd=c(3,3,3))

#  K.2 - ANÁLISE LOAN ----
table_loan_yes=table(banco$subscribed[banco$loan=="yes"])
table_loan_no=table(banco$subscribed[banco$loan=="no"])
prop_loan_yes=round(prop.table(table_loan_yes)*100,2)
prop_loan_no=round(prop.table(table_loan_no)*100,2)
tab_loan=cbind(table_loan_yes,table_loan_no,prop_loan_yes,prop_loan_no)
colnames(tab_loan)=c("Com empréstimo pessoal (ni)","Sem empréstimo pessoal (ni)", 
                     "Com empréstimo pessoal (fi)", "Sem empréstimo pessoal (fi)")
rownames(tab_loan)=c("Não aderiu","Aderiu")
View(tab_loan)

# K.3 - ANÁLISE DEFAULT ----
table_default_yes=table(banco$subscribed[banco$default=="yes"])
table_default_no=table(banco$subscribed[banco$default=="no"])
prop_default_yes=round(prop.table(table_default_yes)*100,2)
prop_default_no=round(prop.table(table_default_no)*100,2)
tab_default=cbind(table_default_yes,table_default_no,prop_default_yes,prop_default_no)
colnames(tab_default)=c("Cliente inadimplente (ni)","Cliente não inadimplente (ni)", 
                        "Cliente inadimplente (fi)", "Cliente não inadimplente (fi)")
rownames(tab_default)=c("Não aderiu","Aderiu")
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


# K.5 - Relações entre variaves não usadas----

faixas=c(0,1,2,3,4,5,6,7,8,9,70)

par(mfrow=c(1,2))
tab_camp1= hist(banco$campaign[banco$subscribed=="yes"], probability = TRUE,
                breaks=faixas,
                col=c("plum"),
                xlab= "Núm. contatos de telemarketing",
                ylab= "Densidade",
                main= "Contatos de telemarketing (ADERIU)",
                xlim=c(0,10),
                ylim=c(0,0.55))

tab_camp2=hist(banco$campaign[banco$subscribed=="no"],probability = TRUE,
               breaks=faixas,
               col=c("plum4"),
               xlab= "Núm. contatos de telemarketing",
               ylab= "Densidade",
               main= "Contatos de telemarketing (NÃO ADERIU)",
               xlim=c(0,10),
               ylim=c(0,0.55))
