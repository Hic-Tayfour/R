# ============================================================================
# Conformal Prediction para ITE - DGP Paulo Cilas Marques Filho (dgp.R)
# Baseado em Lei & Candès (2021)
# ============================================================================

# Bibliotecas 

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

# DGP, razão de densidades e ponderação

dgp <- function(n, mu_x, Sigma_x, true_tau = -1, stdev = 0.7, return_counterfactuals = FALSE) {
  
  X <- MASS::mvrnorm(n = n, mu = mu_x, Sigma = Sigma_x)
  x1 <- X[, 1]
  x2 <- X[, 2]
  colnames(X) <- c("x1", "x2") 
  mu <- ifelse(x1 < x2, 3, -1) 
  propensity_score <- pnorm(mu)
  t <- rbinom(n, size = 1, prob = propensity_score)
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y <- ifelse(t == 0, y0, y1)
  if (!return_counterfactuals) {
    return(data.frame(x1 = x1, x2 = x2, treatment = t, Y = y))
  }
  data.frame(
    x1 = x1, 
    x2 = x2, 
    Y0 = y0, 
    Y1 = y1,
    tau_true = y1 - y0, 
    propensity_score = propensity_score,
    treatment = t, 
    Y = y
  )
}

# Definindo a Função de Razão de Densidade

density_ratio <- function(x, mu, Sigma, mu_tilde, Sigma_tilde) {
  exp(
    mvtnorm::dmvnorm(
      x,
      mean = mu_tilde,
      sigma = Sigma_tilde,
      log = TRUE
    ) -
      mvtnorm::dmvnorm(
        x,
        mean = mu,
        sigma = Sigma,
        log = TRUE
      )
  )
}


w_known <- function(x) {
  density_ratio(x, mu, Sigma, mu_tilde, Sigma_tilde)
}


# Parâmetros

set.seed(42)
alpha <- 0.1
cover <- 1 - alpha
true_tau <- -1
stdev <- 0.7

"
Tamanhos do Paper do Candès
"

n_trn <- 750
n_cal <- 250
n_tst <- 10000

# Distribuição de Treino / Calibração

mu <- c(2, 0)

Sigma <- matrix(c(1, 0.8, 
                      0.8, 1), nrow = 2)

# Distribuição de Teste (P_tst) - DIFERENTE

mu_tilde <- c(4, 0)

Sigma_tilde <- matrix(c(1, 0.6, 
                      0.6, 1), nrow = 2)

# Gerar os dados

trn <- dgp(n_trn, 
           mu, 
           Sigma, 
           true_tau, 
           stdev, 
           TRUE)

cal <- dgp(n_cal, 
           mu, 
           Sigma, 
           true_tau,
           stdev, 
           TRUE)

tst <- dgp(n_tst, 
           mu_tilde, 
           Sigma_tilde, 
           true_tau, 
           stdev, 
           TRUE)


# Visulização das densididades e o Shift----

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

# Caso 1 : O Caso perfeito

# Separar treino

trn_0 <- trn[trn$treatment == 0, ]
trn_1 <- trn[trn$treatment == 1, ]

# 1. Modelos para Y (mu_0, mu_1)

rf_mu0 <- ranger(Y ~ x1 + x2, data = trn_0)
rf_mu1 <- ranger(Y ~ x1 + x2, data = trn_1)

# 2. Contrafactuais 

mu1_pred_on_0 <- predict(rf_mu1, data = trn_0)$predictions
D_0 <- mu1_pred_on_0 - trn_0$Y 

mu0_pred_on_1 <- predict(rf_mu0, data = trn_1)$predictions
D_1 <- trn_1$Y - mu0_pred_on_1 

trn_0_with_D <- trn_0 %>% mutate(D = D_0)
trn_1_with_D <- trn_1 %>% mutate(D = D_1)

# 3. Modelos para ITE (tau_0, tau_1)

rf_tau0 <- ranger(D ~ x1 + x2, data = trn_0_with_D)
rf_tau1 <- ranger(D ~ x1 + x2, data = trn_1_with_D)

# 4. Resíduos absolutos do ITE (|resid_tau|)

tau0_hat_trn <- predict(rf_tau0, data = trn_0_with_D)$predictions
tau1_hat_trn <- predict(rf_tau1, data = trn_1_with_D)$predictions

trn_0_res <- data.frame(
  x1 = trn_0_with_D$x1, x2 = trn_0_with_D$x2,
  resid = abs(trn_0_with_D$D - tau0_hat_trn)
)
trn_1_res <- data.frame(
  x1 = trn_1_with_D$x1, x2 = trn_1_with_D$x2,
  resid = abs(trn_1_with_D$D - tau1_hat_trn)
)

# 5. Modelos para |Resíduos| (sigma_0, sigma_1)

rf_sigma0 <- ranger(resid ~ x1 + x2, data = trn_0_res)
rf_sigma1 <- ranger(resid ~ x1 + x2, data = trn_1_res)


rf_prop <- ranger(
  factor(treatment) ~ x1 + x2,
  data = trn,
  probability = TRUE
)

w_cal_known <- apply(cal[, c("x1", "x2")], 1, w_known)

w_tst_known <- apply(tst[, c("x1", "x2")], 1, w_known)

# Propensity scores

e_hat_cal <- predict(rf_prop, data = cal)$predictions[, 2]
e_hat_tst <- predict(rf_prop, data = tst)$predictions[, 2]

# Predições de ITE (tau)

