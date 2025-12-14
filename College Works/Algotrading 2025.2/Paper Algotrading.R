#---------------------------------
# Algotrading - Paper
# ML Otimization 
#---------------------------------

# Bibliotecas e Seed's

library(PerformanceAnalytics)
library(portfolioBacktest)
library(tidymodels)   
library(tidyverse)
library(tidyquant)    
library(lubridate)
library(showtext)
library(quadprog)
library(rugarch)
library(scales)
library(slider)
library(caret)
library(torch)
library(glue)
library(rbcb)
library(TTR)
set.seed(42)
torch_manual_seed(42)

# Funções Gráficas The Economist ----

font_family <- if ("Roboto Condensed" %in% systemfonts::system_fonts()$family)
  "Roboto Condensed" else "sans"
showtext_auto()

econ_colors <- list(
  main = c(
    econ_red   = "#E3120B",
    red1       = "#D86A77",
    red_text   = "#CC334C",
    blue1      = "#006BA2",
    blue2      = "#3EBCD2",
    blue2_text = "#0097A7"
  ),
  secondary = c(
    mustard   = "#E6B83C",
    burgundy  = "#A63D57",
    mauve     = "#B48A9B",
    teal      = "#008080",
    aqua      = "#6FC7C7"
  ),
  supporting_bright = c(
    purple = "#924C7A",
    pink = "#DA3C78",
    orange = "#F7A11A",
    lime = "#B3D334"
  ),
  supporting_dark = c(
    navy = "#003D73",
    cyan_dk = "#005F73",
    green_dk = "#385F44"
  ),
  background = c(
    print_bkgd = "#E9EDF0",
    highlight  = "#DDE8EF",
    number_box = "#C2D3E0"
  ),
  neutral = c(
    grid_lines = "#B7C6CF",
    grey_box   = "#7C8C99",
    grey_text  = "#333333",
    black25    = "#BFBFBF",
    black50    = "#808080",
    black75    = "#404040",
    black100   = "#000000"
  ),
  equal_lightness = c(
    red = "#A81829",
    blue = "#00588D",
    cyan = "#005F73",
    green = "#005F52",
    yellow = "#714C00",
    olive = "#4C5900",
    purple = "#78405F",
    gold = "#674E1F",
    grey = "#3F5661"
  )
)

econ_base <- list(
  bg   = econ_colors$background["print_bkgd"],
  grid = econ_colors$neutral["grid_lines"],
  text = "#0C0C0C"
)

econ_scheme <- list(
  bars        = unname(
    c(
      econ_colors$main["blue1"],
      econ_colors$main["blue2"],
      econ_colors$secondary["mustard"],
      econ_colors$secondary["teal"],
      econ_colors$secondary["burgundy"],
      econ_colors$secondary["mauve"]
    )
  ),
  stacked     = unname(
    c(
      econ_colors$main["blue1"],
      econ_colors$main["blue2"],
      econ_colors$secondary["mustard"],
      econ_colors$main["blue2_text"],
      econ_colors$secondary["aqua"],
      econ_colors$equal_lightness["blue"]
    )
  ),
  lines_side  = unname(
    c(
      econ_colors$main["blue1"],
      econ_colors$main["blue2"],
      econ_colors$secondary["mustard"],
      econ_colors$secondary["burgundy"],
      econ_colors$main["blue2_text"],
      econ_colors$secondary["mauve"]
    )
  ),
  lines_stack = unname(
    c(
      econ_colors$main["blue1"],
      econ_colors$main["blue2"],
      econ_colors$secondary["mustard"],
      econ_colors$main["blue2_text"],
      econ_colors$secondary["aqua"],
      econ_colors$equal_lightness["blue"]
    )
  ),
  thermometer = unname(
    c(
      econ_colors$main["blue2"],
      econ_colors$secondary["burgundy"],
      econ_colors$secondary["mustard"],
      econ_colors$main["blue1"],
      econ_colors$main["blue2_text"],
      econ_colors$secondary["mauve"]
    )
  ),
  scatter     = unname(
    c(
      econ_colors$main["blue2"],
      econ_colors$secondary["burgundy"],
      econ_colors$secondary["mustard"],
      econ_colors$main["blue1"],
      econ_colors$main["blue2_text"],
      econ_colors$secondary["mauve"]
    )
  ),
  pie         = unname(
    c(
      econ_colors$main["blue1"],
      econ_colors$main["blue2"],
      econ_colors$secondary["mustard"],
      econ_colors$main["blue2_text"],
      econ_colors$secondary["burgundy"],
      econ_colors$secondary["aqua"]
    )
  )
)

theme_econ_base <- function(base_family = font_family) {
  theme_minimal(base_family = base_family) +
    theme(
      plot.background  = element_rect(fill = econ_base$bg, colour = NA),
      panel.background = element_rect(fill = econ_base$bg, colour = NA),
      plot.title.position = "plot",
      plot.title    = element_text(
        face = "bold",
        size = 20,
        hjust = 0,
        colour = econ_base$text,
        margin = margin(b = 2)
      ),
      plot.subtitle = element_text(
        size = 12.5,
        hjust = 0,
        colour = econ_base$text,
        margin = margin(b = 8)
      ),
      plot.caption  = element_text(size = 9, colour = econ_base$text),
      axis.title = element_text(size = 11, colour = econ_base$text),
      axis.text  = element_text(size = 10, colour = econ_base$text),
      axis.line.x  = element_line(colour = econ_base$text, linewidth = 0.6),
      axis.ticks.x = element_line(colour = econ_base$text, linewidth = 0.6),
      panel.grid.major.y = element_line(colour = econ_base$grid, linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text  = element_text(size = 10, colour = econ_base$text),
      plot.margin = margin(16, 16, 12, 16)
    )
}

scale_econ <- function(aes = c("colour", "fill"),
                       scheme = c(names(econ_scheme)),
                       reverse = FALSE,
                       values = NULL,
                       ...) {
  aes    <- match.arg(aes)
  scheme <- match.arg(scheme)
  pal <- if (is.null(values))
    econ_scheme[[scheme]]
  else
    unname(values)
  if (reverse)
    pal <- rev(pal)
  if (aes == "colour")
    scale_colour_manual(values = pal, ...)
  else
    scale_fill_manual(values = pal, ...)
}

fmt_lab <- function(kind = c("number", "percent", "si")) {
  kind <- match.arg(kind)
  switch(
    kind,
    number  = label_number(big.mark = ".", decimal.mark = ","),
    percent = label_percent(),
    si      = label_number(scale_cut = cut_short_scale())
  )
}

econ_colors_flat <- unlist(econ_colors)
# ----

# Baixando os Dados 

## Definindo a lista de ativos a serem usados ----

### 1. Ações Nacionais (Brasil)

stocks_br <- c("PETR4.SA", 
               "VALE3.SA", 
               "WEGE3.SA", 
               "TAEE11.SA",
               "ITUB4.SA",
               "BBSE3.SA",
               "ITSA4.SA",
               "BBAS3.SA")

### 2. Ações Americanas

stocks_us <- c("AAPL", 
               "NVDA", 
               "AMZN", 
               "MSFT")

### 3. ETFs

tickers_etf <- c("BOVA11.SA", 
                 "XOP", 
                 "SPY", 
                 "EFA")

### 4. Criptoativos

tickers_crypto <- c("BTC-USD", 
                    "ETH-USD", 
                    "USDT-USD")

### 5. Commodities

tickers_como <- c("GLD", 
                  "SLV")

## Definido as Datas de começo e fim ----

### Começo

start_date <- ymd("2015-01-01")

### Fim 

end_date <- ymd("2025-10-29")

## Baixando os dados de cada tipo de ativo ----

df_br <- tq_get(stocks_br,
                get  = "stock.prices",
                from = start_date,
                to   = end_date) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(open, high, low, close, volume, adjusted),
    names_sep = "_"
  ) %>% 
  glimpse()

df_us <- tq_get(stocks_us,
                get  = "stock.prices",
                from = start_date,
                to   = end_date) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(open, high, low, close, volume, adjusted),
    names_sep = "_"
  )

df_etf <- tq_get(tickers_etf,
                 get  = "stock.prices",
                 from = start_date,
                 to   = end_date) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(open, high, low, close, volume, adjusted),
    names_sep = "_"
  )

df_crypto <- tq_get(tickers_crypto,
                    get  = "stock.prices",
                    from = start_date,
                    to   = end_date) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(open, high, low, close, volume, adjusted),
    names_sep = "_"
  )

df_como <- tq_get(tickers_como,
                  get  = "stock.prices",
                  from = start_date,
                  to   = end_date) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(open, high, low, close, volume, adjusted),
    names_sep = "_"
  )
# ----

# Transformões necessárias

## Criando a coluna de retornos através do preço ajustado ---- 

df_br <- df_br %>%
  arrange(date) %>%
  mutate(across(
    .cols = starts_with("adjusted_"), 
    .fns = ~ (./lag(.) - 1), 
    .names = "retorno_{.col}" 
  )) %>%
  na.omit()

df_us <- df_us %>%
  arrange(date) %>%
  mutate(across(
    .cols = starts_with("adjusted_"), 
    .fns = ~ (./lag(.) - 1), 
    .names = "retorno_{.col}" 
  )) %>%
  na.omit()

df_como <- df_como %>%
  arrange(date) %>%
  mutate(across(
    .cols = starts_with("adjusted_"), 
    .fns = ~ (./lag(.) - 1), 
    .names = "retorno_{.col}" 
  )) %>%
  na.omit()

df_crypto <- df_crypto %>%
  arrange(date) %>%
  mutate(across(
    .cols = starts_with("adjusted_"), 
    .fns = ~ (./lag(.) - 1), 
    .names = "retorno_{.col}" 
  )) %>%
  na.omit()

df_etf <- df_etf %>%
  arrange(date) %>%
  mutate(across(
    .cols = starts_with("adjusted_"), 
    .fns = ~ (./lag(.) - 1), 
    .names = "retorno_{.col}" 
  )) %>%
  na.omit()

# ----

# Visualizando as séries 

## Fechamentos do Brasil ----

df_br %>%
  select(date, starts_with("close_")) %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "preco_fechamento"
  ) %>%
  mutate(symbol = sub("close_", "", symbol)) %>%
  ggplot(aes(x = date, y = preco_fechamento, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_color_manual(
    values = c(
      "#E3120B",
      "#D86A77",
      "#CC334C",
      "#006BA2",
      "#3EBCD2",
      "#0097A7",
      "#E6B83C",
      "#A63D57",
      "#B48A9B",
      "#008080",
      "#6FC7C7",
      "#924C7A"
    )
  ) + 
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Preços de Fechamento dos Ativos do Brasil",
    subtitle = "Evolução do preço diário de fechamento",
    x = "Data",
    y = "Preço de Fechamento (R$)"
  )

## Fechamentos das Commodities ----

df_como %>%
  select(date, starts_with("close_")) %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "preco_fechamento"
  ) %>%
  mutate(symbol = sub("close_", "", symbol)) %>%
  ggplot(aes(x = date, y = preco_fechamento, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Preços de Fechamento das Commodities",
    subtitle = "Evolução do preço diário de fechamento",
    x = "Data",
    y = "Preço de Fechamento (U$)"
  )

## Fechamentos do Crypto ----

df_crypto %>%
  select(date, starts_with("close_")) %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "preco_fechamento"
  ) %>%
  mutate(symbol = sub("close_", "", symbol)) %>%
  ggplot(aes(x = date, y = preco_fechamento, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Preços de Fechamento das Criptomoedas",
    subtitle = "Evolução do preço diário de fechamento",
    x = "Data",
    y = "Preço de Fechamento (U$)"
  )

## Fechamentos do ETF ----

df_etf %>%
  select(date, starts_with("close_")) %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "preco_fechamento"
  ) %>%
  mutate(symbol = sub("close_", "", symbol)) %>%
  ggplot(aes(x = date, y = preco_fechamento, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Preços de Fechamento de ETF's",
    subtitle = "Evolução do preço diário de fechamento",
    x = "Data",
    y = "Preço de Fechamento (R$ e U$)"
  )

## Fechamentos do EUA ----

df_us %>%
  select(date, starts_with("close_")) %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "preco_fechamento"
  ) %>%
  mutate(symbol = sub("close_", "", symbol)) %>%
  ggplot(aes(x = date, y = preco_fechamento, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Preços de Fechamento dos Ativos dos EUA",
    subtitle = "Evolução do preço diário de fechamento",
    x = "Data",
    y = "Preço de Fechamento (U$)"
  )

# ----

# Visualizando Correlação 

## Correlação do Brasil ----

df_br %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  rename_with(~ sub("retorno_adjusted_", "", .x), .cols = starts_with("retorno_adjusted_")) %>%
  mutate(
    Ano = year(date), 
    Grupo = case_when(
      Ano < 2020 ~ "1. Pré-Pandemia (15-19)",
      Ano %in% c(2020, 2021) ~ "2. Pandemia (20-21)",
      Ano > 2021 ~ "3. Pós-Pandemia (22-25)"
    ),
    Grupo = factor(Grupo) 
  ) %>%
  GGally::ggpairs(
    .,
    columns = stocks_br,
    ggplot2::aes(colour = Grupo, fill = Grupo),
    title = "Análise de Pares: Retornos Diários (por Período)",
    upper = list(continuous = GGally::wrap("cor", size = 3)),
    lower = list(continuous = GGally::wrap("points", alpha = 0.2, size = 0.5)),
    diag = list(continuous = GGally::wrap("densityDiag", alpha = 0.5))
  ) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_econ(aes = "fill", scheme = "lines_side") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_rect(
      colour = econ_base$grid, 
      fill = NA,               
      linewidth = 0.5          
    )
  )

## Correlação das Commodities ----

df_como %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  rename_with(~ sub("retorno_adjusted_", "", .x), .cols = starts_with("retorno_adjusted_")) %>%
  mutate(
    Ano = year(date), 
    Grupo = case_when(
      Ano < 2020 ~ "1. Pré-Pandemia (15-19)",
      Ano %in% c(2020, 2021) ~ "2. Pandemia (20-21)",
      Ano > 2021 ~ "3. Pós-Pandemia (22-25)"
    ),
    Grupo = factor(Grupo) 
  ) %>%
  GGally::ggpairs(
    .,
    columns = tickers_como,
    ggplot2::aes(colour = Grupo, fill = Grupo),
    title = "Análise de Pares: Retornos Diários (por Período)",
    upper = list(continuous = GGally::wrap("cor", size = 3)),
    lower = list(continuous = GGally::wrap("points", alpha = 0.2, size = 0.5)),
    diag = list(continuous = GGally::wrap("densityDiag", alpha = 0.5))
  ) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_econ(aes = "fill", scheme = "lines_side") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_rect(
      colour = econ_base$grid, 
      fill = NA,               
      linewidth = 0.5          
    )
  )

## Correlação das Cryptos ----

df_crypto %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  rename_with(~ sub("retorno_adjusted_", "", .x), .cols = starts_with("retorno_adjusted_")) %>%
  mutate(
    Ano = year(date), 
    Grupo = case_when(
      Ano < 2020 ~ "1. Pré-Pandemia (15-19)",
      Ano %in% c(2020, 2021) ~ "2. Pandemia (20-21)",
      Ano > 2021 ~ "3. Pós-Pandemia (22-25)"
    ),
    Grupo = factor(Grupo) 
  ) %>%
  GGally::ggpairs(
    .,
    columns = tickers_crypto,
    ggplot2::aes(colour = Grupo, fill = Grupo),
    title = "Análise de Pares: Retornos Diários (por Período)",
    upper = list(continuous = GGally::wrap("cor", size = 3)),
    lower = list(continuous = GGally::wrap("points", alpha = 0.2, size = 0.5)),
    diag = list(continuous = GGally::wrap("densityDiag", alpha = 0.5))
  ) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_econ(aes = "fill", scheme = "lines_side") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_rect(
      colour = econ_base$grid, 
      fill = NA,               
      linewidth = 0.5          
    )
  )


## Correlação dos ETF ----

df_etf %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  rename_with(~ sub("retorno_adjusted_", "", .x), .cols = starts_with("retorno_adjusted_")) %>%
  mutate(
    Ano = year(date), 
    Grupo = case_when(
      Ano < 2020 ~ "1. Pré-Pandemia (15-19)",
      Ano %in% c(2020, 2021) ~ "2. Pandemia (20-21)",
      Ano > 2021 ~ "3. Pós-Pandemia (22-25)"
    ),
    Grupo = factor(Grupo) 
  ) %>%
  GGally::ggpairs(
    .,
    columns = tickers_etf,
    ggplot2::aes(colour = Grupo, fill = Grupo),
    title = "Análise de Pares: Retornos Diários (por Período)",
    upper = list(continuous = GGally::wrap("cor", size = 3)),
    lower = list(continuous = GGally::wrap("points", alpha = 0.2, size = 0.5)),
    diag = list(continuous = GGally::wrap("densityDiag", alpha = 0.5))
  ) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_econ(aes = "fill", scheme = "lines_side") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_rect(
      colour = econ_base$grid, 
      fill = NA,               
      linewidth = 0.5          
    )
  )


## Correlação dos USA ----

df_us %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  rename_with(~ sub("retorno_adjusted_", "", .x), .cols = starts_with("retorno_adjusted_")) %>%
  mutate(
    Ano = year(date), 
    Grupo = case_when(
      Ano < 2020 ~ "1. Pré-Pandemia (15-19)",
      Ano %in% c(2020, 2021) ~ "2. Pandemia (20-21)",
      Ano > 2021 ~ "3. Pós-Pandemia (22-25)"
    ),
    Grupo = factor(Grupo) 
  ) %>%
  GGally::ggpairs(
    .,
    columns = stocks_us,
    ggplot2::aes(colour = Grupo, fill = Grupo),
    title = "Análise de Pares: Retornos Diários (por Período)",
    upper = list(continuous = GGally::wrap("cor", size = 3)),
    lower = list(continuous = GGally::wrap("points", alpha = 0.2, size = 0.5)),
    diag = list(continuous = GGally::wrap("densityDiag", alpha = 0.5))
  ) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_econ(aes = "fill", scheme = "lines_side") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_rect(
      colour = econ_base$grid, 
      fill = NA,               
      linewidth = 0.5          
    )
  )


#----

# Visualizando os Retornos Acumulados

## Brasil ----
df_br %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "retorno_diario"
  ) %>%
  mutate(symbol = sub("retorno_adjusted_", "", symbol)) %>%
  group_by(symbol) %>%
  mutate(retorno_cumulativo = cumprod(1 + retorno_diario)) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = retorno_cumulativo, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_color_manual(
    values = c(
      "#E3120B",
      "#D86A77",
      "#CC334C",
      "#006BA2",
      "#3EBCD2",
      "#0097A7",
      "#E6B83C",
      "#A63D57",
      "#B48A9B",
      "#008080",
      "#6FC7C7",
      "#924C7A"
    )
  ) +  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Performance dos Ativos (Retorno Cumulativo)",
    subtitle = "Quanto R$ 1,00 investido teria se tornado",
    x = "Data",
    y = "Retorno Cumulativo"
  )

## Commodities ----

df_como %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "retorno_diario"
  ) %>%
  mutate(symbol = sub("retorno_adjusted_", "", symbol)) %>%
  group_by(symbol) %>%
  mutate(retorno_cumulativo = cumprod(1 + retorno_diario)) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = retorno_cumulativo, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Performance dos Ativos (Retorno Cumulativo)",
    subtitle = "Quanto U$ 1,00 investido teria se tornado",
    x = "Data",
    y = "Retorno Cumulativo"
  )

## Cryptos ----
df_crypto %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "retorno_diario"
  ) %>%
  mutate(symbol = sub("retorno_adjusted_", "", symbol)) %>%
  group_by(symbol) %>%
  mutate(retorno_cumulativo = cumprod(1 + retorno_diario)) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = retorno_cumulativo, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Performance dos Ativos (Retorno Cumulativo)",
    subtitle = "Quanto U$ 1,00 investido teria se tornado",
    x = "Data",
    y = "Retorno Cumulativo"
  )

