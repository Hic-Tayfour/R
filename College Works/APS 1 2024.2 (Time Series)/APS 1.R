# Importando as bibliotecas necessárias----
library(tidyverse)  # Manipulação e Tratamento de Dados
library(dplyr)      # Manipulação e Tratamento de Dados
library(moments)    # Teste de Hipótese de Normalidade
library(ggplot2)    # Criação de Gráficos
library(ggthemes)   # Criação de Gráficos
library(gridExtra)  # Criação de Gráficos
library(forecast)   # Modelagem de Séries Temporais
library(stargazer)  # Montagem de tabelas

# Importando as bases de dados necessárias----

"
Dados Baixados do Federal Reserve Economic Data.
PIB Reais, trimestrais, com ajuste sazonal anual.
Quem calcula o PIB dos EUA é o Bureau of Economic Analysis (BEA).
Quem calcula o PIB do Brasil é o Instituto Brasileiro de Geografia e Estatística (IBGE).
Os dados estão em dólares americanos (USD) e em reais (BRL) respectivamente.
Os dados estão em frequência trimestral, reais e com ajuste sazonal anual.
"

brl <- read.csv("gdp_brazil.csv")
usa <- read.csv("gdp_usa.csv")

brl <- brl %>%
  rename(VALUE = NGDPRSAXDCBRQ) %>%
  mutate(DATE = as.Date(DATE))

usa <- usa %>%
  rename(VALUE = GDPC1) %>%
  mutate(DATE = as.Date(DATE))

# Verificando o Tipo de dados

str(c(brl, usa))

custom_bg_color <- "#f9e7d5"


# Letra A)----

## Série do PIB brasileiro

ggplot(data = brl, aes(x = DATE, y = VALUE, group = 1)) +
  geom_line(color = "chartreuse", size = 1.5) +
  scale_x_date(date_labels = "%Y", date_breaks = "4 years") +
  labs(
    title = "Série Temporal do PIB",
    subtitle = "Brasil (Trimestral)",
    x = "Ano",
    y = "Valor do PIB (Base Reajustada)",
    caption = "Fonte: Gráfico Próprio| Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
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

## Construindo um correlograma da série do PIB brasileiro

acf_data <- acf(brl$VALUE, plot = FALSE)
pacf_data <- pacf(brl$VALUE, plot = FALSE)

acf_df <- data.frame(
  lag = acf_data$lag,
  acf = acf_data$acf
)

pacf_df <- data.frame(
  lag = pacf_data$lag,
  pacf = pacf_data$acf
)

acf_df$lag <- factor(acf_df$lag, levels = rev(unique(acf_df$lag)))
pacf_df$lag <- factor(pacf_df$lag, levels = rev(unique(pacf_df$lag)))

acf_plot <- ggplot(acf_df, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "chartreuse", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl)), 1.96 / sqrt(nrow(brl))), linetype = "dashed", color = "red") +
  labs(title = "Autocorrelação do PIB Brasileiro", x = "Lag", y = NULL,
       caption = "Fonte: Gráfico Próprio| Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)") +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

