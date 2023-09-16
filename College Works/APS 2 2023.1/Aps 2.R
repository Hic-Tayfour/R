"Apelidamos nossa Base de Dados para 'dados'"
library(readxl)
dados <- read_excel("aps2_v2clean.xlsx")
#B)- ESTATÍSTICAS DE "Duration_ms"----
#calculo das estatísticas
quart_dura=quantile(dados$Duration_ms)
media_dura=round(mean(dados$Duration_ms),3)
mediana_dura=median(dados$Duration_ms)
min_dura=min(dados$Duration_ms)
max_dura=max(dados$Duration_ms)
amp_dura=diff(range(dados$Duration_ms))
desv_dura=round(sd(dados$Duration_ms),3)
coef.var_dura=round(((desv_dura/media_dura)*100),2)

#verificação de valores aberrantes
IQ_Dura=IQR(dados$Duration_ms)
Li_dura=quantile(dados$Duration_ms,0.25)-1.5*IQ_Dura
Ls_dura=quantile(dados$Duration_ms,0.75)+1.5*IQ_Dura

dados$Duration_ms[dados$Duration_ms<Li_dura]
dados$Artist[dados$Duration_ms<Li_dura]

dados$Duration_ms[dados$Duration_ms>Ls_dura]
dados$Artist[dados$Duration_ms>Ls_dura]

#tipo de assimetria
q1_dura=quantile(dados$Duration_ms,0.25)
q2_dura=quantile(dados$Duration_ms,0.50)
q3_dura=quantile(dados$Duration_ms,0.75)
a_dura=q2_dura-q1_dura
b_dura=q3_dura-q2_dura
a_dura
b_dura
ba=b_dura-a_dura
"a < b, assimetria é à direita (mediana menor que média)"

#Tabela assimtria
tab_assi_dura=cbind(b_dura,a_dura,ba)
colnames(tab_assi_dura)=c("b","a","Valor de b-a")
rownames(tab_assi_dura)="Valores"
View(tab_assi_dura)

#contrução das tabelas
tab_quart_dura=rbind(quart_dura)
colnames(tab_quart_dura)=c("Q1","Q2","Q3","Q4","Q5")
rownames(tab_quart_dura)="Duration_ms"
View(tab_quart_dura)

tab_estat_dura=cbind(media_dura,mediana_dura,min_dura,max_dura,amp_dura,desv_dura,coef.var_dura)
colnames(tab_estat_dura)=c("Média","Mediana","Mínimo","Máximo","Amplitude","Desvio Pdrão","Coef.Var (em %)")
rownames(tab_estat_dura)="Duration_ms"
View(tab_estat_dura)

#construção dos gráficos
boxplot(dados$Duration_ms,main="BoxPlot do Duration_ms",
        col = "dodgerblue1",ylab="Duration_ms")

hist(dados$Duration_ms, main="Histograma da Duration_ms",
     col = "royalblue2", ylab = "Densidade",xlab = "Duration_ms",probability = TRUE,ylim=c(0,0.000013))

lines(density(dados$Duration_ms),
      lty = 1,
      lwd = 3,
      col = "black")

#C)- BOXPLOT DE "Duartion_ms" BASEADO EM GENRE--------
#pesquisa dos tipos musicais 
"fazer tabela de quartis dos gêneros musicais"
dados$Genre <- as.factor(dados$Genre)
levels(dados$Genre)

dura_dark.trap=dados$Duration_ms[dados$Genre=="Dark Trap"]
min_dura_darktrap=min(dados$Duration_ms[dados$Genre=="Dark Trap"])
max_dura_darktrap=max(dados$Duration_ms[dados$Genre=="Dark Trap"])

dura_rap=dados$Duration_ms[dados$Genre=="Rap"]
min_dura_rap=min(dados$Duration_ms[dados$Genre=="Rap"])
max_dura_rap=max(dados$Duration_ms[dados$Genre=="Rap"])

dura_rnb=dados$Duration_ms[dados$Genre=="RnB"]
min_dura_rnb=min(dados$Duration_ms[dados$Genre=="RnB"])
max_dura_rnb=max(dados$Duration_ms[dados$Genre=="RnB"])

#construção gráfico 
boxplot(dura_dark.trap,dura_rap,dura_rnb,
        main="Duartion_ms com base no gênero",
        ylab="Duartion_ms",
        names=c("Duration Dark Trap","Duration Rap","Duration RnB"),
        col = c("steelblue","steelblue2","steelblue4"))

