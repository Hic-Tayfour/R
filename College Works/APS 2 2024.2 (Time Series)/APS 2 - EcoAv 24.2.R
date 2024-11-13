# Importando as Biblioteca Necesárias
library(tidyverse)  # Manipulação e Tratamento de Dados
library(gridExtra)  # Criação de Gráficos
library(stargazer)  # Montagem de tabelas
library(tidyquant)  # Extração de Dados Financeiros
library(stargazer)  # Montagem de tabelas
library(ggthemes)   # Criação de Gráficos
library(forecast)   # Modelagem de Séries Temporais
library(moments)    # Teste de Hipótese de Normalidade
library(ggplot2)    # Criação de Gráficos
library(tseries)    # Modelagem de Series Temporais
library(dplyr)      # Manipulação e Tratamento de Dados
library(urca)       # Teste de Raiz Unitária

# Importando os Dados

minerio_ferro <- tq_get(
  "TIO=F",
  from = "2007-01-01",
  to = "2024-10-11",
  get = "stock.prices",
  source = "yahoo"
)


acoes_vale <- tq_get(
  "VALE",
  from = "2007-01-01",
  to = "2024-10-11",
  get = "stock.prices",
  source = "yahoo"
)

## Ajustando os dados

iron <- minerio_ferro %>%
  tq_transmute(
    select = adjusted,
    mutate_fun = to.monthly,
    indexAt = "lastof",
    col_rename = "close"
  ) %>%
  na.omit() %>%
  select(date, close) %>%
  rename(price = close) %>%
  mutate(r = price / lag(price) - 1) %>%
  mutate(dl_p = log(price) - log(lag(price))) %>%
  mutate(lp_iron = log(price))

vale <- acoes_vale %>%
  tq_transmute(
    select = adjusted,
    mutate_fun = to.monthly,
    indexAt = "lastof",
    col_rename = "close"
  ) %>%
  select(date, close) %>%
  rename(price = close) %>%
  mutate(r = price / lag(price) - 1) %>%
  mutate(dl_p = log(price) - log(lag(price))) %>%
  mutate(lp_vale = log(price))

# Letra A)----

ggplot(data = iron, aes(x = date, y = price, group = 1)) +
  geom_line(color = "gray46", size = 1.5) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 year") +
  labs(
    title = "Série Mensal de Fechamentos",
    subtitle = "Preço do Ferro (TIO=F)",
    x = "",
    y = "Valor de Fechamento (USD)",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )

## Filtrando os Dados nos 2 últimos anos

iron_last_two_years <- iron %>%
  filter(date >= as.Date(Sys.Date() - 365 * 2))

ggplot(data = iron_last_two_years, aes(x = date, y = price, group = 1)) +
  geom_line(color = "gray46", size = 1.5) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "2 months") +
  labs(
    title = "Série Mensal de Fechamentos - Últimos Dois Anos",
    subtitle = "Preço do Ferro (TIO=F)",
    x = "",
    y = "Valor de Fechamento (USD)",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )


# Letra B) ----

ggplot(data = vale, aes(x = date, y = price, group = 1)) +
  geom_line(color = "seagreen", size = 1.5) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 year") +
  labs(
    title = "Série Mensal de Fechamentos",
    subtitle = "Preço da Vale (VALE)",
    x = "",
    y = "Valor de Fechamento (USD)",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )

# Letra C) ----
full_market <- inner_join(iron, vale, by = "date", suffix = c("_iron", "_vale"))

scale_factor <- max(full_market$price_iron) / max(full_market$price_vale)

ggplot() +
  geom_line(
    data = full_market,
    aes(x = date, y = price_iron, color = "Minério de Ferro"),
    size = 1.5
  ) +
  geom_line(
    data = full_market,
    aes(
      x = date,
      y = price_vale * scale_factor,
      color = "Vale"
    ),
    size = 1.5
  ) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 year") +
  scale_y_continuous(
    name = "Valor de Fechamento (Minério de Ferro)",
    sec.axis = sec_axis(~ . / scale_factor, name = "Valor de Fechamento (Vale)")
  ) +
  scale_color_manual(values = c(
    "Minério de Ferro" = "gray46",
    "Vale" = "seagreen"
  )) +
  labs(
    title = "Comparação de Preços: Minério de Ferro e Vale",
    subtitle = "Séries Mensais de Fechamentos (Intervalo Comum)",
    x = "Data",
    color = "Série",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "top",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.title.y.right = element_text(size = 14)
  )



# Letra D) ----

full_market <- full_market %>%
  mutate(lp_iron = log(price_iron),
         lp_vale = log(price_vale))

ggplot() +
  geom_line(data = full_market,
            aes(x = date, y = lp_iron, color = "Minério de Ferro"),
            size = 1.5) +
  geom_line(data = full_market,
            aes(x = date, y = lp_vale, color = "Vale"),
            size = 1.5) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 year") +
  scale_y_continuous(name = "Valor do Log do Fechamento (Minério de Ferro)",
                     sec.axis = sec_axis(~ ., name = "Valor do Log do Fechamento (Vale)")) +
  scale_color_manual(values = c(
    "Minério de Ferro" = "gray46",
    "Vale" = "seagreen"
  )) +
  labs(
    title = "Comparação do Log dos Preços: Minério de Ferro e Vale",
    subtitle = "Séries Mensais de Fechamentos (Intervalo Comum)",
    x = "Data",
    color = "Série",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "top",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.title.y.right = element_text(size = 14)
  )


# Letra E) ----

