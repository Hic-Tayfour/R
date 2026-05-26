## 📘 APS 3 — Economia da Educação e Experimentos (Microeconomia IV - Insper)

### 🎯 Objetivo do Trabalho
Investigar se a formação dos professores (especificamente, possuir mestrado) modera o efeito do tamanho das turmas no desempenho dos alunos em Língua Portuguesa, com base nos dados experimentais do Projeto STAR (Student-Teacher Achievement Ratio).

---

### 📊 Base de Dados: Projeto STAR
- Coorte de alunos do Tennessee (EUA), alocados aleatoriamente em:
  - **Small**: Turmas pequenas (13–17 alunos)
  - **Regular**: Turmas regulares (22–25 alunos)
  - **Aide**: Turmas regulares com assistente
- Variável dependente: `readscore` (nota em português)
- Variável de moderação: `tchmasters` (professor com mestrado)

---

### 🧪 Etapas da Análise

#### **Etapa I — Teoria Econômica**
- A hipótese microeconômica parte do pressuposto de que **professores com maior formação acadêmica potencializam os efeitos positivos de turmas menores** sobre o desempenho dos alunos.

#### **Etapa II — Estatísticas Descritivas**
- Foram calculadas:
  - Média, mínimo, máximo e desvio padrão do `readscore`
  - Proporção de professores com mestrado em cada tipo de turma
- Resultados apresentados em tabela customizada com `gt`.

#### **Etapa III — Regressão Múltipla**
- Modelo linear estimado:

  $$
  \text{readscore}_i = \beta_0 + \beta_1 \cdot \text{small}_i + \beta_2 \cdot \text{regular}_i + \beta_3 \cdot \text{tchmasters}_i + \beta_4 (\text{small}_i \times \text{tchmasters}_i) + \beta_5 (\text{regular}_i \times \text{tchmasters}_i) + \epsilon_i
  $$

- Resultados apresentados com `stargazer`.

#### **Etapa IV — Efeitos Fixos de Escola**
- Adição de 78 dummies para controlar heterogeneidade entre escolas (`factor(schid)`).
- Teste de significância conjunta via `anova()`.

#### **Etapa V — Verificação da Aleatorização**
- Estimado um **modelo de probabilidade linear (LPM)** para verificar se a alocação em turmas pequenas (`small`) depende de características observáveis.
- Variáveis incluídas: gênero (`boy`), raça, merenda gratuita (`freelunch`) e cor do professor (`tchwhite`).

---

### 📈 Visualizações
- **Gráfico de densidade** da variável `readscore`, por tipo de turma.
- **Boxplot** comparativo entre os grupos.

---

### 💻 Tecnologias Utilizadas
- Linguagem: **R**
- Pacotes: `tidyverse`, `gt`, `stargazer`, `ggplot2`, `survey`, `lmtest`, `margins`

---

### ▶️ Como Executar
1. Salve o arquivo `Star.dta` no mesmo diretório do script.
2. Execute o script `APS3_script.R` em um ambiente R com os pacotes instalados.
3. Verifique a saída dos gráficos e tabelas, que serão exibidos no console.

Atenciosamente,
Hicham Tayfour