#D)- CORRELAÇÃO ENTRE CARACTERÍSTICAS E "STREAM"----
#calculo das covariancias e correlações
cov_stream_ener=cov(dados$Energy, dados$Stream)
cor_stream_ener=cor(dados$Energy, dados$Stream)

cov_stream_loud=cov(dados$Loudness, dados$Stream)
cor_stream_loud=cor(dados$Loudness, dados$Stream)

cov_stream_spee=cov(dados$Speechiness, dados$Stream)
cor_stream_spee=cor(dados$Speechiness, dados$Stream)

cov_stream_acco=cov(dados$Acousticness, dados$Stream)
cor_stream_acco=cor(dados$Acousticness, dados$Stream)

cov_stream_live=cov(dados$Liveness, dados$Stream)
cor_stream_live=cor(dados$Liveness, dados$Stream)

#valores das correlações e covariancias

cov_stream=rbind(cov_stream_ener,cov_stream_loud,cov_stream_spee,cov_stream_acco,cov_stream_live)
cor_stream=rbind(cor_stream_ener,cor_stream_loud,cor_stream_spee,cor_stream_acco,cor_stream_live)
tabSTREAM=cbind(cov_stream,cor_stream)
colnames(tabSTREAM)=c('Covariância (Carac. vs STREAM','Correlação (Carac. vs STREAM')
rownames(tabSTREAM)=c('Energy','Loudness','Speechiness','Acousticness','Liveness')
View(tabSTREAM)

#construção dos gráficos de correlações 
par(mfrow=c(2,3))
plot(dados$Stream
     ~ dados$Energy,
     main="Correlação entre Stream e Energy",
     xlab = "Energy",
     ylab = "Stream",
     pch = 19,
     col = "steelblue",
     xlim = range(dados$Energy),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Energy),
       col = "steelblue",
       lwd = 3, 
       lty = 1) 

plot(dados$Stream
     ~ dados$Loudness,
     main="Correlação entre Stream e Loudness",
     xlab = "Loudness",
     ylab = "Stream",
     pch = 19,
     col = "steelblue1",
     xlim = range(dados$Loudness),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Loudness),
       col = "steelblue1",
       lwd = 3, 
       lty = 1) 

plot(dados$Stream
     ~ dados$Speechiness,
     main="Correlação entre Stream e Speechiness",
     xlab = "Speechiness",
     ylab = "Stream",
     pch = 19,
     col = "steelblue2",
     xlim = range(dados$Speechiness),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Speechiness),
       col = "steelblue2",
       lwd = 3, 
       lty = 1) 

plot(dados$Stream
     ~ dados$Acousticness,
     main="Correlação entre Stream e Acousticness",
     xlab = "Acousticness",
     ylab = "Stream",
     pch = 19,
     col = "steelblue3",
     xlim = range(dados$Acousticness),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Acousticness),
       col = "steelblue3",
       lwd = 3, 
       lty = 1) 

plot(dados$Stream
     ~ dados$Liveness,
     main="Correlação entre Stream e Liveness",
     xlab = "Liveness",
     ylab = "Stream",
     pch = 19,
     col = "steelblue4",
     xlim = range(dados$Liveness),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Liveness),
       col = "steelblue4",
       lwd = 3, 
       lty = 1) 
par(mfrow=c(1,1))

#E)- RELAÇÃO ENTRE CARACTERÍSTICAS E GENERO, E SUCESSO "STREAM"----
# Sucesso entre Genre e Stream
stream_rap=dados$Stream[dados$Genre=="Rap"]
stream_rnb=dados$Stream[dados$Genre=="RnB"]
stream_darktrap=dados$Stream[dados$Genre=="Dark Trap"]

# Relação entre as caracterisitcas e o genero
ener_rap=dados$Energy[dados$Genre=="Rap"]
ener_rnb=dados$Energy[dados$Genre=="RnB"]
ener_darktrap=dados$Energy[dados$Genre=="Dark Trap"]

loud_rap=dados$Loudness[dados$Genre=="Rap"]
loud_rnb=dados$Loudness[dados$Genre=="RnB"]
loud_darktrap=dados$Loudness[dados$Genre=="Dark Trap"]

spee_rap=dados$Speechiness[dados$Genre=="Rap"]
spee_rnb=dados$Speechiness[dados$Genre=="RnB"]
spee_darktrap=dados$Speechiness[dados$Genre=="Dark Trap"]

