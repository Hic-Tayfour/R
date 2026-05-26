## APS 2 - Minério de Ferro, Vale e Séries Temporais (Econometria Avançada | 2024.2)

### Objetivo do Trabalho

Este projeto avalia a relação entre o preço internacional do **minério de ferro** e as ações da **Vale S.A.**, com foco em séries temporais financeiras.

O objetivo é discutir se ações da Vale deveriam ser incluídas na carteira de um investidor, considerando evidências de co-movimentação, estacionariedade, retornos e possível relação de longo prazo com a commodity.

---

### Estrutura do Projeto

- `APS 2 - EcoAv 24.2.R`
  Script principal com coleta de dados, tratamento das séries, testes de raiz unitária, análise de retornos, cointegração e modelagem.

---

### Base de Dados

As séries são coletadas via Yahoo Finance com `tidyquant`.

O período analisado vai de janeiro de 2007 a outubro de 2024.

As séries centrais são:

- Preço mensal do minério de ferro
- Preço mensal das ações da Vale

---

### Fundamentação Teórica

O trabalho parte de conceitos de séries temporais financeiras, incluindo:

- Passeio aleatório
- Estacionariedade
- Raiz unitária
- Log-retornos
- Volatility clustering
- Cointegração
- Relação de equilíbrio de longo prazo

---

### Metodologia

A análise inclui:

- Gráficos das séries de preços
- Comparação entre minério de ferro e Vale com eixos ajustados
- Análise dos log-preços
- Testes ADF de raiz unitária
- Construção dos log-retornos
- Correlogramas ACF e PACF
- Discussão sobre processo estocástico subjacente
- Teste de cointegração via resíduos
- Escolha entre modelagem em níveis ou primeiras diferenças

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `gridExtra`
  - `stargazer`
  - `tidyquant`
  - `ggthemes`
  - `forecast`
  - `moments`
  - `ggplot2`
  - `tseries`
  - `dplyr`
  - `urca`

---

### Como Reproduzir

1. Garanta conexão com a internet para baixar as séries financeiras.

2. Execute:

   ```r
   source("APS 2 - EcoAv 24.2.R")
   ```

3. O código retorna gráficos, testes de raiz unitária, análises de retornos e modelos.

---

### Conclusão

O trabalho integra evidências estatísticas e fundamentos econômicos para discutir a inclusão de VALE em carteira. A interpretação depende especialmente da estacionariedade das séries, da análise dos retornos e da presença ou ausência de relação de equilíbrio de longo prazo.

Atenciosamente,
**Hicham Tayfour**
