# gym-data-analytics
Proyecto de base de datos relacional y analítica  para la gestión y optimización financiera de un gimnasio.
# Gym Data Analytics

Este proyecto contiene el desarrollo completo de una base de datos analítica orientada a un modelo de negocio fitness. Incluye la creación de la arquitectura, el proceso automático de desinfección de duplicados (ETL) y consultas de Inteligencia de Negocio.

## 📁 Contenido del Repositorio

### 1️⃣ `01_schema.sql` (Infraestructura de Datos)
*   Creación física de las tablas de dimensiones, la tabla central de hechos y sus restricciones de integridad referencial.
*   **Vistas Analíticas:**
    *   `vista_ingresos_mensuales`: Automatización del cálculo de la salud financiera del gimnasio a nivel macro.
    *   `vista_asistencias_historicas`: Histórico estructurado temporalmente para análisis de tendencias anuales y mensuales.

### 2️⃣ `02_limpieza.sql` (Proceso de Calidad de Datos - ETL)
*   **Desinfección Automática:** Eliminación avanzada de duplicados masivos utilizando funciones de ventana (`RANK() OVER`) particionadas por las claves del negocio.
*   **Seguridad Transaccional:** Control de datos mediante bloques cerrados con `START TRANSACTION` y `COMMIT` para asegurar la persistencia limpia de los 140 registros reales.

### 3️⃣ `03_consultas.sql` (Módulo de Inteligencia de Negocio)
Set de consultas analíticas avanzadas agrupadas en pilares estratégicos para la toma de decisiones:
*   **Métricas Operativas por Turnos:** Cruce con la dimensión tiempo para sustituir los IDs por los nombres de los turnos reales de trabajo.
*   **Análisis Financiero y ROI de Trabajadores:** Transformación algorítmica de los minutos asistidos en horas laboradas para calcular costos de nómina estimados por entrenador ($25/hora) e impacto porcentual en los ingresos globales.
*   **Retención de Clientes (Análisis de Churn):** Consultas lógicas para descubrir "Socios Fantasma" con asistencias críticas inferiores a la media para activar campañas de fidelización.
*   **Optimización de Infraestructura:** Clasificación automática de sesiones (Exprés vs. Intensivas) y semáforos de tráfico ("Saturación Crítica", "Medio" y "Valle") según el volumen de asistencia.

## 📊 Arquitectura del Modelo de Datos (Modelo Estrella)

El proyecto estructura la base de datos `gymdb` separando las características demográficas y operativas de las métricas de asistencia a través de un diseño en estrella perfectamente definido:

*   **Tabla de Hechos (`hechos_asistencias`):** Centraliza las métricas del negocio. Contiene claves foráneas hacia las dimensiones (`id_socio`, `id_clase`, `id_entrenador`, `id_tiempo`) y datos críticos como `minutos_entrenados` y el estado de `reserva_previa` ('Si' o 'No'). Cuenta con una clave primaria autoincremental `id_asistencia`.
*   **Dimensiones:**
    *   `dim_socios`: Atributos demográficos del cliente. Contiene su clave primaria `id_socio`, además de `nombre`, `edad`, `genero`, `tipo_tarifa`, `estado_cuenta` y `fecha_alta`.
    *   `dim_entrenadores`: Datos del personal staff del gimnasio. Registra su clave primaria `id_entrenador`, junto con `nombre_entrenador`, `especialidad` y `nivel_experiencia`.
    *   `dim_clases`: Catálogo de actividades e infraestructura. Almacena su clave primaria `id_clase`, además de `nombre_actividad`, `zona_gimnasio` y `capacidad_maxima`.
    *   `dim_tiempo`: Estructura cronológica de control. Desglosada mediante su clave primaria `id_tiempo`, acompañada por `fecha`, `año`, `mes`, `dia_semana` y `turno`.
