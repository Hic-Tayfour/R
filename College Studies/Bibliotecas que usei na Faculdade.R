# Leitura e Manipulação de Dados
library(readxl)         # Leitura de arquivos Excel (.xls, .xlsx) - https://cran.r-project.org/web/packages/readxl/readxl.pdf
library(haven)          # Leitura de arquivos SPSS, Stata, SAS - https://cran.r-project.org/web/packages/haven/haven.pdf
library(dplyr)          # Manipulação de dados (parte do tidyverse) - https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
library(tidyverse)      # Coleção de pacotes para manipulação e visualização de dados - https://cran.r-project.org/web/packages/tidyverse/tidyverse.pdf
library(fastDummies)    # Criação de variáveis dummy - https://cran.r-project.org/web/packages/fastDummies/fastDummies.pdf
library(arrow)          # Leitura/escrita eficiente com Apache Arrow - https://cran.r-project.org/web/packages/arrow/arrow.pdf
library(data.table)     # Manipulação eficiente de grandes volumes de dados - https://cran.r-project.org/web/packages/data.table/data.table.pdf
library(DBI)            # Interface genérica para bancos de dados - https://cran.r-project.org/web/packages/DBI/DBI.pdf
library(duckdb)         # Banco de dados embutido e eficiente - https://cran.r-project.org/web/packages/duckdb/duckdb.pdf
library(purrr)          # Programação funcional (ex: map, walk) - https://cran.r-project.org/web/packages/purrr/purrr.pdf
library(broom)          # Organização de resultados de modelos estatísticos - https://cran.r-project.org/web/packages/broom/broom.pdf
library(labelled)       # Manipulação de variáveis com rótulos - https://cran.r-project.org/web/packages/labelled/labelled.pdf

# Estatísticas Descritivas e Testes
library(DescTools)      # Ferramentas estatísticas para análises descritivas - https://cran.r-project.org/web/packages/DescTools/DescTools.pdf
library(moments)        # Cálculo de assimetria, curtose e normalidade - https://cran.r-project.org/web/packages/moments/moments.pdf
library(pastecs)        # Estatísticas descritivas detalhadas - https://cran.r-project.org/web/packages/pastecs/pastecs.pdf

# Modelagem e Testes Estatísticos
library(forecast)       # Modelagem de séries temporais - https://cran.r-project.org/web/packages/forecast/forecast.pdf
library(plm)            # Modelos de dados em painel - https://cran.r-project.org/web/packages/plm/plm.pdf
library(tseries)        # Testes de raiz unitária e séries temporais - https://cran.r-project.org/web/packages/tseries/tseries.pdf
library(lmtest)         # Testes estatísticos para modelos lineares - https://cran.r-project.org/web/packages/lmtest/lmtest.pdf
library(sandwich)       # Estimadores robustos para erros padrão - https://cran.r-project.org/web/packages/sandwich/sandwich.pdf
library(whitestrap)     # Teste de heterocedasticidade (White) - https://cran.r-project.org/web/packages/whitestrap/whitestrap.pdf
library(survey)         # Análise de amostras complexas - https://cran.r-project.org/web/packages/survey/survey.pdf
library(margins)        # Cálculo de efeitos marginais - https://cran.r-project.org/web/packages/margins/margins.pdf
library(fixest)         # Modelos com efeitos fixos e robustez - https://cran.r-project.org/web/packages/fixest/fixest.pdf
library(urca)           # Testes de raiz unitária e cointegração - https://cran.r-project.org/web/packages/urca/urca.pdf

# Diferenças em Diferenças
library(did)            # Modelos de diferenças em diferenças - https://cran.r-project.org/web/packages/did/did.pdf

# Visualização de Dados
library(ggplot2)        # Gráficos (parte do tidyverse) - https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf
library(ggthemes)       # Temas para personalização de gráficos - https://cran.r-project.org/web/packages/ggthemes/ggthemes.pdf
library(gridExtra)      # Combinação de múltiplos gráficos - https://cran.r-project.org/web/packages/gridExtra/gridExtra.pdf
library(ggpubr)         # Gráficos publicáveis - https://cran.r-project.org/web/packages/ggpubr/ggpubr.pdf
library(ggrepel)        # Rótulos que não se sobrepõem - https://cran.r-project.org/web/packages/ggrepel/ggrepel.pdf
library(patchwork)      # Composição de gráficos - https://cran.r-project.org/web/packages/patchwork/patchwork.pdf
library(RColorBrewer)   # Paletas de cores - https://cran.r-project.org/web/packages/RColorBrewer/RColorBrewer.pdf
library(ggdendro)       # Dendrogramas - https://cran.r-project.org/web/packages/ggdendro/ggdendro.pdf
library(GGally)         # Gráficos de pares (extensão do ggplot2) - https://cran.r-project.org/web/packages/GGally/GGally.pdf
library(gganimate)      # Animações com ggplot2 - https://cran.r-project.org/web/packages/gganimate/gganimate.pdf
library(ggstream)       # Visualização de dados temporais com áreas empilhadas - https://cran.r-project.org/web/packages/ggstream/ggstream.pdf
library(ggtext)         # Elementos de texto avançado - https://cran.r-project.org/web/packages/ggtext/ggtext.pdf
library(plotly)         # Gráficos interativos - https://cran.r-project.org/web/packages/plotly/plotly.pdf
library(viridis)        # Paletas de cores perceptualmente uniformes - https://cran.r-project.org/web/packages/viridis/viridis.pdf
library(CGPfunctions)   # Gráficos estatísticos aprimorados - https://cran.r-project.org/web/packages/CGPfunctions/CGPfunctions.pdf

