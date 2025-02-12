SELECT distinct
date_format(date(rental_date), '%Y-%m-%d') 'date',
count(*) rental_ct
FROM sakila.rental r 
group by date_format(date(rental_date), '%Y-%m-%d')
order by rental_ct desc