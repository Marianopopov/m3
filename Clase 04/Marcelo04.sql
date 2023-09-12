-- Active: 1693280239040@@127.0.0.1@3306@m3
CREATE DATABASE IF NOT EXISTS M3;
USE M3;



SET GLOBAL local_infile = 'ON';

-- La tabla de puntos de venta propios, 
-- un Excel frecuentemente utilizado para 
-- contactar a cada sucursal, actualizada en 2021.
-- CanalDeVenta.xlsx   pasar a CSV

DROP TABLE IF EXISTS canal_venta;

CREATE TABLE if NOT EXISTS canal_venta(
    IdCanalVenta    int primary key,
    descripcion     VARCHAR(50));


LOAD DATA INFILE 'C:\\Users\\Marcelo\\Documents\\Henry DataPT05\\m3\\Clase 04\\Homework\\CanalDeVenta.csv' 
-- Clase 04\Homework\CanalDeVenta.csv
INTO TABLE canal_venta 
FIELDS TERMINATED BY ',' ENCLOSED BY '\"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(IdCanalVenta, descripcion);



-- La tabla de empleados, un Excel mantenido
--  por el personal administrativo de RRHH.
-- Empleados.xls  pasar CSV





-- La tabla de proveedores, un Excel mantenido por un analista 
-- de otra dirección que ya no esta en la empresa.



-- La tabla de clientes, alojada en el CRM de la empresa.




-- La tabla de productos, un Excel mantenido por otro analista.



-- Las tablas de ventas, gastos y compras, tres archivos CSV 
-- generados a partir del sistema transaccional de la empresa.

