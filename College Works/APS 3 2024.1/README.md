## 📘 APS — Econometria (Insper | 2024.2)

### 🎯 Objetivo do Trabalho
Investigar os determinantes da taxa de homicídios nos estados norte-americanos utilizando **modelos de regressão linear**, com foco na relação entre criminalidade e fatores socioeconômicos como **armas, PIB per capita, urbanização, policiamento e desigualdade**.

O trabalho realiza análises de resíduos, testes de hipóteses e previsões a partir do modelo ajustado.

---

### 📂 Base de Dados

- Arquivo: `APS econo.xlsx`
- Unidade de análise: Estados norte-americanos
- Variável dependente: `Hom` (Homicídios por 100 mil habitantes)
- Variáveis independentes:
  - `ln_Guns`: Logaritmo do número de armas
  - `ln_IpC`: Logaritmo do PIB per capita
  - `Urb`: Taxa de urbanização
  - `Poli`: Policiais por 100 mil habitantes
  - `Gini`: Índice de Gini

---

### 📊 Etapas da Análise

#### 1. 🧮 Estimação do Modelo Linear Múltiplo
- Modelo ajustado: `Hom ~ ln_Guns + ln_IpC + Urb + Poli + Gini`
- Avaliação dos coeficientes com significância estatística (`p-value`)
- Tabela formatada com `gt`

#### 2. 📉 Análise dos Resíduos
- Histograma e densidade dos resíduos
- Teste de normalidade dos resíduos (Jarque-Bera)
- Dispersão dos resíduos e resíduos ao quadrado
- Teste de heterocedasticidade (Breusch-Pagan)

#### 3. 🔍 Modelos Simples de Regressão
- Estimados separadamente para:
  - `ln_IpC`
  - `Poli`
  - `Gini`
- Geração de gráficos com:
  - Linha de regressão
  - Intervalo de confiança
  - Pontos observados

#### 4. 📈 Visualização Final
- Comparação entre valores observados e valores previstos pelo modelo múltiplo

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Bibliotecas:
  - `tidyverse`, `gt`, `ggplot2`, `readxl`, `lmtest`, `moments`, `broom`

---

### ▶️ Como Executar

1. Coloque o arquivo `APS econo.xlsx` no mesmo diretório do script.
2. Execute o código no RStudio com os pacotes instalados.
3. O script gerará:
   - Tabela de regressão formatada (`gt`)
   - Gráficos de resíduos e previsões
   - Testes estatísticos (Jarque-Bera e Breusch-Pagan)

---

Atenciosamente,  
Hicham Tayfour
