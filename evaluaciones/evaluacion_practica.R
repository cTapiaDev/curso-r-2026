# ==============================================================================
# 🎓 EVALUACIÓN PRÁCTICA: CURSO DE R
# Duración máxima: 2 horas | Modalidad: Resolución individual en script
# ==============================================================================

# 🟢 FASE 0: CARGA DE LIBRERÍAS Y DATOS BASE (¡EJECUTAR ESTE BLOQUE PRIMERO!)
library(tidyverse)
library(scales)

set.seed(2026)

# Tabla 1: Nómina de matrículas e información socioeducativa (100 estudiantes)
matriculas_eval <- tibble(
  id_estudiante = 1:100,
  nivel = sample(c("1ro Medio", "2do Medio", "3ro Medio", "4to Medio"), 100, replace = TRUE),
  jornada = sample(c("Mañana", "Tarde"), 100, replace = TRUE),
  asistencia_anual = round(runif(100, min = 60, max = 98), 0),
  beneficio_beca = sample(c("Con Beca", "Sin Beca"), 100, replace = TRUE)
)

# Tabla 2: Registro de calificaciones anuales (Faltan 4 estudiantes que se retiraron)
calificaciones_eval <- tibble(
  id_estudiante = 1:96,
  nota_lenguaje = round(runif(96, min = 2.5, max = 6.8), 1),
  nota_matematica = round(runif(96, min = 2.0, max = 7.0), 1)
)

# Simulamos 4 casos de pruebas pendientes (NA) en matemática
calificaciones_eval$nota_matematica[sample(1:96, 4)] <- NA

# ==============================================================================
# 💻 DESAFÍO DE EVALUACIÓN (Completa los 7 ejercicios)
# ==============================================================================

# 🎯 EJERCICIO 1: CRUCE DE TABLAS Y FILTRADO DE NULOS
# Instrucciones:
# 1. Une la tabla 'matriculas_eval' con 'calificaciones_eval' usando left_join() por "id_estudiante".
# 2. Filtra la tabla usando !is.na() para conservar solo a los alumnos que tienen nota en 'nota_lenguaje'
#    (eliminando así a los 4 estudiantes retirados).

base_unida <- matriculas_eval |> 
  # ESCRIBE TU CÓDIGO AQUÍ...


# 🎯 EJERCICIO 2: LIMPIEZA DE CELDAS VACÍAS Y PROMEDIO SIMPLE
# Instrucciones:
# 1. Toma 'base_unida' y usa mutate() junto con replace_na() para que los valores vacíos 
#    de la columna 'nota_matematica' sean reemplazados por la nota mínima 1.0.
# 2. En el mismo mutate(), crea la columna 'promedio_general' calculando el promedio entre
#    nota_lenguaje y nota_matematica.

base_limpia <- base_unida |> 
  # ESCRIBE TU CÓDIGO AQUÍ...


# 🎯 EJERCICIO 3: REGLAS DE NEGOCIO MULTIVARIABLES
# Instrucciones:
# Toma 'base_limpia' y usa mutate() con case_when() para crear la columna 'estado_final'.
# - Si promedio_general < 4.0 & asistencia_anual < 75  ~ "Repitencia Crítica"
# - Si promedio_general < 4.0 & asistencia_anual >= 75 ~ "Reprobado por Notas"
# - Si promedio_general >= 4.0 & asistencia_anual < 75 ~ "Riesgo por Inasistencia"
# - En cualquier otro caso (.default)                  ~ "Promovido"

base_evaluada <- base_limpia |> 
  # ESCRIBE TU CÓDIGO AQUÍ...


# 🎯 EJERCICIO 4: RESUMEN AGRUPADO Y CONTEO DE CASOS
# Instrucciones:
# Toma 'base_evaluada', agrupa por 'nivel' y 'estado_final' usando group_by(), y luego
# usa summarise() para calcular dos métricas:
# 1. 'cantidad_alumnos'.
# 2. 'promedio_grupo'.

resumen_niveles <- base_evaluada |> 
  # ESCRIBE TU CÓDIGO AQUÍ...


# 🎯 EJERCICIO 5: GRÁFICO DE DISPERSIÓN Y LÍNEAS DE UMBRAL
# Instrucciones:
# 1. Usando 'base_evaluada', crea un gráfico de puntos donde X sea 'asistencia_anual',
#    Y sea 'promedio_general', y el color dependa de 'estado_final'.
# 2. Agrega una línea horizontal punteada (geom_hline) en la nota de corte 4.0.
# 3. Agrega una línea vertical punteada (geom_vline) en el corte de asistencia 75.
# 4. Formatea el eje Y con coma decimal.

grafico_diagnostico <- ggplot(data = base_evaluada, aes(x = ..., y = ..., color = ...)) +
  # ESCRIBE TU CÓDIGO AQUÍ...


# 🎯 EJERCICIO 6: GRÁFICO DE BARRAS SEGMENTADO POR PANELES
# Instrucciones:
# 1. Usando la tabla 'resumen_niveles' (creada en el Ejercicio 4), construye un gráfico de barras
#    poniendo 'cantidad_alumnos' en el eje X y 'estado_final' en el eje Y.
# 2. Asigna el color de relleno según 'estado_final'.
# 3. Divide el gráfico en paneles separados por 'nivel'.

grafico_barras_nivel <- ggplot(data = resumen_niveles, aes(x = ..., y = ..., fill = ...)) +
  # ESCRIBE TU CÓDIGO AQUÍ...


# 🎯 EJERCICIO 7: ORDENAMIENTO Y EXPORTACIÓN A CSV
# Instrucciones:
# 1. Toma 'base_evaluada' y filtra únicamente a los alumnos cuyo 'estado_final' 
#    sea igual a "Repitencia Crítica".
# 2. Ordena la tabla resultante de menor a mayor según su 'promedio_general'.
# 3. Exporta esta nómina final a un archivo llamado "nomina_repitencia_critica.csv".

nomina_exportar <- base_evaluada |> 
  # ESCRIBE TU CÓDIGO AQUÍ...
