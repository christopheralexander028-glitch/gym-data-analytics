/*=====================================================================
Proyecto 1 SQL de Christopher Lima
=====================================================================*/
DROP DATABASE IF EXISTS Gymdb;
CREATE DATABASE IF NOT EXISTS GymDB;
USE GymDB;
/* En el siguiente paso creamos las tablas de la base de datos*/
CREATE TABLE dim_socios (
    id_socio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    edad INT,
    genero VARCHAR(20),
    tipo_tarifa VARCHAR(20),
    estado_cuenta VARCHAR(20),
    fecha_alta DATE
);
CREATE INDEX idx_fecha_alta ON dim_socios(fecha_alta); /*	hazme un 'índice alfabético/cronológico' de la columna fecha_alta. Cada vez que yo te pida buscar socios que se apuntaron en una fecha concreta, no me leas toda la tabla entera de arriba a abajo; vete directo al índice y busca la fila exacta".*/

CREATE TABLE dim_clases (
    id_clase INT PRIMARY KEY AUTO_INCREMENT,
    nombre_actividad VARCHAR(50),
    zona_gimnasio VARCHAR(50),
    capacidad_maxima INT
);

CREATE TABLE dim_entrenadores (
    id_entrenador INT PRIMARY KEY AUTO_INCREMENT,
    nombre_entrenador VARCHAR(100),
    especialidad VARCHAR(50),
    nivel_experiencia VARCHAR(20)
);

CREATE TABLE dim_tiempo (
    id_tiempo INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    año INT,
    mes VARCHAR(20),
    dia_semana VARCHAR(20),
    turno VARCHAR(20)
);

CREATE TABLE hechos_asistencias (
    id_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_socio INT,
    id_clase INT,
    id_entrenador INT,
    id_tiempo INT,
    minutos_entrenados INT,
    reserva_previa VARCHAR(2), -- Pondremos 'SI' o 'NO'
    FOREIGN KEY (id_socio) REFERENCES dim_socios(id_socio),
    FOREIGN KEY (id_clase) REFERENCES dim_clases(id_clase),
    FOREIGN KEY (id_entrenador) REFERENCES dim_entrenadores(id_entrenador),
    FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo)
);

/* Insertamos datos random*/

INSERT INTO dim_socios (nombre, edad, genero, tipo_tarifa, estado_cuenta, fecha_alta) VALUES
('Carlos Mendoza', 28, 'Masculino', 'Mensual', NULL, '2024-01-15'),       
('Ana Gómez', 34, 'Mujer', 'Pase VIP', 'Activo', '2025-02-15'),          
('Diego Fernández', -25, 'Hombre', 'Mensual', 'Activo', '2025-03-01'),     
('Laura Torres', NULL, 'Mujer', 'Anual', 'Activo', '2025-03-22'),          
('Elena Rivas', 150, 'Mujer', 'Anual', 'Baja', '2025-05-05'),              
('Carlos Mendoza', 28, 'Masculino', 'Mensual', 'Activa', '2024-03-12'), 
('Ana Martínez', 35, 'Femenino', 'Anual', 'Activa', '2024-06-18'),      
('Javier Ortiz', 50, 'Masculino', 'Mensual', 'Inactiva', '2024-09-05'),   
('Elena Gómez', 22, 'Femenino', 'Mensual', 'Activa', '2024-11-22'),        
('Marcos Vega', 41, 'Masculino', 'Anual', 'Activa', '2024-12-01');

INSERT INTO dim_clases (nombre_actividad, zona_gimnasio, capacidad_maxima) VALUES
('CrossFit', 'Box Exterior', 15),
('Spinning', 'Sala Bici', 20),
('Yoga', 'Sala Zen', 12),
('Natación', 'Piscina Climatizada', 10),
('Musculación', 'Zona Máquinas',25);

