# Importando as bibliotecas necessárias ----
library(tidyverse)      # manipulação de dados
library(dplyr)          # manipulação de dados
library(stargazer)      # tabelas de regressão
library(gt)             # tabelas personalizadas
library(survey)         # regressão logística
library(sandwich)       # erros padrão robustos
library(lmtest)         # testes de hipótese
library(ggplot2)        # gráficos
library(ggthemes)       # temas para gráficos
library(margins)        # efeitos marginais
library(readxl)         # leitura de arquivos excel
library(haven)          # leitura de arquivos .dta

# Importando e verificando a estrutura dos dados ----
star_data <- read_dta("Star.dta")
str(star_data)
colnames(star_data)

# Estatísticas descritivas para cada tipo de turma ----

# Turmas pequenas (small)
estatisticas_small <- star_data %>%
  filter(small == 1) %>%
  summarise(
    media_readscore = mean(readscore, na.rm = TRUE),
    minimo_readscore = min(readscore, na.rm = TRUE),
    maximo_readscore = max(readscore, na.rm = TRUE),
    desvio_padrao_readscore = sd(readscore, na.rm = TRUE),
    proporcao_tchmasters = mean(tchmasters, na.rm = TRUE) * 100
  )

# Turmas regulares (regular)
estatisticas_regular <- star_data %>%
  filter(regular == 1) %>%
  summarise(
    media_readscore = mean(readscore, na.rm = TRUE),
    minimo_readscore = min(readscore, na.rm = TRUE),
    maximo_readscore = max(readscore, na.rm = TRUE),
    desvio_padrao_readscore = sd(readscore, na.rm = TRUE),
    proporcao_tchmasters = mean(tchmasters, na.rm = TRUE) * 100
  )

# Turmas com assistente (aide)
estatisticas_aide <- star_data %>%
  filter(aide == 1) %>%
  summarise(
    media_readscore = mean(readscore, na.rm = TRUE),
    minimo_readscore = min(readscore, na.rm = TRUE),
    maximo_readscore = max(readscore, na.rm = TRUE),
    desvio_padrao_readscore = sd(readscore, na.rm = TRUE),
    proporcao_tchmasters = mean(tchmasters, na.rm = TRUE) * 100
  )

# Função para criar tabela formatada ----
criar_tabela_formatada <- function(titulo, subtitulo, fonte, nomes_colunas, nomes_linhas, valores_linhas) {
  dados <- data.frame(
    nome = nomes_linhas,
    matrix(valores_linhas, ncol = length(nomes_colunas), byrow = TRUE)
  )
  
  colnames(dados) <- c("nome", nomes_colunas)
  
  tabela <- gt(data = dados) %>%
    tab_header(
      title = titulo,
      subtitle = subtitulo
    ) %>%
    tab_source_note(
      source_note = fonte
    ) %>%
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels(everything())
    ) %>%
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_body(columns = "nome")
    )
  
  return(tabela)
}

# Criando a tabela formatada com as estatísticas descritivas ----
tabela_formatada_real <- criar_tabela_formatada(
  titulo = "Estatísticas Descritivas por Tipo de Turma",
  subtitulo = "Média, Mínimo, Máximo e Desvio Padrão do Score de Português",
  fonte = "Fonte: Projeto STAR",
  nomes_colunas = c("Média Score", "Mínimo Score", "Máximo Score", "Desvio Padrão", "Proporção Professores com Mestrado (%)"),
  nomes_linhas = c("Small", "Regular", "Aide"),
  valores_linhas = c(
    estatisticas_small$media_readscore, estatisticas_small$minimo_readscore, estatisticas_small$maximo_readscore, estatisticas_small$desvio_padrao_readscore, estatisticas_small$proporcao_tchmasters,
    estatisticas_regular$media_readscore, estatisticas_regular$minimo_readscore, estatisticas_regular$maximo_readscore, estatisticas_regular$desvio_padrao_readscore, estatisticas_regular$proporcao_tchmasters,
    estatisticas_aide$media_readscore, estatisticas_aide$minimo_readscore, estatisticas_aide$maximo_readscore, estatisticas_aide$desvio_padrao_readscore, estatisticas_aide$proporcao_tchmasters
  )
)

# Exibindo a tabela formatada ----
tabela_formatada_real

# Gráficos de densidade e boxplot ----

# Ajustando a base de dados ----
df_star <- star_data %>%
  mutate(
    turma = case_when(
      small == 1 ~ "Small",
      regular == 1 ~ "Regular",
      aide == 1 ~ "Aide"
    ),
    turma = factor(turma, levels = c("Small", "Regular", "Aide"))
  )

# Definindo cor de fundo personalizada ----
custom_bg_color <- "#ffffff"

# Gráfico de densidade ----
ggplot(df_star, aes(x = readscore, fill = turma, color = turma)) +
  geom_density(alpha = 0.05) +
  labs(
    title = "Densidade Suavizada do Score de Português",
    subtitle = "Distribuição por Turmas Small, Regular e Aide",
    x = "Score de Português",
    y = "Densidade",
    fill = "Turma",
    color = "Turma",
    caption = "Fonte: Projeto STAR"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10)
  )

# Boxplot do Score de Português por tipo de turma ----
ggplot(df_star, aes(x = turma, y = readscore, fill = turma)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "Boxplot do Score de Português por Tipo de Turma",
    subtitle = "Comparação entre Turmas Small, Regular e Aide",
    x = "Turma",
    y = "Score de Português",
    fill = "Turma",
    caption = "Fonte: Projeto STAR"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10)
  )

# Regressão múltipla ----
modelo_regressao <- lm(readscore ~ small + regular + tchmasters + small * tchmasters + regular * tchmasters, data = star_data)

# Exibindo os resultados da regressão ----
stargazer(modelo_regressao, type = "text", title = "Resultados da Regressão Múltipla", 
          covariate.labels = c("Turma Pequena (Small)", "Turma Regular (Regular)", 
                               "Professor com Mestrado (tchmasters)", 
                               "Interação: Small x Professor com Mestrado", 
                               "Interação: Regular x Professor com Mestrado"), 
          dep.var.labels = "Score em Português", align = TRUE)

# Incluindo dummies de escola no modelo ----
modelo_regressao_escola <- lm(readscore ~ small + regular + tchmasters + small * tchmasters + regular * tchmasters + factor(schid), data = star_data)

# Exibindo os resultados da regressão com dummies de escola ----
stargazer(modelo_regressao_escola, type = "text", title = "Resultados da Regressão com Efeitos Fixos de Escola", 
          covariate.labels = c("Turma Pequena (Small)", "Turma Regular (Regular)", 
                               "Professor com Mestrado (tchmasters)", 
                               "Interação: Small x Professor com Mestrado", 
                               "Interação: Regular x Professor com Mestrado", 
                               "Dummies de Escola"),
          dep.var.labels = "Score em Português", align = TRUE)

# Teste de significância conjunta dos efeitos fixos das escolas ----
anova(modelo_regressao_escola)

# Estimando o modelo de probabilidade linear (LPM) ----
modelo_lpm <- lm(small ~ boy + white_asian + black + freelunch + tchwhite, data = star_data)

# Exibindo os resultados da regressão LPM ----
stargazer(modelo_lpm, type = "text", title = "Modelo de Probabilidade Linear: Verificação da Aleatorização", 
          covariate.labels = c("Gênero (Menino)", "Raça (Branco/Asiático)", 
                               "Raça (Negro)", "Merenda Gratuita (Freelunch)", 
                               "Professor Branco (Tchwhite)"), 
          dep.var.labels = "Turma Pequena (Small)", align = TRUE)
