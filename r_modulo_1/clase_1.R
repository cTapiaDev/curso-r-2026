# install.packages("tidyverse")
# install.packages("lubridate")
# install.packages("data.table")
# install.packages("microbenchmark")

library(tidyverse)
library(lubridate)
library(data.table)
library(microbenchmark)


# Ingesta de datos masiva
# Esto es una descarga de datos desde un .csv de la red
url_datos <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
datos_crudos <- read_csv(url_datos, show_col_types = FALSE)

catalogo_regiones <- tibble(
  continent = unique(na.omit(datos_crudos$continent)),
  riesgo_operativo = c("Alto", "Medio", "Bajo", "Alto", "Medio", "Bajo")
)

# Cruce de información con left_join
datos_enriquecidos <- datos_crudos |>
  filter(!is.na(continent)) |>
  left_join(catalogo_regiones, by = "continent")

# Transformación estructural (pivot_langer)
datos_largos <- datos_enriquecidos |>
  select(iso_code, location, date, continent, riesgo_operativo, total_cases, total_deaths, icu_patients) |>
  pivot_longer(
    cols = c(total_cases, total_deaths, icu_patients),
    names_to = "tipo_metrica",
    values_to = "valor_metrica"
  )

# Limpieza múltiple (across) y estandarización temporal (lubridate)
datos_limpios <- datos_largos |>
  mutate(
    date = ymd(date),
    across(valor_metrica, \(x) replace_na(x, 0))
  )


# Comparativa de rendimiento
dt_limpios <- as.data.table(datos_limpios)

comparativa <- microbenchmark(
  dplyr_test = datos_limpios |>
    group_by(continent, tipo_metrica) |>
    summarise(total = sum(valor_metrica, na.rm = FALSE), .groups = "drop"),
  
  data.table_test = dt_limpios[, .(total = sum(valor_metrica, na.rm = TRUE)), by = .(continent, tipo_metrica)],
  
  times = 20
)

print(comparativa)
