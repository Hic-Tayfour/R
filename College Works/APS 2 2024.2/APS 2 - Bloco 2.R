# Importando as bibliotecas necessárias ----
library(tidyverse)
library(dplyr)
library(stargazer)
library(gt)
library(survey)
library(sandwich)
library(lmtest)
library(ggplot2)
library(ggthemes)
library(margins)
library(readxl)

# Importando e verificando a estrutura dos dados ----
svy_wdl <- read_csv("wvs_world.csv")
str(svy_wdl)
colnames(svy_wdl)

# Ajustando para facilitar o trabalho ----
df_relevante <- svy_wdl %>%
  select(Q46,    
         Q32,    
         Q33,    
         Q29,    
         Q260,   
         Q262,   
         Q273,   
         W_WEIGHT) %>%  
  mutate(
    feeling_happy = factor(Q46, levels = c(1, 2, 3, 4), labels = c("Nada Feliz", "Não Muito Feliz", "Bastante Feliz", "Muito Feliz")),
    housewife_fulfilling = as.numeric(Q32),
    men_priority_jobs = as.numeric(Q33),
    men_better_leaders = as.numeric(Q29),
    gender = as.factor(Q260),
    age = as.numeric(Q262),
    marital_status = as.factor(Q273),
    happy_binary = ifelse(feeling_happy %in% c("Bastante Feliz", "Muito Feliz"), 1, 0)
  )

# Criando o objeto svydesign para amostragem complexa ----
survey_design <- svydesign(
  ids = ~1,  
  weights = ~W_WEIGHT,  
  data = df_relevante
)

# Estatísticas descritivas ajustadas pelo desenho amostral ----
estatisticas_descritivas <- svymean(~feeling_happy + housewife_fulfilling + men_priority_jobs + men_better_leaders, design = survey_design, na.rm = TRUE)

# Criando a tabela personalizada ----
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

tabela_formatada_real <- criar_tabela_formatada(
  titulo = "Estatísticas Descritivas Relevantes",
  subtitulo = "Análise de Bem-Estar Subjetivo e Normas de Gênero",
  fonte = "Fonte: World Values Survey",
  nomes_colunas = c("Felicidade (%)", "Concorda 'Dona de Casa (%)'", "Concorda 'Homens Prioridade Emprego (%)'", "Concorda 'Homens Melhores Líderes (%)'"),
  nomes_linhas = c("Média"),
  valores_linhas = c(estatisticas_descritivas[1], estatisticas_descritivas[2], estatisticas_descritivas[3], estatisticas_descritivas[4])
)

# Imprimindo a tabela ----
tabela_formatada_real

# Gráficos ----

# Definindo a cor de fundo personalizada
custom_bg_color <- "#ffffff"

# Gráfico de barras para 'Ser dona de casa é tão satisfatório quanto trabalhar'
ggplot(df_relevante, aes(x = housewife_fulfilling, fill = feeling_happy)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Distribuição das Respostas sobre o Papel de Dona de Casa",
    subtitle = "Comparação entre Felizes e Não Felizes",
    x = "Concordância com a frase 'Ser dona de casa é tão satisfatório quanto trabalhar'",
    y = "Frequência",
    fill = "Felicidade",
    caption = "Fonte: World Values Survey"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )

# Gráfico de barras para 'Homens devem ter prioridade de emprego'
ggplot(df_relevante, aes(x = men_priority_jobs, fill = feeling_happy)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Distribuição das Respostas sobre Prioridade de Emprego para Homens",
    subtitle = "Comparação entre Felizes e Não Felizes",
    x = "Concordância com a frase 'Homens devem ter prioridade de emprego'",
    y = "Frequência",
    fill = "Felicidade",
    caption = "Fonte: World Values Survey"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )

# Gráfico de barras para 'Homens são melhores líderes políticos'
ggplot(df_relevante, aes(x = men_better_leaders, fill = feeling_happy)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Distribuição das Respostas sobre Liderança Masculina",
    subtitle = "Comparação entre Felizes e Não Felizes",
    x = "Concordância com a frase 'Homens são melhores líderes políticos'",
    y = "Frequência",
    fill = "Felicidade",
    caption = "Fonte: World Values Survey"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#d3c7ba"),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )

# Histograma e gráfico de densidade para o sentimento de felicidade
ggplot(df_relevante, aes(x = as.numeric(feeling_happy))) +
  geom_histogram(aes(y = ..density..), binwidth = 1, fill = "lightgreen", color = "black", alpha = 0.6) +
  geom_density(color = "blue", fill = "lightblue", alpha = 0.4) +
  labs(
    title = "Histograma e Distribuição Alisada de Felicidade",
    subtitle = "Distribuição do Sentimento de Felicidade com Plot Alisado",
    x = "Sentimento de Felicidade (Escala)",
    y = "Densidade",
    caption = "Fonte: World Values Survey"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = custom_bg_color),
    plot.background = element_rect(fill = custom_bg_color),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.line = element_line(color = "#b0a392"),
    plot.caption = element_text(hjust = 0, size = 10),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  )


# Regressão Logit ajustada pelo desenho amostral ----
logit_model <- svyglm(happy_binary ~ housewife_fulfilling + men_priority_jobs + men_better_leaders + gender + age + marital_status, 
                      design = survey_design, 
                      family = quasibinomial(link = "logit"))

# Regressão Probit ajustada pelo desenho amostral ----
probit_model <- svyglm(happy_binary ~ housewife_fulfilling + men_priority_jobs + men_better_leaders + gender + age + marital_status, 
                       design = survey_design, 
                       family = quasibinomial(link = "probit"))

# Função para calcular efeitos marginais usando svycontrast ----
calcula_efeitos_marginais <- function(modelo) {
  # Coeficientes do modelo
  coeficientes <- coef(modelo)
  # Efeitos marginais aproximados para variáveis contínuas e categóricas
  marginais <- svycontrast(modelo, list("efeitos_marginais" = coeficientes))
  return(marginais)
}

# Calculando os efeitos marginais para os modelos Logit e Probit ----
marginais_logit <- calcula_efeitos_marginais(logit_model)
marginais_probit <- calcula_efeitos_marginais(probit_model)

# Exibindo os resultados das regressões usando stargazer ----
stargazer(logit_model, probit_model, 
          type = "text", 
          title = "Resultados das Regressões: Logit e Probit (Com Desenho Amostral)", 
          covariate.labels = c("Concorda 'Dona de Casa'", 
                               "Concorda 'Homens Prioridade Emprego'", 
                               "Concorda 'Homens Melhores Líderes'", 
                               "Gênero (Mulher)", 
                               "Idade", 
                               "Estado Civil (Casado)"), 
          dep.var.labels = "Probabilidade de Estar Feliz", 
          ci = TRUE,  # Intervalos de confiança
          align = TRUE, 
          no.space = TRUE, 
          omit.stat = c("f", "ser"))

# Exibindo os efeitos marginais ajustados pelo desenho amostral ----
print("Efeitos Marginais Logit:")
print(marginais_logit)

print("Efeitos Marginais Probit:")
print(marginais_probit)
