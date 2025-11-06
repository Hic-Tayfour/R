# ============================================================================
# Conformal Prediction para ITE - DGP Carlos Carvalho, "Bayesian Regression Tree                                                             Models for Causal Inference"
# Baseado em Lei & Candès (2021)
# ============================================================================

# Bibliotecas e Semente

library(patchwork)
library(tidyverse)
library(showtext)
library(mvtnorm)
library(ranger)
library(scales)   
library(MASS)
set.seed(42)


# Definindo funções gráficas ----
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

# ----

# ---------------------------
# 1) DGP
# ---------------------------
dgp <- function(n = 1e3, true_tau = 3, stdev = 1, return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  x3 <- rnorm(n)
  x4 <- sample(1:3, n, replace = TRUE)
  x5 <- rbinom(n, 1, 0.5)
  
  g_x4 <- ifelse(x4 == 1, 2, ifelse(x4 == 2, -1, -4))
  mu <- 1 + g_x4 + x1 * x3
  
  s <- sd(mu)
  u <- runif(n, 0, 1)
  pi <- 0.8 * pnorm(3 * mu / s - 0.5 * x1) + 0.05 + u / 10
  pi <- pmin(pmax(pi, 0.01), 0.99)
  
  t  <- rbinom(n, size = 1, prob = pi)
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y  <- ifelse(t == 0, y0, y1)
  
  if (!return_counterfactuals) return(data.frame(x1, x2, x3, x4 = factor(x4), x5, t, y))
  tibble(x1, x2, x3, x4 = factor(x4), x5, t, y0, y1, y)
}

# ---------------------------
# 2) Configuração
# ---------------------------
set.seed(42)
n_train  <- 1500
n_test   <- 8000
alpha    <- 0.10
alpha_out <- alpha / 2
true_tau <- 3
stdev    <- 1

# ---------------------------
# 3) Dados
# ---------------------------
df <- dgp(n_train, true_tau = true_tau, stdev = stdev, 
          return_counterfactuals = TRUE)

idx_tr <- sample.int(nrow(df), size = floor(0.75 * nrow(df)))
trn <- df[idx_tr, ]
cal <- df[-idx_tr, ]

# ---------------------------
# 4) Propensity Score (para ponderação)
# ---------------------------
rf_ps <- ranger(
  formula = factor(t) ~ x1 + x2 + x3 + x4 + x5,
  data = trn,
  probability = TRUE
)

ps_cal <- predict(rf_ps, data = cal)$predictions[, "1"]
ps_cal <- pmin(pmax(ps_cal, 1e-6), 1 - 1e-6)

cal$ehat <- ps_cal
cal$w1 <- 1 / cal$ehat
cal$w0 <- 1 / (1 - cal$ehat)

# ---------------------------
# 5) PASSO 1: Treinar μ̂(x,t) - MODELO ÚNICO com split forçado
# ---------------------------
rf_mu <- ranger(
  formula = y ~ x1 + x2 + x3 + x4 + x5 + t,
  data = trn,
  always.split.variables = "t",
  split.select.weights = c(x1 = 0.01, x2 = 0.01, x3 = 0.01, 
                           x4 = 0.01, x5 = 0.01, t = 1000)
)

# ---------------------------
# 6) PASSO 2: Estimar σ̂(x,t) - resíduos com MODELO ÚNICO
# ---------------------------
mu_hat_trn <- predict(rf_mu, data = trn)$predictions

trn_res <- trn %>%
  mutate(delta = abs(y - mu_hat_trn)) %>%
  dplyr::select(x1, x2, x3, x4, x5, t, delta)

rf_sigma <- ranger(
  formula = delta ~ x1 + x2 + x3 + x4 + x5 + t,
  data = trn_res,
  always.split.variables = "t",
  split.select.weights = c(x1 = 0.01, x2 = 0.01, x3 = 0.01, 
                           x4 = 0.01, x5 = 0.01, t = 1000)
)

