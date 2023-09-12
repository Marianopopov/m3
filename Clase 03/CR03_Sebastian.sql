USE adventureworks;

## Ejemplo left join
## Nombre de productos que salieron a la venta en 2003  nunca se han vendido

WITH
total_cantidad AS (
	SELECT
    ProductID
    , SUM(OrderQty) AS cantidad
    FROM salesorderdetail
    GROUP BY ProductID
)
SELECT
	p.Name AS product
    , c.cantidad
FROM product p
LEFT JOIN total_cantidad c
	ON p.ProductID = c.productid
WHERE YEAR(p.SellStartDate) = 2003
AND cantidad IS NULL;

-- Homework
-- Punto 1
-- Forma A
WITH
cantidad_año AS(
	SELECT
		YEAR(h.orderdate) AS año
        , SUM(OrderQty) AS cantidad_año
    FROM salesorderheader h
    JOIN salesorderdetail d
		ON h.SalesOrderID = d.SalesOrderID
	GROUP BY año
)
SELECT 
	YEAR(h.orderdate) AS año
    , s.name AS metodo_envio
    , SUM(d.OrderQty) AS cantidad
    , a.cantidad_año
    , ROUND((SUM(d.OrderQty) / a.cantidad_año) * 100, 2) AS procentaje_año
FROM salesorderheader h
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID
JOIN shipmethod s 
	ON h.ShipMethodID = s.ShipMethodID
JOIN cantidad_año a
	ON YEAR(h.orderdate) = a.año 
GROUP BY YEAR(h.orderdate), metodo_envio, cantidad_año
ORDER BY YEAR(h.orderdate), metodo_envio;

-- MÉTODO B
WITH
total_cantidad AS (
	SELECT
		YEAR(h.orderdate) AS año
        , s.name AS metodo_envio
        , SUM(d.OrderQty) AS cantidad
    FROM salesorderheader h
    JOIN salesorderdetail d
		ON h.SalesOrderID = d.SalesOrderID
	JOIN shipmethod s
		ON h.ShipMethodID = s.ShipMethodID
	GROUP BY 1, 2	
)
SELECT 
	año
    , metodo_envio
    , cantidad
    , SUM(cantidad) OVER (PARTITION BY año) AS cantidad_año
    , ROUND((cantidad / SUM(cantidad) OVER (PARTITION BY año)) * 100, 2) AS porcentaje
FROM total_cantidad;

-- Punto 2
WITH
agregado_producto AS (
	SELECT
		c.Name AS categoria
        , SUM(d.OrderQty) AS cantidad_total
        , SUM(d.LineTotal) AS venta_total
    FROM salesorderheader h 
    JOIN salesorderdetail d 
		ON h.SalesOrderID = d.SalesOrderID
	JOIN product p 
		ON d.ProductID = p.ProductID
	JOIN productsubcategory s 
		ON p.ProductSubcategoryID = s.ProductSubcategoryID
	JOIN productcategory c 
		ON s.ProductCategoryID = c.ProductCategoryID
	GROUP BY categoria
)
SELECT
	categoria
    , cantidad_total
    , venta_total
    , ROUND(cantidad_total / SUM(cantidad_total) OVER() * 100, 2) AS cantidad_total_porc
    , ROUND(venta_total / SUM(venta_total) OVER() * 100, 2) AS venta_total_porc
FROM agregado_producto
ORDER BY 5 DESC;

-- Pregunta 3
WITH
agregacion_pais AS (
	SELECT
		cr.name AS pais
		,SUM(d.OrderQty) AS cantidad_total
        , sum(d.LineTotal) AS venta_total
    FROM salesorderheader h 
    JOIN salesorderdetail d
		ON h.SalesOrderID = d.SalesOrderID
	JOIN address a 
		ON h.ShipToAddressID = a.AddressID
	JOIN stateprovince sp
		ON a.StateProvinceID = sp.StateProvinceID
	JOIN countryregion cr
		ON sp.CountryRegionCode = cr.CountryRegionCode
	GROUP BY 1
)
SELECT 
	pais
    , cantidad_total
    , venta_total
	, ROUND(cantidad_total / SUM(cantidad_total) OVER() * 100, 2) AS cantidad_total_porc
    , ROUND(venta_total / SUM(venta_total) OVER() * 100, 2) AS venta_total_porc
FROM agregacion_pais;


-- Pregunta 4
WITH
vental_total AS (
SELECT
	d.ProductID
	, d.LineTotal
	, COUNT(*) OVER (PARTITION BY d.ProductID) AS conteo
, ROW_NUMBER() OVER (PARTITION BY d.ProductID ORDER BY d.LineTotal) AS row_number_
FROM salesorderheader h
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID	
)
SELECT 
ProductID
, AVG(linetotal) AS mediana_producto
FROM vental_total
WHERE (FLOOR(conteo/2) = CEILING(conteo/2) AND (row_number_ = FLOOR(conteo/2) OR row_number_  = FLOOR(conteo/2) + 1))
	OR
    (FLOOR(conteo/2) != CEILING(conteo/2) AND row_number_ = CEILING(conteo/2))
GROUP BY 1;




