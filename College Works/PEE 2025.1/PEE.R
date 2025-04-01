# 📚 Importando as Bibliotecas Necessárias ----

library(rnaturalearth)# Conjunto de dados e mapas de países
library(CGPfunctions) # Gráficos
library(countrycode)  # Nomeação de Países
library(tidyverse)    # Tratamento, Manipulação e Visualização de Dados
library(tidyquant)    # Dados Financeiros
library(gridExtra)    # Gráficos
library(patchwork)    # Gráficos
library(labelled)     # Rótulos
library(ggthemes)     # Gráficos
library(seasonal)     # Ajuste sazonal para séries temporais
library(imf.data)     # Dados do IMF
library(gtExtras)     # Gráficos
library(mFilter)      # Filtro HP 
library(ggtext)       # Gráfico
library(readxl)       # Leitura de arquivos excel
library(sidrar)       # Baixar dados do IBGE
library(scales)       # Gráficos
library(zoo)          # Datas trimestrais
library(WDI)          # Baixar dados direto do World Development Indicators
library(gt)           # Tabelas Formatadas
library(sf)           # Manipulação de dados espaciais 

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

inf_for <- read_xlsx("InflationForecast(FMI).xlsx") %>% 
  select(Country, Code, Year, `Inflation forecast`) %>%
  rename(inflation_forecast = `Inflation forecast`,
         country = Country,
         code = Code,
         year = Year) %>%
  mutate(iso3c = countrycode(sourcevar = country,
                             origin = "country.name",
                             destination = "iso3c"))

ifs <- load_datasets("IFS")

data_wide <- ifs$get_series(
  freq         = "A",         
  ref_area     = NULL,        
  indicator    = "FPOLM_PA",  
  start_period = "1960",
  end_period   = "2025"
)

rate <- data_wide %>%
  pivot_longer(
    cols = -TIME_PERIOD,
    names_to = "col_indicator",
    values_to = "taxa_juros"
  ) %>%
  mutate(
    iso2c = sub("^A\\.(.*?)\\.FPOLM_PA$", "\\1", col_indicator),
    year  = as.numeric(TIME_PERIOD)
  ) %>%
  mutate(
    iso2c = case_when(
      iso2c %in% c("7A", "U2") ~ "EA",  
      TRUE ~ iso2c
    )
  ) %>%
  mutate(
    iso3c   = countrycode(iso2c, origin = "iso2c", destination = "iso3c"),
    country = countrycode(iso2c, origin = "iso2c", destination = "country.name")
  ) %>%
  filter(!is.na(country)) %>%
  select(country, iso2c, iso3c, year, taxa_juros)

target <- data.frame(
  Pais = c("New Zealand", "Canada", "Chile", "Israel", "United Kingdom", "Sweden",
           "Finland", "Australia", "Spain", "Czech Republic", "Poland", "Brazil",
           "Colombia", "South Africa", "Thailand", "South Korea", "Mexico",
           "Iceland", "Norway", "Hungary", "Peru", "Philippines", "Guatemala",
           "Indonesia", "Romania", "Turkey", "Serbia", "Ghana", "Uruguay",
           "Albania", "Georgia", "Armenia", "Japan", "India", "Russia",
           "Moldova", "Paraguay", "Uganda", "Dominican Republic"),
  AnoAdocao = c(1989, 1991, 1991, 1991, 1992, 1993,
                1993, 1993, 1994, 1997, 1998, 1999,
                1999, 2000, 2000, 2001, 2001,
                2001, 2001, 2001, 2002, 2002, 2005,
                2005, 2005, 2006, 2007, 2007,
                2009, 2009, 2009, 2013, 2015, 2014,
                2010, 2011, 2011, 2012, 2015),
  SegueAtualmente = c("sim", "sim", "sim", "sim", "sim", "sim",
                      "não", "sim", "não", "sim", "sim", "sim",
                      "sim", "sim", "sim", "sim", "sim",
                      "sim", "sim", "sim", "sim", "sim", "sim",
                      "sim", "não", "sim", "sim", "sim",
                      "sim", "sim", "sim", "sim", "sim", "sim",
                      "sim", "sim", "sim", "sim", "sim")
)

