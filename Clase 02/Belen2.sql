use adventureworks;
-- 1. Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los 
-- años 2000 y 2003, cuyo método de envío sea "CARGO TRANSPORT 5".

select *  from contact;
select * from salesorderheader;
select * from productsubcategory where name= "Mountain Bikes";
select*from salesorderdetail;
select* from product;
select*from shipmethod;


select distinct c.firstname, c.lastname from salesorderheader h
join contact c on (h.contactid=c.contactid)
join salesorderdetail d on (h.salesorderid=d.salesorderid)
join product p on (d.productid=p.productid)
join productsubcategory s on (p.productsubcategoryid=s.productsubcategoryid)
join shipmethod m on (h.shipmethodid=m.shipmethodid)
where year(h.orderdate) between '2000' and '2003' and s.name="Mountain Bikes" and m.name="CARGO TRANSPORT 5";

-- 2. Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los
-- años 2000 y 2003 con la cantidad de productos adquiridos y ordenado por este valor, de forma descendente.

select distinct c.firstname, c.lastname, sum(d.orderqty) as cantidad from salesorderheader h
join contact c on (h.contactid=c.contactid)
join salesorderdetail d on (h.salesorderid=d.salesorderid)
join product p on (d.productid=p.productid)
join productsubcategory s on (p.productsubcategoryid=s.productsubcategoryid)
where year (h.orderdate) between '2000' and '2003' and s.name="Mountain Bikes" 
group by c.firstname, c.lastname
order by cantidad desc;

-- 3.Obtener un listado de cual fue el volumen de compra (cantidad) por año y método de envío.
select sum(d.orderqty) as cantidad, year(h.orderdate), m.name from salesorderheader h
join salesorderdetail d on (h.salesorderid=d.salesorderid)
join shipmethod m on (h.shipmethodid=m.shipmethodid)
group by year(h.orderdate), m.name;

-- 4. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos.
select*from productcategory;
select*from product;
select * from salesorderdetail;

select c.name, round(sum(d.linetotal),2) as totalventas, sum(d.orderqty) as cantidadproductos from salesorderheader h
join salesorderdetail d on (h.salesorderid=d.salesorderid)
join product p on (d.productid=p.productid)
join productsubcategory s on (p.productsubcategoryid=s.productsubcategoryid)
join productcategory c on (s.productcategoryid=c.productcategoryid)
group by c.name
order by 2 desc;

-- 5. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, 
-- sólo para aquellos países donde se enviaron más de 15 mil productos.
select* from address;
select*from countryregion;
select*from stateprovince;
select*from salesorderheader;
select * from salesorderdetail;
select*from shipmethod;

select cr.name as pais, round(sum(d.linetotal),2) as totalventas, sum(d.orderqty) as cantidadproducto from salesorderheader h
join salesorderdetail d on (h.salesorderid = d.salesorderid)
join address a on (h.shiptoaddressid=a.addressid)
join stateprovince s on (a.stateprovinceid=s.stateprovinceid)
join countryregion cr on (s.countryregioncode=cr.countryregioncode)
group by pais having cantidadproducto > 15000
order by 2 desc;

-- 6.Obtener un listado de las cohortes que no tienen alumnos asignados, utilizando la base de datos henry, 
-- desarrollada en el módulo anterior.
use henry;
select * from cohorte;

select*from cohorte c
left join alumno a on (c.idcohorte = a.idcohorte)
where a.idcohorte is null;