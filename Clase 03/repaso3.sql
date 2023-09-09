-- SUBCONSULTAS
use henry;

-- cual era el primer alumno/s que ingreso/aron a henry

SELECT 
    nombre, apellido,fechaIngreso, count(*) AS cantidad
from alumno
GROUP BY nombre, apellido, fechaIngreso 
ORDER BY fechaIngreso;

-- subconsulta (porque puede pasar que muchas personas entren el mismo dia)

SELECT nombre, apellido, fechaingreso
from alumno
where fechaingreso = 
        (select min(fechaingreso)
        from alumno);

-- si hacemos un insert para que tenga el mismo dia de ingreso que Beverly
-- para mostrar el ejemplo
SELECT * from alumno;
INSERT INTO alumno (idalumno, 
                    cedulaidentidad, 
                    nombre, 
                    apellido, 
                    fechanacimiento, 
                    fechaingreso, 
                    idcohorte)
VALUES (100000, '3585564', 'mariano', 'popov', '1993-09-18', '2019-12-04', 1235);



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

-- MODIFICAR UNA VISTA

ALTER VIEW COHORTE_SIN_ALUMNOS AS -- -- -- -- -- -- 
select * 
from cohorte
where idcohorte NOT IN  
        (select DISTINCT idcohorte from alumno);



-- FUNCION DE VENTANA

use checkpoint_m2;

-- promedio de ventas por fecha

select  fecha,
        avg (precio*cantidad) as promedio_ventas
from venta
GROUP BY fecha;

-- unimos el proMEDIO de ventaS por fecha con las ventas por fecha (USANDO CLAUSALA OVER)
-- QUERY INICIAL
SELECT  v.fecha,
        v.precio * v.cantidad as venta, 
        v2.promedio_ventas 
from venta v JOIN (select  fecha, 
                        avg(precio*cantidad) as promedio_ventas 
                        from venta GROUP BY fecha )v2
on (v.fecha = v2.fecha);

-- QUERY CON VENTANA
SELECT v.fecha,
        v.precio * v.cantidad as venta,
        avg(v.precio * v.cantidad) OVER (PARTITION BY v.fecha) as promedio_ventas
from venta v;

-- sumo WHERE
SELECT v.fecha,
        v.precio * v.cantidad as venta,
        avg(v.precio * v.cantidad) OVER (PARTITION BY v.fecha) as promedio_ventas
from venta v
where v.fecha = '2015-01-01';

-- RANK

SELECT   RANK() OVER (PARTITION BY V.FECHA ORDER BY V.PRECIO * V.CANTIDAD DESC) as ranking_venta, 
        v.fecha,
        v.idcliente,
        v.precio,
        v.cantidad,
        (v.precio * v.cantidad) as venta
from venta v;

