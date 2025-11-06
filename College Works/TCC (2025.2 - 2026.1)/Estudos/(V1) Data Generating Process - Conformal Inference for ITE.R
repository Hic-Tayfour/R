# ============================================================================
# Conformal Prediction para ITE com  Covariate Shift
# Baseado em Lei & Candès (2021) - Adaptado para Inferência Causal
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

# Definindo a Data Generating Process (Processo Gerador dos Dados Causal)

dgp_causal <- function(n, d, rho, heteroscedastic = FALSE, 
                       return_counterfactuals = TRUE) {
  mu <- rep(0, d)
  Sigma <- matrix(rho, nrow = d, ncol = d)
  diag(Sigma) <- 1
  X <- MASS::mvrnorm(n = n, mu = mu, Sigma = Sigma)
  X <- pnorm(X)
  colnames(X) <- paste0("x", 1:d)
  
  # Função de resposta base \mu(X) para outcome de controle
  mu0 <- function(X) {
    2 * X[, 1] - 3 * X[, 2] + 5 * X[, 1] * X[, 2]
  }
  
  Y0 <- mu0(X) + rnorm(n, mean = 0, sd = 0.5)  
  
  # Função \tau(X): CATE 
  f <- function(x) {
    2 / (1 + exp(-12 * (x - 0.5)))
  }
  mu1 <- f(X[, 1]) * f(X[, 2])
  
  # Heteroscedasticidade 
  epsilon <- rnorm(n, mean = 0, sd = 1)
  if (heteroscedastic) {
    sigma_X <- -log(X[, 1] + 1e-9)
  } else {
    sigma_X <- 1
  }
  
  # Y(1) = Y(0) + \mu(X) + erro heteroscedástico
  Y1 <- Y0 + mu1 + sigma_X * epsilon
  
  # Propensity score e atribuição 
  e_x <- 0.25 * (1 + pbeta(X[, 1], shape1 = 2, shape2 = 4))
  T <- rbinom(n = n, size = 1, prob = e_x)
  Y <- T * Y1 + (1 - T) * Y0
  
  if (!return_counterfactuals) {
    return(data.frame(
      X,
      treatment = T,
      Y = Y
    ))
  }
  
  data.frame(
    X,
    Y0 = Y0,
    Y1 = Y1,
    tau_true = Y1 - Y0,
    propensity_score = e_x,
    treatment = T,
    Y = Y
  )
}

# Função de Peso de Densidade

w <- function(x) {
  density_ratio(x, mu, Sigma, mu_tilde, Sigma_tilde)
}

# Definindo a Função de Razão de Densidade

density_ratio <- function(x, mu, Sigma, mu_tilde, Sigma_tilde) {
  exp(mvtnorm::dmvnorm(x,
                       mean = mu_tilde,
                       sigma = Sigma_tilde,
                       log = TRUE) -
        mvtnorm::dmvnorm(x,
                         mean = mu,
                         sigma = Sigma,
                         log = TRUE)
  )
}

# Gerando os Dados

set.seed(42)

# Parâmetros das distribuições dos dados

mu <- rep(0, 10)
Sigma <- matrix(0.9, nrow = 10, ncol = 10)
diag(Sigma) <- 1

mu_tilde <- rep(0, 10)
mu_tilde[1] <- 0.5
mu_tilde[2] <- -0.3
Sigma_tilde <- matrix(0.7, nrow = 10, ncol = 10)
diag(Sigma_tilde) <- 1

a <- 0.1
cover <- 1 - a

n_trn <- 2e4
n <- 3e3
n_tst <- 3e3

trn <- dgp_causal(
  n = n_trn,
  d = 10,
  rho = 0.9,
  heteroscedastic = TRUE,
  return_counterfactuals = TRUE
)

cal <- dgp_causal(
  n = n,
  d = 10,
  rho = 0.9,
  heteroscedastic = TRUE,
  return_counterfactuals = TRUE
)

tst <- dgp_causal(
  n = n_tst,
  d = 10,
  rho = 0.9,
  heteroscedastic = TRUE,
  return_counterfactuals = TRUE
)


# Visualização das densidades (primeiras duas dimensões) ----

