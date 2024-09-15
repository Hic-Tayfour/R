# APS 3 Econometria

# Pacotes necessários
library(tidyverse)
library(gt)
library(readxl)
library(moments)
library(lmtest)
library(dplyr)

# Importação e preparação de dados
dados <- read_excel("APS econo.xlsx") %>%
  mutate(
    Hom = Hom,
    ln_Guns = log(Guns),
    ln_IpC = log(IpC)
  )

# Estimação do modelo
modelo <- lm(Hom ~ ln_Guns + ln_IpC + Urb + Poli + Gini, data = dados)
summary(modelo)

# Tabela de resultados do modelo
coef_df <- broom::tidy(modelo) %>%
  mutate(Significance = case_when(
    p.value < 0.001 ~ "***",
    p.value < 0.01 ~ "**",
    p.value < 0.05 ~ "*",
    p.value < 0.1 ~ ".",
    TRUE ~ ""
  ))

gt_table <- gt(coef_df) %>%
  tab_style(
    style = cell_text(weight = "bold", align = "center"),
    locations = cells_column_labels(columns = everything())
  )
print(gt_table)

# Análise dos resíduos
residuos <- residuals(modelo)

# Histograma dos resíduos
ggplot(data = data.frame(residuos), aes(x = residuos)) +
  geom_histogram(aes(y = ..density..), binwidth = 1, fill = "lightblue", color = "black") +
  geom_density(color = "darkblue") +
  labs(title = "Histograma dos Resíduos", x = "Resíduos", y = "Densidade") +
  theme_minimal()

# Teste de normalidade dos resíduos
jarque.test(residuos)

# Gráficos de dispersão dos resíduos
df_residuos <- data.frame(Residuos = residuos, Residuos_2 = residuos^2)

ggplot(df_residuos, aes(x = 1:length(Residuos), y = Residuos)) +
  geom_point(size = 2, color = "blue") +
  theme_minimal() +
  labs(
    x = "Observação",
    y = "Resíduos",
    title = "Gráfico de Dispersão dos Resíduos",
    subtitle = "Resíduos plotados contra observações"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 12)
  )

ggplot(df_residuos, aes(x = 1:length(Residuos_2), y = Residuos_2)) +
  geom_point(size = 2, color = "red") +
  theme_minimal() +
  labs(
    x = "Observação",
    y = "Resíduos ao Quadrado",
    title = "Gráfico de Dispersão dos Resíduos ao Quadrado",
    subtitle = "Resíduos ao Quadrado plotados contra observações"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 12)
  )

bptest(modelo)

# Previsões
# Previsão do modelo com ln_IpC
modelo_simples <- lm(Hom ~ ln_IpC, data = dados)

previsoes_simples <- predict(modelo_simples, newdata = dados, interval = "confidence")

dados <- dados %>% 
  mutate(
    fit_simples = previsoes_simples[, "fit"],
    lwr_simples = previsoes_simples[, "lwr"],
    upr_simples = previsoes_simples[, "upr"]
  )

grafico_previsao <- ggplot(dados, aes(x = ln_IpC, y = Hom)) +
  geom_point(color = "darkgreen", size = 2) +
  geom_line(aes(y = fit_simples), color = "red", size = 1) +
  geom_ribbon(aes(ymin = lwr_simples, ymax = upr_simples), alpha = 0.3, fill = "lightblue") +
  labs(
    title = "Previsão do Modelo de Regressão Simples",
    subtitle = "Modelo com Intercepto e ln_IpC",
    x = "Log do IPC",
    y = "Homicídios",
    caption = "Fonte: Próprios Autores"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "darkblue"),
    plot.subtitle = element_text(size = 12, color = "darkblue"),
    plot.caption = element_text(size = 10, hjust = 1, color = "grey50"),
    axis.title = element_text(face = "bold", size = 12, color = "darkblue"),
    axis.text = element_text(size = 10, color = "black")
  )
