## 📘 APS 2 — Economia do Gênero e Modelos de Variável Dependente Binária (Microeconomia IV - Insper)

### 🎯 Objetivo do Trabalho
Investigar como valores sociais associados a normas de gênero influenciam o bem-estar subjetivo, mensurado por uma variável binária de felicidade, com base nos dados da pesquisa **World Values Survey (WVS)**.

---

### 🌍 Base de Dados: World Values Survey
- Survey internacional com dados individuais de diversos países e ondas.
- Indicadores utilizados:
  - **Felicidade**: Pergunta "Taking all things together, would you say you are..."
    - Reclassificada como variável binária `happy_binary` (1 = feliz, 0 = não feliz).
  - **Normas de gênero**:
    - `Q32`: Ser dona de casa é tão satisfatório quanto trabalhar.
    - `Q33`: Homens devem ter prioridade de emprego.
    - `Q29`: Homens são melhores líderes políticos.
  - Outras variáveis: idade, gênero, estado civil, peso amostral.

---

### 🧪 Etapas da Análise

#### **Etapa I — Teoria Econômica**
- A investigação parte do modelo de identidade de gênero de **Akerlof e Kranton (2000)**, adaptado por **Chang (2011)**.
- Argumento: **Prescrições sociais sobre papéis de gênero moldam o bem-estar subjetivo**, especialmente para mulheres, ao criar conflitos entre identidade e comportamento.
- Hipótese econômica: **Valores mais tradicionais de gênero estão associados a menor probabilidade de relatar-se feliz.**

#### **Etapa II — Estatísticas Descritivas**
- Foram estimadas médias ponderadas para:
  - Distribuição de felicidade.
  - Concordância com frases normativas de gênero.
- Resultados apresentados em tabela `gt` e gráficos de barra por nível de felicidade.

#### **Etapa III — Regressões**
- Modelos estimados com base em desenho amostral (`svydesign`):
  - **Logit** e **Probit** com `svyglm()`.
  - Cálculo dos **efeitos marginais** com `svycontrast()`.
- Especificação:

  $$
  \text{happy}_i = \beta_0 + \beta_1 \cdot \text{housewife}_i + \beta_2 \cdot \text{priority}_i + \beta_3 \cdot \text{leaders}_i + \beta_4 \cdot \text{gender}_i + \beta_5 \cdot \text{age}_i + \beta_6 \cdot \text{marital}_i + \varepsilon_i
  $$

- Resultados comparados entre os modelos com `stargazer`.

---

### 📈 Visualizações
- Gráficos de barra:
  - Concordância com normas de gênero, por nível de felicidade.
- Histograma e densidade do sentimento de felicidade.

---

### 💻 Tecnologias Utilizadas
- Linguagem: **R**
- Pacotes: `tidyverse`, `survey`, `gt`, `ggplot2`, `stargazer`, `quasibinomial`, `svycontrast`

---

### ▶️ Como Executar
1. Baixe e salve o arquivo `wvs_world.csv` no mesmo diretório do script.
2. Execute o script `APS2_script.R` em um ambiente R com os pacotes listados.
3. Os outputs (gráficos, tabelas e modelos) serão exibidos diretamente no console.

Atenciosamente,  
Hicham Tayfour
