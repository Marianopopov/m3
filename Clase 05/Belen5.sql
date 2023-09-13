-- Active: 1693875076557@@127.0.0.1@3306@henry_04

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

ALTER TABLE `productos` CHANGE `ID_PRODUCTO` `IdProducto` INT(11) NOT NULL;

select * from productos;

 
