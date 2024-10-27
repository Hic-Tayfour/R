# Base de Dados Trabalho Final

```{R}
# Links ajustados para download direto
onedrive_links <- c(
  "https://alinsperedu-my.sharepoint.com/personal/hichamt_al_insper_edu_br/_layouts/15/download.aspx?UniqueId=edn8umxftjdaor4ltvhopgabiqnniicvqcxlqunyamh2qg",
  "https://alinsperedu-my.sharepoint.com/personal/hichamt_al_insper_edu_br/_layouts/15/download.aspx?UniqueId=ebvazlzz7o1bvuuffmwqxecab2jvav3wusga6y_xedfpnra",
  "https://alinsperedu-my.sharepoint.com/personal/hichamt_al_insper_edu_br/_layouts/15/download.aspx?UniqueId=ectnwrhb7ftnrfp21llqtuwb2lulnlvqmq8_qy6vtyjjqy"
)

# Nome dos arquivos locais onde você quer salvar os arquivos RData
local_files_rdata <- c("ninf.Rdata", "minf.Rdata", "cnes.Rdata")

# Link direto para o arquivo CADMUN.xls no GitHub
cadmun_link <- "https://github.com/Hic-Tayfour/R/raw/main/College%20Works/Trabalho%20Final%20Micro%20IV/CADMUN.xls"
local_cadmun <- "CADMUN.xls"

# Loop para baixar os arquivos .Rdata
for (i in seq_along(onedrive_links)) {
  download.file(onedrive_links[i], destfile = local_files_rdata[i], mode = "wb")
  load(local_files_rdata[i])  # Carregar os arquivos RData baixados
  message(paste("Arquivo", local_files_rdata[i], "baixado e carregado com sucesso."))
}

# Baixar o arquivo CADMUN.xls do GitHub
download.file(cadmun_link, destfile = local_cadmun, mode = "wb")
message("Arquivo CADMUN.xls baixado com sucesso.")
```

