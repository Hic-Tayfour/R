# 📚 Importando as Bibliotecas Necessárias ----

library(tidyverse) # Tratamento, Manipulação e Visualização de Dados
library(tidyquant) # Dados Financeiros
library(gridExtra) # Gráficos
library(patchwork) # Gráficos 
library(ggthemes)  # Gráficos
library(seasonal)  # Ajuste sazonal para séries temporais
library(mFilter)   # Filtro HP 
library(readxl)    # Leitura de arquivos excel
library(sidrar)    # Baixar dados do IBGE    
library(gt)        # Tabelas Formatadas


# 📃 Importando as Bases de Dados ----

## BR Dados do Brasil ----
"
Aqui teremos dados Macroeconômicos sobre o Brasil , como por exemplo :
1- PIB Real Trimetsral , Sazonalmente Ajustado
2- PIB Real Anual
3- PIB Potêncial (Filtro HP)
4- Hiato do Produto
5- Inflação Mensal
5- Inflação Anual 
6- Taxa de Juros Nominal
7- Taxa de Juros Real 
"
### PIB Real Trimestral, Sazonalmente Ajustado

pibt_br <- tq_get("NGDPRSAXDCBRQ", get = "economic.data", from = "1900-01-01") %>%
  select(-symbol) %>%
  mutate(data = as.Date(date), pibt = price) %>%
  select(data, pibt)

### PIB Real Anual

piba_br <- tq_get("NGDPRXDCBRA", get = "economic.data", from = "1900-01-01") %>%
  select(-symbol) %>%
  mutate(data = as.Date(date), piba = price) %>%
  select(data, piba)

### PIB Potencial (Filtro HP)

hp_filtert <- hpfilter(pibt_br$pibt, freq = 1600)  
hp_filtera <- hpfilter(piba_br$piba, freq = 100)  

### Hiato do Produto - Trimestral

pibt_br <- pibt_br %>%
  mutate(
    PIB_potencial = as.numeric(hp_filtert$trend),
    hiato_produto = ((pibt - PIB_potencial) / PIB_potencial) * 100
  )

### Hiato do Produto - Anual

piba_br <- piba_br %>%
  mutate(
    PIB_potencial = as.numeric(hp_filtera$trend),
    hiato_produto = ((piba - PIB_potencial) / PIB_potencial) * 100
  )

### Inflação Mensal

infm_br <- get_sidra(api = "/t/1737/n1/all/v/63/p/all/d/v63%202") %>% 
  select(Mês, Valor) %>%
  rename(data = Mês, inflacaom = Valor) %>%
  mutate(data = dmy(paste0("01 ", data)))

### Inflação Anual

infa_br <- tq_get("FPCPITOTLZGBRA", get = "economic.data", from = "1900-01-01") %>%
  select(-symbol) %>%
  mutate(data = as.Date(date), inflacaoa = price) %>%
  select(data, inflacaoa)

### Índice do IPCA

ipca <- get_sidra(api = "/t/1737/n1/all/v/2265/p/all/d/v2265%202") %>%
  select(data = `Mês (Código)`, ipca_indice = `Valor`) %>%
  mutate(data = ymd(paste0(data, "-01"))) %>%
  filter(year(data) >= 1999)

### Metas de Inflação Brasil

meta_inflacao <- tibble(
  data_inicio = as.Date(c("1999-01-01", "2000-01-01", "2001-01-01", "2002-01-01",
                          "2003-01-01", "2004-01-01", "2005-01-01", "2006-01-01",
                          "2007-01-01", "2008-01-01", "2009-01-01", "2010-01-01",
                          "2011-01-01", "2012-01-01", "2013-01-01", "2014-01-01",
                          "2015-01-01", "2016-01-01", "2017-01-01", "2018-01-01",
                          "2019-01-01", "2020-01-01", "2021-01-01", "2022-01-01",
                          "2023-01-01", "2024-01-01", "2025-01-01")),
  meta = c(8, 6, 4, 3.5, 4, 5.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 
           4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.25, 4.0, 3.75, 
           3.5, 3.25, 3, 3),
  intervalo = c(2, 2, 2, 2, 2.5, 2.5, 2.5, 2, 2, 2, 2, 2, 2, 2, 
                2, 2, 2, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5)
) %>%
  mutate(
    limite_sup = meta + intervalo,
    limite_inf = meta - intervalo,
    meta_star = ifelse(data_inicio == as.Date("2003-01-01"), 3.25,
                       ifelse(data_inicio == as.Date("2004-01-01"), 3.75, NA_real_)),
    intervalo_star = ifelse(data_inicio == as.Date("2003-01-01"), 2,
                            ifelse(data_inicio == as.Date("2004-01-01"), 2.5, NA_real_)),
    limite_sup_star = ifelse(!is.na(meta_star), meta_star + intervalo_star, NA_real_),
    limite_inf_star = ifelse(!is.na(meta_star), meta_star - intervalo_star, NA_real_)
  )


