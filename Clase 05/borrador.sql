-- Active: 1693280239040@@127.0.0.1@3306@henry_04

ALTER TABLE venta
ADD id_Vendedor int;

SELECT * FROM venta;

INSERT INTO venta (id_Vendedor)
VALUES (SELECT id_empleado_unico
FROM empleados
WHERE Id_empleado=1968)

SELECT id_empleado_unico
FROM empleados
WHERE Id_empleado=1968;

INSERT INTO nombre_de_la_tabla (columna1, columna2, ...)
VALUES (valor1, valor2, ...);



-- ID Repetidos:
-- ID_Empleados - Tabla Empleados (17 repetidos)
SELECT Id_Empleado, COUNT(*) FROM empleados GROUP BY Id_Empleado HAVING COUNT(*) > 1;
-- Datos Faltantes:
-- Nombre - Tabla Proveedores (2 proveedores)
select * from proveedores where Nombre = '';

-- Normalizar los noombres de las columnas de todas las tablas

ALTER TABLE `clientes` CHANGE `ID` `IdCliente` INT NOT NULL;
select * from clientes

ALTER TABLE `empleados` CHANGE `ID_Empleado` `IdEmpleado` INT NULL DEFAULT NULL;
select * from empleados

ALTER TABLE `proveedores` CHANGE `IDProveedor` `IdProveedor` INT NOT NULL;

select * from proveedores;

ALTER TABLE `tiposdegasto` CHANGE `Descripcion` `Tipo_Gasto` VARCHAR(100);

select * from tiposdegasto;

ALTER TABLE `productos` CHANGE `ID_PRODUCTO` `IdProducto` INT NOT NULL;

select * from productos;

 
