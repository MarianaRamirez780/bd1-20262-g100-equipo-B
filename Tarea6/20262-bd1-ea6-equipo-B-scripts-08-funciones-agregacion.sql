--
-- Scripts - 8.- Enunciados para Consultas con Funciones de Agregación

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Script del Enunciado 8.1 — Función COUNT: Volumen Global de Solicitudes de Servicio
-- Calcular la cantidad total de solicitudes de servicios registradas en la plataforma agrupadas por el estado de la transacción (Completado, Pendiente, Cancelado). 
-- ---------------------------------------------------------------------------------------------------------------------------------

SELECT 
	estado,
	COUNT(*) AS total_solicitudes
FROM servicio_solicitud
GROUP BY estado
ORDER BY total_solicitudes DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Script del Enunciado 8.2 — Función SUM: Recaudo Comercial Total por Categoría de Producto
-- Calcular el monto total acumulado ($) en ventas de productos pertenecientes a la categoría 'Libros' y 'Tecnología/Computadores'.
-- ---------------------------------------------------------------------------------------------------------------------------------

SELECT 
	tipo_p.nombre AS categoria_producto,
	SUM(pro_t.precio_compra * pro_t.cantidad_compra) AS recaudo_total
FROM producto_transaccion pro_t
INNER JOIN producto pro ON pro_t.id_producto = pro.id_producto
INNER JOIN tipo_producto tipo_p ON pro.id_tipo_producto = tipo_p.id_tipo_producto
WHERE tipo_p.id_tipo_producto = 1 OR tipo_p.id_tipo_producto = 15
GROUP BY tipo_p.id_tipo_producto, tipo_p.nombre
ORDER BY recaudo_total DESC;