## ETF ----
df_etf %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "retorno_diario"
  ) %>%
  mutate(symbol = sub("retorno_adjusted_", "", symbol)) %>%
  group_by(symbol) %>%
  mutate(retorno_cumulativo = cumprod(1 + retorno_diario)) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = retorno_cumulativo, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Performance dos Ativos (Retorno Cumulativo)",
    subtitle = "Quanto R$ ou U$ 1,00 investido teria se tornado",
    x = "Data",
    y = "Retorno Cumulativo"
  )

## USA ----
df_us %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  na.omit() %>%
  pivot_longer(
    cols = -date,
    names_to = "symbol",
    values_to = "retorno_diario"
  ) %>%
  mutate(symbol = sub("retorno_adjusted_", "", symbol)) %>%
  group_by(symbol) %>%
  mutate(retorno_cumulativo = cumprod(1 + retorno_diario)) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = retorno_cumulativo, color = symbol)) +
  geom_line(linewidth = 0.8) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    title = "Performance dos Ativos (Retorno Cumulativo)",
    subtitle = "Quanto U$ 1,00 investido teria se tornado",
    x = "Data",
    y = "Retorno Cumulativo"
  )
# ----


# Criando features para alimentar os modelos

calcular_egarch_volatilidade <- function(retornos) {
  retornos_limpos <- retornos[!is.na(retornos)]
  if (length(retornos_limpos) < 100) {
    return(rep(NA, length(retornos)))
  }
  spec <- ugarchspec(
    variance.model = list(
      model = "eGARCH",
      garchOrder = c(1, 1)
    ),
    mean.model = list(
      armaOrder = c(0, 0),
      include.mean = TRUE
    ),
    distribution.model = "std"
  )
  tryCatch({
    fit <- ugarchfit(spec = spec, data = retornos_limpos, solver = "hybrid")
    vol <- sigma(fit)
    resultado <- rep(NA, length(retornos))
    resultado[!is.na(retornos)] <- vol
    return(resultado)
  }, error = function(e) {
    message(paste("Erro na estimação:", e$message))
    return(rep(NA, length(retornos)))
  })
}

calcular_egarch_dl <- function(retornos, min_obs = 252) {
  retornos_limpos <- retornos[!is.na(retornos)]
  n_total <- length(retornos)
  
  if (length(retornos_limpos) < min_obs) {
    return(rep(NA, n_total))
  }
  
  resultado <- rep(NA, n_total)
  idx_validos <- which(!is.na(retornos))
  
  spec <- ugarchspec(
    variance.model = list(model = "eGARCH", garchOrder = c(1, 1)),
    mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
    distribution.model = "std"
  )
  
  tryCatch({
    fit_inicial <- ugarchfit(
      spec = spec, 
      data = retornos_limpos[1:min_obs], 
      solver = "hybrid"
    )
    
    params <- coef(fit_inicial)
    
    spec_fixed <- ugarchspec(
      variance.model = list(model = "eGARCH", garchOrder = c(1, 1)),
      mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
      distribution.model = "std",
      fixed.pars = as.list(params)
    )
    
    fit_full <- ugarchfit(
      spec = spec_fixed, 
      data = retornos_limpos, 
      solver = "hybrid"
    )
    
    vol <- sigma(fit_full)
    resultado[idx_validos] <- vol
    
    return(resultado)
    
  }, error = function(e) {
    message(paste("Erro na estimação EGARCH:", e$message))
    return(rep(NA, n_total))
  })
}


## Brasil ----

df_br <- df_br %>% 
  pivot_longer(
    cols = -date, 
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)" 
  ) %>%
  group_by(symbol) %>%
  mutate(
    ATR14 = TTR::ATR(cbind(high, low, close), n = 14)[, "atr"],
    RSI14 = TTR::RSI(close, n = 14),
    BBands_mat = TTR::BBands(close, n = 20, sd = 2),
    SMA20 = TTR::SMA(close, n = 20),
    SMA50 = TTR::SMA(close, n = 50),
    SMA_Diff = SMA20 - SMA50,
    BB_Width = (BBands_mat[, "up"] - BBands_mat[, "dn"]) / BBands_mat[, "mavg"]
  ) %>%
  ungroup() %>%
  select(
    date, symbol,
    open, high, low, close, volume, adjusted, 
    retorno_adjusted,
    SMA_Diff, RSI14, BB_Width, ATR14,
    SMA20, SMA50
  ) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(
      open, high, low, close, volume, adjusted, 
      retorno_adjusted,
      SMA_Diff, RSI14, BB_Width, ATR14,
      SMA20, SMA50
    )
  ) %>%
  na.omit() %>%
  mutate(
    egarch_vol_PETR4.SA = calcular_egarch_volatilidade(retorno_adjusted_PETR4.SA),
    egarch_vol_VALE3.SA = calcular_egarch_volatilidade(retorno_adjusted_VALE3.SA),
    egarch_vol_WEGE3.SA = calcular_egarch_volatilidade(retorno_adjusted_WEGE3.SA),
    egarch_vol_TAEE11.SA = calcular_egarch_volatilidade(retorno_adjusted_TAEE11.SA),
    egarch_vol_ITUB4.SA = calcular_egarch_volatilidade(retorno_adjusted_ITUB4.SA),
    egarch_vol_BBSE3.SA = calcular_egarch_volatilidade(retorno_adjusted_BBSE3.SA),
    egarch_vol_ITSA4.SA = calcular_egarch_volatilidade(retorno_adjusted_ITSA4.SA),
    egarch_vol_BBAS3.SA = calcular_egarch_volatilidade(retorno_adjusted_BBAS3.SA)
  )

df_br %>%
  select(date, starts_with("egarch_vol_")) %>%
  pivot_longer(-date, names_to = "ativo", values_to = "volatilidade", 
               names_prefix = "egarch_vol_") %>%
  mutate(ativo = str_remove(ativo, ".SA")) %>%
  ggplot(aes(x = date, y = volatilidade, colour = ativo)) +
  annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-12-31"),
           ymin = -Inf, ymax = Inf, fill = "#6FC7C7", alpha = 0.5) +
  annotate("text", x = as.Date("2020-10-01"), y = Inf, label = "Pandemia",
           vjust = 1.5, size = 3.5, colour = "#000000") +
  geom_line(linewidth = 0.9) +
  theme_econ_base() +
  scale_color_manual(
    values = c(
      "#E3120B",
      "#D86A77",
      "#CC334C",
      "#006BA2",
      "#3EBCD2",
      "#0097A7",
      "#E6B83C",
      "#A63D57",
      "#B48A9B",
      "#008080",
      "#6FC7C7",
      "#924C7A"
    )
  ) +  scale_y_continuous(labels = fmt_lab("percent")) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Volatilidade EGARCH dos Ativos do Brasil",
    subtitle = "Faixa sombreada indica período da pandemia",
    x = NULL,
    y = "Volatilidade"
  )

## Commodities ----

df_como <- df_como %>% 
  pivot_longer(
    cols = -date, 
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)" 
  ) %>%
  group_by(symbol) %>%
  mutate(
    ATR14 = TTR::ATR(cbind(high, low, close), n = 14)[, "atr"],
    RSI14 = TTR::RSI(close, n = 14),
    BBands_mat = TTR::BBands(close, n = 20, sd = 2),
    SMA20 = TTR::SMA(close, n = 20),
    SMA50 = TTR::SMA(close, n = 50),
    SMA_Diff = SMA20 - SMA50,
    BB_Width = (BBands_mat[, "up"] - BBands_mat[, "dn"]) / BBands_mat[, "mavg"]
  ) %>%
  ungroup() %>%
  select(
    date, symbol,
    open, high, low, close, volume, adjusted, 
    retorno_adjusted,
    SMA_Diff, RSI14, BB_Width, ATR14,
    SMA20, SMA50
  ) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(
      open, high, low, close, volume, adjusted, 
      retorno_adjusted,
      SMA_Diff, RSI14, BB_Width, ATR14,
      SMA20, SMA50
    )
  ) %>%
  na.omit() %>%
  mutate(
    egarch_vol_GLD = calcular_egarch_volatilidade(retorno_adjusted_GLD),
    egarch_vol_SLV = calcular_egarch_volatilidade(retorno_adjusted_SLV)
  )

df_como %>%
  select(date, starts_with("egarch_vol_")) %>%
  pivot_longer(-date, names_to = "ativo", values_to = "volatilidade", 
               names_prefix = "egarch_vol_") %>%
  mutate(ativo = str_remove(ativo, ".SA")) %>%
  ggplot(aes(x = date, y = volatilidade, colour = ativo)) +
  annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-12-31"),
           ymin = -Inf, ymax = Inf, fill = "#6FC7C7", alpha = 0.5) +
  annotate("text", x = as.Date("2020-10-01"), y = Inf, label = "Pandemia",
           vjust = 1.5, size = 3.5, colour = "#000000") +
  geom_line(linewidth = 0.9) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("percent")) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Volatilidade EGARCH das Commodities",
    subtitle = "Faixa sombreada indica período da pandemia",
    x = NULL,
    y = "Volatilidade"
  )

## Cryptos ----

df_crypto <- df_crypto %>% 
  pivot_longer(
    cols = -date, 
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)" 
  ) %>%
  group_by(symbol) %>%
  mutate(
    ATR14 = TTR::ATR(cbind(high, low, close), n = 14)[, "atr"],
    RSI14 = TTR::RSI(close, n = 14),
    BBands_mat = TTR::BBands(close, n = 20, sd = 2),
    SMA20 = TTR::SMA(close, n = 20),
    SMA50 = TTR::SMA(close, n = 50),
    SMA_Diff = SMA20 - SMA50,
    BB_Width = (BBands_mat[, "up"] - BBands_mat[, "dn"]) / BBands_mat[, "mavg"]
  ) %>%
  ungroup() %>%
  select(
    date, symbol,
    open, high, low, close, volume, adjusted, 
    retorno_adjusted,
    SMA_Diff, RSI14, BB_Width, ATR14,
    SMA20, SMA50
  ) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(
      open, high, low, close, volume, adjusted, 
      retorno_adjusted,
      SMA_Diff, RSI14, BB_Width, ATR14,
      SMA20, SMA50
    )
  ) %>%
  na.omit() %>%
  mutate(
    `egarch_vol_BTC-USD` = calcular_egarch_volatilidade(`retorno_adjusted_BTC-USD`),
    `egarch_vol_ETH-USD` = calcular_egarch_volatilidade(`retorno_adjusted_ETH-USD`),
    `egarch_vol_USDT-USD` = calcular_egarch_volatilidade(`retorno_adjusted_USDT-USD`)
  )

df_crypto %>%
  select(date, starts_with("egarch_vol_")) %>%
  pivot_longer(-date, names_to = "ativo", values_to = "volatilidade", 
               names_prefix = "egarch_vol_") %>%
  mutate(ativo = str_remove(ativo, ".SA")) %>%
  ggplot(aes(x = date, y = volatilidade, colour = ativo)) +
  annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-12-31"),
           ymin = -Inf, ymax = Inf, fill = "#6FC7C7", alpha = 0.5) +
  annotate("text", x = as.Date("2020-10-01"), y = Inf, label = "Pandemia",
           vjust = 1.5, size = 3.5, colour = "#000000") +
  geom_line(linewidth = 0.9) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("percent")) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Volatilidade EGARCH das Criptomoedas",
    subtitle = "Faixa sombreada indica período da pandemia",
    x = NULL,
    y = "Volatilidade"
  )

## ETF ----

df_etf <- df_etf %>% 
  pivot_longer(
    cols = -date, 
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)" 
  ) %>%
  group_by(symbol) %>%
  mutate(
    ATR14 = TTR::ATR(cbind(high, low, close), n = 14)[, "atr"],
    RSI14 = TTR::RSI(close, n = 14),
    BBands_mat = TTR::BBands(close, n = 20, sd = 2),
    SMA20 = TTR::SMA(close, n = 20),
    SMA50 = TTR::SMA(close, n = 50),
    SMA_Diff = SMA20 - SMA50,
    BB_Width = (BBands_mat[, "up"] - BBands_mat[, "dn"]) / BBands_mat[, "mavg"]
  ) %>%
  ungroup() %>%
  select(
    date, symbol,
    open, high, low, close, volume, adjusted, 
    retorno_adjusted,
    SMA_Diff, RSI14, BB_Width, ATR14,
    SMA20, SMA50
  ) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(
      open, high, low, close, volume, adjusted, 
      retorno_adjusted,
      SMA_Diff, RSI14, BB_Width, ATR14,
      SMA20, SMA50
    )
  ) %>%
  na.omit() %>%
  mutate(
    egarch_vol_BOVA11.SA = calcular_egarch_volatilidade(retorno_adjusted_BOVA11.SA),
    egarch_vol_XOP = calcular_egarch_volatilidade(retorno_adjusted_XOP),
    egarch_vol_SPY = calcular_egarch_volatilidade(retorno_adjusted_SPY),
    egarch_vol_EFA = calcular_egarch_volatilidade(retorno_adjusted_EFA)
  )

df_etf %>%
  select(date, starts_with("egarch_vol_")) %>%
  pivot_longer(-date, names_to = "ativo", values_to = "volatilidade", 
               names_prefix = "egarch_vol_") %>%
  mutate(ativo = str_remove(ativo, ".SA")) %>%
  ggplot(aes(x = date, y = volatilidade, colour = ativo)) +
  annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-12-31"),
           ymin = -Inf, ymax = Inf, fill = "#6FC7C7", alpha = 0.5) +
  annotate("text", x = as.Date("2020-10-01"), y = Inf, label = "Pandemia",
           vjust = 1.5, size = 3.5, colour = "#000000") +
  geom_line(linewidth = 0.9) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("percent")) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Volatilidade EGARCH de ETF's",
    subtitle = "Faixa sombreada indica período da pandemia",
    x = NULL,
    y = "Volatilidade"
  )


## USA ----
df_us <- df_us %>% 
  pivot_longer(
    cols = -date, 
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)" 
  ) %>%
  group_by(symbol) %>%
  mutate(
    ATR14 = TTR::ATR(cbind(high, low, close), n = 14)[, "atr"],
    RSI14 = TTR::RSI(close, n = 14),
    BBands_mat = TTR::BBands(close, n = 20, sd = 2),
    SMA20 = TTR::SMA(close, n = 20),
    SMA50 = TTR::SMA(close, n = 50),
    SMA_Diff = SMA20 - SMA50,
    BB_Width = (BBands_mat[, "up"] - BBands_mat[, "dn"]) / BBands_mat[, "mavg"]
  ) %>%
  ungroup() %>%
  select(
    date, symbol,
    open, high, low, close, volume, adjusted, 
    retorno_adjusted,
    SMA_Diff, RSI14, BB_Width, ATR14,
    SMA20, SMA50
  ) %>%
  pivot_wider(
    names_from = symbol,
    values_from = c(
      open, high, low, close, volume, adjusted, 
      retorno_adjusted,
      SMA_Diff, RSI14, BB_Width, ATR14,
      SMA20, SMA50
    )
  ) %>%
  na.omit() %>%
  mutate(
    egarch_vol_AAPL = calcular_egarch_volatilidade(retorno_adjusted_AAPL),
    egarch_vol_NVDA = calcular_egarch_volatilidade(retorno_adjusted_NVDA),
    egarch_vol_AMZN = calcular_egarch_volatilidade(retorno_adjusted_AMZN),
    egarch_vol_MSFT = calcular_egarch_volatilidade(retorno_adjusted_MSFT)
  )

df_us %>%
  select(date, starts_with("egarch_vol_")) %>%
  pivot_longer(-date, names_to = "ativo", values_to = "volatilidade", 
               names_prefix = "egarch_vol_") %>%
  mutate(ativo = str_remove(ativo, ".SA")) %>%
  ggplot(aes(x = date, y = volatilidade, colour = ativo)) +
  annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-12-31"),
           ymin = -Inf, ymax = Inf, fill = "#6FC7C7", alpha = 0.5) +
  annotate("text", x = as.Date("2020-10-01"), y = Inf, label = "Pandemia",
           vjust = 1.5, size = 3.5, colour = "#000000") +
  geom_line(linewidth = 0.9) +
  theme_econ_base() +
  scale_econ(aes = "colour", scheme = "lines_side") +
  scale_y_continuous(labels = fmt_lab("percent")) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Volatilidade EGARCH dos Ativos dos EUA",
    subtitle = "Faixa sombreada indica período da pandemia",
    x = NULL,
    y = "Volatilidade"
  )

# ----

# Modelo de classificação de regime de tendência ----

## MLP ---- 

n_inputs <- 15 
n_hidden1 <- 64
n_hidden2 <- 32
n_hidden3 <- 16
n_outputs <- 3 


MLP_Regime_Model_V5 <- nn_module(
  "RegimeClassifierV5",
  initialize = function(n_inputs, n_hidden1, n_hidden2, n_hidden3, n_outputs, dropout_rate = 0.3) {
    self$fc1 <- nn_linear(n_inputs, n_hidden1)
    self$bn1 <- nn_batch_norm1d(n_hidden1)
    self$relu1 <- nn_relu()
    self$dropout1 <- nn_dropout(p = dropout_rate)
    
    self$fc2 <- nn_linear(n_hidden1, n_hidden2)
    self$bn2 <- nn_batch_norm1d(n_hidden2)
    self$relu2 <- nn_relu()
    self$dropout2 <- nn_dropout(p = dropout_rate)
    
    self$fc3 <- nn_linear(n_hidden2, n_hidden3)
    self$bn3 <- nn_batch_norm1d(n_hidden3)
    self$relu3 <- nn_relu()
    self$dropout3 <- nn_dropout(p = dropout_rate)
    
    self$fc_out <- nn_linear(n_hidden3, n_outputs)
  },
  forward = function(x) {
    x %>%
      self$fc1() %>%
      self$bn1() %>%
      self$relu1() %>%
      self$dropout1() %>%
      self$fc2() %>%
      self$bn2() %>%
      self$relu2() %>%
      self$dropout2() %>%
      self$fc3() %>%
      self$bn3() %>%
      self$relu3() %>%
      self$dropout3() %>%
      self$fc_out()
  }
)

add_enhanced_features <- function(asset_data) {
  
  df <- asset_data %>%
    arrange(date) %>%
    mutate(
      ROC_5 = (close / dplyr::lag(close, 5)) - 1,
      ROC_10 = (close / dplyr::lag(close, 10)) - 1,
      ROC_20 = (close / dplyr::lag(close, 20)) - 1,
      ROC_60 = (close / dplyr::lag(close, 60)) - 1,
      
      realized_vol_5 = rollapply(retorno_adjusted, 5, sd, fill = NA, align = "right"),
      realized_vol_20 = rollapply(retorno_adjusted, 20, sd, fill = NA, align = "right"),
      realized_vol_60 = rollapply(retorno_adjusted, 60, sd, fill = NA, align = "right"),
      vol_ratio_5_20 = realized_vol_5 / (realized_vol_20 + 1e-8),
      vol_ratio_20_60 = realized_vol_20 / (realized_vol_60 + 1e-8),
      
      volume_sma20 = SMA(volume, 20),
      volume_ratio = volume / (volume_sma20 + 1e-8),
      
      adx_result = TTR::ADX(cbind(high, low, close), n = 14),
      ADX = adx_result[, "ADX"],
      
      high_low_range = (high - low) / (close + 1e-8),
      close_position = ifelse((high - low) > 0, 
                              (close - low) / (high - low), 
                              0.5),
      
      running_max = cummax(close),
      drawdown = (close - running_max) / (running_max + 1e-8),
      
      macd_result = TTR::MACD(close, 12, 26, 9),
      macd_line = macd_result[, "macd"],
      macd_signal = macd_result[, "signal"],
      macd_histogram = macd_line - macd_signal,
      
      days_above_sma50 = ifelse(close > SMA50, 1, -1),
      regime_persistence = rollapply(days_above_sma50, 20, sum, fill = NA, align = "right"),
      
      ret_lag1 = dplyr::lag(retorno_adjusted, 1),
      ret_lag2 = dplyr::lag(retorno_adjusted, 2),
      ret_lag3 = dplyr::lag(retorno_adjusted, 3),
      ret_lag5 = dplyr::lag(retorno_adjusted, 5),
      
      ret_momentum_5 = rollapply(retorno_adjusted, 5, mean, fill = NA, align = "right"),
      ret_momentum_10 = rollapply(retorno_adjusted, 10, mean, fill = NA, align = "right"),
      
      ret_autocorr = rollapply(retorno_adjusted, 10, 
                               function(x) {
                                 if (length(x) < 2 || sd(x, na.rm = TRUE) == 0) return(0)
                                 cor(x[1:9], x[2:10], use = "complete.obs")
                               }, 
                               fill = NA, align = "right"),
      
      vol_momentum = (realized_vol_5 - dplyr::lag(realized_vol_5, 5)) / (dplyr::lag(realized_vol_5, 5) + 1e-8)
    )
  
  return(df)
}


