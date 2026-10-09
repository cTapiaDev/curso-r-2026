# ==============================================================================
# Módulos: Nivelación + Workflows + Visualización
# ==============================================================================

library(tidyverse)
library(scales)

set.seed(2026)

postulantes <- tibble(
  rut_id = 1:120,
  dependencia = sample(c("Municipal", "Subvencionado", "Particular"), 120, replace = TRUE),
  asistencia_preu = round(runif(120, 40, 100), 0),
  beca = sample(c(TRUE, FALSE), 120, replace = TRUE)
)

ensayos <- tibble(
  rut_id = 1:115,
  nota_matematica = round(runif(115, 3.0, 7.0), 1),
  nota_lenguaje = round(runif(115, 4.0, 7.0), 1)
)

ensayos$nota_matematica[sample(1:115, 5)] <- NA

# ==============================================================================
# PARTE 1: EL DESAFÍO (¡TU TURNO!)
# Completa los espacios debajo de cada instrucción.
# ==============================================================================

# 🎯 RETO 1: CONSOLIDACIÓN Y LIMPIEZA (Nivelación + Joins)
# Instrucciones:
# 1. Toma la tabla 'postulantes' y únela con la tabla 'ensayos' usando left_join.
# 2. Filtra (!is.na) para eliminar a los alumnos que NO tienen nota en lenguaje (los 5 que faltaban).
# 3. Usa mutate y if_else para crear la columna 'estado_mate': 
#    Si la nota_matematica es NA, que diga "Prueba en Blanco", sino "Rendida".

datos_consolidados <- postulantes |> 
  # ESCRIBE TU CÓDIGO AQUÍ...
  
  
# 🎯 RETO 2: LÓGICA DE NEGOCIO Y PIPELINE
# Instrucciones:
# 1. Toma tus 'datos_consolidados'.
# 2. Reemplaza los NA numéricos de 'nota_matematica' por un 1.0 (usa mutate, across y replace_na).
# 3. Crea una columna 'promedio_ensayos' sumando mate + lenguaje y dividiendo por 2.
# 4. Usa case_when para crear la columna 'proyeccion':
#    - Promedio >= 6.0 ~ "Alto Rendimiento"
#    - Promedio >= 5.0 ~ "Rendimiento Medio"
#    - .default = "Requiere Apoyo"
  
reporte_analitico <- datos_consolidados |> 
# ESCRIBE TU CÓDIGO AQUÍ...
  
  
# 🎯 RETO 3: TABLA DINÁMICA
# Instrucciones:
# Crea un resumen que agrupe por 'dependencia' y calcule la nota promedio 
# de matemáticas. (Recuerda ignorar los NA en el cálculo si los hubiera).
  
resumen_dependencia <- reporte_analitico |> 
# ESCRIBE TU CÓDIGO AQUÍ...
  
  
# 🎯 RETO 4: VISUALIZACIÓN ESTRATÉGICA
# Instrucciones:
# 1. Usa 'reporte_analitico' como lienzo.
# 2. Crea un gráfico de dispersión (geom_point): Eje X = asistencia_preu, Eje Y = promedio_ensayos.
# 3. Dale color a los puntos según la 'proyeccion'.
# 4. Divide el gráfico por 'dependencia' (facet_wrap).
# 5. ¡No olvides formatear el eje Y con coma decimal usando scale_y_continuous y scales!
  
grafico_final <- # ESCRIBE TU CÓDIGO AQUÍ...
  
  
  
  
  
# ==============================================================================
# ==============================================================================
# 🛑 ALTO AQUÍ: NO BAJES HASTA HABERLO INTENTADO.
# ==============================================================================
# ==============================================================================





# ==============================================================================
#  PARTE 2: SOLUCIONARIO
# Compara tu código con este. ¿Usaste |> y + en los lugares correctos?
# ==============================================================================

# ✅ SOLUCIÓN RETO 1: CONSOLIDACIÓN
datos_consolidados_sol <- postulantes |> 
  left_join(ensayos, by = "rut_id") |> 
  filter(!is.na(nota_lenguaje)) |> 
  mutate(
    estado_mate = if_else(is.na(nota_matematica), "Prueba en Blanco", "Rendida")
  )

# ✅ SOLUCIÓN RETO 2: PIPELINE Y REGLAS
reporte_analitico_sol <- datos_consolidados_sol |> 
  mutate(
    across(where(is.numeric), \(x) replace_na(x, 1.0)),
    
    promedio_ensayos = (nota_matematica + nota_lenguaje) / 2,
    
    proyeccion = case_when(
      promedio_ensayos >= 6.0 ~ "Alto Rendimiento",
      promedio_ensayos >= 5.0 ~ "Rendimiento Medio",
      .default = "Requiere Apoyo"
    )
  )

# ✅ SOLUCIÓN RETO 3: TABLA DINÁMICA
resumen_dependencia_sol <- reporte_analitico_sol |> 
  group_by(dependencia) |> 
  summarise(
    promedio_mate = mean(nota_matematica, na.rm = TRUE)
  )

# ✅ SOLUCIÓN RETO 4: GRÁFICO GERENCIAL FINAL
# Notar el cambio: Dejamos de usar |> y empezamos a sumar capas con +
grafico_final_sol <- ggplot(data = reporte_analitico_sol, 
                            aes(x = asistencia_preu, y = promedio_ensayos, color = proyeccion)) +
  geom_point(size = 3, alpha = 0.7) +
  facet_wrap(~ dependencia) +
  theme_minimal() +
  
  labs(
    title = "Impacto de la Asistencia en Ensayos PAES",
    subtitle = "Análisis por dependencia del establecimiento",
    x = "Asistencia a Preuniversitario (%)",
    y = "Promedio Final Ensayos",
    color = "Proyección"
  ) +
  
  scale_y_continuous(labels = label_number(accuracy = 0.1, decimal.mark = ",")) +
  
  scale_color_manual(values = c("Alto Rendimiento" = "#10b981", 
                                "Rendimiento Medio" = "#f59e0b", 
                                "Requiere Apoyo" = "#ef4444")) +
  
  theme(legend.position = "bottom")

print(grafico_final_sol)