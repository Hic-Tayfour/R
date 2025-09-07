# ---- Pacotes ----
library(tidyverse)
library(scales)
library(gt)
library(systemfonts)
library(htmltools)

# ---- Paleta ----
econ_cols <- list(
  text      = "#0C0C0C",
  grey_text = "#3F5661",
  stripe1   = "#E9EDF0",
  stripe2   = "#DDE8EF",
  grid      = "#B7C6CF"
)

# ---- Tema: uma única linha de grade sob rótulos; sem outras linhas ----
economist_gt_theme_one_rule <- function(gt_tbl, font_family = "Roboto Condensed") {
  ft <- try(gt::google_font(font_family), silent = TRUE)
  if (inherits(ft, "try-error")) ft <- gt::default_fonts()
  
  gt_tbl |>
    opt_table_font(font = list(ft, default_fonts())) |>
    tab_options(
      table.background.color          = econ_cols$stripe1,
      heading.background.color        = econ_cols$stripe1,
      column_labels.background.color  = econ_cols$stripe1,
      table.border.top.color          = "transparent",
      table.border.bottom.color       = "transparent",
      row.striping.include_table_body = TRUE,
      row.striping.background_color   = econ_cols$stripe2,
      table.font.size                 = px(13)
    ) |>
    # zera quaisquer bordas do corpo e dos rótulos
    tab_style(
      style = cell_borders(sides = c("top","bottom","left","right"),
                           color = "transparent", weight = px(0)),
      locations = list(
        cells_body(rows = everything(), columns = everything()),
        cells_column_labels(everything())
      )
    ) |>
    # garante que não há linha logo abaixo do subtítulo
    tab_style(
      style = cell_borders(sides = "bottom", color = "transparent", weight = px(0)),
      locations = cells_title(groups = "subtitle")
    ) |>
    # rótulos: bold + 75k
    tab_style(
      style = cell_text(color = econ_cols$grey_text, weight = "bold"),
      locations = cells_column_labels(everything())
    ) |>
    # divisor ÚNICO sob os rótulos
    tab_style(
      style = cell_borders(sides = "bottom", color = econ_cols$grid, weight = px(2)),
      locations = cells_column_labels(everything())
    ) |>
    # título/subtítulo à esquerda; subtítulo menor
    tab_style(style = cell_text(weight = "bold", align = "left", color = econ_cols$text),
              locations = cells_title(groups = "title")) |>
    tab_style(style = cell_text(align = "left", color = econ_cols$grey_text, size = px(12)),
              locations = cells_title(groups = "subtitle"))
}

# ---- Dados ----
gh <- tribble(
  ~company,    ~value_bn, ~joined, ~expl,
  "Airbnb",     25.5,     2009,    "Rents out places to stay for local hosts",
  "Dropbox",    10.0,     2007,    "File storage in the cloud",
  "Stripe",      5.0,     2010,    "Software for selling from within apps",
  "Zenefits",    4.5,     2013,    "Online HR and payroll services",
  "Instacart",   2.0,     2012,    "Grocery collection and delivery service",
  "Docker",      1.1,     2010,    "Platform to manage distribution of software"
) |>
  mutate(
    company_md = paste0(
      "**", company, "**<br>",
      "<span style='color:", econ_cols$grey_text, "; font-size:12px;'>", expl, "</span>"
    ),
    value_lbl  = number(value_bn, accuracy = 0.1)
  )

# ---- Tabela final ----
gt_greatest <-
  gh |>
  transmute(
    Company = company_md,
    `Value* ($bn)` = value_lbl,
    `Date of joining` = as.character(joined)
  ) |>
  gt() |>
  economist_gt_theme_one_rule() |>
  fmt_markdown(columns = Company) |>
  cols_align(align = "right", columns = c(`Value* ($bn)`, `Date of joining`)) |>
  tab_style(style = cell_text(weight = "bold", color = econ_cols$text),
            locations = cells_body(columns = c(`Value* ($bn)`, `Date of joining`))) |>
  cols_width(Company ~ px(360), everything() ~ px(140)) |>
  tab_header(
    title    = md("**Greatest hits**"),
    subtitle = "Largest Y Combinator–funded startups"
  ) |>
  tab_source_note(
    html(
      "<div style='display:flex; justify-content:space-between; width:100%;'>
         <span>Sources: CB Insights; CrunchBase</span>
         <span>*Latest funding round</span>
       </div>"
    )
  )

# Exibir
gt_greatest
