-- Active: 1693280239040@@127.0.0.1@3306@adventureworks
USE adventureworks;

-- 1. Obtener un listado de cuál fue el volumen de ventas (cantidad) por año 
-- y método de envío mostrando para cada registro, qué porcentaje representa 
-- del total del año. Resolver utilizando Subconsultas y Funciones Ventana, 
-- luego comparar la diferencia en la demora de las consultas.

SELECT YEAR(`OrderDate`)
        , s.`Name`
        , SUM(`OrderQty`)
    FROM salesorderheader h
    JOIN shipmethod s
        ON h.`ShipMethodID`=s.`ShipMethodID`
    JOIN salesorderdetail d
        ON h.`SalesOrderID`=d.`SalesOrderID`
GROUP BY YEAR(`OrderDate`), s.`Name`

SELECT SUM(`OrderQty`)
    FROM salesorderheader h
    JOIN salesorderdetail d
        ON h.`SalesOrderID`=d.`SalesOrderID`
GROUP BY YEAR(`OrderDate`)


-- RESOLUCION 1
-- SUBCONSULTA EN EL SELECT
SELECT YEAR(`OrderDate`) as anio
        , s.`Name`
        , SUM(`OrderQty`) as cantidad
        , SUM(`OrderQty`)/(
            SELECT SUM(`OrderQty`)
                FROM salesorderheader h
                JOIN salesorderdetail d
                    ON h.`SalesOrderID`=d.`SalesOrderID`
            WHERE YEAR(`OrderDate`)=anio
            GROUP BY YEAR(`OrderDate`))*100 as "%"
    FROM salesorderheader h
    JOIN shipmethod s
        ON h.`ShipMethodID`=s.`ShipMethodID`
    JOIN salesorderdetail d
        ON h.`SalesOrderID`=d.`SalesOrderID`
GROUP BY YEAR(`OrderDate`), s.`Name`;


-- RESOLUCION 1
-- SUBCONSULTA EN EL JOIN (como si fuera otra tabla)
SELECT YEAR(`OrderDate`) as anio
        , m.`Name`
        , SUM(`OrderQty`) as cantidad
        , ROUND(100*SUM(`OrderQty`)/MIN(suma),2) as "%"
        , MIN(suma) -- solo para ver los valores, da igual si es min/max/avg
    FROM salesorderdetail d
    JOIN salesorderheader h 
        ON d.`SalesOrderID`=h.`SalesOrderID`
    JOIN shipmethod m
        ON h.`ShipMethodID`=m.`ShipMethodID`
    JOIN (SELECT SUM(`OrderQty`) as suma
                , YEAR(`OrderDate`) as anio
            FROM salesorderheader h
            JOIN salesorderdetail d
                ON h.`SalesOrderID`=d.`SalesOrderID`
        GROUP BY YEAR(`OrderDate`)) as sub
        ON YEAR(`OrderDate`)=sub.anio
GROUP BY 1,2
ORDER BY 1,2;


-- RESOLUCION 2
-- USANDO VENTANA
SELECT anio, metodo, suma cantidad, ROUND(100*suma/SUM(suma) OVER (PARTITION BY anio),2) "%"
    FROM(
        SELECT YEAR(`OrderDate`) as anio
            , s.`Name` as metodo
            , SUM(`OrderQty`) as suma
            FROM salesorderheader h
            JOIN shipmethod s
                ON h.`ShipMethodID`=s.`ShipMethodID`
            JOIN salesorderdetail d
                ON h.`SalesOrderID`=d.`SalesOrderID`
            GROUP BY 1,2) as sub



-- 2. Obtener un listado por categoría de productos,
-- con el valor total de ventas y productos vendidos, 
-- mostrando para ambos, su porcentaje respecto del total.

SELECT sum(LineTotal)
    FROM salesorderdetail;

SELECT sum(`OrderQty`)
    FROM salesorderdetail;

SELECT c.`Name`, SUM(`LineTotal`), SUM(`OrderQty`)
    FROM salesorderdetail d
    JOIN product p
        ON d.`ProductID`=p.`ProductID`
    JOIN productsubcategory s
        ON p.`ProductSubcategoryID`=s.`ProductSubcategoryID`
    JOIN productcategory c
        ON s.`ProductCategoryID`=c.`ProductCategoryID`
GROUP BY 1;


-- RESOLUCION CON SUBCONSULTA EN EL SELECT
SELECT c.`Name`
    , ROUND(SUM(`LineTotal`),2) valor_total
    , ROUND(100*SUM(`LineTotal`)/(
        SELECT sum(LineTotal) FROM salesorderdetail),2) "%_valor_total"
    , ROUND(SUM(`OrderQty`),2) prod_vendidos
    , ROUND(100*SUM(`OrderQty`)/(SELECT sum(`OrderQty`) FROM salesorderdetail),2) "%_prod_vendidos"
    FROM salesorderdetail d
    JOIN product p
        ON d.`ProductID`=p.`ProductID`
    JOIN productsubcategory s
        ON p.`ProductSubcategoryID`=s.`ProductSubcategoryID`
    JOIN productcategory c
        ON s.`ProductCategoryID`=c.`ProductCategoryID`
