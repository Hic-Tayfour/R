## R para Ciência de Dados - Análise da Operação Aérea Brasileira (2026.1)

### Objetivo do Trabalho

Este projeto analisa a **operação aérea brasileira em 2023** a partir de microdados públicos da **Agência Nacional de Aviação Civil (ANAC)**, com foco em atrasos, cancelamentos, malha aérea, capacidade, frota e modelagem preditiva.

O objetivo central é diagnosticar o desempenho operacional da aviação brasileira a partir de dois desfechos distintos e complementares:

- **Atraso relevante de chegada**, definido como atraso superior a 15 minutos e calculado apenas entre voos realizados.
- **Cancelamento**, identificado pela situação do voo e analisado sobre toda a base de registros.

A análise combina:

- Tratamento e integração de bases públicas da ANAC
- Construção de indicadores operacionais de atraso e cancelamento
- Diagnóstico por companhia, aeroporto, rota, turno e mês
- Análise de malha, hubs, capacidade, distância e frota
- Modelagem supervisionada com **Random Forest**
- Clusterização de aeroportos com **K-Means**
- Visualizações e tabelas no estilo editorial inspirado em *The Economist*

---

### Estrutura do Projeto

- `APS R - Download dos Dados (2026.1).R`  
  Script responsável por baixar os dados públicos da ANAC, tratar a codificação dos arquivos CSV e salvar as bases em formato Parquet.

- `APS R (2026.1).R`  
  Script principal da análise, contendo tratamento das bases, criação dos indicadores, visualizações, modelagem e síntese executiva.

- `APS R (2026.1).Rmd`  
  Relatório em RMarkdown com narrativa analítica, códigos, tabelas, gráficos e interpretação dos resultados.

- `flights.parquet`  
  Base de voos da ANAC para 2023, construída a partir dos arquivos mensais de VRA.

- `airports.parquet`  
  Base de aeródromos utilizada para validação de chaves, nomes, localização e atributos geográficos.

- `planes.parquet`  
  Base do Registro Aeronáutico Brasileiro (RAB), utilizada para análise exploratória de frota.

---

### Base de Dados

O trabalho utiliza três bases principais:

#### **Voos - VRA / ANAC**

- Registros mensais de voos de 2023.
- Informações de companhia, origem, destino, horários previstos e reais, situação do voo, rota, tipo de linha e equipamento.
- Base final armazenada em `flights.parquet`.

#### **Aeródromos - ANAC**

- Informações cadastrais e geográficas dos aeroportos.
- Utilizada para validar aeroportos de origem e destino e enriquecer a análise espacial.
- Base final armazenada em `airports.parquet`.

#### **Frota - Registro Aeronáutico Brasileiro**

- Dados de aeronaves e modelos de equipamento.
- Utilizada de forma exploratória, pois a chave de integração com a base de voos tem cobertura parcial.
- Base final armazenada em `planes.parquet`.

Além das bases da ANAC, o relatório utiliza malhas geográficas do **IBGE**, via pacote `geobr`, e do **Natural Earth**.

---

### Fundamentação Analítica

O transporte aéreo é tratado como uma infraestrutura crítica para a integração econômica e territorial do Brasil. Atrasos e cancelamentos não são analisados apenas como inconvenientes individuais, mas como sinais de gargalos operacionais que podem se propagar pela malha, afetar conexões e elevar custos.

A separação entre atraso e cancelamento é uma decisão metodológica central:

- O **atraso** mede a piora de desempenho de um voo que foi realizado.
- O **cancelamento** representa a não realização do voo e deve ser analisado como um desfecho próprio.

Essa distinção evita misturar fenômenos operacionais diferentes em um único indicador agregado.

---

### Construção da Base Analítica

A base analítica é construída a partir das seguintes etapas:

- Importação dos arquivos mensais de VRA da ANAC.
- Padronização de nomes de colunas e codificação dos dados.
- Conversão de horários previstos e reais.
- Criação de indicadores de voo realizado, voo cancelado e atraso relevante.
- Validação das chaves de origem e destino com a base de aeroportos.
- Enriquecimento com nomes de aeroportos, coordenadas e informações de malha.
- Integração exploratória com a base de frota.

O diagnóstico inicial também documenta limitações de qualidade dos dados, como horários inconsistentes, justificativas incompletas e cobertura parcial da chave de frota.

---

### Definição dos Desfechos

#### **Atraso Relevante de Chegada**

O atraso relevante é definido como chegada mais de 15 minutos após o horário previsto:

$$
\text{Atraso Relevante} = \mathbb{1}(\text{atraso de chegada em minutos} > 15)
$$

Esse indicador é calculado apenas para voos realizados com informação válida de horário.

#### **Cancelamento**

O cancelamento é identificado a partir da situação do voo na base da ANAC. Diferentemente do atraso, ele é calculado sobre todos os registros, pois inclui voos que não chegaram a ser realizados.

---

### Etapas da Análise

A análise foi organizada em blocos temáticos:

1. **Base Analítica e Qualidade dos Dados**  
   Diagnóstico das bases, criação da base de voos, classificação metodológica e auditoria dos desfechos.

2. **Definição dos Desfechos de Performance**  
   Construção dos indicadores de atraso relevante, cancelamento e decomposição do atraso.

3. **Diagnóstico Geral da Operação em 2023**  
   Painel geral da operação, principais companhias, principais aeroportos, rotas mais voadas e sazonalidade mensal.

4. **Fatores Associados a Atrasos**  
   Distribuição dos atrasos, atraso relevante por companhia, aeroporto, turno, mês e combinação mês-turno.