INSERT INTO dim_entrenadores (nombre_entrenador, especialidad, nivel_experiencia) VALUES
('Javier López', 'CrossFit', 'Senior'),
('Marta Ruiz', 'Spinning', 'Junior'),
('Lucía Sanz', 'Yoga', 'Master'),
('Marcos Peña', 'Natación', 'Senior'),
('Sergio Murillo', 'Musculación', 'Junior');

INSERT INTO dim_tiempo (fecha, año, mes, dia_semana, turno) VALUES
('2025-05-12', 2025, 'Mayo', 'Lunes', 'Mañana'),
('2025-05-12', 2025, 'Mayo', 'Lunes', 'Tarde'),
('2025-05-13', 2025, 'Mayo', 'Martes', 'Tarde'),
('2025-05-14', 2025, 'Mayo', 'Miércoles', 'Mañana'),
('2025-05-15', 2025, 'Mayo', 'Jueves', 'Noche'),
('2025-05-16', 2025, 'Mayo', 'Viernes', 'Mediodía'),
('2024-03-12', 2024, 'Marzo', 'Martes', 'Mañana'),
('2024-06-19', 2024, 'Junio', 'Miércoles', 'Tarde'),
('2024-09-06', 2024, 'Septiembre', 'Viernes', 'Tarde'),
('2024-11-25', 2024, 'Noviembre', 'Lunes', 'Mañana'),
('2024-12-02', 2024, 'Diciembre', 'Lunes', 'Tarde');

