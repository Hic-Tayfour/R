# 📚 Importando as Bibliotecas Necessárias ----

library(rnaturalearth)# Conjunto de dados e mapas de países
library(CGPfunctions) # Gráficos
library(countrycode)  # Nomeação de Países
library(tidyverse)    # Tratamento, Manipulação e Visualização de Dados
library(tidyquant)    # Dados Financeiros
library(gridExtra)    # Gráficos 
library(patchwork)    # Gráficos Organizados
library(gganimate)    # Gráficos Animados
library(ggeffects)    # Gráficos
library(labelled)     # Rótulos
library(ggthemes)     # Gráficos
library(seasonal)     # Ajuste sazonal para séries temporais
library(imf.data)     # Dados do IMF
library(gtExtras)     # Gráficos
library(ggstream)     # Gráficos
library(ggrepel)      # Gráficos
library(rugarch)      # Modelos GARCH
library(stringr)      # Manipulação de strings
library(viridis)      # Gráficos
library(mFilter)      # Filtro HP 
library(fixest)       # Dados em painel
library(ggtext)       # Gráfico
library(plotly)       # Gráfico
library(readxl)       # Leitura de arquivos excel
library(sidrar)       # Baixar dados do IBGE
library(scales)       # Gráficos
library(broom)        # Gráficos
library(glue)         # Gráficos
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

