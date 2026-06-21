USE gymdb;

-- 1. KPI FINANCIERO MENSUAL (Explotando tu Vista 1 de ingresos)
SELECT * FROM vista_ingresos_mensuales;

-- 2. ANÁLISIS HISTÓRICO DE ASISTENCIA (Explotando tu Vista 2 de tiempo)
SELECT * FROM vista_asistencias_historicas ORDER BY año DESC, mes ASC;

-- 3. RANKING DE ENTRENADORES ESTRELLA (Rendimiento con minutos_entrenados)
SELECT 
    e.nombre_entrenador AS entrenador,
    COUNT(h.id_asistencia) AS clases_atendidas_con_exito,
    SUM(h.minutos_entrenados) AS total_minutos_impartidos
FROM hechos_asistencias h
INNER JOIN dim_entrenadores e ON h.id_entrenador = e.id_entrenador
GROUP BY e.id_entrenador, e.nombre_entrenador
ORDER BY clases_atendidas_con_exito DESC;

-- 4. ANÁLISIS DE SOCIOS CON RESERVA PREVIA (Comportamiento de planificación)
SELECT 
    c.id_clase, 
    COUNT(CASE WHEN h.reserva_previa = 'Si' THEN 1 END) AS con_reserva,
    COUNT(h.id_asistencia) AS asistencias_totales,
    ROUND((COUNT(CASE WHEN h.reserva_previa = 'Si' THEN 1 END) / COUNT(h.id_asistencia)) * 100, 2) AS porcentaje_planificado
FROM hechos_asistencias h
INNER JOIN dim_clases c ON h.id_clase = c.id_clase
GROUP BY c.id_clase
ORDER BY porcentaje_planificado DESC;


-- ========================================================================================================================
-- PREGUNTA 5: ¿Qué porcentaje de las asistencias totales se realizan mediante reserva previa?
-- (Métrica clave de operación para medir si los socios planifican o van de improviso)
-- ========================================================================================================================
SELECT 
    reserva_previa AS '¿Tenía Reserva Previa?',
    COUNT(id_asistencia) AS 'Número de Asistencias',
    ROUND((COUNT(id_asistencia) / 140.0) * 100, 2) AS 'Porcentaje del Total (%)'
FROM hechos_asistencias
GROUP BY reserva_previa;

-- ========================================================================================================================
-- PREGUNTA 6: ¿Cuáles son las horas o periodos de tiempo con mayor saturación de entrenamientos?
-- (Ayuda al dueño del gimnasio a saber en qué momentos se acumulan más minutos entrenados)
-- ========================================================================================================================
SELECT 
    t.turno AS 'Turno / Momento del Día', -- <-- Aquí le pedimos el texto real a la tabla dim_tiempo
    COUNT(h.id_asistencia) AS 'Cantidad de Clases Reservadas',
    SUM(h.minutos_entrenados) AS 'Carga Total de Trabajo (Minutos)'
FROM hechos_asistencias h
INNER JOIN dim_tiempo t ON h.id_tiempo = t.id_tiempo -- Conectamos las dos tablas
GROUP BY t.turno
ORDER BY COUNT(h.id_asistencia) DESC;

-- ========================================================================================================================
-- PREGUNTA 7: ¿Cuál es la eficiencia operativa del gimnasio? (Ingresos promedio por asistencia)
-- OBJETIVO: Relacionar tus dos vistas analíticas para saber cuánto dinero real genera cada visita que pisa el gimnasio.
-- ========================================================================================================================
SELECT 
    (SELECT ingresos_totales_mensuales FROM vista_ingresos_mensuales) AS 'Ingresos Totales ($)',
    COUNT(id_asistencia) AS 'Total Asistencias Reales',
    ROUND((SELECT ingresos_totales_mensuales FROM vista_ingresos_mensuales) / COUNT(id_asistencia), 2) AS 'Rendimiento por Asistencia ($)'
FROM hechos_asistencias;

-- ========================================================================================================================
-- PREGUNTA 8: Identificación del Trabajador Más Eficiente (Bono de Rendimiento)
-- OBJETIVO: Encontrar qué entrenador logra que los socios reserven más con antelación. Las reservas previas ayudan a la 
--           logística del gym, por lo que el entrenador que lidere esto merece un incentivo económico.
-- ========================================================================================================================
SELECT 
    e.nombre_entrenador AS 'Entrenador',
    COUNT(h.id_asistencia) AS 'Asistencias Totales Atendidas',
    COUNT(CASE WHEN h.reserva_previa = 'Si' THEN 1 END) AS 'Clases con Reserva Previa',
    ROUND((COUNT(CASE WHEN h.reserva_previa = 'Si' THEN 1 END) / COUNT(h.id_asistencia)) * 100, 1) AS 'Tasa de Planificación (%)',
    CASE 
        WHEN ROUND((COUNT(CASE WHEN h.reserva_previa = 'Si' THEN 1 END) / COUNT(h.id_asistencia)) * 100, 1) >= 85.0 THEN '🏆 APTO PARA BONO PREMIO'
        ELSE 'Mantener Monitoreo'
    END AS 'Estatus de Incentivo'
FROM hechos_asistencias h
INNER JOIN dim_entrenadores e ON h.id_entrenador = e.id_entrenador
GROUP BY e.id_entrenador, e.nombre_entrenador
ORDER BY 'Tasa de Planificación (%)' DESC;

-- ========================================================================================================================
-- PREGUNTA 9: Análisis de Retorno de Inversión (ROI) de los Trabajadores
-- OBJETIVO: Comparar el costo total de la nómina de los entrenadores frente a los ingresos totales del gimnasio 
--           (usando tu Vista 1) para saber qué porcentaje de los ingresos se destina a pagar al personal.
-- ========================================================================================================================
SELECT 
    (SELECT ingresos_totales_mensuales FROM vista_ingresos_mensuales) AS 'Ingresos Totales del Gym ($)',
    -- Sumamos la nómina de todos los entrenadores combinados
    ROUND(SUM(h.minutos_entrenados / 60.0) * 25.0, 2) AS 'Gasto Total en Nómina ($)',
    -- Calculamos el porcentaje que representa la nómina sobre las ganancias
    ROUND((SUM(h.minutos_entrenados / 60.0) * 25.0 / (SELECT ingresos_totales_mensuales FROM vista_ingresos_mensuales)) * 100, 2) AS 'Impacto de Nómina en Ingresos (%)'
FROM hechos_asistencias h;