pacf_plot <- ggplot(pacf_df, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity", fill = "chartreuse4", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl)), 1.96 / sqrt(nrow(brl))), linetype = "dashed", color = "red") +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot, pacf_plot, ncol = 2)



# Letra B) ----

## Criação da Série de Crescimento do PIB

brl <- brl %>%
  mutate(GROWTH = VALUE / lag(VALUE) - 1)

## Gráfico da Série de Crescimento do PIB

ggplot(data = brl, aes(x = DATE, y = GROWTH, group = 1)) +
  geom_line(color = "chartreuse", size = 1.5) +
  scale_x_date(date_labels = "%Y", date_breaks = "4 years") +
  labs(
    title = "Série Temporal do Crescimento do PIB",
    subtitle = "Brasil (Trimestral)",
    x = "Ano",
    y = "Taxa de Crescimento do PIB",
    caption = "Fonte: Gráfico Próprio| Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
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

## Construindo um correlograma da série da taxa de cresecimento do PIB brasileiro

acf_data <- brl %>%
  pull(GROWTH) %>%
  .[-1] %>%
  acf(plot = FALSE)

pacf_data <- brl %>%
  pull(GROWTH) %>%
  .[-1] %>%
  pacf(plot = FALSE)

acf_df <- data.frame(
  lag = acf_data$lag,
  acf = acf_data$acf
)

pacf_df <- data.frame(
  lag = pacf_data$lag,
  pacf = pacf_data$acf
)

acf_df$lag <- factor(acf_df$lag, levels = rev(unique(acf_df$lag)))
pacf_df$lag <- factor(pacf_df$lag, levels = rev(unique(pacf_df$lag)))

acf_plot <- ggplot(acf_df, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "chartreuse", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl)), 1.96 / sqrt(nrow(brl))), linetype = "dashed", color = "red") +
  labs(title = "Autocorrelação da taxa de crescimento do PIB Brasileiro", x = "Lag", y = NULL,
       caption = "Fonte: Gráfico Próprio| Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)") +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