acous_rap=dados$Acousticness[dados$Genre=="Rap"]
acous_rnb=dados$Acousticness[dados$Genre=="RnB"]
acous_darktrap=dados$Acousticness[dados$Genre=="Dark Trap"]

live_rap=dados$Liveness[dados$Genre=="Rap"]
live_rnb=dados$Liveness[dados$Genre=="RnB"]
live_darktrap=dados$Liveness[dados$Genre=="Dark Trap"]

# Calculo da correlação e covariância entre o Gênero e o Sucesso
# Energy
cor_streamrap_enerrap=cor(stream_rap, ener_rap)
cov_streamrap_enerrap=cov(stream_rap, ener_rap)

cor_streamrnb_enerrnb=cor(stream_rnb, ener_rnb)
cov_streamrnb_enerrnb=cov(stream_rnb, ener_rnb)

cor_streamtrap_enertrap=cor(stream_darktrap, ener_darktrap)
cov_streamtrap_enertrap=cov(stream_darktrap, ener_darktrap)

# Loudness
cor_streamrap_loudrap=cor(stream_rap, loud_rap)
cov_streamrap_loudrap=cov(stream_rap, loud_rap)

cor_streamrnb_loudrnb=cor(stream_rnb, loud_rnb)
cov_streamrnb_loudrnb=cov(stream_rnb, loud_rnb)

cor_streamtrap_loudtrap=cor(stream_darktrap, loud_darktrap)
cov_streamtrap_loudtrap=cov(stream_darktrap, loud_darktrap)

# Speechness
cor_streamrap_speerap=cor(stream_rap, spee_rap)
cov_streamrap_speerap=cov(stream_rap, spee_rap)

cor_streamrnb_speernb=cor(stream_rnb, spee_rnb)
cov_streamrnb_speernb=cov(stream_rnb, spee_rnb)

cor_streamtrap_speetrap=cor(stream_darktrap, spee_darktrap)
cov_streamtrap_speetrap=cov(stream_darktrap, spee_darktrap)

# Accousticness
cor_streamrap_acousrap=cor(stream_rap, acous_rap)
cov_streamrap_acousrap=cov(stream_rap, acous_rap)

cor_streamrnb_acousrnb=cor(stream_rnb, acous_rnb)
cov_streamrnb_acousrnb=cov(stream_rnb, acous_rnb)

cor_streamtrap_acoustrap=cor(stream_darktrap, acous_darktrap)
cov_streamtrap_acoustrap=cov(stream_darktrap, acous_darktrap)

# Liveness
cor_streamrap_liverap=cor(stream_rap, live_rap)
cov_streamrap_liverap=cov(stream_rap, live_rap)

cor_streamrnb_livernb=cor(stream_rnb, live_rnb)
cov_streamrnb_livernb=cov(stream_rnb, live_rnb)

cor_streamtrap_livetrap=cor(stream_darktrap, live_darktrap)
cov_streamtrap_livetrap=cov(stream_darktrap, live_darktrap)

# Tabelas de Covariância e Correlação 
# TABELA RAP
cov_rap=rbind(cov_streamrap_enerrap,cov_streamrap_loudrap,cov_streamrap_speerap,cov_streamrap_acousrap,cov_streamrap_liverap)
cor_rap=rbind(cor_streamrap_enerrap,cor_streamrap_loudrap,cor_streamrap_speerap,cor_streamrap_acousrap,cor_streamrap_liverap)
tabRAP=cbind(cov_rap,cor_rap)
colnames(tabRAP)=c('Covariância RAP',"Correlação RAP")
rownames(tabRAP)=c("Energy","Loudness","Speechness","Accousticness","Liveness")
View(tabRAP)

# TABELA RNB
cov_rnb=rbind(cov_streamrnb_enerrnb,cov_streamrnb_loudrnb,cov_streamrnb_speernb,cov_streamrnb_acousrnb,cov_streamrnb_livernb)
cor_rnb=rbind(cor_streamrnb_enerrnb,cor_streamrnb_loudrnb,cor_streamrnb_speernb,cor_streamrnb_acousrnb,cor_streamrnb_livernb)
tabRNB=cbind(cov_rnb,cor_rnb)
colnames(tabRNB)=c('Covariância RNB',"Correlação RNB")
rownames(tabRNB)=c("Energy","Loudness","Speechness","Accousticness","Liveness")
View(tabRNB)

