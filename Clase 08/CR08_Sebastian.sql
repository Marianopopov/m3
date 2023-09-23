use henry_m3;
-- 1) Creamos la tabla que auditará a los usuarios que realizan cambios

DROP TABLE IF EXISTS `fact_venta_auditoria`;
CREATE TABLE IF NOT EXISTS `fact_venta_auditoria` (
	`Fecha`				DATE,
	`Fecha_Entrega`		DATE,
  	`IdCanal` 			INTEGER,
  	`IdCliente` 		INTEGER,
  	`IdEmpleado` 		INTEGER,
  	`IdProducto` 		INTEGER,
    `usuario` 			VARCHAR(20),
    `fechaModificacion` 	DATETIME
);

-- Creamos el trigger que se ejecutara luego de cada cambio
#DROP TRIGGER fact_venta_auditoria;
CREATE TRIGGER fact_venta_auditoria AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO fact_venta_auditoria (Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, usuario, fechaModificacion)
VALUES (NEW.Fecha, NEW.Fecha_Entrega, NEW.IdCanal, NEW.IdCliente, NEW.IdEmpleado, NEW.IdProducto, CURRENT_USER,NOW());

SELECT CURRENT_USER, NOW();

select CURRENT_USER,NOW();

-- truncate table fact_venta;
-- truncate table fact_venta_auditoria;

-- 2)
SELECT * FROM fact_venta_auditoria;
insert into fact_venta (IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad)
VALUES (100002, '2023-08-11', '2023-08-11', 1, 1, 1, 1, 1, 1);


select count(*) from fact_venta;
select count(*) from fact_venta_auditoria;

-- 3) Creamos la tabla que llevara una cuenta de los registros.
DROP TABLE IF EXISTS `fact_inicial_registros`;
CREATE TABLE IF NOT EXISTS `fact_inicial_registros` (
  	id 	INT NOT NULL AUTO_INCREMENT,
	cantidadRegistros INT,
	usuario VARCHAR (20),
	fecha DATETIME,
	PRIMARY KEY (id)
);

-- 4) Creamos el trigger que se ejecutara luego de cada cambio
DROP TRIGGER fact_venta_registros;
CREATE TRIGGER fact_venta_registros AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO fact_inicial_registros (cantidadRegistros,usuario, fecha)
VALUES ((SELECT COUNT(*) FROM fact_venta),CURRENT_USER,NOW());







-- 5) Creamos una tabla donde podremos almacenar la cantidad de registros por día
DROP TABLE registros_tablas;
CREATE TABLE registros_tablas (
id INT NOT NULL AUTO_INCREMENT,
tabla VARCHAR(30),
fecha DATETIME,
cantidadRegistros INT,
PRIMARY KEY (id)
);



-- Esta instrucción nos permite cargar la tabla anterior y saber cual es la cantidad de registros por día.
INSERT INTO registros_tablas (tabla, fecha, cantidadRegistros)
SELECT 'venta', Now(), COUNT(*) FROM venta;
INSERT INTO registros_tablas (tabla, fecha, cantidadRegistros)
SELECT 'gasto', Now(), COUNT(*) FROM gasto;
INSERT INTO registros_tablas (tabla, fecha, cantidadRegistros)
SELECT 'compra', Now(), COUNT(*) FROM compra;






SELECT * FROM registros_tablas;
show triggers;



-- 6) Creamos una tabla para auditar cambios
DROP TABLE IF EXISTS `fact_venta_cambios`;
CREATE TABLE IF NOT EXISTS `fact_venta_cambios` (
  	`Fecha` 			DATE,
  	`IdCliente` 		INTEGER,
  	`IdProducto` 		INTEGER,
    `Precio` 			DECIMAL(15,3),
    `Cantidad` 			INTEGER
);

-- Creamos el trigger que carga nuevos registros
-- DROP TRIGGER auditoria_cambios;
CREATE TRIGGER auditoria_cambios AFTER UPDATE ON fact_venta
FOR EACH ROW
INSERT INTO fact_venta_cambios (Fecha, IdCliente, IdProducto, Precio, Cantidad)
VALUES (OLD.Fecha,OLD.IdCliente, OLD.IdProducto, OLD.Precio, OLD.Cantidad);

-- 7)
SET SQL_SAFE_UPDATES = 0;

SELECT * FROM fact_venta_cambios;
select * from fact_venta where IdVenta = 83;
update fact_venta set Precio = 820 where IdVenta = 83;



-- Pregunta adicional
-- ¿ Qué porcentaje de productos se vendieron en junio de 2020, pero no en julio de 2020?



WITH
productos_junio AS (
SELECT DISTINCT 
	IdProducto
FROM venta
WHERE 
	YEAR(fecha) = 2020
    AND MONTH(fecha) = 6
)
, productos_julio AS (
SELECT DISTINCT 
	IdProducto
FROM venta
WHERE 
	YEAR(fecha) = 2020
    AND MONTH(fecha) = 7
)
SELECT 
	SUM(CASE WHEN jul.idproducto IS NULL THEN 1 ELSE 0 END)
	,(SUM(CASE WHEN jul.idproducto IS NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS porcentaje_productos
FROM productos_junio jun
LEFT JOIN productos_julio jul
	ON jun.idproducto = jul.idproducto;
