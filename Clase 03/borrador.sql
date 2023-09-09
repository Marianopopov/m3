-- Active: 1693280239040@@127.0.0.1@3306@henry
-- SUBCONSULTAS 
-- Gonzalo del Rio (DATAPT04 Lecture)
use henry;

-- cual era el primer alumno/s que ingreso/aron a henry
SELECT 
    nombre
    , apellido
    ,fechaIngreso
    , count(*) AS cantidad
from alumno
GROUP BY nombre, apellido, fechaIngreso 
ORDER BY fechaIngreso;

-- subconsulta (porque puede pasar que muchas personas entren el mismo dia)

SELECT 
        nombre
        , apellido
        , fechaingreso
from alumno
where fechaingreso = 
        (select MIN(fechaingreso)
        from alumno);

-- ejemplo de sub 
SELECT 
    nombre
    , apellido
    ,fechaIngreso
    , idCohorte
from alumno
WHERE fechaIngreso= (SELECT MAX(fechaIngreso)
                        FROM alumno
                        WHERE idCohorte=1238 or idCohorte=1235);

-- si hacemos un insert para que tenga el mismo dia de ingreso que Beverly
-- para mostrar el ejemplo
SELECT * from alumno;
INSERT INTO alumno (cedulaidentidad, 
                    nombre, 
                    apellido, 
                    fechaNacimiento, 
                    fechaIngreso, 
                    idCohorte)
VALUES ('3585564', 'Juan', 'Perez', '2000-01-01', '2019-12-04', 1236);


SELECT 
        nombre
        , apellido
        , fechaingreso
        , `idCohorte`
from alumno
where fechaingreso = 
        (select MIN(fechaingreso)
        from alumno);

SELECT idAlumno 
    FROM alumno
    WHERE nombre="Juan" AND apellido="Perez"

DELETE FROM alumno WHERE idAlumno = 
                    (SELECT idAlumno 
                        FROM alumno
                        WHERE nombre="Juan" 
                        AND apellido="Perez");

-- You can't specify target table 'alumno' for update in FROM clause

-- cuando intentas eliminar o actualizar filas en una tabla utilizando
-- una subconsulta que hace referencia a la misma tabla en la cláusula FROM

DELETE FROM alumno WHERE idAlumno = 181

--para solucionar esto se puede crear una tabla temporal
-- Crea una tabla temporal para almacenar los IDs de las filas que se eliminarán
CREATE TEMPORARY TABLE temporal AS
SELECT idAlumno
    FROM alumno
    WHERE nombre="Juan" 
    AND apellido="Perez"

-- Elimina las filas de la tabla original utilizando la tabla temporal
DELETE FROM alumno WHERE idAlumno IN (SELECT idAlumno FROM temporal);

-- Elimina la tabla temporal
DROP TEMPORARY TABLE temporal;

SELECT COUNT(*) FROM alumno;

INSERT INTO alumno (cedulaidentidad, 
                    nombre, 
                    apellido, 
                    fechaNacimiento, 
                    fechaIngreso, 
                    idCohorte)
VALUES  ('3585564', 'Juan', 'Perez', '2001-01-01', '2019-12-04', 1236),
        ('2458714', 'Pedro', 'Perez', '2002-01-01', '2019-12-04', 1236),
        ('1236547', 'Carlos', 'Gomez', '2003-01-01', '2019-12-04', 1238),
        ('3355889', 'Maria', 'Perez', '1999-01-01', '2019-12-04', 1239);

SELECT 
        nombre
        , apellido
        , fechaingreso
from alumno
where fechaingreso = 
        (select MIN(fechaingreso)
        from alumno);

SELECT * FROM alumno
ORDER BY `idAlumno` DESC;


DELETE FROM alumno WHERE idAlumno >180;


-- cohortes sin alumnos registrados 

select * 
from cohorte
where idcohorte NOT IN  
        (select DISTINCT idcohorte from alumno);


-- VISTAS (PERMITE ALMACENAR DE FORMA PERMANENTE EL RESULTADO DE UNA QUERY)
-- (CREA UNA TABLA VIRTUAL)


