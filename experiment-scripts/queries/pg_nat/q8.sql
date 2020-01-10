WITH _temp_view_2 AS (
SELECT o_year AS "o_year", sum(CASE WHEN nation = 'ALGERIA' THEN volume ELSE 0 END) / sum(volume) AS "mkt_share", ts AS "t_b", te AS "t_e" FROM (
(SELECT to_char(o_orderdate, 'YYYY') AS o_year, l_extendedprice * (1 - l_discount) AS volume, n2_name AS nation, ts, te
FROM                                                                                           
(SELECT * FROM (
 (SELECT * FROM (
 (SELECT * FROM (
  (SELECT * FROM (
   (SELECT * FROM (
    (SELECT * FROM (
      (SELECT * FROM 
        (time_supplier a
        PERIOD JOIN WITH (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts1, te1) 
        time_lineitem b
        ON (s_suppkey = l_suppkey)) x1) y1
            PERIOD JOIN WITH (ts1, te1, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts2, te2) 
             time_orders b
             ON(l_orderkey = o_orderkey)) x2) y2
                PERIOD JOIN WITH (ts2, te2, VISIBLE_TIME_BEGIN, VISIBLE_TIME_END) AS (ts3, te3) 
                time_customer c
                ON (o_custkey = c_custkey)) x3) y3
                    PERIOD JOIN WITH (ts3, te3, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts4, te4) 
                    time_nation d
                    ON (c_nationkey = n_nationkey)) x4) y4
                        PERIOD JOIN WITH (ts4, te4, AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END) AS (ts5, te5)
                        time_part e
                        ON (l_partkey = p_partkey)) x5) y5 
                        PERIOD JOIN WITH (ts5, te5, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts6, te6) 
                        (SELECT n_nationkey AS n2_nationkey, n_name AS n2_name, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END FROM time_nation) n2
                        ON (s_nationkey = n2_nationkey)) x6) y6
                          PERIOD JOIN WITH (ts6, te6, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts, te) 
                          time_region
                          ON (n_regionkey = r_regionkey)) x7) y7
WHERE r_name = 'AFRICA' AND o_orderdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD')  AND o_orderdate <= TO_DATE('1996-12-31', 'YYYY-MM-DD')  AND p_type = 'PROMO BRUSHED COPPER') ) x8
            GROUP BY PERIOD WITH (ts,te) o_year ORDER BY o_year
),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."o_year" AS "o_year", F0."mkt_share" AS "mkt_share", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "o_year" AS "o_year", "mkt_share" AS "mkt_share", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."o_year", F0."mkt_share" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "o_year" AS "o_year", "mkt_share" AS "mkt_share", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."o_year", F0."mkt_share" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "o_year" AS "o_year", "mkt_share" AS "mkt_share", (sum(F0."t_b") OVER (PARTITION BY F0."o_year", F0."mkt_share" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."o_year", F0."mkt_share" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."o_year" AS "o_year", F0."mkt_share" AS "mkt_share", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0 UNION ALL
SELECT F0."o_year" AS "o_year", F0."mkt_share" AS "mkt_share", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0) F0) F0) F0
) F0
WHERE (F0.DIFFPREVIOUS != 0) AND (NOT (((F0."t_e") IS NULL)))),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."o_year" AS "o_year", F0."mkt_share" AS "mkt_share", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_1) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_1) F0)) F1(n) ON ((F0."numopen" >= F1.N))))
SELECT F0."o_year" AS "o_year", F0."mkt_share" AS "mkt_share", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_0) F0
ORDER BY F0."o_year" ASC NULLS LAST;