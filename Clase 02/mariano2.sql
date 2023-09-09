use adventureworks;


/* 1 Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", 
entre los años 2000 y 2003, cuyo método de envío sea "CARGO TRANSPORT 5".*/

SELECT
    c.firstName,
    c.lastName,
    c.contactID
FROM salesorderheader as h
    JOIN contact as c on (h.contactID= c.contactID)
    JOIN salesorderdetail as d on (h.salesorderid = d.salesorderid)
    JOIN product as p on (d.productID = p.productID)
    JOIN productsubcategory as sub on (p.productsubcategoryID = sub.productsubcategoryID)
    JOIN shipmethod as ship on (h.shipmethodID = ship.shipmethodID)
where Year(h.orderDate) between 2000 and 2003
AND sub.Name = "Mountain Bikes"
AND ship.Name = "CARGO TRANSPORT 5"
GROUP BY c.lastName, c.firstName, c.contactID;


--2 

/*Obtener un listado contactos que hayan ordenado productos de la 
subcategoría "Mountain Bikes", entre los años 2000 y 2003 con la 
cantidad de productos adquiridos y ordenado por este valor, 
de forma descendente.*/

SELECT
    c.firstName,
    c.lastName,
    c.contactID,
    sum(d.orderqty) as total_compras
FROM salesorderheader as h
    JOIN contact as c on (h.contactID= c.contactID)
    JOIN salesorderdetail as d on (h.salesorderid = d.salesorderid)
    JOIN product as p on (d.productID = p.productID)
    JOIN productsubcategory as sub on (p.productsubcategoryID = sub.productsubcategoryID)
where Year(h.orderDate) between 2000 and 2003
AND sub.Name = "Mountain Bikes"
GROUP BY  c.firstName, c.lastName , c.contactID
ORDER BY total_compras desc;


-- 3 
/* Obtener un listado de cual fue el volumen de compra (del conctact)
(cantidad) por año y método de envío.*/

SELECT
    YEAR(h.orderdate) as fecha, 
    ship.name as nombre,
    sum(d.orderqty)
FROM salesorderheader as h
    JOIN salesorderdetail as d on (d.salesorderID = h.salesorderID)
    JOIN shipmethod as ship on (h.shipmethodID = ship.shipmethodID)
GROUP BY fecha, nombre
ORDER BY 3 desc;

-- 4 
/*Obtener un listado por categoría de productos, 
con el valor total de ventas y productos vendidos.*/

SELECT
    c.name, sum(d.orderqty) as cantidad_productos, 
    sum(d.linetotal) as total_ventas
from salesorderheader as h
    join salesorderdetail as d on (h.salesorderID = d.salesorderID)
    join product as p on (d.ProductID = p.ProductID)
    join productsubcategory as sub on (p.productsubcategoryID = sub.productsubcategoryID)
    join productcategory as c on (sub.productcategoryID = c.productcategoryID)
    
GROUP BY c.name
ORDER BY total_ventas;

-- 5) Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
-- sólo para aquellos países donde se enviaron más de 15 mil productos. 

SELECT
    co.Name,
    sum(d.orderqty) as cantidad_productos, 
    sum(d.linetotal) as total_ventas
from salesorderheader as h               
    join salesorderdetail as d on (h.salesorderID = d.salesorderID)
    join address as a on (h.shiptoaddressID = a.addressID)
    join stateprovince as state on (a.StateProvinceID = state.StateProvinceID)
    join countryregion as co on (state.CountryRegionCode = co.CountryRegionCode)
group BY co.name
having sum(d.orderqty) > 15000
ORDER BY co.name;


-- 6) Obtener un listado de las cohortes que no tienen alumnos asignados, 
-- utilizando la base de datos henry, desarrollada en el módulo anterior.

USE henry;
SELECT *
FROM cohorte as c
LEFT JOIN alumno as a ON (c.idCohorte=a.IdCohorte)
WHERE a.IdCohorte is null;