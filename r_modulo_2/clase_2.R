library(tidyverse)
library(lubridate)
library(purrr)

# Simulamos el entorno de un colegio.
set.seed(2026)

# Base principal de alumnos
alumnos_db <- tibble(
  id_alumno = 1:100,
  nombre = paste0("Estudiante_", 1:100),
  curso = sample(c("1ro Medio", "2do Medio", "3ro Medio"), 100, replace = TRUE),
  fecha_nacimiento = sample(seq(as.Date('2008-01-01'), as.Date('2011-12-31'), by="day"), 100),
  beca = sample(c(TRUE, FALSE), 100, replace = TRUE, prob = c(0.4, 0.6))
)

# Base de notas
notas_db <- tibble(
  id_alumno = 1:100,
  nota_matematica = round(runif(100, min = 3.0, max = 7.0), 1),
  nota_lenguaje = round(runif(100, min = 3.5, max = 7.0), 1),
  nota_ciencias = round(runif(100, min = 3.0, max = 7.0), 1)
)

# Forzamos 5 valores nulos aleatorios en matemáticas para limpieza posterior
notas_db$nota_matematica[sample(1:100, 5)] <- NA 

# ==============================================================================
# FUNDAMENTOS Y LÓGICA
# ==============================================================================

# Aislar registros y columnas específicas
alumnos_becados_1ro <- alumnos_db |>
  filter(curso == "1ro Medio", beca == TRUE) |>
  select(id_alumno, nombre, fecha_nacimiento)

alumnos_jovenes_3ro <- alumnos_db |>
  filter(curso == "3ro Medio", fecha_nacimiento > as.Date("2010-01-01"))

# ==============================================================================
# LÓGICA CONDICIONAL
# ==============================================================================

alumnos_evaluados <- alumnos_db |>
  mutate(
    # Condición simple
    estado_arancel = if_else(beca == TRUE, "Gratuidad", "Pago Mensual"),
    
    # Condición anidada
    ciclo_educativo = case_when(
      curso == "1ro Medio" | curso == "2do Medio" ~ "Ciclo Básico",
      curso == "3ro Medio" ~ "Ciclo Avanzado",
      .default = "No clasificado"
    )
    
    # Lógica AND (&)
    # TRUE & TRUE = TRUE
    # TRUE & FALSE = FALSE
    # FALSE & TRUE = FALSE
    # FALSE & FALSE = FALSE
    
    # Lógica OR (|)
    # TRUE | TRUE = TRUE
    # TRUE | FALSE = TRUE
    # FALSE | TRUE = TRUE
    # FALSE | FALSE = FALSE
    
    # Lógica Negación
    # !TRUE = FALSE
    # !FALSE = TRUE
  )


# ==============================================================================
# MANIPULACIÓN DE ESTRUCTURAS
# ==============================================================================

boletin_escolar <- alumnos_db |>
  left_join(notas_db, by = "id_alumno")

no_faltan_notas <- notas_db |>
  filter(!is.na(nota_matematica), !is.na(nota_lenguaje), !is.na(nota_ciencias))

# is.na(nota_matematica) = TRUE -> Me trae los alumnos que no tienen nota en matematicas.
# !is.na(nota_matematica) = FALSE -> Me trae todos los alumnos y quita los que no tienen nota.

alumnos_sin_notas <- alumnos_db |>
  anti_join(no_faltan_notas, by = "id_alumno")

# Generar una mutación masiva de datos (Limpieza de nulos)
boletin_limpio <- boletin_escolar |>
  mutate(
    across(where(is.numeric), \(x) replace_na(x, 1.0))
  )

# Manejo de fechas (Control del tiempo) -> Esto es gracias a Lubridate
boletin_fechas <- boletin_limpio |>
  mutate(
    # Extraer el año
    anio_nacimiento = year(fecha_nacimiento),
    # Calcular la fecha exacta
    edad_actual = time_length(interval(fecha_nacimiento, today()), "years"),
    # Redondear
    edad_oficial = floor(edad_actual)
  )