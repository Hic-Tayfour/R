# Base de Dados Trabalho Final
## Natalidade Infantil (2014:2019)

download.file("https://alinsperedu-my.sharepoint.com/:u:/g/personal/hichamt_al_insper_edu_br/EYe5f-Gp1-ZFtLRn9l6k6OIBq3dZQjqv71bYatO81v8MbA?download=1", 
              tempfile(fileext = ".RData"), 
              mode = "wb")
              
load(tempfile(fileext = ".RData"))

## Mortalidade Infantil (2014:2019)

# Baixe o arquivo diretamente do OneDrive

download.file("https://alinsperedu-my.sharepoint.com/:u:/g/personal/hichamt_al_insper_edu_br/ES6Rf-Uk59dOnxL41S0CUTcBluaNCspfIkNiFStKgZucgg?download=1", 
              tempfile(fileext = ".RData"),
              mode = "wb")

load(tempfile(fileext = ".RData"))

# Verifique o conteúdo do arquivo carregado
ls()


## Estabelicimento de Saúde (2014:2019)

download.file("https://alinsperedu-my.sharepoint.com/:u:/g/personal/hichamt_al_insper_edu_br/EfyUyAGXriRCooXlzdAN_ZcBjHWhwZGN6mxg87x5X4EbTw?download=1", 
              tempfile(fileext = ".RData"), 
              mode = "wb")

load(tempfile(fileext = ".RData"))

