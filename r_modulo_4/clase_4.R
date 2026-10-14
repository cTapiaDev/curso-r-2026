library(tidyverse)
library(scales)


# ==============================================================================
# LÍNEAS DE META EN GRÁFICO (geom_hline y geom_vline)
# ==============================================================================

grafico_base <- ggplot(data = reporte_colegio_completo,
                       aes(x = asistencia_anual, y = calificacion, color = alerta_academica)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_y_continuous(labels = label_number(accuracy = 0.1, decimal.mark = ",")) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("Adecuado" = "#26BF35",
                                "Observación" = "#E88320",
                                "Peligro inminente" = "#E62020"))

print(grafico_base)

grafico_metas <- grafico_base +
  geom_hline(yintercept = 4.0, color = "red", linetype = "dashed") +
  geom_vline(xintercept = 75, color = "blue", linetype = "dashed") +
  labs(
    title = "Mapa de Metas del Colegio",
    subtitle = "Línea Roja = Nota 4,0 | Línea Azul = 75% de Asistencia",
    x = "Porcentaje de Asistencia Anual (%)",
    y = "Calificación Final",
    color = "Estado del Alumno"
  )

print(grafico_metas)


# ==============================================================================
# TRADUCIR GRÁFICO A REGLAS DE DECISIÓN (case_when)
# ==============================================================================

tabla_decisiones <- reporte_colegio_completo |>
  mutate(
    medida_escolar = case_when(
      calificacion < 4.0 & asistencia_anual < 75 ~ "Citar Apoderado",
      calificacion < 4.0 & asistencia_anual >= 75 ~ "Tutoría",
      calificacion >= 4.0 & asistencia_anual < 75 ~ "Advertencia por Inasistencia",
      .default = "Sin Intervención"
    )
  )

# ==============================================================================
# CONTAR CASOS CON FUNCIÓN n()
# ==============================================================================

resumen_medidas <- tabla_decisiones |>
  group_by(medida_escolar) |>
  summarise(
    cantidad_casos = n()
  )


# ==============================================================================
# GRÁFICO DE DIAGNÓSTICO (geom_col)
# ==============================================================================
grafico_medidas <- ggplot(data = resumen_medidas,
                          aes(x = cantidad_casos, y = medida_escolar, fill = medida_escolar)) +
  geom_col() +
  labs(
    title = "Cantidad de Casos por Tipo de Medida Escolar",
    x = "Cantidad de Registros",
    y = "Acción a Tomar"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(grafico_medidas)

# ==============================================================================
# FILTRO + CONTEO
# ==============================================================================

conteo_reprobados <- tabla_decisiones |>
  filter(calificacion < 4.0) |>
  group_by(curso, asignatura) |>
  summarise(
    total_rojos = n(),
    .groups = "drop"
  )

grafico_rojos <- ggplot(data = conteo_reprobados,
                        aes(x = asignatura, y = total_rojos, fill = asignatura)) +
  geom_col() +
  labs(
    title = "Cantidad de Alumnos Reprobados por Curso y Asignatura",
    x = "Asignatura",
    y = "Cantidad de Notas Rojas"
  ) +
  theme_minimal() +
  theme(legend.position = "none") +
  facet_wrap(~ curso)

print(grafico_rojos)

# ==============================================================================
# write_csv
# ==============================================================================

lista_apoderados_citar <- tabla_decisiones |>
  filter(medida_escolar == "Citar Apoderado") |>
  select(id_alumno, curso, asignatura, asistencia_anual, calificacion, medida_escolar) |>
  arrange(calificacion)

write_csv(lista_apoderados_citar, "lista_apoderados.csv")