### Unindo IPCA com Metas de Inflação

ipca <- ipca %>%
  mutate(ano = year(data)) %>%
  left_join(meta_inflacao %>%
              mutate(ano = year(data_inicio)), by = "ano") %>%
  select(data, ipca_indice, meta, limite_sup, limite_inf, 
         meta_star, limite_sup_star, limite_inf_star)

### Taxa de Juros Nominal (Selic)

selicm <- tq_get("IRSTCI01BRM156N", get = "economic.data", from = "1900-01-01") %>%
  select(-symbol) %>%
  mutate(data = as.Date(date), selicm = price) %>%
  select(data, selicm)

### Taxa de Juros Real

juros_reais_br <- selicm %>%
  left_join(infm_br, by = "data") %>%
  mutate(
    juros_real = (((1 + selicm / 100) / (1 + inflacaom / 100)) - 1 ) * 100
  )

## CHI Dados do Chile ----
"
Aqui teremos dados Macroeconômicos sobre o Chile , como por exemplo :
1- PIB Real Trimetsral , Sazonalmente Ajustado
2- PIB Real Anual
3- PIB Potêncial (Filtro HP)
4- Hiato do Produto
5- Inflação Mensal
5- Inflação Anual 
6- Taxa de Juros Nominal
7- Taxa de Juros Real 
"

## ARG Dados da Peru ----
"
Aqui teremos dados Macroeconômicos sobre o Peru , como por exemplo :
1- PIB Real Trimetsral , Sazonalmente Ajustado
2- PIB Real Anual
3- PIB Potêncial (Filtro HP)
4- Hiato do Produto
5- Inflação Mensal
5- Inflação Anual 
6- Taxa de Juros Nominal
7- Taxa de Juros Real 
"

## MEX Dados do México ----
"
Aqui teremos dados Macroeconômicos sobre o México , como por exemplo :
1- PIB Real Trimetsral , Sazonalmente Ajustado
2- PIB Real Anual
3- PIB Potêncial (Filtro HP)
4- Hiato do Produto
5- Inflação Mensal
5- Inflação Anual 
6- Taxa de Juros Nominal
7- Taxa de Juros Real 
"

## CO Dados da Colômbia ----
"
Aqui teremos dados Macroeconômicos sobre a Colômbia , como por exemplo :
1- PIB Real Trimetsral , Sazonalmente Ajustado
2- PIB Real Anual
3- PIB Potêncial (Filtro HP)
4- Hiato do Produto
5- Inflação Mensal
5- Inflação Anual 
6- Taxa de Juros Nominal
7- Taxa de Juros Real 
"

# 📈 Gráficos ----

## Brasil 
(((
  ggplot(pibt_br, aes(x = data)) +
    geom_line(aes(y = pibt, color = "PIB Real"), linewidth = 1.2) +
    geom_line(aes(y = PIB_potencial, color = "PIB Potencial"), linewidth = 1.2) +
    labs(
      title = "Evolução do PIB Real, PIB Potencial e Hiato do Produto",
      subtitle = "Brasil - Série Temporal Trimestral (1996 - 2024)",
      y = "PIB (milhões R$)",
      x = NULL
    ) +
    scale_color_manual(
      name = "Legenda",
      values = c(
        "PIB Real" = "#1F4E79",
        "PIB Potencial" = "#81B1D6"
      )
    ) +
    scale_x_date(
      limits = c(min(pibt_br$data, na.rm = TRUE), max(pibt_br$data, na.rm = TRUE)),
      date_labels = "%Y",
      date_breaks = "2 years"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      legend.position = "top",
      legend.title = element_blank(),
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line.x = element_blank(),
      axis.line.y = element_line(color = "#b0a392")
    )
  
)
) / (
  ggplot(pibt_br, aes(x = data, y = hiato_produto)) +
    geom_line(color = "#2A9D8F", size = 1.2) +
    labs(y = "Hiato (%)", x = "Ano") +
    scale_y_continuous(limits = c(-max(abs(
      range(pibt_br$hiato_produto, na.rm = TRUE)
    )), max(abs(
      range(pibt_br$hiato_produto, na.rm = TRUE)
    )))) +
    scale_x_date(
      limits = c(min(pibt_br$data, na.rm = TRUE), max(pibt_br$data, na.rm = TRUE)),
      date_labels = "%Y",
      date_breaks = "2 years"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      axis.text.x = element_text(
        size = 12,
        angle = 0,
        hjust = 0.5
      ),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line = element_line(color = "#b0a392")
    )
)
+
  plot_annotation(
    caption = "Fonte: IBGE | Gráfico Próprio",
    theme = theme(plot.caption = element_text(
      size = 12,
      hjust = 0,
      margin = margin(t = 10)
    ))
  )
)

