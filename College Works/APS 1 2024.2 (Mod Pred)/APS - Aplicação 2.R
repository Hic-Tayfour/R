# Importando as Bibliotecas Necessárias ----

library(rpart.plot) # Visualização de Árvores
library(tidyverse)  # Manipulação de dados
library(catboost)   # CatBoost
library(rsample)    # Divisão de dados
library(ranger)     # Random Forest
library(rpart)      # Árvore de Decisão
library(class)      # K-Nearest Neighbors
library(pROC)       # Curva ROC
library(tree)       # Árvore de Decisão
library(gt)         # Tabelas formatas

# Importando a Base de Dados e Ajustando ----

cars <- read_csv("used_cars.csv") 

cars <- cars %>%
  mutate(trim = as.factor(trim),
         isOneOwner = as.factor(isOneOwner),
         color = as.factor(color),
         fuel = as.factor(fuel),
         soundSystem = as.factor(soundSystem),
         wheelType = as.factor(wheelType))

# Dividindo os dados em treino e teste ----

set.seed(42)
split <- initial_split(cars, prop = 0.7)

tst <- testing(split)
trn <- training(split)

# Montando a Regressão Múltipla ---- 

lm_model <- lm(price ~ ., data = trn)

summary(lm_model)

## Fazendo previsões no conjunto de teste

y_hat_lm <- predict(lm_model, newdata = tst)

## Calculando o Erro Quadrático Médio no treino e teste

lm_eqm_trn <- mean((trn$price - predict(lm_model))^2)
lm_eqm_tst <- mean((tst$price - y_hat_lm)^2)
lm_rmse_tst <- sqrt(lm_eqm_tst)

## Exibindo os Resultados

print(paste("EQM de Treinamento:", lm_eqm_trn))
print(paste("EQM de Teste:", lm_eqm_tst))
print(paste("RMSE de Teste:", lm_rmse_tst))

# Árvore de Regressão ----

## Montando o Modelo de Árvore de Regressão

tree_model <- rpart(price ~ ., data = trn)

## Fazendo previsões no conjunto de treino (trn)

y_hat_tree_train <- predict(tree_model, newdata = trn)

## Fazendo previsões no conjunto de teste (tst)

y_hat_tree_test <- predict(tree_model, newdata = tst)

## Calculando o EQM para o conjunto de treino (trn)

tree_eqm_trn <- mean((trn$price - y_hat_tree_train)^2)

## Calculando o EQM para o conjunto de teste (tst)

tree_eqm_tst <- mean((tst$price - y_hat_tree_test)^2)

## Calculando o RMSE para o conjunto de teste (tst)

tree_rmse_tst <- sqrt(tree_eqm_tst)

## Exibindo os resultados

print(paste("EQM de Treinamento (trn):", tree_eqm_trn))
print(paste("EQM de Teste (tst):", tree_eqm_tst))
print(paste("RMSE de Teste (tst):", tree_rmse_tst))

## Visualizando a Árvore de Regressão

rpart.plot(tree_model, cex = 0.6, extra = 101)

# Random Forest ----

rf_model <- ranger(price ~ ., data = trn, probability = FALSE)  

## Fazendo previsões no conjunto de treino (trn)

y_hat_rf_trn <- predict(rf_model, data = trn)$predictions

## Fazendo previsões no conjunto de teste (tst)

y_hat_rf_tst <- predict(rf_model, data = tst)$predictions

## Calculando o EQM para o conjunto de treino (trn)

rf_eqm_trn <- mean((trn$price - y_hat_rf_trn)^2)

## Calculando o EQM para o conjunto de teste (tst)

rf_eqm_tst <- mean((tst$price - y_hat_rf_tst)^2)

## Calculando o RMSE para o conjunto de teste (tst)

rf_rmse_tst <- sqrt(rf_eqm_tst)

## Exibindo os resultados

print(paste("EQM de Treinamento (trn):", rf_eqm_trn))
print(paste("EQM de Teste (tst):", rf_eqm_tst))
print(paste("RMSE de Teste (tst):", rf_rmse_tst))

# CatBoost ----

## Preparando os Dados para o CatBoost

train_pool <- catboost.load_pool(data = trn %>% 
                                   select(-price), label = trn$price)
test_pool <- catboost.load_pool(data = tst %>% 
                                  select(-price), label = tst$price)

## Montando o Modelo de CatBoost
catboost_model <- catboost.train(train_pool, 
                                 params = list(loss_function = 'RMSE',   
                                               iterations = 500,             
                                               depth = 6,                    
                                               logging_level = 'Silent'))    

## Fazendo previsões no conjunto de treino (trn)

y_hat_cb_trn <- catboost.predict(catboost_model, train_pool)

## Fazendo previsões no conjunto de teste (tst)

y_hat_cb_tst <- catboost.predict(catboost_model, test_pool)

## Calculando o EQM para o conjunto de treino (trn)

ct_eqm_trn <- mean((trn$price - y_hat_cb_trn)^2)

## Calculando o EQM para o conjunto de teste (tst)

ct_eqm_tst <- mean((tst$price - y_hat_cb_tst)^2)

## Calculando o RMSE para o conjunto de teste (tst)

ct_rmse_tst <- sqrt(ct_eqm_tst)

## Exibindo os resultados

print(paste("EQM de Treinamento (trn):", ct_eqm_trn))
print(paste("EQM de Teste (tst):", ct_eqm_tst))
print(paste("RMSE de Teste (tst):", ct_rmse_tst))

# Comparando os Modelos ----

criar_tabela_eqm_rmse <- function(titulo, subtitulo, fonte, nomes_colunas, valores_linhas) {
  
  dados <- data.frame(
    Modelos = c("Regressão Linear", "Árvore de Regressão", "Random Forest", "CatBoost"),
    EQM_Treino = valores_linhas[1, ],
    EQM_Teste = valores_linhas[2, ],
    RMSE_Teste = valores_linhas[3, ]
  )
  
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
      locations = cells_body(columns = "Modelos")
    )
  
  return(tabela)
}

titulo <- "Comparação dos Modelos"
subtitulo <- "EQM e RMSE de Treino e Teste para Vários Modelos"
fonte <- "Fonte: Análise de Previsão de Preços de Veículos Usados"

valores_linhas <- rbind(
  c(lm_eqm_trn, tree_eqm_trn, rf_eqm_trn, ct_eqm_trn),   
  c(lm_eqm_tst, tree_eqm_tst, rf_eqm_tst, ct_eqm_tst),    
  c(lm_rmse_tst, tree_rmse_tst, rf_rmse_tst, ct_rmse_tst) 
)

nomes_colunas <- c("EQM Treino", "EQM Teste", "RMSE Teste")

tabela_resultados <- criar_tabela_eqm_rmse(
  titulo = titulo,
  subtitulo = subtitulo,
  fonte = fonte,
  nomes_colunas = nomes_colunas,
  valores_linhas = valores_linhas
)

tabela_resultados



