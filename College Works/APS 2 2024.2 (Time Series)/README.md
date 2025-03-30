## 📘 APS 2 — Econometria Avançada: Minério de Ferro, VALE e Séries Temporais (Insper - 2024.2)

### 🎯 Objetivo do Trabalho
Avaliar, com ferramentas de séries temporais, se as ações da **Vale S.A.** devem ser incluídas na carteira de um investidor, considerando sua relação com o preço do **minério de ferro** no mercado internacional.

---

### 📊 Fontes de Dados
- **Yahoo Finance** via `tidyquant::tq_get()`
- **Período da amostra**: Janeiro de 2007 até Outubro de 2024
- **Séries coletadas**:
  - Preço mensal do minério de ferro (`TIO=F`)
  - Preço mensal das ações da Vale (`VALE`)

---

### 🧪 Etapas da Análise

#### **a) Análise do Minério de Ferro**
- Gráfico de linha da série mensal.
- Destaques nos choques recentes ligados à reabertura da economia chinesa e crise imobiliária.
- Análise aprofundada dos **últimos 2 anos**.

#### **b) Análise das Ações da Vale**
- Gráfico de linha da série mensal.
- Identificação de eventos que afetaram a série (ex: tragédias ambientais, variações na commodity).

#### **c) Comparação em Eixos Ajustados**
- Gráfico comparando preços mensais de ambas as séries.
- Ajuste via fator de escala para melhor visualização.

#### **d) Comparação dos Logs**
- Gráfico conjunto dos log-preços de Vale e minério.
- Investigação da co-movimentação das séries no longo prazo.

#### **e) e f) Testes de Raiz Unitária (ADF)**
- Aplicação do **Teste de Dickey-Fuller Aumentado (ADF)** em `log(preço)` do minério e da Vale.
- Consideração de diferentes especificações:
  - Com tendência e intercepto
  - Apenas com intercepto
  - Sem nenhum

#### **g) e h) Análise dos Log-Retornos**
- Construção das séries de log-retorno.
- Gráficos e **correlogramas (ACF e PACF)**.
- Discussão de:
  - Estacionariedade
  - Presença de **volatility clustering**
  - Memória nas séries (hipótese de mercado eficiente)

#### **i) Processo Estocástico Subjacente**
- Discussão teórica: presença de raiz unitária → random walk vs. estacionariedade.
- Análise com base nos resultados dos testes ADF e log-retornos.

#### **j) e k) Cointegração**
- Explicação teórica do conceito de **relação de equilíbrio de longo prazo**.
- Verificação prática via:
  - Regressão de log-preços
  - Teste ADF nos resíduos do modelo
  - Interpretação dos resultados

#### **l) e m) Modelagem**
- Escolha entre modelo em **níveis** ou em **primeiras diferenças**, com base nos testes de estacionariedade e cointegração.
- Estimação dos modelos com `lm()` e interpretação dos coeficientes.

---

### 📈 Visualizações Produzidas
- Gráficos de linha (preços e log-preços)
- Correlogramas (ACF/PACF) dos log-retornos
- Séries dos log-retornos com destaques visuais
- Comparações ajustadas entre minério e Vale

---

### 💻 Tecnologias Utilizadas
- Linguagem: **R**
- Pacotes: `tidyquant`, `forecast`, `urca`, `moments`, `ggplot2`, `tseries`, `gridExtra`, `stargazer`, `dplyr`, `ggthemes`

---

### ▶️ Como Executar
1. Execute o script `APS2_EconometriaAvancada.R` com os pacotes previamente instalados.
2. As séries são baixadas diretamente do Yahoo Finance via `tq_get()`.
3. O script retorna:
   - Gráficos salvos ou exibidos no console
   - Tabelas de resumo
   - Resultados dos testes de raiz unitária
   - Estimativas de regressões

---

### 🧠 Reflexão Final
> O trabalho encerra com uma **discussão sobre perspectivas futuras para o preço do minério de ferro** e a recomendação (ou não) de **incluir VALE na carteira de investimentos**, integrando evidências estatísticas e fundamentos econômicos.

---

Atenciosamente,  
Hicham Tayfour

