## Paper Algotrading - Otimização de Portfólio e Regimes de Mercado (2025.2)

### Objetivo do Trabalho

Este projeto implementa e avalia estratégias de **algotrading baseadas em otimização de portfólio**, combinando métodos clássicos de média-variância com modelos de Machine Learning e Deep Learning para classificação de regimes de mercado.

O objetivo central é comparar estratégias com rebalanceamento fixo e estratégias híbridas, nas quais previsões de regime funcionam como gatilho tático para rebalanceamentos adicionais.

---

### Estrutura do Projeto

- `Paper Algotrading.R`
  Script principal com coleta de dados, engenharia de features, treinamento de modelos, classificação de regimes, otimização de portfólio e backtesting.

---

### Base de Dados

O projeto utiliza dados diários entre 2015 e 2025, coletados com `tidyquant`, `TTR` e `rbcb`.

As classes de ativos incluem:

- Ações brasileiras
- Ações dos Estados Unidos
- Criptomoedas
- Commodities
- ETFs
- Ativos livres de risco, como CDI e Treasury Securities

---

### Fundamentação Teórica

O trabalho parte da teoria moderna de portfólios de **Markowitz**, na qual a alocação depende do vetor de retornos esperados e da matriz de covariância.

A motivação do projeto é que esses parâmetros podem variar com regimes de mercado. Assim, modelos de aprendizado de máquina são usados para identificar estados de alta, baixa e lateralização, sem substituir diretamente a otimização clássica.

---

### Engenharia de Features

As variáveis utilizadas incluem indicadores técnicos e medidas de volatilidade, como:

- Médias móveis
- RSI
- Bandas de Bollinger
- Momentum
- Cruzamentos de médias
- ADX
- Volatilidade condicional via eGARCH(1,1)

---

### Modelos Avaliados

#### **MLP**

Modelo *feedforward* com camadas densas, ReLU, BatchNorm, Dropout e saída em três classes de regime.

#### **LSTM**

Modelo sequencial com janelas de 20 dias, camadas LSTM e classificação final em regimes de mercado.

#### **Estratégias de Portfólio**

- GMV: mínima variância global
- MSR: máximo Sharpe Ratio
- Versões com ativo livre de risco
- Estratégias com rebalanceamento fixo
- Estratégias híbridas com gatilho de regime

---

### Backtesting

O backtest é implementado por um motor vetorial customizado em R, permitindo comparar estratégias tradicionais e híbridas sob a mesma lógica de rebalanceamento.

As métricas avaliadas incluem:

- Retorno anualizado
- Sharpe Ratio
- Máximo drawdown

---

### Principais Resultados

Na implementação atual, os sinais de Machine Learning não agregaram valor adicional às estratégias MSR em termos de Sharpe Ratio, principalmente porque não houve acionamento efetivo de rebalanceamentos adicionais.

O resultado sugere que a classificação de regimes, isoladamente, não é suficiente para melhorar a alocação caso os sinais não alterem diretamente os pesos ou o vetor de retornos esperados.

---

### Limitações

- O vetor de retornos esperados permanece baseado em histórico.
- Os sinais de regime não informam diretamente a alocação dos pesos.
- Custos de transação não são considerados.
- A estratégia híbrida depende da frequência e qualidade dos gatilhos gerados.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `PerformanceAnalytics`
  - `portfolioBacktest`
  - `tidymodels`
  - `tidyverse`
  - `tidyquant`
  - `lubridate`
  - `showtext`
  - `quadprog`
  - `rugarch`
  - `scales`
  - `slider`
  - `caret`
  - `torch`
  - `glue`
  - `rbcb`
  - `TTR`

---

### Como Reproduzir

1. Instale os pacotes necessários, incluindo dependências de `torch`.

2. Execute:

   ```r
   source("Paper Algotrading.R")
   ```

3. O script realiza coleta, tratamento, treinamento dos modelos, otimização e backtesting.

---

### Conclusão

O projeto mostra que modelos de regime podem complementar estratégias quantitativas, mas sua utilidade prática depende da forma como os sinais são incorporados à decisão de alocação. Nesta versão, o ganho não aparece de forma robusta, indicando espaço para extensões com sinais mais diretamente ligados aos pesos ou aos retornos esperados.

Atenciosamente,
**Hicham Munir Tayfour**