# ---------------------------
# 7) PASSO 3: Calibração com scores NORMALIZADOS - POR BRAÇO
# ---------------------------
cal_t1 <- cal %>% mutate(t = 1)
cal_t0 <- cal %>% mutate(t = 0)

mu_hat_cal1 <- predict(rf_mu, data = cal_t1)$predictions
mu_hat_cal0 <- predict(rf_mu, data = cal_t0)$predictions

sigma_hat_cal1 <- pmax(predict(rf_sigma, data = cal_t1)$predictions, 0.01)
sigma_hat_cal0 <- pmax(predict(rf_sigma, data = cal_t0)$predictions, 0.01)

# Função auxiliar para quantil ponderado
weighted_quantile <- function(values, weights, probs) {
  ok <- is.finite(values) & is.finite(weights) & (weights > 0)
  if (sum(ok) == 0) return(NA_real_)
  
  v <- values[ok]
  w <- weights[ok]
  ord <- order(v)
  v_sorted <- v[ord]
  w_sorted <- w[ord]
  cum_w <- cumsum(w_sorted) / sum(w_sorted)
  
  idx <- which(cum_w >= probs)[1]
  if (is.na(idx)) return(v_sorted[length(v_sorted)])
  return(v_sorted[idx])
}

# --- Tratados (t=1 observado) ---
idx1 <- cal$t == 1
R1 <- abs(cal$y[idx1] - mu_hat_cal1[idx1]) / sigma_hat_cal1[idx1]
r_hat1 <- weighted_quantile(R1, cal$w1[idx1], probs = 1 - alpha_out)

# --- Controles (t=0 observado) ---
idx0 <- cal$t == 0
R0 <- abs(cal$y[idx0] - mu_hat_cal0[idx0]) / sigma_hat_cal0[idx0]
r_hat0 <- weighted_quantile(R0, cal$w0[idx0], probs = 1 - alpha_out)

cat("r_hat1 (tratados):", r_hat1, "\n")
cat("r_hat0 (controles):", r_hat0, "\n")

# ---------------------------
# 8) PASSO 4: Intervalos ADAPTATIVOS no teste
# ---------------------------
te <- dgp(n_test, true_tau = true_tau, stdev = stdev, 
          return_counterfactuals = TRUE)

# Predições contrafactuais no teste
te_t1 <- te %>% 
  mutate(t = 1) %>% 
  dplyr::select(x1, x2, x3, x4, x5, t)

te_t0 <- te %>% 
  mutate(t = 0) %>% 
  dplyr::select(x1, x2, x3, x4, x5, t)

mu_hat1_te <- predict(rf_mu, data = te_t1)$predictions
mu_hat0_te <- predict(rf_mu, data = te_t0)$predictions

sigma_hat1_te <- pmax(predict(rf_sigma, data = te_t1)$predictions, 0.01)
sigma_hat0_te <- pmax(predict(rf_sigma, data = te_t0)$predictions, 0.01)

# Intervalos adaptativos
L1 <- mu_hat1_te - r_hat1 * sigma_hat1_te
U1 <- mu_hat1_te + r_hat1 * sigma_hat1_te

L0 <- mu_hat0_te - r_hat0 * sigma_hat0_te
U0 <- mu_hat0_te + r_hat0 * sigma_hat0_te

# Intervalo ITE
L_ITE <- L1 - U0
U_ITE <- U1 - L0

# ---------------------------
# 9) Métricas
# ---------------------------
ITE_true <- te$y1 - te$y0
covered <- (ITE_true >= L_ITE) & (ITE_true <= U_ITE)
coverage <- mean(covered)
ITE_pred <- mu_hat1_te - mu_hat0_te

is_trivial <- is.infinite(L_ITE) | is.infinite(U_ITE)
trivial_pct <- mean(is_trivial)

lengths <- U_ITE - L_ITE
avg_len <- mean(lengths[is.finite(lengths)])

cat(sprintf("\nCobertura ITE (target %.0f%%): %.3f\n", (1 - alpha) * 100, coverage))
cat(sprintf("Intervalos triviais: %.3f\n", trivial_pct))
cat(sprintf("Comprimento médio: %.3f\n", avg_len))


