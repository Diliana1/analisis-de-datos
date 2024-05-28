#NIVEL 1
select * from transactions.company;
select* from transactions.transaction;


# ejercicio 2/a
-- Listado de los países que están realizando compras;
select distinct company.country, transaction.declined
FROM transactions.company
join transactions.transaction on company_id = transaction.company_id
where transaction.declined = 0;

#ejercicio 2/b
#Desde cuántos países se realizan las compras;


select count(distinct company.country)
FROM transactions.company
join transactions.transaction on company_id = transaction.company_id;

#ejercicio 2/c
#Identifica a la compañía con la mayor media de ventas;
select company_id, avg(amount)
FROM transactions.transaction
group by company_id
order by avg(amount) desc;

#ejercicio3
#Sin JOIN
#Muestra todas las transacciones realizadas por empresas de Alemania;

Select * 
From transactions.transaction
WHERE company_id IN (
    SELECT id
    FROM transactions.company
    WHERE country = 'Germany'
);

#ejercicio3/b
#Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.

select company_name
from transactions.company
where id in (
	select company_id
	from transactions.transaction
	where amount> (select avg(amount) as media
		from transactions.transaction));

#Ejercicio 3/c
#Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
        

select company_name
from transactions.company
where id not in ( select company_id
		from transactions.transaction);
        
#NIVEL II
# Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. Muestra la fecha de cada transacción junto con el total de las ventas.
SELECT amount as monto, company_id, date(timestamp)
from transactions.transaction
order by monto desc
limit 5;

#Ejercicio 2
#¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
select round(avg(amount),2) as ventas, company.country
from transactions.transaction
join transactions.company ON company.id= transaction.company_id
group by company.country 
order by ventas desc;

#verificando con varios paises
select avg(amount) as ventas, company.country
from transactions.transaction
join transactions.company on company.id= transaction.company_id
where company.country = 'united states';

#Ejercicio 3
#En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”.
# Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.
#Muestra el listado aplicando JOIN y subconsultas.

select amount as ventas, company.country, company.id,  company_name
from transactions.transaction
join transactions.company ON company.id= transaction.company_id
where company.country = (select company.country
						from transactions.company
						where company_name = 'enim condimentum ltd');

#validando
select *
from transactions.company
where company_name = 'enim condimentum ltd';

#En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”.
# Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.
#Muestra el listado aplicando solo subconsultas.

select amount, (select company_name from transactions.company where company_id= transactions.company.id)as empresa
from transactions.transaction
where company_id in ( select company.id
                      from transactions.company 
                      where  company.country = (select company.country
						from transactions.company
						where company_name = 'enim condimentum ltd') );
                     
	
  
#nivel 3
#Ejercicio 1
#Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones 
#con un valor comprendido entre 100 y 200 euros y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. 
#Ordena los resultados de mayor a menor cantidad.
  
select company_name, phone,country,date(timestamp),amount
from transactions.transaction
join transactions.company ON company.id= transaction.company_id
where (date(timestamp)='2021-04-29' or date(timestamp)='2021-06-20' or date(timestamp)= '2022-03-13')
and amount BETWEEN 100.00 AND 200.00 ;

# Ejercicio 2
# Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas,
# pero el departamento de recursos humanos es exigente y quiere un listado de las empresas donde especifiques si tienen más de 4 o menos transacciones.

select company_name, count(transaction.id) as contador
from transactions.transaction
join transactions.company ON company.id= transaction.company_id
group by company_name 
having contador <>4;

SELECT company_name ,
CASE
WHEN COUNT(transaction.id) > 4 THEN "Mayores"
ELSE "Menores"
END AS "transacciones mas o menos de 4"
FROM transactions.transaction
JOIN transactions.company on company.id= transaction.company_id
GROUP BY company_name
ORDER BY company_name ASC;


