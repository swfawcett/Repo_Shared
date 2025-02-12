SELECT 
concat(first_name, ' ', last_name) cust_name,
count(p.rental_id)
FROM sakila.customer c join
sakila.payment p on c.customer_id = p.customer_id
group by concat(first_name, ' ', last_name)
order by cust_name
