## 📘 Trabalho de PEE — Independência do BCB e a Potência da Política Monetária (Problemas em Economia | 2024.2)

### 🎯 Objetivo do Trabalho

Investigar como o grau de independência do Banco Central influencia a potência da política monetária, especialmente no controle da inflação, com foco no Brasil e comparações internacionais.

A análise envolve:
- Fundamentação teórica em modelos Novo-Keynesianos
- Construção de base de dados com indicadores macroeconômicos e institucionais
- Visualizações descritivas e exploratórias
- Avaliação empírica com base em correlações e classificações institucionais

---

### 📂 Estrutura dos Dados

- `cbie_index`: Índice de independência do Banco Central
- `inflation`: Inflação anual (World Bank)
- `real_rate`: Taxa de juros real
- `pib`, `pib_pot`, `hiato_pct`: PIB e hiato do produto com filtro HP
- `divida`: Dívida pública (% PIB)
- `inflation_forecast`: Expectativa de inflação (IMF)
- `target`: Lista de países com metas de inflação (e se ainda seguem)
- `acemoglu_classification`: Classificação institucional (Low, Medium, High)

---

### 🧼 Limpeza e Padronização

- Exclusão de agregados regionais
- Harmonização de códigos ISO2/ISO3 dos países
- Cálculo do hiato do produto e taxa de juros real
- Junção de bases com critérios de integridade temporal (desde 1990)
- Tratamento de dados ausentes e filtragem de países com cobertura suficiente

---

### 📊 Análises Descritivas

#### 📌 Evolução do CBI (1990–2023)
- Média anual do índice global
- Bandas de 1 desvio-padrão e identificação de outliers

#### 📌 Inflação global ao longo do tempo
- Comparações entre países com e sem metas de inflação
- Análise de outliers inflacionários por país e ano

#### 📌 Potência da política monetária
- Correlação entre juros reais e inflação por país
- Análise por classe institucional (Acemoglu et al., 2008)

#### 📌 Cobertura e qualidade dos dados
- Visualização da completude por variável e país
- Avaliação da consistência entre indicadores

#### 📌 Mapa Mundial do CBI
- Visualização geográfica da independência média dos BCs

---

### 🔍 Análises Específicas

#### 1. **Hipótese Econômica**
> Quanto maior o grau de independência do Banco Central, maior será a potência da política monetária no controle inflacionário (desde que haja mecanismos institucionais que reforcem a credibilidade e a consistência temporal das decisões).

#### 2. **Referencial Teórico**
- **Woodford (2003), Clarida, Galí & Gertler (1999):** Modelos NK, Regra de Taylor e consistência intertemporal
- **Jácome & Pienknagura (2022):** Papel das instituições na América Latina
- **Acemoglu et al. (2008):** "Efeito gangorra" e restrições políticas
- **Unsal & Papageorgiou (2023):** Índices compostos de independência formal/informal

#### 3. **Resultados Preliminares**
- Correlação negativa entre CBI e dispersão da inflação de longo prazo
- BCs mais independentes reagem mais fortemente aos desvios da inflação
- Países com instituições **fortes (High)** tendem a apresentar maior potência da política monetária

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes: `tidyverse`, `WDI`, `imf.data`, `ggplot2`, `gt`, `patchwork`, `sf`, `countrycode`, `mFilter`, `readxl`, `rnaturalearth`, entre outros

---

### ▶️ Como Reproduzir

1. Baixar as bases: CBIE, WDI, IMF, Natural Earth
2. Rodar o script `PEE.R` para:
   - Importar, tratar e integrar os dados
   - Gerar os gráficos e tabelas descritivas
3. Interpretar os resultados com base nos modelos teóricos e evidências empíricas

4. Programa executado [aqui](https://raw.githack.com/Hic-Tayfour/HTML/refs/heads/main/PEE.html )
---


Atenciosamente,  
**Hicham Munir Tayfour**  
