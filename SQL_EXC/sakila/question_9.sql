with cte as (select
            inventory_id,
            count(*) ct
            from sakila.rental
            group by inventory_id
            having ct <= 1)
select
title,
cte.inventory_id,
ct
from cte left join sakila.inventory i 
on i.inventory_id = cte.inventory_id join
sakila.film f on f.film_id = i.film_id 
