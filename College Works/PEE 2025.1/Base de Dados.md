# Base de Dados Trabalho Final

```{R}
# Links diretos para download dos arquivos da pasta Data (PEE 2025.1)
github_files <- c(
  "https://github.com/Hic-Tayfour/R/raw/main/College%20Works/PEE%202025.1/Data/CBIDta.xlsx",
  "https://github.com/Hic-Tayfour/R/raw/main/College%20Works/PEE%202025.1/Data/InflationForecast(FMI).xlsx",
  "https://github.com/Hic-Tayfour/R/raw/main/College%20Works/PEE%202025.1/Data/target(eikon).xlsx",
  "https://github.com/Hic-Tayfour/R/raw/main/College%20Works/PEE%202025.1/Data/target(macrobond).xlsx"
)

# Nomes locais dos arquivos
local_files <- c(
  "CBIDta.xlsx",
  "InflationForecast(FMI).xlsx",
  "target(eikon).xlsx",
  "target(macrobond).xlsx"
)

# Loop para baixar os arquivos
for (i in seq_along(github_files)) {
  download.file(github_files[i], destfile = local_files[i], mode = "wb")
  message(paste("Arquivo", local_files[i], "baixado com sucesso."))
}
```