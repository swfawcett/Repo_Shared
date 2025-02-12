SELECT
noc,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
FROM olympics.athlete_events
group by noc