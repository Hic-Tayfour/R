#1- Bibliotecas----
library(readxl)
library(ggplot2)
library(GGally)
library(gridExtra)
library(whitestrap)
library(tseries)
library(dplyr)
library(tidyverse)
library(moments)
library(DescTools)
library(DT)
library(dplyr)
library(maps)

#2 - Importando base de dados----
Dados <- read_excel("APS econo.xlsx")

#3 - Análise de Dados no Geral----
#3.1 - Variáveis Quantitativas----
Hom <- Dados$Hom
Guns <- Dados$Guns
IpC <- Dados$IpC
Urb  <- Dados$Urb 
Poli <- Dados$Poli
Gini <- Dados$Gini

#3.2 - Variáveis Qualitativas----
Lice <- Dados$Lice

#3.3 - Análise Descritiva----
media <- c(round(mean(Hom), 2), round(mean(Guns), 2), round(mean(IpC), 2), round(mean(Urb ), 2), round(mean(Poli), 2), round(mean(Gini), 2))
mediana <- c(round(median(Hom), 2), round(median(Guns), 2), round(median(IpC), 2), round(median(Urb ), 2), round(median(Poli), 2), round(median(Gini), 2))
maximo <- c(round(max(Hom), 2), round(max(Guns), 2), round(max(IpC), 2), round(max(Urb ), 2), round(max(Poli), 2), round(max(Gini), 2))
minimo <- c(round(min(Hom), 2), round(min(Guns), 2), round(min(IpC), 2), round(min(Urb ), 2), round(min(Poli), 2), round(min(Gini), 2))
variancia <- c(round(var(Hom), 2), round(var(Guns), 2), round(var(IpC), 2), round(var(Urb ), 2), round(var(Poli), 2), round(var(Gini), 2))
desv_pad <- c(round(sd(Hom), 2), round(sd(Guns), 2), round(sd(IpC), 2), round(sd(Urb ), 2), round(sd(Poli), 2), round(sd(Gini), 2))

tab_desc <- cbind(media, mediana, maximo, minimo, variancia, desv_pad)
rownames(tab_desc) <- c("Homicídio por 100.000", "Armas por 100.000", "Pib Per Capita", "Taxa de Urb anização", "Polícias por 100.000", "Desigualdade")
colnames(tab_desc) <- c("Média", "Mediana", "Máximo", "Mínimo", "Variância", "Desvio Padrão")

View(tab_desc)
datatable(tab_desc)

#3.4 - Análise de Correlação----
Cor <- round(cor(Dados[, -1]),2)
datatable(Cor)

