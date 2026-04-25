# Bibliotecas 

library(tidymodels)
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
         pais = paa_s_aera_dromo, 
         aeronave_critica = aeronave_cra_tica) |> 
  mutate(across(where(is.character), ~ iconv(.x, from = "UTF-8", to = "windows-1252")),
         latitude = as.numeric(str_replace(latitude, ",", ".")),
         longitude = as.numeric(str_replace(longitude, ",", "."))) |> 
  select(icao, iata, nome_aeroporto, municipio, estado, pais, aeronave_critica, latitude, longitude) |> 
  set_variable_labels(
    icao = "Código ICAO do Aeródromo (4 Letras)", 
    iata = "Código IATA do Aeródromo (3 Letras)", 
    nome_aeroporto = "Nome oficial e completo do aeroporto",
    municipio = "Município onde o aeródromo está localizado",
    estado = "Unidade da Federação (UF)", 
    pais = "País de localização", 
    aeronave_critica = "Aeronave crítica para dimensionamento da infraestrutura do aeródromo",
    latitude = "Latitude geográfica (graus decimais)",
    longitude = "Longitude geográfica (graus decimais)"
  ) |> 
  glimpse()

flights <- read_parquet("flights.parquet") |> 
  rename(icao_empresa = sigla_icao_empresa_aa_c_rea, 
         empresa = empresa_aa_c_rea, 
         num_voo = n_aomero_voo, 
         codigo_di = ca3digo_di,
         codigo_tipo_linha = ca3digo_tipo_linha,
         assentos = n_aomero_de_assentos, 
         origem_icao = sigla_icao_aeroporto_origem,
         nome_origem = descri_a_a_o_aeroporto_origem,
         destino_icao = sigla_icao_aeroporto_destino,
         nome_destino = descri_a_a_o_aeroporto_destino,
         situacao = situa_a_a_o_voo,
         referencia = refer_aancia,
         situacao_partida = situa_a_a_o_partida,
         situacao_chegada = situa_a_a_o_chegada) |> 
  mutate(across(where(is.character), ~ iconv(.x, from = "UTF-8", to = "windows-1252")),
         partida_prevista = dmy_hm(partida_prevista),
         partida_real = dmy_hm(partida_real), 
         chegada_prevista = dmy_hm(chegada_prevista),
         chegada_real = dmy_hm(chegada_real), 
         assentos = as.numeric(assentos), 
         atraso_partida_min = as.numeric(difftime(partida_real, partida_prevista, units = "mins")),
         atraso_chegada_min = as.numeric(difftime(chegada_real, chegada_prevista, units = "mins"))) |> 
  set_variable_labels(icao_empresa = "Sigla ICAO da Empresa Aérea",
                      empresa = "Nome da Empresa Aérea",
                      num_voo = "Número de identificação do voo",
                      codigo_di = "Código de Autorização de Voo (DI)",
                      codigo_tipo_linha  = "Código do Tipo de Linha",
                      modelo_equipamento = "Código do modelo da aeronave (Padrão ICAO)",
                      assentos = "Quantidade de assentos comercializados",
                      origem_icao = "Código ICAO do aeroporto de origem",
                      nome_origem = "Nome oficial do aeroporto de origem",
                      partida_prevista = "Data e hora previstas para a partida (Horário de Brasília)",
                      partida_real = "Data e hora reais da partida (Horário de Brasília)",
                      destino_icao = "Código ICAO do aeroporto de destino",
                      nome_destino = "Nome oficial do aeroporto de destino",
                      chegada_prevista = "Data e hora previstas para a chegada (Horário de Brasília)",
                      chegada_real = "Data e hora reais da chegada (Horário de Brasília)",
                      situacao = "Status final do voo (Realizado, Cancelado, etc)",
                      justificativa = "Justificativa para atraso ou cancelamento do voo",
                      referencia = "Data de referência do voo",
                      situacao_partida = "Categoria do status de partida (Antecipado, Pontual, Atraso, etc)",
                      situacao_chegada = "Categoria do status de chegada (Antecipado, Pontual, Atraso, etc)",
                      atraso_partida_min = "Atraso na partida em minutos (Real - Previsto)",
                      atraso_chegada_min = "Atraso na chegada em minutos (Real - Previsto)") |>
  glimpse()

