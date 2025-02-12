WITH medals as (SELECT
                    region,
                    games,
                    COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
                    COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
                    COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
                    FROM olympics.athlete_events ae JOIN olympics.noc_regions nr
                    ON nr.noc = ae.noc
                    group by region, games),
tot as (select region, games, gd_cnt + slv_cnt + brz_cnt as tot_med from medals group by region, games),
mx_tot as (select region, games, tot_med from tot where (games,tot_med) in (select games, max(tot_med) from tot group by games)),
mx as (SELECT games, MAX(gd_cnt)gd, MAX(slv_cnt)slv, MAX(brz_cnt) brz from medals GROUP BY games),
mx_gd as (SELECT region, games, gd_cnt from medals where (games, gd_cnt) in (select games, gd from mx)),
mx_slv as (SELECT region, games, slv_cnt from medals where (games, slv_cnt) in (select games, slv from mx)),
mx_brz as (SELECT region, games, brz_cnt from medals where (games, brz_cnt) in (select games, brz from mx)),
cal as (select DISTINCT games from olympics.athlete_events)
SELECT
cal.games,
mx_gd.region gd_region,
gd_cnt,
mx_slv.region slv_region,
slv_cnt,
mx_brz.region brz_region,
brz_cnt,
mx_tot.region all_medal,
tot_med
from mx_slv RIGHT JOIN cal
ON cal.games = mx_slv.games
LEFT JOIN mx_gd ON mx_gd.games = cal.games
LEFT JOIN mx_brz ON mx_brz.games = cal.games
RIGHT JOIN mx_tot ON mx_tot.games = cal.games
order by cal.games
-- select * from mx_tot

