WITH _temp_view_3 AS (
    SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."AGGR_1" AS "AGGR_1", F0."open_inter_c_" AS "open_inter_c_", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT sum((CASE  WHEN (F0."p_type" LIKE 'PROMO%') THEN (F0."l_extendedprice" * (1 - F0."l_discount")) ELSE 0 END)) AS "AGGR_0", sum((F0."l_extendedprice" * (1 - F0."l_discount"))) AS "AGGR_1", count(1) AS "open_inter_c_", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
        FROM (
            SELECT F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F1."p_partkey" AS "p_partkey", F1."p_name" AS "p_name", F1."p_mfgr" AS "p_mfgr", F1."p_brand" AS "p_brand", F1."p_type" AS "p_type", F1."p_size" AS "p_size", F1."p_container" AS "p_container", F1."p_retailprice" AS "p_retailprice", F1."p_comment" AS "p_comment", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
            FROM ((
                    SELECT F0."l_orderkey" AS "l_orderkey", F0."l_partkey" AS "l_partkey", F0."l_suppkey" AS "l_suppkey", F0."l_linenumber" AS "l_linenumber", F0."l_quantity" AS "l_quantity", F0."l_extendedprice" AS "l_extendedprice", F0."l_discount" AS "l_discount", F0."l_tax" AS "l_tax", F0."l_returnflag" AS "l_returnflag", F0."l_linestatus" AS "l_linestatus", F0."l_shipdate" AS "l_shipdate", F0."l_commitdate" AS "l_commitdate", F0."l_receiptdate" AS "l_receiptdate", F0."l_shipinstruct" AS "l_shipinstruct", F0."l_shipmode" AS "l_shipmode", F0."l_comment" AS "l_comment", F0."active_time_begin" AS "t_b", F0."active_time_end" AS "t_e"
                    FROM "time_lineitem" AS F0) F0 JOIN (
                    SELECT F0."p_partkey" AS "p_partkey", F0."p_name" AS "p_name", F0."p_mfgr" AS "p_mfgr", F0."p_brand" AS "p_brand", F0."p_type" AS "p_type", F0."p_size" AS "p_size", F0."p_container" AS "p_container", F0."p_retailprice" AS "p_retailprice", F0."p_comment" AS "p_comment", F0."available_time_begin" AS "t_b", F0."available_time_end" AS "t_e"
                    FROM "time_part" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0
        WHERE (((F0."l_partkey" = F0."p_partkey") AND (F0."l_shipdate" >= to_date('1997-12-01', 'YYYY-MM-DD'))) AND (F0."l_shipdate" < to_date('1998-12-01', 'YYYY-MM-DD')))
        GROUP BY F0."t_b", F0."t_e" UNION ALL
        SELECT F0.AGGR_0 AS AGGR_0, F0.AGGR_1 AS AGGR_1, F0.open_inter_c_ AS open_inter_c_, F0.t_b AS t_b, F0.t_e AS t_e
        FROM (SELECT (NULL)::float8 AS AGGR_0, (NULL)::float8 AS AGGR_1, 0 AS open_inter_c_, TO_DATE('1992-01-01', 'YYYY-MM-DD') AS t_b, TO_DATE('9999-01-01', 'YYYY-MM-DD') AS t_e) F0) F0),
_temp_view_2 AS (
    SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."AGGR_1" AS "AGGR_1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT (CASE  WHEN ((F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") = 0) THEN (NULL)::float8 ELSE (F0."W_ADD__AGGR_0" - F0."W_DEC__AGGR_0") END) AS "AGGR_0", (CASE  WHEN ((F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") = 0) THEN (NULL)::float8 ELSE (F0."W_ADD__AGGR_1" - F0."W_DEC__AGGR_1") END) AS "AGGR_1", (F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") AS "open_inter_c_", F0."ts" AS "t_b", last_value(F0."ts") OVER ( ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
        FROM (
            SELECT "ADD__AGGR_0" AS "ADD__AGGR_0", "ADD__AGGR_1" AS "ADD__AGGR_1", "ADD__open_inter_c_" AS "ADD__open_inter_c_", "DEC__AGGR_0" AS "DEC__AGGR_0", "DEC__AGGR_1" AS "DEC__AGGR_1", "DEC__open_inter_c_" AS "DEC__open_inter_c_", "ts" AS "ts", sum(F0."ADD__AGGR_0") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_0", sum(F0."ADD__AGGR_1") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_1", sum(F0."ADD__open_inter_c_") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__open_inter_c_", sum(F0."DEC__AGGR_0") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_0", sum(F0."DEC__AGGR_1") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_1", sum(F0."DEC__open_inter_c_") OVER ( ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__open_inter_c_"
            FROM (
                SELECT sum(F0."ADD__AGGR_0") AS "ADD__AGGR_0", sum(F0."ADD__AGGR_1") AS "ADD__AGGR_1", sum(F0."ADD__open_inter_c_") AS "ADD__open_inter_c_", sum(F0."DEC__AGGR_0") AS "DEC__AGGR_0", sum(F0."DEC__AGGR_1") AS "DEC__AGGR_1", sum(F0."DEC__open_inter_c_") AS "DEC__open_inter_c_", F0."ts" AS "ts"
                FROM (
                    SELECT F0."AGGR_0" AS "ADD__AGGR_0", F0."AGGR_1" AS "ADD__AGGR_1", F0."open_inter_c_" AS "ADD__open_inter_c_", 0 AS "DEC__AGGR_0", 0 AS "DEC__AGGR_1", 0 AS "DEC__open_inter_c_", F0."t_b" AS "ts"
                    FROM (SELECT * FROM _temp_view_3) F0 UNION ALL
                    SELECT 0 AS "ADD__AGGR_0", 0 AS "ADD__AGGR_1", 0 AS "ADD__open_inter_c_", F0."AGGR_0" AS "DEC__AGGR_0", F0."AGGR_1" AS "DEC__AGGR_1", F0."open_inter_c_" AS "DEC__open_inter_c_", F0."t_e" AS "ts"
                    FROM (SELECT * FROM _temp_view_3) F0) F0
                GROUP BY F0."ts") F0) F0) F0
    WHERE (NOT (((F0."t_e") IS NULL)))),
_temp_view_1 AS (
    SELECT /*+ materialize */ ((100.000000 * F0."AGGR_0") / F0."AGGR_1") AS "promo_revenue", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (SELECT * FROM _temp_view_2) F0),
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