# TABELA DARK TRAP
cov_trap=rbind(cov_streamtrap_enertrap,cov_streamtrap_loudtrap,cov_streamtrap_speetrap,cov_streamtrap_acoustrap,cov_streamtrap_livetrap)
cor_trap=rbind(cor_streamtrap_enertrap,cor_streamtrap_loudtrap,cor_streamtrap_speetrap,cor_streamtrap_acoustrap,cor_streamtrap_livetrap)
tabTRAP=cbind(cov_trap,cor_trap)
colnames(tabTRAP)=c('Covariância DARK TRAP',"Correlação DARK TRAP")
rownames(tabTRAP)=c("Energy","Loudness","Speechness","Accousticness","Liveness")
View(tabTRAP)

# Cálculo das estatísticas
quart_stream_rap=quantile(stream_rap)
quart_stream_rnb=quantile(stream_rnb)
quart_stream_darktrap=quantile(stream_darktrap)
media_stream=c(mean(stream_rap),mean(stream_rnb),mean(stream_darktrap))
mediana_stream=c(median(stream_rap),median(stream_rnb),median(stream_darktrap))
max_stream=c(max(stream_rap),max(stream_rnb),max(stream_darktrap))
min_stream=c(min(stream_rap),min(stream_rnb),min(stream_darktrap))
amp_stream=max_stream-min_stream
desv_stream=c(sd(stream_rap),sd(stream_rnb),sd(stream_darktrap))
coef.var_stream=round(((desv_stream/media_stream)*100),2)

#tipo de assimetria
q1_stream_rap=quantile(stream_rap,0.25)
q2_stream_rap=quantile(stream_rap,0.50)
q3_stream_rap=quantile(stream_rap,0.75)
a_stream_rap=q2_stream_rap-q1_stream_rap
b_stream_rap=q3_stream_rap-q2_stream_rap
a_stream_rap
b_stream_rap
b_stream_rap-a_stream_rap
"se a < b, assimetria é à direita (mediana menor que média)"

q1_stream_rnb=quantile(stream_rnb,0.25)
q2_stream_rnb=quantile(stream_rnb,0.50)
q3_stream_rnb=quantile(stream_rnb,0.75)
a_stream_rnb=q2_stream_rnb-q1_stream_rnb
b_stream_rnb=q3_stream_rnb-q2_stream_rnb
a_stream_rnb
b_stream_rnb
b_stream_rnb-a_stream_rnb
"se a < b, assimetria é à direita (mediana menor que média)"

q1_stream_darktrap=quantile(stream_darktrap,0.25)
q2_stream_darktrap=quantile(stream_darktrap,0.50)
q3_stream_darktrap=quantile(stream_darktrap,0.75)
a_stream_darktrap=q2_stream_darktrap-q1_stream_darktrap
b_stream_darktrap=q3_stream_darktrap-q2_stream_darktrap
a_stream_darktrap
b_stream_darktrap
b_stream_darktrap-a_stream_darktrap
"se a < b, assimetria é à direita (mediana menor que média)"

#construção das tabelas
quart_stream=rbind(quart_stream_rap,quart_stream_rnb,quart_stream_darktrap)
tab_quart_stream_genre=cbind(quart_stream)
colnames(tab_quart_stream_genre)=c("Q1","Q2","Q3","Q4","Q5")
rownames(tab_quart_stream_genre)=c("Rap","RnB","Dark Trap")
View(tab_quart_stream_genre)

tab_estat_stream_genre=cbind(media_stream,mediana_stream,min_stream,max_stream,amp_stream,desv_stream,coef.var_stream)
colnames(tab_estat_stream_genre)=c("Média","Mediana","Mínimo","Máximo","Amplitude","Desvio Pdrão","Coef.Var (em %)")
rownames(tab_estat_stream_genre)=c("Rap","RnB","Dark Trap")
View(tab_estat_stream_genre)

#construção dos gráficos
boxplot(stream_rap,stream_rnb,stream_darktrap,main="BoxPlot do Stream de cada gênero",names=c("Rap","RnB","Dark Trap"),
        col = c("steelblue","steelblue2","steelblue4"))


#F)- CORRELAÇÃO ENTRE GÊNERO E ESTILO DE MÚSICA----
par(mfrow=c(1,3))
plot(stream_rap
     ~ ener_rap,
     main="Correlação entre Stream do Rap e Energy do Rap",
     xlab = "Energy do Rap",
     ylab = "Stream do Rap",
     pch = 19,
     col = "steelblue",
     xlim = range(ener_rap),
     ylim = range(stream_rap),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(stream_rap
          ~ ener_rap),
       col = "steelblue",
       lwd = 3, 
       lty = 1) 
