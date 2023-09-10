use adventureworks;

-- 1. Obtener un listado de cuál fue el volumen de ventas (cantidad) por año y método de envío mostrando para cada 
-- registro, qué porcentaje representa del total del año. Resolver utilizando Subconsultas y Funciones Ventana, 
-- luego comparar la diferencia en la demora de las consultas.

-- Función ventana
select año, metodo_envio, volumen_ventas, volumen_ventas / SUM(volumen_ventas) OVER (PARTITION BY Año) * 100 AS Porcentaje_venta_anual 
from 
	(select year(h.orderdate) as año, m.name as metodo_envio, sum(d.orderqty) as volumen_ventas 
		from salesorderheader h
		join salesorderdetail d on (h.SalesOrderID=d.salesorderid)
		join shipmethod m on (h.ShipMethodID=m.ShipMethodID)
		group by year(h.orderdate), m.name
		ORDER BY year(h.orderdate), m.name) as ventas ;

-- Subconsulta
select year(h.orderdate) as año, m.name as metodo_envio, sum(d.orderqty) as volumen_ventas, sum(d.orderqty) / t.volumen_total * 100 AS Porcentaje_venta_anual 
from salesorderheader h
	join salesorderdetail d on (h.SalesOrderID=d.salesorderid)
	join shipmethod m on (h.ShipMethodID=m.ShipMethodID)
	join (select year(h.orderdate) as año,sum(d.orderqty) as volumen_total
		from salesorderheader h
		join salesorderdetail d on (h.SalesOrderID=d.salesorderid)
		group by year(h.orderdate)) as t
		ON (YEAR(h.OrderDate) = t.Año)
GROUP BY YEAR(h.OrderDate), m.Name, t.volumen_total
ORDER BY YEAR(h.OrderDate), m.Name;

-- Las Subconsultas tardan más en ejecutarse que las Ventanas.


-- 2. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, 
-- mostrando para ambos, su porcentaje respecto del total

select categoria, totalventas, cantidadproductos, cantidadproductos/sum(cantidadproductos) OVER () * 100 AS Porcentaje_CP, round(totalventas/sum(totalventas) OVER () * 100,2) AS Porcentaje_TV
from 
	(select c.name as categoria, round(sum(d.linetotal),2) as totalventas, sum(d.orderqty) as cantidadproductos
		from salesorderheader h
		join salesorderdetail d on (h.SalesOrderID=d.salesorderid)
		join product p on (d.productiD=p.ProductID)
        join productsubcategory s on (p.ProductSubcategoryID=s.ProductSubcategoryID)
        join productcategory c on (s.ProductCategoryID=c.ProductCategoryID)
		group by c.name
		ORDER BY c.name) c ;
        
-- 3. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
-- mostrando para ambos, su porcentaje respecto del total.

select pais, totalventas, cantidadproducto, cantidadproducto/sum(cantidadproducto) OVER () * 100 AS Porcentaje_CP, round(totalventas/sum(totalventas) OVER () * 100,2) AS Porcentaje_TV
from 
	(select cr.name as pais, round(sum(d.linetotal),2) as totalventas, sum(d.orderqty) as cantidadproducto from salesorderheader h
	join salesorderdetail d on (h.salesorderid = d.salesorderid)
	join address a on (h.shiptoaddressid=a.addressid)
	join stateprovince s on (a.stateprovinceid=s.stateprovinceid)
	join countryregion cr on (s.countryregioncode=cr.countryregioncode)
	group by cr.name
	ORDER BY cr.name) c;

-- 4.Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes 
-- realizadas. Investigar las funciones FLOOR() y CEILING().

SELECT p.ProductID, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY d.LineTotal) OVER (PARTITION BY p.ProductID) AS Mediana FROM
  (select p.productid, d.linetotal from salesorderheader h 
   join salesorderdetail d on (h.salesorderid=d.salesorderid)
   join product p on (d.productid=p.productid)
   group by p.productid
   order by p.productid) c;


SELECT
  p.ProductID,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY d.LineTotal) OVER (PARTITION BY p.ProductID) AS Mediana
FROM
  salesorderheader h
  JOIN salesorderdetail d ON h.SalesOrderID = d.SalesOrderID
  JOIN product p ON d.ProductID = p.ProductID
ORDER BY
  p.ProductID;