acemoglu_classification <- data.frame(
  Pais = c("Argentina", "Australia", "Austria", "Brazil", "Chile", 
           "Denmark", "Finland", "France", "Greece", "Guatemala", 
           "India", "Indonesia", "Korea", "Malaysia", "Mexico",
           "Mongolia", "Netherlands", "Norway", "Paraguay","Philippines",
           "Portugal", "Spain", "Sweden", "Switzerland", "Turkey", "United Kingdom",
           "Uruguay"),
  Classe = c("Medium", "High", "High", "Medium", "Medium", 
             "High", "High", "Medium", "Medium", "Low", 
             "Medium", "Low", "Medium", "Medium", "Medium",
             "Medium", "High", "High", "Low", "Medium",
             "Medium", "Medium", "High", "High", "Medium", 
             "High", "Medium")
)


data <- cbi %>%
  inner_join(cpi  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(debt %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(gdp  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(rate %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(inf_for %>% select(-country), by = c("iso3c", "year")) %>%
  filter(year >= 1990) %>% 
  select(-c(iso2c.y, iso2c.x.x, iso2c.y.y)) %>% 
  group_by(country) %>%      
  arrange(year) %>%           
  mutate(pib_pot = hpfilter(pib, freq = 6.25)$trend) %>%  
  ungroup() %>% 
  mutate(hiato_pct = ((pib - pib_pot) / pib_pot) * 100) %>% 
  mutate(real_rate = ((1 + as.numeric(taxa_juros)) / (1 + inflation)) - 1) %>% 
  arrange(country, year) %>% 
  select(
    country,
    iso3c,
    iso2c.x,
    year,
    pib,
    inflation,
    inflation_forecast,
    taxa_juros,
    cbie_index,
    divida,
    pib_pot,
    hiato_pct,
    real_rate
  ) %>%
  set_variable_labels(
    pib = "GDP (constant 2015 US$)",
    inflation = "Inflação (%)",
    inflation_forecast = "Expectativa de Inflação (%)",
    taxa_juros = "Taxa de juros nominal (%)(BC)",
    cbie_index = "Índice de independência do Banco Central",
    divida = "Dívida governamental (% do PIB)",
    pib_pot = "PIB potencial (filtro HP)",
    hiato_pct = "Hiato do produto (%)",
    real_rate = "Taxa de juros real (%)"
  )

# Gráficos ----

ggplot() +
  geom_ribbon(
    data = data %>%
      group_by(year) %>%
      summarise(
        mean_cbie = mean(cbie_index, na.rm = TRUE),
        sd_cbie   = sd(cbie_index, na.rm = TRUE)
      ),
    aes(
      x = year,
      ymin = mean_cbie - sd_cbie,
      ymax = mean_cbie + sd_cbie
    ),
    fill = "#2A9D8F",
    alpha = 0.2
  ) +
  geom_line(
    data = data %>%
      group_by(year) %>%
      summarise(mean_cbie = mean(cbie_index, na.rm = TRUE)),
    aes(x = year, y = mean_cbie),
    color = "#1F4E79",
    size = 1
  ) +
  geom_line(
    data = data %>%
      group_by(year) %>%
      summarise(
        mean_cbie = mean(cbie_index, na.rm = TRUE),
        sd_cbie   = sd(cbie_index, na.rm = TRUE)
      ),
    aes(x = year, y = mean_cbie + sd_cbie),
    color = "#81B1D6",
    linetype = "dotted",
    size = 0.8
  ) +
  geom_line(
    data = data %>%
      group_by(year) %>%
      summarise(
        mean_cbie = mean(cbie_index, na.rm = TRUE),
        sd_cbie   = sd(cbie_index, na.rm = TRUE)
      ),
    aes(x = year, y = mean_cbie - sd_cbie),
    color = "#81B1D6",
    linetype = "dotted",
    size = 0.8
  ) +
  geom_point(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_cbie   = mean(cbie_index, na.rm = TRUE),
        sd_cbie     = sd(cbie_index, na.rm = TRUE),
        distance_up = cbie_index - (mean_cbie + sd_cbie)
      ) %>%
      filter(cbie_index > mean_cbie + sd_cbie) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = cbie_index),
    color = "darkgreen",
    size = 3
  ) +
  geom_text(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_cbie   = mean(cbie_index, na.rm = TRUE),
        sd_cbie     = sd(cbie_index, na.rm = TRUE),
        distance_up = cbie_index - (mean_cbie + sd_cbie)
      ) %>%
      filter(cbie_index > mean_cbie + sd_cbie) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = cbie_index, label = iso3c),
    color = "darkgreen",
    vjust = -0.8,
    size = 3
  ) +
  geom_point(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_cbie     = mean(cbie_index, na.rm = TRUE),
        sd_cbie       = sd(cbie_index, na.rm = TRUE),
        distance_down = (mean_cbie - sd_cbie) - cbie_index
      ) %>%
      filter(cbie_index < mean_cbie - sd_cbie) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = cbie_index),
    color = "red",
    size = 3
  ) +
  geom_text(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_cbie     = mean(cbie_index, na.rm = TRUE),
        sd_cbie       = sd(cbie_index, na.rm = TRUE),
        distance_down = (mean_cbie - sd_cbie) - cbie_index
      ) %>%
      filter(cbie_index < mean_cbie - sd_cbie) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = cbie_index, label = iso3c),
    color = "red",
    vjust = 1.5,
    size = 3
  ) +
  scale_x_continuous(breaks = sort(unique(data$year)), expand = expansion(mult = c(0.01, 0.01))) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.2),
    expand = expansion(mult = c(0, 0))
  ) +
  labs(
    title    = "Evolução Anual do CBI",
    subtitle = "Linhas pontilhadas de 1 desvio-padrão, com os outliers",
    x        = "Ano",
    y        = "Índice de Independência do BC (CBI)",
    caption  = expression(bold("Fonte: ") ~ "https://cbidata.org/")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(
      size = 12,
      hjust = 0,
      margin = margin(b = 10)
    ),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    plot.caption       = element_text(
      hjust = 0,
      size = 10,
      color = "black"
    ),
    plot.margin        = margin(15, 25, 15, 25)
  )

