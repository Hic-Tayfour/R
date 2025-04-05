# 📚 Importando as Bibliotecas Necessárias ----

library(rnaturalearth)# Conjunto de dados e mapas de países
library(CGPfunctions) # Gráficos
library(countrycode)  # Nomeação de Países
library(tidyverse)    # Tratamento, Manipulação e Visualização de Dados
library(tidyquant)    # Dados Financeiros
library(gridExtra)    # Gráficos 
library(patchwork)    # Gráficos Organizados
library(gganimate)    # Gráficos Animados
library(labelled)     # Rótulos
library(ggthemes)     # Gráficos
library(seasonal)     # Ajuste sazonal para séries temporais
library(imf.data)     # Dados do IMF
library(gtExtras)     # Gráficos
library(ggstream)     # Gráficos
library(viridis)      # Gráficos
library(mFilter)      # Filtro HP 
library(ggtext)       # Gráfico
library(readxl)       # Leitura de arquivos excel
library(sidrar)       # Baixar dados do IBGE
library(scales)       # Gráficos
library(broom)        # Gráficos
library(zoo)          # Datas trimestrais
library(WDI)          # Baixar dados direto do World Development Indicators
library(plm)          # Dados em painel
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
  filter(!country %in% agrupamentos) %>%
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
  rename(
    inflation_forecast = `Inflation forecast`,
    country = Country,
    code = Code,
    year = Year
  ) %>%
  mutate(iso3c = countrycode(
    sourcevar = country,
    origin = "country.name",
    destination = "iso3c"
  ))

ifs <- load_datasets("IFS")

data_wide <- ifs$get_series(
  freq         = "A",
  ref_area     = NULL,
  indicator    = "FPOLM_PA",
  start_period = "1960",
  end_period   = "2025"
)

rate <- data_wide %>%
  pivot_longer(cols = -TIME_PERIOD,
               names_to = "col_indicator",
               values_to = "taxa_juros") %>%
  mutate(
    iso2c = sub("^A\\.(.*?)\\.FPOLM_PA$", "\\1", col_indicator),
    year  = as.numeric(TIME_PERIOD)
  ) %>%
  mutate(iso2c = case_when(iso2c %in% c("7A", "U2") ~ "EA", TRUE ~ iso2c)) %>%
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
  filter(year >= 2000) %>%
  select(-c(iso2c.y, iso2c.x.x, iso2c.y.y)) %>%
  rename(iso2c = iso2c.x) %>%
  group_by(country) %>%
  arrange(year) %>%
  mutate(
    taxa_juros = as.numeric(taxa_juros),
    pib_pot   = hpfilter(pib, freq = 6.25)$trend,
    hiato_pct = ((pib - pib_pot) / pib_pot) * 100,
    real_rate = ((1 + as.numeric(taxa_juros)) / (1 + inflation)) - 1
  ) %>%
  ungroup() %>%
  arrange(country, year) %>%
  select(
    country,
    iso3c,
    iso2c,
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
    pib                = "GDP (constant 2015 US$)",
    inflation          = "Inflação (%)",
    inflation_forecast = "Expectativa de Inflação (%)",
    taxa_juros         = "Taxa de juros nominal (%)(BC)",
    cbie_index         = "Índice de independência do Banco Central",
    divida             = "Dívida governamental (% do PIB)",
    pib_pot            = "PIB potencial (filtro HP)",
    hiato_pct          = "Hiato do produto (%)",
    real_rate          = "Taxa de juros real (%)"
  ) %>% 
  mutate(across(where(~ inherits(.x, "matrix")), as.numeric))

# Gráficos ----

## 📊 Gráfico de Cobertura de Dados ----

