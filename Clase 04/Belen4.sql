-- Active: 1693875076557@@127.0.0.1@3306@henry_04
-- La Dirección de Ventas ha solicitado las siguientes tablas a Marketing con el fin de que sean integradas:

-- 1) La tabla de puntos de venta propios.
-- 2) La tabla de empleados.
-- 3) La tabla de proveedores. 
-- 4) La tabla de clientes.
-- 5) La tabla de productos.
-- 6) La tabla de ventas.
-- 7) La tabla de gastos. 
-- 8) La tabla de compras.

-- 1)
CREATE DATABASE if not EXISTS henry_04;
use henry_04;
SET GLOBAL local_infile = 'ON';
CREATE Table if not exists canaldeventa(
      codigo INT PRIMARY KEY ,
      descripcion VARCHAR(50));

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\CanalDeVenta.csv'
INTO TABLE canaldeventa  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines

drop table canaldeventa

select * from canaldeventa

-- Si hay valores repetidos en una columna
SELECT descripcion, COUNT(*) as cantidad
FROM canaldeventa
GROUP BY descripcion
HAVING COUNT(*) > 1;

-- si hay valores nulos
select * from  canaldeventa where descripcion and codigo is null

-- 2)
CREATE Table if not exists empleados(
      ID_empleado int ,
      Apellido varchar (50),
      Nombre varchar (50),
      Sucursal varchar (50),
      Sector varchar (50),
      Cargo varchar (50),
      Salario decimal (10,2))


LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\Empleados.csv'
INTO TABLE empleados  
FIELDS TERMINATED BY ';'
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines

drop table empleados

select * from empleados


SELECT id_empleado, COUNT(*) as cantidad
FROM empleados
GROUP BY id_empleado
HAVING COUNT(*) > 1;

-- Hay 17 ID repetidos 

-- 3)
CREATE Table if not exists proveedores(
      IDProveedor int PRIMARY KEY,
      Nombre varchar (50),
      Address varchar (50),
      City varchar (50),
      State varchar (50),
      Country varchar (50),
      departamen varchar (50))

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\Proveedores.csv'
INTO TABLE proveedores  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines

drop table proveedores

select * from proveedores

select * from proveedores where Nombre = '';
-- Dos proveedores sin nombres

-- 4)
CREATE Table if not exists Clientes(
      ID int PRIMARY KEY,
      Provincia varchar (50),
      Nombre_y_Apellido varchar (100),
      Domicilio varchar (50),
      Telefono varchar (50),
      Edad int,
      Localidad varchar (50),
      X DECIMAL(13,10),
      Y DECIMAL(13,10),
      Fecha_Alta date,
      Usuario_Alta varchar (50),
      Fecha_Ultima_Modificacion date,
      Usuario_Ultima_Modificacion varchar (50),
      Marca_Baja int,
      col10 varchar (50))

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\Clientes.csv'
INTO TABLE Clientes  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines

drop table Clientes

select * from Clientes

select * from clientes where 'col10' is not null

-- 5)
CREATE Table if not exists Productos(
      ID_PRODUCTO int PRIMARY KEY,
      Concepto varchar(100),
      Tipo varchar(100),
      Precio decimal (10,2))

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\Productos.csv'
INTO TABLE Productos  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines


drop table Productos

select * from Productos

-- 6)
CREATE Table if not exists Ventas(
      IdVenta int PRIMARY KEY,
      Fecha date, 
      Fecha_Entrega date,
      IdCanal int,
      IdCliente int,
      IdSucursal int,
      IdEmpleado int,
      IdProducto int,
      Precio decimal(10,2),
      Cantidad int)

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\Venta.csv'
INTO TABLE Ventas  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines


drop table Ventas

select * from Ventas


-- 7)
CREATE Table if not exists TiposdeGasto(
      IdTipoGasto int PRIMARY KEY,
      Descripcion varchar (100),
      Monto_Aproximado int)

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\TiposDeGasto.csv'
INTO TABLE TiposdeGasto  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines


drop table TiposdeGasto

select * from TiposdeGasto



-- 8)
CREATE Table if not exists Compra(
      IdCompra int PRIMARY KEY,
      Fecha date, 
      IdProducto int,
      Cantidad int,
      Precio decimal (10,2),
      IdProveedor int)

LOAD DATA LOCAL INFILE 
'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework\\Compra.csv'
INTO TABLE Compra 
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines


drop table Compra

select * from Compra

select* from compra where `IdProveedor` is null


CREATE TABLE IF NOT EXISTS sucursales (
	ID	      INTEGER,
	Sucursal	VARCHAR(40),
	Domicilio	VARCHAR(150),
	Localidad	VARCHAR(80),
	Provincia	VARCHAR(50),
	Latitud	Decimal (13,10),
	Longitud	Decimal (13,10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


LOAD DATA INFILE 'C:\\Users\\belen\\OneDrive\\Escritorio\\M3\\m3\\Clase 04\\Homework_Resuelto\\Sucursales_UTF8.csv' 
INTO TABLE sucursales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '\"' ESCAPED BY '\"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM sucursal;

drop table sucursales