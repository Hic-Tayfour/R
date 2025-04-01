## 📘 Trabalho Final — Construção de Hospitais & Mortalidade Infantil (Microeconomia IV | 2024.2)

### 🎯 Objetivo do Trabalho

Avaliar se a construção de hospitais nas microrregiões da saúde impacta a taxa de mortalidade infantil no Brasil, entre 2014 e 2019.

A análise envolve:
- Construção teórica baseada no modelo de demanda por saúde (Grossman, 1972)
- Tratamento e integração de microdados do DataSUS e IBGE
- Geração de estatísticas e visualizações geográficas
- Estimativa de efeitos causais com Staggered Difference-in-Differences (DiD)

---

### 📂 Estrutura dos Dados

- **Mortalidade Infantil** (`SIM-DOINF`)  
- **Natalidade Infantil** (`SINASC`)  
- **Estabelecimentos de Saúde (Hospitais)** (`CNES-ST`)  
- **PIB per capita e Geolocalização** (IBGE: `PIB.xls`, `CADMUN.xls`)  

Após o tratamento, os dados foram agregados por **microrregião da saúde** e **ano**.

---

### 🧼 Limpeza e Padronização

- Conversão e filtragem de datas (óbito/nascimento)
- Codificação e tratamento de variáveis categóricas (sexo, tipo de parto, escolaridade, etc.)
- Integração dos datasets por `MICROCOD` e `ano`
- Cálculo da **taxa de mortalidade infantil**:  
  \[
  \text{Taxa} = \frac{\text{Óbitos de menores de 1 ano}}{\text{Nascidos vivos}} \times 1000
  \]
- Cálculo da **variação no número de hospitais** por microrregião

---

### 📊 Análises Descritivas

#### 📌 Mortalidade Infantil:
- Hexágonos geográficos por ano (2014–2019)
- Gráficos de violino e linha
- Estatísticas descritivas: média, mínimo, máximo, desvio-padrão

#### 📌 Natalidade:
- Mesma estrutura analítica da mortalidade infantil

#### 📌 Hospitais:
- Evolução do número de hospitais
- Microrregiões que receberam novos hospitais
- Análise da criação de unidades por ano

#### 📌 Taxa de Mortalidade Infantil:
- Cálculo da razão mortalidade/natalidade
- Visualizações: mapas, violinos e linha
- Comparação ao longo do tempo (2014–2019)

---

### 🔍 Análises Específicas

#### 1. **Modelo Microeconômico (Grossman, 1972)**
- Pais maximizam utilidade com restrição orçamentária
- Construção de hospitais reduz custo de acesso (`p_M`) → aumento do investimento em saúde infantil → redução da mortalidade

#### 2. **Estratégia Empírica: Staggered DiD (Callaway & Sant’Anna, 2021)**
- Estima o efeito da construção de hospitais em momentos distintos nas microrregiões
- Controla para:
  - Efeitos fixos regionais e temporais
  - Tendências paralelas e não-antecipação
- Comparações feitas apenas com regiões ainda não tratadas no ano de análise

#### 3. **Resultados**
- Efeitos médios do tratamento **não estatisticamente significativos**
- **Hipótese nula não rejeitada**: construção de hospitais **não apresenta evidência robusta de redução na taxa de mortalidade infantil** no período analisado

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Bibliotecas: `tidyverse`, `microdatasus`, `sf`, `did`, `fixest`, `patchwork`, `ggplot2`, `gt`, `readxl`, `stargazer`, entre outras

---

### ▶️ Como Reproduzir

1. Importar os dados do repositório GitHub do grupo
2. Executar o script `TrabFinalMicro.R` para:
   - Baixar, carregar e tratar os dados
   - Gerar as análises descritivas
   - Estimar os efeitos com DiD escalonado
3. Analisar os resultados via gráficos e tabelas geradas

---

Atenciosamente,  
**Hicham Munir Tayfour**  