data %>%
  mutate(across(
    c(
      pib,
      inflation,
      inflation_forecast,
      taxa_juros,
      cbie_index,
      divida,
      pib_pot,
      hiato_pct,
      real_rate
    ),
    ~ as.numeric(.x)
  )) %>%
  select(
    iso3c,
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
  pivot_longer(cols = -iso3c,
               names_to = "variavel",
               values_to = "valor") %>%
  filter(!is.na(valor)) %>%
  count(iso3c, variavel, name = "n_obs") %>%
  ggplot(aes(
    x = fct_reorder(iso3c, -n_obs, .fun = sum),
    y = n_obs,
    fill = variavel
  )) +
  geom_bar(stat = "identity",
           color = "white",
           width = 0.85) +
  scale_fill_manual(
    values = c(
      "#4DACD6",
      "#4FAE62",
      "#F6C54D",
      "#E37D46",
      "#C02D45",
      "#8ecae6",
      "#219ebc",
      "#023047",
      "#ffb703"
    ),
    name = "Variável"
  ) +
  labs(
    title = "Cobertura de Dados por País e Variável",
    subtitle = "Número de observações não ausentes por país e por variável",
    x = "País",
    y = "Nº de Observações",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(
      angle = 60,
      hjust = 1,
      size = 9
    ),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    axis.text.y = element_text(size = 10),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(
      size = 12,
      hjust = 0,
      margin = margin(b = 10)
    ),
    plot.caption = element_text(
      hjust = 0,
      size = 10,
      color = "black"
    ),
    legend.position = "left",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

## 📊 Gráfico da Inflação Mundo ----

world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(name != "Antarctica") %>%
  select(iso_a3, geometry)

grade_mapa <- expand_grid(iso_a3 = world$iso_a3, year = 2000:2023) %>%
  left_join(world, by = "iso_a3") %>%
  st_as_sf() %>%
  left_join(data %>% filter(year >= 2000, year <= 2023),
            by = c("iso_a3" = "iso3c", "year" = "year"))

paleta_inflacao <- scale_fill_viridis_c(
  option = "plasma",
  direction = -1,
  name = "Inflação (%)",
  limits = c(-10, 100),
  breaks = c(-10, 0, 5, 10, 25, 50, 100),
  oob = squish,
  na.value = "white"
)

p <- ggplot(grade_mapa) +
  geom_sf(aes(fill = inflation),
          color = "grey40",
          size = 0.2) +
  paleta_inflacao +
  coord_sf(expand = FALSE) +
  labs(title = "Inflação Global por País",
       subtitle = "Variação percentual anual — Ano: {current_frame}",
       caption = "Fonte: WDI + Natural Earth") +
  theme_void(base_size = 11) +
  theme(
    plot.title    = element_text(face = "bold", size = 18, hjust = 0),
    plot.subtitle = element_text(
      size = 13,
      hjust = 0,
      margin = margin(b = 10)
    ),
    plot.caption  = element_text(
      size = 10,
      hjust = 0,
      color = "black",
      margin = margin(t = 10)
    ),
    legend.position = "right",
    legend.title = element_text(face = "bold", size = 11),
    legend.text  = element_text(size = 9),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.margin = margin(
      t = 60,
      r = 20,
      b = 40,
      l = 20
    )
  ) +
  transition_manual(year)

anim_save(
  "mapa_inflacao.gif",
  animation = animate(
    p,
    fps = 2,
    width = 1600,
    height = 1000,
    res = 150,
    renderer = gifski_renderer()
  )
)

## 📊 Gráfico da Evolução do CBI----

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


## 📊 Gráfico da Inflação anual ----

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

## 📊 Gráfico da Inflação anual (2000-Hoje; Países com Metas de inflação) ----

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

## 📊 Gráfico do PIB de Acordo com as Classificações do Acemoglu ----

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "High", !is.na(pib)) %>%
  group_by(year, country) %>%
  summarise(pib_total = sum(pib, na.rm = TRUE), .groups = "drop") %>%
  mutate(country = fct_reorder(country, pib_total, .fun = sum)) %>%
  ggplot(aes(x = year, y = pib_total, fill = country)) +
  geom_area(color = "white",
            size = 0.1,
            alpha = 0.95) +
  scale_fill_manual(
    values = c(
      "#4DACD6",
      "#4FAE62",
      "#F6C54D",
      "#E37D46",
      "#C02D45",
      "#8ecae6",
      "#219ebc",
      "#023047",
      "#ffb703"
    )
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "PIB Agregado dos Países com Instituições 'High'",
    subtitle = "Evolução do PIB (USD correntes) — 2000 a 2025",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Classificação Acemoglu"),
    x = NULL,
    y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(
      size = 12,
      hjust = 0,
      margin = margin(b = 10)
    ),
    plot.caption = element_text(
      hjust = 0,
      size = 10,
      color = "black"
    ),
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Medium", !is.na(pib)) %>%
  group_by(year, country) %>%
  summarise(pib_total = sum(pib, na.rm = TRUE), .groups = "drop") %>%
  mutate(country = fct_reorder(country, pib_total, .fun = sum)) %>%
  ggplot(aes(x = year, y = pib_total, fill = country)) +
  geom_area(color = "white",
            size = 0.1,
            alpha = 0.95) +
  scale_fill_manual(
    values = c(
      "#4DACD6",
      "#4FAE62",
      "#F6C54D",
      "#E37D46",
      "#C02D45",
      "#8ecae6",
      "#219ebc",
      "#023047",
      "#ffb703",
      "#9b5de5"
    )
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "PIB Agregado dos Países com Instituições 'Medium'",
    subtitle = "Evolução do PIB (USD correntes) — 2000 a 2025",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Classificação Acemoglu"),
    x = NULL,
    y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(
      size = 12,
      hjust = 0,
      margin = margin(b = 10)
    ),
    plot.caption = element_text(
      hjust = 0,
      size = 10,
      color = "black"
    ),
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Low", !is.na(pib)) %>%
  group_by(year, country) %>%
  summarise(pib_total = sum(pib, na.rm = TRUE), .groups = "drop") %>%
  mutate(country = fct_reorder(country, pib_total, .fun = sum)) %>%
  ggplot(aes(x = year, y = pib_total, fill = country)) +
  geom_area(color = "white",
            size = 0.1,
            alpha = 0.95) +
  scale_fill_manual(
    values = c(
      "#4DACD6",
      "#4FAE62",
      "#F6C54D",
      "#E37D46",
      "#C02D45",
      "#8ecae6",
      "#219ebc",
      "#023047",
      "#ffb703",
      "#9b5de5"
    )
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "PIB Agregado dos Países com Instituições 'Low'",
    subtitle = "Evolução do PIB (USD correntes) — 2000 a 2025",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Classificação Acemoglu"),
    x = NULL,
    y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(
      size = 12,
      hjust = 0,
      margin = margin(b = 10)
    ),
    plot.caption = element_text(
      hjust = 0,
      size = 10,
      color = "black"
    ),
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )


## 📊 Gráfico da Resposta da Inflação à Taxa Real de Juros ----

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  group_by(country) %>%
  mutate(
    inflacao_a_frente = dplyr::lead(inflation, 1),
    delta_inflacao = inflacao_a_frente - inflation
  ) %>%
  ungroup() %>%
  filter(
    Classe == "High",
    !is.na(real_rate),
    !is.na(delta_inflacao),
    !is.na(cbie_index)
  ) %>%
  ggplot(aes(x = real_rate, y = delta_inflacao, color = cbie_index)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  scale_color_viridis_c(option = "plasma", name = "Independência BC") +
  labs(
    title = "Classe 'High': Resposta da Inflação à Taxa Real",
    subtitle = "Δ Inflação (t+1 - t) vs. Taxa Real de Juros",
    x = "Taxa Real de Juros (%)",
    y = "Δ Inflação (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Classificação Acemoglu")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 10, hjust = 0),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  group_by(country) %>%
  mutate(
    inflacao_a_frente = dplyr::lead(inflation, 1),
    delta_inflacao = inflacao_a_frente - inflation
  ) %>%
  ungroup() %>%
  filter(
    Classe == "Medium",
    !is.na(real_rate),
    !is.na(delta_inflacao),
    !is.na(cbie_index)
  ) %>%
  ggplot(aes(x = real_rate, y = delta_inflacao, color = cbie_index)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  scale_color_viridis_c(option = "plasma", name = "Independência BC") +
  labs(
    title = "Classe 'Medium': Resposta da Inflação à Taxa Real",
    subtitle = "Δ Inflação (t+1 - t) vs. Taxa Real de Juros",
    x = "Taxa Real de Juros (%)",
    y = "Δ Inflação (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Classificação Acemoglu")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 10, hjust = 0),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  group_by(country) %>%
  mutate(
    inflacao_a_frente = dplyr::lead(inflation, 1),
    delta_inflacao = inflacao_a_frente - inflation
  ) %>%
  ungroup() %>%
  filter(
    Classe == "Low",
    !is.na(real_rate),
    !is.na(delta_inflacao),
    !is.na(cbie_index)
  ) %>%
  ggplot(aes(x = real_rate, y = delta_inflacao, color = cbie_index)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  scale_color_viridis_c(option = "plasma", name = "Independência BC") +
  labs(
    title = "Classe 'Low': Resposta da Inflação à Taxa Real",
    subtitle = "Δ Inflação (t+1 - t) vs. Taxa Real de Juros",
    x = "Taxa Real de Juros (%)",
    y = "Δ Inflação (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Classificação Acemoglu")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 10, hjust = 0),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )


## 📊 Gráfico da Inflação contra a Inflação Esperada (com ou sem regime de meta)----

data %>%
  left_join(target, by = c("country" = "Pais")) %>%
  filter(
    !is.na(AnoAdocao),
    SegueAtualmente == "sim",
    year >= AnoAdocao,
    !is.na(inflation),
    !is.na(inflation_forecast),
    inflation > 0,
    inflation_forecast > 0
  ) %>%
  ggplot(aes(x = inflation_forecast, y = inflation)) +
  geom_point(alpha = 0.5, size = 2, color = "#43aa8b") +
  geom_smooth(method = "lm", se = FALSE, color = "#005f73", linewidth = 1.2) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "grey50") +
  labs(
    title = "Países que Seguem Regime de Metas",
    subtitle = "Inflação Observada vs. Esperada",
    x = "Inflação Esperada (%)",
    y = "Inflação Observada (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI + Targeting Dataset")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 10, hjust = 0),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(target, by = c("country" = "Pais")) %>%
  filter(
    !is.na(AnoAdocao),
    SegueAtualmente != "sim",
    year >= AnoAdocao,
    !is.na(inflation),
    !is.na(inflation_forecast),
    inflation > 0,
    inflation_forecast > 0
  ) %>%
  ggplot(aes(x = inflation_forecast, y = inflation)) +
  geom_point(alpha = 0.5, size = 2, color = "#f9c74f") +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2, color = "#f9844a") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "grey40") +
  labs(
    title = "Inflação Esperada vs. Observada — Países que Saíram do Regime",
    subtitle = "Apenas anos com regime ainda vigente à época",
    x = "Inflação Esperada (%)",
    y = "Inflação Observada (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + Surveys + Targeting dataset")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 10, hjust = 0),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(target, by = c("country" = "Pais")) %>%
  filter(
    is.na(AnoAdocao),
    !is.na(inflation),
    !is.na(inflation_forecast),
    inflation > 0,
    inflation_forecast > 0
  ) %>%
  ggplot(aes(x = inflation_forecast, y = inflation)) +
  geom_point(alpha = 0.5, size = 2, color = "#f94144") +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2, color = "#d1495b") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "grey40") +
  labs(
    title = "Inflação Esperada vs. Observada — Países sem Regime de Metas",
    subtitle = "Inclui todos os anos disponíveis",
    x = "Inflação Esperada (%)",
    y = "Inflação Observada (%)",
    caption = expression(bold("Fonte: ") ~ "WDI + Surveys")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 10, hjust = 0),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )


