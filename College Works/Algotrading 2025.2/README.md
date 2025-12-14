# Paper Algotrading 2025.2

## Descrição Geral

Este projeto implementa e avalia estratégias de **algotrading baseadas em otimização de portfólio**, integrando métodos clássicos de Média-Variância (GMV e MSR) com **modelos de Machine Learning e Deep Learning** para classificação de regimes de mercado.  
Toda a análise é conduzida em **R**, utilizando pacotes do ecossistema *tidyverse* e o pacote **torch** para redes neurais.

O objetivo central é comparar estratégias de rebalanceamento **puramente fixo** com uma estratégia **híbrida**, na qual um classificador de regimes de mercado atua como um **gatilho tático** para rebalanceamentos adicionais, sem eliminar o rebalanceamento periódico tradicional.

---

## Estrutura do Projeto

- `Algotrading.R`  
  Script principal em R contendo:
  - Aquisição e tratamento dos dados
  - Engenharia de *features*
  - Treinamento dos modelos MLP e LSTM
  - Classificação de regimes de mercado
  - Implementação das estratégias de otimização de portfólio
  - Motor de backtest vetorial customizado em R 

---

## Fundamentação Teórica

O projeto se baseia na teoria moderna de portfólios de **Markowitz (1959)**, que depende da estimação do vetor de retornos esperados (𝜇) e da matriz de covariância (Σ). A literatura aponta que ambos são **instáveis e dependentes do regime de mercado**, o que compromete estratégias baseadas exclusivamente em médias históricas.

Avanços em Machine Learning e Deep Learning são utilizados neste trabalho não para substituir diretamente 𝜇, mas como um **mecanismo de *timing* tático**, identificando regimes de mercado (Alta, Baixa e Lateralização) e acionando rebalanceamentos adicionais.

---

## Dados Utilizados

Foram utilizados **dados diários entre 2015 e 2025**, obtidos via `tidyquant`, `TTR` e `rbcb`, abrangendo múltiplas classes de ativos:

- **Ações brasileiras**: PETR4.SA, TAEE11.SA, VALE3.SA, WEGE3.SA, BBAS3.SA, BBSE3.SA, ITUB4.SA, ITSA4.SA  
- **Ações dos EUA**: AAPL, AMZN, MSFT, NVDA  
- **Criptomoedas**: BTC-USD, ETH-USD, USDT-USD  
- **Commodities**: GLD, SLV  
- **ETFs**: BOVA11.SA, EFA, SPY, XOP  
- **Ativo livre de risco (RF)**: CDI e Treasury Securities  

---

## Engenharia de Features

A engenharia de *features* inclui indicadores técnicos tradicionais e medidas de volatilidade, tais como:

- Médias móveis (SMA)
- RSI
- Bandas de Bollinger
- Indicadores de momentum (ROC)
- Indicadores de tendência (SMA Crossover, ADX)
- Volatilidade condicional estimada via **eGARCH(1,1)** (`rugarch`)

O conjunto final utilizado pelos modelos de ML contém **15 *features* selecionadas**.

---

## Modelos de Classificação de Regime

Foram implementados dois modelos de Deep Learning utilizando o pacote **torch** em R:

### MLP (Multi-Layer Perceptron)
- Arquitetura *feedforward*
- 3 camadas ocultas: 64 → 32 → 16 neurônios
- Ativação ReLU, BatchNorm e Dropout (0,3)
- Saída com 3 classes: Baixa, Lateralização e Alta

### LSTM (Long Short-Term Memory)
- Entrada sequencial com janelas de 20 dias
- 2 camadas LSTM com 64 unidades ocultas
- Uso do *hidden state* do último *timestep* como representação final
- Camada de classificação final para 3 classes :contentReference[oaicite:9]{index=9}

O treinamento foi realizado por até **150 épocas**, com *early stopping*, taxa de aprendizado inicial de **0,0005** e uso de **Focal Loss** para lidar com desbalanceamento de classes.

---

## Definição dos Regimes de Mercado

O *target* de classificação é definido com base no retorno futuro em um *look-forward* de 20 dias, dividido em tercis :contentReference:

- **Alta**: retorno no 3º tercil (> 66%)
- **Baixa**: retorno no 1º tercil (< 33%)
- **Lateralização**: retorno no 2º tercil (entre 33% e 66%)

---

## Estratégias de Otimização de Portfólio

Foram implementadas estratégias clássicas de Média-Variância, rebalançadas com *lookback* de 126 dias :

### GMV — Mínima Variância Global
Minimiza a variância do portfólio, independentemente de retornos esperados.

### MSR — Máximo Sharpe Ratio (Long-Only)
Maximiza o retorno ajustado ao risco, com restrição de pesos não negativos, resolvida via programação quadrática (`quadprog`).

Também foram avaliadas variantes com **ativo livre de risco**, limitando sua participação a **30%** do portfólio.

---

## Backtesting

O backtest foi implementado por meio de um **motor vetorial customizado em R**, sem uso de pacotes de terceiros, permitindo a integração de lógicas complexas de rebalanceamento.

Foram comparadas:
- Estratégias com rebalanceamento fixo
- Estratégias híbridas, utilizando previsões de regime (MLP ou LSTM) como gatilho tático

---

## Resultados

Os resultados indicam que, **nesta implementação**, o uso do ML como gatilho tático **não agregou valor adicional** às estratégias MSR em termos de Sharpe Ratio, pois não houve acionamento efetivo de rebalanceamentos adicionais.

As métricas de desempenho incluem:
- Retorno anualizado
- Sharpe Ratio
- Máximo *drawdown*

---

## Limitações

- O vetor de retornos esperados (𝜇) utilizado na otimização permanece histórico
- Os sinais de regime do ML não informam diretamente a alocação dos pesos
- Custos de transação não são considerados no backtest

---

## Tecnologias Utilizadas

- **Linguagem**: R  
- **Pacotes principais**:
  - `tidyverse`, `tidyquant`, `PerformanceAnalytics`
  - `torch`, `caret`
  - `rugarch`, `quadprog`, `TTR`
  - `rbcb`, `slider`, `scales`

---

Atenciosamente,
**Hicham Munir Tayfour**
