
# 1. Obtener un listado de cual fue el volumen de ventas (cantidad) por año y método de envío mostrando para cada registro, 
## qué porcentaje representa del total del año. Resolver utilizando Subconsultas y Funciones Ventana, 
## luego comparar la diferencia en la demora de las consultas.

USE adventureworks;

SELECT
*,
volumenVentas / SUM(volumenVentas) OVER (PARTITION BY anio ORDER BY anio) as porcentaje
FROM
(
	SELECT
	YEAR(A.orderdate) as anio,
	C.Name, 
	SUM(B.orderqty) AS volumenVentas
	FROM
	salesorderheader A
	INNER JOIN 
	salesorderdetail B
	ON A.salesorderid = B.salesorderid
	INNER JOIN
	shipmethod C
	ON A.shipmethodid = C.shipmethodid
	GROUP BY 
	1,2
) A;


### Sin funciones ventana

WITH desagregado as
(
	SELECT
	YEAR(A.orderdate) as anio,
	C.Name, 
	SUM(B.orderqty) AS volumenVentas
	FROM
	salesorderheader A
	INNER JOIN 
	salesorderdetail B
	ON A.salesorderid = B.salesorderid
	INNER JOIN
	shipmethod C
	ON A.shipmethodid = C.shipmethodid
	GROUP BY 
	1,2
),
totalAnio AS
(
	SELECT
	YEAR(A.orderdate) as anio,
	SUM(B.orderqty) AS volumenVentas
	FROM
	salesorderheader A
	INNER JOIN 
	salesorderdetail B
	ON A.salesorderid = B.salesorderid
	INNER JOIN
	shipmethod C
	ON A.shipmethodid = C.shipmethodid
	GROUP BY 
	1
)
select
A.*,
B.volumenventas,
A.volumenventas/ B.volumenventas as porcentaje
from
desagregado A
INNER JOIN
totalanio B
ON A.anio = B.anio;

### Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, 
## mostrando para ambos, su porcentaje respecto del total.

SELECT
*, 
totalventas / SUM(totalVentas) OVER () as porcentajeVentas,
totalUnidades / SUM(totalUnidades) OVER () as porcentajeUnidades
FROM
(
	SELECT
	C.Name, 
	SUM(D.linetotal) as TotalVentas,
	SUM(D.orderqty) as TotalUnidades
	FROM
	product A
	INNER JOIN 
	productsubcategory B
	ON A.productsubcategoryid = B.productsubcategoryid
	INNER JOIN
	productcategory C
	ON B.productcategoryid = C.productcategoryid
	INNER JOIN
	salesorderdetail D
	ON A.productid = D.productid
	GROUP BY 
	1
) A;

### Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
## mostrando para ambos, su porcentaje respecto del total.

SELECT
*, 
ROUND(totalVentas / SUM(totalVentas) OVER (),2)as porcentajeVentas,
ROUND(totalUnidades / SUM(totalUnidades) OVER (),2) as porcentajeUnidades
FROM
(
	SELECT
	D.Name,
	SUM(E.Linetotal) AS totalVentas,
	SUM(E.orderqty) as TotalUnidades
	FROM
	salesorderheader A
	INNER JOIN 
	address B
	ON A.shiptoaddressid = B.addressid
	INNER JOIN
	stateprovince C
	ON C.stateprovinceid = B.stateprovinceid
	INNER JOIN
	countryregion D
	ON D.countryregioncode = C.countryregioncode
	INNER JOIN
	salesorderdetail E
	ON A.salesorderid = E.salesorderid
	GROUP BY 
	D.Name
) A;

### Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes realizadas. 
## Investigar las funciones FLOOR() y CEILING().


SELECT
ProductID,
AVG(linetotal) as mediana
FROM
(
	SELECT
	productid, 
	linetotal,
	count(*) over (partition by productid) AS RECUENTO,
	ROW_NUMBER() OVER (PARTITION BY productid ORDER BY linetotal ASC) AS ORDEN
	FROM
	salesorderdetail
) A
WHERE 
(FLOOR(recuento/2) = CEILING(recuento/2) and (ORDEN = RECUENTO/2 OR ORDEN = (RECUENTO/2) + 1 ))
OR
(FLOOR(recuento/2) != CEILING(recuento/2) and ORDEN = CEILING(RECUENTO/2))
group by productid
;


-- LEAD y LAG

SELECT
*,
Lag(totalVenta,1,null) OVER (ORDER BY anio),
lead(totalVenta,1,null) OVER (ORDER BY anio),
ROUND((totalVenta - Lag(totalVenta,1,null) OVER (ORDER BY anio)) / Lag(totalVenta,1,null) OVER (ORDER BY anio),2) AS porcentajecrecimiento
FROM
(
	SELECT
	year(ORDERDATE) as anio, 
	SUM(totalDue) as TotalVenta
	FROM
	salesorderheader
GROUP BY 1
)A ;


-- Un ejemplo con OVER y PARTITION BY
SELECT
*,
RANK() OVER (PARTITION BY name ORDER BY totalventas DESC)
FROM
(
	SELECT
	E.name,
	d.firstname ,
	d.lastname,
	SUM(A.totaldue) as TotalVentas
	FROM
	salesorderheader A
	inner join 
	salesperson B
	ON A.salespersonid = B.salespersonid
	INNER JOIN 
	employee C
	ON C.employeeid = B.salespersonid
	INNER JOIN
	contact D
	ON D.contactid = C.contactid
	INNER JOIN 
	salesterritory E
	ON E.territoryid = A.territoryid
	GROUP BY 
	1,2,3
) A;

