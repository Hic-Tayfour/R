## APS 2 - Produtos Orgânicos (Estatística II | 2023.2)

### Objetivo do Trabalho

Este projeto analisa se diferentes textos motivadores afetam a **disposição a pagar por produtos orgânicos**, com base em respostas de questionário aplicado nas turmas da disciplina.

A análise envolve:

- Limpeza e padronização das respostas
- Cálculo de estatísticas descritivas
- Comparações entre grupos de texto
- Avaliação de diferenças por sexo, idade e escolaridade
- Visualizações para apoiar a interpretação dos resultados

---

### Estrutura do Projeto

- `APS 2 2023_2.R`
  Script principal com importação, limpeza, estatísticas e gráficos.

- `APS2023_2(1).xlsx`
  Base de dados utilizada no trabalho.

---

### Base de Dados

A base contém respostas individuais do questionário. As principais variáveis são:

- `Texto`: tipo de texto motivacional
- `P1`: valor máximo que o respondente pagaria pela embalagem orgânica
- `P2`: nível de concordância com a frase apresentada
- `P3`: sexo
- `P4`: idade
- `P5`: escolaridade

---

### Metodologia

Foram aplicadas correções e padronizações nas respostas, incluindo:

- Tratamento de respostas textuais não numéricas
- Conversão de valores inválidos para `NA`
- Uniformização de categorias de concordância, sexo e escolaridade
- Remoção de observações inválidas para as análises principais

As análises incluem:

- Preço médio disposto a pagar
- Comparações entre textos
- Comparações por sexo e escolaridade
- Relação entre idade e preço
- Associação entre texto e resposta de opinião

---

### Resultados Gerados

O script produz:

- Tabelas descritivas
- Histogramas
- Boxplots
- Gráficos de dispersão
- Gráficos de barras
- Comparações visuais entre grupos

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `readxl`
  - `DescTools`
  - `moments`
  - `DT`
  - `ggplot2`

---

### Como Reproduzir

1. Mantenha `APS2023_2(1).xlsx` no mesmo diretório do script.

2. Execute:

   ```r
   source("APS 2 2023_2.R")
   ```

3. O código retorna tabelas e gráficos para interpretação dos padrões observados.

---

### Conclusão

O trabalho usa ferramentas descritivas para investigar se o texto apresentado aos respondentes está associado a diferenças na disposição a pagar por produtos orgânicos. A interpretação é principalmente exploratória e visual.

Atenciosamente,
**Hicham Munir Tayfour**
