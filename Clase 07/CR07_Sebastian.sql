use henry_m3;

-- 1. Venta sin outliers para el 2020 agrupado por provincia, localidad y rango etario
SELECT 	
	p.Provincia
    , l.Localidad
    , c.Rango_Etario
    , SUM(v.Precio * v.Cantidad) AS Venta
FROM venta v 
JOIN cliente c
	ON v.IdCliente = c.IdCliente
		-- AND v.Outlier = 1
		-- AND YEAR(v.Fecha) = 2020 -- OP1
JOIN localidad l
	ON c.IdLocalidad = l.IdLocalidad
JOIN provincia p
	ON l.IdProvincia = p.IdProvincia
WHERE 
	YEAR(v.Fecha) = 2020 -- OP2
	AND v.Outlier = 1
GROUP BY p.Provincia, l.Localidad, c.Rango_Etario
ORDER BY p.Provincia, l.Localidad, c.Rango_Etario;

-- 2. Venta total por provincia, localidad y tipo de producto 
SELECT 	
	pr.Provincia
    , l.Localidad
    , tp.TipoProducto
    , SUM(v.Precio * v.Cantidad) AS Venta
FROM venta v 
JOIN producto p
	ON v.IdProducto = p.IdProducto
JOIN tipo_producto tp
	ON tp.IdTipoProducto = p.IdTipoProducto
JOIN cliente c
	ON v.IdCliente = c.IdCliente
JOIN localidad l
	ON c.IdLocalidad = l.IdLocalidad
JOIN provincia pr
	ON l.IdProvincia = pr.IdProvincia
GROUP BY pr.Provincia, l.Localidad, tp.TipoProducto
ORDER BY pr.Provincia, l.Localidad, tp.TipoProducto;

-- 3. ¿Cuál es la proporción de cada venta con respecto al total diario?
SELECT 	
	v.Fecha
    , v.Precio * v.Cantidad AS Venta
    , SUM(v.Precio * v.Cantidad) OVER (PARTITION BY v.Fecha) AS Total_Ventas
    , (v.Precio * v.Cantidad / SUM(v.Precio * v.Cantidad) OVER (PARTITION BY v.Fecha)) * 100 AS proporcion_venta
FROM venta v
ORDER BY 1, 4 DESC;

-- 4 Cuál fue el año de mayor crecimiento de ventas?
WITH
venta_total AS (
	SELECT 
		YEAR(fecha) AS año
		, SUM(precio * cantidad) AS total_venta
	FROM venta
	GROUP BY YEAR(fecha)
)
SELECT 
	año
	, total_venta 
	, LAG(total_venta, 1) OVER (ORDER BY año) AS venta_anterior
	, ((total_venta /  LAG(total_venta, 1) OVER (ORDER BY año) ) - 1) * 100 AS crecimiento_venta_porcentaje
FROM venta_total ;

