## APS 2 - Economia do Gênero e Bem-Estar Subjetivo (Microeconomia IV | 2024.2)

### Objetivo do Trabalho

Este projeto investiga como valores sociais associados a normas de gênero se relacionam com o bem-estar subjetivo, medido por uma variável binária de felicidade.

A análise utiliza dados da **World Values Survey (WVS)** e modelos de variável dependente binária.

---

### Estrutura do Projeto

- `APS 2 - Bloco 2.R`
  Script principal com tratamento da base, estatísticas descritivas, visualizações e regressões.

- `APS 2 - Bloco 2.qmd`
  Relatório em Quarto com narrativa, código e resultados.

- `wvs_world.zip`
  Base de dados da World Values Survey utilizada no trabalho.

---

### Fundamentação Teórica

O trabalho parte de modelos de identidade de gênero, com destaque para a ideia de que prescrições sociais sobre papéis masculinos e femininos podem afetar o bem-estar subjetivo.

A hipótese econômica é que valores mais tradicionais de gênero estão associados a menor probabilidade de relatar felicidade, especialmente quando há conflito entre identidade, normas sociais e escolhas individuais.

---

### Base de Dados

A base contém dados individuais da World Values Survey. As principais variáveis incluem:

- Indicador binário de felicidade
- `Q32`: concordância com a ideia de que ser dona de casa é tão satisfatório quanto trabalhar
- `Q33`: concordância com prioridade masculina no emprego
- `Q29`: concordância com homens como melhores líderes políticos
- Idade
- Gênero
- Estado civil
- Peso amostral

---

### Metodologia

A análise inclui:

- Recodificação da variável de felicidade
- Construção de indicadores de normas de gênero
- Estatísticas descritivas ponderadas
- Gráficos de barras e distribuições
- Modelos Logit e Probit com `svyglm()`
- Cálculo e interpretação de efeitos marginais
- Comparação dos modelos estimados

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `dplyr`
  - `stargazer`
  - `gt`
  - `survey`
  - `sandwich`
  - `lmtest`
  - `ggplot2`
  - `ggthemes`
  - `margins`
  - `readxl`

---

### Como Reproduzir

1. Mantenha `wvs_world.zip` no diretório do projeto.

2. Execute:

   ```r
   source("APS 2 - Bloco 2.R")
   ```

3. Para renderizar o relatório:

   ```r
   quarto::quarto_render("APS 2 - Bloco 2.qmd")
   ```

---

### Conclusão

O projeto aplica modelos binários para avaliar a associação entre normas de gênero e felicidade declarada. A análise combina fundamentação microeconômica, estatísticas ponderadas e regressões, mantendo interpretação associativa.

Atenciosamente,
**Hicham Tayfour**