## 📊 Gráfico da média do CBIE dados países que seguem ou não as metas de inflação----

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

# 📈🧮 Estimação do Modelo GMM ----

## Preprando os dados para o GMM ----

painel <- pdata.frame(data, index = c("country", "year"))

## Estimando o modelo ----

modelo_gmm <- pgmm(
  formula = inflation ~ lag(inflation, 1) + real_rate * cbie_index + hiato_pct + inflation_forecast
  | lag(inflation, 2:3) + lag(real_rate, 2:3) + lag(inflation_forecast, 2:3) + cbie_index + hiato_pct,
  data           = painel,
  effect         = "individual",
  model          = "twosteps",
  transformation = "d"
)

coefs_gmm <- summary(modelo_gmm, robust = TRUE)$coefficients

tabela_gmm <- as.data.frame(coefs_gmm) %>%
  rownames_to_column("Variável") %>%
  rename(
    `Estimativa` = Estimate,
    `Erro Padrão` = `Std. Error`,
    `Estatística z` = `z-value`,
    `p-valor` = `Pr(>|z|)`
  ) %>%
  mutate(
    Signif = case_when(
      `p-valor` <= 0.001 ~ "***",
      `p-valor` <= 0.01 ~ "**",
      `p-valor` <= 0.05 ~ "*",
      `p-valor` <= 0.1 ~ ".",
      TRUE ~ ""
    )
  ) %>%
  gt() %>%
  tab_header(
    title = md("**Estimativas do Modelo GMM — Painel Completo**"),
    subtitle = "Modelo dinâmico com efeitos individuais e diferenciação em primeiras diferenças"
  ) %>%
  fmt_number(columns = where(is.numeric), decimals = 3) %>%
  cols_label(
    Variável = "Variável",
    `Estimativa` = "Coef.",
    `Erro Padrão` = "Erro Padrão",
    `Estatística z` = "z-valor",
    `p-valor` = "p-valor",
    Signif = " "
  ) %>%
  tab_source_note(md("*Nota: `***` 0.1% | `**` 1% | `*` 5% | `.` 10%*"))