planes <- read_parquet("planes.parquet") |>
  rename(matricula = marca,
         uf_proprietario = sg_uf,
         cpf_cnpj_proprietario = cpf_cnpj,
         operador = nm_operador,
         cpf_cnpj_operador = cpf_cgc,
         cert_matricula = nr_cert_matricula,
         num_serie = nr_serie,
         categoria = cd_categoria,
         tipo = cd_tipo,
         modelo = ds_modelo,
         fabricante = nm_fabricante,
         classe = cd_cls,
         pmd = nr_pmd,
         icao_tipo = cd_tipo_icao,
         tripulacao_min = nr_tripulacao_min,
         passageiros_max = nr_passageiros_max,
         assentos = nr_assentos,
         ano_fabricacao = nr_ano_fabricacao,
         validade_iam = dt_validade_iam,
         validade_ca = dt_validade_ca,
         data_cancelamento = dt_canc,
         motivo_cancelamento = ds_motivo_canc,
         interdicao = cd_interdicao,
         marca_nac1 = cd_marca_nac1,
         marca_nac2 = cd_marca_nac2,
         marca_nac3 = cd_marca_nac3,
         marca_estrangeira = cd_marca_estrangeira,
         gravame = ds_gravame) |>
  mutate(pmd = as.numeric(pmd),
         tripulacao_min = as.numeric(tripulacao_min),
         passageiros_max = as.numeric(passageiros_max),
         assentos = as.numeric(assentos),
         ano_fabricacao = as.numeric(ano_fabricacao),
         matricula = str_replace(matricula, "^([A-Z]{2})([A-Z]{3})$", "\\1-\\2"),
         validade_iam = dmy(validade_iam),
         validade_ca = dmy(validade_ca),
         data_cancelamento = as_date(ymd_hms(data_cancelamento))) |>
  set_variable_labels(matricula = "Marca de Nacionalidade e Matrícula (ex: PR-GUK)",
                      proprietario = "Nome do Proprietário da Aeronave",
                      outros_proprietarios  = "Nomes de outros proprietários registrados",
                      uf_proprietario = "Unidade da Federação (UF) do proprietário",
                      cpf_cnpj_proprietario = "CPF ou CNPJ do proprietário",
                      operador = "Nome do Operador (Companhia Aérea, Táxi Aéreo, etc.)",
                      outros_operadores = "Nomes de outros operadores registrados",
                      uf_operador = "Unidade da Federação do Operador",
                      cpf_cnpj_operador = "CPF ou CNPJ do operador",
                      cert_matricula = "Número do Certificado de Matrícula",
                      num_serie = "Número de série da aeronave",
                      categoria = "Categoria de Registro (ex: TPR = Transporte Regular)",
                      tipo = "Código do tipo de aeronave",
                      modelo = "Designação do Modelo Comercial da Aeronave",
                      fabricante = "Nome do Fabricante da Aeronave (ex: BOEING, AIRBUS)",
                      classe = "Classe da aeronave",
                      pmd = "Peso Máximo de Decolagem Aprovado (Kg)",
                      icao_tipo = "Código de Tipo ICAO (Cruza com 'modelo_equipamento' dos Voos)",
                      tripulacao_min = "Quantidade mínima de tripulantes exigida",
                      passageiros_max = "Número Máximo de Passageiros",
                      assentos = "Número Máximo de Assentos Aprovados",
                      ano_fabricacao = "Ano de Fabricação da Aeronave",
                      validade_iam = "Data de Validade da Inspeção Anual de Manutenção (IAM)",
                      validade_ca = "Data de Validade do Certificado de Aeronavegabilidade",
                      data_cancelamento = "Data em que a matrícula foi cancelada",
                      motivo_cancelamento = "Motivo do cancelamento da matrícula (se inativa)",
                      interdicao = "Situação de Interdição (N = Não, M = Manutenção, etc.)",
                      marca_nac1 = "Código de marca nacional anterior 1",
                      marca_nac2 = "Código de marca nacional anterior 2",
                      marca_nac3 = "Código de marca nacional anterior 3",
                      marca_estrangeira = "Marca estrangeira anterior utilizada pela aeronave",
                      gravame = "Descrição de gravames ou restrições financeiras e legais") |>
  glimpse()

# Tópico 0 : Análise Geral da Base de Dados----

## Auditoria de Estrutura e Dados Faltantes (NAs)

tibble(Base = c("airports", "flights", "planes"),
       data = list(airports, flights, planes)) |>
  mutate(Linhas = map_int(data, nrow),
         summary = map(data, ~ tibble(Coluna = names(.x),
                                      Tipo = map_chr(.x, ~ class(.x)[1]),
                                      Valores_Unicos = map_int(.x, n_distinct),
                                      NAs = map_int(.x, ~ sum(is.na(.x)))))) |>
  select(-data) |>
  unnest(summary) |>
  mutate(Percentual = NAs / Linhas) |>
  gt(groupname_col = "Base") |>
  tab_header(title = "Saúde das Bases de Dados",
             subtitle = "Auditoria de estrutura, cardinalidade e valores faltantes (NAs)") |>
  cols_label(Linhas = "Total de Linhas",
             Coluna = "Coluna",
             Tipo = "Tipo",
             Valores_Unicos = "Valores Únicos",
             NAs = "NAs (Qtd)",
             Percentual = "NAs (%)") |>
  fmt_number(columns = c(Linhas, Valores_Unicos, NAs),
             decimals = 0, dec_mark = ",", sep_mark = ".") |>
  fmt_percent(columns = Percentual,
              decimals = 2, dec_mark = ",", sep_mark = ".") |>
  gt_theme_538() |>
  tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria")



## Escopo Temporal e Cardinalidade Macro

flights |>
  summarise(data_min = format(min(partida_prevista, na.rm = TRUE), "%d/%m/%Y"),
            data_max = format(max(partida_prevista, na.rm = TRUE), "%d/%m/%Y"),
            aeroportos = format(n_distinct(origem_icao, na.rm = TRUE), 
                                big.mark = ".", decimal.mark = ","),
            empresas = format(n_distinct(empresa, na.rm = TRUE), 
                              big.mark = ".", decimal.mark = ","),
            modelos = format(n_distinct(modelo_equipamento, na.rm = TRUE),
                             big.mark = ".", decimal.mark = ",")) |>
  pivot_longer(cols = everything(),
               names_to = "Indicador",
               values_to = "Valor") |>
  mutate(Indicador = case_when(Indicador == "data_min" ~ "Data Inicial (Partidas)",
                               Indicador == "data_max" ~ "Data Final (Partidas)",
                               Indicador == "aeroportos" ~ "Aeroportos de Origem (Total)",
                               Indicador == "empresas" ~ "Companhias Aéreas (Total)",
                               Indicador == "modelos" ~ "Modelos de Equipamento (Total)")) |>
  gt() |>
  tab_header(title = "Escopo Temporal e Operacional",
             subtitle = "Indicadores macro de cobertura e cardinalidade da base") |>
  cols_align(align = "left", columns = Indicador) |>
  cols_align(align = "right", columns = Valor) |>
  gt_theme_538() |> 
  tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria")


## Perfil da Malha Aeroportuária (Nacional vs. Internacional)

flights |>
  pivot_longer(cols = c(origem_icao, destino_icao), values_to = "icao") |>
  drop_na(icao) |>
  distinct(icao) |>
  inner_join(airports, by = "icao") |>
  mutate(tipo = if_else(pais == "BRASIL", "Nacional", "Internacional")) |>
  count(tipo, pais, name = "aeroportos") |>
  mutate(pais = if_else(tipo == "Internacional", 
                        as.character(fct_lump_n(factor(pais), 
                        n = 5, w = aeroportos, 
                        other_level = "Outros")),"Brasil")) |>
  group_by(tipo, pais) |>
  summarise(aeroportos = sum(aeroportos), .groups = "drop") |>
  arrange(desc(tipo), desc(aeroportos)) |>
  mutate(pais = str_to_title(pais)) |>
  gt(groupname_col = "tipo") |>
  tab_header(title = "Conectividade da Malha Aeroportuária",
             subtitle = "Quantidade de aeroportos únicos operacionais em 2023 (Nacional vs. Internacional)") |>
  cols_label(pais = "País de Origem/Destino", aeroportos = "Aeroportos Conectados") |>
  fmt_number(columns = aeroportos, 
             decimals = 0, sep_mark = ".", dec_mark = ",") |>
  summary_rows( groups = everything(), columns = aeroportos, 
                fns = list(Subtotal = ~sum(.)), formatter = fmt_number, 
                decimals = 0, sep_mark = ".", dec_mark = ",") |>
  gt_theme_538() |>
  tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria")

## Diversidade da Frota e Equipamentos

flights |>
  drop_na(modelo_equipamento) |>
  distinct(modelo_equipamento) |>
  inner_join(planes, by = join_by(modelo_equipamento == icao_tipo)) |>
  group_by(categoria) |>
  summarise(volume = n_distinct(matricula), .groups = "drop") |>
  slice_max(order_by = volume, n = 10, with_ties = FALSE) |>
  mutate(categoria = fct_reorder(categoria, volume)) |>
  ggplot(aes(categoria, volume, fill = "Volume")) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    scale_y_continuous(labels = fmt_lab("number")) +
    scale_econ(aes = "fill", scheme = "bars") +
    labs(title = "Composição física da frota operante",
         subtitle = "Volume de aeronaves únicas (Top 10 categorias de registro)",
         caption = "Fonte: ANAC | Elaboração Própria") +
    theme_econ_base()