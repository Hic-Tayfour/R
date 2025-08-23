# ---- Pacotes ----
library(tidyverse)
library(scales)
library(showtext)

# ---- Tipografia (fallback simples) ----
font_family <- if ("Roboto Condensed" %in% systemfonts::system_fonts()$family) "Roboto Condensed" else "sans"
showtext_auto()

# ---- Paletas Economist (exatamente as que você passou) ----
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
    pink   = "#DA3C78",
    orange = "#F7A11A",
    lime   = "#B3D334"
  ),
  supporting_dark = c(
    navy     = "#003D73",
    cyan_dk  = "#005F73",
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
    red    = "#A81829",
    blue   = "#00588D",
    cyan   = "#005F73",
    green  = "#005F52",
    yellow = "#714C00",
    olive  = "#4C5900",
    purple = "#78405F",
    gold   = "#674E1F",
    grey   = "#3F5661"
  )
)

# ---- Tokens base (lendo de econ_colors) ----
econ_base <- list(
  bg   = econ_colors$background["print_bkgd"],
  grid = econ_colors$neutral["grid_lines"],
  text = "#0C0C0C" # preto institucional para textos; grey_text fica disponível se quiser usar
)

# ---- Ordem oficial para barras (1→6) ----
econ_order6 <- unname(c(
  econ_colors$main["blue1"],
  econ_colors$main["blue2"],
  econ_colors$secondary["mustard"],
  econ_colors$secondary["teal"],
  econ_colors$secondary["burgundy"],
  econ_colors$secondary["mauve"]
))

# ---- Scales helpers (usando as listas acima) ----
scale_fill_econ <- function(palette = c("order6","equal_lightness","main","secondary",
                                        "supporting_bright","supporting_dark","neutral"),
                            values = NULL, reverse = FALSE, ...) {
  pal <- switch(match.arg(palette),
                order6 = econ_order6,
                equal_lightness = econ_colors$equal_lightness,
                main = econ_colors$main,
                secondary = econ_colors$secondary,
                supporting_bright = econ_colors$supporting_bright,
                supporting_dark   = econ_colors$supporting_dark,
                neutral = econ_colors$neutral)
  pal <- if (!is.null(values)) values else pal
  pal <- unname(pal)
  if (reverse) pal <- rev(pal)
  scale_fill_manual(values = pal, ...)
}

scale_colour_econ <- function(palette = c("order6","equal_lightness","main","secondary",
                                          "supporting_bright","supporting_dark","neutral"),
                              values = NULL, reverse = FALSE, ...) {
  pal <- switch(match.arg(palette),
                order6 = econ_order6,
                equal_lightness = econ_colors$equal_lightness,
                main = econ_colors$main,
                secondary = econ_colors$secondary,
                supporting_bright = econ_colors$supporting_bright,
                supporting_dark   = econ_colors$supporting_dark,
                neutral = econ_colors$neutral)
  pal <- if (!is.null(values)) values else pal
  pal <- unname(pal)
  if (reverse) pal <- rev(pal)
  scale_colour_manual(values = pal, ...)
}

# ---- Tema base no padrão The Economist ----
theme_econ_base <- function(base_family = font_family) {
  theme_minimal(base_family = base_family) +
    theme(
      plot.background  = element_rect(fill = econ_base$bg, colour = NA),
      panel.background = element_rect(fill = econ_base$bg, colour = NA),
      plot.title.position = "plot",
      plot.title    = element_text(face = "bold", size = 20, hjust = 0, colour = econ_base$text, margin = margin(b = 2)),
      plot.subtitle = element_text(size = 12.5, hjust = 0, colour = econ_base$text, margin = margin(b = 8)),
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
      plot.margin = margin(t = 16, r = 16, b = 12, l = 16)
    )
}

# ---- Exportação em pontos ----
pt_to_in <- function(pt) pt/72
save_econ <- function(plot, width_pt = 332, height_in = 6, dpi = 300, filename = "economist_plot.png") {
  ggsave(filename, plot = plot, width = pt_to_in(width_pt), height = height_in, dpi = dpi)
}

# ========= Barras lado a lado (The Economist) =========
# Requer: econ_colors, econ_order6, theme_econ_base(), scale_fill_econ(), econ_base

econ_bar_side <- function(data,
                          x, y,
                          fill = NULL,                  # grupo (para side-by-side)
                          horizontal = TRUE,            # TRUE = barras horizontais
                          palette = "order6",
                          legend = TRUE,
                          width = 0.66, dodge = 0.7,
                          labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                          format_values = c("number","percent","si")) {
  
  format_values <- match.arg(format_values)
  
  # mapeamentos
  p <- ggplot(data, aes({{x}}, {{y}}))
  has_fill <- !rlang::quo_is_null(rlang::enquo(fill))
  if (has_fill) p <- p + aes(fill = {{fill}})
  
  # geometria + cor
  if (has_fill) {
    p <- p + geom_col(width = width, position = position_dodge(width = dodge)) +
      scale_fill_econ(palette = palette)
  } else {
    p <- p + geom_col(width = width, fill = unname(econ_order6[1]))
  }
  
  # formatação do eixo de valores (é o Y antes do flip)
  if (format_values == "percent") p <- p + scale_y_continuous(labels = scales::label_percent())
  if (format_values == "si")      p <- p + scale_y_continuous(labels = scales::label_number_si())
  
  # orientação
  if (horizontal) p <- p + coord_flip()
  
  # tema + legenda
  p <- p + theme_econ_base()
  if (!has_fill || !legend) p <- p + guides(fill = "none")
  
  # labels
  p + labs(
    title    = labels$title,
    subtitle = labels$subtitle,
    x = labels$x, y = labels$y,
    caption  = labels$caption
  )
}


