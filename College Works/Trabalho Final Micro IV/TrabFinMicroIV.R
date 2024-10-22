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
cnes <- data.frame()

geo <- read_excel("CADMUN.xls") %>%
  mutate(
    MUNCOD   = as.character(MUNCOD),
    MICROCOD = as.character(MICROCOD),
    MSAUDCOD = as.character(MSAUDCOD),
    UF = substr(MICROCOD, 1, 2), 
    MUNNOME = ifelse(
      str_detect(MUNNOME, "Município ignorado - "),
      str_extract(MUNNOME, "\\b[A-Z]{2}$"), 
      MUNNOME  
    )
  ) %>%
  select(MUNCOD,MUNNOME, MICROCOD, MSAUDCOD, UF, LATITUDE, LONGITUDE)

processar_dados <- function(db, geo, col_cod) {
  db %>%
    left_join(geo, by = setNames("MUNCOD", col_cod)) %>%
    select(everything(), MUNNOME, MICROCOD, MSAUDCOD, UF, LATITUDE, LONGITUDE)
}

for (ano in 2015:2019) {
  db_sim <- fetch_datasus(
    year_start = ano,
    year_end = ano,
    information_system = "SIM-DOINF",
    vars = c(
      "SEXO",
      "CODMUNOCOR",
      "LOCOCOR",
      "IDADEMAE",
      "ESCMAE",
      "QTDFILVIVO",
      "PARTO"
    )
  )
  db_sim <- process_sim(db_sim)
  db_sim <- db_sim %>% mutate(ANO = ano)
  db_sim <- processar_dados(db_sim, geo, "CODMUNOCOR")
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
  
  db_cnes_lt <- fetch_datasus(
    year_start = ano,
    month_start = 12,
    year_end = ano,
    month_end = 12, 
    information_system = "CNES-LT",
    vars = c("CODUFMUN", "MICR_REG")  
  )
  db_cnes_lt <- db_cnes_lt %>% mutate(ANO = ano)
  db_cnes_lt <- processar_dados(db_cnes_lt, geo, "CODUFMUN")
  cnes <- bind_rows(cnes_lt, db_cnes_lt)
  
  if (ano == 2019) {
    save(minf, file = "minf.Rdata")
    save(ninf, file = "ninf.Rdata")
    save(cnes_lt, file = "cnes_lt.Rdata")
    remove(db_sim, db_sinasc, minf, ninf, cnes,ano, geo)
  }
}

load("minf.Rdata")
load("ninf.Rdata")
load("cnes.Rdata")
