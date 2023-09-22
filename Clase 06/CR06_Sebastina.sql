use henry_m3;

SET SQL_SAFE_UPDATES = 0;

/*Normalización Localidad Provincia*/
DROP TABLE IF EXISTS aux_Localidad;
CREATE TABLE IF NOT EXISTS aux_Localidad (
	Localidad_Original	VARCHAR(80),
	Provincia_Original	VARCHAR(50),
	Localidad_Normalizada	VARCHAR(80),
	Provincia_Normalizada	VARCHAR(50),
	IdLocalidad			INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


/*Notar la difernecia entre el UNION y el UNION ALL*/
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente where Localidad = 'Avellaneda'
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal where Localidad = 'Avellaneda'
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor where Ciudad = 'Avellaneda'
ORDER BY 2, 1;




SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente where Localidad = 'Avellaneda'
UNION ALL
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal where Localidad = 'Avellaneda'
UNION ALL
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor where Ciudad = 'Avellaneda'
ORDER BY 2, 1;





INSERT INTO aux_localidad (Localidad_Original, Provincia_Original, Localidad_Normalizada, Provincia_Normalizada, IdLocalidad)
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor
ORDER BY 2, 1;

SELECT * FROM aux_localidad ORDER BY Provincia_Original;






UPDATE `aux_localidad` SET Provincia_Normalizada = 'Buenos Aires'
WHERE Provincia_Original IN ('B. Aires',
                            'B.Aires',
                            'Bs As',
                            'Bs.As.',
                            'Buenos Aires',
                            'C Debuenos Aires',
                            'Caba',
                            'Ciudad De Buenos Aires',
                            'Pcia Bs As',
                            'Prov De Bs As.',
                            'Provincia De Buenos Aires');
							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Capital Federal'
WHERE Localidad_Original IN ('Boca De Atencion Monte Castro',
                            'Caba',
                            'Cap.   Federal',
                            'Cap. Fed.',
                            'Capfed',
                            'Capital',
                            'Capital Federal',
                            'Cdad De Buenos Aires',
                            'Ciudad De Buenos Aires')
AND Provincia_Normalizada = 'Buenos Aires';





							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Córdoba'
WHERE Localidad_Original IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba')
AND Provincia_Normalizada = 'Córdoba';

SELECT * FROM aux_localidad;

DROP TABLE IF EXISTS `localidad`;
CREATE TABLE IF NOT EXISTS `localidad` (
  `IdLocalidad` int(11) NOT NULL AUTO_INCREMENT,
  `Localidad` varchar(80) NOT NULL,
  `Provincia` varchar(80) NOT NULL,
  `IdProvincia` int(11) NOT NULL,
  PRIMARY KEY (`IdLocalidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

DROP TABLE IF EXISTS `provincia`;
CREATE TABLE IF NOT EXISTS `provincia` (
  `IdProvincia` int(11) NOT NULL AUTO_INCREMENT,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`IdProvincia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO Localidad (Localidad, Provincia, IdProvincia)
SELECT	DISTINCT Localidad_Normalizada, Provincia_Normalizada, 0
FROM aux_localidad
ORDER BY Provincia_Normalizada, Localidad_Normalizada;

SELECT * FROM Localidad;

INSERT INTO provincia (Provincia)
SELECT DISTINCT Provincia_Normalizada
FROM aux_localidad
ORDER BY Provincia_Normalizada;

select * from provincia;
select * from localidad;




UPDATE localidad l JOIN provincia p
	ON (l.Provincia = p.Provincia)
SET l.IdProvincia = p.IdProvincia;

SELECT * FROM localidad;



UPDATE aux_localidad a JOIN localidad l 
			ON (l.Localidad = a.Localidad_Normalizada
                AND a.Provincia_Normalizada = l.Provincia)
SET a.IdLocalidad = l.IdLocalidad;


select * from aux_localidad;
SELECT * FROM localidad;

ALTER TABLE `cliente` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Localidad`;
ALTER TABLE `proveedor` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Departamento`;
ALTER TABLE `sucursal` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Provincia`;

UPDATE cliente c JOIN aux_localidad a
	ON (c.Provincia = a.Provincia_Original AND c.Localidad = a.Localidad_Original)
SET c.IdLocalidad = a.IdLocalidad;

UPDATE sucursal s JOIN aux_localidad a
	ON (s.Provincia = a.Provincia_Original AND s.Localidad = a.Localidad_Original)
SET s.IdLocalidad = a.IdLocalidad;

UPDATE proveedor p JOIN aux_localidad a
	ON (p.Provincia = a.Provincia_Original AND p.Ciudad = a.Localidad_Original)
SET p.IdLocalidad = a.IdLocalidad;

select * from cliente;
select * from proveedor;
select * from sucursal;

ALTER TABLE `cliente`
  DROP `Provincia`,
  DROP `Localidad`;
  
ALTER TABLE `proveedor`
  DROP `Ciudad`,
  DROP `Provincia`,
  DROP `Pais`,
  DROP `Departamento`;
  
ALTER TABLE `sucursal`
  DROP `Localidad`,
  DROP `Provincia`;
  
ALTER TABLE `localidad`
  DROP `Provincia`;
  
  SELECT * FROM localidad;
  
SELECT * FROM `cliente`;
SELECT * FROM `proveedor`;
SELECT * FROM `sucursal`;
SELECT * FROM `localidad`;
SELECT * FROM `provincia`;

/*Discretización*/
ALTER TABLE `cliente` ADD `Rango_Etario` VARCHAR(20) NOT NULL DEFAULT '-' AFTER `Edad`;

UPDATE cliente
SET Rango_Etario = CASE
    WHEN Edad <= 30 THEN '1_Hasta 30 años'
    WHEN Edad <= 40 THEN '2_De 31 a 40 años'
    WHEN Edad <= 50 THEN '3_De 41 a 50 años'
    WHEN Edad <= 60 THEN '4_De 51 a 60 años'
    ELSE '5_Desde 60 años'
END
WHERE Rango_Etario = '-';  

select Rango_Etario, count(*)
from cliente
group by Rango_Etario
ORDER BY 2 DESC;

/*Deteccion y corrección de Outliers sobre ventas*/
/*Motivos:
2-Outlier de Cantidad
3-Outlier de Precio
*/
-- Detección de outliers
SELECT 
	IdProducto
    , AVG(Precio) AS promedio
    , AVG(Precio) + (3 * stddev(Precio)) AS maximo
FROM venta
GROUP BY IdProducto;

SELECT 
	IdProducto
    , AVG(Precio) AS promedio
    , AVG(Precio) - (3 * stddev(Precio)) AS minimo
FROM venta
GROUP BY IdProducto
HAVING minimo > 0;

SELECT precio FROM venta WHERE idproducto = 42764;

-- Detección de Outliers
WITH
precio_max_min AS (
	SELECT 
		IdProducto
		, AVG(Precio) AS promedio
		, AVG(Precio) + (3 * stddev(Precio)) AS maximo
		, AVG(Precio) - (3 * stddev(Precio)) AS minimo
	FROM venta
	GROUP BY IdProducto
)
SELECT 
	v.*
    , o.promedio
    , o.maximo
    , o.minimo
FROM venta v
JOIN precio_max_min o
	ON v.IdProducto = o.IdProducto
WHERE 
	v.Precio > o.maximo 
    OR v.Precio < minimo;

SELECT *
FROM venta
WHERE IdProducto = 42890;

WITH 
cantidad_min_max AS (
	SELECT 
		IdProducto
		, AVG(Cantidad) AS promedio
		, AVG(Cantidad) + (3 * stddev(Cantidad)) AS maximo
		, AVG(Cantidad) - (3 * stddev(Cantidad)) AS minimo
	FROM venta
	GROUP BY IdProducto
)
SELECT 
	v.*
    , o.promedio
    , o.maximo
    , o.minimo
FROM venta v
JOIN cantidad_min_max o
ON (v.IdProducto = o.IdProducto)
WHERE 
	v.Cantidad > o.maximo 
    OR v.Cantidad < o.minimo;

-- Introducimos los outliers de cantidad en la tabla aux_venta
INSERT INTO aux_venta
select v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado,
v.IdProducto, v.Precio, v.Cantidad, 2
from venta v
JOIN (SELECT IdProducto, avg(Cantidad) as promedio, stddev(Cantidad) as Desv
	from venta
	GROUP BY IdProducto) v2
ON (v.IdProducto = v2.IdProducto)
WHERE v.Cantidad > (v2.Promedio + (3*v2.Desv)) OR v.Cantidad < (v2.Promedio - (3*v2.Desv)) OR v.Cantidad < 0;

-- Introducimos los outliers de precio en la tabla aux_venta
INSERT into aux_venta
select v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal,
v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 3
from venta v
JOIN (SELECT IdProducto, avg(Precio) as promedio, stddev(Precio) as Desv
	from venta
	GROUP BY IdProducto) v2
ON (v.IdProducto = v2.IdProducto)
WHERE v.Precio > (v2.Promedio + (3*v2.Desv)) OR v.Precio < (v2.Promedio - (3*v2.Desv)) OR v.Precio < 0;




select * from aux_venta where Motivo = 2; -- outliers de cantidad
select * from aux_venta where Motivo = 3; -- outliers de precio

ALTER TABLE `venta` ADD `Outlier` TINYINT NOT NULL DEFAULT '1' AFTER `Cantidad`;
-- 1: No outlier
-- 0: Outlier

UPDATE venta v JOIN aux_venta a
	ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 0;



WITH
venta_con_outliers AS (
	SELECT 	
		tp.TipoProducto
		, AVG(v.Precio * v.Cantidad) AS PromedioVentaConOutliers
	FROM venta v 
	JOIN producto p
		ON v.IdProducto = p.IdProducto
	JOIN tipo_producto tp
		ON p.IdTipoProducto = tp.IdTipoProducto
	GROUP BY tp.TipoProducto
)
, venta_sin_outliers AS (
	SELECT 	
		tp.TipoProducto
		, AVG(v.Precio * v.Cantidad) AS PromedioVentaSinOutliers
	FROM venta v 
	JOIN producto p
		ON v.IdProducto = p.IdProducto 
		AND v.Outlier = 1
	JOIN tipo_producto tp
		ON p.IdTipoProducto = tp.IdTipoProducto
	GROUP BY tp.TipoProducto
)
SELECT 	co.TipoProducto,
		co.PromedioVentaConOutliers,
        so.PromedioVentaSinOutliers
FROM venta_con_outliers co
JOIN venta_sin_outliers so
ON co.TipoProducto = so.TipoProducto;

-- KPI: Margen de Ganancia por cada producto en el 2019
WITH
venta_total AS (
SELECT 	
	p.Producto
    , SUM(v.Precio * v.Cantidad * v.Outlier) AS SumaVentas
    , SUM(v.Outlier) AS	CantidadVentas
    , SUM(v.Precio * v.Cantidad) AS SumaVentasOutliers
    , COUNT(*) 	AS	CantidadVentasOutliers
FROM venta v 
JOIN producto p
	ON (v.IdProducto = p.IdProducto
	AND YEAR(v.Fecha) = 2019)
GROUP BY p.Producto
)
, compra_total AS (
SELECT 	
	p.Producto
    , SUM(c.Precio * c.Cantidad) AS SumaCompras
    , COUNT(*) AS CantidadCompras
FROM compra c 
JOIN producto p
	ON c.IdProducto = p.IdProducto
	AND YEAR(c.Fecha) = 2019
GROUP BY p.Producto
)
SELECT 	venta.Producto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM venta_total AS venta
JOIN compra_total AS compra
	ON 	venta.Producto = compra.Producto;