tau0_cal <- predict(rf_tau0, data = cal)$predictions
tau1_cal <- predict(rf_tau1, data = cal)$predictions
tau0_tst <- predict(rf_tau0, data = tst)$predictions
tau1_tst <- predict(rf_tau1, data = tst)$predictions

# Predições de Erro (sigma)

sigma0_cal <- predict(rf_sigma0, data = cal)$predictions
sigma1_cal <- predict(rf_sigma1, data = cal)$predictions
sigma0_tst <- predict(rf_sigma0, data = tst)$predictions
sigma1_tst <- predict(rf_sigma1, data = tst)$predictions

# Combinação ponderada por e(x)

tau_hat_cal <- (1 - e_hat_cal) * tau0_cal + e_hat_cal * tau1_cal
tau_hat_tst <- (1 - e_hat_tst) * tau0_tst + e_hat_tst * tau1_tst

sigma_hat_cal <- (1 - e_hat_cal) * sigma0_cal + e_hat_cal * sigma1_cal
sigma_hat_tst <- (1 - e_hat_tst) * sigma0_tst + e_hat_tst * sigma1_tst

# Scores de Não-Conformidade NORMALIZADOS (R)
# O score é sobre o ITE (tau_true)

R <- abs(cal$tau_true - tau_hat_cal) / pmax(sigma_hat_cal, 1e-6)
R_sorted <- sort(R)
R_order <- order(R)

lower <- numeric(n_tst)
upper <- numeric(n_tst)

# Pré-calcular valores constantes do loop

sum_w_cal <- sum(w_cal_known)
cover <- 1 - alpha

pb <- txtProgressBar(min = 1, max = n_tst, style = 3)

for (i in 1:n_tst) {
  p_cal <- w_cal_known / (sum_w_cal + w_tst_known[i])
  p_tst <- w_tst_known[i] / (sum_w_cal + w_tst_known[i])
  p <- c(p_cal[R_order], p_tst) 
  k_hat <- which.max(cumsum(p) >= cover)
  s_hat <- if (k_hat == n_cal + 1) {
    Inf 
  } else {
    R_sorted[k_hat]
  }
  lower[i] <- tau_hat_tst[i] - s_hat * sigma_hat_tst[i]
  upper[i] <- tau_hat_tst[i] + s_hat * sigma_hat_tst[i]
  setTxtProgressBar(pb, i)
}
close(pb)

sum_know <- sum(upper == Inf)

coverage_know <- mean((lower <= tst$tau_true) & (upper >= tst$tau_true))

range_know <- mean((upper - lower)[is.finite(upper) & is.finite(lower)])

# Caso 2 : O Mundo Real 

combined_X <- rbind(cal[, c("x1", "x2")], tst[, c("x1", "x2")])

is_test <- factor(c(rep(0, n_cal), rep(1, n_tst)))

classifier_data <- data.frame(combined_X, is_test)

# Treinar classificador para prever P(is_test=1 | X) = e(x)

rf_classifier <- ranger(
  is_test ~ .,
  data = classifier_data,
  probability = TRUE
)

# Obter as probabilidades e(x) para todos

e_hat_combined <- predict(rf_classifier, data = classifier_data)$predictions[, 2]
e_hat_cal <- e_hat_combined[1:n_cal]
e_hat_tst <- e_hat_combined[(n_cal + 1):(n_cal + n_tst)]

# Calcular os pesos w_hat(x) = [e(x) / (1-e(x))] * (n_cal / n_tst)

epsilon <- 1e-6 # Evitar divisão por zero
w_cal_est <- (e_hat_cal / pmax(1 - e_hat_cal, epsilon)) * (n_cal / n_tst)
w_tst_est <- (e_hat_tst / pmax(1 - e_hat_tst, epsilon)) * (n_cal / n_tst)

lower <- numeric(n_tst)
upper <- numeric(n_tst)

# Pré-calcular valores constantes do loop (usando pesos 'est')
sum_w_cal <- sum(w_cal_est)
cover <- 1 - alpha

cat("\nExecutando Conformal Loop (Pesos Estimados)...\n")
pb <- txtProgressBar(min = 1, max = n_tst, style = 3)

for (i in 1:n_tst) {
  p_cal <- w_cal_est / (sum_w_cal + w_tst_est[i])
  p_tst <- w_tst_est[i] / (sum_w_cal + w_tst_est[i])
  p <- c(p_cal[R_order], p_tst) 
  k_hat <- which.max(cumsum(p) >= cover)
  s_hat <- if (k_hat == n_cal + 1) {
    Inf 
  } else {
    R_sorted[k_hat]
  }
  lower[i] <- tau_hat_tst[i] - s_hat * sigma_hat_tst[i]
  upper[i] <- tau_hat_tst[i] + s_hat * sigma_hat_tst[i]
  
  setTxtProgressBar(pb, i)
}
close(pb)

sum_estimate <- sum(upper == Inf)

coverage_estimate <- mean((lower <= tst$tau_true) & (upper >= tst$tau_true))

range_estimate <- mean((upper - lower)[is.finite(upper) & is.finite(lower)])

# Conclusão :
Metrica <- c("Intervalos Infinitos", "Cobertura", "Largura Média")
Caso_1_Conhecido <- c(sum_know, coverage_know, range_know)
Caso_2_Estimado <- c(sum_estimate, coverage_estimate, range_estimate)

results_df <- data.frame(
  Metrica = Metrica,
  Caso_1_Conhecido = Caso_1_Conhecido,
  Caso_2_Estimado = Caso_2_Estimado
) %>% print()