reta_enerrap=lm(stream_rap~ ener_rap)
A=coef(reta_enerrap)
a1=A[2]
a2=A[1]
a1
a2

plot(stream_rnb
     ~ spee_rnb,
     main="Correlação entre Stream do RnB e Speechines RnB",
     xlab = "Speechines do RnB",
     ylab = "Stream do RnB",
     pch = 19,
     col = "steelblue1",
     xlim = range(spee_rnb),
     ylim = range(stream_rnb),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(stream_rnb
          ~ spee_rnb),
       col = "steelblue1",
       lwd = 3, 
       lty = 1) 
reta_speernb=lm(stream_rnb~ spee_rnb)
B=coef(reta_speernb)
b1=B[2]
b2=B[1]
b1
b2

plot(stream_darktrap
     ~ spee_darktrap,
     main="Correlação entre Stream do Dark Trap e Speechines Dark Trap",
     xlab = "Speechines do Dark Trap",
     ylab = "Stream do Dark Trap",
     pch = 19,
     col = "steelblue2",
     xlim = range(spee_darktrap),
     ylim = range(stream_darktrap),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(stream_darktrap
          ~ spee_darktrap),
       col = "steelblue2",
       lwd = 3, 
       lty = 1) 
reta_speetrap=lm(stream_darktrap~ spee_darktrap)
C=coef(reta_speetrap)
c1=C[2]
c2=C[1]
c1
c2

#Tabela das equações da reta
coef_ang=rbind(a1,b1,c1)
intercepto=rbind(a2,b2,c2)
tab_eq_ret_f=cbind(coef_ang,intercepto)
colnames(tab_eq_ret_f)=c("Coeficiente Angular","Intercepto")
rownames(tab_eq_ret_f)=c("RAP","RNB","DARK TRAP")
View(tab_eq_ret_f)

par(mfrow=c(1,1))
#G)- SUCESSO "STREAM" DA MÚSICA E O NÚMERO DE LIKES----
like_rap=dados$Likes[dados$Genre=="Rap"]
like_rnb=dados$Likes[dados$Genre=="RnB"]
like_darktrap=dados$Likes[dados$Genre=="Dark Trap"]

#calculo das estatísticas
quart_like_rap=quantile(like_rap)
quart_like_rnb=quantile(like_rnb)
quart_like_darktrap=quantile(like_darktrap)
media_like=c(mean(like_rap),mean(like_rnb),mean(like_darktrap))
mediana_like=c(median(like_rap),median(like_rnb),median(like_darktrap))
max_like=c(max(like_rap),max(like_rnb),max(like_darktrap))
min_like=c(min(like_rap),min(like_rnb),min(like_darktrap))
amp_like=max_like-min_like
desv_like=c(sd(like_rap),sd(like_rnb),sd(like_darktrap))
coef.var_like=round(((desv_like/media_like)*100),2)

#tipo de assimetria
q1_like_rap=quantile(like_rap,0.25)
q2_like_rap=quantile(like_rap,0.50)
q3_like_rap=quantile(like_rap,0.75)
a_like_rap=q2_like_rap-q1_like_rap
b_like_rap=q3_like_rap-q2_like_rap
a_like_rap
b_like_rap
b_like_rap-a_like_rap
"se a < b, assimetria é à direita (mediana menor que média)"

q1_like_rnb=quantile(like_rnb,0.25)
q2_like_rnb=quantile(like_rnb,0.50)
q3_like_rnb=quantile(like_rnb,0.75)
a_like_rnb=q2_like_rnb-q1_like_rnb
b_like_rnb=q3_like_rnb-q2_like_rnb
a_like_rnb
b_like_rnb
b_like_rnb-a_like_rnb
"se a < b, assimetria é à direita (mediana menor que média)"

q1_like_darktrap=quantile(like_darktrap,0.25)
q2_like_darktrap=quantile(like_darktrap,0.50)
q3_like_darktrap=quantile(like_darktrap,0.75)
a_like_darktrap=q2_like_darktrap-q1_like_darktrap
b_like_darktrap=q3_like_darktrap-q2_like_darktrap
a_like_darktrap
b_like_darktrap
b_like_darktrap-a_like_darktrap
"se a < b, assimetria é à direita (mediana menor que média)"

#construção das tabelas
quart_like=rbind(quart_like_rap,quart_like_rnb,quart_like_darktrap)
tab_quart_like_genre=cbind(quart_like)
colnames(tab_quart_like_genre)=c("Q1","Q2","Q3","Q4","Q5")
rownames(tab_quart_like_genre)=c("Rap","RnB","Dark Trap")
View(tab_quart_like_genre)