# Evolução do PIB Real, PIB Potencial e Hiato do Produto Anual

((
  ggplot(piba_br, aes(x = data)) +
    geom_line(aes(y = piba, color = "PIB Real"), linewidth = 1.2) +
    geom_line(aes(y = PIB_potencial, color = "PIB Potencial"), linewidth = 1.2) +
    labs(
      title = "Evolução do PIB Real, PIB Potencial e Hiato do Produto",
      subtitle = "Brasil - Série Temporal Anual (1996 - 2024)",
      y = "PIB (milhões R$)",
      x = NULL
    ) +
    scale_color_manual(
      name = "Legenda",
      values = c(
        "PIB Real" = "#1F4E79",
        "PIB Potencial" = "#81B1D6"
      )
    ) +
    scale_x_date(
      limits = c(min(piba_br$data, na.rm = TRUE), max(piba_br$data, na.rm = TRUE)),
      date_labels = "%Y",
      date_breaks = "2 years"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      legend.position = "top",
      legend.title = element_blank(),
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line.x = element_blank(),
      axis.line.y = element_line(color = "#b0a392")
    )
  
) / (
  ggplot(piba_br, aes(x = data, y = hiato_produto)) +
    geom_line(color = "#2A9D8F", size = 1.2) +
    labs(y = "Hiato (%)", x = "Ano") +
    scale_y_continuous(limits = c(-max(abs(
      range(piba_br$hiato_produto, na.rm = TRUE)
    )), max(abs(
      range(piba_br$hiato_produto, na.rm = TRUE)
    )))) +
    scale_x_date(
      limits = c(min(piba_br$data, na.rm = TRUE), max(piba_br$data, na.rm = TRUE)),
      date_labels = "%Y",
      date_breaks = "2 years"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      axis.text.x = element_text(
        size = 12,
        angle = 0,
        hjust = 0.5
      ),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line = element_line(color = "#b0a392")
    )
)
) +
  plot_annotation(
    caption = "Fonte: IBGE | Gráfico Próprio",
    theme = theme(
      plot.caption = element_text(size = 12, hjust = 0, margin = margin(t = 10))
    )
  )

# Taxa Selic, Juros Reais e Inflação Mensal

((
  ggplot(juros_reais_br, aes(x = data)) +
    geom_line(aes(y = selicm, color = "Taxa Selic"), linewidth = 1.2) +
    geom_line(aes(y = juros_real, color = "Juros Reais"), linewidth = 1.2) +
    labs(
      title = "Evolução da Taxa Selic, Juros Reais e Inflação Mensal",
      subtitle = "Brasil - Série Temporal",
      y = "Percentual (%)",
      x = NULL
    ) +
    scale_color_manual(values = c(
      "Taxa Selic" = "#1F4E79",
      "Juros Reais" = "#2A9D8F"
    )) +
    scale_x_date(
      limits = c(
        min(juros_reais_br$data, na.rm = TRUE),
        max(juros_reais_br$data, na.rm = TRUE)
      ),
      date_labels = "%Y",
      date_breaks = "2 years"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      legend.position = "top",
      legend.title = element_blank(),
      legend.spacing.x = unit(0.5, "cm"),
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(
        size = 14,
        hjust = 0.5,
        margin = margin(b = 10)
      ),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line.x = element_blank(),
      axis.line.y = element_line(color = "#b0a392")
    )
  
) / (
  ggplot(juros_reais_br, aes(x = data, y = inflacaom)) +
    geom_line(color = "#81B1D6", size = 1.2) +
    labs(y = "Inflação (%)", x = "Ano") +
    scale_x_date(
      limits = c(
        min(juros_reais_br$data, na.rm = TRUE),
        max(juros_reais_br$data, na.rm = TRUE)
      ),
      date_labels = "%Y",
      date_breaks = "2 years"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_blank(),
      plot.subtitle = element_blank(),
      axis.text.x = element_text(
        size = 12,
        angle = 0,
        hjust = 0.5
      ),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line = element_line(color = "#b0a392")
    )
)
) +
  plot_annotation(
    caption = "Fonte: IBGE | Banco Central | Gráfico Próprio",
    theme = theme(
      plot.caption = element_text(size = 12, hjust = 0, margin = margin(t = 10))
    )
  )