# ---------------------------
# 10) ANÁLISE VISUAL COMPLETA
# ---------------------------

# Preparar dados para análise
df_results <- tibble(
  ITE_true = ITE_true,
  ITE_pred = ITE_pred,
  largura = lengths,
  covered = covered,
  L_ITE = L_ITE,
  U_ITE = U_ITE,
  sigma_hat1 = sigma_hat1_te,  
  sigma_hat0 = sigma_hat0_te,
  x1 = te$x1,
  x2 = te$x2,
  x3 = te$x3,
  x4 = te$x4,
  x5 = te$x5
)

# Estatísticas básicas das larguras
cat("\n========== ANÁLISE DE LARGURAS ==========\n")
cat(sprintf("Desvio padrão das larguras: %.4f\n", sd(lengths[is.finite(lengths)])))
cat(sprintf("Min largura: %.3f\n", min(lengths[is.finite(lengths)])))
cat(sprintf("Max largura: %.3f\n", max(lengths[is.finite(lengths)])))
cat("\nResumo das larguras:\n")
print(summary(lengths[is.finite(lengths)]))

# ---------------------------
# GRÁFICO 1: Distribuição do ITE verdadeiro
# ---------------------------
df_results %>%
  ggplot(aes(x = ITE_true)) +
  geom_histogram(bins = 50, fill = econ_colors$main["blue1"], 
                 color = "white", alpha = 0.9) +
  geom_vline(xintercept = true_tau, 
             color = econ_colors$main["econ_red"],
             linewidth = 1.2, linetype = "dashed") +
  annotate("text", x = true_tau - 0.3, y = Inf, 
           label = paste0("τ = ", true_tau),
           vjust = 1.5, hjust = 1, 
           color = econ_colors$main["econ_red"],
           size = 4, fontface = "bold") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Distribuição do efeito individual verdadeiro (homogêneo)",
    subtitle = sprintf("ITE = Y(1) - Y(0) | Média: %.2f, DP: %.2f", 
                       mean(ITE_true), sd(ITE_true)),
    x = "ITE verdadeiro",
    y = "Frequência",
    caption = "Fonte: DGP Hahn et al. (2020) - Linear + Homogêneo"
  ) +
  theme_econ_base()


# ---------------------------
# GRÁFICO 2: Predição vs Verdadeiro
# ---------------------------
df_results %>%
  ggplot(aes(x = ITE_true, y = ITE_pred, color = covered)) +
  geom_point(alpha = 0.4, size = 1.5) +
  geom_abline(slope = 1, intercept = 0, 
              color = econ_colors$neutral["grey_text"],
              linewidth = 0.8, linetype = "dashed") +
  scale_econ("colour", "scatter") +
  scale_x_continuous(labels = fmt_lab("number")) +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Predição vs realidade do efeito individual",
    subtitle = sprintf("Cobertura: %.1f%% | Correlação: %.3f | RMSE: %.3f",
                       coverage * 100, 
                       cor(ITE_true, ITE_pred),
                       (sqrt(mean((ITE_pred - ITE_true)^2))
    )),
    x = "ITE verdadeiro",
    y = "ITE predito (μ̂(x,1) - μ̂(x,0))",
    color = "Intervalo\ncobriu?",
    caption = "Linha tracejada: predição perfeita | Targeted selection ativo"
  ) +
  theme_econ_base() +
  theme(legend.position = "right")