INSERT INTO hechos_asistencias (id_asistencia, id_socio, id_clase, id_entrenador, id_tiempo, minutos_entrenados, reserva_previa) VALUES
(1, 1, 1, 1, 1, 60, 'Si'),
(2, 2, 2, 2, 2, 45, 'Si'),
(3, 3, 3, 3, 3, 90, 'No'),
(4, 4, 1, 1, 4, 50, 'Si'),
(5, 1, 2, 2, 5, 60, 'Si'),
(6, 2, 3, 3, 6, 80, 'No'),
(7, 6, 1, 1, 7, 45, 'No'),
(8, 7, 2, 2, 8, 30, 'No'),
(9, 8, 3, 3, 9, 60, 'Si'),
(10, 9, 1, 2, 10, 45, 'No'),
(11, 10, 2, 1, 11, 30, 'Si'),
(12, 6, 2, 3, 8, 60, 'Si'),
(13, 7, 1, 1, 10, 45, 'Si'),
(14, 2, 1, 3, 4, 60, 'Si'),
(15, 5, 2, 2, 2, 45, 'Si'),
(16, 9, 3, 1, 9, 60, 'Si'),
(17, 4, 2, 2, 1, 50, 'No'),
(18, 8, 1, 3, 11, 45, 'Si'),
(19, 3, 3, 2, 7, 90, 'Si'),
(20, 1, 1, 1, 3, 60, 'Si'),
(21, 10, 2, 3, 5, 30, 'No'),
(22, 7, 3, 1, 6, 45, 'Si'),
(23, 6, 1, 2, 10, 60, 'Si'),
(24, 2, 2, 1, 8, 45, 'Si'),
(25, 5, 3, 3, 2, 90, 'No'),
(26, 8, 1, 2, 11, 60, 'Si'),
(27, 4, 2, 1, 4, 50, 'Si'),
(28, 9, 3, 3, 9, 60, 'Si'),
(29, 3, 1, 2, 7, 45, 'No'),
(30, 1, 2, 1, 1, 60, 'Si'),
(31, 10, 3, 3, 5, 30, 'Si'),
(32, 6, 1, 1, 10, 45, 'Si'),
(33, 7, 2, 2, 6, 60, 'Si'),
(34, 2, 3, 3, 8, 80, 'Si'),
(35, 5, 1, 1, 3, 45, 'No'),
(36, 8, 2, 2, 11, 60, 'Si'),
(37, 4, 3, 3, 4, 90, 'Si'),
(38, 9, 1, 1, 9, 45, 'Si'),
(39, 3, 2, 2, 2, 30, 'Si'),
(40, 1, 3, 3, 7, 60, 'No'),
(41, 10, 1, 1, 1, 45, 'Si'),
(42, 6, 2, 2, 11, 60, 'Si'),
(43, 7, 3, 3, 5, 90, 'Si'),
(44, 2, 1, 2, 8, 45, 'No'),
(45, 5, 2, 1, 3, 60, 'Si'),
(46, 8, 3, 3, 10, 80, 'Si'),
(47, 4, 1, 1, 6, 50, 'Si'),
(48, 9, 2, 2, 2, 45, 'No'),
(49, 3, 3, 1, 4, 60, 'Si'),
(50, 1, 1, 3, 9, 45, 'Si'),
(51, 10, 2, 2, 7, 30, 'Si'),
(52, 6, 3, 1, 1, 90, 'No'),
(53, 7, 1, 3, 11, 60, 'Si'),
(54, 2, 2, 1, 5, 45, 'Si'),
(55, 5, 3, 2, 8, 60, 'Si'),
(56, 8, 1, 1, 3, 45, 'Si'),
(57, 4, 2, 3, 10, 50, 'No'),
(58, 9, 3, 2, 6, 80, 'Si'),
(59, 3, 1, 1, 2, 60, 'Si'),
(60, 1, 2, 3, 4, 45, 'Si'),
(61, 10, 3, 1, 9, 30, 'No'),
(62, 6, 1, 2, 7, 60, 'Si'),
(63, 7, 2, 3, 1, 45, 'Si'),
(64, 2, 3, 1, 11, 90, 'Si'),
(65, 5, 1, 2, 5, 45, 'Si'),
(66, 8, 2, 3, 8, 60, 'No'),
(67, 4, 3, 1, 3, 80, 'Si'),
(68, 9, 1, 2, 10, 45, 'Si'),
(69, 3, 2, 3, 6, 60, 'Si'),
(70, 1, 3, 1, 2, 90, 'Si'),
(71, 10, 1, 2, 4, 45, 'Si'),
(72, 6, 2, 3, 9, 30, 'No'),
(73, 7, 3, 1, 7, 60, 'Si'),
(74, 2, 1, 2, 1, 45, 'Si'),
(75, 5, 2, 3, 11, 50, 'Si'),
(76, 8, 3, 1, 5, 80, 'No'),
(77, 4, 1, 2, 8, 60, 'Si'),
(78, 9, 2, 3, 3, 45, 'Si'),
(79, 3, 3, 1, 10, 90, 'Si'),
(80, 1, 1, 2, 6, 45, 'No'),
(81, 10, 2, 3, 2, 30, 'Si'),
(82, 6, 3, 1, 4, 60, 'Si'),
(83, 7, 1, 2, 9, 45, 'Si'),
(84, 2, 2, 3, 7, 60, 'Si'),
(85, 5, 3, 1, 1, 90, 'No'),
(86, 8, 1, 2, 11, 45, 'Si'),
(87, 4, 2, 3, 5, 50, 'Si'),
(88, 9, 3, 1, 8, 80, 'Si'),
(89, 3, 1, 2, 3, 60, 'No'),
(90, 1, 2, 3, 10, 45, 'Si'),
(91, 10, 3, 1, 6, 90, 'Si'),
(92, 6, 1, 2, 2, 45, 'Si'),
(93, 7, 2, 3, 4, 60, 'No'),
(94, 2, 3, 1, 9, 80, 'Si'),
(95, 5, 1, 2, 7, 45, 'Si'),
(96, 8, 2, 3, 1, 30, 'Si'),
(97, 4, 3, 1, 11, 60, 'Si'),
(98, 9, 1, 2, 5, 45, 'No'),
(99, 3, 2, 3, 8, 50, 'Si'),
(100, 1, 3, 1, 4, 60, 'Si'),
(101, 2, 1, 2, 9, 45, 'Si'),
(102, 3, 2, 3, 1, 30, 'No'),
(103, 4, 3, 1, 10, 90, 'Si'),
(104, 5, 1, 2, 6, 45, 'Si'),
(105, 6, 2, 3, 3, 60, 'Si'),
(106, 7, 3, 1, 11, 80, 'No'),
(107, 8, 1, 2, 7, 50, 'Si'),
(108, 9, 2, 3, 2, 45, 'Si'),
(109, 10, 3, 1, 8, 60, 'Si'),
(110, 1, 1, 2, 5, 45, 'No'),
(111, 2, 2, 3, 11, 60, 'Si'),
(112, 3, 3, 1, 4, 90, 'Si'),
(113, 4, 1, 2, 9, 45, 'Si'),
(114, 5, 2, 3, 1, 30, 'No'),
(115, 6, 3, 1, 10, 60, 'Si'),
(116, 7, 1, 2, 6, 45, 'Si'),
(117, 8, 2, 3, 3, 60, 'Si'),
(118, 9, 3, 1, 11, 80, 'No'),
(119, 10, 1, 2, 7, 50, 'Si'),
(120, 1, 2, 3, 2, 45, 'Si'),
(121, 2, 3, 1, 8, 60, 'Si'),
(122, 3, 1, 2, 5, 45, 'No'),
(123, 4, 2, 3, 11, 60, 'Si'),
(124, 5, 3, 1, 4, 90, 'Si'),
(125, 6, 1, 2, 9, 45, 'Si'),
(126, 7, 2, 3, 1, 30, 'No'),
(127, 8, 3, 1, 10, 60, 'Si'),
(128, 9, 1, 2, 6, 45, 'Si'),
(129, 10, 2, 3, 3, 60, 'Si'),
(130, 1, 3, 1, 11, 80, 'No'),
(131, 2, 1, 2, 7, 50, 'Si'),
(132, 3, 2, 3, 2, 45, 'Si'),
(133, 4, 3, 1, 8, 60, 'Si'),
(134, 5, 1, 2, 5, 45, 'No'),
(135, 6, 2, 3, 11, 60, 'Si'),
(136, 7, 3, 1, 4, 90, 'Si'),
(137, 8, 1, 2, 9, 45, 'Si'),
(138, 9, 2, 3, 1, 30, 'No'),
(139, 10, 3, 1, 10, 60, 'Si'),
(140, 10, 2, 1, 11, 30, 'Si'), 
(141, 10, 2, 1, 11, 30, 'Si');