pacf_plot <- ggplot(pacf_df, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity", fill = "chartreuse4", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl)), 1.96 / sqrt(nrow(brl))), linetype = "dashed", color = "red") +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot, pacf_plot, ncol = 2)




# Letra D) ----

## Construindo um modelo AR(2) 3 AR(3) para o crescimento do PIB brasileiro

brl_ar2 <- arima(brl$GROWTH, order = c(2, 0, 0))
brl_ar3 <- arima(brl$GROWTH, order = c(3, 0, 0))

"Verificando os resultados do modelo AR(2) para o crescimento do PIB brasileiro"

ar2_coefs_b <- brl_ar2$coef[1:2]  
poly_coefs_ar2_b <- c(1, -ar2_coefs_b)  
roots_ar2_b <- polyroot(poly_coefs_ar2_b)  
roots_ar2_b

"Calculando o modulo dos autovalores"

mod_roots_ar2_b <- sqrt(Re(roots_ar2_b)^2 + Im(roots_ar2_b)^2)
mod_roots_ar2_b

"Vericando os resultados do modelo AR(3) para o crescimento do PIB brasileiro"

ar3_coefs_b <- brl_ar3$coef[1:3]
poly_coefs_ar3_b <- c(1, -ar3_coefs_b)
roots_ar3_b <- polyroot(poly_coefs_ar3_b)
roots_ar3_b

"Calculando o modulo dos autovalores"

mod_roots_ar3_b <- sqrt(Re(roots_ar3_b)^2 + Im(roots_ar3_b)^2)
mod_roots_ar3_b

# Tabela dos cieficientes dos Modelos AR(2) e AR(3) para o crescimento do PIB brasileiro 

stargazer(brl_ar2, brl_ar3, type = "text", title = "Modelos AR(2) e AR(3) para o crescimento do PIB brasileiro", 
          column.labels = c("AR(2)", "AR(3)"), dep.var.caption = "Taxa de Crescimento do PIB", 
          dep.var.labels.include = FALSE, digits = 4, align = TRUE, single.row = TRUE, 
          omit = "Constant", notes = "Fonte: Gráfico Próprio | Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)")

## Construindo o circulo unitário com as raízes dos modelos AR(2) e AR(3) para o crescimento do PIB brasileiro
circle_data <- data.frame(
  x = cos(seq(0, 2 * pi, length.out = 100)),
  y = sin(seq(0, 2 * pi, length.out = 100))
)

roots_ar_data_br <- data.frame(
  x = c(Re(roots_ar2_b), Re(roots_ar3_b)),
  y = c(Im(roots_ar2_b), Im(roots_ar3_b)),
  model = factor(c(rep("AR(2)", length(roots_ar2_b)), rep("AR(3)", length(roots_ar3_b))))
)

circle_br <- ggplot() +
  geom_point(data = roots_ar_data_br, aes(x = x, y = y, color = model), size = 3) +
  geom_text(data = roots_ar_data_br, aes(x = x, y = y, label = paste0("(", round(x, 2), ", ", round(y, 2), ")")), 
            vjust = -1, size = 3, color = "black") +
  geom_path(data = circle_data, aes(x = x, y = y), color = "black", size = 1.5) +  
  geom_hline(yintercept = 0, color = "black", size = 1.2) +
  geom_vline(xintercept = 0, color = "black", size = 1.2) +
  geom_segment(data = roots_ar_data_br, aes(x = 0, xend = x, y = y, yend = y), 
               linetype = "dashed", color = "gray") +
  geom_segment(data = roots_ar_data_br, aes(x = x, xend = x, y = 0, yend = y), 
               linetype = "dashed", color = "gray") +
  labs(title = "Círculo Unitário", x = "Real", y = "Imaginário") +
  scale_color_manual(values = c("AR(2)" = "chartreuse", "AR(3)" = "chartreuse4"), 
                     name = "Modelos AR") + 
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  coord_fixed(ratio = 1) +
  xlim(c(-3, 7)) + 
  ylim(c(-3, 3))


print(circle_br)

## Raizes dos Modelos AR(2) e AR(3) para o crescimento do PIB brasileiro

mod_roots_ar2_b
mod_roots_ar3_b

"As raizes dos modelos AR(2) e AR(3) para o crescimento do PIB brasileiro estão acima de 1, portanto, a série é estacionária.
"

# Letra E) ----

# Calculando a duração média do ciclo para AR(2) do Brasil
ar2_duration_b <- 2 * pi / acos(Re(roots_ar2_b) / mod_roots_ar2_b)
ar2_duration_b

# Calculando a duração média do ciclo para AR(3) do Brasil
ar3_duration_b <- 2 * pi / acos(Re(roots_ar3_b) / mod_roots_ar3_b)
ar3_duration_b



# Letra F) ----

"
Análise de Resíduos dos dados da taxa de crescimento do PIB brasileiro
"

## Análise de Resíduos do modelo AR(2) para o crescimento do PIB brasileiro

brl_ar2_res <- brl %>%
  mutate(RESIDUALS = residuals(brl_ar2))

## Correlograma dos resíduos do modelo AR(2) para o crescimento do PIB brasileiro 

brl_ar2_res <- brl_ar2_res %>%
  filter(!is.na(RESIDUALS))

acf_data_r_br_2 <- acf(brl_ar2_res$RESIDUALS, plot = FALSE)
pacf_data_r_br_2 <- pacf(brl_ar2_res$RESIDUALS, plot = FALSE)

acf_df_r_br_2 <- data.frame(
  lag = acf_data_r_br_2$lag,
  acf = acf_data_r_br_2$acf
)

pacf_df_r_br_2 <- data.frame(
  lag = pacf_data_r_br_2$lag,
  pacf = pacf_data_r_br_2$acf
)

acf_df_r_br_2$lag <- factor(acf_df_r_br_2$lag, levels = rev(unique(acf_df_r_br_2$lag)))

pacf_df_r_br_2$lag <- factor(pacf_df_r_br_2$lag, levels = rev(unique(pacf_df_r_br_2$lag)))

acf_plot_r_br_2 <- ggplot(acf_df_r_br_2, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "chartreuse", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl_ar2_res)), 1.96 / sqrt(nrow(brl_ar2_res))), linetype = "dashed", color = "red") +
  labs(title = "Autocorrelação dos Resíduos do PIB Brasileiro (AR(2))", x = "Lag", y = NULL,
       caption = "Fonte: Gráfico Próprio| Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)") +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

