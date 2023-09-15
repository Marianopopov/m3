-- Active: 1693280239040@@127.0.0.1@3306@henry_04
DROP DATABASE if EXISTS henry_04;


CREATE DATABASE if not EXISTS henry_04;


SELECT @@global.secure_file_priv;

use henry_04;
SET GLOBAL local_infile = 'ON';

-- La tabla de puntos de venta propios, 
-- un Excel frecuentemente utilizado para 
-- contactar a cada sucursal, actualizada en 2021.
-- CanalDeVenta.xlsx   pasar a CSV

DROP TABLE IF EXISTS canal_venta;
CREATE Table if not exists canal_venta(
      codigo INT PRIMARY KEY ,
      descripcion VARCHAR(50))
      ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CanalDeVenta.csv'
INTO TABLE canal_venta  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
(codigo, descripcion)
;

SELECT * FROM canal_venta;

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
      )
      ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\empleados.csv'
INTO TABLE empleados  
FIELDS TERMINATED BY ';'
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
(ID_empleado,Apellido,Nombre,Sucursal,Sector,Cargo,Salario);

SELECT * from empleados;

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
      )
      ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\proveedores.csv'
INTO TABLE proveedores  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;

SELECT * FROM proveedores;

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
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\clientes.csv'
INTO TABLE clientes  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
(ID,Provincia,Nombre_y_Apellido,Domicilio,Telefono,Edad,Localidad,X,Y,Fecha_Alta,
Usuario_Alta,Fecha_Ultima_Modificacion,Usuario_Ultima_Modificacion,Marca_Baja);

SELECT * FROM clientes;


-- La tabla de productos, un Excel mantenido por otro analista.
-- PRODUCTOS.xlsx  pasar a CSV



CREATE Table productos (
            ID_PRODUCTO INT PRIMARY KEY,
            Concepto VARCHAR(100),
            Tipo VARCHAR(100),
            Precio decimal (10,2)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\productos.csv'
INTO TABLE productos  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;

SELECT * FROM productos;

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
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\venta.csv'
INTO TABLE venta  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT DISTINCT `IdVenta` FROM venta;

-- gastos 
 
CREATE Table gasto (IdGasto int PRIMARY KEY,
                    IdSucursal INT,
                    IdTipoGasto INT,
                    Fecha date,
                    Monto DECIMAL (10,2)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\gasto.csv'
INTO TABLE gasto  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT * FROM gasto;

-- Compra 

CREATE Table compra (IdCompra int PRIMARY KEY,
                    Fecha date,
                    IdProducto int,
                    Cantidad INT,
                    Precio DECIMAL(10,2),
                    IdProve int
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\compra.csv'
INTO TABLE compra  
FIELDS TERMINATED BY ','
ENCLOSED BY '\"' 
ESCAPED BY '\"' 
LINES TERMINATED BY '\n'
ignore 1 lines
;
SELECT * FROM compra;

DROP TABLE IF EXISTS sucursal;
CREATE TABLE IF NOT EXISTS sucursal (
	ID			INTEGER,
	Sucursal	VARCHAR(40),
	Domicilio	VARCHAR(150),
	Localidad	VARCHAR(80),
	Provincia	VARCHAR(50),
	Latitud2	VARCHAR(30),
	Longitud2	VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA INFILE
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Sucursales_ANSI.csv'
INTO TABLE sucursal
CHARACTER SET latin1 -- Si no colocamos esta línea, no reconoce la codificación adecuada ANSI
FIELDS TERMINATED BY ';' ENCLOSED BY '\"' ESCAPED BY '\"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SELECT * FROM sucursal;

DROP TABLE IF EXISTS tipo_gasto;


CREATE TABLE IF NOT EXISTS `tipo_gasto` (
  `IdTipoGasto` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) NOT NULL,
  `Monto_Aproximado` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`IdTipoGasto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA INFILE 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TiposDeGasto.csv' 
INTO TABLE `tipo_gasto` 
FIELDS TERMINATED BY ',' ENCLOSED BY '\"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SELECT * FROM tipo_gasto;