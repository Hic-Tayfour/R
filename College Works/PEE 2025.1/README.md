## 📘 Trabalho de PEE — Independência do BCB e a Potência da Política Monetária (Problemas em Economia | 2024.2)

### 🎯 Objetivo do Trabalho

Investigar como o grau de independência do Banco Central influencia a potência da política monetária, especialmente no controle da inflação, com foco no Brasil e comparações internacionais.

A análise envolve:
- Fundamentação teórica em modelos Novo-Keynesianos
- Construção de base de dados com indicadores macroeconômicos e institucionais
- Visualizações descritivas e exploratórias
- Avaliação empírica com base em estimações de dados em painel

---

### 📂 Estrutura dos Dados

A base de dados principal (`data`) é um painel de países-ano, cobrindo o período de 2000 a 2023, e é construída a partir de diversas fontes:

-   **`cbie_index`**: Índice de independência do Banco Central, bem como suas variantes `cbie_policy` e `cbie_policy_q1`, provenientes do arquivo `CBIDta.xlsx`.
-   **`inflation`**: Taxa de inflação anual (FP.CPI.TOTL.ZG) do World Development Indicators (WDI).
-   **`real_rate`**: Taxa de juros real, calculada a partir da taxa de juros nominal e da inflação. A taxa de juros nominal (`taxa_juros`) é obtida do Fundo Monetário Internacional (IMF-IFS) e do arquivo `rate_macrobond.xlsx`.
-   **`pib`**: PIB (NY.GDP.MKTP.KD, US$ constantes de 2015) do WDI.
-   **`pib_pot`**: PIB potencial, estimado a partir do PIB utilizando o filtro Hodrick-Prescott (HP filter).
-   **`hiato_pct`**: Hiato do produto (diferença percentual entre PIB e PIB potencial).
-   **`divida`**: Dívida governamental (% do PIB - GC.DOD.TOTL.GD.ZS) do WDI.
-   **`inflation_forecast`**: Expectativa de inflação, obtida do arquivo `InflationForecast(FMI).xlsx`.
-   **`target`**: Meta de inflação, compilada a partir dos arquivos `target(macrobond).xlsx` e `target(eikon).xlsx`.
-   **`gap`**: Desvio da inflação em relação à meta (inflação real - meta).
-   **`gap2`**: Desvio absoluto da inflação em relação à meta.

**Fontes de Dados Detalhadas:**
-   **World Development Indicators (WDI)**: PIB, Inflação, Dívida Governamental.
-   **IMF-IFS (International Financial Statistics)**: Taxas de juros.
-   **CBIDta.org**: Índices de independência do Banco Central (CBI).
-   **MacroBond e Eikon**: Taxas de juros e metas de inflação.
-   **FMI (International Monetary Fund)**: Previsões de inflação.
-   **Natural Earth**: Dados geoespaciais para mapas.

---

### 🧼 Limpeza e Padronização

O script `PEE.R` realiza as seguintes etapas para preparar os dados:
-   **Importação e Mesclagem**: Dados de diferentes fontes são importados e mesclados utilizando códigos ISO de países e anos.
-   **Filtragem de Agrupamentos**: Grupos regionais ou econômicos (e.g., "Euro Area", "World", "High income") são excluídos para focar em países individuais.
-   **Tratamento de Dados de Juros e Metas**: As taxas de juros são harmonizadas entre diferentes fontes, com prioridade para dados do MacroBond para a Zona do Euro. As metas de inflação são consolidadas de Eikon e MacroBond e estendidas para os países da Zona do Euro.
-   **Cálculo de Variáveis Derivadas**: O PIB potencial é estimado via filtro HP (freq = 6.25 para dados anuais), e o hiato do produto, taxa de juros real e o desvio da inflação em relação à meta são calculados.
-   **Reestruturação e Rótulos**: As variáveis são renomeadas para facilitar a manipulação e rótulos descritivos são aplicados para melhor compreensão.
-   **Análise de Cobertura**: Funções personalizadas (`analisar_ocorrencias`, `criar_tabela_ocorrencias_novo`) são utilizadas para avaliar a completude dos dados por variável e país, gerando uma tabela detalhada de ocorrências.
-   **Período de Análise**: A base de dados final é filtrada para o período de 2000 a 2023.

---

### 📊 Visualizações Descritivas e Exploratórias

O script gera uma série de gráficos para visualizar as características dos dados e as relações entre as variáveis:

-   **Cobertura de Dados por País e Variável**: Gráfico de barras empilhadas mostrando o número de observações não ausentes por país e por cada variável macroeconômica.
-   **Cobertura Global por País**: Mapa coroplético que exibe a proporção de dados disponíveis por país em relação ao total ideal de observações.
-   **Evolução da Inflação Média por Grupo de Independência**: Gráfico de linhas que compara a inflação média anual entre países nos 25% superiores (alta independência) e 25% inferiores (baixa independência) do índice CBI.
-   **Média do Hiato Inflacionário por Decil de Independência do BC**: Gráfico de linha com pontos e barras de erro ($\pm1$ desvio-padrão), mostrando o hiato inflacionário médio por decil do índice de independência do Banco Central.
-   **Evolução Anual do CBI**: Gráfico de linha com uma faixa que indica $\pm1$ desvio-padrão em torno da média anual do índice CBI, destacando países com valores "outliers" (acima ou abaixo de $\pm1$ desvio-padrão).
-   **Evolução de Indicadores Macroeconômicos (2000–2023)**: Gráficos de linha facetados mostrando a evolução das médias globais anuais do índice CBI, inflação, taxa de juros real e gap inflacionário.
-   **Independência do BC e Volatilidade do Gap Inflacionário**: Gráfico de densidade 2D (com contornos preenchidos) que visualiza a relação entre o índice CBI e a volatilidade condicional do gap inflacionário, estimada via modelo EGARCH(1,1) por país.
-   **Menores desvios frente à meta em países com BC mais independente**: Gráfico de linhas que compara a média anual do gap inflacionário entre os 25% países com BC mais e menos independentes.
-   **Inflação e Hiato do Produto por Regime de Independência Monetária**: Gráficos de densidade 2D facetados que ilustram a relação entre o hiato do produto e a inflação, separando os países em grupos de alta e baixa independência do Banco Central.
-   **Reformas Institucionais e Queda na Inflação**: Gráfico de dispersão que mostra a relação entre a mudança percentual no índice CBI e a mudança percentual na inflação, com uma linha de tendência de regressão linear e rótulos para episódios de mudança.

---

### 🔍 Análise Empírica: Modelagem GMM

Para investigar a relação entre a independência do Banco Central e a potência da política monetária, são utilizados modelos de GMM (Generalized Method of Moments) para dados em painel.

#### 1. **Hipótese Econômica**
> Quanto maior o grau de independência do Banco Central, maior será a potência da política monetária no controle inflacionário.

#### 2. **Referencial Teórico**
-   **Woodford (2003), Clarida, Galí & Gertler (1999):** Modelos Novo-Keynesianos (NK), Regra de Taylor e consistência intertemporal.
-   **Jácome & Pienknagura (2022):** Papel das instituições na América Latina.
-   **Davide Romelli (2023):** Índices compostos de independência formal/informal.

#### 3. **Estimações GMM**

São estimados modelos GMM dinâmicos (usando o pacote `plm` e a função `pgmm` com `model = "twosteps"` e `transformation = "ld"`) para o painel de dados (`panel`). A variável dependente é o `gap` (desvio da inflação em relação à meta). As principais variáveis explicativas incluem:

-   `lag(gap, 1)`: O gap de inflação defasado, capturando a persistência.
-   `cbie_index`, `cbie_policy`, `cbie_policy_q1`: Índices de independência do Banco Central.
-   `real_rate`: Taxa de juros real.
-   `lag(hiato_pct, 1)`: Hiato do produto defasado.
-   `inflation_forecast`: Expectativa de inflação.
-   **Termos de Interação**: `I(cbie_index * real_rate)`, `I(cbie_policy * real_rate)`, `I(cbie_policy_q1 * real_rate)` investigam como a independência do BC modera o efeito da taxa de juros real sobre o gap inflacionário.

**Instrumentação**: Variáveis endógenas e seus lags são instrumentados com lags adicionais (e.g., `lag(gap, 3:4)`, `lag(real_rate, 2:3)`, `lag(inflation_forecast, 3:4)`, `lag(hiato_pct, 3:4)`).

**Tabelas de Resultados**: A função `create_gmm_table` gera tabelas formatadas (usando `gt`) com os coeficientes estimados, erros padrão robustos, níveis de significância e estatísticas de teste (Sargan para validade dos instrumentos, Wald para significância conjunta dos coeficientes, e testes AR(1) e AR(2) para autocorrelação dos resíduos).

#### 4. **Gráficos de Efeitos Marginais**

