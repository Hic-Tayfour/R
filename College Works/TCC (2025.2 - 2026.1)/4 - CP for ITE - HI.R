library(tidyverse)
library(dbarts)
library(ranger)
library(catboost)
library(scales)
library(showtext)

# Funções Gráficas The Economist ----

# Definição do tibble de cores 

econ_colors_tbl <- tribble(
  ~category,           ~color_name,    ~hex,
  # Cores principais e para dados
  "branding",          "econ_red",     "#E3120B", 
  "main",              "data_red",     "#DB444B", 
  "main",              "blue1",        "#006BA2", 
  "main",              "blue2",        "#3EBCD2", 
  "main",              "green",        "#379A8B", 
  "main",              "yellow",       "#EBB434", 
  "main",              "olive",        "#B4BA39", 
  "main",              "purple",       "#9A607F", 
  "main",              "gold",         "#D1B07C", 
  
  # Cores secundárias e para texto 
  "text",              "red_text",     "#CC334C",
  "text",              "blue2_text",   "#0097A7",
  "secondary",         "mustard",      "#E6B83C",
  "secondary",         "burgundy",     "#A63D57",
  "secondary",         "mauve",        "#B48A9B",
  "secondary",         "teal",         "#008080",
  "secondary",         "aqua",         "#6FC7C7",
  
  # Suporte para claridade
  "supporting_bright", "purple_b",     "#924C7A",
  "supporting_bright", "pink",         "#DA3C78",
  "supporting_bright", "orange",       "#F7A11A",
  "supporting_bright", "lime",         "#B3D334",
  
  # Suporte para escuro
  "supporting_dark",   "navy",         "#003D73",
  "supporting_dark",   "cyan_dk",      "#005F73",
  "supporting_dark",   "green_dk",     "#385F44",
  
  # Fundo
  "background",        "print_bkgd",   "#E9EDF0", 
  "background",        "highlight",    "#DDE8EF",
  "background",        "number_box",   "#C2D3E0",
  
  # Para mapas
  "maps",              "sea",          "#EBF5FB",
  "maps",              "land",         "#EBEBEB",
  "maps",              "land_text",    "#6D6E71",
  
  # Neutro
  "neutral",           "grid_lines",   "#B7C6CF", 
  "neutral",           "grey_box",     "#7C8C99",
  "neutral",           "grey_text",    "#333333",
  "neutral",           "black25",      "#BFBFBF",
  "neutral",           "black50",      "#808080",
  "neutral",           "black75",      "#404040",
  "neutral",           "black100",     "#000000",
  
  # Mesma claridade
  "equal_lightness",   "red",          "#A81829", 
  "equal_lightness",   "blue",         "#00588D", 
  "equal_lightness",   "cyan",         "#005F73", 
  "equal_lightness",   "green",        "#005F52", 
  "equal_lightness",   "yellow",       "#714C00", 
  "equal_lightness",   "olive",        "#4C5900", 
  "equal_lightness",   "purple",       "#78405F", 
  "equal_lightness",   "gold",         "#674E1F", 
  "equal_lightness",   "grey",         "#3F5661"  
)

# Vetor de busca

pal <- econ_colors_tbl %>%
  mutate(color_name = case_when(
    category == "equal_lightness" ~ paste0(color_name, "_eq"),
    category == "text" ~ paste0(color_name, "_txt"), 
    TRUE ~ color_name
  )) %>%
  dplyr::select(color_name, hex) %>%
  deframe()

# Configuração de Fonte

(font_family <- if ("Roboto Condensed" %in% systemfonts::system_fonts()$family) 
  "Roboto Condensed" else "sans")
showtext_auto()

# Definição de Bases

econ_base <- list(
  bg   = pal["print_bkgd"],
  grid = pal["grid_lines"],
  text = "#0C0C0C" 
)

# Esquemas de Cores 

