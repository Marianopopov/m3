-- CR 02: Joins

USE adventureworks;

SELECT DISTINCT
F.ContactID,
F.FirstName,
F.LastName
FROM
salesorderheader A
INNER JOIN
salesorderdetail B
ON A.SalesOrderID = B.SalesOrderID
INNER JOIN
product C 
ON B.productid = C.productid
INNER JOIN
productsubcategory D
ON D.productsubcategoryid = C.productsubcategoryid
INNER JOIN
shipmethod E
ON A.shipmethodid = E.shipmethodid
INNER JOIN
contact F
ON A.contactid = F.contactid
WHERE
#OrderDate BETWEEN '2000-01-01' and '2003-12-31' ## OrderDate >= '2000-01-01' and OrderDate <= '2003-12-31'
YEAR(OrderDate) IN (2000,2001,2002,2003)
AND E.Name = 'CARGO TRANSPORT 5';


SELECT
*
FROM
product A,
productsubcategory B
WHERE
A.productsubcategoryid = B.productsubcategoryid
;

SELECT
*
FROM
product A
INNER JOIN
productsubcategory B
ON A.productsubcategoryid = B.productsubcategoryid

;
#Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", 
## entre los años 2000 y 2003 con la cantidad de productos adquiridos y ordenado por este valor, de forma descendente.


SELECT
F.ContactID,
F.FirstName,
F.LastName,
SUM(B.OrderQty) AS TotalUnidades
FROM
salesorderheader A
INNER JOIN
salesorderdetail B
ON A.SalesOrderID = B.SalesOrderID
INNER JOIN
product C 
ON B.productid = C.productid
INNER JOIN
productsubcategory D
ON D.productsubcategoryid = C.productsubcategoryid
INNER JOIN
contact F
ON A.contactid = F.contactid
WHERE
YEAR(OrderDate) IN (2000,2001,2002,2003)
AND D.Name = 'Mountain Bikes'
GROUP BY 
F.ContactID,
F.FirstName,
F.LastName
ORDER BY
SUM(B.OrderQty) DESC
;

## Obtener un listado de cual fue el volumen de compra (cantidad) por año y método de envío.

SELECT
YEAR(A.OrderDate) AS Anio,
E.Name as MetodoEnvio,
SUM(B.OrderQty) as TotalUnidades
FROM
salesorderheader A
INNER JOIN
salesorderdetail B
ON A.SalesOrderID = B.SalesOrderID
INNER JOIN
product C 
ON B.productid = C.productid
INNER JOIN
productsubcategory D
ON D.productsubcategoryid = C.productsubcategoryid
INNER JOIN
shipmethod E
ON E.shipmethodid = A.shipmethodid
INNER JOIN
contact F
ON A.contactid = F.contactid
GROUP BY 
YEAR(A.OrderDate),
E.Name;

-- Sin usar la palabra JOIN

SELECT
YEAR(A.OrderDate) AS Anio,
E.Name as MetodoEnvio,
SUM(B.OrderQty) as TotalUnidades
FROM
salesorderheader A,
salesorderdetail B,
shipmethod E
WHERE
A.SalesOrderID = B.SalesOrderID
AND E.shipmethodid = A.shipmethodid
GROUP BY 
YEAR(A.OrderDate),
E.Name;

-- Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos.

SELECT
C.Name,
SUM(D.linetotal) AS totalVenta,
SUM(D.orderqty) AS totalUnidades
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
ON D.productid = A.productid
GROUP BY 
C.Name;


#Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
##sólo para aquellos países donde se enviaron más de 15 mil productos.



SELECT
E.Name,
SUM(B.LineTotal) as totalVenta,
SUM(B.orderqty) as totalUnidades
FROM
salesorderheader A
INNER JOIN
salesorderdetail B
ON A.salesorderid = B.salesorderid
INNER JOIN
address C
ON A.shiptoaddressid = C.addressid
INNER JOIN
stateprovince D
ON D.stateprovinceid = C.stateprovinceid
INNER JOIN
countryregion E
ON E.countryregioncode = D.countryregioncode
GROUP BY 
E.Name
HAVING
totalUnidades > 15000
; 

# Obtener un listado de las cohortes que no tienen alumnos asignados, utilizando la base de datos henry, 
# desarrollada en el módulo anterior.











