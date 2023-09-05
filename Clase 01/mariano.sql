use adventureworks;

-- 1 Crear el procedimiento

SELECT * from salesorderheader;

DELIMITER $$
CREATE PROCEDURE ContarOrdenesPorFecha(IN fechaBusqueda DATE)
BEGIN

  SELECT COUNT(*)
  FROM salesorderheader
  WHERE DATE(OrderDate) = fechaBusqueda;
  
END;
DELIMITER ;


-- Llamar al procedimiento con la fecha de búsqueda 
CALL ContarOrdenesPorFecha('2001-07-15');


SELECT COUNT(*)
FROM salesorderheader
WHERE orderdate = '2001-07-15'
LIMIT 2;


-- 2 Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario 
-- a partir del precio de lista de los productos.

DELIMITER $$

CREATE FUNCTION CalcularMargenBruto(
    precio DECIMAL(10, 2),
    margen DECIMAL(10, 2)
    )

RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE margen_bruto DECIMAL(10, 2);

    SET margen_bruto = precio * margen;
    
    RETURN margen_bruto;
END $$

DELIMITER ;


SELECT CalcularMargenBruto(100.00, 20.0) AS MargenBruto;


-- 3 Obtner un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, 
-- si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo StandardCost. 
-- Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.

SELECT 	ProductID,
		    Name,
        ProductNumber,
        ListPrice,
        CalcularMargenBruto(StandardCost, 1.2) as ListPriceMargenPropuesto,
        ListPrice - CalcularMargenBruto(StandardCost, 1.2) as Diferencia
FROM product
ORDER BY Name;


SELECT * from product;