econ_scheme <- list(
  bars = unname(pal[c("blue1",
                      "blue2",
                      "mustard",
                      "teal",
                      "burgundy",
                      "mauve",
                      "data_red",
                      "grey_eq")]),
  
  web = unname(pal[c("data_red",
                     "blue1",
                     "blue2",
                     "green",
                     "yellow",
                     "olive",
                     "purple",
                     "gold")]),
  
  stacked     = unname(pal[c("blue1", "blue2", "mustard", "teal", "burgundy", "mauve")]),
  lines_side  = unname(pal[c("blue1", "blue2", "mustard", "teal", "burgundy", "mauve")]),
  
  equal       = unname(pal[grep("_eq$", names(pal))])
)

# Funções de Tema e Escala
theme_econ_base <- function(base_family = font_family) {
  theme_minimal(base_family = base_family) +
    theme(
      plot.background  = element_rect(fill = econ_base$bg, colour = NA),
      panel.background = element_rect(fill = econ_base$bg, colour = NA),
      
      # Títulos e Legendas
      plot.title.position = "plot",
      plot.title     = element_text(
        face = "bold",
        size = 20,
        hjust = 0,
        colour = econ_base$text,
        margin = margin(b = 4)
      ),
      plot.subtitle  = element_text(
        size = 12.5,
        hjust = 0,
        colour = econ_base$text,
        margin = margin(b = 10)
      ),
      plot.caption   = element_text(
        size = 9,
        colour = "#404040",
        hjust = 0,
        margin = margin(t = 10)
      ),
      
      # Eixos
      axis.title     = element_blank(),
      axis.text      = element_text(size = 10, colour = econ_base$text),
      axis.line.x    = element_line(colour = econ_base$text, linewidth = 0.6),
      axis.ticks.x   = element_line(colour = econ_base$text, linewidth = 0.6),
      axis.ticks.y   = element_blank(),
      
      # Grid
      panel.grid.major.y = element_line(colour = econ_base$grid, linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      
      # Legenda
      legend.position = "top",
      legend.justification = "left",
      legend.title    = element_blank(),
      legend.text     = element_text(size = 10, colour = econ_base$text),
      legend.margin   = margin(t = 0, b = 5),
      
      plot.margin     = margin(16, 16, 12, 16)
    )
}

scale_econ <- function(aes = c("colour", "fill"),
                       scheme = "bars",
                       reverse = FALSE,
                       values = NULL,
                       ...) {
  aes <- match.arg(aes)
  
  pal_vec <- if (!is.null(values)) {
    unname(values)
  } else {
    if (!scheme %in% names(econ_scheme))
      scheme <- "bars"
    econ_scheme[[scheme]]
  }
  
  if (reverse)
    pal_vec <- rev(pal_vec)
  
  if (aes == "colour") {
    scale_colour_manual(values = pal_vec, ...)
  } else {
    scale_fill_manual(values = pal_vec, ...)
  }
}

fmt_lab <- function(kind = c("number", "percent", "si")) {
  kind <- match.arg(kind)
  switch(
    kind,
    number  = label_number(big.mark = ",", decimal.mark = "."), 
    percent = label_percent(accuracy = 1),
    si      = label_number(scale_cut = cut_short_scale())
  )
}
# ----

data(HI, package = "Ecdat")

db <- HI |>
  as_tibble() |>
  drop_na() |>
  mutate(t = if_else(hhi == "yes", 1, 0)) |>
  rename(y = whrswk) |>
  select(-hhi, -wght)

set.seed(42)

alpha <- 0.1
alpha_out <- alpha/2

idx <- sample(c(1, 2, 3), nrow(db), replace = TRUE, prob = c(0.5, 0.25, 0.25))

trn <- db[idx == 1, ]
cal <- db[idx == 2, ]
tst <- db[idx == 3, ]

ps_hat <- ranger(t ~ ., data = trn |> select(-y) |> mutate(t = factor(t)), probability = TRUE)

cal0 <- cal |> filter(t == 0)
tst1 <- tst |> filter(t == 1)

e_hat_cal <- predict(ps_hat, data = cal0 |> select(-y))$predictions[, "1"]
e_hat_tst <- predict(ps_hat, data = tst1 |> select(-y))$predictions[, "1"]

# Modelo Random Forest ----

rf0 <- ranger(y ~ ., data = trn |> filter(t == 0) |> select(-t))

mu_hat_cal <- predict(rf0, data = cal0 |> select(-t))$predictions
mu_hat_tst <- predict(rf0, data = tst1 |> select(-t))$predictions

R <- abs(cal0$y - mu_hat_cal)

w_cal <- e_hat_cal[order(R)] / (1 - e_hat_cal[order(R)])
w_tst <- e_hat_tst / (1 - e_hat_tst)

threshold <- (1 - alpha) * (sum(w_cal) + w_tst)

k <- findInterval(threshold, cumsum(w_cal), left.open = TRUE) + 1

r_hat <- c(sort(R), Inf)[k]

lower_y0 <- mu_hat_tst - r_hat
upper_y0 <- mu_hat_tst + r_hat

lower_ite <- tst1$y - upper_y0
upper_ite <- tst1$y - lower_y0

summary(upper_ite - lower_ite)

mean_rf <- mean(upper_ite - lower_ite)
prop_inf_rf <- mean(upper_ite == Inf)
cov_zero_rf <- mean(lower_ite <= 0 & 0 <= upper_ite)

tibble(id = 1:nrow(tst1), lower = lower_ite, upper = upper_ite) |>
  slice_sample(n = 30) |>
  mutate(ite_est = (lower + upper) / 2,
         status = case_when(lower > 0 ~ "Positivo", upper < 0 ~ "Negativo", TRUE ~ "Neutro"),
         id = fct_reorder(factor(id), lower)) |>
  ggplot(aes(ite_est, id, color = status)) +
  geom_vline(xintercept = 0, lty = 2, color = pal["black50"], linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("Positivo" = unname(pal["blue1"]), 
                                "Neutro" = unname(pal["grey_box"]), 
                                "Negativo" = unname(pal["econ_red"]))) +
  labs(title = "Efeitos Individuais de Tratamento (ITE)",
       subtitle = "Intervalos conformais (90%) estimados via Random Forest Padrão em uma amostra de 30 mulheres.",
       caption = "Fonte: Elaboração própria com dados de Seguro de Saúde - HI (pacote Ecdat).",
       x = "Estimativa do Efeito Contrafactual nas Horas Trabalhadas por Semana",
       y = NULL) +
  theme_econ_base() +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank(), 
    panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4))

