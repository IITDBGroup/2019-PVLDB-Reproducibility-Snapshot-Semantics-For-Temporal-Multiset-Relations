WITH _temp_view_2 AS (
SELECT n_name AS "n_name", sum(l_extendedprice * (1 - l_discount)) AS "revenue",ts AS "t_b",te AS "t_e" from (
    SELECT * FROM (
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
                    ON (s_nationkey = n_nationkey)) x4) y4
                      PERIOD JOIN WITH (ts4, te4, ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) AS (ts, te) 
                      time_region d
                      ON (n_regionkey = r_regionkey)) x5
        WHERE c_nationkey = s_nationkey and r_name = 'AMERICA' AND o_orderdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD') AND o_orderdate < TO_DATE('1995-02-01','YYYY-MM-DD')) y
        GROUP BY PERIOD WITH (ts,te) n_name 
        ORDER BY revenue DESC
),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."n_name" AS "n_name", F0."revenue" AS "revenue", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "n_name" AS "n_name", "revenue" AS "revenue", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."n_name", F0."revenue" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "n_name" AS "n_name", "revenue" AS "revenue", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."n_name", F0."revenue" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "n_name" AS "n_name", "revenue" AS "revenue", (sum(F0."t_b") OVER (PARTITION BY F0."n_name", F0."revenue" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."n_name", F0."revenue" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."n_name" AS "n_name", F0."revenue" AS "revenue", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0 UNION ALL
SELECT F0."n_name" AS "n_name", F0."revenue" AS "revenue", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0) F0) F0) F0
WHERE (F0.DIFFPREVIOUS != 0)) F0
WHERE (NOT (((F0."t_e") IS NULL)))),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."n_name" AS "n_name", F0."revenue" AS "revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_1) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_1) F0)) F1(n) ON ((F0."numopen" >= F1.N))))
SELECT F0."n_name" AS "n_name", F0."revenue" AS "revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_0) F0
ORDER BY F0."revenue" DESC NULLS LAST;