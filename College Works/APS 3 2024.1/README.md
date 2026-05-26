## APS 3 - Determinantes da Taxa de Homicídios (Econometria | 2024.1)

### Objetivo do Trabalho

Este projeto estima modelos de regressão linear para investigar os determinantes da taxa de homicídios nos estados norte-americanos.

A análise considera fatores como armas, PIB per capita, urbanização, policiamento e desigualdade.

---

### Estrutura do Projeto

- `APS 3 Econometria.R`
  Script principal com regressões, análise de resíduos, testes estatísticos e gráficos.

- `APS econo.xlsx`
  Base de dados utilizada no trabalho.

---

### Base de Dados

A unidade de análise é o estado norte-americano. A variável dependente é:

- `Hom`: homicídios por 100 mil habitantes

As variáveis explicativas incluem:

- `ln_Guns`
- `ln_IpC`
- `Urb`
- `Poli`
- `Gini`

---

### Fundamentação Metodológica

O trabalho usa regressão linear para avaliar associações entre criminalidade e fatores socioeconômicos. Além da estimação do modelo múltiplo, o projeto verifica suposições importantes por meio de análise de resíduos e testes formais.

---

### Metodologia

A análise inclui:

- Estimação de modelo linear múltiplo
- Avaliação de significância dos coeficientes
- Tabela formatada com `gt`
- Histograma e densidade dos resíduos
- Teste de Jarque-Bera
- Teste de Breusch-Pagan
- Regressões simples para variáveis selecionadas
- Gráficos de valores observados versus previstos

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `gt`
  - `readxl`
  - `moments`
  - `lmtest`
  - `dplyr`

---

### Como Reproduzir

1. Mantenha `APS econo.xlsx` no mesmo diretório do script.

2. Execute:

   ```r
   source("APS 3 Econometria.R")
   ```

3. O código retorna tabelas de regressão, testes estatísticos e gráficos de diagnóstico.

---

### Conclusão

O projeto avança da análise exploratória para a modelagem econométrica, permitindo avaliar associações condicionais entre homicídios e variáveis socioeconômicas. A interpretação depende das hipóteses do modelo linear e dos diagnósticos de resíduos.

Atenciosamente,
**Hicham Tayfour**
