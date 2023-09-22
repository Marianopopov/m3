-- Active: 1693354461857@@127.0.0.1@3306@henry_04

select @@GLOBAL.secure_file_priv;
CREATE DATABASE if not EXISTS henry_04;

use henry_04;
SET GLOBAL local_infile = 'ON';

-- La tabla de puntos de venta propios, 
-- un Excel frecuentemente utilizado para 
-- contactar a cada sucursal, actualizada en 2021.
-- CanalDeVenta.xlsx   pasar a CSV
CREATE Table if not exists canal_venta(
      codigo INT PRIMARY KEY ,
      descripcion VARCHAR(50));

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\CanalDeVenta.csv'
INTO TABLE canal_venta  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
(codigo, descripcion);
#ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

SELECT * FROM canal_venta;
DROP Table canal_venta;
----------------------------------------------------------------------------------



-- La tabla de empleados, un Excel mantenido
--  por el personal administrativo de RRHH.
-- Empleados.xls  pasar CSV

CREATE Table if not exists empleados(
            id_empleado_unico int PRIMARY KEY AUTO_INCREMENT,
            ID_empleado INT,
            Apellido VARCHAR(50),
            Nombre VARCHAR(50),
            Sucursal VARCHAR(50),
            Sector VARCHAR(50),
            Cargo VARCHAR(50),
            Salario DECIMAL(10,2)
      );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\empleados.csv'
INTO TABLE empleados  
FIELDS TERMINATED BY ';'
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
(ID_empleado,Apellido,Nombre,Sucursal,Sector,Cargo,Salario);

SELECT * from empleados;
DROP table empleados;

-- La tabla de proveedores, un Excel mantenido por un analista 
-- de otra dirección que ya no esta en la empresa.
-- Proveedores.xlsx  pasar a CSV

CREATE Table if not exists proveedores(
                IDProveedor int PRIMARY KEY,
                Nombre VARCHAR(50),
                Address VARCHAR(50),
                City VARCHAR(50),
                State VARCHAR(50),
                Country VARCHAR(50),
                departamen VARCHAR(50)
      );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\proveedores.csv'
INTO TABLE proveedores  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;

SELECT * FROM proveedores;
DROP Table proveedores;

-- La tabla de clientes, alojada en el CRM de la empresa.
-- Clientes.csv  ya esta en CSV


CREATE Table clientes (
    ID INT Primary key,
    Provincia varchar(100),
    Nombre_y_Apellido varchar(100),
    Domicilio varchar(100),
    Telefono varchar(100),
    Edad int,
    Localidad varchar(100),
    X varchar(100),
    Y varchar(100),
    Fecha_Alta date,
    Usuario_Alta varchar(100),
    Fecha_Ultima_Modificacion date,
    Usuario_Ultima_Modificacion varchar(100),
    Marca_Baja varchar(100)
    );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\clientes.csv'
INTO TABLE clientes  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
(ID,Provincia,Nombre_y_Apellido,Domicilio,Telefono,Edad,Localidad,X,Y,Fecha_Alta,
Usuario_Alta,Fecha_Ultima_Modificacion,Usuario_Ultima_Modificacion,Marca_Baja);

SELECT * FROM clientes;
DROP Table clientes;



-- La tabla de productos, un Excel mantenido por otro analista.
-- PRODUCTOS.xlsx  pasar a CSV



CREATE Table productos (
            ID_PRODUCTO INT PRIMARY KEY,
            Concepto VARCHAR(100),
            Tipo VARCHAR(100),
            Precio decimal (10,2)
    );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\productos.csv'
INTO TABLE productos  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;

SELECT * FROM productos;
DROP Table productos;


-- Las tablas de ventas, gastos y compras, tres archivos CSV 
-- generados a partir del sistema transaccional de la empresa.
-- venta, gasto y compra (ya son CSV)


-- venta
CREATE Table venta (IdVenta int PRIMARY KEY,
                    Fecha DATE,
                    Fecha_Entrega DATE,
                    IdCanal INT,
                    IdCliente INT,
                    IdSucursal INT,
                    IdEmpleado INT,
                    IdProducto INT,
                    Precio DECIMAL(10,2),
                    Cantidad INT
    );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\venta.csv'
INTO TABLE venta  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT DISTINCT `IdVenta` FROM venta;
DROP Table venta;

-- gastos 
 
CREATE Table gasto (IdGasto int PRIMARY KEY,
                    IdSucursal INT,
                    IdTipoGasto INT,
                    Fecha date,
                    Monto DECIMAL (10,2)
    );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\gasto.csv'
INTO TABLE gasto  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT * FROM gasto;
DROP Table gasto;

-- Compra 

CREATE Table compra (IdCompra int PRIMARY KEY,
                    Fecha date,
                    IdProducto int,
                    Cantidad INT,
                    Precio DECIMAL(10,2),
                    IdProve int
    );

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\compra.csv'
INTO TABLE compra  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT * FROM compra;
DROP Table compra;

SELECT * from compra
where `IdProve` = 1;

-- sucursales

CREATE Table sucursales (ID int primary KEY,
                        Sucursal VARCHAR(50),
                        Direccion VARCHAR(100),
                        Localidad VARCHAR(100),
                        Provincia VARCHAR(100),
                        Latitud VARCHAR(50),
                        Longitud VARCHAR(50)
);

LOAD DATA LOCAL INFILE 
'C:\\Users\\maria\\Desktop\\HENRY\\m3\\Clases\\Clase 04\\Homework\\sucursales.csv'
INTO TABLE sucursales  
FIELDS TERMINATED BY ';'
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT * FROM sucursales;
DROP Table sucursales;

SELECT * from compra
where `IdProve` = 1;