print(grafico_previsao)

# Previsão do Modelo com Poli
modelo_simples_poli <- lm(Hom ~ Poli, data = dados)

previsoes_simples_poli <- predict(modelo_simples_poli, newdata = dados, interval = "confidence")

dados <- dados %>% 
  mutate(
    fit_simples_poli = previsoes_simples_poli[, "fit"],
    lwr_simples_poli = previsoes_simples_poli[, "lwr"],
    upr_simples_poli = previsoes_simples_poli[, "upr"]
  )

grafico_previsao_poli <- ggplot(dados, aes(x = Poli, y = Hom)) +
  geom_point(color = "darkgreen", size = 2) +
  geom_line(aes(y = fit_simples_poli), color = "red", size = 1) +
  geom_ribbon(aes(ymin = lwr_simples_poli, ymax = upr_simples_poli), alpha = 0.3, fill = "lightblue") +
  labs(
    title = "Previsão do Modelo de Regressão Simples",
    subtitle = "Modelo com Intercepto e Poli",
    x = "Policiamento",
    y = "Homicídios",
    caption = "Fonte: Próprios Autores"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "darkblue"),
    plot.subtitle = element_text(size = 12, color = "darkblue"),
    plot.caption = element_text(size = 10, hjust = 1, color = "grey50"),
    axis.title = element_text(face = "bold", size = 12, color = "darkblue"),
    axis.text = element_text(size = 10, color = "black")
  )
print(grafico_previsao_poli)

# Previsão do Modelo com Gini
modelo_simples_gini <- lm(Hom ~ Gini, data = dados)

previsoes_simples_gini <- predict(modelo_simples_gini, newdata = dados, interval = "confidence")

dados <- dados %>% 
  mutate(
    fit_simples_gini = previsoes_simples_gini[, "fit"],
    lwr_simples_gini = previsoes_simples_gini[, "lwr"],
    upr_simples_gini = previsoes_simples_gini[, "upr"]
  )

grafico_previsao_gini <- ggplot(dados, aes(x = Gini, y = Hom)) +
  geom_point(color = "darkgreen", size = 2) +
  geom_line(aes(y = fit_simples_gini), color = "red", size = 1) +
  geom_ribbon(aes(ymin = lwr_simples_gini, ymax = upr_simples_gini), alpha = 0.3, fill = "lightblue") +
  labs(
    title = "Previsão do Modelo de Regressão Simples",
    subtitle = "Modelo com Intercepto e Gini",
    x = "Índice de Gini",
    y = "Homicídios",
    caption = "Fonte: Próprios Autores"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "darkblue"),
    plot.subtitle = element_text(size = 12, color = "darkblue"),
    plot.caption = element_text(size = 10, hjust = 1, color = "grey50"),
    axis.title = element_text(face = "bold", size = 12, color = "darkblue"),
    axis.text = element_text(size = 10, color = "black")
  )
print(grafico_previsao_gini)

# Previsão do Modelo com as observações
dados <- dados %>%
  mutate(Index = row_number(),
         Predicted_Hom = predict(modelo, newdata = dados))

ggplot(dados, aes(x = Index)) +
  geom_point(aes(y = Hom), color = "darkgreen", size = 2) +
  geom_line(aes(y = Predicted_Hom), color = "red", size = 1) +
  labs(
    title = "Visualização de Observações e Previsões de Homicídios",
    subtitle = "Dados Observados e Linha de Regressão Ajustada",
    x = "Índice da Observação",
    y = "Homicídios",
    caption = "Fonte: Base de dados própria"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "darkblue"),
    plot.subtitle = element_text(size = 12, color = "darkblue"),
    plot.caption = element_text(size = 10, hjust = 1, color = "grey50"),
    axis.title = element_text(face = "bold", size = 12, color = "darkblue"),
    axis.text = element_text(size = 10, color = "black")
  )
