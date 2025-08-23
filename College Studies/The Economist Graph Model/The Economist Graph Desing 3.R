# ============================================================
# Economist plotting core (ggplot2) — núcleo enxuto e modular
# ============================================================

# ---- Pacotes ----
library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)
library(scales)
library(rlang)
library(showtext)

# ---- Tipografia (fallback simples) ----
font_family <- if ("Roboto Condensed" %in% systemfonts::system_fonts()$family)
  "Roboto Condensed" else "sans"
showtext_auto()

# ---- Paleta “canônica” (a mesma que você usa) ----
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
    purple = "#924C7A", pink = "#DA3C78",
    orange = "#F7A11A", lime = "#B3D334"
  ),
  supporting_dark = c(
    navy = "#003D73", cyan_dk = "#005F73", green_dk = "#385F44"
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
    red="#A81829", blue="#00588D", cyan="#005F73", green="#005F52",
    yellow="#714C00", olive="#4C5900", purple="#78405F",
    gold="#674E1F", grey="#3F5661"
  )
)

# ---- Tokens base ----
econ_base <- list(
  bg   = econ_colors$background["print_bkgd"],
  grid = econ_colors$neutral["grid_lines"],
  text = "#0C0C0C"
)

# ---- Registro de esquemas de cor por tipo (1→6) ----
econ_scheme <- list(
  bars        = unname(c(econ_colors$main["blue1"], econ_colors$main["blue2"],
                         econ_colors$secondary["mustard"], econ_colors$secondary["teal"],
                         econ_colors$secondary["burgundy"], econ_colors$secondary["mauve"])),
  stacked     = unname(c(econ_colors$main["blue1"], econ_colors$main["blue2"],
                         econ_colors$secondary["mustard"], econ_colors$main["blue2_text"],
                         econ_colors$secondary["aqua"], econ_colors$equal_lightness["blue"])),
  lines_side  = unname(c(econ_colors$main["blue1"], econ_colors$main["blue2"],
                         econ_colors$secondary["mustard"], econ_colors$secondary["burgundy"],
                         econ_colors$main["blue2_text"], econ_colors$secondary["mauve"])),
  lines_stack = unname(c(econ_colors$main["blue1"], econ_colors$main["blue2"],
                         econ_colors$secondary["mustard"], econ_colors$main["blue2_text"],
                         econ_colors$secondary["aqua"], econ_colors$equal_lightness["blue"])),
  thermometer = unname(c(econ_colors$main["blue2"], econ_colors$secondary["burgundy"],
                         econ_colors$secondary["mustard"], econ_colors$main["blue1"],
                         econ_colors$main["blue2_text"], econ_colors$secondary["mauve"])),
  scatter     = unname(c(econ_colors$main["blue2"], econ_colors$secondary["burgundy"],
                         econ_colors$secondary["mustard"], econ_colors$main["blue1"],
                         econ_colors$main["blue2_text"], econ_colors$secondary["mauve"])),
  pie         = unname(c(econ_colors$main["blue1"], econ_colors$main["blue2"],
                         econ_colors$secondary["mustard"], econ_colors$main["blue2_text"],
                         econ_colors$secondary["burgundy"], econ_colors$secondary["aqua"]))
)

# ---- Tema base (uma vez só) ----
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
      plot.margin = margin(16, 16, 12, 16)
    )
}

# ---- Escalas “genéricas”: uma para colour e outra para fill ----
scale_econ <- function(aes = c("colour","fill"), scheme = c(names(econ_scheme)), reverse = FALSE, values = NULL, ...) {
  aes    <- match.arg(aes)
  scheme <- match.arg(scheme)
  pal <- if (is.null(values)) econ_scheme[[scheme]] else unname(values)
  if (reverse) pal <- rev(pal)
  if (aes == "colour") scale_colour_manual(values = pal, ...) else scale_fill_manual(values = pal, ...)
}

