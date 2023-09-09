-- Active: 1693280239040@@127.0.0.1@3306@henry
-- SUBCONSULTAS
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