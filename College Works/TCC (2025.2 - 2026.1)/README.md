## Trabalho de Conclusão de Curso - Predição Conformal Aplicada à Estimação do Efeito de Tratamento Individual (TCC | 2025.2 - 2026.1)

### Objetivo do Trabalho

Este projeto aplica **Predição Conformal Ponderada** (*Weighted Conformal Prediction - WCP*) à estimação de incerteza do **Efeito de Tratamento Individual (ITE)**.

A ideia central é tratar a inferência causal contrafactual como um problema de predição sob **deslocamento de covariadas**, usando o **Escore de Propensão (PS)** para reponderar os resíduos de calibração e construir intervalos com validade marginal em amostras finitas.

A análise combina:

- Simulações controladas com Processos Geradores de Dados (DGPs)
- Comparação entre PS conhecido e PS estimado
- Aplicações reais nas bases **STAR** e **HI**
- Modelos flexíveis de Machine Learning como motores preditivos
- Avaliação do trade-off entre validade estatística e utilidade prática

---

### Estrutura do Projeto

- `1- Lei Candes - PS Know(4 dgps).R`  
  Simulações com DGPs sintéticos usando **Escore de Propensão conhecido**.

- `2- Lei Candes - PS Unknow(4 dgps).R`  
  Simulações com DGPs sintéticos usando **Escore de Propensão estimado** via Random Forest.

- `3-  Lei Candes - Star.R`  
  Aplicação empírica na base **STAR Tennessee**, experimento educacional sobre tamanho de sala e desempenho em matemática.

- `4- Lei Candes - HI.R`  
  Aplicação empírica na base **Health Insurance (HI)**, estudo observacional sobre seguro-saúde do cônjuge e horas trabalhadas por esposas.

---

### Fundamentação Teórica

O trabalho parte do arcabouço de **resultados potenciais** de Neyman-Rubin. Para cada indivíduo, existem dois resultados potenciais:

$$
Y_i(1) \quad \text{e} \quad Y_i(0)
$$

Como apenas um deles é observado, a estimação do ITE exige prever o contrafactual não observado:

$$
ITE_i = Y_i(1) - Y_i(0)
$$

Modelos de Machine Learning conseguem produzir boas previsões pontuais, mas normalmente não oferecem **quantificação de incerteza rigorosa em amostras finitas**. A Predição Conformal resolve essa lacuna ao construir intervalos com garantia **distribution-free**, isto é, sem depender da especificação correta da distribuição dos dados.

Em dados observacionais, porém, tratados e controles podem ter distribuições diferentes de covariadas. A WCP corrige esse problema usando pesos baseados no escore de propensão:

$$
w(x) = \frac{e(x)}{1-e(x)}
$$

---

### Simulações com DGPs

Os scripts de simulação implementam quatro Processos Geradores de Dados:

1. **DGP 1 - HMC / Carvalho Seminário**  
   Cenário com efeito constante e forte risco de falta de sobreposição.

2. **DGP 2 - HMC Complex / Carvalho Paper**  
   Estrutura com covariadas mistas, interação não linear e tratamento com viés de seleção.

3. **DGP 3 - Hahn / YoungStats**  
   Superfície altamente não linear, com efeito heterogêneo variando em torno de zero.

4. **DGP 4 - Lei & Candès (2020)**  
   DGP de referência com deslocamento de covariadas moderado e CATE não linear.

Cada simulação separa as amostras em treino, calibração e teste, com foco em prever o contrafactual \(Y(0)\) para indivíduos tratados.

---

### Bases Reais

#### **STAR Tennessee**
- Base: `star`, pacote `mlmRev`
- Tratamento: aluno em turma pequena (`cltype == "small"`)
- Variável de interesse: nota de matemática (`math`)
- Contexto: experimento randomizado em educação

#### **HI - Health Insurance**
- Base: `HI`, pacote `Ecdat`
- Tratamento: presença de seguro-saúde do cônjuge (`hhi == "yes"`)
- Variável de interesse: horas trabalhadas por semana (`whrswk`)
- Contexto: estudo observacional sujeito a forte viés de seleção

---

### Modelos Avaliados

A camada conformal é comum a todos os modelos. Os algoritmos abaixo funcionam como motores para prever o contrafactual:

- **Random Forest**
- **Quantile Regression Forest (QRF)**
- **Bayesian Additive Regression Trees (BART)**
- **Random Forest Normalizada**
- **CatBoost Quantílico**

---

### Métricas de Avaliação

Os scripts consolidam os resultados em `metricas_consolidadas`, com:

- **Cobertura do ITE real**  
  Proporção de intervalos que contêm o verdadeiro efeito individual nas simulações.

- **Cobertura do zero**  
  Proporção de intervalos que cruzam zero, indicando inconclusão sobre o sinal do efeito.

- **Proporção de intervalos infinitos**  
  Mede degeneração dos intervalos sob falha de suporte comum.

- **Largura média dos intervalos**  
  Mede eficiência e utilidade prática dos intervalos conformais.

---

### Principais Resultados

As simulações mostram que a WCP preserva validade marginal quando as hipóteses de reponderação são plausíveis. No DGP de Lei & Candès, a cobertura fica próxima do nível nominal de 90%, com intervalos finitos e estáveis.

Por outro lado, em cenários com **violação de positividade** e baixa sobreposição entre tratados e controles, os pesos baseados no PS podem se tornar instáveis. Nesses casos, o método preserva a garantia de cobertura ao custo de intervalos muito largos ou infinitos.

Nas aplicações reais:

- A base **STAR** apresenta maior estabilidade, com intervalos finitos e sem degeneração relevante.
- A base **HI** evidencia a limitação prática da WCP: mesmo com baixa proporção pontual de intervalos infinitos, a largura média pode divergir para infinito por causa da falta de suporte comum.

A principal conclusão é que a WCP funciona melhor como uma ferramenta de **auditoria da incerteza causal** do que como um método que sempre entrega intervalos individualmente úteis.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `ranger`
  - `dbarts`
  - `catboost`
  - `mlmRev`
  - `Ecdat`
  - `MASS`
  - `scales`
  - `showtext`
  - `systemfonts`
  - `labelled`

---

### Como Reproduzir

1. Instale os pacotes necessários no R.

2. Execute os scripts na ordem desejada:

   ```r
   source("1- Lei Candes - PS Know(4 dgps).R")
   source("2- Lei Candes - PS Unknow(4 dgps).R")
   source("3-  Lei Candes - Star.R")
   source("4- Lei Candes - HI.R")
   ```

3. Nos scripts de simulação, altere o objeto `dgp` para escolher o processo gerador:

   ```r
   dgp <- dgp1
   dgp <- dgp2
   dgp <- dgp3
   dgp <- dgp4
   ```

4. Os códigos retornam:
   - Intervalos conformais para o ITE
   - Gráficos com amostras de 30 indivíduos
   - Métricas consolidadas por modelo
   - Diagnósticos de cobertura, inconclusão e largura dos intervalos

---

### Conclusão

Este TCC mostra que a Predição Conformal Ponderada é uma abordagem rigorosa para quantificar incerteza em inferência causal individual. A metodologia preserva validade marginal sob deslocamento de covariadas, mas sua utilidade prática depende fortemente da qualidade do suporte comum, da estimação do escore de propensão e da magnitude do efeito em relação ao ruído.

Atenciosamente,  
**Hicham Munir Tayfour**