ggplot() +
  geom_ribbon(
    data = data %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE)
      ),
    aes(
      x = year,
      ymin = mean_inflation - sd_inflation,
      ymax = mean_inflation + sd_inflation
    ),
    fill = "#2A9D8F",
    alpha = 0.2
  ) +
  geom_line(
    data = data %>%
      group_by(year) %>%
      summarise(mean_inflation = mean(inflation, na.rm = TRUE)),
    aes(x = year, y = mean_inflation),
    color = "#1F4E79",
    size = 1
  ) +
  geom_line(
    data = data %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE)
      ),
    aes(x = year, y = mean_inflation + sd_inflation),
    color = "#81B1D6",
    linetype = "dotted",
    size = 0.8
  ) +
  geom_line(
    data = data %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE)
      ),
    aes(x = year, y = mean_inflation - sd_inflation),
    color = "#81B1D6",
    linetype = "dotted",
    size = 0.8
  ) +
  geom_point(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_up = inflation - (mean_inflation + sd_inflation)
      ) %>%
      filter(inflation > mean_inflation + sd_inflation) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation),
    color = "darkgreen",
    size = 3
  ) +
  geom_text(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_up = inflation - (mean_inflation + sd_inflation)
      ) %>%
      filter(inflation > mean_inflation + sd_inflation) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation, label = iso3c),
    color = "darkgreen",
    vjust = -0.8,
    size = 3
  ) +
  geom_point(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_down = (mean_inflation - sd_inflation) - inflation
      ) %>%
      filter(inflation < mean_inflation - sd_inflation) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation),
    color = "red",
    size = 3
  ) +
  geom_text(
    data = data %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_down = (mean_inflation - sd_inflation) - inflation
      ) %>%
      filter(inflation < mean_inflation - sd_inflation) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation, label = iso3c),
    color = "red",
    vjust = 1.5,
    size = 3
  ) +
  scale_x_continuous(
    breaks = sort(unique(data$year)),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0.02, 0.1))
  ) +
  labs(
    title    = "Evolução Anual da Inflação",
    subtitle = "Linhas pontilhadas de 1 desvio-padrão, com os outliers",
    x        = "Ano",
    y        = "Inflação (%)",
    caption  = expression(bold("Fonte: ") ~ "https://data.worldbank.org/indicator/FP.CPI.TOTL.ZG")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
    plot.margin        = margin(15, 25, 15, 25)
  )

