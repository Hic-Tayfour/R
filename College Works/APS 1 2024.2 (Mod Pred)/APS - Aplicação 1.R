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
churn <- read_csv("churn.csv")

## Trocando os valores da coluna Exited para 0 (não cancelou) e 1 (cancelou)
churn <- churn %>%
  mutate(Exited = if_else(Exited == "Yes", 1, 0)) %>% 
  mutate(Geography = as.factor(Geography),
         Gender = as.factor(Gender)) %>%
  drop_na(Exited)

# Dividindo os dados em treino e teste ----
set.seed(42)
split <- initial_split(churn, prop = 0.7)

tst <- testing(split)
trn <- training(split)

# Montando a Regressão Logística ----
logit_model <- glm(Exited ~ ., data = trn, family = binomial)

## Fazendo previsões no conjunto de teste
y_hat_logit <- predict(logit_model, newdata = tst, type = "response")

## Convertendo previsões para 0 e 1 com um threshold de 0.5
y_pred_logit <- ifelse(y_hat_logit > 0.5, 1, 0)

## Calculando a Curva ROC e AUC
roc_logit <- roc(tst$Exited, y_hat_logit)
auc_logit <- auc(roc_logit)

## Exibindo os Resultados
print(paste("AUC da Regressão Logística:", auc_logit))

# Montando o Modelo de Árvore de Classificação ----
tree_model <- rpart(Exited ~ ., data = trn, method = "class")

## Fazendo previsões no conjunto de teste
y_hat_tree <- predict(tree_model, newdata = tst, type = "prob")[,2]

## Convertendo previsões para 0 e 1 com um threshold de 0.5
y_pred_tree <- ifelse(y_hat_tree > 0.5, 1, 0)

## Calculando a Curva ROC e AUC
roc_tree <- roc(tst$Exited, y_hat_tree)
auc_tree <- auc(roc_tree)

## Exibindo os Resultados
print(paste("AUC da Árvore de Classificação:", auc_tree))

## Visualizando a árvore de classificação
rpart.plot(tree_model, cex = 0.6, extra = 106)

# Montando o Modelo de Random Forest ----
rf_model <- ranger(Exited ~ ., data = trn, probability = TRUE)

## Fazendo previsões no conjunto de teste
y_hat_rf <- predict(rf_model, data = tst)$predictions[, 2]

## Convertendo previsões para 0 e 1 com um threshold de 0.5
y_pred_rf <- ifelse(y_hat_rf > 0.5, 1, 0)

## Calculando a Curva ROC e AUC
roc_rf <- roc(tst$Exited, y_hat_rf)
auc_rf <- auc(roc_rf)

## Exibindo os Resultados
print(paste("AUC do Random Forest:", auc_rf))

# Montando o Modelo de CatBoost ----

## Preparando os Dados para o CatBoost
train_pool <- catboost.load_pool(data = trn %>% 
                                   select(-Exited), label = trn$Exited)
test_pool <- catboost.load_pool(data = tst %>% 
                                  select(-Exited), label = tst$Exited)

# Montando o Modelo de CatBoost
catboost_model <- catboost.train(train_pool, 
                                 params = list(loss_function = 'Logloss',   
                                               iterations = 500,             
                                               depth = 6,                    
                                               logging_level = 'Silent'))    

# Fazendo Previsões no Conjunto de Teste
y_hat_catboost <- catboost.predict(catboost_model, test_pool, prediction_type = "Probability")

# Convertendo Previsões para 0 e 1
# Usamos um threshold de 0.5 para classificar as probabilidades em 0 (não churn) ou 1 (churn)
y_pred_catboost <- ifelse(y_hat_catboost > 0.5, 1, 0)

# Calculando a Curva ROC e AUC
roc_catboost <- roc(tst$Exited, y_hat_catboost)
auc_catboost <- auc(roc_catboost)

# Exibindo os Resultados
print(paste("AUC do CatBoost:", auc_catboost))

# Encontrando o melhor ponto de corte para cada modelo ----

# Para a Regressão Logística
best_threshold_logit <- coords(roc_logit, "best", ret = "threshold")[[1]]
sensitivity_logit <- coords(roc_logit, "best", ret = "sensitivity")[[1]]
specificity_logit <- coords(roc_logit, "best", ret = "specificity")[[1]]
accuracy_logit <- coords(roc_logit, "best", ret = "accuracy")[[1]]

cat("Regressão Logística: Melhor Ponto de Corte:", best_threshold_logit, 
    "Sensibilidade:", sensitivity_logit, 
    "Especificidade:", specificity_logit, 
    "Acurácia:", accuracy_logit, "\n")

# Para a Árvore de Decisão
best_threshold_tree <- coords(roc_tree, "best", ret = "threshold")[[1]]
sensitivity_tree <- coords(roc_tree, "best", ret = "sensitivity")[[1]]
specificity_tree <- coords(roc_tree, "best", ret = "specificity")[[1]]
accuracy_tree <- coords(roc_tree, "best", ret = "accuracy")[[1]]

cat("Árvore de Decisão: Melhor Ponto de Corte:", best_threshold_tree, 
    "Sensibilidade:", sensitivity_tree, 
    "Especificidade:", specificity_tree, 
    "Acurácia:", accuracy_tree, "\n")

