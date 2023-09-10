USE adventureworks;

SELECT YEAR(`OrderDate`), s.`Name`, SUM(`OrderQty`)
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