# Modelo Quantile Regression Forest ----

rf0_q <- ranger(y ~ ., data = trn |> filter(t == 0) |> select(-t), quantreg = TRUE)

q_hat_cal <- predict(rf0_q, data = cal0, type = "quantiles", quantiles = c(alpha_out, 1 - alpha_out))$predictions
q_hat_tst <- predict(rf0_q, data = tst1, type = "quantiles", quantiles = c(alpha_out, 1 - alpha_out))$predictions

R <- pmax(q_hat_cal[, 1] - cal0$y, cal0$y - q_hat_cal[, 2])

w_cal <- e_hat_cal[order(R)] / (1 - e_hat_cal[order(R)])
w_tst <- e_hat_tst / (1 - e_hat_tst)

threshold <- (1 - alpha) * (sum(w_cal) + w_tst)

k <- findInterval(threshold, cumsum(w_cal), left.open = TRUE) + 1

r_hat <- c(sort(R), Inf)[k]

lower_y0 <- q_hat_tst[, 1] - r_hat
upper_y0 <- q_hat_tst[, 2] + r_hat

lower_ite <- tst1$y - upper_y0
upper_ite <- tst1$y - lower_y0

summary(upper_ite - lower_ite)

mean_qrf <- mean(upper_ite - lower_ite)
prop_inf_qrf <- mean(upper_ite == Inf)
cov_zero_qrf <- mean(lower_ite <= 0 & 0 <= upper_ite)

