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


-- 3. Obtner un listado de productos en orden alfabético que muestre cuál 
-- debería ser el valor de precio de lista, si se quiere aplicar un
-- margen bruto del 20%, utilizando la función creada en el punto 2,
-- sobre el campo StandardCost.
-- Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.

SELECT Name,
		ListPrice as "precio de lista",
		margenBruto(StandardCost, 20) as "precio+20%",
		round(ListPrice - margenBruto(StandardCost, 20),3) as diferencia
FROM product
WHERE ListPrice!=0 and StandardCost!=0
ORDER BY Name;

SELECT Name,
		StandardCost as costo, 
		ListPrice as "precio de lista",
		round(100*(ListPrice/StandardCost-1),2) as margen_actual,
		margenBruto(StandardCost, 20) as "precio+20%",
		round(ListPrice - margenBruto(StandardCost, 20),3) as diferencia
FROM product
WHERE ListPrice!=0 and StandardCost!=0
ORDER BY margen_actual 
limit 5;

SELECT Name,
		StandardCost as costo, 
		ListPrice as "precio de lista",
		round(100*(ListPrice/StandardCost-1),2) as margen_actual,
		margenBruto(StandardCost, 20) as "precio+20%",
		round(ListPrice - margenBruto(StandardCost, 20),3) as diferencia
FROM product
WHERE ListPrice!=0 and StandardCost!=0
ORDER BY margen_actual desc
limit 5;

-- 4. Crear un procedimiento que reciba como parámetro una fecha desde y 
-- una hasta, y muestre un listado con los Id de los diez Clientes que 
-- más costo de transporte tienen entre esas fechas (campo Freight).

SELECT *
FROM salesorderheader;


DROP PROCEDURE IF EXISTS top10costoTransporte;

DELIMITER $$
CREATE PROCEDURE top10costoTransporte(IN fechainicio DATE, IN fechafinal DATE)
BEGIN
	SELECT CustomerID,
			ROUND(SUM(Freight),2) as CostoTransporte,
			COUNT(Freight) as cantidad
	FROM salesorderheader
	WHERE OrderDate BETWEEN fechainicio AND fechafinal
	GROUP BY CustomerID
	ORDER BY CostoTransporte DESC
	LIMIT 10;
END $$
DELIMITER ;

CALL top10costoTransporte('2000-1-1','2020-12-31');

SELECT CustomerID,
			SUM(Freight) as CostoTransporte
FROM salesorderheader
WHERE OrderDate BETWEEN '2002-3-1' AND '2002-3-10'
GROUP BY CustomerID
ORDER BY CostoTransporte DESC
LIMIT 100;

SELECT CustomerID,
			SUM(Freight) as CostoTransporte
FROM salesorderheader
WHERE OrderDate BETWEEN '2002-3-1' AND '2002-3-10'
GROUP BY CustomerID
ORDER BY CostoTransporte DESC
LIMIT 10;

SELECT CustomerID, Freight
FROM salesorderheader
WHERE DATE(OrderDate) BETWEEN '2002-3-1' AND '2002-3-10'
ORDER BY CustomerID;

SELECT CustomerID, Freight
FROM salesorderheader
WHERE DATE(OrderDate) BETWEEN '2002-3-1' AND '2002-3-10'
ORDER BY Freight DESC;

-- 5. Crear un procedimiento que permita realizar la insercción de 
-- datos en la tabla shipmethod.

DELIMITER $$
CREATE PROCEDURE inserta_ship(in nombre VARCHAR(50),
								 shipB DOUBLE,
								 shipR DOUBLE,
								  rowg VARBINARY(16)
								  )
BEGIN
	INSERT into shipmethod(Name, ShipBase, ShipRate, rowguid)
	VALUES(nombre, ShipB, ShipR, rowg);
END $$
DELIMITER ;

select * from shipmethod;

CALL inserta_ship("UnNombre", 15.95, 2.89,"NoSeQueVaAca");