pacf_plot_r_br_2 <- ggplot(pacf_df_r_br_2, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity", fill = "chartreuse4", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl_ar2_res)), 1.96 / sqrt(nrow(brl_ar2_res))), linetype = "dashed", color = "red") +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot_r_br_2, pacf_plot_r_br_2, ncol = 2)

## Análise de Resíduos do modelo AR(3) para o crescimento do PIB brasileiro

brl_ar3_res <- brl %>%
  mutate(RESIDUALS = residuals(brl_ar3))

## Correlograma dos resíduos do modelo AR(3) para o crescimento do PIB brasileiro

brl_ar3_res <- brl_ar3_res %>%
  filter(!is.na(RESIDUALS))

acf_data_r_br_3 <- acf(brl_ar3_res$RESIDUALS, plot = FALSE)
pacf_data_r_br_3 <- pacf(brl_ar3_res$RESIDUALS, plot = FALSE)

acf_df_r_br_3 <- data.frame(
  lag = acf_data_r_br_3$lag,
  acf = acf_data_r_br_3$acf
)

pacf_df_r_br_3 <- data.frame(
  lag = pacf_data_r_br_3$lag,
  pacf = pacf_data_r_br_3$acf
)

acf_df_r_br_3$lag <- factor(acf_df_r_br_3$lag, levels = rev(unique(acf_df_r_br_3$lag)))

pacf_df_r_br_3$lag <- factor(pacf_df_r_br_3$lag, levels = rev(unique(pacf_df_r_br_3$lag)))

acf_plot_r_br_3 <- ggplot(acf_df_r_br_3, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "chartreuse", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl_ar3_res)), 1.96 / sqrt(nrow(brl_ar3_res))), linetype = "dashed", color = "red") +
  labs(title = "Autocorrelação dos Resíduos do PIB Brasileiro (AR(3))", x = "Lag", y = NULL,
       caption = "Fonte: Gráfico Próprio| Dados: Instituto Brasileiro de Geografia e Estatística (IBGE)") +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

pacf_plot_r_br_3 <- ggplot(pacf_df_r_br_3, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity", fill = "chartreuse4", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(brl_ar3_res)), 1.96 / sqrt(nrow(brl_ar3_res))), linetype = "dashed", color = "red") +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot_r_br_3, pacf_plot_r_br_3, ncol = 2)

"Há memória relevante no Erro que explica o crescimento do PIB brasileiro, pois a autocorrelação dos resíduos é significativa."




# Letra G) ----

## Série do PIB estadunidense

ggplot(data = usa, aes(x = DATE, y = VALUE, group = 1 )) +
  geom_line(color = "red2", size = 1.5) +
  scale_x_date(date_labels = "%Y", date_breaks = "4 years") +
  labs(
    title = "Série Temporal do PIB",
    subtitle = "Estados Unidos (Trimestral)",
    x = "Ano",
    y = "Valor do PIB (Base Reajustada)",
    caption = "Fonte: Gráfico Próprio| Dados: Bureau of Economic Analysis (BEA)"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
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

## Construindo um correlograma da série do PIB estadunidense

acf_data <- acf(usa$VALUE, plot = FALSE)
pacf_data <- pacf(usa$VALUE, plot = FALSE)

acf_df <- data.frame(
  lag = acf_data$lag,
  acf = acf_data$acf
)

pacf_df <- data.frame(
  lag = pacf_data$lag,
  pacf = pacf_data$acf
)

acf_df$lag <- factor(acf_df$lag, levels = rev(unique(acf_df$lag)))
pacf_df$lag <- factor(pacf_df$lag, levels = rev(unique(pacf_df$lag)))

acf_plot <- ggplot(acf_df, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "red2", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(usa)), 1.96 / sqrt(nrow(usa))), linetype = "dashed", color = "red") +
  labs(title = "Autocorrelação do PIB Estadunidense", x = "Lag", y = NULL,
       caption = "Fonte: Gráfico Próprio| Dados: Bureau of Economic Analysis (BEA)") +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

pacf_plot <- ggplot(pacf_df, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity", fill = "red4", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(usa)), 1.96 / sqrt(nrow(usa))), linetype = "dashed", color = "red") +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal()+
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot, pacf_plot, ncol = 2)



