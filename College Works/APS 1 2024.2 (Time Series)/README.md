## 📘 APS 1 — Estimação da Duração dos Ciclos Econômicos com Séries Temporais (Econometria Avançada - Insper, 2024.2)

### 🎯 Objetivo do Trabalho
Estimar e analisar a **duração dos ciclos econômicos** do Brasil e dos Estados Unidos, utilizando modelos AR(p) sobre a série de **taxa de crescimento do PIB real trimestral**, com base em dados dessazonalizados e ajustados.

---

### 📊 Fontes de Dados
- **Brasil**:
  - PIB trimestral real com ajuste sazonal.
  - Fonte: Instituto Brasileiro de Geografia e Estatística (IBGE) / FRED (via série NGDPRSAXDCBRQ).
- **Estados Unidos**:
  - PIB trimestral real com ajuste sazonal.
  - Fonte: Bureau of Economic Analysis (BEA) / FRED (via série GDPC1).

---

### 🧪 Etapas da Análise

#### **a) Análise da Série do PIB do Brasil**
- Gráfico de linha da série.
- Correlograma (ACF e PACF).
- Discussão sobre estacionariedade e implicações econômicas.

#### **b) Análise da Série de Crescimento do PIB do Brasil**
- Construção da série `GROWTH` = variação percentual do PIB.
- Gráfico de linha e análise histórica (ex: crises, retomadas).

#### **c) Correlograma da Série de Crescimento do PIB**
- ACF e PACF para verificar presença de memória na série.
- Discussão teórica com base em **Williamson (2008)** e **Romer (2006)**.

#### **d) Estimação de Modelos AR(2) e AR(3)**
- Estimação via `arima()`.
- Extração das raízes do polinômio característico.
- Verificação da condição de estacionariedade (raízes > 1).

#### **e) Duração Média do Ciclo Estocástico**
- Fórmula de **Tsay (2005)**:

  $$
  k = \frac{2\pi}{\cos^{-1}\left( \frac{a}{\sqrt{a^2 + b^2}} \right)}
  $$

- Cálculo da duração dos ciclos para Brasil (AR(2) e AR(3)) e EUA (AR(3), incluindo janela 1947–2015).

#### **f) Diagnóstico de Resíduos**
- Correlogramas dos resíduos dos modelos AR(2) e AR(3).
- Avaliação de adequação dos modelos ao comportamento da série.

#### **g–i) Análises para os EUA**
- Repetição das análises feitas para o Brasil.
- Gráficos do PIB e da taxa de crescimento.
- Correlogramas e modelos AR estimados.

#### **j) Estimação do Ciclo para EUA**
- Estimação do modelo AR(3) com:
  - Janela completa
  - Janela 1947–2015
- Comparação dos resultados.

#### **k) Comparação entre Brasil e EUA**
- Discussão sobre diferenças estruturais e institucionais:
  - Estabilidade macroeconômica
  - Integração financeira
  - Políticas anticíclicas

#### **l) Espaço para Política Econômica**
- Reflexão com base na variância do ciclo e na capacidade institucional de resposta.
- Fundamentação com autores como Blanchard, Romer e FMI.

#### **m) Discussão Final**
> *"É razoável imaginar que a duração dos ciclos seja constante ao longo do tempo?"*  
Resposta envolve:
- **Mudanças estruturais**
- **Choques externos e internos**
- **Limitações do modelo AR para captar variações temporais**

---

### 📈 Visualizações Produzidas
- Gráficos de linha: PIB e crescimento para Brasil e EUA.
- Correlogramas (ACF, PACF).
- Gráficos de raízes no **círculo unitário**.
- Gráficos de resíduos dos modelos.

---

### 💻 Tecnologias Utilizadas
- Linguagem: **R**
- Pacotes: `ggplot2`, `forecast`, `moments`, `stargazer`, `gridExtra`, `dplyr`, `ggthemes`

---

### ▶️ Como Executar
1. Salve os arquivos `gdp_brazil.csv` e `gdp_usa.csv` no mesmo diretório do script.
2. Execute o script `APS1_EconometriaAvancada.R` em ambiente com os pacotes listados.
3. O script irá:
   - Importar dados
   - Gerar gráficos e correlogramas
   - Estimar modelos AR(p)
   - Calcular raízes e duração dos ciclos

---

Atenciosamente,  
Hicham Tayfour