# Para o Random Forest
best_threshold_rf <- coords(roc_rf, "best", ret = "threshold")[[1]]
sensitivity_rf <- coords(roc_rf, "best", ret = "sensitivity")[[1]]
specificity_rf <- coords(roc_rf, "best", ret = "specificity")[[1]]
accuracy_rf <- coords(roc_rf, "best", ret = "accuracy")[[1]]

cat("Random Forest: Melhor Ponto de Corte:", best_threshold_rf, 
    "Sensibilidade:", sensitivity_rf, 
    "Especificidade:", specificity_rf, 
    "Acurácia:", accuracy_rf, "\n")

# Para o CatBoost
best_threshold_catboost <- coords(roc_catboost, "best", ret = "threshold")[[1]]
sensitivity_catboost <- coords(roc_catboost, "best", ret = "sensitivity")[[1]]
specificity_catboost <- coords(roc_catboost, "best", ret = "specificity")[[1]]
accuracy_catboost <- coords(roc_catboost, "best", ret = "accuracy")[[1]]

cat("CatBoost: Melhor Ponto de Corte:", best_threshold_catboost, 
    "Sensibilidade:", sensitivity_catboost, 
    "Especificidade:", specificity_catboost, 
    "Acurácia:", accuracy_catboost, "\n")


# Fazendo um Gráfico com todas as curvas ROC ----

create_roc_df_with_best <- function(roc_obj, model_name, best_threshold) {
  tibble(
    Sensitivity = roc_obj$sensitivities,
    Specificity = roc_obj$specificities,
    Model = model_name,
    Threshold = roc_obj$thresholds
  ) %>%
    mutate(Best = if_else(Threshold == best_threshold, TRUE, FALSE))
}

# Calculando as curvas ROC e extraindo os melhores pontos de corte
roc_data_logit <- create_roc_df_with_best(roc_logit, paste("Regressão Logística (AUC =", round(auc_logit, 2), ")"), best_threshold_logit)
roc_data_tree <- create_roc_df_with_best(roc_tree, paste("Árvore de Decisão (AUC =", round(auc_tree, 2), ")"), best_threshold_tree)
roc_data_rf <- create_roc_df_with_best(roc_rf, paste("Random Forest (AUC =", round(auc_rf, 2), ")"), best_threshold_rf)
roc_data_catboost <- create_roc_df_with_best(roc_catboost, paste("CatBoost (AUC =", round(auc_catboost, 2), ")"), best_threshold_catboost)

roc_combined_data <- bind_rows(roc_data_logit, roc_data_tree, roc_data_rf, roc_data_catboost)

# Plotando as curvas ROC com ggplot e adicionando os pontos dos melhores thresholds
ggplot(roc_combined_data, aes(x = 1 - Specificity, y = Sensitivity, color = Model)) +
  geom_line(size = 1.5) +
  geom_point(data = subset(roc_combined_data, Best == TRUE), aes(x = 1 - Specificity, y = Sensitivity), 
             shape = 21, color = "black", fill = "yellow", size = 4) +
  theme_minimal(base_size = 15) +
  labs(
    title = "Comparação de Curvas ROC entre Modelos",
    subtitle = "AUCs para Regressão Logística, Árvore de Decisão, Random Forest e CatBoost",
    x = "1 - Especificidade",
    y = "Sensibilidade"
  ) +
  scale_color_manual(values = c("steelblue", "seagreen", "darkred", "purple")) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
    plot.subtitle = element_text(hjust = 0.5, size = 14),
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 12)
  ) +
  geom_abline(linetype = "dashed", color = "grey")

# Criando uma Tabela com os Resultados ----

criar_tabela_roc_metrics <- function(titulo, subtitulo, fonte, nomes_colunas, valores_linhas) {
  
  dados <- data.frame(
    Modelos = c("Regressão Logística", "Árvore de Decisão", "Random Forest", "CatBoost"),
    AUC = valores_linhas[, 1],
    Best_Threshold = valores_linhas[, 2],
    Especificidade = valores_linhas[, 3],
    Sensibilidade = valores_linhas[, 4]
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

# Valores de AUC, Best Threshold, Especificidade e Sensibilidade para cada modelo
valores_linhas <- rbind(
  c(auc_logit, best_threshold_logit, specificity_logit, sensitivity_logit),   
  c(auc_tree, best_threshold_tree, specificity_tree, sensitivity_tree),    
  c(auc_rf, best_threshold_rf, specificity_rf, sensitivity_rf), 
  c(auc_catboost, best_threshold_catboost, specificity_catboost, sensitivity_catboost)
)

titulo <- "Comparação das Métricas ROC dos Modelos"
subtitulo <- "AUC, Melhor Ponto de Corte, Especificidade e Sensibilidade"
fonte <- "Fonte: Análise de Previsão de Churn"

# Criando e exibindo a tabela
tabela_resultados <- criar_tabela_roc_metrics(
  titulo = titulo,
  subtitulo = subtitulo,
  fonte = fonte,
  nomes_colunas = c("AUC", "Best Threshold", "Especificidade", "Sensibilidade"),
  valores_linhas = valores_linhas
)

tabela_resultados
