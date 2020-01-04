WITH _temp_view_4 AS (
    SELECT /*+ materialize */ count(1) AS "AGGR_0", count(1) AS "AGGR_1", count(1) AS "open_inter_c_", F0."dept_no" AS "GROUP_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
        FROM "dept_emp" AS F0) F0
    WHERE (F0."emp_no" < 10282)
    GROUP BY F0."dept_no", F0."t_b", F0."t_e"),
_temp_view_3 AS (
    SELECT /*+ materialize */ F0."AGGR_0" AS "c", F0."GROUP_0" AS "dept_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT (F0."AGGR_0")::int8 AS "AGGR_0", (F0."AGGR_1")::int8 AS "AGGR_1", F0."GROUP_0" AS "GROUP_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
        FROM (
            SELECT (F0."W_ADD__AGGR_0" - F0."W_DEC__AGGR_0") AS "AGGR_0", (F0."W_ADD__AGGR_1" - F0."W_DEC__AGGR_1") AS "AGGR_1", (F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") AS "open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
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
        WHERE ((NOT (((F0."t_e") IS NULL))) AND (F0."open_inter_c_" > 0))) F0
    WHERE (F0."AGGR_0" > 21)),
_temp_view_2 AS (
    SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."open_inter_c_" AS "open_inter_c_", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT count(1) AS "AGGR_0", count(1) AS "open_inter_c_", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
        FROM (SELECT * FROM _temp_view_3) F0
        GROUP BY F0."t_b", F0."t_e" UNION ALL
        SELECT F0.AGGR_0 AS AGGR_0, F0.open_inter_c_ AS open_inter_c_, F0.t_b AS t_b, F0.t_e AS t_e
        FROM (SELECT 0 AS AGGR_0, 0 AS open_inter_c_, TO_DATE('1992-01-01', 'YYYY-MM-DD') AS t_b, TO_DATE('9999-01-01', 'YYYY-MM-DD') AS t_e) F0) F0),
_temp_view_1 AS (
    SELECT /*+ materialize */ (F0."AGGR_0")::int8 AS "AGGR_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT (F0."W_ADD__AGGR_0" - F0."W_DEC__AGGR_0") AS "AGGR_0", (F0."W_ADD__open_inter_c_" - F0."W_DEC__open_inter_c_") AS "open_inter_c_", F0."ts" AS "t_b", last_value(F0."ts") OVER ( ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
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
    SELECT /*+ materialize */ F0."AGGR_0" AS "count(1)", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (SELECT * FROM _temp_view_1) F0)
SELECT F0."count(1)" AS "count(1)", F0."t_b" AS "t_b", F0."ts" AS "t_e"
FROM (
    SELECT "count(1)" AS "count(1)", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", "count_start" AS "count_start", "count_end" AS "count_end", lag(F0."ts", 1) OVER ( ORDER BY F0."count(1)", F0."ts") AS "t_b"
    FROM (
        SELECT "count(1)" AS "count(1)", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", sum(F0."is_s") OVER (PARTITION BY F0."count(1)" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_start", sum(F0."is_e") OVER (PARTITION BY F0."count(1)" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_end"
        FROM (
            SELECT F0."count(1)" AS "count(1)", 1 AS "is_s", 0 AS "is_e", F0."t_b" AS "ts"
            FROM (SELECT * FROM _temp_view_0) F0 UNION ALL
            SELECT F0."count(1)" AS "count(1)", 0 AS "is_s", 1 AS "is_e", F0."t_e" AS "ts"
            FROM (SELECT * FROM _temp_view_0) F0) F0) F0
    WHERE ((F0."count_start" = F0."count_end") OR ((F0."count_start" - F0."is_s") = (F0."count_end" - F0."is_e")))) F0
WHERE (F0."count_start" = F0."count_end");