tibble(id = 1:nrow(tst1), lower = lower_ite, upper = upper_ite) |>
  slice_sample(n = 30) |>
  mutate(ite_est = (lower + upper) / 2,
         status = case_when(lower > 0 ~ "Positivo", upper < 0 ~ "Negativo", TRUE ~ "Neutro"),
         id = fct_reorder(factor(id), lower)) |>
  ggplot(aes(ite_est, id, color = status)) +
  geom_vline(xintercept = 0, lty = 2, color = pal["black50"], linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("Positivo" = unname(pal["blue1"]), 
                                "Neutro" = unname(pal["grey_box"]), 
                                "Negativo" = unname(pal["econ_red"]))) +
  labs(title = "Efeitos Individuais de Tratamento (ITE)",
       subtitle = "Intervalos conformais (90%) estimados via Quantile Regression Forest em uma amostra de 30 mulheres.",
       caption = "Fonte: Elaboração própria com dados de Seguro de Saúde - HI (pacote Ecdat).",
       x = "Estimativa do Efeito Contrafactual nas Horas Trabalhadas por Semana",
       y = NULL) +
  theme_econ_base() +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank(), 
    panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4))

# Bayesian Additive Regression Trees ----

bart0 <- bart2(y ~ ., data = trn |> filter(t == 0) |> select(-t), keepTrees = TRUE, verbose = FALSE)

pred_cal <- predict(bart0, newdata = cal0)
pred_tst <- predict(bart0, newdata = tst1)

mu_hat_cal <- apply(pred_cal, 2, median)
sig_hat_cal <- apply(pred_cal, 2, sd)

mu_hat_tst <- apply(pred_tst, 2, median)
sig_hat_tst <- apply(pred_tst, 2, sd)

R <- abs(cal0$y - mu_hat_cal) / sig_hat_cal

w_cal <- e_hat_cal[order(R)] / (1 - e_hat_cal[order(R)])
w_tst <- e_hat_tst / (1 - e_hat_tst)

threshold <- (1 - alpha) * (sum(w_cal) + w_tst)

k <- findInterval(threshold, cumsum(w_cal), left.open = TRUE) + 1

r_hat <- c(sort(R), Inf)[k]

lower_y0 <- mu_hat_tst - r_hat * sig_hat_tst
upper_y0 <- mu_hat_tst + r_hat * sig_hat_tst

lower_ite <- tst1$y - upper_y0
upper_ite <- tst1$y - lower_y0

summary(upper_ite - lower_ite)

mean_bart <- mean(upper_ite - lower_ite)
prop_inf_bart <- mean(upper_ite == Inf)
cov_zero_bart <- mean(lower_ite <= 0 & 0 <= upper_ite)

tibble(id = 1:nrow(tst1), lower = lower_ite, upper = upper_ite) |>
  slice_sample(n = 30) |>
  mutate(ite_est = (lower + upper) / 2,
         status = case_when(lower > 0 ~ "Positivo", upper < 0 ~ "Negativo", TRUE ~ "Neutro"),
         id = fct_reorder(factor(id), lower)) |>
  ggplot(aes(ite_est, id, color = status)) +
  geom_vline(xintercept = 0, lty = 2, color = pal["black50"], linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("Positivo" = unname(pal["blue1"]), 
                                "Neutro" = unname(pal["grey_box"]), 
                                "Negativo" = unname(pal["econ_red"]))) +
  labs(title = "Efeitos Individuais de Tratamento (ITE)",
       subtitle = "Intervalos conformais adaptativos (90%) estimados via BART em uma amostra de 30 mulheres.",
       caption = "Fonte: Elaboração própria com dados de Seguro de Saúde - HI (pacote Ecdat).",
       x = "Estimativa do Efeito Contrafactual nas Horas Trabalhadas por Semana",
       y = NULL) +
  theme_econ_base() +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank(), 
    panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4))

