-- Active: 1693354461857@@127.0.0.1@3306@henry_04
/*Limpieza, Valores faltantes

- Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de las tablas. 
  Descartar columnas que consideres que no tienen relevancia.
- Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente. De encontrarlos, 
  deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva sobre ese problema.
- Utilizar la funcion provista 'UC_Words' (Homework_Utiles.sql) para modificar a letra capital los campos que contengan 
  descripciones para todas las tablas.
- Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.
- Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.


Normalización

- Generar dos nuevas tablas a partir de la tabla 'empelado' que contengan las entidades Cargo y Sector.
- Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.
- Utilizar la funcion provista 'UC_Words' (Homework_Utiles.sql) para modificar a letra capital los campos que contengan descripciones para todas las tablas.

Utilizar el procedimiento provisto 'Llenar_Calendario' (Homework_Utiles.sql) para poblar la tabla de calendario.*/

/*Sugerencia:
Instrucción INSERT:
Es posible usarla a partir del resultado de otra consulta. Por ejemplo:*/

INSERT INTO cargo (Cargo) 
SELECT DISTINCT Cargo 
FROM empleado 
ORDER BY Cargo;

/*Instrucción UPDATE:
Es posible usarla a partir del resultado del resultado de una consulta de la tabla a modificar y otra/s tabla/s. Por ejemplo:*/

UPDATE empleado e JOIN cargo c 
    ON (c.Cargo = e.Cargo)
SET e.IdCargo = c.IdCargo;


---------------------------------------------------------------------------------------------------------------------------------------


ALTER TABLE venta
ADD id_Vendedor int;


UPDATE venta v
JOIN empleados e ON  e.`ID_empleado` = v.`IdEmpleado`
SET v.`id_Vendedor` = 0 ;


UPDATE venta v
JOIN empleados e ON  e.`ID_empleado` = v.`IdEmpleado`
join sucursales s on s.`Sucursal` = e.`Sucursal`
SET v.`id_Vendedor` = e.`ID_empleado_unico`
where s.`Sucursal` = e.`Sucursal`;

SELECT * from venta
WHERE `IdEmpleado` = 3875;

SELECT * from empleados
WHERE `Id_Empleado` = 3875;
;