# ---- Formatadores compactos ----
fmt_lab <- function(kind = c("number","percent","si")) {
  kind <- match.arg(kind)
  switch(kind,
         number  = label_number(big.mark = ".", decimal.mark = ","),
         percent = label_percent(),
         si      = label_number(scale_cut = cut_short_scale()))
}

# ---- Export helpers ----
pt_to_in <- function(pt) pt/72
save_econ <- function(plot, width_pt = 332, height_in = 6, dpi = 300, filename = "economist_plot.png") {
  ggsave(filename, plot = plot, width = pt_to_in(width_pt), height = height_in, dpi = dpi, bg = econ_base$bg)
}

# ============================================================
# GEOMS/FUNÇÕES ÚNICAS (sem repetição de paletas ou tema)
# ============================================================

# 1) Barras lado a lado (ou simples)
econ_bar_side <- function(data, x, y, fill = NULL, horizontal = TRUE,
                          scheme = "bars", width = 0.66, dodge = 0.7,
                          legend = TRUE,
                          labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                          format_values = c("number","percent","si")) {
  
  format_values <- match.arg(format_values)
  p <- ggplot(data, aes({{x}}, {{y}}))
  if (!quo_is_null(enquo(fill))) p <- p + aes(fill = {{fill}})
  
  p <- p + geom_col(width = width, position = if (!quo_is_null(enquo(fill))) position_dodge(dodge) else "stack")
  
  if (!quo_is_null(enquo(fill))) p <- p + scale_econ("fill", scheme)
  
  if (format_values == "percent") p <- p + scale_y_continuous(labels = fmt_lab("percent"))
  if (format_values == "si")      p <- p + scale_y_continuous(labels = fmt_lab("si"))
  if (horizontal) p <- p + coord_flip()
  
  p <- p + theme_econ_base()
  if (quo_is_null(enquo(fill)) || !legend) p <- p + guides(fill = "none")
  
  p + labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

# 2) Barras empilhadas (normal/100%), com “Other” cinza opcional
econ_bar_stacked <- function(data, x, y, fill, percent = FALSE, horizontal = FALSE,
                             other_levels = NULL, scheme = "stacked",
                             width = 0.66, legend = TRUE,
                             labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                             format_values = c("number","percent","si")) {
  
  format_values <- match.arg(format_values)
  p <- ggplot(data, aes({{x}}, {{y}}, fill = {{fill}})) +
    geom_col(width = width, position = if (percent) "fill" else "stack")
  
  # paleta nomeada (permite cinza p/ “Other”)
  lvls <- levels(factor(pull(data, {{fill}})))
  pal  <- rep(econ_scheme[[scheme]], length.out = length(lvls))
  names(pal) <- lvls
  if (!is.null(other_levels)) pal[names(pal) %in% other_levels] <- econ_colors$neutral["grey_box"]
  p <- p + scale_fill_manual(values = pal)
  
  if (percent || format_values == "percent") p <- p + scale_y_continuous(labels = fmt_lab("percent"))
  else if (format_values == "si")           p <- p + scale_y_continuous(labels = fmt_lab("si"))
  if (horizontal) p <- p + coord_flip()
  
  p <- p + theme_econ_base()
  if (!legend) p <- p + guides(fill = "none")
  
  p + labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

# 3) Linhas lado a lado
econ_line_side <- function(data, x, y, colour, linewidth = 1.1, legend = TRUE,
                           scheme = "lines_side",
                           labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                           format_y = c("number","percent","si")) {
  
  format_y <- match.arg(format_y)
  
  p <- ggplot(data, aes({{x}}, {{y}}, colour = {{colour}})) +
    geom_line(linewidth = linewidth, lineend = "round") +
    scale_econ("colour", scheme) +
    theme_econ_base()
  
  if (format_y == "percent") p <- p + scale_y_continuous(labels = fmt_lab("percent"))
  if (format_y == "si")      p <- p + scale_y_continuous(labels = fmt_lab("si"))
  if (!legend)               p <- p + guides(colour = "none")
  
  p + labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

# 4) Linhas empilhadas (área), absoluta ou 100%
econ_line_stacked <- function(data, x, y, fill, percent = FALSE, legend = TRUE, alpha = 0.95,
                              scheme = "lines_stack",
                              labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                              format_y = c("number","percent","si"), legend_reverse = FALSE) {
  
  format_y <- match.arg(format_y)
  p <- ggplot(data, aes({{x}}, {{y}}, fill = {{fill}})) +
    geom_area(position = if (percent) "fill" else "stack", alpha = alpha, colour = NA) +
    scale_econ("fill", scheme) +
    theme_econ_base()
  
  if (percent || format_y == "percent") p <- p + scale_y_continuous(labels = fmt_lab("percent"))
  else if (format_y == "si")           p <- p + scale_y_continuous(labels = fmt_lab("si"))
  
  if (!legend) p <- p + guides(fill = "none")
  else if (legend_reverse) p <- p + guides(fill = guide_legend(reverse = TRUE))
  
  p + labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

# 5) Thermometer (haste + ponto) ou só pontos
econ_thermometer <- function(data, category, value, group = NULL,
                             segments = TRUE, stem_size = 0.6, dot_size = 2.6,
                             legend = TRUE, scheme = "thermometer",
                             labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                             format_x = c("number","percent","si")) {
  
  format_x <- match.arg(format_x)
  df <- data %>%
    mutate(.cat = fct_rev(fct_inorder({{category}})),
           .grp = if (quo_is_null(enquo(group))) factor("value") else fct_inorder({{group}}))
  
  p <- ggplot(df, aes(x = {{value}}, y = .cat, colour = .grp))
  if (segments) p <- p + geom_segment(aes(x = 0, xend = {{value}}, y = .cat, yend = .cat),
                                      inherit.aes = FALSE, colour = econ_base$grid,
                                      linewidth = stem_size, lineend = "round")
  p <- p + geom_point(size = dot_size, stroke = 0) +
    scale_econ("colour", scheme) +
    theme_econ_base() +
    theme(panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4)) +
    expand_limits(x = 0)
  
  if (!legend || nlevels(df$.grp) == 1) p <- p + guides(colour = "none") else
    p <- p + guides(colour = guide_legend(override.aes = list(linetype = 0, size = 3)))
  
  if (format_x == "percent") p <- p + scale_x_continuous(labels = fmt_lab("percent"), expand = expansion(mult = c(0, .02)))
  if (format_x == "si")      p <- p + scale_x_continuous(labels = fmt_lab("si"),      expand = expansion(mult = c(0, .02)))
  
  p + labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

# 6) Scatter / Bubble / Connected
econ_scatter <- function(data, x, y, colour = NULL, size_var = NULL,
                         style = c("standard","bubble"),
                         highlight = NULL, trendline = FALSE,
                         labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL),
                         format_x = c("number","percent","si"),
                         format_y = c("number","percent","si"),
                         scheme = "scatter") {
  
  style <- match.arg(style); format_x <- match.arg(format_x); format_y <- match.arg(format_y)
  aes_base <- aes({{x}}, {{y}})
  if (!quo_is_null(enquo(colour)))  aes_base$colour <- enquo(colour)
  if (!quo_is_null(enquo(size_var))) aes_base$size   <- enquo(size_var)
  
  p <- ggplot(data, aes_base)
  if (style == "standard") p <- p + geom_point(alpha = 0.5, size = 2.2, stroke = 0, shape = 16)
  else p <- p + geom_point(alpha = 0.5, size = 3.2, shape = 21, colour = econ_base$text, stroke = 0.3,
                           aes(fill = {{colour}}))
  
  if (style == "standard" && !quo_is_null(enquo(colour))) p <- p + scale_econ("colour", scheme)
  if (style == "bubble"   && !quo_is_null(enquo(colour))) p <- p + scale_econ("fill",   scheme)
  
  # highlight avaliado no data
  hq <- enquo(highlight)
  if (!quo_is_null(hq)) {
    hv <- eval_tidy(hq, data = data)
    if (is.logical(hv) && length(hv) == nrow(data) && any(hv, na.rm = TRUE)) {
      d_hi <- data[which(hv %in% TRUE), , drop = FALSE]
      aes_hi <- aes({{x}}, {{y}})
      if (!quo_is_null(enquo(colour))) {
        if (style == "standard") aes_hi$colour <- enquo(colour) else aes_hi$fill <- enquo(colour)
      }
      if (style == "standard") p <- p + geom_point(data = d_hi, aes_hi, alpha = 1, size = 2.6, shape = 16, stroke = 0)
      else p <- p + geom_point(data = d_hi, aes_hi, alpha = 1, size = 3.6, shape = 21, colour = econ_base$text, stroke = 0.3)
    }
  }
  
  if (trendline) p <- p + geom_smooth(method = "lm", se = FALSE, linewidth = 0.4, linetype = "22",
                                      colour = econ_base$text, alpha = 0.9)
  
  if (!quo_is_null(enquo(size_var))) p <- p + scale_size_area(max_size = 10, guide = "none")
  if (format_x == "percent") p <- p + scale_x_continuous(labels = fmt_lab("percent"))
  if (format_x == "si")      p <- p + scale_x_continuous(labels = fmt_lab("si"))
  if (format_y == "percent") p <- p + scale_y_continuous(labels = fmt_lab("percent"))
  if (format_y == "si")      p <- p + scale_y_continuous(labels = fmt_lab("si"))
  
  p + theme_econ_base() +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(colour = econ_base$grid, linewidth = 0.4)) +
    labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

econ_scatter_connected <- function(data, x, y, series, order_var, colour = series,
                                   linewidth = 0.6, size = 2.2, scheme = "scatter",
                                   labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption=NULL)) {
  
  ggplot(data, aes({{x}}, {{y}}, group = {{series}}, colour = {{colour}})) +
    geom_path(linewidth = linewidth, lineend = "round") +
    geom_point(size = size, alpha = 0.8) +
    scale_econ("colour", scheme) +
    theme_econ_base() +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(colour = econ_base$grid, linewidth = 0.4)) +
    labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption)
}

