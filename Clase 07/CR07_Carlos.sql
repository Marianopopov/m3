-- Code Review 7 

-- 1. Generar 5 queries

USE henry_datapt05;

SELECT
B.sucursal,
SUM(precio * cantidad) as totalVentas,
SUM(cantidad) as totalUnidades
FROM
venta A
INNER JOIN
sucursal B
ON A.id_sucursal = B.id_sucursal
GROUP BY B.sucursal;

#Execution time: 0:00:0.03458400
#Execution time: 0:00:0.05290500

SELECT
B.nombre_canal,
AVG(DATEDIFF(fechaEntrega, fecha)) AS promedioDiasEntrega,
MAX(DATEDIFF(fechaEntrega, fecha)) AS maximoDiasEntrega,
MIN(DATEDIFF(fechaEntrega, fecha)) AS minimoDiasEntrega
FROM
venta A
INNER JOIN
canal_venta B
ON A.id_canal = B.id_canal
GROUP BY 
B.nombre_canal; 

#Execution time: 0:00:0.06748400
#Execution time: 0:00:0.04123400


SELECT
C.nombre_provincia,
COUNT(DISTINCT(A.id_cliente)) as numeroClientes
FROM
cliente A
INNER JOIN
localidad B
ON A.id_localidad = B.id_localidad
INNER JOIN
provincia C
ON C.id_provincia = B.id_provincia
GROUP BY 
1
ORDER BY
numeroClientes DESC
;

#Execution time: 0:00:0.02178100
#Execution time: 0:00:0.01232100

SELECT
*,
totalCompra / SUM(totalCompra) OVER (PARTITION BY concepto) as porcentajeCompra
FROM
(
	SELECT
	B.nombre, 
    C.concepto,
	SUM(A.cantidad * A.precio) as totalCompra,
    AVG(A.precio) as precioPromedio
	FROM
	compra A
	INNER JOIN
	proveedor B
	ON A.id_proveedor = B.id_proveedor
    INNER JOIN
    producto C
    ON A.id_producto = C.id_producto
	GROUP BY 
	B.nombre, C.concepto
) A
ORDER BY 
concepto, porcentajeCompra DESC;

#Execution time: 0:00:0.07108000
#Execution time: 0:00:0.06315400


SELECT
B.sucursal,
SUM(A.monto) AS totalGasto
FROM
gasto A
INNER JOIN
sucursal B
ON A.id_sucursal = B.id_sucursal
GROUP BY 
B.sucursal
ORDER BY
totalGasto DESC;
#Execution time: 0:00:0.00744100
#Execution time: 0:00:0.02369100

### 2. Crear llaves primarias

ALTER TABLE canal_venta ADD PRIMARY KEY (id_canal);
ALTER TABLE cargo ADD PRIMARY KEY (id_cargo);
ALTER TABLE cliente ADD PRIMARY KEY (id_cliente);
ALTER TABLE compra ADD PRIMARY KEY (id_compra);
ALTER TABLE compra ADD PRIMARY KEY (id_compra);

### Modificar tabla de empleados

ALTER TABLE empleados ADD COLUMN id_sucursal INTEGER;
;
UPDATE
empleados A 
LEFT JOIN 
sucursal B
ON A.sucursal = B.sucursal
SET A.id_sucursal = B.id_sucursal;


UPDATE
empleados
SET sucursal = 'Mendoza1'
WHERE sucursal = 'Mendoza 1';


UPDATE
empleados
SET sucursal = 'Mendoza2'
WHERE sucursal = 'Mendoza 2';

ALTER TABLE empleados DROP COLUMN sucursal;

ALTER TABLE empleados ADD PRIMARY KEY (id_empleado, id_sucursal);

SELECT
*
FROM
empleados;

ALTER TABLE 
gasto ADD PRIMARY KEY (id_gasto);

ALTER TABLE producto ADD PRIMARY KEY (id_producto);
ALTER TABLE proveedor ADD PRIMARY KEY (id_proveedor);
ALTER TABLE sucursal ADD PRIMARY KEY (id_sucursal);
ALTER TABLE tipo_gasto ADD PRIMARY KEY (id_tipogasto);
ALTER TABLE venta ADD PRIMARY KEY (id_venta);


### Generar índices

CREATE INDEX fecha_alta ON cliente(fecha_alta);
CREATE INDEX fecha_ultima_modificacion ON cliente(fecha_ultima_modificacion);
CREATE INDEX id_localidad ON cliente(id_localidad);


CREATE INDEX fecha ON compra(fecha);
CREATE INDEX id_producto ON compra(id_producto);
CREATE INDEX id_proveedor ON compra(id_proveedor);

CREATE INDEX id_sector ON empleados(id_sector);
CREATE INDEX id_cargo ON empleados(id_cargo);
CREATE INDEX id_sucursal ON empleados(id_sucursal);

CREATE INDEX id_sucursal ON gasto(id_sucursal);
CREATE INDEX id_tipogasto ON gasto(id_tipogasto);
CREATE INDEX fecha ON gasto(fecha);


CREATE INDEX id_provincia ON localidad(id_provincia);

CREATE INDEX id_tipoproducto ON producto(id_tipoproducto);

CREATE INDEX id_localidad ON proveedor(id_localidad);

CREATE INDEX id_localidad ON sucursal(id_localidad);

CREATE INDEX fecha ON venta(fecha);
CREATE INDEX fechaEntrega ON venta(fechaEntrega);
CREATE INDEX id_canal ON venta(id_canal);
CREATE INDEX id_cliente ON venta(id_cliente);
CREATE INDEX id_sucursal ON venta(id_sucursal);
CREATE INDEX id_empleado ON venta(id_empleado);
CREATE INDEX id_producto ON venta(id_producto);

CREATE INDEX sucursal ON sucursal(sucursal)


;

SELECT
*
FROM
venta;

#### Nunca lo hagan en la misma base de datos

CREATE TABLE fact_venta 
(
id_venta INTEGER,
fecha DATE,
fecha_entrega DATE,
id_canal INTEGER,
id_cliente INTEGER, 
id_empleado INTEGER,
id_producto INTEGER,
precio DECIMAL(10,2),
cantidad INTEGER
);


INSERT INTO fact_venta
SELECT
id_venta,
fecha,
fechaEntrega,
id_canal,
id_cliente,
id_empleado,
id_producto,
precio,
cantidad
FROM
venta;


SELECT
*
FROM
cliente;




