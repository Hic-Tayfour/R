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
library(plotly)       # Gráfico
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
  indicator = "FP.CPI.TOTL.ZG",
  start = 1960,
  end = NULL,
  extra = TRUE
) %>%
  filter(!country %in% agrupamentos) %>%
  select(country, iso2c, iso3c, year, FP.CPI.TOTL.ZG) %>%
  rename(inflation = FP.CPI.TOTL.ZG) %>%
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

target_panel_bond <- read_excel("target(macrobond).xlsx", sheet = "Sheet1") %>%
  rename(date = "...1") %>%
  mutate(date = as.Date(date, origin = "1899-12-30")) %>%
  mutate(year = year(date)) %>%
  group_by(year) %>%
  filter(date == max(date)) %>%
  ungroup() %>%
  pivot_longer(
    cols = -c(date, year),
    names_to = "full_country_name",
    values_to = "target"
  ) %>%
  mutate(country = gsub("^([^,]+),.*", "\\1", full_country_name)) %>%
  select(country, year, target) %>%
  filter(!is.na(target))%>%
  arrange(country, year)

target_panel_eikon <- read_excel("target(eikon).xlsx", sheet = "valores") %>%
  mutate(country = str_to_title(GEOGN)) %>%
  mutate(across(matches("^\\d+$"), as.character)) %>%
  pivot_longer(
    cols = matches("^\\d+$"),
    names_to = "date_num",
    values_to = "target"
  ) %>%
  mutate(
    target = na_if(target, "NA"),
    date = as.Date(as.numeric(date_num), origin = "1899-12-30"),
    year = year(date),
    target = as.numeric(target)
  ) %>%
  select(country, year, target) %>%
  arrange(country, year)


target <- target_panel_eikon %>%
  full_join(target_panel_bond, by = c("country", "year"), suffix = c("_eikon", "_bond")) %>%
  mutate(
    target = coalesce(target_eikon, target_bond)
  ) %>%
  select(country, year, target) %>%
  filter(year >= 2000, year <= 2023) %>%
  distinct(country, year, .keep_all = TRUE) %>%  
  mutate(
    iso3c = case_when(
      country == "Euro Area" ~ "EMU",
      TRUE ~ countrycode(country, "country.name", "iso3c")
    )
  ) %>%
  arrange(country, year)



acemoglu_classification <- data.frame(
  Pais = c("Argentina", "Australia", "Austria", "Belgium", "Bolivia", "Brazil", "Canada", 
           "Chile", "China", "Colombia", "Costa Rica", "Denmark", "Dominican Republic", 
           "Ecuador", "El Salvador", "Finland", "France", "Germany", "Greece", "Guatemala", 
           "Guyana", "Honduras", "India", "Indonesia", "Ireland", "Israel", "Italy", 
           "Japan", "South Korea","Malaysia", "Mexico", "Mongolia", "Nepal", "Netherlands", 
           "New Zealand", "Nicaragua", "Norway", "Pakistan", "Paraguay", "Peru", 
           "Philippines", "Portugal", "Qatar", "Singapore", "Spain", "Sweden", 
           "Switzerland", "Turkey", "United Kingdom", "United States of America", 
           "Uruguay", "Venezuela"),
  Classe = c("Medium", "High", "High", "Medium", "Medium", "Medium",
             "High", "Medium", "Medium", "Medium", "Medium", "High",
             "Medium", "Low", "Medium", "High", "Medium",
             "High", "Medium", "Low", "Medium", "Low", "Medium",
             "Low", "High", "Medium", "Medium", "Medium", "Medium", "Medium",
             "Medium", "Medium", "Medium", "High", "High", "Low",
             "High", "Low", "Low", "Medium", "Medium", "Medium",
             "Medium", "High", "Medium", "High", "High", "Medium",
             "High", "High", "Medium", "Low")
)

