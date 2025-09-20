# Importando as Bibliotecas Necessárias

library(tidyverse)
library(showtext)
library(ranger)
library(scales)   
library(ranger)   
library(caret)    

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

# Função Geradora dos Dados

friedman <- function(n, p = 10) {
  X <- matrix(
    runif(n * p),
    nrow = n,
    ncol = p,
    dimnames = list(1:n, paste0("x_", 1:p))
  )
  y <- 10 * sin(pi * X[, 1] * X[, 2]) + 20 * (X[, 3] - 0.5)^2 + 10 * X[, 4] + 5 *
    X[, 5] + rnorm(n)
  data.frame(cbind(y, X))
}

# Trava de Geração de Dados

set.seed(42)

# Gerando os Dados

n_trn <- 2e4
n <- 3e3
n_tst <- 3e3

trn <- friedman(n_trn)
cal <- friedman(n)
tst <- friedman(n_tst)

# Definindo o Nível de Cobertura

a <- 0.1

cover <- 1 - a

# Método Clássico da Predição Conformal Split

rf <- ranger(y ~ ., data = trn)

mu_hat_cal <- predict(rf, data = cal)$predictions

R <- abs(cal$y - mu_hat_cal)

s_hat <- sort(R)[ceiling((cover)*(n+1))]

mu_hat_tst <- predict(rf, data = tst)$predictions

lower <- mu_hat_tst - s_hat
upper <- mu_hat_tst + s_hat

mean((lower <= tst$y) & (upper >= tst$y))
mean(upper - lower)

## Visualização da Cobertura 

idx <- seq_len(50)

ggplot(NULL, aes(x = idx)) +
  geom_errorbar(
    aes(ymin = lower[idx], ymax = upper[idx]),
    width = 0.4,
    linewidth = 0.8,
    colour = "#3EBCD2"
  ) +
  geom_point(
    aes(y = mu_hat_tst[idx]),
    shape = 18, size = 2,
    colour = "#E3120B"
  ) +
  geom_point(
    aes(y = tst$y[idx]),
    shape = 16, size = 1.5,
    colour = "black"
  ) +
  theme_econ_base() +
  theme(
    legend.position    = "none",
    panel.grid.major.x = element_blank(),
    plot.title         = element_text(hjust = 0, face = "bold"),
    plot.caption       = element_text(hjust = 1, face = "italic", size = 9)
  ) +
  labs(
    title   = sprintf("Intervalos de Predição Conformal (Primeiras %d Amostras)", 50),
    subtitle = "Split Conformal Prediction na Random Forest",
    x       = "Unidade da Amostra de Teste",
    y       = "Valor de Y",
    caption = sprintf(
      "Cobertura empírica: %.1f%% | Largura média do intervalo: %.2f",
      100 * mean(lower[idx] <= tst$y[idx] &
                   tst$y[idx] <= upper[idx]),
      mean(upper[idx] - lower[idx])
    )
  )

# Método Ponderado da Predição Conformal Split

y_hat_trn <- predict(rf, data = trn)$predictions

trn_resd <- trn %>% 
  mutate(delta = abs(y - y_hat_trn)) %>% 
  select(-y)

rf_resd <- ranger(delta ~., data = trn_resd)

sig_hat_cal <- predict(rf_resd, data = cal)$predictions

R <- abs(cal$y - mu_hat_cal) / sig_hat_cal

s_hat <- sort(R)[cover * (n + 1)]

lower <- mu_hat_tst - s_hat * sig_hat_cal
upper <- mu_hat_tst + s_hat * sig_hat_cal

mean((lower <= tst$y) & (upper >= tst$y))
mean(upper - lower)

idx <- seq_len(50)

ggplot(NULL, aes(x = idx)) +
  geom_errorbar(
    aes(ymin = lower[idx], ymax = upper[idx]),
    width = 0.4,
    linewidth = 0.8,
    colour = "#3EBCD2"
  ) +
  geom_point(
    aes(y = mu_hat_tst[idx]),
    shape = 18, size = 2,
    colour = "#E3120B"
  ) +
  geom_point(
    aes(y = tst$y[idx]),
    shape = 16, size = 1.5,
    colour = "black"
  ) +
  theme_econ_base() +
  theme(
    legend.position    = "none",
    panel.grid.major.x = element_blank(),
    plot.title         = element_text(hjust = 0, face = "bold"),
    plot.caption       = element_text(hjust = 1, face = "italic", size = 9)
  ) +
  labs(
    title   = sprintf("Intervalos de Predição Conformal (Primeiras %d Amostras)", 50),
    subtitle = "Split Conformal Prediction Padronizada na Random Forest",
    x       = "Unidade da Amostra de Teste",
    y       = "Valor de Y",
    caption = sprintf(
      "Cobertura empírica: %.1f%% | Largura média do intervalo: %.2f",
      100 * mean(lower[idx] <= tst$y[idx] &
                   tst$y[idx] <= upper[idx]),
      mean(upper[idx] - lower[idx])
    )
  )

# Quantile Random Forest

rf <- ranger(y ~., data = trn , quantreg = TRUE)

a_low <- a / 2
a_high <- 1- a / 2

q_hat_cal <- predict(rf, 
                     data = cal, 
                     type = "quantiles", 
                     quantiles = c(a_low, a_high)
                     )$predictions

R <- pmax(q_hat_cal[, 1] - cal$y, 
          cal$y - q_hat_cal[, 2])

s_hat <- sort(R)[cover * (nrow(cal) + 1)]

q_hat_tst <- predict(rf, 
                     data = tst, 
                     type = "quantiles", 
                     quantiles = c(a_low, a_high)
                     )$predictions

lower <- q_hat_tst[, 1] - s_hat
upper <- q_hat_tst[, 2] + s_hat

mean((lower <= tst$y) & (upper >= tst$y))
mean(upper - lower)

idx <- seq_len(50)

ggplot(NULL, aes(x = idx)) +
  geom_errorbar(
    aes(ymin = lower[idx], ymax = upper[idx]),
    width = 0.4,
    linewidth = 0.8,
    colour = "#3EBCD2"
  ) +
  geom_point(
    aes(y = rowMeans(q_hat_tst)[idx]),
    shape = 18, size = 2,
    colour = "#E3120B"
  ) +
  geom_point(
    aes(y = tst$y[idx]),
    shape = 16, size = 1.5,
    colour = "black"
  ) +
  theme_econ_base() +
  theme(
    legend.position    = "none",
    panel.grid.major.x = element_blank(),
    plot.title         = element_text(hjust = 0, face = "bold"),
    plot.caption       = element_text(hjust = 1, face = "italic", size = 9)
  ) +
  labs(
    title   = sprintf("Intervalos de Predição Conformal (Primeiras %d Amostras)", 50),
    subtitle = "Quantile Random Forest",
    x       = "Unidade da Amostra de Teste",
    y       = "Valor de Y",
    caption = sprintf(
      "Cobertura empírica: %.1f%% | Largura média do intervalo: %.2f",
      100 * mean(lower[idx] <= tst$y[idx] &
                   tst$y[idx] <= upper[idx]),
      mean(upper[idx] - lower[idx])
    )
  )