train_regime_model_v5 <- function(asset_data,
                                  look_forward = 20,
                                  threshold_multiplier = 1.0,
                                  label_method = "percentil",  
                                  use_focal_loss = TRUE,     
                                  epochs = 150,
                                  learning_rate = 0.0005,
                                  dropout_rate = 0.3,  
                                  seed = 42,
                                  verbose = TRUE) {
  
  set.seed(seed)
  torch_manual_seed(seed)
  
  if (verbose) cat("\n=== Iniciando Treino do Modelo V5 (OTIMIZADO) ===\n")
  if (verbose) cat("Adicionando features expandidas...\n")
  
  df_enhanced <- add_enhanced_features(asset_data)
  
  if (verbose) cat(sprintf("Criando labels com método: %s\n", label_method))
  
  df_labeled <- criar_labels_melhorados(
    df_enhanced,
    look_forward = look_forward,
    threshold_multiplier = threshold_multiplier,
    method = label_method
  ) %>%
    slice_head(n = -look_forward) %>%
    na.omit()
  
  features_names <- c(
    "drawdown", "SMA_Diff", "egarch_vol", "ROC_60", "regime_persistence",
    
    "RSI14", "realized_vol_20", "BB_Width", "ATR14",
    
    "ret_momentum_5", "ret_lag1", "ret_lag2",
    
    "macd_histogram", "ADX", "vol_ratio_5_20"
  )
  
  n_features <- length(features_names)
  if (verbose) cat(sprintf("Total de features SELECIONADAS: %d\n\n", n_features))
  
  n_total <- nrow(df_labeled)
  n_train <- floor(n_total * 0.70)
  n_val <- floor(n_total * 0.15)
  
  df_train <- df_labeled %>% slice(1:n_train)
  df_val <- df_labeled %>% slice((n_train + 1):(n_train + n_val))
  df_test <- df_labeled %>% slice((n_train + n_val + 1):n_total)
  
  if (verbose) {
    cat("=== Distribuição de Classes ===\n")
    cat("TREINO:\n")
    train_dist <- table(df_train$regime)
    print(train_dist)
    cat(sprintf("  Proporção: Baixa=%.1f%%, Lateral=%.1f%%, Alta=%.1f%%\n",
                train_dist[1]/sum(train_dist)*100,
                train_dist[2]/sum(train_dist)*100,
                train_dist[3]/sum(train_dist)*100))
    
    cat("\nTESTE:\n")
    test_dist <- table(df_test$regime)
    print(test_dist)
    cat(sprintf("  Proporção: Baixa=%.1f%%, Lateral=%.1f%%, Alta=%.1f%%\n\n",
                test_dist[1]/sum(test_dist)*100,
                test_dist[2]/sum(test_dist)*100,
                test_dist[3]/sum(test_dist)*100))
  }
  
  scaler <- caret::preProcess(df_train[, features_names], method = c("center", "scale"))
  
  x_train_scaled <- predict(scaler, df_train[, features_names])
  x_val_scaled <- predict(scaler, df_val[, features_names])
  x_test_scaled <- predict(scaler, df_test[, features_names])
  
  x_train_tensor <- torch_tensor(as.matrix(x_train_scaled), dtype = torch_float())
  x_val_tensor <- torch_tensor(as.matrix(x_val_scaled), dtype = torch_float())
  x_test_tensor <- torch_tensor(as.matrix(x_test_scaled), dtype = torch_float())
  
  y_train_tensor <- torch_tensor(as.integer(df_train$regime), dtype = torch_long())
  y_val_tensor <- torch_tensor(as.integer(df_val$regime), dtype = torch_long())
  y_test_tensor <- torch_tensor(as.integer(df_test$regime), dtype = torch_long())
  
  class_counts <- table(df_train$regime)
  class_weights <- 1.0 / as.numeric(class_counts)
  class_weights <- class_weights / sum(class_weights) * length(class_weights)
  
  if (verbose) {
    cat("=== Pesos das Classes ===\n")
    weight_df <- data.frame(
      Classe = names(class_counts),
      Count = as.numeric(class_counts),
      Weight = round(class_weights, 3)
    )
    print(weight_df)
    cat("\n")
  }
  
  weight_tensor <- torch_tensor(class_weights, dtype = torch_float())
  
  model <- MLP_Regime_Model_V5(
    n_inputs = n_features,
    n_hidden1 = n_hidden1,
    n_hidden2 = n_hidden2,
    n_hidden3 = n_hidden3,
    n_outputs = n_outputs,
    dropout_rate = dropout_rate
  )
  
  if (use_focal_loss) {
    if (verbose) cat("Usando Focal Loss (alpha=0.25, gamma=2.0)\n\n")
    loss_fn <- focal_loss_fn(alpha = 0.25, gamma = 2.0, weight = weight_tensor)
  } else {
    if (verbose) cat("Usando Cross Entropy Loss com class weights\n\n")
    loss_fn <- nn_cross_entropy_loss(weight = weight_tensor)
  }
  
  optimizer <- optim_adam(model$parameters, lr = learning_rate, weight_decay = 1e-5)
  scheduler <- lr_step(optimizer, step_size = 30, gamma = 0.5)
  
  if (verbose) cat("=== Iniciando Treinamento ===\n")
  
  best_val_loss <- Inf
  best_val_acc <- 0
  best_model_state <- NULL
  patience_counter <- 0
  patience <- 25
  
  for (epoch in 1:epochs) {
    model$train()
    y_pred_logits <- model(x_train_tensor)
    loss <- loss_fn(y_pred_logits, y_train_tensor)
    
    optimizer$zero_grad()
    loss$backward()
    optimizer$step()
    
    model$eval()
    with_no_grad({
      val_logits <- model(x_val_tensor)
      val_loss <- loss_fn(val_logits, y_val_tensor)
      
      val_pred_class <- torch_argmax(val_logits, dim = 2)
      val_correct <- torch_sum(val_pred_class == y_val_tensor)
      val_acc <- as.numeric(val_correct) / as.numeric(y_val_tensor$numel())
      
      if (verbose && (epoch %% 25 == 0 || epoch == 1)) {
        current_lr <- optimizer$param_groups[[1]]$lr
        cat(sprintf("Epoch %3d - Train Loss: %.4f | Val Loss: %.4f | Val Acc: %.3f | LR: %.6f\n", 
                    epoch, as.numeric(loss), as.numeric(val_loss), val_acc, current_lr))
      }
      
      if (as.numeric(val_loss) < best_val_loss) {
        best_val_loss <- as.numeric(val_loss)
        best_val_acc <- val_acc
        best_model_state <- model$state_dict()
        patience_counter <- 0
      } else {
        patience_counter <- patience_counter + 1
      }
      
      if (patience_counter >= patience) {
        if (verbose) cat(sprintf("Early stopping at epoch %d\n", epoch))
        break
      }
    })
    
    scheduler$step()
  }
  
  if (!is.null(best_model_state)) {
    model$load_state_dict(best_model_state)
  }
  
  if (verbose) cat(sprintf("\nMelhor Val Loss: %.4f | Melhor Val Acc: %.3f\n\n", 
                           best_val_loss, best_val_acc))
  
  if (verbose) cat("=== Avaliação no Conjunto de Teste ===\n")
  
  model$eval()
  
  predictions_tensor <- with_no_grad({
    test_logits <- model(x_test_tensor)
    torch_argmax(test_logits, dim = 2)
  })
  
  predicted_regime <- factor(as.integer(predictions_tensor),
                             levels = 1:3,
                             labels = c("Baixa", "Laterizacao", "Alta"))
  
  test_accuracy <- with_no_grad({
    test_logits <- model(x_test_tensor)
    test_predicted_class <- torch_argmax(test_logits, dim = 2)
    correct_test_preds <- torch_sum(test_predicted_class == y_test_tensor)
    as.numeric(correct_test_preds) / as.numeric(y_test_tensor$numel())
  })
  
  conf_matrix <- table(Previsto = predicted_regime, Real = df_test$regime)
  
  metrics_per_class <- list()
  for (i in 1:3) {
    classe <- c("Baixa", "Laterizacao", "Alta")[i]
    tp <- conf_matrix[i, i]
    fp <- sum(conf_matrix[i, ]) - tp
    fn <- sum(conf_matrix[, i]) - tp
    
    precision <- ifelse(tp + fp > 0, tp / (tp + fp), 0)
    recall <- ifelse(tp + fn > 0, tp / (tp + fn), 0)
    f1 <- ifelse(precision + recall > 0, 2 * precision * recall / (precision + recall), 0)
    
    metrics_per_class[[classe]] <- list(
      precision = precision,
      recall = recall,
      f1 = f1
    )
  }
  
  if (verbose) {
    cat(sprintf("Acurácia Total: %.3f\n\n", test_accuracy))
    
    cat("=== Matriz de Confusão (Teste) ===\n")
    print(conf_matrix)
    cat("\n")
    
    cat("=== Métricas por Classe ===\n")
    for (classe in names(metrics_per_class)) {
      m <- metrics_per_class[[classe]]
      cat(sprintf("%s: Precision=%.3f | Recall=%.3f | F1=%.3f\n", 
                  classe, m$precision, m$recall, m$f1))
    }
    cat("\n")
  }
  
  return(
    list(
      test_accuracy = test_accuracy,
      val_accuracy = best_val_acc,
      metrics_per_class = metrics_per_class,
      confusion_matrix = conf_matrix,
      
      trained_model = model,
      scaler = scaler,
      model_name = "RegimeClassifierV5_Optimized",
      
      date = df_test$date,
      predicted_regime = predicted_regime,
      actual_regime = df_test$regime,
      
      features_used = features_names,
      label_method = label_method,
      look_forward = look_forward,
      
      n_train = n_train,
      n_val = n_val,
      n_test = nrow(df_test)
    )
  )
}

predict_regime <- function(current_data, modelo_treinado, scaler, features_used) {
  
  df_features <- add_enhanced_features(current_data) %>%
    tail(1) %>%  
    select(all_of(features_used))
  
  df_scaled <- predict(scaler, df_features)
  
  x_tensor <- torch_tensor(as.matrix(df_scaled), dtype = torch_float())
  
  modelo_treinado$eval()
  with_no_grad({
    logits <- modelo_treinado(x_tensor)
    pred_class <- as.integer(torch_argmax(logits, dim = 2))
  })
  
  regime <- factor(pred_class, levels = 1:3, labels = c("Baixa", "Laterizacao", "Alta"))
  
  return(as.character(regime))
}

criar_labels_melhorados <- function(df_enhanced, look_forward = 20, 
                                    threshold_multiplier = 1.0,
                                    method = "adaptive") {
  
  df_labeled <- df_enhanced %>%
    mutate(
      rolling_vol = rollapply(retorno_adjusted, 60, sd, fill = NA, align = "right"),
      
      rolling_sharpe = rollapply(retorno_adjusted, 60, 
                                 function(x) mean(x)/sd(x), 
                                 fill = NA, align = "right"),
      
      future_return = (dplyr::lead(close, n = look_forward) / close) - 1
    )
  
  if (method == "adaptive") {
    df_labeled <- df_labeled %>%
      mutate(
        base_threshold = rolling_vol * threshold_multiplier * sqrt(look_forward),
        
        sharpe_adjustment = pmax(0.8, 1 + abs(rolling_sharpe) * 0.15),
        
        adaptive_threshold = base_threshold * sharpe_adjustment,
        
        regime = case_when(
          future_return > adaptive_threshold  ~ "Alta",
          future_return < -adaptive_threshold ~ "Baixa",
          TRUE                                ~ "Laterizacao"
        ),
        regime = factor(regime, levels = c("Baixa", "Laterizacao", "Alta"))
      )
    
  } else if (method == "percentil") {
    df_labeled <- df_labeled %>%
      mutate(
        regime = case_when(
          future_return > quantile(future_return, 0.66, na.rm = TRUE) ~ "Alta",
          future_return < quantile(future_return, 0.33, na.rm = TRUE) ~ "Baixa",
          TRUE ~ "Laterizacao"
        ),
        regime = factor(regime, levels = c("Baixa", "Laterizacao", "Alta"))
      )
  }
  
  return(df_labeled)
}


focal_loss_fn <- function(alpha = 0.25, gamma = 2.0, weight = NULL) {
  function(input, target) {
    ce_loss <- nnf_cross_entropy(input, target, reduction = "none", weight = weight)
    
    pt <- torch_exp(-ce_loss)
    
    focal_loss <- alpha * (1 - pt)^gamma * ce_loss
    
    return(torch_mean(focal_loss))
  }
}

## LSTM ----

LSTM_Regime_Model <- nn_module(
  "LSTM_Regime_Model",
  
  initialize = function(input_size,
                        hidden_size,
                        num_layers,
                        n_outputs,
                        dropout_rate = 0.3) {
    self$lstm <- nn_lstm(
      input_size = input_size,
      hidden_size = hidden_size,
      num_layers = num_layers,
      batch_first = TRUE,
      dropout = ifelse(num_layers > 1, dropout_rate, 0)
    )
    self$bn1 <- nn_batch_norm1d(hidden_size)
    self$dropout <- nn_dropout(p = dropout_rate)
    self$fc_out <- nn_linear(hidden_size, n_outputs)
  },
  
  forward = function(x) {
    lstm_out <- self$lstm(x)[[1]]
    x <- lstm_out[, dim(lstm_out)[2], ]
    x %>%
      self$bn1() %>%
      self$dropout() %>%
      self$fc_out()
  }
)

create_windowed_sequences <- function(df_features, df_labels, seq_length = 20) {
  n_samples <- nrow(df_features) - seq_length + 1
  n_features <- ncol(df_features)
  x_array <- array(0, dim = c(n_samples, seq_length, n_features))
  y_array <- array(0, dim = c(n_samples))
  mat_features <- as.matrix(df_features)
  vec_labels <- as.integer(df_labels)
  for (i in 1:n_samples) {
    x_array[i, , ] <- mat_features[i:(i + seq_length - 1), ]
    y_array[i] <- vec_labels[i + seq_length - 1]
  }
  return(list(x = x_array, y = y_array))
}


add_enhanced_features <- function(asset_data) {
  df <- asset_data %>%
    arrange(date) %>%
    mutate(
      ROC_5 = (close / dplyr::lag(close, 5)) - 1,
      ROC_10 = (close / dplyr::lag(close, 10)) - 1,
      ROC_20 = (close / dplyr::lag(close, 20)) - 1,
      ROC_60 = (close / dplyr::lag(close, 60)) - 1,
      realized_vol_5 = slider::slide_dbl(
        retorno_adjusted,
        sd,
        .before = 4,
        .complete = TRUE,
        na.rm = TRUE
      ),
      realized_vol_20 = slider::slide_dbl(
        retorno_adjusted,
        sd,
        .before = 19,
        .complete = TRUE,
        na.rm = TRUE
      ),
      realized_vol_60 = slider::slide_dbl(
        retorno_adjusted,
        sd,
        .before = 59,
        .complete = TRUE,
        na.rm = TRUE
      ),
      vol_ratio_5_20 = realized_vol_5 / (realized_vol_20 + 1e-8),
      vol_ratio_20_60 = realized_vol_20 / (realized_vol_60 + 1e-8),
      volume_sma20 = SMA(volume, 20),
      volume_ratio = volume / (volume_sma20 + 1e-8),
      adx_result = TTR::ADX(cbind(high, low, close), n = 14),
      ADX = adx_result[, "ADX"],
      high_low_range = (high - low) / (close + 1e-8),
      close_position = ifelse((high - low) > 0, (close - low) / (high - low), 0.5),
      running_max = cummax(close),
      drawdown = (close - running_max) / (running_max + 1e-8),
      macd_result = TTR::MACD(close, 12, 26, 9),
      macd_line = macd_result[, "macd"],
      macd_signal = macd_result[, "signal"],
      macd_histogram = macd_line - macd_signal,
      
      ATR14 = TTR::ATR(cbind(high, low, close), n = 14)[, "atr"],
      RSI14 = TTR::RSI(close, n = 14),
      BBands_mat = TTR::BBands(close, n = 20, sd = 2),
      SMA20 = TTR::SMA(close, n = 20),
      SMA50 = TTR::SMA(close, n = 50), 
      SMA_Diff = SMA20 - SMA50,       
      BB_Width = (BBands_mat[, "up"] - BBands_mat[, "dn"]) / (BBands_mat[, "mavg"] + 1e-8), 
      
      days_above_sma50 = ifelse(close > SMA50, 1, -1),
      regime_persistence = slider::slide_dbl(
        days_above_sma50,
        sum,
        .before = 19,
        .complete = TRUE,
        na.rm = TRUE
      ),
      ret_lag1 = dplyr::lag(retorno_adjusted, 1),
      ret_lag2 = dplyr::lag(retorno_adjusted, 2),
      ret_lag3 = dplyr::lag(retorno_adjusted, 3),
      ret_lag5 = dplyr::lag(retorno_adjusted, 5),
      
      ret_momentum_5 = slider::slide_dbl(
        retorno_adjusted,
        mean,
        .before = 4,
        .complete = TRUE,
        na.rm = TRUE
      ),
      ret_momentum_10 = slider::slide_dbl(
        retorno_adjusted,
        mean,
        .before = 9,
        .complete = TRUE,
        na.rm = TRUE
      ),
      ret_autocorr = slider::slide_dbl(retorno_adjusted, function(x) {
        if (length(x) < 2 || sd(x, na.rm = TRUE) == 0)
          return(0)
        cor(x[1:(length(x) - 1)], x[2:length(x)], use = "complete.obs")
      }, .before = 9, .complete = TRUE),
      vol_momentum = (realized_vol_5 - dplyr::lag(realized_vol_5, 5)) / (dplyr::lag(realized_vol_5, 5) + 1e-8),
      
      egarch_vol = calcular_egarch_dl(retorno_adjusted)
    )
  
  return(df)
}

criar_labels_melhorados <- function(df_enhanced,
                                    look_forward = 20,
                                    threshold_multiplier = 1.0,
                                    method = "adaptive") {
  df_labeled <- df_enhanced %>%
    mutate(
      rolling_vol = slider::slide_dbl(
        retorno_adjusted,
        sd,
        .before = 59,
        .complete = TRUE,
        na.rm = TRUE
      ),
      
      rolling_sharpe = slider::slide_dbl(retorno_adjusted, function(x)
        mean(x, na.rm = T) / (sd(x, na.rm = T) + 1e-8), .before = 59, .complete = TRUE),
      
      future_return = (dplyr::lead(close, n = look_forward) / close) - 1
    )
  
  if (method == "adaptive") {
    df_labeled <- df_labeled %>%
      mutate(
        base_threshold = rolling_vol * threshold_multiplier * sqrt(look_forward),
        sharpe_adjustment = pmax(0.8, 1 + abs(rolling_sharpe) * 0.15),
        
        adaptive_threshold = base_threshold * sharpe_adjustment,
        
        regime = case_when(
          future_return > adaptive_threshold  ~ "Alta",
          future_return < -adaptive_threshold ~ "Baixa",
          TRUE                                ~ "Laterizacao"
        ),
        regime = factor(regime, levels = c("Baixa", "Laterizacao", "Alta"))
      )
    
  } else if (method == "percentil") {
    df_labeled <- df_labeled %>%
      mutate(
        regime = case_when(
          future_return > quantile(future_return, 0.66, na.rm = TRUE) ~ "Alta",
          future_return < quantile(future_return, 0.33, na.rm = TRUE) ~ "Baixa",
          TRUE ~ "Laterizacao"
        ),
        regime = factor(regime, levels = c("Baixa", "Laterizacao", "Alta"))
      )
  }
  
  return(df_labeled)
}


