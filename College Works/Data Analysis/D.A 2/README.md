## Data Analysis 2 - Internações por Causas Externas

### Objetivo do Trabalho

Esta atividade analisa dados de internações por causas externas para avaliar se houve alteração entre **2021** e **2022** em uma amostra de capitais.

O objetivo central é aplicar ferramentas de inferência estatística para comparar os anos e testar se a diferença observada é estatisticamente relevante.

---

### Estrutura do Projeto

- `Análise da Dados 2.R`
  Script principal em R com estatísticas descritivas, intervalos de confiança e teste de hipótese.

- `Internacoes_causas_externas(1).xlsx`
  Base de dados utilizada na atividade.

---

### Base de Dados

A base contém observações por capital e valores de internações para os anos de 2021 e 2022.

O script cria a variável de diferença:

$$
\text{dif} = \text{Ano 2022} - \text{Ano 2021}
$$

---

### Metodologia

A análise inclui:

- Média e desvio padrão para 2021 e 2022
- Intervalos de confiança para médias e desvios
- Cálculo da diferença entre anos
- Teste t para a diferença média
- Interpretação da estatística de teste

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `readxl`
  - `moments`

---

### Como Reproduzir

1. Mantenha `Internacoes_causas_externas(1).xlsx` no mesmo diretório do script.

2. Execute:

   ```r
   source("Análise da Dados 2.R")
   ```

3. O código retorna estatísticas, intervalos e testes para comparação entre 2021 e 2022.

---

### Conclusão

O projeto aplica inferência estatística básica para comparar internações entre dois anos. A variável de diferença permite transformar a análise em um problema de teste sobre mudança média entre 2021 e 2022.

Atenciosamente,
**Hicham Tayfour**
