
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 9.- Enunciado para creación de Vista (VIEW) con 4 JOINs, GROUP BY y HAVING
-- Construya una vista (VIEW) con el enunciado del ítem 7. Debe crear la vista (darle un nombre) y ejecutarla.
-- ---------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_reporte_ventas_categoria_usuario AS
SELECT 
	pro.nombre AS titulo_producto,
	tipo_p.nombre AS categoria_producto,
	pro_t.precio_compra,
	usu.nombre_1 || ' ' || usu.nombre_2 || ' ' || usu.apellido_1 || ' ' || usu.apellido_2 AS comprador,
	tipo_u.descripcion
FROM producto_transaccion pro_t
INNER JOIN producto pro ON pro_t.id_producto = pro.id_producto
INNER JOIN tipo_producto tipo_p ON pro.id_tipo_producto = tipo_p.id_tipo_producto
INNER JOIN usuario usu ON pro_t.id_usuario = usu.id_usuario
INNER JOIN usuario_tipo_usuario utipou ON usu.id_usuario = utipou.id_usuario
INNER JOIN tipo_usuario tipo_u ON utipou.id_tipo_usuario = tipo_u.id_tipo_usuario
WHERE (utipou.id_tipo_usuario = 1 OR utipou.id_tipo_usuario = 3) AND pro_t.precio_compra > 100000
ORDER BY pro_t.precio_compra DESC;

SELECT * FROM vw_reporte_ventas_categoria_usuario;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- 10.- Ejercicio del enunciado para consulta parametrizada (PREPARE / EXECUTE) con 5 JOINs (GROUP BY y HAVING)
-- ---------------------------------------------------------------------------------------------------------------------------------

PREPARE stmt_analisis_participacion_eventos (INT, TIMESTAMP) AS
SELECT 
    usu.id_usuario,
    usu.nombre_1 || ' ' || usu.nombre_2 || ' ' || usu.apellido_1 || ' ' || usu.apellido_2 AS organizador,
    tipo_u.nombre AS tipo_usuario_organizador,
    tipo_e.nombre AS tipo_evento,
    eve.id_evento,
    eve.nombre AS nombre_evento,
    COUNT(eve_u.id_usuario) AS total_participantes
FROM evento_usuario eve_u
INNER JOIN evento eve ON eve_u.id_evento = eve.id_evento
INNER JOIN tipo_evento tipo_e ON eve.id_tipo_evento = tipo_e.id_tipo_evento
INNER JOIN usuario usu ON eve.id_usuario = usu.id_usuario
INNER JOIN usuario_tipo_usuario utipou ON usu.id_usuario = utipou.id_usuario
INNER JOIN tipo_usuario tipo_u ON utipou.id_tipo_usuario = tipo_u.id_tipo_usuario
WHERE eve.id_tipo_evento = $1 AND eve.fecha_evento >= $2
GROUP BY usu.id_usuario, usu.nombre_1, usu.nombre_2, usu.apellido_1, usu.apellido_2, tipo_u.nombre, tipo_e.nombre, eve.id_evento, eve.nombre
HAVING COUNT(eve_u.id_usuario) >= 10
ORDER BY total_participantes DESC;

EXECUTE stmt_analisis_participacion_eventos(1, '2024-01-01 00:00:00');

DEALLOCATE stmt_analisis_participacion_eventos;

-- ---------------------------------------------------------------------------------------------------------------------------------
--11.- Ejercicio del enunciado para Evaluación Experimental de Rendimiento con ANALYZE
-- ---------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE usuario_1000 AS
SELECT
	g AS id_usuario,
	'Usuario_' || g AS nombre,
	'Apellido_' || (1 + (random()*50)::int) AS apellido_1,
	'Apellido_' || (1 + (random()*50)::int) AS apellido_2,
	'correo@pascualbravo.edu.co' AS correo,
	('2018-01-01'::date + (random() * 3000)::int) AS fecha_registro,
	(1 + (random()*3)::int) AS id_rol,
	(ARRAY['Estudiante', 'Docente', 'Egresado', 'Empleado', 'Ex-Estudiante',
	'Ex-Docente', 'Ex-Empleado', 'Guess'])[1 + (random()*7)::int] AS tipo_usuario,
	(100 + (random()*50)::int) AS id_dependencia
FROM generate_series(1, 1000) AS g;

CREATE TABLE usuario_100000 AS
SELECT
	g AS id_usuario,
	'Usuario_' || g AS nombre,
	'Apellido_' || (1 + (random()*99)::int) AS apellido_1,
	'Apellido_' || (1 + (random()*99)::int) AS apellido_2,
	'correo@pascualbravo.edu.co' AS correo,
	('2018-01-01'::date + (random() * 3000)::int) AS fecha_registro,
	(1 + (random()*3)::int) AS id_rol,
	(ARRAY['Estudiante', 'Docente', 'Egresado', 'Empleado', 'Ex-Estudiante',
	'Ex-Docente', 'Ex-Empleado', 'Guess'])[1 + (random()*7)::int] AS tipo_usuario,
	(100 + (random()*99)::int) AS id_dependencia
FROM generate_series(1, 100000) AS g;

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
	tipo_usuario,
	COUNT(*) AS total_registrados,
	MIN(fecha_registro) AS primera_fecha,
	MAX(fecha_registro) AS ultima_fecha
FROM usuario_1000
WHERE fecha_registro >= '2022-01-01'
GROUP BY tipo_usuario
ORDER BY total_registrados DESC;

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    tipo_usuario,
    COUNT(*) AS total_registrados
FROM usuario_100000
WHERE fecha_registro >= '2022-01-01'
GROUP BY tipo_usuario
ORDER BY total_registrados DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.- Enunciado para Validación de Propiedades ACID en 4 Tablas del DDL
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.1.- Atomicidad (Atomicity): Demostrar que una compra de un producto que falla en medio de la transacción por 
-- saldo  insuficiente o error de clave foránea revierte absolutamente todas las operaciones previas mediante ROLLBACK, 
-- dejando las tablas intactas.
-- ---------------------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.2.- Consistencia (Consistency): Demostrar cómo las restricciones de integridad física (CHECK precio >= 0, FOREIGN KEY, NOT NULL) 
-- impiden que la base de datos ingrese a un estado de datos inconsistente o embasurado.
-- ---------------------------------------------------------------------------------------------------------------------------------

-- cantidad negativa o inválida
INSERT INTO producto (id_tipo_producto, id_usuario, nombre, cantidad, precio, fecha_producto)
VALUES (15, 5, 'Portátil', 5, -50000, NOW());

-- cantidad comprada inválida
INSERT INTO producto_transaccion (id_usuario, id_producto, cantidad_compra, precio_compra, fecha_compra)
VALUES (1, 1, 0, 25000, NOW());

-- usuario no existe o inválido
INSERT INTO producto (id_tipo_producto, id_usuario, nombre, descripcion, cantidad, precio, fecha_producto)
VALUES (1, 888888, 'Libro Fantasma', 'Usuario no registrado', 3, 45000, NOW());

-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.4.- Durabilidad (Durability): Demostrar que una vez ejecutado exitosamente el comando COMMIT, los datos persisten de manera 
-- permanente en el almacenamiento físico de PostgreSQL (archivos WAL) incluso ante una simulación de desconexión imprevista del servidor.
-- ---------------------------------------------------------------------------------------------------------------------------------

