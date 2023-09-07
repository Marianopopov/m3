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


delimiter $$
create procedure ordenesxfecha(in fecha date)
begin
	select count(*) from salesorderheader
    where date(orderdate)=fecha;
end $$
delimiter ;

call ordenesxfecha('2002-01-01');

select * from salesorderdetail;
select*from productsubcategory;
