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
    FROM salesorderdetail


SELECT sum(`OrderQty`)
    FROM salesorderdetail

SELECT c.`Name`, SUM(`LineTotal`), SUM(`OrderQty`)
    FROM salesorderdetail d
    JOIN product p
        ON d.`ProductID`=p.`ProductID`
    JOIN productsubcategory s
        ON p.`ProductSubcategoryID`=s.`ProductSubcategoryID`
    JOIN productcategory c
        ON s.`ProductCategoryID`=c.`ProductCategoryID`
GROUP BY 1


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
ORDER BY 1