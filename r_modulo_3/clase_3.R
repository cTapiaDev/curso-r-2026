library(tidyverse)
library(scales)

reporte_colegio_completo <- asistencia_historica |>
  group_by(id_alumno) |>
  summarise(asistencia_anual = mean(asistencia), .groups = "drop") |>
  left_join(boletin_largo, by = "id_alumno") |>
  auditar_rendimiento()

resumen_asignaturas <- reporte_colegio_completo |>
  group_by(asignatura) |>
  summarise(
    promedio_general = mean(calificacion, na.rm = TRUE)
  )

# ==============================================================================
# CREACIÓN DE GRÁFICOS (CONSTRUCCIÓN POR CAPAS)
# ==============================================================================

# Capa 1: Lienzo = Definir la base del gráfico gracias a los datos
lienzo <- ggplot(data = reporte_colegio_completo, mapping = aes(x = asistencia_anual, y = calificacion))
print(lienzo)

# Capa 2: Dibujar los datos
grafico_basico <- lienzo + geom_point()
print(grafico_basico)

# ==============================================================================
# RELACIONES INDIVIDUALES
# ==============================================================================
grafico_dispersion <- ggplot(data = reporte_colegio_completo,
                             aes(x = asistencia_anual, y = calificacion, color = alerta_academica)) +
  geom_point(size = 3, alpha = 0.7) +
  theme_minimal()

print(grafico_dispersion)

# ==============================================================================
# COMPARATIVA DE CATEGÓRIAS
# ==============================================================================
grafico_barras <- ggplot(data = resumen_asignaturas, aes(x = asignatura, y = promedio_general, fill = asignatura)) +
  geom_col() +
  theme_minimal() +
  scale_y_continuous(labels = label_number(accuracy = 0.1, decimal.mark = ",")) +
  theme(legend.position = "none")

print(grafico_barras)


# ==============================================================================
# COMPARATIVA DE CATEGÓRIAS
# ==============================================================================
grafico_facetas <- ggplot(data = reporte_colegio_completo,
                          aes(x = asistencia_anual, y = calificacion, color = alerta_academica)) +
  geom_point(size = 3, alpha = 0.7) +
  facet_wrap(~ curso) +
  theme_minimal()

print(grafico_facetas)

# ==============================================================================
# REPORTE FINAL
# ==============================================================================
grafico_final <- grafico_facetas +
  labs(
    title = "Monitoreo General de Rendimiento y Asistencia",
    subtitle = "Análisis de riesgo segmentado por curso",
    x = "Porcentaje de Asistencia Anual (%)",
    y = "Nota Final",
    color = "Estado del Alumno"
  ) +
  scale_y_continuous(labels = label_number(accuracy = 0.1, decimal.mark = ",")) +
  scale_color_manual(values = c("Adecuado" = "#26BF35",
                                "Observación" = "#E88320",
                                "Peligro inminente" = "#E62020"
                                )) +
  theme(legend.position = "bottom")

print(grafico_final)