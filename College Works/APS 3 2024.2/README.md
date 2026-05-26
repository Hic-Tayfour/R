## APS 3 - Economia da Educação e Projeto STAR (Microeconomia IV | 2024.2)

### Objetivo do Trabalho

Este projeto investiga se a formação dos professores, especificamente possuir mestrado, modera o efeito do tamanho das turmas no desempenho dos alunos.

A análise utiliza dados do **Projeto STAR (Student-Teacher Achievement Ratio)**, experimento educacional realizado no Tennessee.

---

### Estrutura do Projeto

- `APS 3 - Bloco 3.R`
  Script principal com tratamento da base, estatísticas descritivas, regressões e gráficos.

- `APS 3 - Bloco 3.qmd`
  Relatório em Quarto com narrativa, código e resultados.

- `Star.dta`
  Base de dados utilizada na análise.

---

### Fundamentação Teórica

O trabalho parte da hipótese de que professores com maior formação acadêmica podem potencializar os efeitos positivos de turmas menores sobre o desempenho dos alunos.

O desenho do Projeto STAR permite explorar uma base experimental, com alocação de alunos em diferentes tipos de turma.

---

### Base de Dados

A base contém informações sobre alunos, turmas, professores e desempenho escolar.

As variáveis centrais incluem:

- `readscore`: desempenho em leitura
- Tipo de turma: pequena, regular ou regular com assistente
- `tchmasters`: indicador de professor com mestrado
- Escola
- Características individuais dos alunos

---

### Metodologia

A análise inclui:

- Estatísticas descritivas por tipo de turma
- Proporção de professores com mestrado
- Regressão múltipla com interações
- Efeitos fixos de escola
- Teste de significância conjunta
- Modelo de probabilidade linear para verificar aleatorização
- Gráficos de densidade e boxplots

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
  - `haven`

---

### Como Reproduzir

1. Mantenha `Star.dta` no mesmo diretório do script.

2. Execute:

   ```r
   source("APS 3 - Bloco 3.R")
   ```

3. Para renderizar o relatório:

   ```r
   quarto::quarto_render("APS 3 - Bloco 3.qmd")
   ```

---

### Conclusão

O projeto combina teoria econômica da educação e análise empírica com dados experimentais. A estratégia avalia tanto efeitos médios quanto heterogeneidade associada à formação docente, incluindo controles por escola e verificação da aleatorização.

Atenciosamente,
**Hicham Tayfour**