# ===================== EXEMPLOS RÁPIDOS =====================

# 1) Uma série (sem legenda), horizontal
set.seed(10)
df_bar1 <- tibble(
  pais = c("Alemanha","Áustria","Espanha","França","Itália","Portugal"),
  valor = round(runif(6, 20, 80), 0)
)
p1 <- econ_bar_side(
  df_bar1, x = pais, y = valor,
  labels = list(
    title = "Consultas médicas por pessoa",
    subtitle = "Países selecionados; barras ordenadas por valor",
    caption = "Fonte: Exemplo sintético"
  ),
  legend = FALSE
)

print(p1)

# 2) Duas séries lado a lado (dodge), horizontal
set.seed(11)
df_bar2 <- tibble(
  pais = rep(c("Chile","Brasil","México","Malásia","Polônia","Índia"), each = 2),
  grupo = rep(c("Classe média","Baixa renda"), times = 6),
  valor = runif(12, 0.10, 0.80)  # proporções
)
p2 <- econ_bar_side(
  df_bar2, x = pais, y = valor, fill = grupo,
  labels = list(
    title = "Defensores da democracia",
    subtitle = "Proporção dizendo que eleições são muito importantes",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  ),
  format_values = "percent"
)
print(p2)

# dados (mesmos do exemplo)
set.seed(10)
df_bar1 <- tibble(
  pais = c("Alemanha","Áustria","Espanha","França","Itália","Portugal"),
  valor = round(runif(6, 20, 80), 0)
) %>%
  # opcional: ordenar as barras por valor (do menor ao maior; mude `decreasing = TRUE` se preferir)
  mutate(pais = forcats::fct_reorder(pais, valor, .desc = FALSE))

