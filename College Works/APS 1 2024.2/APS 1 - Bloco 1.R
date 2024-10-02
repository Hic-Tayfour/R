# Configurando o ambiente de trabalho e importando as bibliotecas
library(haven)
library(plm) 
library(tidyverse)
library(dplyr)
library(gt)
library(pastecs)
library(fastDummies)
library(stargazer)
library(ggthemes)
library(sandwich)

# Importando as bases de dados e juntando 
base_1 <- read_dta("Base1_APS1.dta")
base_2 <- read_dta("Base2_APS1.dta")
base_3 <- read_dta("Base3_APS1.dta")

# Combinar a base1 com a base2
comb1 <- merge(base_1, base_2, by = c("state", "year"), all = TRUE)

# Combinar o resultado com a base3
df <- merge(comb1, base_3, by = c("state", "year"), all = TRUE)

# Verificando se o painel está balanceado
pdim(df)

# Função para criar tabela formatada
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

# Estatísticas descritivas
variaveis_selecionadas <- df %>%
  select(ln_property_rate, ln_incarc_rate, unemployment_rate, density)

media_real <- colMeans(variaveis_selecionadas, na.rm = TRUE)
minimo_real <- apply(variaveis_selecionadas, 2, min, na.rm = TRUE)
maximo_real <- apply(variaveis_selecionadas, 2, max, na.rm = TRUE)
desv_pad_real <- apply(variaveis_selecionadas, 2, sd, na.rm = TRUE)

titulo_real <- "Estatísticas Descritivas das Variáveis Reais"
subtitulo_real <- "Análise Descritiva de Variáveis de Crime"
fonte_real <- "Fonte: Base de Dados do Trabalho"
nomes_colunas_reais <- c("ln_property_rate", "ln_incarc_rate", "unemployment_rate", "density")
nomes_linhas_reais <- c("Média", "Mínimo", "Máximo", "Desvio Padrão")
valores_linhas_reais <- c(media_real, minimo_real, maximo_real, desv_pad_real)

tabela_formatada_real <- criar_tabela_formatada(
  titulo = titulo_real,
  subtitulo = subtitulo_real,
  fonte = fonte_real,
  nomes_colunas = nomes_colunas_reais,
  nomes_linhas = nomes_linhas_reais,
  valores_linhas = valores_linhas_reais
)

# Imprimir a tabela
tabela_formatada_real

# Média da taxa de crimes antes e depois das leis RTC
df %>%
  group_by(RTC) %>%
  summarise(media_crimes = mean(ln_property_rate, na.rm = TRUE),
            desvio_padrao = sd(ln_property_rate, na.rm = TRUE))

# Gráficos 
# Boxplot
ggplot(df, aes(x = factor(RTC), y = ln_property_rate)) +
  geom_boxplot(fill = c("#0072B2", "red"), color = "black", alpha = 0.7) +
  labs(x = "Leis RTC em Vigor (0 = Não, 1 = Sim)", 
       y = "Taxa de Crimes contra a Propriedade (Log)", 
       title = "Distribuição da Taxa de Crimes antes e depois das Leis RTC") +
  theme_fivethirtyeight() +
  theme(plot.title = element_text(face = "bold", size = 10),
        axis.title = element_text(size = 14))

# Gráfico de Dispersão
ggplot(df, aes(x = ln_incarc_rate, y = ln_property_rate)) +
  geom_point(color = "#009E73", alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", color = "#E69F00", se = FALSE, size = 1.5) +
  labs(x = "Taxa de Encarceramento (Log)", 
       y = "Taxa de Crimes contra a Propriedade (Log)", 
       title = "Relação entre Taxa de Encarceramento e Taxa de Crimes",
       subtitle = "Ajuste Linear sobre a Dispersão dos Dados",
       caption = "Fonte: Base de Dados do Trabalho") +
  theme_minimal(base_size = 10) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.caption = element_text(size = 10),
        axis.text = element_text(size = 12),
        axis.title = element_text(face = "bold"))

# Fazendo as regressões
pols_model <- plm(ln_property_rate ~ RTC + ln_incarc_rate + unemployment_rate + density, 
                  data = df, index = c("state", "year"), model = "pooling")

fixed_model <- plm(ln_property_rate ~ RTC + ln_incarc_rate + unemployment_rate + density, 
                   data = df, index = c("state", "year"), model = "within")

random_model <- plm(ln_property_rate ~ RTC + ln_incarc_rate + unemployment_rate + density, 
                    data = df, index = c("state", "year"), model = "random")

# Montando as Tabelas 
stargazer(pols_model, fixed_model, random_model, 
          type = "text", 
          title = "Resultados das Regressões: Pooled OLS, Efeitos Fixos e Efeitos Aleatórios",
          dep.var.labels = "Log da Taxa de Crimes contra a Propriedade",
          covariate.labels = c("Leis RTC", "Log da Taxa de Encarceramento", "Taxa de Desemprego", "Densidade Populacional"),
          align = TRUE, 
          no.space = TRUE,
          omit.stat = c("f", "ser"),
          add.lines = list(c("Modelo", "Pooled OLS", "Efeitos Fixos", "Efeitos Aleatórios")))

# Teste de Hausman para Efeitos Fixos ou Aleatórios
hausman_test <- phtest(fixed_model, random_model)
print(hausman_test)
