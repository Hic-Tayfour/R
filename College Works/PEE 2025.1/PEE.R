# 📚 Importando as Bibliotecas Necessárias ----

library(tidyverse) # Tratamento, Manipulação e Visualização de Dados
library(tidyquant) # Dados Financeiros
library(gridExtra) # Gráficos
library(patchwork) # Gráficos 
library(ggthemes)  # Gráficos
library(seasonal)  # Ajuste sazonal para séries temporais
library(mFilter)   # Filtro HP 
library(readxl)    # Leitura de arquivos excel
library(sidrar)    # Baixar dados do IBGE 
library(zoo)       # Datas trimestrais
library(gt)        # Tabelas Formatadas


# 📃 Importando e Ajustando as Bases de Dados ----

gdp <- read_xlsx("GDP.xlsx", 
                 sheet = "Data") %>%
  mutate(across(-c(Country, Scale, `Base Year`), as.character)) %>% 
  pivot_longer(cols = -c(Country, Scale, `Base Year`), 
               names_to = "Periodo", 
               values_to = "GDP") %>%
  mutate(Periodo = as.yearqtr(Periodo, format = "%YQ%q"),
         GDP = as.numeric(GDP)) 

cbi <- read_xlsx("CBIDta.xlsx", sheet = "Data") %>%
  select(country, iso_a3, year, cbie_index) %>%  
  rename(Ano = year) %>%
  mutate(Ano = as.numeric(Ano))


rate <- read_xlsx("CBRatePolicy(%).xlsx", 
                  sheet = "Data") %>%
  mutate(across(-c(Country, Scale, `Base Year`), as.character)) %>% 
  pivot_longer(cols = -c(Country, Scale, `Base Year`), 
               names_to = "Periodo", 
               values_to = "Rate") %>%
  mutate(Periodo = as.yearqtr(Periodo, format = "%YQ%q"),
         Rate = as.numeric(Rate)) 


cpi <- read_xlsx("CPI(%).xlsx", sheet = "Data") %>%
  rename_with(~ gsub("Q([1-4]) (\\d{4})", "\\2Q\\1", .x), -Country) %>%  
  pivot_longer(cols = -Country, names_to = "Periodo", values_to = "CPI") %>%
  mutate(
    Periodo = as.yearqtr(Periodo, format = "%YQ%q"),
    CPI = as.numeric(CPI)
  )

data <- gdp %>%
  select(Country, Periodo, GDP) %>% 
  inner_join(cpi, by = c("Country", "Periodo")) %>%
  inner_join(rate, by = c("Country", "Periodo"))%>%
  select(Country, Periodo, GDP, CPI, Rate)

cbi <- read_xlsx("CBIDta.xlsx", sheet = "Data") %>%
  select(country, iso_a3, year, cbie_index) %>%  
  rename(Ano = year) %>%
  mutate(Ano = as.numeric(Ano)) %>%
  crossing(Trimestre = c("Q1", "Q2", "Q3", "Q4")) %>%
  mutate(Periodo = as.yearqtr(paste0(Ano, " ", Trimestre), format = "%Y Q%q")) %>%
  select(country, iso_a3, Periodo, cbie_index)

data_full <- gdp %>%
  select(Country, Periodo, GDP) %>% 
  inner_join(cpi, by = c("Country", "Periodo")) %>%
  inner_join(rate, by = c("Country", "Periodo")) %>%
  select(Country, Periodo, GDP, CPI, Rate) %>%
  left_join(
    cbi %>% 
      select(country, iso_a3, Periodo, cbie_index) %>%
      rename(Country = country),
    by = c("Country", "Periodo")
  ) %>%
  select(Country, iso_a3, Periodo, GDP, CPI, Rate, cbie_index) %>% 
  rename(
    Cod = iso_a3,
    Cbi = cbie_index,
    CPI_PerCent = CPI,
    Rate_PerCent = Rate
  ) 