# ---------------------------
# GRÁFICO 3: Distribuição das larguras
# ---------------------------
df_results %>%
  filter(is.finite(largura)) %>%
  ggplot(aes(x = largura)) +
  geom_histogram(bins = 50, 
                 fill = econ_colors$main["blue2"], 
                 color = "white", alpha = 0.9) +
  geom_vline(xintercept = avg_len,
             color = econ_colors$main["econ_red"],
             linewidth = 1.2, linetype = "dashed") +
  annotate("text", 
           x = avg_len + 0.5, 
           y = Inf,
           label = sprintf("Média: %.2f", avg_len),
           vjust = 1.5, hjust = 0,
           color = econ_colors$main["econ_red"],
           size = 4, fontface = "bold") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Larguras dos intervalos de predição individuais",
    subtitle = sprintf("Min: %.2f | Mediana: %.2f | Max: %.2f | DP: %.2f",
                       min(lengths[is.finite(lengths)]),
                       median(lengths[is.finite(lengths)]),
                       max(lengths[is.finite(lengths)]),
                       sd(lengths[is.finite(lengths)])),
    x = "Largura do intervalo (U - L)",
    y = "Frequência",
    caption = "Intervalos adaptativos com ponderação IPW | Split forçado em T"
  ) +
  theme_econ_base()


# ---------------------------
# GRÁFICO 4: Cobertura por decil
# ---------------------------
df_decil <- df_results %>%
  mutate(decil = ntile(ITE_true, 10)) %>%
  group_by(decil) %>%
  summarise(
    cobertura = mean(covered),
    ite_medio = mean(ITE_true),
    largura_media = mean(largura[is.finite(largura)]),
    n = n(),
    .groups = "drop"
  )

df_decil %>%
  ggplot(aes(x = factor(decil), y = cobertura)) +
  geom_col(fill = econ_colors$main["blue1"], alpha = 0.9, width = 0.7) +
  geom_hline(yintercept = 1 - alpha,
             color = econ_colors$main["econ_red"],
             linewidth = 1, linetype = "dashed") +
  annotate("text", x = 10, y = 1 - alpha,
           label = sprintf("Alvo: %.0f%%", (1 - alpha) * 100),
           vjust = -0.5, hjust = 1,
           color = econ_colors$main["econ_red"],
           size = 3.5, fontface = "bold") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     limits = c(0, 1.05)) +
  labs(
    title = "Cobertura condicional por decil de ITE",
    subtitle = "Verificação de calibração: cobertura deve ser uniforme",
    x = "Decil do ITE verdadeiro",
    y = "Taxa de cobertura",
    caption = "Efeito homogêneo → cobertura deve ser constante entre decis"
  ) +
  theme_econ_base()


# ---------------------------
# GRÁFICO 5: Largura vs Incerteza estimada
# ---------------------------
df_sigma <- df_results %>%
  filter(is.finite(largura)) %>%
  mutate(sigma_media = (sigma_hat1 + sigma_hat0) / 2) %>%
  {if (nrow(.) > 2000) slice_sample(., n = 2000) else .} 

cor_sigma_largura <- cor(df_sigma$sigma_media, df_sigma$largura)

df_sigma %>%
  ggplot(aes(x = sigma_media, y = largura)) +
  geom_point(alpha = 0.3, size = 1.5, 
             color = econ_colors$main["blue2"]) +
  geom_smooth(method = "loess", se = TRUE,
              color = econ_colors$main["econ_red"],
              fill = econ_colors$main["red1"],
              alpha = 0.2, linewidth = 1) +
  scale_x_continuous(labels = fmt_lab("number")) +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Largura adaptativa responde à incerteza local",
    subtitle = sprintf("Intervalos mais largos onde σ̂(x,t) é maior | Correlação: %.3f",
                       cor_sigma_largura),
    x = "Variância condicional média: [σ̂(x,1) + σ̂(x,0)] / 2",
    y = "Largura do intervalo",
    caption = "Adaptatividade via normalização por σ̂(x,t)"
  ) +
  theme_econ_base()



# ---------------------------
# GRÁFICO 6: Resumo de métricas
# ---------------------------
metricas <- tibble(
  metrica = c("Cobertura", "Largura\nmédia", "% Intervalos\ntriviais"),
  valor = c(coverage, avg_len / 10, trivial_pct), 
  alvo = c(1 - alpha, NA, 0),
  tipo = c("Cobertura", "Eficiência", "Qualidade")
)

