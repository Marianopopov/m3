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


-- 2. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, 
-- mostrando para ambos, su porcentaje respecto del total.<br>
SELECT
categoria, 
cantidad, 
total,
cantidad / sum(cantidad) over() * 100 as prorcentaje_Cantidad,
total / sum(total) over() * 100 as porcentaje_venta
from 
        (SELECT
            c.name as categoria,
            sum(d.orderqty) as cantidad, 
            sum(d.linetotal) as total
        from salesorderheader as h
            join salesorderdetail as d on (h.salesorderID = d.salesorderID)
            join product as p on (d.ProductID = p.ProductID)
            join productsubcategory as sub on (p.productsubcategoryID = sub.productsubcategoryID)
            join productcategory as c on (sub.productcategoryID = c.productcategoryID)
            
        GROUP BY c.name
        ORDER BY total) as productos_por_categoria
        ;

-- 3. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
-- mostrando para ambos, su porcentaje respecto del total.

SELECT
pais, 
cantidad, 
total,
cantidad / sum(cantidad) over() * 100 as prorcentaje_Cantidad,
total / sum(total) over() * 100 as porcentaje_venta
from 
        (SELECT
            cr.name as pais,
            sum(d.`OrderQty`) as cantidad, 
            sum(d.`LineTotal`) as total
        from salesorderheader as h
            join salesorderdetail as d on (h.`SalesOrderID` = d.`SalesOrderID`)
            join address as a on (h.`ShipToAddressID` = a.`AddressID`)
            join stateprovince as sp on (sp.`StateProvinceID` = a.`StateProvinceID`)
            join countryregion as cr on (cr.`CountryRegionCode` = sp.`CountryRegionCode`)    
        GROUP BY cr.`Name`
        ORDER BY cr.`Name`) as listado_pais 
        ;


-- 4 Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes realizadas. 
-- Investigar las funciones FLOOR() y CEILING().*/

SELECT
ProductID, 
AVG(LineTotal) AS Mediana_Producto, 
Conteo
from
    (SELECT
        d.productid,
        d.linetotal,
        count(*) over (PARTITION BY d.`ProductID`) as conteo,
        ROW_NUMBER () OVER (PARTITION BY d.`ProductID` ORDER BY d.linetotal) as row_num
    FROM salesorderheader H
        join salesorderdetail D on (h.salesorderID = d.salesorderID)) as sub
where (FLOOR(conteo/2) = CEILING(conteo/2) and row_num = FLOOR(conteo/2) or row_num = FLOOR(conteo/2) + 1)
GROUP BY productID
    ;