ggplot() +
  geom_ribbon(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE)
      ),
    aes(
      x = year,
      ymin = mean_inflation - sd_inflation,
      ymax = mean_inflation + sd_inflation
    ),
    fill = "#2A9D8F",
    alpha = 0.2
  ) +
  geom_line(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      summarise(mean_inflation = mean(inflation, na.rm = TRUE)),
    aes(x = year, y = mean_inflation),
    color = "#1F4E79",
    size = 1
  ) +
  geom_line(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE)
      ),
    aes(x = year, y = mean_inflation + sd_inflation),
    color = "#81B1D6",
    linetype = "dotted",
    size = 0.8
  ) +
  geom_line(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE)
      ),
    aes(x = year, y = mean_inflation - sd_inflation),
    color = "#81B1D6",
    linetype = "dotted",
    size = 0.8
  ) +
  geom_point(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_up = inflation - (mean_inflation + sd_inflation)
      ) %>%
      filter(inflation > mean_inflation + sd_inflation) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation),
    color = "darkgreen",
    size = 3
  ) +
  geom_text(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_up = inflation - (mean_inflation + sd_inflation)
      ) %>%
      filter(inflation > mean_inflation + sd_inflation) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation, label = iso3c),
    color = "darkgreen",
    vjust = -0.8,
    size = 3
  ) +
  geom_point(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_down = (mean_inflation - sd_inflation) - inflation
      ) %>%
      filter(inflation < mean_inflation - sd_inflation) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation),
    color = "red",
    size = 3
  ) +
  geom_text(
    data = data %>%
      filter(year > 2000) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_down = (mean_inflation - sd_inflation) - inflation
      ) %>%
      filter(inflation < mean_inflation - sd_inflation) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation, label = iso3c),
    color = "red",
    vjust = 1.5,
    size = 3
  ) +
  scale_x_continuous(
    breaks = sort(unique(data %>% filter(year > 2000) %>% pull(year))),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0.02, 0.1))
  ) +
  labs(
    title    = "Evolução Anual da Inflação",
    subtitle = "Linhas pontilhadas de 1 desvio-padrão, com os outliers",
    x        = "Ano",
    y        = "Inflação (%)",
    caption  = expression(bold("Fonte: ") ~ "https://data.worldbank.org/indicator/FP.CPI.TOTL.ZG")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
    plot.margin        = margin(15, 25, 15, 25)
  )

