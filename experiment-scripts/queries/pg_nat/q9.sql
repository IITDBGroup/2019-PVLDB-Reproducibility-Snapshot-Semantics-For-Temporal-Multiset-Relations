WITH _temp_view_2 AS (
SELECT nation AS "nation", o_year AS "o_year", sum(amount) AS "sum_profit", ts AS "t_b", te AS "t_e"  FROM (
 SELECT n_name AS nation, to_char(o_orderdate, 'YYYY') AS o_year, l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity AS amount, ts, te
 FROM (
  SELECT * FROM (     
   (SELECT * FROM (     
    (SELECT * FROM (
     (SELECT * FROM (
        (SELECT * FROM 
        (time_supplier a
        PERIOD JOIN WITH (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts1, te1) 
        time_lineitem b
        ON (s_suppkey = l_suppkey)) x) y
            PERIOD JOIN WITH (ts1, te1, VALIDITY_TIME_BEGIN, VALIDITY_TIME_END) AS (ts2, te2)
            time_partsupp c
            ON (l_suppkey = ps_suppkey)) x1) y1
                PERIOD JOIN WITH (ts2, te2, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts3, te3)
                time_orders d
                ON (l_orderkey = o_orderkey)) x2) y2
                   PERIOD JOIN WITH (ts3, te3, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts4, te4) 
                   time_nation e
                   ON (s_nationkey = n_nationkey)) x3) y3
                     PERIOD JOIN WITH (ts4, te4, AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END) AS (ts, te) 
                     (select * from time_part where p_name LIKE '%orange%') f
                     ON (l_partkey = p_partkey)) x4) y4) x5
     GROUP BY PERIOD WITH (ts, te) nation, o_year 
     ORDER BY nation, o_year desc
),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."nation" AS "nation", F0."o_year" AS "o_year", F0."sum_profit" AS "sum_profit", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "nation" AS "nation", "o_year" AS "o_year", "sum_profit" AS "sum_profit", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."nation", F0."o_year", F0."sum_profit" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "nation" AS "nation", "o_year" AS "o_year", "sum_profit" AS "sum_profit", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."nation", F0."o_year", F0."sum_profit" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "nation" AS "nation", "o_year" AS "o_year", "sum_profit" AS "sum_profit", (sum(F0."t_b") OVER (PARTITION BY F0."nation", F0."o_year", F0."sum_profit" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."nation", F0."o_year", F0."sum_profit" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."nation" AS "nation", F0."o_year" AS "o_year", F0."sum_profit" AS "sum_profit", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0 UNION ALL
SELECT F0."nation" AS "nation", F0."o_year" AS "o_year", F0."sum_profit" AS "sum_profit", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0) F0) F0) F0
) F0
WHERE (F0.DIFFPREVIOUS != 0) AND (NOT (((F0."t_e") IS NULL)))),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."nation" AS "nation", F0."o_year" AS "o_year", F0."sum_profit" AS "sum_profit", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_1) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_1) F0)) F1(n) ON ((F0."numopen" >= F1.N))))
SELECT F0."nation" AS "nation", F0."o_year" AS "o_year", F0."sum_profit" AS "sum_profit", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_0) F0
ORDER BY F0."nation" ASC NULLS LAST, F0."o_year" DESC NULLS LAST;