# df_plot <- rbind(
#   transform(trn[, c("x1", "x2")], set = "Treino"),
#   transform(tst[, c("x1", "x2")], set = "Teste")
# ) %>% 
#   mutate(set = factor(set, levels = c("Treino", "Teste")))
# 
# col_train <- unname(econ_colors$main["blue1"])
# col_test <- unname(econ_colors$secondary["burgundy"])
# 
# p_main <- df_plot %>%
#   ggplot(aes(x = x1, y = x2, color = set)) +
#   stat_density_2d(linewidth = 0.7) +
#   scale_color_manual(values = c("Treino" = col_train, "Teste" = col_test)) +
#   labs(x = "x1", y = "x2") +
#   theme_econ_base() +
#   theme(legend.position = "none")
# 
# p_top <- df_plot %>%
#   ggplot(aes(x = x1, fill = set)) +
#   geom_density(alpha = 0.6) +
#   scale_fill_manual(values = c("Treino" = col_train, "Teste" = col_test)) +
#   theme_econ_base() +
#   theme(
#     axis.title = element_blank(),
#     axis.text = element_blank(),
#     axis.ticks = element_blank(),
#     panel.grid = element_blank(),
#     legend.position = "none"
#   )
# 
# p_right <- df_plot %>%
#   ggplot(aes(x = x2, fill = set)) +
#   geom_density(alpha = 0.6) +
#   scale_fill_manual(values = c("Treino" = col_train, "Teste" = col_test)) +
#   coord_flip() +
#   theme_econ_base() +
#   theme(
#     axis.title = element_blank(),
#     axis.text = element_blank(), 
#     axis.ticks = element_blank(),
#     panel.grid = element_blank(),
#     legend.position = "none"
#   )
# 
# p_top + p_main + p_right +
#   plot_layout(
#     design = "
#     A##
#     BC#
#     ",
#     heights = c(1, 4), 
#     widths = c(4, 1)
#   ) +
#   plot_annotation(
#     title = "Distribuições conjuntas: Treino (Azul) vs. Teste (Roxo)",
#     subtitle = "Contornos centrais e densidades marginais (x1 e x2)",
#     caption = "Fonte: Dados Simulados (DGP Causal)",
#     theme = theme_econ_base()
#   )
# ----

# Treinando o Modelo 

# Separar por grupo de tratamento

trn_0 <- trn[trn$treatment == 0, ]
trn_1 <- trn[trn$treatment == 1, ]

# Modelo 1: Treinar no grupo controle

rf_mu0 <- ranger(Y ~ . - Y0 - Y1 - tau_true - propensity_score - treatment,
                 data = trn_0)

# Modelo 2: Treinar no grupo tratado
rf_mu1 <- ranger(Y ~ . - Y0 - Y1 - tau_true - propensity_score - treatment,
                 data = trn_1)

# Para controles: quanto Y teria aumentado se tratado (contrafactual do controle)

mu1_pred_on_0 <- predict(rf_mu1, data = trn_0)$predictions

D_0 <- mu1_pred_on_0 - trn_0$Y

# Para tratados: quanto Y aumentou por ser tratado (contrafactual do tratado)

mu0_pred_on_1 <- predict(rf_mu0, data = trn_1)$predictions

D_1 <- trn_1$Y - mu0_pred_on_1

cat(sprintf("Contrafactual do Controle: média = %.3f, sd = %.3f\n", 
            mean(D_0), sd(D_0)))

cat(sprintf("Contrafactual do Tratado: média = %.3f, sd = %.3f\n", 
            mean(D_1), sd(D_1)))

# Modelar os efeitos

# Preparar dados com efeitos imputados
trn_0_with_D <- trn_0 %>% 
  mutate(D = D_0)

trn_1_with_D <- trn_1 %>% 
  mutate(D = D_1)

# Aprender D₀ como função de X nos controles
rf_tau0 <- ranger(D ~ . - Y - Y0 - Y1 - tau_true - propensity_score -                                   treatment,
                  data = trn_0_with_D)

# Aprender D₁ como função de X nos tratados
rf_tau1 <- ranger(D ~ . - Y - Y0 - Y1 - tau_true - propensity_score -                                 treatment,
                  data = trn_1_with_D)

# Estimar propensity score

# Treinar modelo de propensity (probabilidade de tratamento)
rf_prop <- ranger(
  treatment ~ . - Y - Y0 - Y1 - tau_true - propensity_score,
  data = trn,
  probability = TRUE
)

# Predições de propensity na calibração e no teste
e_hat_cal <- predict(rf_prop, data = cal)$predictions[, 2]
e_hat_tst <- predict(rf_prop, data = tst)$predictions[, 2]

# Efeitos estimados (modelos treinados separadamente)
tau0_cal <- predict(rf_tau0, data = cal)$predictions
tau1_cal <- predict(rf_tau1, data = cal)$predictions
tau0_tst <- predict(rf_tau0, data = tst)$predictions
tau1_tst <- predict(rf_tau1, data = tst)$predictions