euro_area <- tibble(country = c(
  "Austria", "Belgium", "Bulgaria", "Croatia", "Republic of Cyprus", 
  "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany",
  "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", 
  "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania",
  "Slovakia", "Slovenia", "Spain", "Sweden"
)) %>%
  mutate(
    iso3c = countrycode(country, "country.name", "iso3c"),
    iso2c = countrycode(country, "country.name", "iso2c")
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
  select(country, iso_a3, year, cbie_index, cbie_policy, cbie_policy_q1
) %>%
  mutate(year = as.numeric(year)) %>%
  arrange(country, year) %>%
  rename(iso3c = iso_a3) %>%
  select(country, iso3c, year, cbie_index, cbie_policy, cbie_policy_q1)

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

data_wide_ifs <- ifs$get_series(
  freq         = "A",
  ref_area     = NULL,
  indicator    = "FPOLM_PA",
  start_period = "1960",
  end_period   = "2025"
)

rate <- data_wide_ifs %>%
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

rate_macrobond <- read_excel("rate_macrobond.xlsx") %>%
  rename(date = ...1) %>%
  pivot_longer(
    cols = -date,
    names_to = "full_country_name",
    values_to = "taxa_juros"
  ) %>%
  mutate(
    country = str_extract(full_country_name, "^[^,]+"),
    taxa_juros = as.numeric(taxa_juros),
    year = year(date)
  ) %>%
  filter(!is.na(taxa_juros)) %>%
  group_by(country, year) %>%
  filter(date == max(date)) %>%
  ungroup() %>%
  select(country, year, taxa_juros) %>%
  filter(year <= 2023) %>%
  arrange(country, year)

rate <- rate %>%
  mutate(taxa_juros = as.numeric(taxa_juros)) %>%
  filter(!country %in% euro_area$country) %>%
  bind_rows(
    rate_macrobond %>%
      semi_join(euro_area, by = "country")
  ) %>%
  mutate(
    iso2c = countrycode(country, origin = "country.name", destination = "iso2c"),
    iso3c = countrycode(country, origin = "country.name", destination = "iso3c")
  ) %>%
  arrange(country, year)

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
  bind_rows(
    target_panel_bond %>%
      filter(country == "Euro Area", year >= 2000, year <= 2023) %>%
      select(year, target) %>%
      crossing(country = euro_area$country)  
  ) %>%
  filter(year >= 2000, year <= 2023) %>%
  distinct(country, year, .keep_all = TRUE) %>%
  mutate(
    iso3c = case_when(
      country == "Euro Area" ~ "EMU",
      TRUE ~ countrycode(country, "country.name", "iso3c")
    )
  ) %>%
  arrange(country, year)


data_wide_fm <- load_datasets("FM")$get_series(
  freq        = "A",
  ref_area    = NULL,                       
  indicator   = "GGXONLB_G01_GDP_PT",        
  start_period = "1990",
  end_period   = "2025"
)

capb <- data_wide_fm %>%
  pivot_longer(-TIME_PERIOD,
               names_to  = "col_indicator",
               values_to = "capb") %>%
  mutate(
    iso2c = sub("^A\\.([^.]*)\\..*$", "\\1", col_indicator),
    iso2c = if_else(iso2c %in% c("7A","U2"), "EA", iso2c),
    year  = as.integer(TIME_PERIOD),
    capb  = as.numeric(capb)
  ) %>%
  filter(grepl("^[A-Z]{2}$", iso2c)) %>%        
  mutate(                                       
    iso3c = case_when(
      iso2c == "EA" ~ "EMU", 
      iso2c == "XK" ~ "XKX", 
      TRUE ~ countrycode(iso2c, "iso2c", "iso3c", warn = FALSE)
    ),
    country = case_when(
      iso2c == "EA" ~ "Euro Area",
      iso2c == "XK" ~ "Kosovo",
      TRUE ~ countrycode(iso2c, "iso2c", "country.name", warn = FALSE)
    )
  ) %>%
  arrange(country, year) %>%
  group_by(country) %>%
  mutate(impulso_fiscal = -(capb - dplyr::lag(capb, order_by = year))) %>%
  ungroup() %>%
  select(country, iso2c, iso3c, year, capb, impulso_fiscal) %>%
  semi_join(
    target %>% filter(year >= 2000, year <= 2023) %>% distinct(iso3c, year),
    by = c("iso3c", "year")
  ) %>%
  mutate(iso2c_original = iso2c) %>%
  select(-iso2c) %>%
  rename(iso2c = iso2c_original)

debt <- debt %>%
  left_join(
    capb %>% 
      select(iso3c, year, impulso_fiscal) %>% 
      distinct(),
    by = c("iso3c", "year")
  )

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
  filter(year >= 2000, iso3c %in% (target %>% distinct(iso3c) %>% pull(iso3c))) %>%
  left_join(cpi %>% select(-country), by = c("iso3c", "year")) %>%
  left_join(debt %>% select(-country), by = c("iso3c", "year")) %>%
  left_join(gdp %>% select(-country), by = c("iso3c", "year")) %>%
  left_join(rate %>% select(-country), by = c("iso3c", "year")) %>%
  left_join(inf_for %>% select(-country), by = c("iso3c", "year")) %>%
  left_join(
    target %>% select(-country) %>% distinct(iso3c, year, .keep_all = TRUE),
    by = c("iso3c", "year")
  ) %>%
  select(-c(iso2c.y, iso2c.x.x, iso2c.y.y)) %>%
  rename(iso2c = iso2c.x) %>%
  group_by(country) %>%
  arrange(year) %>%
  mutate(
    taxa_juros = as.numeric(taxa_juros),
    pib_pot = hpfilter(pib, freq = 6.25)$trend,
    hiato_pct = ((pib - pib_pot) / pib_pot) * 100,
    real_rate = ((1 + taxa_juros) / (1 + inflation)) - 1,
    gap = (inflation - target),
    gap2 = abs(gap)
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
    cbie_policy,
    cbie_policy_q1,
    divida,
    impulso_fiscal,
    pib_pot,
    hiato_pct,
    real_rate,
    target,
    gap,
    gap2
  ) %>%
  set_variable_labels(
    pib = "GDP (constant 2015 US$)",
    inflation = "Inflação (%)",
    inflation_forecast = "Expectativa de Inflação (%)",
    taxa_juros = "Taxa de juros nominal (%)(BC)",
    cbie_index = "Índice de independência do Banco Central (%)",
    cbie_policy = "Índice de independência do Banco Central (política monetária)",
    cbie_policy_q1 = "Índice de independência do Banco Central (política monetária Q1)",
    divida = "Dívida governamental (% do PIB)",
    impulso_fiscal = "Impulso fiscal (% do PIB)",
    pib_pot = "PIB potencial (filtro HP)",
    hiato_pct = "Hiato do produto (%)",
    real_rate = "Taxa de juros real (%)",
    target = "Meta de inflação (%)",
    gap = "Desvio da inflação em relação à meta (p.p.)",
    gap2 = "Desvio da inflação em relação à meta (p.p. absoluta)"
  ) %>%
  mutate(across(where(~ inherits(.x, "matrix")), as.numeric)) %>%
  group_by(country, year) %>%
  slice(1) %>%
  ungroup()

analisar_ocorrencias <- function(dados) {
  variaveis_banco <- c("pib", "inflation", "inflation_forecast", "target", 
                       "taxa_juros", "divida", "impulso_fiscal","cbie_index")
  
  nomes_variaveis <- c("PIB", "Inflação", "Inflação Esperada", "Meta de Inflação", 
                       "Taxa Nominal de Juros", "Dívida", "Impulso Fiscal" ,"CBI")
  
  total_paises <- n_distinct(dados$country)
  total_anos <- n_distinct(dados$year)
  total_esperado <- total_paises * total_anos
  
  qtd_observada <- numeric(length(variaveis_banco))
  paises_completos <- numeric(length(variaveis_banco))
  paises_incompletos <- numeric(length(variaveis_banco))
  paises_sem_dados <- numeric(length(variaveis_banco))
  
  for (i in seq_along(variaveis_banco)) {
    var <- variaveis_banco[i]
    
    qtd_observada[i] <- sum(!is.na(dados[[var]]))
    
    por_pais <- dados %>%
      group_by(country) %>%
      summarise(
        total_anos_esperados = n(),
        anos_com_dados = sum(!is.na(.data[[var]])),
        completo = anos_com_dados == total_anos_esperados,
        sem_dados = anos_com_dados == 0,
        .groups = "drop"
      )
    
    paises_completos[i] <- sum(por_pais$completo)
    paises_sem_dados[i] <- sum(por_pais$sem_dados)
    paises_incompletos[i] <- total_paises - paises_completos[i] - paises_sem_dados[i]
  }
  
  valores_linhas <- c(
    rep(total_esperado, length(variaveis_banco)),  
    qtd_observada,                                 
    paises_completos,                              
    paises_incompletos,                            
    paises_sem_dados                               
  )
  
  list(
    nomes_variaveis = nomes_variaveis,
    valores_linhas = valores_linhas
  )
}

criar_tabela_formatada_novo <- function(titulo, subtitulo, fonte, nomes_linhas, nomes_colunas, valores_linhas) {
  
  dados <- data.frame(
    Variável = nomes_linhas,
    matrix(valores_linhas, nrow = length(nomes_linhas), byrow = FALSE)
  )
  
  colnames(dados) <- c("Variável", nomes_colunas)
  
  gt(dados) %>%
    tab_header(
      title = md("**Base de Dados**"),
      subtitle = md(paste0("*", subtitulo, "*"))
    ) %>%
    tab_source_note(
      source_note = md(fonte)
    ) %>%
    tab_style(
      style = cell_text(weight = "bold"),
      locations = list(
        cells_column_labels(everything()),
        cells_body(columns = "Variável")
      )
    ) %>%
    cols_align(align = "center", columns = -1) %>%
    tab_options(table.font.size = 12) %>%
    fmt_number(columns = -1, decimals = 0, sep_mark = ".")
}


criar_tabela_ocorrencias_novo <- function(dados) {
  resultados <- analisar_ocorrencias(dados)
  
  titulo <- "Análise de Ocorrências nos Dados Macroeconômicos"
  subtitulo <- paste0("Base com ", n_distinct(dados$country), " países e ", 
                      n_distinct(dados$year), " anos (", min(dados$year), "-", max(dados$year), ")")
  fonte <- "Fonte: WDI, IMF-IFS, TheGlobalEconomy, Eikon, MacroBond"
  
  nomes_linhas <- c("Qtd Total Esperada", "Qtd Total Observada",
                    "Qtd de Países com Todos os Dados",
                    "Qtd de Países Incompletos",
                    "Qtd de Países sem nenhum dado")
  
  nomes_colunas <- resultados$nomes_variaveis
  
  valores_linhas <- matrix(resultados$valores_linhas,
                           nrow = length(nomes_linhas),
                           byrow = TRUE)
  
  criar_tabela_formatada_novo(
    titulo = titulo,
    subtitulo = subtitulo,
    fonte = fonte,
    nomes_linhas = nomes_linhas,
    nomes_colunas = nomes_colunas,
    valores_linhas = valores_linhas
  )
}

tabela_ocorrencias_novo <- criar_tabela_ocorrencias_novo(data)
print(tabela_ocorrencias_novo)

manter <- c("data",
            "acemoglu_classification")

rm(list = setdiff(ls(), manter))

# 📊 Gráficos ----

## 📊 Gráfico da Visualização da Base de Dados 

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

## 📊 Gráfico dos Paises e a proporção de dados

world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(iso_a3 != "ATA")

world %>%
  left_join(
    data %>%
      select(iso3c, year,
             pib, inflation, inflation_forecast, taxa_juros, cbie_index,
             divida, pib_pot, hiato_pct, real_rate, target) %>%
      pivot_longer(cols = -c(iso3c, year),
                   names_to = "variavel",
                   values_to = "valor") %>%
      filter(!is.na(valor)) %>%
      count(iso3c, name = "n_obs") %>%
      mutate(
        total_ideal = 10 * n_distinct(data$year),
        prop_dados  = n_obs / total_ideal
      ),
    by = c("iso_a3" = "iso3c")
  ) %>%
  ggplot() +
  geom_sf(aes(fill = prop_dados), color = "black", size = .1) +
  scale_fill_gradient2(
    low       = paletteer::paletteer_c("ggthemes::Red-Blue Diverging", 30)[1],    
    mid       = paletteer::paletteer_c("ggthemes::Red-Blue Diverging", 30)[15],   
    high      = paletteer::paletteer_c("ggthemes::Red-Blue Diverging", 30)[30],   
    midpoint  = 0.5,
    na.value  = "white",
    name      = "Proporção de\nDados (%)",
    limits    = c(0, 1),
    labels    = percent_format(accuracy = 1)
  ) +
  labs(
    title    = "Cobertura Global por País",
    subtitle = "Proporção de variáveis com dados disponíveis (2000–2023)",
    caption  = expression(bold("Fonte: ") ~ "WDI + CBIE + FMI + Natural Earth")
  ) +
  coord_sf(expand = FALSE) +
  theme_void(base_size = 13) +
  theme(
    plot.title      = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle   = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption    = element_text(size = 10, hjust = 0, color = "gray30"),
    legend.position = "right",
    legend.title    = element_text(face = "bold", size = 10),
    legend.text     = element_text(size = 9),
    plot.margin     = margin(2, 2, 2, 2)
  )

## 📊 Gráfico da Inflação por Grupo de Independência do Banco Central

data %>%
  filter(!is.na(inflation), !is.na(cbie_index)) %>%
  mutate(
    grupo_indep = if_else(
      cbie_index >= quantile(cbie_index, 0.75, na.rm = TRUE),
      "Alta Independência", "Baixa Independência"
    )
  ) %>%
  group_by(year, grupo_indep) %>%
  summarise(avg_infl = mean(inflation), .groups = "drop") %>%
  ggplot(aes(x = year, y = avg_infl, color = grupo_indep)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c("Alta Independência" = "#023047", "Baixa Independência" = "#ffb703"),
    name = ""
  ) +
  labs(
    title    = "Evolução da Inflação Média por Grupo de Independência",
    subtitle = "Comparação entre os 25% países mais e menos independentes",
    x        = "Ano",
    y        = "Inflação Média (%)",
    caption  = expression(bold("Fonte: ") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title   = element_text(face = "bold", size = 16, hjust = 0),
    legend.position = "bottom",
    legend.text  = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80")
  )

## 📊 Gráfico da Média do Hiato Inflacionário

data %>%
  mutate(
    cbie_index = as.numeric(cbie_index),
    gap        = as.numeric(gap)
  ) %>%
  filter(!is.na(cbie_index), !is.na(gap)) %>%
  mutate(decil = ntile(cbie_index, 10)) %>%
  group_by(decil) %>%
  summarise(
    mean_gap = mean(gap),
    sd_gap   = sd(gap),
    .groups  = "drop"
  ) %>%
  ggplot(aes(x = decil, y = mean_gap)) +
  geom_line(color = "#219ebc", size = 1.2) +
  geom_point(color = "#023047", size = 3) +
  geom_errorbar(
    aes(ymin = mean_gap - sd_gap, ymax = mean_gap + sd_gap),
    width = 0.2, color = "#219ebc"
  ) +
  scale_x_continuous(
    breaks = 1:10,
    labels = paste0(1:10, "º")
  ) +
  labs(
    title    = "Média do Hiato Inflacionário por Decil de Independência do BC",
    subtitle = "Linha de tendência com barras de ±1 desvio-padrão",
    x        = "Decil do Índice de Independência",
    y        = "Gap Inflacionário Médio (p.p.)",
    caption  = expression(bold("Fonte: ") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.title        = element_text(face = "bold"),
    axis.text         = element_text(size = 10),
    plot.title        = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle     = element_text(size = 12, hjust = 0, margin = margin(b = 6)),
    plot.caption      = element_text(size = 9, hjust = 0, color = "black"),
    panel.grid.major.y = element_line(color = "grey90"),
    panel.grid.major.x = element_blank()
  )


## 📊 Gráfico da Evolução do CBI

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

## 📊 Gráfico da Evolução da Variáveis 

data %>%
  select(year, cbie_index, inflation, real_rate, gap) %>%
  filter(across(everything(), ~ !is.na(.))) %>% 
  group_by(year) %>%
  summarise(across(c(cbie_index, inflation, real_rate, gap), ~ mean(.x, na.rm = TRUE)), .groups = "drop") %>%
  pivot_longer(cols = -year, names_to = "variavel", values_to = "valor") %>%
  ggplot(aes(x = year, y = valor, color = variavel)) +
  geom_line(size = 1.2) +
  facet_wrap(~ variavel, scales = "free_y", ncol = 2, strip.position = "top") +
  scale_color_manual(values = c(
    "cbie_index" = "#4DACD6",
    "gap"        = "#4FAE62",
    "inflation"  = "#F6C54D",
    "real_rate"  = "#E37D46"
  )) +
  labs(
    title    = "Evolução de Indicadores Macroeconômicos (2000–2023)",
    subtitle = "Médias globais por ano: inflação, hiato, juros reais e independência do BC",
    x        = "Ano",
    y        = "Valor médio",
    caption  = expression(bold("Fonte:") ~ " WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 14) +
  theme(
    plot.title      = element_text(face = "bold", size = 15),
    plot.subtitle   = element_text(size = 12, margin = margin(b = 10)),
    strip.text      = element_text(face = "bold", size = 12),
    panel.spacing   = unit(1.5, "lines"),
    plot.caption    = element_text(hjust = 0, size = 10, color = "gray30", margin = margin(t = 12)),
    axis.text       = element_text(color = "gray20"),
    legend.position = "none"
  )


## 📊 Gráfico da Volatilidade da Inflação

data %>% 
  mutate(across(c(year, gap, cbie_index), as.numeric)) %>% 
  filter(!is.na(gap), !is.na(cbie_index)) %>% 
  filter(n() >= 12, .by = country) %>% 
  group_by(country) %>% 
  arrange(year, .by_group = TRUE) %>% 
  nest() %>% 
  mutate(
    garch_out = map(data, ~{
      spec <- ugarchspec(
        variance.model = list(
          model      = "eGARCH",   
          garchOrder = c(1, 1)
        ),
        mean.model     = list(armaOrder = c(0, 0)),   
        distribution.model = "std"  
      )
      
      fit <- tryCatch(
        ugarchfit(spec, data = .x$gap, solver = "hybrid"),
        error = function(e) NULL
      )
      
      if (!is.null(fit)) {
        tibble(
          cbie_index = .x$cbie_index,
          sigma_t    = as.numeric(sigma(fit)) 
        )
      } else {
        tibble(cbie_index = numeric(0), sigma_t = numeric(0))
      }
    })
  ) %>% 
  unnest(garch_out) %>% 
  filter(!is.na(sigma_t)) %>% 
  ggplot(aes(cbie_index, sigma_t)) +
  geom_point(alpha = .12, size = 1, colour = "#000000") +
  stat_density_2d_filled(contour_var = "density", adjust = 1.2, alpha = 0.85) +
  stat_density_2d(contour_var = "density", adjust = 1.2,
                  size = 0.25, colour = "grey50", show.legend = FALSE) +
  scale_fill_viridis_d(option = "plasma") +
  scale_x_continuous(
    breaks = seq(0.2, 0.9, 0.1),
    labels = scales::label_percent(accuracy = 1),
    name   = "Índice de Independência do Banco Central"
  ) +
  scale_y_continuous(
    limits = c(0, 6),
    breaks = 0:6,
    name   = "Volatilidade Condicional do Gap Inflacionário"
  ) +
  labs(
    title    = "Independência do BC e Volatilidade do Gap Inflacionário",
    subtitle = "Estimativas EGARCH(1,1) — ~1030 observações de país-ano (2000–2023)",
    caption  = expression(bold("Fonte:") ~ " WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title      = element_text(face = "bold", size = 15, hjust = 0),
    plot.subtitle   = element_text(size = 11.5, hjust = 0),
    axis.title      = element_text(face = "bold"),
    axis.text       = element_text(color = "gray20"),
    plot.caption    = element_text(hjust = 0, size = 10, color = "gray40"),
    legend.position = "none",
    panel.grid.major.y = element_line(colour = "grey85", linewidth = 0.3)
  )


## 📊 Gráfico do Gap de Inflação por Independência do BC

data %>%
  filter(!is.na(gap), !is.na(cbie_index)) %>%
  mutate(
    grupo_indep = if_else(
      cbie_index >= quantile(cbie_index, 0.75, na.rm = TRUE),
      "Alta Independência", "Baixa Independência"
    )
  ) %>%
  group_by(year, grupo_indep) %>%
  summarise(avg_gap = mean(gap), .groups = "drop") %>%
  ggplot(aes(x = year, y = avg_gap, color = grupo_indep)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c("Alta Independência" = "#023047", "Baixa Independência" = "#ffb703"),
    name = ""
  ) +
  labs(
    title    = "Menores desvios frente à meta em países com BC mais independente",
    subtitle = "Média anual do gap inflacionário — comparação dos 25% mais e menos independentes (CBI)",
    x        = "Ano",
    y        = "Gap Médio (Inflação Real - Meta)",
    caption  = expression(bold("Fonte: ") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 12) +
  theme(
    plot.title         = element_text(face = "bold", size = 15, hjust = 0),
    plot.subtitle      = element_text(size = 11.5, hjust = 0, margin = margin(b = 10)),
    legend.position    = "bottom",
    legend.text        = element_text(size = 10),
    panel.grid.major.y = element_line(color = "grey80"),
    axis.title         = element_text(face = "bold")
  )

## 📊 Gráfico do Gap de Produto e Inflação

data %>%
  filter(!is.na(inflation), !is.na(gap), !is.na(cbie_index)) %>%
  mutate(
    grupo_indep = if_else(
      cbie_index >= quantile(cbie_index, 0.75, na.rm = TRUE),
      "CBI Elevado (top 25%)", "CBI Baixo (restante)"
    )
  ) %>%
  ggplot(aes(x = gap, y = inflation)) +
  stat_density_2d(
    aes(fill = after_stat(level)),
    geom = "polygon",
    bins = 10,
    color = "white",
    linewidth = 0.3
  ) +
  facet_wrap(~ grupo_indep) +
  coord_cartesian(xlim = c(-7, 7), ylim = c(-2, 12)) +
  scale_fill_viridis_c(
    option = "inferno",  
    direction = 1,
    begin = 0.1,
    end = 0.9,
    guide = "none",
    na.value = NA
  ) +
  labs(
    title    = "Inflação e Hiato do Produto por Regime de Independência Monetária",
    subtitle = "Contornos preenchidos com paleta refinada — visual técnico e de contraste suave",
    x        = "Gap do Produto (%)",
    y        = "Inflação (%)",
    caption  = expression(bold("Fonte:") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title       = element_text(face = "bold", size = 15, hjust = 0),
    plot.subtitle    = element_text(size = 11.5, hjust = 0, margin = margin(b = 10)),
    strip.text       = element_text(face = "bold", size = 11),
    axis.title       = element_text(face = "bold"),
    axis.text        = element_text(color = "gray20"),
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    plot.caption     = element_text(hjust = 0, size = 10, color = "gray40"),
    legend.position  = "none"
  )

## 📊 Gráfico da Mudança no CBI e Inflação

data %>%
  group_by(country) %>%
  mutate(
    change_inflation = (
      (
        (inflation + dplyr::lead(inflation, 1) + dplyr::lead(inflation, 2) +
           dplyr::lead(inflation, 3) + dplyr::lead(inflation, 4)) /4
      ) /
        ((inflation + dplyr::lag(inflation, 1) + dplyr::lag(inflation, 2)) / 3) - 1
    ),
    cbie_change = (cbie_index - dplyr::lag(cbie_index, 1)) / cbie_index
  ) %>%
  filter(!is.na(change_inflation), !is.na(cbie_change), cbie_change != 0) %>%
  ggplot(aes(x = cbie_change, y = change_inflation)) +
  geom_point(
    aes(fill = cbie_index),
    alpha = 0.8,
    shape = 21,
    size = 3,
    color = "black"
  ) +
  geom_smooth(method = "lm", se = FALSE, fullrange = TRUE, color = "darkblue", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") +
  geom_vline(xintercept = 0, linetype = "solid", color = "black") +
  geom_text_repel(aes(label = paste(iso3c, year, sep = "-")), size = 3, max.overlaps = 10) +
  
  coord_cartesian(ylim = c(-1.2, 4)) +
  scale_fill_viridis_c(
    option = "inferno",
    direction = 1,
    begin = 0.1,
    end = 0.9,
    guide = "none",
    na.value = NA
  ) +
  labs(
    title    = "Reformas Institucionais e Queda na Inflação",
    subtitle = "Pontos representam episódios de mudança no CBI — preenchimento indica nível do índice",
    x        = "\u0394% CBI Index",
    y        = "\u0394% Inflação",
    caption  = expression(bold("Fonte:") ~ "WDI + CBIE + FMI")
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title       = element_text(face = "bold", size = 15, hjust = 0),
    plot.subtitle    = element_text(size = 11.5, hjust = 0, margin = margin(b = 10)),
    axis.title       = element_text(face = "bold"),
    axis.text        = element_text(color = "gray20"),
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    plot.caption     = element_text(hjust = 0, size = 10, color = "gray40"),
    legend.position  = "none"
  )

# 📊 Estimações ----

## 📊 Preparando os dados

panel <- data %>%
  pdata.frame(index = c("iso3c", "year"))

## 📊 Estimando o modelo GMM

gmm_model_cbie_index <- pgmm(
  formula = gap ~
    lag(gap, 1) +        
    cbie_index +                   
    lag(hiato_pct, 1) +            
    inflation_forecast +
    real_rate +
    I(cbie_index * real_rate)
  |
    lag(gap, 3:4) +      
    lag(real_rate, 2:3) +          
    lag(inflation_forecast, 3:4) + 
    lag(hiato_pct, 3:4),           
  data           = panel,
  effect         = "individual",
  model          = "twosteps",
  transformation = "ld"
)


summary(gmm_model_cbie_index)

gmm_model_cbie_index_fiscal <- pgmm(
  formula = gap ~
    lag(gap, 1) +        
    cbie_index +                   
    lag(hiato_pct, 1) +            
    inflation_forecast +
    real_rate +
    impulso_fiscal +
    I(cbie_index * real_rate)
  |
    lag(impulso_fiscal, 1:2) +
    lag(gap, 3:4) +      
    lag(real_rate, 2:3) +          
    lag(inflation_forecast, 3:4) + 
    lag(hiato_pct, 3:4),           
  data           = panel,
  effect         = "individual",
  model          = "twosteps",
  transformation = "ld"
)


summary(gmm_model_cbie_index_fiscal)

gmm_model_cbie_policy <- pgmm(
  formula = gap ~
    lag(gap, 1) +        
    cbie_policy +                   
    lag(hiato_pct, 1) +            
    inflation_forecast +
    real_rate +
    impulso_fiscal +
    I(cbie_policy * real_rate) 
  |
    lag(impulso_fiscal, 1:2) +
    lag(gap, 3:4) +      
    lag(real_rate, 2:3) +          
    lag(inflation_forecast, 3:4) + 
    lag(hiato_pct, 3:4),           
  data           = panel,
  effect         = "individual",
  model          = "twosteps",
  transformation = "ld"
)

summary(gmm_model_cbie_policy)


gmm_model_cbie_policy_q1 <- pgmm(
  formula = gap ~
    lag(gap, 1) +        
    cbie_policy_q1 + 
    real_rate +
    lag(hiato_pct, 1) +            
    inflation_forecast +
    impulso_fiscal +
    I(cbie_policy_q1 * real_rate) 

  |
    lag(impulso_fiscal, 1:2) +
    lag(gap, 3:4) +      
    lag(real_rate, 2:3) +          
    lag(inflation_forecast, 3:4) + 
    lag(hiato_pct, 3:4),           
  data           = panel,
  effect         = "individual",
  model          = "twosteps",
  transformation = "ld"
)

summary(gmm_model_cbie_policy_q1)

## 📊 Tabela de Resultados

create_gmm_table <- function(gmm_model, title, data, panel) {
  s   <- summary(gmm_model, robust = TRUE)
  cm  <- as_tibble(s$coefficients, rownames = "term")
  
  # Coluna de p‑valor (primeira cujo nome começa com "Pr")
  pcol <- grep("^Pr", colnames(cm), value = TRUE)[1]
  
  mapping <- tribble(
    ~term,                          ~Parametro,
    "I(cbie_index * real_rate)",    "α₁ (Independência do BC × Taxa Real de Juros)",
    "I(cbie_policy * real_rate)",   "α₁ (Independência do BC (PM) × Taxa Real de Juros)",
    "I(cbie_policy_q1 * real_rate)","α₁ (Independência do BC (PM Q1) × Taxa Real de Juros)",
    "lag(gap, 1)",                  "α₂ (Gap de Inflação Defasado)",
    "lag(hiato_pct, 1)",            "α₃ (Hiato do Produto Defasado)",
    "inflation_forecast",           "α₄ (Expectativa de Inflação)",
    "cbie_index",                   "α₅ (Índice de Independência do BC)",
    "cbie_policy",                  "α₅ (Índice de Independência do BC - Política Monetária)",
    "cbie_policy_q1",               "α₅ (Índice de Independência do BC - Política Monetária Q1)",
    "real_rate",                    "α₆ (Taxa Real de Juros)",
    "impulso_fiscal",               "α₇ (Impulso Fiscal)"
  )
  
  res <- cm %>%
    left_join(mapping, by = "term") %>%
    mutate(
      Parametro = coalesce(Parametro, term),
      Resultado = paste0(
        sprintf("%.4f", Estimate),
        case_when(
          .data[[pcol]] < 0.001 ~ "***",
          .data[[pcol]] < 0.01  ~ "**",
          .data[[pcol]] < 0.05  ~ "*",
          TRUE                  ~ ""
        ),
        "<br/>(",
        sprintf("%.4f", `Std. Error`),
        ")"
      )
    ) %>%
    arrange(match(Parametro, c(
      "α₁ (Independência do BC × Taxa Real de Juros)",
      "α₁ (Independência do BC (PM) × Taxa Real de Juros)",
      "α₁ (Independência do BC (PM Q1) × Taxa Real de Juros)",
      "α₂ (Gap de Inflação Defasado)",
      "α₃ (Hiato do Produto Defasado)",
      "α₄ (Expectativa de Inflação)",
      "α₅ (Índice de Independência do BC)",
      "α₅ (Índice de Independência do BC - Política Monetária)",
      "α₅ (Índice de Independência do BC - Política Monetária Q1)",
      "α₆ (Taxa Real de Juros)",
      "α₇ (Impulso Fiscal)"
    ))) %>%
    select(Parâmetro = Parametro, Resultado)
  
  # Estatísticas complementares
  sg  <- sargan(gmm_model, robust = TRUE)
  ar1 <- mtest(gmm_model, 1)
  ar2 <- mtest(gmm_model, 2)
  coefs <- coef(gmm_model)
  Vrob  <- vcov(gmm_model, robust = TRUE)
  wald_stat <- as.numeric(t(coefs) %*% solve(Vrob) %*% coefs)
  wald_df   <- length(coefs)
  wald_p    <- pchisq(wald_stat, wald_df, lower.tail = FALSE)
  
  n_countries <- length(unique(data$iso3c))
  n_obs       <- nrow(panel)
  
  res %>%
    gt() %>%
    tab_header(title) %>%
    fmt_markdown(columns = "Resultado") %>%
    tab_source_note(md(glue("Países (n): {n_countries}  •  Observações (N): {n_obs}"))) %>%
    tab_source_note(md("Significância: *** p<0.001; ** p<0.01; * p<0.05")) %>%
    tab_source_note(md(glue("Sargan: χ²({sg$df}) = {round(sg$statistic,3)} (p = {round(sg$p.value,3)})"))) %>%
    tab_source_note(md(glue("Wald: χ²({wald_df}) = {round(wald_stat,3)} (p = {format.pval(wald_p,3)})"))) %>%
    tab_source_note(md(glue("AR(1): z = {round(ar1$statistic,3)} (p = {round(ar1$p.value,3)})"))) %>%
    tab_source_note(md(glue("AR(2): z = {round(ar2$statistic,3)} (p = {round(ar2$p.value,3)})")))
}


table_cbie_index <- create_gmm_table(
  gmm_model_cbie_index,
  "Estimativas GMM — Índice de Independência do BC",
  data,
  panel
)

table_cbie_index_fiscal <- create_gmm_table(
  gmm_model_cbie_index_fiscal,
  "Estimativas GMM — Índice de Independência do BC (Fiscal)",
  data,
  panel
)

table_cbie_policy <- create_gmm_table(
  gmm_model_cbie_policy,
  "Estimativas GMM — Independência do BC (Política Monetária)",
  data,
  panel
)

table_cbie_policy_q1 <- create_gmm_table(
  gmm_model_cbie_policy_q1,
  "Estimativas GMM — Independência do BC (Política Monetária Q1)",
  data,
  panel
)

# Exibir as tabelas
table_cbie_index
table_cbie_index_fiscal
table_cbie_policy
table_cbie_policy_q1


## 📊 Gráfico de Efeitos Marginais

# Função de previsão do gap
predict_gap <- function(cbie_index, real_rate, coef_cbi, coef_real, coef_int) {
  coef_cbi * cbie_index +
    coef_real * real_rate +
    coef_int  * cbie_index * real_rate
}

# Extração dos coeficientes do modelo
coefs     <- coef(gmm_model_cbie_index)
coef_real <- coefs["real_rate"]
coef_cbi  <- coefs["cbie_index"]
coef_int  <- coefs["I(cbie_index * real_rate)"]

# Definição de níveis para CBI e Juros Reais
cbi_levels <- c(round(min(panel$cbie_index, na.rm = TRUE), 2), 0.5, round(max(panel$cbie_index, na.rm = TRUE), 2))
rr_levels  <- c(round(mean(panel$real_rate, na.rm = TRUE), 2), 1.6, 4)

# --- Gap Previsto vs Juros Reais (diferentes CBI) ---
df1 <- expand.grid(
  real_rate  = seq(0, 10, length.out = 100),
  cbie_index = cbi_levels
) %>%
  mutate(
    gap_hat = predict_gap(cbie_index, real_rate, coef_cbi, coef_real, coef_int)
  )

ymax1 <- max(abs(df1$gap_hat), na.rm = TRUE)

legend_labels_cbi <- sprintf(
  "CBI = %.2f: gap = %.2f + %.2f·RR",
  cbi_levels,
  coef_cbi * cbi_levels,
  coef_real + coef_int * cbi_levels
)

ggplot(df1, aes(x = real_rate, y = gap_hat, color = factor(cbie_index))) +
  geom_line(size = 1.3) +
  geom_point(data = df1 %>% filter(real_rate %in% c(0, 5, 10)), size = 2, alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  coord_cartesian(ylim = c(-ymax1, ymax1)) +
  scale_color_manual(
    values = RColorBrewer::brewer.pal(length(cbi_levels), "Set1"),
    labels = legend_labels_cbi,
    name   = "Fórmulas"
  ) +
  labs(
    title    = "Gap Previsto vs Juros Reais",
    subtitle = "Linhas para diferentes valores de CBI",
    x        = "Juros Reais (%)",
    y        = "Gap Previsto"
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", size = 15, hjust = 0),
    plot.subtitle = element_text(size = 11, hjust = 0),
    axis.title    = element_text(face = "bold"),
    legend.title  = element_text(face = "bold"),
    legend.text   = element_text(size = 10),
    legend.position = "right"
  )

# --- Gap Previsto vs CBI (diferentes Juros Reais) ---
df2 <- expand.grid(
  cbie_index = seq(0, 1, length.out = 100),
  real_rate  = rr_levels
) %>%
  mutate(
    gap_hat = predict_gap(cbie_index, real_rate, coef_cbi, coef_real, coef_int)
  )

ymax2 <- max(abs(df2$gap_hat), na.rm = TRUE)

legend_labels_rr <- sprintf(
  "RR = %.2f: gap = %.2f + %.2f·CBI",
  rr_levels,
  coef_real * rr_levels,
  coef_cbi + coef_int * rr_levels
)

ggplot(df2, aes(x = cbie_index, y = gap_hat, color = factor(real_rate))) +
  geom_line(size = 1.3) +
  geom_point(data = df2 %>% filter(cbie_index %in% c(0, 0.5, 1)), size = 2, alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  coord_cartesian(ylim = c(-ymax2, ymax2)) +
  scale_color_manual(
    values = RColorBrewer::brewer.pal(length(rr_levels), "Set2"),
    labels = legend_labels_rr,
    name   = "Fórmulas"
  ) +
  labs(
    title    = "Gap Previsto vs CBI",
    subtitle = "Linhas para diferentes níveis de Juros Reais",
    x        = "CBI (Índice de Independência)",
    y        = "Gap Previsto"
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", size = 15, hjust = 0),
    plot.subtitle = element_text(size = 11, hjust = 0),
    axis.title    = element_text(face = "bold"),
    legend.title  = element_text(face = "bold"),
    legend.text   = element_text(size = 10),
    legend.position = "right"
  )

# Limpeza de variáveis temporárias
rm(coefs, coef_real, coef_cbi, coef_int,
   cbi_levels, rr_levels, df1, ymax1, legend_labels_cbi,
   df2, ymax2, legend_labels_rr, predict_gap)