ggplot() +
  geom_ribbon(
    data = data %>%
      filter(
        year > 2000,
        country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))
      ) %>%
      group_by(year) %>%
      summarise(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        .groups = "drop"
      ),
    aes(
      x = year,
      ymin = mean_inflation - sd_inflation,
      ymax = mean_inflation + sd_inflation
    ),
    fill = "#2A9D8F", alpha = 0.2
  ) +
  geom_line(
    data = data %>%
      filter(
        year > 2000,
        country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))
      ) %>%
      group_by(year) %>%
      summarise(mean_inflation = mean(inflation, na.rm = TRUE), .groups = "drop"),
    aes(x = year, y = mean_inflation),
    color = "#1F4E79", size = 1
  ) +
  geom_point(
    data = data %>%
      filter(
        year > 2000,
        country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))
      ) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_up    = inflation - (mean_inflation + sd_inflation)
      ) %>%
      filter(inflation > mean_inflation + sd_inflation) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation),
    color = "darkgreen", size = 3
  ) +
  geom_text(
    data = data %>%
      filter(
        year > 2000,
        country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))
      ) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_up    = inflation - (mean_inflation + sd_inflation)
      ) %>%
      filter(inflation > mean_inflation + sd_inflation) %>%
      slice_max(distance_up, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation, label = iso3c),
    color = "darkgreen", vjust = -0.8, size = 3
  ) +
  geom_point(
    data = data %>%
      filter(
        year > 2000,
        country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))
      ) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_down  = (mean_inflation - sd_inflation) - inflation
      ) %>%
      filter(inflation < mean_inflation - sd_inflation) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation),
    color = "red", size = 3
  ) +
  geom_text(
    data = data %>%
      filter(
        year > 2000,
        country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))
      ) %>%
      group_by(year) %>%
      mutate(
        mean_inflation = mean(inflation, na.rm = TRUE),
        sd_inflation   = sd(inflation, na.rm = TRUE),
        distance_down  = (mean_inflation - sd_inflation) - inflation
      ) %>%
      filter(inflation < mean_inflation - sd_inflation) %>%
      slice_max(distance_down, with_ties = FALSE) %>%
      ungroup(),
    aes(x = year, y = inflation, label = iso3c),
    color = "red", vjust = 1.5, size = 3
  ) +
  scale_x_continuous(
    breaks = sort(unique(data %>%
                           filter(year > 2000, country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais))) %>%
                           pull(year))),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0.02, 0.1))
  ) +
  labs(
    title    = "Inflação Média Anual — Países com Metas de Inflação",
    subtitle = "Desvio padrão e destaques para outliers acima/abaixo",
    x        = "Ano",
    y        = "Inflação (%)",
    caption  = expression(bold("Fonte: ") ~ "WDI + CBIE + Target Framework")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
    plot.margin        = margin(15, 25, 15, 25)
  )

data %>%
  filter(
    year >= 2000,
    country %in% (acemoglu_classification %>% pull(Pais))
  ) %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  ggplot(aes(x = Classe, y = inflation)) +
  geom_boxplot(
    fill = "#1F4E79", alpha = 0.7, outlier.color = "red",
    width = 0.6
  ) +
  labs(
    title = "Distribuição da Inflação por Classe Institucional",
    subtitle = "Segundo a classificação de Acemoglu et al.",
    x = "Classe Institucional",
    y = "Inflação (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + Acemoglu et al. (2008)")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
    plot.margin        = margin(15, 25, 15, 25)
  )

data %>%
  filter(
    year >= 2000,
    country %in% (target %>% pull(Pais))
  ) %>%
  mutate(grupo_target = if_else(
    country %in% (target %>% filter(SegueAtualmente == "sim") %>% pull(Pais)),
    "Segue metas", "Não segue"
  )) %>%
  group_by(year, grupo_target) %>%
  summarise(cbie_medio = mean(cbie_index, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = year, y = cbie_medio, color = grupo_target)) +
  geom_line(size = 1.2) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("Segue metas" = "#2A9D8F", "Não segue" = "#E76F51")) +
  labs(
    title = "Evolução do Índice de Independência do Banco Central",
    subtitle = "Comparação entre países que seguem ou não metas de inflação",
    x = "Ano", y = "CBIE Médio", color = "Grupo",
    caption = expression(bold("Fonte: ") ~ "CBIE + Target Framework")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    legend.title       = element_text(face = "bold"),
    legend.position    = "top",
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
    plot.margin        = margin(15, 25, 15, 25)
  )

