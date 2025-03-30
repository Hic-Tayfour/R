## 📘 APS 1 — Economia do Crime e Dados em Painel (Microeconomia IV - Insper)

### 🎯 Objetivo do Trabalho
Analisar o impacto das **leis Right-to-Carry (RTC)** sobre a taxa de crimes contra a propriedade nos estados norte-americanos, utilizando modelos de dados em painel entre 1977 e 2014.

---

### 📊 Base de Dados
- **Base1_APS1.dta**: presença das leis RTC por estado e ano.
- **Base2_APS1.dta**: taxas de criminalidade por estado.
- **Base3_APS1.dta**: variáveis explicativas (desemprego, densidade populacional, etc.).

As três bases foram unificadas via `merge()` pelas variáveis `state` e `year`.

---

### 🧪 Etapas da Análise

#### **Etapa I — Teoria Econômica**
- Fundamento teórico com base em **Song & Hao (2022)** e **He & Barkowski (2020)**.
- A teoria do criminoso racional sugere que o comportamento criminal depende do **custo esperado do crime** (risco de punição, encarceramento, etc.).
- Hipótese econômica: **A adoção de leis RTC não reduz — e pode até aumentar — as taxas de crimes contra a propriedade**, ao gerar externalidades indesejadas.

#### **Etapa II — Estatísticas Descritivas**
- Tabela `gt` com:
  - Média, mínimo, máximo e desvio padrão das variáveis `ln_property_rate`, `ln_incarc_rate`, `unemployment_rate` e `density`.
- Cálculo da média da taxa de crimes antes e depois das leis RTC.

#### **Etapa III — Visualizações**
- **Boxplot**: distribuição da taxa de crimes antes e depois das leis RTC.
- **Gráfico de dispersão**: relação entre taxa de encarceramento e taxa de crimes, com linha de regressão.

#### **Etapa IV — Estimações com Dados em Painel**
- Modelos estimados com `plm()`:
  - **Pooled OLS**
  - **Efeitos Fixos (within)**
  - **Efeitos Aleatórios (random)**
- Regressão estimada:

  $$
  \text{ln\_property\_rate}_{it} = \beta_0 + \beta_1 \cdot \text{RTC}_{it} + \beta_2 \cdot \ln(\text{incarc\_rate}_{it}) + \beta_3 \cdot \text{unemployment}_{it} + \beta_4 \cdot \text{density}_{it} + \epsilon_{it}
  $$

- Resultados organizados com `stargazer()`.

#### **Etapa V — Escolha do Modelo**
- Aplicação do **Teste de Hausman** (`phtest`) entre efeitos fixos e aleatórios.
- Discussão sobre identificação e causalidade com base em heterogeneidade entre estados e tempo.

---

### 💻 Tecnologias Utilizadas
- Linguagem: **R**
- Pacotes: `plm`, `gt`, `stargazer`, `haven`, `ggplot2`, `dplyr`, `tidyverse`, `sandwich`

---

### ▶️ Como Executar
1. Salve os arquivos `Base1_APS1.dta`, `Base2_APS1.dta` e `Base3_APS1.dta` no mesmo diretório do script.
2. Execute o script `APS1_script.R` em um ambiente R com os pacotes instalados.
3. A saída inclui:
   - Tabela descritiva formatada
   - Gráficos de comparação
   - Modelos econométricos e testes estatísticos

Atenciosamente,  
Hicham Tayfour