focal_loss_fn <- function(alpha = 0.25,
                          gamma = 2.0,
                          weight = NULL) {
  function(input, target) {
    ce_loss <- nnf_cross_entropy(input, target, reduction = "none", weight = weight)
    
    pt <- torch_exp(-ce_loss)
    
    focal_loss <- alpha * (1 - pt)^gamma * ce_loss
    
    return(torch_mean(focal_loss))
  }
}


train_lstm_model <- function(asset_data,
                             look_forward = 20,
                             threshold_multiplier = 1.0,
                             label_method = "percentil",
                             use_focal_loss = TRUE,
                             epochs = 150,
                             learning_rate = 0.0005,
                             dropout_rate = 0.3,
                             seq_length = 20,
                             hidden_size = 64,
                             num_layers = 2,
                             seed = 42,
                             verbose = TRUE) {
  set.seed(seed)
  torch_manual_seed(seed)
  if (verbose)
    cat("\n=== Iniciando Treino do Modelo LSTM ===\n")
  if (verbose)
    cat("Adicionando features expandidas...\n")
  df_enhanced <- add_enhanced_features(asset_data)
  if (verbose)
    cat(sprintf("Criando labels com método: %s\n", label_method))
  df_labeled <- criar_labels_melhorados(
    df_enhanced,
    look_forward = look_forward,
    threshold_multiplier = threshold_multiplier,
    method = label_method
  ) %>%
    slice_head(n = -look_forward) %>%
    na.omit()
  features_names <- c(
    "drawdown",
    "SMA_Diff",
    "egarch_vol",
    "ROC_60",
    "regime_persistence",
    "RSI14",
    "realized_vol_20",
    "BB_Width",
    "ATR14",
    "ret_momentum_5",
    "ret_lag1",
    "ret_lag2",
    "macd_histogram",
    "ADX",
    "vol_ratio_5_20"
  )
  n_features <- length(features_names)
  if (verbose)
    cat(sprintf("Total de features SELECIONADAS: %d\n\n", n_features))
  n_total <- nrow(df_labeled)
  n_train <- floor(n_total * 0.70)
  n_val <- floor(n_total * 0.15)
  
  df_train <- df_labeled %>% slice(1:n_train)
  df_val <- df_labeled %>% slice((n_train + 1):(n_train + n_val))
  df_test <- df_labeled %>% slice((n_train + n_val + 1):n_total)
  if (verbose) {
    cat("=== Distribuição de Classes (Original) ===\n")
    cat("TREINO:\n")
    print(table(df_train$regime))
    cat("\nTESTE:\n")
    print(table(df_test$regime))
  }
  scaler <- caret::preProcess(df_train[, features_names], method = c("center", "scale"))
  x_train_scaled_df <- predict(scaler, df_train[, features_names])
  x_val_scaled_df <- predict(scaler, df_val[, features_names])
  x_test_scaled_df <- predict(scaler, df_test[, features_names])
  if (verbose)
    cat(sprintf("Criando sequências com janelas de %d dias...\n", seq_length))
  train_data <- create_windowed_sequences(x_train_scaled_df, df_train$regime, seq_length)
  val_data   <- create_windowed_sequences(x_val_scaled_df, df_val$regime, seq_length)
  test_data  <- create_windowed_sequences(x_test_scaled_df, df_test$regime, seq_length)
  
  x_train_tensor <- torch_tensor(train_data$x, dtype = torch_float())
  x_val_tensor <- torch_tensor(val_data$x, dtype = torch_float())
  x_test_tensor <- torch_tensor(test_data$x, dtype = torch_float())
  
  y_train_tensor <- torch_tensor(train_data$y, dtype = torch_long())
  y_val_tensor <- torch_tensor(val_data$y, dtype = torch_long())
  y_test_tensor <- torch_tensor(test_data$y, dtype = torch_long())
  
  class_counts <- table(train_data$y) 
  class_weights <- 1.0 / as.numeric(class_counts)
  class_weights <- class_weights / sum(class_weights) * length(class_weights)
  
  if (verbose) {
    cat("=== Pesos das Classes (base-1) ===\n")
    weight_df <- data.frame(
      Classe = names(class_counts),
      Count = as.numeric(class_counts),
      Weight = round(class_weights, 3)
    )
    print(weight_df)
    cat("\n")
  }
  
  weight_tensor <- torch_tensor(class_weights, dtype = torch_float())
  
  
  model <- LSTM_Regime_Model(
    input_size = n_features,
    hidden_size = hidden_size,
    num_layers = num_layers,
    n_outputs = 3,
    dropout_rate = dropout_rate
  )
  
  if (cuda_is_available()) {
    model <- model$cuda()
    x_train_tensor <- x_train_tensor$cuda()
    y_train_tensor <- y_train_tensor$cuda()
    x_val_tensor <- x_val_tensor$cuda()
    y_val_tensor <- y_val_tensor$cuda()
    x_test_tensor <- x_test_tensor$cuda()
    y_test_tensor <- y_test_tensor$cuda()
    weight_tensor <- weight_tensor$cuda()
    if (verbose)
      cat(">>> Treinando na GPU <<<\n")
  } else {
    if (verbose)
      cat(">>> Treinando na CPU <<<\n")
  }
  
  
  if (use_focal_loss) {
    if (verbose)
      cat("Usando Focal Loss (alpha=0.25, gamma=2.0)\n\n")
    loss_fn <- focal_loss_fn(alpha = 0.25,
                             gamma = 2.0,
                             weight = weight_tensor)
  } else {
    if (verbose)
      cat("Usando Cross Entropy Loss com class weights\n\n")
    loss_fn <- nn_cross_entropy_loss(weight = weight_tensor)
  }
  
  optimizer <- optim_adam(model$parameters, lr = learning_rate, weight_decay = 1e-5)
  scheduler <- lr_step(optimizer, step_size = 30, gamma = 0.5)
  
  if (verbose)
    cat("=== Iniciando Treinamento ===\n")
  best_val_loss <- Inf
  best_val_acc <- 0
  best_model_state <- NULL
  patience_counter <- 0
  patience <- 25
  
  for (epoch in 1:epochs) {
    model$train()
    y_pred_logits <- model(x_train_tensor)
    loss <- loss_fn(y_pred_logits, y_train_tensor)
    
    optimizer$zero_grad()
    loss$backward()
    optimizer$step()
    
    model$eval()
    with_no_grad({
      val_logits <- model(x_val_tensor)
      val_loss <- loss_fn(val_logits, y_val_tensor)
      
      val_pred_class <- torch_argmax(val_logits, dim = 2) 
      val_correct <- torch_sum(val_pred_class == y_val_tensor)
      val_acc <- as.numeric(val_correct$cpu()) / as.numeric(y_val_tensor$numel())
      
      if (verbose && (epoch %% 25 == 0 || epoch == 1)) {
        current_lr <- optimizer$param_groups[[1]]$lr
        cat(
          sprintf(
            "Epoch %3d - Train Loss: %.4f | Val Loss: %.4f | Val Acc: %.3f | LR: %.6f\n",
            epoch,
            as.numeric(loss$cpu()),
            as.numeric(val_loss$cpu()),
            val_acc,
            current_lr
          )
        )
      }
      
      if (as.numeric(val_loss$cpu()) < best_val_loss) {
        best_val_loss <- as.numeric(val_loss$cpu())
        best_val_acc <- val_acc
        best_model_state <- model$to(device = "cpu")$state_dict()
        model$to(device = x_train_tensor$device) 
        patience_counter <- 0
      } else {
        patience_counter <- patience_counter + 1
      }
      
      if (patience_counter >= patience) {
        if (verbose)
          cat(sprintf("Early stopping at epoch %d\n", epoch))
        break
      }
    })
    
    scheduler$step()
  }
  
  
  final_model <- LSTM_Regime_Model(
    input_size = n_features,
    hidden_size = hidden_size,
    num_layers = num_layers,
    n_outputs = 3,
    dropout_rate = dropout_rate
  )$to(device = "cpu")
  
  if (!is.null(best_model_state)) {
    final_model$load_state_dict(best_model_state)
  }
  final_model$eval() 
  
  
  if (verbose)
    cat(
      sprintf(
        "\nMelhor Val Loss: %.4f | Melhor Val Acc: %.3f\n\n",
        best_val_loss,
        best_val_acc
      )
    )
  
  if (verbose)
    cat("=== Avaliação no Conjunto de Teste ===\n")
  
  x_test_tensor_cpu <- x_test_tensor$cpu()
  y_test_tensor_cpu <- y_test_tensor$cpu()
  
  predictions_tensor <- with_no_grad({
    test_logits <- final_model(x_test_tensor_cpu)
    torch_argmax(test_logits, dim = 2) 
  })
  
  predicted_regime <- factor(
    as.integer(predictions_tensor),
    levels = 1:3,
    labels = c("Baixa", "Laterizacao", "Alta")
  )
  
  
  df_test_ajustado <- df_test %>% slice(seq_length:n())
  
  y_test_labels_aligned <- df_test_ajustado$regime
  
  test_accuracy <- mean(predicted_regime == y_test_labels_aligned, na.rm = TRUE)
  
  conf_matrix <- table(Previsto = predicted_regime, Real = y_test_labels_aligned)
  
  metrics_per_class <- list()
  for (i in 1:3) {
    classe <- c("Baixa", "Laterizacao", "Alta")[i]
    if (classe %in% rownames(conf_matrix) &&
        classe %in% colnames(conf_matrix)) {
      tp <- conf_matrix[classe, classe]
      fp <- sum(conf_matrix[classe, ]) - tp
      fn <- sum(conf_matrix[, classe]) - tp
    } else {
      tp <- 0
      fp <- sum(conf_matrix[rownames(conf_matrix) == classe, ])
      fn <- sum(conf_matrix[, colnames(conf_matrix) == classe])
    }
    
    precision <- ifelse(tp + fp > 0, tp / (tp + fp), 0)
    recall <- ifelse(tp + fn > 0, tp / (tp + fn), 0)
    f1 <- ifelse(precision + recall > 0,
                 2 * precision * recall / (precision + recall),
                 0)
    
    metrics_per_class[[classe]] <- list(precision = precision,
                                        recall = recall,
                                        f1 = f1)
  }
  
  if (verbose) {
    cat(sprintf("Acurácia Total: %.3f\n\n", test_accuracy))
    cat("=== Matriz de Confusão (Teste) ===\n")
    print(conf_matrix)
    cat("\n")
    cat("=== Métricas por Classe ===\n")
    for (classe in names(metrics_per_class)) {
      m <- metrics_per_class[[classe]]
      cat(
        sprintf(
          "%-12s: Precision=%.3f | Recall=%.3f | F1=%.3f\n",
          paste0(classe, ":"),
          m$precision,
          m$recall,
          m$f1
        )
      )
    }
    cat("\n")
  }
  
  return(
    list(
      test_accuracy = test_accuracy,
      val_accuracy = best_val_acc,
      metrics_per_class = metrics_per_class,
      confusion_matrix = conf_matrix,
      
      trained_model = final_model,
      scaler = scaler,
      model_name = "LSTM_Regime_Model",
      
      date = df_test_ajustado$date,
      predicted_regime = predicted_regime,
      actual_regime = y_test_labels_aligned,
      
      features_used = features_names,
      label_method = label_method,
      look_forward = look_forward,
      hyperparams = list(
        seq_length = seq_length,
        hidden_size = hidden_size,
        num_layers = num_layers,
        n_features = n_features,
        n_outputs = 3,
        dropout_rate = dropout_rate
      ),
      
      n_train = nrow(train_data$x),
      n_val = nrow(val_data$x),
      n_test = nrow(test_data$x)
    )
  )
}

predict_regime <- function(current_data,
                           modelo_treinado,
                           scaler,
                           features_used,
                           seq_length) {
  
  df_features <- add_enhanced_features(current_data) %>%
    tail(seq_length) 
  
  if (nrow(df_features) < seq_length) {
    return(NA_character_)
  }
  
  df_scaled <- predict(scaler, df_features[, features_used])
  
  x_tensor <- torch_tensor(as.matrix(df_scaled), dtype = torch_float())$unsqueeze(1)
  
  modelo_treinado$eval()
  with_no_grad({
    x_tensor <- x_tensor$to(device = modelo_treinado$parameters[[1]]$device)
    logits <- modelo_treinado(x_tensor)
    
    pred_class <- as.integer(torch_argmax(logits$cpu(), dim = 2))
  })
  
  regime <- factor(
    pred_class,
    levels = 1:3,
    labels = c("Baixa", "Laterizacao", "Alta")
  )
  
  return(as.character(regime))
}


# ----

## Brasil ----

df_br_long <- df_br %>%
  pivot_longer(
    cols = -date,
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)"
  ) %>%
  filter(symbol %in% stocks_br) %>%
  select(
    date, symbol,
    open, high, low, close, volume, adjusted,
    retorno_adjusted, 
    SMA_Diff, RSI14, BB_Width, ATR14, egarch_vol, 
    SMA20, SMA50
  ) %>%
  drop_na() %>%
  arrange(symbol, date)

df_nested_br <- df_br_long %>%
  group_by(symbol) %>%
  nest()

df_results_br_combined <- df_nested_br %>%
  mutate(
    model_results_mlp = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo MLP (V5) para: %s <<<\n", .x))
      train_regime_model_v5(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE 
      )
    }),
    
    model_results_lstm = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo LSTM para: %s <<<\n", .x)) 
      train_lstm_model(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE, 
        seq_length = 20,    
        hidden_size = 64,   
        num_layers = 2      
      )
    })
  )

summary_br_mlp <- df_results_br_combined %>%
  select(symbol, model_results_mlp) %>%
  mutate(
    test_accuracy = map_dbl(model_results_mlp, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_mlp, ~.x$val_accuracy)
  ) %>%
  select(-model_results_mlp) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "MLP")

print(summary_br_mlp)

summary_br_lstm <- df_results_br_combined %>%
  select(symbol, model_results_lstm) %>%
  mutate(
    test_accuracy = map_dbl(model_results_lstm, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_lstm, ~.x$val_accuracy)
  ) %>%
  select(-model_results_lstm) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "LSTM")

print(summary_br_lstm)

summary_br_all <- bind_rows(summary_br_mlp, summary_br_lstm)

summary_br_all %>%
  pivot_longer(cols = c(test_accuracy, val_accuracy), 
               names_to = "metric", 
               values_to = "accuracy") %>%
  mutate(metric = ifelse(metric == "test_accuracy", "Teste", "Validação")) %>%
  ggplot(aes(x = reorder(symbol, accuracy), y = accuracy, fill = metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "red", alpha = 0.5) +
  annotate("text", x = 1, y = 0.35, label = "Baseline (33%)", 
           color = "red", size = 3) +
  coord_flip() +
  scale_fill_manual(values = c("Teste" = "#006BA2", "Validação" = "#3EBCD2")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  theme_econ_base() +
  labs(
    title = "Acurácia dos Modelos de Regime - Ações Brasil",
    subtitle = "Comparação entre MLP e LSTM",
    x = "Ativo",
    y = "Acurácia",
    fill = "Conjunto"
  ) +
  facet_wrap(~ model_type)

df_signals_br_mlp <- df_results_br_combined %>% 
  select(symbol, model_results_mlp) %>%
  mutate(
    date = map(model_results_mlp, ~.x$date),
    predicted_regime = map(model_results_mlp, ~.x$predicted_regime)
  ) %>%
  select(-model_results_mlp) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_MLP = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_MLP) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_MLP,
    names_prefix = "weight_MLP_" 
  )

df_signals_br_lstm <- df_results_br_combined %>% 
  select(symbol, model_results_lstm) %>%
  mutate(
    date = map(model_results_lstm, ~.x$date),
    predicted_regime = map(model_results_lstm, ~.x$predicted_regime)
  ) %>%
  select(-model_results_lstm) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_LSTM = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_LSTM) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_LSTM,
    names_prefix = "weight_LSTM_"
  )

df_br <- df_br %>%
  left_join(df_signals_br_mlp, by = "date") %>%
  left_join(df_signals_br_lstm, by = "date") %>%
  mutate(across(starts_with("weight_MLP_") | starts_with("weight_LSTM_"), ~replace_na(.x, 0)))

rm(df_br_long, df_nested_br,
   summary_br_mlp, summary_br_lstm,
   df_signals_br_mlp, df_signals_br_lstm)

## Comodities ----

df_como_long <- df_como %>%
  pivot_longer(
    cols = -date,
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)"
  ) %>%
  filter(symbol %in% tickers_como) %>% 
  select(
    date, symbol,
    open, high, low, close, volume, adjusted,
    retorno_adjusted, 
    SMA_Diff, RSI14, BB_Width, ATR14, egarch_vol,
    SMA20, SMA50
  ) %>%
  drop_na() %>%
  arrange(symbol, date)

df_nested_como <- df_como_long %>%
  group_by(symbol) %>%
  nest()

df_results_como_combined <- df_nested_como %>%
  mutate(
    model_results_mlp = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo MLP (V5) para: %s <<<\n", .x))
      train_regime_model_v5(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE 
      )
    }),
    
    model_results_lstm = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo LSTM para: %s <<<\n", .x)) 
      train_lstm_model(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE, 
        seq_length = 20,    
        hidden_size = 64,   
        num_layers = 2      
      )
    })
  )

summary_como_mlp <- df_results_como_combined %>%
  select(symbol, model_results_mlp) %>%
  mutate(
    test_accuracy = map_dbl(model_results_mlp, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_mlp, ~.x$val_accuracy)
  ) %>%
  select(-model_results_mlp) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "MLP")

print(summary_como_mlp)

summary_como_lstm <- df_results_como_combined %>%
  select(symbol, model_results_lstm) %>%
  mutate(
    test_accuracy = map_dbl(model_results_lstm, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_lstm, ~.x$val_accuracy)
  ) %>%
  select(-model_results_lstm) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "LSTM")

print(summary_como_lstm)

summary_como_all <- bind_rows(summary_como_mlp, summary_como_lstm)

summary_como_all %>%
  pivot_longer(cols = c(test_accuracy, val_accuracy), 
               names_to = "metric", 
               values_to = "accuracy") %>%
  mutate(metric = ifelse(metric == "test_accuracy", "Teste", "Validação")) %>%
  ggplot(aes(x = reorder(symbol, accuracy), y = accuracy, fill = metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "red", alpha = 0.5) +
  annotate("text", x = 1, y = 0.35, label = "Baseline (33%)", 
           color = "red", size = 3) +
  coord_flip() +
  scale_fill_manual(values = c("Teste" = "#006BA2", "Validação" = "#3EBCD2")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  theme_econ_base() + 
  labs(
    title = "Acurácia dos Modelos de Regime - Commodities",
    subtitle = "Comparação entre MLP e LSTM",
    x = "Ativo",
    y = "Acurácia",
    fill = "Conjunto"
  ) +
  facet_wrap(~ model_type)

df_signals_como_mlp <- df_results_como_combined %>% 
  select(symbol, model_results_mlp) %>%
  mutate(
    date = map(model_results_mlp, ~.x$date),
    predicted_regime = map(model_results_mlp, ~.x$predicted_regime)
  ) %>%
  select(-model_results_mlp) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_MLP = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_MLP) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_MLP,
    names_prefix = "weight_MLP_" 
  )

