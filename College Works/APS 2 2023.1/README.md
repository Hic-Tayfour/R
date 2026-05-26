## APS 2 - Sucesso de Músicas em Plataformas Digitais (Estatística I | 2023.1)

### Objetivo do Trabalho

Este projeto corresponde ao segundo trabalho de Estatística I da graduação. A análise explora uma base de músicas para investigar características associadas ao desempenho em plataformas digitais, com foco em variáveis relacionadas ao **YouTube** e ao **Spotify**.

O objetivo é aplicar estatística descritiva para compreender distribuições, outliers, diferenças entre gêneros musicais e possíveis padrões nas variáveis disponíveis.

---

### Estrutura do Projeto

- `Aps 2.R`
  Script principal em R com importação da base, estatísticas descritivas, tabelas e gráficos.

- `aps2_v2clean.xlsx`
  Base de dados utilizada no trabalho.

---

### Base de Dados

A base contém informações de músicas e artistas, incluindo variáveis como duração, gênero musical e demais métricas disponíveis no arquivo original.

---

### Metodologia

A análise inclui:

- Estatísticas descritivas para a variável `Duration_ms`
- Cálculo de quartis, média, mediana, amplitude, desvio padrão e coeficiente de variação
- Identificação de valores aberrantes
- Avaliação de assimetria
- Comparações por gênero musical
- Visualizações com boxplots, histogramas e curvas de densidade

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `readxl`

---

### Como Reproduzir

1. Mantenha o arquivo `aps2_v2clean.xlsx` no mesmo diretório do script.

2. Execute o script:

   ```r
   source("Aps 2.R")
   ```

3. O código retorna tabelas estatísticas e gráficos exploratórios.

---

### Conclusão

O trabalho aplica os fundamentos de estatística descritiva a uma base musical, permitindo avaliar distribuição, dispersão e diferenças entre grupos. A análise serve como exercício inicial de exploração de dados em R.

Atenciosamente,
**Hicham Tayfour**
