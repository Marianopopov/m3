USE henry_datapt05;

CREATE TEMPORARY TABLE homologacion
SELECT localidad, provincia 
FROM
cliente
UNION
select 
localidad, estado
from
proveedor
UNION
select
localidad, provincia
from
sucursal;



### Tabla provincia

CREATE TABLE provincia 
(
id_provincia INTEGER PRIMARY KEY AUTO_INCREMENT,
nombre_provincia VARCHAR(100)
);


-- INSERT INTO provincia(nombre_provincia) 
SELECT DISTINCT
provincia_corregida
FROM
(
SELECT
*,
CASE 
	WHEN provincia = 'C deBuenos Aires' THEN 'Ciudad de Buenos Aires'
    WHEN provincia = 'Caba' THEN 'Ciudad de Buenos Aires'
    WHEN provincia = 'Bs As' THEN 'Buenos Aires'
    WHEN provincia = 'Bs.As. ' THEN 'Buenos Aires'
    WHEN provincia LIKE 'B%s' THEN 'Buenos Aires'
    WHEN provincia = 'P%s'THEN 'Buenos Aires'
    WHEN provincia = 'Prov de Bs As.'THEN 'Buenos Aires'
    WHEN provincia = 'Pcia Bs AS'THEN 'Buenos Aires'
    WHEN provincia = 'Provincia de Buenos Aires' then 'Buenos Aires'
    WHEN provincia = '' THEN 'Sin provincia'
    ELSE provincia
END as provincia_corregida
FROM
(
SELECT DISTINCT
provincia
FROM
homologacion
) A
) B;


CREATE TEMPORARY TABLE correccion_provincia
SELECT
	*,
	CASE 
		WHEN provincia = 'C deBuenos Aires' THEN 'Ciudad de Buenos Aires'
		WHEN provincia = 'Caba' THEN 'Ciudad de Buenos Aires'
		WHEN provincia = 'Bs As' THEN 'Buenos Aires'
		WHEN provincia = 'Bs.As. ' THEN 'Buenos Aires'
		WHEN provincia LIKE 'B%s' THEN 'Buenos Aires'
		WHEN provincia = 'P%s'THEN 'Buenos Aires'
		WHEN provincia = 'Prov de Bs As.'THEN 'Buenos Aires'
		WHEN provincia = 'Pcia Bs AS'THEN 'Buenos Aires'
		WHEN provincia = 'Provincia de Buenos Aires' then 'Buenos Aires'
		WHEN provincia = '' THEN 'Sin provincia'
		ELSE provincia
	END as provincia_corregida
	FROM
	(
	SELECT DISTINCT
	provincia
	FROM
	homologacion
	) A;


CREATE TEMPORARY TABLE pre_correccion
SELECT DISTINCT
localidad, 
CASE 
	WHEN localidad LIKE 'Cap%l' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Ca%d' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Ca%d.' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Cap%s' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad = 'Cdad de Buenos Aires' THEN 'CABA'
    WHEN localidad = 'Ciudad De Buenos Aires' THEN 'CABA'
    WHEN localidad = 'Ciudad de Buenos Aires' THEN 'CABA'
	WHEN localidad ='' THEN 'Sin localidad'
    ELSE localidad
END as localidad_corregida,
provincia_corregida
FROM
(
	SELECT
	c.*,
	B.provincia_corregida
	FROM
	homologacion c
	LEFT JOIN
	correccion_provincia B
	ON c.provincia = B.provincia
) A
ORDER BY 
localidad;


UPDATE
pre_correccion
SET provincia_corregida = 'Ciudad de Buenos Aires'
WHERE 
localidad_corregida = 'CABA'
AND provincia_corregida != 'Ciudad de Buenos Aires';

CREATE TABLE localidad
(
id_localidad INTEGER PRIMARY KEY AUTO_INCREMENT,
nombre_localidad VARCHAR(100),
id_provincia INTEGER ,
FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia))
;

INSERT INTO localidad (nombre_localidad, id_provincia)
SELECT DISTINCT
localidad_corregida,
B.id_provincia
FROM
pre_correccion A
LEFT JOIN
provincia B
ON A.provincia_corregida = B.nombre_provincia
;


