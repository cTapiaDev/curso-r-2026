# ==============================================================================
# 🟢 Bootcamp R - Módulo II: Taller Práctico 2
# 🟢 Orquestación de Reportes de Aviación y Workflows
# ==============================================================================

library(tidyverse)
library(lubridate)

# 🟢 SETUP PREVIO: Ejecutar para simular la fragmentación de archivos en servidores
dir.create("servidor_aeropuertos", showWarnings = FALSE)
dataset_base <- read_csv("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv", show_col_types = FALSE)

unique(dataset_base$origin) |> 
  walk(\(origen) {
    dataset_base |> 
      filter(origin == origen) |> 
      write_csv(paste0("servidor_aeropuertos/reporte_", str_to_lower(origen), "_2014.csv"))
  })

# ------------------------------------------------------------------------------
# 🟢 Fase 1: Escaneo de Servidor
# Genera un vector con las rutas absolutas de todos los CSV que se acaban 
# de crear en la carpeta 'servidor_aeropuertos'.
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# 🟢 Fase 2: Ingesta Iterativa Vectorizada
# Usa map_df() para leer todos los archivos simultáneamente. 
# Adentro, usa select() para cargar solo: origin, dest, carrier, distance, air_time.
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# 🟢 Fase 3: Creación de Función de Negocio (Abstracción)
# Crea una función llamada 'auditar_vuelos' que reciba un dataframe.
# 1. Crea 'velocidad_promedio' (distance / air_time).
# 2. Usa if_else() para 'ruta_larga' (Verdadero si distance > 1000).
# 3. Usa case_when() para 'eficiencia': 
#    - Si velocidad_promedio > 7 y ruta_larga es TRUE -> "Optima"
#    - Si velocidad_promedio < 4 -> "Deficiente"
#    - .default = "Normal"
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# 🟢 Fase 4: Ejecución del Pipeline
# Pasa tu dataframe consolidado por la tubería, filtra los vuelos del 
# carrier "AA", y aplícale tu nueva función 'auditar_vuelos'.
# ------------------------------------------------------------------------------