tab_estat_like_genre=cbind(media_like,mediana_like,min_like,max_like,amp_like,desv_like,coef.var_like)
colnames(tab_estat_like_genre)=c("Média","Mediana","Mínimo","Máximo","Amplitude","Desvio Pdrão","Coef.Var (em %)")
rownames(tab_estat_like_genre)=c("Rap","RnB","Dark Trap")
View(tab_estat_like_genre)

#construção do gráfico
boxplot(like_rap,like_rnb,like_darktrap,main="BoxPlot do like de cada gênero",names=c("Rap","RnB","Dark Trap"),
        col = c("steelblue","steelblue2","steelblue4"))


par(mfrow=c(1,1))

#verificação de valores aberrantes
Q1=c(quantile(like_rap,0.25),quantile(like_rnb,0.25),quantile(like_darktrap,0.25))
Q2=c(quantile(like_rap,0.5),quantile(like_rnb,0.5),quantile(like_darktrap,0.5))
Q3=c(quantile(like_rap,0.75),quantile(like_rnb,0.75),quantile(like_darktrap,0.75))
IQ=Q3-Q1
MaxMin=c(diff(range(like_rap)), diff(range(like_rnb)),diff(range(like_darktrap)))
a=Q2-Q1
b=Q3-Q2
Q1_IQ=Q1-1.5*IQ
Q3_IQ=Q3-1.5*IQ

outliers=rbind(Q1,MaxMin,a,b,Q1_IQ,Q3_IQ)
rownames(outliers)=c("Q3-Q1","Max - Min","a","b","Q1-1,5IQ","Q3+1,5IQ")
colnames(outliers)=c("Rap","RnB","Dark Trap")
View(outliers)

#H)- Correlação entre Stream E Likes ----

#Calculo da Correlação e Covarância
cor_stream_like=cor(dados$Likes,dados$Stream)
cov_stream_like=cov(dados$Likes,dados$Stream)

#construção das tabelas
tab_stream_like=cbind(cor_stream_like,cov_stream_like)
colnames(tab_stream_like)=c("Correlação do Stream com Likes","Covariância do Stream com Likes")
rownames(tab_stream_like)="Valores"
View(tab_stream_like)

#construção dos gráficos
plot(dados$Stream
     ~ dados$Likes,
     main="Correlação entre Stream e Likes",
     xlab = "Likes",
     ylab = "Stream",
     pch = 19,
     col = "steelblue",
     xlim = range(dados$Likes),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Likes),
       col = "steelblue",
       lwd = 3, 
       lty = 1) 
reta_stream_like=lm(dados$Stream~dados$Likes)
D=coef(reta_stream_like)
d1=D[2]
d2=D[1]
d1
d2
#Tabela das equações da reta
tab_eq_ret_g=cbind(d1,d2)
colnames(tab_eq_ret_g)=c("Coeficiente Angular","Intercepto")
rownames(tab_eq_ret_g)="Valores"
View(tab_eq_ret_g)

#I)-Correlçao entre Views E Stream ----

#Calculo da Correlação e Covarância
cor_stream_views=cor(dados$Views,dados$Stream)
cov_stream_views=cov(dados$Views,dados$Stream)

#construção das tabelas
tab_stream_views=cbind(cor_stream_views,cov_stream_views)
colnames(tab_stream_views)=c("Correlação do Stream com Views","Covariância do Stream com Views")
rownames(tab_stream_views)="Valores"
View(tab_stream_views)

#construção dos gráficos
plot(dados$Stream
     ~ dados$Views,
     main="Correlação entre Stream e Views",
     xlab = "Views",
     ylab = "Stream",
     pch = 19,
     col = "steelblue",
     xlim = range(dados$Views),
     ylim = range(dados$Stream),
     cex.main = 1.15, cex.lab = 1.10)
abline(lm(dados$Stream
          ~ dados$Views),
       col = "steelblue",
       lwd = 3, 
       lty = 1) 
reta_Stream_views=lm(dados$Stream~dados$Views)
E=coef(reta_Stream_views)
e1=E[2]
e2=E[1]
e1
e2

#Tabela das equações da reta
tab_eq_ret_i=cbind(e1,e2)
colnames(tab_eq_ret_i)=c("Coeficiente Angular","Intercepto")
rownames(tab_eq_ret_i)="Valores"
View(tab_eq_ret_i)