realizar_testes_adf <- function(serie, max_lags = 10)  {
  adf_tend_intercept <- ur.df(serie,
                              type = "trend",
                              lags = max_lags,
                              selectlags = "BIC")
  print("Resultados do Teste ADF com Tendência, Intercepto e Defasagens")
  print(summary(adf_tend_intercept))
  
  adf_tend_sem_intercepto <- ur.df(serie,
                                   type = "drift",
                                   lags = max_lags,
                                   selectlags = "BIC")
  print("Resultados do Teste ADF sem Tendência, com Intercepto e com Defasagens")
  print(summary(adf_tend_sem_intercepto))
  
  adf_apenas_defasagens <- ur.df(serie,
                                 type = "none",
                                 lags = max_lags,
                                 selectlags = "BIC")
  print("Resultados do Teste ADF Apenas com Defasagens")
  print(summary(adf_apenas_defasagens))
  
  return(
    list(
      adf_tend_intercept = adf_tend_intercept,
      adf_tend_sem_intercepto = adf_tend_sem_intercepto,
      adf_apenas_defasagens = adf_apenas_defasagens
    )
  )
}

resultados <- realizar_testes_adf(iron$lp_iron, max_lags = 10)


# Letra F) ----

realizar_testes_adf(vale$lp_vale, max_lags = 10)

# Letra G) ----

ggplot(data = iron, aes(x = date, y = dl_p, group = 1)) +
  geom_line(color = "gray46", size = 1.5) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 year") +
  labs(
    title = "Série dos Log-Retornos",
    subtitle = "Log-Retornosddo Ferro (TIO=F)",
    x = "",
    y = "Valor do Log-Retorno",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )


## Gráficos de Autocorrelação e Autocorrelação Parcial
acf_data_iron <- acf(na.omit(iron$dl_p), plot = FALSE)
pacf_data_iron <- pacf(na.omit(iron$dl_p), plot = FALSE)

acf_df_iron <- data.frame(lag = acf_data_iron$lag, acf = acf_data_iron$acf) %>%
  subset(lag != 0)

pacf_df_iron <- data.frame(lag = pacf_data_iron$lag, pacf = pacf_data_iron$acf)

acf_df_iron$lag <- factor(acf_df_iron$lag, levels = rev(unique(acf_df_iron$lag)))

pacf_df_iron$lag <- factor(pacf_df_iron$lag, levels = rev(unique(pacf_df_iron$lag)))

acf_plot <- ggplot(acf_df_iron, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity",
           fill = "gray46",
           color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(
    yintercept = c(-1.96 / sqrt(nrow(iron)), 1.96 / sqrt(nrow(iron))),
    linetype = "dashed",
    color = "red"
  ) +
  labs(
    title = "Autocorrelação do Log-Retorno dos Preços de Ferro (TIO=F)",
    x = "Lag",
    y = NULL,
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  coord_flip() +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())

pacf_plot <- ggplot(pacf_df_iron, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity",
           fill = "gray46",
           color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(
    yintercept = c(-1.96 / sqrt(nrow(iron)), 1.96 / sqrt(nrow(iron))),
    linetype = "dashed",
    color = "red"
  ) +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot, pacf_plot, ncol = 2)

# Letra H) ----

ggplot(data = vale, aes(x = date, y = dl_p, group = 1)) +
  geom_line(color = "seagreen", size = 1.5) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "2 year") +
  labs(
    title = "Série dos Log-Retornos",
    subtitle = "Log-Retornos do Vale (VALE)",
    x = "",
    y = "Valor do Log-Retorno",
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )


## Gráficos de Autocorrelação e Autocorrelação Parcial
acf_data_vale <- acf(na.omit(vale$dl_p), plot = FALSE)
pacf_data_vale <- pacf(na.omit(vale$dl_p), plot = FALSE)

acf_df_vale <- data.frame(lag = acf_data_vale$lag, acf = acf_data_vale$acf) %>%
  subset(lag != 0)

pacf_df_vale <- data.frame(lag = pacf_data_vale$lag, pacf = pacf_data_vale$acf)

acf_df_vale$lag <- factor(acf_df_vale$lag, levels = rev(unique(acf_df_vale$lag)))

pacf_df_vale$lag <- factor(pacf_df_vale$lag, levels = rev(unique(pacf_df_vale$lag)))

acf_plot <- ggplot(acf_df_vale, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity",
           fill = "seagreen",
           color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(
    yintercept = c(-1.96 / sqrt(nrow(vale)), 1.96 / sqrt(nrow(vale))),
    linetype = "dashed",
    color = "red"
  ) +
  labs(
    title = "Autocorrelação do Log-Retorno dos Preços da Vale (VALE)",
    x = "Lag",
    y = NULL,
    caption = "Fonte : Yahoo Finance | Gráfico Próprio"
  ) +
  coord_flip() +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())

pacf_plot <- ggplot(pacf_df_vale, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity",
           fill = "seagreen",
           color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(
    yintercept = c(-1.96 / sqrt(nrow(vale)), 1.96 / sqrt(nrow(vale))),
    linetype = "dashed",
    color = "red"
  ) +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot, pacf_plot, ncol = 2)


# Letra L) ----

ml <- lm(lp_vale ~ lp_iron, data = full_market)
r_ml <- resid(ml)

realizar_testes_adf(r_ml, max_lags = 10)

mpd <- lm(dl_p_vale ~ dl_p_iron, data = full_market)
r_mpd <- resid(mpd)

realizar_testes_adf(r_mpd, max_lags = 10)

# Letra M) ----

summary(ml)
summary(mpd)
