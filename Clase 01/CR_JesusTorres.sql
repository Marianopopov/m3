
SHOW DATABASES;

USE AdventureWorks;

-- 1

DROP PROCEDURE IF EXISTS conteo_ordenes_fecha;
DELIMITER $$
CREATE PROCEDURE conteo_ordenes_fecha(IN fecha DATE)
BEGIN
	SELECT COUNT(*)
	FROM salesorderheader
	WHERE DATE(OrderDate) = fecha;
END$$
DELIMITER ;

CALL conteo_ordenes_fecha('2001-08-05');

-- 2
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION margen_bruto(precio DECIMAL(15,3), margen DECIMAL(15,3)) RETURNS DECIMAL(15,3) DETERMINISTIC
BEGIN
	DECLARE margen_bruto DECIMAL(15,3);
    SET margen_bruto = precio * margen;
    RETURN margen_bruto;
END$$
DELIMITER ;

SELECT margen_bruto(10, 5);

-- 4
DROP PROCEDURE IF EXISTS gasto_transporte_top;
DELIMITER $$
CREATE PROCEDURE gasto_transporte_top(IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
	SELECT 
		CustomerID,
		SUM(Freight) as costo_transporte
	FROM salesorderheader
	WHERE DATE(OrderDate) BETWEEN fecha_inicio AND fecha_fin
	GROUP BY CustomerID
	ORDER BY costo_transporte DESC
	LIMIT 10;
END$$
DELIMITER ;


CALL gasto_transporte_top('2001-06-30','2001-07-01');

-- 5
DROP PROCEDURE IF EXISTS insercion_ship_method;
DELIMITER $$
CREATE PROCEDURE insercion_ship_method(IN Nombre VARCHAR(50), IN ShipBase DECIMAL(10,2), IN ShipRate DECIMAL(10,2))
BEGIN 
	INSERT INTO shipmethod (Name, ShipBase,ShipRate,ModifiedDate)
    VALUES (Nombre, ShipBase, ShipRate,NOW());
END$$
DELIMITER ;

CALL insercion_ship_method('Prueba',0.5,0.5);

SELECT * FROM shipmethod;


