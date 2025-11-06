# ============================================================================
# Conformal Prediction para ITE - DGP Paulo Cilas Marques Filho (dgp.R)
# Baseado em Lei & Candès (2021)
# ============================================================================

library(patchwork)
library(tidyverse)
library(showtext)
library(mvtnorm)
library(ranger)
library(scales)
library(MASS)

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

dgp <- function(n, mu_x, Sigma_x, true_tau = NA, stdev = 1, return_counterfactuals = FALSE) {
  d <- ncol(Sigma_x)
  R <- cov2cor(Sigma_x)                # usa apenas correlação
  Z <- MASS::mvrnorm(n, mu = rep(0, d), Sigma = R)
  X <- pnorm(Z)
  colnames(X) <- paste0("x", seq_len(d))
  x1 <- X[, 1]; x2 <- X[, 2]
  
  f <- function(x) 2 / (1 + exp(-12 * (x - 0.5)))
  mu1 <- f(x1) * f(x2)
  sigma <- 1
  Y0 <- rep(0, n)
  Y1 <- mu1 + sigma * rnorm(n)
  
  propensity_score <- 0.25 * (1 + pbeta(x1, 2, 4))
  t <- rbinom(n, size = 1, prob = propensity_score)
  Y <- ifelse(t == 1, Y1, Y0)
  
  if (!return_counterfactuals) {
    return(data.frame(x1 = x1, x2 = x2, treatment = t, Y = Y))
  }
  data.frame(
    x1 = x1, x2 = x2,
    Y0 = Y0, Y1 = Y1,
    tau_true = Y1 - Y0,                 # == Y1
    propensity_score = propensity_score,
    treatment = t, Y = Y
  )
}

# ---------------------------
# Razão de densidade conhecida w_known (CORRIGIDO para Gaussian copula)
# w(x) = c_{Sigma_tilde}(x) / c_{Sigma}(x),
# com z = qnorm(x) e c_R(u) = |R|^{-1/2} * exp(-1/2 z^T (R^{-1}-I) z)
density_ratio <- function(x, mu, Sigma, mu_tilde, Sigma_tilde) {
  z <- qnorm(x)
  R  <- cov2cor(Sigma)
  Rt <- cov2cor(Sigma_tilde)
  # log c_R(u)
  logc <- function(z, R) {
    # -0.5*log|R| - 0.5 * z^T (R^{-1} - I) z
    as.numeric(-0.5 * log(det(R)) - 0.5 * t(z) %*% (solve(R) - diag(length(z))) %*% z)
  }
  exp(logc(z, Rt) - logc(z, R))
}
w_known <- function(x) density_ratio(x, mu, Sigma, mu_tilde, Sigma_tilde)

# ---------------------------
# Parâmetros (inalterado onde possível)
set.seed(42)
alpha <- 0.1
cover <- 1 - alpha

n_trn <- 750
n_cal <- 250
n_tst <- 10000

# "Sigma" controla APENAS a correlação (rho) do copulão; mu é ignorado.
mu <- c(0, 0)
Sigma <- matrix(c(1, 0.8,
                  0.8, 1), nrow = 2)

mu_tilde <- c(0, 0)
Sigma_tilde <- matrix(c(1, 0.6,
                        0.6, 1), nrow = 2)

# ---------------------------
# Gerar dados (com DGP da §3.6)
trn <- dgp(n_trn, mu, Sigma, return_counterfactuals = TRUE)
cal <- dgp(n_cal, mu, Sigma, return_counterfactuals = TRUE)
tst <- dgp(n_tst, mu_tilde, Sigma_tilde, return_counterfactuals = TRUE)

# ---------------------------
# Visualização (inalterada exceto cores/títulos)
df_plot <- rbind(transform(trn, set = "Treino"),
                 transform(tst, set = "Teste")) %>%
  mutate(set = factor(set, levels = c("Treino", "Teste")))

df_plot <- rbind(
  transform(trn, set = "Treino"),
  transform(tst, set = "Teste")
) %>% 
  mutate(set = factor(set, levels = c("Treino", "Teste")))

col_train <- unname(econ_colors$main["blue1"])
col_test <- unname(econ_colors$secondary["burgundy"])

p_main <- df_plot %>%
  ggplot(aes(x = x1, y = x2, color = set)) +
  stat_density_2d(linewidth = 0.7) +
  scale_color_manual(values = c("Treino" = col_train, "Teste" = col_test)) +
  labs(x = "x1", y = "x2") +
  theme_econ_base() +
  theme(legend.position = "none")

