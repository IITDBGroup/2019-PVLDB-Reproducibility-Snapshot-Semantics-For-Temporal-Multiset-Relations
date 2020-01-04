WITH _temp_view_4 AS (
    SELECT /*+ materialize */ sum((F0."l_extendedprice" * (1 - F0."l_discount"))) AS "AGGR_0", count(1) AS "open_inter_c_", F0."n_name" AS "GROUP_0", F0."n_name1" AS "GROUP_1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT F0."s_suppkey" AS "s_suppkey", F0."s_name" AS "s_name", F0."s_address" AS "s_address", F0."s_nationkey" AS "s_nationkey", F0."s_phone" AS "s_phone", F0."s_acctbal" AS "s_acctbal", F0."s_comment" AS "s_comment", F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."o_orderkey" AS "o_orderkey", F0."o_custkey" AS "o_custkey", F0."o_orderstatus" AS "o_orderstatus", F0."o_totalprice" AS "o_totalprice", F0."o_orderdate" AS "o_orderdate", F0."o_orderpriority" AS "o_orderpriority", F0."o_clerk" AS "o_clerk", F0."o_shippriority" AS "o_shippriority", F0."o_comment" AS "o_comment", F0."receivable_time_begin" AS "receivable_time_begin", F0."receivable_time_end" AS "receivable_time_end", F0."c_custkey" AS "c_custkey", F0."c_name" AS "c_name", F0."c_address" AS "c_address", F0."c_nationkey" AS "c_nationkey", F0."c_phone" AS "c_phone", F0."c_acctbal" AS "c_acctbal", F0."c_mktsegment" AS "c_mktsegment", F0."c_comment" AS "c_comment", F0."n_nationkey" AS "n_nationkey", F0."n_name" AS "n_name", F0."n_regionkey" AS "n_regionkey", F0."n_comment" AS "n_comment", F1."n_nationkey" AS "n_nationkey1", F1."n_name" AS "n_name1", F1."n_regionkey" AS "n_regionkey1", F1."n_comment" AS "n_comment1", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
        FROM ((
                SELECT F0."s_suppkey" AS "s_suppkey", F0."s_name" AS "s_name", F0."s_address" AS "s_address", F0."s_nationkey" AS "s_nationkey", F0."s_phone" AS "s_phone", F0."s_acctbal" AS "s_acctbal", F0."s_comment" AS "s_comment", F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."o_orderkey" AS "o_orderkey", F0."o_custkey" AS "o_custkey", F0."o_orderstatus" AS "o_orderstatus", F0."o_totalprice" AS "o_totalprice", F0."o_orderdate" AS "o_orderdate", F0."o_orderpriority" AS "o_orderpriority", F0."o_clerk" AS "o_clerk", F0."o_shippriority" AS "o_shippriority", F0."o_comment" AS "o_comment", F0."receivable_time_begin" AS "receivable_time_begin", F0."receivable_time_end" AS "receivable_time_end", F0."c_custkey" AS "c_custkey", F0."c_name" AS "c_name", F0."c_address" AS "c_address", F0."c_nationkey" AS "c_nationkey", F0."c_phone" AS "c_phone", F0."c_acctbal" AS "c_acctbal", F0."c_mktsegment" AS "c_mktsegment", F0."c_comment" AS "c_comment", F1."n_nationkey" AS "n_nationkey", F1."n_name" AS "n_name", F1."n_regionkey" AS "n_regionkey", F1."n_comment" AS "n_comment", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
                FROM ((
                        SELECT F0."s_suppkey" AS "s_suppkey", F0."s_name" AS "s_name", F0."s_address" AS "s_address", F0."s_nationkey" AS "s_nationkey", F0."s_phone" AS "s_phone", F0."s_acctbal" AS "s_acctbal", F0."s_comment" AS "s_comment", F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."o_orderkey" AS "o_orderkey", F0."o_custkey" AS "o_custkey", F0."o_orderstatus" AS "o_orderstatus", F0."o_totalprice" AS "o_totalprice", F0."o_orderdate" AS "o_orderdate", F0."o_orderpriority" AS "o_orderpriority", F0."o_clerk" AS "o_clerk", F0."o_shippriority" AS "o_shippriority", F0."o_comment" AS "o_comment", F0."receivable_time_begin" AS "receivable_time_begin", F0."receivable_time_end" AS "receivable_time_end", F1."c_custkey" AS "c_custkey", F1."c_name" AS "c_name", F1."c_address" AS "c_address", F1."c_nationkey" AS "c_nationkey", F1."c_phone" AS "c_phone", F1."c_acctbal" AS "c_acctbal", F1."c_mktsegment" AS "c_mktsegment", F1."c_comment" AS "c_comment", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
                        FROM ((
                                SELECT F0."s_suppkey" AS "s_suppkey", F0."s_name" AS "s_name", F0."s_address" AS "s_address", F0."s_nationkey" AS "s_nationkey", F0."s_phone" AS "s_phone", F0."s_acctbal" AS "s_acctbal", F0."s_comment" AS "s_comment", F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F1."o_orderkey" AS "o_orderkey", F1."o_custkey" AS "o_custkey", F1."o_orderstatus" AS "o_orderstatus", F1."o_totalprice" AS "o_totalprice", F1."o_orderdate" AS "o_orderdate", F1."o_orderpriority" AS "o_orderpriority", F1."o_clerk" AS "o_clerk", F1."o_shippriority" AS "o_shippriority", F1."o_comment" AS "o_comment", F1."receivable_time_begin" AS "receivable_time_begin", F1."receivable_time_end" AS "receivable_time_end", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
                                FROM ((
                                        SELECT F0."s_suppkey" AS "s_suppkey", F0."s_name" AS "s_name", F0."s_address" AS "s_address", F0."s_nationkey" AS "s_nationkey", F0."s_phone" AS "s_phone", F0."s_acctbal" AS "s_acctbal", F0."s_comment" AS "s_comment", F1."l_orderkey" AS "l_orderkey", F1."l_partkey" AS "l_partkey", F1."l_suppkey" AS "l_suppkey", F1."l_linenumber" AS "l_linenumber", F1."l_quantity" AS "l_quantity", F1."l_extendedprice" AS "l_extendedprice", F1."l_discount" AS "l_discount", F1."l_tax" AS "l_tax", F1."l_returnflag" AS "l_returnflag", F1."l_linestatus" AS "l_linestatus", F1."l_shipdate" AS "l_shipdate", F1."l_commitdate" AS "l_commitdate", F1."l_receiptdate" AS "l_receiptdate", F1."l_shipinstruct" AS "l_shipinstruct", F1."l_shipmode" AS "l_shipmode", F1."l_comment" AS "l_comment", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
                                        FROM ((
                                                SELECT F0."s_suppkey" AS "s_suppkey", F0."s_name" AS "s_name", F0."s_address" AS "s_address", F0."s_nationkey" AS "s_nationkey", F0."s_phone" AS "s_phone", F0."s_acctbal" AS "s_acctbal", F0."s_comment" AS "s_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
                                                FROM "time_supplier" AS F0) F0 JOIN (
                                                SELECT F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
                                                FROM "time_lineitem" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0 JOIN (
                                        SELECT F0."o_orderkey" AS "o_orderkey", F0."o_custkey" AS "o_custkey", F0."o_orderstatus" AS "o_orderstatus", F0."o_totalprice" AS "o_totalprice", F0."o_orderdate" AS "o_orderdate", F0."o_orderpriority" AS "o_orderpriority", F0."o_clerk" AS "o_clerk", F0."o_shippriority" AS "o_shippriority", F0."o_comment" AS "o_comment", F0."receivable_time_begin" AS "receivable_time_begin", F0."receivable_time_end" AS "receivable_time_end", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
                                        FROM "time_orders" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0 JOIN (
                                SELECT F0."c_custkey" AS "c_custkey", F0."c_name" AS "c_name", F0."c_address" AS "c_address", F0."c_nationkey" AS "c_nationkey", F0."c_phone" AS "c_phone", F0."c_acctbal" AS "c_acctbal", F0."c_mktsegment" AS "c_mktsegment", F0."c_comment" AS "c_comment", F0."visible_time_begin" AS "t_b", F0."visible_time_end" AS "t_e"
                                FROM "time_customer" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0 JOIN (
                        SELECT F0."n_nationkey" AS "n_nationkey", F0."n_name" AS "n_name", F0."n_regionkey" AS "n_regionkey", F0."n_comment" AS "n_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
                        FROM "time_nation" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0 JOIN (
                SELECT F0."n_nationkey" AS "n_nationkey", F0."n_name" AS "n_name", F0."n_regionkey" AS "n_regionkey", F0."n_comment" AS "n_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
                FROM "time_nation" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0
    WHERE ((((((((F0."s_suppkey" = F0."l_suppkey") AND (F0."o_orderkey" = F0."l_orderkey")) AND (F0."c_custkey" = F0."o_custkey")) AND (F0."s_nationkey" = F0."n_nationkey")) AND (F0."c_nationkey" = F0."n_nationkey1")) AND (((F0."n_name" = 'EGYPT') AND (F0."n_name1" = 'IRAQ')) OR ((F0."n_name" = 'IRAQ') AND (F0."n_name1" = 'EGYPT')))) AND (F0."l_shipdate" > to_date('1995-01-01', 'YYYY-MM-DD'))) AND (F0."l_shipdate" < to_date('1996-12-31', 'YYYY-MM-DD')))
    GROUP BY F0."n_name", F0."n_name1", F0."t_b", F0."t_e"),
_temp_view_3 AS (
    SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."GROUP_0" AS "GROUP_0", F0."GROUP_1" AS "GROUP_1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT (CASE  WHEN ((F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") = 0) THEN (NULL)::float8 ELSE (F0."W_ADD__AGGR_0" - F0."W_DEC__AGGR_0") END) AS "AGGR_0", (F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") AS "open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."GROUP_1" AS "GROUP_1", F0."ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."GROUP_0", F0."GROUP_1" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
        FROM (
            SELECT "ADD__AGGR_0" AS "ADD__AGGR_0", "ADD__open_inter_c_" AS "ADD__open_inter_c_", "DEC__AGGR_0" AS "DEC__AGGR_0", "DEC__open_inter_c_" AS "DEC__open_inter_c_", "GROUP_0" AS "GROUP_0", "GROUP_1" AS "GROUP_1", "ts" AS "ts", sum(F0."ADD__AGGR_0") OVER (PARTITION BY F0."GROUP_0", F0."GROUP_1" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_0", sum(F0."ADD__open_inter_c_") OVER (PARTITION BY F0."GROUP_0", F0."GROUP_1" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__open_inter_c_", sum(F0."DEC__AGGR_0") OVER (PARTITION BY F0."GROUP_0", F0."GROUP_1" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_0", sum(F0."DEC__open_inter_c_") OVER (PARTITION BY F0."GROUP_0", F0."GROUP_1" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__open_inter_c_"
            FROM (
                SELECT sum(F0."ADD__AGGR_0") AS "ADD__AGGR_0", sum(F0."ADD__open_inter_c_") AS "ADD__open_inter_c_", sum(F0."DEC__AGGR_0") AS "DEC__AGGR_0", sum(F0."DEC__open_inter_c_") AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."GROUP_1" AS "GROUP_1", F0."ts" AS "ts"
                FROM (
                    SELECT F0."AGGR_0" AS "ADD__AGGR_0", F0."open_inter_c_" AS "ADD__open_inter_c_", 0 AS "DEC__AGGR_0", 0 AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."GROUP_1" AS "GROUP_1", F0."t_b" AS "ts"
                    FROM (SELECT * FROM _temp_view_4) F0 UNION ALL
                    SELECT 0 AS "ADD__AGGR_0", 0 AS "ADD__open_inter_c_", F0."AGGR_0" AS "DEC__AGGR_0", F0."open_inter_c_" AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."GROUP_1" AS "GROUP_1", F0."t_e" AS "ts"
                    FROM (SELECT * FROM _temp_view_4) F0) F0
                GROUP BY F0."GROUP_0", F0."GROUP_1", F0."ts") F0) F0) F0
    WHERE ((NOT (((F0."t_e") IS NULL))) AND (F0."open_inter_c_" > 0))),
_temp_view_2 AS (
    SELECT /*+ materialize */ F0."GROUP_0" AS "supp_nation", F0."GROUP_1" AS "cust_nation", F0."AGGR_0" AS "revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (SELECT * FROM _temp_view_3) F0),
_temp_view_1 AS (
    SELECT /*+ materialize */ F0."supp_nation" AS "supp_nation", F0."cust_nation" AS "cust_nation", F0."revenue" AS "revenue", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT "supp_nation" AS "supp_nation", "cust_nation" AS "cust_nation", "revenue" AS "revenue", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."supp_nation", F0."cust_nation", F0."revenue" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
        FROM (
            SELECT "supp_nation" AS "supp_nation", "cust_nation" AS "cust_nation", "revenue" AS "revenue", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."supp_nation", F0."cust_nation", F0."revenue" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
            FROM (
                SELECT  DISTINCT "supp_nation" AS "supp_nation", "cust_nation" AS "cust_nation", "revenue" AS "revenue", (sum(F0."t_b") OVER (PARTITION BY F0."supp_nation", F0."cust_nation", F0."revenue" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."supp_nation", F0."cust_nation", F0."revenue" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
                FROM (
                    SELECT F0."supp_nation" AS "supp_nation", F0."cust_nation" AS "cust_nation", F0."revenue" AS "revenue", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
                    FROM (SELECT * FROM _temp_view_2) F0 UNION ALL
                    SELECT F0."supp_nation" AS "supp_nation", F0."cust_nation" AS "cust_nation", F0."revenue" AS "revenue", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
                    FROM (SELECT * FROM _temp_view_2) F0) F0) F0) F0
        WHERE (F0.DIFFPREVIOUS != 0)) F0
    WHERE (NOT (((F0."t_e") IS NULL)))),
_temp_view_0 AS (
    SELECT /*+ materialize */ F0."supp_nation" AS "supp_nation", F0."cust_nation" AS "cust_nation", F0."revenue" AS "revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM ((SELECT * FROM _temp_view_1) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_1) F0)) F1(n) ON ((F0."numopen" >= F1.N))))
SELECT F0."supp_nation" AS "supp_nation", F0."cust_nation" AS "cust_nation", F0."revenue" AS "revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_0) F0
ORDER BY F0."supp_nation" ASC NULLS LAST, F0."cust_nation" ASC NULLS LAST;
