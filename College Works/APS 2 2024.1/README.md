## APS 2 - Criminalidade, Armas e Licenciamento (Econometria | 2024.1)

### Objetivo do Trabalho

Este projeto investiga a relação entre **criminalidade**, posse de armas e variáveis socioeconômicas nos estados norte-americanos, com foco na presença de licença obrigatória para posse de armas.

O objetivo é realizar uma análise exploratória e preparar a base para estudos econométricos posteriores.

---

### Estrutura do Projeto

- `APS 2 Econometria.R`
  Script principal com importação, estatísticas descritivas, visualizações, transformações e mapas.

- `APS econo.xlsx`
  Base de dados utilizada no trabalho.

---

### Base de Dados

A unidade de análise é o estado norte-americano. As principais variáveis são:

- `State`: estado
- `Hom`: homicídios por 100 mil habitantes
- `Guns`: armas por 100 mil habitantes
- `IpC`: PIB per capita
- `Urb`: urbanização
- `Poli`: policiais por 100 mil habitantes
- `Gini`: desigualdade
- `Lice`: indicador de licença obrigatória para armas

---

### Metodologia

A análise inclui:

- Estatísticas descritivas gerais
- Correlações entre variáveis quantitativas
- Histogramas e boxplots
- Identificação de outliers
- Separação da amostra por exigência de licença
- Transformações logarítmicas
- Matrizes de dispersão
- Mapa temático dos Estados Unidos

---

### Resultados Gerados

O script gera tabelas e gráficos para comparar estados com e sem exigência de licença, além de visualizações sobre a distribuição espacial e estatística da criminalidade.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `readxl`
  - `ggplot2`
  - `GGally`
  - `gridExtra`
  - `whitestrap`
  - `tseries`
  - `dplyr`
  - `tidyverse`
  - `moments`
  - `DescTools`
  - `DT`
  - `maps`

---

### Como Reproduzir

1. Mantenha `APS econo.xlsx` no mesmo diretório do script.

2. Execute:

   ```r
   source("APS 2 Econometria.R")
   ```

3. O código retorna tabelas, gráficos e diagnósticos exploratórios.

---

### Conclusão

O projeto organiza uma leitura exploratória da relação entre homicídios, armas e características socioeconômicas. A separação por licença obrigatória permite observar diferenças preliminares entre grupos de estados, sem ainda estabelecer interpretação causal.

Atenciosamente,
**Hicham Tayfour**
