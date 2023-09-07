USE adventureworks;


--1)  Obtener un listado contactos que hayan ordenado productos
-- de la subcategoría "Mountain Bikes", entre los años 2000 y 2003,
-- cuyo método de envío sea "CARGO TRANSPORT 5".


-- buscar las tablas a trabajar
SELECT * FROM product;
DESCRIBE product;

SELECT * from ProductSubcategory;
DESCRIBE ProductSubcategory;

SELECT * from ProductCategory;
DESCRIBE ProductCategory;

SELECT * FROM salesorderdetail;
DESCRIBE salesorderdetail;

SELECT * FROM salesorderheader;
DESCRIBE salesorderheader;

SELECT * from Contact;
DESCRIBE Contact;

SELECT * FROM shipmethod;
DESCRIBE shipmethod;



SELECT * from ProductSubcategory
WHERE Name="Mountain Bikes";

SELECT * FROM shipmethod
WHERE Name="CARGO TRANSPORT 5";

-- Problema (hay 19972 contactos pero solo 19516 
--con firstname+lastname diferentes)
SELECT contactID, FirstName, LastName FROM contact;
SELECT DISTINCT FirstName, LastName FROM contact;

-- Entonces hay 456 contactos que tienen la misma combinacion
-- de firstname+lastname pero con direrentes IDs.
SELECT (CONCAT(FirstName," ", LastName)) as "Nombre y Apellido", count(CONCAT(FirstName, LastName)) as cantidad
FROM contact
GROUP BY (CONCAT(FirstName," ", LastName))
HAVING cantidad>1
ORDER BY cantidad DESC;


SELECT * from Contact
WHERE FirstName="Laura" AND LastName="Norman"

SELECT * from Contact
WHERE FirstName="Bradley" AND LastName="Beck"

SELECT * from Contact
WHERE FirstName="Yan" AND LastName="Li"



SELECT *
    FROM contact c
    JOIN salesorderheader soh on c.contactid=soh.contactid 
    JOIN shipmethod sm on soh.shipmethodid=sm.shipmethodid
    JOIN salesorderdetail sod on soh.salesorderid=sod.salesorderid
    JOIN product p on sod.productid=p.productid
    JOIN productsubcategory psc on p.productsubcategoryid=psc.productsubcategoryid


-- Listado final (206 registros)
SELECT DISTINCT c.ContactID, c.LastName, c.FirstName
    FROM contact c
    JOIN salesorderheader soh on c.contactid=soh.contactid 
    JOIN shipmethod sm on soh.shipmethodid=sm.shipmethodid
    JOIN salesorderdetail sod on soh.salesorderid=sod.salesorderid
    JOIN product p on sod.productid=p.productid
    JOIN productsubcategory psc on p.productsubcategoryid=psc.productsubcategoryid
WHERE psc.Name="Mountain Bikes"
    AND sm.Name="CARGO TRANSPORT 5"
    AND YEAR(soh.OrderDate) BETWEEN 2000 AND 2003
ORDER BY c.LastName, c.FirstName


-- 2. Obtener un listado contactos que hayan ordenado productos 
-- de la subcategoría "Mountain Bikes", entre los años 2000 y 2003
-- con la cantidad de productos adquiridos y ordenado por este valor,
-- de forma descendente.

SELECT * FROM salesorderdetail
ORDER BY OrderQty DESC;
DESCRIBE salesorderdetail;


SELECT c.ContactID, c.LastName, c.FirstName, SUM(OrderQty) as Q
    FROM contact c
    JOIN salesorderheader soh on c.contactid=soh.contactid 
    JOIN salesorderdetail sod on soh.salesorderid=sod.salesorderid
    JOIN product p on sod.productid=p.productid
    JOIN productsubcategory psc on p.productsubcategoryid=psc.productsubcategoryid
WHERE psc.Name="Mountain Bikes"
    AND YEAR(soh.OrderDate) BETWEEN 2000 AND 2003
GROUP BY c.ContactID, c.LastName, c.FirstName    
ORDER BY Q DESC;

-- problema 1
SELECT c.ContactID, c.LastName, c.FirstName, SUM(OrderQty) as Q
    FROM contact c
    JOIN salesorderheader soh on c.contactid=soh.contactid 
    JOIN salesorderdetail sod on soh.salesorderid=sod.salesorderid
    JOIN product p on sod.productid=p.productid
    JOIN productsubcategory psc on p.productsubcategoryid=psc.productsubcategoryid
WHERE psc.Name="Mountain Bikes"
    AND YEAR(soh.OrderDate) BETWEEN 2000 AND 2003
    AND LastName="Turner" AND FirstName="Jordan"
GROUP BY c.ContactID, c.LastName, c.FirstName    
ORDER BY Q DESC;

-- problema 2
SELECT c.ContactID, c.LastName, c.FirstName, SUM(OrderQty) as Q
    FROM contact c
    JOIN salesorderheader soh on c.contactid=soh.contactid 
    JOIN salesorderdetail sod on soh.salesorderid=sod.salesorderid
    JOIN product p on sod.productid=p.productid
    JOIN productsubcategory psc on p.productsubcategoryid=psc.productsubcategoryid
