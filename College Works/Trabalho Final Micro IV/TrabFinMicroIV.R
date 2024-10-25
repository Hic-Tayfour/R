# Bibliotecas a Serem Usadas ----

library(tidyverse)      # manipulação de dados
library(readxl)         # leitura de arquivos excel
library(microdatasus)   # acesso a microdados do DataSUS
library(sf)             # manipulação de dados geográficos
library(rnaturalearth)  # dados geográficos
library(gt)             # tabelas personalizadas
library(patchwork)      # combinação de gráficos
library(ggpubr)         # gráficos
library(RColorBrewer)   # paletas de cores
library(ggthemes)       # temas para gráficos
library(purrr)          # para funções funcionais como map e walk

# DataFrames a Serem Usados ----

minf <- data.frame()
ninf <- data.frame()
cnes <- data.frame()

geo <- read_excel("CADMUN.xls") %>%
  mutate(
    MUNCOD   = as.character(MUNCOD),
    MICROCOD = as.character(MICROCOD),
    MSAUDCOD = as.character(MSAUDCOD),
    UF = substr(MICROCOD, 1, 2),
    MUNNOME = ifelse(
      str_detect(MUNNOME, "Município ignorado - "),
      str_extract(MUNNOME, "\\b[A-Z]{2}$"),
      MUNNOME
    )
  ) %>%
  select(MUNCOD, MUNNOME, MICROCOD, MSAUDCOD, UF, LATITUDE, LONGITUDE)

# Function a Serem Usadas ----

processar_dados <- function(db, geo, col_cod) {
  db %>%
    left_join(geo, by = setNames("MUNCOD", col_cod)) %>%
    select(everything(),
           MUNNOME,
           MICROCOD,
           MSAUDCOD,
           UF,
           LATITUDE,
           LONGITUDE)
}

criar_tabela_formatada <- function(titulo,
                                   subtitulo,
                                   fonte,
                                   nomes_colunas,
                                   nomes_linhas,
                                   valores_linhas) {
  dados <- data.frame(nome = nomes_linhas, matrix(
    valores_linhas,
    ncol = length(nomes_colunas),
    byrow = TRUE
  ))
  
  colnames(dados) <- c("nome", nomes_colunas)
  
  tabela <- gt(data = dados) %>%
    tab_header(title = titulo, subtitle = subtitulo) %>%
    tab_source_note(source_note = fonte) %>%
    tab_style(style = cell_text(weight = "bold"),
              locations = cells_column_labels(everything())) %>%
    tab_style(style = cell_text(weight = "bold"),
              locations = cells_body(columns = "nome"))
  
  return(tabela)
}

# Loop a ser Usado para Obtenção dos dados

processar_dados_ano <- function(ano, geo) {
  db_sim <- fetch_datasus(
    year_start = ano,
    year_end = ano,
    information_system = "SIM-DOINF",
    vars = c("SEXO", "CODMUNNATU", "LOCOCOR", "IDADEMAE", "ESCMAE", "QTDFILVIVO", "PARTO", "DTOBITO")
  ) %>%
    process_sim() %>%
    mutate(ANO = ano) %>%
    processar_dados(geo, "CODMUNNATU")
  
  db_sinasc <- fetch_datasus(
    year_start = ano,
    year_end = ano,
    information_system = "SINASC",
    vars = c("SEXO", "CODMUNRES", "LOCNASC", "IDADEMAE", "ESCMAE", "QTDFILVIVO", "PARTO", "DTNASC")
  ) %>%
    process_sim() %>%
    mutate(ANO = ano) %>%
    processar_dados(geo, "CODMUNRES")
  
  db_cnes <- fetch_datasus(
    year_start = ano,
    year_end = ano,
    month_start = 1,
    month_end = 12,
    information_system = "CNES-ST",
    vars = c("CODUFMUN", "MICR_REG")
  ) %>%
    mutate(ANO = ano) %>%
    processar_dados(geo, "CODUFMUN")
  
  list(db_sim = db_sim, db_sinasc = db_sinasc, db_cnes = db_cnes)
}

resultados <- map(2014:2019, ~ processar_dados_ano(.x, geo))