metricas %>%
  ggplot(aes(x = metrica, y = valor, fill = tipo)) +
  geom_col(alpha = 0.9, width = 0.7) +
  geom_point(aes(y = alvo), 
             color = econ_colors$main["econ_red"],
             size = 5, shape = 18,
             na.rm = TRUE) +
  geom_text(aes(label = sprintf("%.2f", valor)),
            vjust = -0.5, fontface = "bold",
            size = 4.5) +
  scale_econ("fill", "bars") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Resumo de performance do método",
    subtitle = "Diamante vermelho indica valor-alvo quando aplicável",
    x = NULL,
    y = "Valor",
    fill = "Categoria",
    caption = sprintf("DGP: Linear + Homogêneo | n_treino=%d | n_teste=%d | α=%.0f%%",
                      n_train, n_test, alpha * 100)
  ) +
  theme_econ_base() +
  theme(legend.position = "top")



# ---------------------------
# GRÁFICO EXTRA: Cobertura por covariável categórica X4
# ---------------------------
df_x4 <- df_results %>%
  group_by(x4) %>%
  summarise(
    cobertura = mean(covered),
    largura_media = mean(largura[is.finite(largura)]),
    n = n(),
    .groups = "drop"
  )

df_x4 %>%
  ggplot(aes(x = x4, y = cobertura)) +
  geom_col(fill = econ_colors$main["blue1"], alpha = 0.9, width = 0.6) +
  geom_hline(yintercept = 1 - alpha,
             color = econ_colors$main["econ_red"],
             linewidth = 1, linetype = "dashed") +
  geom_text(aes(label = sprintf("%.1f%%", cobertura * 100)),
            vjust = -0.5, fontface = "bold", size = 4) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     limits = c(0, 1.05)) +
  labs(
    title = "Cobertura condicional por nível de X₄",
    subtitle = "X₄ entra em μ(x) via g(X₄) = {2, -1, -4} para níveis {1, 2, 3}",
    x = "Nível da covariável categórica X₄",
    y = "Taxa de cobertura",
    caption = sprintf("Linha vermelha: %.0f%% | n por grupo: %s",
                      (1 - alpha) * 100,
                      paste(df_x4$n, collapse = ", "))
  ) +
  theme_econ_base()



# ---------------------------
# GRÁFICO EXTRA: Bias por região do propensity score
# ---------------------------
te_ps <- predict(rf_ps, data = te)$predictions[, "1"]
te_ps <- pmin(pmax(te_ps, 1e-6), 1 - 1e-6)

df_ps_analysis <- df_results %>%
  mutate(
    ps_hat = te_ps,
    ps_quartil = cut(ps_hat, 
                     breaks = quantile(ps_hat, c(0, 0.25, 0.5, 0.75, 1)),
                     include.lowest = TRUE,
                     labels = c("Q1\n(baixo)", "Q2", "Q3", "Q4\n(alto)"))
  ) %>%
  group_by(ps_quartil) %>%
  summarise(
    bias = mean(ITE_pred - ITE_true),
    cobertura = mean(covered),
    largura = mean(largura[is.finite(largura)]),
    n = n(),
    .groups = "drop"
  )

df_ps_analysis %>%
  ggplot(aes(x = ps_quartil, y = bias)) +
  geom_col(fill = econ_colors$main["blue2"], alpha = 0.9, width = 0.6) +
  geom_hline(yintercept = 0,
             color = econ_colors$neutral["grey_text"],
             linewidth = 0.8, linetype = "dashed") +
  geom_text(aes(label = sprintf("%.3f", bias)),
            vjust = ifelse(df_ps_analysis$bias > 0, -0.5, 1.5),
            fontface = "bold", size = 4) +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Viés da predição por quartil do propensity score",
    subtitle = "Targeted selection pode causar viés diferencial por região do PS",
    x = "Quartil do π̂(x) estimado",
    y = "Viés médio (predito - verdadeiro)",
    caption = "PS baixo = menor prob. de tratamento | PS alto = maior prob. de tratamento"
  ) +
  theme_econ_base()



# ---------------------------
# TABELA RESUMO
# ---------------------------
cat("\n========== RESUMO POR QUARTIL DE PS ==========\n")
print(df_ps_analysis, n = 4)
