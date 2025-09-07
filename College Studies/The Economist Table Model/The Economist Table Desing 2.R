# ---- Pacotes ----
library(tidyverse)
library(scales)
library(gt)
library(systemfonts)
library(glue)

# ---- Paleta Economist ----
econ <- list(
  text       = "#0C0C0C",
  grey75     = "#3F5661",
  box        = "#E9EDF0",
  grid       = "#B7C6CF",
  blue1      = "#006BA2",   # apps (escuro)
  blue2      = "#3EBCD2",   # decisions (claro)
  mustard    = "#E6B83C",
  red        = "#E3120B"
)

# ---- Tema (caixa única, regras finas, rótulos neutros) ----
theme_econ_integrated <- function(gt_tbl, font_family = "Roboto Condensed") {
  ft <- try(gt::google_font(font_family), silent = TRUE)
  if (inherits(ft, "try-error")) ft <- gt::default_fonts()
  
  gt_tbl |>
    opt_table_font(font = list(ft, default_fonts())) |>
    tab_options(
      table.background.color         = econ$box,
      heading.background.color       = econ$box,
      column_labels.background.color = econ$box,
      table.border.top.color         = "transparent",
      table.border.bottom.color      = "transparent",
      table.font.size                = px(13)
    ) |>
    # fundo uniforme + linhas divisórias horizontais
    tab_style(
      style = list(
        cell_fill(color = econ$box),
        cell_borders(sides = "bottom", color = econ$grid, weight = px(1))
      ),
      locations = cells_body(rows = everything())
    ) |>
    # rótulos: neutros (sem bold), divisor único mais marcado
    tab_style(style = cell_text(color = econ$grey75, weight = "normal"),
              locations = cells_column_labels(everything())) |>
    tab_style(style = cell_borders(sides = "bottom", color = econ$grid, weight = px(2)),
              locations = cells_column_labels(everything())) |>
    # título/subtítulo à esquerda; subtítulo menor e 75k
    tab_style(style = cell_text(weight = "bold", align = "left", color = econ$text),
              locations = cells_title(groups = "title")) |>
    tab_style(style = cell_text(align = "left", color = econ$grey75, size = px(12)),
              locations = cells_title(groups = "subtitle"))
}

# ---- Helpers HTML (mini-gráficos) ----
# barras (label: número; serve de legenda via cor do título)
bar_line <- function(value, vmax, color, height) {
  w <- ifelse(vmax > 0, round(100 * value / vmax, 1), 0)
  glue("<div style='flex:1;height:{height}px;background:{color};width:{w}%;border-radius:2px'></div>")
}

