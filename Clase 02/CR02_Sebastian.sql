USE adventureworks;

-- Ejemplo parametro OUT
DELIMITER $$
DROP PROCEDURE total_ordenes_out;
CREATE PROCEDURE total_ordenes_out (IN fecha_order DATE, OUT total INT)
BEGIN
	SELECT
    COUNT(*) INTO total
    FROM salesorderheader
    WHERE DATE(orderdate) = fecha_order;
END $$

DELIMITER ;

SET @total_ordenes = 0;
CALL total_ordenes_out('2002-01-01', @total_ordenes);

SELECT @total_ordenes;

-- INOUT
DELIMITER $$
DROP PROCEDURE incrementar_numero;
CREATE PROCEDURE incrementar_numero (INOUT num INT)
BEGIN
	SET num = num + 1;
END $$

DELIMITER ;

SET @numero = 5;
CALL incrementar_numero(@numero);

SELECT @numero;

-- Ejercicio 1
SELECT DISTINCT
	c.FirstName
    , c.LastName
FROM salesorderheader  h
JOIN contact c
	ON h.ContactID = c.ContactID
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID
JOIN product p 
	ON d.ProductID = p.ProductID
JOIN productsubcategory s 
	ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN shipmethod e
	ON h.ShipMethodID = e.ShipMethodID
WHERE 
	YEAR(h.OrderDate) BETWEEN 2000 AND 2003
    AND s.Name = 'Mountain Bikes'
    AND e.Name = 'CARGO TRANSPORT 5';
    
-- Ejercicio 2
SELECT
	c.ContactID
    , SUM(d.OrderQty) AS cantidad
FROM salesorderheader  h
JOIN contact c
	ON h.ContactID = c.ContactID
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID
JOIN product p 
	ON d.ProductID = p.ProductID
JOIN productsubcategory s 
	ON p.ProductSubcategoryID = s.ProductSubcategoryID
WHERE 
	YEAR(h.OrderDate) BETWEEN 2000 AND 2003
    AND s.Name = 'Mountain Bikes'
GROUP BY 1
ORDER BY 2 DESC;

-- Ejercicio 3
SELECT
	YEAR(h.orderdate) AS año
    , s.name AS metodo_envio
    , SUM(d.OrderQty) AS cantidad_total
FROM salesorderheader h 
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID
JOIN shipmethod s 
	ON h.ShipMethodID = s.ShipMethodID
GROUP BY año, metodo_envio
ORDER BY año, metodo_envio;

-- Ejercicio 4
SELECT
	c.Name AS categoria
    , SUM(d.OrderQty) AS cantidad_total
    , SUM(d.LineTotal) AS venta_total
FROM salesorderheader  h
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID
JOIN product p 
	ON d.ProductID = p.ProductID
JOIN productsubcategory s 
	ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN productcategory c 
	ON s.ProductCategoryID = c.ProductCategoryID
GROUP BY categoria
ORDER BY venta_total DESC;


-- Validacion venta total
SELECT 
ROUND(OrderQty * (UnitPrice * (1 - UnitPriceDiscount)), 6) AS venta_total_calculada
, LineTotal
FROM adventureworks.salesorderdetail
WHERE ROUND(OrderQty * (UnitPrice * (1 - UnitPriceDiscount)), 6) <> LineTotal;

-- Ejercicio 5
SELECT
	cr.Name AS pais
    , SUM(d.OrderQty) AS cantidad_total
    , SUM(LineTotal) AS ventas_totales
FROM salesorderheader h
JOIN salesorderdetail d
	ON h.SalesOrderID = d.SalesOrderID
JOIN address a 
	ON h.ShipToAddressID = a.AddressID
JOIN stateprovince sp
	ON a.StateProvinceID = sp.StateProvinceID
JOIN countryregion cr 
	ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY pais
HAVING cantidad_total > 15000;









	





