minf <- map_dfr(resultados, "db_sim")
ninf <- map_dfr(resultados, "db_sinasc")
cnes <- map_dfr(resultados, "db_cnes")

save(minf, file = "minf.Rdata")
save(ninf, file = "ninf.Rdata")
save(cnes, file = "cnes.Rdata")

rm(minf, ninf, cnes, resultados)

# Carregando os Dados Finais Para o Estudo ----

load("minf.Rdata")
load("ninf.Rdata")
load("cnes.Rdata")

# Geografia Brasileira ----

brasil <- ne_countries(scale = "medium",
                       country = "Brazil",
                       returnclass = "sf")

# Dados de Mortalidade Infántil ----

minf_grouped_month <- minf %>%
  mutate(
    DTOBITO = as.Date(DTOBITO),
    ano = year(DTOBITO),
    mes = month(DTOBITO)
  ) %>%
  group_by(MICROCOD, ano, mes) %>%
  summarize(
    total_observacoes = n(),
    LATITUDE = first(LATITUDE[!is.na(LATITUDE)]),  
    LONGITUDE = first(LONGITUDE[!is.na(LONGITUDE)]), 
    Masculino = sum(SEXO == "Masculino", na.rm = TRUE),
    Feminino = sum(SEXO == "Feminino", na.rm = TRUE),
    Hospital = sum(LOCOCOR == "Hospital", na.rm = TRUE),
    Domicilio = sum(LOCOCOR == "Domicílio", na.rm = TRUE),
    Via_Publica = sum(LOCOCOR == "Via pública", na.rm = TRUE),
    Outros = sum(LOCOCOR == "Outros", na.rm = TRUE),
    Outras_Vias_Publicas = sum(LOCOCOR == "Outro estabelecimento de saúde", na.rm = TRUE),
    ocorrencias_6 = sum(LOCOCOR == "6", na.rm = TRUE),
    Vaginal = sum(PARTO == "Vaginal", na.rm = TRUE),
    Cesareo = sum(PARTO == "Cesáreo", na.rm = TRUE),
    esc_mae_4a7 = sum(ESCMAE == "4 a 7 anos", na.rm = TRUE),
    esc_mae_8a11 = sum(ESCMAE == "8 a 11 anos", na.rm = TRUE),
    esc_mae_12oumais = sum(ESCMAE == "12 anos ou mais", na.rm = TRUE),
    esc_mae_1a3 = sum(ESCMAE == "1 a 3 anos", na.rm = TRUE),
    esc_mae_nenhuma = sum(ESCMAE == "Nenhuma", na.rm = TRUE),
    esc_mae_na = sum(is.na(ESCMAE))
    , .groups = "drop") %>%
  arrange(MICROCOD, ano, mes)

minf_grouped_year <- minf_grouped_month %>%
  group_by(MICROCOD, ano) %>%
  summarize(
    total_observacoes = sum(total_observacoes, na.rm = TRUE),
    LATITUDE = first(LATITUDE[!is.na(LATITUDE)]),  
    LONGITUDE = first(LONGITUDE[!is.na(LONGITUDE)]), 
    Masculino = sum(Masculino, na.rm = TRUE),
    Feminino = sum(Feminino, na.rm = TRUE),
    Hospital = sum(Hospital, na.rm = TRUE),
    Domicilio = sum(Domicilio, na.rm = TRUE),
    Via_Publica = sum(Via_Publica, na.rm = TRUE),
    Outros = sum(Outros, na.rm = TRUE),
    Outras_Vias_Publicas = sum(Outras_Vias_Publicas, na.rm = TRUE),
    ocorrencias_6 = sum(ocorrencias_6, na.rm = TRUE),
    Vaginal = sum(Vaginal, na.rm = TRUE),
    Cesareo = sum(Cesareo, na.rm = TRUE),
    esc_mae_4a7 = sum(esc_mae_4a7, na.rm = TRUE),
    esc_mae_8a11 = sum(esc_mae_8a11, na.rm = TRUE),
    esc_mae_12oumais = sum(esc_mae_12oumais, na.rm = TRUE),
    esc_mae_1a3 = sum(esc_mae_1a3, na.rm = TRUE),
    esc_mae_nenhuma = sum(esc_mae_nenhuma, na.rm = TRUE),
    esc_mae_na = sum(esc_mae_na, na.rm = TRUE)
    , .groups = "drop") %>%
  arrange(MICROCOD, ano)

