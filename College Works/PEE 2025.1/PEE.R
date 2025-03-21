# 📚 Importando as Bibliotecas Necessárias ----

library(countrycode)  # Nomeação de Países
library(tidyverse)    # Tratamento, Manipulação e Visualização de Dados
library(tidyquant)    # Dados Financeiros
library(gridExtra)    # Gráficos
library(patchwork)    # Gráficos 
library(ggthemes)     # Gráficos
library(seasonal)     # Ajuste sazonal para séries temporais
library(imf.data)     # Dados do IMF
library(mFilter)      # Filtro HP 
library(readxl)       # Leitura de arquivos excel
library(sidrar)       # Baixar dados do IBGE
library(zoo)          # Datas trimestrais
library(WDI)          # Baixar dados direto do World Development Indicators
library(gt)           # Tabelas Formatadas


# 📃 Importando e Ajustando as Bases de Dados ----

indicadores <- WDIsearch()

agrupamentos <- c(
  "Africa Eastern and Southern",
  "Africa Western and Central",
  "Arab World",
  "Early-demographic dividend",
  "East Asia & Pacific",
  "East Asia & Pacific (excluding high income)",
  "East Asia & Pacific (IDA & IBRD countries)",
  "Euro area",
  "Europe & Central Asia",
  "Europe & Central Asia (excluding high income)",
  "Europe & Central Asia (IDA & IBRD countries)",
  "European Union",
  "Fragile and conflict affected situations",
  "Heavily indebted poor countries (HIPC)",
  "High income",
  "IBRD only",
  "IDA & IBRD total",
  "IDA blend",
  "IDA only",
  "IDA total",
  "Late-demographic dividend",
  "Latin America & Caribbean",
  "Latin America & Caribbean (excluding high income)",
  "Latin America & the Caribbean (IDA & IBRD countries)",
  "Least developed countries: UN classification",
  "Low & middle income",
  "Low income",
  "Lower middle income",
  "Middle East & North Africa",
  "Middle East & North Africa (excluding high income)",
  "Middle East & North Africa (IDA & IBRD countries)",
  "Middle income",
  "Not classified",
  "OECD members",
  "Other small states",
  "Pacific island small states",
  "Post-demographic dividend",
  "Pre-demographic dividend",
  "Small states",
  "South Asia",
  "South Asia (IDA & IBRD)",
  "Sub-Saharan Africa",
  "Sub-Saharan Africa (excluding high income)",
  "Sub-Saharan Africa (IDA & IBRD countries)",
  "Upper middle income",
  "World"
)

gdp <- WDI(
  country = "all",
  indicator = "NY.GDP.MKTP.KD",
  start = 1960,
  end = NULL,
  extra = TRUE
) %>%
  filter(!country %in% agrupamentos) %>% 
  select(country, iso2c, iso3c, year, NY.GDP.MKTP.KD) %>% 
  rename(pib = NY.GDP.MKTP.KD) %>% 
  arrange(country, year)

cpi <- WDI(
  country = "all",
  indicator = "NY.GDP.DEFL.KD.ZG",
  start = 1960,
  end = NULL,
  extra = TRUE
) %>%
  filter(!country %in% agrupamentos)%>% 
  select(country, iso2c, iso3c, year, NY.GDP.DEFL.KD.ZG) %>% 
  rename(inflation = NY.GDP.DEFL.KD.ZG) %>% 
  arrange(country, year)

debt <- WDI(
  country = "all",
  indicator = "GC.DOD.TOTL.GD.ZS",
  start = 1960,
  end = NULL,
  extra = TRUE
) %>%
  filter(!country %in% agrupamentos) %>% 
  select(country, iso2c, iso3c, year, GC.DOD.TOTL.GD.ZS) %>% 
  rename(divida = GC.DOD.TOTL.GD.ZS) %>% 
  arrange(country, year)

cbi <- read_xlsx("CBIDta.xlsx", sheet = "Data") %>%
  select(country, iso_a3, year, cbie_index) %>%  
  mutate(year = as.numeric(year)) %>% 
  arrange(country, year) %>%
  rename(iso3c = iso_a3) %>%
  select(country, iso3c, year, cbie_index)

ifs <- load_datasets("IFS")

data_wide <- ifs$get_series(
  freq         = "A",         
  ref_area     = NULL,        
  indicator    = "FPOLM_PA",  
  start_period = "1960",      
  end_period   = "2025"       
)

data_long <- data_wide %>%
  pivot_longer(
    cols = -TIME_PERIOD,
    names_to = "col_indicator",
    values_to = "taxa_juros"
  )

data_long <- data_long %>%
  filter(!is.na(country))

data_long <- data_long %>%
  mutate(
    iso2c = case_when(
      iso2c == "7A" ~ "EA",  
      iso2c == "U2" ~ "EA",  
      TRUE          ~ iso2c
    )
  ) %>%
  mutate(
    iso3c   = countrycode(iso2c, origin = "iso2c", destination = "iso3c"),
    country = countrycode(iso2c, origin = "iso2c", destination = "country.name")
  )

data_long <- data_long %>%
  filter(!is.na(country))

rate <- data_long %>%
  select(
    country,
    iso2c,
    iso3c,
    year,
    taxa_juros
  )

data <- cbi %>%
  inner_join(cpi  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(debt %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(gdp  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(rate %>% select(-country), by = c("iso3c", "year")) %>%
  filter(year >= 1990) 