GROUP BY 1
ORDER BY 1;


-- RESOLUCION USANDO VENTANA
SELECT name
    , valor_total
    , ROUND(100*valor_total/sum(valor_total) OVER (),2) "%_valor_total"
    , prod_vendidos
    , ROUND(100*prod_vendidos/sum(prod_vendidos)  OVER (),2) "%_prod_vendidos"
FROM (SELECT c.`Name` name
        , ROUND(SUM(`LineTotal`),2) valor_total
        , ROUND(SUM(`OrderQty`),2) prod_vendidos
        FROM salesorderdetail d
        JOIN product p
            ON d.`ProductID`=p.`ProductID`
        JOIN productsubcategory s
            ON p.`ProductSubcategoryID`=s.`ProductSubcategoryID`
        JOIN productcategory c
            ON s.`ProductCategoryID`=c.`ProductCategoryID`
    GROUP BY 1) as sub
ORDER BY 1;




-- 3. Obtener un listado por país (según la dirección de envío),
--  con el valor total de ventas y productos vendidos,
--   mostrando para ambos, su porcentaje respecto del total.

SELECT * FROM salesorderheader;

SELECT c.`Name`
    , round(sum(`LineTotal`),2) total_vta
    , round(100*sum(`LineTotal`)/
                (SELECT sum(LineTotal)
                    FROM salesorderdetail),2) "%_total_vta"
    , sum(`OrderQty`) cant_vtas
    , round(100*sum(`OrderQty`)/
                (SELECT sum(`OrderQty`)
                    FROM salesorderdetail),2) "%_cant_vtas"
    FROM salesorderheader h
    JOIN salesorderdetail d
        ON h.`SalesOrderID`=d.`SalesOrderID`
    JOIN address a  
        ON h.`ShipToAddressID`=a.`AddressID`
    JOIN stateprovince p
        ON a.`StateProvinceID`=p.`StateProvinceID`
    JOIN countryregion c
        ON p.`CountryRegionCode`=c.`CountryRegionCode`
GROUP BY 1
ORDER BY 1;


-- RESOLUCION USANDO VENTANA
SELECT name
    , total_vta
    , ROUND(100*total_vta/sum(total_vta)  OVER (),2) "%_total_vta"
    , cant_vtas
    , ROUND(100*cant_vtas/sum(cant_vtas)  OVER (),2) "%_cant_vtas"
    FROM(SELECT c.`Name` as name
            , round(sum(`LineTotal`),2) total_vta
            , sum(`OrderQty`) cant_vtas
            FROM salesorderheader h
            JOIN salesorderdetail d
                ON h.`SalesOrderID`=d.`SalesOrderID`
            JOIN address a  
                ON h.`ShipToAddressID`=a.`AddressID`
            JOIN stateprovince p
                ON a.`StateProvinceID`=p.`StateProvinceID`
            JOIN countryregion c
                ON p.`CountryRegionCode`=c.`CountryRegionCode`
        GROUP BY 1) as sub
ORDER BY 1;

-- 4. Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal)
-- , sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING()

SELECT `ProductID`
    , sum(`LineTotal`)
    , COUNT(LineTotal) as q
    FROM salesorderdetail
GROUP BY `ProductID`
order by 1 ;

SELECT ProductID, Cnt, AVG(LineTotal) mediana,CEILING(Cnt/2), FLOOR(Cnt/2) + 1
FROM (
	SELECT	ProductID,
			LineTotal, 
			COUNT(*) OVER (PARTITION BY ProductID) AS Cnt,
			ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY LineTotal) AS RowNum
	FROM salesorderdetail) v
WHERE 	(Cnt%2=0 AND (RowNum = CEILING(Cnt/2) OR RowNum = FLOOR(Cnt/2) + 1))
	    OR
		(Cnt%2=1 AND RowNum = CEILING(Cnt/2))
GROUP BY 1;

SELECT	ProductID,
        LineTotal 
FROM salesorderdetail
WHERE ProductID=911
ORDER BY 2;

SELECT	ProductID,
        LineTotal 
FROM salesorderdetail
WHERE ProductID=942
ORDER BY 2;

SELECT ProductID, Cnt, AVG(LineTotal) mediana,CEILING(Cnt/2), FLOOR(Cnt/2) + 1
FROM (
	SELECT	ProductID,
			LineTotal, 
			COUNT(*) OVER (PARTITION BY ProductID) AS Cnt,
			ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY LineTotal) AS RowNum
	FROM salesorderdetail) v
WHERE 	(Cnt%2=0 AND (RowNum = FLOOR(Cnt/2) + 1))
	    OR
		(RowNum = CEILING(Cnt/2))
GROUP BY 1;

-- RESOLUCION FINAL OPTIMIZADA RAPIDA
SELECT ProductID
    , AVG(LineTotal) AS mediana
FROM (SELECT ProductID
        , LineTotal
        , COUNT(*) OVER (PARTITION BY ProductID) AS C
        , ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY LineTotal) AS R
	    FROM salesorderdetail) sub
WHERE 	(C%2=0 AND (R = FLOOR(C/2) + 1))
	    OR
		(R = CEILING(C/2))
GROUP BY 1;