minf_grouped_clean <- minf_grouped_year %>%
  filter(!is.na(LATITUDE) & !is.na(LONGITUDE))

minf_grouped_sf <- st_as_sf(minf_grouped_clean,
                            coords = c("LONGITUDE", "LATITUDE"),
                            crs = 4326)

minf_cropped <- st_intersection(minf_grouped_sf, brasil)

minf_cropped_coords <- minf_cropped %>%
  mutate(LONGITUDE = st_coordinates(.)[, 1], LATITUDE = st_coordinates(.)[, 2]) %>%
  st_drop_geometry()

## Gráficos de Hexágonos

gerar_grafico_hex <- function(df,
                              ano,
                              brasil,
                              palette,
                              title = NULL,
                              subtitle = NULL,
                              xlim = c(-75, -30),
                              ylim = c(-35, 5)) {
  ggplot(df %>% filter(ano == ano)) +
    geom_sf(data = brasil,
            fill = "white",
            color = "black") +
    geom_hex(aes(x = LONGITUDE, y = LATITUDE), bins = 60) +
    palette +
    labs(title = title %||% as.character(ano),
         subtitle = subtitle) +
    coord_sf(xlim = xlim,
             ylim = ylim,
             expand = FALSE) +
    theme_void() +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5))
}

palette <- scale_fill_gradient(low = "orange",
                               high = "red4",
                               name = "Ocorrências")

anos <- 2014:2019

hex_graficos <- map(
  anos,
  ~ gerar_grafico_hex(
    minf_cropped_coords,
    .x,
    brasil,
    palette,
    title = paste("Ocorrências em", .x),
    subtitle = "Análise por MicroRegião"
  )
)

hex_graficos <- map(hex_graficos, ~ .x + theme(legend.position = "none"))

combined_hex <- wrap_plots(hex_graficos, nrow = 2) +
  plot_annotation(
    title = "Mortalidade Infantil nas MicroRegiões da Saúde (2015-2019)",
    subtitle = "Análise Geográfica das Ocorrências de Mortalidade Infantil",
    theme = theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5, size = 12)
    )
  )

combined_hex

## Gráficos de Violino

gerar_grafico_violino <- function(df,
                                  title = "Distribuição de Ocorrências por Ano",
                                  subtitle = NULL,
                                  xlab = "Ano",
                                  ylab = "Ocorrências (Escala Logarítmica)",
                                  fill_colors = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b")) {
  ggplot(df, aes(
    x = as.factor(ano),
    y = total_observacoes,
    fill = as.factor(ano)
  )) +
    geom_violin(trim = TRUE,
                color = "black",
                alpha = 0.2) +
    geom_boxplot(
      width = 0.1,
      fill = "white",
      color = "black",
      outlier.shape = NA,
      alpha = 0.5
    ) +
    stat_summary(
      fun = "mean",
      geom = "point",
      color = "red",
      size = 4,
      shape = 23,
      fill = "red"
    ) +
    scale_y_log10(breaks = c(1, 10, 100, 1000),
                  labels = c("1", "10", "100", "1000")) +
    labs(
      title = title,
      subtitle = subtitle,
      x = xlab,
      y = ylab,
      caption = "Fonte: DataSUS"
    ) +
    scale_fill_manual(values = fill_colors) +
    theme_classic(base_size = 15) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "none",
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.ticks = element_blank()
    )
}

grafico_violino <- gerar_grafico_violino(
  minf_grouped_year,
  title = "Distribuição de Mortalidade Infantil por Ano",
  subtitle = "Análise Geográfica das Ocorrências",
  xlab = "Ano",
  ylab = "Ocorrências (Escala Logarítmica)",
  fill_colors = c("#2c7bb6", "#abd9e9", "#fdae61", "#d7191c", "#f46d43", "#1f78b4")
)

grafico_violino

## Gráfico de Linha

