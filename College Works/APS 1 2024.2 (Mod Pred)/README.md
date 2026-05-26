## APS 1 - Modelagem Preditiva (2024.2)

### Objetivo do Trabalho

Este projeto aplica métodos de aprendizado supervisionado a dois problemas preditivos: **classificação de churn bancário** e **regressão de preços de veículos usados**.

Além das aplicações empíricas, o trabalho discute a fundamentação de **Random Forests**, incluindo árvores de decisão, bagging, bootstrap, aleatorização de splits e erro out-of-bag.

---

### Estrutura do Projeto

- `APS - Aplicação 1.R`
  Script da aplicação de classificação de churn bancário.

- `APS - Aplicação 2.R`
  Script da aplicação de regressão de preços de veículos usados.

- `churn.csv`
  Base de clientes bancários utilizada na aplicação de classificação.

- `used_cars.csv`
  Base de veículos usados utilizada na aplicação de regressão.

---

### Aplicação 1 - Churn Bancário

A primeira aplicação prevê se um cliente cancelou ou não um serviço bancário.

- Variável-alvo: `Exited`
- Modelos avaliados:
  - Regressão logística
  - Árvore de decisão
  - Random Forest
  - CatBoost

As métricas incluem AUC, curvas ROC, ponto de corte, sensibilidade, especificidade e acurácia.

---

### Aplicação 2 - Preço de Veículos Usados

A segunda aplicação prevê preços de veículos usados da marca Mercedes.

- Variável-alvo: `price`
- Modelos avaliados:
  - Regressão linear múltipla
  - Árvore de regressão
  - Random Forest
  - CatBoost

As métricas incluem RMSE em treino e teste, comparação entre modelos e gráficos de valores previstos versus observados.

---

### Fundamentação Teórica

O relatório discute Random Forests a partir dos seguintes blocos:

1. **Árvores de Regressão**
   Divisão recursiva de nós, minimização de erro e interpretação da estrutura da árvore.

2. **Bagging e Bootstrap**
   Uso de reamostragem para reduzir variância e estabilizar previsões.

3. **Aleatorização de Splits**
   Redução da correlação entre árvores por seleção aleatória de variáveis candidatas.

4. **Erro Out-of-Bag**
   Avaliação interna do modelo sem necessidade de validação cruzada tradicional.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `rpart.plot`
  - `tidyverse`
  - `catboost`
  - `rsample`
  - `ranger`
  - `rpart`
  - `class`
  - `pROC`
  - `tree`
  - `gt`

---

### Como Reproduzir

1. Mantenha `churn.csv` e `used_cars.csv` no diretório do projeto.

2. Execute a aplicação de churn:

   ```r
   source("APS - Aplicação 1.R")
   ```

3. Execute a aplicação de preços:

   ```r
   source("APS - Aplicação 2.R")
   ```

---

### Conclusão

O projeto compara modelos lineares, árvores, Random Forests e CatBoost em tarefas de classificação e regressão. A parte teórica conecta a implementação empírica aos fundamentos estatísticos dos métodos de ensemble.

Atenciosamente,
**Hicham Tayfour**