# Letra H) ----

## Criação da Série de Crescimento do PIB

usa <- usa %>%
  mutate(GROWTH = VALUE / lag(VALUE) - 1)

## Gráfico da Série de Crescimento do PIB

ggplot(data = usa, aes(x = DATE, y = GROWTH, group = 1)) +
  geom_line(color = "red2", size = 1.5) +
  scale_x_date(date_labels = "%Y", date_breaks = "4 years") +
  labs(
    title = "Série Temporal do Crescimento do PIB",
    subtitle = "Estados Unidos (Trimestral)",
    x = "Ano",
    y = "Taxa de Crescimento do PIB",
    caption = "Fonte: Gráfico Próprio| Dados: Bureau of Economic Analysis (BEA)"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
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
    


# Letra I) ----

## Construindo um correlograma da série da taxa de cresecimento do PIB estadunidense

acf_data <- usa %>%
  pull(GROWTH) %>%
  .[-1] %>%
  acf(plot = FALSE)

pacf_data <- usa %>%
  pull(GROWTH) %>%
  .[-1] %>%
  pacf(plot = FALSE)

acf_df <- data.frame(
  lag = acf_data$lag,
  acf = acf_data$acf
)

pacf_df <- data.frame(
  lag = pacf_data$lag,
  pacf = pacf_data$acf
)

acf_df$lag <- factor(acf_df$lag, levels = rev(unique(acf_df$lag)))
pacf_df$lag <- factor(pacf_df$lag, levels = rev(unique(pacf_df$lag)))

acf_plot <- ggplot(acf_df, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "red2", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(usa)), 1.96 / sqrt(nrow(usa))), linetype = "dashed", color = "red") +
  labs(title = "Autocorrelação da taxa de crescimento do PIB Estadunidense", x = "Lag", y = NULL,
       caption = "Fonte: Gráfico Próprio | Dados: Bureau of Economic Analysis (BEA)") +
  coord_flip() +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

pacf_plot <- ggplot(pacf_df, aes(x = lag, y = pacf)) +
  geom_bar(stat = "identity", fill = "red4", color = "black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_hline(yintercept = c(-1.96 / sqrt(nrow(usa)), 1.96 / sqrt(nrow(usa))), linetype = "dashed", color = "red") +
  labs(title = "Partial Correlation", x = "Lag", y = NULL) +
  coord_flip() +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(), 
        panel.grid.minor.y = element_blank())

grid.arrange(acf_plot, pacf_plot, ncol = 2)



# Letra J) ----

## Construindo um modelo AR(2) 3 AR(3) para o crescimento do PIB estadunidense

usa_ar2 <- arima(usa$GROWTH, order = c(2, 0, 0))
usa_ar3 <- arima(usa$GROWTH, order = c(3, 0, 0))

"Verificando os resultados do modelo AR(2) para o crescimento do PIB estadunidense"

ar2_coefs_u <- usa_ar2$coef[1:2]
poly_coefs_ar2_u <- c(1, -ar2_coefs_u)
roots_ar2_u <- polyroot(poly_coefs_ar2_u)
roots_ar2_u

"Calculando o modulo dos autovalores"

mod_roots_ar2_u <- sqrt(Re(roots_ar2_u)^2 + Im(roots_ar2_u)^2)
mod_roots_ar2_u

"Verificando os resultados do modelo AR(3) para o crescimento do PIB estadunidense"

ar3_coefs_u <- usa_ar3$coef[1:3]
poly_coefs_ar3_u <- c(1, -ar3_coefs_u)
roots_ar3_u <- polyroot(poly_coefs_ar3_u)
roots_ar3_u

mod_roots_ar3_u <- sqrt(Re(roots_ar3_u)^2 + Im(roots_ar3_u)^2)
mod_roots_ar3_u

# Tabela dos cieficientes dos Modelos AR(2) e AR(3) para o crescimento do PIB estadunidense 