-- 1. CREACIÓN VISTAS DE NEGOCIO (VIEWS)
-- Vista 1: Resumen	del resultado	financiero mensual de socios activos 
CREATE OR REPLACE VIEW vista_ingresos_mensuales AS
SELECT 
    COUNT(*) AS total_socios_activos,
    SUM(CASE 
        WHEN tipo_tarifa = 'Mensual' THEN 50
        WHEN tipo_tarifa = 'Anual' THEN 35 -- Calculando el equivalente al mes (ej: 420€ al año)
        WHEN tipo_tarifa = 'Pase VIP' THEN 90
        ELSE 30
    END) AS ingresos_totales_mensuales
FROM dim_socios
WHERE estado_cuenta = 'Activa';

-- Vista 2: Rendimiento histórico total de asistencias
CREATE OR REPLACE VIEW vista_asistencias_historicas AS
SELECT 
    t.año,
    t.mes,
    COUNT(h.id_asistencia) AS total_asistencias
FROM hechos_asistencias h
JOIN dim_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.año, t.mes;


-- 2. CREACIÓN DE UNA FUNCIÓN (FUNCTION)
-- Justificación: Evalúa la edad de un socio de forma automática y devuelve si pertenece al grupo 'Senior' o 'Junior'.
DELIMITER $$
CREATE FUNCTION fn_categoria_edad(p_edad INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_categoria VARCHAR(20);
    IF p_edad >= 40 THEN
        SET v_categoria = 'Senior';
    ELSE
        SET v_categoria = 'Adult';
    END IF;
    RETURN v_categoria;
END$$
DELIMITER ;