gerar_grafico_linha <- function(df,
                                title = "Total de Ocorrências por Ano",
                                subtitle = NULL,
                                xlab = "Ano",
                                ylab = "Total de Ocorrências",
                                line_color = "#1f77b4",
                                point_color = "#ff7f0e",
                                background_color = "#f9f9f9") {
  ggplot(df, aes(
    x = as.factor(ano),
    y = total_observacoes,
    group = 1
  )) +
    stat_summary(
      fun = sum,
      geom = "line",
      color = line_color,
      size = 1.2
    ) +
    stat_summary(
      fun = sum,
      geom = "point",
      color = point_color,
      size = 4,
      shape = 21,
      fill = "white",
      stroke = 1.5
    ) +
    labs(
      title = title,
      subtitle = subtitle,
      x = xlab,
      y = ylab,
      caption = "Fonte: DataSUS"
    ) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(
        hjust = 0.5,
        face = "bold",
        size = 16
      ),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = background_color, color = NA),
      plot.background = element_rect(fill = background_color, color = NA),
      axis.line = element_line(color = "gray50", size = 0.5),
      axis.ticks = element_line(color = "gray50")
    )
}

grafico_linha <- gerar_grafico_linha(
  minf_grouped_year,
  title = "Mortalidade Infantil por Ano",
  subtitle = "Total de Ocorrências Registradas de 2014 a 2019",
  xlab = "Ano",
  ylab = "Total de Ocorrências",
  line_color = "#2c7bb6",
  point_color = "#d7191c",
  background_color = "#f9f9f9"
)

grafico_linha

# Dados de Natalidade ----

ninf_grouped_month <- ninf %>%
  mutate(
    DTNASC = as.Date(DTNASC),
    ano = year(DTNASC),
    mes = month(DTNASC)
  ) %>%
  group_by(MICROCOD, ano, mes) %>%
  summarize(
    total_observacoes = n(),
    LATITUDE = first(LATITUDE[!is.na(LATITUDE)]),  
    LONGITUDE = first(LONGITUDE[!is.na(LONGITUDE)]), 
    Masculino = sum(SEXO %in% c("Masculino", "M"), na.rm = TRUE),
    Feminino = sum(SEXO %in% c("Feminino", "F"), na.rm = TRUE),
    Ignorado_SEXO = sum(SEXO %in% c("Ignorado", "I", "0"), na.rm = TRUE),
    Hospital = sum(LOCNASC %in% c("Hospital", "1"), na.rm = TRUE),
    Domicilio = sum(LOCNASC %in% c("Domicílio", "3"), na.rm = TRUE),
    Outro_Estab_Saude = sum(LOCNASC %in% c("Outro Estab Saúde", "2"), na.rm = TRUE),
    Outros = sum(LOCNASC %in% c("Outros", "4"), na.rm = TRUE),
    Ignorado_LOCNASC = sum(LOCNASC %in% c("Ignorado", "9"), na.rm = TRUE),
    Vaginal = sum(PARTO %in% c("Vaginal", "1"), na.rm = TRUE),
    Cesareo = sum(PARTO %in% c("Cesáreo", "2"), na.rm = TRUE),
    Ignorado_PARTO = sum(PARTO %in% c("Ignorado", "9"), na.rm = TRUE),
    esc_mae_4a7 = sum(ESCMAE %in% c("4 a 7 anos", "3"), na.rm = TRUE),
    esc_mae_8a11 = sum(ESCMAE %in% c("8 a 11 anos", "4"), na.rm = TRUE),
    esc_mae_12oumais = sum(ESCMAE %in% c("12 anos ou mais", "5"), na.rm = TRUE),
    esc_mae_1a3 = sum(ESCMAE %in% c("1 a 3 anos", "2"), na.rm = TRUE),
    esc_mae_nenhuma = sum(ESCMAE %in% c("Nenhuma", "1"), na.rm = TRUE),
    esc_mae_ignorado = sum(ESCMAE %in% c("Ignorado", "9"), na.rm = TRUE)
    , .groups = "drop") %>%
  arrange(MICROCOD, ano, mes)

