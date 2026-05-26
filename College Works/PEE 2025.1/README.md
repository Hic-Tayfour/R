## Trabalho de PEE - Independência do Banco Central e Política Monetária (2025.1)

### Objetivo do Trabalho

Este projeto investiga como o grau de **independência do Banco Central** afeta a potência da política monetária no controle da inflação.

A hipótese central é que maior independência institucional pode alterar a resposta do gap inflacionário à taxa real de juros, afetando a eficácia da política monetária.

---

### Estrutura do Projeto

- `PEE.R`
  Script principal com importação, tratamento, visualizações, construção do painel e estimações.

- `PEE.Rmd`
  Relatório em RMarkdown com narrativa, código e resultados.

- `Base de Dados.md`
  Documentação das bases utilizadas.

- `Data/`
  Pasta com arquivos locais de entrada.

---

### Base de Dados

A base final cobre países entre 2000 e 2023 e combina informações macroeconômicas e institucionais.

As principais fontes são:

- World Development Indicators
- IMF-IFS
- CBIDta.org
- MacroBond
- Eikon
- FMI
- Natural Earth

As variáveis centrais incluem:

- Índices de independência do Banco Central
- Inflação
- Taxa real de juros
- PIB e PIB potencial
- Hiato do produto
- Dívida pública
- Expectativas de inflação
- Metas de inflação
- Gap inflacionário

---

### Fundamentação Teórica

O trabalho se apoia em modelos Novo-Keynesianos e na literatura institucional sobre independência de Bancos Centrais.

A intuição é que Bancos Centrais mais independentes podem ter maior credibilidade, o que altera a transmissão da política monetária para expectativas, juros reais e inflação.

---

### Metodologia

A análise inclui:

- Importação de múltiplas fontes
- Padronização por país e ano
- Exclusão de agregados regionais e econômicos
- Harmonização de juros e metas de inflação
- Cálculo de PIB potencial com filtro HP
- Construção do hiato do produto
- Cálculo da taxa real de juros
- Construção do gap inflacionário
- Visualizações descritivas
- Modelos GMM dinâmicos com `plm::pgmm`
- Gráficos de efeitos marginais

---

### Visualizações Geradas

O projeto produz gráficos sobre:

- Cobertura de variáveis por país
- Mapas de cobertura
- Inflação média por grupo de independência
- Gap inflacionário por decil de CBI
- Evolução temporal dos índices de independência
- Indicadores macroeconômicos médios
- Densidades condicionais
- Reformas institucionais e inflação
- Efeitos marginais previstos

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `rnaturalearth`
  - `CGPfunctions`
  - `countrycode`
  - `tidyverse`
  - `tidyquant`
  - `gridExtra`
  - `patchwork`
  - `gganimate`
  - `ggeffects`
  - `labelled`
  - `ggthemes`
  - `seasonal`
  - `imf.data`
  - `gtExtras`
  - `ggstream`
  - `ggrepel`
  - `rugarch`
  - `stringr`
  - `viridis`
  - `mFilter`
  - `fixest`
  - `ggtext`
  - `plotly`
  - `readxl`
  - `sidrar`
  - `scales`
  - `broom`
  - `glue`
  - `zoo`
  - `WDI`
  - `plm`
  - `gt`
  - `sf`
  - `stargazer`

---

### Como Reproduzir

1. Mantenha os arquivos de entrada na pasta `Data/`.

2. Execute:

   ```r
   source("PEE.R")
   ```

3. Para renderizar o relatório:

   ```r
   rmarkdown::render("PEE.Rmd")
   ```

4. O código retorna painéis tratados, visualizações, modelos GMM e tabelas de resultados.

---

### Conclusão

O projeto estrutura uma base país-ano para investigar a relação entre independência do Banco Central e potência da política monetária. A análise combina teoria macroeconômica, construção de indicadores, visualizações descritivas e modelos dinâmicos em painel.

Atenciosamente,
**Hicham Munir Tayfour**
