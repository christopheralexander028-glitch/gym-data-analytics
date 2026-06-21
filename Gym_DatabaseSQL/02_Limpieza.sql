/* Script de limpieza y calidad de datos*/
USE gymdb;

-- ========================================================================================================================
-- FASE 1: INSPECCIÓN INICIAL 
-- ========================================================================================================================
-- 1. VISTA GENERAL DE LA TABLA 
SELECT * FROM dim_socios;

-- Contamos cuántos socios reales hay guardados en la tabla
SELECT COUNT(*) FROM dim_socios;

-- 2. Inspeccionar el duplicado en las Asistencias (Verás las filas 11 y 14 idénticas de Marcos V.)
SELECT * FROM hechos_asistencias 
WHERE id_socio = 10;


-- ========================================================================================================================
-- FASE 2: DESINFECCIÓN Y PROCESO ETL AUTOMÁTICO 
-- ========================================================================================================================
SET SQL_SAFE_UPDATES = 0; -- Desactivamos el modo seguro

START TRANSACTION;

-- 1. Arreglar Estados Nulos (Cambiamos el valor nulo de Carlos Mendoza)
UPDATE dim_socios 
SET estado_cuenta = 'Activa' 
WHERE estado_cuenta IS NULL;

-- 2. Arreglar Edades (Usa lógica condicional CASE para Laura, Diego y Elena de golpe)
UPDATE dim_socios
SET edad = CASE 
    WHEN edad IS NULL THEN 34    -- Asigna tu media de 34 años a Laura Torres
    WHEN edad <= 0 THEN 25       -- Corrige la edad negativa de Diego Fernández a 25
    WHEN edad > 100 THEN 40      -- Limpia el outlier de 150 años de Elena Rivas
    ELSE edad 
END;

-- 3. Borrado inteligente del duplicado real en los hechos usando Funciones Ventana (RANK OVER)
-- Al ejecutarse, detectará la fila 14 repetida y la fulminará del sistema.
WITH AsistenciasNumeradas AS (
    SELECT 
        id_asistencia,
        RANK() OVER (
            PARTITION BY id_socio, id_clase, id_entrenador, id_tiempo 
            ORDER BY id_asistencia ASC
        ) as rango_duplicado
    FROM hechos_asistencias
),
SoloDuplicados AS (
    SELECT id_asistencia 
    FROM AsistenciasNumeradas 
    WHERE rango_duplicado > 1
)
DELETE FROM hechos_asistencias 
WHERE id_asistencia IN (SELECT id_asistencia FROM SoloDuplicados);

COMMIT; -- Es la orden de guardar en la base de datos.

SET SQL_SAFE_UPDATES = 1; -- Volvemos a activar el modo seguro por precaución


-- ========================================================================================================================
-- FASE 3: VERIFICACIÓN FINAL 
-- ========================================================================================================================
-- Comprobamos que las edades sean lógicas, no haya nulos y el duplicado se haya esfumado
SELECT * FROM dim_socios;
SELECT * FROM hechos_asistencias WHERE id_socio = 10;