# 7) Pie / Doughnut
econ_pie <- function(data, cat, val, type = c("pie","doughnut"),
                     top_n = NULL, other_label = "Outros",
                     show_labels = TRUE, label_kind = c("percent","value","both"),
                     min_pct_label = 0.06, hole_text = NULL,
                     start = 0, direction = 1,
                     title = NULL, subtitle = NULL, caption = "Fonte: Exemplo sintético",
                     scheme = "pie") {
  
  type <- match.arg(type); label_kind <- match.arg(label_kind)
  
  df <- as_tibble(data) %>%
    group_by({{cat}}) %>%
    summarise(valor = sum({{val}}, na.rm = TRUE), .groups = "drop") %>%
    arrange(desc(valor))
  
  # colapsa excedente em “Outros”
  if (!is.null(top_n) && nrow(df) > top_n) {
    df <- bind_rows(
      df %>% slice(1:top_n),
      tibble(`{{cat}}` := other_label,
             valor = sum(df$valor[(top_n+1):nrow(df)], na.rm = TRUE))
    )
    names(df)[1] <- as_name(enquo(cat))
  }
  
  total <- sum(df$valor)
  df <- df %>%
    mutate(
      pct  = valor/total,
      lab  = case_when(
        label_kind == "percent" ~ label_percent(accuracy = 1)(pct),
        label_kind == "value"   ~ label_number(big.mark = ".", decimal.mark = ",")(valor),
        TRUE ~ paste0(label_percent(accuracy = 1)(pct), " (",
                      label_number(big.mark = ".", decimal.mark = ",")(valor), ")")
      ),
      cat_f = fct_inorder({{cat}})
    )
  
  pal <- econ_scheme[[scheme]]
  if (any(df[[1]] %in% other_label, na.rm = TRUE)) pal <- c(pal, econ_base$grid)
  pal <- rep(pal, length.out = length(levels(df$cat_f))); names(pal) <- levels(df$cat_f)
  
  base_theme <- theme_void(base_family = font_family) +
    theme(plot.background  = element_rect(fill = econ_base$bg, colour = NA),
          panel.background = element_rect(fill = econ_base$bg, colour = NA),
          legend.position  = "none",
          plot.title    = element_text(face = "bold", size = 20, hjust = 0, colour = econ_base$text),
          plot.subtitle = element_text(size = 12.5, hjust = 0, colour = econ_base$text),
          plot.caption  = element_text(size = 9, hjust = 1, colour = econ_base$text),
          plot.margin   = margin(16,16,14,16))
  
  if (type == "pie") {
    g <- ggplot(df, aes(x = 1, y = valor, fill = cat_f)) +
      geom_col(width = 1, colour = econ_base$bg, linewidth = 0.6) +
      coord_polar(theta = "y", start = start, direction = direction) +
      scale_fill_manual(values = pal) + base_theme
  } else {
    g <- ggplot(df, aes(x = 2, y = valor, fill = cat_f)) +
      geom_col(width = 1, colour = econ_base$bg, linewidth = 0.6) +
      coord_polar(theta = "y", start = start, direction = direction) +
      xlim(0.5, 2.5) + scale_fill_manual(values = pal) + base_theme
    
    if (!is.null(hole_text))
      g <- g + annotate("text", x = 0, y = 0, label = hole_text,
                        family = font_family, colour = econ_base$text,
                        size = 4, lineheight = 1.05, fontface = "bold")
  }
  
  if (show_labels)
    g <- g + geom_text(data = df %>% filter(pct >= min_pct_label),
                       aes(label = lab), position = position_stack(vjust = 0.5),
                       family = font_family, size = 3.2, colour = econ_base$text)
  
  g + labs(title = title, subtitle = subtitle, caption = caption)
}

