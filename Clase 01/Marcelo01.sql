use adventureworks;

-- 1. Crear un procedimiento que recibe como parámetro una fecha

-- y muestre la cantidad de órdenes ingresadas en esa fecha.<br>

DROP PROCEDURE CantidadDeOrdenes;

DELIMITER $$
CREATE PROCEDURE CantidadDeOrdenes(IN FECHA DATE)
BEGIN
	SELECT COUNT(OrderDate) as Cantidad_Ordenes
	FROM salesorderheader
	WHERE DATE(OrderDate) = fecha;
END $$
DELIMITER ;

-- 10 Fechas con mayores ordenes
SELECT DATE(OrderDate), COUNT(`OrderDate`) as cant_ord
FROM salesorderheader
GROUP BY DATE(OrderDate)
ORDER BY cant_ord DESC
LIMIT 10;

-- 10 Fechas con menores ordenes
SELECT DATE(OrderDate), COUNT(`OrderDate`) as cant_ord
FROM salesorderheader
GROUP BY DATE(OrderDate)
ORDER BY cant_ord
LIMIT 10;

CALL CantidadDeOrdenes('2004-05-01');
CALL CantidadDeOrdenes('2004-03-01');
CALL CantidadDeOrdenes('2004-02-01');
CALL CantidadDeOrdenes('2020-02-01');

-- 2. Crear una función que calcule el valor nominal de un margen bruto
-- determinado por el usuario a partir del precio de lista de los productos.
SET GLOBAL log_bin_trust_function_creators=1;


DROP FUNCTION margenBruto;

DELIMITER $$
CREATE FUNCTION margenBruto(
	precio DECIMAL(10,3),
	margen DECIMAL(10,2))  -- valor porcentual Ej: 22% 
	RETURNS DECIMAL(10,3)
	DETERMINISTIC
BEGIN 
	DECLARE margenBruto DECIMAL(10,3);
	SET margenBruto = precio + precio*margen/100;
	RETURN margenBruto;
END $$ 
DELIMITER ;

SELECT margenBruto(100, 20) as Precio_Final;
SELECT margenBruto(100, -25) as Precio_Final;
SELECT margenBruto(120.50, 31.17) as Precio_Final;



