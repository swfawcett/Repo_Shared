SELECT
concat(first_name,' ', last_name)
FROM sakila.customer c join
sakila.payment p on p.customer_id = c.customer_id
join sakila.rental r on r.rental_id = p.rental_id
where date(rental_date) = '2005-07-26'