p_top <- df_plot %>%
  ggplot(aes(x = x1, fill = set)) +
  geom_density(alpha = 0.6) +
  scale_fill_manual(values = c("Treino" = col_train, "Teste" = col_test)) +
  theme_econ_base() +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none"
  )

p_right <- df_plot %>%
  ggplot(aes(x = x2, fill = set)) +
  geom_density(alpha = 0.6) +
  scale_fill_manual(values = c("Treino" = col_train, "Teste" = col_test)) +
  coord_flip() +
  theme_econ_base() +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(), 
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none"
  )

p_top + p_main + p_right +
  plot_layout(
    design = "
    A##
    BC#
    ",
    heights = c(1, 4), 
    widths = c(4, 1)
  ) +
  plot_annotation(
    title = "Distribuições conjuntas: Treino (Azul) vs. Teste (Roxo)",
    subtitle = "Contornos centrais e densidades marginais",
    caption = "Fonte : Dados Simulados",
    theme = theme_econ_base()
  )
#----

# =========================
# Caso 1: "Conhecido"
# =========================

# Split de treino por braço (inalterado)
trn_0 <- trn[trn$treatment == 0, ]
trn_1 <- trn[trn$treatment == 1, ]

# 1) Modelos para Y
rf_mu0 <- ranger(Y ~ x1 + x2, data = trn_0)
rf_mu1 <- ranger(Y ~ x1 + x2, data = trn_1)

# 2) Pseudo-contrafactuais
mu1_pred_on_0 <- predict(rf_mu1, data = trn_0)$predictions
D_0 <- mu1_pred_on_0 - trn_0$Y

mu0_pred_on_1 <- predict(rf_mu0, data = trn_1)$predictions
D_1 <- trn_1$Y - mu0_pred_on_1

trn_0_with_D <- trn_0 %>% mutate(D = D_0)
trn_1_with_D <- trn_1 %>% mutate(D = D_1)

# 3) Modelos para ITE
rf_tau0 <- ranger(D ~ x1 + x2, data = trn_0_with_D)
rf_tau1 <- ranger(D ~ x1 + x2, data = trn_1_with_D)

# 4) Resíduos |ITE| -> sigma-hat
tau0_hat_trn <- predict(rf_tau0, data = trn_0_with_D)$predictions
tau1_hat_trn <- predict(rf_tau1, data = trn_1_with_D)$predictions

trn_0_res <- data.frame(x1 = trn_0_with_D$x1, x2 = trn_0_with_D$x2,
                        resid = abs(trn_0_with_D$D - tau0_hat_trn))
trn_1_res <- data.frame(x1 = trn_1_with_D$x1, x2 = trn_1_with_D$x2,
                        resid = abs(trn_1_with_D$D - tau1_hat_trn))

rf_sigma0 <- ranger(resid ~ x1 + x2, data = trn_0_res)
rf_sigma1 <- ranger(resid ~ x1 + x2, data = trn_1_res)

# PS via RF (mantido — você não pediu para mudar a parte de PS/combinação)
rf_prop <- ranger(factor(treatment) ~ x1 + x2, data = trn, probability = TRUE)
e_hat_cal <- predict(rf_prop, data = cal)$predictions[, 2]
e_hat_tst <- predict(rf_prop, data = tst)$predictions[, 2]

# Predições ITE e sigma
tau0_cal <- predict(rf_tau0, data = cal)$predictions
tau1_cal <- predict(rf_tau1, data = cal)$predictions
tau0_tst <- predict(rf_tau0, data = tst)$predictions
tau1_tst <- predict(rf_tau1, data = tst)$predictions

sigma0_cal <- predict(rf_sigma0, data = cal)$predictions
sigma1_cal <- predict(rf_sigma1, data = cal)$predictions
sigma0_tst <- predict(rf_sigma0, data = tst)$predictions
sigma1_tst <- predict(rf_sigma1, data = tst)$predictions

tau_hat_cal <- (1 - e_hat_cal) * tau0_cal + e_hat_cal * tau1_cal
tau_hat_tst <- (1 - e_hat_tst) * tau0_tst + e_hat_tst * tau1_tst

sigma_hat_cal <- (1 - e_hat_cal) * sigma0_cal + e_hat_cal * sigma1_cal
sigma_hat_tst <- (1 - e_hat_tst) * sigma0_tst + e_hat_tst * sigma1_tst

# ---------- Ponto 3 (CORRIGIDO): Pesar/ordenar APENAS a calibração TRATADA ----------
idx_cal_treated <- which(cal$treatment == 1)

