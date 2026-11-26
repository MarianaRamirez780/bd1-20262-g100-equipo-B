-- ---------------------------------------------------------------------------------
-- Scripts - Enunciados 3, 4, 5, 6 y 7 DML para consultas Sin Join, 1 Join, 2 Join, 3 Join y 4 Join
-- ---------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------
-- 3.- Enunciado para Consulta sin JOIN
-- Análisis de Precios y Disponibilidad en Oferta de Productos
-- ---------------------------------------------------------------------------------

SELECT 
	id_producto,
	nombre,
	precio,
	precio * 1.05 AS precio_con_recargo,
	estado
FROM producto
WHERE precio BETWEEN 50000 AND 500000 AND estado = 'Disponible'
ORDER BY precio DESC
LIMIT 20;

-- ---------------------------------------------------------------------------------
-- 4.- Enunciado para consulta con 1 JOIN. 
-- Censo Institucional de Usuarios por Categoría
-- -----------------------------------------------------------------------------------

SELECT
	tipo_u.nombre,
	COUNT(utipou.id_usuario) AS total_usuarios
FROM usuario_tipo_usuario utipou
INNER JOIN tipo_usuario tipo_u ON utipou.id_tipo_usuario = tipo_u.id_tipo_usuario
GROUP BY tipo_u.id_tipo_usuario, tipo_u.nombre
ORDER BY total_usuarios DESC;

-- ---------------------------------------------------------------------------------
-- 5.- Enunciado para consulta con 2 JOINs
-- Trazabilidad de Eventos Académicos y sus Organizadores
-- ---------------------------------------------------------------------------------

SELECT 
	eve.nombre AS nombre_evento,
	tipo_e.nombre AS tipo_evento,
	eve.fecha_evento,
	usu.nombre_1 || ' ' || usu.apellido_1 || ' ' || usu.apellido_2 AS organizador,
	usu.correo
FROM evento eve
INNER JOIN tipo_evento tipo_e ON eve.id_tipo_evento = tipo_e.id_tipo_evento
INNER JOIN usuario usu ON eve.id_usuario = usu.id_usuario
WHERE eve.fecha_evento >= '2024-01-01 00:00:00' AND eve.fecha_evento <= '2025-12-31 00:00:00';

-- ---------------------------------------------------------------------------------
-- 6.- Enunciado para consulta SELECT con 3 JOINs (4 porque un usuario puede tener varios tipos)
-- Consumo de Servicios Académicos por Estudiantes Activos
-- ---------------------------------------------------------------------------------

SELECT 
	usu.nombre_1 || ' ' || usu.apellido_1 || ' ' || usu.apellido_2 AS estudiante_solicitante,
	serv.nombre AS servicio_solicitado,
	tipo_s.nombre AS categoria_servicio,
	ss.fecha_realizacion_servicio AS fecha_solicitud
FROM servicio_solicitud ss
INNER JOIN servicio serv ON ss.id_servicio = serv.id_servicio
INNER JOIN tipo_servicio tipo_s ON serv.id_tipo_servicio = tipo_s.id_tipo_servicio
INNER JOIN usuario usu ON ss.id_usuario = usu.id_usuario
INNER JOIN usuario_tipo_usuario utipou ON usu.id_usuario = utipou.id_usuario
WHERE ss.estado = 'Completado' AND utipou.id_tipo_usuario = 1;

-- ---------------------------------------------------------------------------------
-- 7.- Enunciado para consulta con 4 JOINs (5 porque un usuario puede tener varios tipos)
-- Reporte Transaccional Consolidado de Venta de Productos
-- ---------------------------------------------------------------------------------

SELECT 
	pro.nombre AS titulo_producto,
	tipo_p.nombre AS categoria_producto,
	pro_t.precio_compra,
	usu.nombre_1 || ' ' || usu.apellido_1 || ' ' || usu.apellido_2 AS comprador,
	tipo_u.nombre AS tipo_usuario,
	tipo_u.descripcion
FROM producto_transaccion pro_t
INNER JOIN producto pro ON pro_t.id_producto = pro.id_producto
INNER JOIN tipo_producto tipo_p ON pro.id_tipo_producto = tipo_p.id_tipo_producto
INNER JOIN usuario usu ON pro_t.id_usuario = usu.id_usuario
INNER JOIN usuario_tipo_usuario utipou ON usu.id_usuario = utipou.id_usuario
INNER JOIN tipo_usuario tipo_u ON utipou.id_tipo_usuario = tipo_u.id_tipo_usuario
WHERE (utipou.id_tipo_usuario = 1 OR utipou.id_tipo_usuario = 3) AND pro_t.precio_compra > 100000
ORDER BY pro_t.precio_compra ASC;