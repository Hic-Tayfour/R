# ============================================================================
# Conformal Prediction para ITE - DGP Paulo Cilas Marques Filho (dgp.R)
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
dgp <- function(n = 1e3, true_tau = -1, stdev = 0.7, return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  mu <- ifelse(x1 < x2, 3, -1)
  t  <- rbinom(n, size = 1, prob = pnorm(mu))
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y  <- ifelse(t == 0, y0, y1)
  if (!return_counterfactuals) return(data.frame(x1, x2, t, y))
  tibble(x1, x2, t, y0, y1, y)
}

# ---------------------------
# 2) Configuração
# ---------------------------
set.seed(42)
n_train  <- 1500
n_test   <- 8000
alpha    <- 0.10
alpha_out <- alpha / 2
true_tau <- -1
stdev    <- 0.7

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
  formula = factor(t) ~ x1 + x2,
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
  formula = y ~ x1 + x2 + t,
  data = trn,
  always.split.variables = "t",
  split.select.weights = c(x1 = 0.01, x2 = 0.01, t = 1000)
  )

# ---------------------------
# 6) PASSO 2: Estimar σ̂(x,t) - resíduos com MODELO ÚNICO
# ---------------------------
# Predições no treino
mu_hat_trn <- predict(rf_mu, data = trn)$predictions

# Calcular resíduos absolutos
trn_res <- trn %>%
  mutate(delta = abs(y - mu_hat_trn)) %>%
  dplyr::select(x1, x2, t, delta)

# Treinar modelo de resíduos (também com split forçado)
rf_sigma <- ranger(
  formula = delta ~ x1 + x2 + t,
  data = trn_res,
  always.split.variables = "t",
  split.select.weights = c(x1 = 0.01, x2 = 0.01, t = 1000)
)

# ---------------------------
# 7) PASSO 3: Calibração com scores NORMALIZADOS - POR BRAÇO
# ---------------------------
# Predições contrafactuais na calibração (para todos)
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
te_t1 <- te %>% mutate(t = 1) %>% dplyr::select(x1, x2, t)
te_t0 <- te %>% mutate(t = 0) %>% dplyr::select(x1, x2, t)

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
# 10) VERIFICAR LARGURAS VARIÁVEIS
# ---------------------------

cat(sprintf("\nDesvio padrão das larguras: %.4f\n", sd(lengths[is.finite(lengths)])))
cat(sprintf("Min largura: %.3f\n", min(lengths[is.finite(lengths)])))
cat(sprintf("Max largura: %.3f\n", max(lengths[is.finite(lengths)])))
cat("Resumo das larguras:\n")
print(summary(lengths[is.finite(lengths)]))


# Comparar ITE verdadeiro vs predito
df_results <- tibble(
  ITE_true = ITE_true,
  ITE_pred = mu_hat1_te - mu_hat0_te,
  largura = U_ITE - L_ITE,
  covered = covered,
  L_ITE = L_ITE,
  U_ITE = U_ITE,
  sigma_hat1 = sigma_hat1_te,  
  sigma_hat0 = sigma_hat0_te   
)

df_results %>%
  ggplot(aes(x = ITE_true)) +
  geom_histogram(bins = 50, fill = econ_colors$main["blue1"], 
                 color = "white", alpha = 0.9) +
  geom_vline(xintercept = true_tau, 
             color = econ_colors$main["econ_red"],
             linewidth = 1.2, linetype = "dashed") +
  annotate("text", x = true_tau - 0.3, y = Inf, 
           label = paste0("CATE = ", true_tau),
           vjust = 1.5, hjust = 1, 
           color = econ_colors$main["econ_red"],
           size = 4, fontface = "bold") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Distribuição do efeito individual verdadeiro",
    subtitle = sprintf("ITE = Y(1) - Y(0) | Média: %.2f, DP: %.2f", 
                       mean(ITE_true), sd(ITE_true)),
    x = "ITE verdadeiro",
    y = "Frequência",
    caption = "Fonte: Simulação DGP | Lei & Candès (2021)"
  ) +
  theme_econ_base()

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
    subtitle = sprintf("Cobertura: %.1f%% | Correlação: %.3f",
                       coverage * 100, 
                       cor(ITE_true, ITE_pred)),
    x = "ITE verdadeiro",
    y = "ITE predito ",
    color = "Intervalo\ncobriu?",
    caption = "Linha tracejada: predição perfeita"
  ) +
  theme_econ_base() +
  theme(legend.position = "right")