-- 5. De los clientes totales, qué % hizo al menos una compra el año 2020?
WITH
clientes_unicos AS (
	SELECT DISTINCT
		v.IdCliente
	FROM cliente c
	JOIN venta v
		ON c.IdCliente = v.IdCliente
		AND YEAR(v.fecha) = 2020
)
SELECT
(SUM(CASE WHEN v.IdCliente IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS porcentaje_cliente_2020
FROM cliente c
LEFT JOIN clientes_unicos AS v
	ON c.idcliente = v.IdCliente;

/*Creamos indices de las tablas determinando claves primarias y foraneas*/
ALTER TABLE `venta` ADD PRIMARY KEY(`IdVenta`);
ALTER TABLE `venta` ADD INDEX(`IdProducto`);
ALTER TABLE `venta` ADD INDEX(`IdEmpleado`);
ALTER TABLE `venta` ADD INDEX(`Fecha`);
ALTER TABLE `venta` ADD INDEX(`Fecha_Entrega`);
ALTER TABLE `venta` ADD INDEX(`IdCliente`);
ALTER TABLE `venta` ADD INDEX(`IdSucursal`);
ALTER TABLE `venta` ADD INDEX(`IdCanal`);

ALTER TABLE `canal_venta` ADD PRIMARY KEY(`IdCanal`);

ALTER TABLE `producto` ADD PRIMARY KEY(`IdProducto`);
ALTER TABLE `producto` ADD INDEX(`IdTipoProducto`);

ALTER TABLE `sucursal` ADD PRIMARY KEY(`IdSucursal`);
ALTER TABLE `sucursal` ADD INDEX(`IdLocalidad`);

ALTER TABLE `empleado` ADD PRIMARY KEY(`CodigoEmpleado`); -- Esto da error de clave duplicada
ALTER TABLE `empleado` ADD PRIMARY KEY(`IdEmpleado`);
ALTER TABLE `empleado` ADD INDEX(`IdSucursal`);
ALTER TABLE `empleado` ADD INDEX(`IdSector`);
ALTER TABLE `empleado` ADD INDEX(`IdCargo`);

ALTER TABLE `localidad` ADD INDEX(`IdProvincia`);

ALTER TABLE `proveedor` ADD PRIMARY KEY(`IdProveedor`);
ALTER TABLE `proveedor` ADD INDEX(`IdLocalidad`);

ALTER TABLE `gasto` ADD PRIMARY KEY(`IdGasto`);
ALTER TABLE `gasto` ADD INDEX(`IdSucursal`);
ALTER TABLE `gasto` ADD INDEX(`IdTipoGasto`);
ALTER TABLE `gasto` ADD INDEX(`Fecha`);

ALTER TABLE `cliente` ADD PRIMARY KEY(`IdCliente`);
ALTER TABLE `cliente` ADD INDEX(`IdLocalidad`);

ALTER TABLE `compra` ADD PRIMARY KEY(`IdCompra`);
ALTER TABLE `compra` ADD INDEX(`Fecha`);
ALTER TABLE `compra` ADD INDEX(`IdProducto`);
ALTER TABLE `compra` ADD INDEX(`IdProveedor`);

DROP INDEX IdCliente ON venta;
ALTER TABLE `venta` ADD INDEX(`IdCliente`);

/*Creamos las relaciones entre las tablas, y con ellas las restricciones*/
ALTER TABLE venta ADD CONSTRAINT `venta_fk_cliente` FOREIGN KEY (IdCliente) REFERENCES cliente (IdCliente) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_producto` FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_empleado` FOREIGN KEY (IdEmpleado) REFERENCES empleado (IdEmpleado) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_canal` FOREIGN KEY (IdCanal) REFERENCES canal_venta (IdCanal) ON DELETE RESTRICT ON UPDATE RESTRICT;

select * from venta where IdCliente = 969;
delete from cliente where IdCliente = 969; -- No me deja porque está creada la restricción

select * from cliente where IdCliente NOT IN (SELECT IdCliente FROM venta);
delete from cliente where IdCliente = 443; -- Me deja, está creada la restricción, pero no existe el cliente en ventas

ALTER TABLE producto ADD CONSTRAINT `producto_fk_tipoproducto` FOREIGN KEY (IdTipoProducto) REFERENCES tipo_producto (IdTipoProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_sector` FOREIGN KEY (IdSector) REFERENCES sector (IdSector) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_cargo` FOREIGN KEY (IdCargo) REFERENCES cargo (IdCargo) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE cliente ADD CONSTRAINT `cliente_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE proveedor ADD CONSTRAINT `proveedor_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE sucursal ADD CONSTRAINT `sucursal_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE localidad ADD CONSTRAINT `localidad_fk_provincia` FOREIGN KEY (IdProvincia) REFERENCES provincia (IdProvincia) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE compra ADD CONSTRAINT `compra_fk_producto` FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_proveedor` FOREIGN KEY (IdProveedor) REFERENCES proveedor (IdProveedor) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_tipogasto` FOREIGN KEY (IdTipoGasto) REFERENCES tipo_gasto (IdTipoGasto) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE gasto DROP CONSTRAINT `gasto_fk_tipogasto`;

ALTER TABLE venta ADD CONSTRAINT `venta_fk_fecha` FOREIGN KEY (fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;

/*Cracion de Tablas de Hechos para modelo Estrella*/
DROP TABLE IF EXISTS `fact_venta`;
CREATE TABLE IF NOT EXISTS `fact_venta` (
  `IdVenta`				INTEGER,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCanal`				INTEGER, 
  `IdCliente`			INTEGER, 
  `IdEmpleado`			INTEGER,
  `IdProducto`			INTEGER,
  `Precio`				DECIMAL(15,3),
  `Cantidad`			INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO fact_venta
SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
WHERE YEAR(Fecha) = 2020;

ALTER TABLE `fact_venta` ADD PRIMARY KEY(`IdVenta`);
ALTER TABLE `fact_venta` ADD INDEX(`IdProducto`);
ALTER TABLE `fact_venta` ADD INDEX(`IdEmpleado`);
ALTER TABLE `fact_venta` ADD INDEX(`Fecha`);
ALTER TABLE `fact_venta` ADD INDEX(`Fecha_Entrega`);
ALTER TABLE `fact_venta` ADD INDEX(`IdCliente`);
ALTER TABLE `fact_venta` ADD INDEX(`IdCanal`);

DROP TABLE IF EXISTS dim_cliente;
CREATE TABLE IF NOT EXISTS dim_cliente (
	IdCliente			INTEGER,
	Nombre_y_Apellido	VARCHAR(80),
	Domicilio			VARCHAR(150),
	Telefono			VARCHAR(30),
	Rango_Etario		VARCHAR(20),
	IdLocalidad			INTEGER,
	Latitud				DECIMAL(13,10),
	Longitud			DECIMAL(13,10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO dim_cliente
SELECT IdCliente, Nombre_y_Apellido, Domicilio, Telefono, Rango_Etario, IdLocalidad, Latitud, Longitud
FROM cliente
WHERE IdCliente IN (SELECT distinct IdCliente FROM fact_venta);

DROP TABLE IF EXISTS dim_producto;
CREATE TABLE IF NOT EXISTS dim_producto (
	IdProducto					INTEGER,
	Producto					VARCHAR(100),
	IdTipoProducto				VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO dim_producto
SELECT IdProducto, Producto, IdTipoProducto
FROM producto
WHERE IdProducto IN (SELECT distinct IdProducto FROM fact_venta);