df_signals_como_lstm <- df_results_como_combined %>% 
  select(symbol, model_results_lstm) %>%
  mutate(
    date = map(model_results_lstm, ~.x$date),
    predicted_regime = map(model_results_lstm, ~.x$predicted_regime)
  ) %>%
  select(-model_results_lstm) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_LSTM = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_LSTM) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_LSTM,
    names_prefix = "weight_LSTM_" 
  )

df_como <- df_como %>%
  left_join(df_signals_como_mlp, by = "date") %>%
  left_join(df_signals_como_lstm, by = "date") %>%
  mutate(across(starts_with("weight_MLP_") | starts_with("weight_LSTM_"), ~replace_na(.x, 0)))

rm(df_como_long, df_nested_como,
   summary_como_mlp, summary_como_lstm,
   df_signals_como_mlp, df_signals_como_lstm)

## Crypto ----

df_crypto_long <- df_crypto %>%
  pivot_longer(
    cols = -date,
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)"
  ) %>%
  filter(symbol %in% tickers_crypto) %>% 
  select(
    date, symbol,
    open, high, low, close, volume, adjusted,
    retorno_adjusted, 
    SMA_Diff, RSI14, BB_Width, ATR14, egarch_vol,
    SMA20, SMA50
  ) %>%
  drop_na() %>%
  arrange(symbol, date)

df_nested_crypto <- df_crypto_long %>%
  group_by(symbol) %>%
  nest()

df_results_crypto_combined <- df_nested_crypto %>%
  mutate(
    model_results_mlp = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo MLP (V5) para: %s <<<\n", .x))
      train_regime_model_v5(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE 
      )
    }),
    
    model_results_lstm = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo LSTM para: %s <<<\n", .x)) 
      train_lstm_model(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE, 
        seq_length = 20,    
        hidden_size = 64,   
        num_layers = 2      
      )
    })
  )

summary_crypto_mlp <- df_results_crypto_combined %>%
  select(symbol, model_results_mlp) %>%
  mutate(
    test_accuracy = map_dbl(model_results_mlp, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_mlp, ~.x$val_accuracy)
  ) %>%
  select(-model_results_mlp) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "MLP")

print(summary_crypto_mlp)

summary_crypto_lstm <- df_results_crypto_combined %>%
  select(symbol, model_results_lstm) %>%
  mutate(
    test_accuracy = map_dbl(model_results_lstm, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_lstm, ~.x$val_accuracy)
  ) %>%
  select(-model_results_lstm) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "LSTM")

print(summary_crypto_lstm)

summary_crypto_all <- bind_rows(summary_crypto_mlp, summary_crypto_lstm)

summary_crypto_all %>%
  pivot_longer(cols = c(test_accuracy, val_accuracy), 
               names_to = "metric", 
               values_to = "accuracy") %>%
  mutate(metric = ifelse(metric == "test_accuracy", "Teste", "Validação")) %>%
  ggplot(aes(x = reorder(symbol, accuracy), y = accuracy, fill = metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "red", alpha = 0.5) +
  annotate("text", x = 1, y = 0.35, label = "Baseline (33%)", 
           color = "red", size = 3) +
  coord_flip() +
  scale_fill_manual(values = c("Teste" = "#006BA2", "Validação" = "#3EBCD2")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  theme_econ_base() + 
  labs(
    title = "Acurácia dos Modelos de Regime - Criptomoedas",
    subtitle = "Comparação entre MLP e LSTM",
    x = "Ativo",
    y = "Acurácia",
    fill = "Conjunto"
  ) +
  facet_wrap(~ model_type)

df_signals_crypto_mlp <- df_results_crypto_combined %>% 
  select(symbol, model_results_mlp) %>%
  mutate(
    date = map(model_results_mlp, ~.x$date),
    predicted_regime = map(model_results_mlp, ~.x$predicted_regime)
  ) %>%
  select(-model_results_mlp) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_MLP = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_MLP) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_MLP,
    names_prefix = "weight_MLP_" 
  )

df_signals_crypto_lstm <- df_results_crypto_combined %>% 
  select(symbol, model_results_lstm) %>%
  mutate(
    date = map(model_results_lstm, ~.x$date),
    predicted_regime = map(model_results_lstm, ~.x$predicted_regime)
  ) %>%
  select(-model_results_lstm) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_LSTM = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_LSTM) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_LSTM,
    names_prefix = "weight_LSTM_" 
  )

df_crypto <- df_crypto %>%
  left_join(df_signals_crypto_mlp, by = "date") %>%
  left_join(df_signals_crypto_lstm, by = "date") %>%
  mutate(across(starts_with("weight_MLP_") | starts_with("weight_LSTM_"), ~replace_na(.x, 0)))

rm(df_crypto_long, df_nested_crypto,
   summary_crypto_mlp, summary_crypto_lstm,
   df_signals_crypto_mlp, df_signals_crypto_lstm)


## ETF ----

df_etf_long <- df_etf %>%
  pivot_longer(
    cols = -date,
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)"  
  ) %>%
  filter(symbol %in% tickers_etf) %>% 
  select(
    date, symbol,
    open, high, low, close, volume, adjusted,
    retorno_adjusted, 
    SMA_Diff, RSI14, BB_Width, ATR14, egarch_vol,
    SMA20, SMA50
  ) %>%
  drop_na() %>%
  arrange(symbol, date)

df_nested_etf <- df_etf_long %>%
  group_by(symbol) %>%
  nest()

df_results_etf_combined <- df_nested_etf %>%
  mutate(
    model_results_mlp = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo MLP (V5) para: %s <<<\n", .x))
      train_regime_model_v5(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE 
      )
    }),
    
    model_results_lstm = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo LSTM para: %s <<<\n", .x)) 
      train_lstm_model(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE, 
        seq_length = 20,    
        hidden_size = 64,   
        num_layers = 2      
      )
    })
  )

summary_etf_mlp <- df_results_etf_combined %>%
  select(symbol, model_results_mlp) %>%
  mutate(
    test_accuracy = map_dbl(model_results_mlp, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_mlp, ~.x$val_accuracy)
  ) %>%
  select(-model_results_mlp) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "MLP")

print(summary_etf_mlp)

summary_etf_lstm <- df_results_etf_combined %>%
  select(symbol, model_results_lstm) %>%
  mutate(
    test_accuracy = map_dbl(model_results_lstm, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_lstm, ~.x$val_accuracy)
  ) %>%
  select(-model_results_lstm) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "LSTM")

print(summary_etf_lstm)

summary_etf_all <- bind_rows(summary_etf_mlp, summary_etf_lstm)

summary_etf_all %>%
  pivot_longer(cols = c(test_accuracy, val_accuracy), 
               names_to = "metric", 
               values_to = "accuracy") %>%
  mutate(metric = ifelse(metric == "test_accuracy", "Teste", "Validação")) %>%
  ggplot(aes(x = reorder(symbol, accuracy), y = accuracy, fill = metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "red", alpha = 0.5) +
  annotate("text", x = 1, y = 0.35, label = "Baseline (33%)", 
           color = "red", size = 3) +
  coord_flip() +
  scale_fill_manual(values = c("Teste" = "#006BA2", "Validação" = "#3EBCD2")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  theme_econ_base() + 
  labs(
    title = "Acurácia dos Modelos de Regime - ETFs",
    subtitle = "Comparação entre MLP e LSTM",
    x = "Ativo",
    y = "Acurácia",
    fill = "Conjunto"
  ) +
  facet_wrap(~ model_type)

df_signals_etf_mlp <- df_results_etf_combined %>% 
  select(symbol, model_results_mlp) %>%
  mutate(
    date = map(model_results_mlp, ~.x$date),
    predicted_regime = map(model_results_mlp, ~.x$predicted_regime)
  ) %>%
  select(-model_results_mlp) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_MLP = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_MLP) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_MLP,
    names_prefix = "weight_MLP_" 
  )

df_signals_etf_lstm <- df_results_etf_combined %>% 
  select(symbol, model_results_lstm) %>%
  mutate(
    date = map(model_results_lstm, ~.x$date),
    predicted_regime = map(model_results_lstm, ~.x$predicted_regime)
  ) %>%
  select(-model_results_lstm) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_LSTM = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_LSTM) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_LSTM,
    names_prefix = "weight_LSTM_" 
  )

df_etf <- df_etf %>%
  left_join(df_signals_etf_mlp, by = "date") %>%
  left_join(df_signals_etf_lstm, by = "date") %>%
  mutate(across(starts_with("weight_MLP_") | starts_with("weight_LSTM_"), ~replace_na(.x, 0)))

rm(df_etf_long, df_nested_etf, 
   summary_etf_mlp, summary_etf_lstm, 
   df_signals_etf_mlp, df_signals_etf_lstm)

## USA ----
df_us_long <- df_us %>%
  pivot_longer(
    cols = -date,
    names_to = c(".value", "symbol"),
    names_pattern = "(.+)_(.+)"  
  ) %>%
  filter(symbol %in% stocks_us) %>% 
  select(
    date, symbol,
    open, high, low, close, volume, adjusted,
    retorno_adjusted, 
    SMA_Diff, RSI14, BB_Width, ATR14, egarch_vol,
    SMA20, SMA50
  ) %>%
  drop_na() %>%
  arrange(symbol, date)

df_nested_us <- df_us_long %>%
  group_by(symbol) %>%
  nest()

df_results_us_combined <- df_nested_us %>%
  mutate(
    model_results_mlp = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo MLP (V5) para: %s <<<\n", .x))
      train_regime_model_v5(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE 
      )
    }),
    
    model_results_lstm = map2(symbol, data, ~ {
      cat(sprintf("\n>>> Treinando modelo LSTM para: %s <<<\n", .x)) 
      train_lstm_model(
        .y, 
        epochs = 150,           
        learning_rate = 0.0005,
        dropout_rate = 0.3,          
        look_forward = 20,      
        threshold_multiplier = 1.0,
        label_method = "percentil",  
        use_focal_loss = TRUE,         
        verbose = FALSE, 
        seq_length = 20,    
        hidden_size = 64,   
        num_layers = 2      
      )
    })
  )

summary_us_mlp <- df_results_us_combined %>%
  select(symbol, model_results_mlp) %>%
  mutate(
    test_accuracy = map_dbl(model_results_mlp, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_mlp, ~.x$val_accuracy)
  ) %>%
  select(-model_results_mlp) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "MLP")

print(summary_us_mlp)


summary_us_lstm <- df_results_us_combined %>%
  select(symbol, model_results_lstm) %>%
  mutate(
    test_accuracy = map_dbl(model_results_lstm, ~.x$test_accuracy),
    val_accuracy = map_dbl(model_results_lstm, ~.x$val_accuracy)
  ) %>%
  select(-model_results_lstm) %>%
  mutate(across(c(test_accuracy, val_accuracy), ~round(.x, 3))) %>%
  mutate(model_type = "LSTM")

print(summary_us_lstm)

summary_us_all <- bind_rows(summary_us_mlp, summary_us_lstm)

summary_us_all %>%
  pivot_longer(cols = c(test_accuracy, val_accuracy), 
               names_to = "metric", 
               values_to = "accuracy") %>%
  mutate(metric = ifelse(metric == "test_accuracy", "Teste", "Validação")) %>%
  ggplot(aes(x = reorder(symbol, accuracy), y = accuracy, fill = metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "red", alpha = 0.5) +
  annotate("text", x = 1, y = 0.35, label = "Baseline (33%)", 
           color = "red", size = 3) +
  coord_flip() +
  scale_fill_manual(values = c("Teste" = "#006BA2", "Validação" = "#3EBCD2")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  theme_econ_base() + 
  labs(
    title = "Acurácia dos Modelos de Regime - Ações USA",
    subtitle = "Comparação entre MLP e LSTM",
    x = "Ativo",
    y = "Acurácia",
    fill = "Conjunto"
  ) +
  facet_wrap(~ model_type)

df_signals_us_mlp <- df_results_us_combined %>% 
  select(symbol, model_results_mlp) %>%
  mutate(
    date = map(model_results_mlp, ~.x$date),
    predicted_regime = map(model_results_mlp, ~.x$predicted_regime)
  ) %>%
  select(-model_results_mlp) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_MLP = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_MLP) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_MLP,
    names_prefix = "weight_MLP_" 
  )

df_signals_us_lstm <- df_results_us_combined %>% 
  select(symbol, model_results_lstm) %>%
  mutate(
    date = map(model_results_lstm, ~.x$date),
    predicted_regime = map(model_results_lstm, ~.x$predicted_regime)
  ) %>%
  select(-model_results_lstm) %>%
  unnest(cols = c(date, predicted_regime)) %>%
  mutate(weight_LSTM = case_when(
    predicted_regime == "Alta" ~ 1,      
    predicted_regime == "Baixa" ~ -1,    
    TRUE ~ 0                             
  )) %>%
  select(date, symbol, weight_LSTM) %>%
  pivot_wider(
    names_from = symbol,
    values_from = weight_LSTM,
    names_prefix = "weight_LSTM_" 
  )

df_us <- df_us %>%
  left_join(df_signals_us_mlp, by = "date") %>%
  left_join(df_signals_us_lstm, by = "date") %>%
  mutate(across(starts_with("weight_MLP_") | starts_with("weight_LSTM_"), ~replace_na(.x, 0)))

rm(df_us_long, df_nested_us, 
   summary_us_mlp, summary_us_lstm,
   df_signals_us_mlp, df_signals_us_lstm)

## Estatísticas Gerais ----

summary_all_models <- bind_rows(
  summary_br_all     %>% mutate(classe = "Brasil"),
  summary_como_all   %>% mutate(classe = "Commodities"),
  summary_crypto_all %>% mutate(classe = "Cripto"),
  summary_etf_all    %>% mutate(classe = "ETF"),
  summary_us_all     %>% mutate(classe = "USA")
)

summary_all_models %>%
  ggplot(aes(x = classe, y = test_accuracy, fill = classe)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.5, size = 2) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "red") +
  annotate("text", x = 1, y = 0.35, label = "Baseline (33%)", 
           color = "red", size = 3) +
  scale_fill_manual(
    values = c(
      "Brasil" = "#006BA2",
      "USA" = "#3EBCD2",
      "ETF" = "#E6B83C",
      "Cripto" = "#A63D57",
      "Commodities" = "#008080"
    )
  ) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  theme_econ_base() +
  theme(legend.position = "none") +
  labs(
    title = "Performance Geral dos Modelos por Classe de Ativo",
    subtitle = "Distribuição de acurácias no conjunto de teste (MLP vs LSTM)",
    x = "Classe de Ativo",
    y = "Acurácia (Teste)"
  ) +
  facet_wrap(~ model_type)

summary_all_models %>%
  group_by(classe, model_type) %>% 
  summarise(
    n_ativos = n(),
    media_accuracy = mean(test_accuracy),
    mediana_accuracy = median(test_accuracy),
    min_accuracy = min(test_accuracy),
    max_accuracy = max(test_accuracy),
    .groups = "drop" 
  ) %>%
  mutate(across(where(is.numeric) & !n_ativos, ~round(.x, 3))) %>%
  print()

rm(summary_br_all, summary_como_all, summary_crypto_all, 
   summary_etf_all, summary_us_all, summary_all_models)

# ----

# Criação de Carteiras

## Ativos Nacionais ----
df_na <- df_br %>% 
  left_join(
    df_etf %>% select(date, ends_with("_BOVA11.SA")),
    by = "date"
  )

ret_na <- df_na %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  rename_with(
    ~ str_remove(., "retorno_adjusted_"), 
    .cols = starts_with("retorno_adjusted_")
  ) %>%
  na.omit() %>%
  xts(x = .[, -1], order.by = .$date)

cdi_data <- rbcb::get_series(
  code       = 12,
  start_date = (format(ymd("2016-01-01"), "%Y-%m-%d")) ,
  end_date   = (format(end_date, "%Y-%m-%d")),
  as         = "tibble"
) %>%
  rename(date = date, CDI = '12')

rf_na <- cdi_data %>%
  mutate(retorno_rf_brl = CDI/100) %>%
  select(date, retorno_rf_brl) %>%
  na.omit() %>%
  xts(x = .[, -1], order.by = .$date)

## Ativos Internacionais ----

df_int <- df_us %>% 
  left_join(df_crypto, by = "date") %>%
  left_join(df_como, by = "date") %>%
  left_join(
    df_etf %>% select(date, !ends_with("_BOVA11.SA")),
    by = "date"
  )

ret_int <- df_int %>%
  select(date, starts_with("retorno_adjusted_")) %>%
  rename_with(
    ~ str_remove(., "retorno_adjusted_"), 
    .cols = starts_with("retorno_adjusted_")
  ) %>%
  na.omit() %>%
  xts(x = .[, -1], order.by = .$date)

treasury_data <- tq_get(x = "DGS1MO", 
                        get = "economic.data",
                        start_date = start_date,
                        end_date = end_date) %>% 
  select(date, price) %>% 
  rename(date = date,
         treasury = price)

rf_int <- treasury_data %>%
  fill(treasury, .direction = "down") %>% 
  mutate(retorno_rf_usd = (1 + (treasury / 100))^(1/252) - 1) %>%
  select(date, retorno_rf_usd) %>%
  na.omit() %>%
  xts(x = .[, -1], order.by = .$date)

## Função das Carteiras ----

gmv_portfolio_fun <- function(dataset, w_current = NULL) {
  
  tryCatch({
    returns_matrix_full <- dataset$X
    all_cols <- colnames(returns_matrix_full)
    
    rf_col_name <- NULL
    if ("retorno_rf_brl" %in% all_cols) {
      rf_col_name <- "retorno_rf_brl"
    } else if ("retorno_rf_usd" %in% all_cols) {
      rf_col_name <- "retorno_rf_usd"
    }
    
    if (!is.null(rf_col_name)) {
      asset_cols <- all_cols[all_cols != rf_col_name]
      returns_matrix <- returns_matrix_full[, asset_cols, drop = FALSE]
    } else {
      returns_matrix <- returns_matrix_full
      asset_cols <- all_cols
    }
    
    Sigma <- cov(returns_matrix, use = "pairwise.complete.obs")
    
    Sigma <- Sigma + diag(1e-8, ncol(Sigma))
    
    Sigma_inv <- solve(Sigma)
    ones <- rep(1, ncol(Sigma_inv))
    weights <- Sigma_inv %*% ones
    weights <- weights / as.numeric(t(ones) %*% weights)
    weights <- as.vector(weights)
    
    if (!is.null(rf_col_name)) {
      full_weights <- numeric(length(all_cols))
      names(full_weights) <- all_cols
      full_weights[asset_cols] <- weights
      full_weights[rf_col_name] <- 0
      return(full_weights)
    } else {
      return(setNames(weights, colnames(returns_matrix)))
    }
    
  }, error = function(e) {
    all_cols <- colnames(dataset$X)
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    
    asset_cols <- all_cols[!all_cols %in% c("retorno_rf_brl", "retorno_rf_usd")]
    N <- length(asset_cols)
    
    if (N > 0) {
      full_weights[asset_cols] <- 1/N
    }
    
    return(full_weights)
  })
}

