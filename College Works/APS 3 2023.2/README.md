## 📘 APS — Estatística II (Insper | 2023.2)

### 🎯 Objetivo do Trabalho
Investigar, por meio de **técnicas inferenciais**, se diferentes tipos de texto influenciam a **disposição a pagar por produtos orgânicos**, além de explorar relações entre as respostas e o conteúdo lido.

---

### 📂 Parte 1 — Efeito dos Textos sobre a Disposição a Pagar (P1)

- Base: `APS2023_2_FASE_3.xlsx`  
- Variável de interesse: `P1` (preço máximo que o respondente pagaria).
- Agrupamento: indivíduos que leram **Texto 1** vs. **Texto 2**.
- Técnicas utilizadas:
  - Estatísticas descritivas: média, mediana, moda, variância, desvio padrão e coeficiente de variação.
  - Visualizações: histogramas com curvas de densidade e boxplots comparativos.
  - Teste de **Jarque-Bera** para verificar normalidade.
  - **Teste de variância (F-test)** e **teste de média (t-test)**.
  
#### ✅ Conclusão
- As médias de preço (`P1`) foram estatisticamente diferentes entre os grupos.
- Conclui-se que **os textos influenciam a disposição a pagar** por produtos orgânicos.

---

### 📂 Parte 2 — Associação entre Texto e Opinião (P2)

- Variável de interesse: `P2` (opinião do respondente sobre incentivar o consumo).
- Categorias: 1 = Concordo, 2 = Indiferente, 3 = Discordo.
- Técnica utilizada: **Teste Qui-Quadrado de Homogeneidade**.

#### ✅ Conclusão
- Foi possível identificar uma **relação entre o texto lido e a resposta à P2**.
- A distribuição das respostas varia significativamente entre os grupos.

---

### 📂 Parte 3 — Verificação das Suposições

- Avaliação da normalidade (Jarque-Bera).
- Homogeneidade de variância (teste F).
- Discussão sobre:
  - Amostragem aleatória.
  - Independência das observações.
  - Implicações da violação das suposições nos testes inferenciais aplicados.

---

### 🧪 Parte 4 — Crítica ao Método de Coleta

- A coleta foi feita via questionário online e amostragem não aleatória.
- Implicações:
  - **Possível viés de seleção** e **limitação de inferência para a população geral**.
  - Testes paramétricos tornam-se **menos confiáveis** sob essas condições.

---

### 💻 Tecnologias Utilizadas

- Linguagem: **R**
- Bibliotecas:
  - `readxl`, `DescTools`, `moments`, `DT`

---

### ▶️ Como Executar

1. Coloque o arquivo `APS2023_2_FASE_3.xlsx` no diretório de trabalho.
2. Execute o script `.R` com os pacotes listados acima instalados.
3. O código gera:
   - Tabelas descritivas
   - Histogramas, boxplots e gráficos de setor
   - Testes estatísticos com conclusões interpretadas
  
4. ---

### 📊 Resultados Gerados

- Tabelas comparativas de estatísticas descritivas com `DT::datatable`.
- Visualizações:
  - Histogramas com curvas de densidade.
  - Boxplots para comparação entre textos.
  - Gráficos de setores e barras para análise da variável P2.
- Tabelas de proporções com visualização gráfica.
- Aplicação e interpretação dos testes:
  - Jarque-Bera (normalidade)
  - Teste F (homogeneidade de variância)
  - Teste t (diferença de médias)
  - Qui-quadrado de homogeneidade (associação entre variáveis categóricas)

---

### 📌 Observações Importantes

- Os testes de média e variância foram aplicados **mesmo com a normalidade violada**, apenas como referência.
- A coleta **não foi probabilística**, o que limita a validade inferencial para a população.
- A análise foi conduzida com **cuidado metodológico** e **interpretação crítica** dos resultados.

---

Atenciosamente,  
Hicham Tayfour

