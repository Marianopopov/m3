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
SELECT contactID FROM contact;
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