tabela_gmm

## Modelo GMM com as Classificações de Acemoglu ----

painel <- left_join(painel, acemoglu_classification, by = c("country" = "Pais"))

gmm_high <- pgmm(
  formula = inflation ~ lag(inflation, 1) + real_rate * cbie_index + hiato_pct + inflation_forecast
  | lag(inflation, 2:3) + lag(real_rate, 2:3) + lag(inflation_forecast, 2:3) + cbie_index + hiato_pct,
  data = subset(painel, Classe == "High"),
  effect = "individual",
  model = "twosteps",
  transformation = "d"
)

coefs_gmm_high <- summary(gmm_high, robust = TRUE)$coefficients

tabela_gmm_high <- as.data.frame(coefs_gmm_high) %>%
  rownames_to_column("Variável") %>%
  rename(
    `Estimativa` = Estimate,
    `Erro Padrão` = `Std. Error`,
    `Estatística z` = `z-value`,
    `p-valor` = `Pr(>|z|)`
  ) %>%
  mutate(
    Signif = case_when(
      `p-valor` <= 0.001 ~ "***",
      `p-valor` <= 0.01 ~ "**",
      `p-valor` <= 0.05 ~ "*",
      `p-valor` <= 0.1 ~ ".",
      TRUE ~ ""
    )
  ) %>%
  gt() %>%
  tab_header(
    title = md("**Estimativas do Modelo GMM — Classe 'High'**"),
    subtitle = "Modelo dinâmico com efeitos individuais e diferenciação em primeiras diferenças"
  ) %>%
  fmt_number(columns = where(is.numeric), decimals = 3) %>%
  cols_label(
    Variável = "Variável",
    `Estimativa` = "Coef.",
    `Erro Padrão` = "Erro Padrão",
    `Estatística z` = "z-valor",
    `p-valor` = "p-valor",
    Signif = " "
  ) %>%
  tab_source_note(md("*Nota: `***` 0.1% | `**` 1% | `*` 5% | `.` 10%*"))