# cada barra com uma cor; legenda oculta
p1_multi <- econ_bar_side(
  df_bar1,
  x = pais, y = valor,
  fill = pais,                # <- chave para colorir cada barra
  legend = FALSE,             # sem legenda
  labels = list(
    title = "Consultas médicas por pessoa",
    subtitle = "Países selecionados; cada barra com uma cor da ordem oficial",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

print(p1_multi)

# Requer: econ_colors, theme_econ_base(), scale_fill_econ(), econ_base (já definidos no núcleo)

# Paleta para empilhadas (ordem da página Stacked)
econ_stack6 <- unname(c(
  econ_colors$main["blue1"],        # 1
  econ_colors$main["blue2"],        # 2
  econ_colors$secondary["mustard"], # 3
  econ_colors$main["blue2_text"],   # 4 (teal do guia)
  econ_colors$secondary["aqua"],    # 5
  econ_colors$equal_lightness["blue"] # 6 (azul escuro)
))

# ---- Função: Barras Empilhadas (normal ou 100%) ----
econ_bar_stacked <- function(data,
                             x, y, fill,
                             percent = FALSE,         # TRUE = 100% stacked
                             horizontal = FALSE,       # TRUE = barras horizontais
                             legend = TRUE,
                             other_levels = NULL,      # c("Other","Não sabe")
                             width = 0.66,
                             labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                             format_values = c("number","percent","si")) {
  
  format_values <- match.arg(format_values)
  
  # base
  p <- ggplot(data, aes({{x}}, {{y}}, fill = {{fill}})) +
    geom_col(width = width, position = if (percent) "fill" else "stack")
  
  # montar paleta nomeada (permite cinza para 'Outros')
  fill_sym <- rlang::ensym(fill)
  lvls <- levels(factor(dplyr::pull(data, !!fill_sym)))
  pal_named <- setNames(rep_len(econ_stack6, length(lvls)), lvls)
  if (!is.null(other_levels)) {
    pal_named[names(pal_named) %in% other_levels] <- econ_colors$neutral["grey_box"]
  }
  p <- p + scale_fill_manual(values = pal_named)
  
  # formatação do eixo de valores (y antes do flip; em percent, rotulo %)
  if (percent || format_values == "percent") {
    p <- p + scale_y_continuous(labels = scales::label_percent())
  } else if (format_values == "si") {
    p <- p + scale_y_continuous(labels = scales::label_number_si())
  }
  
  # orientação
  if (horizontal) p <- p + coord_flip()
  
  # tema + legenda
  p <- p + theme_econ_base()
  if (!legend) p <- p + guides(fill = "none")
  
  # grade correta (após possível flip)
  if (horizontal) {
    p <- p +
      theme(panel.grid.major.y = element_blank(),
            panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4))
  }
  
  # labels
  p + labs(
    title    = labels$title,
    subtitle = labels$subtitle,
    x = labels$x, y = labels$y,
    caption  = labels$caption
  )
}

# ===================== EXEMPLOS =====================

# 1) Empilhada normal (coluna vertical)
set.seed(20)
df_stack1 <- tibble(
  segmento = rep(c("All mobiles","Smartphones"), each = 4),
  operador = rep(c("AT&T","T-Mobile","Verizon","Other"), times = 2),
  share    = c(30, 18, 22, 10, 44, 16, 12, 8)
)
p_stack1 <- econ_bar_stacked(
  df_stack1, x = segmento, y = share, fill = operador,
  percent = FALSE, horizontal = FALSE,
  other_levels = c("Other"),
  labels = list(
    title = "Market share por segmento",
    subtitle = "Operadoras selecionadas; barras empilhadas",
    x = NULL, y = "Unidades", caption = "Fonte: Exemplo sintético"
  ),
  format_values = "number"
)
print(p_stack1)

# 2) Empilhada 100% (horizontal) com 'Outros' em cinza e eixo em %
set.seed(21)
df_stack2 <- tibble(
  ano   = rep(2018:2022, each = 5),
  canal = rep(c("Paid search","Display","Classified","Online video","Other"), times = 5),
  share = runif(25, 5, 35)
) %>%
  group_by(ano) %>%
  mutate(share = share/sum(share)) %>%
  ungroup()

p_stack2 <- econ_bar_stacked(
  df_stack2, x = ano, y = share, fill = canal,
  percent = TRUE, horizontal = TRUE,
  other_levels = c("Other"),
  labels = list(
    title = "Gasto em publicidade digital por canal",
    subtitle = "Barras empilhadas 100%",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  ),
  format_values = "percent"
)
print(p_stack2)

# ====== Linhas lado a lado (The Economist) ======
# Requer: econ_colors, theme_econ_base(), econ_base já carregados no seu "núcleo"

# Ordem de cores para LINHAS (como na página "Lines – side-by-side")
econ_line_order6 <- unname(c(
  econ_colors$main["blue1"],        # 1
  econ_colors$main["blue2"],        # 2
  econ_colors$secondary["mustard"], # 3
  econ_colors$secondary["burgundy"],# 4
  econ_colors$main["blue2_text"],   # 5 (teal)
  econ_colors$secondary["mauve"]    # 6
))

# Função
econ_line_side <- function(data,
                           x, y, colour,                   # mapeamentos
                           linewidth = 1.1,                # espessura
                           legend = TRUE,                  # mostrar legenda?
                           labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                           format_y = c("number","percent","si")) {
  
  format_y <- match.arg(format_y)
  
  p <- ggplot(data, aes({{x}}, {{y}}, colour = {{colour}})) +
    geom_line(linewidth = linewidth, lineend = "round") +
    scale_colour_manual(values = econ_line_order6) +
    theme_econ_base()
  
  # formatação do eixo Y
  if (format_y == "percent") p <- p + scale_y_continuous(labels = scales::label_percent())
  if (format_y == "si")      p <- p + scale_y_continuous(labels = scales::label_number_si())
  
  # legenda
  if (!legend) p <- p + guides(colour = "none")
  
  # rótulos
  p + labs(
    title    = labels$title,
    subtitle = labels$subtitle,
    x = labels$x, y = labels$y,
    caption  = labels$caption
  )
}

# ------------- EXEMPLOS (dados sintéticos) -------------

# -------- Exemplo A: 3 linhas --------
set.seed(42)
df_line3 <- tidyr::crossing(
  ano = 2010:2024,
  serie = c("Japão","EUA","Alemanha")
) %>%
  dplyr::group_by(serie) %>%
  dplyr::arrange(ano, .by_group = TRUE) %>%
  dplyr::mutate(
    base  = 10 + 0.8 * as.integer(factor(serie)),
    valor = base + cumsum(rnorm(dplyr::n(), 0, 0.2))
  ) %>%
  dplyr::ungroup()

p_line3 <- econ_line_side(
  df_line3, x = ano, y = valor, colour = serie,
  labels = list(
    title = "Linhas lado a lado (3 séries)",
    subtitle = "Sem marcadores; ordem de cor oficial do guia",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)
print(p_line3)

# -------- Exemplo B: 6 linhas --------
set.seed(99)
df_line6 <- tidyr::crossing(
  ano = 2010:2024,
  serie = paste0("S", 1:6)
) %>%
  dplyr::group_by(serie) %>%
  dplyr::arrange(ano, .by_group = TRUE) %>%
  dplyr::mutate(
    base  = 10 + 0.7 * as.integer(factor(serie)),
    valor = base + cumsum(rnorm(dplyr::n(), 0, 0.3))
  ) %>%
  dplyr::ungroup()

p_line6 <- econ_line_side(
  df_line6, x = ano, y = valor, colour = serie,
  labels = list(
    title = "Linhas lado a lado (6 séries)",
    subtitle = "Cores: azul, ciano, mostarda, bordô, teal, malva",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)
print(p_line6)

# Paleta para linhas/áreas empilhadas (ordem do guia)
econ_line_stack_order6 <- unname(c(
  econ_colors$main["blue1"],        # 1
  econ_colors$main["blue2"],        # 2
  econ_colors$secondary["mustard"], # 3
  econ_colors$main["blue2_text"],   # 4 (teal)
  econ_colors$secondary["aqua"],    # 5
  econ_colors$equal_lightness["blue"] # 6 (azul escuro)
))

# ---- Função: Linhas Empilhadas (área) ----
econ_line_stacked <- function(data,
                              x, y, fill,
                              percent = FALSE,            # TRUE = 100%
                              legend  = TRUE,
                              alpha   = 0.95,             # transparência leve
                              labels  = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                              format_y = c("number","percent","si"),
                              legend_reverse = FALSE) {
  
  format_y <- match.arg(format_y)
  
  p <- ggplot(data, aes({{x}}, {{y}}, fill = {{fill}})) +
    geom_area(position = if (percent) "fill" else "stack",
              alpha = alpha, colour = NA) +
    scale_fill_manual(values = econ_line_stack_order6) +
    theme_econ_base()
  
  # eixo Y
  if (percent || format_y == "percent") {
    p <- p + scale_y_continuous(labels = scales::label_percent())
  } else if (format_y == "si") {
    p <- p + scale_y_continuous(labels = scales::label_number_si())
  }
  
  # legenda
  if (!legend) {
    p <- p + guides(fill = "none")
  } else if (legend_reverse) {
    p <- p + guides(fill = guide_legend(reverse = TRUE))
  }
  
  # rótulos
  p + labs(
    title    = labels$title,
    subtitle = labels$subtitle,
    x = labels$x, y = labels$y,
    caption  = labels$caption
  )
}

# ---------------- EXEMPLOS ----------------

# A) Área empilhada (absoluta)
set.seed(123)
df_area_abs <- tidyr::crossing(
  ano   = 2005:2020,
  grupo = c("China","Outros países em desenvolvimento","Índia","Brasil","Rússia")
) %>%
  dplyr::group_by(grupo) %>%
  dplyr::arrange(ano, .by_group = TRUE) %>%
  dplyr::mutate(
    base  = c(5, 3.5, 2.8, 2.4, 2.0)[as.integer(factor(grupo))],
    fluxo = base + cumsum(abs(rnorm(dplyr::n(), 0.05, 0.05)))
  ) %>%
  dplyr::ungroup()

p_area_abs <- econ_line_stacked(
  df_area_abs, x = ano, y = fluxo, fill = grupo,
  percent = FALSE,
  labels = list(
    title = "Linhas empilhadas (área)",
    subtitle = "Soma absoluta por grupo",
    x = NULL, y = "Unidades", caption = "Fonte: Exemplo sintético"
  ),
  format_y = "number"
)
print(p_area_abs)

# B) Área empilhada 100%
set.seed(321)
df_area_pct <- tidyr::crossing(
  ano   = 2010:2022,
  grupo = c("Setor A","Setor B","Setor C","Setor D","Setor E","Setor F")
) %>%
  dplyr::group_by(ano) %>%
  dplyr::mutate(valor = rgamma(dplyr::n(), shape = 2, rate = 1)) %>%
  dplyr::group_by(ano) %>%
  dplyr::mutate(share = valor / sum(valor)) %>%
  dplyr::ungroup()

p_area_pct <- econ_line_stacked(
  df_area_pct, x = ano, y = share, fill = grupo,
  percent = TRUE,
  labels = list(
    title = "Linhas empilhadas 100%",
    subtitle = "Participação relativa por ano",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  ),
  format_y = "percent",
  legend_reverse = TRUE   # opcional: legenda de cima para baixo acompanhar a pilha
)
print(p_area_pct)

# Paleta na ordem do guia (1→6): ciano, bordô, mostarda, azul, teal, malva
econ_thermo_order6 <- unname(c(
  econ_colors$main["blue2"],        # 1
  econ_colors$secondary["burgundy"],# 2
  econ_colors$secondary["mustard"], # 3
  econ_colors$main["blue1"],        # 4
  econ_colors$main["blue2_text"],   # 5 (teal)
  econ_colors$secondary["mauve"]    # 6
))

# -------- Thermometer no padrão do guia --------
econ_thermometer <- function(data,
                             category, value,
                             group = NULL,
                             segments = TRUE,           # TRUE = haste + ponto; FALSE = só ponto
                             stem_size = 0.6,           # haste bem fina
                             dot_size  = 2.6,
                             legend = TRUE,
                             labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                             format_x = c("number","percent","si")) {
  
  format_x <- match.arg(format_x)
  
  # preparar fatores (y invertido para ordem de cima p/ baixo)
  df <- data %>%
    dplyr::mutate(
      .cat = forcats::fct_rev(forcats::fct_inorder({{category}})),
      .grp = if (rlang::quo_is_null(rlang::enquo(group))) factor("value")
      else forcats::fct_inorder({{group}})
    )
  
  # base
  p <- ggplot(df, aes(x = {{value}}, y = .cat, colour = .grp))
  
  # haste neutra e fina (uma por observação), sem herdar a cor
  if (segments) {
    p <- p + geom_segment(aes(x = 0, xend = {{value}}, y = .cat, yend = .cat),
                          inherit.aes = FALSE,
                          colour = econ_colors$neutral["grid_lines"],
                          linewidth = stem_size, lineend = "round")
  }
  
  # ponto colorido por série (o elemento que comunica a cor)
  p <- p + geom_point(size = dot_size, stroke = 0)
  
  # paleta por série (recicla se >6)
  pal <- rep(econ_thermo_order6, length.out = nlevels(df$.grp))
  names(pal) <- levels(df$.grp)
  p <- p + scale_colour_manual(values = pal)
  
  # formatação eixo X
  if (format_x == "percent") p <- p + scale_x_continuous(labels = scales::label_percent(), expand = expansion(mult = c(0, .02)))
  if (format_x == "si")      p <- p + scale_x_continuous(labels = scales::label_number_si(), expand = expansion(mult = c(0, .02)))
  if (format_x == "number")  p <- p + scale_x_continuous(expand = expansion(mult = c(0, .02)))
  
  # tema: grid apenas vertical
  p <- p + theme_econ_base() +
    theme(
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4)
    ) +
    expand_limits(x = 0)
  
  # legenda só com pontos (sem linhas)
  if (!legend || nlevels(df$.grp) == 1) {
    p <- p + guides(colour = "none")
  } else {
    p <- p + guides(colour = guide_legend(override.aes = list(linetype = 0, size = 3)))
  }
  
  # rótulos
  p + labs(
    title    = labels$title,
    subtitle = labels$subtitle,
    x = labels$x, y = labels$y,
    caption  = labels$caption
  )
}

# ---------------- Exemplos ----------------

# 1) 3 linhas por disciplina, 0–400 (parecido com a página do guia)
set.seed(7)
disc <- c("Matemática","Economia","Computação","Administração","Biologia",
          "Filosofia","História","Inglês","Comunicação","Sociologia")
df_th3 <- tidyr::crossing(
  disciplina = disc,
  grupo = c("um","dois","três")
) %>%
  dplyr::mutate(valor = round(runif(dplyr::n(), 20, 400), 0))

p_th3 <- econ_thermometer(
  df_th3, category = disciplina, value = valor, group = grupo,
  segments = TRUE,
  labels = list(
    title = "Thermometer chart (3 linhas)",
    subtitle = "Hastes cinza finas + pontos coloridos por série",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  ),
  format_x = "number"
)
print(p_th3)

# 2) Variante “dot terminals” (só pontos) em %
set.seed(9)
df_th4 <- tidyr::crossing(
  disciplina = disc,
  grupo = paste("G", 1:4)
) %>%
  dplyr::mutate(valor = runif(dplyr::n(), 0.05, 1))

p_th4 <- econ_thermometer(
  df_th4, category = disciplina, value = valor, group = grupo,
  segments = FALSE,
  labels = list(
    title = "Thermometer chart (dot terminals)",
    subtitle = "Apenas pontos quando as hastes atrapalham",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  ),
  format_x = "percent"
)
print(p_th4)

# ===== Scatter (The Economist) =====
# Requer: econ_colors, theme_econ_base(), econ_base já definidos

# Paleta na ordem do guia p/ scatter
econ_scatter_order6 <- unname(c(
  econ_colors$main["blue2"],        # 1 ciano
  econ_colors$secondary["burgundy"],# 2 bordô
  econ_colors$secondary["mustard"], # 3 mostarda
  econ_colors$main["blue1"],        # 4 azul
  econ_colors$main["blue2_text"],   # 5 teal
  econ_colors$secondary["mauve"]    # 6 malva
))

# ----- Função principal -----
# --- PATCH: versão robusta de econ_scatter() (apenas o trecho do highlight mudou) ---

econ_scatter <- function(data,
                         x, y,
                         colour = NULL,
                         size_var = NULL,
                         style = c("standard","bubble"),
                         highlight = NULL,          # <- aceita coluna ou vetor lógico
                         trendline = FALSE,
                         trend_by_group = FALSE,
                         labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                         format_x = c("number","percent","si"),
                         format_y = c("number","percent","si")) {
  
  style    <- match.arg(style)
  format_x <- match.arg(format_x)
  format_y <- match.arg(format_y)
  
  aes_base <- aes({{x}}, {{y}})
  if (!rlang::quo_is_null(rlang::enquo(colour))) aes_base$colour <- rlang::enquo(colour)
  if (!rlang::quo_is_null(rlang::enquo(size_var))) aes_base$size   <- rlang::enquo(size_var)
  
  p <- ggplot(data, aes_base)
  
  if (style == "standard") {
    p <- p + geom_point(alpha = 0.5, size = 2.2, stroke = 0, shape = 16)
  } else {
    p <- p + geom_point(alpha = 0.5, size = 3.2, shape = 21,
                        colour = econ_base$text, stroke = 0.3,
                        aes(fill = {{colour}}))
  }
  
  if (style == "standard") {
    if (!rlang::quo_is_null(rlang::enquo(colour)))
      p <- p + scale_colour_manual(values = econ_scatter_order6)
  } else {
    if (!rlang::quo_is_null(rlang::enquo(colour)))
      p <- p + scale_fill_manual(values = econ_scatter_order6)
  }
  
  # === HIGHLIGHT corrigido: avalia dentro de `data` ===
  h_quo <- rlang::enquo(highlight)
  if (!rlang::quo_is_null(h_quo)) {
    hi_vec <- rlang::eval_tidy(h_quo, data = data)
    if (is.logical(hi_vec) && length(hi_vec) == nrow(data) && any(hi_vec, na.rm = TRUE)) {
      d_hi <- data[which(hi_vec %in% TRUE), , drop = FALSE]
      aes_hi <- aes({{x}}, {{y}})
      if (!rlang::quo_is_null(rlang::enquo(colour))) {
        if (style == "standard") aes_hi$colour <- rlang::enquo(colour) else aes_hi$fill <- rlang::enquo(colour)
      }
      if (style == "standard") {
        p <- p + geom_point(data = d_hi, aes_hi, alpha = 1, size = 2.6, shape = 16, stroke = 0)
      } else {
        p <- p + geom_point(data = d_hi, aes_hi, alpha = 1, size = 3.6, shape = 21,
                            colour = econ_base$text, stroke = 0.3)
      }
    }
  }
  # === fim do trecho corrigido ===
  
  if (trendline) {
    p <- p + geom_smooth(method = "lm", se = FALSE,
                         linewidth = 0.4, linetype = "22",
                         colour = econ_base$text, alpha = 0.9)
  }
  
  if (!rlang::quo_is_null(rlang::enquo(size_var)))
    p <- p + scale_size_area(max_size = 10, guide = "none")
  
  if (format_x == "percent") p <- p + scale_x_continuous(labels = scales::label_percent())
  if (format_x == "si")      p <- p + scale_x_continuous(labels = scales::label_number_si())
  if (format_y == "percent") p <- p + scale_y_continuous(labels = scales::label_percent())
  if (format_y == "si")      p <- p + scale_y_continuous(labels = scales::label_number_si())
  
  p + theme_econ_base() +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(colour = econ_base$grid, linewidth = 0.4)) +
    labs(title = labels$title, subtitle = labels$subtitle,
         x = labels$x, y = labels$y, caption = labels$caption)
}

# ---- Exemplo que tinha falhado (agora funciona) ----
set.seed(1)
n <- 200
df_sc <- tibble(
  emprego   = rnorm(n, 50, 15),
  renda     = 0.5*emprego + rnorm(n, 0, 10) + 40,
  regiao    = sample(c("Norte","Sul","Leste","Oeste"), n, TRUE)
) %>%
  dplyr::mutate(outlier = renda > quantile(renda, .97))

p_sc_standard <- econ_scatter(
  df_sc, x = emprego, y = renda, colour = regiao,
  style = "standard", highlight = outlier, trendline = TRUE,
  labels = list(
    title = "Dispersão padrão",
    subtitle = "Pontos 50% opacos; destaques 100% + linha de tendência",
    x = "Emprego", y = "Renda", caption = "Fonte: Exemplo sintético"
  )
)
print(p_sc_standard)

# 2) Bubble (category dot: contorno fino + fill 50%) com tamanho
set.seed(2)
df_bub <- tibble(
  x = runif(120, 0, 1),
  y = runif(120, 0, 1),
  cat = sample(paste("C", 1:5), 120, TRUE),
  pop = rexp(120, 3) * 1e6
)

p_sc_bubble <- econ_scatter(
  df_bub, x = x, y = y, colour = cat, size_var = pop,
  style = "bubble",
  labels = list(
    title = "Bubble chart (category dot)",
    subtitle = "Contorno ~0.3px, fill 50% e tamanho proporcional",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  ),
  format_x = "percent", format_y = "percent"
)
print(p_sc_bubble)

# 3) Connected scatter
set.seed(3)
df_conn <- crossing(
  pais  = c("Japão","EUA","França"),
  ano   = 2010:2020
) %>%
  arrange(pais, ano) %>%
  group_by(pais) %>%
  mutate(x = cumsum(rnorm(n(), 0.4, 0.5)) + 10,
         y = cumsum(rnorm(n(), 0.5, 0.6)) + 10,
         grupo = pais) %>%
  ungroup()

p_sc_connected <- econ_scatter_connected(
  df_conn, x = x, y = y, series = pais, order_var = ano, colour = grupo,
  labels = list(
    title = "Connected scatter",
    subtitle = "Linhas ligando a trajetória por país",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)
print(p_sc_connected)

# ====== PIE / DOUGHNUT (The Economist) ======
# Requer: econ_colors, econ_base, theme_econ_base(), font_family já definidos

# Paleta na ORDEM do guia para pie/doughnut
econ_pie_order6 <- unname(c(
  econ_colors$main["blue1"],        # 1 azul
  econ_colors$main["blue2"],        # 2 ciano
  econ_colors$secondary["mustard"], # 3 mostarda
  econ_colors$main["blue2_text"],   # 4 teal
  econ_colors$secondary["burgundy"],# 5 bordô
  econ_colors$secondary["aqua"]     # 6 aqua
))

# Função utilitária: formata rótulos (% / valor / ambos)
# ===== PATCH: econ_pie() com rótulos corrigidos =====
econ_pie <- function(data, cat, val,
                     type = c("pie","doughnut"),
                     top_n = NULL, other_label = "Outros",
                     show_labels = TRUE, label_kind = c("percent","value","both"),
                     min_pct_label = 0.06,
                     hole_text = NULL,
                     start = 0, direction = 1,
                     title = NULL, subtitle = NULL, caption = "Fonte: Exemplo sintético") {
  
  type <- match.arg(type)
  label_kind <- match.arg(label_kind)
  
  df <- dplyr::as_tibble(data) %>%
    dplyr::group_by({{cat}}) %>%
    dplyr::summarise(valor = sum({{val}}, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(dplyr::desc(valor))
  
  if (!is.null(top_n) && nrow(df) > top_n) {
    df <- dplyr::bind_rows(
      df %>% dplyr::slice(1:top_n),
      tibble(`{{cat}}` := other_label,
             valor = sum(df$valor[(top_n+1):nrow(df)], na.rm = TRUE))
    )
    names(df)[1] <- rlang::as_name(rlang::enquo(cat))
  }
  
  total <- sum(df$valor)
  df <- df %>%
    dplyr::mutate(
      pct   = valor / total,
      lab = dplyr::case_when(
        label_kind == "percent" ~ scales::label_percent(accuracy = 1)(pct),
        label_kind == "value"   ~ scales::label_number(big.mark = ".", decimal.mark = ",")(valor),
        TRUE ~ paste0(scales::label_percent(accuracy = 1)(pct), " (",
                      scales::label_number(big.mark = ".", decimal.mark = ",")(valor), ")")
      ),
      cat_f = forcats::fct_inorder(!!rlang::enquo(cat))
    )
  
  # paleta (adiciona cinza para "Outros" se aparecer)
  pal <- econ_pie_order6
  if (any(df[[1]] %in% other_label, na.rm = TRUE)) pal <- c(pal, econ_base$grid)
  pal <- rep(pal, length.out = length(levels(df$cat_f)))
  names(pal) <- levels(df$cat_f)
  
  base_theme <- theme_void(base_family = font_family) +
    theme(
      plot.background  = element_rect(fill = econ_base$bg, colour = NA),
      panel.background = element_rect(fill = econ_base$bg, colour = NA),
      legend.position = "none",
      plot.title    = element_text(face = "bold", size = 20, hjust = 0, colour = econ_base$text),
      plot.subtitle = element_text(size = 12.5, hjust = 0, colour = econ_base$text),
      plot.caption  = element_text(size = 9,  hjust = 1, colour = econ_base$text),
      plot.margin   = margin(16,16,14,16)
    )
  
  if (type == "pie") {
    g <- ggplot(df, aes(x = 1, y = valor, fill = cat_f)) +
      geom_col(width = 1, colour = econ_base$bg, linewidth = 0.6) +
      coord_polar(theta = "y", start = start, direction = direction) +
      scale_fill_manual(values = pal) + base_theme +
      labs(title = title, subtitle = subtitle, caption = caption)
  } else {
    g <- ggplot(df, aes(x = 2, y = valor, fill = cat_f)) +
      geom_col(width = 1, colour = econ_base$bg, linewidth = 0.6) +
      coord_polar(theta = "y", start = start, direction = direction) +
      xlim(0.5, 2.5) +
      scale_fill_manual(values = pal) + base_theme +
      labs(title = title, subtitle = subtitle, caption = caption)
    
    if (!is.null(hole_text)) {
      g <- g + annotate("text", x = 0, y = 0, label = hole_text,
                        family = font_family, colour = econ_base$text,
                        size = 4, lineheight = 1.05, fontface = "bold")
    }
  }
  
  if (show_labels) {
    g <- g + geom_text(
      data = df %>% dplyr::filter(pct >= min_pct_label),
      aes(label = lab),
      position = position_stack(vjust = 0.5),
      family = font_family, size = 3.2, colour = econ_base$text
    )
  }
  
  g
}


# ====== EXEMPLOS (os mesmos que deram erro) ======

# Ex. 1 — Pizza
df_pie <- tibble(
  categoria = c("A","B","C","D"),
  valor = c(42, 28, 18, 12)
)
p_pie <- econ_pie(
  df_pie, cat = categoria, val = valor,
  type = "pie",
  title = "Participação por segmento",
  subtitle = "Pizza com ordem de cor do guia"
)
print(p_pie)

# Ex. 2 — Rosca com “Outros” + texto central
# Helper para rótulos "SI" (k, M, B) — substitui label_number_si()
label_si_br <- scales::label_number(
  scale_cut    = scales::cut_short_scale(),  # k, M, B…
  big.mark     = ".",                        # milhar
  decimal.mark = ","                         # decimal
)

# Ex. 2 — Rosca com “Outros” + texto central (refeito)
df_donut <- tibble(
  setor = c("Automotivo","Tecnologia","Serviços","Energia","Varejo","Outros nichos"),
  v     = c(23, 19, 17, 14, 11, 9)
)

p_donut <- econ_pie(
  df_donut, cat = setor, val = v,
  type = "doughnut", top_n = 5,
  hole_text = paste0("Total\n", label_si_br(sum(df_donut$v))), # << aqui o ajuste
  title = "Receita por setor",
  subtitle = "Rosca com ‘Outros’ em cinza"
)

print(p_donut)


# ---------------------------------------------
# Timelines no padrão The Economist
# Requer: tidyverse, scales, showtext e seu núcleo (econ_base, theme_econ_base, econ_line_order6)
# ---------------------------------------------

# Função auxiliar: cria faixas alternadas (TRUE/ FALSE)
.make_alternating <- function(n) rep(c(TRUE, FALSE), length.out = n)

# Função principal: timeline de dados com períodos e eventos
econ_timeline_data <- function(data,
                               x, y, series = NULL,
                               periods = NULL,      # tibble com cols: start, end, label
                               events  = NULL,      # tibble com cols: date, label
                               labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption="Fonte: Exemplo sintético"),
                               format_y = c("number","percent","si"),
                               linewidth = 1.1,
                               legend = TRUE) {
  
  format_y <- match.arg(format_y)
  
  # Preparar ranges para posicionar anotações
  y_vec <- dplyr::pull(data, {{y}})
  yr    <- range(y_vec, na.rm = TRUE)
  dy    <- diff(yr)
  y_top <- yr[2]
  y_bot <- yr[1]
  
  p <- ggplot()
  
  # --- faixas de períodos (alternadas) ---
  if (!is.null(periods) && nrow(periods) > 0) {
    per_df <- dplyr::as_tibble(periods) %>%
      dplyr::mutate(shade = .make_alternating(dplyr::n()),
                    xmid  = (start + end) / 2)
    
    p <- p +
      geom_rect(data = dplyr::filter(per_df, shade),
                aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf),
                inherit.aes = FALSE,
                fill = econ_colors$background["highlight"], colour = NA) +
      geom_text(data = per_df,
                aes(x = xmid, y = y_bot + 0.04*dy, label = label),
                inherit.aes = FALSE,
                family = font_family, size = 3.2, fontface = "bold",
                colour = econ_base$text)
  }
  
  # --- séries (1 ou mais) ---
  aes_line <- if (rlang::quo_is_null(rlang::enquo(series))) aes({{x}}, {{y}})
  else aes({{x}}, {{y}}, colour = {{series}})
  
  p <- p + geom_line(data = data, mapping = aes_line,
                     linewidth = linewidth, lineend = "round")
  
  # paleta de linhas
  if (!rlang::quo_is_null(rlang::enquo(series))) {
    p <- p + scale_colour_manual(values = econ_line_order6)
  }
  
  # --- eventos (linhas finas com seta e rótulo curto) ---
  if (!is.null(events) && nrow(events) > 0) {
    ev_df <- dplyr::as_tibble(events) %>%
      dplyr::mutate(
        y0 = y_top - 0.02*dy,
        y1 = y_top - 0.14*dy,
        hjust = rep(c(0,1), length.out = dplyr::n()),
        xlab  = date + ifelse(hjust == 0, 0.2, -0.2)
      )
    
    p <- p +
      geom_segment(data = ev_df,
                   aes(x = date, xend = date, y = y0, yend = y1),
                   inherit.aes = FALSE,
                   linewidth = 0.4,
                   arrow = grid::arrow(length = unit(3, "pt"), type = "closed"),
                   colour = econ_base$text) +
      geom_text(data = ev_df,
                aes(x = xlab, y = y1 - 0.02*dy, label = label, hjust = hjust),
                inherit.aes = FALSE,
                family = font_family, size = 3.2, colour = econ_base$text)
  }
  
  # --- formatação do eixo Y ---
  if (format_y == "percent") p <- p + scale_y_continuous(labels = scales::label_percent())
  if (format_y == "si")      p <- p + scale_y_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale()))
  
  # --- tema/legenda/rótulos ---
  if (!legend) p <- p + guides(colour = "none")
  
  p +
    theme_econ_base() +
    labs(title = labels$title, subtitle = labels$subtitle,
         x = labels$x, y = labels$y, caption = labels$caption)
}