ninf_grouped_year <- ninf_grouped_month %>%
  group_by(MICROCOD, ano) %>%
  summarize(
    total_observacoes = sum(total_observacoes, na.rm = TRUE),
    LATITUDE = first(LATITUDE[!is.na(LATITUDE)]),  
    LONGITUDE = first(LONGITUDE[!is.na(LONGITUDE)]), 
    Masculino = sum(Masculino, na.rm = TRUE),
    Feminino = sum(Feminino, na.rm = TRUE),
    Ignorado_SEXO = sum(Ignorado_SEXO, na.rm = TRUE),
    Hospital = sum(Hospital, na.rm = TRUE),
    Domicilio = sum(Domicilio, na.rm = TRUE),
    Outro_Estab_Saude = sum(Outro_Estab_Saude, na.rm = TRUE),
    Outros = sum(Outros, na.rm = TRUE),
    Ignorado_LOCNASC = sum(Ignorado_LOCNASC, na.rm = TRUE),
    Vaginal = sum(Vaginal, na.rm = TRUE),
    Cesareo = sum(Cesareo, na.rm = TRUE),
    Ignorado_PARTO = sum(Ignorado_PARTO, na.rm = TRUE),
    esc_mae_4a7 = sum(esc_mae_4a7, na.rm = TRUE),
    esc_mae_8a11 = sum(esc_mae_8a11, na.rm = TRUE),
    esc_mae_12oumais = sum(esc_mae_12oumais, na.rm = TRUE),
    esc_mae_1a3 = sum(esc_mae_1a3, na.rm = TRUE),
    esc_mae_nenhuma = sum(esc_mae_nenhuma, na.rm = TRUE),
    esc_mae_ignorado = sum(esc_mae_ignorado, na.rm = TRUE)
    , .groups = "drop") %>%
  arrange(MICROCOD, ano)

ninf_grouped_clean <- ninf_grouped_year %>%
  filter(!is.na(LATITUDE) & !is.na(LONGITUDE))

ninf_grouped_sf <- st_as_sf(ninf_grouped_clean,
                            coords = c("LONGITUDE", "LATITUDE"),
                            crs = 4326)

ninf_cropped <- st_intersection(ninf_grouped_sf, brasil)

ninf_cropped_coords <- ninf_cropped %>%
  mutate(LONGITUDE = st_coordinates(.)[, 1], LATITUDE = st_coordinates(.)[, 2]) %>%
  st_drop_geometry()

## Gráficos de Hexágonos

gerar_grafico_hex_natalidade <- function(df,
                                         ano,
                                         brasil,
                                         palette,
                                         title = NULL,
                                         subtitle = NULL,
                                         xlim = c(-75, -30),
                                         ylim = c(-35, 5)) {
  ggplot(df %>% filter(ano == ano)) +
    geom_sf(data = brasil,
            fill = "white",
            color = "black") +
    geom_hex(aes(x = LONGITUDE, y = LATITUDE), bins = 60) +
    palette +
    labs(title = title %||% as.character(ano),
         subtitle = subtitle) +
    coord_sf(xlim = xlim,
             ylim = ylim,
             expand = FALSE) +
    theme_void() +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5))
}

palette_natalidade <- scale_fill_gradient(low = "lightblue",
                                          high = "blue4",
                                          name = "Natalidade")

anos <- 2014:2019 

hex_graficos_natalidade <- map(
  anos,
  ~ gerar_grafico_hex_natalidade(
    ninf_cropped_coords,
    .x,
    brasil,
    palette_natalidade,
    title = paste("Natalidade em", .x),
    subtitle = "Análise por MicroRegião"
  )
)

hex_graficos_natalidade <- map(hex_graficos_natalidade, ~ .x + theme(legend.position = "none"))

combined_hex_natalidade <- wrap_plots(hex_graficos_natalidade, nrow = 2) +
  plot_annotation(
    title = "Natalidade nas MicroRegiões da Saúde (2014-2019)",
    subtitle = "Análise Geográfica das Ocorrências de Natalidade",
    theme = theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5, size = 12)
    )
  )

combined_hex_natalidade

## Gráficos de Violino

