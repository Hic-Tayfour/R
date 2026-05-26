## APS 3 - Inferência sobre Produtos Orgânicos (Estatística II | 2023.2)

### Objetivo do Trabalho

Este projeto investiga, por meio de técnicas inferenciais, se diferentes tipos de texto influenciam a **disposição a pagar por produtos orgânicos** e se há associação entre o texto lido e a opinião declarada pelos respondentes.

A análise aprofunda o estudo da APS anterior, adicionando testes estatísticos e discussão metodológica sobre as suposições utilizadas.

---

### Estrutura do Projeto

- `APS 3 2023.2.R`
  Script principal com estatísticas descritivas, gráficos e testes inferenciais.

- `APS2023_2_FASE_3.xlsx`
  Base de dados utilizada no trabalho.

---

### Base de Dados

A base contém respostas de questionário sobre produtos orgânicos. As variáveis centrais são:

- `P1`: preço máximo que o respondente pagaria
- `P2`: opinião ou nível de concordância
- Texto lido: grupo de exposição ao Texto 1 ou Texto 2

---

### Fundamentação Metodológica

O trabalho compara grupos de respondentes que receberam textos diferentes. A pergunta central é se a diferença de estímulo textual se reflete em diferenças de disposição a pagar e em diferenças na distribuição das opiniões.

Como a coleta não é probabilística, a análise discute explicitamente as limitações de inferência para a população geral.

---

### Metodologia

A análise inclui:

- Estatísticas descritivas de `P1`
- Histogramas e curvas de densidade
- Boxplots comparativos
- Teste de Jarque-Bera para normalidade
- Teste F para comparação de variâncias
- Teste t para diferença de médias
- Teste qui-quadrado de homogeneidade para associação entre texto e resposta `P2`
- Discussão sobre amostragem, independência e validade inferencial

---

### Principais Resultados

Os resultados indicam diferenças estatísticas entre os grupos de texto na disposição a pagar. Também foi identificada associação entre o texto lido e a distribuição das respostas de opinião.

Apesar disso, a interpretação é condicionada pelas limitações da coleta, especialmente a ausência de amostragem probabilística.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `readxl`
  - `DescTools`
  - `moments`
  - `DT`

---

### Como Reproduzir

1. Mantenha `APS2023_2_FASE_3.xlsx` no mesmo diretório do script.

2. Execute:

   ```r
   source("APS 3 2023.2.R")
   ```

3. O código retorna tabelas, gráficos e testes estatísticos.

---

### Conclusão

O projeto combina estatística descritiva e inferencial para avaliar diferenças entre grupos expostos a textos distintos. A análise encontra evidências de associação, mas ressalta que a validade externa é limitada pelo método de coleta.

Atenciosamente,
**Hicham Tayfour**
