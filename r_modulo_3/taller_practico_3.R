library(tidyverse)
library(scales)

set.seed(123)
datos_taller_3 <- tibble(
  id_alumno = 1:60,
  asignatura = sample(c("Matemática", "Lenguaje", "Ciencias"), 60, replace = TRUE),
  horas_estudio = round(runif(60, min = 1, max = 15), 1),
  nota_prueba = round(runif(60, min = 2.0, max = 7.0), 1)
)

datos_taller_3$nota_prueba[sample(1:60, 3)] <- NA

# ==============================================================================
# 🟢 EJERCICIO 1: EL PASO PREVIO (Resumir antes de graficar barras)
# ==============================================================================
# Contexto: Dirección quiere un gráfico de barras con el promedio de cada asignatura.
# Tarea: Crea una tabla resumen usando group_by y summarise. 
# ¡Cuidado con los alumnos que faltaron (NA)! Usa na.rm = TRUE.



# ==============================================================================
# 🟢 EJERCICIO 2: TU PRIMER GRÁFICO DE BARRAS
# ==============================================================================
# Contexto: Ya tenemos la tabla resumen, ahora hay que pintarla.
# Tarea: Usa ggplot con geom_col(). Pon la asignatura en el eje X y el promedio en el eje Y.
# Dale color de relleno (fill) según la asignatura.



# ==============================================================================
# 🟢 EJERCICIO 3: DIAGNÓSTICO INDIVIDUAL (Dispersión)
# ==============================================================================
# Contexto: Queremos saber si estudiar más horas realmente mejora la nota.
# Tarea: 1. Filtra los alumnos que faltaron (!is.na).
# 2. Haz un gráfico de puntos (geom_point) con horas en el eje X y notas en el eje Y.



# ==============================================================================
# 🟢 EJERCICIO 4: EL TOQUE GERENCIAL
# ==============================================================================
# Contexto: El gráfico anterior tiene todos los puntos mezclados.
# Tarea: Toma el gráfico anterior y agrégale facet_wrap() para separar por asignatura.
# Además, aplica el formato chileno a las notas del eje Y usando scale_y_continuous().