WHERE psc.Name="Mountain Bikes"
    AND YEAR(soh.OrderDate) BETWEEN 2000 AND 2003
    AND LastName="King" AND FirstName="Jordan"
GROUP BY c.ContactID, c.LastName, c.FirstName    
ORDER BY Q DESC;


-- 3. Obtener un listado de cual fue el volumen de 
-- compra (cantidad) por año y método de envío.

SELECT YEAR(soh.OrderDate) YEAR, sm.Name Envio, SUM(sod.OrderQty) Q
    FROM salesorderheader soh
    JOIN shipmethod sm ON soh.shipmethodID=sm.shipmethodID
    JOIN salesorderdetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY YEAR(soh.OrderDate), sm.Name;

-- extra (solo por año)
SELECT YEAR(soh.OrderDate) YEAR, SUM(sod.OrderQty) Q
    FROM salesorderheader soh
    JOIN shipmethod sm ON soh.shipmethodID=sm.shipmethodID
    JOIN salesorderdetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY YEAR(soh.OrderDate)


-- extra (solo por metodo de envio)
SELECT sm.Name Envio, SUM(sod.OrderQty) Q
    FROM salesorderheader soh
    JOIN shipmethod sm ON soh.shipmethodID=sm.shipmethodID
    JOIN salesorderdetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY sm.Name;

-- 4. Obtener un listado por categoría de productos,
-- con el valor total de ventas y productos vendidos.

SELECT pc.Name categoria, ROUND(SUM(sod.LineTotal),2) "Total de Vta", SUM(sod.OrderQty) cantidad
    FROM salesorderdetail sod
    JOIN product p ON sod.ProductID=p.ProductID
    JOIN productsubcategory psc ON p.ProductSubCategoryID=psc.ProductSubCategoryID
    JOIN productcategory pc ON psc.ProductCategoryID=pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY pc.Name;


DESCRIBE salesorderdetail;

-- precio x cantidad a veces es diferente al LineTotal
SELECT UnitPrice, OrderQty, UnitPriceDiscount, (UnitPrice*OrderQty) pxc, LineTotal
FROM salesorderdetail
WHERE ROUND((UnitPrice*OrderQty),4)!=ROUND(LineTotal,4);
-- precio x cantidad menos descuento = LineTotal
SELECT UnitPrice, OrderQty, (UnitPrice*OrderQty*(1-UnitPriceDiscount)) pxc, LineTotal
FROM salesorderdetail
WHERE ROUND((UnitPrice*OrderQty*(1-UnitPriceDiscount)),6)!=ROUND(LineTotal,6);

-- Resumen: LineTotal = UnitPrice*OrderQty*(1-UnitPriceDiscount)


-- 5. Obtener un listado por país (según la dirección de envío),
-- con el valor total de ventas y productos vendidos,
-- sólo para aquellos países donde se enviaron más de 15 mil productos.

DESCRIBE countryregion;
SELECT * FROM countryregion;

DESCRIBE address;
SELECT * FROM address;

DESCRIBE addresstype;
SELECT * FROM addresstype;


DESCRIBE customer;
SELECT * FROM customer;

DESCRIBE customeraddress;
SELECT * FROM customeraddress;


SELECT DISTINCT ShipToAddressID FROM salesorderheader
ORDER BY 1;
SELECT DISTINCT BillToAddressID FROM salesorderheader
ORDER BY 1;
SELECT DISTINCT ShipToAddressID, BillToAddressID from salesorderheader;

SELECT DISTINCT ShipToAddressID, BillToAddressID from salesorderheader
WHERE ShipToAddressID!=BillToAddressID;

SELECT DISTINCT addressID FROM address
ORDER BY 1;
DESCRIBE salesorderheader;
-- En la tabla SalesOrderHeader hay direccion de envio(Ship)
-- y direccion de facturacion (Bill)
-- ambos ID se relacionan con la tabla Address (AddressID)


SELECT cr.Name Pais, ROUND(SUM(sod.LineTotal),2) "Total de Vta", SUM(sod.OrderQty) cantidad
    FROM salesorderheader soh
    JOIN address a ON soh.ShipToAddressID=a.addressID
    JOIN stateprovince sp ON a.StateProvinceID=sp.StateProvinceID
    JOIN countryregion cr ON sp.CountryRegionCode=cr.CountryRegionCode
    JOIN salesorderdetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY 1
HAVING cantidad>15000
ORDER BY 1;


-- 6. Obtener un listado de las cohortes que no tienen alumnos asignados,
-- utilizando la base de datos henry, desarrollada en el módulo anterior.

use henry;

SELECT * from cohorte;
DESCRIBE cohorte;
SELECT * FROM alumno;
DESCRIBE alumno;

-- con right
SELECT c.idCohorte, c.codigo
    FROM alumno a
    RIGHT JOIN cohorte c ON a.idCohorte=c.idCohorte
WHERE a.idCohorte IS NULL;

-- con left
SELECT c.idCohorte, c.codigo
    FROM cohorte c
    LEFT JOIN alumno a ON c.idCohorte=a.idCohorte
WHERE a.idCohorte IS NULL;