## APS 1 - Economia do Crime e Dados em Painel (Microeconomia IV | 2024.2)

### Objetivo do Trabalho

Este projeto analisa o impacto das leis **Right-to-Carry (RTC)** sobre crimes contra a propriedade nos estados norte-americanos entre 1977 e 2014.

O objetivo é avaliar se a adoção dessas leis está associada a mudanças nas taxas de criminalidade, utilizando modelos de dados em painel.

---

### Estrutura do Projeto

- `APS 1 - Bloco 1.R`
  Script principal com tratamento das bases, estatísticas descritivas, gráficos e modelos de painel.

- `APS 1 - Bloco 1.qmd`
  Relatório em Quarto com narrativa, código e resultados.

- `Base1_APS1.dta`
  Base com presença das leis RTC por estado e ano.

- `Base2_APS1.dta`
  Base com taxas de criminalidade por estado.

- `Base3_APS1.dta`
  Base com variáveis explicativas, como encarceramento, desemprego e densidade populacional.

---

### Fundamentação Teórica

O trabalho parte da teoria econômica do crime, segundo a qual o comportamento criminal depende do custo esperado do crime. A adoção de leis RTC pode alterar incentivos ao modificar riscos percebidos, externalidades e condições de segurança.

A hipótese discutida é que a adoção de leis RTC não necessariamente reduz crimes contra a propriedade e pode produzir efeitos ambíguos ou indesejados.

---

### Base de Dados

As três bases são integradas por `state` e `year`, formando um painel estadual ao longo do tempo.

As principais variáveis incluem:

- Taxa de crimes contra a propriedade
- Indicador de lei RTC
- Taxa de encarceramento
- Taxa de desemprego
- Densidade populacional
- Estado e ano

---

### Metodologia

A análise inclui:

- União das três bases
- Criação de variáveis em log
- Estatísticas descritivas antes e depois da adoção das leis
- Boxplots e gráficos de dispersão
- Estimação de modelos `plm`
- Pooled OLS
- Efeitos fixos
- Efeitos aleatórios
- Teste de Hausman para escolha de modelo
- Discussão sobre identificação e causalidade

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `haven`
  - `plm`
  - `tidyverse`
  - `dplyr`
  - `gt`
  - `pastecs`
  - `fastDummies`
  - `stargazer`
  - `ggthemes`
  - `sandwich`

---

### Como Reproduzir

1. Mantenha as bases `.dta` no mesmo diretório do script.

2. Execute:

   ```r
   source("APS 1 - Bloco 1.R")
   ```

3. Para renderizar o relatório:

   ```r
   quarto::quarto_render("APS 1 - Bloco 1.qmd")
   ```

---

### Conclusão

O trabalho usa dados em painel para discutir a relação entre leis RTC e crimes contra a propriedade. A análise combina teoria econômica, estatísticas descritivas e modelos econométricos, destacando a importância de controlar heterogeneidade entre estados e tempo.

Atenciosamente,
**Hicham Tayfour**
