#APS 2 2023.2 Estatística 2
"Estudo sobre pesquisas de preços dos produtos orgânicos, dado diferentes textos motivadores de resposta"

#Grupo----
"
Beatriz Emi Ueda               (beatrizeu@al.insper.edu.br)					
Beatriz Fernandes da Silva      (beatrizfs1@al.insper.edu.br)					
Gabriela Abib                    (gabrielaa6@al.insper.edu.br)					
Hicham Munir Tayfour             (hichamt@al.insper.edu.br)					
Raynnara Silva de Freitas Gurgel (raynnarasf@al.insper.edu.br)
"
#Bibliotecas Usadas----
library(readxl)
library(DescTools)
library(moments)

#Importação dos dados----
prodorg <- read_excel("APS2023_2(1).xlsx")
View(prodorg)

#Seprando respostas pelos tipos de texto usado e por turma
texto_1 <- prodorg[prodorg$Texto==1,]
texto_2 <- prodorg[prodorg$Texto==2,]

texto_1_A <- prodorg[prodorg$Texto==1 & prodorg$Turma=="A",]
texto_2_A <- prodorg[prodorg$Texto==2 & prodorg$Turma=="A",]

texto_1_B <- prodorg[prodorg$Texto==1 & prodorg$Turma=="B",]
texto_2_B <- prodorg[prodorg$Texto==2 & prodorg$Turma=="B",]

texto_1_C <- prodorg[prodorg$Texto==1 & prodorg$Turma=="C",]
texto_2_C <- prodorg[prodorg$Texto==2 & prodorg$Turma=="C",]

texto_1_D <- prodorg[prodorg$Texto==1 & prodorg$Turma=="D",]
texto_2_D <- prodorg[prodorg$Texto==2 & prodorg$Turma=="D",]

"Conclusão: As turmas 'A' e 'B' ficaram responsáveis pelo texto do Tipo 1
            Enquanto as turmas 'C' e 'D' ficaram responsáveis pelo texto do Tipo 2"
rm(list = c("texto_2_A", "texto_2_B", "texto_1_C", "texto_1_D"))

#Tratando os dados----
"Houve um preenchimento incorreto das respostas, seja na formulação do formulário ou na passagem das respostas para o Excel. Com a finalidade de obter uma resposta mais acertiva, teremos que corrigir os dados de acordo com os padrões pré-estabelecidos"

#Dados do Texto 1 da Turma A----
sort(unique(texto_1_A$P2))
texto_1_A$P2 <- gsub('1. Concordo com a frase|Concordo com a frase', '1', texto_1_A$P2)
texto_1_A$P2 <- gsub('2. Sou indiferente à frase|Sou indiferente à frase', '2', texto_1_A$P2)
texto_1_A$P2 <- gsub('Discordo com a frase', '3', texto_1_A$P2)

sort(unique(texto_1_A$P3))
texto_1_A$P3 <- gsub('1. Masculino|Masculino', '1', texto_1_A$P3)
texto_1_A$P3 <- gsub('2. Feminino|Feminino', '2', texto_1_A$P3)

sort(unique(texto_1_A$P5))
texto_1_A$P5 <- gsub('1. Até ensino fundamental completo', '1', texto_1_A$P5)
texto_1_A$P5 <- gsub('2. Até ensino médio completo|Até o ensino médio completo', '2', texto_1_A$P5)
texto_1_A$P5 <- gsub('3. Pelo menos ensino superior completo|Pelo menos ensino superior completo', '3', texto_1_A$P5)

#Dados do Texto 1 da Turma B----
sort(unique(texto_1_B$P2))
texto_1_B$P2 <- gsub('Concordo com a frase', '1', texto_1_B$P2)
texto_1_B$P2 <- gsub('Sou indiferente à frase', '2', texto_1_B$P2)
texto_1_B$P2 <- gsub('Discordo com a frase', '3', texto_1_B$P2)

sort(unique(texto_1_B$P3))
texto_1_B$P3 <- gsub('Masculino', '1', texto_1_B$P3)
texto_1_B$P3 <- gsub('Feminino', '2', texto_1_B$P3)
texto_1_B$P3 <- gsub('Prefiro não dizer|Prefiro não informar', '3', texto_1_B$P3)

sort(unique(texto_1_B$P5))
texto_1_B$P5 <- gsub('Até ensino fundamental completo', '1', texto_1_B$P5)
texto_1_B$P5 <- gsub('Até ensino médio completo', '2', texto_1_B$P5)
texto_1_B$P5 <- gsub('Pelo menos ensino superior completo|Pelo menos ensino superior completo.', '3', texto_1_B$P5)

#Dados do Texto 2 da Turma C----
sort(unique(texto_2_C$P2))
texto_2_C$P2 <- gsub('Concordo com a frase', '1', texto_2_C$P2)
texto_2_C$P2 <- gsub('Sou indiferente a frase|Sou indiferente à frase', '2', texto_2_C$P2)
texto_2_C$P2 <- gsub('Discordo com a frase', '3', texto_2_C$P2)

sort(unique(texto_2_C$P3))
texto_2_C$P3 <- gsub('Masculino', '1', texto_2_C$P3)
texto_2_C$P3 <- gsub('Feminino', '2', texto_2_C$P3)
texto_2_C$P3 <- gsub('Prefiro não informar', '3', texto_2_C$P3)

sort(unique(texto_2_C$P5))
texto_2_C$P5 <- gsub('Até ensino fundamental completo|Até o ensino fundamental completo', '1', texto_2_C$P5)
texto_2_C$P5 <- gsub('Até ensino médio completo|Até o ensino médio completo', '2', texto_2_C$P5)
texto_2_C$P5 <- gsub('pelo menos ensino superior completo|Pelo menos ensino superior completo.', '3', texto_2_C$P5)

#Dados do Texto 2 da Turma D----
sort(unique(texto_2_D$P2))
texto_2_D$P2 <- gsub('Concordo com a frase|Concordo|Concordo com a frase \\(1\\)|1 \\(1\\)', '1', texto_2_D$P2)
texto_2_D$P2 <- gsub('Sou indiferente à frase|Sou indiferente à frase \\(2\\)|Indiferente|2 \\(2\\)', '2', texto_2_D$P2)
texto_2_D$P2 <- gsub('Discordo com a frase|Discordo com a frase \\(3\\)|3 \\(3\\)', '3', texto_2_D$P2)

sort(unique(texto_2_D$P3))
texto_2_D$P3 <- gsub('Masculino|Masculino \\(1\\)', '1', texto_2_D$P3)
texto_2_D$P3 <- gsub('Feminino|Feminino \\(2\\)', '2', texto_2_D$P3)
texto_2_D$P3 <- gsub('Prefiro não dizer|Prefiro não informar \\(3\\)', '3', texto_2_D$P3)

sort(unique(texto_2_D$P5))
texto_2_D$P5 <- gsub('Até ensino fundamental completo|Até o ensino fundamental completo \\(1\\)', '1', texto_2_D$P5)
texto_2_D$P5 <- gsub('Até ensino médio completo|Até ensino médio completo \\(2\\)', '2', texto_2_D$P5)
texto_2_D$P5 <- gsub('Pelo menos ensino superior completo|Pelo menos ensino superior completo \\(3\\)', '3', texto_2_D$P5)

