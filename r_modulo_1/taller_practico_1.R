# ==============================================================================
# 🟢 Bootcamp R - Módulo I: Taller Práctico 1
# 🟢 Industria Aeronáutica: Limpieza, Transformación y Eficiencia
# ==============================================================================

# 🟢 Preparación del Entorno
library(tidyverse)
library(lubridate)
library(data.table)
library(microbenchmark)

# 🟢 Ingesta de datos masivos desde fuente externa (+250k filas)
url_vuelos <- "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
vuelos_crudos <- read_csv(url_vuelos, show_col_types = FALSE)

# 🟢 Catálogo paramétrico de aerolíneas para cruce
catalogo_aerolineas <- tibble(
  carrier = c("AA", "B6", "DL", "UA", "MQ", "EV"),
  tipo_aerolinea = c("Tradicional", "Low Cost", "Tradicional", "Tradicional", "Regional", "Regional")
)

# ------------------------------------------------------------------------------
# 🟢 Fase 1: Cruce de Datos (Enriquecimiento)
# Filtra los vuelos que tengan un 'carrier' válido (no nulo) y cruza la tabla 
# con 'catalogo_aerolineas' para heredar la columna 'tipo_aerolinea'.
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# 🟢 Fase 2: Transformación Estructural (Tidy Data)
# Selecciona las columnas: year, month, day, origin, dest, carrier, tipo_aerolinea, dep_delay, arr_delay.
# Luego, usa pivot_longer() para apilar 'dep_delay' y 'arr_delay' en una 
# nueva columna llamada 'tipo_retraso', y sus valores en 'minutos_retraso'.
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# 🟢 Fase 3: Limpieza Múltiple y Fechas
# 1. Usa make_date() de lubridate combinando year, month y day en una columna 'fecha'.
# 2. Usa across() con una función de flecha anónima para reemplazar los NA 
#    de 'minutos_retraso' por 0.
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# 🟢 Fase 4: Rendimiento Extremo (Benchmarking)
# Compara dplyr vs data.table agrupando por 'tipo_aerolinea' y 'tipo_retraso',
# calculando el promedio de 'minutos_retraso'. Ejecuta 20 iteraciones.
# ------------------------------------------------------------------------------