# 📚 Importando as Bibliotecas Necessárias ----

library(CGPfunctions) # Gráficos
library(countrycode)  # Nomeação de Países
library(tidyverse)    # Tratamento, Manipulação e Visualização de Dados
library(tidyquant)    # Dados Financeiros
library(gridExtra)    # Gráficos
library(patchwork)    # Gráficos 
library(ggthemes)     # Gráficos
library(seasonal)     # Ajuste sazonal para séries temporais
library(imf.data)     # Dados do IMF
library(gtExtras)     # Gráficos
library(mFilter)      # Filtro HP 
library(ggtext)       # Gráfico
library(readxl)       # Leitura de arquivos excel
library(sidrar)       # Baixar dados do IBGE
library(scales)       # Gráficos
library(gt)           # Tabelas 
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
           "Moldova", "Paraguay", "Uganda", "Dominican Republic", "Kazakhstan"),
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


data <- cbi %>%
  inner_join(cpi  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(debt %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(gdp  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(rate %>% select(-country), by = c("iso3c", "year")) %>%
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
    taxa_juros,
    cbie_index,
    divida,
    pib_pot,
    hiato_pct,
    real_rate
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
    plot.subtitle      = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    axis.title         = element_text(face = "bold", size = 12),
    axis.text          = element_text(size = 10, color = "black"),
    plot.caption       = element_text(hjust = 0, size = 10, color = "black"),
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
