## APS 1 - Duração dos Ciclos Econômicos (Econometria Avançada | 2024.2)

### Objetivo do Trabalho

Este projeto estima e compara a **duração dos ciclos econômicos** do Brasil e dos Estados Unidos a partir de séries trimestrais de PIB real.

A análise utiliza modelos autorregressivos para investigar a dinâmica da taxa de crescimento do PIB e calcular durações médias de ciclos estocásticos.

---

### Estrutura do Projeto

- `APS 1.R`
  Script principal com importação das séries, gráficos, correlogramas, modelos AR e cálculo de duração dos ciclos.

- `gdp_brazil.csv`
  Série de PIB trimestral real do Brasil.

- `gdp_usa.csv`
  Série de PIB trimestral real dos Estados Unidos.

---

### Base de Dados

As séries utilizadas são:

- PIB trimestral real do Brasil, com ajuste sazonal
- PIB trimestral real dos Estados Unidos, com ajuste sazonal

A partir dessas séries, o script constrói a taxa de crescimento do PIB.

---

### Fundamentação Teórica

A análise parte da ideia de que ciclos econômicos podem ser aproximados por processos autorregressivos. As raízes do polinômio característico dos modelos AR permitem inferir propriedades de persistência, estacionariedade e duração média dos ciclos.

---

### Metodologia

A análise inclui:

- Gráficos das séries de PIB
- Construção da taxa de crescimento
- ACF e PACF
- Estimação de modelos AR(2) e AR(3)
- Extração das raízes do polinômio característico
- Verificação da condição de estacionariedade
- Cálculo da duração média dos ciclos
- Diagnóstico de resíduos
- Comparação entre Brasil e Estados Unidos

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `dplyr`
  - `moments`
  - `ggplot2`
  - `ggthemes`
  - `gridExtra`
  - `forecast`
  - `stargazer`

---

### Como Reproduzir

1. Mantenha `gdp_brazil.csv` e `gdp_usa.csv` no diretório do projeto.

2. Execute:

   ```r
   source("APS 1.R")
   ```

3. O código retorna gráficos, correlogramas, modelos AR e medidas de duração dos ciclos.

---

### Conclusão

O trabalho mostra como modelos autorregressivos podem ser utilizados para estudar ciclos econômicos de forma comparativa. A interpretação enfatiza diferenças estruturais entre Brasil e Estados Unidos e as limitações de assumir duração constante dos ciclos ao longo do tempo.

Atenciosamente,
**Hicham Tayfour**
