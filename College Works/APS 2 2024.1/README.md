## 📘 APS — Econometria (Insper | 2024.2)

### 🎯 Objetivo do Trabalho
Investigar, por meio de análise exploratória e preparação para modelos econométricos, a relação entre **criminalidade (homicídios)** e variáveis socioeconômicas nos estados norte-americanos, com foco especial na influência da **licença obrigatória para posse de armas** (`Lice`).

A análise compara estatísticas, distribuições e correlações entre estados **com** e **sem exigência de licença**.

---

### 📂 Base de Dados

- Arquivo: `APS econo.xlsx`  
- Unidade de análise: Estados norte-americanos  
- Variáveis analisadas:

| Variável | Descrição |
|----------|-----------|
| `State`  | Nome do estado |
| `Hom`    | Homicídios por 100 mil habitantes |
| `Guns`   | Armas por 100 mil habitantes |
| `IpC`    | PIB per capita |
| `Urb`    | Taxa de urbanização (%) |
| `Poli`   | Policiais por 100 mil habitantes |
| `Gini`   | Índice de Gini (desigualdade) |
| `Lice`   | Licença obrigatória para armas (0 = não exige, 1 = exige) |

---

### 📊 Etapas da Análise

#### 1. 📈 Análise Exploratória Geral
- Estatísticas descritivas: média, mediana, máximo, mínimo, variância, desvio padrão.
- Correlação entre variáveis quantitativas.
- Histogramas e boxplots para visualização das distribuições.
- Identificação de **outliers** por variável.

#### 2. 🧪 Separação por Licença (`Lice`)
- Criação de duas bases: com e sem exigência de licença.
- Estatísticas descritivas separadas para cada grupo.
- Comparações visuais (boxplots, histogramas) entre os grupos.

#### 3. 🔁 Transformação Logarítmica
- Cálculo do logaritmo natural (ln) das variáveis quantitativas.
- Criação de nova base (`Ln_Dados`) para análises com possíveis relações não-lineares.
- Matrizes de dispersão e correlação com variáveis em log.

#### 4. 🌀 Análise de Dispersão
- Gráficos de dispersão entre `Hom` e todas as outras variáveis, com e sem transformação logarítmica.
- Avaliação visual da direção e força das relações.

#### 5. 🗺️ Mapa de Calor
- Mapa dos EUA com preenchimento proporcional à taxa de homicídios por estado.
- Visualização espacial da criminalidade.

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Bibliotecas:
  - `tidyverse`, `ggplot2`, `gridExtra`, `GGally`, `readxl`, `DescTools`, `DT`, `maps`

---

### ▶️ Como Executar

1. Coloque o arquivo `APS econo.xlsx` no mesmo diretório do script R.
2. Execute o script no RStudio com os pacotes instalados.
3. O código gera:
   - Tabelas interativas com `DT`
   - Histogramas, boxplots e dispersões
   - Mapa temático da taxa de homicídios
   - Análises segmentadas por política de licenciamento

---

Atenciosamente,  
Hicham Tayfour