# Séries Temporais e Financeiras
library(tidyquant)      # Integração tidyverse com dados financeiros - https://cran.r-project.org/web/packages/tidyquant/tidyquant.pdf
library(timetk)         # Manipulação e visualização de séries temporais - https://cran.r-project.org/web/packages/timetk/timetk.pdf
library(modeltime)      # Modelagem de séries temporais com ML - https://cran.r-project.org/web/packages/modeltime/modeltime.pdf
library(quantmod)       # Análise de séries financeiras - https://cran.r-project.org/web/packages/quantmod/quantmod.pdf
library(WDI)            # Dados do World Bank (Indicadores) - https://cran.r-project.org/web/packages/WDI/WDI.pdf
library(imf.data)       # Acesso aos dados do FMI - https://cran.r-project.org/web/packages/imf.data/imf.data.pdf
library(zoo)            # Manipulação de séries temporais indexadas - https://cran.r-project.org/web/packages/zoo/zoo.pdf
library(mFilter)        # Filtros para séries temporais (HP, BK, etc.) - https://cran.r-project.org/web/packages/mFilter/mFilter.pdf

# Machine Learning
library(tidymodels)     # Framework completo para ML - https://cran.r-project.org/web/packages/tidymodels/tidymodels.pdf
library(rsample)        # Amostragem e divisão de dados - https://cran.r-project.org/web/packages/rsample/rsample.pdf
library(ranger)         # Random Forest eficiente - https://cran.r-project.org/web/packages/ranger/ranger.pdf
library(rpart)          # Árvores de decisão - https://cran.r-project.org/web/packages/rpart/rpart.pdf
library(rpart.plot)     # Visualização de árvores - https://cran.r-project.org/web/packages/rpart.plot/rpart.plot.pdf
library(tree)           # Árvores de classificação e regressão - https://cran.r-project.org/web/packages/tree/tree.pdf
library(class)          # K-Nearest Neighbors - https://cran.r-project.org/web/packages/class/class.pdf
library(catboost)       # Gradient boosting da Yandex - https://catboost.ai/en/docs/concepts/r-quickstart
library(glmnet)         # LASSO, Ridge e Elastic Net - https://cran.r-project.org/web/packages/glmnet/glmnet.pdf
library(caret)          # Treinamento e validação cruzada - https://cran.r-project.org/web/packages/caret/caret.pdf
library(hdm)            # Double Machine Learning - https://cran.r-project.org/web/packages/hdm/hdm.pdf

# Tabelas e Relatórios
library(stargazer)      # Tabelas formatadas para regressão - https://cran.r-project.org/web/packages/stargazer/stargazer.pdf
library(gt)             # Tabelas elegantes com formatação - https://cran.r-project.org/web/packages/gt/gt.pdf
library(gtExtras)       # Extensões para o pacote gt - https://cran.r-project.org/web/packages/gtExtras/gtExtras.pdf
library(DT)             # Tabelas interativas - https://cran.r-project.org/web/packages/DT/DT.pdf
library(writexl)        # Exportar para Excel (.xlsx) - https://cran.r-project.org/web/packages/writexl/writexl.pdf
library(googlesheets4)  # Conectar ao Google Sheets - https://cran.r-project.org/web/packages/googlesheets4/googlesheets4.pdf

# Web Scraping e JSON
library(jsonlite)       # Manipulação de arquivos JSON - https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf
library(rvest)          # Web scraping com R - https://cran.r-project.org/web/packages/rvest/rvest.pdf
library(repurrrsive)    # Exemplos recursivos com listas - https://cran.r-project.org/web/packages/repurrrsive/repurrrsive.pdf

# Dados Públicos e Geográficos
library(microdatasus)   # Acesso a dados do SUS - https://cran.r-project.org/web/packages/microdatasus/microdatasus.pdf
library(sidrar)         # Acesso a dados do IBGE via API - https://cran.r-project.org/web/packages/sidrar/sidrar.pdf
library(rnaturalearth)  # Mapas geográficos e dados mundiais - https://cran.r-project.org/web/packages/rnaturalearth/rnaturalearth.pdf
library(sf)             # Dados espaciais e geográficos - https://cran.r-project.org/web/packages/sf/sf.pdf

# Conjuntos de Dados para Exemplos
library(palmerpenguins) # Dados de pinguins para análise - https://cran.r-project.org/web/packages/palmerpenguins/palmerpenguins.pdf
library(nycflights13)   # Dados de voos em NY - https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf
library(babynames)      # Nomes de bebês nos EUA - https://cran.r-project.org/web/packages/babynames/babynames.pdf
library(ISLR)           # Conjuntos de dados do livro ISLR - https://cran.r-project.org/web/packages/ISLR/ISLR.pdf