data %>%
  filter(
    country %in% (acemoglu_classification %>% pull(Pais)),
    !is.na(real_rate), !is.na(inflation)
  ) %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  group_by(country, Classe) %>%
  filter(n() >= 5) %>%
  summarise(
    cor_tj_infl = cor(real_rate, inflation, use = "complete.obs"),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = Classe, y = cor_tj_infl, fill = Classe)) +
  geom_violin(
    scale = "width", alpha = 0.5, color = "black", trim = FALSE
  ) +
  geom_jitter(
    width = 0.1, size = 2, alpha = 0.6, color = "black"
  ) +
  scale_fill_manual(values = c("Low" = "#E76F51", "Medium" = "#F4A261", "High" = "#2A9D8F")) +
  labs(
    title = "Potência da Política Monetária por Classe Institucional",
    subtitle = "Correlação entre juros reais e inflação (quanto menor, maior potência)",
    x = "Classe Institucional",
    y = "Correlação",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + Acemoglu")
  ) +
  theme(
    plot.background    = element_rect(fill = "white", color = NA),
    panel.background   = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.line.x.bottom = element_line(color = "black"),
    axis.line.y.left   = element_line(color = "black"),
    axis.ticks         = element_line(color = "black"),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    legend.position    = "none",
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
    plot.margin        = margin(15, 25, 15, 25)
  )


ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(name != "Antarctica") %>%
  left_join(
    data %>%
      group_by(iso3c) %>%
      summarise(
        media_cbie = mean(cbie_index, na.rm = TRUE),
        .groups = "drop"
      ),
    by = c("iso_a3" = "iso3c")
  ) %>%
  ggplot() +
  geom_sf(aes(fill = media_cbie),
          color = "grey40",
          size = 0.2) +
  scale_fill_viridis_c(
    option = "plasma",
    direction = -1,
    name = "CBIE Médio",
    na.value = "white",
    limits = c(0.3, 0.85),
    breaks = seq(0.3, 0.85, 0.1),
    oob = scales::squish
  ) +
  coord_sf(expand = FALSE) +
  labs(title    = NULL,
       subtitle = NULL,
       caption  = NULL) +
  theme_void(base_size = 11) +
  theme(
    legend.position    = "right",
    legend.title       = element_text(face = "bold", size = 11),
    legend.text        = element_text(size = 9),
    
    plot.title.position = "plot",
    plot.caption.position = "plot",
    
    plot.margin = margin(
      t = 60,
      r = 20,
      b = 40,
      l = 20
    )
  ) +
  patchwork::plot_annotation(
    title    = "Independência Média do Banco Central",
    subtitle = "Média do índice CBIE entre 1990 e 2023",
    caption  = expression(bold("Fonte: ") ~ "CBIE (Arnone et al.) + Natural Earth"),
    theme = theme(
      plot.title    = element_text(face = "bold", size = 18, hjust = 0),
      plot.subtitle = element_text(
        size = 13,
        hjust = 0,
        margin = margin(b = 10)
      ),
      plot.caption  = element_text(
        hjust = 0,
        size = 10,
        color = "black",
        margin = margin(t = 10)
      )
    )
  )

library(tidyverse)

data %>%
  mutate(across(
    c(pib, inflation, inflation_forecast, taxa_juros, cbie_index, divida, pib_pot, hiato_pct, real_rate),
    ~ as.numeric(.x)
  )) %>%
  select(iso3c, pib, inflation, inflation_forecast, taxa_juros, cbie_index, divida, pib_pot, hiato_pct, real_rate) %>%
  pivot_longer(
    cols = -iso3c,
    names_to = "variavel",
    values_to = "valor"
  ) %>%
  filter(!is.na(valor)) %>%
  count(iso3c, variavel, name = "n_obs") %>%
  ggplot(aes(x = fct_reorder(iso3c, -n_obs, .fun = sum), y = n_obs, fill = variavel)) +
  geom_bar(stat = "identity", color = "white", width = 0.85) +
  scale_fill_manual(
    values = c(
      "#4DACD6","#4FAE62","#F6C54D","#E37D46","#C02D45","#8ecae6","#219ebc","#023047","#ffb703"),
    name = "Variável"
  ) +
  labs(
    title = "Cobertura de Dados por País e Variável",
    subtitle = "Número de observações não ausentes por país e por variável",
    x = "País (ISO3C)",
    y = "Nº de Observações",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 60, hjust = 1, size = 9),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    axis.text.y = element_text(size = 10),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )
