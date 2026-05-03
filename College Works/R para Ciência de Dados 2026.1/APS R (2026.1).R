# Bibliotecas 

library(rnaturalearthdata)   
library(rnaturalearth)       
library(countrycode)
library(tidymodels)
library(tidyverse)
library(labelled)
library(gtExtras)
library(stringi)
library(bonsai)
library(scales)
library(ranger)
library(arrow)
library(geobr)               
library(gt)
library(sf)                  

# Funções Gráficas The Economist ----

# Definição do tibble de cores 

econ_colors_tbl <- tibble::tribble(
  ~category,           ~color_name,    ~hex,
  
  # Branding
  "branding",          "econ_red",     "#E3120B",
  
  # Main (web palette)
  "main",              "data_red",     "#DB444B",
  "main",              "blue1",        "#006BA2",
  "main",              "blue2",        "#3EBCD2",
  "main",              "green",        "#379A8B",
  "main",              "yellow",       "#EBB434",
  "main",              "olive",        "#B4BA39",
  "main",              "purple",       "#9A607F",
  "main",              "gold",         "#D1B07C",
  "main",              "grey",         "#758D99",
  
  # Text
  "text",              "base_text",    "#3F5661",
  "text",              "red_text",     "#CC334C",
  "text",              "blue2_text",   "#0097A7",
  
  # Secondary
  "secondary",         "mustard",      "#E6B83C",
  "secondary",         "burgundy",     "#A63D57",
  "secondary",         "mauve",        "#B48A9B",
  "secondary",         "teal",         "#008080",
  "secondary",         "aqua",         "#6FC7C7",
  
  # Supporting bright
  "supporting_bright", "purple_b",     "#924C7A",
  "supporting_bright", "pink",         "#DA3C78",
  "supporting_bright", "orange",       "#F7A11A",
  "supporting_bright", "lime",         "#B3D334",
  
  # Supporting dark
  "supporting_dark",   "navy",         "#003D73",
  "supporting_dark",   "cyan_dk",      "#005F73",
  "supporting_dark",   "green_dk",     "#385F44",
  
  # Background
  "background",        "print_bkgd",   "#E9EDF0",
  "background",        "highlight",    "#DDE8EF",
  "background",        "number_box",   "#C2D3E0",
  
  # Maps
  "maps",              "sea",          "#EBF5FB",
  "maps",              "land",         "#EBEBEB",
  "maps",              "land_text",    "#6D6E71",
  
  # Neutral
  "neutral",           "text_black",   "#0C0C0C",
  "neutral",           "grid_lines",   "#B7C6CF",
  "neutral",           "grey_box",     "#7C8C99",
  "neutral",           "grey_text",    "#333333",
  "neutral",           "black25",      "#BFBFBF",
  "neutral",           "black50",      "#808080",
  "neutral",           "black75",      "#404040",
  "neutral",           "black100",     "#000000",
  
  # Equal lightness
  "equal_lightness",   "red",          "#A81829",
  "equal_lightness",   "blue",         "#00588D",
  "equal_lightness",   "cyan",         "#005F73",
  "equal_lightness",   "green",        "#005F52",
  "equal_lightness",   "yellow",       "#714C00",
  "equal_lightness",   "olive",        "#4C5900",
  "equal_lightness",   "purple",       "#78405F",
  "equal_lightness",   "gold",         "#674E1F",
  "equal_lightness",   "grey",         "#3F5661",
  
  # Boxes / Nav (5 níveis)
  "boxes_nav",         "red_1",        "#C7303C",
  "boxes_nav",         "blue_1",       "#1270A8",
  "boxes_nav",         "cyan_1",       "#00788D",
  "boxes_nav",         "green_1",      "#00786B",
  "boxes_nav",         "yellow_1",     "#8D6300",
  "boxes_nav",         "olive_1",      "#667100",
  "boxes_nav",         "purple_1",     "#925977",
  "boxes_nav",         "gold_1",       "#826636",
  "boxes_nav",         "grey_1",       "#576E79",
  
  "boxes_nav",         "red_2",        "#E64E53",
  "boxes_nav",         "blue_2",       "#3D89C3",
  "boxes_nav",         "cyan_2",       "#0092A7",
  "boxes_nav",         "green_2",      "#2E9284",
  "boxes_nav",         "yellow_2",     "#AA7C00",
  "boxes_nav",         "olive_2",      "#818A00",
  "boxes_nav",         "purple_2",     "#AD7291",
  "boxes_nav",         "gold_2",       "#9D7F4E",
  "boxes_nav",         "grey_2",       "#6F8793",
  
  "boxes_nav",         "red_3",        "#FF6B6C",
  "boxes_nav",         "blue_3",       "#5DA4DF",
  "boxes_nav",         "cyan_3",       "#25ADC2",
  "boxes_nav",         "green_3",      "#4DAD9E",
  "boxes_nav",         "yellow_3",     "#C89608",
  "boxes_nav",         "olive_3",      "#9DA521",
  "boxes_nav",         "purple_3",     "#C98CAC",
  "boxes_nav",         "gold_3",       "#B99966",
  "boxes_nav",         "grey_3",       "#89A2AE",
  
  "boxes_nav",         "red_4",        "#FF8785",
  "boxes_nav",         "blue_4",       "#7BBFFC",
  "boxes_nav",         "cyan_4",       "#4EC8DE",
  "boxes_nav",         "green_4",      "#69C9B9",
  "boxes_nav",         "yellow_4",     "#E7B030",
  "boxes_nav",         "olive_4",      "#BAC03F",
  "boxes_nav",         "purple_4",     "#E6A6C7",
  "boxes_nav",         "gold_4",       "#D5B480",
  "boxes_nav",         "grey_4",       "#A4BDC9",
  
  "boxes_nav",         "red_5",        "#FFA39F",
  "boxes_nav",         "blue_5",       "#98DAFF",
  "boxes_nav",         "cyan_5",       "#6FE4FB",
  "boxes_nav",         "green_5",      "#86E5D4",
  "boxes_nav",         "yellow_5",     "#FFCB4D",
  "boxes_nav",         "olive_5",      "#D7DB5A",
  "boxes_nav",         "purple_5",     "#FFC2E3",
  "boxes_nav",         "gold_5",       "#F2CF9A",
  "boxes_nav",         "grey_5",       "#BFD8E5"
)

# Vetor de busca

pal <- econ_colors_tbl |>
  dplyr::mutate(color_name = dplyr::case_when(
    category == "equal_lightness" ~ paste0(color_name, "_eq"),
    category == "text" ~ paste0(color_name, "_txt"), 
    TRUE ~ color_name
  )) |>
  dplyr::select(color_name, hex) |>
  tibble::deframe()

# Configuração de Fonte

(font_family <- if ("Roboto Condensed" %in% systemfonts::system_fonts()$family) 
  "Roboto Condensed" else "sans")
showtext::showtext_auto()

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
  ggplot2::theme_minimal(base_family = base_family) +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = econ_base$bg, colour = NA),
      panel.background = ggplot2::element_rect(fill = econ_base$bg, colour = NA),
      
      # Títulos e Legendas
      plot.title.position = "plot",
      plot.title     = ggplot2::element_text(
        face = "bold",
        size = 20,
        hjust = 0,
        colour = econ_base$text,
        margin = ggplot2::margin(b = 4)
      ),
      plot.subtitle  = ggplot2::element_text(
        size = 12.5,
        hjust = 0,
        colour = econ_base$text,
        margin = ggplot2::margin(b = 10)
      ),
      plot.caption   = ggplot2::element_text(
        size = 9,
        colour = "#404040",
        hjust = 0,
        margin = ggplot2::margin(t = 10)
      ),
      
      # Eixos
      axis.title     = ggplot2::element_blank(),
      axis.text      = ggplot2::element_text(size = 10, colour = econ_base$text),
      axis.line.x    = ggplot2::element_line(colour = econ_base$text, linewidth = 0.6),
      axis.ticks.x   = ggplot2::element_line(colour = econ_base$text, linewidth = 0.6),
      axis.ticks.y   = ggplot2::element_blank(),
      
      # Grid
      panel.grid.major.y = ggplot2::element_line(colour = econ_base$grid, linewidth = 0.4),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor   = ggplot2::element_blank(),
      
      # Legenda
      legend.position = "top",
      legend.justification = "left",
      legend.title    = ggplot2::element_blank(),
      legend.text     = ggplot2::element_text(size = 10, colour = econ_base$text),
      legend.margin   = ggplot2::margin(t = 0, b = 5),
      
      plot.margin     = ggplot2::margin(16, 16, 12, 16)
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
    ggplot2::scale_colour_manual(values = pal_vec, ...)
  } else {
    ggplot2::scale_fill_manual(values = pal_vec, ...)
  }
}

fmt_lab <- function(kind = c("number", "percent", "si")) {
  kind <- match.arg(kind)
  switch(
    kind,
    number  = scales::label_number(big.mark = ",", decimal.mark = "."), 
    percent = scales::label_percent(accuracy = 1),
    si      = scales::label_number(scale_cut = scales::cut_short_scale())
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

pais_iso3 <- c(
  "AFRICA DO SUL" = "ZAF", "ALEMANHA" = "DEU", "ANGOLA" = "AGO", "ANGUILLA" = "AIA", "ANTIGUA E BARBUDA" = "ATG",
  "ANTILHAS HOLANDESAS" = "NLD", "ARABIA SAUDITA" = "SAU", "ARGENTINA" = "ARG", "ARUBA" = "ABW", "AUSTRALIA" = "AUS",
  "AUSTRIA" = "AUT", "BAHAMAS" = "BHS", "BAHREIN" = "BHR", "BANGLADESH" = "BGD", "BARBADOS" = "BRB", "BELIZE" = "BLZ",
  "BENIM" = "BEN", "BERMUDAS" = "BMU", "BOLIVIA" = "BOL", "BOTSUANA" = "BWA", "BRASIL" = "BRA", "BRUNEI" = "BRN",
  "BULGARIA" = "BGR", "BURKINA FASSO" = "BFA", "CABO VERDE" = "CPV", "CAMBOJA" = "KHM", "CANADA" = "CAN", "CHADE" = "TCD",
  "CHILE" = "CHL", "CHINA" = "CHN", "CHIPRE" = "CYP", "COMORES" = "COM", "CONGO" = "COG", "COREIA DO SUL" = "KOR",
  "COSTA DO MARFIM" = "CIV", "COSTA RICA" = "CRI", "CROACIA" = "HRV", "CUBA" = "CUB", "DJIBOUTI" = "DJI",
  "DOMINICA" = "DMA", "EGITO" = "EGY", "EL SALVADOR" = "SLV", "EMIRADOS ARABES UNIDOS" = "ARE", "EQUADOR" = "ECU",
  "ERITREIA" = "ERI", "ESLOVAQUIA" = "SVK", "ESPANHA" = "ESP", "ESTADOS UNIDOS DA AMERICA" = "USA", "FILIPINAS" = "PHL",
  "FORMOSA TAIWAN" = "TWN", "GANA" = "GHA", "GIBRALTAR" = "GIB", "GRANADA" = "GRD", "GUADALUPE" = "GLP", "GUAM" = "USA",
  "GUATEMALA" = "GTM", "GUIANA" = "GUY", "GUIANA FRANCESA" = "GUF", "HAITI" = "HTI", "HOLANDA" = "NLD", "HONDURAS" = "HND",
  "HONG KONG" = "HKG", "HUNGRIA" = "HUN", "ILHAS CANARIAS" = "ESP", "ILHAS CAYMAN" = "CYM", "ILHAS MARSHALL" = "MHL",
  "ILHAS TURCAS E CAICOS" = "TCA", "ILHAS VIRGENS AMERICANAS" = "USA", "INDIA" = "IND", "IRAQUE" = "IRQ", "IRLANDA" = "IRL",
  "ISRAEL" = "ISR", "ITALIA" = "ITA", "JAMAICA" = "JAM", "KOSOVO" = "XKX", "KUWAIT" = "KWT", "LAOS" = "LAO", "LESOTO" = "LSO",
  "LIBANO" = "LBN", "LIBIA" = "LBY", "LUXEMBURGO" = "LUX", "MACAU" = "MAC", "MADAGASCAR" = "MDG", "MALASIA" = "MYS",
  "MALAUI" = "MWI", "MALDIVAS" = "MDV", "MALI" = "MLI", "MALTA" = "MLT", "MARIANAS SETENTRIONAIS" = "USA", "MARROCOS" = "MAR",
  "MARTINICA" = "MTQ", "MAURICIA" = "MUS", "MAYOTTE" = "MYT", "MIANMAR" = "MMR", "MOLDAVIA" = "MDA", "MONTENEGRO" = "MNE",
  "MONTSERRAT" = "MSR", "NAMIBIA" = "NAM", "NAURU" = "NRU", "NEPAL" = "NPL", "NICARAGUA" = "NIC", "NIGER" = "NER",
  "NORUEGA" = "NOR", "PALAU" = "PLW", "PANAMA" = "PAN", "PARAGUAI" = "PRY", "PERU" = "PER", "PORTO RICO" = "USA",
  "PORTUGAL" = "PRT", "QATAR" = "QAT", "REINO UNIDO" = "GBR", "SEICHELES" = "SYC", "SENEGAL" = "SEN", "SERRA LEOA" = "SLE",
  "SINGAPURA" = "SGP", "SIRIA" = "SYR", "SOMALIA" = "SOM", "SRI LANKA" = "LKA", "SURINAME" = "SUR", "TIMOR LESTE" = "TLS",
  "TOGO" = "TGO", "TRINIDAD E TOBAGO" = "TTO", "TUNISIA" = "TUN", "TURQUIA" = "TUR", "TUVALU" = "TUV", "UGANDA" = "UGA",
  "URUGUAI" = "URY", "VENEZUELA" = "VEN", "ZIMBABUE" = "ZWE"
)


airports <- read_parquet("airports.parquet") |> 
  rename(icao = sigla_icao_aera_dromo,
         iata = sigla_iata_aera_dromo, 
         nome_aeroporto = nome_aera_dromo, 
         municipio = munica_pio_aera_dromo, 
         estado = estado_aera_dromo, 
         pais = paa_s_aera_dromo, 
         aeronave_critica = aeronave_cra_tica) |> 
  mutate(latitude = as.numeric(str_replace(latitude, ",", ".")),
         longitude = as.numeric(str_replace(longitude, ",", ".")),
         across(where(is.character),~ {
           x <- iconv(as.character(.x), from = "UTF-8", to = "latin1", sub = "")
           Encoding(x) <- "UTF-8"
           x})) |> 
  mutate(pais_limpo = stringi::stri_trans_general(str_to_upper(str_squish(pais)), "Latin-ASCII") |> 
  str_replace_all("[^A-Z0-9 ]", " ") |> str_squish(), iso_a3 = unname(pais_iso3[pais_limpo])) |> 
  select(icao, iata, nome_aeroporto, municipio, estado, pais, iso_a3, aeronave_critica, latitude, longitude) |> 
  set_variable_labels(icao = "Código ICAO do Aeródromo (4 Letras)", 
                      iata = "Código IATA do Aeródromo (3 Letras)", 
                      nome_aeroporto = "Nome oficial e completo do aeroporto",
                      municipio = "Município onde o aeródromo está localizado",
                      estado = "Unidade da Federação (UF)", 
                      pais = "País de localização", 
                      iso_a3 = "Código ISO-3 do País", 
                      aeronave_critica = "Aeronave crítica para dimensionamento da infraestrutura do aeródromo",
                      latitude = "Latitude geográfica (graus decimais)",
                      longitude = "Longitude geográfica (graus decimais)") |> 
  glimpse()

rm(pais_iso3)

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
  mutate(partida_prevista = dmy_hm(partida_prevista),
         partida_real = dmy_hm(partida_real), 
         chegada_prevista = dmy_hm(chegada_prevista),
         chegada_real = dmy_hm(chegada_real), 
         assentos = as.numeric(assentos), 
         atraso_partida_min = as.numeric(difftime(partida_real, partida_prevista, units = "mins")),
         atraso_chegada_min = as.numeric(difftime(chegada_real, chegada_prevista, units = "mins")),
         across(where(is.character),~ {
           x <- iconv(as.character(.x), from = "UTF-8", to = "latin1", sub = "")
           Encoding(x) <- "UTF-8"
           x})) |> 
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
  tab_header(title = md("**Saúde das Bases de Dados**"),
             subtitle = "Auditoria de estrutura, cardinalidade e valores faltantes (NAs)") |> 
  cols_label(Linhas = "Total de Linhas", Coluna = "Coluna", Tipo = "Tipo", 
             Valores_Unicos = "Valores Únicos", NAs = "NAs (Qtd)", Percentual = "NAs (%)") |> 
  fmt_number(columns = c(Linhas, Valores_Unicos, NAs), decimals = 0, dec_mark = ",", sep_mark = ".") |> 
  fmt_percent(columns = Percentual, decimals = 1, dec_mark = ",", sep_mark = ".") |> 
  cols_align(align = "center", columns = c(Linhas, Tipo, Valores_Unicos, NAs, Percentual)) |> 
  cols_align(align = "left", columns = Coluna) |> 
  gt_color_rows(columns = Percentual, palette = c("#ffffff", "#E64E53"), domain = c(0, 1)) |> 
  tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
  tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3), 
              column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black", 
              table_body.hlines.color = "#ececec", table.border.top.style = "hidden")



## Escopo Temporal e Cardinalidade Macro

flights |>
  summarise(data_min = format(min(partida_prevista, na.rm = TRUE), "%d/%m/%Y"),
            data_max = format(max(partida_prevista, na.rm = TRUE), "%d/%m/%Y"),
            aeroportos = format(n_distinct(origem_icao, na.rm = TRUE), big.mark = ".", decimal.mark = ","),
            empresas = format(n_distinct(empresa, na.rm = TRUE), big.mark = ".", decimal.mark = ","),
            modelos = format(n_distinct(modelo_equipamento, na.rm = TRUE), big.mark = ".", decimal.mark = ",")) |>
  pivot_longer(cols = everything(),
               names_to = "Indicador",
               values_to = "Valor") |>
  mutate(Indicador = case_when(Indicador == "data_min" ~ "Data Inicial (Partidas)",
                               Indicador == "data_max" ~ "Data Final (Partidas)",
                               Indicador == "aeroportos" ~ "Aeroportos de Origem (Total)",
                               Indicador == "empresas" ~ "Companhias Aéreas (Total)",
                               Indicador == "modelos" ~ "Modelos de Equipamento (Total)")) |>
  gt() |>
    tab_header(title = md("**Escopo Temporal e Operacional**"),
               subtitle = "Indicadores macro de cobertura e cardinalidade da base") |>
    cols_align(align = "left", columns = Indicador) |>
    cols_align(align = "right", columns = Valor) |>
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |>
    tab_options(heading.align = "left", 
                column_labels.font.weight = "bold", 
                column_labels.border.top.width = px(3), 
                column_labels.border.top.color = "#E3120B", 
                table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", 
                table.border.top.style = "hidden")


## Perfil da Malha Aeroportuária (Nacional vs. Internacional)

flights |>
  pivot_longer(cols = c(origem_icao, destino_icao), values_to = "icao") |>
  drop_na(icao) |>
  distinct(icao) |>
  inner_join(airports, by = join_by(icao)) |>
  mutate(tipo = if_else(pais == "BRASIL", "Nacional", "Internacional")) |>
  count(tipo, pais, name = "aeroportos") |>
  mutate(pais = if_else(tipo == "Internacional", 
                        as.character(fct_lump_n(factor(pais), n = 5, w = aeroportos, other_level = "Outros")), 
                        "Brasil")) |>
  summarise(aeroportos = sum(aeroportos), .by = c(tipo, pais)) |>
  arrange(desc(tipo), desc(aeroportos)) |>
  mutate(pais = str_to_title(pais)) |>
  gt(id = "tbl_conectividade", groupname_col = "tipo") |>
    tab_header(title = md("**Conectividade da Malha Aeroportuária**"),
               subtitle = "Quantidade de aeroportos únicos operacionais em 2023 (Nacional vs. Internacional)") |>
    cols_label(pais = "País de Origem/Destino", aeroportos = "Aeroportos Conectados") |>
    fmt_number(columns = aeroportos, decimals = 0, use_seps = TRUE, sep_mark = ".") |>
    summary_rows(groups = "Internacional", columns = aeroportos, fns = list(Subtotal = ~sum(.)),
                 formatter = fmt_number, decimals = 0, use_seps = TRUE, sep_mark = ".") |>
    cols_align(align = "left", columns = pais) |>
    cols_align(align = "center", columns = aeroportos) |>
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |>
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black",
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")

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

# Tópico 1: Visão Geral de Operações e Tendências ----

## Evolução Temporal e Sazonalidade (Volume de Voos)
flights |>
  filter(year(partida_prevista) == 2023) |>
  group_by(mes = month(partida_prevista, label = TRUE)) |>
  summarise(volume = n(), .groups = "drop") |>
  ggplot(aes(mes, volume, group = 1, colour = "Volume de Voos")) +
    geom_line(linewidth = 1, show.legend = FALSE) +
    scale_y_continuous(labels = fmt_lab("number")) +
    scale_econ(aes = "colour", scheme = "lines_side") +
    labs(title = "Estabilidade do Tráfego Aéreo", 
         subtitle = "Evolução mensal do volume total de voos previstos, 2023", 
         caption = "Fonte: ANAC | Elaboração Própria") +
    theme_econ_base() 


## Market Share por Oferta de Assentos e Voos Realizados

flights |> 
  filter(situacao == "REALIZADO") |> 
  group_by(empresa) |> 
  summarise(voos = n(), assentos = sum(assentos, na.rm = TRUE)) |> 
  mutate(empresa = fct_lump_n(empresa, n = 5, w = voos, other_level = "Outras")) |> 
  group_by(empresa) |> 
  summarise(voos = sum(voos), assentos = sum(assentos)) |> 
  mutate(`Voos Realizados` = voos / sum(voos), 
         `Assentos Ofertados` = assentos / sum(assentos)) |> 
  select(-c(voos, assentos)) |> 
  pivot_longer(cols = c(`Voos Realizados`, `Assentos Ofertados`), 
               names_to = "metrica", values_to = "valor") |> 
  mutate(empresa = fct_reorder(empresa, valor, .desc = TRUE), 
         empresa = fct_relevel(empresa, "Outras", after = Inf)) |> 
  ggplot(aes(empresa, valor, fill = metrica)) +
    geom_col(position = "dodge") +
    scale_y_continuous(labels = fmt_lab("percent")) +
    scale_econ(aes = "fill", scheme = "web") +
    labs(title = "Concentração do Mercado Aéreo", 
         subtitle = "Maket share das 5 maiores companhias (voos realizados vs assentos ofertados)", 
         caption = "Fonte: ANAC | Elaboração Própria") +
    theme_econ_base()
  

## KPIs Macro (Taxas de Cancelamento e Atrasos Médios)

flights |>
  mutate(empresa = fct_lump_n(empresa, n = 5, other_level = "Outras")) |>
  summarise(taxa_cancelamento = mean(situacao == "CANCELADO", na.rm = TRUE),
            atraso_partida    = mean(atraso_partida_min[situacao == "REALIZADO"], na.rm = TRUE),
            atraso_chegada    = mean(atraso_chegada_min[situacao == "REALIZADO"], na.rm = TRUE),
            .by               = empresa) |>
  arrange(desc(taxa_cancelamento)) |>
  gt() |>
    tab_header(title = md("**Performance Operacional por Companhia Aérea**"),
               subtitle = "Indicadores médios e distribuição de atrasos nas partidas (2023)") |>
    cols_label(empresa = "Empresa", taxa_cancelamento = "Cancelamentos",
               atraso_partida = "Atraso Partida (min)", atraso_chegada = "Atraso Chegada (min)") |>
    fmt_percent(columns = taxa_cancelamento, decimals = 1, dec_mark = ",", sep_mark = ".") |>
    fmt_number(columns = c(atraso_partida, atraso_chegada), decimals = 1, dec_mark = ",", sep_mark = ".") |>
    cols_align(align = "left", columns = empresa) |>
    cols_align(align = "center", columns = c(taxa_cancelamento, atraso_partida, atraso_chegada)) |>
    gt_color_rows(columns = taxa_cancelamento, palette = c("#ffffff", "#E64E53"), domain = c(0, NA)) |>
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |>
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black",
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")

# Tópico 2: Logística e Malha Aérea ----

## Mapeamento de Rotas e Conexões Principais

flights |> 
  drop_na(partida_real) |> 
  count(origem_icao, destino_icao, name = "volume_voos") |> 
  slice_max(order_by = volume_voos, n = 20) |> 
  gt() |> 
    tab_header(title = md("**Top 20 Rotas por Volumes de Voos Realizados**")) |> 
    cols_label(origem_icao = "Origem (ICAO)", destino_icao = "Destino (ICAO)", volume_voos = "Total de Voos") |> 
    fmt_number(columns = volume_voos, decimals = 0, dec_mark = ",", sep_mark = ".") |> 
    cols_align(align = "left", columns = c(origem_icao, destino_icao)) |> 
    cols_align(align = "center", columns = volume_voos) |> 
    gt_color_rows(columns = volume_voos, palette = c("#ffffff", "#3D89C3")) |> 
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")
  
flights |> 
  filter(!is.na(partida_real)) |> 
  group_by(origem_icao) |> 
  summarise(conexao = n_distinct(destino_icao)) |> 
  slice_max(order_by = conexao, n = 10) |>
  mutate(origem_icao = fct_reorder(origem_icao, conexao)) |> 
  ggplot(aes(conexao, origem_icao)) +
    geom_col(fill = pal["blue1"]) +
    labs(title = "Hubs Centrais da Malha Aérea", 
         subtitle = "Top 10 aeroportos classificados por volume de destinos únicos diretos",
         caption = "Fonte: ANAC | Elaboração Própria") +
    scale_econ() +
    theme_econ_base()

## Cálculo de Distâncias Geográficas entre Aeroportos (calc_dist)

flights |>
  drop_na(partida_real) |>
  mutate(empresa = fct_lump_n(empresa, n = 3)) |>
  filter(empresa != "Other") |>
  left_join(airports, by = c("origem_icao" = "icao")) |>
  left_join(airports, by = c("destino_icao" = "icao"), suffix = c("_orig", "_dest")) |>
  drop_na(longitude_orig, latitude_orig, longitude_dest, latitude_dest) |>
  mutate(dist_km = geosphere::distHaversine(cbind(longitude_orig, latitude_orig), 
                                            cbind(longitude_dest, latitude_dest)) / 1000) |>
  ggplot(aes(dist_km, fill = empresa, colour = empresa)) +
    geom_density(alpha = 0.5) +
    scale_econ(aes = "fill", scheme = "web") +
    scale_econ(aes = "colour", scheme = "web") +
    scale_x_continuous(labels = fmt_lab("number")) +
    scale_y_continuous(labels = NULL) +
    theme_econ_base() +
    theme(legend.position = "top") +
    labs(title = "Perfil de Distância da Malha Aérea",
         subtitle = "Distribuição das rotas em quilômetros operadas pelas três maiores empresas",
         fill = NULL,
         colour = NULL,
         caption = "Fonte: Base de Voos e Aeroportos | Elaboração Própria")
  

## Identificação de Hubs e Nós Estratégicos

flights |>
  drop_na(partida_real) |>
  summarise(partidas_totais    = n(),
            assentos_ofertados = sum(assentos, na.rm = TRUE),
            media_voos_diarios = n() / n_distinct(as.Date(partida_real)),
            .by                = origem_icao) |>
  mutate(pct_partidas = partidas_totais / sum(partidas_totais)) |>
  filter(pct_partidas > 0.05) |>
  left_join(select(airports, icao, nome_aeroporto), by = join_by(origem_icao == icao)) |>
  mutate(nome_aeroporto = coalesce(nome_aeroporto, 
                                   case_when(origem_icao == "SBGR" ~ "Guarulhos (Gov. André Franco Montoro)",
                                             TRUE ~ origem_icao))) |>
  arrange(desc(pct_partidas)) |>
  select(origem_icao, nome_aeroporto, partidas_totais, 
         pct_partidas, assentos_ofertados, media_voos_diarios) |>
  gt() |>
    tab_header(title = md("**Hubs Estratégicos da Malha Aérea**"),
               subtitle = "Aeroportos responsáveis por mais de 5% do volume total de partidas") |>
    cols_label(origem_icao = "Código ICAO", nome_aeroporto = "Aeroporto",
               partidas_totais = "Total de Partidas", pct_partidas = "Share da Malha",
               assentos_ofertados = "Assentos Ofertados", media_voos_diarios = "Voos/Dia") |>
    fmt_number(columns = c(partidas_totais, assentos_ofertados), decimals = 0, dec_mark = ",", sep_mark = ".") |>
    fmt_number(columns = media_voos_diarios, decimals = 1, dec_mark = ",", sep_mark = ".") |>
    fmt_percent(columns = pct_partidas, decimals = 1, dec_mark = ",", sep_mark = ".") |> 
    cols_align(align = "left", columns = c(origem_icao, nome_aeroporto)) |>
    cols_align(align = "center", columns = c(partidas_totais, pct_partidas, assentos_ofertados, 
                                             media_voos_diarios)) |>
    gt_color_rows(columns = pct_partidas, palette = c("#ffffff", "#3D89C3")) |>
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |>
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black",
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")

# Distribuição Espacial dos Hubs

ne_countries(scale = "medium", returnclass = "sf") |>
  filter(name_long != "Antarctica") |>
  ggplot() +
  geom_sf(fill = "white", colour = "gray9", linewidth = 0.18) +
  geom_sf(data = flights |>
      left_join(airports |> 
                  select(icao, pais_origem = pais, longitude, latitude), by = c("origem_icao" = "icao")) |>
      left_join(airports |> select(icao, pais_destino = pais), by = c("destino_icao" = "icao")) |>
      filter(pais_origem != pais_destino) |>
      group_by(origem_icao) |>
      summarise(total_voos = n(),
                total_assentos = sum(assentos, na.rm = TRUE),
                longitude = first(longitude),
                latitude = first(latitude)) |>
      ungroup() |>
      mutate(pct_voos = total_voos / sum(total_voos),
             classificacao = if_else(pct_voos > 0.05, 
                                     "Hub Internacional (> 5%)", "Conexão Secundária")) |>
      drop_na(longitude, latitude) |>
      arrange(pct_voos) |>
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326), 
      mapping = aes(colour = classificacao, size = total_assentos),
      alpha = 0.8) +
    scale_econ(aes = "colour") +
    scale_size_continuous(range = c(0.8, 6), labels = fmt_lab("number")) +
    coord_sf(xlim = c(-180, 180), ylim = c(-58, 84), expand = FALSE) +
    theme_econ_base() +
    theme(axis.text = element_blank(),
          axis.line.x = element_blank(),
          axis.ticks.x = element_blank(),
          panel.grid.major.y = element_blank(),
          legend.position = "top",
          legend.box = "vertical",
          plot.caption = element_text(hjust = 0, colour = pal["land_text"])) +
  guides(colour = guide_legend(override.aes = list(size = 4, alpha = 1), order = 1),
         size = guide_legend(override.aes = list(colour = "gray50"), order = 2)) +
  labs(title = "Conectividade Global: Hubs Internacionais",
       subtitle = "Volume de assentos ofertados (excluindo voos domésticos) por aeroporto de origem",
        colour = NULL,
        size = "Assentos Ofertados",
        caption = "Fonte: ANAC e Natural Earth | Elaboração Própria")

read_state(year = 2019, showProgress = FALSE) |>
  ggplot() +
  geom_sf(fill = "white", colour = "gray9", linewidth = 0.4) +
  geom_sf(data = flights |>
            group_by(origem_icao) |>
            summarise(total_voos = n(),
                      total_assentos = sum(assentos, na.rm = TRUE)) |>
            ungroup() |>
            mutate(pct_voos = total_voos / sum(total_voos),
                   classificacao = if_else(pct_voos > 0.05, 
                                           "Hub Principal (> 5%)", "Conexão Secundária")) |>
            left_join(airports, by = c("origem_icao" = "icao")) |>
            filter(iso_a3 == "BRA", longitude < -34.5) |>
            drop_na(longitude, latitude) |>
            arrange(pct_voos) |>
            st_as_sf(coords = c("longitude", "latitude"), crs = 4326) |>
            st_transform(4674),
            mapping = aes(colour = classificacao, size = total_assentos), alpha = 0.8) +
  scale_econ(aes = "colour") +
  scale_size_continuous(range = c(0.8, 6), labels = fmt_lab("number")) +
  coord_sf(xlim = c(-74, -34.5), ylim = c(-34, 6)) +
  theme_econ_base() +
  theme(axis.text = element_blank(),
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = "top",
        legend.box = "vertical",
        plot.caption = element_text(hjust = 0, colour = pal["land_text"])) +
  guides(colour = guide_legend(override.aes = list(size = 4, alpha = 1), order = 1),
         size = guide_legend(override.aes = list(colour = "gray50"), order = 2)) +
  labs(title = "Distribuição da Malha Aérea no Brasil Continental",
       subtitle = "Volume de assentos ofertados (excluindo operações em ilhas oceânicas)",
       colour = NULL,
       size = "Assentos Ofertados",
       caption = "Fonte: ANAC e IBGE via geobr | Elaboração Própria")

# Tópico 3: Performance de Pontualidade ----

## Distribuição de Atrasos (Partida vs. Chegada)

flights |> 
  filter(situacao == "REALIZADO") |>
  select(atraso_partida_min, atraso_chegada_min) |> 
  pivot_longer(cols = everything(), names_to = "tipo_atraso", values_to = "minutos") |> 
  filter(minutos >= -30, minutos <= 150) |> 
  mutate(tipo_atraso = case_when(tipo_atraso == "atraso_partida_min" ~ "Partida", 
                                 tipo_atraso == "atraso_chegada_min" ~ "Chegada")) |> 
  ggplot(aes(minutos, fill = tipo_atraso)) +
    geom_density(alpha = 0.7, colour = NA) +
    scale_econ(aes = "fill") +
    theme_econ_base() +
    labs(title = "Distribuição de Atrasos: Partidas e Chegadas", 
         subtitle = "Densidades de minutos de atraso para voos realizados no período", 
         x = "Minutos de Atraso (valores negativos indicam adiantamento)", 
         y = "", 
         fill = "Etapa do Voo", 
         caption = "Fonte: ANAC | Elaboração Própria")
  
  

## Eficiência Operacional por Aeroporto de Origem e Destino

flights |> 
  filter(situacao == "REALIZADO") |> 
  drop_na(atraso_partida_min) |> 
  summarise(total_voos   = n(), 
            media_atraso = mean(atraso_partida_min),
            .by          = nome_origem) |>
  filter(total_voos > 1000) |> 
  slice_min(order_by = media_atraso, n = 10) |> 
  arrange(media_atraso) |> 
  gt() |> 
    tab_header(title = md("**Top 10 Aeroportos Mais Pontuais**"), 
               subtitle = "Aeroportos com menor média de atraso na partida (>1.000 voos realizados)") |> 
    cols_label(nome_origem = "Aeroporto de Origem", total_voos = "Total de Voos", 
               media_atraso = "Atraso Médio (min)") |> 
    fmt_number(columns = media_atraso, decimals = 1, dec_mark = ",", sep_mark = ".") |> 
    fmt_number(columns = total_voos, decimals = 0, dec_mark = ",", sep_mark = ".") |> 
    cols_align(align = "left", columns = nome_origem) |> 
    cols_align(align = "center", columns = c(total_voos, media_atraso)) |> 
    gt_color_rows(columns = media_atraso, palette = c("#ffffff", "#3D89C3")) |> 
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")
  

## Análise de Impacto por Período do Dia e Turno

flights |> 
  mutate(empresa = fct_lump_n(empresa, n = 3)) |> 
  filter(empresa != "Other", !is.na(partida_prevista)) |> 
  mutate(turno = case_when(hour(partida_prevista) >= 0 & hour(partida_prevista) < 6 ~ "Madrugada",
                           hour(partida_prevista) >= 6 & hour(partida_prevista) < 12 ~ "Manhã",
                           hour(partida_prevista) >= 12 & hour(partida_prevista) < 18 ~ "Tarde",
                           hour(partida_prevista) >= 18 ~ "Noite"),
         turno = factor(turno, levels = c("Madrugada", "Manhã", "Tarde", "Noite"))) |> 
  group_by(empresa, turno) |> 
  summarise(pct_atraso = mean(atraso_partida_min > 15, na.rm = TRUE), 
            .groups = "drop") |> 
  ggplot(aes(empresa, pct_atraso, fill = turno)) +
    geom_col(position = "stack") +
    scale_y_continuous(labels = fmt_lab("percent")) +
    scale_econ(aes = "fill", scheme = "stacked") +
    theme_econ_base() +
    labs(title = "Impacto de Atrasos por Período do Dia", 
         subtitle = "Taxa de atrasos (>15 min) por turno nas principais emrpesas", 
         caption = "Fonte: ANAC | Elaboração Própria", 
         fill = "Turno")


# Tópico 4: Frota e Capacidade (Aeronaves) ----

## Perfil dos Fabricantes (Boeing, Airbus, Embraer)

flights |>
  left_join(planes |>
              drop_na(icao_tipo, fabricante) |>
              count(icao_tipo, fabricante) |>
              group_by(icao_tipo) |>
              slice_max(n, n = 1, with_ties = FALSE) |>
              select(-n),
            by = c("modelo_equipamento" = "icao_tipo")) |>
  drop_na(fabricante) |>
  count(fabricante, name = "total") |>
  slice_max(total, n = 5) |>
  mutate(fabricante = fct_reorder(fabricante, total)) |>
  ggplot(aes(total, fabricante, fill = fabricante)) +
    geom_col(show.legend = FALSE) +
    scale_x_continuous(labels = fmt_lab("number")) +
    scale_econ(aes = "fill") +
    theme_econ_base() +
    labs(title = "Top 5 Fabricantes por Volume de Voos",
         subtitle = "Total de decolagens realizadas por fabricante da aeronave",
         caption = "Fonte: ANAC | Elaboração Própria",
         x = "", y = "")

## Idade Média da Frota Operante e Ciclo de Vida

planes |> 
  drop_na(operador, ano_fabricacao) |> 
  filter(ano_fabricacao > 1900) |>
  mutate(idade = 2023 - ano_fabricacao, 
         operador = fct_lump_n(operador, n = 5)) |> 
  filter(operador != "Other") |> 
  mutate(operador = fct_infreq(fct_drop(operador))) |> 
  ggplot(aes(idade, fill = operador)) +
    geom_density(alpha = 0.8, colour = "transparent") +
    geom_vline(aes(xintercept = media_idade),
               data = ~ .x |> 
                 group_by(operador) |> 
                 summarise(media_idade = mean(idade)), colour = "#0C0C0C", linetype = "dashed", linewidth = 0.6) +
  facet_wrap(~operador, ncol = 2, scale = "free_y") +
  scale_x_continuous(labels =  fmt_lab("number")) +
  scale_econ(aes = "fill") +
  theme_econ_base() +
  theme(legend.position = "none") +
  labs(title = "Perfil Etário da Frota Operante",
       subtitle = "Distribuição da idade e média (linha tracejada) para as 5 maiores operadoras",
       caption = "Fonte: ANAC | Elaboração Própria",
       x = "",
       y = "")
                 

## Distribuição de Assentos por Modelo de Equipamento (ICAO Type)

flights |> 
  drop_na(modelo_equipamento) |> 
  rename(icao_tipo = modelo_equipamento) |> 
  summarise(total_assentos = sum(assentos, na.rm = TRUE), .by = icao_tipo) |> 
  slice_max(total_assentos, n = 10) |> 
  left_join(planes |> 
              drop_na(icao_tipo, fabricante) |> 
              count(icao_tipo, fabricante) |> 
              slice_max(n, n = 1, by = icao_tipo, with_ties = FALSE) |> 
              select(-n), 
            by = join_by(icao_tipo)) |> 
  select(icao_tipo, fabricante, total_assentos) |> 
  gt() |> 
    tab_header(title = md("**Top 10 Modelos de Aeronaves**"), 
               subtitle = "Maior volume de assentos ofertados no ano") |> 
    cols_label(icao_tipo = "Código de ICAO", fabricante = "Fabricante Principal", 
               total_assentos = "Assentos Ofertados") |> 
    fmt_number(columns = total_assentos, decimals = 0, dec_mark = ",", sep_mark = ".") |> 
    cols_align(align = "left", columns = c(icao_tipo, fabricante)) |> 
    cols_align(align = "center", columns = total_assentos) |> 
    gt_color_rows(columns = total_assentos, palette = c("#ffffff", "#3D89C3")) |> 
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E3120B", table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")
  


# Tópico 5: Perfil e Comportamento de Tráfego ----

## Análise de Ocupação (Assentos Ofertados vs. Disponibilidade)

