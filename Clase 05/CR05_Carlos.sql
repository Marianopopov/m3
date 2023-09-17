## CR5 Calidad de datos

######################### Función UCWords

SET GLOBAL log_bin_trust_function_creators = 1;

-- 8 y 9)
/*Función y Procedimiento provistos*/
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$

DELIMITER ;
DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

########################
USE henry_datapt05;

### Homologación de nombres 
### id_canal, nombre_canal

### Canal venta
ALTER TABLE canal_venta CHANGE CODIGO id_canal INTEGER NOT NULL;
ALTER TABLE canal_venta CHANGE DESCRIPCION nombre_canal VARCHAR(100) NOT NULL;

### Cliente

ALTER TABLE cliente DROP COLUMN col10; ### Eliminar columna;

UPDATE cliente 
SET Nombre_y_Apellido = UC_Words(Nombre_y_Apellido);

UPDATE cliente 
SET domicilio = UC_Words(domicilio);

UPDATE cliente 
SET localidad = UC_Words(localidad);

ALTER TABLE cliente CHANGE id id_cliente INTEGER NOT NULL;
ALTER TABLE cliente CHANGE nombre_y_apellido nombre_cliente VARCHAR(200);

UPDATE cliente
SET x = REPLACE(x, ',','.'),
	y = REPLACE(y, ',','.');
;


UPDATE cliente
SET x = NULL
WHERE
x = '';
UPDATE cliente
SET y = NULL
WHERE
y = '';


ALTER TABLE cliente CHANGE x latitud FLOAT; ## Lo corta a 4
ALTER TABLE cliente CHANGE y longitud DECIMAL(10,8); ## Se define el número de decimales

;


###### Compra

ALTER TABLE compra CHANGE idCompra id_compra INTEGER NOT NULL;
ALTER TABLE compra CHANGE idProducto id_producto INTEGER NOT NULL;
ALTER TABLE compra CHANGE idProveedor id_proveedor INTEGER NOT NULL;

;


###### Empleados

ALTER TABLE empleados CHANGE idempleado id_empleado INTEGER NOT NULL;
;

SELECT
*
FROM
empleados
WHERE
id_empleado
IN 
(
SELECT DISTINCT
id_empleado
FROM
(
	SELECT
	id_empleado,
	COUNT(*)
	FROM
	empleados
	GROUP BY
	id_empleado
	HAVING 
	count(*) > 1
) A )
order by id_empleado
;


### Gasto

ALTER TABLE gasto CHANGE idGasto id_gasto INTEGER NOT NULL;
ALTER TABLE gasto CHANGE idSucursal id_sucursal INTEGER NOT NULL;
ALTER TABLE gasto CHANGE idTipoGasto id_tipogasto INTEGER NOT NULL;
;

### Producto

UPDATE producto
SET concepto = UC_Words(concepto);


UPDATE producto
SET tipo = UC_Words(tipo);

ALTER TABLE producto CHANGE idproducto id_producto INTEGER NOT NULL;
### Proveedor
;

UPDATE proveedor
SET nombre = 'Sin nombre'
WHERE
nombre = ''
;

UPDATE proveedor
SET address = UC_Words(address),
	city = UC_Words(city),
    state = UC_Words(state),
    country = UC_Words(country),
    department = UC_Words(department)
    ;
ALTER TABLE proveedor CHANGE address direccion VARCHAR(100) ;
ALTER TABLE proveedor CHANGE city ciudad VARCHAR(100) ;
ALTER TABLE proveedor CHANGE state estado VARCHAR(100) ;
ALTER TABLE proveedor CHANGE department localidad VARCHAR(100) ;
ALTER TABLE proveedor CHANGE country pais VARCHAR(100) ;
ALTER TABLE proveedor CHANGE idproveedor id_proveedor INTEGER NOT NULL ;

;


#### Sucursal

UPDATE sucursal
SET latitud = REPLACE(latitud, ',','.'),
	longitud = REPLACE(longitud, ',','.')
;

ALTER TABLE sucursal CHANGE latitud latitud DECIMAL(10,8) ;
ALTER TABLE sucursal CHANGE longitud longitud DECIMAL(10,8) ;
ALTER TABLE sucursal CHANGE id id_sucursal INTEGER NOT NULL ;
 ### Tipo de gasto


ALTER TABLE tipo_gasto CHANGE idtipogasto id_tipogasto INTEGER NOT NULL ;


### venta

ALTER TABLE venta CHANGE idVenta id_venta INTEGER NOT NULL ;
ALTER TABLE venta CHANGE idCanal id_canal INTEGER NOT NULL ;
ALTER TABLE venta CHANGE idCliente id_cliente INTEGER NOT NULL ;
ALTER TABLE venta CHANGE idSucursal id_sucursal INTEGER NOT NULL ;
ALTER TABLE venta CHANGE idEmpleado id_empleado INTEGER NOT NULL ;
ALTER TABLE venta CHANGE idProducto id_producto INTEGER NOT NULL ;


UPDATE venta
SET precio = NULL 
WHERE precio = '';


UPDATE venta
SET cantidad = null
WHERE cantidad = '\r';


ALTER TABLE venta ADD COLUMN flag_revision INTEGER;


UPDATE venta
SET flag_revision = 1 
WHERE cantidad IS NULL
;


ALTER TABLE venta CHANGE precio precio DECIMAL(10,2);


### MySQL
UPDATE venta A
INNER JOIN
producto B
ON A.id_producto = B.id_producto
SET A.precio = B.precio
WHERE 
A.precio IS NULL;


#### Normalizar cargo y sector
#### Normalizar tipo de producto

CREATE TABLE cargo
(
id_cargo INTEGER PRIMARY KEY AUTO_INCREMENT,
nombre_cargo VARCHAR(100)
);


CREATE TABLE sector
(
id_sector INTEGER PRIMARY KEY AUTO_INCREMENT,
nombre_sector VARCHAR(100)
);

INSERT INTO cargo (nombre_cargo)
SELECT DISTINCT
cargo
FROM
empleados

;
INSERT INTO sector (nombre_sector)
SELECT DISTINCT
sector
FROM
empleados


;

ALTER TABLE empleados ADD COLUMN id_sector INTEGER;
ALTER TABLE empleados ADD COLUMN id_cargo INTEGER;

UPDATE empleados A
INNER JOIN
sector B
ON A.sector = B.nombre_sector
SET A.id_sector = B.id_sector;


UPDATE empleados A
INNER JOIN
cargo B
ON A.cargo = B.nombre_cargo
SET A.id_cargo = B.id_cargo;

ALTER TABLE empleados DROP COLUMN sector;
ALTER TABLE empleados DROP COLUMN cargo;


#### Tipo producto

CREATE TABLE tipo_producto
(
	id_tipoproducto INTEGER PRIMARY KEY AUTO_INCREMENT,
    des_tipoproducto VARCHAR(100)
);

UPDATE 
producto
SET tipo = 'Varios'
WHERE 
tipo = '';

INSERT INTO tipo_producto (des_tipoproducto)
SELECT DISTINCT
tipo
FROM
producto;

ALTER TABLE producto ADD COLUMN id_tipoproducto INTEGER;


UPDATE producto A
INNER JOIN
tipo_producto B
ON A.tipo = B.des_tipoproducto
SET A.id_tipoproducto = B.id_tipoproducto;

ALTER TABLE producto DROP COLUMN tipo;

SELECT
*
FROM
producto;

