## CR08 -- Triggers / carga de datos

#1. Crear una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos registros en fact_venta.

##### Crear una tabla de auditoria

USE henry_datapt05;

CREATE TABLE fact_venta_auditoria
(
	id_venta INTEGER,
    fecha DATE,
    fecha_entrega DATE,
    id_canal INTEGER,
    id_empleado INTEGER,
    id_producto INTEGER,
    precio DECIMAL (10,2),
	cantidad INTEGER,
    usuario VARCHAR(100),
    fecha_registro DATETIME
);
#2. Crear una acción que permita la carga de datos en la tabla anterior.

CREATE TRIGGER registro_fact_venta AFTER INSERT ON fact_venta
FOR EACH ROW 
INSERT INTO fact_venta_auditoria 
VALUES(NEW.id_venta, NEW.fecha, NEW.fecha_entrega, NEW.id_canal, NEW.id_empleado, NEW.id_producto, NEW.precio, NEW.cantidad, CURRENT_USER(), NOW());

#### Insertar un nuevo valor

INSERT INTO
fact_venta
VALUES
(48242,'2023-01-01',NULL,2,1712,3205,42810,1282.82,3);
;

SELECT
*
FROM
fact_venta_auditoria;


#3. Crear una tabla que permita registrar la cantidad total registros, luego de cada ingreso la tabla fact_venta.

CREATE TABLE cantidad_registros_fact_venta
(
	numero_registros INTEGER,
    fecha DATETIME
);


;
#4. Crear una acción que permita la carga de datos en la tabla anterior.

CREATE TRIGGER recuento_registros AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO cantidad_registros_fact_venta VALUES ((SELECT COUNT(*) FROM fact_venta), NOW());




INSERT INTO
fact_venta
VALUES
(48244,'2023-01-01',NULL,2,1712,3205,42810,1282.82,3);


SELECT
*
FROM
cantidad_registros_fact_venta;

#5. Crear una tabla que agrupe los datos de la tabla del item 3, a su vez crear un proceso de carga de los datos agrupados.

CREATE TABLE recuento_registros_auditoria 
(
	cantidad_registros INTEGER,
    fecha DATETIME,
    usuario VARCHAR(100)
);

CREATE TRIGGER recuento_auditoria AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO recuento_registros_auditoria VALUES((SELECT COUNT(*) FROM cantidad_registros_fact_venta),now(), CURRENT_USER());


INSERT INTO
fact_venta
VALUES
(48245,'2023-01-01',NULL,2,1712,3205,42810,1282.82,3);

SELECT
*
FROM
recuento_registros_auditoria;


#6. Crear una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta.

CREATE TABLE cambios_venta 
(
	fecha_entrega_anterior DATE,
    fecha_entrega_nueva DATE,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    cantidad_anterior INTEGER,
    cantidad_nueva INTEGER,
    fecha_cambio DATETIME
);


#7. Crear una acción que permita la carga de datos en la tabla anterior, para su actualización.


CREATE TRIGGER registro_actualizacion AFTER UPDATE ON fact_venta
FOR EACH ROW
INSERT INTO cambios_venta VALUES (OLD.fecha_entrega, NEW.fecha_entrega, OLD.precio, NEW.precio, OLD.cantidad, NEW.cantidad, NOW());



update
fact_venta
set fecha_entrega = '2023-01-15'
where 
id_venta = 48242
;


SELECT
*
FROM
cambios_venta;


##### Carga incremental

CREATE TABLE ventas_actualizadas
(
	id_venta INTEGER,
    fecha DATE,
    fecha_entrega DATE,
    id_canal INTEGER,
    id_cliente INTEGER,
    id_sucursal INTEGER,
    id_empleado INTEGER,
    id_producto INTEGER,
    precio DECIMAL(10,2),
    cantidad INTEGER
);

INSERT INTO venta (id_venta, fecha, fechaEntrega, id_canal, id_cliente, id_sucursal, id_empleado, id_producto, precio, cantidad)
SELECT
A.*
FROM
ventas_actualizadas A
LEFT JOIN
venta B
ON A.id_venta = B.id_venta
WHERE
B.id_venta IS NULL;


delete
FROM
venta
where id_venta between 48266 and 48271;


select
*
from
venta;



#### Clientes actualizado


SELECT
*
FROM
cliente;


####### Carga de datos

CREATE TABLE clientes_actualizado
(
	id_cliente INTEGER,
    provincia VARCHAR(100), 
    nombre_cliente VARCHAR(300),
    domicilio VARCHAR(300), 
    telefono VARCHAR(100),
    edad INTEGER,
    localidad VARCHAR(200),
    latitud VARCHAR(100),
    longitud VARCHAR(100),
    fecha_alta DATE,
    usuario_alta VARCHAR(100),
    fecha_ultima_modificacion DATE,
    usuario_ultima_modificacion VARCHAR(100),
    marca_baja tinyint,
    col10 varchar(109)
);

-- Cargar archivos locales
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 'ON';

;
LOAD DATA local  INFILE '/Users/aladelca/Downloads/Clientes_Actualizado (3).csv'
INTO TABLE clientes_actualizado
character SET 'utf8'
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines;


### Validar modificaciones

SELECT
A.*
FROM
clientes_actualizado a
inner join
cliente b
ON A.ID_CLIENTE = B.ID_CLIENTE
WHERE A.fecha_ultima_modificacion != B.fecha_ultima_modificacion;

### Clientes nuevos

delimiter $$
CREATE PROCEDURE actualizar_clientes() 
begin
create  TEMPORARY TABLE nuevos_clientes 
SELECT
A.*
FROM
clientes_actualizado a
LEFT join
cliente b
ON A.ID_CLIENTE = B.ID_CLIENTE
WHERE 
B.id_cliente IS NULL
;

UPDATE nuevos_clientes
SET 
nombre_cliente = UC_Words(nombre_cliente),
domicilio = UC_Words(domicilio),
localidad = UC_Words(localidad)
;


UPDATE nuevos_clientes
SET
latitud = cast(replace(latitud,',','.') as DECIMAL(10,8)),
longitud = cast(replace(longitud,',','.') as DECIMAL(10,8));

alter table 
nuevos_clientes drop column col10;

ALTER TABLE nuevos_clientes ADD COLUMN id_localidad INTEGER;

UPDATE nuevos_clientes A
LEFT JOIN
localidad B
on a.localidad = b.nombre_localidad
SET A.id_localidad = B.id_localidad;


alter table nuevos_clientes DROP COLUMN provincia;
alter table nuevos_clientes DROP COLUMN localidad;

INSERT INTO cliente
SELECT
id_cliente,
nombre_cliente,
domicilio,
telefono,
edad,
latitud,
longitud,
fecha_alta,
usuario_alta,
fecha_ultima_modificacion,
usuario_ultima_modificacion,
marca_baja,
id_localidad
FROM
nuevos_clientes ;
end $$
delimiter ;



CALL actualizar_clientes();


SELECT
*
FROM
cliente
WHERE
id_cliente = 9999;


##### Funciones ventana



SELECT
*,
promedio_general - promedio_especifico as diferencia
FROM
(
SELECT
*,
AVG(precio) OVER () as promedio_general,
AVG(precio) OVER (PARTITION BY id_producto) as promedio_especifico
FROM
venta
) a;

/*
select
[campos]
from 
[origen : consultas, vistas, tablas, tablas temporales, joins]
where
[condiciones de filas] 
group by
[agregaciones]
having
[condiciones de agregación]
order by
[orden]
limit


select
id_producto,
AVG(PRECIO)
from
venta
group by 
id_producto;
*/

