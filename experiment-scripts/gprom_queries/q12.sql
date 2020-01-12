WITH _temp_view_4 AS (
SELECT /*+ materialize */ sum((CASE  WHEN ((F0."o_orderpriority" = '1-URGENT') OR (F0."o_orderpriority" = '2-HIGH')) THEN 1 ELSE 0 END)) AS "AGGR_0", sum((CASE  WHEN ((F0."o_orderpriority" <> '1-URGENT') AND (F0."o_orderpriority" <> '2-HIGH')) THEN 1 ELSE 0 END)) AS "AGGR_1", count(1) AS "open_inter_c_", F0."l_shipmode" AS "GROUP_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT F0."o_orderkey" AS "o_orderkey", F0."o_custkey" AS "o_custkey", F0."o_orderstatus" AS "o_orderstatus", F0."o_totalprice" AS "o_totalprice", F0."o_orderdate" AS "o_orderdate", F0."o_orderpriority" AS "o_orderpriority", F0."o_clerk" AS "o_clerk", F0."o_shippriority" AS "o_shippriority", F0."o_comment" AS "o_comment", F0."receivable_time_begin" AS "receivable_time_begin", F0."receivable_time_end" AS "receivable_time_end", F1."l_orderkey" AS "l_orderkey", F1."l_partkey" AS "l_partkey", F1."l_suppkey" AS "l_suppkey", F1."l_linenumber" AS "l_linenumber", F1."l_quantity" AS "l_quantity", F1."l_extendedprice" AS "l_extendedprice", F1."l_discount" AS "l_discount", F1."l_tax" AS "l_tax", F1."l_returnflag" AS "l_returnflag", F1."l_linestatus" AS "l_linestatus", F1."l_shipdate" AS "l_shipdate", F1."l_commitdate" AS "l_commitdate", F1."l_receiptdate" AS "l_receiptdate", F1."l_shipinstruct" AS "l_shipinstruct", F1."l_shipmode" AS "l_shipmode", F1."l_comment" AS "l_comment", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
FROM ((
SELECT F0."o_orderkey" AS "o_orderkey", F0."o_custkey" AS "o_custkey", F0."o_orderstatus" AS "o_orderstatus", F0."o_totalprice" AS "o_totalprice", F0."o_orderdate" AS "o_orderdate", F0."o_orderpriority" AS "o_orderpriority", F0."o_clerk" AS "o_clerk", F0."o_shippriority" AS "o_shippriority", F0."o_comment" AS "o_comment", F0."receivable_time_begin" AS "receivable_time_begin", F0."receivable_time_end" AS "receivable_time_end", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
FROM "time_orders" AS F0) F0 JOIN (
SELECT F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
FROM "time_lineitem" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0
WHERE ((((((F0."o_orderkey" = F0."l_orderkey") AND ((F0."l_shipmode" = 'AIR') OR (F0."l_shipmode" = 'MAIL'))) AND (F0."l_commitdate" < F0."l_receiptdate")) AND (F0."l_shipdate" < F0."l_commitdate")) AND (F0."l_receiptdate" >= to_date('1995-01-01', 'YYYY-MM-DD'))) AND (F0."l_receiptdate" < to_date('1996-01-01', 'YYYY-MM-DD')))
GROUP BY F0."l_shipmode", F0."t_b", F0."t_e"),
_temp_view_3 AS (
SELECT /*+ materialize */ (F0."AGGR_0")::int8 AS "AGGR_0", (F0."AGGR_1")::int8 AS "AGGR_1", F0."GROUP_0" AS "GROUP_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT (CASE  WHEN ((F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") = 0) THEN (NULL)::float8 ELSE (F0."W_ADD__AGGR_0" - F0."W_DEC__AGGR_0") END) AS "AGGR_0", (CASE  WHEN ((F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") = 0) THEN (NULL)::float8 ELSE (F0."W_ADD__AGGR_1" - F0."W_DEC__AGGR_1") END) AS "AGGR_1", (F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") AS "open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "ADD__AGGR_0" AS "ADD__AGGR_0", "ADD__AGGR_1" AS "ADD__AGGR_1", "ADD__open_inter_c_" AS "ADD__open_inter_c_", "DEC__AGGR_0" AS "DEC__AGGR_0", "DEC__AGGR_1" AS "DEC__AGGR_1", "DEC__open_inter_c_" AS "DEC__open_inter_c_", "GROUP_0" AS "GROUP_0", "ts" AS "ts", sum(F0."ADD__AGGR_0") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_0", sum(F0."ADD__AGGR_1") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_1", sum(F0."ADD__open_inter_c_") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__open_inter_c_", sum(F0."DEC__AGGR_0") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_0", sum(F0."DEC__AGGR_1") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_1", sum(F0."DEC__open_inter_c_") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__open_inter_c_"
FROM (
SELECT sum(F0."ADD__AGGR_0") AS "ADD__AGGR_0", sum(F0."ADD__AGGR_1") AS "ADD__AGGR_1", sum(F0."ADD__open_inter_c_") AS "ADD__open_inter_c_", sum(F0."DEC__AGGR_0") AS "DEC__AGGR_0", sum(F0."DEC__AGGR_1") AS "DEC__AGGR_1", sum(F0."DEC__open_inter_c_") AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."ts" AS "ts"
FROM (
SELECT F0."AGGR_0" AS "ADD__AGGR_0", F0."AGGR_1" AS "ADD__AGGR_1", F0."open_inter_c_" AS "ADD__open_inter_c_", 0 AS "DEC__AGGR_0", 0 AS "DEC__AGGR_1", 0 AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_4) F0 UNION ALL 
SELECT 0 AS "ADD__AGGR_0", 0 AS "ADD__AGGR_1", 0 AS "ADD__open_inter_c_", F0."AGGR_0" AS "DEC__AGGR_0", F0."AGGR_1" AS "DEC__AGGR_1", F0."open_inter_c_" AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_4) F0) F0
GROUP BY F0."GROUP_0", F0."ts") F0) F0) F0
WHERE ((NOT (((F0."t_e") IS NULL))) AND (F0."open_inter_c_" > 0))),
_temp_view_2 AS (
SELECT /*+ materialize */ F0."GROUP_0" AS "l_shipmode", F0."AGGR_0" AS "high_line_count", F0."AGGR_1" AS "low_line_count", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_3) F0),
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


