use adventureworks;

-- 1. Crear un procedimiento que recibe como parámetro una fecha y muestre la cantidad de órdenes ingresadas en 
-- esa fecha.
select*from salesorderheader;

delimiter $$
create procedure Ordenes_Ingresadas (in fecha date)
begin
select count(*) from salesorderheader where date(orderdate)=fecha;
end $$
delimiter ;

call Ordenes_ingresadas('2001-07-01');

-- 2) Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a 
-- partir del precio de lista de los productos.
select * from product;

delimiter $$
create function valor_nominal(precio decimal(10,5), margen decimal (10,5)) returns decimal (10,5)
deterministic
begin
	declare valor_nominal decimal (10,5);
    set valor_nominal = precio * margen;
    return valor_nominal;
end$$
delimiter ;

select valor_nominal(100.00, 1.2);
 
 -- 3)  Obtner un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, 
 -- si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo 
 -- StandardCost. Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.
 
 delimiter $$
 create procedure listado_precio ()
 begin
 select productid, name, productnumber, listprice, valor_nominal(standardCost, 1.2) as listapreciopropuesto,
 listPrice - valor_nominal(StandardCost, 1.2) as Diferencia
FROM product ORDER BY Name;
end $$
delimiter ;

call listado_precio();

-- 4) Crear un procedimiento que reciba como parámetro una fecha desde y una hasta y muestre un listado con 
-- los Id de los diez Clientes que más costo de transporte tienen entre esas fechas (campo Freight).

delimiter $$
create procedure costo_transporte(fecha_desde date, fecha_hasta date)
begin
	select orderdate, customerid, freight from salesorderheader 
    where orderdate between date(fecha_desde) and date(fecha_hasta)
    order by freight desc
    limit 10;
    end $$
    delimiter ;

call costo_transporte ('2001-07-01', '2001-07-13');

-- 5)Crear un procedimiento que permita realizar la insercción de datos en la tabla shipmethod.
select*from shipmethod;

delimiter $$
create procedure insertar_datos (in nombre varchar (50), enviob double, envior double, rg varbinary(15), fecha_modificada date)
begin
	insert into shipmethod(name, shipbase, shiprate, rowguid, modifieddate)
    values (nombre, enviob, envior, rg,fecha_modificada);
    end $$
    delimiter ;

call insertar_datos ('nombre', 2.55,5.33, 'hola553', '2020-05-09');

select * from shipmethod;