# Modelo Random Forest Normalizado ----

rf0_norm <- ranger(y ~ ., data = trn |> filter(t == 0) |> select(-t))

trn0_mad <- trn |> filter(t == 0) |> select(-t) |> mutate(res_abs = abs(y - rf0_norm$predictions)) |> 
  select(-y)

rf_mad <- ranger(res_abs ~ ., data = trn0_mad)

mu_hat_cal <- predict(rf0_norm, data = cal0)$predictions
sigma_hat_cal <- pmax(predict(rf_mad, data = cal0)$predictions, 1e-6)

mu_hat_tst <- predict(rf0_norm, data = tst1)$predictions
sigma_hat_tst <- pmax(predict(rf_mad, data = tst1)$predictions, 1e-6)

R <- abs(cal0$y - mu_hat_cal) / sigma_hat_cal

w_cal <- e_hat_cal[order(R)] / (1 - e_hat_cal[order(R)])
w_tst <- e_hat_tst / (1 - e_hat_tst)

threshold <- (1 - alpha) * (sum(w_cal) + w_tst)

k <- findInterval(threshold, cumsum(w_cal), left.open = TRUE) + 1

r_hat <- c(sort(R), Inf)[k]

lower_y0 <- mu_hat_tst - r_hat * sigma_hat_tst
upper_y0 <- mu_hat_tst + r_hat * sigma_hat_tst

lower_ite <- tst1$y - upper_y0
upper_ite <- tst1$y - lower_y0

summary(upper_ite - lower_ite)

mean_rfn <- mean(upper_ite - lower_ite)
prop_inf_rfn <- mean(upper_ite == Inf)
cov_zero_rfn <- mean(lower_ite <= 0 & 0 <= upper_ite)

tibble(id = 1:nrow(tst1), lower = lower_ite, upper = upper_ite) |>
  slice_sample(n = 30) |>
  mutate(ite_est = (lower + upper) / 2,
         status = case_when(lower > 0 ~ "Positivo", upper < 0 ~ "Negativo", TRUE ~ "Neutro"),
         id = fct_reorder(factor(id), lower)) |>
  ggplot(aes(ite_est, id, color = status)) +
  geom_vline(xintercept = 0, lty = 2, color = pal["black50"], linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("Positivo" = unname(pal["blue1"]), 
                                "Neutro" = unname(pal["grey_box"]), 
                                "Negativo" = unname(pal["econ_red"]))) +
  labs(title = "Efeitos Individuais de Tratamento (ITE)",
       subtitle = "Intervalos conformais (90%) estimados via Random Forest Normalizada em uma amostra de 30 mulheres.",
       caption = "Fonte: Elaboração própria com dados de Seguro de Saúde - HI (pacote Ecdat).",
       x = "Estimativa do Efeito Contrafactual nas Horas Trabalhadas por Semana",
       y = NULL) +
  theme_econ_base() +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank(), 
    panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4))

# Modelo Catboost Quantílico ----

cb_lo <- trn |> 
  filter(t == 0) |> 
  select(-t) |>
  (\(df) catboost.load_pool(data = select(df, -y), label = df$y))() |> 
  catboost.train(
    test_pool = NULL, 
    params = c(list(iterations = 200, logging_level = "Silent"), 
               list(loss_function = paste0("Quantile:alpha=", alpha_out))))

cb_hi <- trn |> 
  filter(t == 0) |> 
  select(-t) |> 
  (\(df) catboost.load_pool(data = select(df, -y), label = df$y))() |> 
  catboost.train(
    test_pool = NULL, 
    params = c(list(iterations = 200, logging_level = "Silent"), 
               list(loss_function = paste0("Quantile:alpha=", 1 - alpha_out))))

q_hat_cal_lo <- cal0 |> 
  select(-any_of(c("t", "y"))) |> 
  (\(df) catboost.load_pool(data = df))() |> 
  (\(pool) catboost.predict(cb_lo, pool))()

