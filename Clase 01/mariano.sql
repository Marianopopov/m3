use adventureworks;

-- 1 Crear el procedimiento

SELECT * from salesorderheader;

DELIMITER $$
CREATE PROCEDURE ContarOrdenesPorFecha(IN fechaBusqueda DATE)
BEGIN
  DECLARE cantidadOrdenes INT;

  SELECT COUNT(*) INTO cantidadOrdenes
  FROM salesorderheader
  WHERE DATE(OrderDate) = fechaBusqueda;
  
  SELECT CONCAT('La cantidad de órdenes ingresadas en la fecha ', fechaBusqueda, ' es: ', cantidadOrdenes) AS Resultado;
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


SELECT CalcularMargenBruto(59.45, 1.2) AS MargenBruto;


-- 3 Obtner un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, 
-- si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo StandardCost. 
-- Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.
DELIMITER $$
CREATE PROCEDURE diferenciaprecio()
begin
SELECT 	ProductID,
		    Name,
        ProductNumber,
        ListPrice,
        CalcularMargenBruto(StandardCost, 1.2) as ListPriceMargenPropuesto,
        ListPrice - CalcularMargenBruto(StandardCost, 1.2) as Diferencia
FROM product
ORDER BY Name;
end;
delimiter ;

call diferenciaprecio()

SELECT * from product
where `ProductID` = 879;

-- 4 Crear un procedimiento que reciba como parámetro una fecha desde y una hasta, 
-- y muestre un listado con los Id de los diez Clientes que más costo de transporte tienen entre esas fechas (campo Freight).

DELIMITER $$
create PROCEDURE costoTransporte(fecha1 date ,fecha2 date)

begin
    select orderdate, customerid, freight from salesorderheader
    where `OrderDate`  < date(fecha2) and `OrderDate` > date(fecha1)
    ORDER BY freight desc
    limit 10; 
end;
delimiter ;

call `costoTransporte`('2003-09-01', '2003-09-03');

-- 
DELIMITER $$
create PROCEDURE costoTransporte2(fecha1 date ,fecha2 date)

begin
    select orderdate, customerid, freight from salesorderheader
    where `OrderDate`  BETWEEN date(fecha1) and date(fecha2)
    ORDER BY freight desc
    limit 100; 
end;
delimiter ;

call `costoTransporte2`('2003-09-02', '2003-09-02');


-- 5 Crear un procedimiento que permita realizar la insercción de datos en la tabla shipmethod.


SELECT * from shipmethod;

DELIMITER $$
CREATE PROCEDURE insertar(in nombre VARCHAR(50),
                             shipB DOUBLE,
                              shipR DOUBLE, 
                              rowguid varbinary(16)
                              )
begin
      INSERT INTO shipmethod(Name, ShipBase, shiprate, rowguid) 
      values (nombre, shipb, shipr, rowguid);
end ;
DELIMITER ;

call insertar('nombre', 55, 4.55, 'Lalala');

