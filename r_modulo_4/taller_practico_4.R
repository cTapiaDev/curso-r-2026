# ==============================================================================
# TALLER 4: DIAGNÓSTICO NORMATIVO Y EXPORTACIÓN DE REPORTES
# ==============================================================================

library(tidyverse)
library(scales)

set.seed(404)
datos_taller_4 <- tibble(
  id_estudiante = 1001:1080,
  jornada = sample(c("Diurna", "Vespertina"), 80, replace = TRUE),
  area_academica = sample(c("Humanidades", "Ciencias Exactas", "Tecnología"), 80, replace = TRUE),
  asistencia_semestral = round(runif(80, min = 55, max = 98), 0),
  promedio_semestral = round(runif(80, min = 2.2, max = 6.8), 1)
) |> 
  mutate(
    estado_previo = if_else(promedio_semestral < 4.0, "Reprobado", "Aprobado")
  )

# 🎯 EJERCICIO 1: TRAZADO DE UMBRALES NORMATIVOS (geom_hline y geom_vline)
# Contexto: La institución exige una nota mínima de 4,0 y una asistencia mínima del 70%.
# Instrucciones:
# 1. Crea un gráfico de dispersión (geom_point) con 'asistencia_semestral' en X y 'promedio_semestral' en Y.
# 2. Asigna el color según 'estado_previo'.
# 3. Agrega una línea horizontal (geom_hline) en el corte de nota 4.0 (color rojo, línea punteada "dashed").
# 4. Agrega una línea vertical (geom_vline) en el corte de asistencia 70 (color azul, línea punteada "dashed").
# 5. Aplica formato de coma decimal en el eje Y con scale_y_continuous().

grafico_umbrales <- ggplot(data = datos_taller_4, aes(x = asistencia_semestral, y = promedio_semestral, color = estado_previo)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_hline(yintercept = 4.0, color = "red", linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = 70, color = "blue", linetype = "dashed", linewidth = 1) +
  scale_y_continuous(labels = label_number(accuracy = 0.1, decimal.mark = ",")) +
  scale_color_manual(values = c("Aprobado" = "#26BF35", "Reprobado" = "#E62020")) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(grafico_umbrales)
  
  
# 🎯 EJERCICIO 2: CLASIFICACIÓN POR CUADRANTES Y CONTEO DE FRECUENCIAS (case_when + n())
# Contexto: Se requiere clasificar a cada estudiante según su posición respecto a los umbrales
# y luego contabilizar cuántos casos existen por cada categoría.
# Instrucciones:
# 1. Usa mutate() y case_when() para crear la columna 'protocolo_intervencion':
#    - promedio_semestral < 4.0 & asistencia_semestral < 70  ~ "Retención Crítica"
#    - promedio_semestral < 4.0 & asistencia_semestral >= 70 ~ "Nivelación Académica"
#    - promedio_semestral >= 4.0 & asistencia_semestral < 70 ~ "Alerta de Asistencia"
#    - .default = "Situación Regular"
# 2. En un segundo bloque, agrupa por 'protocolo_intervencion' y usa summarise() con n() 
#    para crear la columna 'total_casos'.
  
base_clasificada <- datos_taller_4 |> 
  mutate(
    protocolo_intervencion = case_when(
      promedio_semestral < 4.0 & asistencia_semestral < 70  ~ "Retención Crítica",
      promedio_semestral < 4.0 & asistencia_semestral >= 70 ~ "Nivelación Académica",
      promedio_semestral >= 4.0 & asistencia_semestral < 70 ~ "Alerta de Asistencia",
      .default = "Situación Regular"
    )
  )
  
resumen_protocolos <- base_clasificada |> 
  group_by(protocolo_intervencion) |>
  summarise(
    total_casos = n()
  )
  
  
# 🎯 EJERCICIO 3: VISUALIZACIÓN DE FRECUENCIAS Y FOCOS CRÍTICOS (geom_col + facet_wrap)
# Contexto: La dirección académica necesita visualizar la distribución de los protocolos 
# separados por jornada de estudio.
# Instrucciones:
# 1. A partir de 'base_clasificada', agrupa por 'jornada' y 'protocolo_intervencion', y cuenta los casos con n().
# 2. Grafica el resultado con geom_col() poniendo 'total_casos' en el eje X y 'protocolo_intervencion' en el eje Y.
# 3. Separa el gráfico en paneles por 'jornada' usando facet_wrap().
  
conteo_por_jornada <- base_clasificada |> 
  group_by(jornada, protocolo_intervencion) |>
  summarise(
    total_casos = n(),
    .group = "drop"
  )
  
grafico_protocolos <- ggplot(data = conteo_por_jornada, aes(x = total_casos, y = protocolo_intervencion, fill = protocolo_intervencion)) +
  geom_col() +
  facet_wrap(~ jornada) +
  theme_minimal() +
  theme(legend.position = "none")

print(grafico_protocolos)
  
  
# 🎯 EJERCICIO 4: FILTRADO, ORDENAMIENTO Y PERSISTENCIA DE DATOS (arrange + write_csv)
# Contexto: El departamento de bienestar estudiantil solicita la nómina exclusiva de alumnos
# en "Retención Crítica", ordenada desde el promedio más bajo al más alto, exportada a CSV.
# Instrucciones:
# 1. Toma 'base_clasificada' y filtra solo quienes tengan protocolo_intervencion == "Retención Crítica".
# 2. Ordena las filas de menor a mayor según 'promedio_semestral' usando arrange().
# 3. Exporta la tabla resultante al archivo "nomina_retencion_critica.csv" usando write_csv().
  
nomina_critica <- base_clasificada |> 
  filter(protocolo_intervencion == "Retención Crítica") |>
  arrange(promedio_semestral)

write_csv(nomina_critica, "nomina_retencion_critica.csv")
write_delim(nomina_critica, "nomina_retencion_critica.csv", delim = ";")