# ---------------------------
# EXEMPLO 1 — Timeline de dados com 2 séries, períodos e eventos
# ---------------------------
set.seed(10)
anos <- 2004:2024
df_ts <- tibble(
  ano = rep(anos, 2),
  serie = rep(c("Petróleo (índice)","PIB real (índice)"), each = length(anos)),
  valor = c(
    90 + cumsum(rnorm(length(anos), 0.5, 2)),
    100 + cumsum(rnorm(length(anos), 0.2, 1.2))
  )
)

periodos <- tribble(
  ~start, ~end, ~label,
  2005,   2009, "Período A",
  2009,   2017, "Período B",
  2017,   2021, "Período C",
  2021,   2024, "Período D"
)

eventos <- tribble(
  ~date, ~label,
  2008, "Crise",
  2014, "Choque",
  2020, "Pandemia",
  2022, "Reabertura"
)

p_tl <- econ_timeline_data(
  df_ts, x = ano, y = valor, series = serie,
  periods = periodos, events = eventos,
  labels = list(
    title = "Séries temporais com períodos e eventos",
    subtitle = "Faixas alternadas marcam eras; setas indicam eventos",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)

print(p_tl)

# ---------------------------
# EXEMPLO 2 — Timeline simples (1 série + eventos, sem legenda)
# ---------------------------
set.seed(99)
df_ts1 <- tibble(
  ano = anos,
  valor = 50 + cumsum(rnorm(length(anos), 0.3, 1.5))
)

eventos2 <- tribble(
  ~date, ~label,
  2007, "Mudança\nregulatória",
  2012, "Novo\nproduto",
  2019, "Aquisição"
)

p_tl2 <- econ_timeline_data(
  df_ts1, x = ano, y = valor, series = NULL,
  periods = periodos[2:4,], events = eventos2,
  legend = FALSE,
  labels = list(
    title = "Timeline de dados (1 série)",
    subtitle = "Eventos com rótulos curtos; sem legenda",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)

print(p_tl2)

# Sugestão de exportação fiel ao fundo:
# ggsave("timeline_econ_1.png", p_tl,  width = 9, height = 6, dpi = 300, bg = econ_base$bg)
# ggsave("timeline_econ_2.png", p_tl2, width = 9, height = 6, dpi = 300, bg = econ_base$bg)
