WITH _temp_view_2 AS (
SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."open_inter_c_" AS "open_inter_c_", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT sum((F0."l_extendedprice" * F0."l_discount")) AS "AGGR_0", count(1) AS "open_inter_c_", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
FROM "time_lineitem" AS F0) F0
WHERE (((((F0."l_shipdate" >= to_date('1995-01-01', 'YYYY-MM-DD')) AND (F0."l_shipdate" < to_date('1996-01-01', 'YYYY-MM-DD'))) AND (F0."l_discount" > (0.050000 - 0.010000))) AND (F0."l_discount" < (0.050000 + 0.010000))) AND (F0."l_quantity" < 25))
GROUP BY F0."t_b", F0."t_e" UNION ALL 
SELECT F0.AGGR_0 AS AGGR_0, F0.open_inter_c_ AS open_inter_c_, F0.t_b AS t_b, F0.t_e AS t_e
FROM (SELECT (NULL)::float8 AS AGGR_0, 0 AS open_inter_c_, TO_DATE('1992-01-01', 'YYYY-MM-DD') AS t_b, TO_DATE('9999-01-01', 'YYYY-MM-DD') AS t_e) F0) F0),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT (CASE  WHEN ((F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") = 0) THEN (NULL)::float8 ELSE (F0."W_ADD__AGGR_0" - F0."W_DEC__AGGR_0") END) AS "AGGR_0", (F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") AS "open_inter_c_", F0."ts" AS "t_b", last_value(F0."ts") OVER ( ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "ADD__AGGR_0" AS "ADD__AGGR_0", "ADD__open_inter_c_" AS "ADD__open_inter_c_", "DEC__AGGR_0" AS "DEC__AGGR_0", "DEC__open_inter_c_" AS "DEC__open_inter_c_", "ts" AS "ts", sum(F0."ADD__AGGR_0") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_0", sum(F0."ADD__open_inter_c_") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__open_inter_c_", sum(F0."DEC__AGGR_0") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_0", sum(F0."DEC__open_inter_c_") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__open_inter_c_"
FROM (
SELECT sum(F0."ADD__AGGR_0") AS "ADD__AGGR_0", sum(F0."ADD__open_inter_c_") AS "ADD__open_inter_c_", sum(F0."DEC__AGGR_0") AS "DEC__AGGR_0", sum(F0."DEC__open_inter_c_") AS "DEC__open_inter_c_", F0."ts" AS "ts"
FROM (
SELECT F0."AGGR_0" AS "ADD__AGGR_0", F0."open_inter_c_" AS "ADD__open_inter_c_", 0 AS "DEC__AGGR_0", 0 AS "DEC__open_inter_c_", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0 UNION ALL 
SELECT 0 AS "ADD__AGGR_0", 0 AS "ADD__open_inter_c_", F0."AGGR_0" AS "DEC__AGGR_0", F0."open_inter_c_" AS "DEC__open_inter_c_", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_2) F0) F0
GROUP BY F0."ts") F0) F0) F0
WHERE (NOT (((F0."t_e") IS NULL)))),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."AGGR_0" AS "revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_1) F0)
SELECT F0."revenue" AS "revenue", F0."t_b" AS "t_b", F0."ts" AS "t_e"
FROM (
SELECT "revenue" AS "revenue", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", "count_start" AS "count_start", "count_end" AS "count_end", lag(F0."ts", 1) OVER ( ORDER BY F0."revenue", F0."ts") AS "t_b"
FROM (
SELECT "revenue" AS "revenue", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", sum(F0."is_s") OVER (PARTITION BY F0."revenue" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_start", sum(F0."is_e") OVER (PARTITION BY F0."revenue" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_end"
FROM (
SELECT F0."revenue" AS "revenue", 1 AS "is_s", 0 AS "is_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_0) F0 UNION ALL 
SELECT F0."revenue" AS "revenue", 0 AS "is_s", 1 AS "is_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_0) F0) F0) F0
WHERE ((F0."count_start" = F0."count_end") OR ((F0."count_start" - F0."is_s") = (F0."count_end" - F0."is_e")))) F0
WHERE (F0."count_start" = F0."count_end");


