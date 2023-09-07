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
