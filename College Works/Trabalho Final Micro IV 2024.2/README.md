## Trabalho Final - Construção de Hospitais e Mortalidade Infantil (Microeconomia IV | 2024.2)

### Objetivo do Trabalho

Este projeto avalia se a construção de hospitais nas microrregiões de saúde impactou a **taxa de mortalidade infantil** no Brasil entre 2014 e 2019.

A análise combina teoria microeconômica da demanda por saúde, microdados públicos e estimação de efeitos causais com Difference-in-Differences escalonado.

---

### Estrutura do Projeto

- `TrabFinMicroIV.R`
  Script principal com tratamento dos dados, estatísticas descritivas, visualizações e estimações.

- `Trabalho Final Microeconomia IV.qmd`
  Relatório em Quarto com narrativa, código e resultados.

- `Base de Dados.md`
  Documentação das bases utilizadas no projeto.

- `Data/`
  Pasta com bases locais do projeto.

---

### Fundamentação Teórica

O trabalho parte do modelo de demanda por saúde de **Grossman (1972)**. A construção de hospitais é interpretada como uma redução do custo de acesso a serviços de saúde, o que pode aumentar o investimento em saúde infantil e reduzir a mortalidade.

O mecanismo teórico central é:

$$
\text{Mais hospitais} \Rightarrow \text{menor custo de acesso} \Rightarrow \text{maior investimento em saúde} \Rightarrow \text{menor mortalidade infantil}
$$

---

### Base de Dados

O projeto integra bases públicas de mortalidade, natalidade, estabelecimentos de saúde e informações municipais:

- **SIM-DOINF**: óbitos infantis
- **SINASC**: nascidos vivos
- **CNES-ST**: estabelecimentos de saúde
- **IBGE**: PIB per capita e geolocalização

Após o tratamento, os dados são agregados por microrregião de saúde e ano.

---

### Metodologia

A análise inclui:

- Tratamento de microdados de mortalidade e natalidade
- Integração de bases por microrregião e ano
- Cálculo da taxa de mortalidade infantil
- Identificação de microrregiões que receberam novos hospitais
- Mapas e visualizações descritivas
- Estimação com Staggered Difference-in-Differences
- Discussão das hipóteses de tendências paralelas e não antecipação

---

### Principais Resultados

Os efeitos médios estimados não são estatisticamente significativos. Assim, no período analisado, não há evidência robusta de que a construção de hospitais tenha reduzido a taxa de mortalidade infantil nas microrregiões estudadas.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `rnaturalearth`
  - `microdatasus`
  - `RColorBrewer`
  - `patchwork`
  - `tidyverse`
  - `stargazer`
  - `ggthemes`
  - `readxl`
  - `ggpubr`
  - `fixest`
  - `purrr`
  - `broom`
  - `did`
  - `sf`
  - `gt`

---

### Como Reproduzir

1. Mantenha os arquivos de dados na pasta `Data/`.

2. Execute:

   ```r
   source("TrabFinMicroIV.R")
   ```

3. Para renderizar o relatório:

   ```r
   quarto::quarto_render("Trabalho Final Microeconomia IV.qmd")
   ```

---

### Conclusão

O trabalho mostra que a expansão de hospitais, no recorte analisado, não apresenta evidência estatística robusta de redução da mortalidade infantil. A análise reforça a importância de combinar teoria econômica, construção cuidadosa de base e estratégia empírica adequada para avaliar políticas públicas.

Atenciosamente,
**Hicham Munir Tayfour**
