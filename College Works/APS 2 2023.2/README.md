## 📘 APS — Produtos Orgânicos (Estatística 2 | 2023.2)

### 🎯 Objetivo do Trabalho

Analisar se diferentes textos motivadores impactam a disposição dos indivíduos em pagar mais por produtos orgânicos, com base em dados de questionário aplicado nas turmas A, B, C e D.

A análise envolve:
- Limpeza e padronização dos dados
- Cálculos descritivos (preço, idade, sexo, escolaridade)
- Análises comparativas entre grupos (texto, sexo, idade, escolaridade)
- Visualizações com histogramas, boxplots e gráficos de dispersão

---

### 📂 Estrutura dos Dados

- `Texto`: Tipo de texto motivacional (1 ou 2)
- `P1`: Valor máximo que o respondente pagaria pela embalagem orgânica
- `P2`: Nível de concordância com a frase
- `P3`: Sexo
- `P4`: Idade
- `P5`: Escolaridade

---

### 🧼 Limpeza e Padronização

Foram aplicadas correções em:
- Respostas textuais não numéricas (e.g., “Sim”, “Depende”, etc.)
- Valores nulos ou incorretos tratados como `NA`
- Uniformização dos campos P2 (concordância), P3 (sexo) e P5 (escolaridade)

Após o tratamento, os dados válidos foram integrados no objeto `resp`, com remoção dos `NA`.

---

### 📊 Análises Descritivas

#### 📌 Preço médio pago por produto orgânico:
- Calculado para toda a amostra
- Separado por texto, sexo e escolaridade

#### 📌 Idade média dos respondentes:
- Estatísticas básicas aplicadas à variável `P4`

#### 📌 Distribuições por Sexo:
- Homens, Mulheres, Não Declarados

#### 📌 Nível de Escolaridade:
- Até Ensino Fundamental
- Até Ensino Médio
- Pelo menos Ensino Superior

---

### 🔍 Análises Específicas

#### 1. **Efeito do Texto sobre a disposição a pagar (P1)**
- Preços comparados entre os grupos que leram Texto 1 e Texto 2
- Visualizações: histogramas e boxplots
- Resultados indicam diferenças visuais relevantes

#### 2. **Efeito do Sexo sobre a disposição a pagar**
- Preços comparados por sexo (Masculino, Feminino, Não Informado)
- Histogramas e boxplots gerados

#### 3. **Efeito da Escolaridade sobre a disposição a pagar**
- Grupos comparados: fundamental, médio e superior
- Distribuições comparadas visualmente

#### 4. **Relação entre Idade e Preço**
- Análise de correlação linear entre idade (P4) e preço (P1)
- Gráfico de dispersão com reta de regressão

#### 5. **Associação entre Texto e Resposta P2**
- Tabelas de contingência e proporções
- Comparações visuais com gráficos de barra
- Objetivo: verificar se o texto influencia a concordância com a frase

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes: `tidyverse`, `readxl`, `DescTools`, `moments`, `DT`, `ggplot2`, `base R`

---

### ▶️ Como Reproduzir

1. Importar os dados `APS_ProdutosOrgânicos_V6.xlsx`
2. Rodar os scripts de limpeza e padronização
3. Executar os trechos de análise descritiva e visualizações
4. Interpretar os resultados com base nos gráficos e comparações

---

Atenciosamente,  
**Hicham Munir Tayfour**