# Inflação Anual vs Meta de Inflação no Brasil

ggplot(data = ipca, aes(x = data)) +
  geom_line(aes(y = ipca_indice, color = "Inflação"), linewidth = 1.5) +
  geom_line(aes(y = meta, color = "Meta"),
            linetype = "dashed",
            linewidth = 1.5) +
  geom_line(
    aes(y = limite_sup, color = "Intervalo de Tolerância"),
    linetype = "dotted",
    linewidth = 1
  ) +
  geom_line(
    aes(y = limite_inf, color = "Intervalo de Tolerância"),
    linetype = "dotted",
    linewidth = 1
  ) +
  
  geom_line(aes(y = meta_star, color = "Meta*"),
            linetype = "dashed",
            linewidth = 1.5) +
  geom_line(
    aes(y = limite_sup_star, color = "Intervalo de Tolerância*"),
    linetype = "dotted",
    linewidth = 1
  ) +
  geom_line(
    aes(y = limite_inf_star, color = "Intervalo de Tolerância*"),
    linetype = "dotted",
    linewidth = 1
  ) +
  
  scale_x_date(
    limits = c(min(ipca$data, na.rm = TRUE), max(ipca$data, na.rm = TRUE)),
    date_labels = "%Y",
    date_breaks = "1 year"
  ) +
  
  scale_color_manual(
    values = c(
      "Inflação" = "#1F4E79",
      "Meta" = "#81B1D6",
      "Intervalo de Tolerância" = "#2A9D8F",
      "Meta*" = "red",
      "Intervalo de Tolerância*" = "brown"
    )
  ) +
  
  labs(
    title = "Inflação Anual vs Meta de Inflação no Brasil",
    subtitle = "Valores anuais comparados à meta do Banco Central",
    color = "",
    x = "",
    y = "Inflação Anual (%)",
    caption = "Fonte: IBGE | Banco Central | Gráfico Próprio"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(
      face = "bold",
      size = 18,
      hjust = 0.5,
      margin = margin(b = 8)
    ),
    plot.subtitle = element_text(
      size = 14,
      hjust = 0.5,
      margin = margin(b = 15)
    ),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(
      size = 12,
      hjust = 0,
      margin = margin(t = 10)
    ),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    legend.position = "top",
    legend.direction = "horizontal",
    legend.text = element_text(size = 12),
    legend.margin = margin(t = -5),
    plot.margin = margin(
      t = 20,
      r = 10,
      b = 10,
      l = 10
    )
  )

# Inflação e Hiato Anual

dados_combinados <- inner_join(piba_br,
                               infa_br,
                               by = "data")

((
  ggplot(dados_combinados, aes(x = hiato_produto, y = inflacaoa)) +
    geom_point(
      color = "#1F4E79",
      size = 3,
      alpha = 0.8
    ) +
    geom_smooth(
      method = "lm",
      color = "black",
      se = FALSE,
      linetype = "dashed"
    ) +
    labs(title = "Relação entre Inflação e Hiato do Produto",
         subtitle = "",
         x = "Hiato do Produto (%)",
         y = "Inflação (%)") +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 8)),
      plot.subtitle = element_text(size = 14, hjust = 0.5, margin = margin(b = 15)),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line = element_line(color = "#b0a392")
    )
) / (
  ggplot(dados_combinados, aes(x = data)) +
    geom_line(aes(y = inflacaoa, color = "Série da Inflação"), size = 1.5) +
    geom_line(aes(y = hiato_produto, color = "Série do Hiato"), size = 1.5) +
    labs(x = "Ano", y = "Percentual (%)") +
    scale_color_manual(
      values = c(
        "Série da Inflação" = "#2A9D8F",
        "Série do Hiato" = "#81B1D6"
      )
    ) +
    scale_x_date(date_labels = "%Y", date_breaks = "5 years") +
    theme_minimal(base_size = 14) +
    theme(
      legend.position = "top",
      legend.title = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "#d3c7ba"),
      axis.line = element_line(color = "#b0a392")
    )
)
) +
  plot_annotation(
    caption = "Fonte: IBGE | Banco Central | Gráfico Próprio",
    theme = theme(plot.caption = element_text(size = 12, hjust = 0, margin = margin(t = 10)))
  )
