## 📘 Trabalho de PEE — Independência do BCB e a Potência da Política Monetária (Problemas em Economia | 2024.2)

### 🎯 Objetivo do Trabalho

Este projeto investiga como o grau de independência do Banco Central afeta a potência da política monetária no controle da inflação.

**A abordagem envolve:**

* Fundamentação teórica em modelos Novo-Keynesianos
* Construção de painel país-ano com dados macroeconômicos e institucionais
* Visualizações exploratórias para padrões e cobertura
* Modelagem econométrica (GMM dinâmico) para avaliação empírica

---

### 📂 Estrutura dos Dados

A base de dados `data` cobre países entre 2000 e 2023 e integra informações de diversas fontes:

* **Indicadores Institucionais**: `cbie_index`, `cbie_policy`, `cbie_policy_q1` — Índices de independência do Banco Central (`CBIDta.xlsx`)
* **Inflação**: `inflation` (FP.CPI.TOTL.ZG - WDI)
* **Taxa de Juros Real**: Calculada com base na `taxa_juros` nominal (IMF e `rate_macrobond.xlsx`) e inflação
* **PIB e PIB Potencial**: `pib` (NY.GDP.MKTP.KD - WDI); `pib_pot` calculado com filtro HP
* **Hiato do Produto**: `hiato_pct` — diferença percentual entre PIB e PIB potencial
* **Dívida Pública**: `divida` (% do PIB - GC.DOD.TOTL.GD.ZS - WDI)
* **Expectativas e Metas de Inflação**: `inflation_forecast` (`InflationForecast(FMI).xlsx`) e `target` (consolidado de `target(macrobond).xlsx` e `target(eikon).xlsx`)
* **Gap Inflacionário**: `gap` (inflação - meta) e `gap2` (valor absoluto)

**Fontes utilizadas incluem:**

* World Development Indicators (WDI)
* IMF-IFS
* CBIDta.org
* MacroBond & Eikon
* FMI (Previsões)
* Natural Earth (Mapas)

---

### 🧼 Limpeza e Padronização

O script `PEE.R` realiza as seguintes etapas:

* **Importação e Unificação**: Importa múltiplas fontes e padroniza por `iso3c` e `year`
* **Filtragem**: Exclui agregados regionais/econômicos para manter foco em países
* **Tratamento de Juros e Metas**: Harmoniza séries da Zona do Euro, com prioridade para MacroBond
* **Cálculos Derivados**:

  * PIB potencial via filtro HP (freq = 6.25)
  * Taxa real de juros
  * Hiato do produto
  * Desvios da inflação em relação à meta
* **Rótulos e Organização**: Uso do pacote `labelled` para anotações compreensíveis
* **Cobertura**: Geração de tabela com função `criar_tabela_ocorrencias_novo`, detalhando cobertura por variável e país
* **Período Final**: Painel filtrado para 2000–2023

---

### 📊 Visualizações Descritivas

Diversos gráficos são gerados para explorar padrões nos dados:

* Cobertura de variáveis por país (barras empilhadas)
* Mapa mundial com proporção de cobertura de dados (Natural Earth + WDI)
* Inflação média anual por grupo de CBI (top 25% vs bottom 25%)
* Gap inflacionário médio por decil do índice CBI
* Evolução temporal do índice CBI com destaques para outliers
* Evolução média anual de indicadores macroeconômicos
* Densidade condicional da volatilidade inflacionária estimada via EGARCH(1,1) em relação ao CBI
* Gap inflacionário em países mais e menos independentes
* Densidade conjunta de inflação e hiato, por grupo de independência
* Reformas institucionais: relação entre variação do CBI e da inflação

---

### 🔍 Análise Empírica — Modelos GMM

Modelos dinâmicos GMM (`plm::pgmm`) são estimados para testar a hipótese:

> "Maior independência do Banco Central → maior potência da política monetária no controle inflacionário"

#### Referencial Teórico:

* Modelos Novo-Keynesianos (Woodford 2003; Clarida, Galí & Gertler 1999)
* Enfoques institucionais (Jácome & Pienknagura 2022; Romelli 2023)

#### Especificações:

* Variável dependente: `gap`
* Regressoras principais:

  * `cbie_index`, `cbie_policy`, `cbie_policy_q1`
  * `real_rate`, `inflation_forecast`, `lag(gap, 1)`, `lag(hiato_pct, 1)`
  * Interações: `I(cbie_* × real_rate)`
* Instrumentação: lags de variáveis endógenas (`gap`, `real_rate`, `forecast`, `hiato`)
* Estimativa com `model = "twosteps"` e `transformation = "ld"`

#### Resultados:

* Tabelas formatadas geradas via função `create_gmm_table`, incluindo:

  * Coeficientes com erros padrão robustos
  * Testes de Sargan, Wald, AR(1) e AR(2)

#### Gráficos de Efeitos Marginais:

* **Gap Previsto vs. Juros Reais**: para diferentes níveis de CBI
* **Gap Previsto vs. CBI**: para diferentes níveis de juros reais

---

### 💻 Tecnologias Utilizadas

* **Linguagem**: `R`
* **Principais Pacotes**:

  * Manipulação: `tidyverse`, `labelled`, `countrycode`, `readxl`
  * Visualização: `ggplot2`, `ggrepel`, `patchwork`, `viridis`, `paletteer`, `ggtext`
  * Dados Internacionais: `WDI`, `imf.data`, `sidrar`
  * Econometria: `plm`, `rugarch`, `mFilter`
  * Tabelas: `gt`, `gtExtras`
  * Mapas: `rnaturalearth`, `sf`

---

### ▶️ Como Reproduzir

1. **Instale os Pacotes Relevantes**

   ```R
   install.packages(c("tidyverse", "plm", "WDI", "rnaturalearth", ...)) # e demais listados
   ```

2. **Garanta os Arquivos no Diretório Local**:

   * `CBIDta.xlsx`
   * `InflationForecast(FMI).xlsx`
   * `rate_macrobond.xlsx`
   * `target(macrobond).xlsx`
   * `target(eikon).xlsx`

3. **Execute o Script `PEE.R` no RStudio**

   * O código carrega, limpa, processa, estima e visualiza os dados automaticamente

4. **Explore os Resultados**

   * Tabelas GMM, gráficos descritivos e análise visual

5. **Visualização Interativa (opcional)**

   * Relatório HTML disponível em: [ver aqui](https://raw.githack.com/Hic-Tayfour/HTML/refs/heads/main/PEE.html)

---

Atenciosamente,
**Hicham Munir Tayfour**