msr_long_only_fun <- function(dataset, w_current = NULL) {
  
  tryCatch({
    returns_matrix_full <- dataset$X
    all_cols <- colnames(returns_matrix_full)
    
    rf_col_name <- NULL
    if ("retorno_rf_brl" %in% all_cols) {
      rf_col_name <- "retorno_rf_brl"
    } else if ("retorno_rf_usd" %in% all_cols) {
      rf_col_name <- "retorno_rf_usd"
    } else {
      return(gmv_portfolio_fun(dataset, w_current))
    }
    
    asset_cols <- all_cols[all_cols != rf_col_name]
    asset_returns <- returns_matrix_full[, asset_cols, drop = FALSE]
    rf_returns <- as.numeric(returns_matrix_full[, rf_col_name])
    
    rf_rate_mean <- mean(rf_returns, na.rm = TRUE)
    Sigma <- cov(asset_returns, use = "pairwise.complete.obs")
    mu <- colMeans(asset_returns, na.rm = TRUE)
    mu_excess <- mu - rf_rate_mean
    
    N <- ncol(asset_returns)
    
    Sigma <- Sigma + diag(1e-8, N)
    
    if (all(mu_excess <= 0)) {
      Dmat <- 2 * Sigma
      dvec <- rep(0, N)
      Amat <- cbind(rep(1, N), diag(N))
      bvec <- c(1, rep(0, N))
      
      opt_result <- tryCatch({
        solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec, meq = 1)
      }, error = function(e) {
        list(solution = rep(1/N, N))
      })
      weights <- opt_result$solution
      
    } else {
      Dmat <- 2 * Sigma
      dvec <- rep(0, N)
      Amat <- cbind(mu_excess, diag(N))
      bvec <- c(1, rep(0, N))
      
      opt_result <- tryCatch({
        solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec, meq = 1)
      }, error = function(e) {
        list(solution = rep(1/N, N))
      })
      
      y <- opt_result$solution
      weights <- y / sum(y)
    }
    
    weights[weights < 0] <- 0
    if (sum(weights) == 0) {
      weights <- rep(1/N, N)
    } else {
      weights <- weights / sum(weights)
    }
    
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    full_weights[asset_cols] <- weights
    full_weights[rf_col_name] <- 0
    
    return(full_weights)
    
  }, error = function(e) {
    all_cols <- colnames(dataset$X)
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    
    asset_cols <- all_cols[!all_cols %in% c("retorno_rf_brl", "retorno_rf_usd")]
    N <- length(asset_cols)
    
    if (N > 0) {
      full_weights[asset_cols] <- 1/N
    }
    
    return(full_weights)
  })
}

## Funções de Carteiras com Limite de Renda Fixa ----

gmv_portfolio_with_rf_limit <- function(dataset, w_current = NULL, max_rf_weight = 0.30) {
  
  tryCatch({
    returns_matrix_full <- dataset$X
    all_cols <- colnames(returns_matrix_full)
    
    rf_col_name <- NULL
    if ("retorno_rf_brl" %in% all_cols) {
      rf_col_name <- "retorno_rf_brl"
    } else if ("retorno_rf_usd" %in% all_cols) {
      rf_col_name <- "retorno_rf_usd"
    }
    
    if (is.null(rf_col_name)) {
      return(gmv_portfolio_fun(dataset, w_current))
    }
    
    asset_cols <- all_cols[all_cols != rf_col_name]
    returns_matrix <- returns_matrix_full[, asset_cols, drop = FALSE]
    
    N <- ncol(returns_matrix)
    
    Sigma <- cov(returns_matrix, use = "pairwise.complete.obs")
    Sigma <- Sigma + diag(1e-8, ncol(Sigma))
    
    
    Dmat <- 2 * Sigma
    dvec <- rep(0, N)
    
    Amat <- cbind(
      rep(1, N),      
      rep(-1, N),     
      diag(N)         
    )
    
    bvec <- c(
      1 - max_rf_weight,  
      -1,                 
      rep(0, N)           
    )
    
    opt_result <- tryCatch({
      solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec, meq = 0)
    }, error = function(e) {
      Sigma_inv <- solve(Sigma)
      ones <- rep(1, N)
      weights <- Sigma_inv %*% ones
      weights <- as.vector(weights / sum(weights))
      list(solution = weights)
    })
    
    weights_assets <- opt_result$solution
    
    sum_assets <- sum(weights_assets)
    if (sum_assets > 1) {
      weights_assets <- weights_assets / sum_assets
      sum_assets <- 1
    }
    
    weight_rf <- 1 - sum_assets
    
    if (weight_rf > max_rf_weight) {
      weight_rf <- max_rf_weight
      weights_assets <- weights_assets * (1 - max_rf_weight) / sum_assets
    }
    
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    full_weights[asset_cols] <- weights_assets
    full_weights[rf_col_name] <- weight_rf
    
    return(full_weights)
    
  }, error = function(e) {
    all_cols <- colnames(dataset$X)
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    
    asset_cols <- all_cols[!all_cols %in% c("retorno_rf_brl", "retorno_rf_usd")]
    N <- length(asset_cols)
    
    if (N > 0) {
      full_weights[asset_cols] <- 1/N
    }
    
    return(full_weights)
  })
}


msr_with_rf_limit <- function(dataset, w_current = NULL, max_rf_weight = 0.30) {
  
  tryCatch({
    returns_matrix_full <- dataset$X
    all_cols <- colnames(returns_matrix_full)
    
    rf_col_name <- NULL
    if ("retorno_rf_brl" %in% all_cols) {
      rf_col_name <- "retorno_rf_brl"
    } else if ("retorno_rf_usd" %in% all_cols) {
      rf_col_name <- "retorno_rf_usd"
    } else {
      return(gmv_portfolio_fun(dataset, w_current))
    }
    
    asset_cols <- all_cols[all_cols != rf_col_name]
    asset_returns <- returns_matrix_full[, asset_cols, drop = FALSE]
    rf_returns <- as.numeric(returns_matrix_full[, rf_col_name])
    
    rf_rate_mean <- mean(rf_returns, na.rm = TRUE)
    Sigma <- cov(asset_returns, use = "pairwise.complete.obs")
    mu <- colMeans(asset_returns, na.rm = TRUE)
    mu_excess <- mu - rf_rate_mean
    
    N <- ncol(asset_returns)
    Sigma <- Sigma + diag(1e-8, N)
    
    if (all(mu_excess <= 0)) {
      return(gmv_portfolio_with_rf_limit(dataset, w_current, max_rf_weight))
    }
    
    
    Dmat <- 2 * Sigma
    dvec <- rep(0, N)
    
    
    
    Amat <- cbind(
      mu_excess,      
      rep(1, N),      
      rep(-1, N),     
      diag(N)         
    )
    
    bvec <- c(
      1,                     
      1 - max_rf_weight,     
      -1,                    
      rep(0, N)              
    )
    
    opt_result <- tryCatch({
      solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec, meq = 1)
    }, error = function(e) {
      return(NULL)
    })
    
    if (is.null(opt_result)) {
      return(gmv_portfolio_with_rf_limit(dataset, w_current, max_rf_weight))
    }
    
    y <- opt_result$solution
    
    weights_assets <- y / sum(y)
    
    weights_assets[weights_assets < 1e-6] <- 0
    weights_assets <- weights_assets / sum(weights_assets)
    
    sum_assets <- sum(weights_assets)
    if (sum_assets > 1) {
      weights_assets <- weights_assets / sum_assets
      sum_assets <- 1
    }
    
    weight_rf <- 1 - sum_assets
    
    if (weight_rf > max_rf_weight) {
      weight_rf <- max_rf_weight
      weights_assets <- weights_assets * (1 - max_rf_weight) / sum_assets
    }
    
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    full_weights[asset_cols] <- weights_assets
    full_weights[rf_col_name] <- weight_rf
    
    return(full_weights)
    
  }, error = function(e) {
    all_cols <- colnames(dataset$X)
    full_weights <- numeric(length(all_cols))
    names(full_weights) <- all_cols
    
    asset_cols <- all_cols[!all_cols %in% c("retorno_rf_brl", "retorno_rf_usd")]
    N <- length(asset_cols)
    
    if (N > 0) {
      full_weights[asset_cols] <- 1/N
    }
    
    return(full_weights)
  })
}

backtest_portfolio_manual <- function(returns_data, 
                                      portfolio_fun = msr_with_rf_limit,
                                      lookback = 126, 
                                      rebalance_every = 21,
                                      portfolio_name = "Portfolio",
                                      max_rf_weight = 0.30,
                                      include_rf_in_return = TRUE) {  
  
  rf_col <- NULL
  if ("retorno_rf_brl" %in% colnames(returns_data)) {
    rf_col <- "retorno_rf_brl"
  } else if ("retorno_rf_usd" %in% colnames(returns_data)) {
    rf_col <- "retorno_rf_usd"
  }
  
  all_cols <- colnames(returns_data)
  asset_cols <- if (!is.null(rf_col)) setdiff(all_cols, rf_col) else all_cols
  
  n_periods <- nrow(returns_data)
  portfolio_returns <- c()
  dates <- c()
  weights_history <- list()
  
  rebalance_count <- 0
  current_weights <- NULL
  
  for (t in (lookback + 1):n_periods) {
    
    if ((t - lookback - 1) %% rebalance_every == 0) {
      hist_data <- returns_data[(t - lookback):(t - 1), ]
      
      if (deparse(substitute(portfolio_fun)) %in% c("gmv_portfolio_with_rf_limit", "msr_with_rf_limit")) {
        weights_full <- portfolio_fun(list(X = hist_data), max_rf_weight = max_rf_weight)
      } else {
        weights_full <- portfolio_fun(list(X = hist_data))
      }
      
      current_weights <- weights_full
      
      rebalance_count <- rebalance_count + 1
      weights_history[[rebalance_count]] <- list(
        date = index(returns_data)[t],
        weights = current_weights
      )
    }
    
    if (!is.null(current_weights)) {
      period_returns <- as.numeric(returns_data[t, ])
      names(period_returns) <- colnames(returns_data)
      
      portfolio_return <- sum(current_weights * period_returns)
      
      portfolio_returns <- c(portfolio_returns, portfolio_return)
      dates <- c(dates, index(returns_data)[t])
    }
  }
  
  portfolio_returns_xts <- xts(portfolio_returns, order.by = as.Date(dates))
  
  if (!is.null(rf_col)) {
    rf_returns <- returns_data[(lookback + 1):n_periods, rf_col]
    excess_returns <- portfolio_returns_xts - rf_returns
    sharpe <- mean(excess_returns) / sd(excess_returns) * sqrt(252)
  } else {
    sharpe <- mean(portfolio_returns) / sd(portfolio_returns) * sqrt(252)
  }
  
  annual_return <- mean(portfolio_returns) * 252
  annual_vol <- sd(portfolio_returns) * sqrt(252)
  
  wealth <- cumprod(1 + portfolio_returns_xts)
  running_max <- cummax(wealth)
  drawdown <- (wealth - running_max) / running_max
  max_dd <- min(drawdown)
  
  if (!is.null(rf_col)) {
    rf_weights <- sapply(weights_history, function(x) x$weights[rf_col])
    avg_rf_weight <- mean(rf_weights, na.rm = TRUE)
  } else {
    avg_rf_weight <- 0
  }
  
  results <- list(
    returns = portfolio_returns_xts,
    wealth = wealth,
    drawdown = drawdown,
    weights_history = weights_history,
    metrics = data.frame(
      Portfolio = portfolio_name,
      Annual_Return = annual_return,
      Annual_Volatility = annual_vol,
      Sharpe_Ratio = as.numeric(sharpe),
      Max_Drawdown = max_dd,
      Total_Return = as.numeric(tail(wealth, 1)) - 1,
      Avg_RF_Weight = avg_rf_weight,  
      Max_RF_Limit = max_rf_weight,   
      N_Rebalances = rebalance_count
    )
  )
  
  return(results)
}

## Funções de Carteiras Inteligentes ----

backtest_portfolio_com_modelo <- function(returns_data,
                                          modelo_regime,
                                          portfolio_fun = msr_long_only_fun,
                                          lookback = 126,
                                          rebalance_fixed_days = 14,
                                          use_regime_trigger = TRUE,
                                          portfolio_name = "Portfolio com Modelo",
                                          max_rf_weight = 0.30) {
  cat(
    sprintf(
      "\n=== BACKTEST COM REBALANCEAMENTO INTELIGENTE (%s) ===\n",
      portfolio_name
    )
  )
  
  model_type <- modelo_regime$model_name
  if (is.null(model_type))
    stop("O 'modelo_regime' não tem um 'model_name' (MLP ou LSTM).")
  
  cat(sprintf(
    "Modelo: %s | Acurácia: %.3f\n",
    model_type,
    modelo_regime$test_accuracy
  ))
  cat(
    sprintf(
      "Rebalanceamento fixo: a cada %d dias | Trigger de regime: %s\n",
      rebalance_fixed_days,
      use_regime_trigger
    )
  )
  
  pred_fun <- NULL
  seq_length <- NULL
  
  if (model_type == "LSTM_Regime_Model") {
    pred_fun <- predict_regime_lstm
    seq_length <- modelo_regime$hyperparams$seq_length
    if (is.null(seq_length))
      stop("Modelo LSTM sem 'hyperparams$seq_length'.")
  } else if (model_type == "RegimeClassifierV5_Optimized") {
    pred_fun <- predict_regime_mlp
  } else {
    stop(sprintf("Tipo de modelo '%s' não reconhecido.", model_type))
  }
  
  fun_name <- deparse(substitute(portfolio_fun))
  accepts_rf_limit <- fun_name %in% c("gmv_portfolio_with_rf_limit", "msr_with_rf_limit")
  
  if (accepts_rf_limit) {
    cat(sprintf(
      "Função de Portfólio: %s (Max RF: %.1f%%)\n",
      fun_name,
      max_rf_weight * 100
    ))
  } else {
    cat(sprintf("Função de Portfólio: %s (Sem alocação de RF)\n", fun_name))
  }
  
  rf_col <- NULL
  if ("retorno_rf_brl" %in% colnames(returns_data)) {
    rf_col <- "retorno_rf_brl"
  } else if ("retorno_rf_usd" %in% colnames(returns_data)) {
    rf_col <- "retorno_rf_usd"
  }
  
  all_cols <- colnames(returns_data)
  n_periods <- nrow(returns_data)
  portfolio_returns <- c()
  dates <- c()
  weights_history <- list()
  regime_history <- c()
  
  rebalance_count <- 0
  regime_rebalance_count <- 0
  fixed_rebalance_count <- 0
  
  current_weights <- NULL
  last_regime <- NULL
  days_since_rebalance <- 0
  
  start_index <- lookback + 1
  
  for (t in start_index:n_periods) {
    days_since_rebalance <- days_since_rebalance + 1
    should_rebalance <- FALSE
    rebalance_reason <- ""
    
    if (use_regime_trigger) {
      hist_data_regime_features <- returns_data[(t - lookback):(t - 1), ]
      
      current_regime <- tryCatch({
        if (model_type == "LSTM_Regime_Model") {
          predict_regime_lstm(
            hist_data_regime_features,
            modelo_regime$trained_model,
            modelo_regime$scaler,
            modelo_regime$features_used,
            seq_length = seq_length
          )
        } else {
          predict_regime_mlp(
            hist_data_regime_features,
            modelo_regime$trained_model,
            modelo_regime$scaler,
            modelo_regime$features_used
          )
        }
      }, error = function(e) {
        if (is.null(last_regime))
          NA_character_
        else
          last_regime
      })
      
      regime_history <- c(regime_history, current_regime)
      
      if (!is.na(current_regime) &&
          !is.null(last_regime) && current_regime != last_regime) {
        should_rebalance <- TRUE
        rebalance_reason <- glue::glue("Mudança de regime: {last_regime} → {current_regime}")
        regime_rebalance_count <- regime_rebalance_count + 1
      }
      
      if (!is.na(current_regime)) {
        last_regime <- current_regime
      }
    }
    
    if (days_since_rebalance >= rebalance_fixed_days) {
      should_rebalance <- TRUE
      if (rebalance_reason == "") {
        rebalance_reason <- glue::glue("Rebalanceamento fixo ({rebalance_fixed_days} dias)")
        fixed_rebalance_count <- fixed_rebalance_count + 1
      }
    }
    
    if (should_rebalance) {
      hist_data_portfolio <- returns_data[(t - lookback):(t - 1), ]
      
      if (accepts_rf_limit) {
        weights_full <- portfolio_fun(list(X = hist_data_portfolio), max_rf_weight = max_rf_weight)
      } else {
        weights_full <- portfolio_fun(list(X = hist_data_portfolio))
      }
      
      current_weights <- weights_full
      
      rebalance_count <- rebalance_count + 1
      weights_history[[rebalance_count]] <- list(
        date = index(returns_data)[t],
        weights = current_weights,
        reason = rebalance_reason,
        days_since_last = days_since_rebalance
      )
      
      days_since_rebalance <- 0
    }
    
    if (!is.null(current_weights)) {
      period_returns <- as.numeric(returns_data[t, ])
      names(period_returns) <- colnames(returns_data)
      
      portfolio_return <- sum(current_weights * period_returns, na.rm = TRUE)
      
      portfolio_returns <- c(portfolio_returns, portfolio_return)
      dates <- c(dates, index(returns_data)[t])
    }
  } 
  
  portfolio_returns_xts <- xts(portfolio_returns, order.by = as.Date(dates))
  
  if (!is.null(rf_col) && length(dates) > 0) {
    dates_aligned <- as.Date(dates)
    all_dates <- index(returns_data)
    indices <- which(all_dates %in% dates_aligned)
    
    rf_returns_aligned <- as.numeric(returns_data[indices, rf_col])
    rf_returns_aligned_xts <- xts(rf_returns_aligned, order.by = dates_aligned)
    
    excess_returns <- portfolio_returns_xts - rf_returns_aligned_xts
    sharpe <- mean(excess_returns, na.rm = TRUE) / sd(excess_returns, na.rm = TRUE) * sqrt(252)
  } else {
    sharpe <- mean(portfolio_returns, na.rm = TRUE) / sd(portfolio_returns, na.rm = TRUE) * sqrt(252)
  }
  
  annual_return <- mean(portfolio_returns, na.rm = TRUE) * 252
  annual_vol <- sd(portfolio_returns, na.rm = TRUE) * sqrt(252)
  
  wealth <- cumprod(1 + portfolio_returns_xts)
  running_max <- cummax(wealth)
  drawdown <- (wealth - running_max) / running_max
  max_dd <- min(drawdown, 0, na.rm = TRUE)
  
  if (!is.null(rf_col) && length(weights_history) > 0) {
    rf_weights <- sapply(weights_history, function(x)
      x$weights[rf_col])
    avg_rf_weight <- mean(rf_weights, na.rm = TRUE)
  } else {
    avg_rf_weight <- 0
  }
  
  cat("\n=== ESTATÍSTICAS DE REBALANCEAMENTO ===\n")
  cat(sprintf("Total de rebalanceamentos: %d\n", rebalance_count))
  if (rebalance_count > 0) {
    cat(
      sprintf(
        "  - Por regime: %d (%.1f%%)\n",
        regime_rebalance_count,
        regime_rebalance_count / rebalance_count * 100
      )
    )
    cat(
      sprintf(
        "  - Fixos: %d (%.1f%%)\n\n",
        fixed_rebalance_count,
        fixed_rebalance_count / rebalance_count * 100
      )
    )
  }
  
  results <- list(
    returns = portfolio_returns_xts,
    wealth = wealth,
    drawdown = drawdown,
    weights_history = weights_history,
    regime_history = regime_history,
    metrics = data.frame(
      Portfolio = portfolio_name,
      Model_Accuracy = modelo_regime$test_accuracy,
      Annual_Return = annual_return,
      Annual_Volatility = annual_vol,
      Sharpe_Ratio = as.numeric(sharpe),
      Max_Drawdown = max_dd,
      Total_Return = as.numeric(tail(wealth, 1)) - 1,
      Avg_RF_Weight = avg_rf_weight,
      N_Rebalances = rebalance_count,
      N_Regime_Rebalances = regime_rebalance_count,
      N_Fixed_Rebalances = fixed_rebalance_count
    )
  )
  
  return(results)
}


predict_regime_mlp <- function(current_data,
                               modelo_treinado,
                               scaler,
                               features_used) {
  df_features <- add_enhanced_features(current_data) %>%
    tail(1) %>%
    select(all_of(features_used))
  
  df_scaled <- predict(scaler, df_features)
  
  x_tensor <- torch_tensor(as.matrix(df_scaled), dtype = torch_float())
  
  modelo_treinado$eval()
  with_no_grad({
    logits <- modelo_treinado(x_tensor)
    pred_class <- as.integer(torch_argmax(logits, dim = 2))
  })
  
  regime <- factor(
    pred_class,
    levels = 1:3,
    labels = c("Baixa", "Laterizacao", "Alta")
  )
  
  return(as.character(regime))
}

