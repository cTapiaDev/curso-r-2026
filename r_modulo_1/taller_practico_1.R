# ==============================================================================
# Bootcamp R - Módulo I: Programación y Manipulación Avanzada
# Taller Práctico 1: Limpieza, Transformación y Eficiencia
# ==============================================================================

# Preparación del Entorno (Ejecutar estas 3 líneas primero)
library(tidyverse)
library(lubridate)
library(data.table)

# Automatización de Datos para el Taller
dir.create("datos_taller", showWarnings = FALSE)
write_csv(tibble(id_sucursal = 1:50, Q1_2025 = paste0("$", sample(1000:5000, 50)), Q2_2025 = paste0("$", sample(1000:5000, 50)), fecha_cierre = "15-04-2025"), "datos_taller/ventas_norte.csv")
write_csv(tibble(id_sucursal = 51:100, Q1_2025 = paste0("$", sample(1000:5000, 50)), Q2_2025 = paste0("$", sample(1000:5000, 50)), fecha_cierre = "2025/04/15"), "datos_taller/ventas_sur.csv")
catalogo_sucursales <- tibble(id_sucursal = 1:100, region = c(rep("Norte", 50), rep("Sur", 50)))

# ------------------------------------------------------------------------------
# 🟢 Fase 1: Programación Funcional
# Utiliza map_df() para leer todos los archivos CSV en la carpeta "datos_taller"
# y combinarlos en un único dataframe. 
# Recuerda forzar el tipo de la columna de fecha a carácter para evitar errores.
# ------------------------------------------------------------------------------

# Escribe tu código aquí...


# ------------------------------------------------------------------------------
# 🟢 Fase 2: Cruce de Datos Avanzado
# Cruza tu dataframe consolidado con el objeto 'catalogo_sucursales'
# utilizando un left_join() para incorporar la variable 'region'.
# ------------------------------------------------------------------------------

# Escribe tu código aquí...


# ------------------------------------------------------------------------------
# 🟢 Fase 3: Transformación Estructural
# Convierte el formato ancho (columnas Q1, Q2) a formato largo usando pivot_longer().
# ------------------------------------------------------------------------------

# Escribe tu código aquí...


# ------------------------------------------------------------------------------
# 🟢 Fase 4: Limpieza con across() y Fechas con lubridate
# 1. Remueve los símbolos "$" y "," de las ventas y conviértelas a numérico.
# 2. Estandariza la columna de fechas usando parse_date_time().
# ------------------------------------------------------------------------------

# Escribe tu código aquí...


# ------------------------------------------------------------------------------
# 🟢 Fase 5: Comparativa de Eficiencia
# Compara el tiempo de agrupación y suma de ventas por región y trimestre
# utilizando dplyr versus data.table. (Requiere paquete microbenchmark)
# ------------------------------------------------------------------------------

# Escribe tu código aquí...