Para visualizar os efeitos das interações estimadas nos modelos GMM, são gerados dois gráficos de efeitos marginais:
-   **Gap Previsto vs. Juros Reais**: Mostra a relação entre o gap inflacionário previsto e a taxa de juros real para diferentes níveis do índice CBI.
-   **Gap Previsto vs. CBI**: Ilustra a relação entre o gap inflacionário previsto e o índice CBI para diferentes níveis da taxa de juros real.

---

### 💻 Tecnologias Utilizadas

-   **Linguagem**: **R**
-   **Pacotes**:
    -   `rnaturalearth`: Conjunto de dados e mapas de países.
    -   `CGPfunctions`: Gráficos.
    -   `countrycode`: Nomeação de países.
    -   `tidyverse` (inclui `dplyr`, `ggplot2`, `tidyr`, `readr`): Tratamento, manipulação e visualização de dados.
    -   `tidyquant`: Dados financeiros.
    -   `gridExtra`, `patchwork`: Organização de gráficos.
    -   `gganimate`: Gráficos animados (embora não usado diretamente na saída HTML atual).
    -   `ggeffects`: Gráficos de efeitos (útil para efeitos marginais, mas o script usa cálculo manual).
    -   `labelled`: Rótulos de variáveis.
    -   `ggthemes`: Temas para gráficos.
    -   `seasonal`: Ajuste sazonal para séries temporais (não diretamente usado para dados anuais).
    -   `imf.data`: Baixar dados do IMF.
    -   `gtExtras`, `gt`: Tabelas formatadas.
    -   `ggstream`: Gráficos de fluxo (não usado na saída HTML atual).
    -   `ggrepel`: Rótulos em gráficos que evitam sobreposição.
    -   `rugarch`: Modelos GARCH.
    -   `stringr`: Manipulação de strings.
    -   `viridis`: Paletas de cores para gráficos.
    -   `mFilter`: Filtro HP.
    -   `fixest`: Estimação de modelos (não usado diretamente para GMM, `plm` é usado).
    -   `ggtext`: Formatação avançada de texto em gráficos.
    -   `plotly`: Gráficos interativos (não usado na saída HTML atual).
    -   `readxl`: Leitura de arquivos Excel.
    -   `sidrar`: Baixar dados do IBGE (não usado na saída HTML atual).
    -   `scales`: Formatação de escalas em gráficos.
    -   `broom`: Facilita o trabalho com modelos estatísticos.
    -   `glue`: Interpolação de strings.
    -   `zoo`: Manipulação de séries temporais com datas (útil para dados trimestrais, mas aqui para datas).
    -   `WDI`: Baixar dados direto do World Development Indicators.
    -   `plm`: Modelos para dados em painel (especialmente GMM).
    -   `sf`: Manipulação de dados espaciais.

---

### ▶️ Como Reproduzir

1.  **Preparar o Ambiente**: Certifique-se de ter o R e RStudio instalados. Instale todos os pacotes listados na seção "Tecnologias Utilizadas" usando `install.packages("nome_do_pacote")`.
2.  **Baixar as Bases de Dados Auxiliares**:
    -   `CBIDta.xlsx`: Obtenha do site `https://cbidata.org/`.
    -   `InflationForecast(FMI).xlsx`: Obtenha de fontes do FMI ou um repositório onde esteja disponível.
    -   `rate_macrobond.xlsx`: Arquivo de dados internos, se necessário, obter da fonte MacroBond.
    -   `target(macrobond).xlsx`: Arquivo de dados internos, se necessário, obter da fonte MacroBond.
    -   `target(eikon).xlsx`: Arquivo de dados internos, se necessário, obter da fonte Eikon.
    -   **Observação**: O script assume que esses arquivos estão no mesmo diretório do script `PEE.R`.
3.  **Executar o Script**: Abra o arquivo `PEE.R` no RStudio e execute todo o código.
    -   As etapas de importação, tratamento, visualização e estimação serão processadas.
    -   Os gráficos serão gerados na janela de plots do RStudio.
    -   As tabelas de análise de ocorrências e os resultados do GMM serão impressos no console ou visualizados como objetos `gt` se você estiver no RStudio.
4.  **Interpretar os Resultados**: Analise os gráficos e tabelas geradas para compreender as relações empíricas e comparar com as hipóteses teóricas.

5.  **Visualizar o Relatório Completo**: O programa executado pode ser visualizado [aqui](https://raw.githack.com/Hic-Tayfour/HTML/refs/heads/main/PEE.html).

---

Atenciosamente,
**Hicham Munir Tayfour**
```