stargazer(usa_ar2, usa_ar3, type = "text", title = "Modelos AR(2) e AR(3) para o crescimento do PIB estadunidense", 
          column.labels = c("AR(2)", "AR(3)"), dep.var.caption = "Taxa de Crescimento do PIB", 
          dep.var.labels.include = FALSE, digits = 4, align = TRUE, single.row = TRUE, 
          omit = "Constant", notes = "Fonte: Gráfico Próprio | Dados: Bureau of Economic Analysis (BEA)")

## Construindo o circulo unitário com as raízes dos modelos AR(2) e AR(3) para o crescimento do PIB estadunidense

roots_ar_data_u <- data.frame(
  x = c(Re(roots_ar2_u), Re(roots_ar3_u)),
  y = c(Im(roots_ar2_u), Im(roots_ar3_u)),
  model = factor(c(rep("AR(2)", length(roots_ar2_u)), rep("AR(3)", length(roots_ar3_u)))
  )
)

circle_u <- ggplot() +
  geom_point(data = roots_ar_data_u, aes(x = x, y = y, color = model), size = 3) +
  geom_text(data = roots_ar_data_u, aes(x = x, y = y, label = paste0("(", round(x, 2), ", ", round(y, 2), ")")), 
            vjust = -1, size = 3, color = "black") +
  geom_path(data = circle_data, aes(x = x, y = y), color = "black", size = 1.5) +  
  geom_hline(yintercept = 0, color = "black", size = 1.2) +
  geom_vline(xintercept = 0, color = "black", size = 1.2) +
  geom_segment(data = roots_ar_data_u, aes(x = 0, xend = x, y = y, yend = y), 
               linetype = "dashed", color = "gray") +
  geom_segment(data = roots_ar_data_u, aes(x = x, xend = x, y = 0, yend = y), 
               linetype = "dashed", color = "gray") +
  labs(title = "Círculo Unitário", x = "Real", y = "Imaginário") +
  scale_color_manual(values = c("AR(2)" = "red2", "AR(3)" = "red4"), 
                     name = "Modelos AR") + 
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  coord_fixed(ratio = 1) +
  xlim(c(-4, 4)) + 
  ylim(c(-2, 2))

print(circle_u)

## Raizes dos Modelos AR(2) e AR(3) para o crescimento do PIB estadunidense

mod_roots_ar2_u
mod_roots_ar3_u

"As raizes dos modelos AR(2) e AR(3) para o crescimento do PIB estadunidense estão acima de 1, portanto, a série é estacionária.
"
# Calculando a duração média do ciclo para AR(3) dos Estados Unidos de 1947-01-01 até 2015-10-01

dates <- seq(as.Date("1947-01-01"), as.Date("2015-10-01"), by = "quarter")

usa_1947_2015 <- usa %>%
  filter(DATE >= as.Date("1947-01-01") & DATE <= as.Date("2015-10-01"))

usa_ar3_1947_2015 <- arima(usa_1947_2015$GROWTH, order = c(3, 0, 0))

ar3_coefs_u_1947_2015 <- usa_ar3_1947_2015$coef[1:3]

poly_coefs_ar3_u_1947_2015 <- c(1, -ar3_coefs_u_1947_2015)

roots_ar3_u_1947_2015 <- polyroot(poly_coefs_ar3_u_1947_2015)

mod_roots_ar3_u_1947_2015 <- sqrt(Re(roots_ar3_u_1947_2015)^2 + Im(roots_ar3_u_1947_2015)^2)

# Calculando a duração média do ciclo para AR(3) dos Estados Unidos de 1947-01-01 até 2015-10-01

ar3_duration_u_1947_2015 <- 2 * pi / acos(Re(roots_ar3_u_1947_2015) / mod_roots_ar3_u_1947_2015)

ar3_duration_u_1947_2015

## Calculando a duração média do ciclo para AR(3) dos Estados Unidos

ar3_duration_u <- 2 * pi / acos(Re(roots_ar3_u) / mod_roots_ar3_u)

ar3_duration_u
