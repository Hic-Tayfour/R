# Importando as Bibliotecas Necessárias ----
library(tidyverse)      # manipulação de dados
library(stargazer)      # tabelas de regressão
library(gt)             # tabelas personalizadas
library(survey)         # dados amostrais
library(sandwich)       # erros padrão robustos
library(lmtest)         # testes de hipótese
library(ggthemes)       # temas para gráficos
library(margins)        # efeitos marginais
library(readxl)         # leitura de arquivos excel
library(microdatasus)   # acesso a microdados do DataSUS

minf <- data.frame()
ninf <- data.frame()

geo <- read_excel("CADMUN.xls") %>%
  mutate(
    MICROCOD = as.character(MICROCOD),
    MSAUDCOD = as.character(MSAUDCOD),
    UF = substr(MICROCOD, 1, 2), 
    MUNNOME = ifelse(
      str_detect(MUNNOME, "Município ignorado - "),
      str_extract(MUNNOME, "\\b[A-Z]{2}$"), 
      MUNNOME  
    )
  ) %>%
  select(MUNNOME, MICROCOD, MSAUDCOD, UF, LATITUDE, LONGITUDE)

processar_dados <- function(db, geo, col_cod) {
  db %>%
    mutate(
      UF = substr(!!sym(col_cod), 1, 2),  
      MSAUDCOD = substr(!!sym(col_cod), 1, 4),  
      MICROCOD = substr(!!sym(col_cod), 1, 5)  
    ) %>%
    left_join(geo, by = c("UF", "MSAUDCOD", "MICROCOD")) %>%  
    select(everything(), MUNNOME)  
}

for (ano in 2014:2023) {
  db_sim <- fetch_datasus(
    year_start = ano,
    year_end = ano,
    information_system = "SIM-DOINF",
    vars = c(
      "SEXO",
      "CODMUNNATU",
      "LOCOCOR",
      "IDADEMAE",
      "ESCMAE",
      "QTDFILVIVO",
      "PARTO"
    )
  )
  db_sim <- process_sim(db_sim)
  db_sim <- db_sim %>% mutate(ANO = ano)
  db_sim <- processar_dados(db_sim, geo, "CODMUNNATU")
  minf <- bind_rows(minf, db_sim)
  
  db_sinasc <- fetch_datasus(
    year_start = ano,
    year_end = ano,
    information_system = "SINASC",
    vars = c(
      "SEXO",
      "CODMUNNASC",
      "LOCNASC",
      "IDADEMAE",
      "ESCMAE",
      "QTDFILVIVO",
      "PARTO"
    )
  )
  db_sinasc <- process_sim(db_sinasc)
  db_sinasc <- db_sinasc %>% mutate(ANO = ano)
  db_sinasc <- processar_dados(db_sinasc, geo, "CODMUNNASC")
  ninf <- bind_rows(ninf, db_sinasc)
  
  if (ano == 2023) {
    save(minf, file = "minf.Rdata")
    save(ninf, file = "ninf.Rdata")
    remove(db_sim, db_sinasc, minf, ninf, ano, geo)
  }
}

load("minf.Rdata")
load("ninf.Rdata")