gerar_grafico_violino_natalidade <- function(df,
                                             title = "Distribuição de Natalidade por Ano",
                                             subtitle = NULL,
                                             xlab = "Ano",
                                             ylab = "Ocorrências (Escala Logarítmica)",
                                             fill_colors = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b")) {
  ggplot(df, aes(
    x = as.factor(ano),
    y = total_observacoes,
    fill = as.factor(ano)
  )) +
    geom_violin(trim = TRUE,
                color = "black",
                alpha = 0.2) +
    geom_boxplot(
      width = 0.1,
      fill = "white",
      color = "black",
      outlier.shape = NA,
      alpha = 0.5
    ) +
    stat_summary(
      fun = "mean",
      geom = "point",
      color = "red",
      size = 4,
      shape = 23,
      fill = "red"
    ) +
    scale_y_log10(breaks = c(1, 10, 100, 1000),
                  labels = c("1", "10", "100", "1000")) +
    labs(
      title = title,
      subtitle = subtitle,
      x = xlab,
      y = ylab,
      caption = "Fonte: DataSUS"
    ) +
    scale_fill_manual(values = fill_colors) +
    theme_classic(base_size = 15) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "none",
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.ticks = element_blank()
    )
}

grafico_violino_natalidade <- gerar_grafico_violino_natalidade(
  ninf_grouped_year,
  title = "Distribuição de Natalidade por Ano",
  subtitle = "Análise Geográfica das Ocorrências",
  xlab = "Ano",
  ylab = "Ocorrências (Escala Logarítmica)",
  fill_colors = c("#2c7bb6", "#abd9e9", "#fdae61", "#d7191c", "#f46d43", "#1f78b4")
)

grafico_violino_natalidade

## Gráfico de Linha

gerar_grafico_linha_natalidade <- function(df,
                                           title = "Total de Ocorrências de Natalidade por Ano",
                                           subtitle = NULL,
                                           xlab = "Ano",
                                           ylab = "Total de Ocorrências",
                                           line_color = "#1f77b4",
                                           point_color = "#ff7f0e",
                                           background_color = "#f9f9f9") {
  ggplot(df, aes(
    x = as.factor(ano),
    y = total_observacoes,
    group = 1
  )) +
    stat_summary(
      fun = sum,
      geom = "line",
      color = line_color,
      size = 1.2
    ) +
    stat_summary(
      fun = sum,
      geom = "point",
      color = point_color,
      size = 4,
      shape = 21,
      fill = "white",
      stroke = 1.5
    ) +
    labs(
      title = title,
      subtitle = subtitle,
      x = xlab,
      y = ylab,
      caption = "Fonte: DataSUS"
    ) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(
        hjust = 0.5,
        face = "bold",
        size = 16
      ),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = background_color, color = NA),
      plot.background = element_rect(fill = background_color, color = NA),
      axis.line = element_line(color = "gray50", size = 0.5),
      axis.ticks = element_line(color = "gray50")
    )
}

grafico_linha_natalidade <- gerar_grafico_linha_natalidade(
  ninf_grouped_year,  
  title = "Natalidade por Ano",
  subtitle = "Total de Ocorrências Registradas de 2014 a 2019",
  xlab = "Ano",
  ylab = "Total de Ocorrências",
  line_color = "#2c7bb6",
  point_color = "#d7191c",
  background_color = "#f9f9f9"
)

grafico_linha_natalidade

# Dados Relativos entre Mortalidade e Natalidade ----

combined_df <- minf_grouped_month %>%
  inner_join(ninf_grouped_month, by = c("MICROCOD", "ano", "mes"), suffix = c("_minf", "_ninf"))

combined_df <- combined_df %>%
  mutate(razao_mortalidade_natalidade = total_observacoes_minf / total_observacoes_ninf)

combined_df <- combined_df %>%
  filter(total_observacoes_ninf > 0)

## Gráficos Hexágono 

gerar_grafico_hex_razao <- function(df,
                                    ano,
                                    brasil,
                                    palette,
                                    title = NULL,
                                    subtitle = NULL,
                                    xlim = c(-75, -30),
                                    ylim = c(-35, 5)) {
  ggplot(df %>% filter(ano == ano)) +
    geom_sf(data = brasil,
            fill = "white",
            color = "black") +
    geom_hex(aes(x = LONGITUDE_minf, y = LATITUDE_minf, z = razao_mortalidade_natalidade), bins = 60) +
    palette +
    labs(title = title %||% as.character(ano),
         subtitle = subtitle) +
    coord_sf(xlim = xlim,
             ylim = ylim,
             expand = FALSE) +
    theme_void() +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5))
}

