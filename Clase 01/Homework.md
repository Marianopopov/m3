![HenryLogo](https://d31uz8lwfmyn8g.cloudfront.net/Assets/logo-henry-white-lg.png)


## Homework

Ejecutar el script AdventureWorks.sql para cargar las tablas y sus registros.
(Recuerda que si recibes el triángulo de alerta en vez del tilde verde, el código se ejecutó.)<br>

1. Crear un procedimiento que recibe como parámetro una fecha y muestre la cantidad de órdenes ingresadas en esa fecha.<br>

Si no recuerdas el formato del procedimiento, repasa el ejemplo de la cápsula. El formato debe ser:<br>

DELIMITER $$
CREATE PROCEDURE (NOMBRE...)
BEGIN
    (CODIGO)
END $$

DELIMITER ;<br>



2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.<br>

Si no recuerdas el formato del procedimiento, repasa el ejemplo de la cápsula. El formato debe ser:<br>

DELIMITER $$
CREATE FUNCTION (NOMBRE...)
BEGIN
    DECLARE ...
    SET ...
    RETURN ...
END $$

DELIMITER ;<br>


3. Obtner un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo StandardCost. Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.<br>


4. Crear un procedimiento que reciba como parámetro una fecha desde y una hasta, y muestre un listado con los Id de los diez Clientes que más costo de transporte tienen entre esas fechas (campo Freight).<br>
5. Crear un procedimiento que permita realizar la insercción de datos en la tabla shipmethod.<br>

Origen del Dataset: https://learn.microsoft.com/en-us/previous-versions/sql/sql-server-2008/ms124597(v=sql.100)
Diccionario de Datos: AdventureWorks_DataDictionary
En el script "AWBackup.sql" se encuentra todas las tablas del juego de datos.