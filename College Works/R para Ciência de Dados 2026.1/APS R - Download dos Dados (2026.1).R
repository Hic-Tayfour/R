library(tidyverse)
library(janitor)
library(arrow)

options(timeout = 300)

ano      <- 2023
base_vra <- "https://siros.anac.gov.br/siros/registros/diversos/vra"
url_aero <- "https://siros.anac.gov.br/siros/registros/aerodromo/aerodromos.csv"
url_rab  <- "https://www.gov.br/anac/pt-br/sistemas/rab/base_dados_rab.csv"

baixar <- function(url, dest) {
  if (!file.exists(dest))
    download.file(url, dest, mode = "wb", method = "libcurl", quiet = TRUE)
  invisible(dest)
}

ler_csv_anac <- function(path, pular_linhas = 0) {
  read_delim(
    path,
    delim          = ";",
    locale         = locale(encoding = "latin1"),
    col_types      = cols(.default = col_character()),
    skip           = pular_linhas,
    show_col_types = FALSE
  ) |> clean_names()
}

vra_raw <- map(1:12, function(mes) {
  fname <- sprintf("VRA_%d_%02d.csv", ano, mes)
  baixar(sprintf("%s/%d/%s", base_vra, ano, fname), fname)
  ler_csv_anac(fname)
}) |> list_rbind()

write_parquet(vra_raw, "flights.parquet")
file.remove(list.files(pattern = "^VRA_\\d{4}_\\d{2}\\.csv$"))

baixar(url_aero, "aerodromos.csv")
write_parquet(ler_csv_anac("aerodromos.csv"), "airports.parquet")
file.remove("aerodromos.csv")

baixar(url_rab, "rab.csv")
write_parquet(ler_csv_anac("rab.csv", pular_linhas = 1), "planes.parquet")
file.remove("rab.csv")

read_parquet("airports.parquet") |> glimpse()
read_parquet("flights.parquet") |> glimpse()
read_parquet("planes.parquet") |> glimpse()
