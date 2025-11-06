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


# Definindo a Data Generating Process (Processo Gerador dos Dados Causal)

dgp <- function(n = 1e3, true_tau = -1, stdev = 0.7, return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
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

# Vendo o DGP

set.seed(42)

db_check <- dgp(1e4, return_counterfactuals = TRUE)

# Preparando os Dados para os Modelos de Inferencia Conformal 

# Parâmetros

true_tau <- -1
stdev <- 0.7
alpha <- 0.1
cover <- 1 - alpha

sample <- 10e3

n_trn <- 0.075 * sample
n_cal <- 0.025 * sample
n_tst <- 1 * sample

# Gerar conjuntos

trn <- dgp(
  n = n_trn,
  true_tau = true_tau,
  stdev = stdev,
  return_counterfactuals = TRUE
)

cal <- dgp(
  n = n_cal,
  true_tau = true_tau,
  stdev = stdev,
  return_counterfactuals = TRUE
)

tst <- dgp(
  n = n_tst,
  true_tau = true_tau,
  stdev = stdev,
  return_counterfactuals = TRUE
)

# Treinando o Modelo 

# Separar por grupo de tratamento
"
Separando a base de treino para treinar um modelo 
para o grupo de controle (0) e outro para o grupo tratado(1)
"

trn_0 <- trn[trn$treatment == 0, ]
trn_1 <- trn[trn$treatment == 1, ]


# Modelo 1: Treinar no grupo controle
"
Treinando o modelo do grupo controle com somente o grupo controle
"

rf_mu0 <- ranger(Y ~ x1 + x2, data = trn_0)

# Modelo 2: Treinar no grupo tratado
"
Treinando o modelo do grupo tratado com somente o grupo tratado
"

rf_mu1 <- ranger(Y ~ x1 + x2, data = trn_1)

# Para controles: quanto Y teria aumentado se tratado (contrafactual do controle)
"
Usando o grupo controle, caso eles fossem tratados(usando o modelo tratados),
qual seria o seu Y ?
Contrafactual
"

mu1_pred_on_0 <- predict(rf_mu1, data = trn_0)$predictions

D_0 <- mu1_pred_on_0 - trn_0$Y

# Para tratados: quanto Y aumentou por ser tratado (contrafactual do tratado)
"
Usando o grupo tratado, caso eles fossem não tivessem sido tratados
(usando o modelo controle) , qual seria o seu Y ?
Contrafactual
"

mu0_pred_on_1 <- predict(rf_mu0, data = trn_1)$predictions

D_1 <- trn_1$Y - mu0_pred_on_1

# Modelar os Efeitos

# Preparar dados com efeitos 

"
Adicionando na base de treino o valor do ganho(ou perda) gerado pelo 
tratamento
"

trn_0_with_D <- trn_0 %>% 
  mutate(D = D_0)

trn_1_with_D <- trn_1 %>% 
  mutate(D = D_1)

# Aprender D₀ como função de X nos controles
"
Entendendo o `valor` do tratamento(tau) para os controles
"

rf_tau0 <- ranger(D ~ x1 + x2, data = trn_0_with_D)

# Aprender D₁ como função de X nos tratados
"
Entendendo o `valor` do tratamento(tau) para os tratados
"

rf_tau1 <- ranger(D ~ x1 + x2, data = trn_1_with_D)

# ESTIMAR ERROS PADRÃO DOS RESÍDUOS
"
Preparando e treinando os modelos para fazer os intervalos de confiança
variáveis para a Predição Conformal.
"

# Predições no conjunto de treino

tau0_hat_trn <- predict(rf_tau0, data = trn_0_with_D)$predictions

tau1_hat_trn <- predict(rf_tau1, data = trn_1_with_D)$predictions

# Resíduos ABSOLUTOS

trn_0_res <- data.frame(
  x1 = trn_0_with_D$x1,
  x2 = trn_0_with_D$x2,
  delta = abs(trn_0_with_D$D - tau0_hat_trn)
)

trn_1_res <- data.frame(
  x1 = trn_1_with_D$x1,
  x2 = trn_1_with_D$x2,
  delta = abs(trn_1_with_D$D - tau1_hat_trn)
)

# Treinar Random Forest para prever |resíduos|

rf_sigma0 <- ranger(delta ~ x1 + x2, data = trn_0_res)

rf_sigma1 <- ranger(delta ~ x1 + x2, data = trn_1_res)


# Estimar Propensity Score

# Treinar modelo de propensity

rf_prop <- ranger(
  treatment ~ x1 + x2,
  data = trn,
  probability = TRUE
)

# Predições na Calibração e no Teste

# Propensity scores

e_hat_cal <- predict(rf_prop, data = cal)$predictions[, 2]

e_hat_tst <- predict(rf_prop, data = tst)$predictions[, 2]

# Efeitos estimados

tau0_cal <- predict(rf_tau0, data = cal)$predictions
tau1_cal <- predict(rf_tau1, data = cal)$predictions
tau0_tst <- predict(rf_tau0, data = tst)$predictions
tau1_tst <- predict(rf_tau1, data = tst)$predictions

# Combinação ponderada pelo propensity score

tau_hat_cal <- (1 - e_hat_cal) * tau0_cal + e_hat_cal * tau1_cal
tau_hat_tst <- (1 - e_hat_tst) * tau0_tst + e_hat_tst * tau1_tst

# Erros padrão estimados

sigma0_cal <- predict(rf_sigma0, data = cal)$predictions
sigma1_cal <- predict(rf_sigma1, data = cal)$predictions
sigma_hat_cal <- (1 - e_hat_cal) * sigma0_cal + e_hat_cal * sigma1_cal

sigma0_tst <- predict(rf_sigma0, data = tst)$predictions
sigma1_tst <- predict(rf_sigma1, data = tst)$predictions
sigma_hat_tst <- (1 - e_hat_tst) * sigma0_tst + e_hat_tst * sigma1_tst

# Conformal Prediction NORMALIZADO

# Resíduos de não-conformidade NORMALIZADOS

R <- abs(cal$tau_true - tau_hat_cal) / pmax(sigma_hat_cal, 1e-6)
R_sorted <- sort(R)
R_order <- order(R)

# Construção dos intervalos de predição

lower <- numeric(n_tst)
upper <- numeric(n_tst)

pb <- txtProgressBar(min = 1, max = n_tst, style = 3)
for (i in 1:n_tst) {
  k_hat <- ceiling((1 - alpha) * (n_cal + 1))
  if (k_hat > n_cal) {
    s_hat <- Inf
  } else {
    s_hat <- R_sorted[k_hat]
  }
  lower[i] <- tau_hat_tst[i] - s_hat * sigma_hat_tst[i]
  upper[i] <- tau_hat_tst[i] + s_hat * sigma_hat_tst[i]
  setTxtProgressBar(pb, i)
}
close(pb)

# Avaliação

mean((lower <= tst$tau_true) & (upper >= tst$tau_true))

sum(upper == Inf)

mean((upper - lower)[is.finite(upper) & is.finite(lower)])




