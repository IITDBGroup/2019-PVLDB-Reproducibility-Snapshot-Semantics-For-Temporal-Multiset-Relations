WITH _temp_view_2 AS (
SELECT l_shipmode AS "l_shipmode", sum(CASE WHEN o_orderpriORity = '1-URGENT' OR o_orderpriority = '2-HIGH' THEN 1 ELSE 0 END) AS "high_line_count", sum(CASE WHEN o_orderpriORity <> '1-URGENT' AND o_orderpriORity <> '2-HIGH' THEN 1 ELSE 0 END) AS "low_line_count", ts AS "t_b", te AS "t_e"
FROM 
   (
    time_orders a 
    PERIOD JOIN WITH (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts,te) 
    time_lineitem b
    ON (o_orderkey = l_orderkey)) x
WHERE (l_shipmode = 'AIR' OR l_shipmode = 'MAIL') AND l_commitdate < l_receiptdate AND l_shipdate < l_commitdate AND l_receiptdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD') AND l_receiptdate < TO_DATE('1996-01-01', 'YYYY-MM-DD') 
GROUP BY PERIOD WITH (ts, te) l_shipmode 
ORDER BY l_shipmode
),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."l_shipmode" AS "l_shipmode", F0."high_line_count" AS "high_line_count", F0."low_line_count" AS "low_line_count", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "l_shipmode" AS "l_shipmode", "high_line_count" AS "high_line_count", "low_line_count" AS "low_line_count", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."l_shipmode", F0."high_line_count", F0."low_line_count" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "l_shipmode" AS "l_shipmode", "high_line_count" AS "high_line_count", "low_line_count" AS "low_line_count", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."l_shipmode", F0."high_line_count", F0."low_line_count" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "l_shipmode" AS "l_shipmode", "high_line_count" AS "high_line_count", "low_line_count" AS "low_line_count", (sum(F0."t_b") OVER (PARTITION BY F0."l_shipmode", F0."high_line_count", F0."low_line_count" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."l_shipmode", F0."high_line_count", F0."low_line_count" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."l_shipmode" AS "l_shipmode", F0."high_line_count" AS "high_line_count", F0."low_line_count" AS "low_line_count", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0 UNION ALL
SELECT F0."l_shipmode" AS "l_shipmode", F0."high_line_count" AS "high_line_count", F0."low_line_count" AS "low_line_count", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0) F0) F0) F0
WHERE (F0.DIFFPREVIOUS != 0)) F0
WHERE (NOT (((F0."t_e") IS NULL)))),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."l_shipmode" AS "l_shipmode", F0."high_line_count" AS "high_line_count", F0."low_line_count" AS "low_line_count", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_1) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_1) F0)) F1(n) ON ((F0."numopen" >= F1.N))))
SELECT F0."l_shipmode" AS "l_shipmode", F0."high_line_count" AS "high_line_count", F0."low_line_count" AS "low_line_count", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_0) F0
ORDER BY F0."l_shipmode" ASC NULLS LAST;