# Combinação ponderada pelo propensity score
# (peso maior no modelo do grupo correspondente)
tau_hat_cal <- (1 - e_hat_cal) * tau0_cal + e_hat_cal * tau1_cal
tau_hat_tst <- (1 - e_hat_tst) * tau0_tst + e_hat_tst * tau1_tst

# ================================================================
# Sumário dos Resultados
# ================================================================

cat(sprintf("Contrafactual do Controle: média = %.3f, sd = %.3f\n", 
            mean(D_0), sd(D_0)))

cat(sprintf("Contrafactual do Tratado: média = %.3f, sd = %.3f\n", 
            mean(D_1), sd(D_1)))

cat(sprintf("ITE médio estimado (cal): %.3f (verdadeiro: %.3f)\n", 
            mean(tau_hat_cal), mean(cal$tau_true)))

cat(sprintf("ITE médio estimado (test): %.3f (verdadeiro: %.3f)\n", 
            mean(tau_hat_tst), mean(tst$tau_true)))
# Conformal Prediction

# Resíduos de não-conformidade (ITE)
R <- abs(cal$tau_true - tau_hat_cal)
R_sorted <- sort(R)
R_order <- order(R)

# Pesos de densidade
w_cal <- apply(cal[, paste0("x", 1:10)], 1, w)
w_tst <- apply(tst[, paste0("x", 1:10)], 1, w)

sum_w_cal <- sum(w_cal)
sum_w_tst <- sum(w_tst)

# Construção dos intervalos de predição

lower <- numeric(n_tst)
upper <- numeric(n_tst)

pb <- txtProgressBar(min = 1, max = n_tst, style = 3)
for (i in 1:n_tst) {
  p_cal <- w_cal / (sum_w_cal + w_tst[i])
  p_tst <- w_tst[i] / (sum_w_cal + w_tst[i])
  p <- c(p_cal[R_order], p_tst)
  k_hat <- which.max(cumsum(p) >= cover)
  if (k_hat == n + 1) s_hat <- Inf else s_hat <- R_sorted[k_hat]  
  lower[i] <- tau_hat_tst[i] - s_hat
  upper[i] <- tau_hat_tst[i] + s_hat
  setTxtProgressBar(pb, i)
}
close(pb)

sum(upper == Inf)

mean((lower <= tst$tau_true) & (upper >= tst$tau_true))

# Avaliação

cat("\n")
cat("Intervalos infinitos:", sum(upper == Inf), "\n")
cat("Cobertura empírica:", mean((lower <= tst$tau_true) & (upper >= tst$tau_true)), "\n")

# Visualizando 

idx <- seq_len(50)

ggplot(NULL, aes(x = idx)) +
  geom_errorbar(
    aes(
      ymin = ifelse(is.infinite(lower[idx]), NA, lower[idx]),
      ymax = ifelse(is.infinite(upper[idx]), NA, upper[idx])
    ),
    width = 0.4, linewidth = 0.8, colour = "#3EBCD2",
    na.rm = TRUE
  ) +
  geom_point(
    aes(y = tau_hat_tst[idx]),
    shape = 18, size = 2, colour = "#E3120B"
  ) +
  geom_point(
    aes(y = tst$tau_true[idx]),
    shape = 16, size = 1.5, colour = "black"
  ) +
  theme_econ_base() +
  theme(
    legend.position    = "none",
    panel.grid.major.x = element_blank(),
    plot.title         = element_text(hjust = 0, face = "bold"),
    plot.caption       = element_text(hjust = 1, face = "italic", size = 9)
  ) +
  labs(
    title = sprintf("Intervalos de Predição Conformal para ITE (Primeiras %d Amostras)", 50),
    subtitle = "Split Conformal Prediction com Covariate Shift",
    x = "Unidade da Amostra de Teste", y = "Efeito Individual do Tratamento τ(x)",
    caption = sprintf(
      "Cobertura empírica: %.1f%% | Largura média: %.2f | RMSE(τ): %.3f",
      100 * mean(lower[idx] <= tst$tau_true[idx] & tst$tau_true[idx] <= upper[idx], na.rm = TRUE),
      mean((upper[idx] - lower[idx])[is.finite(upper[idx]) & is.finite(lower[idx])]),
      sqrt(mean((tau_hat_tst[idx] - tst$tau_true[idx])^2))
    )
  )
