WITH _temp_view_1 AS (
SELECT 100.00 * sum(CASE WHEN p_type LIKE 'PROMO%' THEN l_extendedprice * (1 - l_discount) ELSE 0 END) / sum(l_extendedprice * (1 - l_discount)) AS "promo_revenue", ts AS "t_b", te AS "t_e"
FROM (
    SELECT * FROM 
    (time_lineitem a 
    PERIOD JOIN WITH (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END, AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END) AS (ts,te) 
    time_part b
    ON (l_partkey = p_partkey)) x) y
    WHERE l_shipdate >= TO_DATE('1997-12-01', 'YYYY-MM-DD') AND l_shipdate < TO_DATE('1998-12-01', 'YYYY-MM-DD')
GROUP BY PERIOD WITH (ts, te)
),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."promo_revenue" AS "promo_revenue", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "promo_revenue" AS "promo_revenue", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."promo_revenue" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "promo_revenue" AS "promo_revenue", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."promo_revenue" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "promo_revenue" AS "promo_revenue", (sum(F0."t_b") OVER (PARTITION BY F0."promo_revenue" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."promo_revenue" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."promo_revenue" AS "promo_revenue", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL
SELECT F0."promo_revenue" AS "promo_revenue", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
WHERE (F0.DIFFPREVIOUS != 0)) F0
WHERE (NOT (((F0."t_e") IS NULL))))
SELECT F0."promo_revenue" AS "promo_revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));