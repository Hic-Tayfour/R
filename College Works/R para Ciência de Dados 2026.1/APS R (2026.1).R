# Bibliotecas 

library(tidyverse)
library(labelled)
library(showtext)
library(gtExtras)
library(scales)
library(arrow)
library(gt)

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

# Importando as Bases de Dados

# airports <- read_parquet("airports.parquet") |> 
#   glimpse()

# flights <- read_parquet("flights.parquet") |> 
#   glimpse()

# planes <- read_parquet("planes.parquet") |> 
#   glimpse()

# Tratando as Bases 

airports <- read_parquet("airports.parquet") |> 
  rename(icao = sigla_icao_aera_dromo,
         iata = sigla_iata_aera_dromo, 
         nome_aeroporto = nome_aera_dromo, 
         municipio = munica_pio_aera_dromo, 
         estado = estado_aera_dromo, 
         pais = paa_s_aera_dromo) |> 
  mutate(latitude = as.numeric(str_replace(latitude, ",", ".")),
         longitude = as.numeric(str_replace(longitude, ",", "."))) |> 
  select(icao, iata, nome_aeroporto, municipio, estado, pais, latitude, longitude) |> 
  set_variable_labels(
    icao           = "Código ICAO do Aeródromo (4 Letras)", 
    iata           = "Código IATA do Aeródromo (3 Letras)", 
    nome_aeroporto = "Nome oficial e completo do aeroporto",
    municipio      = "Município onde o aeródromo está localizado",
    estado         = "Unidade da Federação (UF)", 
    pais           = "País de localização", 
    latitude       = "Latitude geográfica (graus decimais)",
    longitude      = "Longitude geográfica (graus decimais)"
  ) |> 
  glimpse()

flights <- read_parquet("flights.parquet") |> 
  rename(icao_empresa = sigla_icao_empresa_aa_c_rea, 
         empresa = empresa_aa_c_rea, 
         num_voo = n_aomero_voo, 
         assentos = n_aomero_de_assentos, 
         origem_icao = sigla_icao_aeroporto_origem,
         destino_icao = sigla_icao_aeroporto_destino,
         situacao = situa_a_a_o_voo,
         situacao_partida = situa_a_a_o_partida,
         situacao_chegada = situa_a_a_o_chegada) |> 
  mutate(partida_prevista = dmy_hm(partida_prevista),
         partida_real = dmy_hm(partida_real), 
         chegada_prevista = dmy_hm(chegada_prevista),
         chegada_real = dmy_hm(chegada_real), 
         assentos = as.numeric(assentos), 
         atraso_partida_min = as.numeric(difftime(partida_real, partida_prevista, units = "mins")),
         atraso_chegada_min = as.numeric(difftime(chegada_real, chegada_prevista, units = "mins"))) |> 
  set_variable_labels(
    icao_empresa       = "Sigla ICAO da Empresa Aérea", 
    empresa            = "Nome da Empresa Aérea", 
    num_voo            = "Número de identificação do voo", 
    modelo_equipamento = "Código do modelo da aeronave (Padrão ICAO)", 
    assentos           = "Quantidade de assentos comercializados", 
    origem_icao        = "Código ICAO do aeroporto de origem",
    destino_icao       = "Código ICAO do aeroporto de destino",
    partida_prevista   = "Data e hora previstas para a partida (Horário de Brasília)",
    partida_real       = "Data e hora reais da partida (Horário de Brasília)",
    chegada_prevista   = "Data e hora previstas para a chegada (Horário de Brasília)",
    chegada_real       = "Data e hora reais da chegada (Horário de Brasília)",
    situacao           = "Status final do voo (Realizado, Cancelado, etc)",
    atraso_partida_min = "Atraso na partida em minutos (Real - Previsto)",
    atraso_chegada_min = "Atraso na chegada em minutos (Real - Previsto)"
  ) |> 
  glimpse()

