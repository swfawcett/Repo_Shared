select
title,
rental_date,
return_date
from sakila.rental r join
sakila.inventory i on i.inventory_id = r.inventory_id
join sakila.film f on f.film_id = i.film_id
where return_date is null
order by title