flights |>
  drop_na(partida_prevista, empresa) |>
  mutate(empresa = fct_lump_n(empresa, n = 5)) |>
  filter(empresa != "Other") |>
  mutate(empresa = fct_drop(empresa)) |>
  group_by(empresa, mes = lubridate::floor_date(partida_prevista, "month")) |>
  summarise(voos = n(), assentos = sum(assentos, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(voos, assentos)) +
    geom_point(alpha = 0.6, colour = unname(pal["blue1"]), size = 2) +
    geom_smooth(method = "lm", se = FALSE, colour = unname(pal["data_red"]), linewidth = 0.8) +
    facet_wrap(~ empresa, scales = "free", ncol = 3) +
    scale_x_log10(labels = fmt_lab("number")) +
    scale_y_log10(labels = fmt_lab("number")) +
    theme_econ_base() +
    labs(title = "Dinâmica de Frequência e Capacidade",
         subtitle = "Relação mensal entre voos e assentos (escala logarítmica base 10)",
         caption = "Fonte: ANAC | Elaboração Própria",
         x = "Total de Voos Realizados (log10)",
         y = "Total de Assentos Ofertados (log10)")


## Sazonalidade por Natureza da Linha (Doméstica vs. Internacional)

flights |> 
  drop_na(partida_prevista, codigo_tipo_linha) |> 
  filter(lubridate::as_date(partida_prevista) <= "2023-12-31") |> 
  mutate(mes = lubridate::floor_date(partida_prevista, "month"), 
         tipo_linha = if_else(str_detect(str_to_upper(codigo_tipo_linha), "^I|^X|^G"), 
                              "Internacional", "Doméstica")) |> 
  group_by(tipo_linha, mes) |> 
  summarise(voos = n(), .groups = "drop") |> 
  ggplot(aes(mes, voos, colour = tipo_linha)) +
    geom_line(linewidth = 0.9, show.legend = TRUE) +
    facet_wrap(~ tipo_linha, scales = "free_y") +
    scale_y_continuous(labels = fmt_lab("number")) +
    scale_econ(aes = "colour") +
    theme_econ_base() +
    labs(title = "Evolução Temporal do Mercado Aéreo", 
         subtitle = "Evolução mensal do volume de decolagens (até dez/2023)",
         caption = "Fonte: ANAC | Elaboração Própria",
         x = "", y = "")


# Tópico 6: Dinâmica Regional ----

## Agrupamento por UF e Região (get_region)

flights |> 
  left_join(airports, by = c("origem_icao" = "icao")) |> 
  drop_na(estado) |> 
  mutate(regiao = case_when(estado %in% c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
                            estado %in% c("AC", "AP", "AM", "PA", "RO", "RR", "TO") ~ "Norte",
                            estado %in% c("DF", "GO", "MT", "MS") ~ "Centro-Oeste",
                            estado %in% c("MG", "ES", "RJ", "SP") ~ "Sudeste",
                            estado %in% c("RS", "PR", "SC") ~ "Sul",
         .default = NA_character_)) |>
  drop_na(regiao) |> 
  count(regiao, name = "total_voos") |> 
  mutate(regiao = fct_reorder(regiao, total_voos)) |> 
  ggplot(aes(regiao, total_voos, fill = regiao)) +
    geom_col() +
    scale_y_continuous(labels = fmt_lab("number")) +
    scale_econ(aes = "fill") +
    theme_econ_base() +
    theme(legend.position = "none") +
    labs(title = "Volume de Partidas por Região", 
         subtitle = "Quantidade total de voos agrupados pelas grandes regiões do Brasil", 
         caption = "Fonte: ANAC | Elaboração Própria")
  

## Matriz de Fluxos Migratórios entre Regiões Brasileiras

flights |> 
  left_join(airports |> 
              select(icao, estado), by = c("origem_icao" = "icao")) |> 
  rename(estado_origem = estado) |> 
  left_join(airports |> 
              select(icao, estado), by = c("destino_icao" = "icao")) |> 
  rename(estado_destino = estado) |> 
  drop_na(estado_origem, estado_destino) |> 
  mutate(regiao_origem = case_when(estado_origem %in% 
                                     c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
                                   estado_origem %in% 
                                     c("AC", "AP", "AM", "PA", "RO", "RR", "TO") ~ "Norte",
                                   estado_origem %in% 
                                     c("DF", "GO", "MT", "MS") ~ "Centro-Oeste",
                                   estado_origem %in% 
                                     c("MG", "ES", "RJ", "SP") ~ "Sudeste",
                                   estado_origem %in% 
                                     c("RS", "PR", "SC") ~ "Sul",
                                  .default = NA_character_),
         regiao_destino = case_when(estado_destino %in% 
                                      c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
                                    estado_destino %in% 
                                      c("AC", "AP", "AM", "PA", "RO", "RR", "TO") ~ "Norte",
                                    estado_destino %in% 
                                      c("DF", "GO", "MT", "MS") ~ "Centro-Oeste",
                                    estado_destino %in% 
                                      c("MG", "ES", "RJ", "SP") ~ "Sudeste",
                                    estado_destino %in% 
                                      c("RS", "PR", "SC") ~ "Sul",
                                   .default = NA_character_)) |> 
  drop_na(regiao_origem, regiao_destino) |> 
  count(regiao_origem, regiao_destino, name = "total_voos") |> 
  mutate(categoria_fluxo = cut(total_voos, breaks = 5, labels = c("Muito Baixo", "Baixo", 
                                                                  "Médio", 
                                                                  "Alto", "Muito Alto"))) |> 
  ggplot(aes(regiao_destino, regiao_origem, fill = categoria_fluxo)) +
    geom_tile(colour = "white", linewidth = 0.5) +
    scale_econ(aes = "fill", scheme = "equal") +
    theme_econ_base() +
    theme(panel.grid = element_blank(), axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = "Matriz de Fluxos aéreos Inter-Regionais", 
         subtitle = "Intensidade do volume de voos agrupados por macrorregiões de origem e destino", 
         caption = "Fonte: ANAC | Elaboração Própria")
         
  
## Densidade de Tráfego por Estado

read_state(year = 2020, showProgress = FALSE) |> 
  left_join(flights |> 
              filter(year(partida_real) == 2023) |> 
              left_join(airports, by = c("origem_icao" = "icao")) |> 
              drop_na(estado) |> 
              count(estado, name= "total_partidas"), 
            by = c("abbrev_state" = "estado")) |> 
  mutate(total_partidas = replace_na(total_partidas, 0)) |> 
  ggplot() +
    geom_sf(aes(fill = total_partidas), colour = "gray9", linewidth = 0.4) +
    scale_fill_gradient(low = unname(pal["green"]), high = unname(pal["econ_red"]), 
                        na.value = "white", labels = fmt_lab("number")) +
    theme_econ_base() +
    theme(axis.text = element_blank(), axis.line.x = element_blank(), 
          axis.ticks.x = element_blank(), plot.caption = element_text(hjust = 0, colour = pal["land_text"]), 
          legend.position = "none") +
    labs(title = "Intensidade do tráfego aéreo nacional",
         subtitle = "Quantidade total de partidas realizadas por unidade federativa em 2023",
         fill = "Total de Partidas",
         caption = "Fonte: ANAC e IBGE via geobr | Elaboração Própria")

# Tópico 7: Tabelas e Rankings (GT) ----

## Ranking de Rotas Mais Movimentadas e Rentáveis
flights |> 
  drop_na(origem_icao, destino_icao) |> 
  summarise(total_voos = n(), atraso_medio = mean(atraso_partida_min, na.rm = TRUE), 
            .by = c(origem_icao, nome_origem, destino_icao, nome_destino)) |> 
  arrange(desc(total_voos)) |> 
  slice_head(n = 15) |> 
  mutate(rota = paste(origem_icao, "->", destino_icao),
         rank = row_number(), .before = 1) |> 
  select(rank, rota, nome_origem, nome_destino, total_voos, atraso_medio) |> 
  gt() |> 
    tab_header(title = md("**As 15 Rotas Mais Voadas**"), 
               subtitle = "Volume absoluto de voos e atraso médio na origem") |> 
    cols_label(rank = "Posição", rota = "Rota (ICAO)", nome_origem = "Aeroporto de Origem", 
               nome_destino = "Aeroporto de Destino", total_voos = "Total de Voos", 
               atraso_medio = "Atraso Médio (min)") |> 
    fmt_number(columns = atraso_medio, decimals = 1, dec_mark = ",", force_sign = TRUE) |> 
    cols_align(align = "center", columns = c(rank, rota, total_voos, atraso_medio)) |> 
    gt_color_rows(columns = atraso_medio, palette = c("#3D89C3", "#ffffff", "#E64E53")) |> 
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
    tab_options(heading.align = "left", column_labels.font.weight = "bold", column_labels.border.top.width = px(3),
                column_labels.border.top.color = "#E64E53", table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", table.border.top.style = "hidden")

## Tabelas de Performance Comparativa entre Companhias Aéreas

flights |> 
  drop_na(empresa) |> 
  summarise(total_voos = n(), total_assentos = sum(assentos, na.rm = TRUE), 
            taxa_cancelamento = mean(situacao == "CANCELADO" | is.na(partida_real), na.rm = TRUE), 
                                     atraso_medio = mean(atraso_partida_min, na.rm = TRUE),
            .by = empresa) |> 
  arrange(desc(total_voos)) |> 
  slice_head(n = 15) |> 
  gt() |> 
    tab_header(title = md("**Performance Oprecional Por Empresa**"),
               subtitle = "Volume de voos, oferta de assentos, cancelamento e atraso médio") |> 
    cols_label(empresa = "Companhia Área", total_voos = "Total de Voos", total_assentos = "Assentos Ofertados", 
               taxa_cancelamento = "Cancelamentos (%)", atraso_medio = "Atraso Médio (min)") |> 
    fmt_number(columns = c(total_voos, total_assentos), 
               decimals = 0, use_seps = TRUE, sep_mark = ".") |> 
    fmt_percent(columns = taxa_cancelamento, 
                decimals = 1, dec_mark = ",", sep_mark = ",") |> 
    fmt_number(columns = atraso_medio, 
               decimals = 1, dec_mark = ",", force_sign = TRUE) |> 
    cols_align(align = "center", columns = c(total_voos, total_assentos, taxa_cancelamento, atraso_medio)) |> 
    gt_color_rows(columns = taxa_cancelamento, palette = c("#3D89C3", "#ffffff", "#E64E53"), 
                  domain  = c(0, 1)) |>
    gt_color_rows(columns = atraso_medio, palette = c("#3D89C3", "#ffffff", "#E64E53")) |>
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |>
    tab_options(heading.align = "left", column_labels.font.weight = "bold", 
                column_labels.border.top.width = px(3), column_labels.border.top.color = "#E3120B",  
                table.border.bottom.color = "black", table_body.hlines.color = "#ececec", 
                table.border.top.style = "hidden")


# Tópico 8: Previsão de Atrasos e Predição Conformal (CatBoost) ----

## Engenharia de Features para Séries Temporais

db <- flights |> 
  drop_na(atraso_partida_min, partida_prevista)

rec <- recipe(atraso_partida_min ~ ., data = db) |> 
  step_mutate(hora_prevista = hour(partida_prevista)) |>
  step_date(partida_prevista, features = c("dow", "month"), keep_original_cols = FALSE) |> 
  step_rm(partida_real, chegada_real, chegada_prevista, situacao_partida, situacao_chegada, atraso_chegada_min, 
          num_voo, nome_origem, nome_destino, icao_empresa, codigo_di) 
  
## Treinamento do Modelo CatBoost para Estimativa de Atrasos

cb_sep <- boost_tree(trees = 50, tree_depth = 6, learn_rate = 0.05) |> 
  set_engine("catboost") |> 
  set_mode("regression")

cb_wf <- workflow() |> 
  add_recipe(rec) |> 
  add_model(cb_sep)

## Aplicação de Predição Conformal (Intervalos de Confiança)

splits <- initial_validation_split(db, prop = c(0.7, 0.15))

trn <- training(splits)
cal <- validation(splits)
tst <- testing(splits)

cb_fit <- cb_wf |> 
  fit(data = trn)

mu_hat_cal <- predict(cb_fit, new_data = cal) |> 
  pull(.pred)

R <- abs(cal$atraso_partida_min - mu_hat_cal)

alpha <- 0.1
n_cal <- length(R)
idx   <- ceiling((length(R) + 1) * (1 - alpha))
q_hat <- sort(R)[idx]

tst_preds <- tst |> 
  select(atraso_partida_min) |> 
  mutate(
    mu_hat = predict(cb_fit, new_data = tst) |> pull(.pred),
    lower  = mu_hat - q_hat,
    upper  = mu_hat + q_hat
  )

mean(tst_preds$atraso_partida_min >= tst_preds$lower & tst_preds$atraso_partida_min <= tst_preds$upper) 

tst_preds |> 
  mutate(id = row_number()) |> 
  slice_head(n = 20) |> 
  ggplot(aes(id, mu_hat)) +
    geom_errorbar(aes(ymin = lower, ymax = upper), colour = "#3D89C3", width = 0.2, alpha = 0.7) +
    geom_point(colour = "#3D89C3", size = 1.5) +
    geom_point(aes(id, atraso_partida_min), colour = "#E64E53", size = 1.5) +
    scale_y_continuous(labels = fmt_lab("number")) +
    labs(title = "Predição Conformal: Observado vs. Estimado",
         subtitle = "Amostra de 50 voos (Azul: Predição e Banda 90% | Vermelho: Atraso Real)",
         x = "Unidade da amostra (Teste)",
         y = "Atraso na Partida (min)",
         caption = "Fonte: ANAC | Elaboração Própria") +
    theme_econ_base()
    
# Tópico 9: Classificação de Grupos de Aeroportos (K-Means) ----

## Seleção de Atributos (Volume, Atraso Médio e Conectividade)

db_ap <- flights |> 
  drop_na(origem_icao, destino_icao) |> 
  summarise(volume = n(), conectividade = n_distinct(destino_icao), 
            atraso_medio = mean(atraso_partida_min, na.rm = TRUE), 
            .by = c(origem_icao, nome_origem)) |> 
  drop_na()

X_ap <- db_ap |> 
  select(volume, conectividade, atraso_medio) |> 
  scale()

rownames(X_ap) <- db_ap$origem_icao

## Clusterização e Perfilamento dos Grupos de Aeroportos

km_res <- kmeans(X_ap, centers = 4, nstart = 20)

db_ap_clust <- db_ap |> 
  mutate(cluster = as.factor(km_res$cluster)) |> 
  left_join(airports, by = c("origem_icao" = "icao")) |> 
  drop_na(longitude, latitude)

db_ap_clust |> 
  ggplot(aes(volume, atraso_medio, colour = cluster)) +
    geom_point(size = 3, alpha = 0.7) +
    scale_x_continuous(labels = fmt_lab("number")) +
    scale_y_continuous(labels = fmt_lab("number")) +
    scale_econ(aes = "colour", scheme = "web") +
    labs(title = "Perfilamento Operacional de Aeroportos",
         subtitle = "Clusters gerados via K-Means (k=4) por volume e atraso",
         colour = "Cluster",
         caption = "Fonte: ANAC | Elaboração Própria") +
    theme_econ_base()


ne_countries(scale = "medium", returnclass = "sf") |> 
  filter(name_long != "Antarctica") |> 
  ggplot() +
  geom_sf(fill = "#ececec", colour = "gray9", linewidth = 0.3) +
  geom_sf(data = db_ap_clust |> 
            st_as_sf(coords = c("longitude", "latitude"), crs = 4326), 
          aes(colour = cluster), size = 1.5, alpha = 0.8) +
  scale_econ(aes = "colour", scheme = "web") +
  labs(title = "Distribuição Geográfica dos Clusters Operacionais",
       subtitle = "Classificação da rede global de aeroportos conectada à base de voos",
       colour = "Cluster",
       caption = "Fonte: ANAC e Natural Earth | Elaboração Própria.") +
  theme_econ_base() +
  theme(axis.text  = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())



# Tópico 10: Classificação de Status de Voo (Ranger) ----

## Modelagem Random Forest para Predição de Cancelamentos

db <- flights |> 
  ungroup() |> 
  mutate(situacao = str_to_title(situacao)) |> 
  filter(situacao %in% c("Cancelado", "Realizado")) |>
  mutate(situacao = factor(situacao, levels = c("Cancelado", "Realizado"))) |>
  drop_na(partida_prevista, situacao) |> 
  droplevels() 

set.seed(42)
splits <- initial_split(db, prop = 0.8, strata = situacao)

trn <- training(splits)
tst <- testing(splits)

rec <- recipe(situacao ~., data = trn) |> 
  step_mutate(hora_prevista = hour(partida_prevista)) |> 
  step_date(partida_prevista, features = c("dow", "month"), keep_original_cols = FALSE) |> 
  step_rm(partida_real, chegada_real, chegada_prevista, situacao_partida, 
          situacao_chegada, atraso_partida_min, atraso_chegada_min, justificativa, 
          referencia, num_voo, nome_origem, nome_destino, icao_empresa, codigo_di)

rf <- rand_forest(trees = 50, min_n = 10) |> 
  set_engine("ranger", importance = "impurity") |> 
  set_mode("classification")
  
fit_rf <- workflow() |> 
  add_recipe(rec) |> 
  add_model(rf) |> 
  fit(data = trn)
  
res_tst <- predict(fit_rf, new_data = tst, type = "prob") |> 
  bind_cols(predict(fit_rf, new_data = tst, type = "class")) |>
  bind_cols(tst |> select(situacao))

res_tst |> 
  metrics(truth = situacao, estimate = .pred_class) |> 
  bind_rows(roc_auc(res_tst, truth = situacao, .pred_Cancelado)) |> 
  gt() |> 
    tab_header(title = md("**Performance do Random Forest**"), 
               subtitle = "Avaliação na amostra de teste (20%)") |> 
    cols_label(.metric = "Métrica", .estimator = "Estimador", .estimate = "Valor Estimado") |> 
    fmt_number(columns = .estimate, decimals = 3, dec_mark = ",", sep_mark = ".") |> 
    cols_align(align = "center", columns = c(.estimator, .estimate)) |> 
    gt_color_rows(columns = .estimate, palette = c("#E64E53", "#ffffff", "#3D89C3"), domain = c(0, 1)) |> 
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
    tab_options(heading.align = "left", 
                column_labels.font.weight = "bold", 
                column_labels.border.top.width = px(3), 
                column_labels.border.top.color = "#E3120B",  
                table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", 
                table.border.top.style = "hidden")
    

## Análise de Importância de Variáveis (Feature Importance)

extract_fit_engine(fit_rf)$variable.importance |> 
  enframe(name = "Variavel", value = "Importancia") |> 
  mutate(Variavel = fct_reorder(Variavel, Importancia)) |> 
  ggplot(aes(Importancia, Variavel)) +
    geom_col(fill = pal["blue1"], width = 0.65, alpha = 0.9) +
    scale_x_continuous(labels = fmt_lab("number")) +
    labs(title = "Importância das Variáveis (Feature Importance)",
         subtitle = "Redução média de impureza (Gini) no modelo Random Forest",
         x = "Importância da Variável",
         y = NULL,
         caption = "Fonte: ANAC | Elaboração Própria") +
    theme_econ_base()

# Tópico 11: Análise de Recorrência e Malha ----

## Identificação de Rotas com Alta Frequência Operacional

flights |> 
  drop_na(partida_real) |> 
  mutate(situacao = str_to_title(situacao)) |> 
  filter(situacao == "Realizado", year(partida_real) == 2023) |>
  summarise(dias_operados = n_distinct(as.Date(partida_real)),
            total_voos = n(), .by = c(origem_icao, nome_origem, destino_icao, nome_destino)) |>
  filter(dias_operados > 350) |> 
  arrange(desc(dias_operados), desc(total_voos)) |> 
  gt() |> 
    tab_header(title = md("**Rotas de Alta Frequência Operacional (2023)**"),
               subtitle = "Trechos que registraram voos em mais de 350 dias ao longo do ano") |> 
    cols_label(origem_icao = "Origem (ICAO)", nome_origem = "Aeroporto Origem", 
               destino_icao = "Destino (ICAO)", nome_destino = "Aeroporto Destino", 
               dias_operados = "Dias Operados", total_voos = "Volume Total (Voos)") |> 
    fmt_number(columns = total_voos,  decimals = 0,  use_seps = TRUE,  sep_mark = ".") |> 
    cols_align(align = "center", columns = c(origem_icao, destino_icao, dias_operados, total_voos)) |> 
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria") |> 
    tab_options(heading.align = "left", 
                column_labels.font.weight = "bold", 
                column_labels.border.top.width = px(3), 
                column_labels.border.top.color = "#E3120B",  
                table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", 
                table.border.top.style = "hidden")

## Estabilidade da Malha e Taxa de Recompra de Slots

flights |> 
  drop_na(origem_icao) |> 
  mutate(situacao = str_to_title(situacao)) |> 
  summarise(total_slots = n(),
            voos_realizados = sum(situacao == "Realizado" & !is.na(partida_real), na.rm = TRUE),
            taxa_resiliencia = voos_realizados / total_slots, .by = c(origem_icao, nome_origem)) |> 
  filter(total_slots >= 500) |> 
  arrange(desc(taxa_resiliencia), desc(total_slots)) |> 
  slice_head(n = 15) |> 
  gt() |> 
    tab_header(title = md("**Estabilidade da Malha: Resiliência de Slots por Aeroporto**"),
               subtitle = "Proporção de voos realizados em relação à alocação de slots na origem") |> 
    cols_label(origem_icao = "Origem (ICAO)", nome_origem = "Aeroporto", 
               total_slots = "Slots Previstos", voos_realizados = "Voos Realizados", 
               taxa_resiliencia = "Taxa de Resiliência (%)") |>
    fmt_number(columns = c(total_slots, voos_realizados),
               decimals = 0,use_seps = TRUE,sep_mark = ".") |> 
    fmt_percent(columns = taxa_resiliencia, decimals = 1,
                dec_mark = ",", sep_mark = ".") |> 
    cols_align(align = "center", columns = c(origem_icao, total_slots, voos_realizados, taxa_resiliencia)) |> 
    gt_color_rows(columns = taxa_resiliencia, palette = c("#E64E53", "#ffffff", "#3D89C3"), 
                  domain  = c(0, 1)) |>
    tab_source_note(source_note = "Fonte: ANAC | Elaboração Própria 
                    (Nota: amostra restrita a aeroportos com >= 500 slots)") |>
    tab_options(heading.align = "left", 
                column_labels.font.weight = "bold", 
                column_labels.border.top.width = px(3), 
                column_labels.border.top.color = "#E3120B",  
                table.border.bottom.color = "black", 
                table_body.hlines.color = "#ececec", 
                table.border.top.style = "hidden")  