planes <- read_parquet("planes.parquet") |>
  rename(matricula = marca,
         operador = nm_operador, 
         fabricante = nm_fabricante,
         modelo = ds_modelo, 
         icao_tipo = cd_tipo_icao, 
         ano_fabricacao = nr_ano_fabricacao, 
         assentos = nr_assentos, 
         pmd = nr_pmd, 
         passageiros_max = nr_passageiros_max, 
         categoria = cd_categoria, 
         interdicao = cd_interdicao, 
         motivo_cancelamento = ds_motivo_canc, 
         validade_ca = dt_validade_ca, 
         validade_iam = dt_validade_iam, 
         data_cancelamento = dt_canc) |> 
  mutate(assentos = as.numeric(assentos),
         ano_fabricacao = as.numeric(ano_fabricacao), 
         pmd = as.numeric(pmd), 
         passageiros_max = as.numeric(passageiros_max), 
         matricula = str_replace(matricula, "^([A-Z]{2})([A-Z]{3})$", "\\1-\\2"), 
         validade_iam = dmy(validade_iam),
         validade_ca = dmy(validade_ca),
         data_cancelamento = as_date(ymd_hms(data_cancelamento))) |>
  select(matricula, proprietario, operador, uf_operador, fabricante, modelo, icao_tipo,
         ano_fabricacao, assentos, pmd, categoria, interdicao, motivo_cancelamento,
         validade_ca, validade_iam, passageiros_max, data_cancelamento) |> 
  set_variable_labels(
    matricula           = "Marca de Nacionalidade e Matrícula (ex: PR-GUK)",
    proprietario        = "Nome do Proprietário da Aeronave",
    operador            = "Nome do Operador (Companhia Aérea, Táxi Aéreo, etc.)",
    uf_operador         = "Unidade da Federação do Operador",
    fabricante          = "Nome do Fabricante da Aeronave (ex: BOEING, AIRBUS)",
    modelo              = "Designação do Modelo Comercial da Aeronave",
    icao_tipo           = "Código de Tipo ICAO (Cruza com 'modelo_equipamento' dos Voos)",
    ano_fabricacao      = "Ano de Fabricação da Aeronave",
    assentos            = "Número Máximo de Assentos Aprovados",
    pmd                 = "Peso Máximo de Decolagem Aprovado (Kg)",
    categoria           = "Categoria de Registro (ex: TPR = Transporte Regular)",
    interdicao          = "Situação de Interdição (N = Não, M = Manutenção, etc.)",
    motivo_cancelamento = "Motivo do cancelamento da matrícula (se inativa)",
    validade_ca         = "Data de Validade do Certificado de Aeronavegabilidade",
    validade_iam        = "Data de Validade da Inspeção Anual de Manutenção (IAM)",
    passageiros_max     = "Número Máximo de Passageiros",
    data_cancelamento   = "Data em que a matrícula foi cancelada"
  ) |> 
  glimpse()


# Rotas mais movimentadas

flights |> 
  filter(situacao == "REALIZADO") |> 
  count(origem_icao, destino_icao, name = "total_voos") |> 
  arrange(desc(total_voos)) |> 
  head(10) |>
  mutate(rota = fct_reorder(paste(origem_icao, "-", destino_icao), total_voos)) |>
  ggplot(aes(total_voos, rota, fill = "Principal")) +
  geom_col(width = 0.75, show.legend = FALSE) +
  geom_text(aes(label = scales::comma(total_voos, big.mark = ".", decimal.mark = ",")),
            hjust = -0.2, size = 3.5, family = font_family, colour = "#333333") +
  scale_fill_manual(values = unname(pal["data_red"])) +
  scale_x_continuous(labels = fmt_lab("number"), 
                     expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Ponte Aérea Imbatível", 
       subtitle = "As 10 rotas com maior número de voos realizados no Brasil em 2023", 
       caption = "Fonte: ANAC (Agência Nacional de Aviação Civil) | Dados VRA", 
       x = NULL, y = NULL) +
  theme_econ_base() +
  theme(axis.line.y = element_blank(), 
        panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4),
        panel.grid.major.y = element_blank(), axis.text.y = element_text(hjust = 1))


# Empresas mais movimentadas

flights |> 
  filter(situacao == "REALIZADO") |> 
  mutate(cia = case_when(str_detect(empresa, "(?i)AZUL") ~ "Azul", 
                         str_detect(empresa, "(?i)TAM|LATAM") ~ "LATAM", 
                         str_detect(empresa, "(?i)GOL") ~ "GOL", 
                         str_detect(empresa, "(?i)PASSAREDO|VOEPASS") ~ "Voepass", 
                         TRUE ~ "Outras")) |> 
  filter(cia != "Outras") |> 
  count(cia, name = "total_voos") |> 
  mutate(cia = fct_reorder(cia, total_voos)) |> 
  ggplot(aes(total_voos, cia, fill = "Principal")) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = scales::comma(total_voos, big.mark = ".", decimal.mark = ",")),
            hjust = -0.15, size = 4.5, family = font_family, colour = "#333333") +
  scale_fill_manual(values = unname(pal["blue1"])) +
  scale_x_continuous(labels = fmt_lab("number"), expand = expansion(mult = c(0, 0.2))) +
  labs(title = "O Domínio do Espaço Aéreo", 
       subtitle = "Volume total de voos realizados pelas 4 grandes companhias do Brasil em 2023", 
       caption = "Fonte: ANAC | Dados VRA", 
       x = NULL, y = NULL) +
  theme_econ_base() +
  theme(axis.line.y = element_blank(), 
        panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4), 
        panel.grid.major.y = element_blank(), 
        axis.text.y = element_text(hjust = 1, size = 12, face = "bold"))    


# Atrasos