palette_razao <- scale_fill_gradient(low = "yellow", high = "red", name = "Razão M/N")

anos <- 2014:2019 

hex_graficos_razao <- map(
  anos,
  ~ gerar_grafico_hex_razao(
    combined_df,
    .x,
    brasil,
    palette_razao,
    title = paste("Razão Mortalidade/Natalidade em", .x),
    subtitle = "Análise por MicroRegião"
  )
)

hex_graficos_razao <- map(hex_graficos_razao, ~ .x + theme(legend.position = "none"))

combined_hex_razao <- wrap_plots(hex_graficos_razao, nrow = 2) +
  plot_annotation(
    title = "Razão entre Mortalidade Infantil e Natalidade nas MicroRegiões da Saúde (2014-2019)",
    subtitle = "Análise Geográfica da Razão entre Mortalidade e Natalidade",
    theme = theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5, size = 12)
    )
  )

combined_hex_razao

## Gráficos de Violino

gerar_grafico_violino_razao <- function(df,
                                        title = "Distribuição da Razão Mortalidade/Natalidade por Ano",
                                        subtitle = NULL,
                                        xlab = "Ano",
                                        ylab = "Razão Mortalidade/Natalidade",
                                        fill_colors = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b")) {
  
  ggplot(df, aes(
    x = as.factor(ano),
    y = razao_mortalidade_natalidade,
    fill = as.factor(ano)
  )) +
    geom_violin(trim = TRUE, color = "black", alpha = 0.2) +
    geom_boxplot(width = 0.1, fill = "white", color = "black", outlier.shape = NA, alpha = 0.5) +
    stat_summary(fun = "mean", geom = "point", color = "red", size = 4, shape = 23, fill = "red") +
    scale_y_continuous(limits = c(0, 0.05)) +  
    labs(
      title = title,
      subtitle = subtitle,
      x = xlab,
      y = ylab,
      caption = "Fonte: DataSUS"
    ) +
    scale_fill_manual(values = fill_colors) +
    theme_classic(base_size = 15) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "none",
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.ticks = element_blank()
    )
}

grafico_violino_razao <- gerar_grafico_violino_razao(
  combined_df,
  title = "Distribuição da Razão Mortalidade/Natalidade por Ano",
  subtitle = "Análise Geográfica da Razão entre Mortalidade e Natalidade",
  xlab = "Ano",
  ylab = "Razão Mortalidade/Natalidade",
  fill_colors = c("#2c7bb6", "#abd9e9", "#fdae61", "#d7191c", "#f46d43", "#1f78b4")
)

grafico_violino_razao



## Gráfico de Linha

gerar_grafico_linha_razao_anual <- function(df,
                                            title = "Razão Mortalidade/Natalidade por Ano",
                                            subtitle = "Média da Razão Anual",
                                            xlab = "Ano",
                                            ylab = "Razão Mortalidade/Natalidade",
                                            line_color = "#1f77b4",
                                            point_color = "#ff7f0e",
                                            background_color = "#f9f9f9") {
  
  df <- df %>%
    group_by(ano) %>%
    summarize(razao_media_anual = mean(razao_mortalidade_natalidade, na.rm = TRUE))
  ggplot(df, aes(x = as.factor(ano), y = razao_media_anual, group = 1)) +
    geom_line(color = line_color, size = 1.2) +
    geom_point(size = 4, color = point_color, shape = 21, fill = "white", stroke = 1.5) +
    labs(
      title = title,
      subtitle = subtitle,
      x = xlab,
      y = ylab,
      caption = "Fonte: DataSUS"
    ) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = background_color, color = NA),
      plot.background = element_rect(fill = background_color, color = NA),
      axis.line = element_line(color = "gray50", size = 0.5),
      axis.ticks = element_line(color = "gray50")
    )
}

grafico_linha_razao_anual <- gerar_grafico_linha_razao_anual(
  combined_df,
  title = "Razão Mortalidade/Natalidade por Ano",
  subtitle = "Média da Razão Anual",
  xlab = "Ano",
  ylab = "Razão Mortalidade/Natalidade"
)

grafico_linha_razao_anual
