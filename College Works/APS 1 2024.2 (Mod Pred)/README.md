## 📘 APS — Modelagem Preditiva (Insper | 2024.2)

### 🎯 Objetivo do Trabalho
Aplicar métodos de aprendizado supervisionado para resolver dois problemas reais:
1. **Classificação de churn bancário** (clientes que cancelam ou não um serviço).
2. **Regressão de preços de carros usados** da marca Mercedes.

Além disso, o relatório discute detalhadamente o funcionamento das **Random Forests**, com ênfase em conceitos como bagging, aleatorização de splits, erro out-of-bag, entre outros.

---

### 📂 Aplicação 1 — Previsão de Churn

- Base: `churn.csv`  
- Variável-alvo: `Exited` (1 = cliente cancelou; 0 = manteve).
- Modelos utilizados:
  - Regressão Logística
  - Árvore de Decisão
  - Random Forest
  - CatBoost

#### 🔍 Avaliação
- AUC (Área sob a curva ROC)
- Curvas ROC comparativas com `pROC` + `ggplot2`
- Melhor ponto de corte (threshold), sensibilidade, especificidade e acurácia.

---

### 📂 Aplicação 2 — Previsão de Preços de Veículos Usados

- Base: `used_cars.csv`  
- Variável-alvo: `price` (preço do carro)
- Modelos utilizados:
  - Regressão Linear Múltipla
  - Árvore de Regressão
  - Random Forest
  - CatBoost

#### 🔍 Avaliação
- RMSE (Root Mean Squared Error) nos conjuntos de treino e teste.
- Comparação entre os modelos com tabelas `gt`.
- Visualização dos preços previstos vs. observados.

---

### 📚 Parte Teórica (Random Forest)

O relatório inclui:

1. 🌳 **Treinamento de uma Árvore de Regressão**  
   - Etapas, divisão de nós, minimização de erro, desenvolvimento histórico e figuras manuais.

2. 🎲 **Bagging e Bootstrap**  
   - Fundamentos estatísticos, diferenças do uso clássico x preditivo, papel do overfitting e variância.

3. ✂️ **Aleatorização dos Splits (Breiman)**  
   - Intuição do ganho de performance via redução da correlação entre árvores.

4. 📉 **Erro Out-of-Bag (OOB)**  
   - Cálculo e interpretação como alternativa à validação cruzada.

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Bibliotecas:
  - `tidyverse`, `rpart`, `rpart.plot`, `ranger`, `catboost`, `pROC`, `gt`, `rsample`, `ggplot2`

---

### ▶️ Como Executar

1. Coloque os arquivos `churn.csv` e `used_cars.csv` no mesmo diretório dos scripts.
2. Execute os scripts no RStudio (ou outro ambiente R) com os pacotes instalados.
3. O código gera:
   - Tabelas comparativas com `gt`
   - Gráficos ROC e visualizações de árvore
   - Métricas como AUC, RMSE e thresholds ideais

---

Atenciosamente,  
Hicham Tayfour