data <- cbi %>%
  inner_join(cpi  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(debt %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(gdp  %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(rate %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(inf_for %>% select(-country), by = c("iso3c", "year")) %>%
  inner_join(target %>% select(-country), by = c("iso3c", "year")) %>%
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
    real_rate,
    target
  ) %>%
  set_variable_labels(
    pib                = "GDP (constant 2015 US$)",
    inflation          = "Inflação (%)",
    inflation_forecast = "Expectativa de Inflação (%)",
    taxa_juros         = "Taxa de juros nominal (%)(BC)",
    cbie_index         = "Índice de independência do Banco Central (%)",
    divida             = "Dívida governamental (% do PIB)",
    pib_pot            = "PIB potencial (filtro HP)",
    hiato_pct          = "Hiato do produto (%)",
    real_rate          = "Taxa de juros real (%)",
    target             = "Meta de inflação (%)"
  ) %>% 
  mutate(across(where(~ inherits(.x, "matrix")), as.numeric)) %>%
  group_by(country, year) %>%
  slice(1) %>%
  ungroup()

# 📊 Gráficos ----

# Gráfico 1 : 📊 Gráfico da Base de dados 

data %>%
  mutate(across(
    c(pib,inflation,inflation_forecast,taxa_juros,cbie_index,divida,pib_pot,hiato_pct,real_rate,target
    ),
    ~ as.numeric(.x)
  )) %>% select(iso3c,pib,inflation,inflation_forecast,taxa_juros,cbie_index,divida,pib_pot,hiato_pct,real_rate,target
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
    values = c("#4DACD6","#4FAE62","#F6C54D","#E37D46","#C02D45","#8ecae6","#219ebc","#023047","#ffb703","#F94144"
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


# Gráfico 2 : 📊 Gráfico da Inflação Mundo Animada

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

# Gráfico 3 : 📊 Gráfico da Evolução do CBI

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

# Gráfico 4 : 📊 Gráfico da Inflação Anual 

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


# Gráfico 5 : 📊 Gráfico da Inflação anual (2000-Hoje; Países com Metas de inflação)

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


# Gráfico 6 : 📊 Gráfico da Resposta da Inflação à Taxa Real de Juros

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



# Gráfico 7 : 📊 Gráfico da média do CBIE dados países que seguem ou não as metas de inflação

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

# Gráfico 8 : 📊 Gráfico da média da inflação por classe institucional

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(!is.na(Classe)) %>%
  group_by(year, Classe) %>%
  summarise(inflacao_media = mean(inflation, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = year, y = inflacao_media, color = Classe)) +
  geom_line(size = 1.2) +
  scale_color_manual(
    values = c("Low" = "#C02D45", "Medium" = "#F6C54D", "High" = "#4FAE62")
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Evolução da Inflação Média por Nível Institucional",
    subtitle = "Classificação segundo Acemoglu — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + Classificação Acemoglu"),
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

# Gráfico 9 : 📊 Gráfico do PIB por classe institucional

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "High", !is.na(pib)) %>%
  mutate(country = fct_reorder(country, pib, .fun = max)) %>%
  ggplot(aes(x = year, y = pib, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(
    values = c(
      "#4DACD6", "#4FAE62", "#F6C54D", "#E37D46", "#C02D45", "#8ecae6",
      "#219ebc", "#023047", "#ffb703", "#9b5de5", "#9F86C0", "#5E548E",
      "#2A9D8F", "#E76F51", "#264653", "#F8961E", "#43AA8B", "#F94144",
      "#90BE6D"
    )
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Evolução do PIB por País com Instituições 'High'",
    subtitle = "Séries Temporais Individuais — 2000 a 2023",
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
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Medium", !is.na(pib)) %>%
  mutate(country = fct_reorder(country, pib, .fun = max)) %>%
  ggplot(aes(x = year, y = pib, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(
    values = c(
      "#4DACD6", "#4FAE62", "#F6C54D", "#E37D46", "#C02D45", "#8ecae6",
      "#219ebc", "#023047", "#ffb703", "#9b5de5", "#9F86C0", "#5E548E",
      "#2A9D8F", "#E76F51", "#264653", "#F8961E", "#43AA8B", "#F94144",
      "#90BE6D"
    )
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Evolução do PIB por País com Instituições 'Medium'",
    subtitle = "Séries Temporais Individuais — 2000 a 2023",
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
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Low", !is.na(pib)) %>%
  mutate(country = fct_reorder(country, pib, .fun = max)) %>%
  ggplot(aes(x = year, y = pib, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(
    values = c(
      "#4DACD6", "#4FAE62", "#F6C54D", "#E37D46", "#C02D45", "#8ecae6",
      "#219ebc", "#023047", "#ffb703", "#9b5de5", "#9F86C0", "#5E548E",
      "#2A9D8F", "#E76F51", "#264653", "#F8961E", "#43AA8B", "#F94144",
      "#90BE6D"
    )
  ) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Evolução do PIB por País com Instituições 'Low'",
    subtitle = "Séries Temporais Individuais — 2000 a 2023",
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
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

# Gráfico 10 : 📊 Gráfico da inflação anual por classe institucional

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "High", !is.na(inflation)) %>%
  mutate(country = fct_reorder(country, inflation, .fun = max)) %>%
  ggplot(aes(x = year, y = inflation, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(20, option = "C")) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Inflação Anual por País com Instituições 'High'",
    subtitle = "Séries Temporais Individuais — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Medium", !is.na(inflation)) %>%
  mutate(country = fct_reorder(country, inflation, .fun = max)) %>%
  ggplot(aes(x = year, y = inflation, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(20, option = "H")) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Inflação Anual por País com Instituições 'Medium'",
    subtitle = "Séries Temporais Individuais — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Low", !is.na(inflation)) %>%
  mutate(country = fct_reorder(country, inflation, .fun = max)) %>%
  ggplot(aes(x = year, y = inflation, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(20, option = "D")) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  labs(
    title = "Inflação Anual por País com Instituições 'Low'",
    subtitle = "Séries Temporais Individuais — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + CBIE + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )



# Gráfico 11 : 📊 Gráfico da taxa de juros nominal dos bancos centrais

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "High", !is.na(taxa_juros)) %>%
  mutate(country = fct_reorder(country, taxa_juros, .fun = max)) %>%
  ggplot(aes(x = year, y = taxa_juros, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(15, option = "C")) +
  labs(
    title = "Taxa de Juros Nominal dos Bancos Centrais",
    subtitle = "Países com Instituições 'High' — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "IMF + CBIE + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Medium", !is.na(taxa_juros)) %>%
  mutate(country = fct_reorder(country, taxa_juros, .fun = max)) %>%
  ggplot(aes(x = year, y = taxa_juros, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(19, option = "H")) +
  labs(
    title = "Taxa de Juros Nominal dos Bancos Centrais",
    subtitle = "Países com Instituições 'Medium' — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "IMF + CBIE + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Low", !is.na(taxa_juros)) %>%
  mutate(country = fct_reorder(country, taxa_juros, .fun = max)) %>%
  ggplot(aes(x = year, y = taxa_juros, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(20, option = "D")) +
  labs(
    title = "Taxa de Juros Nominal dos Bancos Centrais",
    subtitle = "Países com Instituições 'Low' — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "IMF + CBIE + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )


# Gráfico 12 : 📊 Gráfico do hiato do produto por classe institucional

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "High", !is.na(hiato_pct)) %>%
  mutate(country = fct_reorder(country, hiato_pct, .fun = max)) %>%
  ggplot(aes(x = year, y = hiato_pct, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(18, option = "C")) +
  labs(
    title = "Hiato do Produto por País (Classe 'High')",
    subtitle = "Diferença entre PIB real e potencial — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + Filtro HP + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Medium", !is.na(hiato_pct)) %>%
  mutate(country = fct_reorder(country, hiato_pct, .fun = max)) %>%
  ggplot(aes(x = year, y = hiato_pct, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(20, option = "H")) +
  labs(
    title = "Hiato do Produto por País (Classe 'Medium')",
    subtitle = "Diferença entre PIB real e potencial — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + Filtro HP + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(Classe == "Low", !is.na(hiato_pct)) %>%
  mutate(country = fct_reorder(country, hiato_pct, .fun = max)) %>%
  ggplot(aes(x = year, y = hiato_pct, color = country)) +
  geom_line(size = 1) +
  scale_color_manual(values = viridis::viridis(20, option = "D")) +
  labs(
    title = "Hiato do Produto por País (Classe 'Low')",
    subtitle = "Diferença entre PIB real e potencial — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + Filtro HP + Classificação Acemoglu"),
    x = NULL, y = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "left",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )


# Gráfico 13 : 📊 Gráfico da inflação observada vs. esperada

data %>%
  filter(!is.na(inflation), !is.na(inflation_forecast)) %>%
  filter(country %in% c("Brazil", "Chile", "Mexico", "South Africa", "United Kingdom")) %>%
  pivot_longer(cols = c(inflation, inflation_forecast),
               names_to = "tipo_inflacao", values_to = "valor") %>%
  ggplot(aes(x = year, y = valor, color = tipo_inflacao)) +
  geom_line(size = 1) +
  facet_wrap(~country, scales = "free_y") +
  scale_color_manual(
    values = c("inflation" = "#E76F51", "inflation_forecast" = "#264653"),
    labels = c("Inflacao Observada", "Inflacao Esperada")
  ) +
  labs(
    title = "Inflação Observada vs. Esperada",
    subtitle = "Comparação entre séries para países selecionados",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI (Expectativas)"),
    x = NULL, y = NULL, color = NULL
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "top",
    legend.text = element_text(size = 10),
    legend.title = element_blank(),
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

data %>%
  filter(!is.na(inflation), !is.na(inflation_forecast)) %>%
  mutate(diferenca = inflation - inflation_forecast) %>%
  filter(country %in% c("Brazil", "Chile", "Mexico", "South Africa", "United Kingdom")) %>%
  ggplot(aes(x = year, y = diferenca, fill = country)) +
  geom_col(position = "dodge") +
  facet_wrap(~country, scales = "free_y") +
  scale_fill_manual(values = c(
    "#4DACD6", "#F6C54D", "#E76F51", "#264653", "#2A9D8F"
  )) +
  labs(
    title = "Diferença entre Inflação Observada e Esperada",
    subtitle = "Inflação Observada - Inflação Esperada — 2000 a 2023",
    caption = expression(bold("Fonte: ") ~ "WDI + FMI"),
    x = NULL, y = "Diferença em pontos percentuais"
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    legend.position = "none",
    panel.grid.major.y = element_line(color = "grey80"),
    panel.grid.major.x = element_blank()
  )

# Gráfico 14 : 📊 Gráfico de Barras do Princípio de Taylor (Coeficiente de Resposta à Inflação)

data %>%
  mutate(nivel_cbie = case_when(
    cbie_index <= 0.25 ~ "0.00-0.25",
    cbie_index <= 0.50 ~ "0.25-0.50",
    cbie_index <= 0.75 ~ "0.50-0.75",
    TRUE ~ "0.75-1.00"
  ),
  nivel_cbie = factor(nivel_cbie, levels = c("0.00-0.25", "0.25-0.50", "0.50-0.75", "0.75-1.00"))) %>%
  group_by(nivel_cbie) %>%
  summarise(
    coef_taylor = coef(lm(taxa_juros ~ inflation))[2],
    se_taylor = summary(lm(taxa_juros ~ inflation))$coefficients[2, 2]
  ) %>%
  ggplot(aes(x = nivel_cbie, y = coef_taylor, fill = nivel_cbie)) +
  geom_col(width = 0.7) +
  geom_errorbar(aes(ymin = coef_taylor - se_taylor, ymax = coef_taylor + se_taylor), width = 0.2) +
  geom_text(aes(label = round(coef_taylor, 2)), vjust = -0.5, size = 4) +
  scale_fill_manual(values = c("#E37D46", "#F6C54D", "#4FAE62", "#4DACD6")) +
  labs(
    title = "Regra de Taylor: Resposta da Taxa de Juros à Inflação",
    subtitle = "Coeficiente de resposta por nível de independência do Banco Central",
    x = "Nível de Independência do Banco Central",
    y = "Coeficiente da Regra de Taylor",
    caption = expression(bold("Fonte: ") ~ "CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    legend.position = "none",
    panel.grid.major.y = element_line(color = "grey90")
  )

# Gráfico 15 : 📊 Gráfico de Barras Comparando a Volatilidade da Inflação

data %>%
  mutate(nivel_cbie = case_when(
    cbie_index <= 0.25 ~ "0.00-0.25",
    cbie_index <= 0.50 ~ "0.25-0.50",
    cbie_index <= 0.75 ~ "0.50-0.75",
    TRUE ~ "0.75-1.00"
  ),
  nivel_cbie = factor(nivel_cbie, levels = c("0.00-0.25", "0.25-0.50", "0.50-0.75", "0.75-1.00"))) %>%
  group_by(nivel_cbie) %>%
  summarise(
    media_inflacao = mean(inflation, na.rm = TRUE),
    desvio_padrao = sd(inflation, na.rm = TRUE),
    coef_variacao = desvio_padrao / media_inflacao,
    contagem = n()
  ) %>%
  ggplot(aes(x = nivel_cbie, y = desvio_padrao, fill = nivel_cbie)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = round(desvio_padrao, 2)), vjust = -0.5, color = "black", size = 4) +
  scale_fill_manual(values = c("#E37D46", "#F6C54D", "#4FAE62", "#4DACD6")) +
  labs(
    title = "Volatilidade da Inflação por Nível de Independência do BC",
    subtitle = "Desvio padrão da inflação para diferentes níveis de independência",
    x = "Nível de Independência do Banco Central",
    y = "Desvio Padrão da Inflação",
    caption = expression(bold("Fonte: ") ~ "CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    legend.position = "none",
    panel.grid.major.y = element_line(color = "grey90")
  )

# Gráfico 16 : 📊 Gráfico da Volatilidade da Inflação por Classificação de Acemoglu

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(!is.na(Classe)) %>% 
  mutate(Classe = factor(Classe, levels = c("Low", "Medium", "High"))) %>%
  group_by(Classe) %>%
  summarise(
    media_inflacao = mean(inflation, na.rm = TRUE),
    desvio_padrao = sd(inflation, na.rm = TRUE),
    coef_variacao = desvio_padrao / media_inflacao,
    contagem = n()
  ) %>%
  ggplot(aes(x = Classe, y = desvio_padrao, fill = Classe)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = round(desvio_padrao, 2)), vjust = -0.5, color = "black", size = 4) +
  scale_fill_manual(values = c("#E37D46", "#F6C54D", "#4DACD6")) +
  labs(
    title = "Volatilidade da Inflação por Classificação de Independência do BC",
    subtitle = "Desvio padrão da inflação para diferentes níveis de independência (Acemoglu)",
    x = "Nível Institucional (Acemoglu)",
    y = "Desvio Padrão da Inflação",
    caption = expression(bold("Fonte: ") ~ "Acemoglu et. al + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    legend.position = "none",
    panel.grid.major.y = element_line(color = "grey90")
  )

# Gráfico 17 : 📊 Gráfico da Regra de Taylor por Classificação de Acemoglu

data %>%
  left_join(acemoglu_classification, by = c("country" = "Pais")) %>%
  filter(!is.na(Classe)) %>% 
  mutate(Classe = factor(Classe, levels = c("Low", "Medium", "High"))) %>%
  group_by(Classe) %>%
  summarise(
    coef_taylor = coef(lm(taxa_juros ~ inflation))[2],
    se_taylor = summary(lm(taxa_juros ~ inflation))$coefficients[2, 2]
  ) %>%
  ggplot(aes(x = Classe, y = coef_taylor, fill = Classe)) +
  geom_col(width = 0.7) +
  geom_errorbar(aes(ymin = coef_taylor - se_taylor, ymax = coef_taylor + se_taylor), width = 0.2) +
  geom_text(aes(label = round(coef_taylor, 2)), vjust = -0.5, size = 4) +
  scale_fill_manual(values = c("#E37D46", "#F6C54D", "#4DACD6")) +
  labs(
    title = "Regra de Taylor: Resposta da Taxa de Juros à Inflação",
    subtitle = "Coeficiente de resposta por classificação de Acemoglu",
    x = "Nível Institucional (Acemoglu)",
    y = "Coeficiente da Regra de Taylor",
    caption = expression(bold("Fonte: ") ~ "Acemoglu et. al + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 10, color = "black"),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    legend.position = "none",
    panel.grid.major.y = element_line(color = "grey90")
  )


# 📈🧮 Estimação do Modelo GMM ----

## 🧮 Preparando os Dados ----

panel <- data %>%
  mutate(inflation_gap = inflation - target) %>%
  pdata.frame(index = c("iso3c", "year"))

# GMM usando "inflation_gap" como variável dependente
gmm_model <- pgmm(
  formula = inflation_gap ~
    lag(inflation_gap, 1) +        
    cbie_index * real_rate +       
    lag(hiato_pct, 1) +            
    inflation_forecast             
  |
    lag(inflation_gap, 3:4) +      
    lag(real_rate, 2:3) +          
    lag(inflation_forecast, 3:4) + 
    cbie_index +                   
    lag(hiato_pct, 3:4),           
  data           = panel,
  effect         = "individual",
  model          = "twosteps",
  transformation = "ld"
)

summary(gmm_model)
