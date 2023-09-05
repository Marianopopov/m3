use adventureworks;

-- 1. Crear un procedimiento que recibe como parámetro una fecha

-- y muestre la cantidad de órdenes ingresadas en esa fecha.<br>

DROP PROCEDURE CantidadDeOrdenes;

DELIMITER $$

CREATE PROCEDURE CANTIDADDEORDENES(IN FECHA DATE) BEGIN 
SELECT 
	SELECT
	    COUNT(OrderDate) as Cantidad_Ordenes
	FROM salesorderheader
	WHERE DATE(OrderDate) = fecha;
	END $$ 


DELIMITER ;

SELECT
    DATE(OrderDate),
    COUNT(`OrderDate`) as cant_ord
FROM salesorderheader
GROUP BY DATE(OrderDate)
ORDER BY cant_ord DESC;

CALL CantidadDeOrdenes('2004-05-01');

CALL CantidadDeOrdenes('2004-03-01');

CALL CantidadDeOrdenes('2004-02-01');

CALL CantidadDeOrdenes('2020-02-01');

-- 2. Crear una función que calcule el valor nominal de un margen bruto

-- determinado por el usuario a partir del precio de lista de los productos.