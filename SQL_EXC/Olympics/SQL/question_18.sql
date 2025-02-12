SELECT
region,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
FROM olympics.athlete_events ae JOIN olympics.noc_regions nr 
ON nr.NOC = ae.noc
group by region
having gd_cnt = 0 and (slv_cnt > 0 or brz_cnt > 0)