df_results %>%
  filter(is.finite(largura)) %>%
  ggplot(aes(x = largura)) +
  geom_histogram(bins = 50, 
                 fill = econ_colors$main["blue2"], 
                 color = "white", alpha = 0.9) +
  geom_vline(xintercept = mean(df_results$largura[is.finite(df_results$largura)]),
             color = econ_colors$main["econ_red"],
             linewidth = 1.2, linetype = "dashed") +
  annotate("text", 
           x = mean(df_results$largura[is.finite(df_results$largura)]) + 0.5, 
           y = Inf,
           label = sprintf("Média: %.2f", avg_len),
           vjust = 1.5, hjust = 0,
           color = econ_colors$main["econ_red"],
           size = 4, fontface = "bold") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Larguras dos intervalos de predição variam",
    subtitle = sprintf("Min: %.2f | Mediana: %.2f | Max: %.2f | DP: %.2f",
                       min(lengths[is.finite(lengths)]),
                       median(lengths[is.finite(lengths)]),
                       max(lengths[is.finite(lengths)]),
                       sd(lengths[is.finite(lengths)])),
    x = "Largura do intervalo (U - L)",
    y = "Frequência",
    caption = "Intervalos adaptativos com ponderação IPW"
  ) +
  theme_econ_base()

df_decil <- df_results %>%
  mutate(decil = ntile(ITE_true, 10)) %>%
  group_by(decil) %>%
  summarise(
    cobertura = mean(covered),
    ite_medio = mean(ITE_true),
    n = n(),
    .groups = "drop"
  )

df_decil %>%
  ggplot(aes(x = factor(decil), y = cobertura)) +
  geom_col(fill = econ_colors$main["blue1"], alpha = 0.9) +
  geom_hline(yintercept = 1 - alpha,
             color = econ_colors$main["econ_red"],
             linewidth = 1, linetype = "dashed") +
  annotate("text", x = 10, y = 1 - alpha,
           label = sprintf("Alvo: %.0f%%", (1 - alpha) * 100),
           vjust = -0.5, hjust = 1,
           color = econ_colors$main["econ_red"],
           size = 3.5, fontface = "bold") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     limits = c(0, 1)) +
  labs(
    title = "Cobertura condicional por decil de ITE",
    subtitle = "Verificação da uniformidade da cobertura",
    x = "Decil do ITE verdadeiro",
    y = "Taxa de cobertura",
    caption = "Linha vermelha: cobertura nominal (90%)"
  ) +
  theme_econ_base()

df_sigma <- df_results %>%
  filter(is.finite(largura)) %>%
  mutate(sigma_media = (sigma_hat1 + sigma_hat0) / 2) %>%
  {if (nrow(.) > 2000) slice_sample(., n = 2000) else .} 

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
    subtitle = "Intervalos mais largos onde o modelo prevê maior variância",
    x = "Variância condicional estimada σ̂(x)",
    y = "Largura do intervalo",
    caption = "Correlação positiva indica adaptatividade"
  ) +
  theme_econ_base()


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
             size = 4, shape = 18,
             na.rm = TRUE) +
  geom_text(aes(label = sprintf("%.2f", valor)),
            vjust = -0.5, fontface = "bold",
            size = 4) +
  scale_econ("fill", "bars") +
  scale_y_continuous(labels = fmt_lab("number")) +
  labs(
    title = "Resumo de performance do método",
    subtitle = "Diamante vermelho indica valor-alvo quando aplicável",
    x = NULL,
    y = "Valor",
    fill = "Categoria",
    caption = sprintf("n_treino=%d | n_teste=%d | α=%.0f%%",
                      n_train, n_test, alpha * 100)
  ) +
  theme_econ_base() +
  theme(legend.position = "top")