-- CREAR UNA VISTA (DE LA CONSULTA ANTERIOR)

CREATE VIEW  COHORTE_SIN_ALUMNOS AS
select * 
from cohorte
where idcohorte NOT IN  
        (select DISTINCT idcohorte from alumno);

-- Select de la vista

SELECT * FROM cohorte_sin_alumnos;

DROP VIEW cohorte_sin_alumnos;

CREATE VIEW  COHORTE_SIN_ALUMNOS AS
select * 
from cohorte
where idcohorte IN  
        (select DISTINCT idcohorte from alumno)
        IS FALSE;

-- NOT IN "algo"  = IN "algo" IS FALSE  ? diferencias?


-- Crear y Modificar una vista.
CREATE VIEW primerosAlumnos AS
SELECT idAlumno, fechaIngreso
FROM alumno
WHERE fechaIngreso = (  SELECT MIN(fechaIngreso) AS fecha
                        FROM alumno)

-- Obtener los resultados de una vista.
SELECT *
FROM primerosAlumnos

-- Modificar una vista.
ALTER VIEW primerosAlumnos AS
SELECT idAlumno, CONCAT(apellido," ",nombre), fechaIngreso
FROM alumno
WHERE fechaIngreso = (  SELECT MIN(fechaIngreso) AS fecha
                        FROM alumno)

-- Eliminar una vista
DROP VIEW primerosAlumnos

----------------
-- FUNCION DE VENTANA

use checkpoint_m2;


SELECT * from venta;
-- promedio de ventas por fecha

select  fecha,
        avg (precio*cantidad) as promedio_ventas
from venta
GROUP BY fecha;

-- unimos el promedio de ventas por fecha con las ventas por fecha 

SELECT  v.fecha,
        v.precio * v.cantidad as venta, 
        v2.promedio_ventas 
from venta v JOIN (select  fecha, 
                        avg(precio*cantidad) as promedio_ventas 
                        from venta GROUP BY fecha ) v2
on (v.fecha = v2.fecha);


-- QUERY CON VENTANA
SELECT v.fecha,
        v.precio * v.cantidad as venta,
        avg(v.precio * v.cantidad) OVER (PARTITION BY v.fecha) as promedio_ventas
from venta v;


SELECT  v.fecha,
        v.precio * v.cantidad as venta, 
        v2.promedio_ventas 
from venta v JOIN (select  fecha, 
                        avg(precio*cantidad) as promedio_ventas 
                        from venta GROUP BY fecha ) v2
on (v.fecha = v2.fecha)
WHERE v.fecha='2015-01-01';

SELECT v.fecha,
        v.precio * v.cantidad as venta,
        avg(v.precio * v.cantidad) OVER (PARTITION BY v.fecha) as promedio_ventas
from venta v
WHERE v.fecha='2015-01-01';

-- RANK

SELECT   RANK() OVER (PARTITION BY V.FECHA ORDER BY V.PRECIO * V.CANTIDAD DESC) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v;

SELECT   RANK() OVER (PARTITION BY V.FECHA ORDER BY V.PRECIO * V.CANTIDAD DESC) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v
where v.fecha = '2015-01-01';

SELECT   RANK() OVER (PARTITION BY V.FECHA) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v
where v.fecha = '2015-01-01'
ORDER BY V.PRECIO * V.CANTIDAD DESC;

SELECT   RANK() OVER (PARTITION BY V.FECHA ORDER BY V.PRECIO * V.CANTIDAD DESC) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v
where v.fecha = '2015-01-01'
order by v.idcliente, V.PRECIO * V.CANTIDAD;

--ord por fecha   

SELECT   RANK() OVER (PARTITION BY V.FECHA ORDER BY v.fecha DESC) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v;


SELECT   RANK() OVER (PARTITION BY V.FECHA) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v
where v.fecha = '2015-01-01'
ORDER BY v.fecha DESC;

SELECT   RANK() OVER (PARTITION BY V.FECHA order by (v.precio * v.cantidad) desc) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v
where v.fecha = '2015-01-01';

