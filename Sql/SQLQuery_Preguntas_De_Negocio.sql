USE Logistica_Clean

SELECT TOP 5 * FROM Producto_Clean
SELECT TOP 5 * FROM pedidos_clean
SELECT TOP 5 * FROM Almacenes_Clean
SELECT TOP 5 * FROM Logistica_Clean

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREGUNTAS QUE SE HIZO PARA ENTENDER Y RESOLVER EL PROBREMA GENERAL
-----------------------------------------------------------------------------------------------------------------------------------------
-- ¿Cuántas cancelaciones hay por almacén?
SELECT A.ubicacion, COUNT(L.id_almacen) AS TOTAL_CANCELACIONES
FROM Almacenes_Clean AS A
JOIN Logistica_Clean AS L ON A.id_almacen = L.id_almacen
WHERE L.estado_envio = 'Cancelado'
GROUP BY A.ubicacion

-- ¿Cuántos pedidos llegaron retrasados por almacén?
SELECT A.ubicacion, COUNT(L.id_almacen) AS TOTAL_PEDIDOS_RETRASADOS
FROM Almacenes_Clean AS A
JOIN Logistica_Clean AS L ON A.id_almacen = L.id_almacen
WHERE L.estado_envio = 'Retrasado'
GROUP BY A.ubicacion

-- ¿Cuál es el costo promedio de envío por almacén?
SELECT A.ubicacion, AVG(L.costo_envio) AS PROMEDIO_ENVIO
FROM Almacenes_Clean AS A
JOIN Logistica_Clean AS L ON A.id_almacen = L.id_almacen
WHERE L.flag_costo_atipico = 0
GROUP BY A.ubicacion;

-- ¿Cuál es la tasa de retraso general?
WITH TOTAL_PEDIDOS AS (
	SELECT COUNT(id_pedido) AS TOTAL_CANTIDAD_PEDIDOS
	FROM pedidos_clean
),

TOTAL_PEDIDOS_RETRASADOS AS (
	SELECT COUNT(P.id_pedido) AS TOTAL_PEDIDOS_Retrasado
	FROM pedidos_clean AS P
	JOIN Logistica_Clean AS L ON P.id_pedido = L.id_pedido
	WHERE L.estado_envio = 'Retrasado'
)

SELECT TP.TOTAL_CANTIDAD_PEDIDOS, TPR.TOTAL_PEDIDOS_Retrasado,
ROUND(CAST(TPR.TOTAL_PEDIDOS_Retrasado AS FLOAT) / TP.TOTAL_CANTIDAD_PEDIDOS * 100, 2) AS TASA_DE_RETRASO FROM TOTAL_PEDIDOS AS TP
CROSS JOIN TOTAL_PEDIDOS_RETRASADOS AS TPR;

-- ¿Cuánto dinero se perdió por cancelaciones?
with dinero_total_perdido as (
	SELECT SUM(P.precio_base * PD.cantidad) AS Dinero_Perdido
FROM Producto_Clean AS P
JOIN pedidos_clean AS PD ON P.id_producto = PD.id_producto
JOIN Logistica_Clean AS L ON PD.id_pedido = L.id_pedido
WHERE L.estado_envio = 'Cancelado'
),

total_dinero as (
SELECT SUM(P.precio_base * PD.cantidad) AS Dinero_total
FROM Producto_Clean AS P
JOIN pedidos_clean AS PD ON P.id_producto = PD.id_producto
)

select dt.Dinero_total, dtp.Dinero_Perdido, 
ROUND((CAST(dtp.Dinero_Perdido AS FLOAT) / dt.Dinero_total) * 100,2) AS porcentaje from dinero_total_perdido as dtp
cross join total_dinero as dt

-- ¿Qué producto tiene más cancelaciones o retrasos?
SELECT P.nombre_producto, COUNT(L.id_pedido) AS 'CANTIDAD CANCELACIONES O RETRASOS' 
FROM Producto_Clean AS P
JOIN pedidos_clean AS PD ON P.id_producto = PD.id_producto
JOIN Logistica_Clean AS L ON PD.id_pedido = L.id_pedido
WHERE L.estado_envio = 'Retrasado' OR L.estado_envio = 'Cancelado'
GROUP BY P.nombre_producto

-- ¿Cómo evolucionaron los retrasos y cancelaciones mes a mes?
SELECT MONTH(P.fecha_pedido) AS MES, YEAR(P.fecha_pedido) AS AÑO, count(l.id_almacen) total_problemas
FROM pedidos_clean AS P
JOIN Logistica_Clean AS L ON P.id_pedido = L.id_pedido
WHERE L.estado_envio = 'Retrasado' or L.estado_envio = 'Cancelado'
group by MONTH(P.fecha_pedido) , YEAR(P.fecha_pedido)
ORDER BY AÑO, MES