predict_regime_lstm <- function(current_data,
                                modelo_treinado,
                                scaler,
                                features_used,
                                seq_length) {
  
  df_features_raw <- add_enhanced_features(current_data)
  
  df_features <- df_features_raw %>%
    tail(seq_length) 
  
  if (nrow(df_features) < seq_length) {
    return(NA_character_)
  }
  
  df_scaled <- predict(scaler, df_features[, features_used])
  
  x_tensor <- torch_tensor(as.matrix(df_scaled), dtype = torch_float())$unsqueeze(1)
  
  modelo_treinado$eval() 
  with_no_grad({
    x_tensor <- x_tensor$to(device = "cpu") 
    logits <- modelo_treinado(x_tensor)
    pred_class <- as.integer(torch_argmax(logits$cpu(), dim = 2))
  })
  
  regime <- factor(
    pred_class,
    levels = 1:3,
    labels = c("Baixa", "Laterizacao", "Alta")
  )
  
  return(as.character(regime))
}


## Carteira Nacional ----

wallet_na <- merge.xts(ret_na, rf_na) %>% na.omit()

results_msr_nacional <- backtest_portfolio_manual(
  wallet_na,
  portfolio_fun = msr_long_only_fun,
  lookback = 126,
  rebalance_every = 14,
  portfolio_name = "MSR Nacional (sem RF)",
  max_rf_weight = 0,
  include_rf_in_return = FALSE
)

results_gmv_nacional <- backtest_portfolio_manual(
  wallet_na,
  portfolio_fun = gmv_portfolio_fun,
  lookback = 126,
  rebalance_every = 28,
  portfolio_name = "GMV Nacional (sem RF)",
  max_rf_weight = 0,
  include_rf_in_return = FALSE
)

results_msr_rf_nacional <- backtest_portfolio_manual(
  wallet_na,
  portfolio_fun = msr_with_rf_limit,
  lookback = 126,
  rebalance_every = 14,
  portfolio_name = "MSR Nacional (RF≤30%)",
  max_rf_weight = 0.30,
  include_rf_in_return = TRUE
)

results_gmv_rf_nacional <- backtest_portfolio_manual(
  wallet_na,
  portfolio_fun = gmv_portfolio_with_rf_limit,
  lookback = 126,
  rebalance_every = 28,
  portfolio_name = "GMV Nacional (RF≤30%)",
  max_rf_weight = 0.30,
  include_rf_in_return = TRUE
)

results_pool_br <- df_results_br_combined %>%
  select(symbol, model_results_mlp, model_results_lstm)

results_pool_bova <- df_results_etf_combined %>%
  filter(symbol == "BOVA11.SA") %>%
  select(symbol, model_results_mlp, model_results_lstm)

all_results_na_combined <- bind_rows(results_pool_br, results_pool_bova)

best_lstm_na <- all_results_na_combined %>%
  select(symbol, model_results_lstm) %>%
  filter(!sapply(model_results_lstm, is.null)) %>%
  mutate(accuracy = map_dbl(model_results_lstm, ~ .x$test_accuracy)) %>%
  arrange(desc(accuracy)) %>%
  slice(1)

modelo_nacional_lstm <- best_lstm_na$model_results_lstm[[1]]
cat(
  sprintf(
    "\n→ Usando modelo LSTM Nacional de %s (Acurácia: %.1f%%)\n",
    best_lstm_na$symbol,
    modelo_nacional_lstm$test_accuracy * 100
  )
)

best_mlp_na <- all_results_na_combined %>%
  select(symbol, model_results_mlp) %>%
  filter(!sapply(model_results_mlp, is.null)) %>%
  mutate(accuracy = map_dbl(model_results_mlp, ~ .x$test_accuracy)) %>%
  arrange(desc(accuracy)) %>%
  slice(1)

modelo_nacional_mlp <- best_mlp_na$model_results_mlp[[1]]
cat(
  sprintf(
    "\n→ Usando modelo MLP Nacional de %s (Acurácia: %.1f%%)\n",
    best_mlp_na$symbol,
    modelo_nacional_mlp$test_accuracy * 100
  )
)

results_modelo_msr_lstm_na <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_lstm,
  portfolio_fun = msr_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + LSTM (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_gmv_lstm_na <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_lstm,
  portfolio_fun = gmv_portfolio_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + LSTM (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_msr_mlp_na <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_mlp,
  portfolio_fun = msr_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + MLP (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_gmv_mlp_na <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_mlp,
  portfolio_fun = gmv_portfolio_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + MLP (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_msr_lstm_na_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_lstm,
  portfolio_fun = msr_long_only_fun,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + LSTM (sem RF)",
  max_rf_weight = 0
)

results_modelo_gmv_lstm_na_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_lstm,
  portfolio_fun = gmv_portfolio_fun,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + LSTM (sem RF)",
  max_rf_weight = 0
)

results_modelo_msr_mlp_na_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_mlp,
  portfolio_fun = msr_long_only_fun,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + MLP (sem RF)",
  max_rf_weight = 0
)

results_modelo_gmv_mlp_na_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_na,
  modelo_regime = modelo_nacional_mlp,
  portfolio_fun = gmv_portfolio_fun,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + MLP (sem RF)",
  max_rf_weight = 0
)



padronizar_metricas <- function(metrics_df) {
  colunas_necessarias <- c("Model_Type",
                           "Model_Accuracy",
                           "N_Regime_Rebalances",
                           "N_Fixed_Rebalances")
  if (!"Model_Type" %in% colnames(metrics_df)) {
    metrics_df[["Model_Type"]] <- "Fixo"
  }
  if (!"Model_Accuracy" %in% colnames(metrics_df)) {
    metrics_df[["Model_Accuracy"]] <- NA
  }
  if (!"N_Regime_Rebalances" %in% colnames(metrics_df)) {
    metrics_df[["N_Regime_Rebalances"]] <- 0
  }
  if (!"N_Fixed_Rebalances" %in% colnames(metrics_df)) {
    metrics_df[["N_Fixed_Rebalances"]] <- metrics_df$N_Rebalances
  }
  return(metrics_df)
}

comparacao_nacional_completa <- bind_rows(
  padronizar_metricas(results_msr_nacional$metrics),
  padronizar_metricas(results_msr_rf_nacional$metrics),
  results_modelo_msr_lstm_na$metrics,
  results_modelo_msr_mlp_na$metrics,
  results_modelo_msr_lstm_na_sem_rf$metrics,
  results_modelo_msr_mlp_na_sem_rf$metrics,
  
  padronizar_metricas(results_gmv_nacional$metrics),
  padronizar_metricas(results_gmv_rf_nacional$metrics),
  results_modelo_gmv_lstm_na$metrics,
  results_modelo_gmv_mlp_na$metrics,
  results_modelo_gmv_lstm_na_sem_rf$metrics,
  results_modelo_gmv_mlp_na_sem_rf$metrics
)

print(
  comparacao_nacional_completa %>%
    select(
      Portfolio,
      Model_Type,
      Annual_Return,
      Sharpe_Ratio,
      Max_Drawdown,
      Model_Accuracy
    ) %>%
    arrange(desc(Sharpe_Ratio))
)


df_performance <- bind_rows(
  data.frame(
    date = index(results_msr_rf_nacional$wealth),
    Valor = as.numeric(results_msr_rf_nacional$wealth) * 100000,
    Estrategia = "MSR (Fixo, RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_na$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_na$wealth) * 100000,
    Estrategia = "MSR + LSTM (RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_na$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_na$wealth) * 100000,
    Estrategia = "MSR + MLP (RF≤30%)"
  ),
  data.frame(
    date = index(results_msr_nacional$wealth),
    Valor = as.numeric(results_msr_nacional$wealth) * 100000,
    Estrategia = "MSR (Fixo, sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_na_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_na_sem_rf$wealth) * 100000,
    Estrategia = "MSR + LSTM (sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_na_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_na_sem_rf$wealth) * 100000,
    Estrategia = "MSR + MLP (sem RF)"
  )
)

df_performance %>%
  ggplot(aes(
    x = date,
    y = Valor,
    color = Estrategia,
    linetype = Estrategia
  )) +
  geom_line(linewidth = 1) +
  geom_hline(
    yintercept = 100000,
    linetype = "dashed",
    color = "gray40",
    alpha = 0.5
  ) +
  scale_color_manual(
    values = c(
      "MSR (Fixo, RF≤30%)" = econ_colors_flat[["main.blue1"]],
      "MSR + LSTM (RF≤30%)" = econ_colors_flat[["main.econ_red"]],
      "MSR + MLP (RF≤30%)" = econ_colors_flat[["secondary.mustard"]],
      "MSR (Fixo, sem RF)" = econ_colors_flat[["main.blue2"]],
      "MSR + LSTM (sem RF)" = econ_colors_flat[["main.red_text"]],
      "MSR + MLP (sem RF)" = econ_colors_flat[["supporting_bright.orange"]]
    )
  ) +
  scale_linetype_manual(
    values = c(
      "MSR (Fixo, RF≤30%)" = "solid",
      "MSR + LSTM (RF≤30%)" = "solid",
      "MSR + MLP (RF≤30%)" = "solid",
      "MSR (Fixo, sem RF)" = "dashed",
      "MSR + LSTM (sem RF)" = "dashed",
      "MSR + MLP (sem RF)" = "dashed"
    )
  ) +
  scale_y_continuous(
    labels = function(x)
      paste0("R$ ", format(
        x / 1000, big.mark = ".", decimal.mark = ","
      ), "k")
  ) +
  theme_econ_base() +
  labs(
    title = "Performance: Rebalanceamento Inteligente vs Fixo (MSR Nacional)",
    subtitle = "Comparação de estratégias com e sem limite de Renda Fixa",
    x = "Data",
    y = "Valor da Carteira (R$ 100k inicial)",
    color = "Estratégia",
    linetype = "Estratégia"
  ) +
  theme(legend.position = "top")


cat(
  sprintf(
    "MSR com RF (Fixo)   | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%%\n",
    results_msr_rf_nacional$metrics$Sharpe_Ratio,
    results_msr_rf_nacional$metrics$Annual_Return * 100,
    results_msr_rf_nacional$metrics$Max_Drawdown * 100
  )
)
delta_sharpe_mlp <- results_modelo_msr_mlp_na$metrics$Sharpe_Ratio - results_msr_rf_nacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + MLP (com RF)  | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_mlp_na$metrics$Sharpe_Ratio,
    results_modelo_msr_mlp_na$metrics$Annual_Return * 100,
    results_modelo_msr_mlp_na$metrics$Max_Drawdown * 100,
    delta_sharpe_mlp
  )
)
delta_sharpe_lstm <- results_modelo_msr_lstm_na$metrics$Sharpe_Ratio - results_msr_rf_nacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + LSTM (com RF) | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_lstm_na$metrics$Sharpe_Ratio,
    results_modelo_msr_lstm_na$metrics$Annual_Return * 100,
    results_modelo_msr_lstm_na$metrics$Max_Drawdown * 100,
    delta_sharpe_lstm
  )
)

cat("\n--- Comparação SEM Limite de RF ---\n")
cat(
  sprintf(
    "MSR sem RF (Fixo)   | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%%\n",
    results_msr_nacional$metrics$Sharpe_Ratio,
    results_msr_nacional$metrics$Annual_Return * 100,
    results_msr_nacional$metrics$Max_Drawdown * 100
  )
)
delta_sharpe_mlp_sem_rf <- results_modelo_msr_mlp_na_sem_rf$metrics$Sharpe_Ratio - results_msr_nacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + MLP (sem RF)  | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_mlp_na_sem_rf$metrics$Sharpe_Ratio,
    results_modelo_msr_mlp_na_sem_rf$metrics$Annual_Return * 100,
    results_modelo_msr_mlp_na_sem_rf$metrics$Max_Drawdown * 100,
    delta_sharpe_mlp_sem_rf
  )
)
delta_sharpe_lstm_sem_rf <- results_modelo_msr_lstm_na_sem_rf$metrics$Sharpe_Ratio - results_msr_nacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + LSTM (sem RF) | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_lstm_na_sem_rf$metrics$Sharpe_Ratio,
    results_modelo_msr_lstm_na_sem_rf$metrics$Annual_Return * 100,
    results_modelo_msr_lstm_na_sem_rf$metrics$Max_Drawdown * 100,
    delta_sharpe_lstm_sem_rf
  )
)


valor_inicial <- 100000
datas_backtest <- index(results_msr_rf_nacional$wealth)
rf_wealth <- cumprod(1 + rf_na[datas_backtest]) * valor_inicial
bova_wealth <- cumprod(1 + ret_na[datas_backtest, "BOVA11.SA"]) * valor_inicial

comparacao_100k <- bind_rows(
  data.frame(
    date = index(results_msr_rf_nacional$wealth),
    Valor = as.numeric(results_msr_rf_nacional$wealth) * valor_inicial,
    Portfolio = "MSR (Fixo, RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_na$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_na$wealth) * valor_inicial,
    Portfolio = "MSR + LSTM (RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_na$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_na$wealth) * valor_inicial,
    Portfolio = "MSR + MLP (RF≤30%)"
  ),
  data.frame(
    date = index(results_msr_nacional$wealth),
    Valor = as.numeric(results_msr_nacional$wealth) * valor_inicial,
    Portfolio = "MSR (Fixo, sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_na_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_na_sem_rf$wealth) * valor_inicial,
    Portfolio = "MSR + LSTM (sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_na_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_na_sem_rf$wealth) * valor_inicial,
    Portfolio = "MSR + MLP (sem RF)"
  ),
  data.frame(
    date = index(results_gmv_nacional$wealth),
    Valor = as.numeric(results_gmv_nacional$wealth) * valor_inicial,
    Portfolio = "GMV (Fixo, sem RF)"
  ),
  data.frame(
    date = index(results_gmv_rf_nacional$wealth),
    Valor = as.numeric(results_gmv_rf_nacional$wealth) * valor_inicial,
    Portfolio = "GMV (Fixo, RF≤30%)"
  ),
  data.frame(
    date = index(rf_wealth),
    Valor = as.numeric(rf_wealth),
    Portfolio = "100% CDI (RF)"
  ),
  data.frame(
    date = index(bova_wealth),
    Valor = as.numeric(bova_wealth),
    Portfolio = "100% BOVA11"
  )
)

palette_nacional <- c(
  "MSR (Fixo, sem RF)" = econ_colors_flat[["main.red1"]],
  "MSR + LSTM (sem RF)" = econ_colors_flat[["main.econ_red"]],
  "MSR + MLP (sem RF)" = econ_colors_flat[["supporting_bright.orange"]],
  
  "MSR (Fixo, RF≤30%)" = econ_colors_flat[["main.blue1"]],
  "MSR + LSTM (RF≤30%)" = econ_colors_flat[["main.blue2_text"]],
  "MSR + MLP (RF≤30%)" = econ_colors_flat[["secondary.aqua"]],
  
  "GMV (Fixo, sem RF)" = econ_colors_flat[["secondary.mauve"]],
  "GMV + LSTM (sem RF)" = econ_colors_flat[["supporting_bright.purple"]],
  "GMV + MLP (sem RF)" = econ_colors_flat[["supporting_bright.pink"]],
  
  "GMV (Fixo, RF≤30%)" = econ_colors_flat[["secondary.teal"]],
  "GMV + LSTM (RF≤30%)" = econ_colors_flat[["supporting_dark.cyan_dk"]],
  "GMV + MLP (RF≤30%)" = econ_colors_flat[["supporting_dark.navy"]],
  
  "100% CDI (RF)" = econ_colors_flat[["secondary.mustard"]],
  "100% BOVA11" = econ_colors_flat[["secondary.burgundy"]]
)

ggplot(comparacao_100k, aes(x = date, y = Valor, color = Portfolio)) +
  geom_line(linewidth = 1) +
  geom_hline(
    yintercept = valor_inicial,
    linetype = "dashed",
    color = "gray40",
    alpha = 0.5
  ) +
  scale_color_manual(values = palette_nacional) +
  scale_y_continuous(
    labels = function(x)
      paste0("R$ ", format(
        x / 1000, big.mark = ".", decimal.mark = ","
      ), "k")
  ) +
  theme_econ_base() +
  labs(
    title = "Comparação Nacional: R$ 100.000 Investidos",
    subtitle = "Performance das carteiras (MLP vs LSTM, com/sem RF) vs benchmarks",
    x = "Data",
    y = "Valor da Carteira",
    color = "Estratégia"
  ) +
  theme(legend.position = "right",
        legend.key.size = unit(1.0, "lines"))

metricas_finais <- comparacao_100k %>%
  group_by(Portfolio) %>%
  summarise(
    Valor_Final = last(Valor),
    Retorno_Total_pct = (Valor_Final / valor_inicial - 1),
    Retorno_Anualizado_pct = ((Valor_Final / valor_inicial)^(252 /
                                                               n()) - 1)
  ) %>%
  arrange(desc(Valor_Final))

cat("\n💰 R$ 100k Investidos - Nacional (MLP vs LSTM, com/sem RF)\n")
print(metricas_finais)

## Carteira Internacional ----

wallet_int <- merge.xts(ret_int, rf_int) %>% na.omit()

results_msr_internacional <- backtest_portfolio_manual(
  wallet_int,
  portfolio_fun = msr_long_only_fun,
  lookback = 126,
  rebalance_every = 14,
  portfolio_name = "MSR Internacional (sem RF)",
  max_rf_weight = 0,
  include_rf_in_return = FALSE
)

results_gmv_internacional <- backtest_portfolio_manual(
  wallet_int,
  portfolio_fun = gmv_portfolio_fun,
  lookback = 126,
  rebalance_every = 28,
  portfolio_name = "GMV Internacional (sem RF)",
  max_rf_weight = 0,
  include_rf_in_return = FALSE
)

results_msr_rf_internacional <- backtest_portfolio_manual(
  wallet_int,
  portfolio_fun = msr_with_rf_limit,
  lookback = 126,
  rebalance_every = 14,
  portfolio_name = "MSR Internacional (RF≤30%)",
  max_rf_weight = 0.30,
  include_rf_in_return = TRUE
)

results_gmv_rf_internacional <- backtest_portfolio_manual(
  wallet_int,
  portfolio_fun = gmv_portfolio_with_rf_limit,
  lookback = 126,
  rebalance_every = 28,
  portfolio_name = "GMV Internacional (RF≤30%)",
  max_rf_weight = 0.30,
  include_rf_in_return = TRUE
)

all_results_int_combined <- bind_rows(
  df_results_us_combined,
  df_results_crypto_combined,
  df_results_como_combined,
  df_results_etf_combined %>% filter(symbol != "BOVA11.SA")
)

best_lstm_int <- all_results_int_combined %>%
  select(symbol, model_results_lstm) %>%
  filter(!sapply(model_results_lstm, is.null)) %>%
  mutate(accuracy = map_dbl(model_results_lstm, ~ .x$test_accuracy)) %>%
  arrange(desc(accuracy)) %>%
  slice(1)

modelo_internacional_lstm <- best_lstm_int$model_results_lstm[[1]]
cat(
  sprintf(
    "\n→ Usando modelo LSTM Internacional de %s (Acurácia: %.1f%%)\n",
    best_lstm_int$symbol,
    modelo_internacional_lstm$test_accuracy * 100
  )
)

best_mlp_int <- all_results_int_combined %>%
  select(symbol, model_results_mlp) %>%
  filter(!sapply(model_results_mlp, is.null)) %>%
  mutate(accuracy = map_dbl(model_results_mlp, ~ .x$test_accuracy)) %>%
  arrange(desc(accuracy)) %>%
  slice(1)

