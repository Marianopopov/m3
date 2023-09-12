-- Active: 1693354461857@@127.0.0.1@3306@henry_04
CREATE DATABASE if not EXISTS henry_04;

use henry_04;
SET GLOBAL local_infile = 'ON';

-- La tabla de puntos de venta propios, 
-- un Excel frecuentemente utilizado para 
-- contactar a cada sucursal, actualizada en 2021.
-- CanalDeVenta.xlsx   pasar a CSV
CREATE Table canal_venta(codigo INT, descripcion VARCHAR(50));

LOAD DATA LOCAL INFILE 'C:\\Users\\maria\\Desktop\\HENRY\\MOD 3\\Clases\\Clase 04\\Homework\\CanalDeVenta.csv'
INTO TABLE canal_venta  
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(codigo, descripcion);

SELECT * FROM canal_venta;

----------------------------------------------------------------------------------

CREATE Table clientes_bkp (
      ID int primary key 
    , Provincia varchar(50)
    , Nombre_y_Apellido varchar(50)
    , Domicilio varchar(100)
    , Telefono int
    , Edad int
    , Localidad varchar(50)
    , X VARCHAR (50)
    , Y VARCHAR (50)
    , col10 int
    );

LOAD DATA LOCAL INFILE 'C:\\Users\\maria\\Desktop\\HENRY\\MOD 3\\Clases\\Clase 04\\Homework\\Clientes_bkp.csv'
INTO TABLE clientes_bkp  
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(ID,Provincia,Nombre_y_Apellido,Domicilio,Telefono,Edad,Localidad,X,Y,col10);

SELECT * FROM clientes_bkp;
DROP Table clientes_bkp;

-- La tabla de empleados, un Excel mantenido
--  por el personal administrativo de RRHH.
-- Empleados.xls  pasar CSV





-- La tabla de proveedores, un Excel mantenido por un analista 
-- de otra dirección que ya no esta en la empresa.
-- Proveedores.xlsx  pasar a CSV


-- La tabla de clientes, alojada en el CRM de la empresa.
-- Clientes.csv  ya esta en CSV




-- La tabla de productos, un Excel mantenido por otro analista.
-- PRODUCTOS.xlsx  pasar a CSV



-- Las tablas de ventas, gastos y compras, tres archivos CSV 
-- generados a partir del sistema transaccional de la empresa.
-- venta, gasto y compra (ya son CSV)