# 8) Timelines (dados + períodos + eventos)
.make_alternating <- function(n) rep(c(TRUE, FALSE), length.out = n)

econ_timeline_data <- function(data, x, y, series = NULL,
                               periods = NULL, events = NULL,
                               labels = list(title=NULL, subtitle=NULL, x=NULL, y=NULL, caption="Fonte: Exemplo sintético"),
                               format_y = c("number","percent","si"),
                               linewidth = 1.1, legend = TRUE,
                               scheme = "lines_side") {
  
  format_y <- match.arg(format_y)
  y_vec <- dplyr::pull(data, {{y}})
  yr <- range(y_vec, na.rm = TRUE); dy <- diff(yr); y_top <- yr[2]; y_bot <- yr[1]
  
  p <- ggplot()
  
  if (!is.null(periods) && nrow(periods) > 0) {
    per_df <- tibble(periods) %>%
      mutate(shade = .make_alternating(n()), xmid = (start + end)/2)
    
    p <- p +
      geom_rect(data = filter(per_df, shade),
                aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf),
                inherit.aes = FALSE,
                fill = econ_colors$background["highlight"], colour = NA) +
      geom_text(data = per_df,
                aes(x = xmid, y = y_bot + 0.04*dy, label = label),
                inherit.aes = FALSE,
                family = font_family, size = 3.2, fontface = "bold",
                colour = econ_base$text)
  }
  
  aes_line <- if (quo_is_null(enquo(series))) aes({{x}}, {{y}})
  else aes({{x}}, {{y}}, colour = {{series}})
  p <- p + geom_line(data = data, mapping = aes_line, linewidth = linewidth, lineend = "round")
  if (!quo_is_null(enquo(series))) p <- p + scale_econ("colour", scheme)
  
  if (!is.null(events) && nrow(events) > 0) {
    ev_df <- tibble(events) %>%
      mutate(y0 = y_top - 0.02*dy, y1 = y_top - 0.14*dy,
             hjust = rep(c(0,1), length.out = n()), xlab = date + ifelse(hjust == 0, 0.2, -0.2))
    
    p <- p +
      geom_segment(data = ev_df,
                   aes(x = date, xend = date, y = y0, yend = y1),
                   inherit.aes = FALSE, linewidth = 0.4,
                   arrow = grid::arrow(length = unit(3, "pt"), type = "closed"),
                   colour = econ_base$text) +
      geom_text(data = ev_df,
                aes(x = xlab, y = y1 - 0.02*dy, label = label, hjust = hjust),
                inherit.aes = FALSE, family = font_family, size = 3.2, colour = econ_base$text)
  }
  
  if (format_y == "percent") p <- p + scale_y_continuous(labels = fmt_lab("percent"))
  if (format_y == "si")      p <- p + scale_y_continuous(labels = fmt_lab("si"))
  
  p + theme_econ_base() +
    labs(title = labels$title, subtitle = labels$subtitle, x = labels$x, y = labels$y, caption = labels$caption) +
    if (!legend) guides(colour = "none")
}

