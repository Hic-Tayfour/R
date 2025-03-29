# Base de Dados Trabalho Final

```{R}
# Links ajustados para download direto do GitHub
github_links <- c(
  "https://github.com/Hic-Tayfour/DataBase-Repo/raw/main/MicroIV/minf.Rdata",
  "https://github.com/Hic-Tayfour/DataBase-Repo/raw/main/MicroIV/ninf.Rdata",
  "https://github.com/Hic-Tayfour/DataBase-Repo/raw/main/MicroIV/cnes.Rdata"
)

# Nome dos arquivos locais onde você quer salvar os arquivos RData
local_files_rdata <- c("minf.Rdata", "ninf.Rdata", "cnes.Rdata")

# Links para os arquivos .xls no GitHub
cadmun_link <- "https://github.com/Hic-Tayfour/DataBase-Repo/raw/main/MicroIV/CADMUN.xls"
pib_link <- "https://github.com/Hic-Tayfour/DataBase-Repo/raw/main/MicroIV/PIB%20Per%20Capita%20IBGE.xls"

# Nome dos arquivos locais onde você quer salvar os arquivos .xls
local_cadmun <- "CADMUN.xls"
local_pib <- "PIB Per Capita IBGE.xls"

# Loop para baixar os arquivos .Rdata
for (i in seq_along(github_links)) {
  download.file(github_links[i], destfile = local_files_rdata[i], mode = "wb")
  load(local_files_rdata[i])  # Carregar os arquivos RData baixados
  message(paste("Arquivo", local_files_rdata[i], "baixado e carregado com sucesso."))
}

# Baixar o arquivo CADMUN.xls do GitHub
download.file(cadmun_link, destfile = local_cadmun, mode = "wb")
message("Arquivo CADMUN.xls baixado com sucesso.")

# Baixar o arquivo PIB Per Capita IBGE.xls do GitHub
download.file(pib_link, destfile = local_pib, mode = "wb")
message("Arquivo PIB Per Capita IBGE.xls baixado com sucesso.")

```