q_hat_cal_hi <- cal0 |> 
  select(-any_of(c("t", "y"))) |> 
  (\(df) catboost.load_pool(data = df))() |> 
  (\(pool) catboost.predict(cb_hi, pool))()

q_hat_tst_lo <- tst1 |> 
  select(-any_of(c("t", "y"))) |> 
  (\(df) catboost.load_pool(data = df))() |> 
  (\(pool) catboost.predict(cb_lo, pool))()

q_hat_tst_hi <- tst1 |> 
  select(-any_of(c("t", "y"))) |> 
  (\(df) catboost.load_pool(data = df))() |> 
  (\(pool) catboost.predict(cb_hi, pool))()

R <- pmax(q_hat_cal_lo - cal0$y, cal0$y - q_hat_cal_hi)

w_cal <- e_hat_cal[order(R)] / (1 - e_hat_cal[order(R)])
w_tst <- e_hat_tst / (1 - e_hat_tst)

threshold <- (1 - alpha) * (sum(w_cal) + w_tst)

k <- findInterval(threshold, cumsum(w_cal), left.open = TRUE) + 1

r_hat <- c(sort(R), Inf)[k]

lower_y0 <- q_hat_tst_lo - r_hat
upper_y0 <- q_hat_tst_hi + r_hat

lower_ite <- tst1$y - upper_y0
upper_ite <- tst1$y - lower_y0

summary(upper_ite - lower_ite)

mean_cbq <- mean(upper_ite - lower_ite)
prop_inf_cbq <- mean(upper_ite == Inf)
cov_zero_cbq <- mean(lower_ite <= 0 & 0 <= upper_ite) 

tibble(id = 1:nrow(tst1), lower = lower_ite, upper = upper_ite) |>
  slice_sample(n = 30) |>
  mutate(ite_est = (lower + upper) / 2,
         status = case_when(lower > 0 ~ "Positivo", upper < 0 ~ "Negativo", TRUE ~ "Neutro"),
         id = fct_reorder(factor(id), lower)) |>
  ggplot(aes(ite_est, id, color = status)) +
  geom_vline(xintercept = 0, lty = 2, color = pal["black50"], linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("Positivo" = unname(pal["blue1"]), 
                                "Neutro" = unname(pal["grey_box"]), 
                                "Negativo" = unname(pal["econ_red"]))) +
  labs(title = "Efeitos Individuais de Tratamento (ITE)",
       subtitle = "Intervalos conformais (90%) estimados via CatBoost Quantílico em uma amostra de 30 mulheres.",
       caption = "Fonte: Elaboração própria com dados de Seguro de Saúde - HI (pacote Ecdat).",
       x = "Estimativa do Efeito Contrafactual nas Horas Trabalhadas por Semana",
       y = NULL) +
  theme_econ_base() +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank(), 
    panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4))

# Resultados Colidados ----

(metricas_consolidadas <- tibble(
  modelo = c("Random Forest", "Quantile Forest Regression", 
             "BART", "Random Forest Normalizada", "CatBoost Quantílico"),
  n_cal = nrow(cal),
  n_cal0 = nrow(cal0),
  prop_infinitos = c(prop_inf_rf, prop_inf_qrf, prop_inf_bart, prop_inf_rfn, prop_inf_cbq),
  cobertura_zero = c(cov_zero_rf, cov_zero_qrf, cov_zero_bart, cov_zero_rfn, cov_zero_cbq),
  largura_media = c(mean_rf, mean_qrf, mean_bart, mean_rfn, mean_cbq)) |>
   labelled::set_variable_labels(
     modelo = "Arquitetura do Modelo Preditivo",
     prop_infinitos = "Taxa de Intervalos Não-Informativos (Eficiência)",
     cobertura_zero = "Taxa de Cobertura do Zero (Insignificância Causal)",
     largura_media = "Largura Média dos Intervalos Conformais"))