apps_cell <- function(apps, decis, max_apps, max_decis) {
  glue("
  <div style='display:flex;flex-direction:column;gap:6px'>
    <div style='display:flex;align-items:center;gap:8px'>
      <span style='font-weight:bold;color:{econ$blue1}'>{comma(apps)}</span>
      {bar_line(apps, max_apps, econ$blue1, 6)}
    </div>
    <div style='display:flex;align-items:center;gap:8px'>
      <span style='font-weight:bold;color:{econ$blue2}'>{comma(decis)}</span>
      {bar_line(decis, max_decis, econ$blue2, 4)}
    </div>
  </div>")
}

# donut (anel com progresso)
donut_svg <- function(pct) {
  r <- 14; c <- 2*pi*r
  off <- round(c*(1 - pct/100),1)
  glue("<svg width='38' height='38' viewBox='0 0 38 38'>
         <circle cx='19' cy='19' r='{r}' fill='none' stroke='{scales::alpha(econ$grid,0.5)}' stroke-width='4'/>
         <circle cx='19' cy='19' r='{r}' fill='none' stroke='{econ$blue1}' stroke-width='4'
                 stroke-dasharray='{round(c,1)}' stroke-dashoffset='{off}' transform='rotate(-90 19 19)'/>
         <text x='19' y='23' text-anchor='middle' font-size='12' font-weight='bold' fill='{econ$text}'>{round(pct)}</text>
       </svg>")
}

# barra vermelha segmentada (meses)
segments_red <- function(months, max_months=12) {
  w <- ifelse(max_months>0, round(100*months/max_months), 0)
  glue("<div style='height:6px;width:{w}%;
               background:repeating-linear-gradient(to right,{econ$red}, {econ$red} 12px, transparent 12px, transparent 16px);
               border-radius:2px'></div>")
}

# dot-matrix em bloco (3 linhas x 10 colunas)
dots_block <- function(value, vmax, note=NULL) {
  n <- 30
  k <- ifelse(vmax>0, round(n*value/vmax), 0)
  full <- k; empty <- n-k
  line <- function(m, col) glue("<span style='letter-spacing:2px;color:{col}'>{strrep('●', m)}</span>")
  rows <- glue("
    <div style='display:flex;gap:6px;flex-direction:column'>
      <div>{line(pmin(full,10), econ$blue1)}{line(pmax(0,10-pmin(full,10)), scales::alpha(econ$grey75,0.35))}</div>
      <div>{line(pmin(pmax(full-10,0),10), econ$blue1)}{line(pmax(0,10-pmin(pmax(full-10,0),10)), scales::alpha(econ$grey75,0.35))}</div>
      <div>{line(pmax(full-20,0), econ$blue1)}{line(pmax(0,10-pmax(full-20,0)), scales::alpha(econ$grey75,0.35))}</div>
    </div>")
  note_html <- if (is.null(note)) "" else glue("<div style='font-style:italic;color:{econ$grey75}'>{note}</div>")
  glue("<div style='display:flex;align-items:center;gap:10px'>
          <span style='font-weight:bold;color:{econ$text}'>€{value}</span>
          {rows}
          {note_html}
       </div>")
}

# “Mainly from %” (3 linhas com acentos e possíveis †/‡)
from_cell <- function(a,b,c) {
  mk <- function(x, col) glue("<span style='color:{col}'>{x}</span>")
  glue("<div style='display:flex;flex-direction:column;gap:2px'>
          {mk(a, econ$grey75)}
          {mk(b, econ$blue2)}
          {mk(c, econ$mustard)}
       </div>")
}

# “Minimum wait” (título bold + barra segmentada + nota 75k)
wait_cell <- function(title, note, months) {
  seg <- segments_red(months)
  nt  <- if (is.na(note) || note=="") "" else glue("<div style='color:{econ$grey75}'>{note}</div>")
  glue("<div style='display:flex;flex-direction:column;gap:6px'>
          <div style='font-weight:bold;color:{econ$text}'>{title}</div>
          {seg}
          {nt}
       </div>")
}

# ---- Dados (com †/‡ onde necessário) ----
tbl <- tribble(
  ~country,       ~apps,  ~decis, ~from1,             ~from2,            ~from3,        ~acc_pct, ~acc_note, ~wait_t,       ~wait_note,                               ~months, ~benefit, ~benef_note,
  "Germany",      173070,  97415, "Syria 23",         "Serbia / Kosovo 14", "Eritrea 8",  42,       "",        "3 months",    "",                                         3,       374,      "",
  "Sweden",        75090,  40015, "Syria 40",         "Stateless 10",       "Eritrea 8",  77,       "",        "Immediately", "Without restrictions",                     0,       226,      "",
  "Hungary",       41370,   5445, "Serbia / Kosovo 51","Afghanistan 21",    "Syria 16",    9,       "",        "9 months",    "Working only in a reception centre",       9,        86,      "Maximum",
  "Britain",       31260,  26055, "Eritrea 13",       "Pakistan 11",        "Syria 8",    39,       "",        "12 months",   "Only jobs where gov’t sees a shortage",    12,      217,      "",
  "United States",121160,  71765, "Mexico 12",        "China 11",           "El Salvador 8",30,     "†",       "6 months",    "In practice, 92% of applicants wait longer",6,        0,       "Nil",
  "Australia",      8960,  13198, "China 19‡",        "India 13‡",          "Pakistan 10‡",19,      "‡",       "—",           "Most applicants cannot work as they are in detention", 0, 275, ""
)

# ---- Pré-cálculos ----
max_apps   <- max(tbl$apps);   max_decis <- max(tbl$decis)
max_months <- max(tbl$months); max_benef <- max(tbl$benefit)

# ---- Render HTML por coluna ----
tbl_render <- tbl |>
  mutate(
    apps_cell  = pmap_chr(list(apps, decis), ~apps_cell(..1, ..2, max_apps, max_decis)),
    from_cell  = pmap_chr(list(from1, from2, from3), ~from_cell(..1, ..2, ..3)),
    donut_cell = pmap_chr(list(acc_pct), ~donut_svg(.x)),
    wait_cell  = pmap_chr(list(wait_t, wait_note, months), ~wait_cell(..1, ..2, ..3)),
    dots_cell  = pmap_chr(list(benefit, benef_note), ~dots_block(..1, max_benef, ..2)),
    donut_plus = ifelse(acc_note=="", donut_cell,
                        glue("<div style='display:flex;align-items:center;gap:4px'>{donut_cell}<sup style='color:{econ$grey75}'>{acc_note}</sup></div>"))
  ) |>
  transmute(
    Country = country,
    `Applications*\nDecisions made` = apps_cell,
    `Mainly from %` = from_cell,
    `Accepted %` = donut_plus,
    `Minimum wait before\npermitted to work` = wait_cell,
    `State benefits\nper month` = dots_cell
  )

# ---- Tabela GT ----
gt_integrated <-
  gt(tbl_render) |>
  theme_econ_integrated() |>
  # rótulo-legenda bicolor na 2ª coluna
  cols_label(
    Country = "Country",
    `Applications*\nDecisions made` = html(glue("<div>
          <div style='color:{econ$blue1};font-weight:bold'>Applications*</div>
          <div style='color:{econ$blue2};font-weight:bold'>Decisions made</div>
        </div>")),
    `Mainly from %` = "Mainly from %",
    `Accepted %` = "Accepted %",
    `Minimum wait before\npermitted to work` = html("Minimum wait before<br>permitted to work"),
    `State benefits\nper month` = html("State benefits<br>per month")
  ) |>
  # permitir HTML em todas as colunas
  fmt_markdown(columns = everything()) |>
  # alinhamentos e larguras
  cols_align(align = "left",
             columns = c(Country, `Applications*\nDecisions made`, `Mainly from %`,
                         `Minimum wait before\npermitted to work`, `State benefits\nper month`)) |>
  cols_align(align = "center", columns = `Accepted %`) |>
  cols_width(
    Country ~ px(110),
    `Applications*\nDecisions made` ~ px(190),
    `Mainly from %` ~ px(180),
    `Accepted %` ~ px(80),
    `Minimum wait before\npermitted to work` ~ px(260),
    `State benefits\nper month` ~ px(210)
  ) |>
  tab_header(
    title    = md("**What to expect**"),
    subtitle = "Asylum processes, selected countries, 2014"
  ) |>
  # rodapé com notas por símbolo
  tab_source_note(
    html(
      "<div style='display:flex;justify-content:space-between;width:100%'>
        <span>Sources: UNHCR; government statistics; <i>The Economist</i></span>
        <span>*From UNHCR 2014 report &nbsp;&nbsp; †From UNHCR Statistical Database &nbsp;&nbsp; ‡2012–13 figures</span>
      </div>"
    )
  )

# ---- Exibir ----
gt_integrated