tabela_gmm_high

gmm_medium <- pgmm(
  formula = inflation ~ lag(inflation, 1) + real_rate * cbie_index + hiato_pct + inflation_forecast
  | lag(inflation, 2:3) + lag(real_rate, 2:3) + lag(inflation_forecast, 2:3) + cbie_index + hiato_pct,
  data = subset(painel, Classe == "Medium"),
  effect = "individual",
  model = "twosteps",
  transformation = "d"
)

coefs_gmm_medium <- summary(gmm_medium, robust = TRUE)$coefficients

tabela_gmm_medium <- as.data.frame(coefs_gmm_medium) %>%
  rownames_to_column("Variável") %>%
  rename(
    `Estimativa` = Estimate,
    `Erro Padrão` = `Std. Error`,
    `Estatística z` = `z-value`,
    `p-valor` = `Pr(>|z|)`
  ) %>%
  mutate(
    Signif = case_when(
      `p-valor` <= 0.001 ~ "***",
      `p-valor` <= 0.01 ~ "**",
      `p-valor` <= 0.05 ~ "*",
      `p-valor` <= 0.1 ~ ".",
      TRUE ~ ""
    )
  ) %>%
  gt() %>%
  tab_header(
    title = md("**Estimativas do Modelo GMM — Classe 'Medium'**"),
    subtitle = "Modelo dinâmico com efeitos individuais e diferenciação em primeiras diferenças"
  ) %>%
  fmt_number(columns = where(is.numeric), decimals = 3) %>%
  cols_label(
    Variável = "Variável",
    `Estimativa` = "Coef.",
    `Erro Padrão` = "Erro Padrão",
    `Estatística z` = "z-valor",
    `p-valor` = "p-valor",
    Signif = " "
  ) %>%
  tab_source_note(md("*Nota: `***` 0.1% | `**` 1% | `*` 5% | `.` 10%*"))

tabela_gmm_medium

modelo_low_fe <- fixest::feols(
  inflation ~ lag(inflation, 1) + real_rate * cbie_index + hiato_pct + inflation_forecast | country + year,
  data = subset(painel, Classe == "Low"),
  cluster = "country"
)

summary(modelo_low_fe)