#3.5 - Gráficos----
#3.5.1 - Histograma----
h1 <- ggplot(Dados, aes(x = Hom)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Homicídio por 100.000", x = "Homicídio por 100.000", y = "Densidade") +
  theme_minimal()

h2 <- ggplot(Dados, aes(x = Guns)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Armas por 100.000", x = "Armas por 100.000", y = "Densidade") +
  theme_minimal()

h3 <- ggplot(Dados, aes(x = IpC)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Pib Per Capita", x = "Pib Per Capita", y = "Densidade") +
  theme_minimal()

h4 <- ggplot(Dados, aes(x = Urb )) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Taxa de Urb anização", x = "Taxa de Urb anização", y = "Densidade") +
  theme_minimal()

h5 <- ggplot(Dados, aes(x = Poli)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Polícias por 100.000", x = "Polícias por 100.000", y = "Densidade") +
  theme_minimal()

h6 <- ggplot(Dados, aes(x = Gini)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Desigualdade", x = "Desigualdade", y = "Densidade") +
  theme_minimal()

grid.arrange(h1, h2, h3, h4, h5, h6, ncol = 3, top = "Histogramas dos Dados")

#3.5.2 - Boxplot----
b1 <- ggplot(Dados, aes(x = "", y = Hom)) +
  geom_boxplot(fill = "steelblue2") +
  labs(title = "Homicídio por 100.000", x = "", y = "Homicídio por 100.000") +
  theme_minimal()

b2 <- ggplot(Dados, aes(x = "", y = Guns)) +
  geom_boxplot(fill = "steelblue2") +
  labs(title = "Armas por 100.000", x = "", y = "Armas por 100.000") +
  theme_minimal()

b3 <- ggplot(Dados, aes(x = "", y = IpC)) +
  geom_boxplot(fill = "steelblue2") +
  labs(title = "Pib Per Capita", x = "", y = "Pib Per Capita") +
  theme_minimal()

b4 <- ggplot(Dados, aes(x = "", y = Urb )) +
  geom_boxplot(fill = "steelblue2") +
  labs(title = "Taxa de Urb anização", x = "", y = "Taxa de Urb anização") +
  theme_minimal()

b5 <- ggplot(Dados, aes(x = "", y = Poli)) +
  geom_boxplot(fill = "steelblue2") +
  labs(title = "Polícias por 100.000", x = "", y = "Polícias por 100.000") +
  theme_minimal()

b6 <- ggplot(Dados, aes(x = "", y = Gini)) +
  geom_boxplot(fill = "steelblue2") +
  labs(title = "Desigualdade", x = "", y = "Desigualdade") +
  theme_minimal()

grid.arrange(b1, b2, b3, b4, b5, b6, ncol = 3, top = "Boxplot dos Dados")

#3.6 - Outliers e de Qual State----
# Homicídio por 100.000
outliers_Hom <- boxplot.stats(Dados$Hom)$out
outliers_Hom

states_of_outliers_Hom<- Dados$State[ Dados$Hom %in% outliers_Hom]
states_of_outliers_Hom


# Armas por 100.000
outliers_Guns <- boxplot.stats(Dados$Guns)$out
outliers_Guns

states_of_outliers_Guns <- Dados$State[ Dados$Guns %in% outliers_Guns]
states_of_outliers_Guns

# Pib Per Capita
outliers_IpC <- boxplot.stats(Dados$IpC)$out
outliers_IpC

states_of_outliers_IpC <- Dados$State[ Dados$IpC %in% outliers_IpC]
states_of_outliers_IpC

#3.7 - Boxplot das Armas sem os outliers----
dados_sem_outliers <- Dados[!(Dados$State %in% c("Alaska", "Louisiana", "Mississippi", "New Mexico")),]

b7 <- ggplot(dados_sem_outliers, aes(x = "", y = Guns)) + geom_boxplot(fill = "steelblue2") + labs(title = "Armas por 100.000", x = "", y = "Armas por 100.000") + theme_minimal()

grid.arrange(b2 , b7, ncol = 2, top = "Comparação dos Boxplot das Armas com e sem Outliers")

#4 - Base sem Licença = 0 (não tem Liceença)----
Dados_s <- Dados[Lice == 0,]
Hom_s <- Dados$Hom[Lice == 0]
Guns_s <- Dados$Guns[Lice == 0]
IpC_s <- Dados$IpC[Lice == 0]
Urb_s <- Dados$Urb [Lice == 0]
Poli_s <- Dados$Poli[Lice == 0]
Gini_s <- Dados$Gini[Lice == 0]

#4.1 - Estatísticas Descritivas----
media_s <- c(round(mean(Hom_s), 2), round(mean(Guns_s), 2), round(mean(IpC_s), 2), round(mean(Urb_s), 2), round(mean(Poli_s), 2), round(mean(Gini_s), 2))
mediana_s <- c(round(median(Hom_s), 2), round(median(Guns_s), 2), round(median(IpC_s), 2), round(median(Urb_s), 2), round(median(Poli_s), 2), round(median(Gini_s), 2))
maximo_s <- c(round(max(Hom_s), 2), round(max(Guns_s), 2), round(max(IpC_s), 2), round(max(Urb_s), 2), round(max(Poli_s), 2), round(max(Gini_s), 2))
minimo_s <- c(round(min(Hom_s), 2), round(min(Guns_s), 2), round(min(IpC_s), 2), round(min(Urb_s), 2), round(min(Poli_s), 2), round(min(Gini_s), 2))
variancia_s <- c(round(var(Hom_s), 2), round(var(Guns_s), 2), round(var(IpC_s), 2), round(var(Urb_s), 2), round(var(Poli_s), 2), round(var(Gini_s), 2))
desv_pad_s <- c(round(sd(Hom_s), 2), round(sd(Guns_s), 2), round(sd(IpC_s), 2), round(sd(Urb_s), 2), round(sd(Poli_s), 2), round(sd(Gini_s), 2))

tab_desc_s <- cbind(media_s, mediana_s, maximo_s, minimo_s, variancia_s, desv_pad_s)
rownames(tab_desc_s) <- c("Homicídio por 100.000", "Armas por 100.000", "Pib Per Capita", "Taxa de Urb anização", "Polícias por 100.000", "Desigualdade")
colnames(tab_desc_s) <- c("Média", "Mediana", "Máximo", "Mínimo", "Variância", "Desvio Padrão")

datatable(tab_desc_s)

#4.3 - Análise de Correlação----
Cor_s <- round(cor(Dados_s[, -1]),2)
datatable(Cor_s)

#4.4 - Gráficos----
#4.4.1 - Histograma----
h1_s <- ggplot(Dados_s, aes(x = Hom_s)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Homicídio por 100.000", x = "Homicídio por 100.000", y = "Densidade") +
  theme_minimal()

h2_s <- ggplot(Dados_s, aes(x = Guns_s)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Armas por 100.000", x = "Armas por 100.000", y = "Densidade") +
  theme_minimal()

h3_s <- ggplot(Dados_s, aes(x = IpC_s)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Pib Per Capita", x = "Pib Per Capita", y = "Densidade") +
  theme_minimal()

h4_s <- ggplot(Dados_s, aes(x = Urb_s)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Taxa de Urb anização", x = "Taxa de Urb anização", y = "Densidade") +
  theme_minimal()

h5_s <- ggplot(Dados_s, aes(x = Poli_s)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Polícias por 100.000", x = "Polícias por 100.000", y = "Densidade") +
  theme_minimal()

h6_s <- ggplot(Dados_s, aes(x = Gini_s)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Desigualdade", x = "Desigualdade", y = "Densidade") +
  theme_minimal()

grid.arrange(h1_s, h2_s, h3_s, h4_s, h5_s, h6_s, ncol = 3, top = "Histograma dos Dados que não tem Licença")

#4.4.2 - Boxplot----
b1_s <- ggplot(Dados_s, aes(x = "", y = Hom_s)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Homicídio por 100.000", x = "Licença", y = "Homicídio por 100.000") +
  theme_minimal()

b2_s <- ggplot(Dados_s, aes(x = "", y = Guns_s)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Armas por 100.000", x = "Licença", y = "Armas por 100.000") +
  theme_minimal()

b3_s <- ggplot(Dados_s, aes(x = "", y = IpC_s)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Pib Per Capita", x = "Liceença", y = "Pib Per Capita") +
  theme_minimal()

b4_s <- ggplot(Dados_s, aes(x = "", y = Urb_s)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Taxa de Urb anização", x = "Licença", y = "Taxa de Urb anização") +
  theme_minimal()

b5_s <- ggplot(Dados_s, aes(x = "", y = Poli_s)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Polícias por 100.000", x = "Licença", y = "Polícias por 100.000") +
  theme_minimal()

b6_s <- ggplot(Dados_s, aes(x = "", y = Gini_s)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Desigualdade", x = "Licença", y = "Desigualdade") +
  theme_minimal()

grid.arrange(b1_s, b2_s, b3_s, b4_s, b5_s, b6_s, ncol = 3, top = "Boxplot dos Dados que não tem Licença")

#4.5 - Outliers----
# Homicidio
outliers_Hom_s <- boxplot.stats(Hom_s)$out
outliers_Hom_s

state_Hom_s <- Dados_s$State[Hom_s %in% outliers_Hom_s]
state_Hom_s

# Armas
outliers_Guns_s <- boxplot.stats(Guns_s)$out
outliers_Guns_s

state_Guns_s <- Dados_s$State[Guns_s %in% outliers_Guns_s]
state_Guns_s

# Pib Per Capita
outliers_IpC_s <- boxplot.stats(IpC_s)$out
outliers_IpC_s

state_IpC_s <- Dados_s$State[IpC_s %in% outliers_IpC_s]
state_IpC_s

# Taxa de Urbanização
outliers_Urb_s <- boxplot.stats(Urb_s)$out
outliers_Urb_s

state_Urb_s <- Dados_s$State[Urb_s %in% outliers_Urb_s]
state_Urb_s

#5 - Base com Licença = 1 (tem Licença)----
Dados_c <- Dados[Lice == 1, ]
Hom_c <- Dados$Hom[Lice == 1]
Guns_c <- Dados$Guns[Lice == 1]
IpC_c <- Dados$IpC[Lice == 1]
Urb_c <- Dados$Urb [Lice == 1]
Poli_c <- Dados$Poli[Lice == 1]
Gini_c <- Dados$Gini[Lice == 1]

#5.1 - Estatísticas Descritivas----
media_c <- c(round(mean(Hom_c), 2), round(mean(Guns_c), 2), round(mean(IpC_c), 2), round(mean(Urb_c), 2), round(mean(Poli_c), 2), round(mean(Gini_c), 2))
mediana_c <- c(round(median(Hom_c), 2), round(median(Guns_c), 2), round(median(IpC_c), 2), round(median(Urb_c), 2), round(median(Poli_c), 2), round(median(Gini_c), 2))
maximo_c <- c(round(max(Hom_c), 2), round(max(Guns_c), 2), round(max(IpC_c), 2), round(max(Urb_c), 2), round(max(Poli_c), 2), round(max(Gini_c), 2))
minimo_c <- c(round(min(Hom_c), 2), round(min(Guns_c), 2), round(min(IpC_c), 2), round(min(Urb_c), 2), round(min(Poli_c), 2), round(min(Gini_c), 2))
variancia_c <- c(round(var(Hom_c), 2), round(var(Guns_c), 2), round(var(IpC_c), 2), round(var(Urb_c), 2), round(var(Poli_c), 2), round(var(Gini_c), 2))
desv_pad_c <- c(round(sd(Hom_c), 2), round(sd(Guns_c), 2), round(sd(IpC_c), 2), round(sd(Urb_c), 2), round(sd(Poli_c), 2), round(sd(Gini_c), 2))

tab_desc_c <- cbind(media_c, mediana_c, maximo_c, minimo_c, variancia_c, desv_pad_c)
rownames(tab_desc_c) <- c("Homicídio por 100.000", "Armas por 100.000", "Pib Per Capita", "Taxa de Urb anização", "Polícias por 100.000", "Desigualdade")
colnames(tab_desc_c) <- c("Média", "Mediana", "Máximo", "Mínimo", "Variância", "Desvio Padrão")

datatable(tab_desc_c)

#5.2 - Correlações----
Cor_c <- cor(Dados_c[, -1])
datatable(Cor_c)

#5.3 - Gráficos----
#5.3.1 - Histograma----
h1_c <- ggplot(Dados_c, aes(x = Hom_c)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Homicídio por 100.000", x = "Homicídio por 100.000", y = "Densidade") +
  theme_minimal()

h2_c <- ggplot(Dados_c, aes(x = Guns_c)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Armas por 100.000", x = "Armas por 100.000", y = "Densidade") +
  theme_minimal()

h3_c <- ggplot(Dados_c, aes(x = IpC_c)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Pib Per Capita", x = "Pib Per Capita", y = "Densidade") +
  theme_minimal()

h4_c <- ggplot(Dados_c, aes(x = Urb_c)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Taxa de Urb anização", x = "Taxa de Urb anização", y = "Densidade") +
  theme_minimal()

h5_c <- ggplot(Dados_c, aes(x = Poli_c)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Polícias por 100.000", x = "Polícias por 100.000", y = "Densidade") +
  theme_minimal()

h6_c <- ggplot(Dados_c, aes(x = Gini_c)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue2", color = "black") +
  geom_density(alpha = 0.2, fill = "gray2") +
  labs(title = "Desigualdade", x = "Desigualdade", y = "Densidade") +
  theme_minimal()

grid.arrange(h1_c, h2_c, h3_c, h4_c, h5_c, h6_c, ncol = 3, top = "Histograma dos Dados que tem Licença")

#5.3.2 - Boxplot----
b1_c <- ggplot(Dados_c, aes(x = "", y = Hom_c)) +
  geom_boxplot(fill = "steelblue2", color = "black") +  
  labs(title = "Homicídio por 100.000", x = "Homicídio por 100.000", y = "Homicídio por 100.000") +
  theme_minimal()

b2_c <- ggplot(Dados_c, aes(x = "", y = Guns_c)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Armas por 100.000", x = "Armas por 100.000", y = "Armas por 100.000") +
  theme_minimal()

b3_c <- ggplot(Dados_c, aes(x = "", y = IpC_c)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Pib Per Capita", x = "Pib Per Capita", y = "Pib Per Capita") +
  theme_minimal()

b4_c <- ggplot(Dados_c, aes(x = "", y = Urb_c)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Taxa de Urb anização", x = "Taxa de Urb anização", y = "Taxa de Urb anização") +
  theme_minimal()

b5_c <- ggplot(Dados_c, aes(x = "", y = Poli_c)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Polícias por 100.000", x = "Polícias por 100.000", y = "Polícias por 100.000") +
  theme_minimal()

b6_c <- ggplot(Dados_c, aes(x = "", y = Gini_c)) +
  geom_boxplot(fill = "steelblue2", color = "black") +
  labs(title = "Desigualdade", x = "Desigualdade", y = "Desigualdade") +
  theme_minimal()

grid.arrange(b1_c, b2_c, b3_c, b4_c, b5_c, b6_c, ncol = 3, top = "Boxplot dos Dados que tem Licença")

#5.4 - Outliers----
# Armas
outliers_Guns_c <- boxplot.stats(Guns_c)$out
outliers_Guns_c

state_Guns_c <- Dados_s$State[Guns_c %in% outliers_Guns_c]
state_Guns_c

#6 - Matrizes de Dados e Gráficos----
ggpairs(subset(Dados, select = -c(State)), 
        title = "Matriz de Dispersão, Distribuição e Correlação")

pairs(subset(Dados, select = -c(State)))
pairs(subset(Dados_s, select = -c(State)))
pairs(subset(Dados_c, select = -c(State)))

#7 - Ln dos Dados----
Ln_Hom <- log(Dados$Hom)
Ln_Guns <- log(Dados$Guns)
Ln_IpC <- log(Dados$IpC)
Ln_Urb <- log(Dados$Urb)
Ln_Poli <- log(Dados$Poli)
Ln_Gini <- log(Dados$Gini)

Ln_Dados <- data.frame(Dados$State ,Ln_Hom, Ln_Guns, Ln_IpC, Ln_Urb, Ln_Poli, Ln_Gini)
colnames(Ln_Dados) <- c("State", "Ln_Hom", "Ln_Guns", "Ln_IpC", "Ln_Urb", "Ln_Poli", "Ln_Gini")

#7.1 - Matriz de Dados dos Ln----
ggpairs(subset(Ln_Dados, select = -c(State)), 
        title = "Matriz de Dispersão, Distribuição e Correlação em Ln")
pairs(subset(Ln_Dados, select = -c(State)))

#8 - Dispersão entre Hom e todas as Outras----
#8.1 - Dispersão entre Hom e todas as Outras Normais----
d1 <- ggplot(Dados, aes(x = Guns, y = Hom)) +
  geom_point() +
  labs(title = "Armas por 100.000 vs Homicídio por 100.000", x = "Armas por 100.000", y = "Homicídio por 100.000") +
  theme_minimal()

d2 <- ggplot(Dados, aes(x = IpC, y = Hom)) +
  geom_point() +
  labs(title = "Pib Per Capita vs Homicídio por 100.000", x = "Pib Per Capita", y = "Homicídio por 100.000") +
  theme_minimal()

d3 <- ggplot(Dados, aes(x = Urb, y = Hom)) +
  geom_point() +
  labs(title = "Taxa de Urbanização vs Homicídio por 100.000", x = "Taxa de Urbanização", y = "Homicídio por 100.000") +
  theme_minimal()

d4 <- ggplot(Dados, aes(x = Poli, y = Hom)) +
  geom_point() +
  labs(title = "Polícias por 100.000 vs Homicídio por 100.000", x = "Polícias por 100.000", y = "Homicídio por 100.000") +
  theme_minimal()

d5 <- ggplot(Dados, aes(x = Gini, y = Hom)) +
  geom_point() +
  labs(title = "Desigualdade vs Homicídio por 100.000", x = "Desigualdade", y = "Homicídio por 100.000") +
  theme_minimal()

grid.arrange(d1, d2, d3, d4, d5, ncol = 3, top = "Gráfico de Dispersão do Homicídio por 100.000 contra todas")

#8.1.1 - Dispersão sem outliers----

#8.2 - Dispersão entre Hom e todas as Outras Ln----
d1_ln <- ggplot(Ln_Dados, aes(x = Ln_Guns, y = Ln_Hom)) +
  geom_point() +
  labs(title = "Armas por 100.000(Ln) vs Homicídio por 100.000 (Ln)", x = "Armas por 100.000(Ln)", y = "Homicídio por 100.000(Ln)") +
  theme_minimal()

d2_ln <- ggplot(Ln_Dados, aes(x = Ln_IpC, y = Ln_Hom)) +
  geom_point() +
  labs(title = "Pib Per Capita(Ln) vs Homicídio por 100.000 (Ln)", x = "Pib Per Capita(Ln)", y = "Homicídio por 100.000(Ln)") +
  theme_minimal()

d3_ln <- ggplot(Ln_Dados, aes(x = Ln_Urb, y = Ln_Hom)) +
  geom_point() +
  labs(title = "Taxa de Urbanização(Ln) vs Homicídio por 100.000 (Ln)", x = "Taxa de Urbanização(Ln)", y = "Homicídio por 100.000(Ln)") +
  theme_minimal()

d4_ln <- ggplot(Ln_Dados, aes(x = Ln_Poli, y = Ln_Hom)) +
  geom_point() +
  labs(title = "Polícias por 100.000(Ln) vs Homicídio por 100.000 (Ln)", x = "Polícias por 100.000(Ln)", y = "Homicídio por 100.000(Ln)") +
  theme_minimal()

d5_ln <- ggplot(Ln_Dados, aes(x = Ln_Gini, y = Ln_Hom)) +
  geom_point() +
  labs(title = "Desigualdade(Ln) vs Homicídio por 100.000 (Ln)", x = "Desigualdade(Ln)", y = "Homicídio por 100.000(Ln)") +
  theme_minimal()

grid.arrange(d1_ln, d2_ln, d3_ln, d4_ln, d5_ln, ncol = 3, top = "Gráfico de Dispersão do Homicídio por 100.000(Ln) contra todas(ln)")

#9 - Mapa de Calor----
correspondencia <- c("alabama" = "alabama", 
                     "alasca" = "alaska", 
                     "arizona" = "arizona", 
                     "arkansas" = "arkansas", 
                     "califórnia" = "california", 
                     "colorado" = "colorado", 
                     "connecticut" = "connecticut", 
                     "delaware" = "delaware", 
                     "flórida" = "florida", 
                     "geórgia" = "georgia", 
                     "havaí" = "hawaii", 
                     "idaho" = "idaho", 
                     "illinois" = "illinois", 
                     "indiana" = "indiana", 
                     "iowa" = "iowa", 
                     "kansas" = "kansas", 
                     "kentucky" = "kentucky", 
                     "louisiana" = "louisiana", 
                     "maine" = "maine", 
                     "maryland" = "maryland", 
                     "massachusetts" = "massachusetts", 
                     "michigan" = "michigan", 
                     "minnesota" = "minnesota", 
                     "mississippi" = "mississippi", 
                     "missouri" = "missouri", 
                     "montana" = "montana", 
                     "nebraska" = "nebraska", 
                     "nevada" = "nevada", 
                     "new hampshire" = "new hampshire", 
                     "nova jersey" = "new jersey", 
                     "novo méxico" = "new mexico", 
                     "nova iorque" = "new york", 
                     "carolina do norte" = "north carolina", 
                     "dakota do norte" = "north dakota", 
                     "ohio" = "ohio", 
                     "oklahoma" = "oklahoma", 
                     "oregon" = "oregon", 
                     "pensilvânia" = "pennsylvania", 
                     "rhode island" = "rhode island", 
                     "carolina do sul" = "south carolina", 
                     "dakota do sul" = "south dakota", 
                     "tennessee" = "tennessee", 
                     "texas" = "texas", 
                     "utah" = "utah", 
                     "vermont" = "vermont", 
                     "virgínia" = "virginia", 
                     "washington" = "washington", 
                     "virgínia ocidental" = "west virginia", 
                     "wisconsin" = "wisconsin", 
                     "wyoming" = "wyoming")

Dados$State <- correspondencia

estados_unidos <- map_data("state")

estados_unidos <- left_join(estados_unidos, Dados, by = c("region" = "State"))

estados_unidos <- estados_unidos[!is.na(estados_unidos$Hom), ]

ggplot(estados_unidos, aes(x = long, y = lat, group = group, fill = Hom)) +
  geom_polygon(color = "black") +
  coord_map() +
  scale_fill_gradient(low = "blue", high = "red") +
  ggtitle("Mapa de Calor dos Homicídeos nos Estados Unidos")


