# Leitura e Manipulação de Dados
library(readxl)      # Leitura de arquivos Excel (.xls, .xlsx) - https://cran.r-project.org/web/packages/readxl/readxl.pdf
library(haven)       # Leitura de arquivos de dados em formatos como SPSS, Stata e SAS - https://cran.r-project.org/web/packages/haven/haven.pdf
library(dplyr)       # Manipulação e tratamento de dados (parte do tidyverse) - https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
library(tidyverse)   # Conjunto de pacotes para manipulação e visualização de dados - https://cran.r-project.org/web/packages/tidyverse/tidyverse.pdf
library(fastDummies) # Criação de variáveis dummy (variáveis indicadoras) - https://cran.r-project.org/web/packages/fastDummies/fastDummies.pdf
library(arrow)       # Processamento de dados com Arrow e integração com formatos columnar - https://cran.r-project.org/web/packages/arrow/arrow.pdf
library(DBI)         # Interface para banco de dados - https://cran.r-project.org/web/packages/DBI/DBI.pdf
library(duckdb)      # Banco de dados embutido altamente eficiente - https://cran.r-project.org/web/packages/duckdb/duckdb.pdf
library(data.table)  # Manipulação eficiente de dados em grandes tabelas - https://cran.r-project.org/web/packages/data.table/data.table.pdf

# Estatísticas Descritivas e Testes
library(DescTools)   # Funções estatísticas e ferramentas para análises descritivas - https://cran.r-project.org/web/packages/DescTools/DescTools.pdf
library(moments)     # Teste de hipótese e análise de momentos (assimetria, curtose) - https://cran.r-project.org/web/packages/moments/moments.pdf
library(pastecs)     # Estatísticas descritivas detalhadas - https://cran.r-project.org/web/packages/pastecs/pastecs.pdf

# Modelagem e Testes Estatísticos
library(forecast)    # Modelagem de séries temporais - https://cran.r-project.org/web/packages/forecast/forecast.pdf
library(plm)         # Modelos de dados em painel - https://cran.r-project.org/web/packages/plm/plm.pdf
library(tseries)     # Análise de séries temporais e testes de raiz unitária - https://cran.r-project.org/web/packages/tseries/tseries.pdf
library(lmtest)      # Testes estatísticos para modelos lineares - https://cran.r-project.org/web/packages/lmtest/lmtest.pdf
library(sandwich)    # Estimativas robustas de covariância (usado em econometria) - https://cran.r-project.org/web/packages/sandwich/sandwich.pdf
library(whitestrap)  # Correção de heterocedasticidade (teste de White) - https://cran.r-project.org/web/packages/whitestrap/whitestrap.pdf
library(survey)      # Regressão logística para amostras complexas - https://cran.r-project.org/web/packages/survey/survey.pdf
library(margins)     # Cálculo de efeitos marginais em modelos de regressão - https://cran.r-project.org/web/packages/margins/margins.pdf
library(fixest)      # Modelos econométricos com correção de heterocedasticidade - https://cran.r-project.org/web/packages/fixest/fixest.pdf
library(urca)        # Testes de raiz unitária e cointegração - https://cran.r-project.org/web/packages/urca/urca.pdf
library(seasonal)    # Ajuste sazonal para séries temporais - https://cran.r-project.org/web/packages/seasonal/seasonal.pdf
library(did)         # Análise de impacto com modelos de diferenças em diferenças - https://cran.r-project.org/web/packages/did/did.pdf

# Visualização de Dados
library(ggplot2)     # Criação de gráficos (parte do tidyverse) - https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf
library(ggthemes)    # Temas para personalização de gráficos no ggplot2 - https://cran.r-project.org/web/packages/ggthemes/ggthemes.pdf
library(gridExtra)   # Combinação e organização de múltiplos gráficos em grid - https://cran.r-project.org/web/packages/gridExtra/gridExtra.pdf
library(GGally)      # Extensão do ggplot2 para matrizes de gráficos - https://cran.r-project.org/web/packages/GGally/GGally.pdf
library(maps)        # Ferramentas para criação de mapas - https://cran.r-project.org/web/packages/maps/maps.pdf
library(scales)      # Escalas personalizadas para gráficos - https://cran.r-project.org/web/packages/scales/scales.pdf
library(ggrepel)     # Rótulos de texto repelentes para gráficos - https://cran.r-project.org/web/packages/ggrepel/ggrepel.pdf
library(patchwork)   # Combinação de múltiplos gráficos em um único layout - https://cran.r-project.org/web/packages/patchwork/patchwork.pdf
library(RColorBrewer)# Paletas de cores para gráficos - https://cran.r-project.org/web/packages/RColorBrewer/RColorBrewer.pdf
library(ggdendro)    # Visualização de dendrogramas (árvores hierárquicas) - https://cran.r-project.org/web/packages/ggdendro/ggdendro.pdf
library(ggpubr)      # Publicação de gráficos e visualizações aprimoradas - https://cran.r-project.org/web/packages/ggpubr/ggpubr.pdf