# =====================================================
# EXEMPLOS DE USO — um (ou dois) por tipo de gráfico
# =====================================================

## 1) BARRAS LADO A LADO (side-by-side)
set.seed(10)
df_bar1 <- tibble(
  pais  = c("Alemanha","Áustria","Espanha","França","Itália","Portugal"),
  valor = round(runif(6, 20, 80), 0)
) %>% mutate(pais = fct_reorder(pais, valor))

econ_bar_side(
  df_bar1, x = pais, y = valor, legend = FALSE,
  labels = list(
    title = "Consultas médicas por pessoa",
    subtitle = "Países selecionados; barras ordenadas",
    caption = "Fonte: Exemplo sintético"
  )
)

# Variante com 2 séries lado a lado
set.seed(11)
df_bar2 <- tibble(
  pais  = rep(c("Chile","Brasil","México","Malásia","Polônia","Índia"), each = 2),
  grupo = rep(c("Classe média","Baixa renda"), times = 6),
  valor = runif(12, 0.10, 0.80)
)
econ_bar_side(
  df_bar2, x = pais, y = valor, fill = grupo, format_values = "percent",
  labels = list(
    title = "Defensores da democracia",
    subtitle = "Proporção dizendo que eleições são muito importantes",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

## 2) BARRAS EMPILHADAS (normal e 100%)
set.seed(20)
df_stack1 <- tibble(
  segmento = rep(c("All mobiles","Smartphones"), each = 4),
  operador = rep(c("AT&T","T-Mobile","Verizon","Other"), times = 2),
  share    = c(30, 18, 22, 10, 44, 16, 12, 8)
)
econ_bar_stacked(
  df_stack1, x = segmento, y = share, fill = operador,
  other_levels = "Other",
  labels = list(
    title = "Market share por segmento",
    subtitle = "Operadoras selecionadas; barras empilhadas",
    x = NULL, y = "Unidades", caption = "Fonte: Exemplo sintético"
  )
)

# 100% empilhada (horizontal) com “Other” em cinza
set.seed(21)
df_stack2 <- tibble(
  ano   = rep(2018:2022, each = 5),
  canal = rep(c("Paid search","Display","Classified","Online video","Other"), times = 5),
  share = runif(25, 5, 35)
) %>%
  group_by(ano) %>%
  mutate(share = share/sum(share)) %>%
  ungroup()
econ_bar_stacked(
  df_stack2, x = ano, y = share, fill = canal,
  percent = TRUE, horizontal = TRUE, other_levels = "Other",
  labels = list(
    title = "Gasto em publicidade digital por canal",
    subtitle = "Barras empilhadas 100%",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

## 3) LINHAS LADO A LADO
set.seed(42)
df_line3 <- tidyr::crossing(
  ano = 2010:2024,
  serie = c("Japão","EUA","Alemanha")
) %>%
  group_by(serie) %>%
  arrange(ano, .by_group = TRUE) %>%
  mutate(
    base  = 10 + 0.8 * as.integer(factor(serie)),
    valor = base + cumsum(rnorm(n(), 0, 0.2))
  ) %>%
  ungroup()
econ_line_side(
  df_line3, x = ano, y = valor, colour = serie,
  labels = list(
    title = "Linhas lado a lado (3 séries)",
    subtitle = "Ordem de cor oficial do guia",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)

## 4) LINHAS EMPILHADAS (área absoluta e 100%)
set.seed(123)
df_area_abs <- tidyr::crossing(
  ano   = 2005:2020,
  grupo = c("China","Outros países em desenvolvimento","Índia","Brasil","Rússia")
) %>%
  group_by(grupo) %>%
  arrange(ano, .by_group = TRUE) %>%
  mutate(
    base  = c(5, 3.5, 2.8, 2.4, 2.0)[as.integer(factor(grupo))],
    fluxo = base + cumsum(abs(rnorm(n(), 0.05, 0.05)))
  ) %>%
  ungroup()
econ_line_stacked(
  df_area_abs, x = ano, y = fluxo, fill = grupo,
  labels = list(
    title = "Linhas empilhadas (área)",
    subtitle = "Soma absoluta por grupo",
    x = NULL, y = "Unidades", caption = "Fonte: Exemplo sintético"
  )
)

set.seed(321)
df_area_pct <- tidyr::crossing(
  ano   = 2010:2022,
  grupo = c("Setor A","Setor B","Setor C","Setor D","Setor E","Setor F")
) %>%
  group_by(ano) %>%
  mutate(share = rgamma(n(), 2, 1)) %>%
  mutate(share = share/sum(share)) %>%
  ungroup()
econ_line_stacked(
  df_area_pct, x = ano, y = share, fill = grupo,
  percent = TRUE,
  labels = list(
    title = "Linhas empilhadas 100%",
    subtitle = "Participação relativa por ano",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

## 5) TERMÔMETRO (haste+ponto e só pontos)
set.seed(7)
disc <- c("Matemática","Economia","Computação","Administração","Biologia",
          "Filosofia","História","Inglês","Comunicação","Sociologia")
df_th3 <- tidyr::crossing(disciplina = disc, grupo = c("um","dois","três")) %>%
  mutate(valor = round(runif(n(), 20, 400), 0))
econ_thermometer(
  df_th3, category = disciplina, value = valor, group = grupo,
  segments = TRUE,
  labels = list(
    title = "Thermometer chart (3 linhas)",
    subtitle = "Hastes cinza finas + pontos coloridos",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

set.seed(9)
df_th4 <- tidyr::crossing(disciplina = disc, grupo = paste("G", 1:4)) %>%
  mutate(valor = runif(n(), 0.05, 1))
econ_thermometer(
  df_th4, category = disciplina, value = valor, group = grupo,
  segments = FALSE,                       # “dot terminals”
  format_x = "percent",
  labels = list(
    title = "Thermometer (dot terminals)",
    subtitle = "Apenas pontos quando hastes atrapalham",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

## 6) DISPERSÃO (padrão + highlight; bubble; connected)
set.seed(1)
n <- 200
df_sc <- tibble(
  emprego = rnorm(n, 50, 15),
  renda   = 0.5*emprego + rnorm(n, 0, 10) + 40,
  regiao  = sample(c("Norte","Sul","Leste","Oeste"), n, TRUE)
) %>% mutate(outlier = renda > quantile(renda, .97))
econ_scatter(
  df_sc, x = emprego, y = renda, colour = regiao,
  style = "standard", highlight = outlier, trendline = TRUE,
  labels = list(
    title = "Dispersão padrão",
    subtitle = "Pontos 50% opacos; destaques 100% + linha de tendência",
    x = "Emprego", y = "Renda", caption = "Fonte: Exemplo sintético"
  )
)

set.seed(2)
df_bub <- tibble(
  x = runif(120, 0, 1), y = runif(120, 0, 1),
  cat = sample(paste("C", 1:5), 120, TRUE),
  pop = rexp(120, 3) * 1e6
)
econ_scatter(
  df_bub, x = x, y = y, colour = cat, size_var = pop,
  style = "bubble", format_x = "percent", format_y = "percent",
  labels = list(
    title = "Bubble chart (category dot)",
    subtitle = "Contorno fino, preenchimento 50% e tamanho proporcional",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

set.seed(3)
df_conn <- crossing(pais = c("Japão","EUA","França"), ano = 2010:2020) %>%
  arrange(pais, ano) %>%
  group_by(pais) %>%
  mutate(x = cumsum(rnorm(n(), 0.4, 0.5)) + 10,
         y = cumsum(rnorm(n(), 0.5, 0.6)) + 10,
         grupo = pais) %>%
  ungroup()
econ_scatter_connected(
  df_conn, x = x, y = y, series = pais, order_var = ano, colour = grupo,
  labels = list(
    title = "Connected scatter",
    subtitle = "Linhas ligando a trajetória por país",
    x = NULL, y = NULL, caption = "Fonte: Exemplo sintético"
  )
)

## 7) PIZZA / ROSCA
df_pie <- tibble(categoria = c("A","B","C","D"), valor = c(42, 28, 18, 12))
econ_pie(
  df_pie, cat = categoria, val = valor, type = "pie",
  title = "Participação por segmento",
  subtitle = "Pizza com ordem de cor do guia"
)

label_si_br <- scales::label_number(scale_cut = scales::cut_short_scale(),
                                    big.mark = ".", decimal.mark = ",")
df_donut <- tibble(
  setor = c("Automotivo","Tecnologia","Serviços","Energia","Varejo","Outros nichos"),
  v     = c(23, 19, 17, 14, 11, 9)
)
econ_pie(
  df_donut, cat = setor, val = v,
  type = "doughnut", top_n = 5,
  hole_text = paste0("Total\n", label_si_br(sum(df_donut$v))),
  title = "Receita por setor",
  subtitle = "Rosca com ‘Outros’ em cinza"
)

## 8) SÉRIES TEMPORAIS / TIMELINES
set.seed(10)
anos <- 2004:2024
df_ts <- tibble(
  ano   = rep(anos, 2),
  serie = rep(c("Petróleo (índice)","PIB real (índice)"), each = length(anos)),
  valor = c(
    90 + cumsum(rnorm(length(anos), 0.5, 2)),
    100 + cumsum(rnorm(length(anos), 0.2, 1.2))
  )
)
periodos <- tribble(
  ~start, ~end, ~label,
  2005, 2009, "Período A",
  2009, 2017, "Período B",
  2017, 2021, "Período C",
  2021, 2024, "Período D"
)
eventos <- tribble(
  ~date, ~label,
  2008, "Crise", 2014, "Choque", 2020, "Pandemia", 2022, "Reabertura"
)
econ_timeline_data(
  df_ts, x = ano, y = valor, series = serie,
  periods = periodos, events = eventos,
  labels = list(
    title = "Séries temporais com períodos e eventos",
    subtitle = "Faixas alternadas marcam eras; setas indicam eventos",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)

# timeline simples (1 série + eventos; sem legenda)
set.seed(99)
df_ts1 <- tibble(ano = anos, valor = 50 + cumsum(rnorm(length(anos), 0.3, 1.5)))
eventos2 <- tribble(
  ~date, ~label,
  2007, "Mudança\nregulatória",
  2012, "Novo\nproduto",
  2019, "Aquisição"
)
econ_timeline_data(
  df_ts1, x = ano, y = valor, series = NULL,
  periods = periodos[2:4,], events = eventos2, legend = FALSE,
  labels = list(
    title = "Timeline de dados (1 série)",
    subtitle = "Eventos com rótulos curtos; sem legenda",
    x = NULL, y = "Índice", caption = "Fonte: Exemplo sintético"
  )
)