R_treated <- abs(cal$tau_true[idx_cal_treated] - tau_hat_cal[idx_cal_treated]) /
  pmax(sigma_hat_cal[idx_cal_treated], 1e-6)
R_sorted <- sort(R_treated)
R_order  <- order(R_treated)

# w_known por copula: usar apenas os tratados na calibração
w_cal_known_all <- apply(cal[, c("x1", "x2")], 1, w_known)
w_cal_known     <- w_cal_known_all[idx_cal_treated]
w_tst_known     <- apply(tst[, c("x1", "x2")], 1, w_known)

lower <- upper <- numeric(n_tst)
sum_w_cal <- sum(w_cal_known)
cover <- 1 - alpha

pb <- txtProgressBar(min = 1, max = n_tst, style = 3)
for (i in 1:n_tst) {
  p_cal <- w_cal_known / (sum_w_cal + w_tst_known[i])
  p_tst <- w_tst_known[i] / (sum_w_cal + w_tst_known[i])
  p <- c(p_cal[R_order], p_tst)
  k_hat <- which.max(cumsum(p) >= cover)
  s_hat <- if (k_hat == length(R_sorted) + 1) Inf else R_sorted[k_hat]
  lower[i] <- tau_hat_tst[i] - s_hat * sigma_hat_tst[i]
  upper[i] <- tau_hat_tst[i] + s_hat * sigma_hat_tst[i]
  setTxtProgressBar(pb, i)
}
close(pb)

sum_know <- sum(is.infinite(lower) & is.infinite(upper))
coverage_know <- mean((lower <= tst$tau_true) & (upper >= tst$tau_true))
range_know <- mean((upper - lower)[is.finite(upper) & is.finite(lower)])

# =========================
# Caso 2: "Mundo real" (w estimado por classificador) — Ponto 3 idem
# =========================

combined_X <- rbind(cal[, c("x1", "x2")], tst[, c("x1", "x2")])
is_test <- factor(c(rep(0, n_cal), rep(1, n_tst)))
classifier_data <- data.frame(combined_X, is_test)

rf_classifier <- ranger(is_test ~ ., data = classifier_data, probability = TRUE)
e_hat_combined <- predict(rf_classifier, data = classifier_data)$predictions[, 2]
e_hat_cal_w <- e_hat_combined[1:n_cal]
e_hat_tst_w <- e_hat_combined[(n_cal + 1):(n_cal + n_tst)]

epsilon <- 1e-6
w_cal_est_all <- (e_hat_cal_w / pmax(1 - e_hat_cal_w, epsilon)) * (n_cal / n_tst)
w_tst_est     <- (e_hat_tst_w / pmax(1 - e_hat_tst_w, epsilon)) * (n_cal / n_tst)

# usar apenas TRATADOS na calibração para pesar os R's

w_cal_est <- w_cal_est_all[idx_cal_treated]

lower <- upper <- numeric(n_tst)
sum_w_cal <- sum(w_cal_est)
cover <- 1 - alpha

cat("\nExecutando Conformal Loop (Pesos Estimados)...\n")

pb <- txtProgressBar(min = 1, max = n_tst, style = 3)
for (i in 1:n_tst) {
  p_cal <- w_cal_est / (sum_w_cal + w_tst_est[i])
  p_tst <- w_tst_est[i] / (sum_w_cal + w_tst_est[i])
  p <- c(p_cal[R_order], p_tst)
  k_hat <- which.max(cumsum(p) >= cover)
  s_hat <- if (k_hat == length(R_sorted) + 1) Inf else R_sorted[k_hat]
  lower[i] <- tau_hat_tst[i] - s_hat * sigma_hat_tst[i]
  upper[i] <- tau_hat_tst[i] + s_hat * sigma_hat_tst[i]
  setTxtProgressBar(pb, i)
}
close(pb)

sum_estimate <- sum(is.infinite(lower) & is.infinite(upper))
coverage_estimate <- mean((lower <= tst$tau_true) & (upper >= tst$tau_true))
range_estimate <- mean((upper - lower)[is.finite(upper) & is.finite(lower)])

# ---------------------------
# Tabela final (inalterada)
Metrica <- c("Intervalos Infinitos", "Cobertura", "Largura Média")
Caso_1_Conhecido <- c(sum_know, coverage_know, range_know)
Caso_2_Estimado  <- c(sum_estimate, coverage_estimate, range_estimate)

results_df <- data.frame(
  Metrica = Metrica,
  Caso_1_Conhecido = Caso_1_Conhecido,
  Caso_2_Estimado = Caso_2_Estimado
) %>% print()
