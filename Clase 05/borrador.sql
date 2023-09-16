-- Active: 1693280239040@@127.0.0.1@3306@henry_04

ALTER TABLE venta
ADD id_Vendedor int;

SELECT * FROM venta;

INSERT INTO venta (id_Vendedor)
VALUES (SELECT id_empleado_unico
FROM empleados
WHERE Id_empleado=1968)

SELECT id_empleado_unico
FROM empleados
WHERE Id_empleado=1968;

INSERT INTO nombre_de_la_tabla (columna1, columna2, ...)
VALUES (valor1, valor2, ...);



-- ID Repetidos:
-- ID_Empleados - Tabla Empleados (17 repetidos)
SELECT Id_Empleado, COUNT(*) FROM empleados GROUP BY Id_Empleado HAVING COUNT(*) > 1;
-- Datos Faltantes:
-- Nombre - Tabla Proveedores (2 proveedores)
select * from proveedores where Nombre = '';

-- Normalizar los noombres de las columnas de todas las tablas

ALTER TABLE `clientes` CHANGE `ID` `IdCliente` INT NOT NULL;
select * from clientes

ALTER TABLE `empleados` CHANGE `ID_Empleado` `IdEmpleado` INT NULL DEFAULT NULL;
select * from empleados

ALTER TABLE `proveedores` CHANGE `IDProveedor` `IdProveedor` INT NOT NULL;

select * from proveedores;

ALTER TABLE `tiposdegasto` CHANGE `Descripcion` `Tipo_Gasto` VARCHAR(100);

select * from tiposdegasto;

ALTER TABLE `productos` CHANGE `ID_PRODUCTO` `IdProducto` INT NOT NULL;

select * from productos;



SELECT * from venta;

WITH
cliente_unico as (
select DISTINCT idcliente
FROM venta)
SELECT * FROM cliente_unico u
    left join clientes c
        on c.id=u.idcliente 
WHERE c.id is null;

-- 2  --
SELECT * FROM venta
WHERE precio = 0;

SELECT * FROM venta
WHERE cantidad = 0;

SELECT * FROM venta
WHERE cantidad = '' or cantidad is null;

-- 3) ¿Se conocen las fuentes de los datos?  --
-- SI, algunos son csv, crm, xlsx


--4) Al integrar éstos datos, es prudente que haya una normalización respecto de nombrar las tablas y sus campos.
-- si, es ideal que tengan el mismo nombre los campos de las tablas a relacionar
-- X Y latitud longitud, id=idcliente, mayusculas y minusculas, mas de un telefono en campo telefono, etc

-- 5) Es importante revisar la consistencia de los datos: 
    -- ¿Se pueden relacionar todas las tablas al modelo? 
    -- si, todas se relacionan

    -- ¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros?
    -- hechos: venta, compra, gasto
    -- dimensionales: el resto de tablas 

    -- ¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)? 
    --

    -- ¿Hay claves duplicadas?  
    -- si

    -- ¿Cuáles son variables cualitativas y cuáles son cuantitativas? 
    -- cuantitativa: precio, cantidad
    -- cualitativa: el resto.


    -- ¿Qué acciones podemos aplicar sobre las mismas?
    -- sobre precio y cantidad se pueden sumar, max, min, avg, etc.
    -- las cualitativas pueden ser ordianles (max, min), o nominales



--6) Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de las tablas. Descartar columnas que consideres que no tienen relevancia.
-- hasta linea 122

--7) Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente. De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva sobre ese problema.
-- hasta 153 

-- 8) Utilizar la funcion provista 'UC_Words' (Homework_Utiles.sql) para modificar a letra capital los campos que contengan descripciones para todas las tablas.
-- hasta 171 

-- 9) Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.
-- hasta 207

-- 10) Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.
-- 208

-- 11) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.



select * from empleados
WHERE id_empleado=3875;

SELECT Id_Empleado, COUNT(*) FROM empleados GROUP BY Id_Empleado HAVING COUNT(*) > 1;

select * from empleados
ORDER BY `ID_empleado` desc;


13    10
1    310

13  10  15   13010015











 