5. **Fatores Associados a Cancelamentos**  
   Taxa geral de cancelamento, cancelamento por companhia, aeroporto e sazonalidade mensal.

6. **Malha, Rotas e Geografia**  
   Conectividade dos aeroportos, comparação entre hubs e demais aeroportos, distribuição geográfica e rotas críticas.

7. **Capacidade, Distância e Frota**  
   Capacidade ofertada, distância das rotas, perfil das maiores companhias, validação da chave de frota e idade aproximada dos equipamentos.

8. **Modelagem com Random Forest**  
   Previsão de atraso relevante de chegada com separação temporal entre treino e teste.

9. **Clusterização com K-Means**  
   Classificação de aeroportos por volume, conectividade e atraso médio de partida.

10. **Síntese Executiva**  
    Tabela final de KPIs por companhia, combinando volume, atraso, cancelamento, capacidade e contexto de malha.

---

### Modelagem Avaliada

#### **Random Forest**

O modelo supervisionado usa atraso relevante de chegada como variável-alvo. A separação entre treino e teste é temporal:

- **Treino**: voos de janeiro a setembro de 2023.
- **Teste**: voos de outubro a dezembro de 2023.

A base de modelagem inclui variáveis de companhia, origem, destino, tipo de linha, turno, mês, dia da semana, assentos e medidas de conectividade do aeroporto de origem.

O modelo foi estimado com `ranger`, usando 500 árvores e importância por impureza.

#### **K-Means**

A clusterização classifica aeroportos com base em:

- Volume de partidas
- Conectividade
- Atraso médio de partida

O objetivo é identificar grupos operacionais semelhantes, especialmente em termos de escala e desempenho.

---

### Métricas e Principais Resultados

A operação analisada possui grande escala:

- **958.546 voos** registrados
- **906.627 voos realizados**
- **51.357 voos cancelados**
- **118 companhias**
- **389 aeroportos de origem**
- **3.148 rotas**
- **148 milhões de assentos ofertados**

Os principais resultados indicam:

- O **atraso relevante** atinge aproximadamente **18,9%** dos voos realizados.
- A **taxa de cancelamento** é de aproximadamente **5,4%**.
- O atraso piora ao longo do dia operacional, com voos noturnos superando 20% de atraso relevante.
- O último trimestre apresenta maior incidência de atrasos, com pico próximo de 25% em outubro.
- O eixo paulista, especialmente Guarulhos, Congonhas, Viracopos e a rota Congonhas-Santos Dumont, tem peso desproporcional no resultado agregado por causa do alto volume de voos.
- Hubs e demais aeroportos têm atraso relevante parecido, mas cancelamentos bastante diferentes: cerca de **4,1%** nos hubs contra **12,2%** nos demais aeroportos.
- A análise de frota tem caráter exploratório, pois a chave `icao_tipo` cobre cerca de **63,7%** dos voos testados.

No modelo Random Forest:

- Acurácia: **0,786**
- Kappa: **0,082**
- Sensibilidade: **0,070**
- Especificidade: **0,986**
- AUC: **0,662**

O modelo é mais útil como ferramenta explicativa do que como classificador operacional final, pois identifica fatores associados ao atraso, mas apresenta baixa sensibilidade para detectar voos atrasados.

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `tidyverse`
  - `arrow`
  - `janitor`
  - `tidymodels`
  - `ranger`
  - `gt`
  - `gtExtras`
  - `geobr`
  - `sf`
  - `rnaturalearth`
  - `rnaturalearthdata`
  - `lubridate`
  - `scales`
  - `showtext`
  - `systemfonts`
  - `geosphere`
  - `labelled`
  - `stringi`

---

### Como Reproduzir

1. Instale os pacotes necessários no R.

2. Caso precise reconstruir as bases Parquet, execute:

   ```r
   source("APS R - Download dos Dados (2026.1).R")
   ```

3. Execute o script principal:

   ```r
   source("APS R (2026.1).R")
   ```

4. Para gerar o relatório completo, renderize o arquivo:

   ```r
   rmarkdown::render("APS R (2026.1).Rmd")
   ```

5. Os códigos retornam:
   - Bases tratadas em formato Parquet
   - Tabelas descritivas com `gt`
   - Gráficos no padrão visual inspirado em *The Economist*
   - Mapas e análises geográficas
   - Modelo Random Forest
   - Clusterização K-Means
   - Síntese final de KPIs por companhia

---

### Conclusão

A análise mostra que o desempenho da operação aérea brasileira em 2023 não pode ser resumido por um único indicador. A malha possui grande escala e heterogeneidade, e os desfechos de atraso e cancelamento seguem lógicas distintas.

O atraso relevante parece associado a fatores temporais, estrutura da malha e concentração de volume em determinados aeroportos e rotas. O cancelamento, por sua vez, aparece com maior intensidade em aeroportos internacionais de menor volume e em algumas companhias internacionais e cargueiras.

O Random Forest confirma o caráter associativo das evidências descritivas, destacando variáveis temporais e de estrutura da malha entre os fatores relevantes. Ainda assim, sua baixa sensibilidade indica que o modelo deve ser interpretado como instrumento de diagnóstico, não como solução operacional final.

As principais limitações do estudo são a ausência de justificativas completas para atrasos e cancelamentos, a presença de registros com horários inconsistentes e a cobertura parcial da base de frota. Extensões naturais incluem incorporar dados meteorológicos, informações de tráfego aéreo, modelagem de propagação de atrasos e tratamento específico do desbalanceamento da variável-alvo.

Atenciosamente,  
**Hicham Munir Tayfour**
