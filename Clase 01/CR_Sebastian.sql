USE adventureworks;

-- Pregunta 1

DELIMITER $$
CREATE PROCEDURE total_ordenes (IN fecha_orden DATE)
BEGIN
	SELECT
    COUNT(*)
    FROM salesorderheader
    WHERE DATE(orderdate) = fecha_orden;
END $$

DELIMITER ;

CALL total_ordenes('2002-01-01');

-- Punto 2 
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION margen_bruto (precio DECIMAL(15,3), margen DECIMAL(9,2)) RETURNS DECIMAL(15,3)
BEGIN
	DECLARE margen_precio DECIMAL(15,3);
    
    SET margen_precio = precio * (1 + margen);
    
    RETURN margen_precio;

END $$

DELIMITER ;

SELECT margen_bruto(100, 0.2);

-- Ejercicio 3
SELECT
	productid
    , name
    , listprice
    , standardcost
    , margen_bruto(standardcost, 0.2) AS list_price_margen
    , listprice - margen_bruto(standardcost, 0.2) AS diff
FROM product
ORDER BY 2;

-- Pregunta 4
DELIMITER $$
CREATE PROCEDURE gasto_transporte (IN fecha_desde DATE, IN fecha_hasta DATE)
BEGIN
	SELECT
    customerid
    , SUM(freight) AS total_transporte
    FROM salesorderheader
    WHERE DATE(orderdate) BETWEEN fecha_desde AND fecha_hasta
    GROUP BY customerid
    ORDER BY total_transporte DESC
    LIMIT 10;

END $$

DELIMITER ;
CALL gasto_transporte('2002-01-01', '2002-01-31');

-- Punto 5
DELIMITER $$
CREATE PROCEDURE carga_datos_ship_method (IN name VARCHAR(50), IN ship_base double, IN ShipRate double)
BEGIN
	INSERT INTO shipmethod (name, ShipBase, ShipRate)
    VALUES (name, ship_base, ShipRate);
END $$

DELIMITER ;
CALL carga_datos_ship_method('metodo_prueba', 1.5, 3.5);

SELECT * FROM shipmethod;







