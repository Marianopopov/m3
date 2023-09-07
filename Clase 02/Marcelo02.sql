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
