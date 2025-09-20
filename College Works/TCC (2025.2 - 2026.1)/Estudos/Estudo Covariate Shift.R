# Bibliotecas 

library(patchwork)
library(tidyverse)
library(showtext)
library(mvtnorm)
library(ranger)
library(scales)   
library(ranger)   
library(caret)    
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

# Definindo a Data Generating Process (Processo Gerador dos Dados)

dgp <- function(n, mu, Sigma) {
  X <- MASS::mvrnorm(n = n, mu = mu, Sigma = Sigma)
  colnames(X) <- paste0("x", 1:2)
  y <- apply(X, 1, \(x) 2*x[1] + sin(pi*x[1]*x[2]) - x[2]^2)
  data.frame(X, y)
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

mu <- c(2, 0)
Sigma <- matrix(c(1, 0.8,
                  0.8, 1),
                nrow = 2
                )

mu_tilde <- c(1, 0)
Sigma_tilde <- matrix(c(1, 0.7,
                        0.7, 1),
                      nrow = 2
                      )

a <- 0.1
cover <- 1 - a


n_trn <- 2e4
n <- 3e3
n_tst <- 3e3

trn <- dgp(n_trn, mu, Sigma)
cal <- dgp(n, mu, Sigma)
tst <- dgp(n_tst, mu_tilde, Sigma_tilde)

# Função de Peso de Densidade

w <- function(x) {
    density_ratio(x, mu, Sigma, mu_tilde, Sigma_tilde)
}

# Visulização das densididades

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

# Treinando os Modelos

rf <- ranger(y ~., data = trn)

mu_hat_cal <- predict(rf, data = cal)$predictions
mu_hat_tst <- predict(rf, data = tst)$predictions

R <- abs(cal$y - mu_hat_cal)
R_sorted <- sort(R)
R_order <- order(R)

w_cal <- apply(cal[, 1:2], 1, w)
w_tst <- apply(tst[, 1:2], 1, w)

sum_w_cal <- sum(w_cal)
sum_w_tst <- sum(w_tst)

lower <- numeric(n_tst)
upper <- numeric(n_tst)

pb <- txtProgressBar(min = 1, max = n_tst, style = 3)
for (i in 1:n_tst) {
  p_cal <- w_cal / (sum_w_cal + w_tst[i])
  p_tst <- w_tst[i] / (sum_w_cal + w_tst[i])
  p <- c(p_cal[R_order], p_tst)
  k_hat <- which.max(cumsum(p) >= cover)
  if (k_hat == n + 1) s_hat <- Inf else s_hat <- R_sorted[k_hat]  
  lower[i] <- mu_hat_tst[i] - s_hat
  upper[i] <- mu_hat_tst[i] + s_hat
  setTxtProgressBar(pb, i)
}
close(pb)

sum(upper == Inf)

mean((lower <= tst$y) & (upper >= tst$y))

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
    aes(y = mu_hat_tst[idx]),
    shape = 18, size = 2, colour = "#E3120B"
  ) +
  geom_point(
    aes(y = tst$y[idx]),
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
    title = sprintf("Intervalos de Predição Conformal (Primeiras %d Amostras)", 50),
    subtitle = "Split Conformal Prediction na Random Forest com Covariate Shift",
    x = "Unidade da Amostra de Teste", y = "Valor de Y",
    caption = sprintf(
      "Cobertura empírica: %.1f%% | Largura média: %.2f",
      100 * mean(lower[idx] <= tst$y[idx] & tst$y[idx] <= upper[idx], na.rm = TRUE),
      mean((upper[idx] - lower[idx])[is.finite(upper[idx]) & is.finite(lower[idx])])
    )
  )