flights |> 
  filter(situacao == "REALIZADO", !is.na(atraso_chegada_min)) |> 
  mutate(cia = case_when(str_detect(empresa, "(?i)AZUL") ~ "Azul", 
                         str_detect(empresa, "(?i)TAM|LATAM") ~ "LATAM", 
                         str_detect(empresa, "(?i)GOL") ~ "GOL", 
                         str_detect(empresa, "(?i)PASSAREDO|VOEPASS") ~ "Voepass", 
                         TRUE ~ "Outras")) |> 
  filter(cia != "Outras") |> 
  group_by(cia) |> 
  summarise(taxa_atraso = mean(atraso_chegada_min > 15) * 100) |> 
  mutate(cia = fct_reorder(cia, taxa_atraso)) |> 
  ggplot(aes(taxa_atraso, cia, fill = "Principal")) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", taxa_atraso)), 
            hjust = -0.15, size = 4.5, family = font_family, colour = "#333333") +
  scale_fill_manual(values = unname(pal["burgundy"])) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.2))) +
  labs(title = "O Relógio da Aviação", 
       subtitle = "Percentual de voos com atraso superior a 15 minutos na chegada em 2023", 
       caption = "Fonte: ANAC | Dados VRA \n Critério internacional de pontualidade (>15 min)", 
       x = NULL, y = NULL) +
  theme_econ_base() +
  theme(axis.line.y = element_blank(), 
        panel.grid.major.x = element_line(colour = econ_base$grid, linewidth = 0.4), 
        panel.grid.major.y = element_blank(), 
        axis.text.y = element_text(hjust = 1, size = 12, face = "bold"), 
        axis.text.x = element_blank(), axis.ticks.x = element_blank())

# Série Histórica

flights |> 
  filter(situacao == "REALIZADO", !is.na(partida_real)) |> 
  mutate(semana = floor_date(as_date(partida_real), "week")) |> 
  filter(year(semana) == 2023) |> 
  count(semana, name = "total_voos") |> 
  ggplot(aes(semana, total_voos)) +
  geom_area(fill = unname(pal["blue1"]), alpha = 0.1) +
  geom_line(colour = unname(pal["blue1"]), linewidth = 1.2) +
  scale_y_continuous(labels = fmt_lab("number"), expand = expansion(mult = c(0, 0.15))) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b") +
  labs(title = "A Sazonalidade do Céu Brasileiro", 
       subtitle = "Volume semanal de voos comerciais realizados ao longo de 2023", 
       caption = "Fonte: ANAC | Dados VRA", 
       x = NULL, y = NULL) +
  theme_econ_base() +
  theme(axis.line.y = element_blank(), 
        panel.grid.major.x = element_blank(), 
        panel.grid.major.y = element_line(colour = econ_base$grid, linewidth = 0.4))


# Idade e Peso da Frota
planes |>
  filter(is.na(data_cancelamento),
         !is.na(ano_fabricacao),
         !is.na(operador)) |>
  group_by(operador) |>
  summarise(frota_total = n(),
            idade_media = mean(2023 - ano_fabricacao, na.rm = TRUE),
            pmd_medio = mean(pmd, na.rm = TRUE),
            .groups = "drop") |>
  filter(frota_total >= 10) |>
  slice_max(frota_total, n = 15) |>
  arrange(desc(frota_total)) |>
  gt() |>
  tab_header(title = md("**Raio-X das Frotas Ativas — Aviação Brasileira 2023**"),
    subtitle = "Grandes operadores | Apenas aeronaves com matrícula ativa no RAB") |>
  tab_source_note(source_note = "Fonte: ANAC — Registro Aeronáutico Brasileiro (RAB). Elaboração própria.") |>
  cols_label(operador = "Operador",
            frota_total = "Frota Total",
            idade_media = "Idade Média (anos)",
            pmd_medio = "PMD Médio (kg)") |>
  fmt_number(columns  = frota_total,
             decimals = 0,
             sep_mark = ",") |>
  fmt_number(columns  = idade_media, decimals = 1) |>
  fmt_number(columns  = pmd_medio,
             decimals = 0,
             sep_mark = ",") |>
  cols_align(align = "left", columns = operador) |>
  cols_align(align = "center",
             columns = c(frota_total, idade_media, pmd_medio)) |>
  tab_style(style = cell_text(weight = "bold"), locations = cells_column_labels()) |>
  tab_style(style = cell_fill(color = unname(pal["highlight"])),
            locations = cells_body(rows = frota_total == max(frota_total))) |>
  gt_color_rows(columns = idade_media,
                domain = NULL,
                palette   = c(unname(pal["blue1"]), unname(pal["data_red"])),
                direction = 1) |>
  gt_color_rows(columns = pmd_medio,
                domain = NULL,
                palette = c(unname(pal["blue1"]), unname(pal["data_red"])),
                direction = 1) |>
  tab_options(table.background.color = unname(pal["print_bkgd"]),
              table.font.names = font_family,
              table.font.size = px(13),
              heading.background.color = unname(pal["print_bkgd"]),
              heading.title.font.size = px(16),
              heading.subtitle.font.size = px(12),
              column_labels.background.color = unname(pal["number_box"]),
              row.striping.background_color = unname(pal["highlight"]),
              row.striping.include_table_body = TRUE,
              source_notes.font.size = px(10),
              table.border.top.color = unname(pal["blue1"]),
              table.border.top.width = px(3))