modelo_internacional_mlp <- best_mlp_int$model_results_mlp[[1]]
cat(
  sprintf(
    "\n→ Usando modelo MLP Internacional de %s (Acurácia: %.1f%%)\n",
    best_mlp_int$symbol,
    modelo_internacional_mlp$test_accuracy * 100
  )
)

results_modelo_msr_lstm_int <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_lstm,
  portfolio_fun = msr_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + LSTM (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_gmv_lstm_int <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_lstm,
  portfolio_fun = gmv_portfolio_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + LSTM (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_msr_mlp_int <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_mlp,
  portfolio_fun = msr_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + MLP (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_gmv_mlp_int <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_mlp,
  portfolio_fun = gmv_portfolio_with_rf_limit,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + MLP (RF≤30%)",
  max_rf_weight = 0.30
)

results_modelo_msr_lstm_int_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_lstm,
  portfolio_fun = msr_long_only_fun,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + LSTM (sem RF)",
  max_rf_weight = 0
)

results_modelo_gmv_lstm_int_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_lstm,
  portfolio_fun = gmv_portfolio_fun,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + LSTM (sem RF)",
  max_rf_weight = 0
)

results_modelo_msr_mlp_int_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_mlp,
  portfolio_fun = msr_long_only_fun,
  lookback = 126,
  rebalance_fixed_days = 14,
  use_regime_trigger = TRUE,
  portfolio_name = "MSR + MLP (sem RF)",
  max_rf_weight = 0
)

results_modelo_gmv_mlp_int_sem_rf <- backtest_portfolio_com_modelo(
  returns_data = wallet_int,
  modelo_regime = modelo_internacional_mlp,
  portfolio_fun = gmv_portfolio_fun,
  lookback = 126,
  rebalance_fixed_days = 28,
  use_regime_trigger = TRUE,
  portfolio_name = "GMV + MLP (sem RF)",
  max_rf_weight = 0
)

padronizar_metricas <- function(metrics_df) {
  colunas_necessarias <- c("Model_Type",
                           "Model_Accuracy",
                           "N_Regime_Rebalances",
                           "N_Fixed_Rebalances")
  if (!"Model_Type" %in% colnames(metrics_df)) {
    metrics_df[["Model_Type"]] <- "Fixo"
  }
  if (!"Model_Accuracy" %in% colnames(metrics_df)) {
    metrics_df[["Model_Accuracy"]] <- NA
  }
  if (!"N_Regime_Rebalances" %in% colnames(metrics_df)) {
    metrics_df[["N_Regime_Rebalances"]] <- 0
  }
  if (!"N_Fixed_Rebalances" %in% colnames(metrics_df)) {
    metrics_df[["N_Fixed_Rebalances"]] <- metrics_df$N_Rebalances
  }
  return(metrics_df)
}

comparacao_internacional_completa <- bind_rows(
  padronizar_metricas(results_msr_internacional$metrics),
  padronizar_metricas(results_msr_rf_internacional$metrics),
  results_modelo_msr_lstm_int$metrics,
  results_modelo_msr_mlp_int$metrics,
  results_modelo_msr_lstm_int_sem_rf$metrics,
  results_modelo_msr_mlp_int_sem_rf$metrics,
  
  padronizar_metricas(results_gmv_internacional$metrics),
  padronizar_metricas(results_gmv_rf_internacional$metrics),
  results_modelo_gmv_lstm_int$metrics,
  results_modelo_gmv_mlp_int$metrics,
  results_modelo_gmv_lstm_int_sem_rf$metrics,
  results_modelo_gmv_mlp_int_sem_rf$metrics
)

cat("\n📊 Comparação Completa - Internacional (MLP vs LSTM, com/sem RF)\n")
print(
  comparacao_internacional_completa %>%
    select(
      Portfolio,
      Model_Type,
      Annual_Return,
      Sharpe_Ratio,
      Max_Drawdown,
      Model_Accuracy
    ) %>%
    arrange(desc(Sharpe_Ratio))
)


df_performance_int <- bind_rows(
  data.frame(
    date = index(results_msr_rf_internacional$wealth),
    Valor = as.numeric(results_msr_rf_internacional$wealth) * 100000,
    Estrategia = "MSR (Fixo, RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_int$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_int$wealth) * 100000,
    Estrategia = "MSR + LSTM (RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_int$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_int$wealth) * 100000,
    Estrategia = "MSR + MLP (RF≤30%)"
  ),
  data.frame(
    date = index(results_msr_internacional$wealth),
    Valor = as.numeric(results_msr_internacional$wealth) * 100000,
    Estrategia = "MSR (Fixo, sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_int_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_int_sem_rf$wealth) * 100000,
    Estrategia = "MSR + LSTM (sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_int_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_int_sem_rf$wealth) * 100000,
    Estrategia = "MSR + MLP (sem RF)"
  )
)

df_performance_int %>%
  ggplot(aes(
    x = date,
    y = Valor,
    color = Estrategia,
    linetype = Estrategia
  )) +
  geom_line(linewidth = 1) +
  geom_hline(
    yintercept = 100000,
    linetype = "dashed",
    color = "gray40",
    alpha = 0.5
  ) +
  scale_color_manual(
    values = c(
      "MSR (Fixo, RF≤30%)" = econ_colors_flat[["main.blue1"]],
      "MSR + LSTM (RF≤30%)" = econ_colors_flat[["main.econ_red"]],
      "MSR + MLP (RF≤30%)" = econ_colors_flat[["secondary.mustard"]],
      "MSR (Fixo, sem RF)" = econ_colors_flat[["main.blue2"]],
      "MSR + LSTM (sem RF)" = econ_colors_flat[["main.red_text"]],
      "MSR + MLP (sem RF)" = econ_colors_flat[["supporting_bright.orange"]]
    )
  ) +
  scale_linetype_manual(
    values = c(
      "MSR (Fixo, RF≤30%)" = "solid",
      "MSR + LSTM (RF≤30%)" = "solid",
      "MSR + MLP (RF≤30%)" = "solid",
      "MSR (Fixo, sem RF)" = "dashed",
      "MSR + LSTM (sem RF)" = "dashed",
      "MSR + MLP (sem RF)" = "dashed"
    )
  ) +
  scale_y_continuous(
    labels = function(x)
      paste0("U$ ", format(
        x / 1000, big.mark = ",", decimal.mark = "."
      ), "k")
  ) +
  theme_econ_base() +
  labs(
    title = "Performance: Rebalanceamento Inteligente vs Fixo (MSR Internacional)",
    subtitle = "Comparação de estratégias com e sem limite de Renda Fixa",
    x = "Data",
    y = "Valor da Carteira (U$ 100k inicial)",
    color = "Estratégia",
    linetype = "Estratégia"
  ) +
  theme(legend.position = "top")


cat("--- Comparação COM Limite de RF (RF≤30%) ---\n")
cat(
  sprintf(
    "MSR com RF (Fixo)   | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%%\n",
    results_msr_rf_internacional$metrics$Sharpe_Ratio,
    results_msr_rf_internacional$metrics$Annual_Return * 100,
    results_msr_rf_internacional$metrics$Max_Drawdown * 100
  )
)
delta_sharpe_mlp_int <-
  results_modelo_msr_mlp_int$metrics$Sharpe_Ratio - results_msr_rf_internacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + MLP (com RF)  | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_mlp_int$metrics$Sharpe_Ratio,
    results_modelo_msr_mlp_int$metrics$Annual_Return * 100,
    results_modelo_msr_mlp_int$metrics$Max_Drawdown * 100,
    delta_sharpe_mlp_int
  )
)
delta_sharpe_lstm_int <-
  results_modelo_msr_lstm_int$metrics$Sharpe_Ratio - results_msr_rf_internacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + LSTM (com RF) | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_lstm_int$metrics$Sharpe_Ratio,
    results_modelo_msr_lstm_int$metrics$Annual_Return * 100,
    results_modelo_msr_lstm_int$metrics$Max_Drawdown * 100,
    delta_sharpe_lstm_int
  )
)

cat("\n--- Comparação SEM Limite de RF ---\n")
cat(
  sprintf(
    "MSR sem RF (Fixo)   | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%%\n",
    results_msr_internacional$metrics$Sharpe_Ratio,
    results_msr_internacional$metrics$Annual_Return * 100,
    results_msr_internacional$metrics$Max_Drawdown * 100
  )
)
delta_sharpe_mlp_int_sem_rf <-
  results_modelo_msr_mlp_int_sem_rf$metrics$Sharpe_Ratio - results_msr_internacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + MLP (sem RF)  | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_mlp_int_sem_rf$metrics$Sharpe_Ratio,
    results_modelo_msr_mlp_int_sem_rf$metrics$Annual_Return * 100,
    results_modelo_msr_mlp_int_sem_rf$metrics$Max_Drawdown * 100,
    delta_sharpe_mlp_int_sem_rf
  )
)
delta_sharpe_lstm_int_sem_rf <-
  results_modelo_msr_lstm_int_sem_rf$metrics$Sharpe_Ratio - results_msr_internacional$metrics$Sharpe_Ratio
cat(
  sprintf(
    "MSR + LSTM (sem RF) | Sharpe: %.3f | Retorno: %5.2f%% | MaxDD: %.2f%% | ΔSharpe: %+.3f\n",
    results_modelo_msr_lstm_int_sem_rf$metrics$Sharpe_Ratio,
    results_modelo_msr_lstm_int_sem_rf$metrics$Annual_Return * 100,
    results_modelo_msr_lstm_int_sem_rf$metrics$Max_Drawdown * 100,
    delta_sharpe_lstm_int_sem_rf
  )
)


valor_inicial_usd <- 100000
datas_backtest_int <- index(results_msr_rf_internacional$wealth)
rf_wealth_int <-
  cumprod(1 + rf_int[datas_backtest_int]) * valor_inicial_usd
spy_wealth <-
  cumprod(1 + ret_int[datas_backtest_int, "SPY"]) * valor_inicial_usd

comparacao_100k_int <- bind_rows(
  data.frame(
    date = index(results_msr_rf_internacional$wealth),
    Valor = as.numeric(results_msr_rf_internacional$wealth) * valor_inicial_usd,
    Portfolio = "MSR (Fixo, RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_int$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_int$wealth) * valor_inicial_usd,
    Portfolio = "MSR + LSTM (RF≤30%)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_int$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_int$wealth) * valor_inicial_usd,
    Portfolio = "MSR + MLP (RF≤30%)"
  ),
  data.frame(
    date = index(results_msr_internacional$wealth),
    Valor = as.numeric(results_msr_internacional$wealth) * valor_inicial_usd,
    Portfolio = "MSR (Fixo, sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_lstm_int_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_lstm_int_sem_rf$wealth) * valor_inicial_usd,
    Portfolio = "MSR + LSTM (sem RF)"
  ),
  data.frame(
    date = index(results_modelo_msr_mlp_int_sem_rf$wealth),
    Valor = as.numeric(results_modelo_msr_mlp_int_sem_rf$wealth) * valor_inicial_usd,
    Portfolio = "MSR + MLP (sem RF)"
  ),
  data.frame(
    date = index(results_gmv_internacional$wealth),
    Valor = as.numeric(results_gmv_internacional$wealth) * valor_inicial_usd,
    Portfolio = "GMV (Fixo, sem RF)"
  ),
  data.frame(
    date = index(results_gmv_rf_internacional$wealth),
    Valor = as.numeric(results_gmv_rf_internacional$wealth) * valor_inicial_usd,
    Portfolio = "GMV (Fixo, RF≤30%)"
  ),
  data.frame(
    date = index(rf_wealth_int),
    Valor = as.numeric(rf_wealth_int),
    Portfolio = "100% Treasury (RF)"
  ),
  data.frame(
    date = index(spy_wealth),
    Valor = as.numeric(spy_wealth),
    Portfolio = "100% SPY"
  )
)

palette_internacional <- c(
  "MSR (Fixo, sem RF)" = econ_colors_flat[["main.red1"]],
  "MSR + LSTM (sem RF)" = econ_colors_flat[["main.econ_red"]],
  "MSR + MLP (sem RF)" = econ_colors_flat[["supporting_bright.orange"]],
  
  "MSR (Fixo, RF≤30%)" = econ_colors_flat[["main.blue1"]],
  "MSR + LSTM (RF≤30%)" = econ_colors_flat[["main.blue2_text"]],
  "MSR + MLP (RF≤30%)" = econ_colors_flat[["secondary.aqua"]],
  
  "GMV (Fixo, sem RF)" = econ_colors_flat[["secondary.mauve"]],
  "GMV + LSTM (sem RF)" = econ_colors_flat[["supporting_bright.purple"]], 
  "GMV + MLP (sem RF)" = econ_colors_flat[["supporting_bright.pink"]],   
  
  "GMV (Fixo, RF≤30%)" = econ_colors_flat[["secondary.teal"]],
  "GMV + LSTM (RF≤30%)" = econ_colors_flat[["supporting_dark.cyan_dk"]], 
  "GMV + MLP (RF≤30%)" = econ_colors_flat[["supporting_dark.navy"]],   
  
  "100% Treasury (RF)" = econ_colors_flat[["secondary.mustard"]],
  "100% SPY" = econ_colors_flat[["secondary.burgundy"]]
)



ggplot(comparacao_100k_int, aes(x = date, y = Valor, color = Portfolio)) +
  geom_line(linewidth = 1) +
  geom_hline(
    yintercept = valor_inicial_usd,
    linetype = "dashed",
    color = "gray40",
    alpha = 0.5
  ) +
  scale_color_manual(values = palette_internacional) +
  scale_y_continuous(
    labels = function(x)
      paste0("U$ ", format(
        x / 1000, big.mark = ",", decimal.mark = "."
      ), "k")
  ) +
  theme_econ_base() +
  labs(
    title = "Comparação Internacional: U$ 100.000 Investidos",
    subtitle = "Performance das carteiras (MLP vs LSTM, com/sem RF) vs benchmarks",
    x = "Data",
    y = "Valor da Carteira",
    color = "Estratégia"
  ) +
  theme(legend.position = "right",
        legend.key.size = unit(1.0, "lines"))

metricas_finais_int <- comparacao_100k_int %>%
  group_by(Portfolio) %>%
  summarise(
    Valor_Final = last(Valor),
    Retorno_Total_pct = (Valor_Final / valor_inicial_usd - 1),
    Retorno_Anualizado_pct = ((Valor_Final / valor_inicial_usd)^(252 /
                                                                   n()) - 1)
  ) %>%
  arrange(desc(Valor_Final))

cat("\n💰 U$ 100k Investidos - Internacional (MLP vs LSTM, com/sem RF)\n")
print(metricas_finais_int)

## Nacional Vs Internacional ----

comparacao_geral <- bind_rows(
  comparacao_nacional_completa %>% mutate(Mercado = "Nacional"),
  comparacao_internacional_completa %>% mutate(Mercado = "Internacional")
)

print(comparacao_geral %>%
        select(Mercado, Portfolio, Model_Type, Annual_Return, Sharpe_Ratio, Max_Drawdown) %>%
        arrange(Mercado, desc(Sharpe_Ratio)))

palette_final_plot <- c(
  "Nacional SEM Modelo" = econ_colors_flat[["main.blue1"]],
  "Nacional COM Modelo (MLP)" = econ_colors_flat[["secondary.aqua"]],
  "Nacional COM Modelo (LSTM)" = econ_colors_flat[["main.blue2_text"]],
  "Internacional SEM Modelo" = econ_colors_flat[["main.econ_red"]],
  "Internacional COM Modelo (MLP)" = econ_colors_flat[["supporting_bright.orange"]],
  "Internacional COM Modelo (LSTM)" = econ_colors_flat[["main.red_text"]]
)

comparacao_geral %>%
  filter(grepl("MSR.*RF≤30%", Portfolio)) %>%
  mutate(
    Tipo = case_when(
      Model_Type == "LSTM_Regime_Model" ~ "COM Modelo (LSTM)",
      Model_Type == "RegimeClassifierV5_Optimized" ~ "COM Modelo (MLP)",
      TRUE ~ "SEM Modelo"
    ),
    Combinacao = paste(Mercado, Tipo)
  ) %>%
  ggplot(aes(x = Annual_Volatility, y = Annual_Return, color = Combinacao, shape = Tipo)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text(aes(label = sprintf("%.2f", Sharpe_Ratio)),
            vjust = -1, size = 3, show.legend = FALSE) +
  scale_color_manual(values = palette_final_plot) +
  scale_shape_manual(values = c(
    "SEM Modelo" = 16,
    "COM Modelo (MLP)" = 17,
    "COM Modelo (LSTM)" = 15
  )) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_econ_base() +
  labs(
    title = "Fronteira Eficiente: MSR com RF≤30%",
    subtitle = "Comparação entre MLP, LSTM e Fixo",
    x = "Volatilidade Anual",
    y = "Retorno Anual",
    color = "Estratégia",
    shape = "Tipo"
  ) +
  theme(legend.position = "right")


comparacao_geral %>%
  filter(grepl("MSR.*sem RF", Portfolio)) %>%
  mutate(
    Tipo = case_when(
      Model_Type == "LSTM_Regime_Model" ~ "COM Modelo (LSTM)",
      Model_Type == "RegimeClassifierV5_Optimized" ~ "COM Modelo (MLP)",
      TRUE ~ "SEM Modelo"
    ),
    Combinacao = paste(Mercado, Tipo)
  ) %>%
  ggplot(aes(x = Annual_Volatility, y = Annual_Return, color = Combinacao, shape = Tipo)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text(aes(label = sprintf("%.2f", Sharpe_Ratio)),
            vjust = -1, size = 3, show.legend = FALSE) +
  scale_color_manual(values = palette_final_plot) +
  scale_shape_manual(values = c(
    "SEM Modelo" = 16,
    "COM Modelo (MLP)" = 17,
    "COM Modelo (LSTM)" = 15
  )) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_econ_base() +
  labs(
    title = "Fronteira Eficiente: MSR sem RF",
    subtitle = "Comparação entre MLP, LSTM e Fixo",
    x = "Volatilidade Anual",
    y = "Retorno Anual",
    color = "Estratégia",
    shape = "Tipo"
  ) +
  theme(legend.position = "right")


rm(
  results_msr_nacional,
  results_gmv_nacional,
  results_msr_rf_nacional,
  results_gmv_rf_nacional,
  results_modelo_msr_lstm_na,
  results_modelo_gmv_lstm_na,
  results_modelo_msr_mlp_na,
  results_modelo_gmv_mlp_na,
  results_modelo_msr_lstm_na_sem_rf,
  results_modelo_gmv_lstm_na_sem_rf,
  results_modelo_msr_mlp_na_sem_rf,
  results_modelo_gmv_mlp_na_sem_rf,
  results_msr_internacional,
  results_gmv_internacional,
  results_msr_rf_internacional,
  results_gmv_rf_internacional,
  results_modelo_msr_lstm_int,
  results_modelo_gmv_lstm_int,
  results_modelo_msr_mlp_int,
  results_modelo_gmv_mlp_int,
  results_modelo_msr_lstm_int_sem_rf,
  results_modelo_gmv_lstm_int_sem_rf,
  results_modelo_msr_mlp_int_sem_rf,
  results_modelo_gmv_mlp_int_sem_rf,
  comparacao_nacional_completa,
  comparacao_internacional_completa,
  comparacao_geral,
  df_performance,
  df_performance_int,
  comparacao_100k,
  comparacao_100k_int,
  metricas_finais,
  metricas_finais_int,
  all_results_na_combined,
  all_results_int_combined,
  best_lstm_na,
  best_mlp_na,
  best_lstm_int,
  best_mlp_int,
  modelo_nacional_lstm,
  modelo_nacional_mlp,
  modelo_internacional_lstm,
  modelo_internacional_mlp,
  rf_wealth,
  bova_wealth,
  rf_wealth_int,
  spy_wealth,
  datas_backtest,
  datas_backtest_int,
  valor_inicial,
  valor_inicial_usd,
  palette_final_plot,
  palette_nacional,
  palette_internacional,
  results_pool_br,
  results_pool_bova
)