SELECT
*
FROM
localidad;



####### Modificar las tablas origen

ALTER TABLE 
cliente
ADD COLUMN id_localidad INTEGER;

CREATE TEMPORARY TABLE homologacion_final
SELECT
A.*,
B.provincia,
C.id_provincia,
D.id_localidad
FROM
pre_correccion A
LEFT JOIN
correccion_provincia B
ON A.provincia_corregida = B.provincia_corregida
LEFT JOIN
provincia C
on A.provincia_corregida = C.nombre_provincia
LEFT JOIN
localidad D
ON A.localidad_corregida = D.nombre_localidad AND D.id_provincia = C.id_provincia;

SELECT 
A.id_cliente,
COUNT(*)
FROM
cliente A
LEFT JOIN
homologacion_final B
ON A.provincia = B.provincia and A.localidad = B.localidad
group by 
1
having
count(*)>1
;

SELECT
*
FROM
cliente
where id_cliente = 1882;


CREATE TEMPORARY TABLE cliente_homologacion
SELECT DISTINCT
A.id_cliente,
B.id_localidad
FROM
cliente A
LEFT JOIN
homologacion_final B
ON A.provincia = B.provincia and A.localidad = B.localidad
;

UPDATE cliente A
left join
cliente_homologacion B
ON A.id_cliente = B.id_cliente
SET A.id_localidad = B.id_localidad

;

SELECT
*
FROM
cliente
;

ALTER TABLE cliente
DROP column localidad;

ALTER TABLE cliente
DROP column provincia;


### Proveedor

CREATE TEMPORARY TABLE proveedor_homologacion
SELECT DISTINCT
A.id_proveedor,
B.id_localidad
FROM
proveedor A
LEFT JOIN
homologacion_final B
ON A.estado = B.provincia and A.localidad = B.localidad
;


ALTER TABLE proveedor ADD COLUMN id_localidad INTEGER;

UPDATE proveedor A
left join
proveedor_homologacion B
ON A.id_proveedor = B.id_proveedor
SET A.id_localidad = B.id_localidad;


SELECT
*
FROM
proveedor;

ALTER TABLE proveedor DROP COLUMN estado;
ALTER TABLE proveedor DROP COLUMN localidad;

### Sucursal

SELECT
*
FROM
sucursal;

CREATE TEMPORARY TABLE sucursal_homologacion
SELECT DISTINCT
A.id_sucursal,
B.id_localidad
FROM
sucursal A
LEFT JOIN
homologacion_final B
ON A.provincia = B.provincia and A.localidad = B.localidad
;

ALTER TABLE sucursal ADD COLUMN id_localidad INTEGER;

UPDATE sucursal A
left join
sucursal_homologacion B
ON A.id_sucursal = B.id_sucursal
SET A.id_localidad = B.id_localidad;

UPDATE sucursal 
SET id_localidad = 76
where id_localidad IS NULL;


ALTER TABLE sucursal DROP COLUMN provincia;
ALTER TABLE sucursal DROP COLUMN localidad;


SELECT
*
FROM
sucursal;



# Aplicar alguna técnica de detección de Outliers en la tabla ventas, 
# sobre los campos Precio y Cantidad. 
# Realizar diversas consultas para verificar la importancia de haber detectado Outliers. 
# Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.


SELECT
*
FROM
(
SELECT
*,
CASE 
	WHEN cantidad > limite_superior or cantidad < limite_inferior THEN 1
    ELSE 0
END as flag_outlier
from
(
SELECT
A.*,
b.id_tipoproducto,
avg(cantidad) OVER (PARTITION BY B.id_tipoproducto) + (3 * std(cantidad) OVER (PARTITION BY B.id_tipoproducto)) AS limite_superior,
avg(cantidad) OVER (PARTITION BY B.id_tipoproducto) - (3 * std(cantidad) OVER (PARTITION BY B.id_tipoproducto)) as limite_inferior
FROM
venta A
inner join
producto b
ON A.id_producto = B.id_producto
) A
) a
WHERE
flag_outlier = 1;


### KPI

SELECT
id_cliente, ## Dimensión
sum(precio*cantidad) ## Medida 
FROM
venta
group by
1;

