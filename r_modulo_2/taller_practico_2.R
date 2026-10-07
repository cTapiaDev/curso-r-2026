library(tidyverse)

set.seed(123)
datos_taller <- tibble(
  id_alumno = 1:50,
  estudiante = paste0("Estudiante_", 1:50),
  curso = sample(c("Octavo", "Primero Medio", "Segundo Medio"), 50, replace = TRUE),
  nota_final = round(runif(50, min = 2.0, max = 7.0), 1),
  porcentaje_asistencia = round(runif(50, min = 60, max = 100), 0)
)

# ==============================================================================
# 🟢 EJERCICIO 1: EL EMBUDO (Filtrar filas)
# ==============================================================================
# Contexto: Dirección Académica necesita contactar urgentemente a los apoderados 
# de los alumnos que están reprobando la asignatura (nota menor a 4.0).
# Tarea: Filtra la tabla original para mostrar solo a estos estudiantes.


# ==============================================================================
# 🟢 EJERCICIO 2: LIMPIEZA VISUAL Y RANKING (Seleccionar y Ordenar)
# ==============================================================================
# Contexto: Se acerca la ceremonia de premiación y necesitamos una lista limpia.
# Tarea: Quédate solo con las columnas "estudiante" y "nota_final". 
# Luego, ordena a los alumnos desde la nota más alta a la más baja.


# ==============================================================================
# 🟢 EJERCICIO 3: REGLAS AUTOMÁTICAS (Crear columnas con condiciones)
# ==============================================================================
# Contexto: El sistema requiere alertar sobre problemas de inasistencia.
# Tarea: Crea una columna nueva llamada 'alerta_asistencia'. 
# Si el porcentaje es menor a 80, debe decir "Llamar a casa", de lo contrario "Al día".


# ==============================================================================
# 🟢 EJERCICIO 4: TABLAS DINÁMICAS BÁSICAS (Agrupar y Resumir)
# ==============================================================================
# Contexto: Fin de semestre. Necesitamos comparar el rendimiento entre los cursos.
# Tarea: Agrupa los datos por curso y calcula la nota promedio de cada uno.


# ==============================================================================
# 🟢 EJERCICIO 5: EL FLUJO COMPLETO (Pipeline final)
# ==============================================================================
# Contexto: Un reporte rápido que mezcle todo lo aprendido.
# Tarea: Toma los datos originales, filtra solo a los de "Primero Medio", 
# crea una columna que calcule cuántos puntos les faltaron para el 7.0, 
# y ordénalos para ver quién estuvo más cerca.