# Relatórios e Tabelas
library(stargazer)     # Criação de tabelas formatadas para relatórios (especialmente para regressões) - https://cran.r-project.org/web/packages/stargazer/stargazer.pdf
library(gt)            # Criação de tabelas com formatação avançada - https://cran.r-project.org/web/packages/gt/gt.pdf
library(DT)            # Tabelas dinâmicas e interativas no R - https://cran.r-project.org/web/packages/DT/DT.pdf
library(writexl)       # Escrever dados em arquivos Excel (.xlsx) - https://cran.r-project.org/web/packages/writexl/writexl.pdf
library(googlesheets4) # Conectar e manipular planilhas do Google Sheets - https://cran.r-project.org/web/packages/googlesheets4/googlesheets4.pdf

# Machine Learning
library(tidymodels)  # Framework de machine learning (com funções para criar modelos, validação cruzada, etc.) - https://cran.r-project.org/web/packages/tidymodels/tidymodels.pdf
library(rsample)     # Divisão e reamostragem de dados (amostragem para treino e teste) - https://cran.r-project.org/web/packages/rsample/rsample.pdf
library(class)       # Algoritmo k-Nearest Neighbors (kNN) - https://cran.r-project.org/web/packages/class/class.pdf
library(tree)        # Árvores de decisão - https://cran.r-project.org/web/packages/tree/tree.pdf
library(ranger)      # Random Forest - https://cran.r-project.org/web/packages/ranger/ranger.pdf
library(MASS)        # Conjunto de funções estatísticas e regressão linear (e logística) - https://cran.r-project.org/web/packages/MASS/MASS.pdf
library(pROC)        # Curvas ROC e AUC (Avaliação de modelos classificadores) - https://cran.r-project.org/web/packages/pROC/pROC.pdf
library(ISLR)        # Conjunto de dados e funções para aprendizado de máquina - https://cran.r-project.org/web/packages/ISLR/ISLR.pdf
library(MCMCpack)    # Modelagem Bayesiana e análise MCMC - https://cran.r-project.org/web/packages/MCMCpack/MCMCpack.pdf
library(catboost)    # Algoritmo de gradient boosting para modelos de machine learning - https://catboost.ai/en/docs/concepts/r-quickstart

# Conjuntos de Dados e Exemplos
library(palmerpenguins)  # Conjunto de dados de pinguins para análise - https://cran.r-project.org/web/packages/palmerpenguins/palmerpenguins.pdf
library(nycflights13)    # Conjunto de dados de voos de Nova York - https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf
library(babynames)       # Conjunto de dados históricos de nomes de bebês nos EUA - https://cran.r-project.org/web/packages/babynames/babynames.pdf

# Web Scraping e Processamento de Dados
library(jsonlite)        # Leitura e manipulação de arquivos JSON - https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf
library(rvest)           # Web scraping (extração de dados da web) - https://cran.r-project.org/web/packages/rvest/rvest.pdf
library(repurrrsive)     # Conjuntos de dados e exemplos recursivos em listas no R - https://cran.r-project.org/web/packages/repurrrsive/repurrrsive.pdf
library(rnaturalearth)   # Conjunto de dados e mapas de países - https://cran.r-project.org/web/packages/rnaturalearth/rnaturalearth.pdf

# Séries Temporais e Análise Financeira
library(quantmod)        # Importação de dados financeiros e modelagem de séries temporais - https://cran.r-project.org/web/packages/quantmod/quantmod.pdf
library(timetk)          # Manipulação e visualização de séries temporais com foco em análises financeiras - https://cran.r-project.org/web/packages/timetk/timetk.pdf
library(modeltime)       # Modelagem e previsão de séries temporais com machine learning - https://cran.r-project.org/web/packages/modeltime/modeltime.pdf
library(tidyquant)       # Ferramentas para análise financeira e séries temporais - https://cran.r-project.org/web/packages/tidyquant/tidyquant.pdf

# Visualização Avançada
library(GWalkR)          # Integração com visualizações interativas - https://cran.r-project.org/web/packages/GWalkR/GWalkR.pdf

# Dados Públicos e Saúde
library(microdatasus)    # Acesso e manipulação de dados públicos de saúde no Brasil - https://cran.r-project.org/web/packages/microdatasus/microdatasus.pdf
library(sf)              # Manipulação de dados espaciais - https://cran.r-project.org/web/packages/sf/sf.pdf
