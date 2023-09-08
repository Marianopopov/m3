/*Para resolver estas actividades usaremos la base de datos "adventureworks" del script AdventureWorks.sql (de la clase 1).

Recuerda revisar la cápsula de la clase para reforzar cómo realizar subconsultas.

1. Obtener un listado de cuál fue el volumen de ventas (cantidad) por año y método de envío mostrando para cada registro, 
qué porcentaje representa del total del año. Resolver utilizando Subconsultas y Funciones Ventana, 
luego comparar la diferencia en la demora de las consultas.<br> 

2. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, 
mostrando para ambos, su porcentaje respecto del total.<br>

3. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
mostrando para ambos, su porcentaje respecto del total.<br>

4. Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes realizadas. 
Investigar las funciones FLOOR() y CEILING().*/

use adventureworks;
-- 1

-- subconsultas 
-- total por año

select 
    YEAR(h.`OrderDate`) as anio, 
    sum(d.`orderqty`) as cantidad
from salesorderheader as h 
    join salesorderdetail as d on (h.`SalesOrderID` = d.`SalesOrderID`)
    join shipmethod as s (s.`ShipMethodID` = h.`ShipMethodID`)
group by YEAR(h.`OrderDate`);



create VIEW Cantidad_año_envio as
select 
  YEAR(h.`OrderDate`) as anio,
  s.name as metodoenvio,
  sum(d.`OrderQty`) as cantidad,
  sum(d.`OrderQty`) / t.cantidadTotal * 100 as porcentaje_por_año
from salesorderheader as h 
    join salesorderdetail as d ON (h.`SalesOrderID` = d.`SalesOrderID`)
    join shipmethod as s ON (s.`ShipMethodID` = h.`ShipMethodID`)
    
    join (
            select 
            YEAR(h.`OrderDate`) as anio, 
            sum(d.`orderqty`) as cantidadTotal
            from salesorderheader as h 
                join salesorderdetail as d on (h.`SalesOrderID` = d.`SalesOrderID`)
                group by YEAR(h.`OrderDate`)) as t 
                on YEAR(h.`OrderDate`) = t.anio
group BY YEAR(h.`OrderDate`), s.`Name`, t.cantidadTotal
ORDER BY YEAR(h.`OrderDate`), s.`Name`;

-- 815 ms

-- funcion ventana
SELECT
anio,
metodoenvio,
cantidad,
cantidad / sum(cantidad) OVER (PARTITION BY anio) * 100 as porcenta_año_total
from
        (SELECT
            YEAR(h.`OrderDate`) as anio,
            s.name as metodoenvio,
            sum(d.`OrderQty`) as cantidad
        from salesorderheader h
            join salesorderdetail d ON (h.`SalesOrderID` = d.`SalesOrderID`)
            join shipmethod s ON (s.`ShipMethodID` = h.`ShipMethodID`)
        group BY YEAR(h.`OrderDate`), s.`Name`
        ORDER BY YEAR(h.`OrderDate`), s.`Name`) as v
;

-- 290 ms